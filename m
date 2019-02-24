Return-Path: <SRS0=FcWR=Q7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C36C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04075204EC
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfBXGJX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Feb 2019 01:09:23 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:43828 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbfBXGJW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Feb 2019 01:09:22 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 91C1B72CCAF;
        Sun, 24 Feb 2019 09:09:03 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 5F17C4A4AE7;
        Sun, 24 Feb 2019 09:09:03 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/10] X.509: parse public key parameters from x509 for akcipher
Date:   Sun, 24 Feb 2019 09:08:23 +0300
Message-Id: <20190224060828.2527-6-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190224060828.2527-1-vt@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some public key algorithms (like EC-DSA) keep in parameters field
important data such as digest and curve OIDs (possibly more for
different EC-DSA variants). Thus, just setting a public key (as
for RSA) is not enough.

Introduce set_params() callback for akcipher which will be used to
pass BER encoded parameters array, with additional argument of
algorithm OID.

Rationale:

- For such keys just setting a public key without parameters is
  meaningless, so it would be possible to set parameters before
  crypto_akcipher_set_pub_key (and .set_pub_key) calls without
  needless change of API for RSA akcipher. Also, additional
  callback making it possible to pass parameters for
  crypto_akcipher_set_priv_key (and .set_priv_key).

- Algorithm OID is passed to be validated in .set_params callback,
  otherwise, it could have a wrong value.

- The callback is completely optional and if the driver doesn't need
  parameters, it may not implement it, such as for RSA drivers.

Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/asymmetric_keys/public_key.c       | 13 ++++++++++++
 crypto/asymmetric_keys/x509.asn1          |  2 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 31 ++++++++++++++++++++++++++++
 crypto/testmgr.c                          |  4 ++++
 crypto/testmgr.h                          |  3 +++
 include/crypto/akcipher.h                 | 34 +++++++++++++++++++++++++++++++
 include/crypto/public_key.h               |  4 ++++
 7 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 338f2b5352b1..d67374ef4f24 100644
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
@@ -115,6 +116,10 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
+	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
+					 pkey->paramlen);
+	if (ret)
+		goto error_free_tfm;
 	if (pkey->key_is_private)
 		ret = crypto_akcipher_set_priv_key(tfm,
 						   pkey->key, pkey->keylen);
@@ -179,6 +184,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	if (!req)
 		goto error_free_tfm;
 
+	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
+					 pkey->paramlen);
+	if (ret)
+		goto error_free_req;
 	if (pkey->key_is_private)
 		ret = crypto_akcipher_set_priv_key(tfm,
 						   pkey->key, pkey->keylen);
@@ -259,6 +268,10 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (!req)
 		goto error_free_tfm;
 
+	ret = crypto_akcipher_set_params(tfm, pkey->algo, pkey->params,
+					 pkey->paramlen);
+	if (ret)
+		goto error_free_req;
 	if (pkey->key_is_private)
 		ret = crypto_akcipher_set_priv_key(tfm,
 						   pkey->key, pkey->keylen);
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
index 991f4d735a4e..b2cdf2db1987 100644
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
@@ -401,6 +411,27 @@ int x509_note_subject(void *context, size_t hdrlen,
 }
 
 /*
+ * Extract the parameters for the public key
+ */
+int x509_note_params(void *context, size_t hdrlen,
+		     unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	/*
+	 * AlgorithmIdentifier is used three times in the x509, we should skip
+	 * first and ignore third, using second one which is after subject and
+	 * before subjectPublicKey.
+	 */
+	if (!ctx->cert->raw_subject || ctx->key)
+		return 0;
+	ctx->params = value - hdrlen;
+	ctx->params_size = vlen + hdrlen;
+	return 0;
+}
+
+/*
  * Extract the data for the public key algorithm
  */
 int x509_extract_key_data(void *context, size_t hdrlen,
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 924a1b9cf5ca..b5bafb59e1dc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2515,6 +2515,10 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 
 	crypto_init_wait(&wait);
 
+	err = crypto_akcipher_set_params(tfm, vecs->algo, vecs->params,
+					 vecs->param_len);
+	if (err)
+		goto free_req;
 	if (vecs->public_key_vec)
 		err = crypto_akcipher_set_pub_key(tfm, vecs->key,
 						  vecs->key_len);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 8f1d30b54a76..9c6a27588882 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -133,13 +133,16 @@ struct drbg_testvec {
 
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
index 28ffa9ef03a9..110f2bdc3a0d 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -13,6 +13,7 @@
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
 #include <linux/crypto.h>
+#include <linux/oid_registry.h>
 
 /**
  * struct akcipher_request - public key request
@@ -78,6 +79,9 @@ struct crypto_akcipher {
  * @set_priv_key: Function invokes the algorithm specific set private key
  *		function, which knows how to decode and interpret
  *		the BER encoded private key
+ * @set_params: Function invokes the algorithm specific set parameters
+ *		function, which knows how to decode and interpret
+ *		the BER encoded public key parameters
  * @max_size:	Function returns dest buffer size required for a given key.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -103,6 +107,8 @@ struct akcipher_alg {
 			   unsigned int keylen);
 	int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
 			    unsigned int keylen);
+	int (*set_params)(struct crypto_akcipher *tfm, enum OID algo,
+			  const void *params, unsigned int paramlen);
 	unsigned int (*max_size)(struct crypto_akcipher *tfm);
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
@@ -425,4 +431,32 @@ static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
 
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
+ * @params:	BER encoded key parameters
+ * @paramlen:	length of the parameters
+ *
+ * Note: should be called before crypto_akcipher_set_{pub,priv}_key()
+ *
+ * Return: zero on success or if no set_params is defined; error code in
+ * case of error
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
+	return 0;
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
-- 
2.11.0

