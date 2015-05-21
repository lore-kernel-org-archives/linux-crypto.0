From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/16] crypto: null - Add default null skcipher
Date: Thu, 21 May 2015 15:11:09 +0800
Message-ID: <E1YvKdJ-0005fd-UI@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59014 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbbEUHLM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:12 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdK-0002zr-9H
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:10 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a default null skcipher for users such as gcm
to perform copies on SG lists.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_null.c  |   39 +++++++++++++++++++++++++++++++++++++++
 include/crypto/null.h |    3 +++
 2 files changed, 42 insertions(+)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index a203191..941c9a4 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -25,6 +25,10 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 
+static DEFINE_MUTEX(crypto_default_null_skcipher_lock);
+static struct crypto_blkcipher *crypto_default_null_skcipher;
+static int crypto_default_null_skcipher_refcnt;
+
 static int null_compress(struct crypto_tfm *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen)
 {
@@ -149,6 +153,41 @@ MODULE_ALIAS_CRYPTO("compress_null");
 MODULE_ALIAS_CRYPTO("digest_null");
 MODULE_ALIAS_CRYPTO("cipher_null");
 
+struct crypto_blkcipher *crypto_get_default_null_skcipher(void)
+{
+	struct crypto_blkcipher *tfm;
+
+	mutex_lock(&crypto_default_null_skcipher_lock);
+	tfm = crypto_default_null_skcipher;
+
+	if (!tfm) {
+		tfm = crypto_alloc_blkcipher("ecb(cipher_null)", 0, 0);
+		if (IS_ERR(tfm))
+			goto unlock;
+
+		crypto_default_null_skcipher = tfm;
+	}
+
+	crypto_default_null_skcipher_refcnt++;
+
+unlock:
+	mutex_unlock(&crypto_default_null_skcipher_lock);
+
+	return tfm;
+}
+EXPORT_SYMBOL_GPL(crypto_get_default_null_skcipher);
+
+void crypto_put_default_null_skcipher(void)
+{
+	mutex_lock(&crypto_default_null_skcipher_lock);
+	if (!--crypto_default_null_skcipher_refcnt) {
+		crypto_free_blkcipher(crypto_default_null_skcipher);
+		crypto_default_null_skcipher = NULL;
+	}
+	mutex_unlock(&crypto_default_null_skcipher_lock);
+}
+EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher);
+
 static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
diff --git a/include/crypto/null.h b/include/crypto/null.h
index b7c864c..06dc30d 100644
--- a/include/crypto/null.h
+++ b/include/crypto/null.h
@@ -8,4 +8,7 @@
 #define NULL_DIGEST_SIZE	0
 #define NULL_IV_SIZE		0
 
+struct crypto_blkcipher *crypto_get_default_null_skcipher(void);
+void crypto_put_default_null_skcipher(void);
+
 #endif
