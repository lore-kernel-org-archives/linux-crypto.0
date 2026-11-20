Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148365;
	b=3/spUUxFMx1tYA7H/c9GoD6C2Jt3f94UkyG4AqO3NaBMaao6OwX3hyVsglHXG28UvKq9
	 CGHqWnkoejgVJ77xEzxRplh7zcQee6yij8DlBZDvDHsTiexFiqaK/JbJYGlaLovO+IuhM
	 0kehy6DO83YLGeqw+iE68LQMuWf1Afun07O4gN4CLh9izLpSQYmKnkIJQfF+DxcVUWvlP
	 cCIm0S81bkCr/G1dkhjzh7tdbT/tlevlCAOO4XpHoFpJwxC0txOrI/8zNO6bDX25+eGHR
	 mY/NWsZIT1ONUzRGL2Wgnd9FByVRI1pzLK+22aEPF93Ext6gg28YhkxUIoTECLF1tow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148365;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tw2IAI5wSBNupIKIxL5Ig7aobgIjCUpdJvEt5vs8Kl4=;
	b=jWKcXaKCE3wat7a6fFX/WAfzwEokNeizPb89wdKSRw6ELo0lFk6sfwNo2UctARkJ8nrX
	 +TuQjWRFH/QmsHHmrMB2cb8cbjxhkSfHUrgopUUTXMmJ0dt80E8lge3fh3Cfgybmvn0+y
	 8sUDoTPj5J29fE1Bhev28rKTwYvSCYIH2UzBCLXxVn4xhw03xENLgfR19oZuN7SpzYlTX
	 8aeMT+A4I4GAA9sLJ29rGyQagFPKG8r4tzwFYmVYSCFZqsGCIN1Yqt9zIptYgl+6wJW0+
	 r+g70RC9HD47OC9gATBnnzrxUdB6KrjXgSb9KC3wgkyBb9+zFYsF9SmFnjJ7x63/AGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vxTRE8OP;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D95A60A3810
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D95A60A3810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vxTRE8OP
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b3ada81853so542590c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148364; x=1795753164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tw2IAI5wSBNupIKIxL5Ig7aobgIjCUpdJvEt5vs8Kl4=;
        b=vxTRE8OPeHqrGUKmjXMjN6bclXHCrqiOHW5v7f+vC0IOosiXZaakFI0plwoiny3h4V
         45LTBXRpY0wENCMkhZvI9eCoDmrlHMB0gufo6mZIqoq7m45MMF9PS5Hp/ymqcnmqz+Y9
         +dxze6qqVjJDisRHHuuIvtO7TYWJsnZe/BTIQkFuLCdZuDUBx3bC2kXidV4OLfHLY1+A
         Wyn1lcbWgqARr1yz1isfJcLUhgw1HrwR1BJJwtvX7cCqEe3dND/3cT/tMFs6MPX9TMH3
         NcGSVfHKTge6t5AO4/t2ALWlh+aj9TCk8QpLh20JHlOUA9xQdEVI3CiJlfJ2sabNsGba
         rmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148364; x=1795753164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tw2IAI5wSBNupIKIxL5Ig7aobgIjCUpdJvEt5vs8Kl4=;
        b=yI47vc5ZwvLR8aKafzVfkl6SngpfSAhT3X11Fohu6r4/YEpjm2mwRWEPtV2gqa0G7N
         WnmkFBAe87FQK+ebaRxraPhHOitmNYypawikaIQlGExffSWA142GBrDt5cUfuSJr1Acf
         27XhTnviacqjIgrg/P4/q335DP6wRUwgS7Hn3zn9IGH4nZOUKb1GNCLbYHwOn1OhBxZ1
         Ue+D7mkX6K6dQoV3v28vBHQr2TowwIwQneCTUyZ7f7+HPmb/DEJGSWC/TbwweulHDl3g
         3tJ3GxweYOTzvgOs2voxoo++NdVw31j0y9cdIo+giedOwVIKqQb2i6JvaFZdhOduJaXv
         lKWw==
X-Forwarded-Encrypted: i=1; AL+hErGud04FmCU0Pko9rUa3/rBzcODzXUI0XPYC0t4oNHb3JQFY9j/On4QJcyNzOKLLlpUI8ZWV1Chv5sVesLI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8JTSZ9XDCBhLvQABwXxi3oJ1HEwHQFuQpAhnE7M31Qrib73lBE
	Pm+6udK4ORwsLtCIs41qis34+mllpt5bONUTy6euuMr1oL7qGd7z8AHb
X-Gm-Gg: AYBFou3VMcgN3tCa42kzPOqVBlTCbcLQ2uH5h2pViZT/8D4iL3LhpAF1eh+01M1OK6p
	9c0+apjlqT9ROCVp0HQU9NSptwVyB+IeIh/tcgzOdXGBStXZrIVx8hYo9lmW18j//cxvn5+pm8l
	/VkErWZ8+/bF320AUC6omdi/J8cWSQQCHHysVYe8yUEWvDSymiNrnmJwAJZUnc/9K3JJQavSijr
	mlgmCFSG8aqUIEfMwXO5bVKnQa0CdQjDPoNB1CfHT/k23vJK3PGtIi1vtE9yZcSWJItMn4L8W3b
	4QzK5R2lEzk4V8kEWn6lqCrjPnryk+rqjBVPgUUO/lPSnvXe9jkOsg4PnqQlobS+3BDu5P8QmRr
	IfpBi1AnCfvgYH/mrFk/E5NiEBeR4Q5RgT0r21LLOI191IdspGmNcZRIS1A6eT9zjvcMoOfoq2E
	/fJp3QFp8lDFk0onaalRU53tJFsKLEA/QGpqbycRX6bSs6hUyMPFKKIy9e6aeEjKfZmzlB3FYjq
	riHanGq718ZChCTiMpSafyQcuNddAzVWyjidiWSioco3gvQdgzHroOE0CQyatetOfWsssgLOEIY
	c/3txA8tKQt0IW7kiQQNxuHI7d/Ad9/06LVVOPvbxQ==
X-Received: by 2002:a05:7022:170c:b0:1ae:59d6:91cd with SMTP id a92af1059eb24-1b5568f522fmr1440476c88.38.1795148364438;
        Thu, 19 Nov 2026 20:19:24 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:23 -0800 (PST)
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
Subject: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Thu, 19 Nov 2026 20:19:03 -0800
Message-Id: <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
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

When storing a folio in zswap, save the folio's node id in the zswap
entry instead of relying on the zswap_entry being allocated on the same
node. This enables optimizations such as batch allocation of zswap
entries for large folios using kmem_cache_alloc_bulk() that does not
support specifying a node id.

Accordingly, replace the SLUB allocation in zswap_entry_cache_alloc() to
be node-agnostic.

The size of the zswap_entry remains unchanged as 'referenced' is lumped
in with the 'length' (as it doesn't need a full unsigned int anyway).
A build time assertion checks for the zswap_entry's 'length' bitfield
being large enough to represent PAGE_SIZE, which can be 256KB on some
architectures.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 9a323862bd59..78d9694f75b5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -181,6 +181,7 @@ struct zswap_pool {
  */
 #define ZSWAP_FIRST_POOL_ID 1
 #define ZSWAP_MAX_POOL_ID U8_MAX
+#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 19U
 static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 static struct zswap_pool __rcu *zswap_current_pool;
 
@@ -207,15 +208,19 @@ static struct shrinker *zswap_shrinker;
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
  * pool_idx - id of the zswap_pool that the entry's data is in.
+ * nid - NUMA node id of the page for which this is the zswap entry.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
-	unsigned int length;
-	bool referenced;
-	u8 pool_idx;
+	struct {
+		unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
+		bool referenced:1U;
+		u8 pool_idx;
+	};
+	int nid;
 	struct zs_handle handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
@@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val,
 * lru functions
 **********************************/
 
-static inline int entry_to_nid(struct zswap_entry *entry)
-{
-	return page_to_nid(virt_to_page(entry));
-}
-
 static void zswap_lru_add(struct zswap_entry *entry)
 {
-	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	/*
@@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
-	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
+	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
 	rcu_read_unlock();
 }
 
 static void zswap_lru_del(struct zswap_entry *entry)
 {
-	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
-	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
+	list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
 	rcu_read_unlock();
 }
 
@@ -764,10 +762,11 @@ void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
 
-static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
+static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp)
 {
 	struct zswap_entry *entry;
-	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
+
+	entry = kmem_cache_alloc(zswap_entry_cache, gfp);
 	if (!entry)
 		return NULL;
 	zs_handle_init(&entry->handle);
@@ -1537,9 +1536,10 @@ static bool zswap_store_page(struct folio *folio, long index,
 {
 	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
+	int nid = folio_nid(folio);
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL);
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
@@ -1554,6 +1554,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
+	entry->nid = nid;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
@@ -1930,6 +1931,8 @@ static int zswap_setup(void)
 	struct zswap_pool *pool;
 	int ret;
 
+	BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <= PAGE_SHIFT);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
-- 
2.39.5

