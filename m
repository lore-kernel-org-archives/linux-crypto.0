Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037741D7E37
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741809384; cv=none; b=EMrIf/DRQI1IFXeNQWlpkbhIAl6a5gW9qxw5/FkBAV0Dn2JsiteXf7yuG1uk7rcFn+drc47+Xc5xUmPgdD+fA863MQK1s1m0qk0D6zKItjXF4HDarGGiCasYfUK4UohMQjyjzUYXHMJHEXp3VZplOKQMC2g4FNWPjV7wELTp/Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741809384; c=relaxed/simple;
	bh=x3KOzNFGwW04TE7eIzmNFwtRL0boZxtzw1HlWlbvdqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THjXP1L7LtULdl6H4u1Wl8gBixBiGimNZOFbiFKfyQrprLfV46bfzaBLnJlhVFg1mcCyNbt4NqhjcJjF8gVlrLYjcDXSc9TNIVhwod8UTBjqSHHks6B5Hf1Z1qEuRtiV0czLL9y3UbVBDT+nGw1AfrFpupx1orCjTfLUOqojxGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q3kAyEnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3kAyEnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D8EC4CEEA;
	Wed, 12 Mar 2025 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741809383;
	bh=x3KOzNFGwW04TE7eIzmNFwtRL0boZxtzw1HlWlbvdqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q3kAyEnAijeF0974XauZl7H5SvwgN+UlKBh2TweLYO2aGKAQ7lwJaI1JFCzZwyX0r
	 D+eZE2j8HNsGgGWAmMHOgYKcysjbI3CzhqLWPF5qVDIfEBedJlMjVHRysT+IFqDsI9
	 aTXzunBniEMtOTQA2M8Q19X+YceY0STcm0/G31JW8W4h9jVYbrbzWUlIEsQ9XOzO82
	 MfQEZxB6Tv3J7rPKb8usIdop5iDL8JuxdHrrlz/bn5J6cwOFqJrJ0wDEWdB13wDcpN
	 SkGlMVFz0iJjMZ6WFG8FZw6kYLjo1bmAvd0x5bYl5wEcGSGrYy2djGb9A3hgdLWDIA
	 vqPoXpSSM63Cg==
Date: Wed, 12 Mar 2025 12:56:22 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of
 doing it by hand
Message-ID: <20250312195622.GA1621@sol.localdomain>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <03f40ecd970de816686b233bd79406768dc66bbc.1741753576.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f40ecd970de816686b233bd79406768dc66bbc.1741753576.git.herbert@gondor.apana.org.au>

On Wed, Mar 12, 2025 at 12:29:57PM +0800, Herbert Xu wrote:
> Curiously, the Crypto API scatterwalk incremented pages by hand
> rather than using nth_page.  Possibly because scatterwalk predates
> nth_page (the following commit is from the history tree):

Well, also because it's never been clearly defined what a scatterlist even is.

> 	commit 3957f2b34960d85b63e814262a8be7d5ad91444d
> 	Author: James Morris <jmorris@intercode.com.au>
> 	Date:   Sun Feb 2 07:35:32 2003 -0800
> 
> 	    [CRYPTO]: in/out scatterlist support for ciphers.
> 
> Fix this by using nth_page.

This needs an explanation of what this is actually fixing.

I think it is: on a system with SPARSEMEM && !SPARSEMEM_VMEMMAP, if the caller
provided a scatterlist element that spanned physical memory sections that are
physically contiguous (but have separate vmemmaps), then the struct page(s)
calculated for any non-first sections would be invalid.  But then that invalid
struct page just gets passed to kmap_local_page(), so it would only matter if
also HIGHMEM || WANT_PAGE_VIRTUAL which are the cases where the struct page
actually gets used, I think?

All the edge cases like this need to be fixed of course, though fortunately it
sounds like this one was super rare.

> diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
> index b7e617ae4442..0ba5be363abf 100644
> --- a/include/crypto/scatterwalk.h
> +++ b/include/crypto/scatterwalk.h
> @@ -100,11 +100,15 @@ static inline void scatterwalk_get_sglist(struct scatter_walk *walk,
>  static inline void scatterwalk_map(struct scatter_walk *walk)
>  {
>  	struct page *base_page = sg_page(walk->sg);
> +	unsigned int offset = walk->offset;
> +	void *addr;
>  
>  	if (IS_ENABLED(CONFIG_HIGHMEM)) {
> -		walk->__addr = kmap_local_page(base_page +
> -					       (walk->offset >> PAGE_SHIFT)) +
> -			       offset_in_page(walk->offset);
> +		struct page *page;
> +
> +		page = nth_page(base_page, offset >> PAGE_SHIFT);
> +		offset = offset_in_page(offset);
> +		addr = kmap_local_page(page) + offset;

It would be cleaner as:

		struct page *page;

		page = nth_page(base_page, offset >> PAGE_SHIFT);
		walk->__addr = kmap_local_page(page) + offset_in_page(offset);

>  	} else {
>  		/*
>  		 * When !HIGHMEM we allow the walker to return segments that
> @@ -112,13 +116,14 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
>  		 * clear that in this case we're working in the linear buffer of
>  		 * the whole sg entry in the kernel's direct map rather than
>  		 * within the mapped buffer of a single page, compute the
> -		 * address as an offset from the page_address() of the first
> -		 * page of the sg entry.  Either way the result is the address
> -		 * in the direct map, but this makes it clearer what is really
> -		 * going on.
> +		 * address as an offset from the lowmem_page_address() of
> +		 * the first page of the sg entry.  Either way the result
> +		 * is the address in the direct map, but this makes it clearer
> +		 * what is really going on.
>  		 */
> -		walk->__addr = page_address(base_page) + walk->offset;
> +		addr = lowmem_page_address(base_page) + offset;
>  	}
> +	walk->__addr = addr;

This change is unrelated and seems incorrect.  lowmem_page_address() is a mm
implementation detail.  page_address() is the right one to use.

- Eric
