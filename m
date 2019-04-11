Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7CAC282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6A620818
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbfDKPvt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:51:49 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44342 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfDKPvs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 11:51:48 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 8F0A972CCAE;
        Thu, 11 Apr 2019 18:51:45 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 2A5A34A4A2A;
        Thu, 11 Apr 2019 18:51:45 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>, qat-linux@intel.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: [PATCH v9 02/10] crypto: rsa - unimplement sign/verify for raw RSA backends
Date:   Thu, 11 Apr 2019 18:51:14 +0300
Message-Id: <20190411155122.13245-3-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190411155122.13245-1-vt@altlinux.org>
References: <20190411155122.13245-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation for new akcipher verify call remove sign/verify callbacks
from RSA backends and make PKCS1 driver call encrypt/decrypt instead.

This also complies with the well-known idea that raw RSA should never be
used for sign/verify. It only should be used with proper padding scheme
such as PKCS1 driver provides.

Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: qat-linux@intel.com
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
---
 crypto/rsa-pkcs1pad.c                         |   4 +-
 crypto/rsa.c                                  | 109 --------------------------
 drivers/crypto/caam/caampkc.c                 |   2 -
 drivers/crypto/ccp/ccp-crypto-rsa.c           |   2 -
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   2 -
 5 files changed, 2 insertions(+), 117 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 0a6680ca8cb6..94382fa2c6ac 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -429,7 +429,7 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
 				   req->dst, ctx->key_size - 1, req->dst_len);
 
-	err = crypto_akcipher_sign(&req_ctx->child_req);
+	err = crypto_akcipher_decrypt(&req_ctx->child_req);
 	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_encrypt_sign_complete(req, err);
 
@@ -551,7 +551,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
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
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 58285642306e..fe24485274e1 100644
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
index 841acdffbc3c..a2570c0c8cdc 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -213,8 +213,6 @@ static void ccp_rsa_exit_tfm(struct crypto_akcipher *tfm)
 static struct akcipher_alg ccp_rsa_defaults = {
 	.encrypt = ccp_rsa_encrypt,
 	.decrypt = ccp_rsa_decrypt,
-	.sign = ccp_rsa_decrypt,
-	.verify = ccp_rsa_encrypt,
 	.set_pub_key = ccp_rsa_setpubkey,
 	.set_priv_key = ccp_rsa_setprivkey,
 	.max_size = ccp_rsa_maxsize,
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index c9f324730d71..692a7aaee749 100644
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
-- 
2.11.0

