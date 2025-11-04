Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254B32144A;
	Tue,  4 Nov 2025 09:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247579; cv=none; b=EsUfaZoJOgOwb6PGWJP0bNaPa/B+/CZLp06bluIMjEyfMSqjoEON4k/u667AYiXy3088dPSZwB/hTrIJlX4s1MpRl/z0JCPgBjrVyTUP9TCLzO02phf6MIMYUJYhNCcPs2B+MuFJXhFTRqsTDMJkG1EWCuIkM/n+eBEL1htSiRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247579; c=relaxed/simple;
	bh=tshnkxFDntEiDDUn9lwaMJT++m4b1goxdBii4NTA0hs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xnau2a0vkpfw6AC1RV4Fx9NOyunMXICvV3s+s4Gas6n2J7Vj5ffgEoWhbwTGmGIX8qD9M8kAQ4is/bOuMmqd/IiLk1PBzMkfWx36pQgJcjcEa8f6H1M8wOOgj4luvOfG76Cj8UAk5pkVRpQRPJWhWjALN+oiLkFanrmhI0yIm1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SylPYYnu; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SylPYYnu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247576; x=1793783576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tshnkxFDntEiDDUn9lwaMJT++m4b1goxdBii4NTA0hs=;
  b=SylPYYnukCwp2goDo82Vk30HamAzS3ziI/ZUFnHN0L8ksYo2NUUkwgLi
   lxFHXIQkYy8KIFUECxGtU4FB+lrKNJJslZa1hXg8sJI3chk3Xb+kECIQy
   rmr3cAy4MCK21FBMI4XlJr7ca+EUZX3HVzmQzTLWbTLVb6bfLpAvYF15n
   x+pNbjXKArG/JHQpEagAhWxBfhoUMvvEMXewN4yZpwa/iIHysKDl47x86
   WWddZkg+mnTh77cqee/3B/warxYbjR5mXdpfsZRq9/igEH7MdPJf6g4XL
   o+JWFiKn1vfvqC8h15yzueKRpEdboiGPfA5hW5uZXab6ZsQrM7QaZeNsG
   g==;
X-CSE-ConnectionGUID: dehHBmfITOyTxHqPVH67hw==
X-CSE-MsgGUID: X5Ejbt2pT0SKK4Wg50keaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798694"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798694"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:40 -0800
X-CSE-ConnectionGUID: thHRiwQuS1mCdXjuj9kx+A==
X-CSE-MsgGUID: sdqk2EGyRG+OzarP7T+rNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795842"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
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
Subject: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with compress batching of large folios.
Date: Tue,  4 Nov 2025 01:12:35 -0800
Message-Id: <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
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

This patch introduces a new unified implementation of zswap_compress()
for compressors that do and do not support batching. This eliminates
code duplication and facilitates code maintainability with the
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
to interface with the crypto API, a "struct sg_table *sg_outputs" is
added to the per-CPU acomp_ctx. In zswap_cpu_comp_prepare(), memory is
allocated for @pool->compr_batch_size scatterlists in
@acomp_ctx->sg_outputs. The per-CPU @acomp_ctx->buffers' addresses are
statically mapped to the respective SG lists. The existing non-NUMA
sg_alloc_table() was found to give better performance than a NUMA-aware
allocation function, hence is used in this patch.

Batching compressors should initialize the output SG lengths to
PAGE_SIZE as part of the internal compress batching setup, to avoid
having to do multiple traversals over the @acomp_ctx->sg_outputs->sgl.
This is exactly how batching is implemented in the iaa_crypto driver's
compress batching procedure, iaa_comp_acompress_batch().

The batched zswap_compress() implementation is generalized as much as
possible for non-batching and batching compressors, so that the
subsequent incompressible page handling, zs_pool writes, and error
handling code is seamless for both, without the use of conditionals to
switch to specialized code for either.

The new batching implementation of zswap_compress() is called with a
batch of @nr_pages sent from zswap_store() to zswap_store_pages().
zswap_compress() steps through the batch in increments of the
compressor's batch-size, sets up the acomp_ctx->req's src/dst SG lists
to contain the folio pages and output buffers, before calling
crypto_acomp_compress().

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

  3) Batching compressors should set acomp_req->dlen to
     acomp_req->dst->length, i.e., the sg->length of the first SG in
     acomp_req->dst.

Another important change this patch makes is with the acomp_ctx mutex
locking in zswap_compress(). Earlier, the mutex was held per page's
compression. With the new code, [un]locking the mutex per page caused
regressions for software compressors when testing with 30 usemem
processes, and also kernel compilation with 'allmod' config. The
regressions were more eggregious when PMD folios were stored. The
implementation in this commit locks/unlocks the mutex once per batch,
that resolves the regression.

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

  usemem30 with 64K folios:
  =========================

     zswap shrinker_enabled = N.

     -----------------------------------------------------------------------
                     mm-unstable-10-24-2025             v13
     -----------------------------------------------------------------------
     zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
                                                                 vs.
                                                             IAA Sequential
     -----------------------------------------------------------------------
     Total throughput (KB/s)     6,118,675       9,901,216       62%
     Average throughput (KB/s)     203,955         330,040       62%
     elapsed time (sec)              98.94           70.90      -28%
     sys time (sec)               2,379.29        1,686.18      -29%
     -----------------------------------------------------------------------

     -----------------------------------------------------------------------
                     mm-unstable-10-24-2025             v13
     -----------------------------------------------------------------------
     zswap compressor                 zstd            zstd   v13 zstd
                                                             improvement
     -----------------------------------------------------------------------
     Total throughput (KB/s)     5,983,561       6,003,851      0.3%
     Average throughput (KB/s)     199,452         200,128      0.3%
     elapsed time (sec)             100.93           96.62     -4.3%
     sys time (sec)               2,532.49        2,395.83       -5%
     -----------------------------------------------------------------------

  usemem30 with 2M folios:
  ========================

     -----------------------------------------------------------------------
                     mm-unstable-10-24-2025             v13
     -----------------------------------------------------------------------
     zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
                                                                 vs.
                                                             IAA Sequential
     -----------------------------------------------------------------------
     Total throughput (KB/s)     6,309,635      10,558,225       67%
     Average throughput (KB/s)     210,321         351,940       67%
     elapsed time (sec)              88.70           67.84      -24%
     sys time (sec)               2,059.83        1,581.07      -23%
     -----------------------------------------------------------------------

     -----------------------------------------------------------------------
                     mm-unstable-10-24-2025             v13
     -----------------------------------------------------------------------
     zswap compressor                 zstd            zstd   v13 zstd
                                                             improvement
     -----------------------------------------------------------------------
     Total throughput (KB/s)     6,562,687       6,567,946      0.1%
     Average throughput (KB/s)     218,756         218,931      0.1%
     elapsed time (sec)              94.69           88.79       -6%
     sys time (sec)               2,253.97        2,083.43       -8%
     -----------------------------------------------------------------------

    The main takeaway from usemem, a workload that is mostly compression
    dominated (very few swapins) is that the higher the number of batches,
    such as with larger folios, the more the benefit of batching cost
    amortization, as shown by the PMD usemem data. This aligns well
    with the future direction for batching.

kernel_compilation/allmodconfig, 64K folios:
============================================

     --------------------------------------------------------------------------
               mm-unstable-10-24-2025             v13
     --------------------------------------------------------------------------
     zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                        IAA Sequential
     --------------------------------------------------------------------------
     real_sec                 836.64          806.94      -3.5%
     sys_sec                3,897.57        3,661.83        -6%
     --------------------------------------------------------------------------

     --------------------------------------------------------------------------
               mm-unstable-10-24-2025             v13
     --------------------------------------------------------------------------
     zswap compressor           zstd            zstd    Improvement
     --------------------------------------------------------------------------
     real_sec                 880.62          850.41      -3.4%
     sys_sec                5,171.90        5,076.51      -1.8%
     --------------------------------------------------------------------------

kernel_compilation/allmodconfig, PMD folios:
============================================

     --------------------------------------------------------------------------
               mm-unstable-10-24-2025             v13
     --------------------------------------------------------------------------
     zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                        IAA Sequential
     --------------------------------------------------------------------------
     real_sec                 818.48          779.67      -4.7%
     sys_sec                4,226.52        4,245.18       0.4%
     --------------------------------------------------------------------------

     --------------------------------------------------------------------------
              mm-unstable-10-24-2025             v13
     --------------------------------------------------------------------------
     zswap compressor          zstd             zstd    Improvement
     --------------------------------------------------------------------------
     real_sec                888.45           849.54      -4.4%
     sys_sec               5,866.72         5,847.17      -0.3%
     --------------------------------------------------------------------------

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 249 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 181 insertions(+), 68 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 257567edc587..c5487dd69ec6 100644
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
@@ -271,6 +272,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
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
@@ -804,6 +810,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -849,6 +856,22 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists.
+	 */
+	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
+
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
@@ -869,84 +892,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool, bool wb_enabled)
+/*
+ * Unified code path for compressors that do and do not support batching. This
+ * procedure will compress multiple @nr_pages in @folio starting from the
+ * @start index.
+ *
+ * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
+ * sure of this by design and zswap_store_pages() warns if this is not
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
+ *   - to initialize each output SG list's @sg->length to PAGE_SIZE.
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
+ *    set each @sg->length to PAGE_SIZE. This is done in zswap_compress()
+ *    for non-batching compressors. This needs to be done within the compress
+ *    batching driver procedure as part of iterating through the SG lists for
+ *    batch setup, so as to minimize expensive traversals through the SG lists.
+ *
+ * 4) Important requirements for batching compressors:
+ *    - Each @sg->length in @acomp_ctx->req->sg_outputs->sgl should reflect the
+ *      compression outcome for that specific page, and be set to:
+ *      - the page's compressed length, or
+ *      - the compression error value for that page.
+ *    - The @acomp_ctx->req->dlen should be set to the first page's
+ *      @sg->length. This enables code generalization in zswap_compress()
+ *      for non-batching and batching compressors.
+ *
+ * acomp_ctx mutex locking:
+ *    Earlier, the mutex was held per page compression. With the new code,
+ *    [un]locking the mutex per page caused regressions for software
+ *    compressors. We now lock the mutex once per batch, which resolves the
+ *    regression.
+ */
+static bool zswap_compress(struct folio *folio, long start, unsigned int nr_pages,
+			   struct zswap_entry *entries[], struct zswap_pool *pool,
+			   int nid, bool wb_enabled)
 {
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	unsigned int nr_comps = min(nr_pages, pool->compr_batch_size);
+	unsigned int slen = nr_comps * PAGE_SIZE;
 	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	int err = 0, err_sg = 0;
+	struct scatterlist *sg;
+	unsigned int i, j, k;
 	unsigned long handle;
-	gfp_t gfp;
-	u8 *dst;
-	bool mapped = false;
+	int *errp, dlen;
+	void *dst;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
-
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	errp = (pool->compr_batch_size == 1) ? &err : &err_sg;
 
 	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zswap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * [i] refers to the incoming batch space and is used to
+	 *     index into the folio pages.
+	 *
+	 * [j] refers to the incoming batch space and is used to
+	 *     index into the @entries for the folio's pages in this
+	 *     batch, per compress call while iterating over the output SG
+	 *     lists. Also used to index into the folio's pages from @start,
+	 *     in case of compress errors.
+	 *
+	 * [k] refers to the @acomp_ctx space, as determined by
+	 *     @pool->compr_batch_size, and is used to index into
+	 *     @acomp_ctx->sg_outputs->sgl and @acomp_ctx->buffers.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	for (i = 0; i < nr_pages; i += nr_comps) {
+		acomp_request_set_src_folio(acomp_ctx->req, folio,
+					    (start + i) * PAGE_SIZE,
+					    slen);
 
-	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
-	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		if (!wb_enabled) {
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
-			goto unlock;
-		}
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_page(page);
-		mapped = true;
-	}
+		acomp_ctx->sg_outputs->sgl->length = slen;
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
-	}
+		acomp_request_set_dst_sg(acomp_ctx->req,
+					 acomp_ctx->sg_outputs->sgl,
+					 slen);
+
+		err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+				      &acomp_ctx->wait);
+
+		acomp_ctx->sg_outputs->sgl->length = acomp_ctx->req->dlen;
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
+		if (err && !wb_enabled)
+			goto compress_error;
+
+		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
+			j = k + i;
+			dst = acomp_ctx->buffers[k];
+			dlen = sg->length | *errp;
+
+			if (dlen < 0) {
+				dlen = PAGE_SIZE;
+				dst = kmap_local_page(folio_page(folio, start + j));
+			}
+
+			handle = zs_malloc(pool->zs_pool, dlen, gfp, nid);
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+			if (IS_ERR_VALUE(handle)) {
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
+			zs_obj_write(pool->zs_pool, handle, dst, dlen);
+			entries[j]->handle = handle;
+			entries[j]->length = dlen;
+			if (dst != acomp_ctx->buffers[k])
+				kunmap_local(dst);
+		}
+	} /* finished compress and store nr_pages. */
+
+	mutex_unlock(&acomp_ctx->mutex);
+	return true;
+
+compress_error:
+	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
 
+err_unlock:
 	mutex_unlock(&acomp_ctx->mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+	return false;
 }
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
@@ -1488,12 +1604,9 @@ static bool zswap_store_pages(struct folio *folio,
 		INIT_LIST_HEAD(&entries[i]->lru);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		struct page *page = folio_page(folio, start + i);
-
-		if (!zswap_compress(page, entries[i], pool, wb_enabled))
-			goto store_pages_failed;
-	}
+	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, pool,
+				     nid, wb_enabled)))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		struct zswap_entry *old, *entry = entries[i];
-- 
2.27.0

