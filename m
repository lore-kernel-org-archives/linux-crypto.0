Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B0B254B10
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 19:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375817; cv=none; b=IrlsaN7x0IRQyfvkpPF1obi/ipMKtWyjbLAPPeHtwpVdwhlIy0hToiVqe8LP7S+m4fxcHO+ybRXAMM74Z/1W1o3zagHgAQsS/D+jvQM/k7cOMBRASv6lWfvroGs9PgrUhACfkGYVgFjbKjtLkWBQrgO3SlVYf7I55zio0KBGoho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375817; c=relaxed/simple;
	bh=3vW18F9KA0DlaUPaJs/96zZMEZ9Knby9T7Tl3QR1unw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1VHEKOREryi6pBOiyxy681RfkfUUhCXvg5gCDn2mEN2umc33DuRav/hqsgQt96wgHuMrJo0p9X+GIJccfvdgfZ7B3/gg6484PIVVjBxZoXUyKncWtwzqA93la536mjka5C/iWP4kYYPADjpgGeu3J2T27B+q5Gswe/QRHgc2+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TDhd8WCK; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TDhd8WCK"
Date: Fri, 7 Mar 2025 19:30:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741375811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=32UydvvKm24N62XCJuTHKuLYGf2FbfzgJt9XuXJNV5s=;
	b=TDhd8WCKICQJYLGnn6HPZ+QXzcj3RRfS4vjR1P/MXJZ4rYirJOWZQ/tdQhKfONZS3aUKgX
	QWewGeEcssJEKALN/G4kWls9uKxRPBL4z/NNGk1/F3O8Ea6vd3YwksMC5cyZMS6YGwHsTN
	t3oI5msH4Gk4bqUAXwGLLx4EKLFyEZI=
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
Message-ID: <Z8tJOi5G_3dpK31v@google.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 07, 2025 at 12:01:14AM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, March 6, 2025 11:36 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
> > allocation/deletion and mutex lock usage.
> > 
> > On Mon, Mar 03, 2025 at 12:47:22AM -0800, Kanchana P Sridhar wrote:
> > > This patch modifies the acomp_ctx resources' lifetime to be from pool
> > > creation to deletion. A "bool __online" and "u8 nr_reqs" are added to
> > > "struct crypto_acomp_ctx" which simplify a few things:
> > >
> > > 1) zswap_pool_create() will initialize all members of each percpu
> > acomp_ctx
> > >    to 0 or NULL and only then initialize the mutex.
> > > 2) CPU hotplug will set nr_reqs to 1, allocate resources and set __online
> > >    to true, without locking the mutex.
> > > 3) CPU hotunplug will lock the mutex before setting __online to false. It
> > >    will not delete any resources.
> > > 4) acomp_ctx_get_cpu_lock() will lock the mutex, then check if __online
> > >    is true, and if so, return the mutex for use in zswap compress and
> > >    decompress ops.
> > > 5) CPU onlining after offlining will simply check if either __online or
> > >    nr_reqs are non-0, and return 0 if so, without re-allocating the
> > >    resources.
> > > 6) zswap_pool_destroy() will call a newly added zswap_cpu_comp_dealloc()
> > to
> > >    delete the acomp_ctx resources.
> > > 7) Common resource deletion code in case of zswap_cpu_comp_prepare()
> > >    errors, and for use in zswap_cpu_comp_dealloc(), is factored into a new
> > >    acomp_ctx_dealloc().
> > >
> > > The CPU hot[un]plug callback functions are moved to "pool functions"
> > > accordingly.
> > >
> > > The per-cpu memory cost of not deleting the acomp_ctx resources upon
> > CPU
> > > offlining, and only deleting them when the pool is destroyed, is as follows:
> > >
> > >     IAA with batching: 64.8 KB
> > >     Software compressors: 8.2 KB
> > >
> > > I would appreciate code review comments on whether this memory cost is
> > > acceptable, for the latency improvement that it provides due to a faster
> > > reclaim restart after a CPU hotunplug-hotplug sequence - all that the
> > > hotplug code needs to do is to check if acomp_ctx->nr_reqs is non-0, and
> > > if so, set __online to true and return, and reclaim can proceed.
> > 
> > I like the idea of allocating the resources on memory hotplug but
> > leaving them allocated until the pool is torn down. It avoids allocating
> > unnecessary memory if some CPUs are never onlined, but it simplifies
> > things because we don't have to synchronize against the resources being
> > freed in CPU offline.
> > 
> > The only case that would suffer from this AFAICT is if someone onlines
> > many CPUs, uses them once, and then offline them and not use them again.
> > I am not familiar with CPU hotplug use cases so I can't tell if that's
> > something people do, but I am inclined to agree with this
> > simplification.
> 
> Thanks Yosry, for your code review comments! Good to know that this
> simplification is acceptable.
> 
> > 
> > >
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > ---
> > >  mm/zswap.c | 273 +++++++++++++++++++++++++++++++++++--------------
> > ----
> > >  1 file changed, 182 insertions(+), 91 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 10f2a16e7586..cff96df1df8b 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -144,10 +144,12 @@ bool zswap_never_enabled(void)
> > >  struct crypto_acomp_ctx {
> > >  	struct crypto_acomp *acomp;
> > >  	struct acomp_req *req;
> > > -	struct crypto_wait wait;
> > 
> > Is there a reason for moving this? If not please avoid unrelated changes.
> 
> The reason is so that req/buffer, and reqs/buffers with batching, go together
> logically, hence I found this easier to understand. I can restore this to the
> original order, if that's preferable.

I see. In that case, this fits better in the patch that actually adds
support for having multiple requests and buffers, and please call it out
explicitly in the commit message.

> 
> > 
> > >  	u8 *buffer;
> > > +	u8 nr_reqs;
> > > +	struct crypto_wait wait;
> > >  	struct mutex mutex;
> > >  	bool is_sleepable;
> > > +	bool __online;
> > 
> > I don't believe we need this.
> > 
> > If we are not freeing resources during CPU offlining, then we do not
> > need a CPU offline callback and acomp_ctx->__online serves no purpose.
> > 
> > The whole point of synchronizing between offlining and
> > compress/decompress operations is to avoid UAF. If offlining does not
> > free resources, then we can hold the mutex directly in the
> > compress/decompress path and drop the hotunplug callback completely.
> > 
> > I also believe nr_reqs can be dropped from this patch, as it seems like
> > it's only used know when to set __online.
> 
> All great points! In fact, that was the original solution I had implemented
> (not having an offline callback). But then, I spent some time understanding
> the v6.13 hotfix for synchronizing freeing of resources, and this comment
> in zswap_cpu_comp_prepare():
> 
> 	/*
> 	 * Only hold the mutex after completing allocations, otherwise we may
> 	 * recurse into zswap through reclaim and attempt to hold the mutex
> 	 * again resulting in a deadlock.
> 	 */
> 
> Hence, I figured the constraint of "recurse into zswap through reclaim" was
> something to comprehend in the simplification (even though I had a tough
> time imagining how this could happen).

The constraint here is about zswap_cpu_comp_prepare() holding the mutex,
making an allocation which internally triggers reclaim, then recursing
into zswap and trying to hold the same mutex again causing a deadlock.

If zswap_cpu_comp_prepare() does not need to hold the mutex to begin
with, the constraint naturally goes away.

> 
> Hence, I added the "bool __online" because zswap_cpu_comp_prepare()
> does not acquire the mutex lock while allocating resources. We have already
> initialized the mutex, so in theory, it is possible for compress/decompress
> to acquire the mutex lock. The __online acts as a way to indicate whether
> compress/decompress can proceed reliably to use the resources.

For compress/decompress to acquire the mutex they need to run on that
CPU, and I don't think that's possible before onlining completes, so
zswap_cpu_comp_prepare() must have already completed before
compress/decompress can use that CPU IIUC.

> 
> The "nr_reqs" was needed as a way to distinguish between initial and
> subsequent calls into zswap_cpu_comp_prepare(), for e.g., on a CPU that
> goes through an online-offline-online sequence. In the initial onlining,
> we need to allocate resources because nr_reqs=0. If resources are to
> be allocated, we set acomp_ctx->nr_reqs and proceed to allocate
> reqs/buffers/etc. In the subsequent onlining, we can quickly inspect
> nr_reqs as being greater than 0 and return, thus avoiding any latency
> delays before reclaim/page-faults can be handled on that CPU.
> 
> Please let me know if this rationale seems reasonable for why
> __online and nr_reqs were introduced.

Based on what I said, I still don't believe they are needed, but please
correct me if I am wrong.

[..]
> > I also see some ordering changes inside the function (e.g. we now
> > allocate the request before the buffer). Not sure if these are
> > intentional. If not, please keep the diff to the required changes only.
> 
> The reason for this was, I am trying to organize the allocations based
> on dependencies. Unless requests are allocated, there is no point in
> allocating buffers. Please let me know if this is Ok.

Please separate refactoring changes in general from functional changes
because it makes code review harder.

In this specific instance, I think moving the code is probably not worth
it, as there's also no point in allocating requests if we cannot
allocate buffers. In fact, since the buffers are larger, in theory their
allocation is more likely to fail, so it makes since to do it first.

Anyway, please propose such refactoring changes separately and they can
be discussed as such.

[..]
> > > +static void zswap_cpu_comp_dealloc(unsigned int cpu, struct hlist_node
> > *node)
> > > +{
> > > +	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool,
> > node);
> > > +	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > >acomp_ctx, cpu);
> > > +
> > > +	/*
> > > +	 * The lifetime of acomp_ctx resources is from pool creation to
> > > +	 * pool deletion.
> > > +	 *
> > > +	 * Reclaims should not be happening because, we get to this routine
> > only
> > > +	 * in two scenarios:
> > > +	 *
> > > +	 * 1) pool creation failures before/during the pool ref initialization.
> > > +	 * 2) we are in the process of releasing the pool, it is off the
> > > +	 *    zswap_pools list and has no references.
> > > +	 *
> > > +	 * Hence, there is no need for locks.
> > > +	 */
> > > +	acomp_ctx->__online = false;
> > > +	acomp_ctx_dealloc(acomp_ctx);
> > 
> > Since __online can be dropped, we can probably drop
> > zswap_cpu_comp_dealloc() and call acomp_ctx_dealloc() directly?
> 
> I suppose there is value in having a way in zswap to know for sure, that
> resource allocation has completed, and it is safe for compress/decompress
> to proceed. Especially because the mutex has been initialized before we
> get to resource allocation. Would you agree?

As I mentioned above, I believe compress/decompress cannot run on a CPU
before the onlining completes. Please correct me if I am wrong.

> 
> > 
> > > +}
> > > +
> > >  static struct zswap_pool *zswap_pool_create(char *type, char
> > *compressor)
> > >  {
> > >  	struct zswap_pool *pool;
> > > @@ -285,13 +403,21 @@ static struct zswap_pool
> > *zswap_pool_create(char *type, char *compressor)
> > >  		goto error;
> > >  	}
> > >
> > > -	for_each_possible_cpu(cpu)
> > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > > +	for_each_possible_cpu(cpu) {
> > > +		struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > >acomp_ctx, cpu);
> > > +
> > > +		acomp_ctx->acomp = NULL;
> > > +		acomp_ctx->req = NULL;
> > > +		acomp_ctx->buffer = NULL;
> > > +		acomp_ctx->__online = false;
> > > +		acomp_ctx->nr_reqs = 0;
> > 
> > Why is this needed? Wouldn't zswap_cpu_comp_prepare() initialize them
> > right away?
> 
> Yes, I figured this is needed for two reasons:
> 
> 1) For the error handling in zswap_cpu_comp_prepare() and calls into
>     zswap_cpu_comp_dealloc() to be handled by the common procedure
>     "acomp_ctx_dealloc()" unambiguously.

This makes sense. When you move the refactoring to create
acomp_ctx_dealloc() to a separate patch, please include this change in
it and call it out explicitly in the commit message.

> 2) The second scenario I thought of that would need this, is let's say
>      the zswap compressor is switched immediately after setting the
>      compressor. Some cores have executed the onlining code and
>      some haven't. Because there are no pool refs held,
>      zswap_cpu_comp_dealloc() would be called per-CPU. Hence, I figured
>      it would help to initialize these acomp_ctx members before the
>      hand-off to "cpuhp_state_add_instance()" in zswap_pool_create().

I believe cpuhp_state_add_instance() calls the onlining function
synchronously on all present CPUs, so I don't think it's possible to end
up in a state where the pool is being destroyed and some CPU executed
zswap_cpu_comp_prepare() while others haven't.

That being said, this made me think of a different problem. If pool
destruction races with CPU onlining, there could be a race between
zswap_cpu_comp_prepare() allocating resources and
zswap_cpu_comp_dealloc() (or acomp_ctx_dealloc()) freeing them.

I believe we must always call cpuhp_state_remove_instance() *before*
freeing the resources to prevent this race from happening. This needs to
be documented with a comment.

Let me know if I missed something.

> 
> Please let me know if these are valid considerations.
> 
> > 
> > If it is in fact needed we should probably just use __GFP_ZERO.
> 
> Sure. Are you suggesting I use "alloc_percpu_gfp()" instead of "alloc_percpu()"
> for the acomp_ctx?

Yeah if we need to initialize all/most fields to 0 let's use
alloc_percpu_gfp() and pass GFP_KERNEL | __GFP_ZERO.

[..]
> > > @@ -902,16 +957,52 @@ static struct crypto_acomp_ctx
> > *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
> > >
> > >  	for (;;) {
> > >  		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
> > > -		mutex_lock(&acomp_ctx->mutex);
> > > -		if (likely(acomp_ctx->req))
> > > -			return acomp_ctx;
> > >  		/*
> > > -		 * It is possible that we were migrated to a different CPU
> > after
> > > -		 * getting the per-CPU ctx but before the mutex was
> > acquired. If
> > > -		 * the old CPU got offlined, zswap_cpu_comp_dead() could
> > have
> > > -		 * already freed ctx->req (among other things) and set it to
> > > -		 * NULL. Just try again on the new CPU that we ended up on.
> > > +		 * If the CPU onlining code successfully allocates acomp_ctx
> > resources,
> > > +		 * it sets acomp_ctx->__online to true. Until this happens, we
> > have
> > > +		 * two options:
> > > +		 *
> > > +		 * 1. Return NULL and fail all stores on this CPU.
> > > +		 * 2. Retry, until onlining has finished allocating resources.
> > > +		 *
> > > +		 * In theory, option 1 could be more appropriate, because it
> > > +		 * allows the calling procedure to decide how it wants to
> > handle
> > > +		 * reclaim racing with CPU hotplug. For instance, it might be
> > Ok
> > > +		 * for compress to return an error for the backing swap device
> > > +		 * to store the folio. Decompress could wait until we get a
> > > +		 * valid and locked mutex after onlining has completed. For
> > now,
> > > +		 * we go with option 2 because adding a do-while in
> > > +		 * zswap_decompress() adds latency for software
> > compressors.
> > > +		 *
> > > +		 * Once initialized, the resources will be de-allocated only
> > > +		 * when the pool is destroyed. The acomp_ctx will hold on to
> > the
> > > +		 * resources through CPU offlining/onlining at any time until
> > > +		 * the pool is destroyed.
> > > +		 *
> > > +		 * This prevents races/deadlocks between reclaim and CPU
> > acomp_ctx
> > > +		 * resource allocation that are a dependency for reclaim.
> > > +		 * It further simplifies the interaction with CPU onlining and
> > > +		 * offlining:
> > > +		 *
> > > +		 * - CPU onlining does not take the mutex. It only allocates
> > > +		 *   resources and sets __online to true.
> > > +		 * - CPU offlining acquires the mutex before setting
> > > +		 *   __online to false. If reclaim has acquired the mutex,
> > > +		 *   offlining will have to wait for reclaim to complete before
> > > +		 *   hotunplug can proceed. Further, hotplug merely sets
> > > +		 *   __online to false. It does not delete the acomp_ctx
> > > +		 *   resources.
> > > +		 *
> > > +		 * Option 1 is better than potentially not exiting the earlier
> > > +		 * for (;;) loop because the system is running low on memory
> > > +		 * and/or CPUs are getting offlined for whatever reason. At
> > > +		 * least failing this store will prevent data loss by failing
> > > +		 * zswap_store(), and saving the data in the backing swap
> > device.
> > >  		 */
> > 
> > I believe we can dropped. I don't think we can have any store/load
> > operations on a CPU before it's fully onlined, and we should always have
> > a reference on the pool here, so the resources cannot go away.
> > 
> > So unless I missed something we can drop this completely now and just
> > hold the mutex directly in the load/store paths.
> 
> Based on the above explanations, please let me know if it is a good idea
> to keep the __online, or if you think further simplification is possible.

I still think it's not needed. Let me know if I missed anything.
