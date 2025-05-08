Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE0628DB71;
	Thu,  8 May 2025 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733314; cv=none; b=k+z2Ueer/+/QUKTluVVQJ9kwtbYBJWBG4ZQagMUZFeG7hVlifqQzbI/fWo03hVLtwH6fFlaW3wvpR53s0pHwyCrJJ9+I4N7cubjTFlu3HDMkpOM6KHOggfRuUP4jbl+oC75cWYgKUXuldYLAfYwMaFfmQ4uVwTz8dAly7AFPnEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733314; c=relaxed/simple;
	bh=n8lZ8yIQmOM0rAWlBzDxJH5i5KHCUMbDeeth3crBxmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieq7NiZWsDSIpgPxEdR/HCa7zlOot9hkW0KDVaB0uqDmSaMT4O8lVkGaRHCBC9Q4itTEajUFVoBj5jlCtVeEorB8IRwG3hSmVDQJuNTivYP2sPxP5tzYR4RdQpRNdhTQtD1bJInSLhV1y5h6tziSkphCyePgGG0uc69JMOp8qQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HM+EFUZN; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HM+EFUZN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733312; x=1778269312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n8lZ8yIQmOM0rAWlBzDxJH5i5KHCUMbDeeth3crBxmU=;
  b=HM+EFUZNwx1pKC9L9WYmc3LiHwXum1Yhh/v3TI1nnq8gwY/ZwCuXJNLa
   iYEsPepDS5ndeQp+AYa1VOBe0eFbPDGjtnoBUB+D6ydUziw15MQmkmRFC
   /QCO4BGLA6CmTNww3IRQIaxSD1X/H0DExbMv98SILF7MUFIlyfa1Ucfbg
   M4r9u8RMMCBGFetxrWB6nCjvjBtSDKDFhYxKU11lNOS+UMzFAgDuE7IoZ
   iHs+B1NRfta+xYwk588cgZuj4fHxraQGRQ1rXWxVYXSXMemmFEZhd0x3l
   IXc+MCo3xdIwPv+mZi2AFeUseSs0b25cwPa5modMJCAfQ+JZ94lre7nto
   g==;
X-CSE-ConnectionGUID: Te1bS9JqRxOUEFWvx1Q4Yg==
X-CSE-MsgGUID: ArBioeE8SZe9bx20swFffw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454802"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454802"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:46 -0700
X-CSE-ConnectionGUID: JNac+pJqSR2ieo5YOFySZg==
X-CSE-MsgGUID: /Dyhs7OhRjqMEzCE7Ai2Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880890"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:45 -0700
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
Subject: [PATCH v9 17/19] mm: zswap: Allocate pool batching resources if the compressor supports batching.
Date: Thu,  8 May 2025 12:41:32 -0700
Message-Id: <20250508194134.28392-18-kanchana.p.sridhar@intel.com>
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

This patch adds support for the per-CPU acomp_ctx to track multiple
compression/decompression requests and multiple compression destination
buffers. zswap_cpu_comp_prepare() will get the maximum batch-size the
compressor supports. If so, it will allocate the necessary batching
resources (reqs/buffers), up to ZSWAP_MAX_BATCH_SIZE, which this patch
defines as 8U.

This patch also adds a "u8 nr_reqs" member to "struct
zswap_pool". Thanks Yosry for this suggestion. Once the pool's per-CPU
acomp_ctx resources have been successfully allocated, the pool->nr_reqs
is set up as the minimum of ZSWAP_MAX_BATCH_SIZE and
crypto_acomp_batch_size(acomp_ctx->acomp).

However, zswap does not use more than one request yet. Follow-up patches
will actually utilize the multiple acomp_ctx requests/buffers for batch
compression/decompression of multiple pages.

The newly added ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory
used for batching. There is a small extra memory overhead of allocating
the "reqs" and "buffers" arrays for compressors that do not support
batching: On x86_64, the overhead is two pointers per-CPU (i.e. 16 bytes).

Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 113 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 32 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 717835f214b2..2273dbfd460f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -80,6 +80,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for reqs and buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -145,9 +148,9 @@ bool zswap_never_enabled(void)
 
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
-	struct acomp_req *req;
+	struct acomp_req **reqs;
+	u8 **buffers;
 	struct crypto_wait wait;
-	u8 *buffer;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -166,6 +169,7 @@ struct zswap_pool {
 	struct work_struct release_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+	u8 nr_reqs;
 };
 
 /* Global LRU lists shared by all zswap pools. */
@@ -258,16 +262,29 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
  *   zswap_cpu_comp_prepare(), not others.
  * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
  */
-static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_reqs)
 {
+	u8 i;
+
 	if (IS_ERR_OR_NULL(acomp_ctx))
 		return;
 
-	if (!IS_ERR_OR_NULL(acomp_ctx->req))
-		acomp_request_free(acomp_ctx->req);
+	if (acomp_ctx->reqs) {
+		for (i = 0; i < nr_reqs; ++i) {
+			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
+				acomp_request_free(acomp_ctx->reqs[i]);
+		}
+		kfree(acomp_ctx->reqs);
+	}
+
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		crypto_free_acomp(acomp_ctx->acomp);
-	kfree(acomp_ctx->buffer);
+
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_reqs; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
 }
 
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
@@ -275,6 +292,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int ret = -ENOMEM;
+	u8 i, nr_reqs = 0;
 
 	/*
 	 * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
@@ -287,10 +305,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		return 0;
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return ret;
-
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
@@ -300,33 +314,58 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	}
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
+	nr_reqs = min(ZSWAP_MAX_BATCH_SIZE,
+		      crypto_acomp_batch_size(acomp_ctx->acomp));
+
+	acomp_ctx->buffers = kcalloc_node(nr_reqs, sizeof(u8 *),
+					  GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffers)
 		goto fail;
+
+	for (i = 0; i < nr_reqs; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
+						     cpu_to_node(cpu));
+		if (!acomp_ctx->buffers[i])
+			goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
+	acomp_ctx->reqs = kcalloc_node(nr_reqs, sizeof(struct acomp_req *),
+				       GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->reqs)
+		goto fail;
+
+	for (i = 0; i < nr_reqs; ++i) {
+		acomp_ctx->reqs[i] = acomp_request_alloc(acomp_ctx->acomp);
+		if (IS_ERR_OR_NULL(acomp_ctx->reqs[i])) {
+			pr_err("could not alloc crypto acomp_request reqs[%d] %s\n",
+				i, pool->tfm_name);
+			goto fail;
+		}
+	}
 
 	/*
+	 * All calls to crypto_acomp_[de]compress() from zswap will use
+	 * acomp_ctx->reqs[0] with acomp_ctx->wait.
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
-	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	crypto_init_wait(&acomp_ctx->wait);
+
+	acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
 	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
 fail:
-	acomp_ctx_dealloc(acomp_ctx);
+	acomp_ctx_dealloc(acomp_ctx, nr_reqs);
 	return ret;
 }
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
+	struct crypto_acomp_ctx *acomp_ctx;
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
@@ -343,6 +382,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 			return NULL;
 	}
 
+	/* Many things rely on the zero-initialization. */
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
@@ -393,9 +433,18 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	 */
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
+	/*
+	 * If there was an error in adding the multi instance state, the
+	 * zero-initialized pool->nr_reqs value will be accurate for passing to
+	 * acomp_ctx_dealloc().
+	 */
 	if (ret)
 		goto ref_fail;
 
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	pool->nr_reqs = min(ZSWAP_MAX_BATCH_SIZE,
+			    crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	/* being the current pool takes 1 ref; this func expects the
 	 * caller to always add the new pool as the current pool
 	 */
@@ -411,7 +460,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 
 ref_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu), pool->nr_reqs);
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -470,7 +519,7 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	zswap_pool_debug("destroying", pool);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu), pool->nr_reqs);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -940,7 +989,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -950,7 +999,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * giving the dst buffer with enough length to avoid buffer overflow.
 	 */
 	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -964,8 +1013,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
+	dlen = acomp_ctx->reqs[0]->dlen;
 	if (comp_ret)
 		goto unlock;
 
@@ -1001,27 +1050,27 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
-	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
+	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffers[0]);
 
 	/*
 	 * zpool_obj_read_begin() might return a kmap address of highmem when
-	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
-	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
+	 * acomp_ctx->buffers[0] is not used.  However, sg_init_one() does not
+	 * handle highmem addresses, so copy the object to acomp_ctx->buffers[0].
 	 */
 	if (virt_addr_valid(obj)) {
 		src = obj;
 	} else {
-		WARN_ON_ONCE(obj == acomp_ctx->buffer);
-		memcpy(acomp_ctx->buffer, obj, entry->length);
-		src = acomp_ctx->buffer;
+		WARN_ON_ONCE(obj == acomp_ctx->buffers[0]);
+		memcpy(acomp_ctx->buffers[0], obj, entry->length);
+		src = acomp_ctx->buffers[0];
 	}
 
 	sg_init_one(&input, src, entry->length);
 	sg_init_table(&output, 1);
 	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, entry->length, PAGE_SIZE);
+	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
+	dlen = acomp_ctx->reqs[0]->dlen;
 
 	zpool_obj_read_end(zpool, entry->handle, obj);
 	mutex_unlock(&acomp_ctx->mutex);
-- 
2.27.0

