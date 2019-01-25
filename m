Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC1FC282C2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 18:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5457D218A6
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 18:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfAYSNK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 13:13:10 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:45690 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfAYSNK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 13:13:10 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id EAB9F72CC61;
        Fri, 25 Jan 2019 21:01:24 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id AB9474A4A16;
        Fri, 25 Jan 2019 21:01:24 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: [RFC PATCH v4] akcipher: new verify API for public key algorithms
Date:   Fri, 25 Jan 2019 21:01:16 +0300
Message-Id: <20190125180116.13702-1-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

API is reworked following suggestions of Herbert Xu.

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

Make improved .verify() call which gets a signature together with a hash
value as input and produce complete signature check without any output
besides status.

RSA backends should not have sign/verify callbacks defined (nor they
should be used directly). PKCS1 driver knows to call appropriate RSA
encrypt/decrypt callbacks to implement sign/verify.

Now for the top level verification only crypto_akcipher_verify() needs
to be called.

Tested on x86_64.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
This should be applied over cryptodev tree.

Changes since v3:
- remove verify_rsa API from RSA backends.
- digest is appended to akcipher_request->src SG.
- pkcs1pad calls encrypt/decrypt for its backends instead of sign/verify.
- pkcs1pad now conform to the new verify API.
- make crypto_akcipher_{maxsize,sign,verify} more robust allowing
  appropriate akcipher clllbacks to be undefined.

Changes since v2:
- `output` is factored out from public_key_verify_signature() into
  crypto_akcipher_verify().
- in crypto_akcipher_verify_rsa() -ENOSYS error is added for robustness (if,
  in the future, some RSA driver will not implement this api).
- api descriptions are updated to be more clear.

Changes since v1:
- complete rework to the different approach and should be treated as
  a new patch.

 crypto/asymmetric_keys/asym_tpm.c             |  32 ++------
 crypto/asymmetric_keys/public_key.c           |  33 ++------
 crypto/rsa-pkcs1pad.c                         |  31 +++++---
 crypto/rsa.c                                  | 109 --------------------------
 crypto/testmgr.c                              |  47 ++++++-----
 drivers/crypto/caam/caampkc.c                 |   2 -
 drivers/crypto/ccp/ccp-crypto-rsa.c           |   2 -
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   2 -
 include/crypto/akcipher.h                     |  53 +++++++++----
 9 files changed, 94 insertions(+), 217 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 5d4c270463f6..eef548319877 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -744,11 +744,10 @@ static int tpm_key_verify_signature(const struct key *key,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist sig_sg, digest_sg;
+	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
 	uint32_t der_pub_key_len;
-	void *output;
 	unsigned int outlen;
 	int ret;
 
@@ -781,36 +780,17 @@ static int tpm_key_verify_signature(const struct key *key,
 	if (!req)
 		goto error_free_tfm;
 
-	ret = -ENOMEM;
-	outlen = crypto_akcipher_maxsize(tfm);
-	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
-		goto error_free_req;
-
-	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
-				   outlen);
+	sg_init_table(&src_sg, 2);
+	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
+	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
+	akcipher_request_set_crypt(req, &src_sg, NULL, sig->s_size,
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
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index f5d85b47fcc6..33093b7bcc47 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -227,10 +227,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist sig_sg, digest_sg;
+	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
-	void *output;
-	unsigned int outlen;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -263,36 +261,17 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_req;
 
-	ret = -ENOMEM;
-	outlen = crypto_akcipher_maxsize(tfm);
-	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
-		goto error_free_req;
-
-	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, output, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
-				   outlen);
+	sg_init_table(src_sg, 2);
+	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
+	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
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
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 0a6680ca8cb6..489bda6acf08 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -429,7 +429,7 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
 				   req->dst, ctx->key_size - 1, req->dst_len);
 
-	err = crypto_akcipher_sign(&req_ctx->child_req);
+	err = crypto_akcipher_decrypt(&req_ctx->child_req);
 	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_encrypt_sign_complete(req, err);
 
@@ -488,14 +488,20 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 
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
+	if (memcmp(req_ctx->out_buf + ctx->key_size, out_buf + pos, req->dst_len))
+		err = -EKEYREJECTED;
 done:
 	kzfree(req_ctx->out_buf);
 
@@ -532,10 +538,11 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
 	int err;
 
-	if (!ctx->key_size || req->src_len < ctx->key_size)
+	if (req->dst || !req->dst_len ||
+	    !ctx->key_size || req->src_len < ctx->key_size)
 		return -EINVAL;
 
-	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
+	req_ctx->out_buf = kmalloc(ctx->key_size + req->dst_len, GFP_KERNEL);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
 
@@ -551,7 +558,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 				   req_ctx->out_sg, req->src_len,
 				   ctx->key_size);
 
-	err = crypto_akcipher_verify(&req_ctx->child_req);
+	err = crypto_akcipher_encrypt(&req_ctx->child_req);
 	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_verify_complete(req, err);
 
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4167980c243d..5d427c1100d6 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -50,34 +50,6 @@ static int _rsa_dec(const struct rsa_mpi_key *key, MPI m, MPI c)
 	return mpi_powm(m, c, key->d, key->n);
 }
 
-/*
- * RSASP1 function [RFC3447 sec 5.2.1]
- * s = m^d mod n
- */
-static int _rsa_sign(const struct rsa_mpi_key *key, MPI s, MPI m)
-{
-	/* (1) Validate 0 <= m < n */
-	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
-		return -EINVAL;
-
-	/* (2) s = m^d mod n */
-	return mpi_powm(s, m, key->d, key->n);
-}
-
-/*
- * RSAVP1 function [RFC3447 sec 5.2.2]
- * m = s^e mod n;
- */
-static int _rsa_verify(const struct rsa_mpi_key *key, MPI m, MPI s)
-{
-	/* (1) Validate 0 <= s < n */
-	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->n) >= 0)
-		return -EINVAL;
-
-	/* (2) m = s^e mod n */
-	return mpi_powm(m, s, key->e, key->n);
-}
-
 static inline struct rsa_mpi_key *rsa_get_key(struct crypto_akcipher *tfm)
 {
 	return akcipher_tfm_ctx(tfm);
@@ -160,85 +132,6 @@ static int rsa_dec(struct akcipher_request *req)
 	return ret;
 }
 
-static int rsa_sign(struct akcipher_request *req)
-{
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
-	MPI m, s = mpi_alloc(0);
-	int ret = 0;
-	int sign;
-
-	if (!s)
-		return -ENOMEM;
-
-	if (unlikely(!pkey->n || !pkey->d)) {
-		ret = -EINVAL;
-		goto err_free_s;
-	}
-
-	ret = -ENOMEM;
-	m = mpi_read_raw_from_sgl(req->src, req->src_len);
-	if (!m)
-		goto err_free_s;
-
-	ret = _rsa_sign(pkey, s, m);
-	if (ret)
-		goto err_free_m;
-
-	ret = mpi_write_to_sgl(s, req->dst, req->dst_len, &sign);
-	if (ret)
-		goto err_free_m;
-
-	if (sign < 0)
-		ret = -EBADMSG;
-
-err_free_m:
-	mpi_free(m);
-err_free_s:
-	mpi_free(s);
-	return ret;
-}
-
-static int rsa_verify(struct akcipher_request *req)
-{
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
-	MPI s, m = mpi_alloc(0);
-	int ret = 0;
-	int sign;
-
-	if (!m)
-		return -ENOMEM;
-
-	if (unlikely(!pkey->n || !pkey->e)) {
-		ret = -EINVAL;
-		goto err_free_m;
-	}
-
-	s = mpi_read_raw_from_sgl(req->src, req->src_len);
-	if (!s) {
-		ret = -ENOMEM;
-		goto err_free_m;
-	}
-
-	ret = _rsa_verify(pkey, m, s);
-	if (ret)
-		goto err_free_s;
-
-	ret = mpi_write_to_sgl(m, req->dst, req->dst_len, &sign);
-	if (ret)
-		goto err_free_s;
-
-	if (sign < 0)
-		ret = -EBADMSG;
-
-err_free_s:
-	mpi_free(s);
-err_free_m:
-	mpi_free(m);
-	return ret;
-}
-
 static void rsa_free_mpi_key(struct rsa_mpi_key *key)
 {
 	mpi_free(key->d);
@@ -353,8 +246,6 @@ static void rsa_exit_tfm(struct crypto_akcipher *tfm)
 static struct akcipher_alg rsa = {
 	.encrypt = rsa_enc,
 	.decrypt = rsa_dec,
-	.sign = rsa_sign,
-	.verify = rsa_verify,
 	.set_priv_key = rsa_set_priv_key,
 	.set_pub_key = rsa_set_pub_key,
 	.max_size = rsa_max_size,
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4ac3d22256c3..a5a07caf4c76 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2252,7 +2252,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	struct crypto_wait wait;
 	unsigned int out_len_max, out_len = 0;
 	int err = -ENOMEM;
-	struct scatterlist src, dst, src_tab[2];
+	struct scatterlist src, dst, src_tab[3];
 	const char *m, *c;
 	unsigned int m_size, c_size;
 	const char *op;
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
@@ -2307,12 +2306,17 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
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
+		sg_set_buf(&src_tab[2], c, c_size);
+		akcipher_request_set_crypt(req, src_tab, NULL, m_size, c_size);
+	} else {
+		sg_init_one(&dst, outbuf_enc, out_len_max);
+		akcipher_request_set_crypt(req, src_tab, &dst, m_size,
+					   out_len_max);
+	}
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      crypto_req_done, &wait);
 
@@ -2325,18 +2329,21 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
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
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 77ab28a2811a..d7e1fc5bacc5 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -994,8 +994,6 @@ static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
 static struct akcipher_alg caam_rsa = {
 	.encrypt = caam_rsa_enc,
 	.decrypt = caam_rsa_dec,
-	.sign = caam_rsa_dec,
-	.verify = caam_rsa_enc,
 	.set_pub_key = caam_rsa_set_pub_key,
 	.set_priv_key = caam_rsa_set_priv_key,
 	.max_size = caam_rsa_max_size,
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index 05850dfd7940..71e40680c880 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -214,8 +214,6 @@ static void ccp_rsa_exit_tfm(struct crypto_akcipher *tfm)
 static struct akcipher_alg ccp_rsa_defaults = {
 	.encrypt = ccp_rsa_encrypt,
 	.decrypt = ccp_rsa_decrypt,
-	.sign = ccp_rsa_decrypt,
-	.verify = ccp_rsa_encrypt,
 	.set_pub_key = ccp_rsa_setpubkey,
 	.set_priv_key = ccp_rsa_setprivkey,
 	.max_size = ccp_rsa_maxsize,
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 320e7854b4ee..c05d03565e96 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1300,8 +1300,6 @@ static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
 static struct akcipher_alg rsa = {
 	.encrypt = qat_rsa_enc,
 	.decrypt = qat_rsa_dec,
-	.sign = qat_rsa_dec,
-	.verify = qat_rsa_enc,
 	.set_pub_key = qat_rsa_setpubkey,
 	.set_priv_key = qat_rsa_setprivkey,
 	.max_size = qat_rsa_max_size,
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 2d690494568c..d44a3d566413 100644
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
+ * @verify:	Function performs a complete verify operation as defined by public
+ *		key algorithm, returning verification status. Requires digest
+ *		value as input parameter.
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
@@ -268,7 +274,10 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
-	return alg->max_size(tfm);
+	if (alg->max_size)
+		return alg->max_size(tfm);
+	else
+		return 0;
 }
 
 /**
@@ -334,23 +343,28 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
+	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	ret = alg->sign(req);
+	if (alg->sign)
+		ret = alg->sign(req);
 	crypto_stats_akcipher_sign(ret, calg);
 	return ret;
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
@@ -360,7 +374,12 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 	int ret;
 
 	crypto_stats_get(calg);
-	ret = alg->verify(req);
+	if (req->dst || !req->dst_len)
+		ret = -EINVAL;
+	else if (alg->verify)
+		ret = alg->verify(req);
+	else
+		ret = -ENOSYS;
 	crypto_stats_akcipher_verify(ret, calg);
 	return ret;
 }
-- 
2.11.0

