Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8CFC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6AF20818
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfDKPwE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:52:04 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44654 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfDKPwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 11:52:04 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id A43AF72CC61;
        Thu, 11 Apr 2019 18:51:57 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 747B24A4A2A;
        Thu, 11 Apr 2019 18:51:57 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v9 05/10] X.509: parse public key parameters from x509 for akcipher
Date:   Thu, 11 Apr 2019 18:51:17 +0300
Message-Id: <20190411155122.13245-6-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190411155122.13245-1-vt@altlinux.org>
References: <20190411155122.13245-1-vt@altlinux.org>
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

Append parameters into the key stream for akcipher_set_{pub,priv}_key.
Appended data is: (u32) algo OID, (u32) parameters length, parameters
data.

This does not affect current akcipher API nor RSA ciphers (they could
ignore it). Idea of appending parameters to the key stream is by Herbert
Xu.

Cc: David Howells <dhowells@redhat.com>
Cc: Denis Kenzior <denkenz@gmail.com>
Cc: keyrings@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/asymmetric_keys/asym_tpm.c         |  9 +++-
 crypto/asymmetric_keys/public_key.c       | 72 ++++++++++++++++++++++++-------
 crypto/asymmetric_keys/x509.asn1          |  2 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 31 +++++++++++++
 crypto/testmgr.c                          | 24 +++++++++--
 crypto/testmgr.h                          |  5 +++
 include/crypto/akcipher.h                 | 18 ++++----
 include/crypto/public_key.h               |  4 ++
 8 files changed, 136 insertions(+), 29 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 402fc34ca044..76d2ce3a1b5b 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -276,6 +276,10 @@ static int tpm_sign(struct tpm_buf *tb,
 
 	return datalen;
 }
+
+/* Room to fit two u32 zeros for algo id and parameters length. */
+#define SETKEY_PARAMS_SIZE (sizeof(u32) * 2)
+
 /*
  * Maximum buffer size for the BER/DER encoded public key.  The public key
  * is of the form SEQUENCE { INTEGER n, INTEGER e } where n is a maximum 2048
@@ -286,8 +290,9 @@ static int tpm_sign(struct tpm_buf *tb,
  *     - 257 bytes of n
  *   - max 2 bytes for INTEGER e type/length
  *     - 3 bytes of e
+ * - 4+4 of zeros for set_pub_key parameters (SETKEY_PARAMS_SIZE)
  */
-#define PUB_KEY_BUF_SIZE (4 + 4 + 257 + 2 + 3)
+#define PUB_KEY_BUF_SIZE (4 + 4 + 257 + 2 + 3 + SETKEY_PARAMS_SIZE)
 
 /*
  * Provide a part of a description of the key for /proc/keys.
@@ -364,6 +369,8 @@ static uint32_t derive_pub_key(const void *pub_key, uint32_t len, uint8_t *buf)
 	cur = encode_tag_length(cur, 0x02, sizeof(e));
 	memcpy(cur, e, sizeof(e));
 	cur += sizeof(e);
+	/* Zero parameters to satisfy set_pub_key ABI. */
+	memset(cur, 0, SETKEY_PARAMS_SIZE);
 
 	return cur - buf;
 }
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 33093b7bcc47..77e0ae7840ff 100644
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
@@ -94,6 +95,12 @@ int software_key_determine_akcipher(const char *encoding,
 	return -ENOPKG;
 }
 
+static u8 *pkey_pack_u32(u8 *dst, u32 val)
+{
+	memcpy(dst, &val, sizeof(val));
+	return dst + sizeof(val);
+}
+
 /*
  * Query information about a key.
  */
@@ -103,6 +110,7 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	struct crypto_akcipher *tfm;
 	struct public_key *pkey = params->key->payload.data[asym_crypto];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
+	u8 *key, *ptr;
 	int ret, len;
 
 	ret = software_key_determine_akcipher(params->encoding,
@@ -115,14 +123,22 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
+	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
+		      GFP_KERNEL);
+	if (!key)
+		goto error_free_tfm;
+	memcpy(key, pkey->key, pkey->keylen);
+	ptr = key + pkey->keylen;
+	ptr = pkey_pack_u32(ptr, pkey->algo);
+	ptr = pkey_pack_u32(ptr, pkey->paramlen);
+	memcpy(ptr, pkey->params, pkey->paramlen);
+
 	if (pkey->key_is_private)
-		ret = crypto_akcipher_set_priv_key(tfm,
-						   pkey->key, pkey->keylen);
+		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
 	else
-		ret = crypto_akcipher_set_pub_key(tfm,
-						  pkey->key, pkey->keylen);
+		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
 	if (ret < 0)
-		goto error_free_tfm;
+		goto error_free_key;
 
 	len = crypto_akcipher_maxsize(tfm);
 	info->key_size = len * 8;
@@ -137,6 +153,8 @@ static int software_key_query(const struct kernel_pkey_params *params,
 					KEYCTL_SUPPORTS_SIGN);
 	ret = 0;
 
+error_free_key:
+	kfree(key);
 error_free_tfm:
 	crypto_free_akcipher(tfm);
 	pr_devel("<==%s() = %d\n", __func__, ret);
@@ -155,6 +173,7 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	struct crypto_wait cwait;
 	struct scatterlist in_sg, out_sg;
 	char alg_name[CRYPTO_MAX_ALG_NAME];
+	char *key, *ptr;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -173,14 +192,23 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	if (!req)
 		goto error_free_tfm;
 
+	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
+		      GFP_KERNEL);
+	if (!key)
+		goto error_free_req;
+
+	memcpy(key, pkey->key, pkey->keylen);
+	ptr = key + pkey->keylen;
+	ptr = pkey_pack_u32(ptr, pkey->algo);
+	ptr = pkey_pack_u32(ptr, pkey->paramlen);
+	memcpy(ptr, pkey->params, pkey->paramlen);
+
 	if (pkey->key_is_private)
-		ret = crypto_akcipher_set_priv_key(tfm,
-						   pkey->key, pkey->keylen);
+		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
 	else
-		ret = crypto_akcipher_set_pub_key(tfm,
-						  pkey->key, pkey->keylen);
+		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
 	if (ret)
-		goto error_free_req;
+		goto error_free_key;
 
 	sg_init_one(&in_sg, in, params->in_len);
 	sg_init_one(&out_sg, out, params->out_len);
@@ -210,6 +238,8 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	if (ret == 0)
 		ret = req->dst_len;
 
+error_free_key:
+	kfree(key);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
@@ -229,6 +259,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct akcipher_request *req;
 	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
+	char *key, *ptr;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -252,14 +283,23 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (!req)
 		goto error_free_tfm;
 
+	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
+		      GFP_KERNEL);
+	if (!key)
+		goto error_free_req;
+
+	memcpy(key, pkey->key, pkey->keylen);
+	ptr = key + pkey->keylen;
+	ptr = pkey_pack_u32(ptr, pkey->algo);
+	ptr = pkey_pack_u32(ptr, pkey->paramlen);
+	memcpy(ptr, pkey->params, pkey->paramlen);
+
 	if (pkey->key_is_private)
-		ret = crypto_akcipher_set_priv_key(tfm,
-						   pkey->key, pkey->keylen);
+		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
 	else
-		ret = crypto_akcipher_set_pub_key(tfm,
-						  pkey->key, pkey->keylen);
+		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
 	if (ret)
-		goto error_free_req;
+		goto error_free_key;
 
 	sg_init_table(src_sg, 2);
 	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
@@ -272,6 +312,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 				      crypto_req_done, &cwait);
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
 
+error_free_key:
+	kfree(key);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
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
index 21b27996508a..bc382b0c0ac6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2585,6 +2585,12 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+static u8 *test_pack_u32(u8 *dst, u32 val)
+{
+	memcpy(dst, &val, sizeof(val));
+	return dst + sizeof(val);
+}
+
 static int test_akcipher_one(struct crypto_akcipher *tfm,
 			     const struct akcipher_testvec *vecs)
 {
@@ -2599,6 +2605,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	const char *m, *c;
 	unsigned int m_size, c_size;
 	const char *op;
+	u8 *key, *ptr;
 
 	if (testmgr_alloc_buf(xbuf))
 		return err;
@@ -2609,12 +2616,20 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 
 	crypto_init_wait(&wait);
 
+	key = kmalloc(vecs->key_len + sizeof(u32) * 2 + vecs->param_len,
+		      GFP_KERNEL);
+	if (!key)
+		goto free_xbuf;
+	memcpy(key, vecs->key, vecs->key_len);
+	ptr = key + vecs->key_len;
+	ptr = test_pack_u32(ptr, vecs->algo);
+	ptr = test_pack_u32(ptr, vecs->param_len);
+	memcpy(ptr, vecs->params, vecs->param_len);
+
 	if (vecs->public_key_vec)
-		err = crypto_akcipher_set_pub_key(tfm, vecs->key,
-						  vecs->key_len);
+		err = crypto_akcipher_set_pub_key(tfm, key, vecs->key_len);
 	else
-		err = crypto_akcipher_set_priv_key(tfm, vecs->key,
-						   vecs->key_len);
+		err = crypto_akcipher_set_priv_key(tfm, key, vecs->key_len);
 	if (err)
 		goto free_req;
 
@@ -2744,6 +2759,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	kfree(outbuf_enc);
 free_req:
 	akcipher_request_free(req);
+	kfree(key);
 free_xbuf:
 	testmgr_free_buf(xbuf);
 	return err;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index f267633cf13a..75d8f8c3e203 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -25,6 +25,8 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
+#include <linux/oid_registry.h>
+
 #define MAX_IVLEN		32
 
 /*
@@ -135,13 +137,16 @@ struct drbg_testvec {
 
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
index 2d26939fff51..53c069ab30bd 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -74,10 +74,10 @@ struct crypto_akcipher {
  *		operation
  * @set_pub_key: Function invokes the algorithm specific set public key
  *		function, which knows how to decode and interpret
- *		the BER encoded public key
+ *		the BER encoded public key and parameters
  * @set_priv_key: Function invokes the algorithm specific set private key
  *		function, which knows how to decode and interpret
- *		the BER encoded private key
+ *		the BER encoded private key and parameters
  * @max_size:	Function returns dest buffer size required for a given key.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -379,11 +379,12 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
  * crypto_akcipher_set_pub_key() - Invoke set public key operation
  *
  * Function invokes the algorithm specific set key function, which knows
- * how to decode and interpret the encoded key
+ * how to decode and interpret the encoded key and parameters
  *
  * @tfm:	tfm handle
- * @key:	BER encoded public key
- * @keylen:	length of the key
+ * @key:	BER encoded public key, algo OID, paramlen, BER encoded
+ *		parameters
+ * @keylen:	length of the key (not including other data)
  *
  * Return: zero on success; error code in case of error
  */
@@ -400,11 +401,12 @@ static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
  * crypto_akcipher_set_priv_key() - Invoke set private key operation
  *
  * Function invokes the algorithm specific set key function, which knows
- * how to decode and interpret the encoded key
+ * how to decode and interpret the encoded keya and parameters
  *
  * @tfm:	tfm handle
- * @key:	BER encoded private key
- * @keylen:	length of the key
+ * @key:	BER encoded private key, algo OID, paramlen, BER encoded
+ *		parameters
+ * @keylen:	length of the key (not including other data)
  *
  * Return: zero on success; error code in case of error
  */
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

