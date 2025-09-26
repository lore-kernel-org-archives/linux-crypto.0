Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E376286898;
	Fri, 26 Sep 2025 03:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857729; cv=none; b=fsUpbeXaqeoOuJm/UXU/j0kXNj7zVKhF9NitOBGi9KT6c3p79hJthqGoFKuQHh+0Iq5dlvt+Bc7kOAH7xwDSnmYmN1THu9nQfP5we7GD3zvpQfmRT+t+LxsaO3aGn5gUHlGwEvr5BMd0rL0eC3ThVbNyuNrcd2C1xbWjIKojTgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857729; c=relaxed/simple;
	bh=/IMJmgZyIzA42OJgV5BL7ppfZNvkisR4eqtX58YpxiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VstsntYLJlTwcnhOYRYMgfU9jagEPDvE431LzfvAxEkVV5Ve+RtVLI+PK6rB8wRCwooKQzUUfWDRM1kxXsgjWXMGtf5uwarAtyvBlPo+DgMmBSxPDOCxY64Uj/WZNhIs3p9oryExexlKbc7xiDXjVBiLniuPLzHhsAcCb0JKUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HqiC24o8; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HqiC24o8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857726; x=1790393726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/IMJmgZyIzA42OJgV5BL7ppfZNvkisR4eqtX58YpxiY=;
  b=HqiC24o8hki+fYhDvhjCGGEPCul/FBDjw4qEaBCJ39fDiQeiGiwvKq6i
   jZbKQdnIvQ5VQZMDhsS03bMOf28vaMbMIrJR9GTXXFuqccjEhIiQ80S37
   FtWmHTWUSBk0+UcLch0hyn94W+HghBHvmHK8BsgQwzy/j+UTTMPxKe7VC
   SFACd8Hql7UxktCCv9IB2lvDL2hlDIY6bAF7zK4Yb33apVlTkWeqFc5Ua
   ac1R73k/abbnZotqm3JaiJOakkJGlC0YHB89h/T9uF3S+uDa4pe1QVbds
   +OiXKR7xPWRLD9rYSHrLhzs5fgIzDAOqqLi00tDUl0/wdA5AZi2yz7hw4
   A==;
X-CSE-ConnectionGUID: 1bJX8OdpTfSMVAHgGLJl/g==
X-CSE-MsgGUID: bk0Wa11STxCFW8FbOsOixQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819716"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819716"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:08 -0700
X-CSE-ConnectionGUID: QypCj91aR/aKHZ0y9k5QVw==
X-CSE-MsgGUID: 3MtKD3D+Re+w0p0vqcKOGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636622"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:07 -0700
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
Subject: [PATCH v12 23/23] mm: zswap: Batched zswap_compress() with compress batching of large folios.
Date: Thu, 25 Sep 2025 20:35:02 -0700
Message-Id: <20250926033502.7486-24-kanchana.p.sridhar@intel.com>
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

crypto: iaa - Use the memory allocated in acomp_req->__ctx[] for batching.

This patch introduces a new unified implementation of zswap_compress()
for compressors that do and do not support batching. This eliminates
code duplication and facilitates maintainability of the code with the
introduction of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

If the compressor does not support batching, each page in the batch is
compressed and stored sequentially. If the compressor supports batching,
for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
is compressed in parallel in hardware. If the batch is compressed
without errors, the compressed buffers are then stored in zsmalloc. In
case of compression errors, the current behavior is preserved for the
batching zswap_compress(): if the folio's memcg is writeback enabled,
pages with compression errors are store uncompressed in zsmalloc; if
not, we return an error for the folio in zswap_store().

As per Herbert's suggestion in [1] for batching to be based on SG lists
to interface with the crypto API, an "struct sg_table *sg_outputs" is
added to the per-CPU acomp_ctx. In zswap_cpu_comp_prepare(), memory is
allocated for @pool->compr_batch_size scatterlists in
@acomp_ctx->sg_outputs. The per-CPU @acomp_ctx->buffers' addresses are
mapped to the respective SG in @acomp_ctx->sg_outputs. This is done once
and does not need to be repeated in zswap_compress(). The existing
non-NUMA sg_alloc_table() was found to give better performance than a
NUMA-aware allocation function, hence is used in this patch.

All that zswap_compress() needs to do for non-batching software
compressors is to set the singular output SG's length to PAGE_SIZE.
Batching compressors should initialize the output SG lengths to
PAGE_SIZE as part of the internal compress batching setup, to avoid
having to do multiple traversals over the @acomp_ctx->sg_outputs->sgl.
This is exactly how batching is implemented in the iaa_crypto driver's
compress batching procedure, iaa_comp_acompress_batch().

Another initialization level optimization that happens in
zswap_cpu_comp_prepare() is, only for batching compressors, we allocate
extra memory for "batch-size" int pointers in the
@acomp_ctx->req->__ctx[] that are statically set to track the output SG
lists' lengths. This optimization was necessary to avoid the latency
cost of multiple @acomp_ctx->sg_outputs->sgl traversals in
zswap_compress() and in iaa_comp_acompress_batch() and to recover
batching performance with the SG lists based architecture. This
optimization's per-CPU memory cost for a batching compressor with
batch-size of 8 is 64 bytes. There is no memory cost for software
compressors.

Consequently, batching compressors can use the memory allocated in
@acomp_ctx->req->__ctx[] to internally manage updates to the output
@sg->lengths for the batch. zswap_compress() does not need to
traverse @pool->compr_batch_size number of output SG list elements to
get the compressed output length/error for each page in the batch.
This is readily available in the per-CPU acomp_ctx->req->__ctx[].

On a related note, the code in zswap_compress() is generalized as much
as possible for software compressors, by introducing a local @dstlen int
pointer to track @acomp_ctx->req->dlen, and assigning it the @err return
value from crypto_acomp_compress(), so that the subsequent
incompressible page handling, zs_pool writes, and error handling code is
seamless for software and batching compressors, i.e., avoids
conditionals to switch to specialized code for either.

Finally, again as per Herbert's suggestion, we call:

  acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);

to set the unit size for zswap to PAGE_SIZE, after the call to
acomp_request_set_callback() in zswap_cpu_comp_prepare().

The new batching implementation of zswap_compress() is called with a
batch of @nr_pages sent to zswap_store_pages(). It sets up the
acomp_ctx->req's src/dst SG lists to contain the folio pages and
@nr_comps output buffers, where @nr_comps is min(nr_pages,
pool->compr_batch_size); before calling crypto_acomp_compress().

An upfront mapping of @dlens to the @acomp_ctx->req->__ctx for batching
compressors, and to @acomp_ctx->req->dlen for software compressors,
simplifies the zs_pool writes and error handling after compression.

Some important requirements of this batching architecture for batching
compressors:

  1) The output SG lengths for each sg in the acomp_req->dst should be
     intialized to PAGE_SIZE as part of other batch setup in the batch
     compression function. zswap will not take care of this in the
     interest of avoiding repetitive traversals of the
     @acomp_ctx->sg_outputs->sgl so as to not lose the benefits of
     batching.

  2) In case of a compression error for any page in the batch, the
     batching compressor should set the corresponding @sg->length to a
     negative error number, as suggested by Herbert. Otherwise, the
     @sg->length will contain the compressed output length.

Another important change this patch makes is with the acomp_ctx mutex
locking in zswap_compress(). Earlier, the mutex was held per page's
compression. With the new code, [un]locking the mutex per page caused
regressions for software compressors when testing with usemem
(30 processes) and also kernel compilation with 'allmod' config. The
regressions were more eggregious when PMD folios were stored. The
implementation in this commit locks/unlocks the mutex once per batch,
that resolves the regression.

The use of likely()/unlikely() annotations prevent regressions with
software compressors like zstd, and generally improve non-batching
compressors' performance with the batching code by ~3%.

Architectural considerations for the zswap batching framework:
==============================================================
We have designed the zswap batching framework to be
hardware-agnostic. It has no dependencies on Intel-specific features and
can be leveraged by any hardware accelerator or software-based
compressor. In other words, the framework is open and inclusive by
design.

Other ongoing work that can use batching:
=========================================
This patch-series demonstrates the performance benefits of compress
batching when used in zswap_store() of large folios. shrink_folio_list()
"reclaim batching" of any-order folios is the major next work that uses
the zswap compress batching framework: our testing of kernel_compilation
with writeback and the zswap shrinker indicates 10X fewer pages get
written back when we reclaim 32 folios as a batch, as compared to one
folio at a time: this is with deflate-iaa and with zstd. We expect to
submit a patch-series with this data and the resulting performance
improvements shortly. Reclaim batching relieves memory pressure faster
than reclaiming one folio at a time, hence alleviates the need to scan
slab memory for writeback.

Nhat has given ideas on using batching with the ongoing kcompressd work,
as well as beneficially using decompression batching & block IO batching
to improve zswap writeback efficiency.

Experiments that combine zswap compress batching, reclaim batching,
swapin_readahead() decompression batching of prefetched pages, and
writeback batching show that 0 pages are written back with deflate-iaa
and zstd. For comparison, the baselines for these compressors see
200K-800K pages written to disk (kernel compilation 'allmod' config).

To summarize, these are future clients of the batching framework:

   - shrink_folio_list() reclaim batching of multiple folios:
       Implemented, will submit patch-series.
   - zswap writeback with decompress batching:
       Implemented, will submit patch-series.
   - zram:
       Implemented, will submit patch-series.
   - kcompressd:
       Not yet implemented.
   - file systems:
       Not yet implemented.
   - swapin_readahead() decompression batching of prefetched pages:
       Implemented, will submit patch-series.

Additionally, any place we have folios that need to be compressed, can
potentially be parallelized.

Performance data:
=================

As suggested by Barry, this is the performance data gathered on Intel
Sapphire Rapids with usemem 30 processes running at 50% memory pressure
and kernel_compilation/allmod config run with 2G limit using 32
threads. To keep comparisons simple, all testing was done without the
zswap shrinker.

usemem30, 64K folios:
=====================
 ------------------------------------------------------------------
                                    deflate-iaa

                     mm-unstable-9-18-2025           v12    Change
 ------------------------------------------------------------------
 Total throughput (KB/s)         7,191,949    10,702,115      49%
 Average throughput (KB/s)         239,731       356,737      49%
 elapsed time (sec)                  93.21         69.98     -25%
 sys time (sec)                   2,190.52      1,651.51     -25%
 ------------------------------------------------------------------

 ------------------------------------------------------------------
                                    zstd

                     mm-unstable-9-18-2025           v12    Change
 ------------------------------------------------------------------
 Total throughput (KB/s)         6,258,312     6,269,511     0.2%
 Average throughput (KB/s)         208,610       208,983     0.2%
 elapsed time (sec)                 100.01        100.50     0.5%
 sys time (sec)                   2,505.14      2,490.00      -1%
 ------------------------------------------------------------------

usemem30, PMD folios:
=====================
 ------------------------------------------------------------------
                                    deflate-iaa

                     mm-unstable-9-18-2025           v12    Change
 ------------------------------------------------------------------
 Total throughput (KB/s)         7,237,676    11,228,928      55%
 Average throughput (KB/s)         241,255       374,297      55%
 elapsed time (sec)                  82.26         69.30     -16%
 sys time (sec)                   1,901.90      1,634.78     -14%
 ------------------------------------------------------------------

 ------------------------------------------------------------------
                                    zstd

                     mm-unstable-9-18-2025           v12    Change
 ------------------------------------------------------------------
 Total throughput (KB/s)         6,796,376     6,865,781     1.0%
 Average throughput (KB/s)         226,545       228,859     1.0%
 elapsed time (sec)                  94.07         88.80      -6%
 sys time (sec)                   2,261.67      2,082.91      -8%
 ------------------------------------------------------------------

The main takeaway from usemem, a workload that is mostly compression
dominated (very few swapins) is that the higher the number of batches,
such as, with larger folios, the more the benefit of batching cost
amortization, as shown by the PMD usemem data. This aligns well with the
future direction noted earlier.

kernel_compilation/allmodconfig, 64K folios:
============================================

 -------------------------------------------------------
                           deflate-iaa

          mm-unstable-9-18-2025           v12    Change
 -------------------------------------------------------
 real_sec                874.74        821.59    -6.1%
 sys_sec               3,834.35      3,791.12      -1%
 -------------------------------------------------------

 -------------------------------------------------------
                              zstd

          mm-unstable-9-18-2025           v12    Change
 -------------------------------------------------------
 real_sec                925.08        853.14    -7.8%
 sys_sec               5,318.65      5,172.23    -2.8%
 -------------------------------------------------------

kernel_compilation/allmodconfig, PMD folios:
============================================

 -------------------------------------------------------
                           deflate-iaa

          mm-unstable-9-18-2025           v12    Change
 -------------------------------------------------------
 real_sec                808.10        794.85    -1.6%
 sys_sec               4,351.01      4,266.95      -2%
 -------------------------------------------------------

 -------------------------------------------------------
                              zstd

          mm-unstable-9-18-2025           v12    Change
 -------------------------------------------------------
 real_sec                848.06        845.42    -0.3%
 sys_sec               5,898.58      5,741.31    -2.7%
 -------------------------------------------------------

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   4 +-
 mm/zswap.c                                 | 311 ++++++++++++++++-----
 2 files changed, 247 insertions(+), 68 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 2fa38176034d..019f80f87993 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1510,7 +1510,9 @@ static __always_inline void acomp_to_iaa(struct acomp_req *areq,
 	req->slen = areq->slen;
 	req->dlen = areq->dlen;
 	req->flags = areq->base.flags;
-	if (unlikely(ctx->use_irq))
+	if (likely(!ctx->use_irq))
+		req->dlens = (int **)&areq->__ctx[0];
+	else
 		req->drv_data = areq;
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 9e0e7887de33..8104ecb30a1a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -143,6 +143,7 @@ struct crypto_acomp_ctx {
 	struct acomp_req *req;
 	struct crypto_wait wait;
 	u8 **buffers;
+	struct sg_table *sg_outputs;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -275,6 +276,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 			kfree(acomp_ctx->buffers[i]);
 		kfree(acomp_ctx->buffers);
 	}
+
+	if (acomp_ctx->sg_outputs) {
+		sg_free_table(acomp_ctx->sg_outputs);
+		kfree(acomp_ctx->sg_outputs);
+	}
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -836,6 +842,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int cpu_node = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -866,7 +873,28 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
 				     crypto_acomp_batch_size(acomp_ctx->acomp));
 
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
+	/*
+	 * For batching compressors, we allocate extra memory for "batch-size"
+	 * int pointers that will be statically set to track the output
+	 * SG lists' lengths later in this procedure. This optimization was
+	 * required to avoid the latency cost of SG lists traversal in
+	 * zswap_compress().
+	 *
+	 * Consequently, batching compressors can use the memory allocated in
+	 * acomp_ctx->req->__ctx[] to internally manage updates to the output
+	 * @sg->lengths for the batch. zswap_compress() does not need to
+	 * traverse ZSWAP_MAX_BATCH_SIZE number of output SG list elements to
+	 * get the compressed output length/error for each page in the batch.
+	 * This is readily available in the per-CPU acomp_ctx->req->__ctx[].
+	 * This optimization's per-CPU memory cost for a batching compressor
+	 * with batch-size of 8 is 64 bytes.
+	 */
+	if (pool->compr_batch_size > 1)
+		acomp_ctx->req = acomp_request_alloc_extra(acomp_ctx->acomp,
+					pool->compr_batch_size * sizeof(int *),
+					GFP_KERNEL | __GFP_ZERO);
+	else
+		acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
 
 	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
@@ -886,6 +914,37 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 			goto fail;
 	}
 
+	acomp_ctx->sg_outputs = kmalloc(sizeof(*acomp_ctx->sg_outputs),
+					GFP_KERNEL);
+	if (!acomp_ctx->sg_outputs)
+		goto fail;
+
+	if (sg_alloc_table(acomp_ctx->sg_outputs, pool->compr_batch_size,
+			   GFP_KERNEL))
+		goto fail;
+
+	/*
+	 * Map the per-CPU destination buffers to the per-CPU SG list.
+	 * This only needs to be done once.
+	 */
+	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
+
+	/*
+	 * Use the @pool->compr_batch_size number of int pointers for
+	 * which we allocated extra memory in the @acomp_ctx->req above, to
+	 * track the addresses of the @sg->length members of the individual
+	 * SG lists in @acomp_ctx->sg_outputs->sgl. This is a static mapping
+	 * that needs to be done only once, and saves latency by avoiding
+	 * traversing the SG lists in zswap_compress().
+	 */
+	if (pool->compr_batch_size > 1) {
+		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, pool->compr_batch_size, i)
+			acomp_ctx->req->__ctx[i] = &sg->length;
+	} else {
+		acomp_ctx->req->dlen = PAGE_SIZE;
+	}
+
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
@@ -896,6 +955,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
 	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
@@ -904,84 +965,203 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool, bool folio_wb)
+/*
+ * Unified code path for compressors that do and do not support batching. This
+ * procedure will compress multiple @nr_pages in @folio starting from the
+ * @start index.
+ *
+ * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
+ * sure of this by design and zswap_store_pages() warns once if this is not
+ * true.
+ *
+ * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
+ * support batching.
+ *
+ * If @pool->compr_batch_size is 1, each page is processed sequentially.
+ *
+ * If @pool->compr_batch_size is > 1, compression batching is invoked within
+ * the algorithm's driver, except if @nr_pages is 1: if so, the driver can
+ * choose to call the sequential/non-batching compress API.
+ *
+ * In both cases, if all compressions are successful, the compressed buffers
+ * are stored in zsmalloc.
+ *
+ * Traversing multiple SG lists when @nr_comps is > 1 is expensive, and impacts
+ * batching performance if we were to repeat this operation multiple times,
+ * such as:
+ *   - to map destination buffers to each SG list in the @acomp_ctx->sg_outputs
+ *     sg_table.
+ *   - to initialize each output SG list @sg->length to PAGE_SIZE.
+ *   - to get the compressed output length in each @sg->length.
+ *
+ * These are some design choices made to optimize batching with SG lists:
+ *
+ * 1) The source folio pages in the batch are directly submitted to
+ *    crypto_acomp via acomp_request_set_src_folio().
+ *
+ * 2) The per-CPU @acomp_ctx->sg_outputs scatterlists are used to set up
+ *    destination buffers for interfacing with crypto_acomp.
+ *
+ * 3) To optimize performance, we map the per-CPU @acomp_ctx->buffers to the
+ *    @acomp_ctx->sg_outputs->sgl SG lists at pool creation time. The only task
+ *    remaining to be done for the output SG lists in zswap_compress() is to
+ *    set the @sg->length to PAGE_SIZE. This is done in zswap_compress()
+ *    for non-batching compressors. This needs to be done within the compress
+ *    batching driver procedure as part of iterating through the SG lists for
+ *    batch setup, so as to minimize traversals through the SG lists.
+ *
+ * 4) For batching compressors, we allocate extra memory in the
+ *    @acomp_ctx->req->__ctx[] to store @pool->compr_batch_size number of
+ *    int pointers (the @dlens). These pointers are initialized to the
+ *    individual @sg->lengths' addresses in @acomp_ctx->sg_outputs->sgl at pool
+ *    creation time. zswap_compress() has this readily available without having
+ *    to re-traverse @acomp_ctx->sg_outputs->sgl to get the compressed output
+ *    lengths after batch compression.
+ *
+ * 5) An important requirement for compression errors and batching compressors:
+ *    the individual @sg->lengths in @acomp_ctx->req->sg_outputs->sgl should be
+ *    set to the error value for the respective batch page.
+ *
+ * A few important changes made to not regress and in fact improve
+ * compression performance with non-batching software compressors, using this
+ * new batching code:
+ *
+ * 1) acomp_ctx mutex locking:
+ *    Earlier, the mutex was held per page compression. With the new code,
+ *    [un]locking the mutex per page caused regressions for software
+ *    compressors. We now lock the mutex once per batch, which resolves the
+ *    regression.
+ *
+ * 2) The likely()/unlikely() annotations prevent regressions with software
+ *    compressors like zstd, and generally improve non-batching compressors'
+ *    performance with the batching code by ~3%.
+ */
+static bool zswap_compress(struct folio *folio, long start, unsigned int nr_pages,
+			   struct zswap_entry *entries[], struct zswap_pool *pool,
+			   int node_id, bool folio_wb)
 {
+	unsigned int nr_comps = min(nr_pages, pool->compr_batch_size);
 	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	int *dstlen[1], **dlens;
+	struct scatterlist *sg;
 	unsigned long handle;
+	unsigned int i, j, k;
+	void *dst;
 	gfp_t gfp;
-	u8 *dst;
-	bool mapped = false;
+	int err;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
-
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	dstlen[0] = &acomp_ctx->req->dlen;
+	if (pool->compr_batch_size == 1)
+		dlens = &dstlen[0];
+	else
+		dlens = (int **)&acomp_ctx->req->__ctx[0];
 
 	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zwap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * [i] refers to the incoming batch space and is used to
+	 *     index into the folio pages.
+	 *
+	 * [j] refers to the incoming batch space and is used to
+	 *     index into the @entries for the folio's pages in this
+	 *     batch, per compress call while iterating over the output SG
+	 *     lists. Also used to index into the folio's pages from @start, in
+	 *     case of compress errors.
+	 *
+	 * [k] refers to the @acomp_ctx space, as determined by
+	 *     @pool->compr_batch_size, and is used to index into
+	 *     @acomp_ctx->sg_outputs->sgl, @acomp_ctx->buffers and @dlens.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	for (i = 0; i < nr_pages; i += nr_comps) {
+		acomp_request_set_src_folio(acomp_ctx->req, folio,
+					    (start + i) * PAGE_SIZE,
+					    nr_comps * PAGE_SIZE);
 
-	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
-	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		dlen = PAGE_SIZE;
-		if (!folio_wb) {
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
-			goto unlock;
+		acomp_ctx->sg_outputs->sgl->length = nr_comps * PAGE_SIZE;
+
+		acomp_request_set_dst_sg(acomp_ctx->req,
+					 acomp_ctx->sg_outputs->sgl,
+					 nr_comps * PAGE_SIZE);
+
+		err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+				      &acomp_ctx->wait);
+
+		/*
+		 * If a page cannot be compressed into a size smaller than
+		 * PAGE_SIZE, save the content as is without a compression, to
+		 * keep the LRU order of writebacks.  If writeback is disabled,
+		 * reject the page since it only adds metadata overhead.
+		 * swap_writeout() will put the page back to the active LRU list
+		 * in the case.
+		 *
+		 * It is assumed that any compressor that sets the output length
+		 * to 0 or a value >= PAGE_SIZE will also return a negative
+		 * error status in @err; i.e, will not return a successful
+		 * compression status in @err in this case.
+		 */
+		if (unlikely(err)) {
+			*dstlen[0] = err;
+			if (!folio_wb)
+				goto compress_error;
 		}
-		comp_ret = 0;
-		dst = kmap_local_page(page);
-		mapped = true;
-	}
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
-	}
+		/*
+		 * All @nr_comps pages were either successfully compressed, or,
+		 * writeback is enabled for the folio's memcg and there were
+		 * compression errors. In either case, store the pages in
+		 * zsmalloc:
+		 *
+		 * - For successful compressions, store the compressed outputs.
+		 * - For errors, store the page uncompressed.
+		 */
+		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
+			j = k + i;
+
+			dst = acomp_ctx->buffers[k];
+
+			if (unlikely(*dlens[k] < 0)) {
+				*dlens[k] = PAGE_SIZE;
+				dst = kmap_local_page(folio_page(folio, start + j));
+			}
+
+			handle = zs_malloc(pool->zs_pool, *dlens[k], gfp, node_id);
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+			if (unlikely(IS_ERR_VALUE(handle))) {
+				if (PTR_ERR((void *)handle) == -ENOSPC)
+					zswap_reject_compress_poor++;
+				else
+					zswap_reject_alloc_fail++;
 
-unlock:
-	if (mapped)
-		kunmap_local(dst);
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
+				goto err_unlock;
+			}
+
+			zs_obj_write(pool->zs_pool, handle, dst, *dlens[k]);
+			entries[j]->handle = handle;
+			entries[j]->length = *dlens[k];
+			if (unlikely(dst != acomp_ctx->buffers[k]))
+				kunmap_local(dst);
+		}
+	} /* finished compress and store nr_pages. */
 
 	mutex_unlock(&acomp_ctx->mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+	return true;
+
+compress_error:
+	for (k = 0; k < nr_comps; ++k) {
+		if (*dlens[k] < 0) {
+			if (*dlens[k] == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
+
+err_unlock:
+	mutex_unlock(&acomp_ctx->mutex);
+	return false;
 }
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
@@ -1529,12 +1709,9 @@ static bool zswap_store_pages(struct folio *folio,
 		INIT_LIST_HEAD(&entries[i]->lru);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		struct page *page = folio_page(folio, start + i);
-
-		if (!zswap_compress(page, entries[i], pool, folio_wb))
-			goto store_pages_failed;
-	}
+	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, pool,
+				     node_id, folio_wb)))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		struct zswap_entry *old, *entry = entries[i];
-- 
2.27.0

