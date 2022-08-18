Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D23C00140
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345165AbiHRSB5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242519AbiHRSBr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A266B4D813
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845705; x=1692381705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KOfvS7BqAEvFKyD2zMKQx3rT/m/SIStmkPJKu58NYmo=;
  b=NAxnN494rsvtgtVeLQRxvJmfNSCB0aPUdKGz6cRuJirOUpQ04PkWZACN
   jLCTbvom1Eody9Zw9AvWxnI9acO/BDUC+ydOGEw5DgdT8M9MWdXZc6/Rt
   jGs/VDBl2F84DYVkewFUFFpa/Y/10F5NYnvvkkNw9DWrRgL7T8+X7K8x6
   KuXmOKKMRZJrRilQshM8ksqXQbVjBAGVqGzHkuPCsHGt7177kb+CDYY+7
   sp0rgA0Q1ocpDOCKv+sd5AUe9s2V6dnQQmiMs9YQVfqPzPtgiF2bYE8NU
   wwdy6M9NzuTdWUhhCTiKlIlkXlWJlBD/e1Uz3f/3vFhyMebvYl0nqmWDu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109443"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109443"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919532"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:43 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 4/9] crypto: qat - extend buffer list interface
Date:   Thu, 18 Aug 2022 19:01:15 +0100
Message-Id: <20220818180120.63452-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
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
 drivers/crypto/qat/qat_common/qat_algs.c |  8 ++---
 drivers/crypto/qat/qat_common/qat_bl.c   | 46 ++++++++++++++++++------
 drivers/crypto/qat/qat_common/qat_bl.h   |  6 ++++
 3 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 387d83b19bc1..42c0a77e7e2d 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -800,7 +800,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 		return -EINVAL;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
-				  &qat_req->buf, f);
+				  &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -844,7 +844,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 		return -EINVAL;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
-				  &qat_req->buf, f);
+				  &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1030,7 +1030,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 		return 0;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
-				  &qat_req->buf, f);
+				  &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1097,7 +1097,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 		return 0;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
-				  &qat_req->buf, f);
+				  &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 31addc2ee48e..f9e71a1c363e 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -32,10 +32,7 @@ void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
 		kfree(bl);
 
 	if (blp != blpout) {
-		/* If out of place operation dma unmap only data */
-		int bufless = blout->num_bufs - blout->num_mapped_bufs;
-
-		for (i = bufless; i < blout->num_bufs; i++) {
+		for (i = 0; i < blout->num_mapped_bufs; i++) {
 			dma_unmap_single(dev, blout->bufers[i].addr,
 					 blout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
@@ -47,11 +44,13 @@ void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
 	}
 }
 
-int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
-			struct scatterlist *sgl,
-			struct scatterlist *sglout,
-			struct qat_request_buffs *buf,
-			gfp_t flags)
+static int __qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
+				 struct scatterlist *sgl,
+				 struct scatterlist *sglout,
+				 struct qat_request_buffs *buf,
+				 dma_addr_t extra_dst_buff,
+				 size_t sz_extra_dst_buff,
+				 gfp_t flags)
 {
 	struct device *dev = &GET_DEV(accel_dev);
 	int i, sg_nctr = 0;
@@ -107,9 +106,10 @@ int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	/* Handle out of place operation */
 	if (sgl != sglout) {
 		struct qat_alg_buf *bufers;
+		int extra_buff = extra_dst_buff ? 1 : 0;
 
 		n = sg_nents(sglout);
-		sz_out = struct_size(buflout, bufers, n);
+		sz_out = struct_size(buflout, bufers, n + extra_buff);
 		sg_nctr = 0;
 
 		if (n > QAT_MAX_BUFF_DESC) {
@@ -140,7 +140,13 @@ int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
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
@@ -186,3 +192,23 @@ int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
 }
+
+int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
+			struct scatterlist *sgl,
+			struct scatterlist *sglout,
+			struct qat_request_buffs *buf,
+			struct qat_sgl_to_bufl_params *params,
+			gfp_t flags)
+{
+	dma_addr_t extra_dst_buff = 0;
+	size_t sz_extra_dst_buff = 0;
+
+	if (params) {
+		extra_dst_buff = params->extra_dst_buff;
+		sz_extra_dst_buff = params->sz_extra_dst_buff;
+	}
+
+	return __qat_alg_sgl_to_bufl(accel_dev, sgl, sglout, buf,
+				     extra_dst_buff, sz_extra_dst_buff,
+				     flags);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 7b66c2b92824..e8c02a02415a 100644
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
 void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
 		       struct qat_request_buffs *buf);
 int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			struct scatterlist *sgl,
 			struct scatterlist *sglout,
 			struct qat_request_buffs *buf,
+			struct qat_sgl_to_bufl_params *params,
 			gfp_t flags);
 
 #endif
-- 
2.37.1

