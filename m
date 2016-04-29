From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH] crypto: rsa - return raw integer for the ASN.1 parser
Date: Fri, 29 Apr 2016 15:51:46 +0300
Message-ID: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0063.outbound.protection.outlook.com ([207.46.100.63]:42336
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753003AbcD2Mv7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 08:51:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return the raw integer with no other processing.
The scope is to have only one ANS.1 parser for the RSA keys.

Update the RSA software implementation so that it does
the MPI conversion on top.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/rsa.c                  | 122 ++++++++++++++---------
 crypto/rsa_helper.c           | 224 ++++++++++++++++++++++++++++++++----------
 include/crypto/internal/rsa.h |  41 +++++++-
 3 files changed, 287 insertions(+), 100 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 77d737f..4459cb7 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -19,7 +19,7 @@
  * RSAEP function [RFC3447 sec 5.1.1]
  * c = m^e mod n;
  */
-static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
+static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
 {
 	/* (1) Validate 0 <= m < n */
 	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
@@ -33,7 +33,7 @@ static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
  * RSADP function [RFC3447 sec 5.1.2]
  * m = c^d mod n;
  */
-static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
+static int _rsa_dec(const struct rsa_mpi_key *key, MPI m, MPI c)
 {
 	/* (1) Validate 0 <= c < n */
 	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
@@ -47,7 +47,7 @@ static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
  * RSASP1 function [RFC3447 sec 5.2.1]
  * s = m^d mod n
  */
-static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
+static int _rsa_sign(const struct rsa_mpi_key *key, MPI s, MPI m)
 {
 	/* (1) Validate 0 <= m < n */
 	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
@@ -61,7 +61,7 @@ static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
  * RSAVP1 function [RFC3447 sec 5.2.2]
  * m = s^e mod n;
  */
-static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
+static int _rsa_verify(const struct rsa_mpi_key *key, MPI m, MPI s)
 {
 	/* (1) Validate 0 <= s < n */
 	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->n) >= 0)
@@ -71,15 +71,17 @@ static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
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
@@ -118,7 +120,7 @@ err_free_c:
 static int rsa_dec(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI c, m = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -156,7 +158,7 @@ err_free_m:
 static int rsa_sign(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI m, s = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -195,7 +197,7 @@ err_free_s:
 static int rsa_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
+	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 	MPI s, m = mpi_alloc(0);
 	int ret = 0;
 	int sign;
@@ -233,67 +235,98 @@ err_free_m:
 	return ret;
 }
 
-static int rsa_check_key_length(unsigned int len)
-{
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
-}
-
 static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 			   unsigned int keylen)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
+	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
 	int ret;
 
-	ret = rsa_parse_pub_key(pkey, key, keylen);
+	/* Free the old MPI key if any */
+	rsa_free_mpi_key(mpi_key);
+
+	ret = rsa_parse_pub_key(ctx, key, keylen);
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
+	rsa_free_key(ctx->dev, pkey);
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
 
-	ret = rsa_parse_priv_key(pkey, key, keylen);
+	/* Free the old MPI key if any */
+	rsa_free_mpi_key(mpi_key);
+
+	ret = rsa_parse_priv_key(ctx, key, keylen);
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
+	rsa_free_key(ctx->dev, pkey);
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
 
-	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+static int rsa_init_tfm(struct crypto_akcipher *tfm)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *pkey = &ctx->key;
+
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
 
-	rsa_free_key(pkey);
+	rsa_free_mpi_key(mpi_key);
+	rsa_free_key(ctx->dev, pkey);
 }
 
 static struct akcipher_alg rsa = {
@@ -304,13 +337,14 @@ static struct akcipher_alg rsa = {
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
index d226f48..492f37f 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -14,136 +14,256 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/device.h>
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
-	struct rsa_key *key = context;
+	struct rsa_ctx *ctx = context;
+	struct rsa_key *key = &ctx->key;
+	const char *ptr = value;
+	int ret = -EINVAL;
 
-	key->n = mpi_read_raw_data(value, vlen);
-
-	if (!key->n)
-		return -ENOMEM;
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
 
+	key->n_sz = vlen;
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (mpi_get_size(key->n) != 256 &&
-			     mpi_get_size(key->n) != 384)) {
-		pr_err("RSA: key size not allowed in FIPS mode\n");
-		mpi_free(key->n);
-		key->n = NULL;
-		return -EINVAL;
+	if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
+		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
+		goto err;
 	}
+	/* invalid key size provided */
+	ret = rsa_check_key_length(key->n_sz << 3);
+	if (ret)
+		goto err;
+
+	if (key->coherent)
+		key->n = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_n,
+					     key->flags);
+	else
+		key->n = kzalloc(key->n_sz, key->flags);
+
+	if (!key->n) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	memcpy(key->n, ptr, key->n_sz);
+
 	return 0;
+err:
+	key->n_sz = 0;
+	key->n = NULL;
+	return ret;
 }
 
 int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
-	struct rsa_key *key = context;
+	struct rsa_ctx *ctx = context;
+	struct rsa_key *key = &ctx->key;
+	const char *ptr = value;
+	size_t offset = 0;
+
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
 
-	key->e = mpi_read_raw_data(value, vlen);
+	key->e_sz = vlen;
+
+	if (!key->n_sz || !vlen || vlen > key->n_sz) {
+		key->e = NULL;
+		return -EINVAL;
+	}
+
+	if (key->coherent) {
+		key->e = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_e,
+					     key->flags);
+		offset = key->n_sz - vlen;
+	} else {
+		key->e = kzalloc(key->e_sz, key->flags);
+	}
 
 	if (!key->e)
 		return -ENOMEM;
 
+	memcpy(key->e + offset, ptr, vlen);
+
 	return 0;
 }
 
 int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
-	struct rsa_key *key = context;
+	struct rsa_ctx *ctx = context;
+	struct rsa_key *key = &ctx->key;
+	const char *ptr = value;
+	size_t offset = 0;
+	int ret = -EINVAL;
 
-	key->d = mpi_read_raw_data(value, vlen);
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
 
-	if (!key->d)
-		return -ENOMEM;
+	if (!key->n_sz || !vlen || vlen > key->n_sz)
+		goto err;
 
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (mpi_get_size(key->d) != 256 &&
-			     mpi_get_size(key->d) != 384)) {
-		pr_err("RSA: key size not allowed in FIPS mode\n");
-		mpi_free(key->d);
-		key->d = NULL;
-		return -EINVAL;
+	if (fips_enabled && (vlen != 256 && vlen != 384)) {
+		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
+		goto err;
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
+	if (key->coherent) {
+		key->d = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_d,
+					     key->flags);
+		offset = key->n_sz - vlen;
+	} else {
+		key->d = kzalloc(key->n_sz, key->flags);
+	}
+
+	if (!key->d) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	memcpy(key->d + offset, ptr, vlen);
+
+	return 0;
+err:
 	key->d = NULL;
+	return ret;
 }
 
-/**
- * rsa_free_key() - frees rsa key allocated by rsa_parse_key()
- *
- * @rsa_key:	struct rsa_key key representation
- */
-void rsa_free_key(struct rsa_key *key)
+void rsa_free_key(struct device *dev, struct rsa_key *key)
 {
-	free_mpis(key);
+	if (key->coherent) {
+		if (key->d) {
+			memset(key->d, 0, key->n_sz);
+			dma_free_coherent(dev, key->n_sz, key->d, key->dma_d);
+		}
+		if (key->e)
+			dma_free_coherent(dev, key->n_sz, key->e, key->dma_e);
+		if (key->n)
+			dma_free_coherent(dev, key->n_sz, key->n, key->dma_n);
+	} else {
+		kzfree(key->d);
+		kfree(key->e);
+		kfree(key->n);
+	}
+
+	key->d = NULL;
+	key->e = NULL;
+	key->n = NULL;
+	key->n_sz = 0;
+	key->e_sz = 0;
 }
 EXPORT_SYMBOL_GPL(rsa_free_key);
 
 /**
  * rsa_parse_pub_key() - extracts an rsa public key from BER encoded buffer
- *			 and stores it in the provided struct rsa_key
+ *                       and stores it in the provided struct rsa_key.
  *
- * @rsa_key:	struct rsa_key key representation
+ * @rsa_ctx:	RSA internal context
  * @key:	key in BER format
  * @key_len:	length of key
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
+int rsa_parse_pub_key(struct rsa_ctx *ctx, const void *key,
 		      unsigned int key_len)
 {
+	struct rsa_key *rsa_key = &ctx->key;
 	int ret;
 
-	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
+	/* Free the old key if any */
+	rsa_free_key(ctx->dev, rsa_key);
+
+	ret = asn1_ber_decoder(&rsapubkey_decoder, ctx, key, key_len);
 	if (ret < 0)
 		goto error;
 
+	if (!rsa_key->n || !rsa_key->e) {
+		/* Invalid key provided */
+		ret = -EINVAL;
+		goto error;
+	}
+
 	return 0;
 error:
-	free_mpis(rsa_key);
+	rsa_free_key(ctx->dev, rsa_key);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
 
 /**
- * rsa_parse_pub_key() - extracts an rsa private key from BER encoded buffer
- *			 and stores it in the provided struct rsa_key
+ * rsa_parse_priv_key() - extracts an rsa private key from BER encoded buffer
+ *                        and stores it in the provided struct rsa_key.
  *
- * @rsa_key:	struct rsa_key key representation
+ * @rsa_ctx:	RSA internal context
  * @key:	key in BER format
  * @key_len:	length of key
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+int rsa_parse_priv_key(struct rsa_ctx *ctx, const void *key,
 		       unsigned int key_len)
 {
+	struct rsa_key *rsa_key = &ctx->key;
 	int ret;
 
-	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
+	/* Free the old key if any */
+	rsa_free_key(ctx->dev, rsa_key);
+
+	ret = asn1_ber_decoder(&rsaprivkey_decoder, ctx, key, key_len);
 	if (ret < 0)
 		goto error;
 
+	if (!rsa_key->n || !rsa_key->e || !rsa_key->d) {
+		/* Invalid key provided */
+		ret = -EINVAL;
+		goto error;
+	}
+
 	return 0;
 error:
-	free_mpis(rsa_key);
+	rsa_free_key(ctx->dev, rsa_key);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
+
+void rsa_free_mpi_key(struct rsa_mpi_key *key)
+{
+	mpi_free(key->n);
+	mpi_free(key->e);
+	mpi_free(key->d);
+	key->n = NULL;
+	key->e = NULL;
+	key->d = NULL;
+}
+EXPORT_SYMBOL_GPL(rsa_free_mpi_key);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index c7585bd..a0a7431 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -14,19 +14,52 @@
 #define _RSA_HELPER_
 #include <linux/mpi.h>
 
+/**
+ * rsa_key - RSA key structure
+ * @n           : RSA modulus raw byte stream
+ * @e           : RSA public exponent raw byte stream
+ * @d           : RSA private exponent raw byte stream
+ * @dma_n       : DMA address of RSA modulus
+ * @dma_e       : DMA address of RSA public exponent
+ * @dma_d       : DMA address of RSA private exponent
+ * @n_sz        : length in bytes of RSA modulus n
+ * @e_sz        : length in bytes of RSA public exponent
+ * @coherent    : set true to enforce software coherency for all key members
+ * @flags       : gfp_t key allocation flags
+ */
 struct rsa_key {
+	u8 *n;
+	u8 *e;
+	u8 *d;
+	dma_addr_t dma_n;
+	dma_addr_t dma_e;
+	dma_addr_t dma_d;
+	size_t n_sz;
+	size_t e_sz;
+	bool coherent;
+	gfp_t flags;
+};
+
+struct rsa_mpi_key {
 	MPI n;
 	MPI e;
 	MPI d;
 };
 
-int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
-		      unsigned int key_len);
+struct rsa_ctx {
+	struct rsa_key key;
+	struct rsa_mpi_key mpi_key;
+	struct device *dev;
+};
+
+void rsa_free_key(struct device *dev, struct rsa_key *key);
 
-int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+int rsa_parse_pub_key(struct rsa_ctx *ctx, const void *key,
+		      unsigned int key_len);
+int rsa_parse_priv_key(struct rsa_ctx *ctx, const void *key,
 		       unsigned int key_len);
 
-void rsa_free_key(struct rsa_key *rsa_key);
+void rsa_free_mpi_key(struct rsa_mpi_key *key);
 
 extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
1.8.3.1
