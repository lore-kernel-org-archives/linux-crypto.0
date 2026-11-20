Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148369;
	b=EKLM7dgzAwWPl+BJoheTjXo83q+lcXyMaoCDmIffJyvYs8oekwNzVoDD4LIo41ZJbs4J
	 9q2jH3PjoP6VETVZxqnOtyXkBZAgYWtb0KQfF2Aoa2HsuM7rDst5IiWkjDHVZy4WSRKPW
	 99rc57NcXThFgpeICmKPrfzkaXUfKdETRs/Ch6Ea5VNMbip7qkJHxepyhuicIbSgxfsuN
	 S58IBUu7gfYv2wcjwtCZqmj1mGgiEApLm+7AmgZ9/pkuN94l5t4nTAjxUO7YvB8HpqwGN
	 RjI1UD+B0b31Qk/QvY7eytkmh4YTqmjeBZfBvAPRQlEvc6ywDYHzK/t9mKJ2FnmwgpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148369;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jDv05nkOneIbU+C75C/3/SwzM7ssV+xwiPDI9idFT20=;
	b=4VGQ1CqL3W1mn8b51qecFLUY2jz+mVwl1iuylmExyK459Mykam0qTlXodP+TapEKN66i
	 gRnNl3e8KdlpQd8HVz5vjz05CCJ8KzDy+VHGYkVhRwdAGgbsB1BcOIiAnFZQ9QoYC+FAt
	 WzBbz+ToMzkw4Fnkg3QlbMvIDFg/+WckM5Ra/KSgCN+nbTyc5hajptitQX/OFiYoqH6j4
	 ex9DTxrbXICU2VHT3LEIOq7t5mi7x4IQLOZoPe42bv7bxPgJXkPIb8P4J0htJAOiJzDC5
	 Qv/BC1SocfivTP/1T8efJYmFQi7rt9eANigAqP8Ng8KDhviMUHM3hGHmp99/Zmv2zfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQkr8bp3;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFB560A383D
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEFB560A383D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQkr8bp3
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b3ada81853so542639c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148368; x=1795753168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jDv05nkOneIbU+C75C/3/SwzM7ssV+xwiPDI9idFT20=;
        b=qQkr8bp3yzlgJ1HIYJVmFQ+67Zow4VnfASx3hDN8j3TFOl+FbnqzeTb9A6fRUPDGOx
         axdSf7Ey25d6qSkNT+1v2dd/FgAYBfw4fIragcmnClbZwmXLcONfTBJfFfp+mLR/pd4s
         2S6AlhVSFEozwr4mQXulwfwQhDtMaTkwIfoeHWS/HJgYG+Mcj1u7uyC6xPj9vbJWx9Zo
         WnR5BfdFQkKMHGaPk9iwc6hcjNH1xR03dyQM2mMdZUINoigeoifUyums8cLU1GHJMIZu
         SjXRUhdQ6l+dfvrVCd8KPleFhQTPsIxst1aQ19IOcKLpJZMtTXRpSjXY9JpLiDRyQFeo
         ViBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148368; x=1795753168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jDv05nkOneIbU+C75C/3/SwzM7ssV+xwiPDI9idFT20=;
        b=Ta8R42TQSj971quLsleWYo/w54T9R5b6mWEEmrNMq2uomYx1fp8wwkPgDip+TsvgEH
         yMvRxcJMq5BJ0jerdCpTLH2pNnxkMv69QETSqzISJi8kPl9pz097uv3Csrf4arbILA4U
         JrqUD+L1/NBGB02aT3a2yzkf3x+C1aLPPZ7QGQNSyXVGMfqselCtS5dfBD1z9WGU4CsP
         0neA+vSW6YueUoadlWWTTCEWNF+FWzYTtGrm29r7YW89parh/5dUQx7gCjuEe8pX+yrp
         JWlDZ+nZYXGCqzLLB1OZyg1WSC3hs+dNemwHx1kVfBt6za860ADZ8ZwmaF3v0XXaPlUj
         6LTQ==
X-Forwarded-Encrypted: i=1; AL+hErFw7kuvu6whwZ19GEVPzlIfv7ViI7x0wyb/Z72CyjxrAuCICjdTlj8NH/5OkAqV5csckFQnZfKf+V5gp9A=@vger.kernel.org
X-Gm-Message-State: APuU4Z+PnDy+gt6tKyAuuWJJwuoVdI9d+dJ1laBUw9NwHuiQtrCLbqgl
	B8LrQhKyXWzu/2UX5tX8i9PDLKU+dlKIwqxu4kpIiEpJ7qCiajXiiy99
X-Gm-Gg: AYBFou1JTwK8mWfsALKBWFx378+RIPuX9sc7LM3viXm0p8c8ghzBFKyy7O2GkhpQjXi
	HmrPgpkBCdKDnY3uSAVHE92yhySxbLwxvsjnlm993DwxZgSOovS9oTbJKEctf1D+nzERCwHPKC7
	lLFP7BrWNdeFm1N+0c9alFaHc6o+JfrvM/k4YQFPcelkZCA7AoJ5t3OHetAUszp+tdY+jU48KE0
	i1g5CoApNyyJI5wBXiW2kIRxj6RebrnvgE0c+4jrzSdOaHkdz5KDAbWij3Zpzp453RrPo3cDiFE
	TLTtIpzkBpfV2kwpU6EqW8ZViR6qdJiFsWnfphDWO7S+WDA6o6Jft8WEPjfvVvEP1CkQS5eY7C2
	b/rrfsgYG+TqDJQ20ejE7iVLXoUt3DZmVCeUJfYwou7hQEDY5OChLB+tJz0f6USZgNpoxORy1tb
	34NFS8CM9SO1uRrSU6VahfWirqWjrFjKBaLc4AhRL/aA3hZIyT5X5zmiZQEzHefpY0nGmWutRDL
	RpFspP4NpRHrs9kcUa4VNSNDw+i3KmlJ4HNQ++LJEkHwzSTMkyHMOq49jROhOECGNholxgYGJxz
	rds6vlGnBb/6dbfuDE6Ax11fiHzx5N/oEwXy3Mdp9Q==
X-Received: by 2002:a05:7022:3a8b:b0:15a:4155:3d9d with SMTP id a92af1059eb24-1b5568d6db3mr1940114c88.31.1795148367700;
        Thu, 19 Nov 2026 20:19:27 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:26 -0800 (PST)
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
Subject: [PATCH v4 7/8] mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
Date: Thu, 19 Nov 2026 20:19:05 -0800
Message-Id: <20261120041906.5785-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The various stages of zswap_store_pages() are broken down into routines
that work on a batch of data when a large folio is being processed:

 zswap_init_entries()
 zswap_tree_stores()

The struct zswap_store_context is used to pass constraints and data
among these batching components. The resulting code is highly simplified
and maintainable, where each of the batching sub-routines of
zswap_store() can be optimized modularly.

For instance, the zswap_tree_stores() now does the zswap atomics
counter increments, getting pool references, getting objcg references
and objcg zswap charging at the batch level. A new
obj_cgroup_charge_zswap_many() is added to enable batch charging of
compressed bytes for multiple pages/incompressible pages in the batch,
in order to accurately update the MEMCG_ZSWAP* counters.

The next commit will implement batching of zswap_compress().

Subsequent patch series will be submitted, that implement ideas building
upon this batching framework:

 1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
    for a finite # of compressed size bins. This enables bulk allocation
    of compressed buffers in a batch that belong to the same size
    bin. It gets rid of significant zsmalloc latency overhead (locks,
    compressed data spanning zspages, etc.), without compromising memory
    efficiency.

 2) vmscan reclaim batching of hybrid any-order folios, that will submit
    a batch of folios to zswap_store()'s batching framework to optimize
    storing of batches of pages from different folios, in addition to
    within large folios.

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/linux/memcontrol.h |  12 +++
 mm/memcontrol.c            |  23 ++++-
 mm/zswap.c                 | 181 +++++++++++++++++++++++++------------
 3 files changed, 153 insertions(+), 63 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..93f060818c14 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1244,6 +1244,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
 	return NULL;
 }
 
+static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
+				       unsigned long nr)
+{
+}
+
 static inline void obj_cgroup_get(struct obj_cgroup *objcg)
 {
 }
@@ -1921,6 +1926,8 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
@@ -1932,6 +1939,11 @@ static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
 }
+static inline void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg,
+						size_t size, u8 nr_pages,
+						u8 nr_incomp_pages)
+{
+}
 static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..2236f5ba6304 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6345,6 +6345,23 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
  * compression and storage in zswap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
+{
+	obj_cgroup_charge_zswap_many(objcg, size, 1, (u8)(size == PAGE_SIZE));
+}
+
+/**
+ * obj_cgroup_charge_zswap_many - bulk charge compression backend memory
+ *                                from compressing a batch of pages.
+ * @objcg: the object cgroup
+ * @size: total compressed length of a batch of compressed objects
+ * @nr_pages: # of pages that were compressed to store in zswap
+ * @nr_incomp_pages: # of incompressible pages to store in zswap
+ *
+ * This forces the charge after obj_cgroup_may_zswap() allowed
+ * compression and storage in zswap for this cgroup to go ahead.
+ */
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages)
 {
 	struct mem_cgroup *memcg;
 
@@ -6363,9 +6380,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
-	if (size == PAGE_SIZE)
-		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
+	if (nr_incomp_pages)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
 	rcu_read_unlock();
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index df59ab0c1029..5e1fb5624ffb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -491,12 +491,12 @@ static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 }
 
 /* The caller must already have a reference. */
-static void zswap_pool_get(struct zswap_pool *pool)
+static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
 {
-	percpu_ref_get(&pool->ref);
+	percpu_ref_get_many(&pool->ref, nr);
 }
 
-static void zswap_pool_put(struct zswap_pool *pool)
+static inline void zswap_pool_put(struct zswap_pool *pool)
 {
 	percpu_ref_put(&pool->ref);
 }
@@ -1603,55 +1603,60 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
+/* Functions called by zswap_store(), that operate on batches of pages. */
+
 /*
- * Store multiple pages in @zc->folio, starting from the page at index @start up
- * to the page at index @end-1.
+ * zswap_init_entries() co-locates most of the zswap entry fields' setup under
+ * the assumption that all phases of store processing will succeed. An important
+ * marker to simplify catch-all cleanup in zswap_store_pages() is done by
+ * initializing each entry's @handle to ERR_PTR(-EINVAL).
  */
-static bool zswap_store_pages(struct zswap_store_context *zc,
-			      long start,
-			      long end,
-			      struct zswap_pool *pool,
-			      struct obj_cgroup *objcg)
+static inline void zswap_init_entries(struct zswap_store_context *zc,
+				      struct zswap_pool *pool,
+				      struct obj_cgroup *objcg)
 {
-	u8 i, store_fail_idx = 0;
-	bool ret;
-
-	zc->nr_pages = end - start;
-	zc->folio_start = start;
-
-	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
-
-	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
-	if (unlikely(!ret))
-		return false;
+	struct zswap_entry *entry;
+	u8 i;
 
 	/*
 	 * We co-locate entry initialization as much as possible here to
 	 * minimize potential cache misses.
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
+		entry = zc->entries[i];
 		/*
-		 * Set pool_idx before the xa_store() below publishes the entry, or a
-		 * concurrent reader could resolve a stale pool_idx left by slab reuse
-		 * to an unrelated live pool.
+		 * Set pool_idx before the xa_store() in zswap_tree_stores()
+		 * publishes the entry, or a concurrent reader could resolve a
+		 * stale pool_idx left by slab reuse to an unrelated live pool.
 		 */
-		zc->entries[i]->pool_idx = pool->idx;
-		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
+		entry->pool_idx = pool->idx;
+		entry->swpentry = folio_swap_entry(zc->folio,
 							zc->folio_start + i);
-		zc->entries[i]->objcg = objcg;
-		zc->entries[i]->referenced = true;
-		zc->entries[i]->nid = zc->nid;
-		INIT_LIST_HEAD(&zc->entries[i]->lru);
+		entry->objcg = objcg;
+		entry->referenced = true;
+		entry->nid = zc->nid;
+		INIT_LIST_HEAD(&entry->lru);
 	}
+}
 
-	for (i = 0; i < zc->nr_pages; ++i) {
-		if (!zswap_compress(zc->folio, zc->folio_start + i,
-				    zc->entries[i], pool, zc->wb_enabled))
-			goto store_pages_failed;
-	}
+/*
+ * zswap_tree_stores() stores the batch entries in xarray and adds them to the
+ * zswap LRU list. If an error occurs during xa_store(), localized state
+ * unwinding is done to erase prior batch entries from the xarray and delete
+ * them from the zswap LRU list. Remaining batch cleanup occurs in
+ * zswap_store_pages(). As batch entries are processed, we maintain aggregate
+ * statistics to do the accounting in one bulk operation.
+ */
+static bool zswap_tree_stores(struct zswap_store_context *zc,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	u8 i, store_fail_idx = 0, nr_incomp = 0;
+	size_t total_batch_comp_length = 0;
+	struct zswap_entry *old, *entry;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
-		struct zswap_entry *old, *entry = zc->entries[i];
+		entry = zc->entries[i];
 
 		old = xa_store(swap_zswap_tree(entry->swpentry),
 			       swp_offset(entry->swpentry),
@@ -1663,13 +1668,11 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_reject_alloc_fail++;
 			/*
 			 * Entries up to this point have been stored in the
-			 * xarray. zswap_store() will erase them from the xarray
-			 * and call zswap_entry_free(). Local cleanup in
-			 * 'store_pages_failed' only needs to happen for
-			 * entries from [@i to @nr_pages).
+			 * xarray. Local cleanup in 'tree_store_failed' needs to
+			 * erase entries up until now.
 			 */
 			store_fail_idx = i;
-			goto store_pages_failed;
+			goto tree_store_failed;
 		}
 
 		/*
@@ -1680,22 +1683,10 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		if (unlikely(old))
 			zswap_entry_free(old);
 
-		/*
-		 * The entry is successfully compressed and stored in the tree,
-		 * and further failures will be cleaned up in zswap_store().
-		 * Grab refs to the pool and objcg, charge zswap memory, and
-		 * increment zswap_stored_pages. The opposite actions will be
-		 * performed by zswap_entry_free() when the entry is removed
-		 * from the tree.
-		 */
-		zswap_pool_get(pool);
-		if (objcg) {
-			obj_cgroup_get(objcg);
-			obj_cgroup_charge_zswap(objcg, entry->length);
-		}
-		atomic_long_inc(&zswap_stored_pages);
+		total_batch_comp_length += entry->length;
+
 		if (unlikely(entry->length == PAGE_SIZE))
-			atomic_long_inc(&zswap_stored_incompressible_pages);
+			++nr_incomp;
 
 		/*
 		 * We finish by adding the entry to the LRU while it's already
@@ -1711,17 +1702,87 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_lru_add(entry);
 	}
 
+	/*
+	 * Each batch entry is successfully compressed and stored in the tree,
+	 * and further failures will be cleaned up in zswap_store().
+	 * Next, we do bulk accounting for the batch: grab refs to the pool and
+	 * objcg, charge zswap memory, increment zswap_stored_pages and
+	 * zswap_stored_incompressible_pages. The opposite actions will be
+	 * performed by zswap_entry_free() when the entry is removed from the
+	 * tree.
+	 */
+	zswap_pool_get_many(pool, zc->nr_pages);
+	if (objcg) {
+		obj_cgroup_get_many(objcg, zc->nr_pages);
+		obj_cgroup_charge_zswap_many(objcg, total_batch_comp_length,
+					     zc->nr_pages, nr_incomp);
+	}
+	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
+	if (unlikely(nr_incomp))
+		atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);
+
+	return true;
+
+tree_store_failed:
+	for (i = 0; i < store_fail_idx; ++i) {
+		xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
+			 swp_offset(zc->entries[i]->swpentry));
+		zswap_lru_del(zc->entries[i]);
+	}
+
+	return false;
+}
+
+/*
+ * Store multiple pages in @zc->folio, starting from the page at index @start up
+ * to the page at index @end-1, i.e. @zc->nr_pages. Each phase of
+ * zswap_store_pages() does batch processing of @zc->nr_pages in the folio.
+ * State unwinding is kept to a minimum as a result of the batch processing: a
+ * batch proceeds to the next phase of store processing only if it passes this
+ * stage. The batch cleanup is consolidated under the @store_pages_failed
+ * label. Errors in storing a batch result in folio level cleanup occurring in
+ * zswap_store().
+ */
+static bool zswap_store_pages(struct zswap_store_context *zc,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	bool ret;
+	u8 i;
+
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
+
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
+	if (unlikely(!ret))
+		return false;
+
+	zswap_init_entries(zc, pool, objcg);
+
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (!zswap_compress(zc->folio, zc->folio_start + i,
+				    zc->entries[i], pool, zc->wb_enabled))
+			goto store_pages_failed;
+	}
+
+	ret = zswap_tree_stores(zc, pool, objcg);
+
+	if (unlikely(!ret))
+		goto store_pages_failed;
+
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
+	for (i = 0; i < zc->nr_pages; ++i) {
 		if (zs_handle_is_allocated(&zc->entries[i]->handle))
 			zs_free(pool->zs_pool, &zc->entries[i]->handle);
 	}
 
-	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
-				       zc->nr_pages - store_fail_idx);
-
+	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
 	return false;
 }
 
-- 
2.39.5

