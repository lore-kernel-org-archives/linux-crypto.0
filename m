Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24B318A6DD;
	Sat, 23 Nov 2024 07:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345298; cv=none; b=ZsCkP22b0FNomadxJOMLzq7uiMtgzHN3D3wqvU0zelmTKhRBThUsDj9oWjFVYGnGme/K6RFGVPFbTNBUiNpjhGg9IRSqUPKY1khH/NQRnKDrTtVr7slvwutBzvkiqz7z4P/ewWWiTbjS47gWVkk0Efc+T88clGdvR8xxit1sEqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345298; c=relaxed/simple;
	bh=7BRL3M7QAqVe3HBLgp+ukwHwPsCAsGa3NLBo+BVhcjM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XlnOO/xiT5077EWQQ+i7Mek4MHQeYZRSp62jLbg2BeHF6g6M/aSyTJfmtkXk20Cx3FqI0ZVyNtcbmCJevtqo85Neh0Iqfo6Gz/JqBE1z3PvlZ3XWkwrACUYaqXPXwXMiuZeagNMWW9M+LBhZy25uD5+w9DU2j2fgwojY3QQJp84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RpI12vWN; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RpI12vWN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345296; x=1763881296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7BRL3M7QAqVe3HBLgp+ukwHwPsCAsGa3NLBo+BVhcjM=;
  b=RpI12vWNAC6RX6jfWW0VcnM8dPSsJyFYyU9/Uvy4FAxatHuzyuOgstum
   HueWO5UrBdCUDVY6BGhX45dWbrMlqUF//PGMs/LSmz70UolQZB4m9bDPb
   OkaMkER0OMARZHeaqFHgJOIYDNaiK5RIywE+R1GBOhC3oTKExTSB14dth
   0TEoygyRT1LA7bIjygZmnKHxxFT+iKejxrX2rS2AwfF7hEGVDBHAZvfb/
   KCXtcM2Gi/sy94PNcfJAImn8LOyWmk2kIfCRg2nNGwYW+n7bd8PVcUgBp
   hhDO30LIo6m1s1qO2blV95UJppeg5/xwBKOvZtvuYtTUGAiHz+i8NOynD
   Q==;
X-CSE-ConnectionGUID: LMfbRfOZQHCtGj9EMFs0SA==
X-CSE-MsgGUID: r/wJtRRmTieb/jriAF3mYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435556"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435556"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:30 -0800
X-CSE-ConnectionGUID: osjt3+rHSjukUyKzXXPNhQ==
X-CSE-MsgGUID: lYHG2HlqS9GEU+WtlJ2VGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573571"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:29 -0800
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
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if the crypto_alg supports batching.
Date: Fri, 22 Nov 2024 23:01:26 -0800
Message-Id: <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch does the following:

1) Modifies the definition of "struct crypto_acomp_ctx" to represent a
   configurable number of acomp_reqs and buffers. Adds a "nr_reqs" to
   "struct crypto_acomp_ctx" to contain the nr of resources that will be
   allocated in the cpu onlining code.

2) The zswap_cpu_comp_prepare() cpu onlining code will detect if the
   crypto_acomp created for the pool (in other words, the zswap compression
   algorithm) has registered an implementation for batch_compress() and
   batch_decompress(). If so, it will set "nr_reqs" to
   SWAP_CRYPTO_BATCH_SIZE and allocate these many reqs/buffers, and set
   the acomp_ctx->nr_reqs accordingly. If the crypto_acomp does not support
   batching, "nr_reqs" defaults to 1.

3) Adds a "bool can_batch" to "struct zswap_pool" that step (2) will set to
   true if the batching API are present for the crypto_acomp.

SWAP_CRYPTO_BATCH_SIZE is set to 8, which will be the IAA compress batching
"sub-batch" size when zswap_batch_store() is processing a large folio. This
represents the nr of buffers that can be compressed/decompressed in
parallel by Intel IAA hardware.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/linux/zswap.h |   7 +++
 mm/zswap.c            | 120 +++++++++++++++++++++++++++++++-----------
 2 files changed, 95 insertions(+), 32 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index d961ead91bf1..9ad27ab3d222 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -7,6 +7,13 @@
 
 struct lruvec;
 
+/*
+ * For IAA compression batching:
+ * Maximum number of IAA acomp compress requests that will be processed
+ * in a batch: in parallel, if iaa_crypto async/no irq mode is enabled
+ * (the default); else sequentially, if iaa_crypto sync mode is in effect.
+ */
+#define SWAP_CRYPTO_BATCH_SIZE 8UL
 extern atomic_long_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
diff --git a/mm/zswap.c b/mm/zswap.c
index f6316b66fb23..173f7632990e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -143,9 +143,10 @@ bool zswap_never_enabled(void)
 
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
-	struct acomp_req *req;
+	struct acomp_req **reqs;
+	u8 **buffers;
+	unsigned int nr_reqs;
 	struct crypto_wait wait;
-	u8 *buffer;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -158,6 +159,7 @@ struct crypto_acomp_ctx {
  */
 struct zswap_pool {
 	struct zpool *zpool;
+	bool can_batch;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
@@ -285,6 +287,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 		goto error;
 	}
 
+	pool->can_batch = false;
+
 	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
 				       &pool->node);
 	if (ret)
@@ -818,49 +822,90 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	struct crypto_acomp *acomp;
-	struct acomp_req *req;
-	int ret;
+	unsigned int nr_reqs = 1;
+	int ret = -ENOMEM;
+	int i, j;
 
 	mutex_init(&acomp_ctx->mutex);
-
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return -ENOMEM;
+	acomp_ctx->nr_reqs = 0;
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp));
-		ret = PTR_ERR(acomp);
-		goto acomp_fail;
+		return PTR_ERR(acomp);
 	}
 	acomp_ctx->acomp = acomp;
 	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 
-	req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!req) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		ret = -ENOMEM;
+	/*
+	 * Create the necessary batching resources if the crypto acomp alg
+	 * implements the batch_compress and batch_decompress API.
+	 */
+	if (acomp_has_async_batching(acomp)) {
+		pool->can_batch = true;
+		nr_reqs = SWAP_CRYPTO_BATCH_SIZE;
+		pr_info_once("Creating acomp_ctx with %d reqs for batching since crypto acomp %s\nhas registered batch_compress() and batch_decompress()\n",
+			nr_reqs, pool->tfm_name);
+	}
+
+	acomp_ctx->buffers = kmalloc_node(nr_reqs * sizeof(u8 *), GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffers)
+		goto buf_fail;
+
+	for (i = 0; i < nr_reqs; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+		if (!acomp_ctx->buffers[i]) {
+			for (j = 0; j < i; ++j)
+				kfree(acomp_ctx->buffers[j]);
+			kfree(acomp_ctx->buffers);
+			ret = -ENOMEM;
+			goto buf_fail;
+		}
+	}
+
+	acomp_ctx->reqs = kmalloc_node(nr_reqs * sizeof(struct acomp_req *), GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->reqs)
 		goto req_fail;
+
+	for (i = 0; i < nr_reqs; ++i) {
+		acomp_ctx->reqs[i] = acomp_request_alloc(acomp_ctx->acomp);
+		if (!acomp_ctx->reqs[i]) {
+			pr_err("could not alloc crypto acomp_request reqs[%d] %s\n",
+			       i, pool->tfm_name);
+			for (j = 0; j < i; ++j)
+				acomp_request_free(acomp_ctx->reqs[j]);
+			kfree(acomp_ctx->reqs);
+			ret = -ENOMEM;
+			goto req_fail;
+		}
 	}
-	acomp_ctx->req = req;
 
+	/*
+	 * The crypto_wait is used only in fully synchronous, i.e., with scomp
+	 * or non-poll mode of acomp, hence there is only one "wait" per
+	 * acomp_ctx, with callback set to reqs[0], under the assumption that
+	 * there is at least 1 request per acomp_ctx.
+	 */
 	crypto_init_wait(&acomp_ctx->wait);
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	acomp_ctx->nr_reqs = nr_reqs;
 	return 0;
 
 req_fail:
+	for (i = 0; i < nr_reqs; ++i)
+		kfree(acomp_ctx->buffers[i]);
+	kfree(acomp_ctx->buffers);
+buf_fail:
 	crypto_free_acomp(acomp_ctx->acomp);
-acomp_fail:
-	kfree(acomp_ctx->buffer);
+	pool->can_batch = false;
 	return ret;
 }
 
@@ -870,11 +915,22 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 
 	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
+		int i;
+
+		for (i = 0; i < acomp_ctx->nr_reqs; ++i)
+			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
+				acomp_request_free(acomp_ctx->reqs[i]);
+		kfree(acomp_ctx->reqs);
+
+		for (i = 0; i < acomp_ctx->nr_reqs; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+
 		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
+
+		acomp_ctx->nr_reqs = 0;
+		acomp_ctx = NULL;
 	}
 
 	return 0;
@@ -897,7 +953,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -907,7 +963,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * giving the dst buffer with enough length to avoid buffer overflow.
 	 */
 	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -921,8 +977,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
+	dlen = acomp_ctx->reqs[0]->dlen;
 	if (comp_ret)
 		goto unlock;
 
@@ -975,20 +1031,20 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	 */
 	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
 	    !virt_addr_valid(src)) {
-		memcpy(acomp_ctx->buffer, src, entry->length);
-		src = acomp_ctx->buffer;
+		memcpy(acomp_ctx->buffers[0], src, entry->length);
+		src = acomp_ctx->buffers[0];
 		zpool_unmap_handle(zpool, entry->handle);
 	}
 
 	sg_init_one(&input, src, entry->length);
 	sg_init_table(&output, 1);
 	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
-	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, entry->length, PAGE_SIZE);
+	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->reqs[0]), &acomp_ctx->wait));
+	BUG_ON(acomp_ctx->reqs[0]->dlen != PAGE_SIZE);
 	mutex_unlock(&acomp_ctx->mutex);
 
-	if (src != acomp_ctx->buffer)
+	if (src != acomp_ctx->buffers[0])
 		zpool_unmap_handle(zpool, entry->handle);
 }
 
-- 
2.27.0

