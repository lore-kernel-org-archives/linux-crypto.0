From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 01/10] crypto: rsa - generalize ASN.1 sequences
Date: Fri, 18 Mar 2016 20:31:58 +0200
Message-ID: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0070.outbound.protection.outlook.com ([157.56.110.70]:23796
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754987AbcCRSsN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:48:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use common ASN.1 sequences for all RSA implementations.

Give hardware RSA implementations the chance to use
the RSA's software implementation parser even if they
are likely to want to use raw integers.

The parser expects a context that contains at the first address
a struct rsa_asn1_action with function pointers to specific
parser actions (return MPI or raw integer keys), followed by
a key representation structure (for MPI or raw integers).

This approach has the advantage that users can select specific
parser actions by using a general parser with function pointers
to specific actions.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/rsa.c                  |  48 +++++++++--------
 crypto/rsa_helper.c           | 117 +++++++++++++++++++++++++++++-------------
 include/crypto/internal/rsa.h |  28 +++++++---
 3 files changed, 130 insertions(+), 63 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 77d737f..2d53ad8 100644
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
+	return &ctx->key;
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
@@ -251,15 +253,18 @@ static int rsa_check_key_length(unsigned int len)
 static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 			   unsigned int keylen)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_mpi_key *pkey = &ctx->key;
 	int ret;
 
-	ret = rsa_parse_pub_key(pkey, key, keylen);
+	set_rsa_pub_action(&ctx->action);
+
+	ret = rsa_parse_mpi_pub_key(ctx, key, keylen);
 	if (ret)
 		return ret;
 
 	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
-		rsa_free_key(pkey);
+		rsa_free_mpi_key(pkey);
 		ret = -EINVAL;
 	}
 	return ret;
@@ -268,15 +273,18 @@ static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 			    unsigned int keylen)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_mpi_key *pkey = &ctx->key;
 	int ret;
 
-	ret = rsa_parse_priv_key(pkey, key, keylen);
+	set_rsa_priv_action(&ctx->action);
+
+	ret = rsa_parse_mpi_priv_key(ctx, key, keylen);
 	if (ret)
 		return ret;
 
 	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
-		rsa_free_key(pkey);
+		rsa_free_mpi_key(pkey);
 		ret = -EINVAL;
 	}
 	return ret;
@@ -284,16 +292,16 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 
 static int rsa_max_size(struct crypto_akcipher *tfm)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 
 	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
 }
 
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	struct rsa_mpi_key *pkey = rsa_get_key(tfm);
 
-	rsa_free_key(pkey);
+	rsa_free_mpi_key(pkey);
 }
 
 static struct akcipher_alg rsa = {
@@ -310,7 +318,7 @@ static struct akcipher_alg rsa = {
 		.cra_driver_name = "rsa-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
-		.cra_ctxsize = sizeof(struct rsa_key),
+		.cra_ctxsize = sizeof(struct rsa_ctx),
 	},
 };
 
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index d226f48..1ed32af 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -21,7 +21,32 @@
 int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
-	struct rsa_key *key = context;
+	struct rsa_asn1_action *action = (struct rsa_asn1_action *)context;
+
+	return action->get_n(context, hdrlen, tag, value, vlen);
+}
+
+int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
+	      const void *value, size_t vlen)
+{
+	struct rsa_asn1_action *action = (struct rsa_asn1_action *)context;
+
+	return action->get_e(context, hdrlen, tag, value, vlen);
+}
+
+int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
+	      const void *value, size_t vlen)
+{
+	struct rsa_asn1_action *action = (struct rsa_asn1_action *)context;
+
+	return action->get_d(context, hdrlen, tag, value, vlen);
+}
+
+int rsa_get_mpi_n(void *context, size_t hdrlen, unsigned char tag,
+		  const void *value, size_t vlen)
+{
+	struct rsa_ctx *ctx = context;
+	struct rsa_mpi_key *key = &ctx->key;
 
 	key->n = mpi_read_raw_data(value, vlen);
 
@@ -39,10 +64,11 @@ int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	return 0;
 }
 
-int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
-	      const void *value, size_t vlen)
+int rsa_get_mpi_e(void *context, size_t hdrlen, unsigned char tag,
+		  const void *value, size_t vlen)
 {
-	struct rsa_key *key = context;
+	struct rsa_ctx *ctx = context;
+	struct rsa_mpi_key *key = &ctx->key;
 
 	key->e = mpi_read_raw_data(value, vlen);
 
@@ -52,10 +78,11 @@ int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
 	return 0;
 }
 
-int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
-	      const void *value, size_t vlen)
+int rsa_get_mpi_d(void *context, size_t hdrlen, unsigned char tag,
+		  const void *value, size_t vlen)
 {
-	struct rsa_key *key = context;
+	struct rsa_ctx *ctx = context;
+	struct rsa_mpi_key *key = &ctx->key;
 
 	key->d = mpi_read_raw_data(value, vlen);
 
@@ -73,7 +100,12 @@ int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 	return 0;
 }
 
-static void free_mpis(struct rsa_key *key)
+/**
+ * rsa_free_mpi_key() - frees rsa key allocated by rsa_parse_key()
+ *
+ * @rsa_mpi_key:	struct rsa_mpi_key key representation
+ */
+void rsa_free_mpi_key(struct rsa_mpi_key *key)
 {
 	mpi_free(key->n);
 	mpi_free(key->e);
@@ -82,68 +114,79 @@ static void free_mpis(struct rsa_key *key)
 	key->e = NULL;
 	key->d = NULL;
 }
+EXPORT_SYMBOL_GPL(rsa_free_mpi_key);
 
 /**
- * rsa_free_key() - frees rsa key allocated by rsa_parse_key()
- *
- * @rsa_key:	struct rsa_key key representation
- */
-void rsa_free_key(struct rsa_key *key)
-{
-	free_mpis(key);
-}
-EXPORT_SYMBOL_GPL(rsa_free_key);
-
-/**
- * rsa_parse_pub_key() - extracts an rsa public key from BER encoded buffer
- *			 and stores it in the provided struct rsa_key
+ * rsa_parse_mpi_pub_key() - extracts an RSA public key from BER encoded buffer
+ *			     and stores it in the provided context.
  *
- * @rsa_key:	struct rsa_key key representation
+ * @rsa_ctx:	RSA internal context
  * @key:	key in BER format
  * @key_len:	length of key
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
-		      unsigned int key_len)
+int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
+			  unsigned int key_len)
 {
+	struct rsa_mpi_key *rsa_key = &ctx->key;
 	int ret;
 
-	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
+	/* Free the old key if any */
+	rsa_free_mpi_key(rsa_key);
+
+	ret = asn1_ber_decoder(&rsapubkey_decoder, ctx, key, key_len);
 	if (ret < 0)
 		goto error;
 
 	return 0;
 error:
-	free_mpis(rsa_key);
+	rsa_free_mpi_key(rsa_key);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
+EXPORT_SYMBOL_GPL(rsa_parse_mpi_pub_key);
 
 /**
- * rsa_parse_pub_key() - extracts an rsa private key from BER encoded buffer
- *			 and stores it in the provided struct rsa_key
+ * rsa_parse_mpi_priv_key() - extracts an RSA private key from BER encoded
+ *			      buffer and stores it in the provided context.
  *
- * @rsa_key:	struct rsa_key key representation
+ * @rsa_ctx:	RSA internal context
  * @key:	key in BER format
  * @key_len:	length of key
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
-		       unsigned int key_len)
+int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, const void *key,
+			   unsigned int key_len)
 {
+	struct rsa_mpi_key *rsa_key = &ctx->key;
 	int ret;
 
-	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
+	/* Free the old key if any */
+	rsa_free_mpi_key(rsa_key);
+
+	ret = asn1_ber_decoder(&rsaprivkey_decoder, ctx, key, key_len);
 	if (ret < 0)
 		goto error;
 
 	return 0;
 error:
-	free_mpis(rsa_key);
+	rsa_free_mpi_key(rsa_key);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
+EXPORT_SYMBOL_GPL(rsa_parse_mpi_priv_key);
+
+void set_rsa_pub_action(struct rsa_asn1_action *action)
+{
+	action->get_e = rsa_get_mpi_e;
+	action->get_n = rsa_get_mpi_n;
+}
+EXPORT_SYMBOL_GPL(set_rsa_pub_action);
+
+void set_rsa_priv_action(struct rsa_asn1_action *action)
+{
+	action->get_d = rsa_get_mpi_d;
+	action->get_e = rsa_get_mpi_e;
+	action->get_n = rsa_get_mpi_n;
+}
+EXPORT_SYMBOL_GPL(set_rsa_priv_action);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index c7585bd..bf0f49d 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -14,19 +14,35 @@
 #define _RSA_HELPER_
 #include <linux/mpi.h>
 
-struct rsa_key {
+struct rsa_mpi_key {
 	MPI n;
 	MPI e;
 	MPI d;
 };
 
-int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
-		      unsigned int key_len);
+struct rsa_asn1_action {
+	int (*get_n)(void *context, size_t hdrlen, unsigned char tag,
+		     const void *value, size_t vlen);
+	int (*get_e)(void *context, size_t hdrlen, unsigned char tag,
+		     const void *value, size_t vlen);
+	int (*get_d)(void *context, size_t hdrlen, unsigned char tag,
+		     const void *value, size_t vlen);
+};
+
+struct rsa_ctx {
+	struct rsa_asn1_action action;
+	struct rsa_mpi_key key;
+};
+
+void rsa_free_mpi_key(struct rsa_mpi_key *key);
 
-int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
-		       unsigned int key_len);
+int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
+			  unsigned int key_len);
+int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, const void *key,
+			   unsigned int key_len);
 
-void rsa_free_key(struct rsa_key *rsa_key);
+void set_rsa_pub_action(struct rsa_asn1_action *action);
+void set_rsa_priv_action(struct rsa_asn1_action *action);
 
 extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
1.8.3.1
