From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/16] crypto: aead - Rename aead_alg to old_aead_alg
Date: Thu, 21 May 2015 15:11:02 +0800
Message-ID: <E1YvKdC-0005dv-C6@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53957 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbbEUHLG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:06 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdD-0002xR-5f
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:03 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch is the first step in the introduction of a new AEAD
alg type.  Unlike normal conversions this patch only renames the
existing aead_alg structure because there are external references
to it.

Those references will be removed after this patch.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |   25 +++++++++++++------------
 include/crypto/aead.h          |    2 ++
 include/crypto/internal/aead.h |    5 +++++
 include/linux/crypto.h         |    6 +++---
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index c2bf3b3..ebc91ea 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -33,7 +33,7 @@ static int aead_null_givdecrypt(struct aead_givcrypt_request *req);
 static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
-	struct aead_alg *aead = crypto_aead_alg(tfm);
+	struct old_aead_alg *aead = crypto_old_aead_alg(tfm);
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
 	int ret;
 	u8 *buffer, *alignbuffer;
@@ -55,7 +55,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 int crypto_aead_setkey(struct crypto_aead *tfm,
 		       const u8 *key, unsigned int keylen)
 {
-	struct aead_alg *aead = crypto_aead_alg(tfm);
+	struct old_aead_alg *aead = crypto_old_aead_alg(tfm);
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
 
 	tfm = tfm->child;
@@ -71,11 +71,12 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
 	int err;
 
-	if (authsize > crypto_aead_alg(tfm)->maxauthsize)
+	if (authsize > crypto_old_aead_alg(tfm)->maxauthsize)
 		return -EINVAL;
 
-	if (crypto_aead_alg(tfm)->setauthsize) {
-		err = crypto_aead_alg(tfm)->setauthsize(tfm->child, authsize);
+	if (crypto_old_aead_alg(tfm)->setauthsize) {
+		err = crypto_old_aead_alg(tfm)->setauthsize(
+			tfm->child, authsize);
 		if (err)
 			return err;
 	}
@@ -126,7 +127,7 @@ static int old_crypt(struct aead_request *req,
 static int old_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct old_aead_alg *alg = crypto_old_aead_alg(aead);
 
 	return old_crypt(req, alg->encrypt);
 }
@@ -134,7 +135,7 @@ static int old_encrypt(struct aead_request *req)
 static int old_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct old_aead_alg *alg = crypto_old_aead_alg(aead);
 
 	return old_crypt(req, alg->decrypt);
 }
@@ -146,7 +147,7 @@ static int no_givcrypt(struct aead_givcrypt_request *req)
 
 static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 {
-	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
+	struct old_aead_alg *alg = &tfm->__crt_alg->cra_aead;
 	struct crypto_aead *crt = __crypto_aead_cast(tfm);
 
 	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
@@ -172,7 +173,7 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
-	struct aead_alg *aead = &alg->cra_aead;
+	struct old_aead_alg *aead = &alg->cra_aead;
 
 	strncpy(raead.type, "aead", sizeof(raead.type));
 	strncpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
@@ -200,7 +201,7 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 {
-	struct aead_alg *aead = &alg->cra_aead;
+	struct old_aead_alg *aead = &alg->cra_aead;
 
 	seq_printf(m, "type         : aead\n");
 	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
@@ -240,7 +241,7 @@ static int aead_null_givdecrypt(struct aead_givcrypt_request *req)
 static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
-	struct aead_alg *aead = &alg->cra_aead;
+	struct old_aead_alg *aead = &alg->cra_aead;
 
 	strncpy(raead.type, "nivaead", sizeof(raead.type));
 	strncpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
@@ -269,7 +270,7 @@ static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
 {
-	struct aead_alg *aead = &alg->cra_aead;
+	struct old_aead_alg *aead = &alg->cra_aead;
 
 	seq_printf(m, "type         : nivaead\n");
 	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index e2d2c3c..aebf57d 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
+#define aead_alg old_aead_alg
+
 /**
  * DOC: Authenticated Encryption With Associated Data (AEAD) Cipher API
  *
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index a2d104a..84c17bb 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -26,6 +26,11 @@ struct crypto_aead_spawn {
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_nivaead_type;
 
+static inline struct old_aead_alg *crypto_old_aead_alg(struct crypto_aead *tfm)
+{
+	return &crypto_aead_tfm(tfm)->__crt_alg->cra_aead;
+}
+
 static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
 {
 	return &crypto_aead_tfm(tfm)->__crt_alg->cra_aead;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 59ca408..7d290a9 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -268,7 +268,7 @@ struct ablkcipher_alg {
 };
 
 /**
- * struct aead_alg - AEAD cipher definition
+ * struct old_aead_alg - AEAD cipher definition
  * @maxauthsize: Set the maximum authentication tag size supported by the
  *		 transformation. A transformation may support smaller tag sizes.
  *		 As the authentication tag is a message digest to ensure the
@@ -293,7 +293,7 @@ struct ablkcipher_alg {
  * All fields except @givencrypt , @givdecrypt , @geniv and @ivsize are
  * mandatory and must be filled.
  */
-struct aead_alg {
+struct old_aead_alg {
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
@@ -501,7 +501,7 @@ struct crypto_alg {
 
 	union {
 		struct ablkcipher_alg ablkcipher;
-		struct aead_alg aead;
+		struct old_aead_alg aead;
 		struct blkcipher_alg blkcipher;
 		struct cipher_alg cipher;
 		struct compress_alg compress;
