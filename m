Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148368;
	b=yrGK5R5atUgIIl0vyAW+o6zBnflhQdzY8F7qfQuQOaZpj6o2O3JVCILflOKl61A7Ryyy
	 LRO8MPX7NR+lEFl6MnhruYh0pEf4mup709jHUrOSnMGdGSQRuI5gmw2+MqWA3YZTZkCq2
	 E5AhkHB+pnQF0WF3TQ6mGF7fDpYfpA6c6Zj4DZNeAfbcjgmpwjeh6vDXJE2wtttpmz/z0
	 Y08ORd/A6Gl2b0NSzJ73XOExMXmjmN3LBIuJyn+BENyZB0//c8QTyrOsFVM/vJ1JGb3ls
	 ULC8dYpbCkYuSdjY6eKJ7U1D7LCczX7ofqWj20jKr1SWuwv4O0pSo2mYa2W4a3DH/rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148368;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EqeMfxM8xgeWT0tjUJL9cHt5zheKeVoDa21rgCviEWs=;
	b=OIGEhWOFpJa4RwtyE0lsoirX4QqsgHfTCrfie6oTvpM8r7uar8vPzJABK/dpQQ7dah4F
	 1w3fd5auP30Urt1oillXQJLDvnTY9SHgEdj26wNbq/yZnXD1OGEfVtEbsMeV0O/21DBws
	 b9ax56LGss7XeDMJzhAddhyw1HXEsV37WlA5MqohvT/nDlj5XkwikGbpV4O8+QAyyWioE
	 5dcIGDyfVDVMMUjjLheQRlSUc+juG+ZShBxZbAqv/oug5xw/o5ZNLgzGF/JEPmG/7eD/L
	 31TxmR5ch+Dfw4Uueze5sY77elGQHrJJjQHi5pQglc7/+fC8qz+XoDwB7BFKphATusw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZNYkBJHU;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C360A3821
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A5C360A3821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZNYkBJHU
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1aefd1bf74aso318919c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148366; x=1795753166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EqeMfxM8xgeWT0tjUJL9cHt5zheKeVoDa21rgCviEWs=;
        b=ZNYkBJHUeuLv8zUAzVJD0t1/k3DBYe1IE/yqSpVxVHdvN/b25kE5VdFPCgwEXpAzHT
         DiY9tT9XsKBGo0X0BbZ99Vx9YyCbgjssEzlvVeqZH+RlJ9TovCnHfBo/a5XKh1n8XNcP
         5sydPspfz/zrfoao7FGE5E7MJvyV/XjJ4DqQQnL07wB0Jet3QbFaeUqWWJqaR9dNWcIM
         Z0Yqdgu4HAgFVwgETpUX1Y89FZJUv3gi1P1JjlF5iEQ+sTrsL6C42RMW8wi3fL6kvibI
         iSGwNp4eF1Bi3OKlfdud3exzTBW1oxO4j0S96IQLdAYtVd06P28nx/ZRKN6v3qKfmAJ9
         7qzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148366; x=1795753166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EqeMfxM8xgeWT0tjUJL9cHt5zheKeVoDa21rgCviEWs=;
        b=j40KcK50h93LBJMFQCoJJiLfcMxGWPdjskviCt4cIDq2dMOwXVJ11ycGBF8ZZwtXaz
         S40TbPl/kXPXH6dGpO4JITn+kARdyZ9dR7c3AzUfHFC0OGR+2o1Up5fkM3UC1LxNxc88
         E1c2EIEmtK9o1h3QVlYzfLwy41KdFKAzKthm2JW8+Q97yLnZPz/dA3n2X21S47y+DMQf
         cAVXK81VHKCbJLUuF510qSBRzslWpWS0LsUrw0FBHokUU4LHUWTTxXv60lMSbezW3jLU
         xCZX/qge38NY8F7gT3xbjKjLWJ/mdUSqGsvmKer2VwR1PWquZN/OREnJGdpYILTtlOAD
         AC1A==
X-Forwarded-Encrypted: i=1; AL+hErHYaCike87eoKL5SO368Lfr74O8dkTZaTrFGIfOpaMoWWTLblqaPE2yP87Z0X/TOPLg8sx34ZqmFvcvr3A=@vger.kernel.org
X-Gm-Message-State: APuU4Z/crGSHctPTuLiZpADtSR3pfa2aHBPwJHVGvo61lJHhZWOmzJQ+
	CsfqbWDudcS7sj17Ahv7AWDpF7oLhrxXZgTecujc9pmGti8epyRQCxVo
X-Gm-Gg: AYBFou3FCZ0C/80jIly3Ga5lSxZ0GFV5n/ymz3DQ1c+J38C2cPixZyoPcrLTVVq5VGh
	XybyPodxx3E6SkyElZ7vV1k0EK/7rjnzjrt9svfFJ0l9IhV/mXNtehLDqGADFjmLDdXJMIuXxJ4
	SZx4Eufr0C7XUbowX6phpCBWEAR8yfXpHMPJWLLNvBNY45uEj6YPY/sFI9ag39AdPY7baWU2OiG
	vIk+6QGSAotSUHVgtQQGQ+GvM2Uhk5PIWH9+CgrQPgWVLHA84ubf4E50NKqn0PwDtiXtP1SjBqd
	yqaXBDfnlKE8UCPj4DXSuKIhpfCyEgvf6qqr8cK9YubvrWrIwdSQuNpZsgzkr8utisMnnYHzoJT
	K8+nFoqIB3oay7biT0g0fvpRz2bBxOouIFSkVPsQb10++h+PWn4SsrYsTUaBilfPnK/n/zDoYeC
	mQNaYlHCYOGCrsZbEegl4GCvix4nTkln2O6Ef4X2QKCj+4k7u5sdbbDeMhZmvg/vwMy0HJgY3KP
	L3gmYYpykNh4ReG3HBb22eIW+TLvMn5mQFbm0UqpfKN5pTagK5X/7RO/S/s4ZEp8PxXhdbIzYxI
	MbN0Mp/G3SBlqbAw7eiO7nfLNct1k3cvuBnRomJtDQ==
X-Received: by 2002:a05:7022:7f14:b0:19d:233:989d with SMTP id a92af1059eb24-1b5568ff754mr1580091c88.14.1795148365990;
        Thu, 19 Nov 2026 20:19:25 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:25 -0800 (PST)
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
Subject: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
Date: Thu, 19 Nov 2026 20:19:04 -0800
Message-Id: <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
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

Use batching when storing large folios in zswap. A new constant,
ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
up to 4 pages at a time while storing large folios. This commit
modifies the "store single page" approach to "store a batch of pages".

As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
compression buffers are allocated to eventually be able to compress and
store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.

For existing software compressors, the extra overhead is the
the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
x86_64. Only the first buffer is currently used.

zswap_store_page() is replaced with zswap_store_pages(), which processes
a batch of pages and allows for batching optimizations. For now, only
optimize allocating entries by using batch allocations from the slab
cache.

Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
page and only call it once for the folio, since the entire folio is
charged to a single memcg. Similarly, obtain the nid once to use during
each batch store of a folio. To facilitate this, a "struct
zswap_store_context" is introduced to keep function parameter lists
concise.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 307 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 217 insertions(+), 90 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 78d9694f75b5..df59ab0c1029 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -85,6 +85,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 4U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -144,10 +147,12 @@ struct zswap_acomp_req {
 	struct mutex mutex;
 };
 
-/* The compression mutex also protects the output buffer. */
+/*
+ * The compression mutex also protects the output buffer(s).
+ */
 struct zswap_comp_ctx {
 	struct zswap_acomp_req areq;
-	u8 *buffer;
+	u8 **buffers;
 };
 
 /* Separate requests, so that decompression does not wait for compression. */
@@ -162,6 +167,7 @@ struct crypto_acomp_ctx {
  * The only case where lru_lock is not acquired while holding tree.lock is
  * when a zswap_entry is taken off the lru for writeback, in that case it
  * needs to be verified that it's still valid in the tree.
+ *
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
@@ -226,6 +232,15 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
+struct zswap_store_context {
+	struct folio *folio;
+	long folio_start;
+	bool wb_enabled;
+	int nid;
+	u8 nr_pages;
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+};
+
 /*
  * No RCU section is needed around the returned pointer: a stored entry pins
  * its pool via percpu_ref (taken in zswap_store_page()), so the id cannot be
@@ -284,6 +299,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
 
 static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 {
+	u8 i;
+
 	if (!acomp_ctx)
 		return;
 
@@ -302,8 +319,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->comp.buffer);
-	acomp_ctx->comp.buffer = NULL;
+	if (acomp_ctx->comp.buffers) {
+		for (i = 0; i < ZSWAP_MAX_BATCH_SIZE; ++i)
+			kfree(acomp_ctx->comp.buffers[i]);
+		kfree(acomp_ctx->comp.buffers);
+	}
+	acomp_ctx->comp.buffers = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -388,6 +409,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 cpuhp_add_fail:
 	for_each_possible_cpu(cpu)
 		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -778,6 +800,44 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+static inline void zswap_entries_cache_free_batch(
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
+	struct zswap_store_context *zc,
+	gfp_t gfp)
+{
+	u8 i;
+
+	bool ret = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					 zc->nr_pages, (void **)zc->entries);
+
+	if (likely(ret)) {
+		for (i = 0; i < zc->nr_pages; ++i)
+			zs_handle_init(&zc->entries[i]->handle);
+	} else {
+		for (i = 0; i < zc->nr_pages; ++i) {
+			zc->entries[i] = zswap_entry_cache_alloc(GFP_KERNEL);
+
+			if (unlikely(!zc->entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				zswap_entries_cache_free_batch(zc->entries, i);
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
@@ -842,7 +902,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -853,15 +915,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return 0;
 	}
 
-	acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->comp.buffer)
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
@@ -873,6 +931,24 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (ret)
 		goto req_fail;
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers for all compressors.
+	 */
+	acomp_ctx->comp.buffers = kcalloc_node(ZSWAP_MAX_BATCH_SIZE,
+					       sizeof(u8 *), GFP_KERNEL, nid);
+	if (!acomp_ctx->comp.buffers) {
+		ret = -ENOMEM;
+		goto req_fail;
+	}
+
+	for (i = 0; i < ZSWAP_MAX_BATCH_SIZE; ++i) {
+		acomp_ctx->comp.buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
+		if (!acomp_ctx->comp.buffers[i]) {
+			ret = -ENOMEM;
+			goto req_fail;
+		}
+	}
+
 	/* Skip the per-CPU request when decompression can use the stack. */
 	if (acomp_is_async(acomp_ctx->acomp)) {
 		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
@@ -890,7 +966,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 }
 
 static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool)
+			   struct zswap_entry *entry, struct zswap_pool *pool,
+			   bool wb_enabled)
 {
 	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
@@ -903,7 +980,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
 	mutex_lock(&comp_ctx->areq.mutex);
 
-	dst = comp_ctx->buffer;
+	dst = comp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
@@ -942,12 +1019,8 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret) {
-		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
-			rcu_read_unlock();
+		if (!wb_enabled)
 			goto unlock;
-		}
-		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_folio(folio, index * PAGE_SIZE);
@@ -1530,91 +1603,125 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct folio *folio, long index,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @zc->folio, starting from the page at index @start up
+ * to the page at index @end-1.
+ */
+static bool zswap_store_pages(struct zswap_store_context *zc,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
 {
-	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
-	struct zswap_entry *entry, *old;
-	int nid = folio_nid(folio);
+	u8 i, store_fail_idx = 0;
+	bool ret;
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL);
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
-	}
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
+
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
 
-	if (!zswap_compress(folio, index, entry, pool))
-		goto compress_failed;
+	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
+	if (unlikely(!ret))
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
+	for (i = 0; i < zc->nr_pages; ++i) {
+		/*
+		 * Set pool_idx before the xa_store() below publishes the entry, or a
+		 * concurrent reader could resolve a stale pool_idx left by slab reuse
+		 * to an unrelated live pool.
+		 */
+		zc->entries[i]->pool_idx = pool->idx;
+		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
+							zc->folio_start + i);
+		zc->entries[i]->objcg = objcg;
+		zc->entries[i]->referenced = true;
+		zc->entries[i]->nid = zc->nid;
+		INIT_LIST_HEAD(&zc->entries[i]->lru);
+	}
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (!zswap_compress(zc->folio, zc->folio_start + i,
+				    zc->entries[i], pool, zc->wb_enabled))
+			goto store_pages_failed;
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (i = 0; i < zc->nr_pages; ++i) {
+		struct zswap_entry *old, *entry = zc->entries[i];
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
+		if (unlikely(entry->length == PAGE_SIZE))
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
-	zs_free(pool->zs_pool, &entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
+		if (zs_handle_is_allocated(&zc->entries[i]->handle))
+			zs_free(pool->zs_pool, &zc->entries[i]->handle);
+	}
+
+	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
+				       zc->nr_pages - store_fail_idx);
+
 	return false;
 }
 
@@ -1624,9 +1731,14 @@ bool zswap_store(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct zswap_pool *pool;
+	int nid = folio_nid(folio);
 	bool ret = false;
-	long index;
+	struct zswap_pool *pool;
+	long start, end;
+	struct zswap_store_context zc = {
+		.folio = folio,
+		.nid = nid,
+	};
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1660,8 +1772,23 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		if (!zswap_store_page(folio, index, objcg, pool))
+	rcu_read_lock();
+	zc.wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
+	rcu_read_unlock();
+
+	/*
+	 * For batching and non-batching compressors, store the folio in
+	 * batches of ZSWAP_MAX_BATCH_SIZE, where the pages in the batch
+	 * are compressed in batches of the compressor's batch_size. This gives
+	 * better performance than invoking zswap_store_pages() per-page,
+	 * due to cache locality of working set structures.
+	 */
+	for (start = 0; start < nr_pages; start += ZSWAP_MAX_BATCH_SIZE) {
+		end = min(start + ZSWAP_MAX_BATCH_SIZE, nr_pages);
+
+		ret = zswap_store_pages(&zc, start, end, pool, objcg);
+
+		if (unlikely(!ret))
 			goto put_pool;
 	}
 
-- 
2.39.5

