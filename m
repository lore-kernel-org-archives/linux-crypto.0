From: "Loc Ho" <locnho@sbcglobal.net>
Subject: RE: [PATCH] Async Digest Support
Date: Fri, 25 Jan 2008 13:35:33 -0800
Message-ID: <005401c85f9a$377891f0$5c05420a@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27551 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760249AbYAYVff (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jan 2008 16:35:35 -0500
References: 
In-Reply-To: 
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add asynchronous digest support using asynchronous hash interface.
---
 crypto/ahash.c                |    9 ++++-
 crypto/api.c                  |    9 +++-
 crypto/digest.c               |   83
++++++++++++++++++++++++++++++++++++++++-
 crypto/internal.h             |    1 +
 crypto/tcrypt.c               |   40 +++++++++++++++-----
 drivers/crypto/ahash_sample.c |   17 ++++++++
 include/linux/crypto.h        |    6 +++
 7 files changed, 150 insertions(+), 15 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c index e9bf72f..923fc0e 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -57,6 +57,13 @@ static int ahash_setkey(struct crypto_ahash *tfm, const
u8 *key,
 	return ahash->setkey(tfm, key, keylen);  }
 
+static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_RES_MASK);
+	return -ENOSYS;
+}
+
 static unsigned int crypto_ahash_ctxsize(struct crypto_alg *alg, u32 type,
 					u32 mask)
 {
@@ -75,7 +82,7 @@ static int crypto_init_ahash_ops(struct crypto_tfm *tfm,
u32 type, u32 mask)
 	crt->update = alg->update;
 	crt->final  = alg->final;
 	crt->digest = alg->digest;
-	crt->setkey = ahash_setkey;
+	crt->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
 	crt->base   = __crypto_ahash_cast(tfm);
 	crt->digestsize = alg->digestsize;
 
diff --git a/crypto/api.c b/crypto/api.c index c3213f4..6efa3b6 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -233,10 +233,13 @@ static int crypto_init_ops(struct crypto_tfm *tfm, u32
type, u32 mask)
 	switch (crypto_tfm_alg_type(tfm)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
 		return crypto_init_cipher_ops(tfm);
-		
+
 	case CRYPTO_ALG_TYPE_DIGEST:
-		return crypto_init_digest_ops(tfm);
-		
+		if (mask & CRYPTO_ALG_ASYNC)
+			return crypto_init_digest_ops_async(tfm);
+		else
+			return crypto_init_digest_ops(tfm);
+
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		return crypto_init_compress_ops(tfm);
 	
diff --git a/crypto/digest.c b/crypto/digest.c index 19b7ade..fd107b7 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -7,7 +7,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
Free
- * Software Foundation; either version 2 of the License, or (at your
option) 
+ * Software Foundation; either version 2 of the License, or (at your
+ option)
  * any later version.
  *
  */
@@ -155,3 +155,84 @@ int crypto_init_digest_ops(struct crypto_tfm *tfm)
void crypto_exit_digest_ops(struct crypto_tfm *tfm)  {  }
+
+static int digest_async_nosetkey(struct crypto_ahash *tfm_async, const u8
*key,
+			unsigned int keylen)
+{
+	crypto_ahash_clear_flags(tfm_async, CRYPTO_TFM_RES_MASK);
+	return -ENOSYS;
+}
+
+static int digest_async_setkey(struct crypto_ahash *tfm_async, const u8
*key,
+			unsigned int keylen)
+{
+	struct crypto_tfm    *tfm        = crypto_ahash_tfm(tfm_async);
+	struct digest_alg    *dalg       = &tfm->__crt_alg->cra_digest;
+
+	crypto_ahash_clear_flags(tfm_async, CRYPTO_TFM_RES_MASK);
+	return dalg->dia_setkey(tfm, key, keylen); }
+
+static int digest_async_init(struct ahash_request *req) {
+	struct crypto_tfm *tfm  = req->base.tfm;
+	struct digest_alg *dalg = &tfm->__crt_alg->cra_digest;
+
+	dalg->dia_init(tfm);
+	return 0;
+}
+
+static int digest_async_update(struct ahash_request *req) {
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct hash_desc  desc = {
+		.tfm   = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	update(&desc, req->src, req->nbytes);
+	return 0;
+}
+
+static int digest_async_final(struct ahash_request *req) {
+	struct crypto_tfm *tfm  = req->base.tfm;
+	struct hash_desc  desc = {
+		.tfm   = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	final(&desc, req->result);
+	return 0;
+}
+
+static int digest_async_digest(struct ahash_request *req) {
+	struct crypto_tfm *tfm  = req->base.tfm;
+	struct hash_desc  desc = {
+		.tfm   = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	return digest(&desc, req->src, req->nbytes, req->result); }
+
+int crypto_init_digest_ops_async(struct crypto_tfm *tfm) {
+	struct ahash_tfm  *crt  = &tfm->crt_ahash;
+	struct digest_alg *dalg = &tfm->__crt_alg->cra_digest;
+
+	if (dalg->dia_digestsize > crypto_tfm_alg_blocksize(tfm))
+		return -EINVAL;
+
+	crt->init       = digest_async_init;
+	crt->update     = digest_async_update;
+	crt->final      = digest_async_final;
+	crt->digest     = digest_async_digest;
+	crt->setkey     = dalg->dia_setkey ? digest_async_setkey :
+						digest_async_nosetkey;
+	crt->digestsize = dalg->dia_digestsize;
+	crt->base       = __crypto_ahash_cast(tfm);
+
+	return 0;
+}
diff --git a/crypto/internal.h b/crypto/internal.h index 32f4c21..683fcb2
100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -86,6 +86,7 @@ struct crypto_alg *__crypto_alg_lookup(const char *name,
u32 type, u32 mask);  struct crypto_alg *crypto_alg_mod_lookup(const char
*name, u32 type, u32 mask);
 
 int crypto_init_digest_ops(struct crypto_tfm *tfm);
+int crypto_init_digest_ops_async(struct crypto_tfm *tfm);
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);  int
crypto_init_compress_ops(struct crypto_tfm *tfm);
 
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c index 784f0b5..b680309 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1716,33 +1716,53 @@ static void do_test(void)
 		test_ahash("hmac(md5)", hmac_md5_tv_template,
 			  HMAC_MD5_TEST_VECTORS);
 		break;
-
 	case 111:
 		test_ahash("hmac(sha1)", hmac_sha1_tv_template,
 			  HMAC_SHA1_TEST_VECTORS);
 		break;
-
 	case 112:
+		test_ahash("hmac(sha224)", hmac_sha224_tv_template,
+			  HMAC_SHA224_TEST_VECTORS);
+		break;
+	case 113:
 		test_ahash("hmac(sha256)", hmac_sha256_tv_template,
 			  HMAC_SHA256_TEST_VECTORS);
 		break;
-
-	case 113:
+	case 114:
 		test_ahash("hmac(sha384)", hmac_sha384_tv_template,
 			  HMAC_SHA384_TEST_VECTORS);
 		break;
-
-	case 114:
+	case 115:
 		test_ahash("hmac(sha512)", hmac_sha512_tv_template,
 			  HMAC_SHA512_TEST_VECTORS);
 		break;
 
-	case 115:
-		test_ahash("hmac(sha224)", hmac_sha224_tv_template,
-			  HMAC_SHA224_TEST_VECTORS);
+	case 120:
+		test_ahash("md5", md5_tv_template, MD5_TEST_VECTORS);
+		break;
+	case 121:
+		test_ahash("sha1", sha1_tv_template, SHA1_TEST_VECTORS);
+		break;
+	case 122:
+		test_ahash("sha224", sha224_tv_template,
SHA224_TEST_VECTORS);
+		break;
+	case 123:
+		test_ahash("sha256", sha256_tv_template,
SHA256_TEST_VECTORS);
+		break;
+	case 124:
+		test_ahash("sha384", sha384_tv_template,
SHA384_TEST_VECTORS);
+		break;
+	case 125:
+		test_ahash("sha512", sha512_tv_template,
SHA512_TEST_VECTORS);
 		break;
 
-	case 120:
+	case 130:
+		test_ahash("md5", md5_tv_template, MD5_TEST_VECTORS);
+		test_ahash("sha1", sha1_tv_template, SHA1_TEST_VECTORS);
+		test_ahash("sha224", sha224_tv_template,
SHA224_TEST_VECTORS);
+		test_ahash("sha256", sha256_tv_template,
SHA256_TEST_VECTORS);
+		test_ahash("sha384", sha384_tv_template,
SHA384_TEST_VECTORS);
+		test_ahash("sha512", sha512_tv_template,
SHA512_TEST_VECTORS);
 		test_ahash("hmac(md5)", hmac_md5_tv_template,
 			  HMAC_MD5_TEST_VECTORS);
 		test_ahash("hmac(sha1)", hmac_sha1_tv_template, diff --git
a/drivers/crypto/ahash_sample.c b/drivers/crypto/ahash_sample.c index
0c1ad60..5bd6aa0 100644
--- a/drivers/crypto/ahash_sample.c
+++ b/drivers/crypto/ahash_sample.c
@@ -235,6 +235,23 @@ static void ahash_sample_bh_tasklet_cb(unsigned long
data)
 
 static struct crypto_alg ahash_sample_alg_tbl[] =  {
+	{ .cra_name		= "md5",
+	  .cra_driver_name	= "ahash-md5",
+	  .cra_priority		= 300,
+	  .cra_flags		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	  .cra_blocksize	= 64, /* MD5-HMAC block size is 512-bits */
+	  .cra_ctxsize		= sizeof(struct ahash_sample_context),
+	  .cra_alignmask 	= 0,
+	  .cra_type		= &crypto_ahash_type,
+	  .cra_module		= THIS_MODULE,
+	  .cra_u		= { .ahash = {
+	  .digestsize		= 16, /* Disgest is 128-bits */
+	  .init   		= ahash_sample_ops_init,
+	  .update   		= ahash_sample_ops_update,
+	  .final   		= ahash_sample_ops_final,
+	  .digest 		= ahash_sample_ops_digest,
+	  } },
+	},
 	{ .cra_name		= "hmac(md5)",
 	  .cra_driver_name	= "ahash-md5",
 	  .cra_priority		= 300,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h index
fe9a5c2..c4f6eda 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1440,5 +1440,11 @@ static inline void ahash_request_set_crypt(
 	req->result = result;
 }
 
+static inline struct crypto_digest *__crypto_digest_cast(
+	struct crypto_tfm *tfm)
+{
+	return (struct crypto_digest *) tfm;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
--
1.5.3
