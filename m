From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 15/18] crypto: serpent-sse2: add xts support
Date: Tue, 18 Oct 2011 13:33:28 +0300
Message-ID: <20111018103327.3074.52385.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43592 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKdc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:32 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds XTS support for serpent-sse2 by using xts_crypt(). Patch has been
tested with tcrypt and automated filesystem tests.

Tcrypt benchmarks results (serpent-sse2/serpent_generic speed ratios):

Intel Celeron T1600 (x86_64) (fam:6, model:15, step:13):

size    xts-enc xts-dec
16B     0.98x   1.00x
64B     1.00x   1.01x
256B    2.78x   2.75x
1024B   3.30x   3.26x
8192B   3.39x   3.30x

AMD Phenom II 1055T (x86_64) (fam:16, model:10):

size    xts-enc xts-dec
16B     1.05x   1.02x
64B     1.04x   1.03x
256B    2.10x   2.05x
1024B   2.34x   2.35x
8192B   2.34x   2.40x

Intel Atom N270 (i586):

size    xts-enc xts-dec
16B     0.95x   0.96x
64B     1.53x   1.50x
256B    1.72x   1.75x
1024B   1.88x   1.87x
8192B   1.86x   1.83x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |  180 +++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 97c55b6..2ad7ed8 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -39,6 +39,7 @@
 #include <crypto/b128ops.h>
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
+#include <crypto/xts.h>
 #include <asm/i387.h>
 #include <asm/serpent.h>
 #include <crypto/scatterwalk.h>
@@ -49,6 +50,10 @@
 #define HAS_LRW
 #endif
 
+#if defined(CONFIG_CRYPTO_XTS) || defined(CONFIG_CRYPTO_XTS_MODULE)
+#define HAS_XTS
+#endif
+
 struct async_serpent_ctx {
 	struct cryptd_ablkcipher *cryptd_tfm;
 };
@@ -464,7 +469,7 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
-#ifdef HAS_LRW
+#if defined(HAS_LRW) || defined(HAS_XTS)
 
 struct crypt_priv {
 	struct serpent_ctx *ctx;
@@ -505,6 +510,10 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		__serpent_decrypt(ctx->ctx, srcdst, srcdst);
 }
 
+#endif
+
+#ifdef HAS_LRW
+
 struct serpent_lrw_ctx {
 	struct lrw_table_ctx lrw_table;
 	struct serpent_ctx serpent_ctx;
@@ -610,6 +619,114 @@ static struct crypto_alg blk_lrw_alg = {
 
 #endif
 
+#ifdef HAS_XTS
+
+struct serpent_xts_ctx {
+	struct serpent_ctx tweak_ctx;
+	struct serpent_ctx crypt_ctx;
+};
+
+static int xts_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct serpent_xts_ctx *ctx = crypto_tfm_ctx(tfm);
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
+	err = __serpent_setkey(&ctx->crypt_ctx, key, keylen / 2);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return __serpent_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(__serpent_encrypt),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(__serpent_encrypt),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static struct crypto_alg blk_xts_alg = {
+	.cra_name		= "__xts-serpent-sse2",
+	.cra_driver_name	= "__driver-xts-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_xts_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= xts_serpent_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+};
+
+#endif
+
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
 {
@@ -850,6 +967,46 @@ static struct crypto_alg ablk_lrw_alg = {
 
 #endif
 
+#ifdef HAS_XTS
+
+static int ablk_xts_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-xts-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_xts_alg = {
+	.cra_name		= "xts(serpent)",
+	.cra_driver_name	= "xts-serpent-sse2",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ablk_xts_alg.cra_list),
+	.cra_init		= ablk_xts_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+};
+
+#endif
+
 static int __init serpent_sse2_init(void)
 {
 	int err;
@@ -885,14 +1042,29 @@ static int __init serpent_sse2_init(void)
 	if (err)
 		goto ablk_lrw_err;
 #endif
+#ifdef HAS_XTS
+	err = crypto_register_alg(&blk_xts_alg);
+	if (err)
+		goto blk_xts_err;
+	err = crypto_register_alg(&ablk_xts_alg);
+	if (err)
+		goto ablk_xts_err;
+#endif
 	return err;
 
+#ifdef HAS_XTS
+	crypto_unregister_alg(&ablk_xts_alg);
+ablk_xts_err:
+	crypto_unregister_alg(&blk_xts_alg);
+blk_xts_err:
+#endif
 #ifdef HAS_LRW
+	crypto_unregister_alg(&ablk_lrw_alg);
 ablk_lrw_err:
 	crypto_unregister_alg(&blk_lrw_alg);
 blk_lrw_err:
-	crypto_unregister_alg(&ablk_ctr_alg);
 #endif
+	crypto_unregister_alg(&ablk_ctr_alg);
 ablk_ctr_err:
 	crypto_unregister_alg(&ablk_cbc_alg);
 ablk_cbc_err:
@@ -909,6 +1081,10 @@ blk_ecb_err:
 
 static void __exit serpent_sse2_exit(void)
 {
+#ifdef HAS_XTS
+	crypto_unregister_alg(&ablk_xts_alg);
+	crypto_unregister_alg(&blk_xts_alg);
+#endif
 #ifdef HAS_LRW
 	crypto_unregister_alg(&ablk_lrw_alg);
 	crypto_unregister_alg(&blk_lrw_alg);
