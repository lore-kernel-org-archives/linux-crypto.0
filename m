Return-Path: <SRS0=FcWR=Q7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED77CC10F19
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD7F520840
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfBXGJF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Feb 2019 01:09:05 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:43796 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbfBXGJF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Feb 2019 01:09:05 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 4E2C072CCAE;
        Sun, 24 Feb 2019 09:09:00 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id DC5C24A4AE7;
        Sun, 24 Feb 2019 09:08:59 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/10] crypto: akcipher - new verify API for public key algorithms
Date:   Sun, 24 Feb 2019 09:08:22 +0300
Message-Id: <20190224060828.2527-5-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190224060828.2527-1-vt@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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

Make improved .verify() call which gets hash value as input and produce
complete signature check without any output besides status.

Now for the top level verification only crypto_akcipher_verify() needs
to be called.

Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/asymmetric_keys/asym_tpm.c   | 34 ++++++++-----------------
 crypto/asymmetric_keys/public_key.c | 34 ++++++++-----------------
 crypto/rsa-pkcs1pad.c               | 29 +++++++++++++--------
 crypto/testmgr.c                    | 50 ++++++++++++++++++++++---------------
 include/crypto/akcipher.h           | 40 ++++++++++++++++++-----------
 5 files changed, 95 insertions(+), 92 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 5d4c270463f6..4e5b6fb57a94 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -744,12 +744,11 @@ static int tpm_key_verify_signature(const struct key *key,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist sig_sg, digest_sg;
+	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
 	uint32_t der_pub_key_len;
-	void *output;
-	unsigned int outlen;
+	void *digest;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -782,35 +781,22 @@ static int tpm_key_verify_signature(const struct key *key,
 		goto error_free_tfm;
 
 	ret = -ENOMEM;
-	outlen = crypto_akcipher_maxsize(tfm);
-	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
+	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
+	if (!digest)
 		goto error_free_req;
 
-	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
-				   outlen);
+	sg_init_table(src_sg, 2);
+	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
+	sg_set_buf(&src_sg[1], digest, sig->digest_size);
+	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
+				   sig->digest_size);
 	crypto_init_wait(&cwait);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
 				      crypto_req_done, &cwait);
-
-	/* Perform the verification calculation.  This doesn't actually do the
-	 * verification, but rather calculates the hash expected by the
-	 * signature and returns that to us.
-	 */
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
-	if (ret)
-		goto out_free_output;
-
-	/* Do the actual verification step. */
-	if (req->dst_len != sig->digest_size ||
-	    memcmp(sig->digest, output, sig->digest_size) != 0)
-		ret = -EKEYREJECTED;
 
-out_free_output:
-	kfree(output);
+	kfree(digest);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index c2e4e73fcf06..338f2b5352b1 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -233,10 +233,9 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist sig_sg, digest_sg;
+	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
-	void *output;
-	unsigned int outlen;
+	void *digest;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -270,35 +269,22 @@ int public_key_verify_signature(const struct public_key *pkey,
 		goto error_free_req;
 
 	ret = -ENOMEM;
-	outlen = crypto_akcipher_maxsize(tfm);
-	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
+	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
+	if (!digest)
 		goto error_free_req;
 
-	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
-				   outlen);
+	sg_init_table(src_sg, 2);
+	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
+	sg_set_buf(&src_sg[1], digest, sig->digest_size);
+	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
+				   sig->digest_size);
 	crypto_init_wait(&cwait);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
 				      crypto_req_done, &cwait);
-
-	/* Perform the verification calculation.  This doesn't actually do the
-	 * verification, but rather calculates the hash expected by the
-	 * signature and returns that to us.
-	 */
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
-	if (ret)
-		goto out_free_output;
-
-	/* Do the actual verification step. */
-	if (req->dst_len != sig->digest_size ||
-	    memcmp(sig->digest, output, sig->digest_size) != 0)
-		ret = -EKEYREJECTED;
 
-out_free_output:
-	kfree(output);
+	kfree(digest);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 94382fa2c6ac..f2fa1ce90cfa 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -488,14 +488,21 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 
 	err = 0;
 
-	if (req->dst_len < dst_len - pos)
-		err = -EOVERFLOW;
-	req->dst_len = dst_len - pos;
-
-	if (!err)
-		sg_copy_from_buffer(req->dst,
-				sg_nents_for_len(req->dst, req->dst_len),
-				out_buf + pos, req->dst_len);
+	if (req->dst_len != dst_len - pos) {
+		err = -EKEYREJECTED;
+		req->dst_len = dst_len - pos;
+		goto done;
+	}
+	/* Extract appended digest. */
+	sg_pcopy_to_buffer(req->src,
+			   sg_nents_for_len(req->src,
+					    req->src_len + req->dst_len),
+			   req_ctx->out_buf + ctx->key_size,
+			   req->dst_len, ctx->key_size);
+	/* Do the actual verification step. */
+	if (memcmp(req_ctx->out_buf + ctx->key_size, out_buf + pos,
+		   req->dst_len))
+		err = -EKEYREJECTED;
 done:
 	kzfree(req_ctx->out_buf);
 
@@ -532,10 +539,12 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
 	int err;
 
-	if (!ctx->key_size || req->src_len < ctx->key_size)
+	if (WARN_ON(req->dst) ||
+	    WARN_ON(!req->dst_len) ||
+	    !ctx->key_size || req->src_len < ctx->key_size)
 		return -EINVAL;
 
-	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
+	req_ctx->out_buf = kmalloc(ctx->key_size + req->dst_len, GFP_KERNEL);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d582a2758feb..924a1b9cf5ca 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2501,7 +2501,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	struct crypto_wait wait;
 	unsigned int out_len_max, out_len = 0;
 	int err = -ENOMEM;
-	struct scatterlist src, dst, src_tab[2];
+	struct scatterlist src, dst, src_tab[3];
 	const char *m, *c;
 	unsigned int m_size, c_size;
 	const char *op;
@@ -2524,13 +2524,12 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
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
@@ -2556,12 +2555,20 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 		goto free_all;
 	memcpy(xbuf[0], m, m_size);
 
-	sg_init_table(src_tab, 2);
+	sg_init_table(src_tab, 3);
 	sg_set_buf(&src_tab[0], xbuf[0], 8);
 	sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
-	sg_init_one(&dst, outbuf_enc, out_len_max);
-	akcipher_request_set_crypt(req, src_tab, &dst, m_size,
-				   out_len_max);
+	if (vecs->siggen_sigver_test) {
+		if (WARN_ON(c_size > PAGE_SIZE))
+			goto free_all;
+		memcpy(xbuf[1], c, c_size);
+		sg_set_buf(&src_tab[2], xbuf[1], c_size);
+		akcipher_request_set_crypt(req, src_tab, NULL, m_size, c_size);
+	} else {
+		sg_init_one(&dst, outbuf_enc, out_len_max);
+		akcipher_request_set_crypt(req, src_tab, &dst, m_size,
+					   out_len_max);
+	}
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      crypto_req_done, &wait);
 
@@ -2574,18 +2581,21 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
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
+			pr_err("alg: akcipher: %s test failed. Invalid output\n",
+			       op);
+			hexdump(outbuf_enc, c_size);
+			err = -EINVAL;
+			goto free_all;
+		}
 	}
 
 	/*
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index f537fad1989f..28ffa9ef03a9 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -19,14 +19,20 @@
  *
  * @base:	Common attributes for async crypto requests
  * @src:	Source data
- * @dst:	Destination data
+ *		For verify op this is signature + digest, in that case
+ *		total size of @src is @src_len + @dst_len.
+ * @dst:	Destination data (Should be NULL for verify op)
  * @src_len:	Size of the input buffer
- * @dst_len:	Size of the output buffer. It needs to be at least
- *		as big as the expected result depending	on the operation
+ *		For verify op it's size of signature part of @src, this part
+ *		is supposed to be operated by cipher.
+ * @dst_len:	Size of @dst buffer (for all ops except verify).
+ *		It needs to be at least	as big as the expected result
+ *		depending on the operation.
  *		After operation it will be updated with the actual size of the
  *		result.
  *		In case of error where the dst sgl size was insufficient,
  *		it will be updated to the size required for the operation.
+ *		For verify op this is size of digest part in @src.
  * @__ctx:	Start of private context data
  */
 struct akcipher_request {
@@ -55,10 +61,9 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @verify:	Function performs a sign operation as defined by public key
- *		algorithm. In case of error, where the dst_len was insufficient,
- *		the req->dst_len will be updated to the size required for the
- *		operation
+ * @verify:	Function performs a complete verify operation as defined by
+ *		public key algorithm, returning verification status. Requires
+ *		digest value as input parameter.
  * @encrypt:	Function performs an encrypt operation as defined by public key
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
@@ -238,9 +243,10 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
  *
  * @req:	public key request
  * @src:	ptr to input scatter list
- * @dst:	ptr to output scatter list
+ * @dst:	ptr to output scatter list or NULL for verify op
  * @src_len:	size of the src input scatter list to be processed
- * @dst_len:	size of the dst output scatter list
+ * @dst_len:	size of the dst output scatter list or size of signature
+ *		portion in @src for verify op
  */
 static inline void akcipher_request_set_crypt(struct akcipher_request *req,
 					      struct scatterlist *src,
@@ -349,14 +355,18 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_verify() - Invoke public key verify operation
+ * crypto_akcipher_verify() - Invoke public key signature verification
  *
- * Function invokes the specific public key verify operation for a given
- * public key algorithm
+ * Function invokes the specific public key signature verification operation
+ * for a given public key algorithm.
  *
  * @req:	asymmetric key request
  *
- * Return: zero on success; error code in case of error
+ * Note: req->dst should be NULL, req->src should point to SG of size
+ * (req->src_size + req->dst_size), containing signature (of req->src_size
+ * length) with appended digest (of req->dst_size length).
+ *
+ * Return: zero on verification success; error code in case of error.
  */
 static inline int crypto_akcipher_verify(struct akcipher_request *req)
 {
@@ -366,7 +376,9 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	if (alg->verify)
+	if (req->dst || !req->dst_len)
+		ret = -EINVAL;
+	else if (alg->verify)
 		ret = alg->verify(req);
 	crypto_stats_akcipher_verify(ret, calg);
 	return ret;
-- 
2.11.0

