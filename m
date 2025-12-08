Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872362309AA;
	Mon,  8 Dec 2025 03:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765164270; cv=none; b=ZRrmEKQT1xoC7Kqq1PQzxYLzVt1X3AEtXGN2NHn/0CWjWwDjJgrmgrDSmW3bmXUV6/fbBnPhwMhiQFIU9KeRrwjqwKthe2BI3cbMxU5YNcGls6mmm6yrNlPrgDVApmuN10/vIR7sJ7IILGRqIVw+gVvPLfxKeOjtdZBF2k6F6rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765164270; c=relaxed/simple;
	bh=Pvrc4FadI4rh0F3zdUo69p2LT9Q3nnmRn/wVsyq7fes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBjST/EFj95MOYPKDf2aWPhntl3t319AnGg3AQ3MifVBh2n6oJJNSQ6IUYBg9wS4TGJbSX4tgkGkfquMtQjlh+iHt/9/+ccXRmHrR+dFaEOzmFnimMLICSzMC93jBGjHAAfaB+xJtdzdRqEkBn1fXROE4BDtMC+gfgC1wwrtuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=j00J0/IH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="j00J0/IH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xgnn6MwSl2S/6LuXc1sx4ksRMJ6UXHwQQO3rL1/acEI=; 
	b=j00J0/IHH6pOHYr1EdBh3Pfn8wlSyxziIWLWdek3IBYXF/P9SrYAS3Gs51jEyFdh4bjSifxC5jv
	ii/aC2PJTyv2sutj7cdM1hTQDoP11Fm7e8tRWpwlKpbH3qbQyXE9iJaiBJTT9/oEt8Qqh5dj2jl/A
	sFjnI0WvAu3E5l4ciYVVvKt9wuMZmGO/nQt5qlvI2+wbpFMOuwABCwOoaul2lAm0svQMCmIOHK8Iu
	LObyEF8YMbjrRvOIDBI5CnA5xXUkOe0fFG6nup7EtGu1xBcvk+jf7XHzMwvlD43xzEKTsaReTdJsb
	64CGxDvsyKlgTkA/Ye8oSpj2YQV0I0VR1a+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vSRqn-008iGp-1h;
	Mon, 08 Dec 2025 11:23:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Dec 2025 11:23:49 +0800
Date: Mon, 8 Dec 2025 11:23:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>

On Wed, Nov 26, 2025 at 08:05:40PM +0000, Sridhar, Kanchana P wrote:
>
> Herbert, to make sure I understand, will you be implementing all of these
> features in crypto_acomp for software compressors? I would appreciate it
> if you can clarify:
> 
> 1) Error & compressed length propagation to the dst sg->length only for
>     non-batching compressors.
>     a) For batching compressors, this wouldn't apply since errors could occur
>         for any page in the batch, and the first page (dst sg->length) could have
>         successfully compressed.

This would be the first step.

> 2) Will you also be handling the case where zswap can send an SG list batch
>      with multiple pages to a non-batching compressor, and the crypto_acomp
>      API will internally compress each page sequentially, propagate
>      errors/compress lengths before returning?
>         
> If so, this would really standardize the code in zswap for batching and
> non-batching compressors.

Yes this will be done as the next step.  My understanding is that
your patch-set doesn't require this yet as all non-batching compressors
will have a batch size of 1.

But yes this certainly will be extended, not just with sequential
processing, but we could also use pcrypt/cryptd to parallelise the
compression across CPUs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
