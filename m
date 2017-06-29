From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/gcm - implement native driver using v8 Crypto Extensions
Date: Thu, 29 Jun 2017 18:37:42 +0000
Message-ID: <20170629183742.2896-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:36316 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdF2Shz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 14:37:55 -0400
Received: by mail-wr0-f177.google.com with SMTP id c11so193855932wrc.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jun 2017 11:37:54 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, the AES-GCM implementation for arm64 systems that support the
ARMv8 Crypto Extensions is based on the generic GCM module, which combines
the AES-CTR implementation using AES instructions with the PMULL based
GHASH driver. This is suboptimal, given the fact that the input data needs
to be loaded twice, once for the encryption and again for the MAC
calculation.

On Cortex-A57 (r1p2) and other recent cores that implement micro-op fusing
for the AES instructions, AES executes at less than 1 cycle per byte, which
means that any cycles wasted on loading the data twice hurt even more.

So implement a new GCM driver that combines the AES and PMULL instructions
at the block level. This improves performance on Cortex-A57 by ~27% (from
3.5 cpb to 2.6 cpb)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Raw numbers measured on a 2GHz AMD Overdrive B1 can be found after he patch.

 arch/arm64/crypto/ghash-ce-core.S | 177 ++++++++++
 arch/arm64/crypto/ghash-ce-glue.c | 348 +++++++++++++++++++-
 2 files changed, 515 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index f0bb9f0b524f..7f0c7271c569 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -77,3 +77,180 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	st1		{XL.2d}, [x1]
 	ret
 ENDPROC(pmull_ghash_update)
+
+	KS		.req	v8
+	CTR		.req	v9
+	INP		.req	v10
+
+	.macro		load_round_keys, rounds, rk
+	cmp		\rounds, #12
+	blo		2222f		/* 128 bits */
+	beq		1111f		/* 192 bits */
+	ld1		{v17.16b-v18.16b}, [\rk], #32
+1111:	ld1		{v19.16b-v20.16b}, [\rk], #32
+2222:	ld1		{v21.16b-v24.16b}, [\rk], #64
+	ld1		{v25.16b-v28.16b}, [\rk], #64
+	ld1		{v29.16b-v31.16b}, [\rk]
+	.endm
+
+	.macro		enc_round, state, key
+	aese		\state\().16b, \key\().16b
+	aesmc		\state\().16b, \state\().16b
+	.endm
+
+	.macro		enc_block, state, rounds
+	cmp		\rounds, #12
+	b.lo		2222f		/* 128 bits */
+	b.eq		1111f		/* 192 bits */
+	enc_round	\state, v17
+	enc_round	\state, v18
+1111:	enc_round	\state, v19
+	enc_round	\state, v20
+2222:	.irp		key, v21, v22, v23, v24, v25, v26, v27, v28, v29
+	enc_round	\state, \key
+	.endr
+	aese		\state\().16b, v30.16b
+	eor		\state\().16b, \state\().16b, v31.16b
+	.endm
+
+	.macro		pmull_gcm_do_crypt, enc
+	load_round_keys	w7, x6
+
+	ld1		{SHASH.2d}, [x4]
+	ld1		{XL.2d}, [x1]
+	ldr		x8, [x5, #8]			// load lower counter
+
+	movi		MASK.16b, #0xe1
+	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
+CPU_LE(	rev		x8, x8		)
+	shl		MASK.2d, MASK.2d, #57
+	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
+
+	.if		\enc == 1
+	ldr		x10, [sp]
+	ld1		{KS.16b}, [x10]
+	.endif
+
+0:	ld1		{CTR.8b}, [x5]			// load upper counter
+	ld1		{INP.16b}, [x3], #16
+	rev		x9, x8
+	add		x8, x8, #1
+	sub		w0, w0, #1
+	ins		CTR.d[1], x9			// set lower counter
+
+	.if		\enc == 1
+	eor		INP.16b, INP.16b, KS.16b	// encrypt input
+	st1		{INP.16b}, [x2], #16
+	.endif
+
+	rev64		T1.16b, INP.16b
+
+	cmp		w7, #12
+	b.ge		2f				// AES-192/256?
+
+1:	enc_round	CTR, v21
+
+	ext		T2.16b, XL.16b, XL.16b, #8
+	ext		IN1.16b, T1.16b, T1.16b, #8
+
+	enc_round	CTR, v22
+
+	eor		T1.16b, T1.16b, T2.16b
+	eor		XL.16b, XL.16b, IN1.16b
+
+	enc_round	CTR, v23
+
+	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
+	eor		T1.16b, T1.16b, XL.16b
+
+	enc_round	CTR, v24
+
+	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
+	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
+
+	enc_round	CTR, v25
+
+	ext		T1.16b, XL.16b, XH.16b, #8
+	eor		T2.16b, XL.16b, XH.16b
+	eor		XM.16b, XM.16b, T1.16b
+
+	enc_round	CTR, v26
+
+	eor		XM.16b, XM.16b, T2.16b
+	pmull		T2.1q, XL.1d, MASK.1d
+
+	enc_round	CTR, v27
+
+	mov		XH.d[0], XM.d[1]
+	mov		XM.d[1], XL.d[0]
+
+	enc_round	CTR, v28
+
+	eor		XL.16b, XM.16b, T2.16b
+
+	enc_round	CTR, v29
+
+	ext		T2.16b, XL.16b, XL.16b, #8
+
+	aese		CTR.16b, v30.16b
+
+	pmull		XL.1q, XL.1d, MASK.1d
+	eor		T2.16b, T2.16b, XH.16b
+
+	eor		KS.16b, CTR.16b, v31.16b
+
+	eor		XL.16b, XL.16b, T2.16b
+
+	.if		\enc == 0
+	eor		INP.16b, INP.16b, KS.16b
+	st1		{INP.16b}, [x2], #16
+	.endif
+
+	cbnz		w0, 0b
+
+CPU_LE(	rev		x8, x8		)
+	st1		{XL.2d}, [x1]
+	str		x8, [x5, #8]			// store lower counter
+
+	.if		\enc == 1
+	st1		{KS.16b}, [x10]
+	.endif
+
+	ret
+
+2:	b.eq		3f				// AES-192?
+	enc_round	CTR, v17
+	enc_round	CTR, v18
+3:	enc_round	CTR, v19
+	enc_round	CTR, v20
+	b		1b
+	.endm
+
+	/*
+	 * void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[], const u8 src[],
+	 *			  struct ghash_key const *k, u8 ctr[], u8 rk[],
+	 *			  int rounds, u8 ks[])
+	 */
+ENTRY(pmull_gcm_encrypt)
+	pmull_gcm_do_crypt	1
+ENDPROC(pmull_gcm_encrypt)
+
+	/*
+	 * void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[], const u8 src[],
+	 *			  struct ghash_key const *k, u8 ctr[], u8 rk[],
+	 *			  int rounds)
+	 */
+ENTRY(pmull_gcm_decrypt)
+	pmull_gcm_do_crypt	0
+ENDPROC(pmull_gcm_decrypt)
+
+	/*
+	 * void pmull_gcm_encrypt_block(u8 dst[], u8 src[], u8 rk[], int rounds)
+	 */
+ENTRY(pmull_gcm_encrypt_block)
+	load_round_keys	w3, x2
+	ld1		{v0.16b}, [x1]
+	enc_block	v0, w3
+	st1		{v0.16b}, [x0]
+	ret
+ENDPROC(pmull_gcm_encrypt_block)
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 833ec1e3f3e9..6df097391643 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -10,11 +10,19 @@
 
 #include <asm/neon.h>
 #include <asm/unaligned.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/b128ops.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 
+#include "aes-ce-setkey.h"
+
 MODULE_DESCRIPTION("GHASH secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -33,6 +41,11 @@ struct ghash_desc_ctx {
 	u32 count;
 };
 
+struct gcm_aes_ctx {
+	struct crypto_aes_ctx	aes_key;
+	struct ghash_key	ghash_key;
+};
+
 asmlinkage void pmull_ghash_update(int blocks, u64 dg[], const char *src,
 				   struct ghash_key const *k, const char *head);
 
@@ -100,17 +113,11 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 	return 0;
 }
 
-static int ghash_setkey(struct crypto_shash *tfm,
-			const u8 *inkey, unsigned int keylen)
+static int __ghash_setkey(struct ghash_key *key,
+			  const u8 *inkey, unsigned int keylen)
 {
-	struct ghash_key *key = crypto_shash_ctx(tfm);
 	u64 a, b;
 
-	if (keylen != GHASH_BLOCK_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
 	/* perform multiplication by 'x' in GF(2^128) */
 	b = get_unaligned_be64(inkey);
 	a = get_unaligned_be64(inkey + 8);
@@ -124,6 +131,19 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	return 0;
 }
 
+static int ghash_setkey(struct crypto_shash *tfm,
+			const u8 *inkey, unsigned int keylen)
+{
+	struct ghash_key *key = crypto_shash_ctx(tfm);
+
+	if (keylen != GHASH_BLOCK_SIZE) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	return __ghash_setkey(key, inkey, keylen);
+}
+
 static struct shash_alg ghash_alg = {
 	.digestsize	= GHASH_DIGEST_SIZE,
 	.init		= ghash_init,
@@ -142,13 +162,321 @@ static struct shash_alg ghash_alg = {
 	},
 };
 
-static int __init ghash_ce_mod_init(void)
+asmlinkage void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[],
+				  const u8 src[], struct ghash_key const *k,
+				  u8 ctr[], u32 rk[], int rounds, u8 ks[]);
+
+asmlinkage void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[],
+				  const u8 src[], struct ghash_key const *k,
+				  u8 ctr[], u32 rk[], int rounds);
+
+asmlinkage void pmull_gcm_encrypt_block(u8 dst[], u8 const src[],
+					u32 const rk[], int rounds);
+
+static int num_rounds(struct crypto_aes_ctx *ctx)
+{
+	/*
+	 * # of rounds specified by AES:
+	 * 128 bit key		10 rounds
+	 * 192 bit key		12 rounds
+	 * 256 bit key		14 rounds
+	 * => n byte key	=> 6 + (n/4) rounds
+	 */
+	return 6 + ctx->key_length / 4;
+}
+
+static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
+		      unsigned int keylen)
+{
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
+	u8 key[GHASH_BLOCK_SIZE];
+	int ret;
+
+	ret = ce_aes_expandkey(&ctx->aes_key, inkey, keylen);
+	if (ret) {
+		tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	kernel_neon_begin();
+	pmull_gcm_encrypt_block(key, (u8[AES_BLOCK_SIZE]){},
+				ctx->aes_key.key_enc,
+				num_rounds(&ctx->aes_key));
+	kernel_neon_end();
+
+	return __ghash_setkey(&ctx->ghash_key, key, sizeof(key));
+}
+
+static int gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12 ... 16:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void gcm_update_mac(u64 dg[], const u8 *src, int count, u8 buf[],
+			   int *buf_count, struct gcm_aes_ctx *ctx)
+{
+	if (*buf_count > 0) {
+		int buf_added = min(count, GHASH_BLOCK_SIZE - *buf_count);
+
+		memcpy(&buf[*buf_count], src, buf_added);
+
+		*buf_count += buf_added;
+		src += buf_added;
+		count -= buf_added;
+	}
+
+	if (count >= GHASH_BLOCK_SIZE || *buf_count == GHASH_BLOCK_SIZE) {
+		int blocks = count / GHASH_BLOCK_SIZE;
+
+		pmull_ghash_update(blocks, dg, src, &ctx->ghash_key,
+				   *buf_count ? buf : NULL);
+
+		src += blocks * GHASH_BLOCK_SIZE;
+		count %= GHASH_BLOCK_SIZE;
+		*buf_count = 0;
+	}
+
+	if (count > 0) {
+		memcpy(buf, src, count);
+		*buf_count = count;
+	}
+}
+
+static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[])
 {
-	return crypto_register_shash(&ghash_alg);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
+	u8 buf[GHASH_BLOCK_SIZE];
+	struct scatter_walk walk;
+	u32 len = req->assoclen;
+	int buf_count = 0;
+
+	scatterwalk_start(&walk, req->src);
+
+	do {
+		u32 n = scatterwalk_clamp(&walk, len);
+		u8 *p;
+
+		if (!n) {
+			scatterwalk_start(&walk, sg_next(walk.sg));
+			n = scatterwalk_clamp(&walk, len);
+		}
+		p = scatterwalk_map(&walk);
+
+		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
+		len -= n;
+
+		scatterwalk_unmap(p);
+		scatterwalk_advance(&walk, n);
+		scatterwalk_done(&walk, 0, len);
+	} while (len);
+
+	if (buf_count) {
+		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
+		pmull_ghash_update(1, dg, buf, &ctx->ghash_key, NULL);
+	}
+}
+
+static void gcm_final(struct aead_request *req, struct gcm_aes_ctx *ctx,
+		      u64 dg[], u8 mac[], int cryptlen)
+{
+	u8 ctr[AES_BLOCK_SIZE];
+	u128 lengths;
+
+	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.b = cpu_to_be64(cryptlen * 8);
+
+	pmull_ghash_update(1, dg, (void *)&lengths, &ctx->ghash_key, NULL);
+
+	put_unaligned_be64(dg[1], mac);
+	put_unaligned_be64(dg[0], mac + 8);
+
+	memcpy(ctr, req->iv, 12);
+	ctr[12] = ctr[13] = ctr[14] = 0;
+	ctr[15] = 1;
+
+	pmull_gcm_encrypt_block(ctr, ctr, ctx->aes_key.key_enc,
+				num_rounds(&ctx->aes_key));
+	crypto_xor(mac, ctr, AES_BLOCK_SIZE);
+}
+
+static int gcm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct skcipher_walk walk;
+	u8 iv[AES_BLOCK_SIZE];
+	u8 ks[AES_BLOCK_SIZE];
+	u8 mac[AES_BLOCK_SIZE];
+	u64 dg[2] = {};
+	int err;
+
+	kernel_neon_begin();
+
+	if (req->assoclen)
+		gcm_calculate_auth_mac(req, dg);
+
+	memcpy(iv, req->iv, 12);
+	iv[12] = iv[13] = iv[14] = 0;
+	iv[15] = 2;
+
+	pmull_gcm_encrypt_block(ks, iv, ctx->aes_key.key_enc,
+				num_rounds(&ctx->aes_key));
+	iv[15] = 3;
+
+	err = skcipher_walk_aead_encrypt(&walk, req, true);
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int blocks = walk.nbytes / AES_BLOCK_SIZE;
+
+		pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
+				  walk.src.virt.addr, &ctx->ghash_key,
+				  iv, ctx->aes_key.key_enc,
+				  num_rounds(&ctx->aes_key), ks);
+
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+
+	/* handle the tail */
+	if (walk.nbytes) {
+		u8 buf[GHASH_BLOCK_SIZE];
+
+		if (walk.dst.virt.addr != walk.src.virt.addr)
+			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       walk.nbytes);
+		crypto_xor(walk.dst.virt.addr, ks, walk.nbytes);
+
+		memcpy(buf, walk.dst.virt.addr, walk.nbytes);
+		memset(buf + walk.nbytes, 0, GHASH_BLOCK_SIZE - walk.nbytes);
+		pmull_ghash_update(1, dg, buf, &ctx->ghash_key, NULL);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (!err)
+		gcm_final(req, ctx, dg, mac, req->cryptlen);
+
+	kernel_neon_end();
+
+	if (err)
+		return err;
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
+				 crypto_aead_authsize(aead), 1);
+
+	return 0;
+}
+
+static int gcm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	struct skcipher_walk walk;
+	u8 iv[AES_BLOCK_SIZE];
+	u8 mac[AES_BLOCK_SIZE];
+	u8 buf[GHASH_BLOCK_SIZE];
+	u64 dg[2] = {};
+	int err;
+
+	kernel_neon_begin();
+
+	if (req->assoclen)
+		gcm_calculate_auth_mac(req, dg);
+
+	memcpy(iv, req->iv, 12);
+	iv[12] = iv[13] = iv[14] = 0;
+	iv[15] = 2;
+
+	err = skcipher_walk_aead_decrypt(&walk, req, true);
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int blocks = walk.nbytes / AES_BLOCK_SIZE;
+
+		pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
+				  walk.src.virt.addr, &ctx->ghash_key,
+				  iv, ctx->aes_key.key_enc,
+				  num_rounds(&ctx->aes_key));
+
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+
+	/* handle the tail */
+	if (walk.nbytes) {
+		memcpy(buf, walk.src.virt.addr, walk.nbytes);
+		memset(buf + walk.nbytes, 0, GHASH_BLOCK_SIZE - walk.nbytes);
+		pmull_ghash_update(1, dg, buf, &ctx->ghash_key, NULL);
+
+		pmull_gcm_encrypt_block(buf, iv, ctx->aes_key.key_enc,
+					num_rounds(&ctx->aes_key));
+
+		if (walk.dst.virt.addr != walk.src.virt.addr)
+			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       walk.nbytes);
+		crypto_xor(walk.dst.virt.addr, buf, walk.nbytes);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (!err)
+		gcm_final(req, ctx, dg, mac, req->cryptlen - authsize);
+
+	kernel_neon_end();
+
+	if (err)
+		return err;
+
+	/* compare calculated auth tag with the stored one */
+	scatterwalk_map_and_copy(buf, req->src,
+				 req->assoclen + req->cryptlen - authsize,
+				 authsize, 0);
+
+	if (crypto_memneq(mac, buf, authsize))
+		return -EBADMSG;
+	return 0;
+}
+
+static struct aead_alg gcm_aes_alg = {
+	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.maxauthsize		= AES_BLOCK_SIZE,
+	.setkey			= gcm_setkey,
+	.setauthsize		= gcm_setauthsize,
+	.encrypt		= gcm_encrypt,
+	.decrypt		= gcm_decrypt,
+
+	.base.cra_name		= "gcm(aes)",
+	.base.cra_driver_name	= "gcm-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init ghash_ce_mod_init(void)
+{	int ret;
+
+	ret = crypto_register_shash(&ghash_alg);
+	if (ret)
+		return ret;
+
+	ret = crypto_register_aead(&gcm_aes_alg);
+	if (ret)
+		crypto_unregister_shash(&ghash_alg);
+	return ret;
 }
 
 static void __exit ghash_ce_mod_exit(void)
 {
+	crypto_unregister_aead(&gcm_aes_alg);
 	crypto_unregister_shash(&ghash_alg);
 }
 
-- 
2.9.3

Generic GCM wrapper around AES-CTR and GHASH (using AES and PMULL instructions)
===============================================================================

testing speed of gcm(aes) (gcm_base(ctr-aes-ce,ghash-ce)) encryption
test 0 (128 bit key, 16 byte blocks): 1133407 operations in 1 seconds (18134512 bytes)
test 1 (128 bit key, 64 byte blocks): 1025997 operations in 1 seconds (65663808 bytes)
test 2 (128 bit key, 256 byte blocks): 768971 operations in 1 seconds (196856576 bytes)
test 3 (128 bit key, 512 byte blocks): 577197 operations in 1 seconds (295524864 bytes)
test 4 (128 bit key, 1024 byte blocks): 390516 operations in 1 seconds (399888384 bytes)
test 5 (128 bit key, 2048 byte blocks): 237002 operations in 1 seconds (485380096 bytes)
test 6 (128 bit key, 4096 byte blocks): 132590 operations in 1 seconds (543088640 bytes)
test 7 (128 bit key, 8192 byte blocks): 69495 operations in 1 seconds (569303040 bytes)
test 8 (192 bit key, 16 byte blocks): 1108665 operations in 1 seconds (17738640 bytes)
test 9 (192 bit key, 64 byte blocks): 1054793 operations in 1 seconds (67506752 bytes)
test 10 (192 bit key, 256 byte blocks): 759134 operations in 1 seconds (194338304 bytes)
test 11 (192 bit key, 512 byte blocks): 565960 operations in 1 seconds (289771520 bytes)
test 12 (192 bit key, 1024 byte blocks): 380881 operations in 1 seconds (390022144 bytes)
test 13 (192 bit key, 2048 byte blocks): 231188 operations in 1 seconds (473473024 bytes)
test 14 (192 bit key, 4096 byte blocks): 128310 operations in 1 seconds (525557760 bytes)
test 15 (192 bit key, 8192 byte blocks): 67436 operations in 1 seconds (552435712 bytes)
test 16 (256 bit key, 16 byte blocks): 1122946 operations in 1 seconds (17967136 bytes)
test 17 (256 bit key, 64 byte blocks): 1006653 operations in 1 seconds (64425792 bytes)
test 18 (256 bit key, 256 byte blocks): 744818 operations in 1 seconds (190673408 bytes)
test 19 (256 bit key, 512 byte blocks): 553923 operations in 1 seconds (283608576 bytes)
test 20 (256 bit key, 1024 byte blocks): 371402 operations in 1 seconds (380315648 bytes)
test 21 (256 bit key, 2048 byte blocks): 223312 operations in 1 seconds (457342976 bytes)
test 22 (256 bit key, 4096 byte blocks): 123945 operations in 1 seconds (507678720 bytes)
test 23 (256 bit key, 8192 byte blocks): 64935 operations in 1 seconds (531947520 bytes)

Native GCM module with block level interleave of AES-CTR and GHASH
==================================================================

testing speed of gcm(aes) (gcm-aes-ce) encryption
test 0 (128 bit key, 16 byte blocks): 1860711 operations in 1 seconds (29771376 bytes)
test 1 (128 bit key, 64 byte blocks): 1573017 operations in 1 seconds (100673088 bytes)
test 2 (128 bit key, 256 byte blocks): 1136989 operations in 1 seconds (291069184 bytes)
test 3 (128 bit key, 512 byte blocks): 840846 operations in 1 seconds (430513152 bytes)
test 4 (128 bit key, 1024 byte blocks): 548205 operations in 1 seconds (561361920 bytes)
test 5 (128 bit key, 2048 byte blocks): 328413 operations in 1 seconds (672589824 bytes)
test 6 (128 bit key, 4096 byte blocks): 181673 operations in 1 seconds (744132608 bytes)
test 7 (128 bit key, 8192 byte blocks): 94986 operations in 1 seconds (778125312 bytes)
test 8 (192 bit key, 16 byte blocks): 1837762 operations in 1 seconds (29404192 bytes)
test 9 (192 bit key, 64 byte blocks): 1537458 operations in 1 seconds (98397312 bytes)
test 10 (192 bit key, 256 byte blocks): 1087589 operations in 1 seconds (278422784 bytes)
test 11 (192 bit key, 512 byte blocks): 807194 operations in 1 seconds (413283328 bytes)
test 12 (192 bit key, 1024 byte blocks): 524966 operations in 1 seconds (537565184 bytes)
test 13 (192 bit key, 2048 byte blocks): 312338 operations in 1 seconds (639668224 bytes)
test 14 (192 bit key, 4096 byte blocks): 173324 operations in 1 seconds (709935104 bytes)
test 15 (192 bit key, 8192 byte blocks): 90857 operations in 1 seconds (744300544 bytes)
test 16 (256 bit key, 16 byte blocks): 1798971 operations in 1 seconds (28783536 bytes)
test 17 (256 bit key, 64 byte blocks): 1497989 operations in 1 seconds (95871296 bytes)
test 18 (256 bit key, 256 byte blocks): 1058926 operations in 1 seconds (271085056 bytes)
test 19 (256 bit key, 512 byte blocks): 775609 operations in 1 seconds (397111808 bytes)
test 20 (256 bit key, 1024 byte blocks): 492267 operations in 1 seconds (504081408 bytes)
test 21 (256 bit key, 2048 byte blocks): 294868 operations in 1 seconds (603889664 bytes)
test 22 (256 bit key, 4096 byte blocks): 161802 operations in 1 seconds (662740992 bytes)
test 23 (256 bit key, 8192 byte blocks): 84664 operations in 1 seconds (693567488 bytes)
