From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Hardware acceleration indication in af_alg
Date: Tue, 01 Nov 2011 13:43:26 +0100
Message-ID: <4EAFE96E.9080601@gnutls.org>
References: <20111021132336.GA1080@gondor.apana.org.au> <4EAAD74E.7060202@gnutls.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070508030305090400030808"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33793 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1KAMmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Nov 2011 08:42:00 -0400
Received: by wwi36 with SMTP id 36so3024817wwi.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Nov 2011 05:41:58 -0700 (PDT)
In-Reply-To: <4EAAD74E.7060202@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070508030305090400030808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/28/2011 06:24 PM, Nikos Mavrogiannopoulos wrote:

>>> I can imagine, an alternative approach and perhaps better
>>> approach would be to measure the speed of the kernel provided
>>> algorithm against a software implementation, but there are many
>>> other factors that could influence the results. Therefore, it is
>>> perhaps better to just make the assumption that hardware
>>> acceleration is faster which is made in the kernel anyhow.
>> You have to be careful to distinguish between hardware
>> acceleration that is directly available to user-space (such as
>> AESNI) and those that aren't.
> How can this be done? The only driver field that could be used for
> that is cra_priority and it seems it typically set to 300
> irrespective of instruction based crypto or external device.

I suppose that no answer means there is no way. In that case would you
consider this or a similar patch to indicate whether a driver provides
an algorithm not available to userspace via other means (e.g.
instruction set)? This would allow users of the kernel interfaces to
avoid using software implementations or implementations that are
available to userspace anyway.

regards,
Nikos

--------------070508030305090400030808
Content-Type: text/x-patch;
 name="0001-Added-CRYPTO_ALG_KERN_ONLY-flag-to-indicate-whether-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Added-CRYPTO_ALG_KERN_ONLY-flag-to-indicate-whether-.pa";
 filename*1="tch"

>From ee66a849c15c6b83cb0fd85d61eedef707288aea Mon Sep 17 00:00:00 2001
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Date: Tue, 1 Nov 2011 13:39:56 +0100
Subject: [PATCH] Added CRYPTO_ALG_KERN_ONLY flag to indicate whether a cipher
 maybe available to userspace via instruction set or not.

---
 drivers/crypto/geode-aes.c        |    4 +++-
 drivers/crypto/hifn_795x.c        |    2 +-
 drivers/crypto/ixp4xx_crypto.c    |    2 ++
 drivers/crypto/mv_cesa.c          |    8 ++++----
 drivers/crypto/n2_core.c          |    4 ++--
 drivers/crypto/omap-aes.c         |    4 ++--
 drivers/crypto/omap-sham.c        |    4 ++++
 drivers/crypto/picoxcell_crypto.c |   35 ++++++++++++++++++++++++-----------
 drivers/crypto/s5p-sss.c          |    4 ++--
 drivers/crypto/talitos.c          |   28 ++++++++++++++--------------
 include/linux/crypto.h            |    5 +++++
 11 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 219d09c..3a8a3ef1 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -392,7 +392,8 @@ static struct crypto_alg geode_cbc_alg = {
 	.cra_name		=	"cbc(aes)",
 	.cra_driver_name	=	"cbc-aes-geode",
 	.cra_priority		=	400,
-	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
+	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER | 
+							CRYPTO_ALG_KERN_ONLY |
 							CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=	fallback_init_blk,
 	.cra_exit			=	fallback_exit_blk,
@@ -479,6 +480,7 @@ static struct crypto_alg geode_ecb_alg = {
 	.cra_driver_name	=	"ecb-aes-geode",
 	.cra_priority		=	400,
 	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
+						        CRYPTO_ALG_KERN_ONLY |
 							CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=	fallback_init_blk,
 	.cra_exit			=	fallback_exit_blk,
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index fe765f4..7556a045 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2494,7 +2494,7 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 		 t->drv_name, dev->name);
 
 	alg->alg.cra_priority = 300;
-	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_ASYNC;
 	alg->alg.cra_blocksize = t->bsize;
 	alg->alg.cra_ctxsize = sizeof(struct hifn_context);
 	alg->alg.cra_alignmask = 0;
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 4c20c5b..52e6525 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1449,6 +1449,7 @@ static int __init ixp_module_init(void)
 			/* block ciphers */
 			cra->cra_type = &crypto_ablkcipher_type;
 			cra->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+                                         CRYPTO_ALG_KERN_ONLY |
 					 CRYPTO_ALG_ASYNC;
 			if (!cra->cra_ablkcipher.setkey)
 				cra->cra_ablkcipher.setkey = ablk_setkey;
@@ -1461,6 +1462,7 @@ static int __init ixp_module_init(void)
 			/* authenc */
 			cra->cra_type = &crypto_aead_type;
 			cra->cra_flags = CRYPTO_ALG_TYPE_AEAD |
+                                         CRYPTO_ALG_KERN_ONLY |
 					 CRYPTO_ALG_ASYNC;
 			cra->cra_aead.setkey = aead_setkey;
 			cra->cra_aead.setauthsize = aead_setauthsize;
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 3cf303e..8d157ed 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -895,7 +895,7 @@ struct crypto_alg mv_aes_alg_ecb = {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "mv-ecb-aes",
 	.cra_priority	= 300,
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= 16,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
 	.cra_alignmask	= 0,
@@ -917,7 +917,7 @@ struct crypto_alg mv_aes_alg_cbc = {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "mv-cbc-aes",
 	.cra_priority	= 300,
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= AES_BLOCK_SIZE,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
 	.cra_alignmask	= 0,
@@ -949,7 +949,7 @@ struct ahash_alg mv_sha1_alg = {
 			  .cra_driver_name = "mv-sha1",
 			  .cra_priority = 300,
 			  .cra_flags =
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			  .cra_blocksize = SHA1_BLOCK_SIZE,
 			  .cra_ctxsize = sizeof(struct mv_tfm_hash_ctx),
 			  .cra_init = mv_cra_hash_sha1_init,
@@ -973,7 +973,7 @@ struct ahash_alg mv_hmac_sha1_alg = {
 			  .cra_driver_name = "mv-hmac-sha1",
 			  .cra_priority = 300,
 			  .cra_flags =
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			  .cra_blocksize = SHA1_BLOCK_SIZE,
 			  .cra_ctxsize = sizeof(struct mv_tfm_hash_ctx),
 			  .cra_init = mv_cra_hash_hmac_sha1_init,
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8944dab..37256c5 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1402,7 +1402,7 @@ static int __devinit __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
 	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->drv_name);
 	alg->cra_priority = N2_CRA_PRIORITY;
-	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_ASYNC;
 	alg->cra_blocksize = tmpl->block_size;
 	p->enc_type = tmpl->enc_type;
 	alg->cra_ctxsize = sizeof(struct n2_cipher_context);
@@ -1493,7 +1493,7 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->name);
 	base->cra_priority = N2_CRA_PRIORITY;
-	base->cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK;
+	base->cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_NEED_FALLBACK;
 	base->cra_blocksize = tmpl->block_size;
 	base->cra_ctxsize = sizeof(struct n2_hash_ctx);
 	base->cra_module = THIS_MODULE;
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 5b970d9..376b22e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -756,7 +756,7 @@ static struct crypto_alg algs[] = {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "ecb-aes-omap",
 	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
@@ -776,7 +776,7 @@ static struct crypto_alg algs[] = {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "cbc-aes-omap",
 	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_KERN_ONLY | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6399a8f..ddd1744 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -953,6 +953,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-sha1",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
@@ -975,6 +976,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-md5",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
@@ -998,6 +1000,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-hmac-sha1",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
@@ -1022,6 +1025,7 @@ static struct ahash_alg algs[] = {
 		.cra_driver_name	= "omap-hmac-md5",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_KERN_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a2b553e..1ed9c1d 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1322,6 +1322,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_driver_name = "cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_KERN_ONLY |
 				     CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1349,6 +1350,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_driver_name = "ecb-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				CRYPTO_ALG_KERN_ONLY |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
@@ -1373,7 +1375,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "cbc(des)",
 			.cra_driver_name = "cbc-des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1398,7 +1401,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "ecb-des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1422,7 +1426,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "cbc-des3-ede-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1447,7 +1452,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "ecb-des3-ede-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
@@ -1472,7 +1478,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1500,7 +1507,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1527,7 +1535,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1554,7 +1563,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1582,7 +1592,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1609,7 +1620,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
 			.cra_type = &crypto_aead_type,
@@ -1639,7 +1651,8 @@ static struct spacc_alg l2_engine_algs[] = {
 			.cra_name = "f8(kasumi)",
 			.cra_driver_name = "f8-kasumi-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_ONLY,
 			.cra_blocksize = 8,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
 			.cra_type = &crypto_ablkcipher_type,
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 8115417..2294de6 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -518,7 +518,7 @@ static struct crypto_alg algs[] = {
 		.cra_driver_name	= "ecb-aes-s5p",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC,
+					  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
 		.cra_alignmask		= 0x0f,
@@ -538,7 +538,7 @@ static struct crypto_alg algs[] = {
 		.cra_driver_name	= "cbc-aes-s5p",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC,
+					  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
 		.cra_alignmask		= 0x0f,
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dbe76b5..f165ea1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1890,7 +1890,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1916,7 +1916,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1943,7 +1943,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1969,7 +1969,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -1996,7 +1996,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -2022,7 +2022,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
@@ -2051,7 +2051,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-                                     CRYPTO_ALG_ASYNC,
+				     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_ablkcipher_type,
 			.cra_ablkcipher = {
 				.setkey = ablkcipher_setkey,
@@ -2073,7 +2073,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-                                     CRYPTO_ALG_ASYNC,
+				     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 			.cra_type = &crypto_ablkcipher_type,
 			.cra_ablkcipher = {
 				.setkey = ablkcipher_setkey,
@@ -2104,7 +2104,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2125,7 +2125,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2146,7 +2146,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2167,7 +2167,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2188,7 +2188,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
@@ -2209,7 +2209,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-					     CRYPTO_ALG_ASYNC,
+					     CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_ONLY,
 				.cra_type = &crypto_ahash_type
 			}
 		},
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index de9adec..3e14cee 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -51,6 +51,11 @@
 #define CRYPTO_ALG_DYING		0x00000040
 #define CRYPTO_ALG_ASYNC		0x00000080
 
+/* Set this bit if the algorithm provided is hardware accelerated but
+ * not available to userspace via instruction set or so.
+ */
+#define CRYPTO_ALG_KERN_ONLY            0x00000100
+
 /*
  * Set this bit if and only if the algorithm requires another algorithm of
  * the same type to handle corner cases.
-- 
1.7.7


--------------070508030305090400030808--
