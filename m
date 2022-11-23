Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29321C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 12:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiKWMLK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbiKWMLD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 07:11:03 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0348D64A23
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 04:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669205450; x=1700741450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HF7aulUL6mziOvlIVFds4+N6JMs4QqxjfrRCz6I4nRA=;
  b=lgb86Egkm45M09pXWKdC0ZEhsldojod/4yGEgt8UgjsbLqvx+p8XXpqu
   kkj4vDPxiGqz56EFPajcxtuYIJNDRDCmhfmgc+qUbUptIFy2ev0RfF5iM
   oAu/efNo0A/UfVIktuU5TKRfEbkXwNK0nQ54ZwvusMRdmYFveRvYObf7N
   6J3cB3DhhXhV0Qi21G87VCxfk5KB6nBuOjay6qFz3HWG7w+fXFQEg2AE6
   SD9/O1BWUt+KWBNdFuBooiX4mPHzOWjH3CXpvXHuR4X5OhkmITYCHHKVT
   liGIrtsr/w6CXCg9H5CjCaZHA02MYm8sukjexN9uRhLsrnqLqN218skcg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312752486"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312752486"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 04:10:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784227483"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784227483"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 04:10:47 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH v2 05/11] crypto: qat - extend buffer list interface
Date:   Wed, 23 Nov 2022 12:10:26 +0000
Message-Id: <20221123121032.71991-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The compression service requires an additional pre-allocated buffer for
each destination scatter list.
Extend the function qat_alg_sgl_to_bufl() to take an additional
structure that contains the dma address and the size of the extra
buffer which will be appended in the destination FW SGL.

The logic that unmaps buffers in qat_alg_free_bufl() has been changed to
start unmapping from buffer 0 instead of skipping the initial buffers
num_buff - num_mapped_bufs as that functionality was not used in the
code.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |  8 ++--
 drivers/crypto/qat/qat_common/qat_bl.c   | 58 ++++++++++++++++++------
 drivers/crypto/qat/qat_common/qat_bl.h   |  6 +++
 3 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index dfa65e42db78..b4b9f0aa59b9 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -800,7 +800,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 		return -EINVAL;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -844,7 +844,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 		return -EINVAL;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1030,7 +1030,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 		return 0;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1097,7 +1097,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 		return 0;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index c32b12d386f0..221a4eb610a3 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -35,10 +35,7 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 		kfree(bl);
 
 	if (blp != blpout) {
-		/* If out of place operation dma unmap only data */
-		int bufless = blout->num_bufs - blout->num_mapped_bufs;
-
-		for (i = bufless; i < blout->num_bufs; i++) {
+		for (i = 0; i < blout->num_mapped_bufs; i++) {
 			dma_unmap_single(dev, blout->bufers[i].addr,
 					 blout->bufers[i].len,
 					 DMA_FROM_DEVICE);
@@ -50,11 +47,13 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 	}
 }
 
-int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
-		       struct scatterlist *sgl,
-		       struct scatterlist *sglout,
-		       struct qat_request_buffs *buf,
-		       gfp_t flags)
+static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
+				struct scatterlist *sgl,
+				struct scatterlist *sglout,
+				struct qat_request_buffs *buf,
+				dma_addr_t extra_dst_buff,
+				size_t sz_extra_dst_buff,
+				gfp_t flags)
 {
 	struct device *dev = &GET_DEV(accel_dev);
 	int i, sg_nctr = 0;
@@ -86,7 +85,7 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 
 	bufl_dma_dir = sgl != sglout ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 
-	for_each_sg(sgl, sg, n, i)
+	for (i = 0; i < n; i++)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
 
 	for_each_sg(sgl, sg, n, i) {
@@ -113,8 +112,10 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	/* Handle out of place operation */
 	if (sgl != sglout) {
 		struct qat_alg_buf *bufers;
+		int extra_buff = extra_dst_buff ? 1 : 0;
+		int n_sglout = sg_nents(sglout);
 
-		n = sg_nents(sglout);
+		n = n_sglout + extra_buff;
 		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
 
@@ -129,10 +130,10 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		}
 
 		bufers = buflout->bufers;
-		for_each_sg(sglout, sg, n, i)
+		for (i = 0; i < n; i++)
 			bufers[i].addr = DMA_MAPPING_ERROR;
 
-		for_each_sg(sglout, sg, n, i) {
+		for_each_sg(sglout, sg, n_sglout, i) {
 			int y = sg_nctr;
 
 			if (!sg->length)
@@ -146,7 +147,13 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			bufers[y].len = sg->length;
 			sg_nctr++;
 		}
+		if (extra_buff) {
+			bufers[sg_nctr].addr = extra_dst_buff;
+			bufers[sg_nctr].len = sz_extra_dst_buff;
+		}
+
 		buflout->num_bufs = sg_nctr;
+		buflout->num_bufs += extra_buff;
 		buflout->num_mapped_bufs = sg_nctr;
 		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, bloutp)))
@@ -166,11 +173,14 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
 
 	n = sg_nents(sglout);
-	for (i = 0; i < n; i++)
+	for (i = 0; i < n; i++) {
+		if (buflout->bufers[i].addr == extra_dst_buff)
+			break;
 		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_FROM_DEVICE);
+	}
 
 	if (!buf->sgl_dst_valid)
 		kfree(buflout);
@@ -192,3 +202,23 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
 }
+
+int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
+		       struct scatterlist *sgl,
+		       struct scatterlist *sglout,
+		       struct qat_request_buffs *buf,
+		       struct qat_sgl_to_bufl_params *params,
+		       gfp_t flags)
+{
+	dma_addr_t extra_dst_buff = 0;
+	size_t sz_extra_dst_buff = 0;
+
+	if (params) {
+		extra_dst_buff = params->extra_dst_buff;
+		sz_extra_dst_buff = params->sz_extra_dst_buff;
+	}
+
+	return __qat_bl_sgl_to_bufl(accel_dev, sgl, sglout, buf,
+				    extra_dst_buff, sz_extra_dst_buff,
+				    flags);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 1c534c57a36b..0c174fee9e64 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -38,12 +38,18 @@ struct qat_request_buffs {
 	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
+struct qat_sgl_to_bufl_params {
+	dma_addr_t extra_dst_buff;
+	size_t sz_extra_dst_buff;
+};
+
 void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 		      struct qat_request_buffs *buf);
 int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		       struct scatterlist *sgl,
 		       struct scatterlist *sglout,
 		       struct qat_request_buffs *buf,
+		       struct qat_sgl_to_bufl_params *params,
 		       gfp_t flags);
 
 #endif
-- 
2.38.1

