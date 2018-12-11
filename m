Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:43632 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeLKQ77 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 11:59:59 -0500
From: Vitaly Chikunov <vt@altlinux.org>
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] akcipher: Introduce verify2 for public key algorithms
Date: Tue, 11 Dec 2018 19:59:38 +0300
Message-Id: <20181211165938.1150-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Current akcipher .verify() just decrypts signature to uncover message
hash, which is then verified in upper level public_key_verify_signature
by memcmp with the expected signature value, which is never passed into
verify().

This approach is incompatible with ECDSA algorithms, because, to verify
a signature ECDSA algorithm also needs a hash value as input; also, hash
is used in ECDSA (together with a signature divided into halves `r||s`),
not to produce hash, but to produce a number, which is then compared to
`r` (first part of the signature) to determine if the signature is
correct.  Thus, for ECDSA, nor requirements of .verify() itself, nor its
output expectations in public_key_verify_signature aren't satisfied.

Make alternative .verify2() call which gets hash value and produce
complete signature check (without any output, thus max_size() call will
not be needed for verify2() operation).

If .verify2() call is present, it should be used in place of .verify().

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/asymmetric_keys/public_key.c | 57 ++++++++++++++++++++++++-------------
 include/crypto/akcipher.h           | 54 +++++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 22 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 3bc090b8adef..51dc1c858c7c 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -242,6 +242,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	void *output;
 	unsigned int outlen;
+	int verify2;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -279,14 +280,23 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_req;
 
-	ret = -ENOMEM;
-	outlen = crypto_akcipher_maxsize(tfm);
-	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
-		goto error_free_req;
-
+	verify2 = crypto_akcipher_have_verify2(req);
+	if (!verify2) {
+		/* verify2 does not need output buffer */
+		ret = -ENOMEM;
+		outlen = crypto_akcipher_maxsize(tfm);
+		output = kmalloc(outlen, GFP_KERNEL);
+		if (!output)
+			goto error_free_req;
+
+		sg_init_one(&digest_sg, output, outlen);
+	} else {
+		/* dummy init digest_sg */
+		memset(&digest_sg, 0, sizeof(digest_sg));
+		output = NULL;
+		outlen = 0;
+	}
 	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
 	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
 				   outlen);
 	crypto_init_wait(&cwait);
@@ -294,18 +304,27 @@ int public_key_verify_signature(const struct public_key *pkey,
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
 				      crypto_req_done, &cwait);
 
-	/* Perform the verification calculation.  This doesn't actually do the
-	 * verification, but rather calculates the hash expected by the
-	 * signature and returns that to us.
-	 */
-	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
-	if (ret)
-		goto out_free_output;
-
-	/* Do the actual verification step. */
-	if (req->dst_len != sig->digest_size ||
-	    memcmp(sig->digest, output, sig->digest_size) != 0)
-		ret = -EKEYREJECTED;
+	if (!verify2) {
+		/* Perform the verification calculation.  This doesn't actually
+		 * do the verification, but rather calculates the hash expected
+		 * by the signature and returns that to us.
+		 */
+		ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
+		if (ret)
+			goto out_free_output;
+
+		/* Do the actual verification step. */
+		if (req->dst_len != sig->digest_size ||
+		    memcmp(sig->digest, output, sig->digest_size) != 0)
+			ret = -EKEYREJECTED;
+	} else {
+		/* Perform full verification in one call. */
+		req->digest = sig->digest;
+		req->digest_len = sig->digest_size;
+		ret = crypto_wait_req(crypto_akcipher_verify2(req), &cwait);
+		if (ret)
+			goto out_free_output;
+	}
 
 out_free_output:
 	kfree(output);
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index d6aba84ed2c4..f1ad67474bc1 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -28,6 +28,8 @@
  *		result.
  *		In case of error where the dst sgl size was insufficient,
  *		it will be updated to the size required for the operation.
+ * @digest:	Digest for verify2.
+ * @digest_len:	Size of the digest.
  * @__ctx:	Start of private context data
  */
 struct akcipher_request {
@@ -36,6 +38,8 @@ struct akcipher_request {
 	struct scatterlist *dst;
 	unsigned int src_len;
 	unsigned int dst_len;
+	u8 *digest;
+	u8 digest_len;
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -60,6 +64,8 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
+ * @verify2:	Function performs a verify operation as defined by public key
+ *		algorithm.
  * @encrypt:	Function performs an encrypt operation as defined by public key
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
@@ -96,6 +102,7 @@ struct crypto_akcipher {
 struct akcipher_alg {
 	int (*sign)(struct akcipher_request *req);
 	int (*verify)(struct akcipher_request *req);
+	int (*verify2)(struct akcipher_request *req);
 	int (*encrypt)(struct akcipher_request *req);
 	int (*decrypt)(struct akcipher_request *req);
 	int (*set_pub_key)(struct crypto_akcipher *tfm, const void *key,
@@ -400,11 +407,13 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
  * crypto_akcipher_verify() - Invoke public key verify operation
  *
  * Function invokes the specific public key verify operation for a given
- * public key algorithm
+ * public key algorithm: basically it does (rsa) decrypt of signature
+ * producing decrypted hash into dst, which should be compared by a caller
+ * with expected hash value.
  *
- * @req:	asymmetric key request
+ * @req:	asymmetric key request (without hash)
  *
- * Return: zero on success; error code in case of error
+ * Return: zero on decryption success; error code in case of error
  */
 static inline int crypto_akcipher_verify(struct akcipher_request *req)
 {
@@ -418,6 +427,45 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 }
 
 /**
+ * crypto_akcipher_verify2() - Invoke public key verify operation
+ *
+ * Function performs complete public key verify operation for a given
+ * public key algorithm
+ *
+ * @req:	asymmetric key request (with hash)
+ *
+ * Return: zero on verification success; error code in case of error
+ */
+static inline int crypto_akcipher_verify2(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	int ret;
+
+	ret = alg->verify2(req);
+	crypto_stat_akcipher_verify(req, ret);
+	return ret;
+}
+
+/**
+ * crypto_akcipher_have_verify2() - Check for existence of public key verify2
+ * operation
+ *
+ * Function checks for existence of verify2 call for the public key algorithm
+ *
+ * @req:	asymmetric key request (with hash)
+ *
+ * Return: non-zero is verify2 call exists; zero if it does not
+ */
+static inline int crypto_akcipher_have_verify2(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return !!alg->verify2;
+}
+
+/**
  * crypto_akcipher_set_pub_key() - Invoke set public key operation
  *
  * Function invokes the algorithm specific set key function, which knows
-- 
2.11.0
