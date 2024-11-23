Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA6818B464;
	Sat, 23 Nov 2024 07:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345299; cv=none; b=AL9ghPTh6X0tBDw6z96NxoMfrqVkDPCLbd0/jTEMPTwcAOs7bRFOJ4NAQERdBpUOksg4cquUJ5P8PDzlCNAI8D7TdNbnW6zs2/e12V3fnB+rUeMHVBmzUcXHd6f0NW+V37jKRIuDPBp8GQRpb+hXkzjuxA/33+NO9nOk5O5r22A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345299; c=relaxed/simple;
	bh=+3rqkJH/SwncCXsl5CpY/iFTNLwceujbB/a3ZiVVtHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hdBDqSHTCq9CeKFXfuL2wyhy6qgttd6phQzEk7tRDs//+EOR1gez5hjpQLsdPiW96OUTwZbZPlwtlgUcXIEv3MliSlYit6HO0lqDuqylnxLGb25SnuolXHSmiKONlQ1E3B1sm2G+QKMfizyGB9YcTDXMXXuPAfybpCIu9JbFdQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cNFUe3fk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cNFUe3fk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345297; x=1763881297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+3rqkJH/SwncCXsl5CpY/iFTNLwceujbB/a3ZiVVtHs=;
  b=cNFUe3fkgGyQadllm0TZEK+2bmcBth+G8vtb82OE9Usx32TSIafd44cV
   yXiYCeew1HfPE6prQkoW87IFfCrTSAUHfLLUtMar4iUX9rIKzm2b61/U2
   mRJtSn5YEC5HDLLLHXfE0Q70N0p5Kj6TCz7qhA2+AgZ/jConhrAXw5ZpU
   EPwzrQ7I3WEr3z8B5pFuEQaU2xEfdyCAawqa4wNVQNYQFU0HqT5jsK4Pa
   nbleUHsqr8/1PIjGY1mNNXpk9gXvl5lezisaJskTa42fXzDiOMTO2LI9a
   i9V4qoMfmBxv4oIBiBNLr8szGpQr8o5dNGyJD/vHi5ZUVFBlmKCV7E1NB
   Q==;
X-CSE-ConnectionGUID: EkUFTw7lQ1a7Y/TCZykkag==
X-CSE-MsgGUID: i4veEpqpTsyheSNSotMHZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435568"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435568"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:30 -0800
X-CSE-ConnectionGUID: qCe775yiSni/CxtTRPBmJQ==
X-CSE-MsgGUID: Aa7lpLhRRe+MyuU+gGClTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573574"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:29 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
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
Subject: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in zswap_batch_store() of large folios.
Date: Fri, 22 Nov 2024 23:01:27 -0800
Message-Id: <20241123070127.332773-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds two new zswap API:

 1) bool zswap_can_batch(void);
 2) void zswap_batch_store(struct folio_batch *batch, int *errors);

Higher level mm code, for instance, swap_writepage(), can query if the
current zswap pool supports batching, by calling zswap_can_batch(). If so
it can invoke zswap_batch_store() to swapout a large folio much more
efficiently to zswap, instead of calling zswap_store().

Hence, on systems with Intel IAA hardware compress/decompress accelerators,
swap_writepage() will invoke zswap_batch_store() for large folios.

zswap_batch_store() will call crypto_acomp_batch_compress() to compress up
to SWAP_CRYPTO_BATCH_SIZE (i.e. 8) pages in large folios in parallel using
the multiple compress engines available in IAA.

On platforms with multiple IAA devices per package, compress jobs from all
cores in a package will be distributed among all IAA devices in the package
by the iaa_crypto driver.

The newly added zswap_batch_store() follows the general structure of
zswap_store(). Some amount of restructuring and optimization is done to
minimize failure points for a batch, fail early and maximize the zswap
store pipeline occupancy with SWAP_CRYPTO_BATCH_SIZE pages, potentially
from multiple folios in future. This is intended to maximize reclaim
throughput with the IAA hardware parallel compressions.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/linux/zswap.h |  12 +
 mm/page_io.c          |  16 +-
 mm/zswap.c            | 639 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 666 insertions(+), 1 deletion(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 9ad27ab3d222..a05f59139a6e 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/pagevec.h>
 
 struct lruvec;
 
@@ -33,6 +34,8 @@ struct zswap_lruvec_state {
 
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
+bool zswap_can_batch(void);
+void zswap_batch_store(struct folio_batch *batch, int *errors);
 bool zswap_load(struct folio *folio);
 void zswap_invalidate(swp_entry_t swp);
 int zswap_swapon(int type, unsigned long nr_pages);
@@ -51,6 +54,15 @@ static inline bool zswap_store(struct folio *folio)
 	return false;
 }
 
+static inline bool zswap_can_batch(void)
+{
+	return false;
+}
+
+static inline void zswap_batch_store(struct folio_batch *batch, int *errors)
+{
+}
+
 static inline bool zswap_load(struct folio *folio)
 {
 	return false;
diff --git a/mm/page_io.c b/mm/page_io.c
index 4b4ea8e49cf6..271d3a40c0c1 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -276,7 +276,21 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		 */
 		swap_zeromap_folio_clear(folio);
 	}
-	if (zswap_store(folio)) {
+
+	if (folio_test_large(folio) && zswap_can_batch()) {
+		struct folio_batch batch;
+		int error = -1;
+
+		folio_batch_init(&batch);
+		folio_batch_add(&batch, folio);
+		zswap_batch_store(&batch, &error);
+
+		if (!error) {
+			count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
+			folio_unlock(folio);
+			return 0;
+		}
+	} else if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		folio_unlock(folio);
 		return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index 173f7632990e..53c8e39b778b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -229,6 +229,80 @@ static DEFINE_MUTEX(zswap_init_lock);
 /* init completed, but couldn't create the initial pool */
 static bool zswap_has_pool;
 
+/*
+ * struct zswap_batch_store_sub_batch:
+ *
+ * This represents a sub-batch of SWAP_CRYPTO_BATCH_SIZE pages during IAA
+ * compress batching of a folio or (conceptually, a reclaim batch of) folios.
+ * The new zswap_batch_store() API will break down the batch of folios being
+ * reclaimed into sub-batches of SWAP_CRYPTO_BATCH_SIZE pages, batch compress
+ * the pages by calling the iaa_crypto driver API crypto_acomp_batch_compress();
+ * and storing the sub-batch in zpool/xarray before updating objcg/vm/zswap
+ * stats.
+ *
+ * Although the page itself is represented directly, the structure adds a
+ * "u8 folio_id" to represent an index for the folio in a conceptual
+ * "reclaim batch of folios" that can be passed to zswap_store(). Conceptually,
+ * this allows for up to 256 folios that can be passed to zswap_store().
+ * Even though the folio_id seems redundant in the context of a single large
+ * folio being stored by zswap, it does simplify error handling and redundant
+ * computes/rewinding state, all of which can add latency. Since the
+ * zswap_batch_store() of a large folio can fail for any of these reasons --
+ * compress errors, zpool malloc errors, xarray store errors -- the procedures
+ * that detect these errors for a sub-batch, can all call a single cleanup
+ * procedure, zswap_batch_cleanup(), which will de-allocate zpool memory and
+ * zswap_entries for the sub-batch and set the "errors[folio_id]" to -EINVAL.
+ * All subsequent procedures that operate on a sub-batch will do nothing if the
+ * errors[folio_id] is non-0. Hence, the folio_id facilitates the use of the
+ * "errors" passed to zswap_batch_store() as a global folio error status for a
+ * single folio (which could also be a folio in the folio_batch).
+ *
+ * The sub-batch concept could be further evolved to use pipelining to
+ * overlap CPU computes with IAA computes. For instance, we could stage
+ * the post-compress computes for sub-batch "N-1" to happen in parallel with
+ * IAA batch compression of sub-batch "N".
+ *
+ * We begin by developing the concept of compress batching. Pipelining with
+ * overlap can be future work.
+ *
+ * @pages: The individual pages in the sub-batch. There are no assumptions
+ *         about all of them belonging to the same folio.
+ * @dsts: The destination buffers for batch compress of the sub-batch.
+ * @dlens: The destination length constraints, and eventual compressed lengths
+ *         of successful compressions.
+ * @comp_errors: The compress error status for each page in the sub-batch, set
+ *               by crypto_acomp_batch_compress().
+ * @folio_ids: The containing folio_id of each sub-batch page.
+ * @swpentries: The page_swap_entry() for each corresponding sub-batch page.
+ * @objcgs: The objcg for each corresponding sub-batch page.
+ * @entries: The zswap_entry for each corresponding sub-batch page.
+ * @nr_pages: Total number of pages in @sub_batch.
+ * @pool: A valid zswap_pool that can_batch.
+ *
+ * Note:
+ * The max sub-batch size is SWAP_CRYPTO_BATCH_SIZE, currently 8UL.
+ * Hence, if SWAP_CRYPTO_BATCH_SIZE exceeds 256, @nr_pages needs to become u16.
+ * The sub-batch representation is future-proofed to a small extent to be able
+ * to easily scale the zswap_batch_store() implementation to handle a conceptual
+ * "reclaim batch of folios"; without addding too much complexity, while
+ * benefiting from simpler error handling, localized sub-batch resources cleanup
+ * and avoiding expensive rewinding state. If this conceptual number of reclaim
+ * folios sent to zswap_batch_store() exceeds 256, @folio_ids needs to
+ * become u16.
+ */
+struct zswap_batch_store_sub_batch {
+	struct page *pages[SWAP_CRYPTO_BATCH_SIZE];
+	u8 *dsts[SWAP_CRYPTO_BATCH_SIZE];
+	unsigned int dlens[SWAP_CRYPTO_BATCH_SIZE];
+	int comp_errors[SWAP_CRYPTO_BATCH_SIZE]; /* folio error status. */
+	u8 folio_ids[SWAP_CRYPTO_BATCH_SIZE];
+	swp_entry_t swpentries[SWAP_CRYPTO_BATCH_SIZE];
+	struct obj_cgroup *objcgs[SWAP_CRYPTO_BATCH_SIZE];
+	struct zswap_entry *entries[SWAP_CRYPTO_BATCH_SIZE];
+	u8 nr_pages;
+	struct zswap_pool *pool;
+};
+
 /*********************************
 * helpers and fwd declarations
 **********************************/
@@ -1705,6 +1779,571 @@ void zswap_invalidate(swp_entry_t swp)
 		zswap_entry_free(entry);
 }
 
+/******************************************************
+ * zswap_batch_store() with compress batching.
+ ******************************************************/
+
+/*
+ * Note: If SWAP_CRYPTO_BATCH_SIZE exceeds 256, change the
+ * u8 stack variables in the next several functions, to u16.
+ */
+bool zswap_can_batch(void)
+{
+	struct zswap_pool *pool;
+	bool ret = false;
+
+	pool = zswap_pool_current_get();
+
+	if (!pool)
+		return ret;
+
+	if (pool->can_batch)
+		ret = true;
+
+	zswap_pool_put(pool);
+
+	return ret;
+}
+
+/*
+ * If the zswap store fails or zswap is disabled, we must invalidate
+ * the possibly stale entries which were previously stored at the
+ * offsets corresponding to each page of the folio. Otherwise,
+ * writeback could overwrite the new data in the swapfile.
+ */
+static void zswap_delete_stored_entries(struct folio *folio)
+{
+	swp_entry_t swp = folio->swap;
+	unsigned type = swp_type(swp);
+	pgoff_t offset = swp_offset(swp);
+	struct zswap_entry *entry;
+	struct xarray *tree;
+	long index;
+
+	for (index = 0; index < folio_nr_pages(folio); ++index) {
+		tree = swap_zswap_tree(swp_entry(type, offset + index));
+		entry = xa_erase(tree, offset + index);
+		if (entry)
+			zswap_entry_free(entry);
+	}
+}
+
+static __always_inline void zswap_batch_reset(struct zswap_batch_store_sub_batch *sb)
+{
+	sb->nr_pages = 0;
+}
+
+/*
+ * Upon encountering the first sub-batch page in a folio with an error due to
+ * any of the following:
+ *  - compression
+ *  - zpool malloc
+ *  - xarray store
+ * , cleanup the sub-batch resources (zpool memory, zswap_entry) for all other
+ * sub_batch elements belonging to the same folio, using the "error_folio_id".
+ *
+ * Set the "errors[error_folio_id] to signify to all downstream computes in
+ * zswap_batch_store(), that no further processing is required for the folio
+ * with "error_folio_id" in the batch: this folio's zswap store status will
+ * be considered an error, and existing zswap_entries in the xarray will be
+ * deleted before zswap_batch_store() exits.
+ */
+static void zswap_batch_cleanup(struct zswap_batch_store_sub_batch *sb,
+				int *errors,
+				u8 error_folio_id)
+{
+	u8 i;
+
+	if (errors[error_folio_id])
+		return;
+
+	for (i = 0; i < sb->nr_pages; ++i) {
+		if (sb->folio_ids[i] == error_folio_id) {
+			if (sb->entries[i]) {
+				if (!IS_ERR_VALUE(sb->entries[i]->handle))
+					zpool_free(sb->pool->zpool, sb->entries[i]->handle);
+
+				zswap_entry_cache_free(sb->entries[i]);
+				sb->entries[i] = NULL;
+			}
+		}
+	}
+
+	errors[error_folio_id] = -EINVAL;
+}
+
+/*
+ * Returns true if the entry was successfully
+ * stored in the xarray, and false otherwise.
+ */
+static bool zswap_store_entry(swp_entry_t page_swpentry, struct zswap_entry *entry)
+{
+	struct zswap_entry *old = xa_store(swap_zswap_tree(page_swpentry),
+					   swp_offset(page_swpentry),
+					   entry, GFP_KERNEL);
+	if (xa_is_err(old)) {
+		int err = xa_err(old);
+
+		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+		zswap_reject_alloc_fail++;
+		return false;
+	}
+
+	/*
+	 * We may have had an existing entry that became stale when
+	 * the folio was redirtied and now the new version is being
+	 * swapped out. Get rid of the old.
+	 */
+	if (old)
+		zswap_entry_free(old);
+
+	return true;
+}
+
+/*
+ * The stats accounting makes no assumptions about all pages in the sub-batch
+ * belonging to the same folio, or having the same objcg; while still doing
+ * the updates in aggregation.
+ */
+static void zswap_batch_xarray_stats(struct zswap_batch_store_sub_batch *sb,
+				     int *errors)
+{
+	int nr_objcg_pages = 0, nr_pages = 0;
+	struct obj_cgroup *objcg = NULL;
+	size_t compressed_bytes = 0;
+	u8 i;
+
+	for (i = 0; i < sb->nr_pages; ++i) {
+		if (errors[sb->folio_ids[i]])
+			continue;
+
+		if (!zswap_store_entry(sb->swpentries[i], sb->entries[i])) {
+			zswap_batch_cleanup(sb, errors, sb->folio_ids[i]);
+			continue;
+		}
+
+		/*
+		 * The entry is successfully compressed and stored in the tree,
+		 * there is no further possibility of failure. Grab refs to the
+		 * pool and objcg. These refs will be dropped by
+		 * zswap_entry_free() when the entry is removed from the tree.
+		 */
+		zswap_pool_get(sb->pool);
+		if (sb->objcgs[i])
+			obj_cgroup_get(sb->objcgs[i]);
+
+		/*
+		 * We finish initializing the entry while it's already in xarray.
+		 * This is safe because:
+		 *
+		 * 1. Concurrent stores and invalidations are excluded by folio
+		 *    lock.
+		 *
+		 * 2. Writeback is excluded by the entry not being on the LRU yet.
+		 *    The publishing order matters to prevent writeback from seeing
+		 *    an incoherent entry.
+		 */
+		sb->entries[i]->pool = sb->pool;
+		sb->entries[i]->swpentry = sb->swpentries[i];
+		sb->entries[i]->objcg = sb->objcgs[i];
+		sb->entries[i]->referenced = true;
+		if (sb->entries[i]->length) {
+			INIT_LIST_HEAD(&(sb->entries[i]->lru));
+			zswap_lru_add(&zswap_list_lru, sb->entries[i]);
+		}
+
+		if (!objcg && sb->objcgs[i]) {
+			objcg = sb->objcgs[i];
+		} else if (objcg && sb->objcgs[i] && (objcg != sb->objcgs[i])) {
+			obj_cgroup_charge_zswap(objcg, compressed_bytes);
+			count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages);
+			compressed_bytes = 0;
+			nr_objcg_pages = 0;
+			objcg = sb->objcgs[i];
+		}
+
+		if (sb->objcgs[i]) {
+			compressed_bytes += sb->entries[i]->length;
+			++nr_objcg_pages;
+		}
+
+		++nr_pages;
+	} /* for sub-batch pages. */
+
+	if (objcg) {
+		obj_cgroup_charge_zswap(objcg, compressed_bytes);
+		count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages);
+	}
+
+	atomic_long_add(nr_pages, &zswap_stored_pages);
+	count_vm_events(ZSWPOUT, nr_pages);
+}
+
+static void zswap_batch_zpool_store(struct zswap_batch_store_sub_batch *sb,
+				    int *errors)
+{
+	u8 i;
+
+	for (i = 0; i < sb->nr_pages; ++i) {
+		struct zpool *zpool;
+		unsigned long handle;
+		char *buf;
+		gfp_t gfp;
+		int err;
+
+		/* Skip pages belonging to folios that had compress errors. */
+		if (errors[sb->folio_ids[i]])
+			continue;
+
+		zpool = sb->pool->zpool;
+		gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
+		if (zpool_malloc_support_movable(zpool))
+			gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
+		err = zpool_malloc(zpool, sb->dlens[i], gfp, &handle);
+
+		if (err) {
+			if (err == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_alloc_fail++;
+
+			/*
+			 * A zpool malloc error should trigger cleanup for
+			 * other same-folio pages in the sub-batch, and zpool
+			 * resources/zswap_entries for those pages should be
+			 * de-allocated.
+			 */
+			zswap_batch_cleanup(sb, errors, sb->folio_ids[i]);
+			continue;
+		}
+
+		buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
+		memcpy(buf, sb->dsts[i], sb->dlens[i]);
+		zpool_unmap_handle(zpool, handle);
+
+		sb->entries[i]->handle = handle;
+		sb->entries[i]->length = sb->dlens[i];
+	}
+}
+
+static void zswap_batch_proc_comp_errors(struct zswap_batch_store_sub_batch *sb,
+					 int *errors)
+{
+	u8 i;
+
+	for (i = 0; i < sb->nr_pages; ++i) {
+		if (sb->comp_errors[i]) {
+			if (sb->comp_errors[i] == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+
+			if (!errors[sb->folio_ids[i]])
+				zswap_batch_cleanup(sb, errors, sb->folio_ids[i]);
+		}
+	}
+}
+
+/*
+ * Batch compress up to SWAP_CRYPTO_BATCH_SIZE pages with IAA.
+ * It is important to note that the SWAP_CRYPTO_BATCH_SIZE resources
+ * resources are allocated for the pool's per-cpu acomp_ctx during cpu
+ * hotplug only if the crypto_acomp has registered either
+ * batch_compress() and batch_decompress().
+ * The iaa_crypto driver registers implementations for both these API.
+ * Hence, if IAA is the zswap compressor, the call to
+ * crypto_acomp_batch_compress() will compress the pages in parallel,
+ * resulting in significant performance improvements as compared to
+ * software compressors.
+ */
+static void zswap_batch_compress(struct zswap_batch_store_sub_batch *sb,
+				 int *errors)
+{
+	struct crypto_acomp_ctx *acomp_ctx = raw_cpu_ptr(sb->pool->acomp_ctx);
+	u8 i;
+
+	mutex_lock(&acomp_ctx->mutex);
+
+	BUG_ON(acomp_ctx->nr_reqs != SWAP_CRYPTO_BATCH_SIZE);
+
+	for (i = 0; i < sb->nr_pages; ++i) {
+		sb->dsts[i] = acomp_ctx->buffers[i];
+		sb->dlens[i] = PAGE_SIZE;
+	}
+
+	/*
+	 * Batch compress sub-batch "N". If IAA is the compressor, the
+	 * hardware will compress multiple pages in parallel.
+	 */
+	crypto_acomp_batch_compress(
+		acomp_ctx->reqs,
+		&acomp_ctx->wait,
+		sb->pages,
+		sb->dsts,
+		sb->dlens,
+		sb->comp_errors,
+		sb->nr_pages);
+
+	/*
+	 * Scan the sub-batch for any compression errors,
+	 * and invalidate pages with errors, along with other
+	 * pages belonging to the same folio as the error page(s).
+	 * Set the folio's error status in "errors" so that no
+	 * further zswap_batch_store() processing is done for
+	 * the folio(s) with compression errors.
+	 */
+	zswap_batch_proc_comp_errors(sb, errors);
+
+	zswap_batch_zpool_store(sb, errors);
+
+	mutex_unlock(&acomp_ctx->mutex);
+}
+
+static void zswap_batch_add_pages(struct zswap_batch_store_sub_batch *sb,
+				  struct folio *folio,
+				  u8 folio_id,
+				  struct obj_cgroup *objcg,
+				  struct zswap_entry *entries[],
+				  long start_idx,
+				  u8 nr)
+{
+	long index;
+
+	for (index = start_idx; index < (start_idx + nr); ++index) {
+		u8 i = sb->nr_pages;
+		struct page *page = folio_page(folio, index);
+		sb->pages[i] = page;
+		sb->swpentries[i] = page_swap_entry(page);
+		sb->folio_ids[i] = folio_id;
+		sb->objcgs[i] = objcg;
+		sb->entries[i] = entries[index - start_idx];
+		sb->comp_errors[i] = 0;
+		++sb->nr_pages;
+	}
+}
+
+/* Allocate entries for the next sub-batch. */
+static int zswap_batch_alloc_entries(struct zswap_entry *entries[], int node_id, u8 nr)
+{
+	u8 i;
+
+	for (i = 0; i < nr; ++i) {
+		entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+		if (!entries[i]) {
+			u8 j;
+
+			zswap_reject_kmemcache_fail++;
+			for (j = 0; j < i; ++j)
+				zswap_entry_cache_free(entries[j]);
+			return -EINVAL;
+		}
+
+		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+	}
+
+	return 0;
+}
+
+static bool zswap_batch_comp_folio(struct folio *folio, int *errors, u8 folio_id,
+				   struct obj_cgroup *objcg,
+				   struct zswap_batch_store_sub_batch *sub_batch,
+				   bool last)
+{
+	long folio_start_idx = 0, nr_folio_pages = folio_nr_pages(folio);
+	struct zswap_entry *entries[SWAP_CRYPTO_BATCH_SIZE];
+	int node_id = folio_nid(folio);
+
+	/*
+	 * Iterate over the pages in the folio passed in. Construct compress
+	 * sub-batches of up to SWAP_CRYPTO_BATCH_SIZE pages. Process each
+	 * sub-batch with IAA batch compression. Detect errors from batch
+	 * compression and set the folio's error status.
+	 */
+	while (nr_folio_pages > 0) {
+		u8 add_nr_pages;
+
+		/*
+		 * If we have accumulated SWAP_CRYPTO_BATCH_SIZE
+		 * pages, process the sub-batch.
+		 */
+		if (sub_batch->nr_pages == SWAP_CRYPTO_BATCH_SIZE) {
+			zswap_batch_compress(sub_batch, errors);
+			zswap_batch_xarray_stats(sub_batch, errors);
+			zswap_batch_reset(sub_batch);
+			/*
+			 * Stop processing this folio if it had compress errors.
+			 */
+			if (errors[folio_id])
+				goto ret_folio;
+		}
+
+		/* Add pages from the folio to the compress sub-batch. */
+		add_nr_pages = min3((
+				(long)SWAP_CRYPTO_BATCH_SIZE -
+				(long)sub_batch->nr_pages),
+				nr_folio_pages,
+				(long)SWAP_CRYPTO_BATCH_SIZE);
+
+		/*
+		 * Allocate zswap entries for this sub-batch. If we get errors
+		 * while doing so, we can fail early and flag an error for the
+		 * folio.
+		 */
+		if (zswap_batch_alloc_entries(entries, node_id, add_nr_pages)) {
+			zswap_batch_reset(sub_batch);
+			errors[folio_id] = -EINVAL;
+			goto ret_folio;
+		}
+
+		zswap_batch_add_pages(sub_batch, folio,	folio_id, objcg,
+				      entries, folio_start_idx, add_nr_pages);
+
+		nr_folio_pages -= add_nr_pages;
+		folio_start_idx += add_nr_pages;
+	} /* this folio has pages to be compressed. */
+
+	/*
+	 * Process last sub-batch: it could contain pages from multiple folios.
+	 */
+	if (last && sub_batch->nr_pages) {
+		zswap_batch_compress(sub_batch, errors);
+		zswap_batch_xarray_stats(sub_batch, errors);
+	}
+
+ret_folio:
+	return (!errors[folio_id]);
+}
+
+/*
+ * Store a large folio and/or a batch of any-order folio(s) in zswap
+ * using IAA compress batching API.
+ *
+ * This the main procedure for batching within large folios and for batching
+ * of folios. Each large folio will be broken into sub-batches of
+ * SWAP_CRYPTO_BATCH_SIZE pages, the sub-batch pages will be compressed by
+ * IAA hardware compress engines in parallel, then stored in zpool/xarray.
+ *
+ * This procedure should only be called if zswap supports batching of stores.
+ * Otherwise, the sequential implementation for storing folios as in the
+ * current zswap_store() should be used. The code handles the unlikely event
+ * that the zswap pool changes from batching to non-batching between
+ * swap_writepage() and the start of zswap_batch_store().
+ *
+ * The signature of this procedure is meant to allow the calling function,
+ * (for instance, swap_writepage()) to pass a batch of folios @batch
+ * (the "reclaim batch") to be stored in zswap.
+ *
+ * @batch and @errors have folio_batch_count(@batch) number of entries,
+ * with one-one correspondence (@errors[i] represents the error status of
+ * @batch->folios[i], for i in folio_batch_count(@batch)). Please also
+ * see comments preceding "struct zswap_batch_store_sub_batch" definition
+ * above.
+ *
+ * The calling function (for instance, swap_writepage()) should initialize
+ * @errors[i] to a non-0 value.
+ * If zswap successfully stores @batch->folios[i], it will set @errors[i] to 0.
+ * If there is an error in zswap, it will set @errors[i] to -EINVAL.
+ *
+ * @batch: folio_batch of folios to be batch compressed.
+ * @errors: zswap_batch_store() error status for the folios in @batch.
+ */
+void zswap_batch_store(struct folio_batch *batch, int *errors)
+{
+	struct zswap_batch_store_sub_batch sub_batch;
+	struct zswap_pool *pool;
+	u8 i;
+
+	/*
+	 * If zswap is disabled, we must invalidate the possibly stale entry
+	 * which was previously stored at this offset. Otherwise, writeback
+	 * could overwrite the new data in the swapfile.
+	 */
+	if (!zswap_enabled)
+		goto check_old;
+
+	pool = zswap_pool_current_get();
+
+	if (!pool) {
+		if (zswap_check_limits())
+			queue_work(shrink_wq, &zswap_shrink_work);
+		goto check_old;
+	}
+
+	if (!pool->can_batch) {
+		for (i = 0; i < folio_batch_count(batch); ++i)
+			if (zswap_store(batch->folios[i]))
+				errors[i] = 0;
+			else
+				errors[i] = -EINVAL;
+		/*
+		 * Seems preferable to release the pool ref after the calls to
+		 * zswap_store(), so that the non-batching pool cannot be
+		 * deleted, can be used for sequential stores, and the zswap pool
+		 * cannot morph into a batching pool.
+		 */
+		zswap_pool_put(pool);
+		return;
+	}
+
+	zswap_batch_reset(&sub_batch);
+	sub_batch.pool = pool;
+
+	for (i = 0; i < folio_batch_count(batch); ++i) {
+		struct folio *folio = batch->folios[i];
+		struct obj_cgroup *objcg = NULL;
+		struct mem_cgroup *memcg = NULL;
+		bool ret;
+
+		VM_WARN_ON_ONCE(!folio_test_locked(folio));
+		VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
+
+		objcg = get_obj_cgroup_from_folio(folio);
+		if (objcg && !obj_cgroup_may_zswap(objcg)) {
+			memcg = get_mem_cgroup_from_objcg(objcg);
+			if (shrink_memcg(memcg)) {
+				mem_cgroup_put(memcg);
+				goto put_objcg;
+			}
+			mem_cgroup_put(memcg);
+		}
+
+		if (zswap_check_limits())
+			goto put_objcg;
+
+		if (objcg) {
+			memcg = get_mem_cgroup_from_objcg(objcg);
+			if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
+				mem_cgroup_put(memcg);
+				goto put_objcg;
+			}
+			mem_cgroup_put(memcg);
+		}
+
+		/*
+		 * By default, set zswap error status in "errors" to "success"
+		 * for use in swap_writepage() when this returns. In case of
+		 * errors encountered in any sub-batch in which this folio's
+		 * pages are batch-compressed, a negative error number will
+		 * over-write this when zswap_batch_cleanup() is called.
+		 */
+		errors[i] = 0;
+		ret = zswap_batch_comp_folio(folio, errors, i, objcg, &sub_batch,
+					     (i == folio_batch_count(batch) - 1));
+
+put_objcg:
+		obj_cgroup_put(objcg);
+		if (!ret && zswap_pool_reached_full)
+			queue_work(shrink_wq, &zswap_shrink_work);
+	} /* for batch folios */
+
+	zswap_pool_put(pool);
+
+check_old:
+	for (i = 0; i < folio_batch_count(batch); ++i)
+		if (errors[i])
+			zswap_delete_stored_entries(batch->folios[i]);
+}
+
 int zswap_swapon(int type, unsigned long nr_pages)
 {
 	struct xarray *trees, *tree;
-- 
2.27.0

