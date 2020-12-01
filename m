Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01987C64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E7F20757
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgLAOZn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:25:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:7317 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbgLAOZm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:25:42 -0500
IronPort-SDR: uY6/ZphWWUBHUz/KYYjbp4iLzFc4ae/uA499RCn9m/R9THroK17tc90aJ6iJbjpJwJXzAvm0hK
 kVOB/8tUhz5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160603454"
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="160603454"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 06:24:59 -0800
IronPort-SDR: x81Oz3N+yNDw8iZaOoZK3XPDJvG1NCaXOiButaXQsqZCMFnDH9qxq5KRMLfzBPCaTbzbxsZyG4
 xyWGmrPACmvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="345478644"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 01 Dec 2020 06:24:58 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/3] crypto: qat - add AES-XTS support for QAT GEN4 devices
Date:   Tue,  1 Dec 2020 14:24:50 +0000
Message-Id: <20201201142451.138221-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
References: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Add handling of AES-XTS specific to QAT GEN4 devices.

Co-developed-by: Tomaszx Kowalik <tomaszx.kowalik@intel.com>
Signed-off-by: Tomaszx Kowalik <tomaszx.kowalik@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 96 ++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 84d1a3545c3a..31c7a206a629 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -33,6 +33,11 @@
 				       ICP_QAT_HW_CIPHER_KEY_CONVERT, \
 				       ICP_QAT_HW_CIPHER_DECRYPT)
 
+#define QAT_AES_HW_CONFIG_DEC_NO_CONV(alg, mode) \
+	ICP_QAT_HW_CIPHER_CONFIG_BUILD(mode, alg, \
+				       ICP_QAT_HW_CIPHER_NO_CONVERT, \
+				       ICP_QAT_HW_CIPHER_DECRYPT)
+
 #define HW_CAP_AES_V2(accel_dev) \
 	(GET_HW_DATA(accel_dev)->accel_capabilities_mask & \
 	 ICP_ACCEL_CAPABILITIES_AES_V2)
@@ -95,6 +100,7 @@ struct qat_alg_skcipher_ctx {
 	struct icp_qat_fw_la_bulk_req dec_fw_req;
 	struct qat_crypto_instance *inst;
 	struct crypto_skcipher *ftfm;
+	struct crypto_cipher *tweak;
 	bool fallback;
 	int mode;
 };
@@ -428,7 +434,16 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 	cd_pars->u.s.content_desc_params_sz =
 				sizeof(struct icp_qat_hw_cipher_algo_blk) >> 3;
 
-	if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
+	if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_XTS_MODE) {
+		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
+					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
+
+		/* Store both XTS keys in CD, only the first key is sent
+		 * to the HW, the second key is used for tweak calculation
+		 */
+		memcpy(cd->ucs_aes.key, key, keylen);
+		keylen = keylen / 2;
+	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
 		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
 					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
 		keylen = round_up(keylen, 16);
@@ -458,6 +473,28 @@ static void qat_alg_skcipher_init_enc(struct qat_alg_skcipher_ctx *ctx,
 	enc_cd->aes.cipher_config.val = QAT_AES_HW_CONFIG_ENC(alg, mode);
 }
 
+static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
+				    u8 *key_reverse)
+{
+	struct crypto_aes_ctx aes_expanded;
+	int nrounds;
+	u8 *key;
+
+	aes_expandkey(&aes_expanded, key_forward, keylen);
+	if (keylen == AES_KEYSIZE_128) {
+		nrounds = 10;
+		key = (u8 *)aes_expanded.key_enc + (AES_BLOCK_SIZE * nrounds);
+		memcpy(key_reverse, key, AES_BLOCK_SIZE);
+	} else {
+		/* AES_KEYSIZE_256 */
+		nrounds = 14;
+		key = (u8 *)aes_expanded.key_enc + (AES_BLOCK_SIZE * nrounds);
+		memcpy(key_reverse, key, AES_BLOCK_SIZE);
+		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
+		       AES_BLOCK_SIZE);
+	}
+}
+
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
 				      int alg, const u8 *key,
 				      unsigned int keylen, int mode)
@@ -465,16 +502,26 @@ static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
 	struct icp_qat_hw_cipher_algo_blk *dec_cd = ctx->dec_cd;
 	struct icp_qat_fw_la_bulk_req *req = &ctx->dec_fw_req;
 	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req->cd_pars;
+	bool aes_v2_capable = HW_CAP_AES_V2(ctx->inst->accel_dev);
 
 	qat_alg_skcipher_init_com(ctx, req, dec_cd, key, keylen);
 	cd_pars->u.s.content_desc_addr = ctx->dec_cd_paddr;
 
-	if (mode != ICP_QAT_HW_CIPHER_CTR_MODE)
+	if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_XTS_MODE) {
+		/* Key reversing not supported, set no convert */
+		dec_cd->aes.cipher_config.val =
+				QAT_AES_HW_CONFIG_DEC_NO_CONV(alg, mode);
+
+		/* In-place key reversal */
+		qat_alg_xts_reverse_key(dec_cd->ucs_aes.key, keylen / 2,
+					dec_cd->ucs_aes.key);
+	} else if (mode != ICP_QAT_HW_CIPHER_CTR_MODE) {
 		dec_cd->aes.cipher_config.val =
 					QAT_AES_HW_CONFIG_DEC(alg, mode);
-	else
+	} else {
 		dec_cd->aes.cipher_config.val =
 					QAT_AES_HW_CONFIG_ENC(alg, mode);
+	}
 }
 
 static int qat_alg_validate_key(int key_len, int *alg, int mode)
@@ -1081,8 +1128,33 @@ static int qat_alg_skcipher_xts_setkey(struct crypto_skcipher *tfm,
 
 	ctx->fallback = false;
 
-	return qat_alg_skcipher_setkey(tfm, key, keylen,
-				       ICP_QAT_HW_CIPHER_XTS_MODE);
+	ret = qat_alg_skcipher_setkey(tfm, key, keylen,
+				      ICP_QAT_HW_CIPHER_XTS_MODE);
+	if (ret)
+		return ret;
+
+	if (HW_CAP_AES_V2(ctx->inst->accel_dev))
+		ret = crypto_cipher_setkey(ctx->tweak, key + (keylen / 2),
+					   keylen / 2);
+
+	return ret;
+}
+
+static void qat_alg_set_req_iv(struct qat_crypto_request *qat_req)
+{
+	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	struct qat_alg_skcipher_ctx *ctx = qat_req->skcipher_ctx;
+	bool aes_v2_capable = HW_CAP_AES_V2(ctx->inst->accel_dev);
+	u8 *iv = qat_req->skcipher_req->iv;
+
+	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
+
+	if (aes_v2_capable && ctx->mode == ICP_QAT_HW_CIPHER_XTS_MODE)
+		crypto_cipher_encrypt_one(ctx->tweak,
+					  (u8 *)cipher_param->u.cipher_IV_array,
+					  iv);
+	else
+		memcpy(cipher_param->u.cipher_IV_array, iv, AES_BLOCK_SIZE);
 }
 
 static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
@@ -1114,7 +1186,8 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = req->cryptlen;
 	cipher_param->cipher_offset = 0;
-	memcpy(cipher_param->u.cipher_IV_array, req->iv, AES_BLOCK_SIZE);
+
+	qat_alg_set_req_iv(qat_req);
 
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
@@ -1182,8 +1255,8 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = req->cryptlen;
 	cipher_param->cipher_offset = 0;
-	memcpy(cipher_param->u.cipher_IV_array, req->iv, AES_BLOCK_SIZE);
 
+	qat_alg_set_req_iv(qat_req);
 	qat_alg_update_iv(qat_req);
 
 	do {
@@ -1293,6 +1366,12 @@ static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(ctx->ftfm))
 		return PTR_ERR(ctx->ftfm);
 
+	ctx->tweak = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(ctx->tweak)) {
+		crypto_free_skcipher(ctx->ftfm);
+		return PTR_ERR(ctx->tweak);
+	}
+
 	reqsize = max(sizeof(struct qat_crypto_request),
 		      sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(ctx->ftfm));
@@ -1335,6 +1414,9 @@ static void qat_alg_skcipher_exit_xts_tfm(struct crypto_skcipher *tfm)
 	if (ctx->ftfm)
 		crypto_free_skcipher(ctx->ftfm);
 
+	if (ctx->tweak)
+		crypto_free_cipher(ctx->tweak);
+
 	qat_alg_skcipher_exit_tfm(tfm);
 }
 
-- 
2.28.0

