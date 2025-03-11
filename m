Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC5260A54
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741713987; cv=none; b=P4Wr92RRMXsEZ3DLFxM/W/7mYmESeCZYsnGd9V8qN9Z9BRcEC+t9PQjqCSHByYw7h5u/Rv/UCGQp+I1Hkfdo+CDo0kp4WfIHR70Z0XG89X1vW4nSSw4E0bqrX/hJJEFAF3pGNviM3D1/Y0mocF1ZW67d4q2QbDct8qZJabIe11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741713987; c=relaxed/simple;
	bh=Wkr6rjeRIq3xCUCB6e6mntEUYLwxX8KlUEHvkoxnKYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxJaCdoytrciTmVVxpl2pIsYJdEdhpMfyfCLj3Sp/qRa9PLmPUB70DXBVQvhsQOtwhDGyC64EDHksS5vqAlyi2AL7LMKLa9nme4aQgHh0Hox0nXCZpjUt00ShD5rqMPO1ZsSPf3tF+Z2pxre/CQwxqSTMnl2Ez/LqW+7fr/3DaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cD/1Mehw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cD/1Mehw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69298C4CEE9;
	Tue, 11 Mar 2025 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741713986;
	bh=Wkr6rjeRIq3xCUCB6e6mntEUYLwxX8KlUEHvkoxnKYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cD/1MehwOC5wr3Jp3jhQqLBHYyGDMjPEzav+dTI5X1EBH9mN0FFXJKYBs6LEc25J6
	 Kt6WLiOyXMzdHwxWgmje+pjM5EWMvMjCyGCGRTaNZne11oLvVhYPMKNun0zhpuxBvD
	 7q7mkzOh+d/XBu5NQRPeZO0fZdirs2mNGY04jwth3pMCLoBQAAS44hfrxAwY/+FT1k
	 I2WASUPmakvZEuAZqziJCummP4U/PovW0x3R9PQXL1fnZO/5XpYUDrsPKRE08dMcbh
	 kx2Uj91ZIb8vnCY1AqRZzn6pqZ6scEyFe97YFLIFez26k9S6qHYp91rrVDRyeDAg0r
	 vmCaH+WkPJuGw==
Date: Tue, 11 Mar 2025 10:26:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scatterwalk - Use nth_page instead of doing
 it by hand
Message-ID: <20250311172624.GA1268@sol.localdomain>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
 <9c5624f2b3a0131e89f3e692553a55d132f50a96.1741688305.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c5624f2b3a0131e89f3e692553a55d132f50a96.1741688305.git.herbert@gondor.apana.org.au>

On Tue, Mar 11, 2025 at 06:20:29PM +0800, Herbert Xu wrote:
>  static inline void scatterwalk_map(struct scatter_walk *walk)
>  {
> -	struct page *base_page = sg_page(walk->sg);
> +	struct page *page = sg_page(walk->sg);
> +	unsigned int offset = walk->offset;
> +	void *addr;
> +
> +	page = nth_page(page, offset >> PAGE_SHIFT);
> +	offset = offset_in_page(offset);
>  
>  	if (IS_ENABLED(CONFIG_HIGHMEM)) {
> -		walk->__addr = kmap_local_page(base_page +
> -					       (walk->offset >> PAGE_SHIFT)) +
> -			       offset_in_page(walk->offset);
> +		addr = kmap_local_page(page) + offset;
>  	} else {
>  		/*
>  		 * When !HIGHMEM we allow the walker to return segments that
>  		 * span a page boundary; see scatterwalk_clamp().  To make it
>  		 * clear that in this case we're working in the linear buffer of
>  		 * the whole sg entry in the kernel's direct map rather than
> -		 * within the mapped buffer of a single page, compute the
> -		 * address as an offset from the page_address() of the first
> -		 * page of the sg entry.  Either way the result is the address
> -		 * in the direct map, but this makes it clearer what is really
> -		 * going on.
> +		 * within the mapped buffer of a single page, use
> +		 * page_address() instead of going through kmap.
>  		 */
> -		walk->__addr = page_address(base_page) + walk->offset;
> +		addr = page_address(page) + offset;
>  	}
> +	walk->__addr = addr;

In the !HIGHMEM case (i.e., the common case) this is just worse, though.  It
expands into more instructions than before, only to get the same linear address
that it did before.  You also seem to be ignoring the comment that explains that
we're working in the linear buffer of the whole sg entry.

- Eric
