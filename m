Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916F81FDA92
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 05:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099559; cv=none; b=Rfr67Vs9dczM0sjdY1yEbxBCJprYkgfcaHIDxbulquALa5g6LXa2fDtu+1aK6aw5n6gPuPlxPBHaNGwzueynqt2LZmSFJKhpeiWBP70M+jLqRCLhLcyx6zB7vJ68LNbZ2yj3gAVk0gPXdQtWQ1bu5nGLsJF3TY7VaLYsMkv6cfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099559; c=relaxed/simple;
	bh=HJ9fq5KFA2WXbJbM4wkAhfACjzvC7TSJ+QfsiP6Q5Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQ1CY7CpMYPqVNMpeb6XiGGspJfSojRUN1eM1lgitDd6MVrJhZd6G1grxWWPmhvVp1Ycl86K9KGZ4SrronFdAbU1BlPyx/MYCO2qeR7EQm3up2e01jFWVVHKP0c6rf+PQX7TH2w1sBEzrfWDmMZ2J7NXJucaZUD4rNnw0tCqr3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I4Zby4cW; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I4Zby4cW"
Date: Fri, 14 Nov 2025 05:52:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763099554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jXkxn+nUrE4qhcH53ASIXVe+cIbpnFTU4tsJNDHC20I=;
	b=I4Zby4cWK2XFX5NxE4X+qHrxjoy5T/HYxLZrxPbMMl9bUlmDerYHa0lpiGb6YgQpuPzFTZ
	Wtf8HEMRXWaWYQNSKHTyCgYSjs60uxptFvI7K1dJ1YnvNApqgx7ot5Xa7Cu8DZYMJdGCZm
	AytU+hPToISs+NkMJgd7rnXrXiUq+vo=
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
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 11:55:10PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 1:35 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> > 
[..]
> > > +		/*
> > > +		 * If a page cannot be compressed into a size smaller than
> > > +		 * PAGE_SIZE, save the content as is without a compression,
> > to
> > > +		 * keep the LRU order of writebacks.  If writeback is disabled,
> > > +		 * reject the page since it only adds metadata overhead.
> > > +		 * swap_writeout() will put the page back to the active LRU
> > list
> > > +		 * in the case.
> > > +		 *
> > > +		 * It is assumed that any compressor that sets the output
> > length
> > > +		 * to 0 or a value >= PAGE_SIZE will also return a negative
> > > +		 * error status in @err; i.e, will not return a successful
> > > +		 * compression status in @err in this case.
> > > +		 */
> > 
> > Ugh, checking the compression error and checking the compression length
> > are now in separate places so we need to check if writeback is disabled
> > in separate places and store the page as-is. It's ugly, and I think the
> > current code is not correct.
> 
> The code is 100% correct. You need to spend more time understanding
> the code. I have stated my assumption above in the comments to
> help in understanding the "why".
> 
> From a maintainer, I would expect more responsible statements than
> this. A flippant remark made without understanding the code (and,
> disparaging the comments intended to help you do this), can impact
> someone's career. I am held accountable in my job based on your
> comments.
> 
> That said, I have worked tirelessly and innovated to make the code
> compliant with Herbert's suggestions (which btw have enabled an
> elegant batching implementation and code commonality for IAA and
> software compressors), validated it thoroughly for IAA and ZSTD to
> ensure that both demonstrate performance improvements, which
> are crucial for memory savings. I am proud of this work.
> 
> 
> > 
> > > +		if (err && !wb_enabled)
> > > +			goto compress_error;
> > > +
> > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > +			j = k + i;
> > 
> > Please use meaningful iterator names rather than i, j, and k and the huge
> > comment explaining what they are.
> 
> I happen to have a different view: having longer iterator names firstly makes
> code seem "verbose" and detracts from readability, not to mention exceeding the
> 80-character line limit. The comments are essential for code maintainability
> and avoid out-of-bounds errors when the next zswap developer wants to
> optimize the code.
> 
> One drawback of i/j/k iterators is mis-typing errors which cannot be caught
> at compile time. Let me think some more about how to strike a good balance.
> 
> > 
> > > +			dst = acomp_ctx->buffers[k];
> > > +			dlen = sg->length | *errp;
> > 
> > Why are we doing this?
> > 
> > > +
> > > +			if (dlen < 0) {
> > 
> > We should do the incompressible page handling also if dlen is PAGE_SIZE,
> > or if the compression failed (I guess that's the intention of bit OR'ing
> > with *errp?)
> 
> Yes, indeed: that's the intention of bit OR'ing with *errp.

..and you never really answered my question. In the exising code we
store the page as incompressible if writeback is enabled AND
crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
if crypto_wait_req() fails and writeback is disabled, but what about the
rest?

We don't check again if writeback is enabled before storing the page is
incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
these cases no longer possible?

Also, why use errp, why not explicitly use the appropriate error code?
It's also unclear to me why the error code is always zero with HW
compression?

> 
> > 
> > > +				dlen = PAGE_SIZE;
> > > +				dst = kmap_local_page(folio_page(folio, start
> > + j));
> > > +			}
> > > +
> > > +			handle = zs_malloc(pool->zs_pool, dlen, gfp, nid);
> > >
> > > -	zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > -	entry->handle = handle;
> > > -	entry->length = dlen;
> > > +			if (IS_ERR_VALUE(handle)) {
> > > +				if (PTR_ERR((void *)handle) == -ENOSPC)
> > > +					zswap_reject_compress_poor++;
> > > +				else
> > > +					zswap_reject_alloc_fail++;
> > >
> > > -unlock:
> > > -	if (mapped)
> > > -		kunmap_local(dst);
> > > -	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
> > > -		zswap_reject_compress_poor++;
> > > -	else if (comp_ret)
> > > -		zswap_reject_compress_fail++;
> > > -	else if (alloc_ret)
> > > -		zswap_reject_alloc_fail++;
> > > +				goto err_unlock;
> > > +			}
> > > +
> > > +			zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > +			entries[j]->handle = handle;
> > > +			entries[j]->length = dlen;
> > > +			if (dst != acomp_ctx->buffers[k])
> > > +				kunmap_local(dst);
> > > +		}
> > > +	} /* finished compress and store nr_pages. */
> > > +
> > > +	mutex_unlock(&acomp_ctx->mutex);
> > > +	return true;
> > > +
> > > +compress_error:
> > > +	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > +		if ((int)sg->length < 0) {
> > > +			if ((int)sg->length == -ENOSPC)
> > > +				zswap_reject_compress_poor++;
> > > +			else
> > > +				zswap_reject_compress_fail++;
> > > +		}
> > > +	}
> > >
> > > +err_unlock:
> > >  	mutex_unlock(&acomp_ctx->mutex);
> > > -	return comp_ret == 0 && alloc_ret == 0;
> > > +	return false;
> > >  }
> > >
> > >  static bool zswap_decompress(struct zswap_entry *entry, struct folio
> > *folio)
> > > @@ -1488,12 +1604,9 @@ static bool zswap_store_pages(struct folio
> > *folio,
> > >  		INIT_LIST_HEAD(&entries[i]->lru);
> > >  	}
> > >
> > > -	for (i = 0; i < nr_pages; ++i) {
> > > -		struct page *page = folio_page(folio, start + i);
> > > -
> > > -		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> > > -			goto store_pages_failed;
> > > -	}
> > > +	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, pool,
> > > +				     nid, wb_enabled)))
> > > +		goto store_pages_failed;
> > >
> > >  	for (i = 0; i < nr_pages; ++i) {
> > >  		struct zswap_entry *old, *entry = entries[i];
> > > --
> > > 2.27.0
> > >
