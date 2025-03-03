Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8300F1F03C9;
	Mon,  3 Mar 2025 08:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740991655; cv=none; b=gHNLQ8m/tG2mqNmXsBFI+mnIk47cjcOBQgm+Q0Whu5R0l2JuvyNCsX4QohbHI/e27dbNCgyirGgJFl580ULjsf4pUdSAlrXBEECOaC0RJeMA2sukZSXt/MxF34viK3lGcPP16iNSJo1m8ZaXJ+sdRy6/RO+E34EzbIoUFSm8XJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740991655; c=relaxed/simple;
	bh=yAxiyAJkmOi+qCLJ6YIryDvvFkW0bqE3LR6f2KKFmuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hzEISQ7JYoBDLFFwwiflND0jjLEl7Ejgp+Pe2FYczkPHUU/4TMTLi/kHqXxclNhsotXKeZ+DIcIgRgm8IqDkMFHHFeKcVecEQbnRIrBMlMM/DWHW/VZmIOrz5FSYOdEjYUVLXlG4lcJhptg5yvn25VvGvDvFgyxnSi2ezJ1wwUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5Jo9FVH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5Jo9FVH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740991654; x=1772527654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yAxiyAJkmOi+qCLJ6YIryDvvFkW0bqE3LR6f2KKFmuI=;
  b=Q5Jo9FVH4DINRiUBVDZfUge+i/MDwZedto2nJEqznbsy3K0Pp5wQlQ9g
   SoZ27z4jPKSUGaDeArAlLrBDRj/WcxOsb7GC5RYZ8Mw5LDteSZZEg5bhB
   MOKE4DXidpketSk+K8MVF+ElCbMPEXhPlz+5hVYcOT8lxdeQJjQuXEesu
   7dIoJkXUqWB+5FoyO5YTqA/IxUQ7uTJoLXW8y5wEiAKiRkZmYtutRzAzA
   VGYtAarFVSVCYlG/QSE5Y34Ahk8k1sOk7E7CQaSQ8SL8e1r5q/i0Hi7ta
   yausb0H2vbFdoqXmMN6k9MQNGSE8CfcPBmyu4XMBbLBYbNmoeOs4w0Quq
   g==;
X-CSE-ConnectionGUID: 0y2kQFlqTvG9vuo1sdENdw==
X-CSE-MsgGUID: xzFcGJDbSDWYH2hqXLkoBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="42111894"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="42111894"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 00:47:31 -0800
X-CSE-ConnectionGUID: fvBsJymEQP6lwEgEmf6goA==
X-CSE-MsgGUID: RpkS3VTXRlGfrTvv0qcbqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="118426786"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 03 Mar 2025 00:47:28 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v8 04/14] crypto: iaa - Implement batch compression/decompression with request chaining.
Date: Mon,  3 Mar 2025 00:47:14 -0800
Message-Id: <20250303084724.6490-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch provides the iaa_crypto driver implementation for the newly added
crypto_acomp "get_batch_size()" interface which will be called when swap
modules invoke crypto_acomp_batch_size() to query for the maximum batch size.
This will return an iaa_driver specific constant, IAA_CRYPTO_MAX_BATCH_SIZE
(set to 8U currently).

This allows swap modules such as zswap/zram to allocate required batching
resources and then invoke fully asynchronous batch parallel
compression/decompression of pages on systems with Intel IAA, by setting up
a request chain, and calling crypto_acomp_compress() or
crypto_acomp_decompress() with the head request in the chain.

This enables zswap compress batching code to be developed in
a manner similar to the current single-page synchronous calls to
crypto_acomp_compress() and crypto_acomp_decompress(), thereby,
facilitating encapsulated and modular hand-off between the kernel
zswap/zram code and the crypto_acomp layer.

This patch also provides implementations of IAA batching with request
chaining for both iaa_crypto sync modes: asynchronous/no-irq and fully
synchronous.

Since iaa_crypto supports the use of acomp request chaining, this patch
also adds CRYPTO_ALG_REQ_CHAIN to the iaa_acomp_fixed_deflate algorithm's
cra_flags.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |   9 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 186 ++++++++++++++++++++-
 2 files changed, 192 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 56985e395263..45d94a646636 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -39,6 +39,15 @@
 					 IAA_DECOMP_CHECK_FOR_EOB | \
 					 IAA_DECOMP_STOP_ON_EOB)
 
+/*
+ * The maximum compress/decompress batch size for IAA's implementation of
+ * batched compressions/decompressions.
+ * The IAA compression algorithms should provide the crypto_acomp
+ * get_batch_size() interface through a function that returns this
+ * constant.
+ */
+#define IAA_CRYPTO_MAX_BATCH_SIZE 8U
+
 /* Representation of IAA workqueue */
 struct iaa_wq {
 	struct list_head	list;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index d7983ab3c34a..a9800b8f3575 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1807,6 +1807,185 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 	ctx->use_irq = use_irq;
 }
 
+static int iaa_comp_poll(struct acomp_req *req)
+{
+	struct idxd_desc *idxd_desc;
+	struct idxd_device *idxd;
+	struct iaa_wq *iaa_wq;
+	struct pci_dev *pdev;
+	struct device *dev;
+	struct idxd_wq *wq;
+	bool compress_op;
+	int ret;
+
+	idxd_desc = req->base.data;
+	if (!idxd_desc)
+		return -EAGAIN;
+
+	compress_op = (idxd_desc->iax_hw->opcode == IAX_OPCODE_COMPRESS);
+	wq = idxd_desc->wq;
+	iaa_wq = idxd_wq_get_private(wq);
+	idxd = iaa_wq->iaa_device->idxd;
+	pdev = idxd->pdev;
+	dev = &pdev->dev;
+
+	ret = check_completion(dev, idxd_desc->iax_completion, true, true);
+	if (ret == -EAGAIN)
+		return ret;
+	if (ret)
+		goto out;
+
+	req->dlen = idxd_desc->iax_completion->output_size;
+
+	/* Update stats */
+	if (compress_op) {
+		update_total_comp_bytes_out(req->dlen);
+		update_wq_comp_bytes(wq, req->dlen);
+	} else {
+		update_total_decomp_bytes_in(req->slen);
+		update_wq_decomp_bytes(wq, req->slen);
+	}
+
+	if (iaa_verify_compress && (idxd_desc->iax_hw->opcode == IAX_OPCODE_COMPRESS)) {
+		struct crypto_tfm *tfm = req->base.tfm;
+		dma_addr_t src_addr, dst_addr;
+		u32 compression_crc;
+
+		compression_crc = idxd_desc->iax_completion->crc;
+
+		dma_sync_sg_for_device(dev, req->dst, 1, DMA_FROM_DEVICE);
+		dma_sync_sg_for_device(dev, req->src, 1, DMA_TO_DEVICE);
+
+		src_addr = sg_dma_address(req->src);
+		dst_addr = sg_dma_address(req->dst);
+
+		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
+					  dst_addr, &req->dlen, compression_crc);
+	}
+out:
+	/* caller doesn't call crypto_wait_req, so no acomp_request_complete() */
+
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+
+	idxd_free_desc(idxd_desc->wq, idxd_desc);
+
+	dev_dbg(dev, "%s: returning ret=%d\n", __func__, ret);
+
+	return ret;
+}
+
+static unsigned int iaa_comp_get_batch_size(void)
+{
+	return IAA_CRYPTO_MAX_BATCH_SIZE;
+}
+
+static void iaa_set_reqchain_poll(
+	struct acomp_req *req0,
+	bool set_flag)
+{
+	struct acomp_req *req;
+
+	set_flag ? (req0->flags |= CRYPTO_ACOMP_REQ_POLL) :
+		   (req0->flags &= ~CRYPTO_ACOMP_REQ_POLL);
+
+	list_for_each_entry(req, &req0->base.list, base.list)
+		set_flag ? (req->flags |= CRYPTO_ACOMP_REQ_POLL) :
+			   (req->flags &= ~CRYPTO_ACOMP_REQ_POLL);
+}
+
+/**
+ * This API provides IAA compress batching functionality for use by swap
+ * modules. Batching is implemented using request chaining.
+ *
+ * @req:  The head asynchronous compress request in the chain.
+ *
+ * Returns the compression error status (0 or -errno) of the last
+ * request that finishes. Caller should call acomp_request_err()
+ * for each request in the chain, to get its error status.
+ */
+static int iaa_comp_acompress_batch(struct acomp_req *req)
+{
+	bool async = (async_mode && !use_irq);
+	int err = 0;
+
+	if (likely(async))
+		iaa_set_reqchain_poll(req, true);
+	else
+		iaa_set_reqchain_poll(req, false);
+
+
+	if (likely(async))
+		/* Process the request chain in parallel. */
+		err = acomp_do_async_req_chain(req, iaa_comp_acompress, iaa_comp_poll);
+	else
+		/* Process the request chain in series. */
+		err = acomp_do_req_chain(req, iaa_comp_acompress);
+
+	/*
+	 * For the same request chain to be usable by
+	 * iaa_comp_acompress()/iaa_comp_adecompress() in synchronous mode,
+	 * clear the CRYPTO_ACOMP_REQ_POLL bit on all acomp_reqs.
+	 */
+	iaa_set_reqchain_poll(req, false);
+
+	return err;
+}
+
+/**
+ * This API provides IAA decompress batching functionality for use by swap
+ * modules. Batching is implemented using request chaining.
+ *
+ * @req:  The head asynchronous decompress request in the chain.
+ *
+ * Returns the decompression error status (0 or -errno) of the last
+ * request that finishes. Caller should call acomp_request_err()
+ * for each request in the chain, to get its error status.
+ */
+static int iaa_comp_adecompress_batch(struct acomp_req *req)
+{
+	bool async = (async_mode && !use_irq);
+	int err = 0;
+
+	if (likely(async))
+		iaa_set_reqchain_poll(req, true);
+	else
+		iaa_set_reqchain_poll(req, false);
+
+
+	if (likely(async))
+		/* Process the request chain in parallel. */
+		err = acomp_do_async_req_chain(req, iaa_comp_adecompress, iaa_comp_poll);
+	else
+		/* Process the request chain in series. */
+		err = acomp_do_req_chain(req, iaa_comp_adecompress);
+
+	/*
+	 * For the same request chain to be usable by
+	 * iaa_comp_acompress()/iaa_comp_adecompress() in synchronous mode,
+	 * clear the CRYPTO_ACOMP_REQ_POLL bit on all acomp_reqs.
+	 */
+	iaa_set_reqchain_poll(req, false);
+
+	return err;
+}
+
+static int iaa_compress_main(struct acomp_req *req)
+{
+	if (acomp_is_reqchain(req))
+		return iaa_comp_acompress_batch(req);
+
+	return iaa_comp_acompress(req);
+}
+
+static int iaa_decompress_main(struct acomp_req *req)
+{
+	if (acomp_is_reqchain(req))
+		return iaa_comp_adecompress_batch(req);
+
+	return iaa_comp_adecompress(req);
+}
+
 static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
@@ -1829,13 +2008,14 @@ static void dst_free(struct scatterlist *sgl)
 
 static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
-	.compress		= iaa_comp_acompress,
-	.decompress		= iaa_comp_adecompress,
+	.compress		= iaa_compress_main,
+	.decompress		= iaa_decompress_main,
 	.dst_free               = dst_free,
+	.get_batch_size		= iaa_comp_get_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_CHAIN,
 		.cra_ctxsize		= sizeof(struct iaa_compression_ctx),
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= IAA_ALG_PRIORITY,
-- 
2.27.0

