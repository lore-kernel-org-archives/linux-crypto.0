Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949870;
	b=jwUoJTtMJZ01i38CC2NpRX40KTZAXM8LU1rYLunJ/kJBKajQ+kKN++DxVXpJKp6+zhho
	 LijXgisrb4OZQ7x98RqJwP4+9V+8hMkkwAOcpYjco6K2EdRaoP9MoKyTr4vOGZn39Hezh
	 gEwLQII/46RxcpPQ7pyln3w4u6YIQ0tV0HWwAxk0PwWBFfjLlUuv68q16MMiOgh/L/UjD
	 tEzpeMYaoK6OEjhAYX9nd86BpvcatSIJbOaVr6kuLfD5I18jpdCy9uHK/i52oPDAXoYgJ
	 FC1NzyEwDYhMANSC5xjrHPliFTkpJVsWHCy6mmQ5mJVriP7nrVWjJjyYH87Lg/Vqr1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949870;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zPKGTeKDiBLjJEUjuWcNmxgLTe9SMXKIDb5z53Wh2O8=;
	b=FK0A/CsOYcYuN2APrp8pbUXPPKCngMCc47D+f3lKMeHIVCkST4A5ZZX+DQyNBHMWVhlT
	 bD63qM6awd4XCG2oabiX2Ll+wBPQrWsAD+u/fKqxbEd7JojRzo5f0d88EnHqggeGpe9a8
	 w+/gFUEewLMrRhsySnD8rn4ToxxHIlNuS1HLH0wCLqN3q+Y52t6H2VQ/GNkdZVbeFLn1D
	 BaF4dYE3taSNldfIn7YAvjRACT6g+QcyC5/oxQVTvfENBmyB3QbaOc9PB1rYgEC9s6/9V
	 78AoMYs3vFx5SGibZH9Q/R6z8LzUpw2pZGVPEn6X+035T2lPlnsjftQlFi3ucbHL9cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cd+UUmhs;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A89606D839
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3A89606D839
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cd+UUmhs
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1a8cc11ac42so355478c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949869; x=1794554669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPKGTeKDiBLjJEUjuWcNmxgLTe9SMXKIDb5z53Wh2O8=;
        b=Cd+UUmhs/fYETrP99MeObMbGceqNgn26ZY6K47HQFzoSfZXu3quuGHgQ+EUnbcOOMO
         Cw1dThTLSQaX36+i9uD48/a6LVp7xyj98Xo7AKMJtT9j1PiTZjL4vHdMLtxMNZ0RJe+K
         KrgVv+B49EUfWdQfqRtTGiFnhET4YiEmkybVkXyEpGAh6MjmtnfgBV40q/yWqtsVrdvD
         P5K+SGXQ3usbWNcM/8gBw0WFncLBeNeFKsTug02IcdATNCwL4NwY2tZ0eajnwYkQZKHR
         iSWLYH+hZ8mSRQSVYJfrb03osKOxm7Z2Rxn0Fy7LdxQRiQkU5T9l/T5mAGc5st6yDkJJ
         etTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949869; x=1794554669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zPKGTeKDiBLjJEUjuWcNmxgLTe9SMXKIDb5z53Wh2O8=;
        b=fJ1NVpENTEOrOjrw9PJTS2QLoYq3PxiZI1VBT8tAMrcS6aXkbw5nlw5ANXUMAxV3ds
         ygyWa6uKVZuaqWtYmGQnz7xmV7Sk3Ni85/BmJHEaCVsn33Bc354Qd67WXZ3jeNHarUoe
         /4SIYiQGffVQopaZyxLHmH979SnBGH/gh18OgTkW0XrrKNqKNlt4ZXrya6UZgQ6A2a4L
         RH4D2JAdXw5U9R1dRtWGRfZsIjtX9vNHQEDpzW3RP8ByRWmO8VqgZdA+hbObXnBZNN2/
         cWRDrYlRnzNT7x0qmfbhm6J2FIEzA5QgW+fDUH0mlrublJAnWoTkU4RF9hLxPWnJkS/7
         e+1A==
X-Forwarded-Encrypted: i=1; AKwUvBzKi+8m0VNVHn7hQQWLGAiezM7J1r2mg7PPbHdwSJJiG9nLJKDQnlPUVHATxl+PGoy8BYD+vtLuCb/R7g4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/vavN7no9o1q2Q5OEbIVEVHfgBg3XM+IS3oDELE7XmiogK/js3
	3XqW8kYoHyr/ih2pVY/WL2dQyPFl/+vI30Kq4gQKyCF4797wI/ts+FEy
X-Gm-Gg: AYBFou2532q1EoWrUNTe0iqar/vu4f51hhpRwxB/krngxL4VusG6fudPweAWY4b98GE
	5o3VF5YobZhuplgw41WJm5xVMIS5k26DZktzY3sHgjdMZEtq9haC61d2QyDsl6A1IAJZ1Ut/mV/
	SErDMrB9UOYRh7oaOM/0resr9t4x3fDDazoPN+4EDp9C6+Kw/2rDgM/x04O3dechQbpef0r2LAv
	/65DpMgPJv6HEJyC5U4F7tJI1UWgkM1MaobQttTOZHH+KC7hUVhVE5/65FhvbFd4TKkH1SLvyYx
	qCRS5V+XjXj4k6oEXhhnSdZwQqUv4rPReh8tIsRi4JZHbq2rGaUEisFAV7DoITt/gg9blLbikqY
	EUUNAA361JosYyfoUWu1GFxRXNxuk6kczrN89nesUzlYaqX4CHqOAQqBzcnGRzcSEryUfZuYCre
	z4ZYaSdgQby3x3n1DVrQvbbKJX/BkzV5YYWKFRRKEbPrFm9POYiUds+OUsT6rtoRhiRDqHC4i+/
	JijHpYv08NgTfnlwOrZvXk2d1ojnzbPOd6TBYebCYS4tU3wV/COaPW3pAPEV3tkb4qmOP3qL82e
	HQS3vk3lqvkYwNqrAXIsGCeU5aizNQfrt9fr/jQXH86ijQZNh5/bPuoYhde14dI=
X-Received: by 2002:a05:7022:7f04:b0:1a9:cad6:5b58 with SMTP id a92af1059eb24-1b25d3650f3mr2241658c88.39.1793949868871;
        Thu, 05 Nov 2026 23:24:28 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:27 -0800 (PST)
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
Subject: [PATCH v3 7/8] mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
Date: Thu,  5 Nov 2026 23:24:11 -0800
Message-Id: <20261106072412.7909-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
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
 include/linux/memcontrol.h |   7 ++
 mm/memcontrol.c            |  36 ++++++++
 mm/zswap.c                 | 182 ++++++++++++++++++++++++-------------
 3 files changed, 164 insertions(+), 61 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..7532dd9f2211 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1946,6 +1946,8 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
@@ -1957,6 +1959,11 @@ static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
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
index 84f4a8fd4d16..eddf6dbe6342 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6345,6 +6345,42 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
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
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	if (obj_cgroup_is_root(objcg))
+		return;
+
+	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
+
+	/* PF_MEMALLOC context, charging must succeed */
+	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
+		VM_WARN_ON_ONCE(1);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
+	rcu_read_unlock();
+}
+
 /**
  * obj_cgroup_uncharge_zswap - uncharge compression backend memory
  * @objcg: the object cgroup
diff --git a/mm/zswap.c b/mm/zswap.c
index 00cc4586b284..c2d17ccb53a1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -490,12 +490,12 @@ static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
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
@@ -1570,56 +1570,61 @@ static void shrink_worker(struct work_struct *w)
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
-		zc->entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		entry = zc->entries[i];
+		entry->handle = (unsigned long)ERR_PTR(-EINVAL);
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
@@ -1631,13 +1636,11 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
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
@@ -1648,22 +1651,10 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
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
@@ -1679,17 +1670,86 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
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
+	atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);
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
 		if (!IS_ERR_VALUE(zc->entries[i]->handle))
 			zs_free(pool->zs_pool, zc->entries[i]->handle);
 	}
 
-	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
-				       zc->nr_pages - store_fail_idx);
-
+	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
 	return false;
 }
 
-- 
2.39.5

