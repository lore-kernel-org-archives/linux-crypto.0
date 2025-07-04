Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A749525D8E6;
	Fri,  4 Jul 2025 04:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751603029; cv=none; b=GHHpv3nzENS+4gpk/6VcYuxcg+Zr0BRAhZXi1g/3g54mlRyHrTXiAkkUPvRZ6oX0mC3eMJVsvO6/GGMh4WV4HFo1226jUOsdWRyo/8eZjNN7X6tOpFyVrwGogipS7b21UK9CrvKNwqKaPg+OsD1Swfm7ZFXHOIa4Myh0cUQaNn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751603029; c=relaxed/simple;
	bh=R1GmBfu/8AZsPGpw9Llp7HaStu54DlDLoyZUH7aNHgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kU9hMylnUnD9FiHhLAwcCtHIODUY820DtkVN0baIKp7jhUEY6UTfppZQJy+TyoKgD/h6FfTSjrVk5RgMdzam7mIWenxVn9YA1nEyX14gjeCwHHHuG45qP/IibUuOb4xmE3vSS/Rro5sGr3NQUCdgnsGHRj53TXMFTYPKy08irRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F/zArubT; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F/zArubT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751603027; x=1783139027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R1GmBfu/8AZsPGpw9Llp7HaStu54DlDLoyZUH7aNHgM=;
  b=F/zArubTVASp7ruzu7jUEROtEQN4XW2q6a09z5RW8BhmqPG+/qU8uzO4
   TnzDcuhnNEOiCy2Cgq7bebag5v0S0nLpajkmFuO81b3LXHuqXdyt6MrZc
   ts8ahBYQRJmOtj0uTh5k/Pt4vS24EhvvN1BDZiZGo3sJkQQ55x3WyVgav
   yOlHxE+egN9Jq5ZpdBr0k7t/Em8IZ41s9da17HPK2CAtps3NRQLsTBwvT
   7sVdnTA51bBuRwC60HcDWoPUYuvQVufbOP4bbFq3hulz0MUG8yr9dKILc
   RFRYZR9NxHEDLCM10rCk94r5siLvgAiyjh44UmLMSf+vvbvihdoHvLbc4
   Q==;
X-CSE-ConnectionGUID: hh3jnn8fTCml2rDzyfffXw==
X-CSE-MsgGUID: 7krfmPZhS1iyq/i2ClDesA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53909280"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53909280"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:23:28 -0700
X-CSE-ConnectionGUID: GusJRaPeQ4exj5GVhw1oAQ==
X-CSE-MsgGUID: cE8wGGuBSz6b+pNbaPBRag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="153968738"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2025 21:23:28 -0700
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
Subject: [PATCH v10 25/25] mm: zswap: Batched zswap_compress() with compress batching of large folios.
Date: Thu,  3 Jul 2025 21:23:23 -0700
Message-Id: <20250704042323.10318-26-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
References: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
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

If the compressor supports batching, for e.g., 'deflate-iaa', the Intel
IAA hardware accelerator, the batch is compressed in parallel in
hardware by setting the acomp_ctx->req->kernel_data to contain the
necessary batching data before calling crypto_acomp_compress(). If all
requests in the batch are compressed without errors, the compressed
buffers are then stored in zpool.

Another important change this patch makes is with the acomp_ctx mutex
locking in zswap_compress(). Earlier, the mutex was held per page's
compression. With the new code, [un]locking the mutex per page caused
regressions for software compressors when testing with usemem
(30 processes) and also kernel compilation with 'allmod' config. The
regressions were more eggregious when PMD folios were stored. The
implementation in this commit locks/unlocks the mutex once per batch,
that resolves the regression.

The use of prefetchw() for zswap entries and likely()/unlikely()
annotations prevent regressions with software compressors like zstd, and
generally improve non-batching compressors' performance with the
batching code by ~3%.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/swap.h  |  23 ++++++
 mm/zswap.c | 201 ++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 168 insertions(+), 56 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 911ad5ff0f89f..2afbf00f59fea 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -11,6 +11,29 @@ extern int page_cluster;
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
+/* linux/mm/zswap.c */
+/*
+ * A compression algorithm that wants to batch compressions/decompressions
+ * must define its own internal data structures that exactly mirror
+ * @struct swap_batch_comp_data and @struct swap_batch_decomp_data.
+ */
+struct swap_batch_comp_data {
+	struct page **pages;
+	u8 **dsts;
+	unsigned int *dlens;
+	int *errors;
+	u8 nr_comps;
+};
+
+struct swap_batch_decomp_data {
+	u8 **srcs;
+	struct page **pages;
+	unsigned int *slens;
+	unsigned int *dlens;
+	int *errors;
+	u8 nr_decomps;
+};
+
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
diff --git a/mm/zswap.c b/mm/zswap.c
index e8a9b8ef65b93..b3c2a287610f9 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -35,6 +35,7 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/list_lru.h>
+#include <linux/prefetch.h>
 
 #include "swap.h"
 #include "internal.h"
@@ -988,71 +989,163 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+/*
+ * Unified code path for compressors that do and do not support batching. This
+ * procedure will compress multiple @nr_pages in @folio starting from the
+ * @start index.
+ *
+ * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
+ * sure of this by design.
+ *
+ * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
+ * support batching.
+ *
+ * If @pool->compr_batch_size is 1, each page is processed sequentially.
+ *
+ * If @pool->compr_batch_size is > 1, compression batching is invoked, except if
+ * @nr_pages is 1: if so, we call the fully synchronous non-batching
+ * crypto_acomp API.
+ *
+ * In both cases, if all compressions are successful, the compressed buffers
+ * are stored in zpool.
+ *
+ * A few important changes made to not regress and in fact improve
+ * compression performance with non-batching software compressors, using this
+ * new/batching code:
+ *
+ * 1) acomp_ctx mutex locking:
+ *    Earlier, the mutex was held per page compression. With the new code,
+ *    [un]locking the mutex per page caused regressions for software
+ *    compressors. We now lock the mutex once per batch, which resolves the
+ *    regression.
+ *
+ * 2) The prefetchw() and likely()/unlikely() annotations prevent
+ *    regressions with software compressors like zstd, and generally improve
+ *    non-batching compressors' performance with the batching code by ~3%.
+ */
+static bool zswap_compress(struct folio *folio, long start, unsigned int nr_pages,
+			   struct zswap_entry *entries[], struct zswap_pool *pool,
+			   int node_id)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
-	unsigned long handle;
-	struct zpool *zpool;
+	struct zpool *zpool = pool->zpool;
+
+	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
+	int errors[ZSWAP_MAX_BATCH_SIZE];
+
+	unsigned int nr_comps = min(nr_pages, pool->compr_batch_size);
+	unsigned int i, j;
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
+	 *     index into the folio pages, @entries and @errors.
 	 */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	for (i = 0; i < nr_pages; i += nr_comps) {
+		if (nr_comps == 1) {
+			sg_init_table(&input, 1);
+			sg_set_page(&input, folio_page(folio, start + i), PAGE_SIZE, 0);
 
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
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-	if (comp_ret)
-		goto unlock;
+			/*
+			 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
+			 * and hardware-accelerators may won't check the dst buffer size, so
+			 * giving the dst buffer with enough length to avoid buffer overflow.
+			 */
+			sg_init_one(&output, acomp_ctx->buffers[0], PAGE_SIZE * 2);
+			acomp_request_set_params(acomp_ctx->req, &input,
+						 &output, PAGE_SIZE, PAGE_SIZE);
+
+			errors[i] = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+						    &acomp_ctx->wait);
+			if (unlikely(errors[i]))
+				goto compress_error;
+
+			dlens[i] = acomp_ctx->req->dlen;
+		} else {
+			struct page *pages[ZSWAP_MAX_BATCH_SIZE];
+			unsigned int k;
+
+			for (k = 0; k < nr_pages; ++k)
+				pages[k] = folio_page(folio, start + k);
+
+			struct swap_batch_comp_data batch_comp_data = {
+				.pages = pages,
+				.dsts = acomp_ctx->buffers,
+				.dlens = dlens,
+				.errors = errors,
+				.nr_comps = nr_pages,
+			};
+
+			acomp_ctx->req->kernel_data = &batch_comp_data;
+
+			if (unlikely(crypto_acomp_compress(acomp_ctx->req)))
+				goto compress_error;
+		}
 
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
+		/*
+		 * All @nr_comps pages were successfully compressed.
+		 * Store the pages in zpool.
+		 *
+		 * Note:
+		 * [j] refers to the incoming batch space and is used to
+		 *     index into the folio pages, @entries, @dlens and @errors.
+		 * [k] refers to the @acomp_ctx space, as determined by
+		 *     @pool->compr_batch_size, and is used to index into
+		 *     @acomp_ctx->buffers.
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
+			err = zpool_malloc(zpool, dlens[j], gfp, &handle, node_id);
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
+			zpool_obj_write(zpool, handle, acomp_ctx->buffers[k], dlens[j]);
+			entries[j]->handle = handle;
+			entries[j]->length = dlens[j];
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
@@ -1590,12 +1683,8 @@ static bool zswap_store_pages(struct folio *folio,
 		INIT_LIST_HEAD(&entries[i]->lru);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		struct page *page = folio_page(folio, start + i);
-
-		if (!zswap_compress(page, entries[i], pool))
-			goto store_pages_failed;
-	}
+	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, pool, node_id)))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		struct zswap_entry *old, *entry = entries[i];
-- 
2.27.0

