Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC841F2377;
	Sat, 21 Dec 2024 06:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762691; cv=none; b=eXDbnYhw3w2BwIvVNJlX5xDrlXuz5HBZbRM8xtQmsyQgBrkxJn8fkvZM647pCWq6dKQhDzPpZmYQiLrcoy/ot0UUru/XCq8yMP/axDKgoF8sxFdtToM254SnTDN1tYL/MwtqB5f/aCPr5JgLwTlU/ffkuJnMrVBZHYXr12wzNAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762691; c=relaxed/simple;
	bh=KPv/lIOr9UJuu1TDwAGjapkWxba0uS6X9GnVkLeTgfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WCdWCwAemrGDSqUxnzRb7De1hgnvS6LmgcU1JGVFMveSkpwd38yiDyG4D6QZPXbEA5DHmYOpyanifalHR+E8sl/5bWY0GcOpS3MetWQeO6QZUSqIDRD254vUblMOg2eS/ZksxXEcE+a4+vcriagnWB2F9ppxRBhvFSPyrWeVy4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TlnmFjtn; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TlnmFjtn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762689; x=1766298689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KPv/lIOr9UJuu1TDwAGjapkWxba0uS6X9GnVkLeTgfc=;
  b=TlnmFjtn8LsdEnX4WjcjjREbR4uvbd7UOp9bosxA/YpbJLz/llgpJVF/
   h98TnDv5MPouF48G8o9/PUuVW3lLq3Pzkf3pU5/Pswjt25VsJG1eVHhhb
   QlLjqHtS3KdVwMnHjoMTw7Uqd59VLvcFTJU2IVsEYf5Mu6F2kC1AN/9Yv
   jrQYNiuHEkyFteADCPNT5I8P2kGHsquiQfx8dALIYJEbDyV9DcCv1m6sy
   UDolzYlr8OtIwTowbu7sH8ToMIvoI4Y25sQKyLJPxdmKtlljJGKJekOm5
   TrIVZOaT9rpwupf5yFJSQRlARQDeteGYNNJwlxpjhmtVR0x1tL1ke7Z4l
   A==;
X-CSE-ConnectionGUID: NrgutftuTUS3Fyy/QVOZow==
X-CSE-MsgGUID: vAdh1tWIQPKAdPiI7pgDOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021719"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021719"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:21 -0800
X-CSE-ConnectionGUID: 7G/EcktGThmli+QGpElkYQ==
X-CSE-MsgGUID: M7yZhvoTT6i5+xSQGaVIsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184607"
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
Subject: [PATCH v5 10/12] mm: zswap: Allocate pool batching resources if the crypto_alg supports batching.
Date: Fri, 20 Dec 2024 22:31:17 -0800
Message-Id: <20241221063119.29140-11-kanchana.p.sridhar@intel.com>
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

This patch does the following:

1) Defines ZSWAP_MAX_BATCH_SIZE to denote the maximum number of acomp_ctx
   batching resources (acomp_reqs and buffers) to allocate if the zswap
   compressor supports batching. Currently, ZSWAP_MAX_BATCH_SIZE is set to
   8U.

2) Modifies the definition of "struct crypto_acomp_ctx" to represent a
   configurable number of acomp_reqs and buffers. Adds a "nr_reqs" to
   "struct crypto_acomp_ctx" to contain the number of resources that will
   be allocated in the cpu hotplug onlining code.

3) The zswap_cpu_comp_prepare() cpu onlining code will detect if the
   crypto_acomp created for the zswap pool (in other words, the zswap
   compression algorithm) has registered implementations for
   batch_compress() and batch_decompress(). If so, it will query the
   crypto_acomp for the maximum batch size supported by the compressor, and
   set "nr_reqs" to the minimum of this compressor-specific max batch size
   and ZSWAP_MAX_BATCH_SIZE. Finally, it will allocate "nr_reqs"
   reqs/buffers, and set the acomp_ctx->nr_reqs accordingly.

4) If the crypto_acomp does not support batching, "nr_reqs" defaults to 1.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 122 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 90 insertions(+), 32 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 9718c33f8192..99cd78891fd0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -78,6 +78,13 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/*
+ * For compression batching of large folios:
+ * Maximum number of acomp compress requests that will be processed
+ * in a batch, iff the zswap compressor supports batching.
+ */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -143,9 +150,10 @@ bool zswap_never_enabled(void)
 
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
@@ -818,49 +826,88 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
+		nr_reqs = min(ZSWAP_MAX_BATCH_SIZE, crypto_acomp_batch_size(acomp));
+		pr_info_once("Creating acomp_ctx with %d reqs/buffers for batching since crypto acomp\n%s has registered batch_compress() and batch_decompress().\n",
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
 	return ret;
 }
 
@@ -870,11 +917,22 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
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
@@ -897,7 +955,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -907,7 +965,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * giving the dst buffer with enough length to avoid buffer overflow.
 	 */
 	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -921,8 +979,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
+	dlen = acomp_ctx->reqs[0]->dlen;
 	if (comp_ret)
 		goto unlock;
 
@@ -975,20 +1033,20 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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

