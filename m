Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBEF4F5DE9
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484138; cv=none; b=YDU4/XZPsjuv4fN8/y5qjqJX+Gdowuaaul5K6Y04Id79dM9+vKjrtJUUd4Xoz7MN4IXp0osEt+jftSwUutGmx7uj5egTRT62XjWKggQFMa9kojchFytVSRiem3pLGB+KnpPzgNHsQ5ACUoDwaeDYjaimD98NRSmRKlDYwU5O++8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484138; c=relaxed/simple;
	bh=JEBAkbGUNY6kIW9W2b3U3EYpJVf2gM14JyWf1+1Hy9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CJPCLZMwHEyzzIU1bzibciBIDBmb1um8kxUiByXXlPqGPZDk2lhspJxD+tIiuXfSWu78fMt2kQn1f1vP30f3y1IlkPrPiBRY1/QLT1KaLY5XKrloW6QYelbdw4xjzoOnVLHEeZfFb+XqVrg+E5qw4mEsloS3VCbuOSo3jPCc2x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJWUdA6P; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJWUdA6P"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1433e7b057fso4031505c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484115; x=1792088915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AxE3sHe6me8Wwsd+c2Znto62yEHlspamg6eVt2Dlhi0=;
        b=YJWUdA6PyO50u0I3gFadFpccg5yBFxoc7RAvuyvVb9q3VG9GImtyOqiKljAMmK0XDW
         r1Uxpfo8ToPpb9704C6/bGPdBvZe3ZtBJxELMsBk3rETbTw84EQSN9o3g8OMBWxaCWj7
         UWBewMds+goq9dSpeiWnKq2PuHMJGW7A+EY68witI17XWQnbVcqx+Q20y4j3Wpgy2whY
         96T4DbNc/imFAf1D3WiQekgKsBS8UuJx7ZqaOGaqZj48FDGOAqAhwvDEM435+CF2SgJI
         HNQaeHpynJ8x5jJP3FH2fBPh4j99zhhSU2p/VV8IexNMsUeI5HQZrJyPoGm7z3ZNx2Ob
         ZboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484115; x=1792088915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AxE3sHe6me8Wwsd+c2Znto62yEHlspamg6eVt2Dlhi0=;
        b=EcQ55fZblyUceUXYBMXPIbwWN/lqWyrQweTJBde8cOs5cyR8vhmaHkq8GaucDBjCCQ
         Zdj2eLqmPx0eWidC0Tzloabn8b1J1Nbcovwh5bjjD13aSjlxkWloQp03kpnrQkEmWuYe
         zhgt7X9kTPcwYaJBHVUXSIjf74doJzRTJ0NAWYLZndRyQbQ34zQ7Pt2J21XpmrosEdm3
         pIgyysODCWd0Zhp6hxizy7qZMrvaGPuBWZ52BD075dt+alCSZ16Dnfg12j1CaEN5L7A3
         7gNKT334iUOpqmfgXENxJWHXJHl+cGwNmvX/I/m6My5FGLK1v8M+aVkGrbtqRNLgsJ0L
         t1gA==
X-Forwarded-Encrypted: i=1; AKwUvBzyW/txcWXUfy/0eppyHUdamEFsN/BINXv09LvWsbjQ3rCo4VWkE93mh9IJ2dEc/H4Sq4Y2u47hVlNIuR4=@vger.kernel.org
X-Gm-Message-State: AFuF++m5HZGjvxEwOYhrKEM/wIb29eV7WWaybY2qtUYg+YlLPivTRx2y
	qus2mR1qNGJs1rrO8qrpnBFYrrCh8OakUFsoLBXq9GswOg629jrCBItf
X-Gm-Gg: AYBFou0rV+lvBanU5tR3y8j+t5OWsmNucjc8a8CK6Fy16fwrACsPF5pslQzW82JYQz6
	EHLL9R/O5lZHpxUgCSAHdv+EpAhYzv/LTRToHHaRu8TcTER14DrF7m7MrMsICwIYJAcT2O8riAn
	aIp7DdkxEPboNC+LQGsyMJTAsicRQzJLq6YtnVWFK0GIJiuBgzHyLXGvjwwB/x0fz/mkJSP4vGe
	qTvhgQDGlp1veWJqj97/HWmMyWDETMBnM37UJczz35sbDWojEeJ44z5t/HvBVmrbxiAXR+XBD7A
	skwZsZ6rU9TyJb7vPGM8KrGhdP6Mzw5jchZdsiL+aVDseZfi1MPm0slAVa6aDcJsh3XbNFFcM5D
	5gAgdxSQ/deemJSB4CBfZxQyQuslt3sUVSoAz9ReAhbzdXSn6IZ6a5+9kNNFi2s+EynLeVb+06E
	GIrN33zs/Ed9Yg4E9WHwU/E2MDMbE7VbCXhmmqOUi3aVNVdGFqikGhLi8Y718kIDrrx+6SbDz2U
	J63gGMImYA=
X-Received: by 2002:a05:701b:21ce:b0:151:8280:2c57 with SMTP id a92af1059eb24-1620880900amr6711157c88.38.1791484115200;
        Thu, 08 Oct 2026 11:28:35 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:34 -0700 (PDT)
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
Subject: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Thu,  8 Oct 2026 11:28:11 -0700
Message-Id: <20261008182814.27450-6-kanchanapsridhar2026@gmail.com>
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

When storing a folio in zswap, save the folio's node id in the zswap
entry instead of relying on the zswap_entry being allocated on the same
node. This enables optimizations such as batch allocation of zswap
entries for large folios using kmem_cache_alloc_bulk() that does not
support specifying a node id.

The size of the zswap_entry remains unchanged as 'referenced' is lumped
in with the 'length' (as it doesn't need a full unsigned int anyway).

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ca513a9f89e3..c2731d3acb2c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
+ * nid - NUMA node id of the page for which this is the zswap entry.
  * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
@@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
-	unsigned int length;
-	bool referenced;
+	struct {
+		unsigned int length:31;
+		bool referenced:1;
+	};
+	int nid;
 	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *val,
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
@@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
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
 
@@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio, long index,
 {
 	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
+	int nid = folio_nid(folio);
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
@@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
+	entry->nid = nid;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
-- 
2.39.5

