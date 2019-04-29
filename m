Return-Path: <SRS0=wtno=S7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9219BC43219
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AA4E20675
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfD2PoU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Apr 2019 11:44:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:4157 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfD2PoU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Apr 2019 11:44:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 08:44:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="319990363"
Received: from silvixa00391824.ir.intel.com (HELO silvixa00391824.ger.corp.intel.com) ([10.237.222.24])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2019 08:44:17 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Conor Mcloughlin <conor.mcloughlin@intel.com>,
        Sergey Portnoy <sergey.portnoy@intel.com>
Subject: [PATCH 3/7] crypto: qat - update iv after encryption or decryption operations
Date:   Mon, 29 Apr 2019 16:43:17 +0100
Message-Id: <20190429154321.21098-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
References: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allocate a contiguous buffer and instruct the qat hardware to return the
iv at the end of an encryption or decryption operation.
The iv is copied to the array provided by the user in the callback
function.

This problem was found with by the crypto self test.

Reviewed-by: Conor Mcloughlin <conor.mcloughlin@intel.com>
Tested-by: Sergey Portnoy <sergey.portnoy@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c   | 71 ++++++++++++++++++----
 drivers/crypto/qat/qat_common/qat_crypto.h |  2 +
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index b60156d987eb..6be3e7413beb 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -255,7 +255,24 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	return 0;
 }
 
-static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
+static void qat_alg_init_hdr_iv_updt(struct icp_qat_fw_comn_req_hdr *header)
+{
+	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_CIPH_IV_64BIT_PTR);
+	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
+				       ICP_QAT_FW_LA_UPDATE_STATE);
+}
+
+static void qat_alg_init_hdr_no_iv_updt(struct icp_qat_fw_comn_req_hdr *header)
+{
+	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_CIPH_IV_16BYTE_DATA);
+	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
+				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
+}
+
+static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header,
+				    int aead)
 {
 	header->hdr_flags =
 		ICP_QAT_FW_COMN_HDR_FLAGS_BUILD(ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -265,12 +282,12 @@ static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 					    QAT_COMN_PTR_TYPE_SGL);
 	ICP_QAT_FW_LA_PARTIAL_SET(header->serv_specif_flags,
 				  ICP_QAT_FW_LA_PARTIAL_NONE);
-	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
-					   ICP_QAT_FW_CIPH_IV_16BYTE_DATA);
+	if (aead)
+		qat_alg_init_hdr_no_iv_updt(header);
+	else
+		qat_alg_init_hdr_iv_updt(header);
 	ICP_QAT_FW_LA_PROTO_SET(header->serv_specif_flags,
 				ICP_QAT_FW_LA_NO_PROTO);
-	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
-				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
 }
 
 static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
@@ -305,7 +322,7 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 		return -EFAULT;
 
 	/* Request setup */
-	qat_alg_init_common_hdr(header);
+	qat_alg_init_common_hdr(header, 1);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER_HASH;
 	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
 					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
@@ -392,7 +409,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 		return -EFAULT;
 
 	/* Request setup */
-	qat_alg_init_common_hdr(header);
+	qat_alg_init_common_hdr(header, 1);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_HASH_CIPHER;
 	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
 					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
@@ -456,7 +473,7 @@ static void qat_alg_ablkcipher_init_com(struct qat_alg_ablkcipher_ctx *ctx,
 	struct icp_qat_fw_cipher_cd_ctrl_hdr *cd_ctrl = (void *)&req->cd_ctrl;
 
 	memcpy(cd->aes.key, key, keylen);
-	qat_alg_init_common_hdr(header);
+	qat_alg_init_common_hdr(header, 0);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER;
 	cd_pars->u.s.content_desc_params_sz =
 				sizeof(struct icp_qat_hw_cipher_algo_blk) >> 3;
@@ -803,11 +820,17 @@ static void qat_ablkcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct ablkcipher_request *areq = qat_req->ablkcipher_req;
 	uint8_t stat_filed = qat_resp->comn_resp.comn_status;
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
 	qat_alg_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EINVAL;
+
+	memcpy(areq->info, qat_req->iv, AES_BLOCK_SIZE);
+	dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
+			  qat_req->iv_paddr);
+
 	areq->base.complete(&areq->base, res);
 }
 
@@ -989,11 +1012,20 @@ static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
 	struct qat_crypto_request *qat_req = ablkcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int ret, ctr = 0;
 
+	qat_req->iv = dma_alloc_coherent(dev, AES_BLOCK_SIZE,
+					 &qat_req->iv_paddr, GFP_ATOMIC);
+	if (!qat_req->iv)
+		return -ENOMEM;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
+				  qat_req->iv_paddr);
 		return ret;
+	}
 
 	msg = &qat_req->req;
 	*msg = ctx->enc_fw_req;
@@ -1006,13 +1038,16 @@ static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = req->nbytes;
 	cipher_param->cipher_offset = 0;
-	memcpy(cipher_param->u.cipher_IV_array, req->info, AES_BLOCK_SIZE);
+	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
+	memcpy(qat_req->iv, req->info, AES_BLOCK_SIZE);
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
 		qat_alg_free_bufl(ctx->inst, qat_req);
+		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
+				  qat_req->iv_paddr);
 		return -EBUSY;
 	}
 	return -EINPROGRESS;
@@ -1026,11 +1061,20 @@ static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 	struct qat_crypto_request *qat_req = ablkcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int ret, ctr = 0;
 
+	qat_req->iv = dma_alloc_coherent(dev, AES_BLOCK_SIZE,
+					 &qat_req->iv_paddr, GFP_ATOMIC);
+	if (!qat_req->iv)
+		return -ENOMEM;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
+				  qat_req->iv_paddr);
 		return ret;
+	}
 
 	msg = &qat_req->req;
 	*msg = ctx->dec_fw_req;
@@ -1043,13 +1087,16 @@ static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = req->nbytes;
 	cipher_param->cipher_offset = 0;
-	memcpy(cipher_param->u.cipher_IV_array, req->info, AES_BLOCK_SIZE);
+	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
+	memcpy(qat_req->iv, req->info, AES_BLOCK_SIZE);
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
 		qat_alg_free_bufl(ctx->inst, qat_req);
+		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
+				  qat_req->iv_paddr);
 		return -EBUSY;
 	}
 	return -EINPROGRESS;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index dc0273fe3620..c77a80020cde 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -88,6 +88,8 @@ struct qat_crypto_request {
 	struct qat_crypto_request_buffs buf;
 	void (*cb)(struct icp_qat_fw_la_resp *resp,
 		   struct qat_crypto_request *req);
+	void *iv;
+	dma_addr_t iv_paddr;
 };
 
 #endif
-- 
2.20.1

