Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5125E309EEC;
	Fri, 12 Dec 2025 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765565029; cv=none; b=ikoM7R8g9xyO8aHUdwxfWgPErAHAgbON+xgDQB3rD42Nr5yQSznGSvgrQSKxBWSp3T6mZcWxuPvhawslL5Q9oZfb1+djr/SzGYKW2B/DHM4yR68EU4OZ5ArPSJzkiFv8C+l1rH3NRIc1flv43mhrRn5LLs6UgzSkC/b2fZXIQ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765565029; c=relaxed/simple;
	bh=2HPqsLQLVHyDurVxLFqsgQdUuByRC/iAJ3TxV+Kxows=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBPXREUZL2afs817670DAQclxgPnSgbZQgEltgZ6bTcxSvMbWs9VKDBLgJeHD4Zbe1w20LXg0ue7NZglB1dwx/LOHVqZbLHbP53s1oxLcS9RxN0eSD1FFULrogtIJDhRyqg0RLYyHZUhiTB2SLmLhliJiu8zfx8PIeW3B1tG9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R1ADOYHl; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R1ADOYHl"
Date: Fri, 12 Dec 2025 18:43:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765565022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkoC9XWWPULzArIPL3U+sa96HBni49Kt2rCzkNlq5t8=;
	b=R1ADOYHlub0M/KbSRdIhf2T3VCcTZxmsBlp3fmVIgDnB7ES/8Mw38pY+Qt+KmtpqY3IO5x
	BOFAg1tfc8BxdsoGt4SpVEMUFCTU1MABXowIbbwvKUI579zeH9UthNlKEF4BCi1FzBxZrT
	l51kTl7BM5XwHYt5sC9AUzJz2YyjWzw=
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
Message-ID: <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 12, 2025 at 06:17:07PM +0000, Sridhar, Kanchana P wrote:
> > 
> > >  	ret =
> > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > >  				       &pool->node);
> > >  	if (ret)
> > > -		goto error;
> > > +		goto ref_fail;
> > 
> > IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> > probably should add a new label.
> 
> In this case we should because it is part of the pool creation failure
> handling flow, at the end of which, the pool will be deleted.

What I mean is, when cpuhp_state_add_instance() fails we goto ref_fail
which will call cpuhp_state_remove_instance(). But the current code does
not call cpuhp_state_remove_instance() if cpuhp_state_add_instance()
fails.

> 
> > 
> > >
> > >  	/* being the current pool takes 1 ref; this func expects the
> > >  	 * caller to always add the new pool as the current pool
> > > @@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char
> > *compressor)
> > >
> > >  ref_fail:
> > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > &pool->node);
> > > +
> > > +	for_each_possible_cpu(cpu)
> > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > >  error:
> > >  	if (pool->acomp_ctx)
> > >  		free_percpu(pool->acomp_ctx);
> > > @@ -322,9 +346,15 @@ static struct zswap_pool
> > *__zswap_pool_create_fallback(void)
> > >
> > >  static void zswap_pool_destroy(struct zswap_pool *pool)
> > >  {
> > > +	int cpu;
> > > +
> > >  	zswap_pool_debug("destroying", pool);
> > >
> > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > &pool->node);
> > > +
> > > +	for_each_possible_cpu(cpu)
> > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > > +
> > >  	free_percpu(pool->acomp_ctx);
> > >
> > >  	zs_destroy_pool(pool->zs_pool);
> > > @@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int
> > cpu, struct hlist_node *node)
> > >  {
> > >  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool,
> > node);
> > >  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > >acomp_ctx, cpu);
> > > -	struct crypto_acomp *acomp = NULL;
> > > -	struct acomp_req *req = NULL;
> > > -	u8 *buffer = NULL;
> > > -	int ret;
> > > +	int ret = -ENOMEM;
> > >
> > > -	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > > -	if (!buffer) {
> > > -		ret = -ENOMEM;
> > > -		goto fail;
> > > -	}
> > > +	/*
> > > +	 * To handle cases where the CPU goes through online-offline-online
> > > +	 * transitions, we return if the acomp_ctx has already been initialized.
> > > +	 */
> > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > +		return 0;
> > 
> > Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
> > then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
> > that case?
> 
> This is checking for a valid acomp_ctx->acomp using the same criteria
> being uniformly used in acomp_ctx_dealloc(). This check is necessary to
> handle the case where the CPU goes through online-offline-online state
> transitions.

I think I am confused. I thought now we don't free this on CPU offline,
so either it's NULL because this is the first time we initialize it on
this CPU, or it is allocated. If it is an ERR value, then the pool
creation should have failed and we wouldn't be calling this again on CPU
online.

In other words, what scenario do we expect to legitimately see an ERR
value here?
