Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E7B2FD7D2
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765382534; cv=none; b=Pt7IlEGVBl4sb/5kFJ9gAsK28xfVARkQOJPnFGMRIjn9Gx+2A96BU/UNMwqWKPToz1Fnv7PajfcXz3i5wJt22ELzLKUkcVm6BH+PrSj2O9u1HgU2BJ9Q2UfW2gpvhAo6nTWbNKohNOtGHnplt9QnUoFhQugybawQC4U2etDR+Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765382534; c=relaxed/simple;
	bh=hF5rSjk1M61DJETn2Ptd9E4Evxhs55n7pt+Lct5jdf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCSDNt0RdGyQ7PaDNYEfFWF3RDmGIlAKGFOUPP3tk4NIpDq9VYJ8Y4kcPoxkb9C3PE49XKAz3MQDyyMp3k/P9ZAuhITXX9gEK/UTk/X9thM+eEPLVmCCRbyHJFinQA/hq0nF74qAG7pBfz59VdVLCr+Y02uJXFoqjZ3rFcES2pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qo5LTV5m; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qo5LTV5m"
Date: Wed, 10 Dec 2025 16:01:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765382521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dWoR7UIzQcb07jlgSZ/0O0cJ2y2/O3Euwx3b+WfcfL8=;
	b=qo5LTV5mTOnx7nIoTU+LKhYwSrfrTkAeZCQdagkhS+BEeI3hmFSvbe/JuD6qH6K8chR8R3
	JWnrrO9QyYWYXi0+9vxUEWAAKORhM7fnlO68nFiwGNndu2k6Jqdm76GEv6NLru2zruclAg
	vHX1YivYOm6Ckn6M6wHoanBUEQQjQZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <yhecgcnt52hnsyf23p576mz2mlnffqrluikwzv6tdn3bnmzumc@thpyltdpxtjq>
References: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
 <SJ2PR11MB8472D347836B6CA3FEB0CDEEC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472D347836B6CA3FEB0CDEEC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 07:38:20PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Tuesday, December 9, 2025 9:32 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; SeongJae Park
> > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> > 
> > On Tue, Dec 09, 2025 at 05:21:06PM +0000, Sridhar, Kanchana P wrote:
> > >
> > > > -----Original Message-----
> > > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > Sent: Tuesday, December 9, 2025 8:55 AM
> > > > To: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> > > > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > > hannes@cmpxchg.org; nphamcs@gmail.com;
> > chengming.zhou@linux.dev;
> > > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > > > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > > > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > > > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > > > <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>;
> > > > Gopal, Vinodh <vinodh.gopal@intel.com>
> > > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> > with
> > > > compress batching of large folios.
> > > >
> > > > On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > > > > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > > > > >
> > > > > > Just to clarify, does this mean that zswap can pass a batch of (eight)
> > > > > > pages to the acomp API, and get the results for the batch uniformly
> > > > > > whether or not the underlying compressor supports batching?
> > > > >
> > > > > Correct.  In fact I'd like to remove the batch size exposure to zswap
> > > > > altogether.  zswap should just pass along whatever maximum number of
> > > > > pages that is convenient to itself.
> > > >
> > > > I think exposing the batch size is still useful as a hint for zswap. In
> > > > the current series, zswap allocates as many per-CPU buffers as the
> > > > compressor's batch size, so no extra buffers for non-batching
> > > > compressors (including SW compressors).
> > > >
> > > > If we use the same batch size regardless, we'll have to always allocate
> > > > 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> > > > compressors.
> > > >
> > > > So we still want the batch size on the zswap side, but we want the
> > > > crypto API to be uniform whether or not the compressor supports
> > > > batching.
> > >
> > > Thanks Yosry, you bring up a good point. I currently have the outer for
> > > loop in zswap_compress() due to the above constraint. For non-batching
> > > compressors, we allocate only one per-CPU buffer. Hence, we need to
> > > call crypto_acomp_compress() and write the compressed data to the
> > > zs_poll for each page in the batch. Wouldn't we need to allocate
> > > 8 per-CPU buffers for non-batching compressors if we want zswap to
> > > send a batch of 8 pages uniformly to the crypto API, so that
> > > zswap_compress() can store the 8 pages in zs_pool after the crypto
> > > API returns?
> > 
> > Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> > compressors.
> > 
> > I think the cleanest way to handle this would be to:
> > - Rename zswap_compress() to __zswap_compress(), and make it handle a
> >   given batch size (which would be 1 or 8).
> > - Introduce zswap_compress() as a wrapper that breaks down the folio
> >   into batches and loops over them, passing them to __zswap_compress().
> > - __zswap_compress() has a single unified path (e.g. for compressed
> >   length and error handling), regardless of the batch size.
> > 
> > Can this be done with the current acomp API? I think all we really need
> > is to be able to pass in a batch of size N (which can be 1), and read
> > the error and compressed length in a single way. This is my main problem
> > with the current patch.
> 
> Once Herbert gives us the crypto_acomp modification for non-batching
> compressors to set the acomp_req->dst->length to the
> compressed length/error value, I think the same could be accomplished
> with the current patch, since I will be able to delete the "errp". IOW, I think
> a simplification is possible without introducing __zswap_compress(). The
> code will look seamless for non-batching and batching compressors, and the
> distinction will be made apparent by the outer for loop that iterates over
> the batch based on the pool->compr_batch_size in the current patch.

I think moving the outer loop outside to a wrapper could make the
function digestable without nested loops.

> 
> Alternately, we could introduce the __zswap_compress() that abstracts
> one single iteration through the outer for loop: it compresses 1 or 8 pages
> as a "batch". However, the distinction would still need to be made for
> non-batching vs. batching compressors in the zswap_compress() wrapper:
> both for sending the pool->compr_batch_size # of pages to
> __zswap_compress() and for iterating over the single/multiple dst buffers
> to write to zs_pool (the latter could be done within __zswap_compress(),
> but the point remains: we would need to distinguish in one or the other).

Not sure what you mean by the latter. IIUC, for all compressors
__zswap_compress() would iterate over the dst buffers and write to
zs_pool, whether the number of dst buffers is 1 or 8. So there wouldn't
be any different handling in __zswap_compress(), right?

That's my whole motivation for introducing a wrapper that abstracts away
the batching size.

> 
> It could be argued that keeping the seamless-ness in handling the calls to
> crypto based on the pool->compr_batch_size and the logical distinctions
> imposed by this in iterating over the output SG lists/buffers, would be
> cleaner being self-contained in zswap_compress(). We already have a
> zswap_store_pages() that processes the folio in batches. Maybe minimizing
> the functions that do batch processing could be cleaner?

Yeah it's not great that we'll end up with zswap_store_pages() splitting
the folio into batches of 8, then zswap_compress() further splitting
them into compression batches -- but we'll have that anyway. Whether
it's inside zswap_compress() or a wrapper doesn't make things much
different imo.

Also, splitting the folio differently at different levels make semantic
sense. zswap_store_pages() splits it into batches of 8, because this is
what zswap handles (mainly to avoid dynamically allocating things like
entries). zswap_compress() will split it further if the underlying
compressor prefers that, to avoid allocating many buffer pages. So I
think it kinda makes sense.

In the future, we can revisit the split in zswap_compress() if we have a
good case for batching compression for SW (e.g. compress every 8 pages
as a single unit), or if we can optimize the per-CPU buffers somehow.

> 
> In any case, let me know which would be preferable.
> 
> Thanks,
> Kanchana
> 
> > 
> > In the future, if it's beneifical for some SW compressors to batch
> > compressions, we can look into optimizations for the per-CPU buffers to
> > avoid allocating 8 pages per-CPU (e.g. shared page pool), or make this
> > opt-in for certain SW compressors that justify the cost.
> > 
> > >
> > > Thanks,
> > > Kanchana
> > >
> > > >
> > > > >
> > > > > Cheers,
> > > > > --
> > > > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > > > Home Page: http://gondor.apana.org.au/~herbert/
> > > > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
