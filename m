Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C59DDA8
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 19:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741289749; cv=none; b=u+R9KYQL8g19h5LOfh+ln5ytFU1yZ3Ezl3MLyH/aATvXG4ID9TmnY5sbY6wL4tMIFiBuQ9LUDy+WtcRLinMFafLxOP2IsriNb4yQAsLC2FWk5SZ76BfjCecdaxM1tBTxN5PM4IQxN6l5IC0MvELMvNsDOt18YPggyni90lWTZMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741289749; c=relaxed/simple;
	bh=Y5s5ZSErrIrrGSOGw5LxRxDydtyb8wWYUPhpUN1CLAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TW0kpD8gwYxZ8cHeI4U4t0VegXfpZARzbiqvJSUYgB84E4E95B/uYyE1tAJtVfJDj6Mx51jNFBTsJFdgAgJx1ETKXqUPzCWRslswXKH8zAeiMtsiA1BEmxWWBiQNtw5+rUr2gVL0f/4NvQnyUfUJr0CmlKVNaiw+yWheUyWXgCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=trpjJYtr; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="trpjJYtr"
Date: Thu, 6 Mar 2025 19:35:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741289744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xhOq4mPdbJ4tOrQue2/68LxzZIMXtFWSaq9aWhki0Ao=;
	b=trpjJYtr4lU5VzepGxwSHstSlkm+L7XLoDrNrl7cfR0ktNiv+QcKMvtrHacToIx2WXTyxE
	Dz/q3vjh2Ht9kKi1Oy/67FMkCxPWoZg5uTt3x7rkNrNlboogOvauiRrX9LxQGZSB7/fD1J
	4j/+wgZVwr1IceEDiCGLP5c5wYU9b3w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Message-ID: <Z8n5CCmELvpUwi3B@google.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 03, 2025 at 12:47:22AM -0800, Kanchana P Sridhar wrote:
> This patch modifies the acomp_ctx resources' lifetime to be from pool
> creation to deletion. A "bool __online" and "u8 nr_reqs" are added to
> "struct crypto_acomp_ctx" which simplify a few things:
> 
> 1) zswap_pool_create() will initialize all members of each percpu acomp_ctx
>    to 0 or NULL and only then initialize the mutex.
> 2) CPU hotplug will set nr_reqs to 1, allocate resources and set __online
>    to true, without locking the mutex.
> 3) CPU hotunplug will lock the mutex before setting __online to false. It
>    will not delete any resources.
> 4) acomp_ctx_get_cpu_lock() will lock the mutex, then check if __online
>    is true, and if so, return the mutex for use in zswap compress and
>    decompress ops.
> 5) CPU onlining after offlining will simply check if either __online or
>    nr_reqs are non-0, and return 0 if so, without re-allocating the
>    resources.
> 6) zswap_pool_destroy() will call a newly added zswap_cpu_comp_dealloc() to
>    delete the acomp_ctx resources.
> 7) Common resource deletion code in case of zswap_cpu_comp_prepare()
>    errors, and for use in zswap_cpu_comp_dealloc(), is factored into a new
>    acomp_ctx_dealloc().
> 
> The CPU hot[un]plug callback functions are moved to "pool functions"
> accordingly.
> 
> The per-cpu memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as follows:
> 
>     IAA with batching: 64.8 KB
>     Software compressors: 8.2 KB
> 
> I would appreciate code review comments on whether this memory cost is
> acceptable, for the latency improvement that it provides due to a faster
> reclaim restart after a CPU hotunplug-hotplug sequence - all that the
> hotplug code needs to do is to check if acomp_ctx->nr_reqs is non-0, and
> if so, set __online to true and return, and reclaim can proceed.

I like the idea of allocating the resources on memory hotplug but
leaving them allocated until the pool is torn down. It avoids allocating
unnecessary memory if some CPUs are never onlined, but it simplifies
things because we don't have to synchronize against the resources being
freed in CPU offline.

The only case that would suffer from this AFAICT is if someone onlines
many CPUs, uses them once, and then offline them and not use them again.
I am not familiar with CPU hotplug use cases so I can't tell if that's
something people do, but I am inclined to agree with this
simplification.

> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 273 +++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 182 insertions(+), 91 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 10f2a16e7586..cff96df1df8b 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -144,10 +144,12 @@ bool zswap_never_enabled(void)
>  struct crypto_acomp_ctx {
>  	struct crypto_acomp *acomp;
>  	struct acomp_req *req;
> -	struct crypto_wait wait;

Is there a reason for moving this? If not please avoid unrelated changes.

>  	u8 *buffer;
> +	u8 nr_reqs;
> +	struct crypto_wait wait;
>  	struct mutex mutex;
>  	bool is_sleepable;
> +	bool __online;

I don't believe we need this.

If we are not freeing resources during CPU offlining, then we do not
need a CPU offline callback and acomp_ctx->__online serves no purpose.

The whole point of synchronizing between offlining and
compress/decompress operations is to avoid UAF. If offlining does not
free resources, then we can hold the mutex directly in the
compress/decompress path and drop the hotunplug callback completely.

I also believe nr_reqs can be dropped from this patch, as it seems like
it's only used know when to set __online.

>  };
>  
>  /*
> @@ -246,6 +248,122 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +{
> +	if (!IS_ERR_OR_NULL(acomp_ctx) && acomp_ctx->nr_reqs) {
> +
> +		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> +			acomp_request_free(acomp_ctx->req);
> +		acomp_ctx->req = NULL;
> +
> +		kfree(acomp_ctx->buffer);
> +		acomp_ctx->buffer = NULL;
> +
> +		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +			crypto_free_acomp(acomp_ctx->acomp);
> +
> +		acomp_ctx->nr_reqs = 0;
> +	}
> +}

Please split the pure refactoring into a separate patch to make it
easier to review.

> +
> +static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)

Why is the function moved while being changed? It's really hard to see
the diff this way. If the function needs to be moved please do that
separately as well.

I also see some ordering changes inside the function (e.g. we now
allocate the request before the buffer). Not sure if these are
intentional. If not, please keep the diff to the required changes only.

> +{
> +	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> +	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +	int ret = -ENOMEM;
> +
> +	/*
> +	 * Just to be even more fail-safe against changes in assumptions and/or
> +	 * implementation of the CPU hotplug code.
> +	 */
> +	if (acomp_ctx->__online)
> +		return 0;
> +
> +	if (acomp_ctx->nr_reqs) {
> +		acomp_ctx->__online = true;
> +		return 0;
> +	}
> +
> +	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> +	if (IS_ERR(acomp_ctx->acomp)) {
> +		pr_err("could not alloc crypto acomp %s : %ld\n",
> +			pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
> +		ret = PTR_ERR(acomp_ctx->acomp);
> +		goto fail;
> +	}
> +
> +	acomp_ctx->nr_reqs = 1;
> +
> +	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> +	if (!acomp_ctx->req) {
> +		pr_err("could not alloc crypto acomp_request %s\n",
> +		       pool->tfm_name);
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->buffer) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	crypto_init_wait(&acomp_ctx->wait);
> +
> +	/*
> +	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
> +	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> +	 * won't be called, crypto_wait_req() will return without blocking.
> +	 */
> +	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				   crypto_req_done, &acomp_ctx->wait);
> +
> +	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
> +
> +	acomp_ctx->__online = true;
> +
> +	return 0;
> +
> +fail:
> +	acomp_ctx_dealloc(acomp_ctx);
> +
> +	return ret;
> +}
> +
> +static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
> +{
> +	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> +	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +
> +	mutex_lock(&acomp_ctx->mutex);
> +	acomp_ctx->__online = false;
> +	mutex_unlock(&acomp_ctx->mutex);
> +
> +	return 0;
> +}
> +
> +static void zswap_cpu_comp_dealloc(unsigned int cpu, struct hlist_node *node)
> +{
> +	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> +	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +
> +	/*
> +	 * The lifetime of acomp_ctx resources is from pool creation to
> +	 * pool deletion.
> +	 *
> +	 * Reclaims should not be happening because, we get to this routine only
> +	 * in two scenarios:
> +	 *
> +	 * 1) pool creation failures before/during the pool ref initialization.
> +	 * 2) we are in the process of releasing the pool, it is off the
> +	 *    zswap_pools list and has no references.
> +	 *
> +	 * Hence, there is no need for locks.
> +	 */
> +	acomp_ctx->__online = false;
> +	acomp_ctx_dealloc(acomp_ctx);

Since __online can be dropped, we can probably drop
zswap_cpu_comp_dealloc() and call acomp_ctx_dealloc() directly?

> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>  {
>  	struct zswap_pool *pool;
> @@ -285,13 +403,21 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>  		goto error;
>  	}
>  
> -	for_each_possible_cpu(cpu)
> -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> +	for_each_possible_cpu(cpu) {
> +		struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +
> +		acomp_ctx->acomp = NULL;
> +		acomp_ctx->req = NULL;
> +		acomp_ctx->buffer = NULL;
> +		acomp_ctx->__online = false;
> +		acomp_ctx->nr_reqs = 0;

Why is this needed? Wouldn't zswap_cpu_comp_prepare() initialize them
right away?

If it is in fact needed we should probably just use __GFP_ZERO.

> +		mutex_init(&acomp_ctx->mutex);
> +	}
>  
>  	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
>  				       &pool->node);
>  	if (ret)
> -		goto error;
> +		goto ref_fail;
>  
>  	/* being the current pool takes 1 ref; this func expects the
>  	 * caller to always add the new pool as the current pool
> @@ -307,6 +433,9 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>  	return pool;
>  
>  ref_fail:
> +	for_each_possible_cpu(cpu)
> +		zswap_cpu_comp_dealloc(cpu, &pool->node);
> +
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);

I am wondering if we can guard these by hlist_empty(&pool->node) instead
of having separate labels. If we do that we can probably make all the
cleanup calls conditional and merge this cleanup code with
zswap_pool_destroy().

Although I am not too sure about whether or not we should rely on
hlist_empty() for this. I am just thinking out loud, no need to do
anything here. If you decide to pursue this tho please make it a
separate refactoring patch.

>  error:
>  	if (pool->acomp_ctx)
> @@ -361,8 +490,13 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
>  
>  static void zswap_pool_destroy(struct zswap_pool *pool)
>  {
> +	int cpu;
> +
>  	zswap_pool_debug("destroying", pool);
>  
> +	for_each_possible_cpu(cpu)
> +		zswap_cpu_comp_dealloc(cpu, &pool->node);
> +
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
>  	free_percpu(pool->acomp_ctx);
>  
> @@ -816,85 +950,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
>  /*********************************
>  * compressed storage functions
>  **********************************/
> -static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> -{
> -	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> -	struct crypto_acomp *acomp = NULL;
> -	struct acomp_req *req = NULL;
> -	u8 *buffer = NULL;
> -	int ret;
> -
> -	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!buffer) {
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> -	if (IS_ERR(acomp)) {
> -		pr_err("could not alloc crypto acomp %s : %ld\n",
> -				pool->tfm_name, PTR_ERR(acomp));
> -		ret = PTR_ERR(acomp);
> -		goto fail;
> -	}
> -
> -	req = acomp_request_alloc(acomp);
> -	if (!req) {
> -		pr_err("could not alloc crypto acomp_request %s\n",
> -		       pool->tfm_name);
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	/*
> -	 * Only hold the mutex after completing allocations, otherwise we may
> -	 * recurse into zswap through reclaim and attempt to hold the mutex
> -	 * again resulting in a deadlock.
> -	 */
> -	mutex_lock(&acomp_ctx->mutex);
> -	crypto_init_wait(&acomp_ctx->wait);
> -
> -	/*
> -	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
> -	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> -	 * won't be called, crypto_wait_req() will return without blocking.
> -	 */
> -	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -				   crypto_req_done, &acomp_ctx->wait);
> -
> -	acomp_ctx->buffer = buffer;
> -	acomp_ctx->acomp = acomp;
> -	acomp_ctx->is_sleepable = acomp_is_async(acomp);
> -	acomp_ctx->req = req;
> -	mutex_unlock(&acomp_ctx->mutex);
> -	return 0;
> -
> -fail:
> -	if (acomp)
> -		crypto_free_acomp(acomp);
> -	kfree(buffer);
> -	return ret;
> -}
> -
> -static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
> -{
> -	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> -
> -	mutex_lock(&acomp_ctx->mutex);
> -	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -			acomp_request_free(acomp_ctx->req);
> -		acomp_ctx->req = NULL;
> -		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> -			crypto_free_acomp(acomp_ctx->acomp);
> -		kfree(acomp_ctx->buffer);
> -	}
> -	mutex_unlock(&acomp_ctx->mutex);
> -
> -	return 0;
> -}
>  
>  static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
>  {
> @@ -902,16 +957,52 @@ static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
>  
>  	for (;;) {
>  		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
> -		mutex_lock(&acomp_ctx->mutex);
> -		if (likely(acomp_ctx->req))
> -			return acomp_ctx;
>  		/*
> -		 * It is possible that we were migrated to a different CPU after
> -		 * getting the per-CPU ctx but before the mutex was acquired. If
> -		 * the old CPU got offlined, zswap_cpu_comp_dead() could have
> -		 * already freed ctx->req (among other things) and set it to
> -		 * NULL. Just try again on the new CPU that we ended up on.
> +		 * If the CPU onlining code successfully allocates acomp_ctx resources,
> +		 * it sets acomp_ctx->__online to true. Until this happens, we have
> +		 * two options:
> +		 *
> +		 * 1. Return NULL and fail all stores on this CPU.
> +		 * 2. Retry, until onlining has finished allocating resources.
> +		 *
> +		 * In theory, option 1 could be more appropriate, because it
> +		 * allows the calling procedure to decide how it wants to handle
> +		 * reclaim racing with CPU hotplug. For instance, it might be Ok
> +		 * for compress to return an error for the backing swap device
> +		 * to store the folio. Decompress could wait until we get a
> +		 * valid and locked mutex after onlining has completed. For now,
> +		 * we go with option 2 because adding a do-while in
> +		 * zswap_decompress() adds latency for software compressors.
> +		 *
> +		 * Once initialized, the resources will be de-allocated only
> +		 * when the pool is destroyed. The acomp_ctx will hold on to the
> +		 * resources through CPU offlining/onlining at any time until
> +		 * the pool is destroyed.
> +		 *
> +		 * This prevents races/deadlocks between reclaim and CPU acomp_ctx
> +		 * resource allocation that are a dependency for reclaim.
> +		 * It further simplifies the interaction with CPU onlining and
> +		 * offlining:
> +		 *
> +		 * - CPU onlining does not take the mutex. It only allocates
> +		 *   resources and sets __online to true.
> +		 * - CPU offlining acquires the mutex before setting
> +		 *   __online to false. If reclaim has acquired the mutex,
> +		 *   offlining will have to wait for reclaim to complete before
> +		 *   hotunplug can proceed. Further, hotplug merely sets
> +		 *   __online to false. It does not delete the acomp_ctx
> +		 *   resources.
> +		 *
> +		 * Option 1 is better than potentially not exiting the earlier
> +		 * for (;;) loop because the system is running low on memory
> +		 * and/or CPUs are getting offlined for whatever reason. At
> +		 * least failing this store will prevent data loss by failing
> +		 * zswap_store(), and saving the data in the backing swap device.
>  		 */

I believe we can dropped. I don't think we can have any store/load
operations on a CPU before it's fully onlined, and we should always have
a reference on the pool here, so the resources cannot go away.

So unless I missed something we can drop this completely now and just
hold the mutex directly in the load/store paths.

> +		mutex_lock(&acomp_ctx->mutex);
> +		if (likely(acomp_ctx->__online))
> +			return acomp_ctx;
> +
>  		mutex_unlock(&acomp_ctx->mutex);
>  	}
>  }
> -- 
> 2.27.0
> 
