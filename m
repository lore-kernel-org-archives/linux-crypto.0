From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag.
Date: Sun, 11 Dec 2011 13:26:26 +0100
Message-ID: <4EE4A172.9010308@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40481 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1LKMXl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Dec 2011 07:23:41 -0500
Received: by eekc4 with SMTP id c4so1154707eek.19
        for <linux-crypto@vger.kernel.org>; Sun, 11 Dec 2011 04:23:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The added CRYPTO_ALG_KERN_DRIVER_ONLY flag indicates whether a cipher
is only available via a kernel driver. If the cipher implementation
might be available by using an instruction set or by porting the
kernel code, then it must not be set.

Signed-off-by: Nikos Mavrogiannopoulos <nmav@gnutls.org>
---
 drivers/crypto/geode-aes.c        |    8 ++++--
 drivers/crypto/hifn_795x.c        |    3 +-
 drivers/crypto/ixp4xx_crypto.c    |    2 +
 drivers/crypto/mv_cesa.c          |   12 ++++++---
 drivers/crypto/n2_core.c          |    7 ++++-
 drivers/crypto/omap-aes.c         |    8 ++++-
 drivers/crypto/omap-sham.c        |    4 +++
 drivers/crypto/picoxcell_crypto.c |   46 +++++++++++++++++++++++++++--------
 drivers/crypto/s5p-sss.c          |    6 +++-
 drivers/crypto/talitos.c          |   48 ++++++++++++++++++++++++++----------
 include/linux/crypto.h            |    5 ++++
 11 files changed, 110 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 219d09c..8b0ef70 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -392,8 +392,9 @@ static struct crypto_alg geode_cbc_alg = {
 	.cra_name		=	"cbc(aes)",
 	.cra_driver_name	=	"cbc-aes-geode",
 	.cra_priority		=	400,
-	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
+	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=	fallback_init_blk,
 	.cra_exit			=	fallback_exit_blk,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
@@ -479,7 +480,8 @@ static struct crypto_alg geode_ecb_alg = {
 	.cra_driver_name	=	"ecb-aes-geode",
 	.cra_priority		=	400,
 	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=	fallback_init_blk,
 	.cra_exit			=	fallback_exit_blk,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index fe765f4..14780c8 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2494,7 +2494,8 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 		 t->drv_name, dev->name);
 
 	alg->alg.cra_priority = 300;
-	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC;
 	alg->alg.cra_blocksize = t->bsize;
 	alg->alg.cra_ctxsize = sizeof(struct hifn_context);
 	alg->alg.cra_alignmask = 0;
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 4c20c5b..a82c11a 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1449,6 +1449,7 @@ static int __init ixp_module_init(void)
 			/* block ciphers */
 			cra->cra_type = &crypto_ablkcipher_type;
 			cra->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					 CRYPTO_ALG_KERN_DRIVER_ONLY |
 					 CRYPTO_ALG_ASYNC;
 			if (!cra->cra_ablkcipher.setkey)
 				cra->cra_ablkcipher.setkey = ablk_setkey;
@@ -1461,6 +1462,7 @@ static int __init ixp_module_init(void)
 			/* authenc */
 			cra->cra_type = &crypto_aead_type;
 			cra->cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					 CRYPTO_ALG_KERN_DRIVER_ONLY |
 					 CRYPTO_ALG_ASYNC;
 			cra->cra_aead.setkey = aead_setkey;
 			cra->cra_aead.setauthsize = aead_setauthsize;
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 38a3297..04f47e5 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -897,7 +897,8 @@ struct crypto_alg mv_aes_alg_ecb = {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "mv-ecb-aes",
 	.cra_priority	= 300,
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+			  CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= 16,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
 	.cra_alignmask	= 0,
@@ -919,7 +920,8 @@ struct crypto_alg mv_aes_alg_cbc = {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "mv-cbc-aes",
 	.cra_priority	= 300,
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+			  CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= AES_BLOCK_SIZE,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
 	.cra_alignmask	= 0,
@@ -951,7 +953,8 @@ struct ahash_alg mv_sha1_alg = {
 			  .cra_driver_name = "mv-sha1",
 			  .cra_priority = 300,
 			  .cra_flags =
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			  CRYPTO_ALG_NEED_FALLBACK,
 			  .cra_blocksize = SHA1_BLOCK_SIZE,
 			  .cra_ctxsize = sizeof(struct mv_tfm_hash_ctx),
 			  .cra_init = mv_cra_hash_sha1_init,
@@ -975,7 +978,8 @@ struct ahash_alg mv_hmac_sha1_alg = {
 			  .cra_driver_name = "mv-hmac-sha1",
 			  .cra_priority = 300,
 			  .cra_flags =
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			  CRYPTO_ALG_NEED_FALLBACK,
 			  .cra_blocksize = SHA1_BLOCK_SIZE,
 			  .cra_ctxsize = sizeof(struct mv_tfm_hash_ctx),
 			  .cra_init = mv_cra_hash_hmac_sha1_init,
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8944dab..b7a98ea 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1402,7 +1402,8 @@ static int __devinit __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
 	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->drv_name);
 	alg->cra_priority = N2_CRA_PRIORITY;
-	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+			 CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC;
 	alg->cra_blocksize = tmpl->block_size;
 	p->enc_type = tmpl->enc_type;
 	alg->cra_ctxsize = sizeof(struct n2_cipher_context);
@@ -1493,7 +1494,9 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->name);
 	base->cra_priority = N2_CRA_PRIORITY;
-	base->cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK;
+	base->cra_flags = CRYPTO_ALG_TYPE_AHASH |
+			  CRYPTO_ALG_KERN_DRIVER_ONLY |
+			  CRYPTO_ALG_NEED_FALLBACK;
 	base->cra_blocksize = tmpl->block_size;
 	base->cra_ctxsize = sizeof(struct n2_hash_ctx);
 	base->cra_module = THIS_MODULE;
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 5b970d9..61d313f 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -756,7 +756,9 @@ static struct crypto_alg algs[] = {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "ecb-aes-omap",
 	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
@@ -776,7 +778,9 @@ static struct crypto_alg algs[] = {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "cbc-aes-omap",
 	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6399a8f..a3fd6fc 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -953,6 +953,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-sha1",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
@@ -975,6 +976,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-md5",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
@@ -998,6 +1000,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-hmac-sha1",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
@@ -1022,6 +1025,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-hmac-md5",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a2b553e..f4df418 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1322,6 +1322,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_driver_name = "cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1349,6 +1350,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_driver_name = "ecb-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				CRYPTO_ALG_KERN_DRIVER_ONLY |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
@@ -1373,7 +1375,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "cbc(des)",
 			.cra_driver_name = "cbc-des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1398,7 +1402,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "ecb-des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1422,7 +1428,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "cbc-des3-ede-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1447,7 +1455,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "ecb-des3-ede-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1472,7 +1482,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1500,7 +1512,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1527,7 +1541,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1554,7 +1570,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1582,7 +1600,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1609,7 +1629,9 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1639,7 +1661,9 @@ static struct spacc_alg l2_engine_algs[] = {
 			.cra_name = "f8(kasumi)",
 			.cra_driver_name = "f8-kasumi-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 8,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 8115417..49dbab6 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -518,7 +518,8 @@ static struct crypto_alg algs[] = {
 		.cra_driver_name	= "ecb-aes-s5p",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC,
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
 		.cra_alignmask		= 0x0f,
@@ -538,7 +539,8 @@ static struct crypto_alg algs[] = {
 		.cra_driver_name	= "cbc-aes-s5p",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC,
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
 		.cra_alignmask		= 0x0f,
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dbe76b5..d2fbf72 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1890,7 +1890,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1916,7 +1918,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1943,7 +1947,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1969,7 +1975,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1996,7 +2004,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -2022,7 +2032,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -2051,7 +2063,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-                                     CRYPTO_ALG_ASYNC,
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_ablkcipher_type,
 			.cra_ablkcipher = {
 				.setkey = ablkcipher_setkey,
@@ -2073,7 +2086,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-                                     CRYPTO_ALG_ASYNC,
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_type = &crypto_ablkcipher_type,
 			.cra_ablkcipher = {
 				.setkey = ablkcipher_setkey,
@@ -2104,7 +2118,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2125,7 +2140,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2146,7 +2162,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2167,7 +2184,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2188,7 +2206,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2209,7 +2228,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index de9adec..e09acce 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -76,6 +76,11 @@
  */
 #define CRYPTO_ALG_INSTANCE		0x00000800
 
+/* Set this bit if the algorithm provided is hardware accelerated but
+ * not available to userspace via instruction set or so.
+ */
+#define CRYPTO_ALG_KERN_DRIVER_ONLY	0x00001000
+
 /*
  * Transform masks and values (for crt_flags).
  */
-- 
1.7.7.3
