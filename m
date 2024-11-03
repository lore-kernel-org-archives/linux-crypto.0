Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE6414F12F;
	Sun,  3 Nov 2024 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604084; cv=none; b=mOGt9dCOXSgaxh93Rje7v8IdEmMwwvlE69REf2DP6z97bauivV8Od+OaII5+NofCDTrSYmkRV0GJHcSKresZbmeRym9sXpM4jaqZae6m563eZP/7gRP5tKIdfbjV3dlzum0GM2DMaVqGXG6+PVuBGmUor2D3hH4E88D8rYLM4j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604084; c=relaxed/simple;
	bh=e3w3jsrwSRn0skEK+1OKRkuNEeuFjmM/VVAG1YViexY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GbAjJaGPJPzOIohO9jJevnhs8/jj/q4ksMs7UR7DNK5klpWjKiIoD+9ajT7y8BUeWWdZYVS9p38fYyAuCicM0815+KzopcL3p2BuDbpRCsSPYEd+FSWs/e+YKaI3hYt7tYX0petPD5+Cyi7dL1CFWm7mGXObH9/Eb0bWfB8qb1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q1ygJ5j+; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q1ygJ5j+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604082; x=1762140082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e3w3jsrwSRn0skEK+1OKRkuNEeuFjmM/VVAG1YViexY=;
  b=Q1ygJ5j+U8WXR2zPDa/8wlk+m31CdVxrd06x1i7RHkJkHdKdjm1JN+Mv
   g3TslP4Iy43daE6JYz6KgTpHdiaon3CYmesESNNXg+TAM8hLhpi6WRmLV
   uaPVHZtTEHIdn7Bi0kKkD7UDSgfMtFJVyZHWdhNTuqPdN+V7iCsL5xCSo
   yP7VYzQrGoqVVpukbBO8yijafP0MnYfwD9oMVM649debYbKj2lYS9C43R
   8owebu49Hobb3PnjN3ibH/0pENaRbwPY0mUUI8Pg9HJSZG2rpZsrGNQab
   HFk1uBpZ9ijsiymO5FNg+FQOmiNPAtAl7rZ7N6ZwW4A7Awt70rv3CnyTZ
   Q==;
X-CSE-ConnectionGUID: g+fgih3oQgOzYJvNgFAdcw==
X-CSE-MsgGUID: 2mHStZz6Qyagui0DL7Q2GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548309"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548309"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:13 -0700
X-CSE-ConnectionGUID: PVoUksXZR4mAcYTV3a/VVg==
X-CSE-MsgGUID: azt2Ht8kSBu5utEhSx2oiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451891"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 02 Nov 2024 20:21:14 -0700
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
Subject: [PATCH v2 08/13] mm: zswap: acomp_ctx mutex lock/unlock optimizations.
Date: Sat,  2 Nov 2024 20:21:06 -0700
Message-Id: <20241103032111.333282-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
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

