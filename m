Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:52898 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfAFNgu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 08:36:50 -0500
From: Vitaly Chikunov <vt@altlinux.org>
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for akcipher
Date: Sun,  6 Jan 2019 16:36:05 +0300
Message-Id: <20190106133608.820-2-vt@altlinux.org>
In-Reply-To: <20190106133608.820-1-vt@altlinux.org>
References: <20190106133608.820-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some public key algorithms (like ECDSA) keep in parameters field
important data such as digest and curve OIDs (possibly more for
different ECDSA variants). Thus, just setting a public key (as
for RSA) is not enough.

Introduce set_params() callback for akcipher which will be used to
pass DER encoded parameters array, with additional argument of
algorithm OID.

This is done with the intent of adding support for EC-RDSA (ISO/IEC
14888-3:2018, RFC 7091, and basically ECDSA variant) public keys (which
will be finally used in IMA subsystem). Thus, also oid_registry.h is
updated.

Rationale:

- For such keys just setting public key without parameters is
  meaningless, so it would be possible to add parameters in
  crypto_akcipher_set_pub_key (and .set_pub_key) calls. But, this will
  needlessly change API for RSA akcipher. Also, additional callback
  making it possible to pass parameters after
  crypto_akcipher_set_priv_key (and .set_priv_key) in the future.

- Algorithm OID is passed to be validated in .set_params callback,
  otherwise, it could have the wrong value.

- Particular algorithm OIDs are checked in x509_note_params, (because
  this is called from AlgorithmIdentifier (ASN.1) parser, which is
  called multiple times, as it's used multiple times in X.509
  certificate), to distinguish a public key call from a signature call.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/asymmetric_keys/public_key.c       | 16 +++++++++++++
 crypto/asymmetric_keys/x509.asn1          |  2 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 38 ++++++++++++++++++++++++++++---
 crypto/testmgr.c                          |  5 ++++
 crypto/testmgr.h                          |  3 +++
 include/crypto/akcipher.h                 | 33 +++++++++++++++++++++++++++
 include/crypto/public_key.h               |  4 ++++
 include/linux/oid_registry.h              |  6 +++++
 8 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index f5d85b47fcc6..3bc090b8adef 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -45,6 +45,7 @@ void public_key_free(struct public_key *key)
 {
 	if (key) {
 		kfree(key->key);
+		kfree(key->params);
 		kfree(key);
 	}
 }
@@ -124,6 +125,11 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	if (ret < 0)
 		goto error_free_tfm;
 
+	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
+					 pkey->paramlen);
+	if (ret)
+		goto error_free_tfm;
+
 	len = crypto_akcipher_maxsize(tfm);
 	info->key_size = len * 8;
 	info->max_data_size = len;
@@ -182,6 +188,11 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	if (ret)
 		goto error_free_req;
 
+	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
+					 pkey->paramlen);
+	if (ret)
+		goto error_free_req;
+
 	sg_init_one(&in_sg, in, params->in_len);
 	sg_init_one(&out_sg, out, params->out_len);
 	akcipher_request_set_crypt(req, &in_sg, &out_sg, params->in_len,
@@ -263,6 +274,11 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_req;
 
+	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
+					 pkey->paramlen);
+	if (ret)
+		goto error_free_req;
+
 	ret = -ENOMEM;
 	outlen = crypto_akcipher_maxsize(tfm);
 	output = kmalloc(outlen, GFP_KERNEL);
diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
index aae0cde414e2..5c9f4e4a5231 100644
--- a/crypto/asymmetric_keys/x509.asn1
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -22,7 +22,7 @@ CertificateSerialNumber ::= INTEGER
 
 AlgorithmIdentifier ::= SEQUENCE {
 	algorithm		OBJECT IDENTIFIER ({ x509_note_OID }),
-	parameters		ANY OPTIONAL
+	parameters		ANY OPTIONAL ({ x509_note_params })
 }
 
 Name ::= SEQUENCE OF RelativeDistinguishedName
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 991f4d735a4e..202a9dc66c93 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -26,6 +26,9 @@ struct x509_parse_context {
 	const void	*cert_start;		/* Start of cert content */
 	const void	*key;			/* Key data */
 	size_t		key_size;		/* Size of key data */
+	const void	*params;		/* Key parameters */
+	size_t		params_size;		/* Size of key parameters */
+	enum OID	key_algo;		/* Public key algorithm */
 	enum OID	last_oid;		/* Last OID encountered */
 	enum OID	algo_oid;		/* Algorithm OID */
 	unsigned char	nr_mpi;			/* Number of MPIs stored */
@@ -109,6 +112,13 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 
 	cert->pub->keylen = ctx->key_size;
 
+	cert->pub->params = kmemdup(ctx->params, ctx->params_size, GFP_KERNEL);
+	if (!cert->pub->params)
+		goto error_decode;
+
+	cert->pub->paramlen = ctx->params_size;
+	cert->pub->algo = ctx->key_algo;
+
 	/* Grab the signature bits */
 	ret = x509_get_sig_params(cert);
 	if (ret < 0)
@@ -401,6 +411,23 @@ int x509_note_subject(void *context, size_t hdrlen,
 }
 
 /*
+ * Extract parameters for particular keys
+ */
+int x509_note_params(void *context, size_t hdrlen,
+		     unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	if (ctx->last_oid != OID_gost2012PublicKey256 &&
+	    ctx->last_oid != OID_gost2012PublicKey512)
+		return 0;
+	ctx->params = value;
+	ctx->params_size = vlen;
+	return 0;
+}
+
+/*
  * Extract the data for the public key algorithm
  */
 int x509_extract_key_data(void *context, size_t hdrlen,
@@ -409,16 +436,21 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 {
 	struct x509_parse_context *ctx = context;
 
-	if (ctx->last_oid != OID_rsaEncryption)
+	ctx->key_algo = ctx->last_oid;
+	if (ctx->last_oid == OID_rsaEncryption)
+		ctx->cert->pub->pkey_algo = "rsa";
+	else if (ctx->last_oid == OID_gost2012PublicKey256 ||
+		 ctx->last_oid == OID_gost2012PublicKey512)
+		ctx->cert->pub->pkey_algo = "ecrdsa";
+	else
 		return -ENOPKG;
 
-	ctx->cert->pub->pkey_algo = "rsa";
-
 	/* Discard the BIT STRING metadata */
 	if (vlen < 1 || *(const u8 *)value != 0)
 		return -EBADMSG;
 	ctx->key = value + 1;
 	ctx->key_size = vlen - 1;
+
 	return 0;
 }
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f684a414acb..a030526a6609 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2257,6 +2257,11 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	if (err)
 		goto free_req;
 
+	err = crypto_akcipher_set_params(tfm, vecs->algo, vecs->params,
+					 vecs->param_len);
+	if (err)
+		goto free_req;
+
 	err = -ENOMEM;
 	out_len_max = crypto_akcipher_maxsize(tfm);
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e7e56a8febbc..9855da080eaf 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -124,13 +124,16 @@ struct drbg_testvec {
 
 struct akcipher_testvec {
 	const unsigned char *key;
+	const unsigned char *params;
 	const unsigned char *m;
 	const unsigned char *c;
 	unsigned int key_len;
+	unsigned int param_len;
 	unsigned int m_size;
 	unsigned int c_size;
 	bool public_key_vec;
 	bool siggen_sigver_test;
+	enum OID algo;
 };
 
 struct kpp_testvec {
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index afac71119396..84d68dfb551a 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -13,6 +13,7 @@
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
 #include <linux/crypto.h>
+#include <linux/oid_registry.h>
 
 /**
  * struct akcipher_request - public key request
@@ -73,6 +74,9 @@ struct crypto_akcipher {
  * @set_priv_key: Function invokes the algorithm specific set private key
  *		function, which knows how to decode and interpret
  *		the BER encoded private key
+ * @set_params: Function invokes the algorithm specific set parameters
+ *		function, which knows how to decode and interpret
+ *		the DER encoded public key parameters
  * @max_size:	Function returns dest buffer size required for a given key.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -98,6 +102,8 @@ struct akcipher_alg {
 			   unsigned int keylen);
 	int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
 			    unsigned int keylen);
+	int (*set_params)(struct crypto_akcipher *tfm, enum OID algo,
+			  const void *params, unsigned int paramlen);
 	unsigned int (*max_size)(struct crypto_akcipher *tfm);
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
@@ -452,4 +458,31 @@ static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
 
 	return alg->set_priv_key(tfm, key, keylen);
 }
+
+/**
+ * crypto_akcipher_set_params() - Invoke set parameters operation
+ *
+ * Function invokes the algorithm specific set parameters function, which
+ * knows how to decode and interpret the encoded parameters
+ *
+ * @tfm:	tfm handle
+ * @algo:	OID of the key algorithm
+ * @params:	DER encoded key parameters
+ * @paramlen:	length of the parameters
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_set_params(struct crypto_akcipher *tfm,
+					     enum OID algo,
+					     const void *params,
+					     unsigned int paramlen)
+{
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	if (alg->set_params)
+		return alg->set_params(tfm, algo, params, paramlen);
+	if (!params || !paramlen)
+		return 0;
+	return -ENOTSUPP;
+}
 #endif
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index be626eac9113..712fe1214b5f 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -15,6 +15,7 @@
 #define _LINUX_PUBLIC_KEY_H
 
 #include <linux/keyctl.h>
+#include <linux/oid_registry.h>
 
 /*
  * Cryptographic data for the public-key subtype of the asymmetric key type.
@@ -25,6 +26,9 @@
 struct public_key {
 	void *key;
 	u32 keylen;
+	enum OID algo;
+	void *params;
+	u32 paramlen;
 	bool key_is_private;
 	const char *id_type;
 	const char *pkey_algo;
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index d2fa9ca42e9a..e2e323fd4826 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -93,6 +93,12 @@ enum OID {
 	OID_authorityKeyIdentifier,	/* 2.5.29.35 */
 	OID_extKeyUsage,		/* 2.5.29.37 */
 
+	/* EC-RDSA */
+	OID_gost2012PublicKey256,	/* 1.2.643.7.1.1.1.1 */
+	OID_gost2012PublicKey512,	/* 1.2.643.7.1.1.1.2 */
+	OID_gost2012Signature256,	/* 1.2.643.7.1.1.3.2 */
+	OID_gost2012Signature512,	/* 1.2.643.7.1.1.3.3 */
+
 	OID__NR
 };
 
-- 
2.11.0
