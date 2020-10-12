Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D4FC43457
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8007208D5
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgJLUjF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:33900 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:04 -0400
IronPort-SDR: xZJN1uUsvRo+xpT6hnf+WobStR3o4CEmJbdyrQ0NANtXJM9kzBNXuRHXwVY9WHKThQnw0cOMoD
 i+cQuqqechEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913055"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913055"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:03 -0700
IronPort-SDR: YlNOI/0aAUqvjMnlbHBIF87wlu6mOQbPs+EEZ8vZVuL1dc4MBmXLXWfdj3MYJFfz4FTdPW0mlx
 mYkKcwEZRe2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328111"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:01 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Mateusz Polrola <mateuszx.potrola@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Indrasena Reddy Gali <indrasena.reddygali@intel.com>
Subject: [PATCH 01/31] crypto: qat - update IV in software
Date:   Mon, 12 Oct 2020 21:38:17 +0100
Message-Id: <20201012203847.340030-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Do IV update calculations in software for AES-CBC and AES-CTR.

This allows to embed the IV on the request descriptor and removes the
allocation of the IV buffer in the data path.

In addition, this change allows the support of QAT devices that are not
capable of updating the IV buffer when performing an AES-CBC or AES-CTR
operation.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Mateusz Polrola <mateuszx.potrola@intel.com>
Signed-off-by: Mateusz Polrola <mateuszx.potrola@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Indrasena Reddy Gali <indrasena.reddygali@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c   | 136 ++++++++++++---------
 drivers/crypto/qat/qat_common/qat_crypto.h |  11 +-
 2 files changed, 89 insertions(+), 58 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index d552dbcfe0a0..a38afc61f6d2 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -11,6 +11,7 @@
 #include <crypto/hmac.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
@@ -90,6 +91,7 @@ struct qat_alg_skcipher_ctx {
 	struct qat_crypto_instance *inst;
 	struct crypto_skcipher *ftfm;
 	bool fallback;
+	int mode;
 };
 
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
@@ -214,24 +216,7 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	return 0;
 }
 
-static void qat_alg_init_hdr_iv_updt(struct icp_qat_fw_comn_req_hdr *header)
-{
-	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
-					   ICP_QAT_FW_CIPH_IV_64BIT_PTR);
-	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
-				       ICP_QAT_FW_LA_UPDATE_STATE);
-}
-
-static void qat_alg_init_hdr_no_iv_updt(struct icp_qat_fw_comn_req_hdr *header)
-{
-	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
-					   ICP_QAT_FW_CIPH_IV_16BYTE_DATA);
-	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
-				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
-}
-
-static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header,
-				    int aead)
+static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 {
 	header->hdr_flags =
 		ICP_QAT_FW_COMN_HDR_FLAGS_BUILD(ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -241,12 +226,12 @@ static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header,
 					    QAT_COMN_PTR_TYPE_SGL);
 	ICP_QAT_FW_LA_PARTIAL_SET(header->serv_specif_flags,
 				  ICP_QAT_FW_LA_PARTIAL_NONE);
-	if (aead)
-		qat_alg_init_hdr_no_iv_updt(header);
-	else
-		qat_alg_init_hdr_iv_updt(header);
+	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_CIPH_IV_16BYTE_DATA);
 	ICP_QAT_FW_LA_PROTO_SET(header->serv_specif_flags,
 				ICP_QAT_FW_LA_NO_PROTO);
+	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
+				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
 }
 
 static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
@@ -281,7 +266,7 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 		return -EFAULT;
 
 	/* Request setup */
-	qat_alg_init_common_hdr(header, 1);
+	qat_alg_init_common_hdr(header);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER_HASH;
 	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
 					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
@@ -368,7 +353,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 		return -EFAULT;
 
 	/* Request setup */
-	qat_alg_init_common_hdr(header, 1);
+	qat_alg_init_common_hdr(header);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_HASH_CIPHER;
 	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
 					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
@@ -432,7 +417,7 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 	struct icp_qat_fw_cipher_cd_ctrl_hdr *cd_ctrl = (void *)&req->cd_ctrl;
 
 	memcpy(cd->aes.key, key, keylen);
-	qat_alg_init_common_hdr(header, 0);
+	qat_alg_init_common_hdr(header);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER;
 	cd_pars->u.s.content_desc_params_sz =
 				sizeof(struct icp_qat_hw_cipher_algo_blk) >> 3;
@@ -787,6 +772,61 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	areq->base.complete(&areq->base, res);
 }
 
+static void qat_alg_update_iv_ctr_mode(struct qat_crypto_request *qat_req)
+{
+	struct skcipher_request *sreq = qat_req->skcipher_req;
+	u64 iv_lo_prev;
+	u64 iv_lo;
+	u64 iv_hi;
+
+	memcpy(qat_req->iv, sreq->iv, AES_BLOCK_SIZE);
+
+	iv_lo = be64_to_cpu(qat_req->iv_lo);
+	iv_hi = be64_to_cpu(qat_req->iv_hi);
+
+	iv_lo_prev = iv_lo;
+	iv_lo += DIV_ROUND_UP(sreq->cryptlen, AES_BLOCK_SIZE);
+	if (iv_lo < iv_lo_prev)
+		iv_hi++;
+
+	qat_req->iv_lo = cpu_to_be64(iv_lo);
+	qat_req->iv_hi = cpu_to_be64(iv_hi);
+}
+
+static void qat_alg_update_iv_cbc_mode(struct qat_crypto_request *qat_req)
+{
+	struct skcipher_request *sreq = qat_req->skcipher_req;
+	int offset = sreq->cryptlen - AES_BLOCK_SIZE;
+	struct scatterlist *sgl;
+
+	if (qat_req->encryption)
+		sgl = sreq->dst;
+	else
+		sgl = sreq->src;
+
+	scatterwalk_map_and_copy(qat_req->iv, sgl, offset, AES_BLOCK_SIZE, 0);
+}
+
+static void qat_alg_update_iv(struct qat_crypto_request *qat_req)
+{
+	struct qat_alg_skcipher_ctx *ctx = qat_req->skcipher_ctx;
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+
+	switch (ctx->mode) {
+	case ICP_QAT_HW_CIPHER_CTR_MODE:
+		qat_alg_update_iv_ctr_mode(qat_req);
+		break;
+	case ICP_QAT_HW_CIPHER_CBC_MODE:
+		qat_alg_update_iv_cbc_mode(qat_req);
+		break;
+	case ICP_QAT_HW_CIPHER_XTS_MODE:
+		break;
+	default:
+		dev_warn(dev, "Unsupported IV update for cipher mode %d\n",
+			 ctx->mode);
+	}
+}
+
 static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 				      struct qat_crypto_request *qat_req)
 {
@@ -794,16 +834,16 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct skcipher_request *sreq = qat_req->skcipher_req;
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
-	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
 	qat_alg_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EINVAL;
 
+	if (qat_req->encryption)
+		qat_alg_update_iv(qat_req);
+
 	memcpy(sreq->iv, qat_req->iv, AES_BLOCK_SIZE);
-	dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-			  qat_req->iv_paddr);
 
 	sreq->base.complete(&sreq->base, res);
 }
@@ -981,6 +1021,8 @@ static int qat_alg_skcipher_setkey(struct crypto_skcipher *tfm,
 {
 	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	ctx->mode = mode;
+
 	if (ctx->enc_cd)
 		return qat_alg_skcipher_rekey(ctx, key, keylen, mode);
 	else
@@ -1035,23 +1077,14 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int ret, ctr = 0;
 
 	if (req->cryptlen == 0)
 		return 0;
 
-	qat_req->iv = dma_alloc_coherent(dev, AES_BLOCK_SIZE,
-					 &qat_req->iv_paddr, GFP_ATOMIC);
-	if (!qat_req->iv)
-		return -ENOMEM;
-
 	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
-	if (unlikely(ret)) {
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
+	if (unlikely(ret))
 		return ret;
-	}
 
 	msg = &qat_req->req;
 	*msg = ctx->enc_fw_req;
@@ -1061,19 +1094,18 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	qat_req->req.comn_mid.opaque_data = (u64)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
+	qat_req->encryption = true;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = req->cryptlen;
 	cipher_param->cipher_offset = 0;
-	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
-	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
+	memcpy(cipher_param->u.cipher_IV_array, req->iv, AES_BLOCK_SIZE);
+
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
 		qat_alg_free_bufl(ctx->inst, qat_req);
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
 		return -EBUSY;
 	}
 	return -EINPROGRESS;
@@ -1113,23 +1145,14 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int ret, ctr = 0;
 
 	if (req->cryptlen == 0)
 		return 0;
 
-	qat_req->iv = dma_alloc_coherent(dev, AES_BLOCK_SIZE,
-					 &qat_req->iv_paddr, GFP_ATOMIC);
-	if (!qat_req->iv)
-		return -ENOMEM;
-
 	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
-	if (unlikely(ret)) {
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
+	if (unlikely(ret))
 		return ret;
-	}
 
 	msg = &qat_req->req;
 	*msg = ctx->dec_fw_req;
@@ -1139,19 +1162,20 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	qat_req->req.comn_mid.opaque_data = (u64)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
+	qat_req->encryption = false;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = req->cryptlen;
 	cipher_param->cipher_offset = 0;
-	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
-	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
+	memcpy(cipher_param->u.cipher_IV_array, req->iv, AES_BLOCK_SIZE);
+
+	qat_alg_update_iv(qat_req);
+
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
 		qat_alg_free_bufl(ctx->inst, qat_req);
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
 		return -EBUSY;
 	}
 	return -EINPROGRESS;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 12682d1e9f5f..8d11e94cbf08 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -3,6 +3,7 @@
 #ifndef _QAT_CRYPTO_INSTANCE_H_
 #define _QAT_CRYPTO_INSTANCE_H_
 
+#include <crypto/aes.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include "adf_accel_devices.h"
@@ -44,8 +45,14 @@ struct qat_crypto_request {
 	struct qat_crypto_request_buffs buf;
 	void (*cb)(struct icp_qat_fw_la_resp *resp,
 		   struct qat_crypto_request *req);
-	void *iv;
-	dma_addr_t iv_paddr;
+	union {
+		struct {
+			__be64 iv_hi;
+			__be64 iv_lo;
+		};
+		u8 iv[AES_BLOCK_SIZE];
+	};
+	bool encryption;
 };
 
 #endif
-- 
2.26.2

