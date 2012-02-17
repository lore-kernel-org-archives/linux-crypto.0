From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/6] crypto: twofish-x86_64-3way - use crypto_[un]register_algs
Date: Fri, 17 Feb 2012 22:48:43 +0200
Message-ID: <20120217204843.3744.7763.stgit@localhost6.localdomain6>
References: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34729 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2BQUsq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Feb 2012 15:48:46 -0500
In-Reply-To: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. Simplifies init/exit code and reduce object size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |  219 ++++++++++++++---------------------
 1 files changed, 89 insertions(+), 130 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 2c7f14e..408fc0c 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -123,28 +123,6 @@ static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ecb_crypt(desc, &walk, twofish_dec_blk, twofish_dec_blk_3way);
 }
 
-static struct crypto_alg blk_ecb_alg = {
-	.cra_name		= "ecb(twofish)",
-	.cra_driver_name	= "ecb-twofish-3way",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct twofish_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= TF_MIN_KEY_SIZE,
-			.max_keysize	= TF_MAX_KEY_SIZE,
-			.setkey		= twofish_setkey,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-};
-
 static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
 				  struct blkcipher_walk *walk)
 {
@@ -268,29 +246,6 @@ static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg blk_cbc_alg = {
-	.cra_name		= "cbc(twofish)",
-	.cra_driver_name	= "cbc-twofish-3way",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct twofish_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= TF_MIN_KEY_SIZE,
-			.max_keysize	= TF_MAX_KEY_SIZE,
-			.ivsize		= TF_BLOCK_SIZE,
-			.setkey		= twofish_setkey,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-};
-
 static inline void u128_to_be128(be128 *dst, const u128 *src)
 {
 	dst->a = cpu_to_be64(src->a);
@@ -412,29 +367,6 @@ static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg blk_ctr_alg = {
-	.cra_name		= "ctr(twofish)",
-	.cra_driver_name	= "ctr-twofish-3way",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct twofish_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= TF_MIN_KEY_SIZE,
-			.max_keysize	= TF_MAX_KEY_SIZE,
-			.ivsize		= TF_BLOCK_SIZE,
-			.setkey		= twofish_setkey,
-			.encrypt	= ctr_crypt,
-			.decrypt	= ctr_crypt,
-		},
-	},
-};
-
 static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 {
 	const unsigned int bsize = TF_BLOCK_SIZE;
@@ -525,30 +457,6 @@ static void lrw_exit_tfm(struct crypto_tfm *tfm)
 	lrw_free_table(&ctx->lrw_table);
 }
 
-static struct crypto_alg blk_lrw_alg = {
-	.cra_name		= "lrw(twofish)",
-	.cra_driver_name	= "lrw-twofish-3way",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct twofish_lrw_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_lrw_alg.cra_list),
-	.cra_exit		= lrw_exit_tfm,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= TF_MIN_KEY_SIZE + TF_BLOCK_SIZE,
-			.max_keysize	= TF_MAX_KEY_SIZE + TF_BLOCK_SIZE,
-			.ivsize		= TF_BLOCK_SIZE,
-			.setkey		= lrw_twofish_setkey,
-			.encrypt	= lrw_encrypt,
-			.decrypt	= lrw_decrypt,
-		},
-	},
-};
-
 struct twofish_xts_ctx {
 	struct twofish_ctx tweak_ctx;
 	struct twofish_ctx crypt_ctx;
@@ -615,7 +523,91 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return xts_crypt(desc, dst, src, nbytes, &req);
 }
 
-static struct crypto_alg blk_xts_alg = {
+static struct crypto_alg tf_algs[5] = { {
+	.cra_name		= "ecb(twofish)",
+	.cra_driver_name	= "ecb-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(tf_algs[0].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(twofish)",
+	.cra_driver_name	= "cbc-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(tf_algs[1].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(twofish)",
+	.cra_driver_name	= "ctr-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(tf_algs[2].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "lrw(twofish)",
+	.cra_driver_name	= "lrw-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(tf_algs[3].cra_list),
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE + TF_BLOCK_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE + TF_BLOCK_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= lrw_twofish_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
 	.cra_name		= "xts(twofish)",
 	.cra_driver_name	= "xts-twofish-3way",
 	.cra_priority		= 300,
@@ -625,7 +617,7 @@ static struct crypto_alg blk_xts_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_xts_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(tf_algs[4].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE * 2,
@@ -636,7 +628,7 @@ static struct crypto_alg blk_xts_alg = {
 			.decrypt	= xts_decrypt,
 		},
 	},
-};
+} };
 
 static bool is_blacklisted_cpu(void)
 {
@@ -678,8 +670,6 @@ MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
 
 int __init init(void)
 {
-	int err;
-
 	if (!force && is_blacklisted_cpu()) {
 		printk(KERN_INFO
 			"twofish-x86_64-3way: performance on this CPU "
@@ -688,43 +678,12 @@ int __init init(void)
 		return -ENODEV;
 	}
 
-	err = crypto_register_alg(&blk_ecb_alg);
-	if (err)
-		goto ecb_err;
-	err = crypto_register_alg(&blk_cbc_alg);
-	if (err)
-		goto cbc_err;
-	err = crypto_register_alg(&blk_ctr_alg);
-	if (err)
-		goto ctr_err;
-	err = crypto_register_alg(&blk_lrw_alg);
-	if (err)
-		goto blk_lrw_err;
-	err = crypto_register_alg(&blk_xts_alg);
-	if (err)
-		goto blk_xts_err;
-
-	return 0;
-
-blk_xts_err:
-	crypto_unregister_alg(&blk_lrw_alg);
-blk_lrw_err:
-	crypto_unregister_alg(&blk_ctr_alg);
-ctr_err:
-	crypto_unregister_alg(&blk_cbc_alg);
-cbc_err:
-	crypto_unregister_alg(&blk_ecb_alg);
-ecb_err:
-	return err;
+	return crypto_register_algs(tf_algs, ARRAY_SIZE(tf_algs));
 }
 
 void __exit fini(void)
 {
-	crypto_unregister_alg(&blk_xts_alg);
-	crypto_unregister_alg(&blk_lrw_alg);
-	crypto_unregister_alg(&blk_ctr_alg);
-	crypto_unregister_alg(&blk_cbc_alg);
-	crypto_unregister_alg(&blk_ecb_alg);
+	crypto_unregister_algs(tf_algs, ARRAY_SIZE(tf_algs));
 }
 
 module_init(init);
