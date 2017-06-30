From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFT PATCH v2] crypto: arm64/gcm - implement native driver using v8 Crypto Extensions
Date: Fri, 30 Jun 2017 11:32:41 +0000
Message-ID: <20170630113241.17002-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35535 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdF3LdK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2017 07:33:10 -0400
Received: by mail-wm0-f50.google.com with SMTP id w126so107252387wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2017 04:33:10 -0700 (PDT)
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
v2: - rebase onto non-upstream arm64 SIMD refactoring branch
      (https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm64-gcm)
    - implement non-SIMD fallback
    - remove accelerated AES routines from setkey() path
    - use be32() accessors instead of open-coded array assignments
    - remove redundant round key loads

Raw numbers measured on a 2GHz AMD Overdrive B1 can be found after he patch.

 arch/arm64/crypto/Kconfig         |   3 +-
 arch/arm64/crypto/ghash-ce-core.S | 175 ++++++++
 arch/arm64/crypto/ghash-ce-glue.c | 436 ++++++++++++++++++--
 3 files changed, 587 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index a669dedc8767..3e5b39b79fb9 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -29,10 +29,11 @@ config CRYPTO_SHA2_ARM64_CE
 	select CRYPTO_SHA256_ARM64
 
 config CRYPTO_GHASH_ARM64_CE
-	tristate "GHASH (for GCM chaining mode) using ARMv8 Crypto Extensions"
+	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
 	select CRYPTO_GF128MUL
+	select CRYPTO_AES
 
 config CRYPTO_CRCT10DIF_ARM64_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index f0bb9f0b524f..cb22459eba85 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -77,3 +77,178 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
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
+	ld1		{v17.4s-v18.4s}, [\rk], #32
+1111:	ld1		{v19.4s-v20.4s}, [\rk], #32
+2222:	ld1		{v21.4s-v24.4s}, [\rk], #64
+	ld1		{v25.4s-v28.4s}, [\rk], #64
+	ld1		{v29.4s-v31.4s}, [\rk]
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
+	ld1		{KS.16b}, [x7]
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
+	cmp		w6, #12
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
+	st1		{KS.16b}, [x7]
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
+	 *			  struct ghash_key const *k, u8 ctr[],
+	 *			  int rounds, u8 ks[])
+	 */
+ENTRY(pmull_gcm_encrypt)
+	pmull_gcm_do_crypt	1
+ENDPROC(pmull_gcm_encrypt)
+
+	/*
+	 * void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[], const u8 src[],
+	 *			  struct ghash_key const *k, u8 ctr[],
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
+	cbz		x2, 0f
+	load_round_keys	w3, x2
+0:	ld1		{v0.16b}, [x1]
+	enc_block	v0, w3
+	st1		{v0.16b}, [x0]
+	ret
+ENDPROC(pmull_gcm_encrypt_block)
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 30221ef56e70..85ff57e789ff 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -11,18 +11,25 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <asm/unaligned.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 
-MODULE_DESCRIPTION("GHASH secure hash using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("GHASH and AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
+#define GCM_IV_SIZE		12
 
 struct ghash_key {
 	u64 a;
@@ -36,9 +43,25 @@ struct ghash_desc_ctx {
 	u32 count;
 };
 
+struct gcm_aes_ctx {
+	struct crypto_aes_ctx	aes_key;
+	struct ghash_key	ghash_key;
+};
+
 asmlinkage void pmull_ghash_update(int blocks, u64 dg[], const char *src,
 				   struct ghash_key const *k, const char *head);
 
+asmlinkage void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[],
+				  const u8 src[], struct ghash_key const *k,
+				  u8 ctr[], int rounds, u8 ks[]);
+
+asmlinkage void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[],
+				  const u8 src[], struct ghash_key const *k,
+				  u8 ctr[], int rounds);
+
+asmlinkage void pmull_gcm_encrypt_block(u8 dst[], u8 const src[],
+					u32 const rk[], int rounds);
+
 static int ghash_init(struct shash_desc *desc)
 {
 	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
@@ -130,17 +153,11 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
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
 	/* needed for the fallback */
 	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
 
@@ -157,31 +174,398 @@ static int ghash_setkey(struct crypto_shash *tfm,
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
-	.digestsize	= GHASH_DIGEST_SIZE,
-	.init		= ghash_init,
-	.update		= ghash_update,
-	.final		= ghash_final,
-	.setkey		= ghash_setkey,
-	.descsize	= sizeof(struct ghash_desc_ctx),
-	.base		= {
-		.cra_name		= "ghash",
-		.cra_driver_name	= "ghash-ce",
-		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize		= GHASH_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct ghash_key),
-		.cra_module		= THIS_MODULE,
-	},
+	.base.cra_name		= "ghash",
+	.base.cra_driver_name	= "ghash-ce",
+	.base.cra_priority	= 200,
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct ghash_key),
+	.base.cra_module	= THIS_MODULE,
+
+	.digestsize		= GHASH_DIGEST_SIZE,
+	.init			= ghash_init,
+	.update			= ghash_update,
+	.final			= ghash_final,
+	.setkey			= ghash_setkey,
+	.descsize		= sizeof(struct ghash_desc_ctx),
 };
 
-static int __init ghash_ce_mod_init(void)
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
+	ret = crypto_aes_expand_key(&ctx->aes_key, inkey, keylen);
+	if (ret) {
+		tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	crypto_aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
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
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
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
+		ghash_do_update(blocks, dg, src, &ctx->ghash_key,
+				*buf_count ? buf : NULL);
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
+{
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
+		ghash_do_update(1, dg, buf, &ctx->ghash_key, NULL);
+	}
+}
+
+static void gcm_final(struct aead_request *req, struct gcm_aes_ctx *ctx,
+		      u64 dg[], u8 tag[], int cryptlen)
+{
+	u8 mac[AES_BLOCK_SIZE];
+	u128 lengths;
+
+	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.b = cpu_to_be64(cryptlen * 8);
+
+	ghash_do_update(1, dg, (void *)&lengths, &ctx->ghash_key, NULL);
+
+	put_unaligned_be64(dg[1], mac);
+	put_unaligned_be64(dg[0], mac + 8);
+
+	crypto_xor(tag, mac, AES_BLOCK_SIZE);
+}
+
+static int gcm_encrypt(struct aead_request *req)
 {
-	return crypto_register_shash(&ghash_alg);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct skcipher_walk walk;
+	u8 iv[AES_BLOCK_SIZE];
+	u8 ks[AES_BLOCK_SIZE];
+	u8 tag[AES_BLOCK_SIZE];
+	u64 dg[2] = {};
+	int err;
+
+	if (req->assoclen)
+		gcm_calculate_auth_mac(req, dg);
+
+	memcpy(iv, req->iv, GCM_IV_SIZE);
+	put_unaligned_be32(1, iv + GCM_IV_SIZE);
+
+	if (likely(may_use_simd())) {
+		kernel_neon_begin();
+
+		pmull_gcm_encrypt_block(tag, iv, ctx->aes_key.key_enc,
+					num_rounds(&ctx->aes_key));
+		put_unaligned_be32(2, iv + GCM_IV_SIZE);
+		pmull_gcm_encrypt_block(ks, iv, NULL,
+					num_rounds(&ctx->aes_key));
+		put_unaligned_be32(3, iv + GCM_IV_SIZE);
+
+		err = skcipher_walk_aead_encrypt(&walk, req, true);
+
+		while (walk.nbytes >= AES_BLOCK_SIZE) {
+			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+
+			pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
+					  walk.src.virt.addr, &ctx->ghash_key,
+					  iv, num_rounds(&ctx->aes_key), ks);
+
+			err = skcipher_walk_done(&walk,
+						 walk.nbytes % AES_BLOCK_SIZE);
+		}
+		kernel_neon_end();
+	} else {
+		crypto_aes_encrypt(&ctx->aes_key, tag, iv);
+		put_unaligned_be32(2, iv + GCM_IV_SIZE);
+
+		err = skcipher_walk_aead_encrypt(&walk, req, true);
+
+		while (walk.nbytes >= AES_BLOCK_SIZE) {
+			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+			u8 *dst = walk.dst.virt.addr;
+			u8 *src = walk.src.virt.addr;
+
+			do {
+				crypto_aes_encrypt(&ctx->aes_key, ks, iv);
+				if (dst != src)
+					memcpy(dst, src, AES_BLOCK_SIZE);
+				crypto_xor(dst, ks, AES_BLOCK_SIZE);
+				crypto_inc(iv, AES_BLOCK_SIZE);
+
+				dst += AES_BLOCK_SIZE;
+				src += AES_BLOCK_SIZE;
+			} while (--blocks > 0);
+
+			ghash_do_update(walk.nbytes / AES_BLOCK_SIZE, dg,
+					walk.dst.virt.addr, &ctx->ghash_key,
+					NULL);
+
+			err = skcipher_walk_done(&walk,
+						 walk.nbytes % AES_BLOCK_SIZE);
+		}
+		if (walk.nbytes)
+			crypto_aes_encrypt(&ctx->aes_key, ks, iv);
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
+		ghash_do_update(1, dg, buf, &ctx->ghash_key, NULL);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (err)
+		return err;
+
+	gcm_final(req, ctx, dg, tag, req->cryptlen);
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(tag, req->dst, req->assoclen + req->cryptlen,
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
+	u8 tag[AES_BLOCK_SIZE];
+	u8 buf[GHASH_BLOCK_SIZE];
+	u64 dg[2] = {};
+	int err;
+
+	if (req->assoclen)
+		gcm_calculate_auth_mac(req, dg);
+
+	memcpy(iv, req->iv, GCM_IV_SIZE);
+	put_unaligned_be32(1, iv + GCM_IV_SIZE);
+
+	if (likely(may_use_simd())) {
+		kernel_neon_begin();
+
+		pmull_gcm_encrypt_block(tag, iv, ctx->aes_key.key_enc,
+					num_rounds(&ctx->aes_key));
+		put_unaligned_be32(2, iv + GCM_IV_SIZE);
+
+		err = skcipher_walk_aead_decrypt(&walk, req, true);
+
+		while (walk.nbytes >= AES_BLOCK_SIZE) {
+			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+
+			pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
+					  walk.src.virt.addr, &ctx->ghash_key,
+					  iv, num_rounds(&ctx->aes_key));
+
+			err = skcipher_walk_done(&walk,
+						 walk.nbytes % AES_BLOCK_SIZE);
+		}
+		if (walk.nbytes)
+			pmull_gcm_encrypt_block(iv, iv, NULL,
+						num_rounds(&ctx->aes_key));
+
+		kernel_neon_end();
+	} else {
+		crypto_aes_encrypt(&ctx->aes_key, tag, iv);
+		put_unaligned_be32(2, iv + GCM_IV_SIZE);
+
+		err = skcipher_walk_aead_decrypt(&walk, req, true);
+
+		while (walk.nbytes >= AES_BLOCK_SIZE) {
+			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+			u8 *dst = walk.dst.virt.addr;
+			u8 *src = walk.src.virt.addr;
+
+			ghash_do_update(blocks, dg, walk.src.virt.addr,
+					&ctx->ghash_key, NULL);
+
+			do {
+				crypto_aes_encrypt(&ctx->aes_key, buf, iv);
+				if (dst != src)
+					memcpy(dst, src, AES_BLOCK_SIZE);
+				crypto_xor(dst, buf, AES_BLOCK_SIZE);
+				crypto_inc(iv, AES_BLOCK_SIZE);
+
+				dst += AES_BLOCK_SIZE;
+				src += AES_BLOCK_SIZE;
+			} while (--blocks > 0);
+
+			err = skcipher_walk_done(&walk,
+						 walk.nbytes % AES_BLOCK_SIZE);
+		}
+		if (walk.nbytes)
+			crypto_aes_encrypt(&ctx->aes_key, iv, iv);
+	}
+
+	/* handle the tail */
+	if (walk.nbytes) {
+		memcpy(buf, walk.src.virt.addr, walk.nbytes);
+		memset(buf + walk.nbytes, 0, GHASH_BLOCK_SIZE - walk.nbytes);
+		ghash_do_update(1, dg, buf, &ctx->ghash_key, NULL);
+
+		if (walk.dst.virt.addr != walk.src.virt.addr)
+			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       walk.nbytes);
+		crypto_xor(walk.dst.virt.addr, iv, walk.nbytes);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (err)
+		return err;
+
+	gcm_final(req, ctx, dg, tag, req->cryptlen - authsize);
+
+	/* compare calculated auth tag with the stored one */
+	scatterwalk_map_and_copy(buf, req->src,
+				 req->assoclen + req->cryptlen - authsize,
+				 authsize, 0);
+
+	if (crypto_memneq(tag, buf, authsize))
+		return -EBADMSG;
+	return 0;
+}
+
+static struct aead_alg gcm_aes_alg = {
+	.ivsize			= GCM_IV_SIZE,
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
