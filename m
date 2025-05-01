Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28320DD7D;
	Thu,  1 May 2025 01:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746063687; cv=none; b=WlmGp2m1xC32bvhIBIjB1TfyipKmrWaFn0HdsaCkadnll8yaBwInYsU46tGcDyiZJX8ILKCNtKPxEVCc5eLtPIkrGMk8HEiBvSVzd+3s99lOOI9sHX+xkav5kbVVr16zNnNzrSpbpbSEJhJRzuWUcTlNAiSsMWPsIR4vlzoBLqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746063687; c=relaxed/simple;
	bh=JRo1hJI/8W+6ewuuE3wFT/YQUEgeNQ7z+KAfQSOOn3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/Yf8PBADlZvl7GuNx//JMHMtsst5MHfJPMeoEQDRdiXxW8MnXm/DpjIOeck2bsaiFbsZdgBTObcWmCOuqsnK8GKWKQ8lmA8Onduq7ywr5nt5niC4rSKRfpa5ZiijYWbuYgwyioV0HBQHqBbQ/FwNAjWD4gp2ZysisFj7EOYDFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Fmbgifoi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Fmbgifoi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ed9go9csUlM1m+JZ6KkzZFk4Wl1ssOHqWmUSovrkrnA=; b=FmbgifoizgTBZWSlXn7C89RnMW
	Zeusr5as1LP7nJR0o5GZj7fp0u9g1fyY5s5H6Nas9iR6MrpjSclcbLt/igrf4fCVd1Rhamb77nkI6
	6d3Q0TiOceLLlSaOX/jGDb0j/NX60Fa3IhtQpTeCd0IVWPCJzWeZtvW4XfjiepoNBVLyh/chi3NKO
	VfGrov68qtjFF57UhHPVgMLm0+FA3wLRkeNMIk9EFjW6F8BeWd70mJHpDeM2ksBKJqwOhGXS6/0Zm
	KzH2pnMFWyi5qMDtvwyoV+o0cR8KTEcEBgp/QplHHDjHLl/vVNRp9psNJTBzmWRzST6b7e7Hycn7a
	2wBTVbsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAIv4-002R2Q-2g;
	Thu, 01 May 2025 09:40:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 May 2025 09:40:58 +0800
Date: Thu, 1 May 2025 09:40:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Message-ID: <aBLRKuhJOSF8kGZv@gondor.apana.org.au>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
 <20250430205305.22844-11-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430205305.22844-11-kanchana.p.sridhar@intel.com>

On Wed, Apr 30, 2025 at 01:52:56PM -0700, Kanchana P Sridhar wrote:
>
> @@ -127,6 +131,22 @@ struct acomp_req {
>  struct crypto_acomp {
>  	int (*compress)(struct acomp_req *req);
>  	int (*decompress)(struct acomp_req *req);
> +	unsigned int (*get_batch_size)(void);
> +	bool (*batch_compress)(
> +		struct acomp_req *reqs[],
> +		struct page *pages[],
> +		u8 *dsts[],
> +		unsigned int dlens[],
> +		int errors[],
> +		int nr_reqs);
> +	bool (*batch_decompress)(
> +		struct acomp_req *reqs[],
> +		u8 *srcs[],
> +		struct page *pages[],
> +		unsigned int slens[],
> +		unsigned int dlens[],
> +		int errors[],
> +		int nr_reqs);

I shelved request chaining because allocating one request per page
is actively harmful to performance.  So we should not add any
interface that is based on one request per page.

My plan is to supply a whole folio through acomp_request_set_src_folio
and mark it as a batch request with a data unit size of 4K, e.g.:

	acomp_request_set_src_folio(req, folio, 0, len);
	acomp_request_set_data_unit(req, 4096);

Then the algorithm can dice it up in whatever way it sees fit.  For
algorithms that don't support batching, the acompress API should dice
it up and feed it to the algorithm piece-meal.

IOW the folio loop in zswap_store would be moved into the Crypto API.

This is contingent on one API change, bringing back NULL dst support
to acompress.  This way zswap does not need to worry about allocating
memory that might not even be needed (when pages compress well).

This won't look like the useless NULL dst we had before which simply
pre-allocated memory rather than allocating them on demand.

What acompress should do is allocate one dst page at a time, once that
is filled up, then allocate one more.  They should be chained up in an
SG list.  Pages that do not compress can be marked as a zero-length
entry in the SG list.

If the allocation fails at any point in time, simply stop the
batching at that point and return the SG list of what has been
compressed so far.  After processing the returned pages, zswap
can then call acompress again with an offset into the folio to
continue compression.

To prevent pathological cases of zero progress, zswap can provide
one pre-allocated page to seed the process.  For iaa, it should
just allocate as many pages as it needs for batching, and if that
fails, simply fall back to no batching and do things one page at
a time (or however many pages you manage to allocate).

I'll whip up a quick POC and we can work on top of it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
