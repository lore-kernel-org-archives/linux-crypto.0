From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 10/11] arm64/crypto: add voluntary preemption to Crypto Extensions SHA2
Date: Wed, 14 May 2014 11:17:30 -0700
Message-ID: <1400091451-9117-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, jussi.kivilinna@iki.fi,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:60112 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaENSSE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 14:18:04 -0400
Received: by mail-yh0-f54.google.com with SMTP id i57so2031071yha.13
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2014 11:18:03 -0700 (PDT)
In-Reply-To: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Crypto Extensions based SHA2 implementation uses the NEON register file,
and hence runs with preemption disabled. This patch adds a TIF_NEED_RESCHED
check to its inner loop so we at least give up the CPU voluntarily when we
are running in process context and have been tagged for preemption by the
scheduler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha2-ce-core.S | 19 ++++++++-------
 arch/arm64/crypto/sha2-ce-glue.c | 51 ++++++++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 7f29fc031ea8..71c617cd57ca 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -73,8 +73,8 @@
 	.word		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
 
 	/*
-	 * void sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-	 *                        u8 *head, long bytes)
+	 * int sha2_ce_transform(int blocks, u8 const *src, u32 *state,
+	 *                       u8 *head, long bytes, struct thread_info *ti)
 	 */
 ENTRY(sha2_ce_transform)
 	/* load round constants */
@@ -131,7 +131,14 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	add		dgbv.4s, dgbv.4s, dg1v.4s
 
 	/* handled all input blocks? */
-	cbnz		w0, 0b
+	cbz		w0, 4f
+
+	/* should we exit early? */
+	b_if_no_resched	x5, x8, 0b
+
+	/* store new state */
+3:	stp		dga, dgb, [x2]
+	ret
 
 	/*
 	 * Final block: add padding and total bit count.
@@ -139,7 +146,7 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	 * size was not a round multiple of the block size, and the padding is
 	 * handled by the C code.
 	 */
-	cbz		x4, 3f
+4:	cbz		x4, 3b
 	movi		v17.2d, #0
 	mov		x8, #0x80000000
 	movi		v18.2d, #0
@@ -149,8 +156,4 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	mov		v19.d[0], xzr
 	mov		v19.d[1], x7
 	b		2b
-
-	/* store new state */
-3:	stp		dga, dgb, [x2]
-	ret
 ENDPROC(sha2_ce_transform)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index c294e67d3925..3ab69e8f8604 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -21,7 +21,7 @@ MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 asmlinkage int sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-				 u8 *head, long bytes);
+				 u8 *head, long bytes, struct thread_info *ti);
 
 static int sha224_init(struct shash_desc *desc)
 {
@@ -49,6 +49,34 @@ static int sha256_init(struct shash_desc *desc)
 	return 0;
 }
 
+static u8 const *sha2_do_update(struct shash_desc *desc, const u8 *data,
+				int blocks, u8 *head, unsigned int len)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct thread_info *ti = NULL;
+
+	/*
+	 * Pass current's thread info pointer to sha2_ce_transform()
+	 * below if we want it to play nice under preemption.
+	 */
+	if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) || IS_ENABLED(CONFIG_PREEMPT))
+	    && (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP))
+		ti = current_thread_info();
+
+	do {
+		int rem;
+
+		kernel_neon_begin_partial(28);
+		rem = sha2_ce_transform(blocks, data, sctx->state, head, 0, ti);
+		kernel_neon_end();
+
+		data += (blocks - rem) * SHA1_BLOCK_SIZE;
+		blocks = rem;
+		head = NULL;
+	} while (unlikely(ti && blocks > 0));
+	return data;
+}
+
 static int sha2_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
@@ -58,8 +86,6 @@ static int sha2_update(struct shash_desc *desc, const u8 *data,
 	sctx->count += len;
 
 	if ((partial + len) >= SHA256_BLOCK_SIZE) {
-		int blocks;
-
 		if (partial) {
 			int p = SHA256_BLOCK_SIZE - partial;
 
@@ -68,15 +94,10 @@ static int sha2_update(struct shash_desc *desc, const u8 *data,
 			len -= p;
 		}
 
-		blocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
+		data = sha2_do_update(desc, data, len / SHA256_BLOCK_SIZE,
+				      partial ? sctx->buf : NULL, 0);
 
-		kernel_neon_begin_partial(28);
-		sha2_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buf : NULL, 0);
-		kernel_neon_end();
-
-		data += blocks * SHA256_BLOCK_SIZE;
+		len %= SHA256_BLOCK_SIZE;
 		partial = 0;
 	}
 	if (len)
@@ -131,7 +152,6 @@ static void sha2_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
-	int blocks;
 
 	if (sctx->count || !len || (len % SHA256_BLOCK_SIZE)) {
 		sha2_update(desc, data, len);
@@ -145,12 +165,7 @@ static void sha2_finup(struct shash_desc *desc, const u8 *data,
 	 * perform the entire digest calculation in a single invocation
 	 * of sha2_ce_transform()
 	 */
-	blocks = len / SHA256_BLOCK_SIZE;
-
-	kernel_neon_begin_partial(28);
-	sha2_ce_transform(blocks, data, sctx->state, NULL, len);
-	kernel_neon_end();
-	data += blocks * SHA256_BLOCK_SIZE;
+	sha2_do_update(desc, data, len / SHA256_BLOCK_SIZE, NULL, len);
 }
 
 static int sha224_finup(struct shash_desc *desc, const u8 *data,
-- 
1.8.3.2
