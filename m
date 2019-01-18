Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:52478 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729438AbfARVCy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 16:02:54 -0500
From: Vitaly Chikunov <vt@altlinux.org>
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3] akcipher: Introduce verify_rsa/verify for public key algorithms
Date: Fri, 18 Jan 2019 23:58:46 +0300
Message-Id: <20190118205846.20309-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Previous akcipher .verify() just `decrypts' (using RSA encrypt which is
using public key) signature to uncover message hash, which was then
compared in upper level public_key_verify_signature() with the expected
hash value, which itself was never passed into verify().

This approach was incompatible with EC-DSA family of algorithms,
because, to verify a signature EC-DSA algorithm also needs a hash value
as input; then it's used (together with a signature divided into halves
`r||s') to produce a witness value, which is then compared with `r' to
determine if the signature is correct. Thus, for EC-DSA, nor
requirements of .verify() itself, nor its output expectations in
public_key_verify_signature() wasn't sufficient.

Make improved .verify() call which gets hash value as parameter and
produce complete signature check without any output besides status.

RSA-centric drivers have replaced verify() with verify_rsa() which
have old semantic and which they still should implement (if they want
pkcs1pad to work). If akcipher have .verify_rsa() callback, it will be
used for a partial verification, which then is finished in
crypto_akcipher_verify().

Now for the top level verification only crypto_akcipher_verify() needs
to be called.

For pkcs1pad crypto_akcipher_verify_rsa() is introduced which directly
calls .verify_rsa() for its backend. Without this api PKCS1 can not be
implemented.

Tested on x86_64.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---

This should be applied over cryptodev tree.

Changes since v2:
- `output` is factored out from public_key_verify_signature() into
  crypto_akcipher_verify().
- in crypto_akcipher_verify_rsa() -ENOSYS error is added for robustness (if,
  in the future, some RSA driver will not implement this api).
- api descriptions are updated to be more clear.

Changes since v1:
- complete rework to the different approach and should be treated as
  a new patch.

 crypto/akcipher.c                             | 60 +++++++++++++++++++++++++++
 crypto/asymmetric_keys/public_key.c           | 32 ++------------
 crypto/rsa-pkcs1pad.c                         |  4 +-
 crypto/rsa.c                                  |  2 +-
 crypto/testmgr.c                              | 43 ++++++++++---------
 drivers/crypto/caam/caampkc.c                 |  2 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c           |  2 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  2 +-
 include/crypto/akcipher.h                     | 34 ++++++++++-----
 9 files changed, 117 insertions(+), 64 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 0cbeae137e0a..95f207b2eb12 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -25,6 +25,66 @@
 #include <crypto/internal/akcipher.h>
 #include "internal.h"
 
+/**
+ * crypto_akcipher_verify() - Invoke public key signature verification
+ *
+ * Function invokes the specific public key signature verification operation
+ * for a given public key algorithm.
+ *
+ * @req:	asymmetric key request
+ * @digest:	expected hash value
+ * @digest_len:	hash length
+ *
+ * Return: zero on verification success; error code in case of error.
+ */
+int crypto_akcipher_verify(struct akcipher_request *req,
+			   const unsigned char *digest, unsigned int digest_len)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
+	int ret;
+
+	if (WARN_ON(!digest || !digest_len) ||
+	    WARN_ON(req->dst || req->dst_len))
+		return -EINVAL;
+
+	crypto_stats_get(calg);
+	if (alg->verify_rsa) {
+		struct scatterlist output_sg;
+		void *output;
+		unsigned int outlen;
+
+		outlen = crypto_akcipher_maxsize(tfm);
+		ret = -EKEYREJECTED;
+		if (WARN_ON(outlen < digest_len))
+			goto out;
+		ret = -ENOMEM;
+		output = kmalloc(outlen, GFP_KERNEL);
+		if (!output)
+			goto out;
+		sg_init_one(&output_sg, output, outlen);
+		akcipher_request_set_crypt(req, req->src, &output_sg,
+					   req->src_len, outlen);
+
+		/* Perform the verification calculation.  This doesn't actually
+		 * do the verification, but rather calculates the hash expected
+		 * by the signature and returns that to us.
+		 */
+		ret = crypto_akcipher_verify_rsa(req);
+		if (!ret &&
+		    (req->dst_len != digest_len ||
+		     memcmp(digest, output, digest_len)))
+			ret = -EKEYREJECTED;
+		kfree(output);
+	} else
+		ret = alg->verify(req, digest, digest_len);
+out:
+	crypto_stats_akcipher_verify(ret, calg);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_akcipher_verify);
+
 #ifdef CONFIG_NET
 static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index f5d85b47fcc6..73724f74d124 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -227,10 +227,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist sig_sg, digest_sg;
+	struct scatterlist sig_sg;
 	char alg_name[CRYPTO_MAX_ALG_NAME];
-	void *output;
-	unsigned int outlen;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -263,36 +261,14 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_req;
 
-	ret = -ENOMEM;
-	outlen = crypto_akcipher_maxsize(tfm);
-	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
-		goto error_free_req;
-
 	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
-				   outlen);
+	akcipher_request_set_crypt(req, &sig_sg, NULL, sig->s_size, 0);
 	crypto_init_wait(&cwait);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
 				      crypto_req_done, &cwait);
-
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
-
-out_free_output:
-	kfree(output);
+	ret = crypto_wait_req(crypto_akcipher_verify(req, sig->digest,
+						     sig->digest_size), &cwait);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 0a6680ca8cb6..88728ffb6b69 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -551,7 +551,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 				   req_ctx->out_sg, req->src_len,
 				   ctx->key_size);
 
-	err = crypto_akcipher_verify(&req_ctx->child_req);
+	err = crypto_akcipher_verify_rsa(&req_ctx->child_req);
 	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_verify_complete(req, err);
 
@@ -675,7 +675,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = pkcs1pad_encrypt;
 	inst->alg.decrypt = pkcs1pad_decrypt;
 	inst->alg.sign = pkcs1pad_sign;
-	inst->alg.verify = pkcs1pad_verify;
+	inst->alg.verify_rsa = pkcs1pad_verify;
 	inst->alg.set_pub_key = pkcs1pad_set_pub_key;
 	inst->alg.set_priv_key = pkcs1pad_set_priv_key;
 	inst->alg.max_size = pkcs1pad_get_max_size;
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4167980c243d..42df7d0c915c 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -354,7 +354,7 @@ static struct akcipher_alg rsa = {
 	.encrypt = rsa_enc,
 	.decrypt = rsa_dec,
 	.sign = rsa_sign,
-	.verify = rsa_verify,
+	.verify_rsa = rsa_verify,
 	.set_priv_key = rsa_set_priv_key,
 	.set_pub_key = rsa_set_pub_key,
 	.max_size = rsa_max_size,
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e4f3f5f688e7..eb2adcf606d2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2275,13 +2275,12 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	if (err)
 		goto free_req;
 
-	err = -ENOMEM;
-	out_len_max = crypto_akcipher_maxsize(tfm);
-
 	/*
 	 * First run test which do not require a private key, such as
 	 * encrypt or verify.
 	 */
+	err = -ENOMEM;
+	out_len_max = crypto_akcipher_maxsize(tfm);
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
 	if (!outbuf_enc)
 		goto free_req;
@@ -2310,33 +2309,39 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	sg_init_table(src_tab, 2);
 	sg_set_buf(&src_tab[0], xbuf[0], 8);
 	sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
-	sg_init_one(&dst, outbuf_enc, out_len_max);
-	akcipher_request_set_crypt(req, src_tab, &dst, m_size,
-				   out_len_max);
+	if (vecs->siggen_sigver_test)
+		akcipher_request_set_crypt(req, src_tab, NULL, m_size, 0);
+	else {
+		sg_init_one(&dst, outbuf_enc, out_len_max);
+		akcipher_request_set_crypt(req, src_tab, &dst, m_size,
+					   out_len_max);
+	}
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      crypto_req_done, &wait);
 
 	err = crypto_wait_req(vecs->siggen_sigver_test ?
 			      /* Run asymmetric signature verification */
-			      crypto_akcipher_verify(req) :
+			      crypto_akcipher_verify(req, c, c_size) :
 			      /* Run asymmetric encrypt */
 			      crypto_akcipher_encrypt(req), &wait);
 	if (err) {
 		pr_err("alg: akcipher: %s test failed. err %d\n", op, err);
 		goto free_all;
 	}
-	if (req->dst_len != c_size) {
-		pr_err("alg: akcipher: %s test failed. Invalid output len\n",
-		       op);
-		err = -EINVAL;
-		goto free_all;
-	}
-	/* verify that encrypted message is equal to expected */
-	if (memcmp(c, outbuf_enc, c_size)) {
-		pr_err("alg: akcipher: %s test failed. Invalid output\n", op);
-		hexdump(outbuf_enc, c_size);
-		err = -EINVAL;
-		goto free_all;
+	if (!vecs->siggen_sigver_test) {
+		if (req->dst_len != c_size) {
+			pr_err("alg: akcipher: %s test failed. Invalid output len\n",
+			       op);
+			err = -EINVAL;
+			goto free_all;
+		}
+		/* verify that encrypted message is equal to expected */
+		if (memcmp(c, outbuf_enc, c_size)) {
+			pr_err("alg: akcipher: %s test failed. Invalid output\n", op);
+			hexdump(outbuf_enc, c_size);
+			err = -EINVAL;
+			goto free_all;
+		}
 	}
 
 	/*
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 77ab28a2811a..e06b4c9a89e2 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -995,7 +995,7 @@ static struct akcipher_alg caam_rsa = {
 	.encrypt = caam_rsa_enc,
 	.decrypt = caam_rsa_dec,
 	.sign = caam_rsa_dec,
-	.verify = caam_rsa_enc,
+	.verify_rsa = caam_rsa_enc,
 	.set_pub_key = caam_rsa_set_pub_key,
 	.set_priv_key = caam_rsa_set_priv_key,
 	.max_size = caam_rsa_max_size,
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index 05850dfd7940..fc669b1bb328 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -215,7 +215,7 @@ static struct akcipher_alg ccp_rsa_defaults = {
 	.encrypt = ccp_rsa_encrypt,
 	.decrypt = ccp_rsa_decrypt,
 	.sign = ccp_rsa_decrypt,
-	.verify = ccp_rsa_encrypt,
+	.verify_rsa = ccp_rsa_encrypt,
 	.set_pub_key = ccp_rsa_setpubkey,
 	.set_priv_key = ccp_rsa_setprivkey,
 	.max_size = ccp_rsa_maxsize,
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 320e7854b4ee..a6c7ff572970 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1301,7 +1301,7 @@ static struct akcipher_alg rsa = {
 	.encrypt = qat_rsa_enc,
 	.decrypt = qat_rsa_dec,
 	.sign = qat_rsa_dec,
-	.verify = qat_rsa_enc,
+	.verify_rsa = qat_rsa_enc,
 	.set_pub_key = qat_rsa_setpubkey,
 	.set_priv_key = qat_rsa_setprivkey,
 	.max_size = qat_rsa_max_size,
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 2d690494568c..286f529024ba 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -55,10 +55,14 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @verify:	Function performs a sign operation as defined by public key
- *		algorithm. In case of error, where the dst_len was insufficient,
- *		the req->dst_len will be updated to the size required for the
- *		operation
+ * @verify_rsa:	Function performs a partial verify operation as defined by RSA
+ *		algorithm producing signature in the output. In case of error,
+ *		where the dst_len was insufficient, the req->dst_len will be
+ *		updated to the size required for the operation. All RSA
+ *		implementations that could be PKCS1 padded should implement that.
+ * @verify:	Function performs a complete verify operation as defined by public
+ *		key algorithm, returning verification status. Requires digest
+ *		value as input parameter.
  * @encrypt:	Function performs an encrypt operation as defined by public key
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
@@ -91,7 +95,9 @@ struct crypto_akcipher {
  */
 struct akcipher_alg {
 	int (*sign)(struct akcipher_request *req);
-	int (*verify)(struct akcipher_request *req);
+	int (*verify_rsa)(struct akcipher_request *req);
+	int (*verify)(struct akcipher_request *req, const u8 *digest,
+		      unsigned int digest_len);
 	int (*encrypt)(struct akcipher_request *req);
 	int (*decrypt)(struct akcipher_request *req);
 	int (*set_pub_key)(struct crypto_akcipher *tfm, const void *key,
@@ -343,24 +349,26 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_verify() - Invoke public key verify operation
+ * crypto_akcipher_verify_rsa() - Invoke partial RSA verify operation
  *
- * Function invokes the specific public key verify operation for a given
- * public key algorithm
+ * Function invokes partial verify operation for a RSA algorithm
  *
  * @req:	asymmetric key request
  *
+ * Note: this should only be used by RSA wrappers such as PKCS1.
+ *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_verify(struct akcipher_request *req)
+static inline int crypto_akcipher_verify_rsa(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
+	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	ret = alg->verify(req);
+	if (alg->verify_rsa)
+		ret = alg->verify_rsa(req);
 	crypto_stats_akcipher_verify(ret, calg);
 	return ret;
 }
@@ -406,4 +414,8 @@ static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
 
 	return alg->set_priv_key(tfm, key, keylen);
 }
+
+int crypto_akcipher_verify(struct akcipher_request *req,
+			   const unsigned char *digest,
+			   unsigned int digest_len);
 #endif
-- 
2.11.0
