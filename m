Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156723;
	b=vFVS2TQNODa3iU0TjLJdgg4ObesUIOE0+pdLGyLJaZgs/7u79Ky39xv6dn/2FISSfLb/
	 39h9XTueSavB6rZgSldyM9qaRTd9KzkYz75CS8H+ShijPbAx83uLMbfSab51KdrLonjzp
	 ROnIdFEQgxUqU9X3Nrltr1xKmgHCFI6WvuMwpWdopzfihj6J0QglqR8PYlO2eI6ZPFOMy
	 SQkCrEiemM1SHGBuiCsnqFKs9hrteeXiRoqnVovruy+kZFFE2uF3mPluAfSL4GQlSK4tq
	 XwbHBjv07vPyaWXvgOt8AVAEAsoA7hyBpZNQFArRLSY5rhLq53xJg41+F00lmcftxIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156723;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APLAV0ZJuR/FzIwnAo/aU9jS3GkzW09H+h9WgSzD6P0=;
	b=0rjlpPOFG6YMq9KXepYuj4dBl/NElp01H72Xiy+QWRskCugxBBnG49/nVR8rj8+nFyx9
	 n8YoNJUh7/2yb9CqOWkvvlBpXI3nVTTdstJq62mfFkTi2FmlOVk3vqMdKnFqhDK4yTnmi
	 QrbIfyoO3CNXhPCWkFwhhG5D0HCVpxMKylsYGdPHda2dChpBNd8IveHmmLUJjaJHi3UL5
	 tnPGtpgZndvyyHPJypn2jw1aLGEJ6VOZQ70679zIayiM89G2UdTHGaAf6bLCqyvM+ZxdF
	 FaTNbq6dPSbx8oTsJ9VzdJjhlFjy5UdAaCmoA6JZvk6xX33DtulTGzTUklJXGhSHAXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQlytz9Z;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49771606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49771606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQlytz9Z
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1931ff67a29so1255191c88.1
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156722; x=1793761522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=APLAV0ZJuR/FzIwnAo/aU9jS3GkzW09H+h9WgSzD6P0=;
        b=jQlytz9ZYZklZCP2Q3EDMBNPlfq/L/LN7hQFVY7e8jVXV3HflQn4VAtJS9iBRzA94Z
         6P5FYHFRwWkBPhbasjIrSyNEBDaIA9ZE+m4Au3pY3TFlLVXmcEY4dLjdKafTq3gZxnMd
         8ERb65EG0+6bPuZ21IkaCpBwrSaFKeLsIFR1lcQRy/gWCsmJsjV/8WDNoINTJDogHnzt
         /oxePzrjRIZbtQzRN3j8CILKQwpfw+T495IsMucTQQTYt3ZzTJOGdg2MEZ0f8zFdq3Zd
         rvEnkD8+gMkEQO1xd1FeGHEu3u9yaO9V4wREbaKWFkSXULqAz+lgsxEiPtYDdYUr1U+u
         nhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156722; x=1793761522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=APLAV0ZJuR/FzIwnAo/aU9jS3GkzW09H+h9WgSzD6P0=;
        b=SNubSgOGHRNFqNB4CKAIoL9XhyqsSGw16QzG/ebC0mD317qPsAUQS6AMHXUdMsGxmZ
         KJ4cEpvL1fWk9rx/laO1v3LlpsDIIrdeoImPT5LV0IOfHcxcRwaoQbxYbjnaUUek4Mxx
         Ako9wFqFFi5R53ec4F9fu27FgSifXzZPjQmCgfbEf1s5lkudhssOlnH7JdjR/b4pU2bb
         9lqOlcPYFtMlOuu6ilji8Rx3SbwZ40bHFLbr7ixl5Go51P3YloTYqNrHB+oKVhWtiqMk
         He2StQw2aBw9y2P+sSez78Z08gw1HwRXOye3P7/AH7FTwAsxzPagsf+rebiPeiJE9krz
         adZg==
X-Forwarded-Encrypted: i=1; AKwUvBxk4TZJvpuSdSxSjP/V9OogczuUVgA7S/nhemTrt046M0Dj81u9bGeDUnOtq0BPdyK7TTtcqS2IlLj+168=@vger.kernel.org
X-Gm-Message-State: AFq9FYKK1PCtwPqy9upRK5m7d93Q5osHznc9a7GkeTf6EOwadD0OU82T
	RKXMvFdA5GZQqZly5mFHU3+YW8/+e9zec/9a2ZLBDADmGs5xLWJcQGXi
X-Gm-Gg: AYBFou3qBCVhjLo42GjQiBO56vbGnJ7R2be8YrCYYjzQSblg0FQ5fiA4cppnJ3hzOqd
	By5UH9JWQyuvlHtD5+IHuuOHzj2mPHGaSI8sBXcKl1k8V19xQpWBrh/C2vGLDkS/GPjafjsjWW6
	EerJRvBKAw2NQ/HQTXpS/ys1iP6jb/pr+fpGyvCCdXzU7v5axi+ODLHCj+0I3jVSDuCBJ0k7As/
	ZzyblHJY8lq/yE0fuxKdtrf1pYDqBj/dq3Uqr8ZvBHZppTT/in9wM7GwRh00BpJQ+jE7T3bpOY8
	CW07vrgWTZnmqi0raSZYKeMKNWmGJxrIMrWm5XCTMin5U7c3296ROSoPEN87ziQ0e6cFIoScIcK
	hVHcJB5th+qkVSGYLSbHygqN6SGSTXVdhv17AwzsyRdNreu3tOPndFqWX3Bsh23dy/3U+iQ6rcC
	Mf8TBJ6GvIngTi+4d5NXzn55ruYnaUJx/Si4iJDTh400pei3QV6dWNAl9Y0VVqZAp/Io6TFuwYq
	ZcvW48OVU6mGvtvG/qv9wxgFEZVJFgW3hf0qi7wDIBoZ0rxXyyLy7VN2x32BaoK2ArQN5vGGjnV
	JoOCp73UTQfsTh6ENFk9m+/mBAmp8IBuxAXGPC4M6iOAxw65+7usHmUB45OKV3U=
X-Received: by 2002:a05:701a:ca03:b0:151:5d01:9316 with SMTP id a92af1059eb24-1a6cca02d70mr1584749c88.23.1793156722103;
        Tue, 27 Oct 2026 20:05:22 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:21 -0700 (PDT)
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
Subject: [PATCH v2 8/8] mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
Date: Tue, 27 Oct 2026 20:05:03 -0700
Message-Id: <20261028030503.17923-9-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
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

This various stages of zswap_store_pages() are broken down into routines
that work on a batch of data when a large folio is being processed:

 zswap_init_entries()
 zswap_compress()
 zswap_tree_stores()
 zswap_account_stores()

The struct zswap_store_context is used to pass constraints and data
among these batching components. The resulting code is highly simplified
and maintainable, where each of the batching sub-routines of
zswap_store() can be optimized modularly.

For instance, the zswap_account_stores() now does the zswap atomics
counter increments, getting pool references, getting objcg references
and objcg zswap charging at the batch level.

Subsequent patch series will be submitted, that implement ideas building
upon this batching framework:

 1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
    for a finite # of compressed size bins. This enables bulk allocation
    of compressed buffers in a batch, that belong to the same size
    bin. It gets rid of significant zsmalloc latency overhead (locks,
    compressed data spanning zspages, etc.), without compromising memory
    efficiency.

 2) vmscan reclaim batching of hybrid any-order folios, that will submit
    a batch of folios to zswap_store()'s batching framework to optimize
    storing of batches of pages from different folios, and also within
    large folios.

The batching framework introduced in this series improves zswap_store()
latency by a lot.

Performance data: usemem with 56% over-commit:
==============================================
Validation was done with mm-unstable as of 10-25-2026 (Baseline) and with this
patch series. To minimize variation in the data, I made these changes to my
performance measurement methodology:

1) Reduced the number of usemem processes to 2. Each process tried to allocate
   2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
   over-commit.

2) Increased the runtime of the workload to ~9 minutes by enabling PMD THP,
   i.e., 2048kB mTHP folios.

3) The use of PMD THP forces zswap_store()/zswap_compress() latency to be in the
   critical path, and thus enables very reliable measurements with bpftrace.

4) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
   level of granularity and accuracy.

Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.

Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 2 (E-Cores: 2,3)

zswap compressor:
  ZSTD

mTHP enabled:
  2048kB (PMD THP)

I used the help of an LLM to write the bpftrace data post-processing scripts
that generate latency percentiles.

vm-scalability/usemem setup:

  cgroup memory.high: 3G
  2 usemem processes, each allocates 2400M anonymous memory, reads the
  Silesia dataset [1] from a pre-fork-allocated buffer into the 2400M,
  writes to each unsigned long in the 2400M, sleeps for 10 sec, then
  frees the memory and exits.

    usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M

 usemem metrics are reported from a single run after starting the QEMU VM.
 Further, I have tabulated the bpftrace p50/p95/p99 latencies with these labels:

 "zswap_store_higher_order":
    zswap_store() of PMD folios.

 "zswap_store_order_0":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 ----------------------------------------------------------------------------
 usemem                       Baseline      zswap        zswap   Change with
 PMD THP                   mm-unstable      store     compress      compress
                            10-25-2026   batching     batching      batching
                                        (patch 6)    (patch 8)          %
 ----------------------------------------------------------------------------
 usemem process 1                6,353      7,240        7,428
  Throughput (KB/s)

 usemem process 2                6,352      7,236        7,422
  Throughput (KB/s)

 Average Throughput (KB/s)       6,353      7,238        7,425        17%
 ----------------------------------------------------------------------------
 usemem process 1              484,580    308,903      257,230
  Time to free memory (usecs)

 usemem process 2              518,928    438,585      446,958
  Time to free memory (usecs)

 Average Time to               501,754    373,744      352,094       -30%
  Free Memory (usecs)
 -------------------------------------------------------------------------------

 -------------------------------------------------------------------------------
 usemem                          Baseline        zswap        zswap       Change
 PMD THP                      mm-unstable        store     compress         with
 BPFTRACE                      10-25-2026     batching     batching     compress
                                             (patch 6)    (patch 8)     batching
						                            (ns)
 -------------------------------------------------------------------------------
 zswap_batch_compress_per_page (ns):
                         p50                                 40,086        1,569
                         p95                                 54,689      -64,505
                         p99                                 83,248      -88,488
 -------------------------------------------------------------------------------
 zswap_single_compress_per_page (ns):
                         p50       38,517       38,352       36,650       -1,867
                         p95      119,194      121,174      133,678       14,484
                         p99      171,736      158,601      169,010       -2,726
 -------------------------------------------------------------------------------
 zswap_store_higher_order (ns):
                         p50   21,012,222   21,322,885   20,176,667     -835,556
                         p95   25,643,500   26,204,375   24,485,000   -1,158,500
                         p99   28,567,400   38,577,750   26,158,000   -2,409,400
 -------------------------------------------------------------------------------
 zswap_store_order_0 (ns):
                         p50       37,601       36,994       37,568          -33
                         p95      123,731      137,034      128,366        4,635
                         p99      159,965      169,282      175,618       15,653
 -------------------------------------------------------------------------------
 vmstat summary:
 -------------------------------------------------------------------------------
 zswpin                         1,104,226      993,412    1,091,146
 zswpout                        1,688,181    1,582,664    1,669,671
 2048kB-alloc                       2,500        2,505        2,500
 2048kB-zswpout                     1,535        1,535        1,535
 2048kB-swpout-fallback               927          929          875
 -------------------------------------------------------------------------------

 zswap compress batching improves on both, zswap_store() latency and
 zswap_compress() latency wrt the baseline, pretty consistently; except for p50
 batch compress latency which can be optimized further in subsequent
 patches. The batching framework established in this series allows us to make
 locking and bulk-processing improvements in each stage of zswap_store(). One of
 the ideas that has been showing very promising results is to replace zsmalloc
 with SLUB compressed caches and will be submitted separately. This is expected
 to resolve the p50 batch compress latency issue since it will be directly
 optimizing zswap_update_entries().

 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim and the cycle continues. As the data
 demonstrates, this directly contributes to more memory over-commit
 opportunity.

Architectural considerations for the zswap batching framework:
==============================================================
The zswap batching framework is designed to be hardware-agnostic.
It can be leveraged by any hardware accelerator or software-based
compressor.

Potential future clients of the batching framework:
===================================================
This patch-series demonstrates the performance benefits of compression
batching when used in zswap_store() of large folios. Compression
batching can be used for other use cases such as batching compression in
zram, batch compression of different folios during reclaim, kcompressd,
file systems, etc. Decompression batching can be used to improve
efficiency of zswap writeback (Thanks Nhat for this idea), batching
decompressions in zram, etc.

[1]: https://wanos.co/assets/silesia.tar

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 178 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 112 insertions(+), 66 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4476fb4aeb5f..2831284cfc90 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -504,12 +504,18 @@ static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 }
 
 /* The caller must already have a reference. */
-static void zswap_pool_get(struct zswap_pool *pool)
+static void __maybe_unused zswap_pool_get(struct zswap_pool *pool)
 {
 	percpu_ref_get(&pool->ref);
 }
 
-static void zswap_pool_put(struct zswap_pool *pool)
+/* The caller must already have a reference. */
+static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
+{
+	percpu_ref_get_many(&pool->ref, nr);
+}
+
+static inline void zswap_pool_put(struct zswap_pool *pool)
 {
 	percpu_ref_put(&pool->ref);
 }
@@ -1668,25 +1674,13 @@ static void shrink_worker(struct work_struct *w)
 **********************************/
 
 /*
- * Store multiple pages in @folio, starting from the page at index @start up to
- * the page at index @end-1.
+ * Functions called by zswap_store(), that operate on batches of pages.
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
-	if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
-		return false;
+	u8 i;
 
 	/*
 	 * We co-locate entry initialization as much as possible here to
@@ -1694,9 +1688,9 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
 		/*
-		 * Set pool_idx before the xa_store() below publishes the entry, or a
-		 * concurrent reader could resolve a stale pool_idx left by slab reuse
-		 * to an unrelated live pool.
+		 * Set pool_idx before the xa_store() in zswap_tree_stores()
+		 * publishes the entry, or a concurrent reader could resolve a
+		 * stale pool_idx left by slab reuse to an unrelated live pool.
 		 */
 		zc->entries[i]->pool_idx = pool->idx;
 		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
@@ -1706,27 +1700,17 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		zc->entries[i]->nid = zc->nid;
 		INIT_LIST_HEAD(&zc->entries[i]->lru);
 	}
+}
 
-	/*
-	 * Locking the comp_ctx mutex once per store batch results in better
-	 * performance as compared to locking per compress batch.
-	 */
-	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
-	mutex_lock(&zc->comp_ctx->areq.mutex);
-
-	ret = zswap_compress(zc);
-
-	mutex_unlock(&zc->comp_ctx->areq.mutex);
-
-	if (unlikely(!ret))
-		goto compress_failed;
+static bool zswap_tree_stores(struct zswap_store_context *zc)
+{
+	struct zswap_entry *old;
+	u8 i, store_fail_idx = 0;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
-		struct zswap_entry *old, *entry = zc->entries[i];
-
-		old = xa_store(swap_zswap_tree(entry->swpentry),
-			       swp_offset(entry->swpentry),
-			       entry, GFP_KERNEL);
+		old = xa_store(swap_zswap_tree(zc->entries[i]->swpentry),
+			       swp_offset(zc->entries[i]->swpentry),
+			       zc->entries[i], GFP_KERNEL);
 		if (unlikely(xa_is_err(old))) {
 			int err = xa_err(old);
 
@@ -1734,13 +1718,11 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
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
@@ -1750,24 +1732,30 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		 */
 		if (unlikely(old))
 			zswap_entry_free(old);
+	}
 
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
-		if (unlikely(entry->length == PAGE_SIZE))
+	return true;
+
+tree_store_failed:
+	for (i = 0; i < store_fail_idx; ++i)
+		xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
+			 swp_offset(zc->entries[i]->swpentry));
+	return false;
+}
+
+static inline void zswap_account_stores(struct zswap_store_context *zc,
+					struct zswap_pool *pool,
+					struct obj_cgroup *objcg)
+{
+	size_t total_batch_comp_length = 0;
+	u8 i;
+
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (unlikely(zc->entries[i]->length == PAGE_SIZE))
 			atomic_long_inc(&zswap_stored_incompressible_pages);
 
+		total_batch_comp_length += zc->entries[i]->length;
+
 		/*
 		 * We finish by adding the entry to the LRU while it's already
 		 * in xarray. This is safe because:
@@ -1778,20 +1766,78 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		 *    The publishing order matters to prevent writeback from seeing
 		 *    an incoherent entry.
 		 */
-		if (likely(entry->length))
-			zswap_lru_add(entry);
+		if (likely(zc->entries[i]->length))
+			zswap_lru_add(zc->entries[i]);
 	}
 
+	/*
+	 * The entry is successfully compressed and stored in the tree,
+	 * and further failures will be cleaned up in zswap_store().
+	 * For the batch, grab refs to the pool and objcg, charge zswap memory,
+	 * and increment zswap_stored_pages by @zc->nr_pages. The opposite
+	 * actions will be performed by zswap_entry_free() when the entry is
+	 * removed from the tree.
+	 */
+	zswap_pool_get_many(pool, zc->nr_pages);
+	if (objcg) {
+		obj_cgroup_get_many(objcg, zc->nr_pages);
+		obj_cgroup_charge_zswap(objcg, total_batch_comp_length);
+	}
+	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
+}
+
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
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
+	if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
+		return false;
+
+	zswap_init_entries(zc, pool, objcg);
+
+	/*
+	 * Locking the comp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&zc->comp_ctx->areq.mutex);
+
+	ret = zswap_compress(zc);
+
+	mutex_unlock(&zc->comp_ctx->areq.mutex);
+
+	if (unlikely(!ret))
+		goto compress_failed;
+
+	ret = zswap_tree_stores(zc);
+
+	if (unlikely(!ret))
+		goto store_pages_failed;
+
+	zswap_account_stores(zc, pool, objcg);
+
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i)
+	for (i = 0; i < zc->nr_pages; ++i)
 		zs_free(pool->zs_pool, zc->entries[i]->handle);
 
 compress_failed:
-	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
-				       zc->nr_pages - store_fail_idx);
-
+	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
 	return false;
 }
 
-- 
2.39.5

