Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E6B1F2C51;
	Sat, 21 Dec 2024 06:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762692; cv=none; b=MsH+3Z4Hg7HttcEzGas2xZXFTdYZiwTLd6KI3q3VpEGkNIZX4yUaIMNa0BJV6RoPUg4pBseItsKrPvXRPVnGXhaymlv4rcFJ9pg29t5HVevCFKrvQi4mSMicQe1V+NLsn5mzt/HTFyWQNzXMg8f1SOKd7N02GHUZmAWVUuZikhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762692; c=relaxed/simple;
	bh=OMiXITVf1zg7CemO/j63XZqQRFVNfoKOofrwr8FdVdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p6CYp5bklxJ5XBSzi3KwSdODPO0C+dty0zlLPJSPX0nmU7R2tfwhx7IuCq3/fjNSM2dizpfiyUY4jV8dKZp2iTm7msDXzuO+qKRaO9BdlltyEz1Y8KBwocpz7voD/RQVVl2mWpXIB6Xl5bGWTfJ3LxH/37CFEJo7odeA//BNtbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YKOdtHZR; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YKOdtHZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762690; x=1766298690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OMiXITVf1zg7CemO/j63XZqQRFVNfoKOofrwr8FdVdM=;
  b=YKOdtHZRhsbW0msLWY6OzlVf3hSiDtLTBKR7X6dMdQe0l0JYbulxsFs7
   E1SrS/S48xy+leEPPKaG+F6BUzezt5Z+y2blAff6gg/nzdlRGbrKrVqWo
   mdQkXvMWPtRukXAE0fr8JcrLvITW/DIFTofV3SmZb858PjrdwOnMi6xDP
   pVMD2eySylcUU1fCSmtKtj8dVuIaRffLY5W0FXmptADs9NJFvufm/1zEY
   +JVw+WzSvoOfa4f5Bw60bC5SIDWarRMMKbSKFjG1T45jzAO5Vt1/jQ0WF
   abb/pwdH3t258Ast83LoeDGKbooDbmmyQB+DLkpNO/EI0JWExlZq/bnmf
   g==;
X-CSE-ConnectionGUID: wTyED2RPSUSxrJAwLPBUQg==
X-CSE-MsgGUID: dicAFlLRStaXz5FUALnQ0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021743"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021743"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:21 -0800
X-CSE-ConnectionGUID: 0Yaxj/qcRrSccQi1sf6c2A==
X-CSE-MsgGUID: 1hw2SbHQRge/3biOVZBL3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184613"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:21 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
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
Subject: [PATCH v5 12/12] mm: zswap: Compress batching with Intel IAA in zswap_store() of large folios.
Date: Fri, 20 Dec 2024 22:31:19 -0800
Message-Id: <20241221063119.29140-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zswap_compress_folio() is modified to detect if the pool's acomp_ctx has
more than one "nr_reqs", which will be the case if the cpu onlining code
has allocated batching resources in the acomp_ctx based on the queries to
acomp_has_async_batching() and crypto_acomp_batch_size(). If multiple
"nr_reqs" are available in the acomp_ctx, it means compress batching can be
used with a batch-size of "acomp_ctx->nr_reqs".

If compress batching can be used with the given zswap pool,
zswap_compress_folio() will invoke the newly added zswap_batch_compress()
procedure to compress and store the folio in batches of
"acomp_ctx->nr_reqs" pages. The batch size is effectively
"acomp_ctx->nr_reqs".

zswap_batch_compress() calls crypto_acomp_batch_compress() to compress each
batch of (up to) "acomp_ctx->nr_reqs" pages. The iaa_crypto driver
will compress each batch of pages in parallel in the Intel IAA hardware
with 'async' mode and request chaining.

Hence, zswap_batch_compress() does the same computes for a batch, as
zswap_compress() does for a page; and returns true if the batch was
successfully compressed/stored, and false otherwise.

If the pool does not support compress batching, zswap_compress_folio()
calls zswap_compress() for each individual page in the folio, as before.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1be0f1807bfc..f336fafe24c4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1467,17 +1467,118 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
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
+	mutex_lock(&acomp_ctx->mutex);
+
+	/*
+	 * Batch compress @nr_batch_pages. If IAA is the compressor, the
+	 * hardware will compress @nr_batch_pages in parallel.
+	 */
+	ret = crypto_acomp_batch_compress(
+		acomp_ctx->reqs,
+		&acomp_ctx->wait,
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
+	mutex_unlock(&acomp_ctx->mutex);
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
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	batch_size = acomp_ctx->nr_reqs;
 
-		if (!zswap_compress(page, entries[index], pool))
-			return false;
+	if ((batch_size > 1) && (nr_pages > 1)) {
+		for (index = 0; index < nr_pages; index += batch_size) {
+
+			if (!zswap_batch_compress(folio, index, batch_size,
+						  &entries[index], pool, acomp_ctx))
+				return false;
+		}
+	} else {
+		for (index = 0; index < nr_pages; ++index) {
+			struct page *page = folio_page(folio, index);
+
+			if (!zswap_compress(page, entries[index], pool))
+				return false;
+		}
 	}
 
 	return true;
-- 
2.27.0

