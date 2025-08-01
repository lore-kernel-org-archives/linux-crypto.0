Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C1229B1F;
	Fri,  1 Aug 2025 04:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023025; cv=none; b=btFVU2BUeCfB5PNH/2hFmJHNtLParnrqWaiHKqOe4QulkXh+zcUpysxxzeHwup4T9x1cGjVZaxpfCh6iKPz+YgqeOXZxTVdHZBju4u0SOGt58B6uxlemHl3kG1xb8mxkhlCMM9gs/MeBdAqgZKxFMwrQLTOMHUUuZg2yMXCmLPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023025; c=relaxed/simple;
	bh=jil+A0E/m2UFmjaChcPPdJdtHRi4WRZpw0YMt+8QL7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OZyJsa+4kFOk2bsN7bQQH24xSDg+G6RKlboF7dBDcygXmTUAqTvmo+yTTMhSl82Oo3CDYk2DLaEB9ABdeYF0HNKYy/clGdDCwEhh+bPpT4leI6mu7vKFRA5ZOhkbqRt8E26AUJ8eDRg3dJIWZfHeBPHvmj0Mrutibfjf7YjbCjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbE/9pvf; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbE/9pvf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023024; x=1785559024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jil+A0E/m2UFmjaChcPPdJdtHRi4WRZpw0YMt+8QL7E=;
  b=kbE/9pvfxNjdjcMJKq84GO0mm0X+izNLqvsM0daUB90pOq4dFEdwJTDR
   Y8BdYK7vsU6hSGdxmN5S7usxL1cpAXh+x3UivevZCA24P3XfFNRRJ/b2Z
   QO581nQpH5MB5gHGPN4rier8nOtPcnlGTohQZWnxQkWqWWT5JUnfqFGUy
   jUbGBbVrMb65v0NaOBeRNTW6f4stCImCAO/IFWXrjax05HQwzQ/pSXmvl
   Y3QSS7TIgdi+ikZ7cIRQrmT5dU2+Umb7XynYQuKmzDz+8IhocGPWRyZBe
   /hg7ObFgjprHbfnJbhKbyrQJ98yM2+8M+W8EFC6AosRrYWzll6v3PiRhL
   w==;
X-CSE-ConnectionGUID: Z5pP6b+WTASI2G2ToMqCkQ==
X-CSE-MsgGUID: HyVujuQGSx6qf0OLK/eFEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820430"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820430"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: undxc/RuQGqPeYESUj16Kg==
X-CSE-MsgGUID: U4gn3gXHRz6IxpcWkGnwjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796312"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if the compressor supports batching.
Date: Thu, 31 Jul 2025 21:36:40 -0700
Message-Id: <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch sets up zswap for allocating per-CPU resources optimally for
non-batching and batching compressors.

A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
limit on the number of pages in large folios that will be batch
compressed.

As per Herbert's comments in [2] in response to the
crypto_acomp_batch_compress() and crypto_acomp_batch_decompress() API
proposed in [1], this series does not create new crypto_acomp batching
API. Instead, zswap compression batching uses the existing
crypto_acomp_compress() API in combination with the "void *kernel_data"
member added to "struct acomp_req" earlier in this series.

It is up to the compressor to manage multiple requests, as needed, to
accomplish batch parallelism. zswap only needs to allocate the per-CPU
dst buffers according to the batch size supported by the compressor.

A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
Yosry's suggestion. pool->compr_batch_size is set as the minimum of the
compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly, it
proceeds to allocate the necessary compression dst buffers in the
per-CPU acomp_ctx.

Another "u8 batch_size" member is added to "struct zswap_pool" to store
the unit for batching large folio stores: for batching compressors, this
is the pool->compr_batch_size. For non-batching compressors, this is
ZSWAP_MAX_BATCH_SIZE.

zswap does not use more than one dst buffer yet. Follow-up patches will
actually utilize the multiple acomp_ctx buffers for batch
compression/decompression of multiple pages.

Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
batching. There is a small extra memory overhead of allocating
the acomp_ctx->buffers array for compressors that do not support
batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20250508194134.28392-11-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/comment/26382610

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 82 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 19 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index efd501a7fe294..63a997b999537 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -80,6 +80,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -147,7 +150,7 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
+	u8 **buffers;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -166,6 +169,8 @@ struct zswap_pool {
 	struct work_struct release_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+	u8 compr_batch_size;
+	u8 batch_size;
 };
 
 /* Global LRU lists shared by all zswap pools. */
@@ -258,8 +263,10 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
  *   zswap_cpu_comp_prepare(), not others.
  * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
  */
-static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (IS_ERR_OR_NULL(acomp_ctx))
 		return;
 
@@ -269,7 +276,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		crypto_free_acomp(acomp_ctx->acomp);
 
-	kfree(acomp_ctx->buffer);
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
 }
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
@@ -290,6 +301,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 			return NULL;
 	}
 
+	/* Many things rely on the zero-initialization. */
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
@@ -352,13 +364,28 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 		goto ref_fail;
 	INIT_LIST_HEAD(&pool->list);
 
+	/*
+	 * Set the unit of compress batching for large folios, for quick
+	 * retrieval in the zswap_compress() fast path:
+	 * If the compressor is sequential (@pool->compr_batch_size is 1),
+	 * large folios will be compressed in batches of ZSWAP_MAX_BATCH_SIZE
+	 * pages, where each page in the batch is compressed sequentially.
+	 * We see better performance by processing the folio in batches of
+	 * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
+	 * structures.
+	 */
+	pool->batch_size = (pool->compr_batch_size > 1) ?
+				pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
+
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
 ref_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -417,7 +444,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	zswap_pool_debug("destroying", pool);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -876,6 +904,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
@@ -888,10 +917,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		return 0;
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return ret;
-
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
@@ -904,17 +929,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
 	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
+			pool->tfm_name);
 		goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
+	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					  GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffers)
+		goto fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
+						     cpu_to_node(cpu));
+		if (!acomp_ctx->buffers[i])
+			goto fail;
+	}
 
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
+	crypto_init_wait(&acomp_ctx->wait);
+
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
@@ -922,7 +966,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
 fail:
-	acomp_ctx_dealloc(acomp_ctx);
+	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
 	return ret;
 }
 
@@ -942,7 +986,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -1003,19 +1047,19 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
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
-- 
2.27.0

