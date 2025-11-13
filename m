Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC1F2877F2
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 20:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763065477; cv=none; b=pWxLSvrRMMjGrvzGwtl8jHpGgq7M8luHkfmVG9v5CrXrPRbyeQ9IbcEExOvMngR/cqXQapsaDAc5cY0WGvwaaXqRXXKJxmCs2duaXojFaMYvEB37f7bVDaixbCvD+ffjpDGDknFVEdVppIZtxSKZaTyXjJur+8vv0itCrBvW8Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763065477; c=relaxed/simple;
	bh=/Z23KZhqEvpPjVvhZY15umJCo3I1rmdSkkLyALi9p4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4UlxMkhLNE2JbWwJiw9weH5s5objHX1ya/v5oETAyuLA+njEfkTzezBLjfC+PcNoIXUoioV7hdMruUZhP9Bgqm6I7h/RtdzknWEnXqX/jXf5eAHGfoguBRJfDYHCGZ+OSuH0MEmOvnAvWJaLyqmw/DEr6SwbwfqkcNaS9Oa6ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xqfxIfOF; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xqfxIfOF"
Date: Thu, 13 Nov 2025 20:24:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763065473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jT/ew4lyAZdjduPWOHcjteBKICf50dJTobZNEHLjS+A=;
	b=xqfxIfOFHqlzr4bODDqrWDXl7d/V2JzDrkJAG4mfkCMBnhYeRFqhwKuPehPQpRLWMRclII
	7R4a9RIYL/T32vumS+yVYWmSGtn7QM2CwNMi5RQqY0u47JIOV75F59VN6lZXt+/m5ha1Rx
	8rrmNCD7B6LUgs0MY862IxYraVu/2jo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:

The subject can be shortened to:

"mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"

> This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> pool creation to pool deletion. These resources will persist through CPU
> hotplug operations instead of being destroyed/recreated. The
> zswap_cpu_comp_dead() teardown callback has been deleted from the call
> to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
> offline hotplug operations will be no-ops as far as the acomp_ctx
> resources are concerned.

Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
hotplug, and destroyed on pool destruction or CPU hotunplug. This
complicates the lifetime management to save memory while a CPU is
offlined, which is not very common.

Simplify lifetime management by allocating per-CPU acomp_ctx once on
pool creation (or CPU hotplug for CPUs onlined later), and keeping them
allocated until the pool is destroyed.

> 
> This commit refactors the code from zswap_cpu_comp_dead() into a
> new function acomp_ctx_dealloc() that is called to clean up acomp_ctx
> resources from:
> 
> 1) zswap_cpu_comp_prepare() when an error is encountered,
> 2) zswap_pool_create() when an error is encountered, and
> 3) from zswap_pool_destroy().


Refactor cleanup code from zswap_cpu_comp_dead() into
acomp_ctx_dealloc() to be used elsewhere.

> 
> The main benefit of using the CPU hotplug multi state instance startup
> callback to allocate the acomp_ctx resources is that it prevents the
> cores from being offlined until the multi state instance addition call
> returns.
> 
>   From Documentation/core-api/cpu_hotplug.rst:
> 
>     "The node list add/remove operations and the callback invocations are
>      serialized against CPU hotplug operations."
> 
> Furthermore, zswap_[de]compress() cannot contend with
> zswap_cpu_comp_prepare() because:
> 
>   - During pool creation/deletion, the pool is not in the zswap_pools
>     list.
> 
>   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
>     out. zswap_cpu_comp_prepare() will be run on a control CPU,
>     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
>     cpuhp_state". Thanks Yosry for sharing this observation!
> 
>   In both these cases, any recursions into zswap reclaim from
>   zswap_cpu_comp_prepare() will be handled by the old pool.
> 
> The above two observations enable the following simplifications:
> 
>  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot use
>     the pool. Considerations for mutex init/locking and handling
>     subsequent CPU hotplug online-offline-online:
> 
>     Should we lock the mutex of current CPU's acomp_ctx from start to
>     end? It doesn't seem like this is required. The CPU hotplug
>     operations acquire a "cpuhp_state_mutex" before proceeding, hence
>     they are serialized against CPU hotplug operations.
> 
>     If the process gets migrated while zswap_cpu_comp_prepare() is
>     running, it will complete on the new CPU. In case of failures, we
>     pass the acomp_ctx pointer obtained at the start of
>     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
>     only undergo migration. There appear to be no contention scenarios
>     that might cause inconsistent values of acomp_ctx's members. Hence,
>     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
>     zswap_cpu_comp_prepare().
> 
>     Since the pool is not yet on zswap_pools list, we don't need to
>     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
>     has been restored to occur in zswap_cpu_comp_prepare().
> 
>     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
>     valid. If so, it returns success. This should handle any CPU
>     hotplug online-offline transitions after pool creation is done.
> 
>  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
>     migrated to another CPU before the current CPU is dysfunctional. If
>     zswap_[de]compress() holds the acomp_ctx->mutex lock of the offlined
>     CPU, that mutex will be released once it completes on the new
>     CPU. Since there is no teardown callback, there is no possibility of
>     UAF.
> 
>  3) Pool creation/deletion and process migration to another CPU:
> 
>     - During pool creation/deletion, the pool is not in the zswap_pools
>       list. Hence it cannot contend with zswap ops on that CPU. However,
>       the process can get migrated.
> 
>       Pool creation --> zswap_cpu_comp_prepare()
>                                 --> process migrated:
>                                     * CPU offline: no-op.
>                                     * zswap_cpu_comp_prepare() continues
>                                       to run on the new CPU to finish
>                                       allocating acomp_ctx resources for
>                                       the offlined CPU.
> 
>       Pool deletion --> acomp_ctx_dealloc()
>                                 --> process migrated:
>                                     * CPU offline: no-op.
>                                     * acomp_ctx_dealloc() continues
>                                       to run on the new CPU to finish
>                                       de-allocating acomp_ctx resources
>                                       for the offlined CPU.
> 
>  4) Pool deletion vis-a-vis CPU onlining:
>     The call to cpuhp_state_remove_instance() cannot race with
>     zswap_cpu_comp_prepare() because of hotplug synchronization.
> 
> This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> Instead, zswap_[de]compress() directly call
> mutex_[un]lock(&acomp_ctx->mutex).

I am not sure why all of this is needed. We should just describe why
it's safe to drop holding the mutex while initializing per-CPU
acomp_ctx:

It is no longer possible for CPU hotplug to race against allocation or
usage of per-CPU acomp_ctx, as they are only allocated once before the
pool can be used, and remain allocated as long as the pool is used.
Hence, stop holding the lock during acomp_ctx initialization, and drop
acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().

> 
> The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as
> follows, on x86_64:
> 
>     IAA with 8 dst buffers for batching:    64.34 KB
>     Software compressors with 1 dst buffer:  8.28 KB

This cost is only paid when a CPU is offlined, until it is onlined
again.

> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 164 +++++++++++++++++++++--------------------------------
>  1 file changed, 64 insertions(+), 100 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4897ed689b9f..87d50786f61f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -242,6 +242,20 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +{
> +	if (IS_ERR_OR_NULL(acomp_ctx))
> +		return;
> +
> +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> +		acomp_request_free(acomp_ctx->req);
> +
> +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +		crypto_free_acomp(acomp_ctx->acomp);
> +
> +	kfree(acomp_ctx->buffer);
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *compressor)
>  {
>  	struct zswap_pool *pool;
> @@ -263,19 +277,26 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  
>  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
>  
> -	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
> +	/* Many things rely on the zero-initialization. */
> +	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
> +					   GFP_KERNEL | __GFP_ZERO);
>  	if (!pool->acomp_ctx) {
>  		pr_err("percpu alloc failed\n");
>  		goto error;
>  	}
>  
> -	for_each_possible_cpu(cpu)
> -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> -
> +	/*
> +	 * This is serialized against CPU hotplug operations. Hence, cores
> +	 * cannot be offlined until this finishes.
> +	 * In case of errors, we need to goto "ref_fail" instead of "error"
> +	 * because there is no teardown callback registered anymore, for
> +	 * cpuhp_state_add_instance() to de-allocate resources as it rolls back
> +	 * state on cores before the CPU on which error was encountered.
> +	 */

Do we need to manually call acomp_ctx_dealloc() on each CPU on failure
because cpuhp_state_add_instance() relies on the hotunplug callback for
cleanup, and we don't have any?

If that's the case:

	/*
	 * cpuhp_state_add_instance() will not cleanup on failure since
	 * we don't register a hotunplug callback.
	 */

Describing what the code does is not helpful, and things like "anymore"
do not make sense once the code is merged.

>  	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
>  				       &pool->node);
>  	if (ret)
> -		goto error;
> +		goto ref_fail;

IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
probably should add a new label.

>  
>  	/* being the current pool takes 1 ref; this func expects the
>  	 * caller to always add the new pool as the current pool
> @@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  
>  ref_fail:
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +
> +	for_each_possible_cpu(cpu)
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
>  error:
>  	if (pool->acomp_ctx)
>  		free_percpu(pool->acomp_ctx);
> @@ -322,9 +346,15 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
>  
>  static void zswap_pool_destroy(struct zswap_pool *pool)
>  {
> +	int cpu;
> +
>  	zswap_pool_debug("destroying", pool);
>  
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +
> +	for_each_possible_cpu(cpu)
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +
>  	free_percpu(pool->acomp_ctx);
>  
>  	zs_destroy_pool(pool->zs_pool);
> @@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  {
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> -	struct crypto_acomp *acomp = NULL;
> -	struct acomp_req *req = NULL;
> -	u8 *buffer = NULL;
> -	int ret;
> +	int ret = -ENOMEM;
>  
> -	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!buffer) {
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> +	/*
> +	 * To handle cases where the CPU goes through online-offline-online
> +	 * transitions, we return if the acomp_ctx has already been initialized.
> +	 */
> +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +		return 0;

Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
that case?

>  
> -	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> -	if (IS_ERR(acomp)) {
> +	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->buffer)
> +		return ret;
> +
> +	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> +	if (IS_ERR(acomp_ctx->acomp)) {
>  		pr_err("could not alloc crypto acomp %s : %ld\n",
> -				pool->tfm_name, PTR_ERR(acomp));
> -		ret = PTR_ERR(acomp);
> +				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
> +		ret = PTR_ERR(acomp_ctx->acomp);
>  		goto fail;
>  	}
> +	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
>  
> -	req = acomp_request_alloc(acomp);
> -	if (!req) {
> +	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> +	if (!acomp_ctx->req) {
>  		pr_err("could not alloc crypto acomp_request %s\n",
>  		       pool->tfm_name);
> -		ret = -ENOMEM;
>  		goto fail;
>  	}
>  
> -	/*
> -	 * Only hold the mutex after completing allocations, otherwise we may
> -	 * recurse into zswap through reclaim and attempt to hold the mutex
> -	 * again resulting in a deadlock.
> -	 */
> -	mutex_lock(&acomp_ctx->mutex);
>  	crypto_init_wait(&acomp_ctx->wait);
>  
>  	/*
[..]
