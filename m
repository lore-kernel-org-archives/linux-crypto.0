Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949868;
	b=WKLaTivqteSW0JM0bs1SIWPgrJHIcajx4DBSpYBFELAArykfqQkJ4YLIuZdqh6uLumz1
	 oBSEH//nNyTve7oRXjTW6//OGC3diAfmjNHLbg5fIcQTBoia7sFMx7t6mmq3b6eOcx0Wv
	 KJ2O6x3aUyGpbLseOcM31gGr25fjpPcEnC1zcVGTjmo7dYvZr9yngVGPd6+uEjge6cDiw
	 CQWGtAhlDyWWVAMLDaXUKSh04JeAubVzY5l1ufbC+rvDpB8Em0PwrAJctDfLUPTKRy3HO
	 oIPgDJbABrGI1LG1O1F2q0ZFUC+BXZIA8vzRz+G/FGaxV1MK9+IQm2nWgbqs7Vwaqsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949868;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+SsT0VqRyTfN8lC353rIijD7LbE4Wu8DXCcMg5rqu4=;
	b=5Sig9YVEnAYs5FNHOtV51cNDiSRxB6X4phWmgZeecR4NVRjQ/URqPrqUiCZWvWUj0q1f
	 xTXuIkSlX88OTeMkaxJEhPjHlDNG1CXss94Seh5DF0SJvBGmJs8v77iywXtYxswzHs5rd
	 HqZI6qc4IIZp423xl76UI+BbyAvDm8/y4U2zuH2NogIpvgK8vjCt+4UKmITzvv8DUiFMO
	 9XPBPTlxMQz4ldUxSRD+bDWLb3vsbcsd6Z6p5wEQ7RV3gFMewHMgjPMlcgDRchrW6wRpj
	 T9vqqhPVsQ2QIx3eP0Uhdrj0FXx4VKvGm8ywdg1d5VI04S4V63xaGIAqEcR7j+ZDtPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="XnWXc/1I";
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BBA606D824
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5BBA606D824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XnWXc/1I
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so508060c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949867; x=1794554667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M+SsT0VqRyTfN8lC353rIijD7LbE4Wu8DXCcMg5rqu4=;
        b=XnWXc/1I3Yg2L0Zxg37jrwI64vH2fNMBa/deyjBrOIkXpkyZ1+zrFn3kuw6E0Zpwn9
         F4cbt+CPbH1zsMQxFrD+/u6w50a7ElTfAaP3RekK4EQexSdnVgxvLrbjWfDdOsztyTtX
         mUyBTtgn9Xhmi83lJsL56MoZzmbsCSia5mD4gutoXj6mgeVhVFpNuZcFadBGcknc/Svx
         wJjaFSG7MfTEfuBB37osOK7iFi+VmNUelrEFIcRNalcVJ2zXDmC6iXQ8vSdFNO2aCpxl
         7W45w0MTIqex+B+r7dyhHLMF26rwtimmrqmDeZV5FTxEv4MW51PBDl8JHi51jCRAzkyC
         fbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949867; x=1794554667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M+SsT0VqRyTfN8lC353rIijD7LbE4Wu8DXCcMg5rqu4=;
        b=Ubtjue9q6fqajMVhLqx6dsMN6NFKielyJWS/n8cTaflaT8SBUn/sqB+26ZuvmwO9ZE
         wii1ebISoUzH0/+oC8M0mysAi9oC8hxYSBK8jHn1QxOhBQkYwtMzQc//ze/w1B9Bb0Tq
         A+/ngy9aVHyTfuFR4gAoKOqm1O8S3Mg+D48cJKKNzIJ1NMJwLHMWRNJNpl/sQU5boz1F
         KPU68crxobiDCLM/Fkoy5ZdOWzGxzrGPwZrNsIZluQLpAqrxgzkzYx6MQVmO8rm/ZadQ
         K5bMm/YwNiAAONLLFHifZL+JPWyXOCkUzPXne3e0p7X+QloC6l8FNhXK9R+66hV14iTt
         ychA==
X-Forwarded-Encrypted: i=1; AKwUvBzpCy5Gut0fQoFHUQ6WlcsezMorPAVekCVHEl8Z+Aut4nwUTihWy6i4bCE4uH/7+5lKrqG9/4glGiVSpDY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ms55JE+8xuKmPyOQPasi4JYU0qYAHHvU3warJ5KbEKiILc9m/
	P8Jdh2RFzZjwHuyMM3T2Wh4z+DCZLU4tSsRBSyXYVexo/50o+DyMIcfL
X-Gm-Gg: AYBFou0gh7y7HrF5qtAokcNIJWzuHKE4StTi0a4GeZWWn9q2Ydew1b6UNSmPjTF8wis
	kLgaGkcXLF0AhpC+qiLiOo5crXo7doVckeUEVR1jK1FDoD6jVHlnj6wEAOtM0PN2ioKUxqdqktf
	Jd5YuzaoXIL+WvOQdygDY8Mi3vpPxN0x8rlU5Q+Uvu9xhETS96lQkAB0ilmB4VL0ugSLbQfVNj0
	4pWGNgwJy7e89ANmmKaTnvq2BelYlEFTFCt0i3e46EhG2yWwYjvo4iqCDIdH409dRwpzl6Z3Q0+
	2XhEFHLEy1CGtpL49fIs8czuzNY9Taw1rDqZ82sYdXiJWgqOtAEHrQ5bsijscJQsW49lUKqfgwp
	tOdHF9e4bVHlWT1AxzthjoeJqA+3QH151w64lJ0hNbia4/+X9W3cUVl72l+ZUfpvE+uEowvltml
	zJdCr/5RDa5nd8zYzeKMJJXiE3hnSs/MEFnUT8i5mUV5/SHRShMS3dk/pR/tgD7InEqmSe9u1de
	KSg//EgGP9gB8CQ8zuKPm62+Xho/IC0ZNCONrqQWY3bvzzJ63u9VfKAxWkAHxFa5+ZFg9bme8vg
	jI8MO+byLc1g5VXwedqeq9u0Vx68BNSp1Swo+3ncLw==
X-Received: by 2002:a05:701b:21db:b0:181:5cac:8f27 with SMTP id a92af1059eb24-1b25d34ab7bmr1913466c88.35.1793949865384;
        Thu, 05 Nov 2026 23:24:25 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:24 -0800 (PST)
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
Subject: [PATCH v3 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Thu,  5 Nov 2026 23:24:09 -0800
Message-Id: <20261106072412.7909-6-kanchanapsridhar2026@gmail.com>
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
index e1d57a7d9595..8cc9e0fde456 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -180,6 +180,7 @@ struct zswap_pool {
  */
 #define ZSWAP_FIRST_POOL_ID 1
 #define ZSWAP_MAX_POOL_ID U8_MAX
+#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 19U
 static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 static struct zswap_pool __rcu *zswap_current_pool;
 
@@ -206,15 +207,19 @@ static struct shrinker *zswap_shrinker;
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
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
@@ -679,14 +684,8 @@ static int zswap_enabled_param_set(const char *val,
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
@@ -703,19 +702,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
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
 
@@ -763,10 +761,11 @@ void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
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
 	return entry;
@@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *folio, long index,
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
@@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
+	entry->nid = nid;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
@@ -1897,6 +1898,8 @@ static int zswap_setup(void)
 	struct zswap_pool *pool;
 	int ret;
 
+	BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <= PAGE_SHIFT);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
-- 
2.39.5

