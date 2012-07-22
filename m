From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: aesni_intel - improve lrw and xts performance by
 utilizing parallel AES-NI hardware pipelines
Date: Sun, 22 Jul 2012 18:18:37 +0300
Message-ID: <20120722151837.28864.2550.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:54284 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2GVPSl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Jul 2012 11:18:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use parallel LRW and XTS encryption facilities to better utilize AES-NI
hardware pipelines and gain extra performance.

Tcrypt benchmark results (async), old vs new ratios:

Intel Core i5-2450M CPU (fam: 6, model: 42, step: 7)

aes:128bit
        lrw:256bit      xts:256bit
size    lrw-enc lrw-dec xts-dec xts-dec
16B     0.99x   1.00x   1.22x   1.19x
64B     1.38x   1.50x   1.58x   1.61x
256B    2.04x   2.02x   2.27x   2.29x
1024B   2.56x   2.54x   2.89x   2.92x
8192B   2.85x   2.99x   3.40x   3.23x

aes:192bit
        lrw:320bit      xts:384bit
size    lrw-enc lrw-dec xts-dec xts-dec
16B     1.08x   1.08x   1.16x   1.17x
64B     1.48x   1.54x   1.59x   1.65x
256B    2.18x   2.17x   2.29x   2.28x
1024B   2.67x   2.67x   2.87x   3.05x
8192B   2.93x   2.84x   3.28x   3.33x

aes:256bit
        lrw:348bit      xts:512bit
size    lrw-enc lrw-dec xts-dec xts-dec
16B     1.07x   1.07x   1.18x   1.19x
64B     1.56x   1.56x   1.70x   1.71x
256B    2.22x   2.24x   2.46x   2.46x
1024B   2.76x   2.77x   3.13x   3.05x
8192B   2.99x   3.05x   3.40x   3.30x

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aesni-intel_glue.c |  253 +++++++++++++++++++++++++++++++-----
 crypto/Kconfig                     |    2 
 2 files changed, 220 insertions(+), 35 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 648347a..7c04d0d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -28,6 +28,9 @@
 #include <crypto/aes.h>
 #include <crypto/cryptd.h>
 #include <crypto/ctr.h>
+#include <crypto/b128ops.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
 #include <asm/cpu_device_id.h>
 #include <asm/i387.h>
 #include <asm/crypto/aes.h>
@@ -41,18 +44,10 @@
 #define HAS_CTR
 #endif
 
-#if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
-#define HAS_LRW
-#endif
-
 #if defined(CONFIG_CRYPTO_PCBC) || defined(CONFIG_CRYPTO_PCBC_MODULE)
 #define HAS_PCBC
 #endif
 
-#if defined(CONFIG_CRYPTO_XTS) || defined(CONFIG_CRYPTO_XTS_MODULE)
-#define HAS_XTS
-#endif
-
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
@@ -79,6 +74,16 @@ struct aesni_hash_subkey_req_data {
 #define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
 #define RFC4106_HASH_SUBKEY_SIZE 16
 
+struct aesni_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	u8 raw_aes_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
+};
+
+struct aesni_xts_ctx {
+	u8 raw_tweak_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
+	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
+};
+
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
 asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
@@ -398,13 +403,6 @@ static int ablk_rfc3686_ctr_init(struct crypto_tfm *tfm)
 #endif
 #endif
 
-#ifdef HAS_LRW
-static int ablk_lrw_init(struct crypto_tfm *tfm)
-{
-	return ablk_init_common(tfm, "fpu(lrw(__driver-aes-aesni))");
-}
-#endif
-
 #ifdef HAS_PCBC
 static int ablk_pcbc_init(struct crypto_tfm *tfm)
 {
@@ -412,12 +410,160 @@ static int ablk_pcbc_init(struct crypto_tfm *tfm)
 }
 #endif
 
-#ifdef HAS_XTS
-static int ablk_xts_init(struct crypto_tfm *tfm)
+static void lrw_xts_encrypt_callback(void *ctx, u8 *blks, unsigned int nbytes)
 {
-	return ablk_init_common(tfm, "fpu(xts(__driver-aes-aesni))");
+	aesni_ecb_enc(ctx, blks, blks, nbytes);
+}
+
+static void lrw_xts_decrypt_callback(void *ctx, u8 *blks, unsigned int nbytes)
+{
+	aesni_ecb_dec(ctx, blks, blks, nbytes);
+}
+
+static int lrw_aesni_setkey(struct crypto_tfm *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct aesni_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
+
+	err = aes_set_key_common(tfm, ctx->raw_aes_ctx, key,
+				 keylen - AES_BLOCK_SIZE);
+	if (err)
+		return err;
+
+	return lrw_init_table(&ctx->lrw_table, key + keylen - AES_BLOCK_SIZE);
+}
+
+static void lrw_aesni_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct aesni_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	lrw_free_table(&ctx->lrw_table);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct aesni_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[8];
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = aes_ctx(ctx->raw_aes_ctx),
+		.crypt_fn = lrw_xts_encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	kernel_fpu_begin();
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	kernel_fpu_end();
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct aesni_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[8];
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = aes_ctx(ctx->raw_aes_ctx),
+		.crypt_fn = lrw_xts_decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	kernel_fpu_begin();
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	kernel_fpu_end();
+
+	return ret;
+}
+
+static int xts_aesni_setkey(struct crypto_tfm *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct aesni_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+	int err;
+
+	/* key consists of keys of equal size concatenated, therefore
+	 * the length must be even
+	 */
+	if (keylen % 2) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	/* first half of xts-key is for crypt */
+	err = aes_set_key_common(tfm, ctx->raw_crypt_ctx, key, keylen / 2);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return aes_set_key_common(tfm, ctx->raw_tweak_ctx, key + keylen / 2,
+				  keylen / 2);
+}
+
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[8];
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = aes_ctx(ctx->raw_tweak_ctx),
+		.tweak_fn = XTS_TWEAK_CAST(aesni_enc),
+		.crypt_ctx = aes_ctx(ctx->raw_crypt_ctx),
+		.crypt_fn = lrw_xts_encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	kernel_fpu_begin();
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	kernel_fpu_end();
+
+	return ret;
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[8];
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = aes_ctx(ctx->raw_tweak_ctx),
+		.tweak_fn = XTS_TWEAK_CAST(aesni_enc),
+		.crypt_ctx = aes_ctx(ctx->raw_crypt_ctx),
+		.crypt_fn = lrw_xts_decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	kernel_fpu_begin();
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	kernel_fpu_end();
+
+	return ret;
 }
-#endif
 
 #ifdef CONFIG_X86_64
 static int rfc4106_init(struct crypto_tfm *tfm)
@@ -1035,10 +1181,10 @@ static struct crypto_alg aesni_algs[] = { {
 	},
 #endif
 #endif
-#ifdef HAS_LRW
+#ifdef HAS_PCBC
 }, {
-	.cra_name		= "lrw(aes)",
-	.cra_driver_name	= "lrw-aes-aesni",
+	.cra_name		= "pcbc(aes)",
+	.cra_driver_name	= "pcbc-aes-aesni",
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
@@ -1046,12 +1192,12 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_lrw_init,
+	.cra_init		= ablk_pcbc_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
 			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= ablk_set_key,
 			.encrypt	= ablk_encrypt,
@@ -1059,10 +1205,50 @@ static struct crypto_alg aesni_algs[] = { {
 		},
 	},
 #endif
-#ifdef HAS_PCBC
 }, {
-	.cra_name		= "pcbc(aes)",
-	.cra_driver_name	= "pcbc-aes-aesni",
+	.cra_name		= "__lrw-aes-aesni",
+	.cra_driver_name	= "__driver-lrw-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct aesni_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_exit		= lrw_aesni_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= lrw_aesni_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-aes-aesni",
+	.cra_driver_name	= "__driver-xts-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct aesni_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+			.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= xts_aesni_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "lrw(aes)",
+	.cra_driver_name	= "lrw-aes-aesni",
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
@@ -1070,20 +1256,18 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_pcbc_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
+			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
 			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= ablk_set_key,
 			.encrypt	= ablk_encrypt,
 			.decrypt	= ablk_decrypt,
 		},
 	},
-#endif
-#ifdef HAS_XTS
 }, {
 	.cra_name		= "xts(aes)",
 	.cra_driver_name	= "xts-aes-aesni",
@@ -1094,7 +1278,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_init		= ablk_xts_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
@@ -1106,7 +1290,6 @@ static struct crypto_alg aesni_algs[] = { {
 			.decrypt	= ablk_decrypt,
 		},
 	},
-#endif
 } };
 
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a323805..e376d70 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -564,6 +564,8 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_ALGAPI
+	select CRYPTO_LRW
+	select CRYPTO_XTS
 	help
 	  Use Intel AES-NI instructions for AES algorithm.
 
