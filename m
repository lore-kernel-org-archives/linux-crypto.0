Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE246315D2C;
	Tue,  4 Nov 2025 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247570; cv=none; b=EUL+E5hox5X73cXJ9ZXHKg43MgahMNc8/NzSpPbkZX7apl1JMs3s5drTsnfqG686C2fJDA8Sd7dwDnOHgfQ8kxyNTF+x4ToRGlOR4tYZ3KHN0YoCpV65VvSV+4+xA6IoWuZUDnhhG0ixc1prbrbrbyVOkU+YCXWbCqy8h45s2hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247570; c=relaxed/simple;
	bh=l12Y3K2O0e4lVd/69AIlvx7c2fjQqUHhdMaCYpoLZDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CoRSRQYTSpYo7uFJG86K8C5d+jELLQ1pPVKAEAoYX5o4bMm7uQ9uMPTwwhfRNMFCYBeKlrugjuXuhSG/wH8WfR+X6aTO5tngcz7orCsKGIrqU2BmwHOzti7A0xXAQzVC8DbqzMJmNSZostWPtM+fOfSQUDUB1/oEkh6qWyDSpqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=miq0Jex6; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="miq0Jex6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247567; x=1793783567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l12Y3K2O0e4lVd/69AIlvx7c2fjQqUHhdMaCYpoLZDs=;
  b=miq0Jex6Yu1vh6l5wRz4g+DDGEoJEBTtC//nfL6G+xe/Y0W5ga0G6Do6
   abjSXVif6F0TFAg6z39/6VEoSHPEd3eV5/E8w737oA0wjeqrZaUpbpHTd
   aGa2HjqiMyj83DcnegHE2DWF7qlucuGmP0oORCtqzE0v2lDsrLWJPyuPa
   Jhz5SBXmgNXH8tbPPZWIIaGtM66BNJVjLs7QbrCWg5gPaEo/OE+1InbsL
   k5umVyAKS/NqZVJbB6i1Z572uH7THkDTHitXQIs2axi0nZiqNuC350kFP
   utXqYwOsu8dSiiqPJ3QCiOsIIopUsgK6/xi/6DQgOVw3Flgn4w0hirTDD
   w==;
X-CSE-ConnectionGUID: 9b2ufiflRXul0IDpAx94hg==
X-CSE-MsgGUID: ss+yq6iCQ/SazqEvCrBR7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798685"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798685"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: Z0jlWs9kROWfhQ593gg0tw==
X-CSE-MsgGUID: D4y8QPJTT6yYRUlx6sPrHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795814"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel compressions/decompressions.
Date: Tue,  4 Nov 2025 01:12:26 -0800
Message-Id: <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds capabilities in the IAA driver for kernel users to avail
of the benefits of compressing/decompressing multiple jobs in parallel
using IAA hardware acceleration, without the use of interrupts. Instead,
this is accomplished using an async "submit-poll" mechanism.

To achieve this, we break down a compress/decompress job into two
separate activities if the driver is configured for non-irq async mode:

1) Submit a descriptor after caching the "idxd_desc" descriptor in the
   req->drv_data, and return -EINPROGRESS.
2) Poll: Given a request, retrieve the descriptor and poll its completion
   status for success/error.

This is enabled by the following additions in the driver:

1) The idxd_desc is cached in the "drv_data" member of "struct iaa_req".

2) IAA_REQ_POLL_FLAG: if set in the iaa_req's flags, this tells
   the driver that it should submit the descriptor and return
   -EINPROGRESS. If not set, the driver will proceed to call
   check_completion() in fully synchronous mode, until the hardware
   returns a completion status.

3) iaa_comp_poll() procedure: This routine is intended to be called
   after submission returns -EINPROGRESS. It will check the completion
   status once, and return -EAGAIN if the job has not completed. If the
   job has completed, it will return the completion status.

The purpose of this commit is to allow kernel users of iaa_crypto, such
as zswap, to be able to invoke the crypto_acomp_compress() API in fully
synchronous mode for sequential/non-batching use cases (i.e. today's
status-quo), wherein zswap calls:

  crypto_wait_req(crypto_acomp_compress(req), wait);

and to seamlessly invoke fully asynchronous batch
compress/decompress functionality. Both use cases need to reuse same
code paths in the driver to interface with hardware: the
IAA_REQ_POLL_FLAG allows this shared code to determine whether we need
to process an iaa_req synchronously/asynchronously. The idea is to
simplify iaa_crypto's sequential/batching interfaces for use by swap
modules.

Thus, regardless of the iaa_crypto driver's 'sync_mode' setting, it
can still be forced to use synchronous mode by *not setting* the
IAA_REQ_POLL_FLAG in iaa_req->flags: this is the default to support
sequential use cases in zswap today. In other words, both these
conditions need to be met for a request to be processed in fully async
submit-poll mode:

 1) use_irq should be "false"
 2) iaa_req->flags & IAA_REQ_POLL_FLAG should be "true"

The IAA batching functionality introduced in this patch will set
the IAA_REQ_POLL_FLAG for the requests in a batch. We will submit the
descriptors for each request in the batch in iaa_[de]compress(), and
return -EINPROGRESS. The hardware will begin processing each request as
soon as it is submitted; essentially all compress/decompress jobs will
be parallelized. The polling function, "iaa_comp_poll()", will retrieve
the descriptor from each iaa_req->drv_data to check its completion
status. This enables the iaa_crypto driver to implement true async
"submit-polling" for parallel compressions and decompressions in the IAA
hardware accelerator.

This patch introduces batch compressions/decompressions in
iaa_crypto, that zswap can invoke using the same crypto API mentioned
earlier.

IAA Batching allows the kernel swap modules to compress/decompress
multiple pages/buffers in parallel in hardware, significantly improving
swapout/swapin latency and throughput.

The patch defines an iaa_crypto constant, IAA_CRYPTO_MAX_BATCH_SIZE
(set to 8U currently). This is the maximum batch-size for IAA, and
represents the maximum number of pages/buffers that can be
compressed/decompressed in parallel, respectively.

In order to support IAA batching, the iaa_crypto driver allocates
IAA_CRYPTO_MAX_BATCH_SIZE "struct iaa_req *reqs[]" per-CPU, upon
initialization. Notably, the task of allocating multiple requests to
submit to the hardware for parallel [de]compressions is taken over by
iaa_crypto, so that zswap doesn't need to allocate the reqs.

Compress batching is expected to be called by kernel modules such as
zswap by passing the folio pages as the "source" SG list of the
acomp_req, and by constructing an SG table of SG lists for the output
buffers and setting the acomp_req's "dst" to the head of this list of
scatterlists. Thanks to Herbert Xu for suggesting this batching
architecture.

Within the iaa_crypto driver's compress batching function:

1) The per-CPU iaa_reqs are populated from the acomp_req's src/dst SG
   lists.

2) All iaa_reqs are submitted to the hardware in async mode, using
   movdir64b. This enables hardware parallelism, because we don't wait
   for one compress/decompress job to finish before submitting the next
   one.

3) The iaa_reqs submitted are polled for completion statuses in a
   non-blocking manner in a while loop: each request that is still
   pending is polled once, and this repeats, until all requests have
   completed.

The core IAA batching functions are:

        static int iaa_comp_acompress_batch(
                struct iaa_compression_ctx *ctx,
                struct iaa_req *parent_req,
                unsigned int unit_size);

        static int iaa_comp_adecompress_batch(
                struct iaa_compression_ctx *ctx,
                struct iaa_req *parent_req,
                unsigned int unit_size);

The parameter @unit_size represents the unit size in bytes, for
dis-assembling the source or destination @parent_req->slen or
@parent_req->dlen and SG lists passed in through
@parent_req->src and @parent_req->dst.

The zswap interface to these batching API will be done by setting up the
acomp_req through these crypto API:

 acomp_request_set_src_folio()
 acomp_request_set_dst_sg()
 acomp_request_set_unit_size()

before proceeding to invoke batch compression/decompression using the
existing crypto_acomp_compress()/crypto_acomp_decompress() interfaces.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  30 ++
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 399 ++++++++++++++++++++-
 2 files changed, 420 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 4dfb65c88f83..a99cd421f918 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -41,6 +41,35 @@
 					 IAA_DECOMP_CHECK_FOR_EOB | \
 					 IAA_DECOMP_STOP_ON_EOB)
 
+/*
+ * If set, the driver must have a way to submit the req, then
+ * poll its completion status for success/error.
+ */
+#define IAA_REQ_POLL_FLAG		0x00000002
+
+/*
+ * The maximum compress/decompress batch size for IAA's batch compression
+ * and batch decompression functionality.
+ */
+#define IAA_CRYPTO_MAX_BATCH_SIZE 8U
+
+/*
+ * Used to create per-CPU structure comprising of IAA_CRYPTO_MAX_BATCH_SIZE
+ * reqs for batch [de]compressions.
+ *
+ * @reqs:  Used to submit up to IAA_CRYPTO_MAX_BATCH_SIZE parallel
+ *         compress/decompress jobs to the accelerator.
+ * @mutex: Used to protect the per-CPU batch compression/decompression context
+ *         from preemption/process migration; and to allow upper layers in the
+ *         kernel to use synchronous/asynchronous compress/decompress calls to
+ *         IAA. In other words, don't make any assumptions, and protect
+ *         compression/decompression data.
+ */
+struct iaa_batch_ctx {
+	struct iaa_req **reqs;
+	struct mutex mutex;
+};
+
 #define IAA_COMP_MODES_MAX  IAA_MODE_NONE
 
 enum iaa_mode {
@@ -51,6 +80,7 @@ enum iaa_mode {
 struct iaa_req {
 	struct scatterlist *src;
 	struct scatterlist *dst;
+	struct scatterlist sg_src;
 	unsigned int slen;
 	unsigned int dlen;
 	u32 flags;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 75bd455b3b34..910598405c5c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -55,6 +55,9 @@ static struct wq_table_entry **pkg_global_comp_wqs;
 static struct crypto_acomp *deflate_crypto_acomp;
 DEFINE_MUTEX(deflate_crypto_acomp_lock);
 
+/* Per-cpu iaa_reqs for batching. */
+static struct iaa_batch_ctx __percpu *iaa_batch_ctx;
+
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
@@ -1901,13 +1904,14 @@ static int iaa_compress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
+		req->drv_data = idxd_desc;
 		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_comp_calls();
 		update_wq_comp_calls(wq);
 
-		if (ctx->async_mode)
+		if (req->flags & IAA_REQ_POLL_FLAG)
 			return -EINPROGRESS;
 
 		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
@@ -1989,13 +1993,14 @@ static int iaa_decompress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
+		req->drv_data = idxd_desc;
 		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_decomp_calls();
 		update_wq_decomp_calls(wq);
 
-		if (ctx->async_mode)
+		if (req->flags & IAA_REQ_POLL_FLAG)
 			return -EINPROGRESS;
 
 		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
@@ -2198,6 +2203,301 @@ static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req
 	return ret;
 }
 
+static int iaa_comp_poll(struct iaa_compression_ctx *ctx, struct iaa_req *req)
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
+	idxd_desc = req->drv_data;
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
+	ret = check_completion(dev, idxd_desc->iax_completion, compress_op, true);
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
+	if (compress_op && ctx->verify_compress) {
+		dma_addr_t src_addr, dst_addr;
+
+		req->compression_crc = idxd_desc->iax_completion->crc;
+
+		dma_sync_sg_for_device(dev, req->dst, 1, DMA_FROM_DEVICE);
+		dma_sync_sg_for_device(dev, req->src, 1, DMA_TO_DEVICE);
+
+		src_addr = sg_dma_address(req->src);
+		dst_addr = sg_dma_address(req->dst);
+
+		ret = iaa_compress_verify(ctx, req, wq, src_addr, req->slen,
+					  dst_addr, req->dlen);
+	}
+
+out:
+	/* caller doesn't call crypto_wait_req, so no acomp_request_complete() */
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+
+	idxd_free_desc(idxd_desc->wq, idxd_desc);
+	percpu_ref_put(&iaa_wq->ref);
+
+	return ret;
+}
+
+static __always_inline void iaa_set_req_poll(
+	struct iaa_req *reqs[],
+	int nr_reqs,
+	bool set_flag)
+{
+	int i;
+
+	for (i = 0; i < nr_reqs; ++i) {
+		set_flag ? (reqs[i]->flags |= IAA_REQ_POLL_FLAG) :
+			   (reqs[i]->flags &= ~IAA_REQ_POLL_FLAG);
+	}
+}
+
+/**
+ * This API provides IAA compress batching functionality for use by swap
+ * modules.
+ *
+ * @ctx:  compression ctx for the requested IAA mode (fixed/dynamic).
+ * @parent_req: The "parent" iaa_req that contains SG lists for the batch's
+ *              inputs and outputs.
+ * @unit_size: The unit size to apply to @parent_req->slen to get the number of
+ *             scatterlists it contains.
+ *
+ * The caller should check the individual sg->lengths in the @parent_req for
+ * errors, including incompressible page errors.
+ *
+ * Returns 0 if all compress requests in the batch complete successfully,
+ * -EINVAL otherwise.
+ */
+static int iaa_comp_acompress_batch(
+	struct iaa_compression_ctx *ctx,
+	struct iaa_req *parent_req,
+	unsigned int unit_size)
+{
+	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+	int nr_reqs = parent_req->slen / unit_size;
+	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
+	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
+	bool compressions_done = false;
+	struct sg_page_iter sgiter;
+	struct scatterlist *sg;
+	struct iaa_req **reqs;
+	int i, err = 0;
+
+	mutex_lock(&cpu_ctx->mutex);
+
+	reqs = cpu_ctx->reqs;
+
+	__sg_page_iter_start(&sgiter, parent_req->src, nr_reqs,
+			     parent_req->src->offset/unit_size);
+
+	for (i = 0; i < nr_reqs; ++i, ++sgiter.sg_pgoffset) {
+		sg_set_page(reqs[i]->src, sg_page_iter_page(&sgiter), PAGE_SIZE, 0);
+		reqs[i]->slen = PAGE_SIZE;
+	}
+
+	for_each_sg(parent_req->dst, sg, nr_reqs, i) {
+		sg->length = PAGE_SIZE;
+		dlens[i] = &sg->length;
+		reqs[i]->dst = sg;
+		reqs[i]->dlen = PAGE_SIZE;
+	}
+
+	iaa_set_req_poll(reqs, nr_reqs, true);
+
+	/*
+	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
+	 * these compress jobs in parallel.
+	 */
+	for (i = 0; i < nr_reqs; ++i) {
+		errors[i] = iaa_comp_acompress(ctx, reqs[i]);
+
+		if (likely(errors[i] == -EINPROGRESS)) {
+			errors[i] = -EAGAIN;
+		} else if (unlikely(errors[i])) {
+			*dlens[i] = errors[i];
+			err = -EINVAL;
+		} else {
+			*dlens[i] = reqs[i]->dlen;
+		}
+	}
+
+	/*
+	 * Asynchronously poll for and process IAA compress job completions.
+	 */
+	while (!compressions_done) {
+		compressions_done = true;
+
+		for (i = 0; i < nr_reqs; ++i) {
+			/*
+			 * Skip, if the compression has already completed
+			 * successfully or with an error.
+			 */
+			if (errors[i] != -EAGAIN)
+				continue;
+
+			errors[i] = iaa_comp_poll(ctx, reqs[i]);
+
+			if (errors[i]) {
+				if (likely(errors[i] == -EAGAIN)) {
+					compressions_done = false;
+				} else {
+					*dlens[i] = errors[i];
+					err = -EINVAL;
+				}
+			} else {
+				*dlens[i] = reqs[i]->dlen;
+			}
+		}
+	}
+
+	/*
+	 * For the same 'reqs[]' to be usable by
+	 * iaa_comp_acompress()/iaa_comp_adecompress(),
+	 * clear the IAA_REQ_POLL_FLAG bit on all iaa_reqs.
+	 */
+	iaa_set_req_poll(reqs, nr_reqs, false);
+
+	mutex_unlock(&cpu_ctx->mutex);
+	return err;
+}
+
+/**
+ * This API provides IAA decompress batching functionality for use by swap
+ * modules.
+ *
+ * @ctx:  compression ctx for the requested IAA mode (fixed/dynamic).
+ * @parent_req: The "parent" iaa_req that contains SG lists for the batch's
+ *              inputs and outputs.
+ * @unit_size: The unit size to apply to @parent_req->dlen to get the number of
+ *             scatterlists it contains.
+ *
+ * The caller should check @parent_req->dst scatterlist's component SG lists'
+ * @length for errors and handle @length != PAGE_SIZE.
+ *
+ * Returns 0 if all decompress requests complete successfully,
+ * -EINVAL otherwise.
+ */
+static int iaa_comp_adecompress_batch(
+	struct iaa_compression_ctx *ctx,
+	struct iaa_req *parent_req,
+	unsigned int unit_size)
+{
+	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+	int nr_reqs = parent_req->dlen / unit_size;
+	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
+	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
+	bool decompressions_done = false;
+	struct scatterlist *sg;
+	struct iaa_req **reqs;
+	int i, err = 0;
+
+	mutex_lock(&cpu_ctx->mutex);
+
+	reqs = cpu_ctx->reqs;
+
+	for_each_sg(parent_req->src, sg, nr_reqs, i) {
+		reqs[i]->src = sg;
+		reqs[i]->slen = sg->length;
+	}
+
+	for_each_sg(parent_req->dst, sg, nr_reqs, i) {
+		dlens[i] = &sg->length;
+		reqs[i]->dst = sg;
+		reqs[i]->dlen = PAGE_SIZE;
+	}
+
+	iaa_set_req_poll(reqs, nr_reqs, true);
+
+	/*
+	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
+	 * these decompress jobs in parallel.
+	 */
+	for (i = 0; i < nr_reqs; ++i) {
+		errors[i] = iaa_comp_adecompress(ctx, reqs[i]);
+
+		/*
+		 * If it failed desc allocation/submission, errors[i] can
+		 * be 0 or error value from software decompress.
+		 */
+		if (likely(errors[i] == -EINPROGRESS)) {
+			errors[i] = -EAGAIN;
+		} else if (unlikely(errors[i])) {
+			*dlens[i] = errors[i];
+			err = -EINVAL;
+		} else {
+			*dlens[i] = reqs[i]->dlen;
+		}
+	}
+
+	/*
+	 * Asynchronously poll for and process IAA decompress job completions.
+	 */
+	while (!decompressions_done) {
+		decompressions_done = true;
+
+		for (i = 0; i < nr_reqs; ++i) {
+			/*
+			 * Skip, if the decompression has already completed
+			 * successfully or with an error.
+			 */
+			if (errors[i] != -EAGAIN)
+				continue;
+
+			errors[i] = iaa_comp_poll(ctx, reqs[i]);
+
+			if (errors[i]) {
+				if (likely(errors[i] == -EAGAIN)) {
+					decompressions_done = false;
+				} else {
+					*dlens[i] = errors[i];
+					err = -EINVAL;
+				}
+			} else {
+				*dlens[i] = reqs[i]->dlen;
+			}
+		}
+	}
+
+	/*
+	 * For the same 'reqs[]' to be usable by
+	 * iaa_comp_acompress()/iaa_comp_adecompress(),
+	 * clear the IAA_REQ_POLL_FLAG bit on all iaa_reqs.
+	 */
+	iaa_set_req_poll(reqs, nr_reqs, false);
+
+	mutex_unlock(&cpu_ctx->mutex);
+	return err;
+}
+
 static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
 	ctx->mode = mode;
@@ -2222,9 +2522,19 @@ static int iaa_comp_acompress_main(struct acomp_req *areq)
 	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
 		ctx = iaa_ctx[idx];
 
-		acomp_to_iaa(areq, &req, ctx);
-		ret = iaa_comp_acompress(ctx, &req);
-		iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+		if (likely(areq->slen == areq->unit_size) || !areq->unit_size) {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_acompress(ctx, &req);
+			iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+		} else {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_acompress_batch(ctx, &req, areq->unit_size);
+			/* 
+			 * Set the acomp_req's dlen to be the first SG list's
+			 * compressed length/error value.
+			 */
+			areq->dlen = req.dst->length;
+		}
 	}
 
 	return ret;
@@ -2240,9 +2550,19 @@ static int iaa_comp_adecompress_main(struct acomp_req *areq)
 	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
 		ctx = iaa_ctx[idx];
 
-		acomp_to_iaa(areq, &req, ctx);
-		ret = iaa_comp_adecompress(ctx, &req);
-		iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+		if (likely(areq->dlen == areq->unit_size) || !areq->unit_size) {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_adecompress(ctx, &req);
+			iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+		} else {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_adecompress_batch(ctx, &req, areq->unit_size);
+			/* 
+			 * Set the acomp_req's dlen to be the first SG list's
+			 * decompressed length/error value.
+			 */
+			areq->dlen = req.dst->length;
+		}
 	}
 
 	return ret;
@@ -2527,9 +2847,31 @@ static struct idxd_device_driver iaa_crypto_driver = {
  * Module init/exit.
  ********************/
 
+static void iaa_batch_ctx_dealloc(void)
+{
+	int cpu;
+	u8 i;
+
+	if (!iaa_batch_ctx)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct iaa_batch_ctx *cpu_ctx = per_cpu_ptr(iaa_batch_ctx, cpu);
+
+		if (cpu_ctx && cpu_ctx->reqs) {
+			for (i = 0; i < IAA_CRYPTO_MAX_BATCH_SIZE; ++i)
+				kfree(cpu_ctx->reqs[i]);
+			kfree(cpu_ctx->reqs);
+		}
+	}
+
+	free_percpu(iaa_batch_ctx);
+}
+
 static int __init iaa_crypto_init_module(void)
 {
-	int ret = 0;
+	int cpu, ret = 0;
+	u8 i;
 
 	INIT_LIST_HEAD(&iaa_devices);
 
@@ -2591,6 +2933,39 @@ static int __init iaa_crypto_init_module(void)
 		goto err_sync_attr_create;
 	}
 
+	/* Allocate batching resources for iaa_crypto. */
+	iaa_batch_ctx = alloc_percpu_gfp(struct iaa_batch_ctx, GFP_KERNEL | __GFP_ZERO);
+	if (!iaa_batch_ctx) {
+		pr_debug("Failed to allocate per-cpu iaa_batch_ctx\n");
+		goto batch_ctx_fail;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct iaa_batch_ctx *cpu_ctx = per_cpu_ptr(iaa_batch_ctx, cpu);
+		int nid = cpu_to_node(cpu);
+
+		cpu_ctx->reqs = kcalloc_node(IAA_CRYPTO_MAX_BATCH_SIZE,
+					     sizeof(struct iaa_req *),
+					     GFP_KERNEL, nid);
+
+		if (!cpu_ctx->reqs)
+			goto reqs_fail;
+
+		for (i = 0; i < IAA_CRYPTO_MAX_BATCH_SIZE; ++i) {
+			cpu_ctx->reqs[i] = kzalloc_node(sizeof(struct iaa_req),
+							GFP_KERNEL, nid);
+			if (!cpu_ctx->reqs[i]) {
+				pr_debug("Could not alloc iaa_req reqs[%d]\n", i);
+				goto reqs_fail;
+			}
+
+			sg_init_table(&cpu_ctx->reqs[i]->sg_src, 1);
+			cpu_ctx->reqs[i]->src = &cpu_ctx->reqs[i]->sg_src;
+		}
+
+		mutex_init(&cpu_ctx->mutex);
+	}
+
 	if (iaa_crypto_debugfs_init())
 		pr_warn("debugfs init failed, stats not available\n");
 
@@ -2598,6 +2973,11 @@ static int __init iaa_crypto_init_module(void)
 out:
 	return ret;
 
+reqs_fail:
+	iaa_batch_ctx_dealloc();
+batch_ctx_fail:
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_sync_mode);
 err_sync_attr_create:
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_verify_compress);
@@ -2629,6 +3009,7 @@ static void __exit iaa_crypto_cleanup_module(void)
 	iaa_unregister_acomp_compression_device();
 	iaa_unregister_compression_device();
 
+	iaa_batch_ctx_dealloc();
 	iaa_crypto_debugfs_cleanup();
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_sync_mode);
-- 
2.27.0

