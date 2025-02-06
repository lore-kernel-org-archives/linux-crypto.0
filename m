Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C4C19F464
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869325; cv=none; b=u+QQH82q8+wc3Zwh2KOMKbI8BBAepko/JH6cPpYFrlVcutKpg4nE+HQSUAaXUqx0fR7Y/kKhhmaXI3iA6EBmju3feLFmMPOeAC+A8XiLijrzPVMtzHxEiHzlH3Hytj8d4jo+mVVeyZyjE3F30ESBjUpg1jAs8DTq8nZ0Mu5iflc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869325; c=relaxed/simple;
	bh=fWzD+qN+BgqaeaoPvea644QX2Z9cFg9Vc54iYkvk8/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCzswQTYSUmwf3taJ2jJDidjsX2bCCOKm7b6BxcRZaR3/3SzjkwJ98QvAC7MHu26tFGaaPssYamN+R1hHBNi4wjsdz4rahPHt5kEr8Rwlp1gkPWhgoXGGq07c0plLPZAU0jn31SP9Ziqm8eVBlOZ92TzVmPOW6BxGchqNxQvV5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rhOuGx60; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rhOuGx60"
Date: Thu, 6 Feb 2025 19:15:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738869321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZQyY8MCXQQhnq9axd4H2VgxvWzK3oBbYgT4qwXq3zg=;
	b=rhOuGx60ql/eguU89eWhDhiQ14Rd0VDaXkm3ijXCqFwnFvMnvbHa4UP14hib7Zx9M8PrAo
	Z0xBySVvFJhRYkQRycVd10kFmK+M4Nam4F4sKSOyYPB9LX3jf2SCihncVmkM5ZQYylibMs
	iTPIdx38nl3NZLHnzhSnDV2FcjkbeJE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v6 16/16] mm: zswap: Fix for zstd performance regression
 with 2M folios.
Message-ID: <Z6UKQ04ClABSePLZ@google.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-17-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206072102.29045-17-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 05, 2025 at 11:21:02PM -0800, Kanchana P Sridhar wrote:
> With the previous patch that enables support for batch compressions in
> zswap_compress_folio(), a 6.2% throughput regression was seen with zstd and
> 2M folios, using vm-scalability/usemem.
> 
> For compressors that don't support batching, this was root-caused to the
> following zswap_store_folio() structure:
> 
>  Batched stores:
>  ---------------
>  - Allocate all entries,
>  - Compress all entries,
>  - Store all entries in xarray/LRU.
> 
> Hence, the above structure is maintained only for batched stores, and the
> following structure is implemented for sequential stores of large folio pages,
> that fixes the zstd regression, while preserving common code paths for batched
> and sequential stores of a folio:
> 
>  Sequential stores:
>  ------------------
>  For each page in folio:
>   - allocate an entry,
>   - compress the page,
>   - store the entry in xarray/LRU.
> 
> This is submitted as a separate patch only for code review purposes. I will
> squash this with the previous commit in subsequent versions of this
> patch-series.

Could it be the cache locality?

I wonder if we should do what Chengming initially suggested and batch
everything at ZSWAP_MAX_BATCH_SIZE instead. Instead of
zswap_compress_folio() operating on the entire folio, we can operate on
batches of size ZSWAP_MAX_BATCH_SIZE, regardless of whether the
underlying compressor supports batching.

If we do this, instead of:
- Allocate all entries
- Compress all entries
- Store all entries

We can do:
  - For each batch (8 entries)
  	- Allocate all entries
	- Compress all entries
	- Store all entries

This should help unify the code, and I suspect it may also fix the zstd
regression. We can also skip the entries array allocation and use one on
the stack.
