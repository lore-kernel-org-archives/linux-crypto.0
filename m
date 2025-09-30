Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D650C86347;
	Tue, 30 Sep 2025 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759247376; cv=none; b=EVLeHc7mor2f0oUDbveNAHT5rFgOA+P0z6m+rhX86Gl6MBVjnjggRM81OfN74bsWcukJDJZW9n93NUkZ7zzHamqJXuJ//4BIk92NKKd6b96M3XaHmwKb5xBy6qm6l8yXDljcGF3gq+grujRy2SG8q1hcSgJpcHIoBWRLISjr3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759247376; c=relaxed/simple;
	bh=bjy7Dm2UzpjgDWmn6S0SerrxCIm+e0HXf7fRyYZQJXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlfZ49mzlbNFpW5gDKzF0QBQFBzFKYY5XM/Tx8rAdNKYVHsnfuC0hKhoJ3BBzFbhW/SbnD3OHra7MjlP4eF/HpWiaJVA2qinne+WxNOdXg/EoriJmyqGJaQj3GdYI+5uwTkQhFDWo31RAGqhc4duxb71yjhKADi80JKjP5USxDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MwgSYTPU; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MwgSYTPU"
Date: Tue, 30 Sep 2025 15:49:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759247371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wPH6wwQqSIxcr7X9Oo8NWI4UvG7fGAU6TYD6yDcIv0=;
	b=MwgSYTPUL7adjksmBhQxp2WuuSY96pTGQlwQtd3HSZMa9Ln1QHS4QpsnzP9GGvZc4Y6OXG
	pUV9If8/2R8cwvdkCZ1zkgM3qqqCWMppi23nBM7fGeKALxswf3v+uJiYLNISX0hOqG1qDw
	DLZ1IUZPgrNLHRmd7Jiy1sS/52weqO0=
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
Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 25, 2025 at 08:34:59PM -0700, Kanchana P Sridhar wrote:
> This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> pool creation to pool deletion. These resources will persist through CPU
> hotplug operations. The zswap_cpu_comp_dead() teardown callback has been
> deleted from the call to
> cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
> offline hotplug operations will be no-ops as far as the acomp_ctx
> resources are concerned.
> 
> This commit refactors the code from zswap_cpu_comp_dead() into a
> new function acomp_ctx_dealloc() that preserves the IS_ERR_OR_NULL()
> checks on acomp_ctx, req and acomp from the existing mainline
> implementation of zswap_cpu_comp_dead(). acomp_ctx_dealloc() is called
> to clean up acomp_ctx resources from all these procedures:
> 
> 1) zswap_cpu_comp_prepare() when an error is encountered,
> 2) zswap_pool_create() when an error is encountered, and
> 3) from zswap_pool_destroy().
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
>     out. zswap_cpu_comp_prepare() will be executed on a control CPU,
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
>     subsequent CPU hotplug online-offlines:
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
>     To prevent possibility of race conditions between
>     acomp_ctx_dealloc() freeing the acomp_ctx resources and the initial
>     check for a valid acomp_ctx->acomp in zswap_cpu_comp_prepare(), we
>     need to delete the multi state instance right after it is added, in
>     zswap_pool_create().
> 
>  Summary of changes based on the above:
>  --------------------------------------
>  1) Zero-initialization of pool->acomp_ctx in zswap_pool_create() to
>     simplify and share common code for different error handling/cleanup
>     related to the acomp_ctx.
> 
>  2) Remove the node list instance right after node list add function
>     call in zswap_pool_create(). This prevents race conditions between
>     CPU onlining after initial pool creation, and acomp_ctx_dealloc()
>     freeing the acomp_ctx resources.
> 
>  3) zswap_pool_destroy() will call acomp_ctx_dealloc() to de-allocate
>     the per-CPU acomp_ctx resources.
> 
>  4) Changes to zswap_cpu_comp_prepare():
> 
>     a) Check if acomp_ctx->acomp is valid at the beginning and return,
>        because the acomp_ctx is already initialized.
>     b) Move the mutex_init to happen in this procedure, before it
>        returns.
>     c) All error conditions handled by calling acomp_ctx_dealloc().
> 
>  5) New procedure acomp_ctx_dealloc() for common error/cleanup code.
> 
>  6) No more multi state instance teardown callback. CPU offlining is a
>     no-op as far as acomp_ctx resources are concerned.
> 
>  7) Delete acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock(). Directly
>     call mutex_lock(&acomp_ctx->mutex)/mutex_unlock(&acomp_ctx->mutex)
>     in zswap_[de]compress().
> 
> The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as
> follows, on x86_64:
> 
>     IAA with 8 dst buffers for batching:    64.34 KB
>     Software compressors with 1 dst buffer:  8.28 KB
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Please try to make the commit logs a bit more summarized. Details are
helpful, but it's easy to lose track of things when it gets too long.

> ---
>  mm/zswap.c | 194 +++++++++++++++++++++++++----------------------------
>  1 file changed, 93 insertions(+), 101 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c1af782e54ec..27665eaa3f89 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -242,6 +242,30 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> +/*
> + * The per-cpu pool->acomp_ctx is zero-initialized on allocation. This makes
> + * it easy for different error conditions/cleanup related to the acomp_ctx
> + * to be handled by acomp_ctx_dealloc():
> + * - Errors during zswap_cpu_comp_prepare().
> + * - Partial success/error of cpuhp_state_add_instance() call in
> + *   zswap_pool_create(). Only some cores could have executed
> + *   zswap_cpu_comp_prepare(), not others.
> + * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
> + */

Comments describing specific code paths go out of date really fast. The
comment is probably unnecessary, it's easy to check the allocation path
to figure out that these are zero-initialized.

Also in general, please keep the comments as summarized as possible, and
only when the logic is not clear from the code.

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
> @@ -263,19 +287,43 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
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
>  	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
>  				       &pool->node);
> +
> +	/*
> +	 * We only needed the multi state instance add operation to invoke the
> +	 * startup callback for all cores without cores getting offlined. Since
> +	 * the acomp_ctx resources will now only be de-allocated when the pool
> +	 * is destroyed, we can safely remove the multi state instance. This
> +	 * minimizes (but does not eliminate) the possibility of
> +	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
> +	 * offline-online transition. Removing the instance also prevents race
> +	 * conditions between CPU onlining after initial pool creation, and
> +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> +	 * Note that we delete the instance before checking the error status of
> +	 * the node list add operation because we want the instance removal even
> +	 * in case of errors in the former.
> +	 */
> +	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +

I don't understand what's wrong with the current flow? We call
cpuhp_state_remove_instance() in pool deletion before freeing up the
per-CPU resources. Why is this not enough?

