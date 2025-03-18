Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BA91FA14B
	for <linux-crypto@vger.kernel.org>; Tue, 18 Mar 2025 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742307834; cv=none; b=hY7S7uOeAzd6kKW/UDeJHUxBoIeV4SkbpyklOkiDs29a9XTcaoBS+bwCpD2BSLbELhWTbPe7LvajTxEJJWfq//BdXDfFHS8rk5zw4kcdmmnY0ECfb9Jtp/TLK68wnfySm7XrKbjWMKRKOTGSUR3A5J1VfwDQSob22htmS/8MlNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742307834; c=relaxed/simple;
	bh=3l7/+w0Cqrj84kKZHIfTbz64aZ88NXHvCOE+ukXY7dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzFBhvoBdoIkoAZp98LC+sIK0M51jaux4QY26nw7mXN8X8xLa7uIDSJaOi0PI2yt0cm5aBTzjJkTKRxtoyErQvgWEXcs9DB0qa3f4yShU4GwWrpelMfjGCdvX+rhWb0dbRh4UFkYGOyk/TSd6SwEMQ9Q6UPGvMTEU4NzgpG/n+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mj4tt69B; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mj4tt69B"
Date: Tue, 18 Mar 2025 14:23:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742307828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ls7Y8UAc4E5oYUHdeF3Zui0XA8kiPNXgDdqTzRTlvAE=;
	b=mj4tt69BP31yx1XmC0KXe2ExEfhJaFB0CID9iWDRqJ/7x7RQ6gRKgjovCn/2yTHDpriF3n
	3Bbj1+EbTbDq5nulMG3EeHNObhLL3B2Mwvw0+VkBaaxKNrdujUJoWEqvjbFkkyq2STiAfq
	I+VAx6cvm7jwkFUwZPVolYzEqY5uSWQ=
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
Message-ID: <Z9mB5IbNEdNdtmUp@google.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com>
 <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 09:15:09PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Monday, March 10, 2025 10:31 AM
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
> > On Sat, Mar 08, 2025 at 02:47:15AM +0000, Sridhar, Kanchana P wrote:
> > >
> > [..]
> > > > > > >  	u8 *buffer;
> > > > > > > +	u8 nr_reqs;
> > > > > > > +	struct crypto_wait wait;
> > > > > > >  	struct mutex mutex;
> > > > > > >  	bool is_sleepable;
> > > > > > > +	bool __online;
> > > > > >
> > > > > > I don't believe we need this.
> > > > > >
> > > > > > If we are not freeing resources during CPU offlining, then we do not
> > > > > > need a CPU offline callback and acomp_ctx->__online serves no
> > purpose.
> > > > > >
> > > > > > The whole point of synchronizing between offlining and
> > > > > > compress/decompress operations is to avoid UAF. If offlining does not
> > > > > > free resources, then we can hold the mutex directly in the
> > > > > > compress/decompress path and drop the hotunplug callback
> > completely.
> > > > > >
> > > > > > I also believe nr_reqs can be dropped from this patch, as it seems like
> > > > > > it's only used know when to set __online.
> > > > >
> > > > > All great points! In fact, that was the original solution I had implemented
> > > > > (not having an offline callback). But then, I spent some time
> > understanding
> > > > > the v6.13 hotfix for synchronizing freeing of resources, and this comment
> > > > > in zswap_cpu_comp_prepare():
> > > > >
> > > > > 	/*
> > > > > 	 * Only hold the mutex after completing allocations, otherwise we
> > > > may
> > > > > 	 * recurse into zswap through reclaim and attempt to hold the mutex
> > > > > 	 * again resulting in a deadlock.
> > > > > 	 */
> > > > >
> > > > > Hence, I figured the constraint of "recurse into zswap through reclaim"
> > was
> > > > > something to comprehend in the simplification (even though I had a
> > tough
> > > > > time imagining how this could happen).
> > > >
> > > > The constraint here is about zswap_cpu_comp_prepare() holding the
> > mutex,
> > > > making an allocation which internally triggers reclaim, then recursing
> > > > into zswap and trying to hold the same mutex again causing a deadlock.
> > > >
> > > > If zswap_cpu_comp_prepare() does not need to hold the mutex to begin
> > > > with, the constraint naturally goes away.
> > >
> > > Actually, if it is possible for the allocations in zswap_cpu_comp_prepare()
> > > to trigger reclaim, then I believe we need some way for reclaim to know if
> > > the acomp_ctx resources are available. Hence, this seems like a potential
> > > for deadlock regardless of the mutex.
> > 
> > I took a closer look and I believe my hotfix was actually unnecessary. I
> > sent it out in response to a syzbot report, but upon closer look it
> > seems like it was not an actual problem. Sorry if my patch confused you.
> > 
> > Looking at enum cpuhp_state in include/linux/cpuhotplug.h, it seems like
> > CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section. The comment
> > above
> > says:
> > 
> >  * PREPARE: The callbacks are invoked on a control CPU before the
> >  * hotplugged CPU is started up or after the hotplugged CPU has died.
> > 
> > So even if we go into reclaim during zswap_cpu_comp_prepare(), it will
> > never be on the CPU that we are allocating resources for.
> > 
> > The other case where zswap_cpu_comp_prepare() could race with
> > compression/decompression is when a pool is being created. In this case,
> > reclaim from zswap_cpu_comp_prepare() can recurse into zswap on the
> > same
> > CPU AFAICT. However, because the pool is still under creation, it will
> > not be used (i.e. zswap_pool_current_get() won't find it).
> > 
> > So I think we don't need to worry about zswap_cpu_comp_prepare() racing
> > with compression or decompression for the same pool and CPU.
> 
> Thanks Yosry, for this observation! You are right, when considered purely
> from a CPU hotplug perspective, zswap_cpu_comp_prepare() and
> zswap_cpu_comp_dead() in fact run on a control CPU, because the state is
> registered in the PREPARE section of "enum cpuhp_state" in cpuhotplug.h.
> 
> The problem however is that, in the current architecture, CPU onlining/ 
> zswap_pool creation, and CPU offlining/zswap_pool deletion have the
> same semantics as far as these resources are concerned. Hence, although
> zswap_cpu_comp_prepare() is run on a control CPU, the CPU for which
> the "hotplug" code is called is in fact online. It is possible for the memory
> allocation calls in zswap_cpu_comp_prepare() to recurse into
> zswap_compress(), which now needs to be handled by the current pool,
> since the new pool has not yet been added to the zswap_pools, as you
> pointed out.
> 
> The ref on the current pool has not yet been dropped. Could there be
> a potential for a deadlock at pool transition time: the new pool is blocked
> from allocating acomp_ctx resources, triggering reclaim, which the old
> pool needs to handle?

I am not sure how this could lead to a deadlock. The compression will be
happening in a different pool with a different acomp_ctx.

> 
> I see other places in the kernel that use CPU hotplug for resource allocation,
> outside of the context of CPU onlining. IIUC, it is difficult to guarantee that
> the startup/teardown callbacks are modifying acomp_ctx resources for a
> dysfunctional CPU.

IIUC, outside the context of CPU onlining, CPU hotplug callbacks get
called when they are added. In this case, only the newly added callbacks
will be executed. IOW, zswap's hotplug callback should not be randomly
getting called when irrelevant code adds hotplug callbacks. It should
only happen during zswap pool initialization or CPU onlining.

Please correct me if I am wrong.

> 
> Now that I think about it, the only real constraint is that the acomp_ctx
> resources are guaranteed to exist for a functional CPU which can run zswap
> compress/decompress.

I believe this is already the case as I previously described, because
the hotplug callback can only be called in two scenarios:
- Zswap pool initialization, in which case compress/decompress
  operations cannot run on the pool we are initializing.
- CPU onlining, in which case compress/decompress operations cannot run
  on the CPU we are onlining.

Please correct me if I am wrong.

> 
> I think we can simplify this as follows, and would welcome suggestions
> to improve the proposed solution:
> 
> 1) We dis-associate the acomp_ctx from the pool, and instead, have this
>     be a global percpu zswap resource that gets allocated once in zswap_setup(),
>     just like the zswap_entry_cache.
> 2) The acomp_ctx resources will get allocated during zswap_setup(), using
>     the cpuhp_setup_state_multi callback() in zswap_setup(), that registers
>     zswap_cpu_comp_prepare(), but no teardown callback.
> 3) We call cpuhp_state_add_instance() for_each_possible_cpu(cpu) in
>      zswap_setup(). 
> 4) The acomp_ctx resources persist through subsequent "real CPU offline/online
>      state transitions".
> 5) zswap_[de]compress() can go ahead and lock the mutex, and use the
>     reqs/buffers without worrying about whether these resources are
>     initialized or still exist/are being deleted.
> 6) "struct zswap_pool" is now de-coupled from this global percpu zswap
>     acomp_ctx.
> 7) To address the issue of how many reqs/buffers to allocate, there could
>      potentially be a memory cost for non-batching compressors, if we want
>      to always allocate ZSWAP_MAX_BATCH_SIZE acomp_reqs and buffers.
>      This would allow the acomp_ctx to seamlessly handle batching
>      compressors, non-batching compressors, and transitions among the
>      two compressor types in a pretty general manner, that relies only on
>      the ZSWAP_MAX_BATCH_SIZE, which we define anyway.
> 
>      I believe we can maximize the chances of success for the allocation of
>      the acomp_ctx resources if this is done in zswap_setup(), but please
>      correct me if I am wrong.
> 
>      The added memory cost for platforms without IAA would be
>      ~57 KB per cpu, on x86. Would this be acceptable?

I think that's a lot of memory to waste per-CPU, and I don't see a good
reason for it.

>      If not, I don't believe this simplification would be worth it, because
>      allocating for one req/buffer, then dynamically adding more resources
>      if a newly selected compressor requires more resources, would run
>      into the same race conditions and added checks as in
>      acomp_ctx_get_cpu_lock(), which I believe, seem to be necessary because
>      CPU onlining/zswap_pool creation and CPU offlining/zswap_pool
>      deletion have the same semantics for these resources.

Agree that using a single acomp_ctx per-CPU but making the resources
resizable is not a win.

> 
>     The only other fallback solution in lieu of the proposed simplification that
>     I can think of is to keep the lifespan of these resources from pool creation
>     to deletion, using the CPU hotplug code. Although, it is not totally clear
>     to me if there is potential for deadlock during pool transitions, as noted above.

I am not sure what's the deadlock scenario you're worried about, please
clarify.
