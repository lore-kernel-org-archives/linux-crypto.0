Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC1B226523;
	Thu,  6 Feb 2025 07:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826481; cv=none; b=qObJNmzyBOUpjW84WmdyKfgOsj+iUehFqM+X70zo9HvrFYmmVCXOYz2zh5ItgBqbE3X05H0ZqXzhIzHfz3sefGXTHL3Wa0ash6H/pqdPDF6Bs9Dc5tR6IXuzGfvSkfXIUUIC+X0e30rnJ5QOPf3fZBmLMnEEOj515tJuKLHjNQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826481; c=relaxed/simple;
	bh=hGMXf+St2ZchUBtwIHiThEldg2uqLPjq0XggSNACRI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hWPHuij2leI1Vh2IZJ/wpN/CE9gkjzGjz+fOiEA7wUQUezvIo5OFIacxsYmy/jkksJiwzDkQHBfje5NcbgxClyZlqLQIcQ/dP4vkhvYTurjv3KwTnQhNa1nwCOnpL6ZOQC8r7gyZB9plJJ22vYmHOk8ewpU+GZ8L6XsixLnL4Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m2RvUlr7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m2RvUlr7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826479; x=1770362479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hGMXf+St2ZchUBtwIHiThEldg2uqLPjq0XggSNACRI4=;
  b=m2RvUlr7k03CoV+w+5k8d+B6qBibVr01WBmg0J9GStkuv4qiasvWo89e
   4Ba5LyRn6pFIToNF4MnflDLeSQOPEidZau2f5ZT9l19PLOebpkIg3O697
   B/+OnOunoWkDLZeczL/xjsCU9sSx+4TZfvTBrl4tpwJcgai/kawlEnHoS
   mAhgf15pxt2hZbIeouvZUpbhfVzTkuq+dDmFq4wFyLN/waxFWq5FdaKDA
   wAjGvx7te0BiHE57YIUdHOkdj3arJBz0Ux9/ndqdjCbEt/lhSF8G4AgHS
   6aXDIkOZp3j4dRyDHTG8Plp29wT+sIxAweQ8F2ms1iNd1CorFTfX00rbv
   w==;
X-CSE-ConnectionGUID: MmjPVO3YT8OVTdDslRVi1g==
X-CSE-MsgGUID: /aCx2EtwT3yoEBRVLjCE6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962745"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962745"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:06 -0800
X-CSE-ConnectionGUID: T5sTzomPTre7jUusWIkprA==
X-CSE-MsgGUID: 3PROnXzOSNuq6V4KrEWVwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022649"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:06 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA in zswap_store() of large folios.
Date: Wed,  5 Feb 2025 23:21:01 -0800
Message-Id: <20250206072102.29045-16-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zswap_compress_folio() is modified to detect if the pool's acomp_ctx has
more than one "nr_reqs", which will be the case if the cpu onlining code
has allocated multiple batching resources in the acomp_ctx. If so, it means
compress batching can be used with a batch-size of "acomp_ctx->nr_reqs".

If compress batching can be used, zswap_compress_folio() will invoke the
newly added zswap_batch_compress() procedure to compress and store the
folio in batches of "acomp_ctx->nr_reqs" pages.

With Intel IAA, the iaa_crypto driver will compress each batch of pages in
parallel in hardware.

Hence, zswap_batch_compress() does the same computes for a batch, as
zswap_compress() does for a page; and returns true if the batch was
successfully compressed/stored, and false otherwise.

If the pool does not support compress batching, or the folio has only one
page, zswap_compress_folio() calls zswap_compress() for each individual
page in the folio, as before.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 113 insertions(+), 9 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 6563d12e907b..f1cba77eda62 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -985,10 +985,11 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 	mutex_unlock(&acomp_ctx->mutex);
 }
 
+/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the caller. */
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+			   struct zswap_pool *pool,
+			   struct crypto_acomp_ctx *acomp_ctx)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
@@ -998,7 +999,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	gfp_t gfp;
 	u8 *dst;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -1051,7 +1051,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -1509,20 +1508,125 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
+/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the caller. */
+static bool zswap_batch_compress(struct folio *folio,
+				 long index,
+				 unsigned int batch_size,
+				 struct zswap_entry *entries[],
+				 struct zswap_pool *pool,
+				 struct crypto_acomp_ctx *acomp_ctx)
+{
+	int comp_errors[ZSWAP_MAX_BATCH_SIZE] = { 0 };
+	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
+	struct page *pages[ZSWAP_MAX_BATCH_SIZE];
+	unsigned int i, nr_batch_pages;
+	bool ret = true;
+
+	nr_batch_pages = min((unsigned int)(folio_nr_pages(folio) - index), batch_size);
+
+	for (i = 0; i < nr_batch_pages; ++i) {
+		pages[i] = folio_page(folio, index + i);
+		dlens[i] = PAGE_SIZE;
+	}
+
+	/*
+	 * Batch compress @nr_batch_pages. If IAA is the compressor, the
+	 * hardware will compress @nr_batch_pages in parallel.
+	 */
+	ret = crypto_acomp_batch_compress(
+		acomp_ctx->reqs,
+		NULL,
+		pages,
+		acomp_ctx->buffers,
+		dlens,
+		comp_errors,
+		nr_batch_pages);
+
+	if (ret) {
+		/*
+		 * All batch pages were successfully compressed.
+		 * Store the pages in zpool.
+		 */
+		struct zpool *zpool = pool->zpool;
+		gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
+
+		if (zpool_malloc_support_movable(zpool))
+			gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
+
+		for (i = 0; i < nr_batch_pages; ++i) {
+			unsigned long handle;
+			char *buf;
+			int err;
+
+			err = zpool_malloc(zpool, dlens[i], gfp, &handle);
+
+			if (err) {
+				if (err == -ENOSPC)
+					zswap_reject_compress_poor++;
+				else
+					zswap_reject_alloc_fail++;
+
+				ret = false;
+				break;
+			}
+
+			buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
+			memcpy(buf, acomp_ctx->buffers[i], dlens[i]);
+			zpool_unmap_handle(zpool, handle);
+
+			entries[i]->handle = handle;
+			entries[i]->length = dlens[i];
+		}
+	} else {
+		/* Some batch pages had compression errors. */
+		for (i = 0; i < nr_batch_pages; ++i) {
+			if (comp_errors[i]) {
+				if (comp_errors[i] == -ENOSPC)
+					zswap_reject_compress_poor++;
+				else
+					zswap_reject_compress_fail++;
+			}
+		}
+	}
+
+	return ret;
+}
+
 static bool zswap_compress_folio(struct folio *folio,
 				 struct zswap_entry *entries[],
 				 struct zswap_pool *pool)
 {
 	long index, nr_pages = folio_nr_pages(folio);
+	struct crypto_acomp_ctx *acomp_ctx;
+	unsigned int batch_size;
+	bool ret = true;
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
+	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	batch_size = acomp_ctx->nr_reqs;
+
+	if ((batch_size > 1) && (nr_pages > 1)) {
+		for (index = 0; index < nr_pages; index += batch_size) {
+
+			if (!zswap_batch_compress(folio, index, batch_size,
+						  &entries[index], pool, acomp_ctx)) {
+				ret = false;
+				goto unlock_acomp_ctx;
+			}
+		}
+	} else {
+		for (index = 0; index < nr_pages; ++index) {
+			struct page *page = folio_page(folio, index);
 
-		if (!zswap_compress(page, entries[index], pool))
-			return false;
+			if (!zswap_compress(page, entries[index], pool, acomp_ctx)) {
+				ret = false;
+				goto unlock_acomp_ctx;
+			}
+		}
 	}
 
-	return true;
+unlock_acomp_ctx:
+	acomp_ctx_put_unlock(acomp_ctx);
+	return ret;
 }
 
 /*
-- 
2.27.0

