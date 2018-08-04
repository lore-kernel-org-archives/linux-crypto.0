From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm64/ghash-ce - replace NEON yield check with
 block limit
Date: Sat,  4 Aug 2018 20:46:24 +0200
Message-ID: <20180804184625.28523-2-ard.biesheuvel@linaro.org>
References: <20180804184625.28523-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, jerome.forissier@linaro.org,
 herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 jens.wiklander@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180804184625.28523-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Checking the TIF_NEED_RESCHED flag is disproportionately costly on cores
with fast crypto instructions and comparatively slow memory accesses.

On algorithms such as GHASH, which executes at ~1 cycle per byte on
cores that implement support for 64 bit polynomial multiplication,
there is really no need to check the TIF_NEED_RESCHED particularly
often, and so we can remove the NEON yield check from the assembler
routines.

However, unlike the AEAD or skcipher APIs, the shash/ahash APIs take
arbitrary input lengths, and so there needs to be some sanity check
to ensure that we don't hog the CPU for excessive amounts of time.

So let's simply cap the maximum input size that is processed in one go
to 64 KB.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 39 ++++++--------------
 arch/arm64/crypto/ghash-ce-glue.c | 16 ++++++--
 2 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 913e49932ae6..344811c6a0ca 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -213,31 +213,23 @@
 	.endm
 
 	.macro		__pmull_ghash, pn
-	frame_push	5
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-
-0:	ld1		{SHASH.2d}, [x22]
-	ld1		{XL.2d}, [x20]
+	ld1		{SHASH.2d}, [x3]
+	ld1		{XL.2d}, [x1]
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	__pmull_pre_\pn
 
 	/* do the head block first, if supplied */
-	cbz		x23, 1f
-	ld1		{T1.2d}, [x23]
-	mov		x23, xzr
-	b		2f
+	cbz		x4, 0f
+	ld1		{T1.2d}, [x4]
+	mov		x4, xzr
+	b		1f
 
-1:	ld1		{T1.2d}, [x21], #16
-	sub		w19, w19, #1
+0:	ld1		{T1.2d}, [x2], #16
+	sub		w0, w0, #1
 
-2:	/* multiply XL by SHASH in GF(2^128) */
+1:	/* multiply XL by SHASH in GF(2^128) */
 CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	ext		T2.16b, XL.16b, XL.16b, #8
@@ -259,18 +251,9 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	eor		T2.16b, T2.16b, XH.16b
 	eor		XL.16b, XL.16b, T2.16b
 
-	cbz		w19, 3f
-
-	if_will_cond_yield_neon
-	st1		{XL.2d}, [x20]
-	do_cond_yield_neon
-	b		0b
-	endif_yield_neon
-
-	b		1b
+	cbnz		w0, 0b
 
-3:	st1		{XL.2d}, [x20]
-	frame_pop
+	st1		{XL.2d}, [x1]
 	ret
 	.endm
 
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 88e3d93fa7c7..03ce71ea81a2 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -113,6 +113,9 @@ static void ghash_do_update(int blocks, u64 dg[], const char *src,
 	}
 }
 
+/* avoid hogging the CPU for too long */
+#define MAX_BLOCKS	(SZ_64K / GHASH_BLOCK_SIZE)
+
 static int ghash_update(struct shash_desc *desc, const u8 *src,
 			unsigned int len)
 {
@@ -136,11 +139,16 @@ static int ghash_update(struct shash_desc *desc, const u8 *src,
 		blocks = len / GHASH_BLOCK_SIZE;
 		len %= GHASH_BLOCK_SIZE;
 
-		ghash_do_update(blocks, ctx->digest, src, key,
-				partial ? ctx->buf : NULL);
+		do {
+			int chunk = min(blocks, MAX_BLOCKS);
+
+			ghash_do_update(chunk, ctx->digest, src, key,
+					partial ? ctx->buf : NULL);
 
-		src += blocks * GHASH_BLOCK_SIZE;
-		partial = 0;
+			blocks -= chunk;
+			src += chunk * GHASH_BLOCK_SIZE;
+			partial = 0;
+		} while (unlikely(blocks > 0));
 	}
 	if (len)
 		memcpy(ctx->buf + partial, src, len);
-- 
2.18.0
