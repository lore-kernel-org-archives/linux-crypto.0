From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 09 Sep 2015 09:15:20 -0700
Message-ID: <20150909161520.2828.35852.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbbIIQRJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:17:09 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Setkey function has been split into set_priv_key and set_pub_key.
Akcipher requests takes sgl for src and dst instead of void *.
Users of the API need to be disabled so that the build works fine
after this patch.
They will be enabled in subsequent patches.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Makefile                        |    5 --
 crypto/testmgr.c                       |    4 +
 drivers/crypto/qat/qat_common/Makefile |    2 -
 include/crypto/akcipher.h              |   99 ++++++++++++++++++++++----------
 4 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index e2c5981..65e91da 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -34,11 +34,6 @@ obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 $(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
 clean-files += rsakey-asn1.c rsakey-asn1.h
 
-rsa_generic-y := rsakey-asn1.o
-rsa_generic-y += rsa.o
-rsa_generic-y += rsa_helper.o
-obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
-
 cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 35c2de1..2f2b66e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1835,6 +1835,7 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 
 }
 
+#if 0
 static int do_test_rsa(struct crypto_akcipher *tfm,
 		       struct akcipher_testvec *vecs)
 {
@@ -1975,6 +1976,7 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 	crypto_free_akcipher(tfm);
 	return err;
 }
+#endif
 
 static int alg_test_null(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
@@ -3611,7 +3613,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rsa",
-		.test = alg_test_akcipher,
+		.test = alg_test_null,
 		.fips_allowed = 1,
 		.suite = {
 			.akcipher = {
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index df20a9d..ba5abdb 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -13,8 +13,6 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	qat_crypto.o \
 	qat_algs.o \
-	qat_rsakey-asn1.o \
-	qat_asym_algs.o \
 	qat_uclo.o \
 	qat_hal.o
 
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 69d163e..7380e25 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -13,28 +13,25 @@
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 
 /**
  * struct akcipher_request - public key request
  *
  * @base:	Common attributes for async crypto requests
- * @src:	Pointer to memory containing the input parameters
- *		The format of the parameter(s) is expeted to be Octet String
- * @dst:	Pointer to memory whare the result will be stored
- * @src_len:	Size of the input parameter
- * @dst_len:	Size of the output buffer. It needs to be at leaset
- *		as big as the expected result depending	on the operation
- *		After operation it will be updated with the acctual size of the
- *		result. In case of error, where the dst_len was insufficient,
+ * @src:	Source data
+ * @dst:	Destination data
+ * @out_len:	Size of the result. After operation it will be updated with
+ *		the acctual size of the data stored in the dst.
+ *		In case of error, where the dst sgl size was insufficient,
  *		it will be updated to the size required for the operation.
  * @__ctx:	Start of private context data
  */
 struct akcipher_request {
 	struct crypto_async_request base;
-	void *src;
-	void *dst;
-	unsigned int src_len;
-	unsigned int dst_len;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	unsigned int out_len;
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -67,8 +64,13 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @setkey:	Function invokes the algorithm specific set key function, which
- *		knows how to decode and interpret the BER encoded key
+ * @set_pub_key: Function invokes the algorithm specific set public key
+ *		function, which knows how to decode and interpret
+ *		the BER encoded public key
+ * @set_priv_key: Function invokes the algorithm specific set private key
+ *		function, which knows how to decode and interpret
+ *		the BER encoded private key
+ * @get_len:	Function returns minimum dest buffer size for a given key.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -89,8 +91,11 @@ struct akcipher_alg {
 	int (*verify)(struct akcipher_request *req);
 	int (*encrypt)(struct akcipher_request *req);
 	int (*decrypt)(struct akcipher_request *req);
-	int (*setkey)(struct crypto_akcipher *tfm, const void *key,
-		      unsigned int keylen);
+	int (*set_pub_key)(struct crypto_akcipher *tfm, const void *key,
+			   unsigned int keylen);
+	int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
+			    unsigned int keylen);
+	int (*get_len)(struct crypto_akcipher *tfm);
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
 
@@ -229,21 +234,31 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
  * Sets parameters required by crypto operation
  *
  * @req:	public key request
- * @src:	ptr to input parameter
- * @dst:	ptr of output parameter
- * @src_len:	size of the input buffer
- * @dst_len:	size of the output buffer. It will be updated by the
- *		implementation to reflect the acctual size of the result
+ * @src:	ptr to input scatter list
+ * @dst:	ptr to output scatter list
  */
 static inline void akcipher_request_set_crypt(struct akcipher_request *req,
-					      void *src, void *dst,
-					      unsigned int src_len,
-					      unsigned int dst_len)
+					      struct scatterlist *src,
+					      struct scatterlist *dst)
 {
 	req->src = src;
 	req->dst = dst;
-	req->src_len = src_len;
-	req->dst_len = dst_len;
+}
+
+/**
+ * crypto_akcipher_get_len() -- Get minimum len for output buffer
+ *
+ * Function returns minimum dest buffer size for a given key
+ *
+ * @tfm:	AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
+ *
+ * Return: minimum len for output buffer or error code in key hasn't been set
+ */
+static inline int crypto_akcipher_get_len(struct crypto_akcipher *tfm)
+{
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->get_len(tfm);
 }
 
 /**
@@ -319,22 +334,44 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_setkey() -- Invoke public key setkey operation
+ * crypto_akcipher_set_pub_key() -- Invoke set public key operation
+ *
+ * Function invokes the algorithm specific set key function, which knows
+ * how to decode and interpret the encoded key
+ *
+ * @tfm:	tfm handle
+ * @key:	BER encoded public key
+ * @keylen:	length of the key
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
+					      const void *key,
+					      unsigned int keylen)
+{
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->set_pub_key(tfm, key, keylen);
+}
+
+/**
+ * crypto_akcipher_set_priv_key() -- Invoke set private key operation
  *
  * Function invokes the algorithm specific set key function, which knows
  * how to decode and interpret the encoded key
  *
  * @tfm:	tfm handle
- * @key:	BER encoded private or public key
+ * @key:	BER encoded private key
  * @keylen:	length of the key
  *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm, void *key,
-					 unsigned int keylen)
+static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
+					       const void *key,
+					       unsigned int keylen)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
-	return alg->setkey(tfm, key, keylen);
+	return alg->set_priv_key(tfm, key, keylen);
 }
 #endif
