From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/7] [CRYPTO] api: Deprecate crypto_digest_* and crypto_alg_available
Date: Sat, 02 Sep 2006 21:06:55 +1000
Message-ID: <E1GJTKx-0001Fr-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46608 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751071AbWIBLGz
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:55 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Deprecate crypto_digest_* and crypto_alg_available

This patch marks the crypto_digest_* functions and crypto_alg_available
as deprecated.  They've been replaced by crypto_hash_* and crypto_has_*
respectively.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -241,9 +241,12 @@ int crypto_unregister_alg(struct crypto_
  * Algorithm query interface.
  */
 #ifdef CONFIG_CRYPTO
-int crypto_alg_available(const char *name, u32 flags);
+int crypto_alg_available(const char *name, u32 flags)
+	__deprecated_for_modules;
 int crypto_has_alg(const char *name, u32 type, u32 mask);
 #else
+static int crypto_alg_available(const char *name, u32 flags);
+	__deprecated_for_modules;
 static inline int crypto_alg_available(const char *name, u32 flags)
 {
 	return 0;
@@ -704,12 +707,15 @@ static inline void crypto_cipher_decrypt
 						dst, src);
 }
 
-void crypto_digest_init(struct crypto_tfm *tfm);
+void crypto_digest_init(struct crypto_tfm *tfm) __deprecated_for_modules;
 void crypto_digest_update(struct crypto_tfm *tfm,
-			  struct scatterlist *sg, unsigned int nsg);
-void crypto_digest_final(struct crypto_tfm *tfm, u8 *out);
+			  struct scatterlist *sg, unsigned int nsg)
+	__deprecated_for_modules;
+void crypto_digest_final(struct crypto_tfm *tfm, u8 *out)
+	__deprecated_for_modules;
 void crypto_digest_digest(struct crypto_tfm *tfm,
-			  struct scatterlist *sg, unsigned int nsg, u8 *out);
+			  struct scatterlist *sg, unsigned int nsg, u8 *out)
+	__deprecated_for_modules;
 
 static inline struct crypto_hash *__crypto_hash_cast(struct crypto_tfm *tfm)
 {
@@ -723,6 +729,8 @@ static inline struct crypto_hash *crypto
 	return __crypto_hash_cast(tfm);
 }
 
+static int crypto_digest_setkey(struct crypto_tfm *tfm, const u8 *key,
+				unsigned int keylen) __deprecated;
 static inline int crypto_digest_setkey(struct crypto_tfm *tfm,
                                        const u8 *key, unsigned int keylen)
 {

-- 
VGER BF report: H 0
