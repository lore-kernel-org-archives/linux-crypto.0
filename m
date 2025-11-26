Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756C9463;
	Wed, 26 Nov 2025 06:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764138899; cv=none; b=BFW0uqIbolyEfVDwhHzmjqGKF/1NXerH7mJpPT+kDdtHBGthBdo6fYTKjYp1+97GV/ZAnvvIl/wjmjZus8Snbccf/6yfupOz7HvWlwOGhi/UyyMePHaI8L+CW+Pro9fSGx7RMr1+FzdwiHG9yXPUyHxjQWgAC5B0xaqJku0e69o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764138899; c=relaxed/simple;
	bh=QBkjFmbicvkGO3ZEAtcpkCtIjtY98edEsKATlOAZ0pQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYdpLWsQbuwUwwYH9YPsJAx0CZ1WWvy3sFH+uCEwqTknvsRT2uEWcW0JD4QPCKmPntb3XnAFaLKsd3EKNKZgUt3Pw/scYX46r0FAbao3FjIPanjIvvmOHDAZGWF/vZOB+VMCd6rLLh3sSqR54PcPSt0XC8ABCyYvqZdVQ9K2U2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z/1NgAnW; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z/1NgAnW"
Date: Wed, 26 Nov 2025 06:34:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764138893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pt3UEXc3/Z0TV1okLPkYdDhe3DfPfF0KumEJGXKpnc4=;
	b=Z/1NgAnWeaYRTwRyoaHBMoUoPuUlstfNUGHAfAtiGEkjTykAe3zrpTXgovCyTnFNg5WW1j
	FGKWaS7yJhssoDVCZ53OZ/cnaHN5te5Qtb9hfofHcCZhA/BOEwzZTIhs22+mW4FCJ46Uhz
	+t1+Cv16cU+qbQvGmE4J3+Yf7D3wfcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
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
Message-ID: <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 26, 2025 at 01:46:57PM +0800, Herbert Xu wrote:
> On Fri, Nov 14, 2025 at 03:37:53PM +0000, Yosry Ahmed wrote:
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
> > 
> > This would simplify usage as we do not have to handle the differences in
> > zswap.
> > 
> > If that is not doable, at the very least the API should be consistent.
> > Right now the error code and length are propagated differently to the
> > caller based on whether or not the compressor support batching.
> 
> Yes we should only have one code path in zswap, regardless of whether
> batching is used or not.
> 
> The degenerate case of a batch with a single page should be handled
> by the Crypto API.
> 
> So I will change crypto_acomp to take care of this case.

Nice :)

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
