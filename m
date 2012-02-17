From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/6] crypto: serpent-sse2 - use crypto_[un]register_algs
Date: Fri, 17 Feb 2012 22:48:37 +0200
Message-ID: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:43878 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2BQUsm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Feb 2012 15:48:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. Simplifies init/exit code and reduce object size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |  406 ++++++++++++++---------------------
 1 files changed, 163 insertions(+), 243 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index de81cf4..5520c75 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -145,28 +145,6 @@ static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ecb_crypt(desc, &walk, false);
 }
 
-static struct crypto_alg blk_ecb_alg = {
-	.cra_name		= "__ecb-serpent-sse2",
-	.cra_driver_name	= "__driver-ecb-serpent-sse2",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct serpent_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= SERPENT_MIN_KEY_SIZE,
-			.max_keysize	= SERPENT_MAX_KEY_SIZE,
-			.setkey		= serpent_setkey,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-};
-
 static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
 				  struct blkcipher_walk *walk)
 {
@@ -295,28 +273,6 @@ static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg blk_cbc_alg = {
-	.cra_name		= "__cbc-serpent-sse2",
-	.cra_driver_name	= "__driver-cbc-serpent-sse2",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct serpent_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= SERPENT_MIN_KEY_SIZE,
-			.max_keysize	= SERPENT_MAX_KEY_SIZE,
-			.setkey		= serpent_setkey,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-};
-
 static inline void u128_to_be128(be128 *dst, const u128 *src)
 {
 	dst->a = cpu_to_be64(src->a);
@@ -439,29 +395,6 @@ static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg blk_ctr_alg = {
-	.cra_name		= "__ctr-serpent-sse2",
-	.cra_driver_name	= "__driver-ctr-serpent-sse2",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct serpent_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= SERPENT_MIN_KEY_SIZE,
-			.max_keysize	= SERPENT_MAX_KEY_SIZE,
-			.ivsize		= SERPENT_BLOCK_SIZE,
-			.setkey		= serpent_setkey,
-			.encrypt	= ctr_crypt,
-			.decrypt	= ctr_crypt,
-		},
-	},
-};
-
 struct crypt_priv {
 	struct serpent_ctx *ctx;
 	bool fpu_enabled;
@@ -580,32 +513,6 @@ static void lrw_exit_tfm(struct crypto_tfm *tfm)
 	lrw_free_table(&ctx->lrw_table);
 }
 
-static struct crypto_alg blk_lrw_alg = {
-	.cra_name		= "__lrw-serpent-sse2",
-	.cra_driver_name	= "__driver-lrw-serpent-sse2",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_lrw_alg.cra_list),
-	.cra_exit		= lrw_exit_tfm,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= SERPENT_MIN_KEY_SIZE +
-					  SERPENT_BLOCK_SIZE,
-			.max_keysize	= SERPENT_MAX_KEY_SIZE +
-					  SERPENT_BLOCK_SIZE,
-			.ivsize		= SERPENT_BLOCK_SIZE,
-			.setkey		= lrw_serpent_setkey,
-			.encrypt	= lrw_encrypt,
-			.decrypt	= lrw_decrypt,
-		},
-	},
-};
-
 struct serpent_xts_ctx {
 	struct serpent_ctx tweak_ctx;
 	struct serpent_ctx crypt_ctx;
@@ -689,29 +596,6 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
-static struct crypto_alg blk_xts_alg = {
-	.cra_name		= "__xts-serpent-sse2",
-	.cra_driver_name	= "__driver-xts-serpent-sse2",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_xts_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
-			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
-			.ivsize		= SERPENT_BLOCK_SIZE,
-			.setkey		= xts_serpent_setkey,
-			.encrypt	= xts_encrypt,
-			.decrypt	= xts_decrypt,
-		},
-	},
-};
-
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
 {
@@ -813,7 +697,157 @@ static int ablk_ecb_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct crypto_alg ablk_ecb_alg = {
+static int ablk_cbc_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-cbc-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static int ablk_ctr_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ctr-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static int ablk_lrw_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-lrw-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
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
+static struct crypto_alg serpent_algs[10] = { {
+	.cra_name		= "__ecb-serpent-sse2",
+	.cra_driver_name	= "__driver-ecb-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[0].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-serpent-sse2",
+	.cra_driver_name	= "__driver-cbc-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[1].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-serpent-sse2",
+	.cra_driver_name	= "__driver-ctr-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[2].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "__lrw-serpent-sse2",
+	.cra_driver_name	= "__driver-lrw-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[3].cra_list),
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= lrw_serpent_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-serpent-sse2",
+	.cra_driver_name	= "__driver-xts-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[4].cra_list),
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
+}, {
 	.cra_name		= "ecb(serpent)",
 	.cra_driver_name	= "ecb-serpent-sse2",
 	.cra_priority		= 400,
@@ -823,7 +857,7 @@ static struct crypto_alg ablk_ecb_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_ecb_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[5].cra_list),
 	.cra_init		= ablk_ecb_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -835,20 +869,7 @@ static struct crypto_alg ablk_ecb_alg = {
 			.decrypt	= ablk_decrypt,
 		},
 	},
-};
-
-static int ablk_cbc_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-cbc-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static struct crypto_alg ablk_cbc_alg = {
+}, {
 	.cra_name		= "cbc(serpent)",
 	.cra_driver_name	= "cbc-serpent-sse2",
 	.cra_priority		= 400,
@@ -858,7 +879,7 @@ static struct crypto_alg ablk_cbc_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_cbc_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[6].cra_list),
 	.cra_init		= ablk_cbc_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -871,20 +892,7 @@ static struct crypto_alg ablk_cbc_alg = {
 			.decrypt	= ablk_decrypt,
 		},
 	},
-};
-
-static int ablk_ctr_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ctr-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static struct crypto_alg ablk_ctr_alg = {
+}, {
 	.cra_name		= "ctr(serpent)",
 	.cra_driver_name	= "ctr-serpent-sse2",
 	.cra_priority		= 400,
@@ -894,7 +902,7 @@ static struct crypto_alg ablk_ctr_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_ctr_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[7].cra_list),
 	.cra_init		= ablk_ctr_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -908,20 +916,7 @@ static struct crypto_alg ablk_ctr_alg = {
 			.geniv		= "chainiv",
 		},
 	},
-};
-
-static int ablk_lrw_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-lrw-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static struct crypto_alg ablk_lrw_alg = {
+}, {
 	.cra_name		= "lrw(serpent)",
 	.cra_driver_name	= "lrw-serpent-sse2",
 	.cra_priority		= 400,
@@ -931,7 +926,7 @@ static struct crypto_alg ablk_lrw_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_lrw_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[8].cra_list),
 	.cra_init		= ablk_lrw_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -946,20 +941,7 @@ static struct crypto_alg ablk_lrw_alg = {
 			.decrypt	= ablk_decrypt,
 		},
 	},
-};
-
-static int ablk_xts_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-xts-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static struct crypto_alg ablk_xts_alg = {
+}, {
 	.cra_name		= "xts(serpent)",
 	.cra_driver_name	= "xts-serpent-sse2",
 	.cra_priority		= 400,
@@ -969,7 +951,7 @@ static struct crypto_alg ablk_xts_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_xts_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[9].cra_list),
 	.cra_init		= ablk_xts_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -982,83 +964,21 @@ static struct crypto_alg ablk_xts_alg = {
 			.decrypt	= ablk_decrypt,
 		},
 	},
-};
+} };
 
 static int __init serpent_sse2_init(void)
 {
-	int err;
-
 	if (!cpu_has_xmm2) {
 		printk(KERN_INFO "SSE2 instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	err = crypto_register_alg(&blk_ecb_alg);
-	if (err)
-		goto blk_ecb_err;
-	err = crypto_register_alg(&blk_cbc_alg);
-	if (err)
-		goto blk_cbc_err;
-	err = crypto_register_alg(&blk_ctr_alg);
-	if (err)
-		goto blk_ctr_err;
-	err = crypto_register_alg(&ablk_ecb_alg);
-	if (err)
-		goto ablk_ecb_err;
-	err = crypto_register_alg(&ablk_cbc_alg);
-	if (err)
-		goto ablk_cbc_err;
-	err = crypto_register_alg(&ablk_ctr_alg);
-	if (err)
-		goto ablk_ctr_err;
-	err = crypto_register_alg(&blk_lrw_alg);
-	if (err)
-		goto blk_lrw_err;
-	err = crypto_register_alg(&ablk_lrw_alg);
-	if (err)
-		goto ablk_lrw_err;
-	err = crypto_register_alg(&blk_xts_alg);
-	if (err)
-		goto blk_xts_err;
-	err = crypto_register_alg(&ablk_xts_alg);
-	if (err)
-		goto ablk_xts_err;
-	return err;
-
-ablk_xts_err:
-	crypto_unregister_alg(&blk_xts_alg);
-blk_xts_err:
-	crypto_unregister_alg(&ablk_lrw_alg);
-ablk_lrw_err:
-	crypto_unregister_alg(&blk_lrw_alg);
-blk_lrw_err:
-	crypto_unregister_alg(&ablk_ctr_alg);
-ablk_ctr_err:
-	crypto_unregister_alg(&ablk_cbc_alg);
-ablk_cbc_err:
-	crypto_unregister_alg(&ablk_ecb_alg);
-ablk_ecb_err:
-	crypto_unregister_alg(&blk_ctr_alg);
-blk_ctr_err:
-	crypto_unregister_alg(&blk_cbc_alg);
-blk_cbc_err:
-	crypto_unregister_alg(&blk_ecb_alg);
-blk_ecb_err:
-	return err;
+	return crypto_register_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
 }
 
 static void __exit serpent_sse2_exit(void)
 {
-	crypto_unregister_alg(&ablk_xts_alg);
-	crypto_unregister_alg(&blk_xts_alg);
-	crypto_unregister_alg(&ablk_lrw_alg);
-	crypto_unregister_alg(&blk_lrw_alg);
-	crypto_unregister_alg(&ablk_ctr_alg);
-	crypto_unregister_alg(&ablk_cbc_alg);
-	crypto_unregister_alg(&ablk_ecb_alg);
-	crypto_unregister_alg(&blk_ctr_alg);
-	crypto_unregister_alg(&blk_cbc_alg);
-	crypto_unregister_alg(&blk_ecb_alg);
+	crypto_unregister_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
 }
 
 module_init(serpent_sse2_init);
