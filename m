From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/6] crypto: blowfish-x86_64 - use crypto_[un]register_algs
Date: Fri, 17 Feb 2012 22:48:48 +0200
Message-ID: <20120217204848.3744.45044.stgit@localhost6.localdomain6>
References: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:43903 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2BQUsv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Feb 2012 15:48:51 -0500
In-Reply-To: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. Simplifies init/exit code and reduce object size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/blowfish_glue.c |  163 ++++++++++++++++-----------------------
 1 files changed, 65 insertions(+), 98 deletions(-)

diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 2970110..73bc8a9 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -77,27 +77,6 @@ static void blowfish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	blowfish_dec_blk(crypto_tfm_ctx(tfm), dst, src);
 }
 
-static struct crypto_alg bf_alg = {
-	.cra_name		=	"blowfish",
-	.cra_driver_name	=	"blowfish-asm",
-	.cra_priority		=	200,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	BF_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct bf_ctx),
-	.cra_alignmask		=	3,
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(bf_alg.cra_list),
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	BF_MIN_KEY_SIZE,
-			.cia_max_keysize	=	BF_MAX_KEY_SIZE,
-			.cia_setkey		=	blowfish_setkey,
-			.cia_encrypt		=	blowfish_encrypt,
-			.cia_decrypt		=	blowfish_decrypt,
-		}
-	}
-};
-
 static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 		     void (*fn)(struct bf_ctx *, u8 *, const u8 *),
 		     void (*fn_4way)(struct bf_ctx *, u8 *, const u8 *))
@@ -161,28 +140,6 @@ static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ecb_crypt(desc, &walk, blowfish_dec_blk, blowfish_dec_blk_4way);
 }
 
-static struct crypto_alg blk_ecb_alg = {
-	.cra_name		= "ecb(blowfish)",
-	.cra_driver_name	= "ecb-blowfish-asm",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= BF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct bf_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= BF_MIN_KEY_SIZE,
-			.max_keysize	= BF_MAX_KEY_SIZE,
-			.setkey		= blowfish_setkey,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-};
-
 static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
 				  struct blkcipher_walk *walk)
 {
@@ -308,29 +265,6 @@ static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg blk_cbc_alg = {
-	.cra_name		= "cbc(blowfish)",
-	.cra_driver_name	= "cbc-blowfish-asm",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= BF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct bf_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= BF_MIN_KEY_SIZE,
-			.max_keysize	= BF_MAX_KEY_SIZE,
-			.ivsize		= BF_BLOCK_SIZE,
-			.setkey		= blowfish_setkey,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-};
-
 static void ctr_crypt_final(struct bf_ctx *ctx, struct blkcipher_walk *walk)
 {
 	u8 *ctrblk = walk->iv;
@@ -424,7 +358,67 @@ static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg blk_ctr_alg = {
+static struct crypto_alg bf_algs[4] = { {
+	.cra_name		= "blowfish",
+	.cra_driver_name	= "blowfish-asm",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct bf_ctx),
+	.cra_alignmask		= 3,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(bf_algs[0].cra_list),
+	.cra_u = {
+		.cipher = {
+			.cia_min_keysize	= BF_MIN_KEY_SIZE,
+			.cia_max_keysize	= BF_MAX_KEY_SIZE,
+			.cia_setkey		= blowfish_setkey,
+			.cia_encrypt		= blowfish_encrypt,
+			.cia_decrypt		= blowfish_decrypt,
+		}
+	}
+}, {
+	.cra_name		= "ecb(blowfish)",
+	.cra_driver_name	= "ecb-blowfish-asm",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct bf_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(bf_algs[1].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= BF_MIN_KEY_SIZE,
+			.max_keysize	= BF_MAX_KEY_SIZE,
+			.setkey		= blowfish_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(blowfish)",
+	.cra_driver_name	= "cbc-blowfish-asm",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct bf_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(bf_algs[2].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= BF_MIN_KEY_SIZE,
+			.max_keysize	= BF_MAX_KEY_SIZE,
+			.ivsize		= BF_BLOCK_SIZE,
+			.setkey		= blowfish_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
 	.cra_name		= "ctr(blowfish)",
 	.cra_driver_name	= "ctr-blowfish-asm",
 	.cra_priority		= 300,
@@ -434,7 +428,7 @@ static struct crypto_alg blk_ctr_alg = {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
+	.cra_list		= LIST_HEAD_INIT(bf_algs[3].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= BF_MIN_KEY_SIZE,
@@ -445,7 +439,7 @@ static struct crypto_alg blk_ctr_alg = {
 			.decrypt	= ctr_crypt,
 		},
 	},
-};
+} };
 
 static bool is_blacklisted_cpu(void)
 {
@@ -470,8 +464,6 @@ MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
 
 static int __init init(void)
 {
-	int err;
-
 	if (!force && is_blacklisted_cpu()) {
 		printk(KERN_INFO
 			"blowfish-x86_64: performance on this CPU "
@@ -480,37 +472,12 @@ static int __init init(void)
 		return -ENODEV;
 	}
 
-	err = crypto_register_alg(&bf_alg);
-	if (err)
-		goto bf_err;
-	err = crypto_register_alg(&blk_ecb_alg);
-	if (err)
-		goto ecb_err;
-	err = crypto_register_alg(&blk_cbc_alg);
-	if (err)
-		goto cbc_err;
-	err = crypto_register_alg(&blk_ctr_alg);
-	if (err)
-		goto ctr_err;
-
-	return 0;
-
-ctr_err:
-	crypto_unregister_alg(&blk_cbc_alg);
-cbc_err:
-	crypto_unregister_alg(&blk_ecb_alg);
-ecb_err:
-	crypto_unregister_alg(&bf_alg);
-bf_err:
-	return err;
+	return crypto_register_algs(bf_algs, ARRAY_SIZE(bf_algs));
 }
 
 static void __exit fini(void)
 {
-	crypto_unregister_alg(&blk_ctr_alg);
-	crypto_unregister_alg(&blk_cbc_alg);
-	crypto_unregister_alg(&blk_ecb_alg);
-	crypto_unregister_alg(&bf_alg);
+	crypto_unregister_algs(bf_algs, ARRAY_SIZE(bf_algs));
 }
 
 module_init(init);
