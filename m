Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618001F2384;
	Sat, 21 Dec 2024 06:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762691; cv=none; b=Ba6IaZvhCQal8sqOPv52/h0Fk9qoBBa/vuaUfEH8sK0n2ejimelwg2miGfb0gQZoAGMxufeuJK9pHPTjfIFk61lzKMoF3G5dNfnk8to8Q5F5yK7LRTzSL1v9NvmgJiz6r/TrmkoJ3HWw9lwa4YPaRSdOMQBczpjsNrG46ZeUwJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762691; c=relaxed/simple;
	bh=3T5mE0tmACfbWWCJAYrQoPctDfhArcrXCQeauBvfdDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TbeeVvQLqSP7KXJaxmVLetmMgSI/UGeEW/CtgygM2Cx2AUJGuImOD33+kYn3R1zzO41DcxVOej5HyNZsvOF7QMnrCFwnpbT1VkCewephj7oDR0L8bm4cdDgut2Y7yrStOZlQvA/E60GpD7fzzYRncYYj3OgmdZF3o5QAKpGv8AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D5qTbx52; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D5qTbx52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762689; x=1766298689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3T5mE0tmACfbWWCJAYrQoPctDfhArcrXCQeauBvfdDw=;
  b=D5qTbx52gHZ024DmSULvHWzbQGk66BxHS1dBSco2hGIHBkjON4F4k5iS
   IZFnE38aaHkZ5iFqJdSBGX9kHNyAZ7moF8j95lJGnUyR6ykrRjUywOay9
   37Lrg0+XdYI2upVmb6nEHCoHCsTYF4cyPk7uWJxloLdHQOSCHl6WhXHlE
   vJiIDv7om9Ax314y8KyOhmBfsq5Xtg7YE4SuN89gH5Bk17BrjOf0oe+Dm
   IpAd+GAR4lDXZPhYtcBtxSGP6bzaPOlJJYQQdesMNQyde3mNrBfb8MaA5
   r4pK7c2fNeQE/ptAUFl56oF6IpVV9+XRuZdD3X34Q44xhaMGxFSpUnkWC
   Q==;
X-CSE-ConnectionGUID: UMPZT9TuRrq486ug5ZJznQ==
X-CSE-MsgGUID: CAZJmblNTZ2ioOvkVcOhHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021731"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021731"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:21 -0800
X-CSE-ConnectionGUID: 8ICHdYlyQDKSYSh1fVmI1Q==
X-CSE-MsgGUID: AiI31hJNT9G273n9bOuR5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184610"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:21 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
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
Subject: [PATCH v5 11/12] mm: zswap: Restructure & simplify zswap_store() to make it amenable for batching.
Date: Fri, 20 Dec 2024 22:31:18 -0800
Message-Id: <20241221063119.29140-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces zswap_store_folio() that implements all the computes
done earlier in zswap_store_page() for a single-page, for all the pages in
a folio. This allows us to move the loop over the folio's pages from
zswap_store() to zswap_store_folio().

A distinct zswap_compress_folio() is also added, that simply calls
zswap_compress() for each page in the folio it is called with.

zswap_store_folio() starts by allocating all zswap entries required to
store the folio. Next, it calls zswap_compress_folio() and finally, adds
the entries to the xarray and LRU.

The error handling and cleanup required for all failure scenarios that can
occur while storing a folio in zswap is now consolidated to a
"store_folio_failed" label in zswap_store_folio().

These changes facilitate developing support for compress batching in
zswap_store_folio().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 183 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 116 insertions(+), 67 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 99cd78891fd0..1be0f1807bfc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1467,77 +1467,129 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static ssize_t zswap_store_page(struct page *page,
-				struct obj_cgroup *objcg,
-				struct zswap_pool *pool)
+static bool zswap_compress_folio(struct folio *folio,
+				 struct zswap_entry *entries[],
+				 struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
-	struct zswap_entry *entry, *old;
+	long index, nr_pages = folio_nr_pages(folio);
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return -EINVAL;
+	for (index = 0; index < nr_pages; ++index) {
+		struct page *page = folio_page(folio, index);
+
+		if (!zswap_compress(page, entries[index], pool))
+			return false;
 	}
 
-	if (!zswap_compress(page, entry, pool))
-		goto compress_failed;
+	return true;
+}
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+/*
+ * Store all pages in a folio.
+ *
+ * The error handling from all failure points is consolidated to the
+ * "store_folio_failed" label, based on the initialization of the zswap entries'
+ * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
+ * entry's handle is subsequently modified only upon a successful zpool_malloc()
+ * after the page is compressed.
+ */
+static ssize_t zswap_store_folio(struct folio *folio,
+				 struct obj_cgroup *objcg,
+				 struct zswap_pool *pool)
+{
+	long index, nr_pages = folio_nr_pages(folio);
+	struct zswap_entry **entries = NULL;
+	int node_id = folio_nid(folio);
+	size_t compressed_bytes = 0;
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+	entries = kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	/* allocate entries */
+	for (index = 0; index < nr_pages; ++index) {
+		entries[index] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+
+		if (!entries[index]) {
+			zswap_reject_kmemcache_fail++;
+			nr_pages = index;
+			goto store_folio_failed;
+		}
+
+		entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	if (!zswap_compress_folio(folio, entries, pool))
+		goto store_folio_failed;
 
-	/*
-	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg.
-	 * These refs will be dropped by zswap_entry_free() when the entry is
-	 * removed from the tree.
-	 */
-	zswap_pool_get(pool);
-	if (objcg)
-		obj_cgroup_get(objcg);
+	for (index = 0; index < nr_pages; ++index) {
+		swp_entry_t page_swpentry = page_swap_entry(folio_page(folio, index));
+		struct zswap_entry *old, *entry = entries[index];
+
+		old = xa_store(swap_zswap_tree(page_swpentry),
+			       swp_offset(page_swpentry),
+			       entry, GFP_KERNEL);
+		if (xa_is_err(old)) {
+			int err = xa_err(old);
+
+			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+			zswap_reject_alloc_fail++;
+			goto store_folio_failed;
+		}
 
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
+		/*
+		 * We may have had an existing entry that became stale when
+		 * the folio was redirtied and now the new version is being
+		 * swapped out. Get rid of the old.
+		 */
+		if (old)
+			zswap_entry_free(old);
+
+		/*
+		 * The entry is successfully compressed and stored in the tree, there is
+		 * no further possibility of failure. Grab refs to the pool and objcg.
+		 * These refs will be dropped by zswap_entry_free() when the entry is
+		 * removed from the tree.
+		 */
+		zswap_pool_get(pool);
+		if (objcg)
+			obj_cgroup_get(objcg);
+
+		/*
+		 * We finish initializing the entry while it's already in xarray.
+		 * This is safe because:
+		 *
+		 * 1. Concurrent stores and invalidations are excluded by folio lock.
+		 *
+		 * 2. Writeback is excluded by the entry not being on the LRU yet.
+		 *    The publishing order matters to prevent writeback from seeing
+		 *    an incoherent entry.
+		 */
+		entry->pool = pool;
+		entry->swpentry = page_swpentry;
+		entry->objcg = objcg;
+		entry->referenced = true;
+		if (entry->length) {
+			INIT_LIST_HEAD(&entry->lru);
+			zswap_lru_add(&zswap_list_lru, entry);
+		}
+
+		compressed_bytes += entry->length;
 	}
 
-	return entry->length;
+	kfree(entries);
+
+	return compressed_bytes;
+
+store_folio_failed:
+	for (index = 0; index < nr_pages; ++index) {
+		if (!IS_ERR_VALUE(entries[index]->handle))
+			zpool_free(pool->zpool, entries[index]->handle);
+
+		zswap_entry_cache_free(entries[index]);
+	}
+
+	kfree(entries);
 
-store_failed:
-	zpool_free(pool->zpool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
 	return -EINVAL;
 }
 
@@ -1549,8 +1601,8 @@ bool zswap_store(struct folio *folio)
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	size_t compressed_bytes = 0;
+	ssize_t bytes;
 	bool ret = false;
-	long index;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1584,15 +1636,11 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-		ssize_t bytes;
+	bytes = zswap_store_folio(folio, objcg, pool);
+	if (bytes < 0)
+		goto put_pool;
 
-		bytes = zswap_store_page(page, objcg, pool);
-		if (bytes < 0)
-			goto put_pool;
-		compressed_bytes += bytes;
-	}
+	compressed_bytes = bytes;
 
 	if (objcg) {
 		obj_cgroup_charge_zswap(objcg, compressed_bytes);
@@ -1622,6 +1670,7 @@ bool zswap_store(struct folio *folio)
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
 		struct xarray *tree;
+		long index;
 
 		for (index = 0; index < nr_pages; ++index) {
 			tree = swap_zswap_tree(swp_entry(type, offset + index));
-- 
2.27.0

