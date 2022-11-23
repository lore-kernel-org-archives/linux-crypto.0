Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB5AC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 12:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbiKWMLa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbiKWMLF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 07:11:05 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3B85BD43
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 04:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669205464; x=1700741464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xhNdjLftLA1OcEZL2FVL05RB0fcE4wTxnyZ4E6mviM0=;
  b=dspTtio7dfBjnMfofT1aLKppXYe78hsk8G8TfHiX90xwd6G3iu/Nvnnm
   8cXN2r0g41OeIPAOfUPxZ0WvG2g7HOehpYsDt6Lg8w8xV7n5NuiVgdVbb
   fG+22TsljIy3m5ghJOLSRqd3kYjljCownId1D3zVskRgmlwGvl5IWsIyD
   FSScBzrOKIgyWpb0VWDEa83P3Tj7wPghwDa7Ex2ELCMVtajRGM2kywCrM
   yHPAxmu1xCUK0uiG+X47je7ih+sA7G1MrSVT0eNmUqqpb/FOyfUpPaUOi
   7nfyoLZSM7g/v7jPD9GV+G0I+VC3OSYTEgsbPAewlSV9RvQ268wlHcGq6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312752530"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312752530"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 04:11:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784227542"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784227542"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 04:11:02 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 11/11] crypto: qat - add resubmit logic for decompression
Date:   Wed, 23 Nov 2022 12:10:32 +0000
Message-Id: <20221123121032.71991-12-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The acomp API allows to send requests with a NULL destination buffer. In
this case, the algorithm implementation needs to allocate the
destination
scatter list, perform the operation and return the buffer to the user.
For decompression, data is likely to expand and be bigger than the
allocated buffer.

This implements a re-submission mechanism for decompression requests
that is triggered if the destination buffer, allocated by the driver,
is not sufficiently big to store the output from decompression.

If an overflow is detected when processing the callback for a
decompression request with a NULL destination buffer, a workqueue is
scheduled. This allocates a new scatter list of the size of the
previously allocated destination buffer, combines it with that, creates
a new firmware scatter list and resubmits the job to the hardware
accelerator.
If the number of retries exceeds 5, an error is returned to the user.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_bl.c        | 227 ++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_bl.h        |   6 +
 drivers/crypto/qat/qat_common/qat_comp_algs.c |  76 ++++++
 drivers/crypto/qat/qat_common/qat_comp_req.h  |  10 +
 4 files changed, 319 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 221a4eb610a3..517938b2e211 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -222,3 +222,230 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 				    extra_dst_buff, sz_extra_dst_buff,
 				    flags);
 }
+
+static void qat_bl_sgl_unmap(struct adf_accel_dev *accel_dev,
+			     struct qat_alg_buf_list *bl)
+{
+	struct device *dev = &GET_DEV(accel_dev);
+	int n = bl->num_bufs;
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (!dma_mapping_error(dev, bl->bufers[i].addr))
+			dma_unmap_single(dev, bl->bufers[i].addr,
+					 bl->bufers[i].len, DMA_FROM_DEVICE);
+
+	kfree(bl);
+}
+
+static int qat_bl_sgl_map(struct adf_accel_dev *accel_dev,
+			  struct scatterlist *sgl,
+			  struct qat_alg_buf_list **bl)
+{
+	struct device *dev = &GET_DEV(accel_dev);
+	struct qat_alg_buf_list *bufl;
+	int node = dev_to_node(dev);
+	struct scatterlist *sg;
+	int n, i, sg_nctr;
+	size_t sz;
+
+	n = sg_nents(sgl);
+	sz = struct_size(bufl, bufers, n);
+	bufl = kzalloc_node(sz, GFP_KERNEL, node);
+	if (unlikely(!bufl))
+		return -ENOMEM;
+
+	for (i = 0; i < n; i++)
+		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
+
+	sg_nctr = 0;
+	for_each_sg(sgl, sg, n, i) {
+		int y = sg_nctr;
+
+		if (!sg->length)
+			continue;
+
+		bufl->bufers[y].addr = dma_map_single(dev, sg_virt(sg),
+						      sg->length,
+						      DMA_FROM_DEVICE);
+		bufl->bufers[y].len = sg->length;
+		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
+			goto err_map;
+		sg_nctr++;
+	}
+	bufl->num_bufs = sg_nctr;
+	bufl->num_mapped_bufs = sg_nctr;
+
+	*bl = bufl;
+
+	return 0;
+
+err_map:
+	for (i = 0; i < n; i++)
+		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
+			dma_unmap_single(dev, bufl->bufers[i].addr,
+					 bufl->bufers[i].len,
+					 DMA_FROM_DEVICE);
+	kfree(bufl);
+	*bl = NULL;
+
+	return -ENOMEM;
+}
+
+static void qat_bl_sgl_free_unmap(struct adf_accel_dev *accel_dev,
+				  struct scatterlist *sgl,
+				  struct qat_alg_buf_list *bl)
+{
+	if (bl)
+		qat_bl_sgl_unmap(accel_dev, bl);
+	if (sgl)
+		sgl_free(sgl);
+}
+
+static int qat_bl_sgl_alloc_map(struct adf_accel_dev *accel_dev,
+				struct scatterlist **sgl,
+				struct qat_alg_buf_list **bl,
+				unsigned int dlen,
+				gfp_t gfp)
+{
+	struct scatterlist *dst;
+	int ret;
+
+	dst = sgl_alloc(dlen, gfp, NULL);
+	if (!dst) {
+		dev_err(&GET_DEV(accel_dev), "sg_alloc failed\n");
+		return -ENOMEM;
+	}
+
+	ret = qat_bl_sgl_map(accel_dev, dst, bl);
+	if (ret)
+		goto err;
+
+	*sgl = dst;
+
+	return 0;
+
+err:
+	sgl_free(dst);
+	*sgl = NULL;
+	return ret;
+}
+
+static void qat_bl_merge_fw_sgl(struct qat_alg_buf_list *out,
+				struct qat_alg_buf_list *in_one,
+				struct qat_alg_buf_list *in_two)
+{
+	size_t cpy_sz;
+	void *s, *d;
+
+	cpy_sz = in_one->num_bufs * sizeof(struct qat_alg_buf);
+	s = in_one->bufers;
+	d = out->bufers;
+	memcpy(d, s, cpy_sz);
+
+	s = in_two->bufers;
+	d += cpy_sz;
+	cpy_sz = in_two->num_bufs * sizeof(struct qat_alg_buf);
+	memcpy(d, s, cpy_sz);
+
+	out->num_bufs = in_one->num_bufs + in_two->num_bufs;
+	out->num_mapped_bufs = in_one->num_mapped_bufs + in_two->num_mapped_bufs;
+}
+
+static void qat_bl_merge_scatterlists(struct scatterlist *out,
+				      struct scatterlist *in_one,
+				      struct scatterlist *in_two)
+{
+	struct scatterlist *dst = out;
+	int i, nents_one, nents_two;
+	struct scatterlist *sg;
+
+	nents_one = sg_nents(in_one);
+	nents_two = sg_nents(in_two);
+
+	sg_init_table(dst, nents_one + nents_two);
+
+	for_each_sg(in_one, sg, nents_one, i) {
+		sg_set_page(dst, sg_page(sg), sg->length, 0);
+		dst = sg_next(dst);
+	}
+
+	for_each_sg(in_two, sg, nents_two, i) {
+		sg_set_page(dst, sg_page(sg), sg->length, 0);
+		dst = sg_next(dst);
+	}
+}
+
+int qat_bl_realloc_map_new_dst(struct adf_accel_dev *accel_dev,
+			       struct scatterlist **sg,
+			       unsigned int *dlen,
+			       struct qat_request_buffs *qat_bufs,
+			       gfp_t gfp)
+{
+	struct qat_alg_buf_list *tmp_bl, *dst_bl, *old_bl;
+	struct device *dev = &GET_DEV(accel_dev);
+	dma_addr_t dst_blp = DMA_MAPPING_ERROR;
+	struct scatterlist *dst = NULL;
+	struct scatterlist *tmp_dst;
+	int node = dev_to_node(dev);
+	size_t dst_bl_size;
+	int ret, nents;
+
+	ret = qat_bl_sgl_alloc_map(accel_dev, &tmp_dst, &tmp_bl, *dlen, gfp);
+	if (ret)
+		return ret;
+
+	old_bl = qat_bufs->blout;
+	nents = tmp_bl->num_bufs + old_bl->num_bufs;
+	dst_bl_size = struct_size(dst_bl, bufers, nents);
+
+	/* Allocate new FW SGL descriptor */
+	dst_bl = kzalloc_node(dst_bl_size, gfp, node);
+	if (!dst_bl)
+		goto err;
+
+	dst_blp = dma_map_single(dev, dst_bl, dst_bl_size, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, dst_blp)))
+		goto err;
+
+	/* Allocate new scatter list */
+	dst = kmalloc_array(nents, sizeof(struct scatterlist), gfp);
+	if (!dst)
+		goto err;
+
+	/* Create new FW SGL and scatterlist as composition of the old one
+	 * and the newly allocated one
+	 */
+	qat_bl_merge_fw_sgl(dst_bl, tmp_bl, old_bl);
+	qat_bl_merge_scatterlists(dst, tmp_dst, *sg);
+
+	/* Unmap old firmware SGL descriptor */
+	dma_unmap_single(dev, qat_bufs->bloutp, qat_bufs->sz_out, DMA_TO_DEVICE);
+
+	/* Free temporary FW sgl descriptor */
+	kfree(tmp_bl);
+
+	if (!qat_bufs->sgl_dst_valid)
+		kfree(qat_bufs->blout);
+	qat_bufs->sgl_dst_valid = false;
+	qat_bufs->blout = dst_bl;
+	qat_bufs->bloutp = dst_blp;
+	qat_bufs->sz_out = dst_bl_size;
+
+	/* Free old scatterlist and return newly created one */
+	kfree(*sg);
+	*sg = dst;
+
+	*dlen *= 2;
+
+	return 0;
+err:
+	qat_bl_sgl_free_unmap(accel_dev, tmp_dst, tmp_bl);
+	kfree(dst_bl);
+	kfree(dst);
+
+	if (!dma_mapping_error(dev, dst_blp))
+		dma_unmap_single(dev, dst_blp, dst_bl_size, DMA_TO_DEVICE);
+
+	return -ENOMEM;
+}
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 5f2ea8f352f7..bfe9ed62b174 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -58,4 +58,10 @@ static inline gfp_t qat_algs_alloc_flags(struct crypto_async_request *req)
 	return req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 }
 
+int qat_bl_realloc_map_new_dst(struct adf_accel_dev *accel_dev,
+			       struct scatterlist **newd,
+			       unsigned int *dlen,
+			       struct qat_request_buffs *qat_bufs,
+			       gfp_t gfp);
+
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
index bdc5107b359b..9099d6c3f74b 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
@@ -5,6 +5,7 @@
 #include <crypto/internal/acompress.h>
 #include <crypto/scatterwalk.h>
 #include <linux/dma-mapping.h>
+#include <linux/workqueue.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "qat_bl.h"
@@ -25,6 +26,14 @@ struct qat_compression_ctx {
 	struct qat_compression_instance *inst;
 };
 
+#define MAX_NULL_DST_RETRIES 5
+
+struct qat_dst {
+	bool is_null;
+	int retries;
+	unsigned int total_dlen;
+};
+
 struct qat_compression_req {
 	u8 req[QAT_COMP_REQ_SIZE];
 	struct qat_compression_ctx *qat_compression_ctx;
@@ -33,6 +42,8 @@ struct qat_compression_req {
 	enum direction dir;
 	int actual_dlen;
 	struct qat_alg_req alg_req;
+	struct work_struct resubmit;
+	struct qat_dst dst;
 };
 
 static int qat_alg_send_dc_message(struct qat_compression_req *qat_req,
@@ -49,6 +60,55 @@ static int qat_alg_send_dc_message(struct qat_compression_req *qat_req,
 	return qat_alg_send_message(alg_req);
 }
 
+static void qat_comp_resubmit(struct work_struct *work)
+{
+	struct qat_compression_req *qat_req =
+		container_of(work, struct qat_compression_req, resubmit);
+	struct qat_compression_ctx *ctx = qat_req->qat_compression_ctx;
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	struct qat_request_buffs *qat_bufs = &qat_req->buf;
+	struct qat_compression_instance *inst = ctx->inst;
+	struct acomp_req *areq = qat_req->acompress_req;
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(areq);
+	unsigned int dlen = qat_req->dst.total_dlen;
+	int retries = ++qat_req->dst.retries;
+	u8 *req = qat_req->req;
+	int ret = -EINVAL;
+	dma_addr_t dfbuf;
+
+	dev_dbg(&GET_DEV(accel_dev), "[%s][%s] retry NULL dst request - retries = %d dlen = %d\n",
+		crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm)),
+		qat_req->dir == COMPRESSION ? "comp" : "decomp", retries,
+		dlen * 2);
+
+	if (retries > MAX_NULL_DST_RETRIES) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"[%s] exceeded max number of retries for NULL dst %s request\n",
+			crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm)),
+			qat_req->dir == COMPRESSION ? "comp" : "decomp");
+			ret = -EOVERFLOW;
+			goto err;
+	}
+
+	ret = qat_bl_realloc_map_new_dst(accel_dev, &areq->dst, &dlen, qat_bufs,
+					 qat_algs_alloc_flags(&areq->base));
+	if (ret)
+		goto err;
+
+	qat_req->dst.total_dlen = dlen;
+
+	dfbuf = qat_req->buf.bloutp;
+	qat_comp_override_dst(req, dfbuf, dlen);
+
+	ret = qat_alg_send_dc_message(qat_req, inst, &areq->base);
+	if (ret != -ENOSPC)
+		return;
+
+err:
+	qat_bl_free_bufl(accel_dev, qat_bufs);
+	areq->base.complete(&areq->base, ret);
+}
+
 static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 				      void *resp)
 {
@@ -79,6 +139,14 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 		status ? "ERR" : "OK ",
 		consumed, produced, cmp_err, xlt_err);
 
+	if (qat_req->dir == DECOMPRESSION && qat_req->dst.is_null) {
+		if (cmp_err == ERR_CODE_OVERFLOW_ERROR) {
+			INIT_WORK(&qat_req->resubmit, qat_comp_resubmit);
+			adf_misc_wq_queue_work(&qat_req->resubmit);
+			return;
+		}
+	}
+
 	if (unlikely(status != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		goto end;
 
@@ -175,16 +243,24 @@ static int qat_comp_alg_compress_decompress(struct acomp_req *areq,
 	if (areq->dst && !dlen)
 		return -EINVAL;
 
+	qat_req->dst.is_null = false;
+
 	/* Handle acomp requests that require the allocation of a destination
 	 * buffer. The size of the destination buffer is double the source
 	 * buffer (rounded up to the size of a page) to fit the decompressed
 	 * output or an expansion on the data for compression.
 	 */
 	if (!areq->dst) {
+		qat_req->dst.is_null = true;
+
 		dlen = round_up(2 * slen, PAGE_SIZE);
 		areq->dst = sgl_alloc(dlen, f, NULL);
 		if (!areq->dst)
 			return -ENOMEM;
+
+		areq->dlen = dlen;
+		qat_req->dst.retries = 0;
+		qat_req->dst.total_dlen = dlen;
 	}
 
 	if (dir == COMPRESSION) {
diff --git a/drivers/crypto/qat/qat_common/qat_comp_req.h b/drivers/crypto/qat/qat_common/qat_comp_req.h
index 18a1f33a6db9..404e32c5e778 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_req.h
+++ b/drivers/crypto/qat/qat_common/qat_comp_req.h
@@ -25,6 +25,16 @@ static inline void qat_comp_create_req(void *ctx, void *req, u64 src, u32 slen,
 	req_pars->out_buffer_sz = dlen;
 }
 
+static inline void qat_comp_override_dst(void *req, u64 dst, u32 dlen)
+{
+	struct icp_qat_fw_comp_req *fw_req = req;
+	struct icp_qat_fw_comp_req_params *req_pars = &fw_req->comp_pars;
+
+	fw_req->comn_mid.dest_data_addr = dst;
+	fw_req->comn_mid.dst_length = dlen;
+	req_pars->out_buffer_sz = dlen;
+}
+
 static inline void qat_comp_create_compression_req(void *ctx, void *req,
 						   u64 src, u32 slen,
 						   u64 dst, u32 dlen,
-- 
2.38.1

