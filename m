Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED620C463
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 22:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765578327; cv=none; b=S5bqEPUvUq9K8o4JESXnpaHTvghnGYN6IQzfG1BE6+MbTOjjfHGRGWqzVkdNxcWQHgDVVNu8hTD0EQAvzKjqGjr7eA9vwueuPuIRx5U+HvEOszhAcpoZngLBFAED01Rxgy9yw2BzW3TLvM0PiKX3obmANaFBm5Nun0xJtrFvWlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765578327; c=relaxed/simple;
	bh=jJis8TvFF2Ag/t1sJv1DWJ+v/JMPlJBBHNyJwvsNpS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJWnB9a1NzmNsMSyqR75gRcZCn4sKr2E6Byj1S9c4uRnuSOlC1BtIrHiVfQz3skukVhqLrYsbz0zg7OocIAtfD3YzOUtDVr49otk2RMpeyHK1Z93h9JZ+gr6of6t0kKNNoGn/1uUTijuT5/h3DLSOD5HDdFBk4pjN4KOoETgi74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P/KZ82Hq; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P/KZ82Hq"
Date: Fri, 12 Dec 2025 22:25:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765578318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8xZuNC1E0nPRDl81t4/ST2owbyreuFV1CYO01fwFdPM=;
	b=P/KZ82Hqr1babxk8ltueZJ3SaxWJ4aQuwLT0FPycxuW432QKkmGwGQfvD2hm7IN7R3Jsxh
	XqhxVesPax45GBPx3p80B3A3htkmGT81fyhA3QEILkpzMzg+iMC+Y1I357GkJk2dLVTZB4
	2IOddnTAXzCQtqT3uWY3/LZqnUf7brw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <qbrym673jqbz4kaqqzhgioh7vhiq55pqdxyvlwgfle5yqlbtln@xjxem4dbwca7>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
 <SJ2PR11MB8472C23A8E67F71D207D66E1C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472C23A8E67F71D207D66E1C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 12, 2025 at 08:53:13PM +0000, Sridhar, Kanchana P wrote:
[..]
> > On Fri, Dec 12, 2025 at 06:17:07PM +0000, Sridhar, Kanchana P wrote:
> > > >
> > > > >  	ret =
> > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > >  				       &pool->node);
> > > > >  	if (ret)
> > > > > -		goto error;
> > > > > +		goto ref_fail;
> > > >
> > > > IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> > > > probably should add a new label.
> > >
> > > In this case we should because it is part of the pool creation failure
> > > handling flow, at the end of which, the pool will be deleted.
> > 
> > What I mean is, when cpuhp_state_add_instance() fails we goto ref_fail
> > which will call cpuhp_state_remove_instance(). But the current code does
> > not call cpuhp_state_remove_instance() if cpuhp_state_add_instance()
> > fails.
> 
> I see what you mean. The current mainline code does not call
> cpuhp_state_remove_instance() if cpuhp_state_add_instance() fails, because
> the cpuhotplug code will call the teardown callback in this case.
> 
> In this patch, I do need to call cpuhp_state_remove_instance() and
> acomp_ctx_dealloc() in this case because there is no teardown callback
> being registered.

Hmm looking at cpuhp_state_add_instance(), it seems like it doesn't add
the node to the list on failure. cpuhp_state_remove_instance() only
removes the node from the list when there's no teardown cb, so it will
be a nop in this case.

What we need to do is manual cleanup, since there is no teardown cb,
which is already being done by acomp_ctx_dealloc() IIUC.

So I think calling cpuhp_state_remove_instance() when
cpuhp_state_add_instance() fails is not needed, and I don't see other
callers doing it.

[..]
> > > > > @@ -322,9 +346,15 @@ static struct zswap_pool
> > > > *__zswap_pool_create_fallback(void)
> > > > >
> > > > >  static void zswap_pool_destroy(struct zswap_pool *pool)
> > > > >  {
> > > > > +	int cpu;
> > > > > +
> > > > >  	zswap_pool_debug("destroying", pool);
> > > > >
> > > > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > &pool->node);
> > > > > +
> > > > > +	for_each_possible_cpu(cpu)
> > > > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > > > > +
> > > > >  	free_percpu(pool->acomp_ctx);
> > > > >
> > > > >  	zs_destroy_pool(pool->zs_pool);
> > > > > @@ -736,39 +766,35 @@ static int
> > zswap_cpu_comp_prepare(unsigned int
> > > > cpu, struct hlist_node *node)
> > > > >  {
> > > > >  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool,
> > > > node);
> > > > >  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > > > >acomp_ctx, cpu);
> > > > > -	struct crypto_acomp *acomp = NULL;
> > > > > -	struct acomp_req *req = NULL;
> > > > > -	u8 *buffer = NULL;
> > > > > -	int ret;
> > > > > +	int ret = -ENOMEM;
> > > > >
> > > > > -	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > > > > -	if (!buffer) {
> > > > > -		ret = -ENOMEM;
> > > > > -		goto fail;
> > > > > -	}
> > > > > +	/*
> > > > > +	 * To handle cases where the CPU goes through online-offline-online
> > > > > +	 * transitions, we return if the acomp_ctx has already been initialized.
> > > > > +	 */
> > > > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > > > +		return 0;
> > > >
> > > > Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
> > > > then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
> > > > that case?
> > >
> > > This is checking for a valid acomp_ctx->acomp using the same criteria
> > > being uniformly used in acomp_ctx_dealloc(). This check is necessary to
> > > handle the case where the CPU goes through online-offline-online state
> > > transitions.
> > 
> > I think I am confused. I thought now we don't free this on CPU offline,
> > so either it's NULL because this is the first time we initialize it on
> > this CPU, or it is allocated.
> 
> Yes, this is correct.
> 
> > If it is an ERR value, then the pool
> > creation should have failed and we wouldn't be calling this again on CPU
> > online.
> > 
> > In other words, what scenario do we expect to legitimately see an ERR
> > value here?
> 
> I am using "(!IS_ERR_OR_NULL(acomp_ctx->acomp)" as a check for the
> acomp being allocated already. I could instead have used "if (acomp_ctx->acomp)",
> but use the former to be consistent with patch 20/22.
> 
> I cannot think of a scenario where we can expect an ERR value here.

Yeah maybe do if (acomp_ctx->acomp) and
WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp))?
