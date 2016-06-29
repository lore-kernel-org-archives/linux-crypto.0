From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 25/28] crypto: null - Remove default null blkcipher
Date: Wed, 29 Jun 2016 18:04:12 +0800
Message-ID: <E1bICLs-0006xZ-KC@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35521 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbcF2KEP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLs-0005OY-Pt
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:12 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The default null blkcipher is no longer used and can now be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_null.c  |   49 ++++++-------------------------------------------
 include/crypto/null.h |   14 +++++++++++---
 2 files changed, 17 insertions(+), 46 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index c3f6839..20ff2c7 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -26,10 +26,8 @@
 #include <linux/string.h>
 
 static DEFINE_MUTEX(crypto_default_null_skcipher_lock);
-static struct crypto_blkcipher *crypto_default_null_skcipher;
+static struct crypto_skcipher *crypto_default_null_skcipher;
 static int crypto_default_null_skcipher_refcnt;
-static struct crypto_skcipher *crypto_default_null_skcipher2;
-static int crypto_default_null_skcipher2_refcnt;
 
 static int null_compress(struct crypto_tfm *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen)
@@ -155,15 +153,16 @@ MODULE_ALIAS_CRYPTO("compress_null");
 MODULE_ALIAS_CRYPTO("digest_null");
 MODULE_ALIAS_CRYPTO("cipher_null");
 
-struct crypto_blkcipher *crypto_get_default_null_skcipher(void)
+struct crypto_skcipher *crypto_get_default_null_skcipher(void)
 {
-	struct crypto_blkcipher *tfm;
+	struct crypto_skcipher *tfm;
 
 	mutex_lock(&crypto_default_null_skcipher_lock);
 	tfm = crypto_default_null_skcipher;
 
 	if (!tfm) {
-		tfm = crypto_alloc_blkcipher("ecb(cipher_null)", 0, 0);
+		tfm = crypto_alloc_skcipher("ecb(cipher_null)",
+					    0, CRYPTO_ALG_ASYNC);
 		if (IS_ERR(tfm))
 			goto unlock;
 
@@ -183,49 +182,13 @@ void crypto_put_default_null_skcipher(void)
 {
 	mutex_lock(&crypto_default_null_skcipher_lock);
 	if (!--crypto_default_null_skcipher_refcnt) {
-		crypto_free_blkcipher(crypto_default_null_skcipher);
+		crypto_free_skcipher(crypto_default_null_skcipher);
 		crypto_default_null_skcipher = NULL;
 	}
 	mutex_unlock(&crypto_default_null_skcipher_lock);
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher);
 
-struct crypto_skcipher *crypto_get_default_null_skcipher2(void)
-{
-	struct crypto_skcipher *tfm;
-
-	mutex_lock(&crypto_default_null_skcipher_lock);
-	tfm = crypto_default_null_skcipher2;
-
-	if (!tfm) {
-		tfm = crypto_alloc_skcipher("ecb(cipher_null)",
-					    0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(tfm))
-			goto unlock;
-
-		crypto_default_null_skcipher2 = tfm;
-	}
-
-	crypto_default_null_skcipher2_refcnt++;
-
-unlock:
-	mutex_unlock(&crypto_default_null_skcipher_lock);
-
-	return tfm;
-}
-EXPORT_SYMBOL_GPL(crypto_get_default_null_skcipher2);
-
-void crypto_put_default_null_skcipher2(void)
-{
-	mutex_lock(&crypto_default_null_skcipher_lock);
-	if (!--crypto_default_null_skcipher2_refcnt) {
-		crypto_free_skcipher(crypto_default_null_skcipher2);
-		crypto_default_null_skcipher2 = NULL;
-	}
-	mutex_unlock(&crypto_default_null_skcipher_lock);
-}
-EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher2);
-
 static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
diff --git a/include/crypto/null.h b/include/crypto/null.h
index dda87cb..3f0c59fb 100644
--- a/include/crypto/null.h
+++ b/include/crypto/null.h
@@ -8,9 +8,17 @@
 #define NULL_DIGEST_SIZE	0
 #define NULL_IV_SIZE		0
 
-struct crypto_blkcipher *crypto_get_default_null_skcipher(void);
+struct crypto_skcipher *crypto_get_default_null_skcipher(void);
 void crypto_put_default_null_skcipher(void);
-struct crypto_skcipher *crypto_get_default_null_skcipher2(void);
-void crypto_put_default_null_skcipher2(void);
+
+static inline struct crypto_skcipher *crypto_get_default_null_skcipher2(void)
+{
+	return crypto_get_default_null_skcipher();
+}
+
+static inline void crypto_put_default_null_skcipher2(void)
+{
+	crypto_put_default_null_skcipher();
+}
 
 #endif
