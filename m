From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd attempt)
Date: Tue, 13 Dec 2011 21:34:00 +0100
Message-ID: <4EE7B6B8.7070700@gnutls.org>
References: <4EE712A0.3090601@gnutls.org> <20111213101017.aceb0df9285bd5701d61df39@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48582 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab1LMUbI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 15:31:08 -0500
Received: by eaaj10 with SMTP id j10so75377eaa.19
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2011 12:31:05 -0800 (PST)
In-Reply-To: <20111213101017.aceb0df9285bd5701d61df39@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The added CRYPTO_ALG_KERN_DRIVER_ONLY indicates whether a cipher
is only available via a kernel driver. If the cipher implementation
might be available by using an instruction set or by porting the
kernel code, then it must not be set.

In addition it provides crypto_tfm_alg_flags() to obtain
this and other possible flags.

Signed-off-by: Nikos Mavrogiannopoulos <nmav@gnutls.org>
---
 drivers/crypto/caam/caamalg.c     |    3 +-
 drivers/crypto/geode-aes.c        |    6 +++-
 drivers/crypto/hifn_795x.c        |    3 +-
 drivers/crypto/ixp4xx_crypto.c    |    2 +
 drivers/crypto/mv_cesa.c          |   12 ++++++---
 drivers/crypto/n2_core.c          |    7 ++++-
 drivers/crypto/omap-aes.c         |    8 +++++-
 drivers/crypto/omap-sham.c        |    4 +++
 drivers/crypto/picoxcell_crypto.c |   46 ++++++++++++++++++++++++++++---------
 drivers/crypto/s5p-sss.c          |    6 +++-
 drivers/crypto/talitos.c          |    1 +
 include/linux/crypto.h            |   10 ++++++++
 12 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a5bc706..4117836 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2205,7 +2205,8 @@ static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct caam_ctx);
-	alg->cra_flags = CRYPTO_ALG_ASYNC | template->type;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			 template->type;
 	switch (template->type) {
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg->cra_type = &crypto_ablkcipher_type;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 219d09c..f3e36c8 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -393,7 +393,8 @@ static struct crypto_alg geode_cbc_alg = {
 	.cra_driver_name	=	"cbc-aes-geode",
 	.cra_priority		=	400,
 	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
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
index fe765f4..6bd9d17 100644
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
index 015c0fc..9d41ec6 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -896,7 +896,8 @@ struct crypto_alg mv_aes_alg_ecb = {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "mv-ecb-aes",
 	.cra_priority	= 300,
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+			  CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= 16,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
 	.cra_alignmask	= 0,
@@ -918,7 +919,8 @@ struct crypto_alg mv_aes_alg_cbc = {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "mv-cbc-aes",
 	.cra_priority	= 300,
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+			  CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= AES_BLOCK_SIZE,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
 	.cra_alignmask	= 0,
@@ -950,7 +952,8 @@ struct ahash_alg mv_sha1_alg = {
 			  .cra_driver_name = "mv-sha1",
 			  .cra_priority = 300,
 			  .cra_flags =
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			  CRYPTO_ALG_NEED_FALLBACK,
 			  .cra_blocksize = SHA1_BLOCK_SIZE,
 			  .cra_ctxsize = sizeof(struct mv_tfm_hash_ctx),
 			  .cra_init = mv_cra_hash_sha1_init,
@@ -974,7 +977,8 @@ struct ahash_alg mv_hmac_sha1_alg = {
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
index 8944dab..67b97c5 100644
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
index 5b970d9..63e57b5 100644
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
index 9b1571c..f0609c4 100644
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
index 3376bca..bc986f8 100644
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
index 230509e..39d570b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2647,6 +2647,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	alg->cra_priority = TALITOS_CRA_PRIORITY;
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
+	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	t_alg->dev = dev;
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 8a94217..569bb76 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -75,6 +75,11 @@
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
@@ -514,6 +519,11 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
+static inline u32 crypto_tfm_alg_flags(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags;
+}
+
 static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_blocksize;
-- 
1.7.7.3
