Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE18C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 18:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiCCSOU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 13:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiCCSOU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 13:14:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CE7EBBB4
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 10:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646331214; x=1677867214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/aSIoxxrcUjK5q+GvpyOjEsZQzL2+bA6hBE05WY83wQ=;
  b=PAPUoWMvcJNvATtD1/KKcF/jTJoCsoMMC8QF4yxjZpwrfuI9e7RaQ1P3
   uqbyhJsNuy5x3SL5NK2JwArP+IwssI7aYHUpF4MjkZKQz4E7rjkG63DRI
   4vOwomTG3UT5tztLGjyLcZe10dr2us6a3GhJmzhi0qiB9Ovogho2V7utP
   EoyJzf31buBTzfk/LBb+70IDmRL5dlBzb5Ez5MCQcqz1tvfzhCCa2TG/v
   l6aFSky+wXEAp4zV7XjmwAh4io/cLqv/KqSjKf4SFuYDCApJpDlDitLZ0
   TdXSrjkPvEajetMrYLyPAxzKCK5GI8A6CT2PGLxZb5icITFjep6ef6jjy
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="278447742"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="278447742"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 10:00:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="640279657"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 10:00:50 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [RFC 1/3] crypto: qat - use pre-allocated buffers in datapath
Date:   Thu,  3 Mar 2022 18:00:34 +0000
Message-Id: <20220303180036.13475-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
References: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to do DMAs, the QAT device requires that scatterlists are
mapped and translated in a format that the firmware can understand. This
is defined as the composition of an sgl descriptor header, the struct
qat_alg_buf_list, plus a variable number of flat buffer descriptors,
the struct qat_alg_buf.

The allocation and mapping of these data structures is done each time a
request is received from the skcipher and aead APIs.
In an OOM situation, this behaviour might lead to a dead-lock as
allocations might fail.

Based on the conversation in [1], increase the size of the aead and
skcipher request contexts to include an SGL descriptor that can handle
maximum 4 flat buffers.
If requests exceed 4 entries buffers, memory is allocated dynamically.

[1] https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/

Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c   | 62 ++++++++++++----------
 drivers/crypto/qat/qat_common/qat_crypto.h | 24 +++++++++
 2 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f998ed58457c..862184aec3d4 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -46,19 +46,6 @@
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed __aligned(64);
-
 /* Common content descriptor */
 struct qat_alg_cd {
 	union {
@@ -693,7 +680,10 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
-	kfree(bl);
+
+	if (!qat_req->sgl_src_valid)
+		kfree(bl);
+
 	if (blp != blpout) {
 		/* If out of place operation dma unmap only data */
 		int bufless = blout->num_bufs - blout->num_mapped_bufs;
@@ -704,7 +694,9 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 					 DMA_BIDIRECTIONAL);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
-		kfree(blout);
+
+		if (!qat_req->sgl_dst_valid)
+			kfree(blout);
 	}
 }
 
@@ -721,15 +713,23 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blp = DMA_MAPPING_ERROR;
 	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
-	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
+	size_t sz_out, sz = struct_size(bufl, bufers, n);
+	int node = dev_to_node(&GET_DEV(inst->accel_dev));
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kzalloc_node(sz, GFP_ATOMIC,
-			    dev_to_node(&GET_DEV(inst->accel_dev)));
-	if (unlikely(!bufl))
-		return -ENOMEM;
+	qat_req->sgl_src_valid = false;
+	qat_req->sgl_dst_valid = false;
+
+	if (n > QAT_MAX_BUFF_DESC) {
+		bufl = kzalloc_node(sz, GFP_ATOMIC, node);
+		if (unlikely(!bufl))
+			return -ENOMEM;
+	} else {
+		bufl = &qat_req->sgl_src.sgl_hdr;
+		qat_req->sgl_src_valid = true;
+	}
 
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
@@ -760,12 +760,17 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		struct qat_alg_buf *bufers;
 
 		n = sg_nents(sglout);
-		sz_out = struct_size(buflout, bufers, n + 1);
+		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
-		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
-				       dev_to_node(&GET_DEV(inst->accel_dev)));
-		if (unlikely(!buflout))
-			goto err_in;
+
+		if (n > QAT_MAX_BUFF_DESC) {
+			buflout = kzalloc_node(sz_out, GFP_ATOMIC, node);
+			if (unlikely(!buflout))
+				goto err_in;
+		} else {
+			buflout = &qat_req->sgl_dst.sgl_hdr;
+			qat_req->sgl_dst_valid = true;
+		}
 
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i)
@@ -810,7 +815,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-	kfree(buflout);
+
+	if (!qat_req->sgl_dst_valid)
+		kfree(buflout);
 
 err_in:
 	if (!dma_mapping_error(dev, blp))
@@ -823,7 +830,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	kfree(bufl);
+	if (!qat_req->sgl_src_valid)
+		kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index b6a4c95ae003..8f2aa4804ed0 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -21,6 +21,26 @@ struct qat_crypto_instance {
 	atomic_t refctr;
 };
 
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed __aligned(64);
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
 struct qat_crypto_request_buffs {
 	struct qat_alg_buf_list *bl;
 	dma_addr_t blp;
@@ -53,6 +73,10 @@ struct qat_crypto_request {
 		u8 iv[AES_BLOCK_SIZE];
 	};
 	bool encryption;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
 static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
-- 
2.35.1

