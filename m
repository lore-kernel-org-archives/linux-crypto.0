Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D21E225412;
	Thu,  6 Feb 2025 07:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826479; cv=none; b=Tat4mm/Pkvce9Bt+dPs77IotimZxM/Z3imExnM4tAyyu59I9ZY5kQs5y5DXem0EgEVbw4bcq3Ktxew0Pet5O+AFgpVnamYZS710rs0mbuS4uP4guGHKA1bwGWD0+gsjgLgvdqqPe6haPY5cUYux8cG7CxYy09X41WoBA0I7b6Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826479; c=relaxed/simple;
	bh=2J9gtcIwHxH1MpbEJssRtTtbQQgA3xu9INBQ54csBJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HZ15E8cVcUTuj+m2lbhxp572d/X+NzV4sjarFlAM1uniyzCjX3k6e7sSL0Jbl/th9tnHKJViaiJNcAc7WK/Izq3mctso2+cGxGkY0yeJcU011rsUsvpiS8Q1pzQBHcTHryYrN4B7iqnyYnRpfHp/cw+RQ0ddceTNMzwXkUe/Fgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O5eYAZik; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O5eYAZik"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826477; x=1770362477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2J9gtcIwHxH1MpbEJssRtTtbQQgA3xu9INBQ54csBJY=;
  b=O5eYAZikCExUuQIZ7OeVyni78s6TnfqRkbYcrSgtddlNE87g6pfskQUa
   vLLfxgj/CZPBmnwhKP96S160d/DJ+3KHlWBBjHn8MFhJ/D3AvV+4okfHs
   96aFEAtvHBBlT6/uDeBDIRc1Ww6m+2nyz3L06uJ36FUBYvB+HiQH+yoX5
   WamXgtHTDHpQj2Tcoq5XdA1n1/HEeuaphoT3+pyUMcGXduPVdCYO98VA1
   4Oc6wcsTbo4RHB7xmmLDOP1fkvi0+CHonjtlB5zUynIK3R2HNbee7O4yS
   5ixWbIpyZuMoFwM5vAo9ko7SBt9cw4GcmE7zjsyH76iybLXuVEitMGGEu
   g==;
X-CSE-ConnectionGUID: wiJ9mxGaRdWv1G2C18wmVQ==
X-CSE-MsgGUID: bdJ0sKziRMi7XKXLQL1xaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962756"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962756"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:06 -0800
X-CSE-ConnectionGUID: IlfEp/8QS12Kl4i9twxvoA==
X-CSE-MsgGUID: bYZGwRz4Rc256Qiw4cxcsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022652"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:06 -0800
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
Subject: [PATCH v6 16/16] mm: zswap: Fix for zstd performance regression with 2M folios.
Date: Wed,  5 Feb 2025 23:21:02 -0800
Message-Id: <20250206072102.29045-17-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the previous patch that enables support for batch compressions in
zswap_compress_folio(), a 6.2% throughput regression was seen with zstd and
2M folios, using vm-scalability/usemem.

For compressors that don't support batching, this was root-caused to the
following zswap_store_folio() structure:

 Batched stores:
 ---------------
 - Allocate all entries,
 - Compress all entries,
 - Store all entries in xarray/LRU.

Hence, the above structure is maintained only for batched stores, and the
following structure is implemented for sequential stores of large folio pages,
that fixes the zstd regression, while preserving common code paths for batched
and sequential stores of a folio:

 Sequential stores:
 ------------------
 For each page in folio:
  - allocate an entry,
  - compress the page,
  - store the entry in xarray/LRU.

This is submitted as a separate patch only for code review purposes. I will
squash this with the previous commit in subsequent versions of this
patch-series.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 193 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 111 insertions(+), 82 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f1cba77eda62..7bfc720a6201 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1592,40 +1592,32 @@ static bool zswap_batch_compress(struct folio *folio,
 	return ret;
 }
 
-static bool zswap_compress_folio(struct folio *folio,
-				 struct zswap_entry *entries[],
-				 struct zswap_pool *pool)
+static __always_inline bool zswap_compress_folio(struct folio *folio,
+						 struct zswap_entry *entries[],
+						 long from_index,
+						 struct zswap_pool *pool,
+						 unsigned int batch_size,
+						 struct crypto_acomp_ctx *acomp_ctx)
 {
-	long index, nr_pages = folio_nr_pages(folio);
-	struct crypto_acomp_ctx *acomp_ctx;
-	unsigned int batch_size;
+	long index = from_index, nr_pages = folio_nr_pages(folio);
 	bool ret = true;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
-	batch_size = acomp_ctx->nr_reqs;
-
 	if ((batch_size > 1) && (nr_pages > 1)) {
-		for (index = 0; index < nr_pages; index += batch_size) {
+		for (; index < nr_pages; index += batch_size) {
 
 			if (!zswap_batch_compress(folio, index, batch_size,
 						  &entries[index], pool, acomp_ctx)) {
 				ret = false;
-				goto unlock_acomp_ctx;
+				break;
 			}
 		}
 	} else {
-		for (index = 0; index < nr_pages; ++index) {
-			struct page *page = folio_page(folio, index);
+		struct page *page = folio_page(folio, index);
 
-			if (!zswap_compress(page, entries[index], pool, acomp_ctx)) {
-				ret = false;
-				goto unlock_acomp_ctx;
-			}
-		}
+		if (!zswap_compress(page, entries[index], pool, acomp_ctx))
+			ret = false;
 	}
 
-unlock_acomp_ctx:
-	acomp_ctx_put_unlock(acomp_ctx);
 	return ret;
 }
 
@@ -1637,92 +1629,128 @@ static bool zswap_compress_folio(struct folio *folio,
  * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
  * entry's handle is subsequently modified only upon a successful zpool_malloc()
  * after the page is compressed.
+ *
+ * For compressors that don't support batching, the following structure
+ * showed a performance regression with zstd/2M folios:
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
 
-	entries = kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);
+	entries = kmalloc(nr_folio_pages * sizeof(*entries), GFP_KERNEL);
 	if (!entries)
 		return false;
 
-	for (index = 0; index < nr_pages; ++index) {
-		entries[index] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	batch_size = acomp_ctx->nr_reqs;
 
-		if (!entries[index]) {
-			zswap_reject_kmemcache_fail++;
-			nr_pages = index;
-			goto store_folio_failed;
+	nr_pages = (batch_size > 1) ? nr_folio_pages : 1;
+
+	while (1) {
+		for (index = from_index; index < nr_pages; ++index) {
+			entries[index] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+
+			if (!entries[index]) {
+				zswap_reject_kmemcache_fail++;
+				nr_pages = index;
+				goto store_folio_failed;
+			}
+
+			entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
 		}
 
-		entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
-	}
+		if (!zswap_compress_folio(folio, entries, from_index, pool, batch_size, acomp_ctx))
+			goto store_folio_failed;
 
-	if (!zswap_compress_folio(folio, entries, pool))
-		goto store_folio_failed;
+		for (index = from_index; index < nr_pages; ++index) {
+			swp_entry_t page_swpentry = page_swap_entry(folio_page(folio, index));
+			struct zswap_entry *old, *entry = entries[index];
 
-	for (index = 0; index < nr_pages; ++index) {
-		swp_entry_t page_swpentry = page_swap_entry(folio_page(folio, index));
-		struct zswap_entry *old, *entry = entries[index];
+			old = xa_store(swap_zswap_tree(page_swpentry),
+				swp_offset(page_swpentry),
+				entry, GFP_KERNEL);
+			if (xa_is_err(old)) {
+				int err = xa_err(old);
 
-		old = xa_store(swap_zswap_tree(page_swpentry),
-			       swp_offset(page_swpentry),
-			       entry, GFP_KERNEL);
-		if (xa_is_err(old)) {
-			int err = xa_err(old);
+				WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+				zswap_reject_alloc_fail++;
+				from_index = index;
+				goto store_folio_failed;
+			}
 
-			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-			zswap_reject_alloc_fail++;
-			from_index = index;
-			goto store_folio_failed;
-		}
+			/*
+			 * We may have had an existing entry that became stale when
+			 * the folio was redirtied and now the new version is being
+			 * swapped out. Get rid of the old.
+			 */
+			if (old)
+				zswap_entry_free(old);
 
-		/*
-		 * We may have had an existing entry that became stale when
-		 * the folio was redirtied and now the new version is being
-		 * swapped out. Get rid of the old.
-		 */
-		if (old)
-			zswap_entry_free(old);
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
-		atomic_long_inc(&zswap_stored_pages);
 
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
-		}
+		from_index = nr_pages++;
+
+		if (nr_pages > nr_folio_pages)
+			break;
 	}
 
+	acomp_ctx_put_unlock(acomp_ctx);
 	kfree(entries);
 	return true;
 
@@ -1734,6 +1762,7 @@ static bool zswap_store_folio(struct folio *folio,
 		zswap_entry_cache_free(entries[index]);
 	}
 
+	acomp_ctx_put_unlock(acomp_ctx);
 	kfree(entries);
 	return false;
 }
-- 
2.27.0

