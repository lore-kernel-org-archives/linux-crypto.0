Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AABF2D26B3;
	Wed, 30 Apr 2025 20:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046404; cv=none; b=aoB6MYZi6Chvnt2UTq3HhVv/W6Javo+xWd7yagz5QasDN4V/rVTi7tf9HXDtSDNKhaV5O3hQnCNMUrnfBM61uE9FmVsw5NTaxaSMrsF7XkRPS/vpertlsSDxuA6bsNIZ+POsRuyK3Pr7yvOq2JXPd4VcKSkIadJMGp13gGRFSsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046404; c=relaxed/simple;
	bh=AvunHsRrxVpuS1Dp2nlscgwVBY2zU8yiTAXdQyduiSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fBfTTui4FVgjTU2Kpfa4HuurTBT0YYyUT2pyi354TQ+T3m3ydBGUbeYqhaYiFIdfvDjZLVIL9djMPvXNuyDfuRHRSpn1JwS66Kb6S0pTs7NZOIQxfNR5xYGf/vgXVD7TYg11Nyccz+3v6ifPSOaMTWmW/uS2hLifDdpmGT9/jaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PQlb5FOz; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PQlb5FOz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046402; x=1777582402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AvunHsRrxVpuS1Dp2nlscgwVBY2zU8yiTAXdQyduiSQ=;
  b=PQlb5FOz66TYoleZeolSf7f2KRalF9SiH98PQ/slULwYyTOZ7uX/gUH8
   T1cRJOwDTR3Sz6o/dn6kk1zSnEFTT/L0VfKzh+FgOt1IpgZ8ZrXcexdJl
   NQi1M60JAyfWXNaRO9Jfqvw1iNAGnrK8cHomsOJW5nA8IANs371+qv4/e
   V87quvzegM/9iznoo7xyGtYqQhE5SwPgo+Tw0hS2gREYvxZsVbZu7qu1D
   KJLNkOaFG6QbfSoHpccJcqQp1SMULaGgnfO0f90MXja1lW16NStfzKbK0
   Vyx6EvxYViu/u4Q79vPRMGS8posz2ndZcdH3mQNwn+BH4V88wHahDibqW
   A==;
X-CSE-ConnectionGUID: PqNY17ZKTNaSwq379B7Y4w==
X-CSE-MsgGUID: qwrwRSPCSpCHPNUmYRE1/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388687"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388687"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:20 -0700
X-CSE-ConnectionGUID: xwuqEKmXSaOdIYE2dNDueQ==
X-CSE-MsgGUID: An8Du/lMTsqTa+0zQDAPhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248935"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:19 -0700
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
Subject: [PATCH v9 15/19] mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to deletion.
Date: Wed, 30 Apr 2025 13:53:01 -0700
Message-Id: <20250430205305.22844-16-kanchana.p.sridhar@intel.com>
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

This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
management. Similar to the per-CPU acomp_ctx itself, the per-CPU
acomp_ctx's resources' (acomp, ref, buffer) lifetime will also be from
pool creation to pool deletion. These resources will persist through CPU
hotplug operations. The zswap_cpu_comp_dead() teardown callback has been
deleted from the call to
cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
offline hotplug operations will be no-ops as far as the acomp_ctx
resources are concerned.

The main benefit of using the CPU hotplug multi state instance startup
callback to allocate the acomp_ctx resources is that it prevents the
cores from being offlined until the multi state instance addition call
returns.

  From Documentation/core-api/cpu_hotplug.rst:

    "The node list add/remove operations and the callback invocations are
     serialized against CPU hotplug operations."

Furthermore, zswap_[de]compress() cannot contend with
zswap_cpu_comp_prepare() because:

  - During pool creation/deletion, the pool is not in the zswap_pools
    list.

  - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
    out. zswap_cpu_comp_prepare() will be executed on a control CPU,
    since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
    cpuhp_state". Thanks Yosry for sharing this observation!

  In both these cases, any recursions into zswap reclaim from
  zswap_cpu_comp_prepare() will be handled by the old pool.

The above two observations enable the following simplifications:

 1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot use
    the pool. Considerations for mutex init/locking and handling
    subsequent CPU hotplug online-offlines:

    Should we lock the mutex of current CPU's acomp_ctx from start to
    end? It doesn't seem like this is required. The CPU hotplug
    operations acquire a "cpuhp_state_mutex" before proceeding, hence
    they are serialized against CPU hotplug operations.

    If the process gets migrated while zswap_cpu_comp_prepare() is
    running, it will complete on the new CPU. In case of failures, we
    pass the acomp_ctx pointer obtained at the start of
    zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
    only undergo migration. There appear to be no contention scenarios
    that might cause inconsistent values of acomp_ctx's members. Hence,
    it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
    zswap_cpu_comp_prepare().

    Since the pool is not yet on zswap_pools list, we don't need to
    initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
    has been restored to occur in zswap_cpu_comp_prepare().

    zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
    valid. If so, it returns success. This should handle any CPU
    hotplug online-offline transitions after pool creation is done.

 2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
    migrated to another CPU before the current CPU is dysfunctional. If
    zswap_[de]compress() holds the acomp_ctx->mutex lock of the offlined
    CPU, that mutex will be released once it completes on the new
    CPU. Since there is no teardown callback, there is no possibility of
    UAF.

 3) Pool creation/deletion and process migration to another CPU:

    - During pool creation/deletion, the pool is not in the zswap_pools
      list. Hence it cannot contend with zswap ops on that CPU. However,
      the process can get migrated.

      Pool creation --> zswap_cpu_comp_prepare()
                                --> process migrated:
                                    * CPU offline: no-op.
                                    * zswap_cpu_comp_prepare() continues
                                      to run on the new CPU to finish
                                      allocating acomp_ctx resources for
                                      the offlined CPU.

      Pool deletion --> acomp_ctx_dealloc()
                                --> process migrated:
                                    * CPU offline: no-op.
                                    * acomp_ctx_dealloc() continues
                                      to run on the new CPU to finish
                                      de-allocating acomp_ctx resources
                                      for the offlined CPU.

 4) Pool deletion vis-a-vis CPU onlining:
    To prevent possibility of race conditions between
    acomp_ctx_dealloc() freeing the acomp_ctx resources and the initial
    check for a valid acomp_ctx->acomp in zswap_cpu_comp_prepare(), we
    need to delete the multi state instance right after it is added, in
    zswap_pool_create().

 Summary of changes based on the above:
 --------------------------------------
 1) Zero-initialization of pool->acomp_ctx in zswap_pool_create() to
    simplify and share common code for different error handling/cleanup
    related to the acomp_ctx.

 2) Remove the node list instance right after node list add function
    call in zswap_pool_create(). This prevents race conditions between
    CPU onlining after initial pool creation, and acomp_ctx_dealloc()
    freeing the acomp_ctx resources.

 3) zswap_pool_destroy() will call acomp_ctx_dealloc() to de-allocate
    the per-CPU acomp_ctx resources.

 4) Changes to zswap_cpu_comp_prepare():

    a) Check if acomp_ctx->acomp is valid at the beginning and return,
       because the acomp_ctx is already initialized.
    b) Move the mutex_init to happen in this procedure, before it
       returns.
    c) All error conditions handled by calling acomp_ctx_dealloc().

 5) New procedure acomp_ctx_dealloc() for common error/cleanup code.

 6) No more multi state instance teardown callback. CPU offlining is a
    no-op as far as acomp_ctx resources are concerned.

 7) Delete acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock(). Directly
    call mutex_lock(&acomp_ctx->mutex)/mutex_unlock(&acomp_ctx->mutex)
    in zswap_[de]compress().

The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
offlining, and only deleting them when the pool is destroyed, is as
follows, on x86_64:

    IAA with batching: 64.8 KB
    Software compressors: 8.2 KB

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 193 +++++++++++++++++++++++++----------------------------
 1 file changed, 92 insertions(+), 101 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 358dad3e612a..238f92e63a22 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -248,43 +248,65 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
+/*
+ * The per-cpu pool->acomp_ctx is zero-initialized on allocation. This makes
+ * it easy for different error conditions/cleanup related to the acomp_ctx
+ * to be handled by acomp_ctx_dealloc():
+ * - Errors during zswap_cpu_comp_prepare().
+ * - Partial success/error of cpuhp_state_add_instance() call in
+ *   zswap_pool_create(). Only some cores could have executed
+ *   zswap_cpu_comp_prepare(), not others.
+ * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
+ */
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+{
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return;
+
+	if (!IS_ERR_OR_NULL(acomp_ctx->req))
+		acomp_request_free(acomp_ctx->req);
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		crypto_free_acomp(acomp_ctx->acomp);
+	kfree(acomp_ctx->buffer);
+}
+
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp = NULL;
-	struct acomp_req *req = NULL;
-	u8 *buffer = NULL;
-	int ret;
+	int ret = -ENOMEM;
 
-	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	/*
+	 * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
+	 * Even though we delete the multi state instance right after successful
+	 * addition of the instance in zswap_pool_create(), we cannot eliminate
+	 * the possibility of the CPU going through offline-online transitions.
+	 * If this does happen, we check if the acomp_ctx has already been
+	 * initialized, and return.
+	 */
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		return 0;
 
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp)) {
+	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffer)
+		return ret;
+
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
-		ret = PTR_ERR(acomp);
+				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
+		ret = PTR_ERR(acomp_ctx->acomp);
 		goto fail;
 	}
+	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
-	req = acomp_request_alloc(acomp);
-	if (!req) {
+	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
+	if (!acomp_ctx->req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
-		ret = -ENOMEM;
 		goto fail;
 	}
 
-	/*
-	 * Only hold the mutex after completing allocations, otherwise we may
-	 * recurse into zswap through reclaim and attempt to hold the mutex
-	 * again resulting in a deadlock.
-	 */
-	mutex_lock(&acomp_ctx->mutex);
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -292,56 +314,17 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
-	acomp_ctx->buffer = buffer;
-	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
-	acomp_ctx->req = req;
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
 fail:
-	if (acomp)
-		crypto_free_acomp(acomp);
-	kfree(buffer);
+	acomp_ctx_dealloc(acomp_ctx);
 	return ret;
 }
 
-static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct acomp_req *req;
-	struct crypto_acomp *acomp;
-	u8 *buffer;
-
-	if (IS_ERR_OR_NULL(acomp_ctx))
-		return 0;
-
-	mutex_lock(&acomp_ctx->mutex);
-	req = acomp_ctx->req;
-	acomp = acomp_ctx->acomp;
-	buffer = acomp_ctx->buffer;
-	acomp_ctx->req = NULL;
-	acomp_ctx->acomp = NULL;
-	acomp_ctx->buffer = NULL;
-	mutex_unlock(&acomp_ctx->mutex);
-
-	/*
-	 * Do the actual freeing after releasing the mutex to avoid subtle
-	 * locking dependencies causing deadlocks.
-	 */
-	if (!IS_ERR_OR_NULL(req))
-		acomp_request_free(req);
-	if (!IS_ERR_OR_NULL(acomp))
-		crypto_free_acomp(acomp);
-	kfree(buffer);
-
-	return 0;
-}
-
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
@@ -375,19 +358,43 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
-	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
+	/* Many things rely on the zero-initialization. */
+	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
+					   GFP_KERNEL | __GFP_ZERO);
 	if (!pool->acomp_ctx) {
 		pr_err("percpu alloc failed\n");
 		goto error;
 	}
 
-	for_each_possible_cpu(cpu)
-		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
-
+	/*
+	 * This is serialized against CPU hotplug operations. Hence, cores
+	 * cannot be offlined until this finishes.
+	 * In case of errors, we need to goto "ref_fail" instead of "error"
+	 * because there is no teardown callback registered anymore, for
+	 * cpuhp_state_add_instance() to de-allocate resources as it rolls back
+	 * state on cores before the CPU on which error was encountered.
+	 */
 	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
 				       &pool->node);
+
+	/*
+	 * We only needed the multi state instance add operation to invoke the
+	 * startup callback for all cores without cores getting offlined. Since
+	 * the acomp_ctx resources will now only be de-allocated when the pool
+	 * is destroyed, we can safely remove the multi state instance. This
+	 * minimizes (but does not eliminate) the possibility of
+	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
+	 * offline-online transition. Removing the instance also prevents race
+	 * conditions between CPU onlining after initial pool creation, and
+	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
+	 * Note that we delete the instance before checking the error status of
+	 * the node list add operation because we want the instance removal even
+	 * in case of errors in the former.
+	 */
+	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
 	if (ret)
-		goto error;
+		goto ref_fail;
 
 	/* being the current pool takes 1 ref; this func expects the
 	 * caller to always add the new pool as the current pool
@@ -403,7 +410,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	return pool;
 
 ref_fail:
-	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -457,9 +465,13 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 
 static void zswap_pool_destroy(struct zswap_pool *pool)
 {
+	int cpu;
+
 	zswap_pool_debug("destroying", pool);
 
-	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 	free_percpu(pool->acomp_ctx);
 
 	zpool_destroy_pool(pool->zpool);
@@ -912,31 +924,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
-static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
-{
-	struct crypto_acomp_ctx *acomp_ctx;
-
-	for (;;) {
-		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-		mutex_lock(&acomp_ctx->mutex);
-		if (likely(acomp_ctx->req))
-			return acomp_ctx;
-		/*
-		 * It is possible that we were migrated to a different CPU after
-		 * getting the per-CPU ctx but before the mutex was acquired. If
-		 * the old CPU got offlined, zswap_cpu_comp_dead() could have
-		 * already freed ctx->req (among other things) and set it to
-		 * NULL. Just try again on the new CPU that we ended up on.
-		 */
-		mutex_unlock(&acomp_ctx->mutex);
-	}
-}
-
-static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
-{
-	mutex_unlock(&acomp_ctx->mutex);
-}
-
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -949,7 +936,10 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	gfp_t gfp;
 	u8 *dst;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+
+	mutex_lock(&acomp_ctx->mutex);
+
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -997,7 +987,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -1009,7 +999,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret, dlen;
 	u8 *src, *obj;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
 	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
 
 	/*
@@ -1033,7 +1024,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	dlen = acomp_ctx->req->dlen;
 
 	zpool_obj_read_end(zpool, entry->handle, obj);
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
@@ -1849,7 +1840,7 @@ static int zswap_setup(void)
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
-				      zswap_cpu_comp_dead);
+				      NULL);
 	if (ret)
 		goto hp_fail;
 
-- 
2.27.0

