Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A95317A31A
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 17:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627880; cv=none; b=qDWBXrXtPO4I6dfA3JopFWE4W0cLMq8rAkCw0qUNBLOnpAjSMQIeTHpYhTHkUsoBlyLwcVG+4RNlPIynUccynLMjX5kLVq5MVVipw8gLpbN3x738YVzrSprqoFQd3+ZS6YFKwl/hRBzUwAmvGUItqtAXCx0sJ5CouOrMqNeAgfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627880; c=relaxed/simple;
	bh=zKc0sdLMgvyw+MGvOj3UKmAPQrDoIt6HAaheJ5pxgSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMX/8217pkGftI47bdYbPDFdCv3HFYvY1U/fpGCELopZSykK1DMbg5+S66Hw1CsYynplp0kYUGdkNr4V/eKLMkYRS92zRvPLN92CMMzsEBf5Rq51/eQ5cuYwCh1x200Iaa3L5nWYmyNqAujypx6j7asBqlUCo7PHqdn4Ex1pqpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g/zEmscr; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g/zEmscr"
Date: Mon, 10 Mar 2025 17:31:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741627874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9AKzdTafnP5muRvcqyXS2cPqfeLVBByaoT/d3amflSw=;
	b=g/zEmscrHJL62ZFqgpFnuqAI9kvWT61cfapyzX53zX6kHG8OVkvakrd95jEfjly4hW6Esl
	TajY/BRHAhXAKHdQn26Va00uNSowqAzhmH2UD6+YtJbZcu/JdZhcwzIEmZJtWEBz544CUi
	aBAVwwjDZHOQOjK7FcJsLkcX6ctTveU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Message-ID: <Z88h1mPkYNM6yOGE@google.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 08, 2025 at 02:47:15AM +0000, Sridhar, Kanchana P wrote:
> 
[..]
> > > > >  	u8 *buffer;
> > > > > +	u8 nr_reqs;
> > > > > +	struct crypto_wait wait;
> > > > >  	struct mutex mutex;
> > > > >  	bool is_sleepable;
> > > > > +	bool __online;
> > > >
> > > > I don't believe we need this.
> > > >
> > > > If we are not freeing resources during CPU offlining, then we do not
> > > > need a CPU offline callback and acomp_ctx->__online serves no purpose.
> > > >
> > > > The whole point of synchronizing between offlining and
> > > > compress/decompress operations is to avoid UAF. If offlining does not
> > > > free resources, then we can hold the mutex directly in the
> > > > compress/decompress path and drop the hotunplug callback completely.
> > > >
> > > > I also believe nr_reqs can be dropped from this patch, as it seems like
> > > > it's only used know when to set __online.
> > >
> > > All great points! In fact, that was the original solution I had implemented
> > > (not having an offline callback). But then, I spent some time understanding
> > > the v6.13 hotfix for synchronizing freeing of resources, and this comment
> > > in zswap_cpu_comp_prepare():
> > >
> > > 	/*
> > > 	 * Only hold the mutex after completing allocations, otherwise we
> > may
> > > 	 * recurse into zswap through reclaim and attempt to hold the mutex
> > > 	 * again resulting in a deadlock.
> > > 	 */
> > >
> > > Hence, I figured the constraint of "recurse into zswap through reclaim" was
> > > something to comprehend in the simplification (even though I had a tough
> > > time imagining how this could happen).
> > 
> > The constraint here is about zswap_cpu_comp_prepare() holding the mutex,
> > making an allocation which internally triggers reclaim, then recursing
> > into zswap and trying to hold the same mutex again causing a deadlock.
> > 
> > If zswap_cpu_comp_prepare() does not need to hold the mutex to begin
> > with, the constraint naturally goes away.
> 
> Actually, if it is possible for the allocations in zswap_cpu_comp_prepare()
> to trigger reclaim, then I believe we need some way for reclaim to know if
> the acomp_ctx resources are available. Hence, this seems like a potential
> for deadlock regardless of the mutex.

I took a closer look and I believe my hotfix was actually unnecessary. I
sent it out in response to a syzbot report, but upon closer look it
seems like it was not an actual problem. Sorry if my patch confused you.

Looking at enum cpuhp_state in include/linux/cpuhotplug.h, it seems like
CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section. The comment above
says:

 * PREPARE: The callbacks are invoked on a control CPU before the
 * hotplugged CPU is started up or after the hotplugged CPU has died.

So even if we go into reclaim during zswap_cpu_comp_prepare(), it will
never be on the CPU that we are allocating resources for.

The other case where zswap_cpu_comp_prepare() could race with
compression/decompression is when a pool is being created. In this case,
reclaim from zswap_cpu_comp_prepare() can recurse into zswap on the same
CPU AFAICT. However, because the pool is still under creation, it will
not be used (i.e. zswap_pool_current_get() won't find it).

So I think we don't need to worry about zswap_cpu_comp_prepare() racing
with compression or decompression for the same pool and CPU.

> 
> I verified that all the zswap_cpu_comp_prepare() allocations are done with
> GFP_KERNEL, which implicitly allows direct reclaim. So this appears to be a
> risk for deadlock between zswap_compress() and zswap_cpu_comp_prepare()
> in general, i.e., aside from this patchset.
> 
> I can think of the following options to resolve this, and would welcome
> other suggestions:
> 
> 1) Less intrusive: acomp_ctx_get_cpu_lock() should get the mutex, check
>     if acomp_ctx->__online is true, and if so, return the mutex. If
>     acomp_ctx->__online is false, then it returns NULL. In other words, we
>     don't have the for loop.
>     - This will cause recursions into direct reclaim from zswap_cpu_comp_prepare()
>        to fail, cpuhotplug to fail. However, there is no deadlock.
>         - zswap_compress() will need to detect NULL returned by
>           acomp_ctx_get_cpu_lock(), and return an error.
>         - zswap_decompress() will need a BUG_ON(!acomp_ctx) after calling
>           acomp_ctx_get_cpu_lock().
>     - We won't be migrated to a different CPU because we hold the mutex, hence
>       zswap_cpu_comp_dead() will wait on the mutex.
> 
> 2) More intrusive: We would need to use a gfp_t that prevents direct reclaim
>     and kswapd, i.e., something similar to GFP_TRANSHUGE_LIGHT in gfp_types.h,
>     but for non-THP allocations. If we decide to adopt this approach, we would
>     need changes in include/crypto/acompress.h, crypto/api.c, and crypto/acompress.c
>     to allow crypto_create_tfm_node() to call crypto_alloc_tfmmem() with this
>     new gfp_t, in lieu of GFP_KERNEL.
> 
> > 
> > >
> > > Hence, I added the "bool __online" because zswap_cpu_comp_prepare()
> > > does not acquire the mutex lock while allocating resources. We have
> > already
> > > initialized the mutex, so in theory, it is possible for compress/decompress
> > > to acquire the mutex lock. The __online acts as a way to indicate whether
> > > compress/decompress can proceed reliably to use the resources.
> > 
> > For compress/decompress to acquire the mutex they need to run on that
> > CPU, and I don't think that's possible before onlining completes, so
> > zswap_cpu_comp_prepare() must have already completed before
> > compress/decompress can use that CPU IIUC.
> 
> If we can make this assumption, that would be great! However, I am not
> totally sure because of the GFP_KERNEL allocations in
> zswap_cpu_comp_prepare().

As I mentioned above, when zswap_cpu_comp_prepare() is run we are in one
of two situations:
- The pool is under creation, so we cannot race with stores/loads from
  that same pool.
- The CPU is being onlined, in which case zswap_cpu_comp_prepare() is
  called from a control CPU before tasks start running on the CPU being
  onlined.

Please correct me if I am wrong.

[..]
> > > > > @@ -285,13 +403,21 @@ static struct zswap_pool
> > > > *zswap_pool_create(char *type, char *compressor)
> > > > >  		goto error;
> > > > >  	}
> > > > >
> > > > > -	for_each_possible_cpu(cpu)
> > > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > > > > +	for_each_possible_cpu(cpu) {
> > > > > +		struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > > > >acomp_ctx, cpu);
> > > > > +
> > > > > +		acomp_ctx->acomp = NULL;
> > > > > +		acomp_ctx->req = NULL;
> > > > > +		acomp_ctx->buffer = NULL;
> > > > > +		acomp_ctx->__online = false;
> > > > > +		acomp_ctx->nr_reqs = 0;
> > > >
> > > > Why is this needed? Wouldn't zswap_cpu_comp_prepare() initialize them
> > > > right away?
> > >
> > > Yes, I figured this is needed for two reasons:
> > >
> > > 1) For the error handling in zswap_cpu_comp_prepare() and calls into
> > >     zswap_cpu_comp_dealloc() to be handled by the common procedure
> > >     "acomp_ctx_dealloc()" unambiguously.
> > 
> > This makes sense. When you move the refactoring to create
> > acomp_ctx_dealloc() to a separate patch, please include this change in
> > it and call it out explicitly in the commit message.
> 
> Sure.
> 
> > 
> > > 2) The second scenario I thought of that would need this, is let's say
> > >      the zswap compressor is switched immediately after setting the
> > >      compressor. Some cores have executed the onlining code and
> > >      some haven't. Because there are no pool refs held,
> > >      zswap_cpu_comp_dealloc() would be called per-CPU. Hence, I figured
> > >      it would help to initialize these acomp_ctx members before the
> > >      hand-off to "cpuhp_state_add_instance()" in zswap_pool_create().
> > 
> > I believe cpuhp_state_add_instance() calls the onlining function
> > synchronously on all present CPUs, so I don't think it's possible to end
> > up in a state where the pool is being destroyed and some CPU executed
> > zswap_cpu_comp_prepare() while others haven't.
> 
> I looked at the cpuhotplug code some more. The startup callback is
> invoked sequentially for_each_present_cpu(). If an error occurs for any
> one of them, it calls the teardown callback only on the earlier cores that
> have already finished running the startup callback. However, 
> zswap_cpu_comp_dealloc() will be called for all cores, even the ones
> for which the startup callback was not run. Hence, I believe the
> zero initialization is useful, albeit using alloc_percpu_gfp(__GFP_ZERO)
> to allocate the acomp_ctx.

Yeah this is point (1) above IIUC, and I agree about zero initialization
for that.

> 
> > 
> > That being said, this made me think of a different problem. If pool
> > destruction races with CPU onlining, there could be a race between
> > zswap_cpu_comp_prepare() allocating resources and
> > zswap_cpu_comp_dealloc() (or acomp_ctx_dealloc()) freeing them.
> > 
> > I believe we must always call cpuhp_state_remove_instance() *before*
> > freeing the resources to prevent this race from happening. This needs to
> > be documented with a comment.
> 
> Yes, this race condition is possible, thanks for catching this! The problem with
> calling cpuhp_state_remove_instance() before freeing the resources is that
> cpuhp_state_add_instance() and cpuhp_state_remove_instance() both
> acquire a "mutex_lock(&cpuhp_state_mutex);" at the beginning; and hence
> are serialized.
> 
> For the reasons motivating why acomp_ctx->__online is set to false in
> zswap_cpu_comp_dead(), I cannot call cpuhp_state_remove_instance()
> before calling acomp_ctx_dealloc() because the latter could wait until
> acomp_ctx->__online to be true before deleting the resources. I will
> think about this some more.

I believe this problem goes away with acomp_ctx->__online going away,
right?

> 
> Another possibility is to not rely on cpuhotplug in zswap, and instead
> manage the per-cpu acomp_ctx resource allocation entirely in
> zswap_pool_create(), and deletion entirely in zswap_pool_destroy(),
> along with the necessary error handling. Let me think about this some
> more as well.
> 
> > 
> > Let me know if I missed something.
> > 
> > >
> > > Please let me know if these are valid considerations.
> > >
> > > >
> > > > If it is in fact needed we should probably just use __GFP_ZERO.
> > >
> > > Sure. Are you suggesting I use "alloc_percpu_gfp()" instead of
> > "alloc_percpu()"
> > > for the acomp_ctx?
> > 
> > Yeah if we need to initialize all/most fields to 0 let's use
> > alloc_percpu_gfp() and pass GFP_KERNEL | __GFP_ZERO.
> 
> Sounds good.
> 
> > 
> > [..]
> > > > > @@ -902,16 +957,52 @@ static struct crypto_acomp_ctx
> > > > *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
> > > > >
> > > > >  	for (;;) {
> > > > >  		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
> > > > > -		mutex_lock(&acomp_ctx->mutex);
> > > > > -		if (likely(acomp_ctx->req))
> > > > > -			return acomp_ctx;
> > > > >  		/*
> > > > > -		 * It is possible that we were migrated to a different CPU
> > > > after
> > > > > -		 * getting the per-CPU ctx but before the mutex was
> > > > acquired. If
> > > > > -		 * the old CPU got offlined, zswap_cpu_comp_dead() could
> > > > have
> > > > > -		 * already freed ctx->req (among other things) and set it to
> > > > > -		 * NULL. Just try again on the new CPU that we ended up on.
> > > > > +		 * If the CPU onlining code successfully allocates acomp_ctx
> > > > resources,
> > > > > +		 * it sets acomp_ctx->__online to true. Until this happens, we
> > > > have
> > > > > +		 * two options:
> > > > > +		 *
> > > > > +		 * 1. Return NULL and fail all stores on this CPU.
> > > > > +		 * 2. Retry, until onlining has finished allocating resources.
> > > > > +		 *
> > > > > +		 * In theory, option 1 could be more appropriate, because it
> > > > > +		 * allows the calling procedure to decide how it wants to
> > > > handle
> > > > > +		 * reclaim racing with CPU hotplug. For instance, it might be
> > > > Ok
> > > > > +		 * for compress to return an error for the backing swap device
> > > > > +		 * to store the folio. Decompress could wait until we get a
> > > > > +		 * valid and locked mutex after onlining has completed. For
> > > > now,
> > > > > +		 * we go with option 2 because adding a do-while in
> > > > > +		 * zswap_decompress() adds latency for software
> > > > compressors.
> > > > > +		 *
> > > > > +		 * Once initialized, the resources will be de-allocated only
> > > > > +		 * when the pool is destroyed. The acomp_ctx will hold on to
> > > > the
> > > > > +		 * resources through CPU offlining/onlining at any time until
> > > > > +		 * the pool is destroyed.
> > > > > +		 *
> > > > > +		 * This prevents races/deadlocks between reclaim and CPU
> > > > acomp_ctx
> > > > > +		 * resource allocation that are a dependency for reclaim.
> > > > > +		 * It further simplifies the interaction with CPU onlining and
> > > > > +		 * offlining:
> > > > > +		 *
> > > > > +		 * - CPU onlining does not take the mutex. It only allocates
> > > > > +		 *   resources and sets __online to true.
> > > > > +		 * - CPU offlining acquires the mutex before setting
> > > > > +		 *   __online to false. If reclaim has acquired the mutex,
> > > > > +		 *   offlining will have to wait for reclaim to complete before
> > > > > +		 *   hotunplug can proceed. Further, hotplug merely sets
> > > > > +		 *   __online to false. It does not delete the acomp_ctx
> > > > > +		 *   resources.
> > > > > +		 *
> > > > > +		 * Option 1 is better than potentially not exiting the earlier
> > > > > +		 * for (;;) loop because the system is running low on memory
> > > > > +		 * and/or CPUs are getting offlined for whatever reason. At
> > > > > +		 * least failing this store will prevent data loss by failing
> > > > > +		 * zswap_store(), and saving the data in the backing swap
> > > > device.
> > > > >  		 */
> > > >
> > > > I believe we can dropped. I don't think we can have any store/load
> > > > operations on a CPU before it's fully onlined, and we should always have
> > > > a reference on the pool here, so the resources cannot go away.
> > > >
> > > > So unless I missed something we can drop this completely now and just
> > > > hold the mutex directly in the load/store paths.
> > >
> > > Based on the above explanations, please let me know if it is a good idea
> > > to keep the __online, or if you think further simplification is possible.
> > 
> > I still think it's not needed. Let me know if I missed anything.
> 
> Let me think some more about whether it is feasible to not have cpuhotplug
> manage the acomp_ctx resource allocation, and instead have this be done
> through the pool creation/deletion routines.

I don't think this is necessary, see my comments above.
