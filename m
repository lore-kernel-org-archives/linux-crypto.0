Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A92F530A
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763149480; cv=none; b=IaNFGY2HwerflmoCgphWuh8osHmn1QEHeerqgE1fxPFqiTRNewKf31uXKmFYZlhaeiRcHOh1BcciAqAg+ETjo+kW/TOpROxIH7fyg3fxgO76xoo8NmlGkWGunASmTtfKqlJ73H3vsV9xAtihmeN1T0bY1G59lkmkAp4uqdz35mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763149480; c=relaxed/simple;
	bh=dhqHPwyJFbJ/WMsS+rxC8AnN8GcYb0NAeNQAV2VyS4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMnNwrLjd6axkTeFPYxXe1Lnc7sRyg64NVsl7qq76IVbDBk6IYjnQM8PvgIKjwfu+SnCERqfw+1x1XIQAsit7lZZrh0CtVLxI/JzvRbtE6k/Gn2LAgngjIT/Qql78lP0S7DMdgK5Nl4J6wZld2OVZJ9sruuACpL2ysxWdFUjDrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oECBROwT; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oECBROwT"
Date: Fri, 14 Nov 2025 19:44:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763149463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmtmWeVNeDQubCUVIegKVeaojqJ5R7D+neANaxfZ/xM=;
	b=oECBROwTZkUKRWuM22PjHPCS/YhfD5lND8hPGbXU6uUs8SYac1gb+XRHmW6iqtkb7imn85
	sP+Hn5rjdoo/uLNvFcPFpxV42UR9uOTmYsDBn1/R+0bX4O/ZFWcxdT/9FW9mAkZF+7VBI/
	wC5h61dzOV6ofF+MxRf9zPsBXkYQlSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: SeongJae Park <sj@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "usamaarif642@gmail.com" <usamaarif642@gmail.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <keys236tojsj7a4lx6tyqtr3hbhvtjtkbpb73zejgzxmegjwrb@i2xkzvgp5ake>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 14, 2025 at 07:23:42PM +0000, Sridhar, Kanchana P wrote:
[..]
 > > > > >
> > > > > > > +		if (err && !wb_enabled)
> > > > > > > +			goto compress_error;
> > > > > > > +
> > > > > > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg,
> > nr_comps, k) {
> > > > > > > +			j = k + i;
> > > > > >
[..]
> > > > >
> > > > > >
> > > > > > > +			dst = acomp_ctx->buffers[k];
> > > > > > > +			dlen = sg->length | *errp;
> > > > > >
> > > > > > Why are we doing this?
> > > > > >
> > > > > > > +
> > > > > > > +			if (dlen < 0) {
> > > > > >
> > > > > > We should do the incompressible page handling also if dlen is
> > PAGE_SIZE,
> > > > > > or if the compression failed (I guess that's the intention of bit OR'ing
> > > > > > with *errp?)
> > > > >
> > > > > Yes, indeed: that's the intention of bit OR'ing with *errp.
> > > >
> > > > ..and you never really answered my question. In the exising code we
> > > > store the page as incompressible if writeback is enabled AND
> > > > crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
> > > > if crypto_wait_req() fails and writeback is disabled, but what about the
> > > > rest?
> > >
> > > Let me explain this some more. The new code only relies on the assumption
> > > that if dlen is zero or >= PAGE_SIZE, the compressor will not return a 0
> > > ("successful status"). In other words, the compressor will return an error
> > status
> > > in this case, which is expected to be a negative error code.
> > 
> > I am not sure if all compressors do that, especially for the case where
> > dlen >= PAGE_SIZE. The existing code does not assume that there will be
> > an error code in these cases.
> > 
> > For the dlen == 0 case, the check was introduced recently by commit
> > dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> > as-is"). Looking through the history it seems like it was introduced in
> > v4 of that patch but I don't see the reasoning.
> 
> The existing code did not check for dlen == 0 and dlen >= PAGE_SIZE
> prior to commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression
> failed page as-is") either. We need SeongJae or Herbert to clarify whether
> this check is needed, or if it is sufficient to rely on comp_ret, the return from
> crypto_wait_req().
> 
> > 
> > SeongJae, did you observe any compressors returning dlen == 0 but no
> > error code? What was the reasoning behind the dlen == 0 check?
> > 
> > >
> > > Under these (hopefully valid) assumptions, the code handles the simple case
> > > of an error compression return status and writeback is disabled, by the
> > > "goto compress_error".
> > >
> > > The rest is handled by these:
> > >
> > > 1) First, I need to adapt the use of sg_outputs->sgl->length to represent the
> > > compress length for software compressors, so I do this after
> > crypto_wait_req()
> > > returns:
> > >
> > >                 acomp_ctx->sg_outputs->sgl->length = acomp_ctx->req->dlen;
> > 
> > For SW compressors, why is acomp_ctx->sg_outputs->sgl->length not set?
> > IIUC we are using the same API for SW and HW compressors, why is the
> > output length in different places for each of them?
> 
> This is to first implement the SG lists batching interface in iaa_crypto, while
> maintaining backward compatibility for SW compressors with the new API.
> I believe we may want to adapt the crypto API to SW compressors
> at a later point. I also believe this would be outside the scope of this patch.
> It would be nice if Herbert can share his vision on this aspect.
> 
> > 
> > >
> > > I did not want to propose any changes to crypto software compressors
> > protocols.
> > >
> > > 2) After the check for the "if (err && !wb_enabled)" case, the new code has
> > this:
> > >
> > >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > >                         j = k + i;
> > >                         dst = acomp_ctx->buffers[k];
> > >                         dlen = sg->length | *errp;
> > >
> > >                         if (dlen < 0) {
> > >                                 dlen = PAGE_SIZE;
> > >                                 dst = kmap_local_page(folio_page(folio, start + j));
> > >                         }
> > >
> > > For batching compressors, namely, iaa_crypto, the individual output SG
> > > lists sg->length follows the requirements from Herbert: each sg->length
> > > is the compressed length or the error status (a negative error code).
> > >
> > > Then all I need to know whether to store the page as incompressible
> > > is to either directly test if sg->length is negative (for batching compressors),
> > > or sg->length bit-OR'ed with the crypto_wait_req() return status ("err")
> > > is negative. This is accomplished by the "dlen = sg->length | *errp;".
> > >
> > > I believe this maintains backward compatibility with the existing code.
> > > Please let me know if you agree.
> > 
> > For batching compressors, will 'err' be set as well, or just sg->length?
> > If it's just sg->length, then we need to check again if WB is enabled
> > here before storing the page uncompressed. Right?
> 
> iaa_crypto will set 'err' and set the sg->length as per the batching interface
> spec from Herbert.

So both 'err' and sg->length will contain the same error? In this case
why do we need to check if dlen < 0? Shouldn't checking 'err' be
sufficient? and it would work for both SW and HW and we wouldn't need
errp. Did I miss something?

> 
> > 
> > >
> > > >
> > > > We don't check again if writeback is enabled before storing the page is
> > > > incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
> > > > these cases no longer possible?
> > >
> > > Hope the above explanation clarifies things some more? These case
> > > are possible, and as long as they return an error status, they should be
> > > correctly handled by the new code.
> > 
> > As mentioned above, I am not sure if that's correct for dlen >=
> > PAGE_SIZE.
> 
> We need to get clarity on this from SeongJae/Herbert.
> 
> > 
> > >
> > > >
> > > > Also, why use errp, why not explicitly use the appropriate error code?
> > > > It's also unclear to me why the error code is always zero with HW
> > > > compression?
> > >
> > > This is because of the sg->length requirements (compressed length/error)
> > > for the batching interface suggested by Herbert. Hence, I upfront define
> > > err_sg to 0, and, set errp to &err_sg for batching compressors. For software
> > > compressors, errp is set to &err, namely, the above check will always apply
> > > the software compressor's error status to the compressed length via
> > > the bit-OR to determine if the page needs to be stored uncompressed.
> > 
> > Thanks for the clarification. I understand that the error code has
> > different sources for SW and HW compressors, but I do not like using
> > errp as an indirection. It makes the code unclear. I would rather we
> > explicitly check err for SW compressors and dlen for HW compressors.
> > 
> > That being said, I thought what Herbert suggested was that the same API
> > is used for both SW and HW compressors. IOW, either way we submit a
> > batch of pages (8 pages for SW compressors), and then the crypto API
> > would either give the entire batch to the compressor if it supports
> > batching, or loop over them internally and hand them page-by-page to
> > the compressor.
> 
> That was not how I understood Herbert's suggestion for the batching interface.
> He did suggest the following:
> 
> "Before the call to acomp, the destination SG list should contain as
> many elements as the number of units.  On return, the dst lengths
> should be stored in each destination SG entry."
> 
> I have incorporated this suggestion in the iaa_crypto driver. For SW
> compressors, I have tried not to propose any API changes, while making
> sure that the zswap changes for the SG lists batching API work as expected
> for SW without too much special-casing code.
> 
> I suppose I always assumed that we would update SW compressors later,
> and not as part of this patch-set.

I am not sure I understand what changes lie in the crypto layer and what
changes lie in the SW compressors. I am not suggesting we do any
modification to the SW compressors.

I imagined that the crypto layer would present a uniform API regardless
of whether or not the compressor supports batching. Ideally zswap would
pass in a batch to crypto and it would figure out if it needs to break
them down or not. Then the output length and errors would be presented
uniformly to the caller.

That being said, I am not at all familiar with how crypto works and how
straightforward that would be. Herbert, WDYT?

> 
> > 
> > This would simplify usage as we do not have to handle the differences in
> > zswap.
> 
> That's the nice thing about SG lists - I think the zswap_compress() calls to
> the new batching API appears agnostic to SW and HW compressors.
> Other than the upfront "errp = (pool->compr_batch_size == 1) ? &err : &err_sg;"
> the logical code organization of the new zswap_compress() is quite similar to
> the existing code. The post-compress "dlen = sg->length | *errp;" handles the rest.

It would be even nicer if the batches are also abstracted by SG lists.

Also, I don't like how the error codes and output lengths are presented
differently for HW and SW compressors.
