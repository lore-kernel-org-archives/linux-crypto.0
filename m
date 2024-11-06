Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C051920ADF2;
	Wed,  6 Nov 2024 19:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920875; cv=none; b=FXEj5Y/YrFiK2mUsRdlJ8WQBIHZw9rJUq7aB5Lf/pxXk/xbECAzG4ytcKE/Oet0q5PxAdVS7SkUsK5fYpECPs0N6c480y5axp6CEAHZTPgGqnhvrNl96ORsKExopgKNXMu65o7wBvTkNHwHrt23iyRF9CR0es9BoejHEk1X2Sxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920875; c=relaxed/simple;
	bh=e3w3jsrwSRn0skEK+1OKRkuNEeuFjmM/VVAG1YViexY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oZ3rZs81mZuRglFVl8OEug43Jh3wveycerm9TGfyp0og+++kOEyLpsuFOfWbpb+87rqVMk22cL2uNEkCQBpN/6zkAMnJ+7/7MZ5TaRxG3nZPB1kUlCxov9eW95AXxn7N7iiQCLQomtFkJDwGw0rFFHO/anm4LGjJKF1nPTRJn6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NziEj5XJ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NziEj5XJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920874; x=1762456874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e3w3jsrwSRn0skEK+1OKRkuNEeuFjmM/VVAG1YViexY=;
  b=NziEj5XJtCSEsc3p+QSQQnDz/Fsc7T+kfeHJP+KV1wM62mkiabNnCzxM
   eH/BdgOi2MBYLAzDxm0VbNv6g+AY1+NfiobcQXOFkabsqBmpWYji6XiCA
   ycYwrZuN4mZIPsjjCVh2QwaHCu57jFJ2AcKEHUBZEdcYpl0+BbI8t6OCx
   et9XFPvizzdNEW/twz3YrnZi6KoE3c2dJuYZZ71TMMBm5JrbC65zpG542
   gUaMRrOgkgJqgCsbLj84pQDjDfbu14tvWRF+kDZxB7vyirz0gIzmiRgwI
   +EE3cw9EqkXYjxe9rBhfXklBIcPGai8HchZeNYnM7isC7i6nYMnfVV8xF
   g==;
X-CSE-ConnectionGUID: GUVQ78v+RU6eXnqEPpUpgQ==
X-CSE-MsgGUID: bpRJtHR4TKy/3DrXrjb0yA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41292022"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41292022"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:12 -0800
X-CSE-ConnectionGUID: JuZp7wgeTZupSYi8bw+nGA==
X-CSE-MsgGUID: /kRNAQktRwSLiBLyCdU2qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695402"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:11 -0800
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
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v3 08/13] mm: zswap: acomp_ctx mutex lock/unlock optimizations.
Date: Wed,  6 Nov 2024 11:21:00 -0800
Message-Id: <20241106192105.6731-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch implements two changes with respect to the acomp_ctx mutex lock:

1) The mutex lock is not acquired/released in zswap_compress(). Instead,
   zswap_store() acquires the mutex lock once before compressing each page
   in a large folio, and releases the lock once all pages in the folio have
   been compressed. This should reduce some compute cycles in case of large
   folio stores.
2) In zswap_decompress(), the mutex lock is released after the conditional
   zpool_unmap_handle() based on "src != acomp_ctx->buffer" rather than
   before. This ensures that the value of "src" obtained earlier does not
   change. If the mutex lock is released before the comparison of "src" it
   is possible that another call to reclaim by the same process could
   obtain the mutex lock and over-write the value of "src".

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f6316b66fb23..3e899fa61445 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -880,6 +880,9 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
+/*
+ * The acomp_ctx->mutex must be locked/unlocked in the calling procedure.
+ */
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -895,8 +898,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 
-	mutex_lock(&acomp_ctx->mutex);
-
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -949,7 +950,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	mutex_unlock(&acomp_ctx->mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -986,10 +986,16 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
-	mutex_unlock(&acomp_ctx->mutex);
 
 	if (src != acomp_ctx->buffer)
 		zpool_unmap_handle(zpool, entry->handle);
+
+	/*
+	 * It is safer to unlock the mutex after the check for
+	 * "src != acomp_ctx->buffer" so that the value of "src"
+	 * does not change.
+	 */
+	mutex_unlock(&acomp_ctx->mutex);
 }
 
 /*********************************
@@ -1487,6 +1493,7 @@ bool zswap_store(struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 	swp_entry_t swp = folio->swap;
+	struct crypto_acomp_ctx *acomp_ctx;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
@@ -1526,6 +1533,9 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
 	for (index = 0; index < nr_pages; ++index) {
 		struct page *page = folio_page(folio, index);
 		ssize_t bytes;
@@ -1547,6 +1557,7 @@ bool zswap_store(struct folio *folio)
 	ret = true;
 
 put_pool:
+	mutex_unlock(&acomp_ctx->mutex);
 	zswap_pool_put(pool);
 put_objcg:
 	obj_cgroup_put(objcg);
-- 
2.27.0

