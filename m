Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A281A3154
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765301529; cv=none; b=QMGFTfBdBviuwiVA+iAq6Bhz7VxrmGPaj6Itto1ANj+pY9jlaz4G2OqphxQb9C9KN8DWJt/HZjyCozOfKa4mfffjbUC/a0e9VkazvfdGs8+Pw2+uHqwdAuOTFjB/qZEE4MUq4fS4Y+WwojZzwFtdvEYmePrdV+Qtv9WybwunAxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765301529; c=relaxed/simple;
	bh=okhRmd0k9JrXvX7ahpAZVBy5qCLwEZ9tzVAP7xD7ZzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TX7Fh3J46VYABjF00wn4I6sBBU0kZpfum6XYH1kLS8lNfj6IPkbK+8otfLaUXTJ3BKMakFN5goGcENSeiN7zYDxA/34aslz2m+3xG05PFz9y+HG+42+XH5eZD2cYanxP/dgFC7TYIeOjhSBFu0jeiv4kF96p/a/ijZMimjFUf8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oro8iw+y; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oro8iw+y"
Date: Tue, 9 Dec 2025 17:31:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765301513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k0r6smmgNfGvVjQrSAgG2MQSRnerif7fVYwrIvFf+EA=;
	b=oro8iw+yCYsySwiIDvfYRW4SEi3cU6GqUjVPipwHfrmZXzH2l7EayPnm2QMKAVWOAA78pM
	1jteLiceqnsVJ9Yo+w2/Ug+vi/qfA2Vz6soCMohKlCVg7Mqa/Y+Fg3hPCMRRVhmflXlGcW
	tgEdAAkMz9bGWBBRsSJg/339Rs1Atpg=
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
Message-ID: <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
References: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 05:21:06PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Tuesday, December 9, 2025 8:55 AM
> > To: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
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
> > On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > > >
> > > > Just to clarify, does this mean that zswap can pass a batch of (eight)
> > > > pages to the acomp API, and get the results for the batch uniformly
> > > > whether or not the underlying compressor supports batching?
> > >
> > > Correct.  In fact I'd like to remove the batch size exposure to zswap
> > > altogether.  zswap should just pass along whatever maximum number of
> > > pages that is convenient to itself.
> > 
> > I think exposing the batch size is still useful as a hint for zswap. In
> > the current series, zswap allocates as many per-CPU buffers as the
> > compressor's batch size, so no extra buffers for non-batching
> > compressors (including SW compressors).
> > 
> > If we use the same batch size regardless, we'll have to always allocate
> > 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> > compressors.
> > 
> > So we still want the batch size on the zswap side, but we want the
> > crypto API to be uniform whether or not the compressor supports
> > batching.
> 
> Thanks Yosry, you bring up a good point. I currently have the outer for
> loop in zswap_compress() due to the above constraint. For non-batching
> compressors, we allocate only one per-CPU buffer. Hence, we need to
> call crypto_acomp_compress() and write the compressed data to the
> zs_poll for each page in the batch. Wouldn't we need to allocate
> 8 per-CPU buffers for non-batching compressors if we want zswap to
> send a batch of 8 pages uniformly to the crypto API, so that
> zswap_compress() can store the 8 pages in zs_pool after the crypto
> API returns?

Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
compressors.

I think the cleanest way to handle this would be to:
- Rename zswap_compress() to __zswap_compress(), and make it handle a
  given batch size (which would be 1 or 8).
- Introduce zswap_compress() as a wrapper that breaks down the folio
  into batches and loops over them, passing them to __zswap_compress().
- __zswap_compress() has a single unified path (e.g. for compressed
  length and error handling), regardless of the batch size.

Can this be done with the current acomp API? I think all we really need
is to be able to pass in a batch of size N (which can be 1), and read
the error and compressed length in a single way. This is my main problem
with the current patch.

In the future, if it's beneifical for some SW compressors to batch
compressions, we can look into optimizations for the per-CPU buffers to
avoid allocating 8 pages per-CPU (e.g. shared page pool), or make this
opt-in for certain SW compressors that justify the cost.

> 
> Thanks,
> Kanchana
> 
> > 
> > >
> > > Cheers,
> > > --
> > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > Home Page: http://gondor.apana.org.au/~herbert/
> > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
