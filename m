From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2] crypto: rsa - return raw integers for the ASN.1 parser
Date: Thu, 12 May 2016 18:00:33 +0300
Message-ID: <1463065233-13452-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0095.outbound.protection.outlook.com ([157.56.111.95]:28358
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbcELPQP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 11:16:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return kmalloced raw integers with no other processing.
The scope is to have only one ANS.1 parser for the RSA keys.

Update the RSA software implementation so that it does
the MPI conversion on top.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
Changes from initial patch:
- remove device related variables from the generic helper
- move struct rsa_mpi_key to rsa.c; the helper now handles
raw integers.
- cosmetics on error path for rsa_get_n,e,d functions

 crypto/rsa.c                  | 132 ++++++++++++++++++++++++++++++------------
 crypto/rsa_helper.c           | 111 +++++++++++++++++++++++++----------
 include/crypto/internal/rsa.h |  20 +++++--
 3 files changed, 190 insertions(+), 73 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 77d737f..c181ad9 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -14,12 +14,24 @@
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
 #include <crypto/algapi.h>
+#include <linux/mpi.h>
+
+struct rsa_mpi_key {
+	MPI n;
+	MPI e;
+	MPI d;
+};
+
+struct rsa_ctx {
+	struct rsa_key key;
+	struct rsa_mpi_key mpi_key;
+};
 
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
  * c = m^e mod n;
  */
-static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
+static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
 {
 	/* (1) Validate 0 <= m < n */
 	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
@@ -33,7 +45,7 @@ static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
  * RSADP function [RFC3447 sec 5.1.2]
  * m = c^d mod n;
  */
-static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
+static int _rsa_dec(const struct rsa_mpi_key *key, MPI m, MPI c)
 {
 	/* (1) Validate 0 <= c < n */
 	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
@@ -47,7 +59,7 @@ static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
  * RSASP1 function [RFC3447 sec 5.2.1]
  * s = m^d mod n
  */
-static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
+static int _rsa_sign(const struct rsa_mpi_key *key, MPI s, MPI m)
 {
 	/* (1) Validate 0 <= m < n */
 	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
@@ -61,7 +73,7 @@ static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
  * RSAVP1 function [RFC3447 sec 5.2.2]
  * m = s^e mod n;
  */
-static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
+static int _rsa_verify(const struct rsa_mpi_key *key, MPI m, MPI s)
 {
 	/* (1) Validate 0 <= s < n */
 	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->n) >= 0)
@@ -71,15 +83,17 @@ static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
 	return mpi_powm(m, s, key->e, key->n);
 }
 
-static inline struct rsa_key *rsa_get_key(struct crypto_akcipher *tfm)
+static inline struct rsa_mpi_key *rsa_get_key(struct crypto_akcipher *tfm)
 {
-	return akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	return &ctx->mpi_key;
 }
 
 static int rsa_enc(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI m, c = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -118,7 +132,7 @@ err_free_c:
 static int rsa_dec(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI c, m = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -156,7 +170,7 @@ err_free_m:
 static int rsa_sign(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI m, s = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -195,7 +209,7 @@ err_free_s:
 static int rsa_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI s, m = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -233,66 +247,107 @@ err_free_m:
 	return ret;
 }
 
-static int rsa_check_key_length(unsigned int len)
+static void rsa_free_mpi_key(struct rsa_mpi_key *key)
 {
-	switch (len) {
-	case 512:
-	case 1024:
-	case 1536:
-	case 2048:
-	case 3072:
-	case 4096:
-		return 0;
-	}
-
-	return -EINVAL;
+	mpi_free(key->d);
+	mpi_free(key->e);
+	mpi_free(key->n);
+	key->d = NULL;
+	key->e = NULL;
+	key->n = NULL;
 }
 
 static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 			   unsigned int keylen)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
+	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
 	int ret;
 
+	/* Free the old MPI key if any */
+	rsa_free_mpi_key(mpi_key);
+
 	ret = rsa_parse_pub_key(pkey, key, keylen);
 	if (ret)
 		return ret;
 
-	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
-		rsa_free_key(pkey);
-		ret = -EINVAL;
-	}
-	return ret;
+	mpi_key->e = mpi_read_raw_data(pkey->e, pkey->e_sz);
+	if (!mpi_key->e)
+		goto err;
+
+	mpi_key->n = mpi_read_raw_data(pkey->n, pkey->n_sz);
+	if (!mpi_key->n)
+		goto err;
+
+	return 0;
+
+err:
+	rsa_free_mpi_key(mpi_key);
+	rsa_free_key(pkey);
+	return -ENOMEM;
 }
 
 static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 			    unsigned int keylen)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
+	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
 	int ret;
 
+	/* Free the old MPI key if any */
+	rsa_free_mpi_key(mpi_key);
+
 	ret = rsa_parse_priv_key(pkey, key, keylen);
 	if (ret)
 		return ret;
 
-	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
-		rsa_free_key(pkey);
-		ret = -EINVAL;
-	}
-	return ret;
+	mpi_key->d = mpi_read_raw_data(pkey->d, pkey->n_sz);
+	if (!mpi_key->d)
+		goto err;
+
+	mpi_key->e = mpi_read_raw_data(pkey->e, pkey->e_sz);
+	if (!mpi_key->e)
+		goto err;
+
+	mpi_key->n = mpi_read_raw_data(pkey->n, pkey->n_sz);
+	if (!mpi_key->n)
+		goto err;
+
+	return 0;
+
+err:
+	rsa_free_mpi_key(mpi_key);
+	rsa_free_key(pkey);
+	return -ENOMEM;
 }
 
 static int rsa_max_size(struct crypto_akcipher *tfm)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
+
+	return pkey->n ? pkey->n_sz : -EINVAL;
+}
+
+static int rsa_init_tfm(struct crypto_akcipher *tfm)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
 
-	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+	pkey->flags = GFP_KERNEL;
+
+	return 0;
 }
 
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
+	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
 
+	rsa_free_mpi_key(mpi_key);
 	rsa_free_key(pkey);
 }
 
@@ -304,13 +359,14 @@ static struct akcipher_alg rsa = {
 	.set_priv_key = rsa_set_priv_key,
 	.set_pub_key = rsa_set_pub_key,
 	.max_size = rsa_max_size,
+	.init = rsa_init_tfm,
 	.exit = rsa_exit_tfm,
 	.base = {
 		.cra_name = "rsa",
 		.cra_driver_name = "rsa-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
-		.cra_ctxsize = sizeof(struct rsa_key),
+		.cra_ctxsize = sizeof(struct rsa_ctx),
 	},
 };
 
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index d226f48..95a4747 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -14,28 +14,56 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/slab.h>
 #include <crypto/internal/rsa.h>
 #include "rsapubkey-asn1.h"
 #include "rsaprivkey-asn1.h"
 
+static int rsa_check_key_length(unsigned int len)
+{
+	switch (len) {
+	case 512:
+	case 1024:
+	case 1536:
+	case 2048:
+	case 3072:
+	case 4096:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
 	struct rsa_key *key = context;
+	const char *ptr = value;
+	int ret;
 
-	key->n = mpi_read_raw_data(value, vlen);
-
-	if (!key->n)
-		return -ENOMEM;
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
 
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (mpi_get_size(key->n) != 256 &&
-			     mpi_get_size(key->n) != 384)) {
+	if (fips_enabled && (vlen != 256 && vlen != 384)) {
 		pr_err("RSA: key size not allowed in FIPS mode\n");
-		mpi_free(key->n);
-		key->n = NULL;
 		return -EINVAL;
 	}
+	/* invalid key size provided */
+	ret = rsa_check_key_length(vlen << 3);
+	if (ret)
+		return ret;
+
+	key->n = kzalloc(vlen, key->flags);
+	if (!key->n)
+		return -ENOMEM;
+
+	memcpy(key->n, ptr, vlen);
+
+	key->n_sz = vlen;
+
 	return 0;
 }
 
@@ -43,12 +71,24 @@ int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
 	struct rsa_key *key = context;
+	const char *ptr = value;
 
-	key->e = mpi_read_raw_data(value, vlen);
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
+
+	if (!key->n_sz || !vlen || vlen > key->n_sz)
+		return -EINVAL;
 
+	key->e = kzalloc(vlen, key->flags);
 	if (!key->e)
 		return -ENOMEM;
 
+	memcpy(key->e, ptr, vlen);
+
+	key->e_sz = vlen;
+
 	return 0;
 }
 
@@ -56,31 +96,29 @@ int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
 	struct rsa_key *key = context;
+	const char *ptr = value;
 
-	key->d = mpi_read_raw_data(value, vlen);
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
 
-	if (!key->d)
-		return -ENOMEM;
+	if (!key->n_sz || !vlen || vlen > key->n_sz)
+		return -EINVAL;
 
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (mpi_get_size(key->d) != 256 &&
-			     mpi_get_size(key->d) != 384)) {
+	if (fips_enabled && (vlen != 256 && vlen != 384)) {
 		pr_err("RSA: key size not allowed in FIPS mode\n");
-		mpi_free(key->d);
-		key->d = NULL;
 		return -EINVAL;
 	}
-	return 0;
-}
 
-static void free_mpis(struct rsa_key *key)
-{
-	mpi_free(key->n);
-	mpi_free(key->e);
-	mpi_free(key->d);
-	key->n = NULL;
-	key->e = NULL;
-	key->d = NULL;
+	key->d = kzalloc(vlen, key->flags);
+	if (!key->d)
+		return -ENOMEM;
+
+	memcpy(key->d, ptr, vlen);
+
+	return 0;
 }
 
 /**
@@ -90,7 +128,14 @@ static void free_mpis(struct rsa_key *key)
  */
 void rsa_free_key(struct rsa_key *key)
 {
-	free_mpis(key);
+	kzfree(key->d);
+	kfree(key->e);
+	kfree(key->n);
+	key->d = NULL;
+	key->e = NULL;
+	key->n = NULL;
+	key->n_sz = 0;
+	key->e_sz = 0;
 }
 EXPORT_SYMBOL_GPL(rsa_free_key);
 
@@ -109,14 +154,16 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 {
 	int ret;
 
-	free_mpis(rsa_key);
+	/* Free the old key if any */
+	rsa_free_key(rsa_key);
+
 	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
 	if (ret < 0)
 		goto error;
 
 	return 0;
 error:
-	free_mpis(rsa_key);
+	rsa_free_key(rsa_key);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
@@ -136,14 +183,16 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 {
 	int ret;
 
-	free_mpis(rsa_key);
+	/* Free the old key if any */
+	rsa_free_key(rsa_key);
+
 	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
 	if (ret < 0)
 		goto error;
 
 	return 0;
 error:
-	free_mpis(rsa_key);
+	rsa_free_key(rsa_key);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index c7585bd..bafb974 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -12,12 +12,24 @@
  */
 #ifndef _RSA_HELPER_
 #define _RSA_HELPER_
-#include <linux/mpi.h>
+#include <linux/types.h>
 
+/**
+ * rsa_key - RSA key structure
+ * @n           : RSA modulus raw byte stream
+ * @e           : RSA public exponent raw byte stream
+ * @d           : RSA private exponent raw byte stream
+ * @n_sz        : length in bytes of RSA modulus n
+ * @e_sz        : length in bytes of RSA public exponent
+ * @flags       : gfp_t key allocation flags
+ */
 struct rsa_key {
-	MPI n;
-	MPI e;
-	MPI d;
+	u8 *n;
+	u8 *e;
+	u8 *d;
+	size_t n_sz;
+	size_t e_sz;
+	gfp_t flags;
 };
 
 int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
-- 
1.8.3.1
