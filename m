Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156719;
	b=GqfiJiWhwnyANHW54KuecddPXoxe6IMeefvoY/iyqFWLI9t5Wuw8xzbuQOw+R9Rxm6Tf
	 yvhgWEDO6NGrgrJJFyn7MXBBOzo7ZqpRJOI190Y++Ex6FEAaErYV1XZGFm02tXlfOG3sN
	 0xeVfMQYW98YyQ50WxP0hn74UwqWFGFtqdcKyJYICC7Ou7dG1zPuh4JLhps6fBtKZl1fj
	 puhSuUw1WRI6wX2QIhaVNTwX7nEz75KTc+k10aZqadHUhf9bd7cgWXQqNPCoaljB+rF5X
	 68bAZseuwCCGCP0cuPrAHxAd8F9BbuQEi+7jForEnT0so8g9CSC1s58DfV53qbH7Ntg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156719;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3MUpJwq590qKxQafFD8yMuDx2EKKmvFmC/ravAUrJ70=;
	b=HUGRZdCdneTGuc8g+34gSb5/0I8npwADR1U8c9+9BQT4txrJQsdR7MwA4ilQ5rBFWsqF
	 3LrHYkeZz7WCaWrBqUBPkCPxzQ/G9nR2dekd68y4sGxS2BigbcY9teZ8DsbeG+zjGYz2x
	 zD4/eDl3LduwpsZ21fn9Ve1QpZGWzfvFQnUotgsaTbheTAsNKYL0fs2QUsdsivAjbdMne
	 Xn6lWy/76nbnrNcQISsbHlNQK7sXwsc90/XxbUFd3AsSR1QnKKjNE1ig1v0GgHRROISf3
	 GT4nznnzm3X70cYwCTWDzVpSTU/7nJAlj4gxymxUedguR5O2TDGSEM4zf7pgVhwvZnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="lu0aN/Bf";
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025BF606A31F
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 025BF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lu0aN/Bf
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-157fe9d771bso581537c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156718; x=1793761518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3MUpJwq590qKxQafFD8yMuDx2EKKmvFmC/ravAUrJ70=;
        b=lu0aN/Bf13LzUy/y7a8c9pHBCWjgPjy2A5uDvfFvXglkah6xQzVtJxKQWfFiezaU8p
         /Jcca6GYoyM62Qm9anLld99DCIaqedrdq6i/Y8YGeiG3F8F6QF55T2q26fN+QDy0+tNR
         2JRci5gscV7kF+s/lcliRkwuAOqwGOqM9qCOF5SemgyyaF1btvd48JywxLnZUDcJ9WEs
         gVC51P+BSBe/25Uk823KGINiumgTwtGV8nyTFjFX1CJmeN2/mb7+f7dIW22M0D9H6LzT
         Z+Xu8Ec1B9J+KwoNTGMZOY9Rval/OPzG2QVCNvwPYfl19x1YbpZ63qB2kDuOoPjMa5dm
         nxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156718; x=1793761518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3MUpJwq590qKxQafFD8yMuDx2EKKmvFmC/ravAUrJ70=;
        b=Ttd9N6JwASNVO++qLB7KlrMpVgDiVSMLUkSxUxOpPh6gK3MygXPlzyhGnn9wYFgNMY
         bxz6APS3ae6rAFCMMkDfqmPPEpzx3gLa2meAzTHo7tcMzvaAH+N5vJ5O5u4TOORT+1gQ
         dpU3HyJxHYTjFhI6LMHmmQ5ugHPOdyk2wmyu9uAYvY1OHRBkgongHHdjQHmFPbJFrq7P
         xeF5oa2N36vm7h8yB7PY3qY88y1uV5vFqQNDoIOxtajODo6Zpl+iAVZMrDjgH45C7acb
         HvP3icDYxdjSC0SrTwV/9LwsPTFc+QhqxfbYMGkz+CqgUty0XQ38VTdWXyWWrogQvUD1
         kbBw==
X-Forwarded-Encrypted: i=1; AKwUvBws6LhZcoCYQ2CZeybtc+f9d2jRUvtZAytHTkBvbKTTTRXKSYwrAsCakSTavrg9ogdL8BMvISnJxDvjrMs=@vger.kernel.org
X-Gm-Message-State: AFq9FYKfNiWHVcSOU/9RFXTchRo4clD74giVkwIk0UfR4quU30kgOwrz
	2tWQspz10cwSdSKtLW3ZlXn/emJDzAfViHcsw2x6+/9VcoYl35C6gWNc
X-Gm-Gg: AYBFou0SJJ9bvJ3jfIP48BDvXwZVdfEF/1pDo6/shv2guBwYKOkbUqmRGFVAalDi76a
	b2aTDX1FH0Gxriub2CwvcG3hWG7b/qv0hoddVNqAJ+h6cDhUoqaGe+f+lifqE2dwPxHZ5XsAloV
	Z1lJy4HjC3K0WU3cTyQAh9DsEENUTyQu0NPzBhthqJbmT+RNUALSI+pBp+ZYGGe+Y7cXgXsRrCo
	nP6hg+wnfwg/VaVHH1T7EW252HTLEHCp2PaXXEgEFkVJx8Zja1+9//etORC18n616oEbS6Kghlr
	+4MINtLphDydTSxAi41s/lnhjll47kjFcFchtMGA+apMoeo3ziGlvDbGQnoU+kSBxzvi9Rcmj4F
	zhAChj2mjRjF3CIjH8Dyo3aRdyMjOvGkd7us8Mib9XLlFTX8X1tOeTIP5QOjarUhbuUvHVRlGkP
	8RP/mO9RCTiy1tgpWw97wBWZlPbFUZNEvyGU7iL21R9p/kd0etpMfzsdQDR7fiIZwHb81hn53Jx
	hKp/QQb1Fae1z6ikzL69IJd1uXg4mYJ/eJi1HwR9mPbsCe8/TcSmWczuR1diTHt36hFWvqNKhgG
	C5980WS3Gm71ok9rF7G4oUwfduH8vozMX3NgNfHKDQ==
X-Received: by 2002:a05:701b:4552:10b0:1a3:dfb6:e593 with SMTP id a92af1059eb24-1a6ced8ee94mr1353465c88.27.1793156717838;
        Tue, 27 Oct 2026 20:05:17 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:17 -0700 (PDT)
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
Subject: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Tue, 27 Oct 2026 20:05:00 -0700
Message-Id: <20261028030503.17923-6-kanchanapsridhar2026@gmail.com>
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
being at least as large as the PAGE_SHIFT, which can be 18 on some
architectures.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e1d57a7d9595..19b7d60bc7d2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -180,6 +180,7 @@ struct zswap_pool {
  */
 #define ZSWAP_FIRST_POOL_ID 1
 #define ZSWAP_MAX_POOL_ID U8_MAX
+#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
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
 
+	BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT < PAGE_SHIFT);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
-- 
2.39.5

