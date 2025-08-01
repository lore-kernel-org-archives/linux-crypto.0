Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDAC1F03F3;
	Fri,  1 Aug 2025 04:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023024; cv=none; b=b1nsIcETdd0Z+gh+ur8clIAX6TLvEoFJt2huZt9V68BXYbrLz/vbGlgd7x8eat/6D55+/aYbLqeWzUbvkLFzMwbmpx4ZQSIH1KFORv0uYqvPaqHlKgufoerkPg3kr0jG7oN41Wq3+it51OoSz9qFPaH0dbisnjHIgYCCqgVcWlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023024; c=relaxed/simple;
	bh=qTMMs1qHpqZx0vXDoWue7AAa9wyxuWEhxcUxCOVhNzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j7ZcB3CaQfpY9zjzwbSgfZr1fwAi8m1fJuuDb5GBPkFybp+H+oaxIoEsx4+kfYRkUqt5LQl3E5+TuSGG+e5Rdlx4O3ued94j02JfzQV/vxeRzFIM+1KGS01Jvko5N5AO8+zwlZKbF7aVvb+Y1LCTJE7kYgY49HcuzLohVVNkOyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BYmg1WjH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BYmg1WjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023021; x=1785559021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qTMMs1qHpqZx0vXDoWue7AAa9wyxuWEhxcUxCOVhNzc=;
  b=BYmg1WjHNMRM1jzRdCwxIhBM+DkIUDRM7Lj3rT/hKg1BY7ovVCgbQYM8
   eAAOOSe+FBI/dcZedrBPtbt3wlUWReAFNpWQQ/DBN74mLVPtHE1MxNk0S
   oY2bzkcXrt1zNJbP7rXlWeMKyqbkvI3O62237Um+9670k2x78jcT6Vzoe
   HwiDXdjd5L1wl9Pm3vHrFkoBOrcTKnLL+dt2xCjSerK9LsED/peHujT2P
   d3Zfpt5SYc/s8qK8gkxsLoiTXRWLZOznhxURkdNsU7nEjOJ/hdjNnoAJS
   DnNZKIw/lg1sdN9h3fV5SFJPni7EowX6EvwhHTiMtF2nbyW6dX/9sh3Gd
   Q==;
X-CSE-ConnectionGUID: 11ARXoXwQhKURdHF73qP7g==
X-CSE-MsgGUID: 90zKA8xwSjixwlw1H+idGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820402"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820402"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: TmfHQR/7R9yFNLs7v0pLcQ==
X-CSE-MsgGUID: ELovNzY/QKaF/ubEq87JGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796304"
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
Subject: [PATCH v11 20/24] mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to deletion.
Date: Thu, 31 Jul 2025 21:36:38 -0700
Message-Id: <20250801043642.8103-21-kanchana.p.sridhar@intel.com>
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

This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
management. Similar to the per-CPU acomp_ctx itself, the per-CPU
acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
pool creation to pool deletion. These resources will persist through CPU
hotplug operations. The zswap_cpu_comp_dead() teardown callback has been
deleted from the call to
cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
offline hotplug operations will be no-ops as far as the acomp_ctx
resources are concerned.

This commit refactors the code from zswap_cpu_comp_dead() into a
new function acomp_ctx_dealloc() that preserves the IS_ERR_OR_NULL()
checks on acomp_ctx, req and acomp from the existing mainline
implementation of zswap_cpu_comp_dead(). acomp_ctx_dealloc() is called
to clean up acomp_ctx resources from all these procedures:

1) zswap_cpu_comp_prepare() when an error is encountered,
2) zswap_pool_create() when an error is encountered, and
3) from zswap_pool_destroy().

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

    IAA with 8 dst buffers for batching:    64.34 KB
    Software compressors with 1 dst buffer:  8.28 KB

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 195 ++++++++++++++++++++++++++---------------------------
 1 file changed, 94 insertions(+), 101 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3c0fd8a137182..7970bd67f0109 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -248,6 +248,30 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
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
+
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		crypto_free_acomp(acomp_ctx->acomp);
+
+	kfree(acomp_ctx->buffer);
+}
+
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
@@ -281,19 +305,43 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 
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
@@ -309,7 +357,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	return pool;
 
 ref_fail:
-	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -363,9 +412,13 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 
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
@@ -822,39 +875,39 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
@@ -862,81 +915,17 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
@@ -949,7 +938,10 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
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
@@ -997,7 +989,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -1009,7 +1001,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret, dlen;
 	u8 *src, *obj;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
 	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
 
 	/*
@@ -1033,7 +1026,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	dlen = acomp_ctx->req->dlen;
 
 	zpool_obj_read_end(zpool, entry->handle, obj);
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
@@ -1846,7 +1839,7 @@ static int zswap_setup(void)
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
-				      zswap_cpu_comp_dead);
+				      NULL);
 	if (ret)
 		goto hp_fail;
 
-- 
2.27.0

