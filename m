Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E0F25DD09;
	Fri, 28 Feb 2025 10:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736842; cv=none; b=OTuYbNuLMo84Rp/VvtKnH0PE/r2U0IyJdU4Bniq5A0yG7smqa2/zCACWnezyLnLFWqfvkT01Sm+NXxVYbB5buloRqef++FcwouFMnuZ+ECy2jY8t1eOUPRQsY9Marz93OgyhEAvKs7XnSxAh0EG+AtqqI6OzfPV18qY/D0wlGp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736842; c=relaxed/simple;
	bh=r6PEYgxq6/N6uxBAD+xcepNUnGuvoW5pJWNnSNPI1s4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JApudlcR2Yapa3W+4xfqq2yuDyCGfwrplyJSMTXRrAYD4urcmUPlejbmp9JFb2mwYbEY3lQhdJqhSGit0XE5BXNpVO7vYyxYhlcL8/nbuWtbC/C7C92oAbqVFShQ49bmTFckgdzjMzg5Ag3joMeijjZaZ4udeAuyjoGmCXAjiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DmVw/xV1; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DmVw/xV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736840; x=1772272840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r6PEYgxq6/N6uxBAD+xcepNUnGuvoW5pJWNnSNPI1s4=;
  b=DmVw/xV1Vtcs8dVgSxoUFaiQEQdP5O9tXzvSzhe7smZVYoIlO5ITOrbE
   f3oKslwwQGv9rFOjp0IUD+NpEXdpk9DXOuHUBdWmUF7Wox7x+x34q+SLx
   /oILnrrJkcZZSRPqHdgU2ZpFidWf2WjQxRcQiaeRrFc9yECM8U3BZQw6H
   Xyq5T1/Nyv1Ywr227Es6xjlS/M9AbQsOXxy/cngLMgC5lfmVVbCJ9tohD
   D0v4AXvUDPlaIBo+f6IBlaUI9yYoOS817blIDljLoRx0twSlDjifJGmda
   /KZtoyHsQffcn5UhRcmsErEyy0lhvaRWXLdOS0dwuOmScyYNiU7AAp3yM
   g==;
X-CSE-ConnectionGUID: OkFdMWBlTsyhhDKMPSL3wQ==
X-CSE-MsgGUID: PCI5NR04QleS/T7u0fLQww==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902736"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902736"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:29 -0800
X-CSE-ConnectionGUID: qKe0qnEyQwu6amG26g9mBA==
X-CSE-MsgGUID: mm6IdXK6SA27wiKDPmIP8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325757"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:29 -0800
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
Subject: [PATCH v7 14/15] mm: zswap: Restructure & simplify zswap_store() to make it amenable for batching.
Date: Fri, 28 Feb 2025 02:00:23 -0800
Message-Id: <20250228100024.332528-15-kanchana.p.sridhar@intel.com>
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

This patch introduces zswap_store_folio() that implements all the computes
done earlier in zswap_store_page() for a single-page, for all the pages in
a folio. This allows us to move the loop over the folio's pages from
zswap_store() to zswap_store_folio().

zswap_store_folio() starts by allocating all zswap entries required to
store the folio. Next, it iterates over the folio's pages, and for each
page, it calls zswap_compress(), adds the zswap entry to the xarray and
LRU, charges zswap memory and increments zswap stats.

The error handling and cleanup required for all failure scenarios that can
occur while storing a folio in zswap are now consolidated to a
"store_folio_failed" label in zswap_store_folio().

These changes facilitate developing support for compress batching in
zswap_store_folio().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 166 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 98 insertions(+), 68 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 6aa602b8514e..ab9167220cb6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1580,81 +1580,115 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store all pages in a folio.
+ *
+ * The error handling from all failure points is consolidated to the
+ * "store_folio_failed" label, based on the initialization of the zswap entries'
+ * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
+ * entry's handle is subsequently modified only upon a successful zpool_malloc()
+ * after the page is compressed.
+ */
+static bool zswap_store_folio(struct folio *folio,
+			      struct obj_cgroup *objcg,
+			      struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
-	struct zswap_entry *entry, *old;
+	long index, from_index = 0, nr_pages = folio_nr_pages(folio);
+	struct zswap_entry **entries = NULL;
+	int node_id = folio_nid(folio);
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
+	entries = kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);
+	if (!entries)
 		return false;
-	}
 
-	if (!zswap_compress(page, entry, pool))
-		goto compress_failed;
+	for (index = from_index; index < nr_pages; ++index) {
+		entries[index] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+		if (!entries[index]) {
+			zswap_reject_kmemcache_fail++;
+			nr_pages = index;
+			goto store_folio_failed;
+		}
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+		entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (index = from_index; index < nr_pages; ++index) {
+		struct page *page = folio_page(folio, index);
+		swp_entry_t page_swpentry = page_swap_entry(page);
+		struct zswap_entry *old, *entry = entries[index];
 
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
+		if (!zswap_compress(page, entry, pool)) {
+			from_index = index;
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
+		old = xa_store(swap_zswap_tree(page_swpentry),
+			       swp_offset(page_swpentry),
+			       entry, GFP_KERNEL);
+		if (xa_is_err(old)) {
+			int err = xa_err(old);
+
+			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+			zswap_reject_alloc_fail++;
+			from_index = index;
+			goto store_folio_failed;
+		}
+
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
 	}
 
+	kfree(entries);
 	return true;
 
-store_failed:
-	zpool_free(pool->zpool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_folio_failed:
+	for (index = from_index; index < nr_pages; ++index) {
+		if (!IS_ERR_VALUE(entries[index]->handle))
+			zpool_free(pool->zpool, entries[index]->handle);
+
+		zswap_entry_cache_free(entries[index]);
+	}
+
+	kfree(entries);
 	return false;
 }
 
@@ -1666,7 +1700,6 @@ bool zswap_store(struct folio *folio)
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	bool ret = false;
-	long index;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1700,12 +1733,8 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-
-		if (!zswap_store_page(page, objcg, pool))
-			goto put_pool;
-	}
+	if (!zswap_store_folio(folio, objcg, pool))
+		goto put_pool;
 
 	if (objcg)
 		count_objcg_events(objcg, ZSWPOUT, nr_pages);
@@ -1732,6 +1761,7 @@ bool zswap_store(struct folio *folio)
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
 		struct xarray *tree;
+		long index;
 
 		for (index = 0; index < nr_pages; ++index) {
 			tree = swap_zswap_tree(swp_entry(type, offset + index));
-- 
2.27.0

