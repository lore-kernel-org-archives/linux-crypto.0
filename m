From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/30] crypto: null - Add new default null skcipher
Date: Tue, 12 Jul 2016 13:17:32 +0800
Message-ID: <E1bMq4a-0007OK-JC@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49998 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbcGLFRf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:35 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4a-0004Y5-Om
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:32 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Current the default null skcipher is actually a crypto_blkcipher.
This patch creates a synchronous crypto_skcipher version of the
null cipher which unfortunately has to settle for the name skcipher2.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_null.c  |   38 ++++++++++++++++++++++++++++++++++++++
 include/crypto/null.h |    2 ++
 2 files changed, 40 insertions(+)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 941c9a4..c3f6839 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -28,6 +28,8 @@
 static DEFINE_MUTEX(crypto_default_null_skcipher_lock);
 static struct crypto_blkcipher *crypto_default_null_skcipher;
 static int crypto_default_null_skcipher_refcnt;
+static struct crypto_skcipher *crypto_default_null_skcipher2;
+static int crypto_default_null_skcipher2_refcnt;
 
 static int null_compress(struct crypto_tfm *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen)
@@ -188,6 +190,42 @@ void crypto_put_default_null_skcipher(void)
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher);
 
+struct crypto_skcipher *crypto_get_default_null_skcipher2(void)
+{
+	struct crypto_skcipher *tfm;
+
+	mutex_lock(&crypto_default_null_skcipher_lock);
+	tfm = crypto_default_null_skcipher2;
+
+	if (!tfm) {
+		tfm = crypto_alloc_skcipher("ecb(cipher_null)",
+					    0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(tfm))
+			goto unlock;
+
+		crypto_default_null_skcipher2 = tfm;
+	}
+
+	crypto_default_null_skcipher2_refcnt++;
+
+unlock:
+	mutex_unlock(&crypto_default_null_skcipher_lock);
+
+	return tfm;
+}
+EXPORT_SYMBOL_GPL(crypto_get_default_null_skcipher2);
+
+void crypto_put_default_null_skcipher2(void)
+{
+	mutex_lock(&crypto_default_null_skcipher_lock);
+	if (!--crypto_default_null_skcipher2_refcnt) {
+		crypto_free_skcipher(crypto_default_null_skcipher2);
+		crypto_default_null_skcipher2 = NULL;
+	}
+	mutex_unlock(&crypto_default_null_skcipher_lock);
+}
+EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher2);
+
 static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
diff --git a/include/crypto/null.h b/include/crypto/null.h
index 06dc30d..dda87cb 100644
--- a/include/crypto/null.h
+++ b/include/crypto/null.h
@@ -10,5 +10,7 @@
 
 struct crypto_blkcipher *crypto_get_default_null_skcipher(void);
 void crypto_put_default_null_skcipher(void);
+struct crypto_skcipher *crypto_get_default_null_skcipher2(void);
+void crypto_put_default_null_skcipher2(void);
 
 #endif
