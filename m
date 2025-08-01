Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1244A22D4E9;
	Fri,  1 Aug 2025 04:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023026; cv=none; b=bWXcGyY89djyO8TrbCMNpktafmCnbL2y8Mh64agZZOe3uzm1S1s3FNsOiQnPXD8sKBaWKAfA47w4NEFkWp2D53lLBRP0M9QJ6Ei66r9KkC5/B564fqP9k6lvQoEQKMMJ5xcHXLzn64gsoy4W20WhRChbFQOu8tELB1IaRPDriC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023026; c=relaxed/simple;
	bh=4O1PtJOxHU0uFj7Qwb/its0w8B+AFIicISATmM2iugY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cbe/lESr8LU+PxQDWFeKCRQJZGxeVs88zvAW7ZnmMHq8dl2atuNttlpscLYuZ7vTJDd7hKaE3XvnjRFOZawBbcIgsn5NH48hGEdhCnmG67sLb5MLNq2Ouv5aK8orQk/C9miKWOk5xQ3PS2wINv3mK4gMfKNpMrvp+lYbl6X4BWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VjuLLVg9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VjuLLVg9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023024; x=1785559024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4O1PtJOxHU0uFj7Qwb/its0w8B+AFIicISATmM2iugY=;
  b=VjuLLVg9JSNBixevktuSoNtnbBuBxSRGjwMSTaqgUkIMNYvgFtm63RHR
   udNTh9KCRcHWapD4+51NN50zMr4dvNGzivVV5gZpFuu+xYQbDiCApCAAt
   n3GB7EE3Zog1zE1Hidy/2v/r6mZxVM9to+cpLOyjFtANOM2vkl/1YZY90
   bKpzjE15sj4IamK7JdI6Nhzo3qMCxX4nOmq7+5oooMOkx2Yn64wxAVCbV
   61Kxql6oxDB0FLR9LR4mG7qKnRPdqg6fIQ90m66bexo2/zzDUDCfIPPWE
   MfV5W5QsuwDCClJhVlYwb5+wXPvXuWjAX+u/xbn0FyNBFbx+jP3aCI1ov
   A==;
X-CSE-ConnectionGUID: eVXYEN6tSoGlZ5S7HugUtQ==
X-CSE-MsgGUID: u9KFhOSmRAabuGtZ0eEwpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820444"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820444"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: gYq1lz4uSNWPP+XWvg6arw==
X-CSE-MsgGUID: CAvFKNwkTtOIVy7Zd+ADnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796317"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:47 -0700
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
Subject: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large folio in batches.
Date: Thu, 31 Jul 2025 21:36:41 -0700
Message-Id: <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch modifies zswap_store() to store a batch of pages in large
folios at a time, instead of storing one page at a time. It does this by
calling a new procedure zswap_store_pages() with a range of
"pool->batch_size" indices in the folio.

zswap_store_pages() implements all the computes done earlier in
zswap_store_page() for a single-page, for multiple pages in a folio,
namely the "batch":

1) It starts by allocating all zswap entries required to store the
   batch. New procedures, zswap_entries_cache_alloc_batch() and
   zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
   to optimize the performance of this step.

2) Next, the entries fields are written, computes that need to be happen
   anyway, without modifying the zswap xarray/LRU publishing order. This
   improves latency by avoiding having the bring the entries into the
   cache for writing in different code blocks within this procedure.

3) Next, it calls zswap_compress() to sequentially compress each page in
   the batch.

4) Finally, it adds the batch's zswap entries to the xarray and LRU,
   charges zswap memory and increments zswap stats.

5) The error handling and cleanup required for all failure scenarios
   that can occur while storing a batch in zswap are consolidated to a
   single "store_pages_failed" label in zswap_store_pages(). Here again,
   we optimize performance by calling kmem_cache_free_bulk().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 218 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 149 insertions(+), 69 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 63a997b999537..8ca69c3f30df2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -879,6 +879,24 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
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
  * Carries out the common pattern of freeing and entry's zpool allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -1512,93 +1530,154 @@ static void shrink_worker(struct work_struct *w)
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
+			      int node_id)
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
+	 *    handle to determine whether zpool memory needs to be
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
+		if (!zswap_compress(page, entries[i], pool))
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
-	zpool_free(pool->zpool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < nr_pages; ++i) {
+		if (!IS_ERR_VALUE(entries[i]->handle))
+			zpool_free(pool->zpool, entries[i]->handle);
+	}
+	zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
+				       nr_pages - store_fail_idx);
+
 	return false;
 }
 
 bool zswap_store(struct folio *folio)
 {
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
@@ -1632,10 +1711,11 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
+	/* Store the folio in batches of @pool->batch_size pages. */
+	for (start = 0; start < nr_pages; start += pool->batch_size) {
+		end = min(start + pool->batch_size, nr_pages);
 
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_pages(folio, start, end, objcg, pool, node_id))
 			goto put_pool;
 	}
 
@@ -1665,9 +1745,9 @@ bool zswap_store(struct folio *folio)
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

