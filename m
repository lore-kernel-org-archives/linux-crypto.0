Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE1C28DF10;
	Thu,  8 May 2025 19:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733315; cv=none; b=skGLSdVrtVHINtu30CLd3s+DuM7FXStzfusdZFyshq1JJ484TBEveFzEC81bnvH8MPkGdoVNQB7HMEcR/EcVo4KMncj3AoaHCBDI4Sje4U/7CG2DbRkk4ZbZfgR+m2X+0/SncVHqU8HrtyNrl2JE9LWCIi7TVXbXVGxcbliOiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733315; c=relaxed/simple;
	bh=QeU7OJJnQc8OUFHpvKhiB60Fd/8n0u/d9ngD8H0HIB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sfDxwj6fjinFOh0KcN/zlpbmw3fZDmxRp+qH6gIZFTkUB3PfRvNYUDWTYLR6mbaVcREGa6KSgyNADJ5NyMhCAZv7Zd9YXstaA6l2XuTs1WS+YhFXizh7rZRlXibLaMfvMu95bhb1waAOd2CJoNVCpFu4gmuNzgzeBx+h42AVlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AmAhYbyx; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmAhYbyx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733313; x=1778269313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QeU7OJJnQc8OUFHpvKhiB60Fd/8n0u/d9ngD8H0HIB4=;
  b=AmAhYbyxJSYZzClo6cAunl/okiwfTnKiedzs1lK/wBD55ly4FOX42ffp
   DSyFcFPnWHdlwwiPj4VDW2YNFyzJ5akpfXqn44SIAwkX9eQUsHTcAm3pM
   pfpKHahvLpfegianIO4qzC0QQ50AeC8MCEZKhWKbn4IzH4T8a1c021Myc
   zDYd0L/o8tdOlANE8BlxCH6uwVtOdUcEPyBx/gJhXEMchE82SB6vwwRPt
   3dT2JaIJFfs1meP3diQTu4CeszhRIMQznatdzThm1NgsYTGXa/d3uINuR
   PokPOa8sUVmZs22h78AeKT5m28w5oZghjY0Adv12C18hD/k7vYpCR9RhH
   w==;
X-CSE-ConnectionGUID: Iwkh6svOSKeRYOORsPFdkA==
X-CSE-MsgGUID: n5bhiOhzQnaQTcYyy822xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454830"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454830"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:47 -0700
X-CSE-ConnectionGUID: +/7EeUqlTXinxf4qv2GcbQ==
X-CSE-MsgGUID: Wd+6XAYVS++xaIBFiGqAPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880897"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:46 -0700
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
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v9 19/19] mm: zswap: Batched zswap_compress() with compress batching of large folios.
Date: Thu,  8 May 2025 12:41:34 -0700
Message-Id: <20250508194134.28392-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
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

