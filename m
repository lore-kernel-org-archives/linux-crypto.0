Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79E54B8273
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484137; cv=none; b=DFJXfCNzROYj60IZVjk7QR/GiIZLqnFGhA2ZanWRFCZmumLWq6qb9atgc5mLwGKmBg7qiVI+qSYzv8MgANiUsdGeBMUCsJgvrXpmKB41i2xB4X56L870n4UMysv+ADNYAk0V6XM6i8QLNQeUc8EQA9fQ/OmRRJvEs4a2J9jiOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484137; c=relaxed/simple;
	bh=Td3QiJoYJQ5byELNxCV1QM41yRxJkS4f0MlQFa3Q+PE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UAnURXXLsJZX9m8SFAHe6sjSofC8uatXC80HRPijAjH3vePWkRAx+qBoDe7STebJfeRwns7cPHCT8fGVwO4BWk/e5MdvDikNdEVEiFyG2ugWcQV4yhXompfEnbdNpr0/ILfvmOkV1fV1yzgdI2RqO8qSDi2uMi9KXWObndzFvyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkyEH7aG; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkyEH7aG"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1419d3416ceso10781493c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484117; x=1792088917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H8F1lWjV4954gJVzEPW44SYFrIQOOUNywVyJnvWveaQ=;
        b=YkyEH7aG4iGEoR9Mba2A4ufmg/o7ZUXASLOh/kEni9akdebj6f3lxJSNG00LlQ6ipS
         bCbOGwN2/m+dHhFHa8cXdgNuKDycNOeQoX5V9O5mj6unSZQVtw0bWSifDSX29lSHAxSf
         8TvN9CBy/1zRVBcJOuKqk1Izm9MYOWSSw0Id7xvZKHJ6/m3kBYHgjYFRQU/kCOo0M6vt
         a4Dez3INFJcwLMPIu2EE32+8uYxY09BmmO9QYn8ksizvpEdNR8RSjmhRZzRAXaUYOgYJ
         xBegdZJ8NUs6rIop8SLjYKLKw2xR9uKQXl7COzR3qc6TJRnb7dSiiDx3piqoF69odMX0
         vXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484117; x=1792088917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H8F1lWjV4954gJVzEPW44SYFrIQOOUNywVyJnvWveaQ=;
        b=N1Zfglf1ftqplQR1Iib2Z1sFiWJY6ovVwZ05IE5ZzIBQi8omtb/ZnxlSI4+vxFl71x
         lXK6cR/CxbRwAnF5MHVdTNviE0D7HlWld58eG34BZxxNU4SGPWz2n4EDUOf1cjxiRPyX
         LsQcnLIyT8V3em/nrvqTZTQZuImH+VWqpinX0FQVqUq+yGCqYjwdEI+W26KQ1L77OBoB
         X7Mq+AE1f1Uen7BQ0Zo+NmYr+GkhDdrk/86jy8lVbc8vU4qbQ65gvuqCUkA0hcrbpMvT
         phT0iwLtQD8VZTf2E1Vr/A4SOMGrHJ94safj+m5kJeFT1VUerxq2Y7gWPY0H0HTgp5TJ
         XJEw==
X-Forwarded-Encrypted: i=1; AKwUvBzoilmAX3PxnsqbZn7XiLafjMWAE12maRAbhjG+X/4o3uHzFcOvvo17xcCVTssJ/9UerVBjf3Z5neO9qUQ=@vger.kernel.org
X-Gm-Message-State: AFuF++ni/1G2yM1Lh70SUngagOP2uoNXmnhRg/4c0Sk8TWCAryaoikwc
	HWEVH2CSgFP0ft0YwKp9PLPtopGo29kRhcfznlr7KYZLjz4dj0Iay2Mi
X-Gm-Gg: AYBFou0n2HmOsN10+cVdNT2SLjkCCVWf0vqVboBaQZ1gK85ZRCRPb+bpx0Hu4HpZW1Q
	Q3Zz4rBwKJU0spTJLbKB+TpGGn9G5jWdJvcDlJIN8rGczPzJulDGc1pEI3bDLPV5E5pbpq1MC38
	wO/NeGTs2y0Wml6MGuKn2pdbS1YkaQUketIUyi4qR1zXSUnhe84MvMkdg88J/8EGUxzoOrxVhxf
	lp9nY5c/VEwtpORL63eXWMMChj3PnmNs0A1+WWsSSlzOKtAotdGbHe2EwZ9TWb+eHXUpZ3/aFaB
	532YR7qc7tjgKStY4n3l+Nq7fQC8aOyLODp5jzPra89qkjQohV7ZYaX1bBEpSBH9BA11QJ06N2w
	iEodAzcv7Y4uD/kSiHO/XxeafPQWUtoGrN9RqkFhnZ/oqA4hkNDurDEwdyjY2h9+3N1ymTEP5c3
	sd8gw7rptVkvvm+FDyFC/Q0FrtD8YTSsCcF1e0to/fKPXfCPjtcRRQAeP1jDpVyfmQHRbrqdKZg
	DezPMjTYLs=
X-Received: by 2002:a05:701b:454f:20b0:14d:baf5:c411 with SMTP id a92af1059eb24-1620374e31emr6990690c88.14.1791484116447;
        Thu, 08 Oct 2026 11:28:36 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:35 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 6/8] mm: zswap: Store large folios in batches.
Date: Thu,  8 Oct 2026 11:28:12 -0700
Message-Id: <20261008182814.27450-7-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use batching when storing large folios in zswap. If the underlying
compressor supports batching (e.g. hardware parallel compression),
allocate multiple compression buffers, otherwise allocate one. The
number of buffers is bounded by a new constant, ZSWAP_MAX_BATCH_SIZE, to
limit the memory overhead. For existing software compressors, the only
extra overhead is the extra 'buffers' pointer, so 8 bytes per-CPU on
x86_64. Only the first buffer is currently used.

Regardless of compression batching, always process large folios in
batches. For hardware compressors, the batch size is the compressor
batch size, otherwise ZSWAP_MAX_BATCH_SIZE is used.

zswap_store_page() is replaced with zswap_store_pages(), which processes
a batch of pages and allows for batching optimizations. For now, only
optimize allocating entries by using batch allocations from the slab
cache.

Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
page and only call it once for the folio, since the entire folio is
charged to a single memcg. Similarly, obtain the nid once to use during
each batch store of a folio.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 304 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 212 insertions(+), 92 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c2731d3acb2c..8ae67fd10522 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -84,6 +84,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -141,7 +144,7 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
+	u8 **buffers;
 	struct mutex mutex;
 };
 
@@ -150,10 +153,14 @@ struct crypto_acomp_ctx {
  * The only case where lru_lock is not acquired while holding tree.lock is
  * when a zswap_entry is taken off the lru for writeback, in that case it
  * needs to be verified that it's still valid in the tree.
+ *
+ * @compr_batch_size: The max batch size of the compression algorithm,
+ *                    bounded by ZSWAP_MAX_BATCH_SIZE.
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
+	u8 compr_batch_size;
 	struct percpu_ref ref;
 	struct rcu_work release_rwork;
 	struct hlist_node node;
@@ -269,8 +276,10 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
-static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (!acomp_ctx)
 		return;
 
@@ -293,8 +302,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->buffer);
-	acomp_ctx->buffer = NULL;
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
+	acomp_ctx->buffers = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -378,7 +391,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 cpuhp_add_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
+			       pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -416,7 +431,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
+			       pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -767,6 +783,41 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+static __always_inline void zswap_entries_cache_free_batch(
+	struct zswap_entry **entries,
+	u8 nr_entries)
+{
+	/*
+	 * It is okay to use this to free entries allocated separately
+	 * by zswap_entry_cache_alloc().
+	 */
+	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, (void **)entries);
+}
+
+static bool zswap_entries_cache_alloc_batch(
+	struct zswap_entry **entries,
+	u8 nr_entries,
+	gfp_t gfp,
+	int nid)
+{
+	if (unlikely(!kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					    nr_entries, (void **)entries))) {
+		u8 i;
+
+		for (i = 0; i < nr_entries; ++i) {
+			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, nid);
+
+			if (unlikely(!entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				zswap_entries_cache_free_batch(entries, i);
+				return false;
+			}
+		}
+	}
+
+	return true;
+}
+
 /*
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -797,7 +848,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -808,15 +861,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return 0;
 	}
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return ret;
-
 	/*
 	 * In case of an error, crypto_alloc_acomp_node() returns an
 	 * error pointer, never NULL.
 	 */
-	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, nid);
 	if (IS_ERR(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
 				pool->tfm_name, acomp_ctx->acomp);
@@ -824,6 +873,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	/* acomp_request_alloc() returns NULL in case of an error. */
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
 	if (!acomp_ctx->req) {
@@ -832,6 +888,17 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					  GFP_KERNEL, nid);
+	if (!acomp_ctx->buffers)
+		goto fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
+		if (!acomp_ctx->buffers[i])
+			goto fail;
+	}
+
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -852,12 +919,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
 fail:
-	acomp_ctx_free(acomp_ctx);
+	acomp_ctx_free(acomp_ctx, pool->compr_batch_size);
 	return ret;
 }
 
 static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool)
+			   struct zswap_entry *entry, struct zswap_pool *pool,
+			   bool wb_enabled)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -871,7 +939,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
@@ -901,13 +969,10 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
-			rcu_read_unlock();
+		if (!wb_enabled) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
-		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_folio(folio, index * PAGE_SIZE);
@@ -1440,91 +1505,122 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct folio *folio, long index,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct folio *folio,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      int nid,
+			      bool wb_enabled,
+			      struct obj_cgroup *objcg)
 {
-	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
-	struct zswap_entry *entry, *old;
-	int nid = folio_nid(folio);
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+	u8 i, store_fail_idx = 0, nr_pages = end - start;
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
-	}
+	VM_WARN_ON_ONCE(nr_pages <= 0 || nr_pages > ZSWAP_MAX_BATCH_SIZE);
 
-	if (!zswap_compress(folio, index, entry, pool))
-		goto compress_failed;
+	if (unlikely(!zswap_entries_cache_alloc_batch(entries, nr_pages,
+						      GFP_KERNEL, nid)))
+		return false;
 
 	/*
-	 * Set pool_idx before the xa_store() below publishes the entry, or a
-	 * concurrent reader could resolve a stale pool_idx left by slab reuse
-	 * to an unrelated live pool.
+	 * We co-locate entry initialization as much as possible here to
+	 * minimize potential cache misses.
 	 */
-	entry->pool_idx = pool->idx;
-	entry->nid = nid;
-
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+	for (i = 0; i < nr_pages; ++i) {
+		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		/*
+		 * Set pool_idx before the xa_store() below publishes the entry, or a
+		 * concurrent reader could resolve a stale pool_idx left by slab reuse
+		 * to an unrelated live pool.
+		 */
+		entries[i]->pool_idx = pool->idx;
+		entries[i]->swpentry = folio_swap_entry(folio, start + i);
+		entries[i]->objcg = objcg;
+		entries[i]->referenced = true;
+		entries[i]->nid = nid;
+		INIT_LIST_HEAD(&entries[i]->lru);
+	}
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+	for (i = 0; i < nr_pages; ++i) {
+		if (!zswap_compress(folio, start + i, entries[i], pool, wb_enabled))
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
+
+		old = xa_store(swap_zswap_tree(entry->swpentry),
+			       swp_offset(entry->swpentry),
+			       entry, GFP_KERNEL);
+		if (unlikely(xa_is_err(old))) {
+			int err = xa_err(old);
+
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
+		/*
+		 * We may have had an existing entry that became stale when
+		 * the folio was redirtied and now the new version is being
+		 * swapped out. Get rid of the old.
+		 */
+		if (unlikely(old))
+			zswap_entry_free(old);
 
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
-	entry->swpentry = page_swpentry;
-	entry->objcg = objcg;
-	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
+		/*
+		 * The entry is successfully compressed and stored in the tree,
+		 * and further failures will be cleaned up in zswap_store().
+		 * Grab refs to the pool and objcg, charge zswap memory, and
+		 * increment zswap_stored_pages. The opposite actions will be
+		 * performed by zswap_entry_free() when the entry is removed
+		 * from the tree.
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
+			zswap_lru_add(entry);
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
+	zswap_entries_cache_free_batch(&entries[store_fail_idx],
+				       nr_pages - store_fail_idx);
+
 	return false;
 }
 
@@ -1534,9 +1630,11 @@ bool zswap_store(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
+	bool wb_enabled, ret = false;
+	int nid = folio_nid(folio);
 	struct zswap_pool *pool;
-	bool ret = false;
-	long index;
+	u8 store_batch_size;
+	long start, end;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1570,8 +1668,30 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		if (!zswap_store_page(folio, index, objcg, pool))
+	rcu_read_lock();
+	wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
+	rcu_read_unlock();
+
+	/*
+	 * For batching compressors, store the folio in batches of the
+	 * compressor's batch_size.
+	 *
+	 * For non-batching compressors, store the folio in batches
+	 * of ZSWAP_MAX_BATCH_SIZE, where each page in the batch is
+	 * compressed sequentially. This gives better performance than
+	 * invoking zswap_store_pages() per-page, due to cache locality
+	 * of working set structures.
+	 */
+	store_batch_size = (pool->compr_batch_size > 1) ?
+			    pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
+
+	for (start = 0; start < nr_pages; start += store_batch_size) {
+		end = min(start + store_batch_size, nr_pages);
+
+		ret = zswap_store_pages(folio, start, end, pool,
+					nid, wb_enabled, objcg);
+
+		if (unlikely(!ret))
 			goto put_pool;
 	}
 
-- 
2.39.5

