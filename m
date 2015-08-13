From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/13] crypto: qat - Remove reference to crypto_aead_crt
Date: Thu, 13 Aug 2015 17:29:04 +0800
Message-ID: <E1ZPooq-0005rH-4D@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35406 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbHMJ3J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:29:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The qat driver uses crypto_aead_crt in order to get the authsize.
This patch replaces it with the crypto_aead_authsize helper instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qat/qat_common/qat_algs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 1411e4c..b7099f2 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -274,7 +274,7 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 					 struct crypto_authenc_keys *keys)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(aead_tfm);
-	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
+	unsigned int digestsize = crypto_aead_authsize(aead_tfm);
 	struct qat_enc *enc_ctx = &ctx->enc_cd->qat_enc_cd;
 	struct icp_qat_hw_cipher_algo_blk *cipher = &enc_ctx->cipher;
 	struct icp_qat_hw_auth_algo_blk *hash =
@@ -354,7 +354,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 					 struct crypto_authenc_keys *keys)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(aead_tfm);
-	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
+	unsigned int digestsize = crypto_aead_authsize(aead_tfm);
 	struct qat_dec *dec_ctx = &ctx->dec_cd->qat_dec_cd;
 	struct icp_qat_hw_auth_algo_blk *hash = &dec_ctx->hash;
 	struct icp_qat_hw_cipher_algo_blk *cipher =
@@ -797,7 +797,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	int digst_size = crypto_aead_crt(aead_tfm)->authsize;
+	int digst_size = crypto_aead_authsize(aead_tfm);
 	int ret, ctr = 0;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
