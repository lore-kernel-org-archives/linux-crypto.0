Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF91C00140
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbiHRSBs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbiHRSBn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF574621A
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845702; x=1692381702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zp/0JtOio550VkVE2a+lu+q7ItmZoAeboSqTVT3+xjg=;
  b=f9VUPT+oQuVXis4r6O7akq1gdxzOyxiwY86ajRt/lDM8dXCFatu7fhBX
   F/nODOrbFVC0ab1XGbGgfANsCDey8yPIM48B7fG1Jlr0Vy1XvE05QMThP
   nMXT8+h/citPnGrRCCrdOLDjXPDIPPni3Nq70bg7mXPK7RBqKNkSjTCFV
   MEzNvX+GvyF6Ro4caWnQAteg/wW9K7PaXuW33SPMe2tEkZRaOL6QimAKW
   pjTXX/eqBR3mXblpztqWJ2py/ei84aWjnBlIzazSlFK3JmRpsC1ZmXh5T
   +HLm98htmilcLnkAGNUyk1NRVvab/Z3woWKdbWicauw63xXkX44iSagTl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109424"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109424"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919487"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:40 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 2/9] crypto: qat - change bufferlist logic interface
Date:   Thu, 18 Aug 2022 19:01:13 +0100
Message-Id: <20220818180120.63452-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The functions qat_alg_sgl_to_bufl() and qat_alg_free_bufl() take as
argument a qat_crypto_instance and a qat_crypto_request structure.
These two structures are used only to get a reference to the
adf_accel_dev and qat_crypto_request_buffs.

In order to reuse these functions for the compression service, change
the signature so that they take adf_accel_dev and
qat_crypto_request_buffs.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 24 +++++----
 drivers/crypto/qat/qat_common/qat_bl.c   | 62 ++++++++++++------------
 drivers/crypto/qat/qat_common/qat_bl.h   |  8 +--
 3 files changed, 49 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2ee4fa64032f..387d83b19bc1 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -673,7 +673,7 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
-	qat_alg_free_bufl(inst, qat_req);
+	qat_alg_free_bufl(inst->accel_dev, &qat_req->buf);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
 	areq->base.complete(&areq->base, res);
@@ -743,7 +743,7 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
-	qat_alg_free_bufl(inst, qat_req);
+	qat_alg_free_bufl(inst->accel_dev, &qat_req->buf);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EINVAL;
 
@@ -799,7 +799,8 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	if (cipher_len % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
+	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
+				  &qat_req->buf, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -821,7 +822,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_alg_free_bufl(ctx->inst->accel_dev, &qat_req->buf);
 
 	return ret;
 }
@@ -842,7 +843,8 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
+	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
+				  &qat_req->buf, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -866,7 +868,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_alg_free_bufl(ctx->inst->accel_dev, &qat_req->buf);
 
 	return ret;
 }
@@ -1027,7 +1029,8 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
+	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
+				  &qat_req->buf, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1048,7 +1051,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_alg_free_bufl(ctx->inst->accel_dev, &qat_req->buf);
 
 	return ret;
 }
@@ -1093,7 +1096,8 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
+	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
+				  &qat_req->buf, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1115,7 +1119,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_alg_free_bufl(ctx->inst->accel_dev, &qat_req->buf);
 
 	return ret;
 }
diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 5c2837aba3ad..62834aa5bce7 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -10,16 +10,16 @@
 #include "qat_bl.h"
 #include "qat_crypto.h"
 
-void qat_alg_free_bufl(struct qat_crypto_instance *inst,
-		       struct qat_crypto_request *qat_req)
+void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
+		       struct qat_crypto_request_buffs *buf)
 {
-	struct device *dev = &GET_DEV(inst->accel_dev);
-	struct qat_alg_buf_list *bl = qat_req->buf.bl;
-	struct qat_alg_buf_list *blout = qat_req->buf.blout;
-	dma_addr_t blp = qat_req->buf.blp;
-	dma_addr_t blpout = qat_req->buf.bloutp;
-	size_t sz = qat_req->buf.sz;
-	size_t sz_out = qat_req->buf.sz_out;
+	struct device *dev = &GET_DEV(accel_dev);
+	struct qat_alg_buf_list *bl = buf->bl;
+	struct qat_alg_buf_list *blout = buf->blout;
+	dma_addr_t blp = buf->blp;
+	dma_addr_t blpout = buf->bloutp;
+	size_t sz = buf->sz;
+	size_t sz_out = buf->sz_out;
 	int i;
 
 	for (i = 0; i < bl->num_bufs; i++)
@@ -28,7 +28,7 @@ void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
 
-	if (!qat_req->buf.sgl_src_valid)
+	if (!buf->sgl_src_valid)
 		kfree(bl);
 
 	if (blp != blpout) {
@@ -42,18 +42,18 @@ void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
 
-		if (!qat_req->buf.sgl_dst_valid)
+		if (!buf->sgl_dst_valid)
 			kfree(blout);
 	}
 }
 
-int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
+int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			struct scatterlist *sgl,
 			struct scatterlist *sglout,
-			struct qat_crypto_request *qat_req,
+			struct qat_crypto_request_buffs *buf,
 			gfp_t flags)
 {
-	struct device *dev = &GET_DEV(inst->accel_dev);
+	struct device *dev = &GET_DEV(accel_dev);
 	int i, sg_nctr = 0;
 	int n = sg_nents(sgl);
 	struct qat_alg_buf_list *bufl;
@@ -62,22 +62,22 @@ int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
 	size_t sz_out, sz = struct_size(bufl, bufers, n);
-	int node = dev_to_node(&GET_DEV(inst->accel_dev));
+	int node = dev_to_node(&GET_DEV(accel_dev));
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	qat_req->buf.sgl_src_valid = false;
-	qat_req->buf.sgl_dst_valid = false;
+	buf->sgl_src_valid = false;
+	buf->sgl_dst_valid = false;
 
 	if (n > QAT_MAX_BUFF_DESC) {
 		bufl = kzalloc_node(sz, flags, node);
 		if (unlikely(!bufl))
 			return -ENOMEM;
 	} else {
-		bufl = &qat_req->buf.sgl_src.sgl_hdr;
+		bufl = &buf->sgl_src.sgl_hdr;
 		memset(bufl, 0, sizeof(struct qat_alg_buf_list));
-		qat_req->buf.sgl_src_valid = true;
+		buf->sgl_src_valid = true;
 	}
 
 	for_each_sg(sgl, sg, n, i)
@@ -101,9 +101,9 @@ int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, blp)))
 		goto err_in;
-	qat_req->buf.bl = bufl;
-	qat_req->buf.blp = blp;
-	qat_req->buf.sz = sz;
+	buf->bl = bufl;
+	buf->blp = blp;
+	buf->sz = sz;
 	/* Handle out of place operation */
 	if (sgl != sglout) {
 		struct qat_alg_buf *bufers;
@@ -117,9 +117,9 @@ int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			if (unlikely(!buflout))
 				goto err_in;
 		} else {
-			buflout = &qat_req->buf.sgl_dst.sgl_hdr;
+			buflout = &buf->sgl_dst.sgl_hdr;
 			memset(buflout, 0, sizeof(struct qat_alg_buf_list));
-			qat_req->buf.sgl_dst_valid = true;
+			buf->sgl_dst_valid = true;
 		}
 
 		bufers = buflout->bufers;
@@ -145,13 +145,13 @@ int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, bloutp)))
 			goto err_out;
-		qat_req->buf.blout = buflout;
-		qat_req->buf.bloutp = bloutp;
-		qat_req->buf.sz_out = sz_out;
+		buf->blout = buflout;
+		buf->bloutp = bloutp;
+		buf->sz_out = sz_out;
 	} else {
 		/* Otherwise set the src and dst to the same address */
-		qat_req->buf.bloutp = qat_req->buf.blp;
-		qat_req->buf.sz_out = 0;
+		buf->bloutp = buf->blp;
+		buf->sz_out = 0;
 	}
 	return 0;
 
@@ -166,7 +166,7 @@ int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	if (!qat_req->buf.sgl_dst_valid)
+	if (!buf->sgl_dst_valid)
 		kfree(buflout);
 
 err_in:
@@ -180,7 +180,7 @@ int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	if (!qat_req->buf.sgl_src_valid)
+	if (!buf->sgl_src_valid)
 		kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 538e0ed52d6f..902fd7fcde66 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -6,12 +6,12 @@
 #include <linux/types.h>
 #include "qat_crypto.h"
 
-void qat_alg_free_bufl(struct qat_crypto_instance *inst,
-		       struct qat_crypto_request *qat_req);
-int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
+void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
+		       struct qat_crypto_request_buffs *buf);
+int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			struct scatterlist *sgl,
 			struct scatterlist *sglout,
-			struct qat_crypto_request *qat_req,
+			struct qat_crypto_request_buffs *buf,
 			gfp_t flags);
 
 #endif
-- 
2.37.1

