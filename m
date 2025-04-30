Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D82D3F8B;
	Wed, 30 Apr 2025 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046406; cv=none; b=erS5FRW1I8iEi5b7l7mmJ4gBxy6hVdAxUTq8CvI28bHWo/hbukUxF7ZjNHg0T0ni/45PFiMPoZWauYZJolPIgYHh4bGAqzsWz8RBl96mUKqMYfBhBbmtdep4D+AfViMNWVpxaxb+obCDBuE3c24k8Yp15AgT12GUvjGEELocFnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046406; c=relaxed/simple;
	bh=QeU7OJJnQc8OUFHpvKhiB60Fd/8n0u/d9ngD8H0HIB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nXxoExBowJSb5ap9isV/AX9LDUqjDwrKduaXTc4GMP/ronCvI5NR/J14J714lp8w5bI04wTgE2poJeRrA/ASTeFLacna+20lcSqQvGMIq6fmISIFbiNt/VRTFUx+azOhCi8PCsYITVLEjftcTQnuiCbszefJiuJ3vaFxXs6H1Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GmFUZdCn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GmFUZdCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046405; x=1777582405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QeU7OJJnQc8OUFHpvKhiB60Fd/8n0u/d9ngD8H0HIB4=;
  b=GmFUZdCnfvdKHafYqwIDQ0S/b13sX7BBhoUX2N5sSq4HTHGIXs05ZG3c
   8FakKE7yzE9ymO3xyN6REefDNsu84to/34qtCa9uFVRONn5+HScKPDDYc
   J6VFRvx8jJ7SLS7D5p8LHKOVBTurKzQrZ00iaPdtX1PwaM0TbpRH0loJj
   zOlAeN+jwTwpwkt+v234jxRujTY/O2QPhO1GnQadSDV7VHzfal7YianGf
   xm84uEFP+MAaFCXpRvqN8Ndli0hp3sgMBYAhzdEzJ2GdHo6ku6NCcUIgv
   GpN3Y9nyeTq1P1wHC+pb3rpoyWunsSozjtyp+YEislDw2qW8EPFUrg/7C
   w==;
X-CSE-ConnectionGUID: K0KSPS6nRiG4s+XZPALdiw==
X-CSE-MsgGUID: eGZpxKEDSzqAjvb7twpJeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388743"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388743"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:23 -0700
X-CSE-ConnectionGUID: ZMpkVDrXSE6O2WNqgEU8zw==
X-CSE-MsgGUID: NP+Y/ySFR6GDgJ/O1eDJKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248949"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:22 -0700
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
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 19/19] mm: zswap: Batched zswap_compress() with compress batching of large folios.
Date: Wed, 30 Apr 2025 13:53:05 -0700
Message-Id: <20250430205305.22844-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces a new unified implementation of zswap_compress()
for compressors that do and do not support batching. This eliminates
code duplication and facilitates maintainability of the code with the
introduction of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

If the compressor does not support batching, each page in the batch is
compressed and stored sequentially.

If the zswap compressor supports batching, for e.g., 'deflate-iaa',
the Intel IAA hardware accelerator, the batch is compressed in parallel
in hardware by calling crypto_acomp_batch_compress(), the new batch
compression API added earlier in this series. If all requests in the
batch are compressed without errors, the compressed buffers are then
stored in zpool.

Another important change this patch makes is with the acomp_ctx mutex
locking in zswap_compress(). Earlier, the mutex was only held during
compression. With the new code, [un]locking the mutex per page caused
regressions for software compressors when testing with usemem
(30 processes) and also kernel compilation with 'allmod' config. The
regressions were more eggregious when PMD folios were stored. The
implementation in this commit locks/unlocks the mutex once per batch,
that resolves the regression.

The use of prefetchw() for zswap entries and likely()/unlikely()
annotations prevent regressions with software compressors like zstd, and
generally improve non-batching compressors' performance with the
batching code by ~8%.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 187 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 132 insertions(+), 55 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1d6795704350..561096f29c58 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -35,6 +35,7 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/list_lru.h>
+#include <linux/prefetch.h>
 
 #include "swap.h"
 #include "internal.h"
@@ -973,71 +974,147 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+/*
+ * Unified code path for compressors that do and do not support batching. This
+ * procedure will compress multiple @nr_pages passed in as @pages.
+ *
+ * @nr_pages can be ZSWAP_MAX_BATCH_SIZE even if the compressor does not support
+ * batching.
+ *
+ * If @pool->nr_reqs is 1, each page is processed sequentially.
+ *
+ * If @pool->nr_reqs is > 1, compression batching is invoked, except if
+ * @nr_pages is 1: if so, we call the fully synchronous non-batching
+ * crypto_acomp API.
+ *
+ * It is assumed that @nr_pages <= @pool->nr_reqs. We could
+ * check this, but don't, for performance reasons. zswap_store() makes
+ * sure of this by design.
+ *
+ * In both cases, if all compressions are successful, the compressed buffers
+ * are stored in zpool.
+ *
+ * A few important changes made to not regress and in fact improve
+ * compression performance with non-batching software compressors, using this
+ * new/batching code:
+ *
+ * 1) acomp_ctx mutex locking:
+ *    Earlier, the mutex was only held during compression. With the new code,
+ *    [un]locking the mutex per page caused regressions for software
+ *    compressors. We now lock the mutex once per batch, which resolved the
+ *    regression.
+ *
+ * 2) The prefetchw() and likely()/unlikely() annotations prevent
+ *    regressions with software compressors like zstd, and generally improve
+ *    non-batching compressors' performance with the batching code by ~7.3%.
+ */
+static bool zswap_compress(struct page *pages[], struct zswap_entry *entries[],
+			   unsigned int nr_pages, struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
-	unsigned long handle;
-	struct zpool *zpool;
+	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
+	int errors[ZSWAP_MAX_BATCH_SIZE];
+	struct zpool *zpool = pool->zpool;
+	unsigned int i, j, nr_comps = min(nr_pages, pool->nr_reqs);
+	int err;
 	gfp_t gfp;
-	u8 *dst;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
-
 	/*
-	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
-	 * and hardware-accelerators may won't check the dst buffer size, so
-	 * giving the dst buffer with enough length to avoid buffer overflow.
+	 * Note:
+	 * [i] refers to the incoming batch space and is used to
+	 *     index into @pages, @entries and @errors.
 	 */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAGE_SIZE, dlen);
+	for (i = 0; i < nr_pages; i += nr_comps) {
 
-	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zwap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
-	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
-	dlen = acomp_ctx->reqs[0]->dlen;
-	if (comp_ret)
-		goto unlock;
+		if (likely(nr_comps == 1)) {
+			sg_init_table(&input, 1);
+			sg_set_page(&input, pages[i], PAGE_SIZE, 0);
 
-	zpool = pool->zpool;
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	alloc_ret = zpool_malloc(zpool, dlen, gfp, &handle, page_to_nid(page));
-	if (alloc_ret)
-		goto unlock;
-
-	zpool_obj_write(zpool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
-
-unlock:
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
+			/*
+			 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
+			 * and hardware-accelerators may won't check the dst buffer size, so
+			 * giving the dst buffer with enough length to avoid buffer overflow.
+			 */
+			sg_init_one(&output, acomp_ctx->buffers[0], PAGE_SIZE * 2);
+			acomp_request_set_params(acomp_ctx->reqs[0], &input,
+						 &output, PAGE_SIZE, PAGE_SIZE);
+
+			errors[i] = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]),
+						    &acomp_ctx->wait);
+			if (unlikely(errors[i]))
+				goto compress_error;
+		} else if (!crypto_acomp_batch_compress(acomp_ctx->reqs,
+							pages,
+							acomp_ctx->buffers,
+							dlens,
+							errors,
+							nr_pages)) {
+				goto compress_error;
+		}
+
+		/*
+		 * All @nr_comps pages were successfully compressed.
+		 * Store the pages in zpool.
+		 *
+		 * Note:
+		 * [j] refers to the incoming batch space and is used to
+		 *     index into @pages, @entries and @errors.
+		 * [k] refers to the @acomp_ctx space, as determined by
+		 *     @pool->nr_reqs, and is used to index into
+		 *     @acomp_ctx->reqs and @acomp_ctx->buffers.
+		 */
+		for (j = i; j < i + nr_comps; ++j) {
+			unsigned int k = j - i;
+			unsigned long handle;
+
+			/*
+			 * prefetchw() minimizes cache-miss latency by
+			 * moving the zswap entry to the cache before it
+			 * is written to; reducing sys time by ~1.5% for
+			 * non-batching software compressors.
+			 */
+			prefetchw(entries[j]);
+			err = zpool_malloc(zpool, acomp_ctx->reqs[k]->dlen, gfp, &handle,
+					   page_to_nid(pages[j]));
+
+			if (unlikely(err)) {
+				if (err == -ENOSPC)
+					zswap_reject_compress_poor++;
+				else
+					zswap_reject_alloc_fail++;
+
+				goto err_unlock;
+			}
+
+			zpool_obj_write(zpool, handle, acomp_ctx->buffers[k], acomp_ctx->reqs[k]->dlen);
+			entries[j]->handle = handle;
+			entries[j]->length = acomp_ctx->reqs[k]->dlen;
+		}
+	} /* finished compress and store nr_pages. */
 
 	mutex_unlock(&acomp_ctx->mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+	return true;
+
+compress_error:
+	for (j = i; j < i + nr_comps; ++j) {
+		if (errors[j]) {
+			if (errors[j] == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
+
+err_unlock:
+	mutex_unlock(&acomp_ctx->mutex);
+	return false;
 }
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
@@ -1529,6 +1606,7 @@ static bool zswap_store_pages(struct folio *folio,
 			      struct zswap_pool *pool)
 {
 	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+	struct page *pages[ZSWAP_MAX_BATCH_SIZE];
 	int node_id = folio_nid(folio);
 	u8 i, store_fail_idx = 0, nr_pages = end - start;
 
@@ -1555,12 +1633,11 @@ static bool zswap_store_pages(struct folio *folio,
 		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		struct page *page = folio_page(folio, start + i);
+	for (i = 0; i < nr_pages; ++i)
+		pages[i] = folio_page(folio, start + i);
 
-		if (!zswap_compress(page, entries[i], pool))
-			goto store_pages_failed;
-	}
+	if (!zswap_compress(pages, entries, nr_pages, pool))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		swp_entry_t page_swpentry = page_swap_entry(folio_page(folio, start + i));
-- 
2.27.0

