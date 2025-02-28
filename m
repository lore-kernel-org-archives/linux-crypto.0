Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9C525E444;
	Fri, 28 Feb 2025 10:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736843; cv=none; b=fQSOS9sN2/booqZTc1RfnWSK9T+SRA62olz8IT7LC/Y4RG+aSOJokI9QZ6FYGVDmGaGcHPy6Kt0LDKF3MLejyS2VWGXO0gSJJJORxvhBmyRlP4MMRd65SEH5nSgJpiEslfrPVFQUIzZiNZSKsO5AWuXjmBbjVbWeSMS11kBjhiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736843; c=relaxed/simple;
	bh=jvGXi0w+0TEz8Qyri1YoZHBnZuLioAdX+aCO0qi+82U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QsKFSYPjM+emDYni0k5AXtp38sUWKiEbrQa6TLmE3jUMlDI0YdSWha0ARhdy2TLg98By98Z6U7AbDmGvin/AXqqNI9Rfn4L0YGva3Qgxu4CpvkZaAEnRVpdA6vJMLLDPjOt93h5L5c6HZl81yZZgKSkmruSWNyjREGkXtjfHPh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lfMuV8Nk; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lfMuV8Nk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736841; x=1772272841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvGXi0w+0TEz8Qyri1YoZHBnZuLioAdX+aCO0qi+82U=;
  b=lfMuV8NkHvnGDuQ2T7GoqTheD8oak5tJjlTKBrTjxt1lUZGVO6wwv1WK
   DFPqJkCSZ4/++MRFhN+nElj+/4whx44vVxJUPUu0JcwQz3VJUwVRP5jXM
   NpfNmNKjs5HRGSYFqjBXtxm4Fxv43axk4MKDyuZ4c4Kxb4vj0CiD7xV0+
   oLsGZSVpIDhDjUhWKWqwuqrQXSgk0wqUx+SM818MFlF0F1U7iFuLh3uOM
   F2S7Pco04Og2t6d3LvNcfTa9fB6ibN3XKypIg9Z8ArhWSuDSwiFadBTOt
   iyLK9dgKy7G6jBBY28OAT7o/9vbA/omwpVwj34+NczB1MhoelffVAifaI
   Q==;
X-CSE-ConnectionGUID: oK7i7NahQOeM7GcHZ5fVcA==
X-CSE-MsgGUID: ADPy/qW0TuerYoNtMDx2GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902752"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902752"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:30 -0800
X-CSE-ConnectionGUID: gf9n65U1T1W3py/NR3L3jA==
X-CSE-MsgGUID: FFypTQGRSBufECFT1f0iYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325761"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:30 -0800
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
Subject: [PATCH v7 15/15] mm: zswap: Compress batching with request chaining in zswap_store() of large folios.
Date: Fri, 28 Feb 2025 02:00:24 -0800
Message-Id: <20250228100024.332528-16-kanchana.p.sridhar@intel.com>
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

This patch introduces zswap_batch_compress() that takes an index within a
folio, and sets up a request chain for compressing multiple pages of that
folio, as a batch.

The call to the crypto layer is exactly the same as in zswap_compress(),
when batch compressing a request chain in zswap_batch_compress().

zswap_store_folio() is modified to detect if the pool's acomp_ctx has
more than one "nr_reqs", which will be the case if the CPU onlining code
has allocated multiple batching resources in the acomp_ctx. If so, it means
compress batching can be used with a batch-size of "acomp_ctx->nr_reqs".

If compress batching can be used, zswap_store_folio() will invoke
zswap_batch_compress() to compress and store the folio in batches of
"acomp_ctx->nr_reqs" pages.

With Intel IAA, the iaa_crypto driver will compress each batch of pages in
parallel in hardware.

Hence, zswap_batch_compress() does the same computes for a batch, as
zswap_compress() does for a page; and returns true if the batch was
successfully compressed/stored, and false otherwise.

If the pool does not support compress batching, or the folio has only one
page, zswap_store_folio() calls zswap_compress() for each individual
page in the folio, as before.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 296 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 224 insertions(+), 72 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ab9167220cb6..626574bd84f6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1051,9 +1051,9 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 }
 
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+			   struct zswap_pool *pool,
+			   struct crypto_acomp_ctx *acomp_ctx)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
@@ -1063,7 +1063,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	gfp_t gfp;
 	u8 *dst;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	lockdep_assert_held(&acomp_ctx->mutex);
+
 	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -1091,7 +1092,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
 	dlen = acomp_ctx->reqs[0]->dlen;
 	if (comp_ret)
-		goto unlock;
+		goto check_errors;
 
 	zpool = pool->zpool;
 	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
@@ -1099,7 +1100,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
 	alloc_ret = zpool_malloc(zpool, dlen, gfp, &handle);
 	if (alloc_ret)
-		goto unlock;
+		goto check_errors;
 
 	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
 	memcpy(buf, dst, dlen);
@@ -1108,7 +1109,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	entry->handle = handle;
 	entry->length = dlen;
 
-unlock:
+check_errors:
 	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
 		zswap_reject_compress_poor++;
 	else if (comp_ret)
@@ -1116,7 +1117,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -1580,6 +1580,106 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
+/*
+ * Batch compress multiple @nr_pages in @folio, starting from @index.
+ */
+static bool zswap_batch_compress(struct folio *folio,
+				 long index,
+				 unsigned int nr_pages,
+				 struct zswap_entry *entries[],
+				 struct zswap_pool *pool,
+				 struct crypto_acomp_ctx *acomp_ctx)
+{
+	struct scatterlist inputs[ZSWAP_MAX_BATCH_SIZE];
+	struct scatterlist outputs[ZSWAP_MAX_BATCH_SIZE];
+	unsigned int i;
+	int err = 0;
+
+	lockdep_assert_held(&acomp_ctx->mutex);
+
+	for (i = 0; i < nr_pages; ++i) {
+		struct page *page = folio_page(folio, index + i);
+
+		sg_init_table(&inputs[i], 1);
+		sg_set_page(&inputs[i], page, PAGE_SIZE, 0);
+
+		/*
+		 * Each dst buffer should be of size (PAGE_SIZE * 2).
+		 * Reflect same in sg_list.
+		 */
+		sg_init_one(&outputs[i], acomp_ctx->buffers[i], PAGE_SIZE * 2);
+		acomp_request_set_params(acomp_ctx->reqs[i], &inputs[i],
+					 &outputs[i], PAGE_SIZE, PAGE_SIZE);
+
+		/* Use acomp request chaining. */
+		if (i)
+			acomp_request_chain(acomp_ctx->reqs[i], acomp_ctx->reqs[0]);
+		else
+			acomp_reqchain_init(acomp_ctx->reqs[0], 0, crypto_req_done,
+					    &acomp_ctx->wait);
+	}
+
+	err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
+
+	/*
+	 * Get the individual compress errors from request chaining.
+	 */
+	for (i = 0; i < nr_pages; ++i) {
+		if (unlikely(acomp_request_err(acomp_ctx->reqs[i]))) {
+			err = -EINVAL;
+			if (acomp_request_err(acomp_ctx->reqs[i]) == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
+
+	if (likely(!err)) {
+		/*
+		 * All batch pages were successfully compressed.
+		 * Store the pages in zpool.
+		 */
+		struct zpool *zpool = pool->zpool;
+		gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
+
+		if (zpool_malloc_support_movable(zpool))
+			gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
+
+		for (i = 0; i < nr_pages; ++i) {
+			unsigned long handle;
+			char *buf;
+
+			err = zpool_malloc(zpool, acomp_ctx->reqs[i]->dlen, gfp, &handle);
+
+			if (err) {
+				if (err == -ENOSPC)
+					zswap_reject_compress_poor++;
+				else
+					zswap_reject_alloc_fail++;
+
+				break;
+			}
+
+			buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
+			memcpy(buf, acomp_ctx->buffers[i], acomp_ctx->reqs[i]->dlen);
+			zpool_unmap_handle(zpool, handle);
+
+			entries[i]->handle = handle;
+			entries[i]->length = acomp_ctx->reqs[i]->dlen;
+		}
+	}
+
+	/*
+	 * Request chaining cleanup:
+	 *
+	 * - Clear the CRYPTO_TFM_REQ_CHAIN bit on acomp_ctx->reqs[0].
+	 * - Reset the acomp_ctx->wait to notify acomp_ctx->reqs[0].
+	 */
+	acomp_reqchain_clear(acomp_ctx->reqs[0], &acomp_ctx->wait);
+
+	return !err;
+}
+
 /*
  * Store all pages in a folio.
  *
@@ -1588,95 +1688,146 @@ static void shrink_worker(struct work_struct *w)
  * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
  * entry's handle is subsequently modified only upon a successful zpool_malloc()
  * after the page is compressed.
+ *
+ * For compressors that don't support batching, the following structure
+ * showed a performance regression with zstd using 64K as well as 2M folios:
+ *
+ * Batched stores:
+ * ---------------
+ *  - Allocate all entries,
+ *  - Compress all entries,
+ *  - Store all entries in xarray/LRU.
+ *
+ * Hence, the above structure is maintained only for batched stores, and the
+ * following structure is implemented for sequential stores of large folio pages,
+ * that fixes the regression, while preserving common code paths for batched
+ * and sequential stores of a folio:
+ *
+ * Sequential stores:
+ * ------------------
+ * For each page in folio:
+ *  - allocate an entry,
+ *  - compress the page,
+ *  - store the entry in xarray/LRU.
  */
 static bool zswap_store_folio(struct folio *folio,
 			      struct obj_cgroup *objcg,
 			      struct zswap_pool *pool)
 {
-	long index, from_index = 0, nr_pages = folio_nr_pages(folio);
+	long index = 0, from_index = 0, nr_pages, nr_folio_pages = folio_nr_pages(folio);
 	struct zswap_entry **entries = NULL;
+	struct crypto_acomp_ctx *acomp_ctx;
 	int node_id = folio_nid(folio);
+	unsigned int batch_size;
+	bool batching;
 
-	entries = kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);
+	entries = kmalloc(nr_folio_pages * sizeof(*entries), GFP_KERNEL);
 	if (!entries)
 		return false;
 
-	for (index = from_index; index < nr_pages; ++index) {
-		entries[index] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 
-		if (!entries[index]) {
-			zswap_reject_kmemcache_fail++;
-			nr_pages = index;
-			goto store_folio_failed;
-		}
+	batch_size = acomp_ctx->nr_reqs;
 
-		entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
-	}
+	nr_pages = (batch_size > 1) ? nr_folio_pages : 1;
+	batching = (nr_pages > 1) ? true : false;
 
-	for (index = from_index; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-		swp_entry_t page_swpentry = page_swap_entry(page);
-		struct zswap_entry *old, *entry = entries[index];
+	while (1) {
+		for (index = from_index; index < nr_pages; ++index) {
+			entries[index] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
 
-		if (!zswap_compress(page, entry, pool)) {
-			from_index = index;
-			goto store_folio_failed;
-		}
+			if (!entries[index]) {
+				zswap_reject_kmemcache_fail++;
+				nr_pages = index;
+				goto store_folio_failed;
+			}
 
-		old = xa_store(swap_zswap_tree(page_swpentry),
-			       swp_offset(page_swpentry),
-			       entry, GFP_KERNEL);
-		if (xa_is_err(old)) {
-			int err = xa_err(old);
+			entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		}
 
-			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-			zswap_reject_alloc_fail++;
-			from_index = index;
-			goto store_folio_failed;
+		if (batching) {
+			/* Batch compress the pages in the folio. */
+			for (index = from_index; index < nr_pages; index += batch_size) {
+
+				if (!zswap_batch_compress(folio, index,
+							  min((unsigned int)(nr_pages - index),
+							      batch_size),
+							  &entries[index], pool, acomp_ctx))
+					goto store_folio_failed;
+			}
+		} else {
+			/* Sequential compress the next page in the folio. */
+			struct page *page = folio_page(folio, from_index);
+
+			if (!zswap_compress(page, entries[from_index], pool, acomp_ctx))
+				goto store_folio_failed;
 		}
 
-		/*
-		 * We may have had an existing entry that became stale when
-		 * the folio was redirtied and now the new version is being
-		 * swapped out. Get rid of the old.
-		 */
-		if (old)
-			zswap_entry_free(old);
+		for (index = from_index; index < nr_pages; ++index) {
+			swp_entry_t page_swpentry = page_swap_entry(folio_page(folio, index));
+			struct zswap_entry *old, *entry = entries[index];
 
-		/*
-		 * The entry is successfully compressed and stored in the tree, there is
-		 * no further possibility of failure. Grab refs to the pool and objcg,
-		 * charge zswap memory, and increment zswap_stored_pages.
-		 * The opposite actions will be performed by zswap_entry_free()
-		 * when the entry is removed from the tree.
-		 */
-		zswap_pool_get(pool);
-		if (objcg) {
-			obj_cgroup_get(objcg);
-			obj_cgroup_charge_zswap(objcg, entry->length);
-		}
-		atomic_long_inc(&zswap_stored_pages);
+			old = xa_store(swap_zswap_tree(page_swpentry),
+				swp_offset(page_swpentry),
+				entry, GFP_KERNEL);
+			if (xa_is_err(old)) {
+				int err = xa_err(old);
 
-		/*
-		 * We finish initializing the entry while it's already in xarray.
-		 * This is safe because:
-		 *
-		 * 1. Concurrent stores and invalidations are excluded by folio lock.
-		 *
-		 * 2. Writeback is excluded by the entry not being on the LRU yet.
-		 *    The publishing order matters to prevent writeback from seeing
-		 *    an incoherent entry.
-		 */
-		entry->pool = pool;
-		entry->swpentry = page_swpentry;
-		entry->objcg = objcg;
-		entry->referenced = true;
-		if (entry->length) {
-			INIT_LIST_HEAD(&entry->lru);
-			zswap_lru_add(&zswap_list_lru, entry);
+				WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+				zswap_reject_alloc_fail++;
+				from_index = index;
+				goto store_folio_failed;
+			}
+
+			/*
+			 * We may have had an existing entry that became stale when
+			 * the folio was redirtied and now the new version is being
+			 * swapped out. Get rid of the old.
+			 */
+			if (old)
+				zswap_entry_free(old);
+
+			/*
+			 * The entry is successfully compressed and stored in the tree, there is
+			 * no further possibility of failure. Grab refs to the pool and objcg,
+			 * charge zswap memory, and increment zswap_stored_pages.
+			 * The opposite actions will be performed by zswap_entry_free()
+			 * when the entry is removed from the tree.
+			 */
+			zswap_pool_get(pool);
+			if (objcg) {
+				obj_cgroup_get(objcg);
+				obj_cgroup_charge_zswap(objcg, entry->length);
+			}
+			atomic_long_inc(&zswap_stored_pages);
+
+			/*
+			 * We finish initializing the entry while it's already in xarray.
+			 * This is safe because:
+			 *
+			 * 1. Concurrent stores and invalidations are excluded by folio lock.
+			 *
+			 * 2. Writeback is excluded by the entry not being on the LRU yet.
+			 *    The publishing order matters to prevent writeback from seeing
+			 *    an incoherent entry.
+			 */
+			entry->pool = pool;
+			entry->swpentry = page_swpentry;
+			entry->objcg = objcg;
+			entry->referenced = true;
+			if (entry->length) {
+				INIT_LIST_HEAD(&entry->lru);
+				zswap_lru_add(&zswap_list_lru, entry);
+			}
 		}
+
+		from_index = nr_pages++;
+
+		if (nr_pages > nr_folio_pages)
+			break;
 	}
 
+	acomp_ctx_put_unlock(acomp_ctx);
 	kfree(entries);
 	return true;
 
@@ -1688,6 +1839,7 @@ static bool zswap_store_folio(struct folio *folio,
 		zswap_entry_cache_free(entries[index]);
 	}
 
+	acomp_ctx_put_unlock(acomp_ctx);
 	kfree(entries);
 	return false;
 }
-- 
2.27.0

