From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 18/18] crypto: twofish-x86_64-3way: add xts support
Date: Tue, 18 Oct 2011 13:33:43 +0300
Message-ID: <20111018103343.3074.11526.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:39634 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKeD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:34:03 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds XTS support for twofish-x86_64-3way by using xts_crypt(). Patch has
been tested with tcrypt and automated filesystem tests.

Tcrypt benchmarks results (twofish-3way/twofish-asm speed ratios):

Intel Celeron T1600 (fam:6, model:15, step:13):

size    xts-enc xts-dec
16B     0.98x   1.00x
64B     1.14x   1.15x
256B    1.23x   1.25x
1024B   1.26x   1.29x
8192B   1.28x   1.30x

AMD Phenom II 1055T (fam:16, model:10):

size    xts-enc xts-dec
16B     1.03x   1.03x
64B     1.13x   1.16x
256B    1.20x   1.20x
1024B   1.22x   1.22x
8192B   1.22x   1.21x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |  119 ++++++++++++++++++++++++++++++++++-
 1 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index fa9151d..954f59e 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -33,11 +33,16 @@
 #include <crypto/twofish.h>
 #include <crypto/b128ops.h>
 #include <crypto/lrw.h>
+#include <crypto/xts.h>
 
 #if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
 #define HAS_LRW
 #endif
 
+#if defined(CONFIG_CRYPTO_XTS) || defined(CONFIG_CRYPTO_XTS_MODULE)
+#define HAS_XTS
+#endif
+
 /* regular block cipher functions from twofish_x86_64 module */
 asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
 				const u8 *src);
@@ -437,7 +442,7 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
-#ifdef HAS_LRW
+#if defined(HAS_LRW) || defined(HAS_XTS)
 
 static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 {
@@ -469,6 +474,10 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		twofish_dec_blk(ctx, srcdst, srcdst);
 }
 
+#endif
+
+#ifdef HAS_LRW
+
 struct twofish_lrw_ctx {
 	struct lrw_table_ctx lrw_table;
 	struct twofish_ctx twofish_ctx;
@@ -555,6 +564,99 @@ static struct crypto_alg blk_lrw_alg = {
 
 #endif
 
+#ifdef HAS_XTS
+
+struct twofish_xts_ctx {
+	struct twofish_ctx tweak_ctx;
+	struct twofish_ctx crypt_ctx;
+};
+
+static int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct twofish_xts_ctx *ctx = crypto_tfm_ctx(tfm);
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
+	err = __twofish_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return __twofish_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
+				flags);
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[3];
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(twofish_enc_blk),
+		.crypt_ctx = &ctx->crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+
+	return xts_crypt(desc, dst, src, nbytes, &req);
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[3];
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(twofish_enc_blk),
+		.crypt_ctx = &ctx->crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+
+	return xts_crypt(desc, dst, src, nbytes, &req);
+}
+
+static struct crypto_alg blk_xts_alg = {
+	.cra_name		= "xts(twofish)",
+	.cra_driver_name	= "xts-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_xts_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE * 2,
+			.max_keysize	= TF_MAX_KEY_SIZE * 2,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= xts_twofish_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+};
+
+#endif
+
 int __init init(void)
 {
 	int err;
@@ -573,13 +675,23 @@ int __init init(void)
 	if (err)
 		goto blk_lrw_err;
 #endif
+#ifdef HAS_XTS
+	err = crypto_register_alg(&blk_xts_alg);
+	if (err)
+		goto blk_xts_err;
+#endif
 
 	return 0;
 
+#ifdef HAS_XTS
+	crypto_unregister_alg(&blk_xts_alg);
+blk_xts_err:
+#endif
 #ifdef HAS_LRW
+	crypto_unregister_alg(&blk_lrw_alg);
 blk_lrw_err:
-	crypto_unregister_alg(&blk_ctr_alg);
 #endif
+	crypto_unregister_alg(&blk_ctr_alg);
 ctr_err:
 	crypto_unregister_alg(&blk_cbc_alg);
 cbc_err:
@@ -590,6 +702,9 @@ ecb_err:
 
 void __exit fini(void)
 {
+#ifdef HAS_XTS
+	crypto_unregister_alg(&blk_xts_alg);
+#endif
 #ifdef HAS_LRW
 	crypto_unregister_alg(&blk_lrw_alg);
 #endif
