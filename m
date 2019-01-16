Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:57302 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394233AbfAPQrp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 11:47:45 -0500
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, qat-linux@intel.com
Subject: [RFC PATCH v2] akcipher: Introduce verify_rsa/verify for public key algorithms
Date: Wed, 16 Jan 2019 19:47:03 +0300
Message-Id: <20190116164703.9267-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To my opinion this new version may fit suggestions of Herbert and David - we only
have single general top level crypto_akcipher_verify() call, but two low level
 ->verify() and ->verify_rsa() calls. Final signature verification is moved from
each caller of crypto_akcipher_verify() into crypto_akcipher_verify() itself.

There is remained crypto_akcipher_verify_rsa() just for rsa specific (pkcs1)
code (it seems that we are isolating from calling directly ->verify_rsa()).

Does it looks good?

Original/new commit message:

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
public_key_verify_signature() wasn't satisfied.

Make improved .verify() call which gets hash value as parameter and
produce complete signature check (without any output besides status.

Other rsa-centric drivers have replaced verify() with verify_rsa() which
have old semantic. If akcipher have .verify_rsa() callback, it will be
used for a partial verification, which then is finished in
crypto_akcipher_verify().

Now for the top level verification only crypto_akcipher_verify() needs
to be called.

crypto_akcipher_verify_rsa() is introduced which directly calls
.verify_rsa() for use by PKCS1 driver to call its backend.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/akcipher.c                             | 53 +++++++++++++++++++++++++++
 crypto/asymmetric_keys/public_key.c           | 19 +++-------
 crypto/rsa-pkcs1pad.c                         |  4 +-
 crypto/rsa.c                                  |  2 +-
 crypto/testmgr.c                              |  5 ++-
 drivers/crypto/caam/caampkc.c                 |  2 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c           |  2 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  2 +-
 include/crypto/akcipher.h                     | 21 +++++++----
 9 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 0cbeae137e0a..2e247cbf5115 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -25,6 +25,59 @@
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
+	if (WARN_ON(!digest || !digest_len))
+		return -EINVAL;
+
+	crypto_stats_get(calg);
+	if (alg->verify_rsa) {
+		u8 output[HASH_MAX_DIGESTSIZE];
+
+		/* Perform the verification calculation.  This doesn't actually
+		 * do the verification, but rather calculates the hash expected
+		 * by the signature and returns that to us.
+		 */
+		ret = crypto_akcipher_verify_rsa(req);
+		if (ret)
+			goto out;
+		if (req->dst_len != digest_len ||
+		    WARN_ON(req->dst_len > sizeof(output))) {
+			ret = -EKEYREJECTED;
+			goto out;
+		}
+		sg_copy_to_buffer(req->dst,
+				  sg_nents_for_len(req->dst, digest_len),
+				  output, digest_len);
+		/* Do final verification step. */
+		if (memcmp(digest, output, digest_len))
+			ret = -EKEYREJECTED;
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
index f5d85b47fcc6..1f86d22548f0 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -227,7 +227,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist sig_sg, digest_sg;
+	struct scatterlist sig_sg, output_sg;
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	void *output;
 	unsigned int outlen;
@@ -270,27 +270,18 @@ int public_key_verify_signature(const struct public_key *pkey,
 		goto error_free_req;
 
 	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
+	sg_init_one(&output_sg, output, outlen);
+	akcipher_request_set_crypt(req, &sig_sg, &output_sg, sig->s_size,
 				   outlen);
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
+	ret = crypto_wait_req(crypto_akcipher_verify(req, sig->digest,
+						     sig->digest_size), &cwait);
 	if (ret)
 		goto out_free_output;
 
-	/* Do the actual verification step. */
-	if (req->dst_len != sig->digest_size ||
-	    memcmp(sig->digest, output, sig->digest_size) != 0)
-		ret = -EKEYREJECTED;
-
 out_free_output:
 	kfree(output);
 error_free_req:
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index cfc04e15fd97..f82d70724229 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -550,7 +550,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 				   req_ctx->out_sg, req->src_len,
 				   ctx->key_size);
 
-	err = crypto_akcipher_verify(&req_ctx->child_req);
+	err = crypto_akcipher_verify_rsa(&req_ctx->child_req);
 	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_verify_complete(req, err);
 
@@ -674,7 +674,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
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
index 1ce53f8058d2..ed59408bf30b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2303,7 +2303,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 
 	err = crypto_wait_req(vecs->siggen_sigver_test ?
 			      /* Run asymmetric signature verification */
-			      crypto_akcipher_verify(req) :
+			      crypto_akcipher_verify(req, c, c_size) :
 			      /* Run asymmetric encrypt */
 			      crypto_akcipher_encrypt(req), &wait);
 	if (err) {
@@ -2317,7 +2317,8 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 		goto free_all;
 	}
 	/* verify that encrypted message is equal to expected */
-	if (memcmp(c, outbuf_enc, c_size)) {
+	if (!vecs->siggen_sigver_test &&
+	    memcmp(c, outbuf_enc, c_size)) {
 		pr_err("alg: akcipher: %s test failed. Invalid output\n", op);
 		hexdump(outbuf_enc, c_size);
 		err = -EINVAL;
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
index 2d690494568c..1bb8ba74b95d 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -55,10 +55,12 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @verify:	Function performs a sign operation as defined by public key
+ * @verify_rsa:	Function performs a partial verify operation as defined by RSA
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
+ * @verify:	Function performs a complete verify operation as defined by public
+ *		key algorithm. Requires digest value as input parameter.
  * @encrypt:	Function performs an encrypt operation as defined by public key
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
@@ -91,7 +93,9 @@ struct crypto_akcipher {
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
@@ -343,16 +347,15 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
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
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_verify(struct akcipher_request *req)
+static inline int crypto_akcipher_verify_rsa(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
@@ -360,7 +363,7 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 	int ret;
 
 	crypto_stats_get(calg);
-	ret = alg->verify(req);
+	ret = alg->verify_rsa(req);
 	crypto_stats_akcipher_verify(ret, calg);
 	return ret;
 }
@@ -406,4 +409,8 @@ static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
 
 	return alg->set_priv_key(tfm, key, keylen);
 }
+
+int crypto_akcipher_verify(struct akcipher_request *req,
+			   const unsigned char *digest,
+			   unsigned int digest_len);
 #endif
-- 
2.11.0
