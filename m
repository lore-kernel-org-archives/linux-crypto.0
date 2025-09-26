Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336EF27A469;
	Fri, 26 Sep 2025 03:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857722; cv=none; b=R0Wah6us5r4BdETZ66cq4IVVLve1HS2A7SNsF+a0n9A4ZZR1UicRle1eJRltvcI2luB7gzQFxG4nZDH6FME+xTFtaYJsx6mAJu0Pv1tgCa23o4tjR8jhDY/J6PHJouCSEZal74K06s0gxj3H6hjkttK6kKksQiHQsFgxE8WKV4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857722; c=relaxed/simple;
	bh=N8aXNrIp+qZCywAl09Ev5Oxt+e20/Z67wlwTT/DfLEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ko0LfnIM9EA4UXN9+xkymFfWi+cvm62T3Kx5AAQ7kfzcZrDPktySapPbaMDdXUBCpXVMqNeDcM4KVqCGURcUL9m0PK0+XH+FgAtNzwGU+3tGzvdK8ZG/LopoSnXjItWkO0sRXUHaiLgRK0zQ+IPVC8vzuxayu3rd9kF9bWHFAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RCtnjCXF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCtnjCXF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857718; x=1790393718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N8aXNrIp+qZCywAl09Ev5Oxt+e20/Z67wlwTT/DfLEI=;
  b=RCtnjCXFkM2zHtLRRHgFRsH1PXvMh3jleXora/PTI96DzPJzBkolYzdQ
   qDVovdLp+MLaz708iYt/l/VJRsxDDMRTkVCGt6ArrVgqRTYA5RTUQvJsT
   KHjvem1p4n6gjt4fmO4IQAzUxFhJNHT5PD1pMhDO5jvel4qf48nmzmaIF
   ZQyc26ooGQfreEPZJZ3D2YxfHO4sDcwd+1Fda8FF4V2aGOM3mOlQVJQZ4
   kWuM4eXcN0EpVkfcc26HcpeVwWOeshkgm/mbCf5al5UEo+dnvACsbW/jQ
   uEzQpQQkIKGZAowDtuQ2vuUczH0JFpAvHhYnYunXz6kVvQsUQb/sbvraN
   A==;
X-CSE-ConnectionGUID: h+kL4AAaSaShLQSLaM+uHg==
X-CSE-MsgGUID: Axvs5UvbQACzIjib8He6yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819573"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819573"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:06 -0700
X-CSE-ConnectionGUID: 64DpwJ5kRa6KB1khQF1v+Q==
X-CSE-MsgGUID: kfRBRszPSgWsxoKPzYQUTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636592"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:05 -0700
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
Subject: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel compressions/decompressions.
Date: Thu, 25 Sep 2025 20:34:53 -0700
Message-Id: <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces batch compressions/decompressions in
iaa_crypto. Two new interfaces are provided for use in the kernel,
either directly, in the zram/zcomp backend, or by calling
crypto_acomp_[de]compress() in the case of zswap.

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
iaa_crypto, so that zswap/zram don't need to allocate the reqs.

Compress batching is expected to be called by kernel modules such as
zswap by passing the folio pages for the "source" SG list of the
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

IAA's maximum batch-size can be queried with the following API:

  unsigned int iaa_comp_get_max_batch_size(void);

This allows swap modules such as zram to allocate required batching
dst buffers and then invoke fully asynchronous batch parallel
compression/decompression of pages/buffers on systems with Intel IAA, by
invoking these batching API, respectively:

 int iaa_comp_compress_batch(
        enum iaa_mode mode,
        struct iaa_req *parent_req,
        unsigned int unit_size);

 int iaa_comp_decompress_batch(
        enum iaa_mode mode,
        struct iaa_req *parent_req,
        unsigned int unit_size);

The parameter @unit_size represents the unit size in bytes, for
dis-assembling the source/destination
@parent_req->slen/@parent_req->dlen and SG lists passed in through
@parent_req->src and @parent_req->dst.

A zram/zcomp backend_deflate_iaa.c will be submitted as a separate patch
series, and will enable single-page and batch IAA compress/decompress
ops.

The zswap interface to these batching API will be done by setting up the
acomp_req through these crypto API:

 acomp_request_set_src_folio()
 acomp_request_set_dst_sg()
 acomp_request_set_unit_size()

before proceeding to invoke batch compression/decompression using the
existing crypto_acomp_compress()/crypto_acomp_decompress() interfaces.

The new crypto_acomp-agnostic iaa_comp_[de]compress_batch() API result
in impressive latency improvements for zswap batch [de]compression, as
compared to a crypto_acomp based batching interface, most likely because
we avoid the overhead of crypto_acomp: we observe 17.78 micro-seconds
p99 latency savings for a decompress batch of 8 with the new
iaa_comp_decompress_batch() API.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  15 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 346 ++++++++++++++++++++-
 include/linux/iaa_comp.h                   |  35 +++
 3 files changed, 388 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 1cc383c94fb8..db1e50574662 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -47,6 +47,21 @@
  */
 #define IAA_REQ_POLL_FLAG		0x00000002
 
+/*
+ * The maximum compress/decompress batch size for IAA's batch compression
+ * and batch decompression functionality.
+ */
+#define IAA_CRYPTO_MAX_BATCH_SIZE 8U
+
+/*
+ * Used to create per-CPU structure comprising of IAA_CRYPTO_MAX_BATCH_SIZE
+ * reqs for batch [de]compressions.
+ */
+struct iaa_batch_ctx {
+	struct iaa_req **reqs;
+	struct mutex mutex;
+};
+
 /* Representation of IAA workqueue */
 struct iaa_wq {
 	struct list_head	list;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 7395822430b1..0a620f2dc58e 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -55,6 +55,9 @@ static struct wq_table_entry **pkg_global_comp_wqs;
 /* For software deflate fallback compress/decompress. */
 static struct crypto_acomp *deflate_crypto_acomp;
 
+/* Per-cpu iaa_reqs for batching. */
+static struct iaa_batch_ctx __percpu *iaa_batch_ctx;
+
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
@@ -2190,7 +2193,7 @@ static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req
 	return ret;
 }
 
-static int __maybe_unused iaa_comp_poll(struct iaa_compression_ctx *ctx, struct iaa_req *req)
+static int iaa_comp_poll(struct iaa_compression_ctx *ctx, struct iaa_req *req)
 {
 	struct idxd_desc *idxd_desc;
 	struct idxd_device *idxd;
@@ -2255,6 +2258,234 @@ static int __maybe_unused iaa_comp_poll(struct iaa_compression_ctx *ctx, struct
 	return ret;
 }
 
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
+		parent_req->dlens[i] = &sg->length;
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
+			*parent_req->dlens[i] = errors[i];
+			err = -EINVAL;
+		} else {
+			*parent_req->dlens[i] = reqs[i]->dlen;
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
+					*parent_req->dlens[i] = errors[i];
+					err = -EINVAL;
+				}
+			} else {
+				*parent_req->dlens[i] = reqs[i]->dlen;
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
+		parent_req->dlens[i] = &sg->length;
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
+			*parent_req->dlens[i] = errors[i];
+			err = -EINVAL;
+		} else {
+			*parent_req->dlens[i] = reqs[i]->dlen;
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
+					*parent_req->dlens[i] = errors[i];
+					err = -EINVAL;
+				}
+			} else {
+				*parent_req->dlens[i] = reqs[i]->dlen;
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
@@ -2357,6 +2588,12 @@ u8 iaa_comp_get_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes)
 }
 EXPORT_SYMBOL_GPL(iaa_comp_get_modes);
 
+__always_inline unsigned int iaa_comp_get_max_batch_size(void)
+{
+	return IAA_CRYPTO_MAX_BATCH_SIZE;
+}
+EXPORT_SYMBOL_GPL(iaa_comp_get_max_batch_size);
+
 __always_inline int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req)
 {
 	return iaa_comp_acompress(iaa_ctx[mode], req);
@@ -2369,6 +2606,24 @@ __always_inline int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req)
 }
 EXPORT_SYMBOL_GPL(iaa_comp_decompress);
 
+__always_inline int iaa_comp_compress_batch(
+	enum iaa_mode mode,
+	struct iaa_req *parent_req,
+	unsigned int unit_size)
+{
+	return iaa_comp_acompress_batch(iaa_ctx[mode], parent_req, unit_size);
+}
+EXPORT_SYMBOL_GPL(iaa_comp_compress_batch);
+
+__always_inline int iaa_comp_decompress_batch(
+	enum iaa_mode mode,
+	struct iaa_req *parent_req,
+	unsigned int unit_size)
+{
+	return iaa_comp_adecompress_batch(iaa_ctx[mode], parent_req, unit_size);
+}
+EXPORT_SYMBOL_GPL(iaa_comp_decompress_batch);
+
 /*********************************************
  * Interfaces to crypto_alg and crypto_acomp.
  *********************************************/
@@ -2383,9 +2638,16 @@ static int iaa_comp_acompress_main(struct acomp_req *areq)
 	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
 		ctx = iaa_ctx[idx];
 
-		acomp_to_iaa(areq, &req, ctx);
-		ret = iaa_comp_acompress(ctx, &req);
-		iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+		if (likely(areq->slen == areq->unit_size)) {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_acompress(ctx, &req);
+			iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+			return ret;
+		} else {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_acompress_batch(ctx, &req, areq->unit_size);
+			return ret;
+		}
 	}
 
 	return ret;
@@ -2401,9 +2663,16 @@ static int iaa_comp_adecompress_main(struct acomp_req *areq)
 	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
 		ctx = iaa_ctx[idx];
 
-		acomp_to_iaa(areq, &req, ctx);
-		ret = iaa_comp_adecompress(ctx, &req);
-		iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+		if (likely(areq->dlen == areq->unit_size)) {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_adecompress(ctx, &req);
+			iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+			return ret;
+		} else {
+			acomp_to_iaa(areq, &req, ctx);
+			ret = iaa_comp_adecompress_batch(ctx, &req, areq->unit_size);
+			return ret;
+		}
 	}
 
 	return ret;
@@ -2699,9 +2968,31 @@ static struct idxd_device_driver iaa_crypto_driver = {
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
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
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
 
@@ -2756,6 +3047,39 @@ static int __init iaa_crypto_init_module(void)
 		goto err_sync_attr_create;
 	}
 
+	/* Allocate batching resources for iaa_crypto. */
+	iaa_batch_ctx = alloc_percpu_gfp(struct iaa_batch_ctx, GFP_KERNEL | __GFP_ZERO);
+	if (!iaa_batch_ctx) {
+		pr_debug("Failed to allocate per-cpu iaa_batch_ctx\n");
+		goto batch_ctx_fail;
+	}
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		struct iaa_batch_ctx *cpu_ctx = per_cpu_ptr(iaa_batch_ctx, cpu);
+		int cpu_node = cpu_to_node(cpu);
+
+		cpu_ctx->reqs = kcalloc_node(IAA_CRYPTO_MAX_BATCH_SIZE,
+					     sizeof(struct iaa_req *),
+					     GFP_KERNEL, cpu_node);
+
+		if (!cpu_ctx->reqs)
+			goto reqs_fail;
+
+		for (i = 0; i < IAA_CRYPTO_MAX_BATCH_SIZE; ++i) {
+			cpu_ctx->reqs[i] = kzalloc_node(sizeof(struct iaa_req),
+							GFP_KERNEL, cpu_node);
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
 
@@ -2763,6 +3087,11 @@ static int __init iaa_crypto_init_module(void)
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
@@ -2789,6 +3118,7 @@ static void __exit iaa_crypto_cleanup_module(void)
 	iaa_unregister_acomp_compression_device();
 	iaa_unregister_compression_device();
 
+	iaa_batch_ctx_dealloc();
 	iaa_crypto_debugfs_cleanup();
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_sync_mode);
diff --git a/include/linux/iaa_comp.h b/include/linux/iaa_comp.h
index ec061315f477..7b765760485c 100644
--- a/include/linux/iaa_comp.h
+++ b/include/linux/iaa_comp.h
@@ -18,11 +18,13 @@ enum iaa_mode {
 struct iaa_req {
 	struct scatterlist *src;
 	struct scatterlist *dst;
+	struct scatterlist sg_src;
 	unsigned int slen;
 	unsigned int dlen;
 	u32 flags;
 	u32 compression_crc;
 	void *drv_data; /* for driver internal use */
+	int **dlens;
 };
 
 extern bool iaa_comp_enabled(void);
@@ -35,10 +37,22 @@ extern u8 iaa_comp_get_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes);
 
 extern void iaa_comp_put_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes, u8 nr_modes);
 
+extern unsigned int iaa_comp_get_max_batch_size(void);
+
 extern int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req);
 
 extern int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req);
 
+extern int iaa_comp_compress_batch(
+	enum iaa_mode mode,
+	struct iaa_req *parent_req,
+	unsigned int unit_size);
+
+extern int iaa_comp_decompress_batch(
+	enum iaa_mode mode,
+	struct iaa_req *parent_req,
+	unsigned int unit_size);
+
 #else /* CONFIG_CRYPTO_DEV_IAA_CRYPTO */
 
 enum iaa_mode {
@@ -71,6 +85,11 @@ static inline void iaa_comp_put_modes(char **iaa_mode_names, enum iaa_mode *iaa_
 {
 }
 
+static inline unsigned int iaa_comp_get_max_batch_size(void)
+{
+	return 0;
+}
+
 static inline int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req)
 {
 	return -EINVAL;
@@ -81,6 +100,22 @@ static inline int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req)
 	return -EINVAL;
 }
 
+static inline int iaa_comp_compress_batch(
+	enum iaa_mode mode,
+	struct iaa_req *parent_req,
+	unsigned int unit_size)
+{
+	return -EINVAL;
+}
+
+static inline int iaa_comp_decompress_batch(
+	enum iaa_mode mode,
+	struct iaa_req *parent_req,
+	unsigned int unit_size)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_CRYPTO_DEV_IAA_CRYPTO */
 
 #endif
-- 
2.27.0

