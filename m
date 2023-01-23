Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0E7C25B50
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Jan 2023 10:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjAWKmm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Jan 2023 05:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjAWKmm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2023 05:42:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80AA13DCD
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2023 02:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674470560; x=1706006560;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YCQ3h+d1CtK5xFZQh8uovbNiuBpW1MaelA0n3A6Y7lo=;
  b=I/bVAOuA45Sb5cycWj1uWiyc2TF1xYoVmWbFFcGeovQvZv0Ey2pDMnlA
   wn71KbtV0M9Fmgsq/rkYvQ0unXfj9MY94o7SYC5/WDXeEJqVneac710YA
   4BD+JzXhsS07PAkpXicNS+GH3cTkwBRUBe9Om7CNs4LBkeQLyT/qrAa5n
   rTp1UHuIk38eYHCDOHvjzJr4qC1ky6HBlBHLYO5FUjE6DSVXmFfYa9wVW
   89kwjH8It1Bjnf8IbvG5NwiMZfPoQdyUI4NjulQz3RHVwHNqxHc3H8MYn
   oDtEzdXN7TmLEgcsmo3KU5JX4Cydu9/wfiZxqhe5RS//e07Oa5xMD2hVo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="324695516"
X-IronPort-AV: E=Sophos;i="5.97,239,1669104000"; 
   d="scan'208";a="324695516"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 02:42:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="990361870"
X-IronPort-AV: E=Sophos;i="5.97,239,1669104000"; 
   d="scan'208";a="990361870"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jan 2023 02:42:40 -0800
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: qat - extend buffer list logic interface
Date:   Mon, 23 Jan 2023 11:42:21 +0100
Message-Id: <20230123104222.131643-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend qat_bl_sgl_to_bufl() to allow skipping the mapping of a region
of the source and the destination scatter lists starting from byte
zero.

This is to support the ZLIB format (RFC 1950) in the qat driver.
The ZLIB format is made of deflate compressed data surrounded by a
header and a footer. The QAT accelerators support only the deflate
algorithm, therefore the header should not be mapped since it is
inserted in software.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_bl.c        | 37 ++++++++++++++++---
 drivers/crypto/qat/qat_common/qat_bl.h        |  2 +
 drivers/crypto/qat/qat_common/qat_comp_algs.c |  3 ++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index c72831fa025d..76baed0a76c0 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -53,6 +53,8 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 				struct qat_request_buffs *buf,
 				dma_addr_t extra_dst_buff,
 				size_t sz_extra_dst_buff,
+				unsigned int sskip,
+				unsigned int dskip,
 				gfp_t flags)
 {
 	struct device *dev = &GET_DEV(accel_dev);
@@ -65,6 +67,7 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	struct scatterlist *sg;
 	size_t sz_out, sz = struct_size(bufl, buffers, n);
 	int node = dev_to_node(&GET_DEV(accel_dev));
+	unsigned int left;
 	int bufl_dma_dir;
 
 	if (unlikely(!n))
@@ -88,19 +91,29 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	for (i = 0; i < n; i++)
 		bufl->buffers[i].addr = DMA_MAPPING_ERROR;
 
+	left = sskip;
+
 	for_each_sg(sgl, sg, n, i) {
 		int y = sg_nctr;
 
 		if (!sg->length)
 			continue;
 
-		bufl->buffers[y].addr = dma_map_single(dev, sg_virt(sg),
-						       sg->length,
+		if (left >= sg->length) {
+			left -= sg->length;
+			continue;
+		}
+		bufl->buffers[y].addr = dma_map_single(dev, sg_virt(sg) + left,
+						       sg->length - left,
 						       bufl_dma_dir);
 		bufl->buffers[y].len = sg->length;
 		if (unlikely(dma_mapping_error(dev, bufl->buffers[y].addr)))
 			goto err_in;
 		sg_nctr++;
+		if (left) {
+			bufl->buffers[y].len -= left;
+			left = 0;
+		}
 	}
 	bufl->num_bufs = sg_nctr;
 	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
@@ -117,6 +130,8 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 
 		n = n_sglout + extra_buff;
 		sz_out = struct_size(buflout, buffers, n);
+		left = dskip;
+
 		sg_nctr = 0;
 
 		if (n > QAT_MAX_BUFF_DESC) {
@@ -139,13 +154,21 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			if (!sg->length)
 				continue;
 
-			buffers[y].addr = dma_map_single(dev, sg_virt(sg),
-							 sg->length,
+			if (left >= sg->length) {
+				left -= sg->length;
+				continue;
+			}
+			buffers[y].addr = dma_map_single(dev, sg_virt(sg) + left,
+							 sg->length - left,
 							 DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(dev, buffers[y].addr)))
 				goto err_out;
 			buffers[y].len = sg->length;
 			sg_nctr++;
+			if (left) {
+				buffers[y].len -= left;
+				left = 0;
+			}
 		}
 		if (extra_buff) {
 			buffers[sg_nctr].addr = extra_dst_buff;
@@ -212,15 +235,19 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 {
 	dma_addr_t extra_dst_buff = 0;
 	size_t sz_extra_dst_buff = 0;
+	unsigned int sskip = 0;
+	unsigned int dskip = 0;
 
 	if (params) {
 		extra_dst_buff = params->extra_dst_buff;
 		sz_extra_dst_buff = params->sz_extra_dst_buff;
+		sskip = params->sskip;
+		dskip = params->dskip;
 	}
 
 	return __qat_bl_sgl_to_bufl(accel_dev, sgl, sglout, buf,
 				    extra_dst_buff, sz_extra_dst_buff,
-				    flags);
+				    sskip, dskip, flags);
 }
 
 static void qat_bl_sgl_unmap(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 1479fef3b634..d87e4f35ac39 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -42,6 +42,8 @@ struct qat_request_buffs {
 struct qat_sgl_to_bufl_params {
 	dma_addr_t extra_dst_buff;
 	size_t sz_extra_dst_buff;
+	unsigned int sskip;
+	unsigned int dskip;
 };
 
 void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
index 1480d36a8d2b..12d5e0fc3a95 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
@@ -233,6 +233,9 @@ static int qat_comp_alg_compress_decompress(struct acomp_req *areq,
 	size_t ovf_buff_sz;
 	int ret;
 
+	params.sskip = 0;
+	params.dskip = 0;
+
 	if (!areq->src || !slen)
 		return -EINVAL;
 
-- 
2.37.1

