Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C0728489E;
	Fri, 26 Sep 2025 03:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857727; cv=none; b=b0H+UnONw73EX+pusHAxD5WsySw+g9B+BKsR0UnVDJ7tHBfqFHCliry7cfNETcSR4WXzf0aQhgws5bV48YGCs/MsR84jrsDMEz9jpBXasKoWqhVDnuq0N+vDieNGymX92iPVYRMMlIVt7/Kla5Nbx9Vq7a/90qvevzDidQPqEbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857727; c=relaxed/simple;
	bh=mGtXvNmlYxsrpZ+kKJB5ZWF7dLawxjBywtU+Xpqj8Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gNhVZ6EzGjbrbw4gWuqcjRDTP+JGFUKMpr83tsn/3G5qYtlUEJ9XOz1TiMDYizYX4G7UpphzTZpA3SdcjmhYisufbxMUZ3ORhpp9u1BiRFp5k59lDyPo2Lo6xY22yfvxxnOZ7Dr3k4UbUcviFO1yadItS46B/vW8DP3IIq+Di2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y5MMlU5K; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y5MMlU5K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857725; x=1790393725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mGtXvNmlYxsrpZ+kKJB5ZWF7dLawxjBywtU+Xpqj8Mg=;
  b=Y5MMlU5Kq5F/jUqwyjMAuhd8nhRfA8j15uyyxesNfXVPC+SrCQd7TEPD
   5qm6uq7VmbdTRPJAqEBKx3alKCl+JtjkweZU1SSjcvH7BS288Yj8TGU0w
   3goTeg9D0QMnqFEV92xEmMw8I1jBJwC1OtsbD65eZ+8YWoEFwEG9RhE2H
   7S2TvAcsOa2h0TTZ2quij429bOq6m3IksDn87dKczRLoqGnc0yaNZVoby
   EEn3RZEGpPR3QQvRD/uQwpg1zXgw5qnHw+n/A65Z9wpV/eFfBD+SWyf3L
   ZuDi3qPRupT16KGxL1/21AjRYAMvqS4NJLpYwlv2eIil0WjOKtp/EHnqv
   g==;
X-CSE-ConnectionGUID: b2nyaV1IRhOI3P07BAJ15Q==
X-CSE-MsgGUID: 1LHjrlPHTPiA5hBygWkMSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819700"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819700"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:08 -0700
X-CSE-ConnectionGUID: 1UJzSllASZCUHGsMSBm3oQ==
X-CSE-MsgGUID: xgBxwvpgT7utbXkp/7Mv3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636618"
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
Subject: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large folio in batches.
Date: Thu, 25 Sep 2025 20:35:01 -0700
Message-Id: <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
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

This patch makes two major changes:

First, we allocate pool batching resources if the compressor supports
batching:

  This patch sets up zswap for allocating per-CPU resources optimally
  for non-batching and batching compressors.

  A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
  limit on the number of pages in large folios that will be batch
  compressed.

  It is up to the compressor to manage multiple requests, as needed, to
  accomplish batch parallelism. zswap only needs to allocate the per-CPU
  dst buffers according to the batch size supported by the compressor.

  A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
  Yosry's suggestion. pool->compr_batch_size is set as the minimum of
  the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly,
  it proceeds to allocate the necessary compression dst buffers in the
  per-CPU acomp_ctx.

  Another "u8 store_batch_size" member is added to "struct zswap_pool"
  to store the unit for batching large folio stores: for batching
  compressors, this is the pool->compr_batch_size. For non-batching
  compressors, this is ZSWAP_MAX_BATCH_SIZE.

  zswap does not use more than one dst buffer yet. Follow-up patches
  will actually utilize the multiple acomp_ctx buffers for batch
  compression/decompression of multiple pages.

  Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
  batching. There is a small extra memory overhead of allocating
  the acomp_ctx->buffers array for compressors that do not support
  batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).

Next, we store the folio in batches:

  This patch modifies zswap_store() to store a batch of pages in large
  folios at a time, instead of storing one page at a time. It does this by
  calling a new procedure zswap_store_pages() with a range of
  "pool->store_batch_size" indices in the folio.

  zswap_store_pages() implements all the computes done earlier in
  zswap_store_page() for a single-page, for multiple pages in a folio,
  namely the "batch":

  1) It starts by allocating all zswap entries required to store the
     batch. New procedures, zswap_entries_cache_alloc_batch() and
     zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
     to optimize the performance of this step.

  2) Next, the entries fields are written, computes that need to be happen
     anyway, without modifying the zswap xarray/LRU publishing order. This
     improves latency by avoiding having to bring the entries into the
     cache for writing in different code blocks within this procedure.

  3) Next, it calls zswap_compress() to sequentially compress each page in
     the batch.

  4) Finally, it adds the batch's zswap entries to the xarray and LRU,
     charges zswap memory and increments zswap stats.

  5) The error handling and cleanup required for all failure scenarios
     that can occur while storing a batch in zswap are consolidated to a
     single "store_pages_failed" label in zswap_store_pages(). Here again,
     we optimize performance by calling kmem_cache_free_bulk().

This commit also makes a minor optimization in zswap_compress(), for the
info on whether or not the page's folio has memcg writeback enabled to
be passed in via a "bool folio_wb" flag from zswap_store(). The intent
is to not re-compute this for every page in a folio. Since
zswap_compress() is a static function, I figured this should be safe.
A repetition of "dlen = PAGE_SIZE" is deleted.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 319 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 224 insertions(+), 95 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3b3716808d7d..9e0e7887de33 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
+	u8 **buffers;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -158,6 +161,8 @@ struct zswap_pool {
 	struct work_struct release_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+	u8 compr_batch_size;
+	u8 store_batch_size;
 };
 
 /* Global LRU lists shared by all zswap pools. */
@@ -252,8 +257,10 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
  *   zswap_cpu_comp_prepare(), not others.
  * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
  */
-static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (IS_ERR_OR_NULL(acomp_ctx))
 		return;
 
@@ -263,7 +270,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		crypto_free_acomp(acomp_ctx->acomp);
 
-	kfree(acomp_ctx->buffer);
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -275,6 +286,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
 		return NULL;
 
+	/* Many things rely on the zero-initialization. */
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
@@ -334,13 +346,28 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 		goto ref_fail;
 	INIT_LIST_HEAD(&pool->list);
 
+	/*
+	 * Set the unit of compress batching for large folios, for quick
+	 * retrieval in the zswap_compress() fast path:
+	 * If the compressor is sequential (@pool->compr_batch_size is 1),
+	 * large folios will be compressed in batches of ZSWAP_MAX_BATCH_SIZE
+	 * pages, where each page in the batch is compressed sequentially.
+	 * We see better performance by processing the folio in batches of
+	 * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
+	 * structures.
+	 */
+	pool->store_batch_size = (pool->compr_batch_size > 1) ?
+				  pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
+
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
 ref_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -376,7 +403,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	zswap_pool_debug("destroying", pool);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -763,6 +791,24 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+/*
+ * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number otherwise.
+ * The code for __kmem_cache_alloc_bulk() indicates that this positive number
+ * will be the @size requested, i.e., @nr_entries.
+ */
+static __always_inline int zswap_entries_cache_alloc_batch(void **entries,
+							   unsigned int nr_entries,
+							   gfp_t gfp)
+{
+	return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries, entries);
+}
+
+static __always_inline void zswap_entries_cache_free_batch(void **entries,
+							   unsigned int nr_entries)
+{
+	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
+}
+
 /*
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -789,7 +835,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int cpu_node = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
@@ -802,11 +850,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		return 0;
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return ret;
-
-	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_node);
 	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
@@ -815,20 +859,40 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	}
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
+
 	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
+			pool->tfm_name);
 		goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
+	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					  GFP_KERNEL, cpu_node);
+	if (!acomp_ctx->buffers)
+		goto fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL,
+						     cpu_node);
+		if (!acomp_ctx->buffers[i])
+			goto fail;
+	}
 
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
+	crypto_init_wait(&acomp_ctx->wait);
+
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
@@ -836,12 +900,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
 fail:
-	acomp_ctx_dealloc(acomp_ctx);
+	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
 	return ret;
 }
 
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+			   struct zswap_pool *pool, bool folio_wb)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -855,7 +919,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -886,13 +950,11 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		dlen = PAGE_SIZE;
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
+		if (!folio_wb) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
 		comp_ret = 0;
-		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
 		mapped = true;
 	}
@@ -932,7 +994,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
+	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffers[0]);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
@@ -942,15 +1004,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	/*
 	 * zs_obj_read_begin() might return a kmap address of highmem when
-	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
-	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
+	 * acomp_ctx->buffers[0] is not used.  However, sg_init_one() does not
+	 * handle highmem addresses, so copy the object to acomp_ctx->buffers[0].
 	 */
 	if (virt_addr_valid(obj)) {
 		src = obj;
 	} else {
-		WARN_ON_ONCE(obj == acomp_ctx->buffer);
-		memcpy(acomp_ctx->buffer, obj, entry->length);
-		src = acomp_ctx->buffer;
+		WARN_ON_ONCE(obj == acomp_ctx->buffers[0]);
+		memcpy(acomp_ctx->buffers[0], obj, entry->length);
+		src = acomp_ctx->buffers[0];
 	}
 
 	sg_init_one(&input, src, entry->length);
@@ -1404,95 +1466,160 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct folio *folio,
+			      long start,
+			      long end,
+			      struct obj_cgroup *objcg,
+			      struct zswap_pool *pool,
+			      int node_id,
+			      bool folio_wb)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
-	struct zswap_entry *entry, *old;
-
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+	u8 i, store_fail_idx = 0, nr_pages = end - start;
+
+	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
+						      nr_pages, GFP_KERNEL))) {
+		for (i = 0; i < nr_pages; ++i) {
+			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+
+			if (unlikely(!entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				/*
+				 * While handling this error, we only need to
+				 * call zswap_entries_cache_free_batch() for
+				 * entries[0 .. i-1].
+				 */
+				nr_pages = i;
+				goto store_pages_failed;
+			}
+		}
 	}
 
-	if (!zswap_compress(page, entry, pool))
-		goto compress_failed;
+	/*
+	 * Three sets of initializations are done to minimize bringing
+	 * @entries into the cache for writing at different parts of this
+	 * procedure, since doing so regresses performance:
+	 *
+	 * 1) Do all the writes to each entry in one code block. These
+	 *    writes need to be done anyway upon success which is more likely
+	 *    than not.
+	 *
+	 * 2) Initialize the handle to an error value. This facilitates
+	 *    having a consolidated failure handling
+	 *    'goto store_pages_failed' that can inspect the value of the
+	 *    handle to determine whether zsmalloc memory needs to be
+	 *    de-allocated.
+	 *
+	 * 3) The page_swap_entry() is obtained once and stored in the entry.
+	 *    Subsequent store in xarray gets the entry->swpentry instead of
+	 *    calling page_swap_entry(), minimizing computes.
+	 */
+	for (i = 0; i < nr_pages; ++i) {
+		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		entries[i]->pool = pool;
+		entries[i]->swpentry = page_swap_entry(folio_page(folio, start + i));
+		entries[i]->objcg = objcg;
+		entries[i]->referenced = true;
+		INIT_LIST_HEAD(&entries[i]->lru);
+	}
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct page *page = folio_page(folio, start + i);
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+		if (!zswap_compress(page, entries[i], pool, folio_wb))
+			goto store_pages_failed;
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct zswap_entry *old, *entry = entries[i];
 
-	/*
-	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg,
-	 * charge zswap memory, and increment zswap_stored_pages.
-	 * The opposite actions will be performed by zswap_entry_free()
-	 * when the entry is removed from the tree.
-	 */
-	zswap_pool_get(pool);
-	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
-	}
-	atomic_long_inc(&zswap_stored_pages);
-	if (entry->length == PAGE_SIZE)
-		atomic_long_inc(&zswap_stored_incompressible_pages);
+		old = xa_store(swap_zswap_tree(entry->swpentry),
+			       swp_offset(entry->swpentry),
+			       entry, GFP_KERNEL);
+		if (unlikely(xa_is_err(old))) {
+			int err = xa_err(old);
 
-	/*
-	 * We finish initializing the entry while it's already in xarray.
-	 * This is safe because:
-	 *
-	 * 1. Concurrent stores and invalidations are excluded by folio lock.
-	 *
-	 * 2. Writeback is excluded by the entry not being on the LRU yet.
-	 *    The publishing order matters to prevent writeback from seeing
-	 *    an incoherent entry.
-	 */
-	entry->pool = pool;
-	entry->swpentry = page_swpentry;
-	entry->objcg = objcg;
-	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+			zswap_reject_alloc_fail++;
+			/*
+			 * Entries up to this point have been stored in the
+			 * xarray. zswap_store() will erase them from the xarray
+			 * and call zswap_entry_free(). Local cleanup in
+			 * 'store_pages_failed' only needs to happen for
+			 * entries from [@i to @nr_pages).
+			 */
+			store_fail_idx = i;
+			goto store_pages_failed;
+		}
+
+		/*
+		 * We may have had an existing entry that became stale when
+		 * the folio was redirtied and now the new version is being
+		 * swapped out. Get rid of the old.
+		 */
+		if (unlikely(old))
+			zswap_entry_free(old);
+
+		/*
+		 * The entry is successfully compressed and stored in the tree, there is
+		 * no further possibility of failure. Grab refs to the pool and objcg,
+		 * charge zswap memory, and increment zswap_stored_pages.
+		 * The opposite actions will be performed by zswap_entry_free()
+		 * when the entry is removed from the tree.
+		 */
+		zswap_pool_get(pool);
+		if (objcg) {
+			obj_cgroup_get(objcg);
+			obj_cgroup_charge_zswap(objcg, entry->length);
+		}
+		atomic_long_inc(&zswap_stored_pages);
+		if (entry->length == PAGE_SIZE)
+			atomic_long_inc(&zswap_stored_incompressible_pages);
+
+		/*
+		 * We finish by adding the entry to the LRU while it's already
+		 * in xarray. This is safe because:
+		 *
+		 * 1. Concurrent stores and invalidations are excluded by folio lock.
+		 *
+		 * 2. Writeback is excluded by the entry not being on the LRU yet.
+		 *    The publishing order matters to prevent writeback from seeing
+		 *    an incoherent entry.
+		 */
+		if (likely(entry->length))
+			zswap_lru_add(&zswap_list_lru, entry);
 	}
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < nr_pages; ++i) {
+		if (!IS_ERR_VALUE(entries[i]->handle))
+			zs_free(pool->zs_pool, entries[i]->handle);
+	}
+	zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
+				       nr_pages - store_fail_idx);
+
 	return false;
 }
 
 bool zswap_store(struct folio *folio)
 {
+	bool folio_wb = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
 	long nr_pages = folio_nr_pages(folio);
+	int node_id = folio_nid(folio);
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	bool ret = false;
-	long index;
+	long start, end;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1526,10 +1653,12 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
+	/* Store the folio in batches of @pool->store_batch_size pages. */
+	for (start = 0; start < nr_pages; start += pool->store_batch_size) {
+		end = min(start + pool->store_batch_size, nr_pages);
 
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_pages(folio, start, end, objcg, pool,
+				       node_id, folio_wb))
 			goto put_pool;
 	}
 
@@ -1559,9 +1688,9 @@ bool zswap_store(struct folio *folio)
 		struct zswap_entry *entry;
 		struct xarray *tree;
 
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
+		for (start = 0; start < nr_pages; ++start) {
+			tree = swap_zswap_tree(swp_entry(type, offset + start));
+			entry = xa_erase(tree, offset + start);
 			if (entry)
 				zswap_entry_free(entry);
 		}
-- 
2.27.0

