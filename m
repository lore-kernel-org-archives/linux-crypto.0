From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto/arm64: aes-ce-gcm - operate on two input blocks at
 a time
Date: Sat, 28 Jul 2018 20:53:59 +0200
Message-ID: <20180728185400.8237-2-ard.biesheuvel@linaro.org>
References: <20180728185400.8237-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jerome.forissier@linaro.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, catalin.marinas@arm.com,
 will.deacon@arm.com, vakul.garg@nxp.com, jens.wiklander@linaro.org,
 linux-arm-kernel@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180728185400.8237-1-ard.biesheuvel@linaro.org>
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

Update the core AES/GCM transform and the associated plumbing to operate
on 2 AES/GHASH blocks at a time. By itself, this is not expected to
result in a noticeable speedup, but it paves the way for reimplementing
the GHASH component using 2-way aggregation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 129 +++++++++++++++-----
 arch/arm64/crypto/ghash-ce-glue.c |  84 +++++++++----
 2 files changed, 155 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index dcffb9e77589..437a2fb0f7f9 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -286,9 +286,10 @@ ENTRY(pmull_ghash_update_p8)
 	__pmull_ghash	p8
 ENDPROC(pmull_ghash_update_p8)
 
-	KS		.req	v8
-	CTR		.req	v9
-	INP		.req	v10
+	KS0		.req	v8
+	KS1		.req	v9
+	INP0		.req	v10
+	INP1		.req	v11
 
 	.macro		load_round_keys, rounds, rk
 	cmp		\rounds, #12
@@ -350,90 +351,152 @@ CPU_LE(	rev		x28, x28	)
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	.if		\enc == 1
-	ld1		{KS.16b}, [x27]
+	ld1		{KS0.16b-KS1.16b}, [x27]
 	.endif
 
-1:	ld1		{CTR.8b}, [x24]			// load upper counter
-	ld1		{INP.16b}, [x22], #16
+1:	ld1		{INP0.16b-INP1.16b}, [x22], #32
+
 	rev		x9, x28
-	add		x28, x28, #1
-	sub		w19, w19, #1
-	ins		CTR.d[1], x9			// set lower counter
+	add		x10, x28, #1
+	add		x28, x28, #2
 
 	.if		\enc == 1
-	eor		INP.16b, INP.16b, KS.16b	// encrypt input
-	st1		{INP.16b}, [x21], #16
+	eor		INP0.16b, INP0.16b, KS0.16b	// encrypt input
+	eor		INP1.16b, INP1.16b, KS1.16b
 	.endif
 
-	rev64		T1.16b, INP.16b
+	ld1		{KS0.8b}, [x24]			// load upper counter
+	rev		x10, x10
+	sub		w19, w19, #2
+	mov		KS1.8b, KS0.8b
+	ins		KS0.d[1], x9			// set lower counter
+	ins		KS1.d[1], x10
+
+	rev64		T1.16b, INP0.16b
 
 	cmp		w26, #12
 	b.ge		4f				// AES-192/256?
 
-2:	enc_round	CTR, v21
+2:	enc_round	KS0, v21
+
+	ext		T2.16b, XL.16b, XL.16b, #8
+	ext		IN1.16b, T1.16b, T1.16b, #8
+
+	enc_round	KS1, v21
+
+	eor		T1.16b, T1.16b, T2.16b
+	eor		XL.16b, XL.16b, IN1.16b
+
+	enc_round	KS0, v22
+
+	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
+	eor		T1.16b, T1.16b, XL.16b
+
+	enc_round	KS1, v22
+
+	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
+	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
+
+	enc_round	KS0, v23
+
+	ext		T1.16b, XL.16b, XH.16b, #8
+	eor		T2.16b, XL.16b, XH.16b
+	eor		XM.16b, XM.16b, T1.16b
+
+	enc_round	KS1, v23
+
+	eor		XM.16b, XM.16b, T2.16b
+	pmull		T2.1q, XL.1d, MASK.1d
+
+	enc_round	KS0, v24
+
+	mov		XH.d[0], XM.d[1]
+	mov		XM.d[1], XL.d[0]
+
+	enc_round	KS1, v24
+
+	eor		XL.16b, XM.16b, T2.16b
+
+	enc_round	KS0, v25
+
+	ext		T2.16b, XL.16b, XL.16b, #8
+
+	enc_round	KS1, v25
+
+	pmull		XL.1q, XL.1d, MASK.1d
+	eor		T2.16b, T2.16b, XH.16b
+
+	enc_round	KS0, v26
+
+	eor		XL.16b, XL.16b, T2.16b
+	rev64		T1.16b, INP1.16b
+
+	enc_round	KS1, v26
 
 	ext		T2.16b, XL.16b, XL.16b, #8
 	ext		IN1.16b, T1.16b, T1.16b, #8
 
-	enc_round	CTR, v22
+	enc_round	KS0, v27
 
 	eor		T1.16b, T1.16b, T2.16b
 	eor		XL.16b, XL.16b, IN1.16b
 
-	enc_round	CTR, v23
+	enc_round	KS1, v27
 
 	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
 	eor		T1.16b, T1.16b, XL.16b
 
-	enc_round	CTR, v24
+	enc_round	KS0, v28
 
 	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
 	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
 
-	enc_round	CTR, v25
+	enc_round	KS1, v28
 
 	ext		T1.16b, XL.16b, XH.16b, #8
 	eor		T2.16b, XL.16b, XH.16b
 	eor		XM.16b, XM.16b, T1.16b
 
-	enc_round	CTR, v26
+	enc_round	KS0, v29
 
 	eor		XM.16b, XM.16b, T2.16b
 	pmull		T2.1q, XL.1d, MASK.1d
 
-	enc_round	CTR, v27
+	enc_round	KS1, v29
 
 	mov		XH.d[0], XM.d[1]
 	mov		XM.d[1], XL.d[0]
 
-	enc_round	CTR, v28
+	aese		KS0.16b, v30.16b
 
 	eor		XL.16b, XM.16b, T2.16b
 
-	enc_round	CTR, v29
+	aese		KS1.16b, v30.16b
 
 	ext		T2.16b, XL.16b, XL.16b, #8
 
-	aese		CTR.16b, v30.16b
+	eor		KS0.16b, KS0.16b, v31.16b
 
 	pmull		XL.1q, XL.1d, MASK.1d
 	eor		T2.16b, T2.16b, XH.16b
 
-	eor		KS.16b, CTR.16b, v31.16b
+	eor		KS1.16b, KS1.16b, v31.16b
 
 	eor		XL.16b, XL.16b, T2.16b
 
 	.if		\enc == 0
-	eor		INP.16b, INP.16b, KS.16b
-	st1		{INP.16b}, [x21], #16
+	eor		INP0.16b, INP0.16b, KS0.16b
+	eor		INP1.16b, INP1.16b, KS1.16b
 	.endif
 
+	st1		{INP0.16b-INP1.16b}, [x21], #32
+
 	cbz		w19, 3f
 
 	if_will_cond_yield_neon
 	st1		{XL.2d}, [x20]
 	.if		\enc == 1
-	st1		{KS.16b}, [x27]
+	st1		{KS0.16b-KS1.16b}, [x27]
 	.endif
 	do_cond_yield_neon
 	b		0b
@@ -443,7 +506,7 @@ CPU_LE(	rev		x28, x28	)
 
 3:	st1		{XL.2d}, [x20]
 	.if		\enc == 1
-	st1		{KS.16b}, [x27]
+	st1		{KS0.16b-KS1.16b}, [x27]
 	.endif
 
 CPU_LE(	rev		x28, x28	)
@@ -453,10 +516,14 @@ CPU_LE(	rev		x28, x28	)
 	ret
 
 4:	b.eq		5f				// AES-192?
-	enc_round	CTR, v17
-	enc_round	CTR, v18
-5:	enc_round	CTR, v19
-	enc_round	CTR, v20
+	enc_round	KS0, v17
+	enc_round	KS1, v17
+	enc_round	KS0, v18
+	enc_round	KS1, v18
+5:	enc_round	KS0, v19
+	enc_round	KS1, v19
+	enc_round	KS0, v20
+	enc_round	KS1, v20
 	b		2b
 	.endm
 
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 8a10f1d7199a..371f8368c196 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -349,7 +349,7 @@ static int gcm_encrypt(struct aead_request *req)
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
 	struct skcipher_walk walk;
 	u8 iv[AES_BLOCK_SIZE];
-	u8 ks[AES_BLOCK_SIZE];
+	u8 ks[2 * AES_BLOCK_SIZE];
 	u8 tag[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
 	int err;
@@ -369,12 +369,15 @@ static int gcm_encrypt(struct aead_request *req)
 		pmull_gcm_encrypt_block(ks, iv, NULL,
 					num_rounds(&ctx->aes_key));
 		put_unaligned_be32(3, iv + GCM_IV_SIZE);
+		pmull_gcm_encrypt_block(ks + AES_BLOCK_SIZE, iv, NULL,
+					num_rounds(&ctx->aes_key));
+		put_unaligned_be32(4, iv + GCM_IV_SIZE);
 		kernel_neon_end();
 
 		err = skcipher_walk_aead_encrypt(&walk, req, false);
 
-		while (walk.nbytes >= AES_BLOCK_SIZE) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+		while (walk.nbytes >= 2 * AES_BLOCK_SIZE) {
+			int blocks = walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
 
 			kernel_neon_begin();
 			pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
@@ -384,7 +387,7 @@ static int gcm_encrypt(struct aead_request *req)
 			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
+					walk.nbytes % (2 * AES_BLOCK_SIZE));
 		}
 	} else {
 		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv,
@@ -424,13 +427,21 @@ static int gcm_encrypt(struct aead_request *req)
 	/* handle the tail */
 	if (walk.nbytes) {
 		u8 buf[GHASH_BLOCK_SIZE];
+		unsigned int nbytes = walk.nbytes;
+		u8 *dst = walk.dst.virt.addr;
+		u8 *head = NULL;
 
-		crypto_xor_cpy(walk.dst.virt.addr, walk.src.virt.addr, ks,
-			       walk.nbytes);
+		crypto_xor_cpy(dst, walk.src.virt.addr, ks, nbytes);
 
-		memcpy(buf, walk.dst.virt.addr, walk.nbytes);
-		memset(buf + walk.nbytes, 0, GHASH_BLOCK_SIZE - walk.nbytes);
-		ghash_do_update(1, dg, buf, &ctx->ghash_key, NULL);
+		if (walk.nbytes > GHASH_BLOCK_SIZE) {
+			head = dst;
+			dst += GHASH_BLOCK_SIZE;
+			nbytes %= GHASH_BLOCK_SIZE;
+		}
+
+		memcpy(buf, dst, nbytes);
+		memset(buf + nbytes, 0, GHASH_BLOCK_SIZE - nbytes);
+		ghash_do_update(!!nbytes, dg, buf, &ctx->ghash_key, head);
 
 		err = skcipher_walk_done(&walk, 0);
 	}
@@ -453,10 +464,11 @@ static int gcm_decrypt(struct aead_request *req)
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int authsize = crypto_aead_authsize(aead);
 	struct skcipher_walk walk;
-	u8 iv[AES_BLOCK_SIZE];
+	u8 iv[2 * AES_BLOCK_SIZE];
 	u8 tag[AES_BLOCK_SIZE];
-	u8 buf[GHASH_BLOCK_SIZE];
+	u8 buf[2 * GHASH_BLOCK_SIZE];
 	u64 dg[2] = {};
+	int nrounds = num_rounds(&ctx->aes_key);
 	int err;
 
 	if (req->assoclen)
@@ -467,31 +479,40 @@ static int gcm_decrypt(struct aead_request *req)
 
 	if (likely(may_use_simd())) {
 		kernel_neon_begin();
-
-		pmull_gcm_encrypt_block(tag, iv, ctx->aes_key.key_enc,
-					num_rounds(&ctx->aes_key));
+		pmull_gcm_encrypt_block(tag, iv, ctx->aes_key.key_enc, nrounds);
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 		kernel_neon_end();
 
 		err = skcipher_walk_aead_decrypt(&walk, req, false);
 
-		while (walk.nbytes >= AES_BLOCK_SIZE) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+		while (walk.nbytes >= 2 * AES_BLOCK_SIZE) {
+			int blocks = walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
 
 			kernel_neon_begin();
 			pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
 					  walk.src.virt.addr, &ctx->ghash_key,
-					  iv, ctx->aes_key.key_enc,
-					  num_rounds(&ctx->aes_key));
+					  iv, ctx->aes_key.key_enc, nrounds);
 			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
+					walk.nbytes % (2 * AES_BLOCK_SIZE));
+		}
+		if (walk.nbytes > AES_BLOCK_SIZE) {
+			u32 ctr = get_unaligned_be32(iv + GCM_IV_SIZE);
+
+			memcpy(iv + AES_BLOCK_SIZE, iv, GCM_IV_SIZE);
+			put_unaligned_be32(ctr + 1,
+					   iv + AES_BLOCK_SIZE + GCM_IV_SIZE);
 		}
 		if (walk.nbytes) {
 			kernel_neon_begin();
 			pmull_gcm_encrypt_block(iv, iv, ctx->aes_key.key_enc,
-						num_rounds(&ctx->aes_key));
+						nrounds);
+
+			if (walk.nbytes > AES_BLOCK_SIZE)
+				pmull_gcm_encrypt_block(iv + AES_BLOCK_SIZE,
+							iv + AES_BLOCK_SIZE,
+							NULL, nrounds);
 			kernel_neon_end();
 		}
 
@@ -512,8 +533,7 @@ static int gcm_decrypt(struct aead_request *req)
 
 			do {
 				__aes_arm64_encrypt(ctx->aes_key.key_enc,
-						    buf, iv,
-						    num_rounds(&ctx->aes_key));
+						    buf, iv, nrounds);
 				crypto_xor_cpy(dst, src, buf, AES_BLOCK_SIZE);
 				crypto_inc(iv, AES_BLOCK_SIZE);
 
@@ -526,14 +546,24 @@ static int gcm_decrypt(struct aead_request *req)
 		}
 		if (walk.nbytes)
 			__aes_arm64_encrypt(ctx->aes_key.key_enc, iv, iv,
-					    num_rounds(&ctx->aes_key));
+					    nrounds);
 	}
 
 	/* handle the tail */
 	if (walk.nbytes) {
-		memcpy(buf, walk.src.virt.addr, walk.nbytes);
-		memset(buf + walk.nbytes, 0, GHASH_BLOCK_SIZE - walk.nbytes);
-		ghash_do_update(1, dg, buf, &ctx->ghash_key, NULL);
+		const u8 *src = walk.src.virt.addr;
+		const u8 *head = NULL;
+		unsigned int nbytes = walk.nbytes;
+
+		if (walk.nbytes > GHASH_BLOCK_SIZE) {
+			head = src;
+			src += GHASH_BLOCK_SIZE;
+			nbytes %= GHASH_BLOCK_SIZE;
+		}
+
+		memcpy(buf, src, nbytes);
+		memset(buf + nbytes, 0, GHASH_BLOCK_SIZE - nbytes);
+		ghash_do_update(!!nbytes, dg, buf, &ctx->ghash_key, head);
 
 		crypto_xor_cpy(walk.dst.virt.addr, walk.src.virt.addr, iv,
 			       walk.nbytes);
@@ -558,7 +588,7 @@ static int gcm_decrypt(struct aead_request *req)
 
 static struct aead_alg gcm_aes_alg = {
 	.ivsize			= GCM_IV_SIZE,
-	.chunksize		= AES_BLOCK_SIZE,
+	.chunksize		= 2 * AES_BLOCK_SIZE,
 	.maxauthsize		= AES_BLOCK_SIZE,
 	.setkey			= gcm_setkey,
 	.setauthsize		= gcm_setauthsize,
-- 
2.18.0
