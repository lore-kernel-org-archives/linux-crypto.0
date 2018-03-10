From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 17/23] crypto: arm64/aes-ghash - yield NEON after every
 block of input
Date: Sat, 10 Mar 2018 15:22:02 +0000
Message-ID: <20180310152208.10369-18-ard.biesheuvel@linaro.org>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-rt-users@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
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

Avoid excessive scheduling delays under a preemptible kernel by
conditionally yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 113 ++++++++++++++------
 arch/arm64/crypto/ghash-ce-glue.c |  28 +++--
 2 files changed, 97 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 11ebf1ae248a..dcffb9e77589 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -213,22 +213,31 @@
 	.endm
 
 	.macro		__pmull_ghash, pn
-	ld1		{SHASH.2d}, [x3]
-	ld1		{XL.2d}, [x1]
+	frame_push	5
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+
+0:	ld1		{SHASH.2d}, [x22]
+	ld1		{XL.2d}, [x20]
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	__pmull_pre_\pn
 
 	/* do the head block first, if supplied */
-	cbz		x4, 0f
-	ld1		{T1.2d}, [x4]
-	b		1f
+	cbz		x23, 1f
+	ld1		{T1.2d}, [x23]
+	mov		x23, xzr
+	b		2f
 
-0:	ld1		{T1.2d}, [x2], #16
-	sub		w0, w0, #1
+1:	ld1		{T1.2d}, [x21], #16
+	sub		w19, w19, #1
 
-1:	/* multiply XL by SHASH in GF(2^128) */
+2:	/* multiply XL by SHASH in GF(2^128) */
 CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	ext		T2.16b, XL.16b, XL.16b, #8
@@ -250,9 +259,18 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	eor		T2.16b, T2.16b, XH.16b
 	eor		XL.16b, XL.16b, T2.16b
 
-	cbnz		w0, 0b
+	cbz		w19, 3f
+
+	if_will_cond_yield_neon
+	st1		{XL.2d}, [x20]
+	do_cond_yield_neon
+	b		0b
+	endif_yield_neon
+
+	b		1b
 
-	st1		{XL.2d}, [x1]
+3:	st1		{XL.2d}, [x20]
+	frame_pop
 	ret
 	.endm
 
@@ -304,38 +322,55 @@ ENDPROC(pmull_ghash_update_p8)
 	.endm
 
 	.macro		pmull_gcm_do_crypt, enc
-	ld1		{SHASH.2d}, [x4]
-	ld1		{XL.2d}, [x1]
-	ldr		x8, [x5, #8]			// load lower counter
+	frame_push	10
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+	mov		x25, x6
+	mov		x26, x7
+	.if		\enc == 1
+	ldr		x27, [sp, #96]			// first stacked arg
+	.endif
+
+	ldr		x28, [x24, #8]			// load lower counter
+CPU_LE(	rev		x28, x28	)
+
+0:	mov		x0, x25
+	load_round_keys	w26, x0
+	ld1		{SHASH.2d}, [x23]
+	ld1		{XL.2d}, [x20]
 
 	movi		MASK.16b, #0xe1
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
-CPU_LE(	rev		x8, x8		)
 	shl		MASK.2d, MASK.2d, #57
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	.if		\enc == 1
-	ld1		{KS.16b}, [x7]
+	ld1		{KS.16b}, [x27]
 	.endif
 
-0:	ld1		{CTR.8b}, [x5]			// load upper counter
-	ld1		{INP.16b}, [x3], #16
-	rev		x9, x8
-	add		x8, x8, #1
-	sub		w0, w0, #1
+1:	ld1		{CTR.8b}, [x24]			// load upper counter
+	ld1		{INP.16b}, [x22], #16
+	rev		x9, x28
+	add		x28, x28, #1
+	sub		w19, w19, #1
 	ins		CTR.d[1], x9			// set lower counter
 
 	.if		\enc == 1
 	eor		INP.16b, INP.16b, KS.16b	// encrypt input
-	st1		{INP.16b}, [x2], #16
+	st1		{INP.16b}, [x21], #16
 	.endif
 
 	rev64		T1.16b, INP.16b
 
-	cmp		w6, #12
-	b.ge		2f				// AES-192/256?
+	cmp		w26, #12
+	b.ge		4f				// AES-192/256?
 
-1:	enc_round	CTR, v21
+2:	enc_round	CTR, v21
 
 	ext		T2.16b, XL.16b, XL.16b, #8
 	ext		IN1.16b, T1.16b, T1.16b, #8
@@ -390,27 +425,39 @@ CPU_LE(	rev		x8, x8		)
 
 	.if		\enc == 0
 	eor		INP.16b, INP.16b, KS.16b
-	st1		{INP.16b}, [x2], #16
+	st1		{INP.16b}, [x21], #16
 	.endif
 
-	cbnz		w0, 0b
+	cbz		w19, 3f
 
-CPU_LE(	rev		x8, x8		)
-	st1		{XL.2d}, [x1]
-	str		x8, [x5, #8]			// store lower counter
+	if_will_cond_yield_neon
+	st1		{XL.2d}, [x20]
+	.if		\enc == 1
+	st1		{KS.16b}, [x27]
+	.endif
+	do_cond_yield_neon
+	b		0b
+	endif_yield_neon
 
+	b		1b
+
+3:	st1		{XL.2d}, [x20]
 	.if		\enc == 1
-	st1		{KS.16b}, [x7]
+	st1		{KS.16b}, [x27]
 	.endif
 
+CPU_LE(	rev		x28, x28	)
+	str		x28, [x24, #8]			// store lower counter
+
+	frame_pop
 	ret
 
-2:	b.eq		3f				// AES-192?
+4:	b.eq		5f				// AES-192?
 	enc_round	CTR, v17
 	enc_round	CTR, v18
-3:	enc_round	CTR, v19
+5:	enc_round	CTR, v19
 	enc_round	CTR, v20
-	b		1b
+	b		2b
 	.endm
 
 	/*
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index cfc9c92814fd..7cf0b1aa6ea8 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -63,11 +63,12 @@ static void (*pmull_ghash_update)(int blocks, u64 dg[], const char *src,
 
 asmlinkage void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[],
 				  const u8 src[], struct ghash_key const *k,
-				  u8 ctr[], int rounds, u8 ks[]);
+				  u8 ctr[], u32 const rk[], int rounds,
+				  u8 ks[]);
 
 asmlinkage void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[],
 				  const u8 src[], struct ghash_key const *k,
-				  u8 ctr[], int rounds);
+				  u8 ctr[], u32 const rk[], int rounds);
 
 asmlinkage void pmull_gcm_encrypt_block(u8 dst[], u8 const src[],
 					u32 const rk[], int rounds);
@@ -368,26 +369,29 @@ static int gcm_encrypt(struct aead_request *req)
 		pmull_gcm_encrypt_block(ks, iv, NULL,
 					num_rounds(&ctx->aes_key));
 		put_unaligned_be32(3, iv + GCM_IV_SIZE);
+		kernel_neon_end();
 
-		err = skcipher_walk_aead_encrypt(&walk, req, true);
+		err = skcipher_walk_aead_encrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
+			kernel_neon_begin();
 			pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
 					  walk.src.virt.addr, &ctx->ghash_key,
-					  iv, num_rounds(&ctx->aes_key), ks);
+					  iv, ctx->aes_key.key_enc,
+					  num_rounds(&ctx->aes_key), ks);
+			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
 						 walk.nbytes % AES_BLOCK_SIZE);
 		}
-		kernel_neon_end();
 	} else {
 		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv,
 				    num_rounds(&ctx->aes_key));
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
-		err = skcipher_walk_aead_encrypt(&walk, req, true);
+		err = skcipher_walk_aead_encrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -467,15 +471,19 @@ static int gcm_decrypt(struct aead_request *req)
 		pmull_gcm_encrypt_block(tag, iv, ctx->aes_key.key_enc,
 					num_rounds(&ctx->aes_key));
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
+		kernel_neon_end();
 
-		err = skcipher_walk_aead_decrypt(&walk, req, true);
+		err = skcipher_walk_aead_decrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
+			kernel_neon_begin();
 			pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
 					  walk.src.virt.addr, &ctx->ghash_key,
-					  iv, num_rounds(&ctx->aes_key));
+					  iv, ctx->aes_key.key_enc,
+					  num_rounds(&ctx->aes_key));
+			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
 						 walk.nbytes % AES_BLOCK_SIZE);
@@ -483,14 +491,12 @@ static int gcm_decrypt(struct aead_request *req)
 		if (walk.nbytes)
 			pmull_gcm_encrypt_block(iv, iv, NULL,
 						num_rounds(&ctx->aes_key));
-
-		kernel_neon_end();
 	} else {
 		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv,
 				    num_rounds(&ctx->aes_key));
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
-		err = skcipher_walk_aead_decrypt(&walk, req, true);
+		err = skcipher_walk_aead_decrypt(&walk, req, false);
 
 		while (walk.nbytes >= AES_BLOCK_SIZE) {
 			int blocks = walk.nbytes / AES_BLOCK_SIZE;
-- 
2.15.1
