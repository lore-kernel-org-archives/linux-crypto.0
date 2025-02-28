Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C292B25BAD6;
	Fri, 28 Feb 2025 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736832; cv=none; b=oo0tB7ZdZO5Oj9bs71fWSQZ/Ro/E0Bwg8kQyWcBlcGowelyNgFhsU52rvcJ6+Vlj7qHQ8uZZQaFrEnPthzahLpg1CJkg8+tuMR3YnynHu1v2+uaiGqMeJYqIwF2+CzZtDpEDpJABOtKg6k/F/p8sCnNeDzRC7Tcd3aHgipznDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736832; c=relaxed/simple;
	bh=yAxiyAJkmOi+qCLJ6YIryDvvFkW0bqE3LR6f2KKFmuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PZlasmz5PvywgVvFw3+0O9nZtEvc2wqcfATIWS9sdsx5pMyIon7Jna8PLLLXipsvJgAU9TT/BRJvOaAI4xgVu8OHnDA+yyAxK0zKY1n8F0caGjKMxkrja2WZH2XHc/suEkrOo0eBeUNGO8JqFQ9Co0E4y9i2iDLORI1GypmxaeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hPsX2fy4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hPsX2fy4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736830; x=1772272830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yAxiyAJkmOi+qCLJ6YIryDvvFkW0bqE3LR6f2KKFmuI=;
  b=hPsX2fy4H86xbNCpyWSdo3OpOltKyM3AbkizzYSSEY2StjlMkXlGUamo
   QWI1lvP/93IuByOY4KIxFleq8MC8TriRMOWJiZUh9Nz0Qu8PceoLddJAP
   e7sBHOPZMf8M4bHsRjGat2kw7312EMBBFAaANJwzYjduIDhqRYYPRDNHa
   YSulpHIOCR2Twm4lwa8w21ZQiP8+8k8pjSuW5ElQH3GBuxkFTibQZ52DF
   SrU/39+AGbJM3v7LaV2rdJHSq89iIEvs89XWU/FNVKLkAov2Up1XeX6Rb
   Zo2z8JKyzlUiiZiPOsH1AthI27ZRYJWRfdotC4yBp1tZtX8N3K1x3O05j
   Q==;
X-CSE-ConnectionGUID: Gy3kI9mxTQCyLuJMDu8fHg==
X-CSE-MsgGUID: oQoY9T55RNOTL1oSroxfEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902602"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902602"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:26 -0800
X-CSE-ConnectionGUID: JsOxxOoQS1Wcf0vCVk5nKw==
X-CSE-MsgGUID: PNSJc6UrQ0OcddnrQDWl/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325703"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:26 -0800
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
Subject: [PATCH v7 04/15] crypto: iaa - Implement batch compression/decompression with request chaining.
Date: Fri, 28 Feb 2025 02:00:13 -0800
Message-Id: <20250228100024.332528-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
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

