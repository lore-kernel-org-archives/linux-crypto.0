Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4004293C4E
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 04:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765514467; cv=none; b=L67sF/a49DS/Opi6afkLQL+fxvpqA3ZkTV8SVLrcnRS52yjQNG7Ala/3XmLU7iPgWmxWIncM/QCvfpQLP0f8iu/kAIKv34GIDN9PxyCNYUfbM7hdRk1yHWvdEW59ED3OcfgdHn7/E4FqAas+Wa/5POJMuz/xaZOdI+MLD7pSbXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765514467; c=relaxed/simple;
	bh=hhhmHqaEoRpcCfCE0LuZhy0p/UK9976lVQui6bGbyrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6K04iu84WoJpWpEpgEPUzupcA0kADeEOnWZcR/Idry1MmTXUNZ9d/r3f3iuRN+KC5TdeOncvLFs10+QCIMti+29VznxoA7lbvIPflVwH5zNXarwceAGurltZKhq9zzVLIdX6o3QTDyUcsvi1a+uD908kXUltq6BDP+6PaXwuM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ClgzUaV6; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ClgzUaV6"
Date: Fri, 12 Dec 2025 04:40:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765514458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKAqM3auLcUWVEG/CGpBLBCuxFDBqzTE3fKRBrAdSPA=;
	b=ClgzUaV6JPUtQzlZahw94WSyjGJZeE5TJs/CVOmwIa/6tY7Cjgylvd2FokG5CpMSQ1FAdz
	tDYi8jcjq/kCbmcrGDGsBflOfOtib7FkNO+13YQ/zFWGjnTaE2fYkt2jph1vEPY0Wzgo7/
	5K5RkqEU/3x6TzjgvhJ0lH3Wp6u0o+U=
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
Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Message-ID: <okfbc6hqk63qn4bxcryhmfmtjnzzaswtk2emev7lpjr5flrwiu@3g2o7geu5zgm>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <3i4jpzank53niagxzddc3vmzi5s3o5kmernzitktyavd5jwvp5@ytxzww57ux7a>
 <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 12, 2025 at 01:43:54AM +0000, Sridhar, Kanchana P wrote:
[..]
> > 
> > Instead of this:
> > 
> > > +/*
> > > + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number
> > otherwise.
> > > + * The code for __kmem_cache_alloc_bulk() indicates that this positive
> > number
> > > + * will be the @size requested, i.e., @nr_entries.
> > > + */
> > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > **entries,
> > > +							   unsigned int
> > nr_entries,
> > > +							   gfp_t gfp)
> > > +{
> > > +	int nr_alloc = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > > +					     nr_entries, entries);
> > > +
> > 
> > Add this here:
> > 	/*
> > 	 * kmem_cache_alloc_bulk() should return nr_entries on success
> > 	 * and 0 on failure.
> > 	 */
> > 
> 
> Sure.
> 
> > > +	WARN_ON(!nr_alloc || (nr_alloc != nr_entries));
> > 
> > WARN_ON_ONCE() is sufficient, and why do we WARN if
> > kmem_cache_alloc_bulk() fails? I thought that was expected in some
> > cases.
> 
> I can change this to a WARN_ON_ONCE(). The code for kmem_cache_alloc_bulk()
> makes sure that either all entries are allocated, or none are allocated
> (partial allocations are freed and 0 returned in case of the latter). It can be expected
> to fail based on this.

Right, I mean specifically the !nr_alloc case. This should be expected,
so we should not WARN in this case, right? IIUC, we should do:

	WARN_ON_ONCE(nr_alloc && nr_alloc != nr_entries)

> 
> I believe there was an earlier comment for which I added the WARN_ON? I can
> either change this to WARN_ON_ONCE() or drop the WARN_ON_ONCE(), since
> we anyway have a fallback mechanism.
> 
> > 
> > > +
> > > +	return nr_alloc;
> > > +}
> > > +
> > 
[..]
> > > +static bool zswap_store_pages(struct folio *folio,
> > > +			      long start,
> > > +			      long end,
> > > +			      struct obj_cgroup *objcg,
> > > +			      struct zswap_pool *pool,
> > > +			      int nid,
> > > +			      bool wb_enabled)
> > >  {
> > > -	swp_entry_t page_swpentry = page_swap_entry(page);
> > > -	struct zswap_entry *entry, *old;
> > > -
> > > -	/* allocate entry */
> > > -	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > > -	if (!entry) {
> > > -		zswap_reject_kmemcache_fail++;
> > > -		return false;
> > > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > > +	u8 i, store_fail_idx = 0, nr_pages = end - start;
> > > +
> > > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > > +
> > > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
> > 
> > Is this equivalent to just passing in 'entries'?
> 
> It is, however, I wanted to keep this equivalent to the failure case call to
> zswap_entries_cache_free_batch(), that passes in the address of the
> batch index that failed xarray store.

I understand, but I think it's clearer to pass 'entries'. Also, can we
make zswap_entries_cache_alloc_batch() take in the proper type and avoid
the cast at the callsites?

> 
> > 
> > > +						      nr_pages, GFP_KERNEL)))
> > {
> > > +		for (i = 0; i < nr_pages; ++i) {
> > > +			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL,
> > nid);
> > > +
> > > +			if (unlikely(!entries[i])) {
> > > +				zswap_reject_kmemcache_fail++;
> > > +				/*
> > > +				 * While handling this error, we only need to
> > > +				 * call zswap_entries_cache_free_batch() for
> > > +				 * entries[0 .. @i-1].
> > > +				 */
> > > +				nr_pages = i;
> > > +				goto store_pages_failed;
> > > +			}
> > > +		}
> > 
> > 
> > Maybe move the fallback loop into zswap_entries_cache_alloc_batch()?
> 
> I could, however, I would need to modify the API to return the error index "i",
> so that the "goto store_pages_failed" works. Imo, inlining this makes the error
> handling more apparent, but let me know.

Hmm yeah. Maybe make zswap_entries_cache_alloc_batch() free the already
allocated entries on failure? Then if zswap_entries_cache_alloc_batch()
fails we exit without goto store_pages_failed. This is the first failure
mode so we don't need any further cleanup anyway.
