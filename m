From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 11/16] crypto: aesni - Convert to skcipher
Date: Sun, 13 Nov 2016 19:45:43 +0800
Message-ID: <E1c5tEF-0002BK-A1@gondolin.me.apana.org.au>
References: <20161113114354.GA8169@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53427 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933828AbcKMLpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:45:54 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c5tEF-0007BY-Ea
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 22:45:43 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts aesni (including fpu) over to the skcipher
interface.  The LRW implementation has been removed as the generic
LRW code can now be used directly on top of the accelerated ECB
implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/aesni-intel_glue.c |  705 +++++++++++--------------------------
 arch/x86/crypto/fpu.c              |  207 ++++++----
 crypto/Kconfig                     |    7 
 3 files changed, 346 insertions(+), 573 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 0ab5ee1..f466019 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -21,7 +21,6 @@
 
 #include <linux/hardirq.h>
 #include <linux/types.h>
-#include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
@@ -29,14 +28,14 @@
 #include <crypto/cryptd.h>
 #include <crypto/ctr.h>
 #include <crypto/b128ops.h>
-#include <crypto/lrw.h>
 #include <crypto/xts.h>
 #include <asm/cpu_device_id.h>
 #include <asm/fpu/api.h>
 #include <asm/crypto/aes.h>
-#include <crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #ifdef CONFIG_X86_64
@@ -45,28 +44,26 @@
 
 
 #define AESNI_ALIGN	16
+#define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
 #define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE - 1))
 #define RFC4106_HASH_SUBKEY_SIZE 16
+#define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+#define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
+#define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
  */
 struct aesni_rfc4106_gcm_ctx {
-	u8 hash_subkey[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
-	struct crypto_aes_ctx aes_key_expanded
-		__attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 hash_subkey[16] AESNI_ALIGN_ATTR;
+	struct crypto_aes_ctx aes_key_expanded AESNI_ALIGN_ATTR;
 	u8 nonce[4];
 };
 
-struct aesni_lrw_ctx {
-	struct lrw_table_ctx lrw_table;
-	u8 raw_aes_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
-};
-
 struct aesni_xts_ctx {
-	u8 raw_tweak_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
-	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
+	u8 raw_tweak_ctx[sizeof(struct crypto_aes_ctx)] AESNI_ALIGN_ATTR;
+	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx)] AESNI_ALIGN_ATTR;
 };
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
@@ -360,96 +357,95 @@ static void __aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	aesni_dec(ctx, dst, src);
 }
 
-static int ecb_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			         unsigned int len)
+{
+	return aes_set_key_common(crypto_skcipher_tfm(tfm),
+				  crypto_skcipher_ctx(tfm), key, len);
+}
+
+static int ecb_encrypt(struct skcipher_request *req)
 {
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
 		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
 
-static int ecb_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb_decrypt(struct skcipher_request *req)
 {
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
 		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
 
-static int cbc_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
 		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
 
-static int cbc_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_decrypt(struct skcipher_request *req)
 {
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
 		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 	kernel_fpu_end();
 
@@ -458,7 +454,7 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 
 #ifdef CONFIG_X86_64
 static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
-			    struct blkcipher_walk *walk)
+			    struct skcipher_walk *walk)
 {
 	u8 *ctrblk = walk->iv;
 	u8 keystream[AES_BLOCK_SIZE];
@@ -491,157 +487,53 @@ static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 }
 #endif
 
-static int ctr_crypt(struct blkcipher_desc *desc,
-		     struct scatterlist *dst, struct scatterlist *src,
-		     unsigned int nbytes)
+static int ctr_crypt(struct skcipher_request *req)
 {
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
 		aesni_ctr_enc_tfm(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			              nbytes & AES_BLOCK_MASK, walk.iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 	if (walk.nbytes) {
 		ctr_crypt_final(ctx, &walk);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = skcipher_walk_done(&walk, 0);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
-#endif
-
-static int ablk_ecb_init(struct crypto_tfm *tfm)
-{
-	return ablk_init_common(tfm, "__driver-ecb-aes-aesni");
-}
-
-static int ablk_cbc_init(struct crypto_tfm *tfm)
-{
-	return ablk_init_common(tfm, "__driver-cbc-aes-aesni");
-}
-
-#ifdef CONFIG_X86_64
-static int ablk_ctr_init(struct crypto_tfm *tfm)
-{
-	return ablk_init_common(tfm, "__driver-ctr-aes-aesni");
-}
-
-#endif
-
-#if IS_ENABLED(CONFIG_CRYPTO_PCBC)
-static int ablk_pcbc_init(struct crypto_tfm *tfm)
-{
-	return ablk_init_common(tfm, "fpu(pcbc(__driver-aes-aesni))");
-}
-#endif
-
-static void lrw_xts_encrypt_callback(void *ctx, u8 *blks, unsigned int nbytes)
-{
-	aesni_ecb_enc(ctx, blks, blks, nbytes);
-}
 
-static void lrw_xts_decrypt_callback(void *ctx, u8 *blks, unsigned int nbytes)
-{
-	aesni_ecb_dec(ctx, blks, blks, nbytes);
-}
-
-static int lrw_aesni_setkey(struct crypto_tfm *tfm, const u8 *key,
+static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
-	struct aesni_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = aes_set_key_common(tfm, ctx->raw_aes_ctx, key,
-				 keylen - AES_BLOCK_SIZE);
+	err = xts_verify_key(tfm, key, keylen);
 	if (err)
 		return err;
 
-	return lrw_init_table(&ctx->lrw_table, key + keylen - AES_BLOCK_SIZE);
-}
-
-static void lrw_aesni_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct aesni_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lrw_free_table(&ctx->lrw_table);
-}
-
-static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct aesni_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[8];
-	struct lrw_crypt_req req = {
-		.tbuf = buf,
-		.tbuflen = sizeof(buf),
-
-		.table_ctx = &ctx->lrw_table,
-		.crypt_ctx = aes_ctx(ctx->raw_aes_ctx),
-		.crypt_fn = lrw_xts_encrypt_callback,
-	};
-	int ret;
-
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	kernel_fpu_begin();
-	ret = lrw_crypt(desc, dst, src, nbytes, &req);
-	kernel_fpu_end();
-
-	return ret;
-}
-
-static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct aesni_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[8];
-	struct lrw_crypt_req req = {
-		.tbuf = buf,
-		.tbuflen = sizeof(buf),
-
-		.table_ctx = &ctx->lrw_table,
-		.crypt_ctx = aes_ctx(ctx->raw_aes_ctx),
-		.crypt_fn = lrw_xts_decrypt_callback,
-	};
-	int ret;
-
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	kernel_fpu_begin();
-	ret = lrw_crypt(desc, dst, src, nbytes, &req);
-	kernel_fpu_end();
-
-	return ret;
-}
-
-static int xts_aesni_setkey(struct crypto_tfm *tfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct aesni_xts_ctx *ctx = crypto_tfm_ctx(tfm);
-	int err;
-
-	err = xts_check_key(tfm, key, keylen);
-	if (err)
-		return err;
+	keylen /= 2;
 
 	/* first half of xts-key is for crypt */
-	err = aes_set_key_common(tfm, ctx->raw_crypt_ctx, key, keylen / 2);
+	err = aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx,
+				 key, keylen);
 	if (err)
 		return err;
 
 	/* second half of xts-key is for tweak */
-	return aes_set_key_common(tfm, ctx->raw_tweak_ctx, key + keylen / 2,
-				  keylen / 2);
+	return aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx,
+				  key + keylen, keylen);
 }
 
 
@@ -650,8 +542,6 @@ static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
 	aesni_enc(ctx, out, in);
 }
 
-#ifdef CONFIG_X86_64
-
 static void aesni_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_enc));
@@ -698,83 +588,28 @@ static void aesni_xts_dec8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	} }
 };
 
-static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+static int xts_encrypt(struct skcipher_request *req)
 {
-	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_crypt_128bit(&aesni_enc_xts, desc, dst, src, nbytes,
-				     XTS_TWEAK_CAST(aesni_xts_tweak),
-				     aes_ctx(ctx->raw_tweak_ctx),
-				     aes_ctx(ctx->raw_crypt_ctx));
+	return glue_xts_req_128bit(&aesni_enc_xts, req,
+				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aes_ctx(ctx->raw_tweak_ctx),
+				   aes_ctx(ctx->raw_crypt_ctx));
 }
 
-static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+static int xts_decrypt(struct skcipher_request *req)
 {
-	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-
-	return glue_xts_crypt_128bit(&aesni_dec_xts, desc, dst, src, nbytes,
-				     XTS_TWEAK_CAST(aesni_xts_tweak),
-				     aes_ctx(ctx->raw_tweak_ctx),
-				     aes_ctx(ctx->raw_crypt_ctx));
-}
-
-#else
-
-static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[8];
-	struct xts_crypt_req req = {
-		.tbuf = buf,
-		.tbuflen = sizeof(buf),
-
-		.tweak_ctx = aes_ctx(ctx->raw_tweak_ctx),
-		.tweak_fn = aesni_xts_tweak,
-		.crypt_ctx = aes_ctx(ctx->raw_crypt_ctx),
-		.crypt_fn = lrw_xts_encrypt_callback,
-	};
-	int ret;
-
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	kernel_fpu_begin();
-	ret = xts_crypt(desc, dst, src, nbytes, &req);
-	kernel_fpu_end();
-
-	return ret;
-}
-
-static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[8];
-	struct xts_crypt_req req = {
-		.tbuf = buf,
-		.tbuflen = sizeof(buf),
-
-		.tweak_ctx = aes_ctx(ctx->raw_tweak_ctx),
-		.tweak_fn = aesni_xts_tweak,
-		.crypt_ctx = aes_ctx(ctx->raw_crypt_ctx),
-		.crypt_fn = lrw_xts_decrypt_callback,
-	};
-	int ret;
-
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	kernel_fpu_begin();
-	ret = xts_crypt(desc, dst, src, nbytes, &req);
-	kernel_fpu_end();
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return ret;
+	return glue_xts_req_128bit(&aesni_dec_xts, req,
+				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aes_ctx(ctx->raw_tweak_ctx),
+				   aes_ctx(ctx->raw_crypt_ctx));
 }
 
-#endif
-
-#ifdef CONFIG_X86_64
 static int rfc4106_init(struct crypto_aead *aead)
 {
 	struct cryptd_aead *cryptd_tfm;
@@ -1077,9 +912,7 @@ static int rfc4106_decrypt(struct aead_request *req)
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
-				  AESNI_ALIGN - 1,
-	.cra_alignmask		= 0,
+	.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 	.cra_module		= THIS_MODULE,
 	.cra_u	= {
 		.cipher	= {
@@ -1091,14 +924,12 @@ static int rfc4106_decrypt(struct aead_request *req)
 		}
 	}
 }, {
-	.cra_name		= "__aes-aesni",
-	.cra_driver_name	= "__driver-aes-aesni",
-	.cra_priority		= 0,
+	.cra_name		= "__aes",
+	.cra_driver_name	= "__aes-aesni",
+	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER | CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
-				  AESNI_ALIGN - 1,
-	.cra_alignmask		= 0,
+	.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 	.cra_module		= THIS_MODULE,
 	.cra_u	= {
 		.cipher	= {
@@ -1109,250 +940,94 @@ static int rfc4106_decrypt(struct aead_request *req)
 			.cia_decrypt		= __aes_decrypt
 		}
 	}
-}, {
-	.cra_name		= "__ecb-aes-aesni",
-	.cra_driver_name	= "__driver-ecb-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
-				  CRYPTO_ALG_INTERNAL,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
-				  AESNI_ALIGN - 1,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "__cbc-aes-aesni",
-	.cra_driver_name	= "__driver-cbc-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
-				  CRYPTO_ALG_INTERNAL,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
-				  AESNI_ALIGN - 1,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "ecb(aes)",
-	.cra_driver_name	= "ecb-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_ecb_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
+} };
+
+static struct skcipher_alg aesni_skciphers[] = {
+	{
+		.base = {
+			.cra_name		= "__ecb(aes)",
+			.cra_driver_name	= "__ecb-aes-aesni",
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
 		},
-	},
-}, {
-	.cra_name		= "cbc(aes)",
-	.cra_driver_name	= "cbc-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_cbc_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= aesni_skcipher_setkey,
+		.encrypt	= ecb_encrypt,
+		.decrypt	= ecb_decrypt,
+	}, {
+		.base = {
+			.cra_name		= "__cbc(aes)",
+			.cra_driver_name	= "__cbc-aes-aesni",
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
 		},
-	},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= aesni_skcipher_setkey,
+		.encrypt	= cbc_encrypt,
+		.decrypt	= cbc_decrypt,
 #ifdef CONFIG_X86_64
-}, {
-	.cra_name		= "__ctr-aes-aesni",
-	.cra_driver_name	= "__driver-ctr-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
-				  CRYPTO_ALG_INTERNAL,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
-				  AESNI_ALIGN - 1,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= ctr_crypt,
-			.decrypt	= ctr_crypt,
+	}, {
+		.base = {
+			.cra_name		= "__ctr(aes)",
+			.cra_driver_name	= "__ctr-aes-aesni",
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
 		},
-	},
-}, {
-	.cra_name		= "ctr(aes)",
-	.cra_driver_name	= "ctr-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_ctr_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_encrypt,
-			.geniv		= "chainiv",
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.setkey		= aesni_skcipher_setkey,
+		.encrypt	= ctr_crypt,
+		.decrypt	= ctr_crypt,
+	}, {
+		.base = {
+			.cra_name		= "__xts(aes)",
+			.cra_driver_name	= "__xts-aes-aesni",
+			.cra_priority		= 401,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= XTS_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
 		},
-	},
+		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= xts_aesni_setkey,
+		.encrypt	= xts_encrypt,
+		.decrypt	= xts_decrypt,
 #endif
+	}
+};
+
+struct simd_skcipher_alg *aesni_simd_skciphers[ARRAY_SIZE(aesni_skciphers)];
+
+struct {
+	const char *algname;
+	const char *drvname;
+	const char *basename;
+	struct simd_skcipher_alg *simd;
+} aesni_simd_skciphers2[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_PCBC)
-}, {
-	.cra_name		= "pcbc(aes)",
-	.cra_driver_name	= "pcbc-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_pcbc_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
+	{
+		.algname	= "pcbc(aes)",
+		.drvname	= "pcbc-aes-aesni",
+		.basename	= "fpu(pcbc(__aes-aesni))",
 	},
 #endif
-}, {
-	.cra_name		= "__lrw-aes-aesni",
-	.cra_driver_name	= "__driver-lrw-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
-				  CRYPTO_ALG_INTERNAL,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct aesni_lrw_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_exit		= lrw_aesni_exit_tfm,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= lrw_aesni_setkey,
-			.encrypt	= lrw_encrypt,
-			.decrypt	= lrw_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "__xts-aes-aesni",
-	.cra_driver_name	= "__driver-xts-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
-				  CRYPTO_ALG_INTERNAL,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct aesni_xts_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= 2 * AES_MIN_KEY_SIZE,
-			.max_keysize	= 2 * AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= xts_aesni_setkey,
-			.encrypt	= xts_encrypt,
-			.decrypt	= xts_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "lrw(aes)",
-	.cra_driver_name	= "lrw-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "xts(aes)",
-	.cra_driver_name	= "xts-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= 2 * AES_MIN_KEY_SIZE,
-			.max_keysize	= 2 * AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-} };
+};
 
 #ifdef CONFIG_X86_64
 static struct aead_alg aesni_aead_algs[] = { {
@@ -1401,9 +1076,27 @@ static int rfc4106_decrypt(struct aead_request *req)
 };
 MODULE_DEVICE_TABLE(x86cpu, aesni_cpu_id);
 
+static void aesni_free_simds(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(aesni_simd_skciphers) &&
+		    aesni_simd_skciphers[i]; i++)
+		simd_skcipher_free(aesni_simd_skciphers[i]);
+
+	for (i = 0; i < ARRAY_SIZE(aesni_simd_skciphers2) &&
+		    aesni_simd_skciphers2[i].simd; i++)
+		simd_skcipher_free(aesni_simd_skciphers2[i].simd);
+}
+
 static int __init aesni_init(void)
 {
+	struct simd_skcipher_alg *simd;
+	const char *basename;
+	const char *algname;
+	const char *drvname;
 	int err;
+	int i;
 
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
@@ -1445,13 +1138,48 @@ static int __init aesni_init(void)
 	if (err)
 		goto fpu_exit;
 
+	err = crypto_register_skciphers(aesni_skciphers,
+					ARRAY_SIZE(aesni_skciphers));
+	if (err)
+		goto unregister_algs;
+
 	err = crypto_register_aeads(aesni_aead_algs,
 				    ARRAY_SIZE(aesni_aead_algs));
 	if (err)
-		goto unregister_algs;
+		goto unregister_skciphers;
+
+	for (i = 0; i < ARRAY_SIZE(aesni_skciphers); i++) {
+		algname = aesni_skciphers[i].base.cra_name + 2;
+		drvname = aesni_skciphers[i].base.cra_driver_name + 2;
+		basename = aesni_skciphers[i].base.cra_driver_name;
+		simd = simd_skcipher_create_compat(algname, drvname, basename);
+		err = PTR_ERR(simd);
+		if (IS_ERR(simd))
+			goto unregister_simds;
+
+		aesni_simd_skciphers[i] = simd;
+	}
 
-	return err;
+	for (i = 0; i < ARRAY_SIZE(aesni_simd_skciphers2); i++) {
+		algname = aesni_simd_skciphers2[i].algname;
+		drvname = aesni_simd_skciphers2[i].drvname;
+		basename = aesni_simd_skciphers2[i].basename;
+		simd = simd_skcipher_create_compat(algname, drvname, basename);
+		err = PTR_ERR(simd);
+		if (IS_ERR(simd))
+			goto unregister_simds;
 
+		aesni_simd_skciphers2[i].simd = simd;
+	}
+
+	return 0;
+
+unregister_simds:
+	aesni_free_simds();
+	crypto_unregister_aeads(aesni_aead_algs, ARRAY_SIZE(aesni_aead_algs));
+unregister_skciphers:
+	crypto_unregister_skciphers(aesni_skciphers,
+				    ARRAY_SIZE(aesni_skciphers));
 unregister_algs:
 	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 fpu_exit:
@@ -1461,7 +1189,10 @@ static int __init aesni_init(void)
 
 static void __exit aesni_exit(void)
 {
+	aesni_free_simds();
 	crypto_unregister_aeads(aesni_aead_algs, ARRAY_SIZE(aesni_aead_algs));
+	crypto_unregister_skciphers(aesni_skciphers,
+				    ARRAY_SIZE(aesni_skciphers));
 	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 
 	crypto_fpu_exit();
diff --git a/arch/x86/crypto/fpu.c b/arch/x86/crypto/fpu.c
index e7d679e..4066804 100644
--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -11,143 +11,186 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/crypto.h>
 #include <asm/fpu/api.h>
 
 struct crypto_fpu_ctx {
-	struct crypto_blkcipher *child;
+	struct crypto_skcipher *child;
 };
 
-static int crypto_fpu_setkey(struct crypto_tfm *parent, const u8 *key,
+static int crypto_fpu_setkey(struct crypto_skcipher *parent, const u8 *key,
 			     unsigned int keylen)
 {
-	struct crypto_fpu_ctx *ctx = crypto_tfm_ctx(parent);
-	struct crypto_blkcipher *child = ctx->child;
+	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
 	int err;
 
-	crypto_blkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_blkcipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				   CRYPTO_TFM_REQ_MASK);
-	err = crypto_blkcipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_blkcipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
 	return err;
 }
 
-static int crypto_fpu_encrypt(struct blkcipher_desc *desc_in,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static int crypto_fpu_encrypt(struct skcipher_request *req)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	SKCIPHER_REQUEST_ON_STACK(subreq, child);
 	int err;
-	struct crypto_fpu_ctx *ctx = crypto_blkcipher_ctx(desc_in->tfm);
-	struct crypto_blkcipher *child = ctx->child;
-	struct blkcipher_desc desc = {
-		.tfm = child,
-		.info = desc_in->info,
-		.flags = desc_in->flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
-	};
+
+	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_callback(subreq, 0, NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+				   req->iv);
 
 	kernel_fpu_begin();
-	err = crypto_blkcipher_crt(desc.tfm)->encrypt(&desc, dst, src, nbytes);
+	err = crypto_skcipher_encrypt(subreq);
 	kernel_fpu_end();
+
+	skcipher_request_zero(subreq);
 	return err;
 }
 
-static int crypto_fpu_decrypt(struct blkcipher_desc *desc_in,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static int crypto_fpu_decrypt(struct skcipher_request *req)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	SKCIPHER_REQUEST_ON_STACK(subreq, child);
 	int err;
-	struct crypto_fpu_ctx *ctx = crypto_blkcipher_ctx(desc_in->tfm);
-	struct crypto_blkcipher *child = ctx->child;
-	struct blkcipher_desc desc = {
-		.tfm = child,
-		.info = desc_in->info,
-		.flags = desc_in->flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
-	};
+
+	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_callback(subreq, 0, NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+				   req->iv);
 
 	kernel_fpu_begin();
-	err = crypto_blkcipher_crt(desc.tfm)->decrypt(&desc, dst, src, nbytes);
+	err = crypto_skcipher_decrypt(subreq);
 	kernel_fpu_end();
+
+	skcipher_request_zero(subreq);
 	return err;
 }
 
-static int crypto_fpu_init_tfm(struct crypto_tfm *tfm)
+static int crypto_fpu_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_fpu_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_blkcipher *cipher;
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher_spawn *spawn;
+	struct crypto_skcipher *cipher;
 
-	cipher = crypto_spawn_blkcipher(spawn);
+	spawn = skcipher_instance_ctx(inst);
+	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
+
 	return 0;
 }
 
-static void crypto_fpu_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_fpu_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
+}
+
+static void crypto_fpu_free(struct skcipher_instance *inst)
 {
-	struct crypto_fpu_ctx *ctx = crypto_tfm_ctx(tfm);
-	crypto_free_blkcipher(ctx->child);
+	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	kfree(inst);
 }
 
-static struct crypto_instance *crypto_fpu_alloc(struct rtattr **tb)
+static int crypto_fpu_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct crypto_skcipher_spawn *spawn;
+	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
+	struct skcipher_alg *alg;
+	const char *cipher_name;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ (CRYPTO_ALG_INTERNAL | CRYPTO_ALG_TYPE_SKCIPHER)) &
+	    algt->mask)
+		return -EINVAL;
+
+	if (!(algt->mask & CRYPTO_ALG_INTERNAL))
+		return -EINVAL;
+
+	cipher_name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(cipher_name))
+		return PTR_ERR(cipher_name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	spawn = skcipher_instance_ctx(inst);
+
+	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher(spawn, cipher_name, CRYPTO_ALG_INTERNAL,
+				   CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
 	if (err)
-		return ERR_PTR(err);
-
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
-
-	inst = crypto_alloc_instance("fpu", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	inst->alg.cra_flags = alg->cra_flags;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = alg->cra_type;
-	inst->alg.cra_blkcipher.ivsize = alg->cra_blkcipher.ivsize;
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
-	inst->alg.cra_ctxsize = sizeof(struct crypto_fpu_ctx);
-	inst->alg.cra_init = crypto_fpu_init_tfm;
-	inst->alg.cra_exit = crypto_fpu_exit_tfm;
-	inst->alg.cra_blkcipher.setkey = crypto_fpu_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_fpu_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_fpu_decrypt;
-
-out_put_alg:
-	crypto_mod_put(alg);
-	return inst;
-}
+		goto out_free_inst;
 
-static void crypto_fpu_free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
+	alg = crypto_skcipher_spawn_alg(spawn);
+
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), "fpu",
+				  &alg->base);
+	if (err)
+		goto out_drop_skcipher;
+
+	inst->alg.base.cra_flags = CRYPTO_ALG_INTERNAL;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+
+	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_fpu_ctx);
+
+	inst->alg.init = crypto_fpu_init_tfm;
+	inst->alg.exit = crypto_fpu_exit_tfm;
+
+	inst->alg.setkey = crypto_fpu_setkey;
+	inst->alg.encrypt = crypto_fpu_encrypt;
+	inst->alg.decrypt = crypto_fpu_decrypt;
+
+	inst->free = crypto_fpu_free;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_skcipher;
+
+out:
+	return err;
+
+out_drop_skcipher:
+	crypto_drop_skcipher(spawn);
+out_free_inst:
 	kfree(inst);
+	goto out;
 }
 
 static struct crypto_template crypto_fpu_tmpl = {
 	.name = "fpu",
-	.alloc = crypto_fpu_alloc,
-	.free = crypto_fpu_free,
+	.create = crypto_fpu_create,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87a09c7..50fa56c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -942,14 +942,13 @@ config CRYPTO_AES_X86_64
 config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
 	depends on X86
+	select CRYPTO_AEAD
 	select CRYPTO_AES_X86_64 if 64BIT
 	select CRYPTO_AES_586 if !64BIT
-	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER
 	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
-	select CRYPTO_LRW
-	select CRYPTO_XTS
+	select CRYPTO_SIMD
 	help
 	  Use Intel AES-NI instructions for AES algorithm.
 
