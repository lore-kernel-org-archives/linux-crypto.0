Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFEC13D8A0
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742100156; cv=none; b=uIn3zDOddU1cWLBIxlObObWTTHocAXL4VPR0Dt9QZb6HuvRWdpYkHUXxSuOPWE2SFDrXSkPYMM5g9AGPKR4+xb9o83CVutiJ1ZsxUHaw0Av5Pmk0+zva6nyNGcudLYRk23Ha48xD+9swZKymzRg1s5idB724jQwZWoXJtp5kMpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742100156; c=relaxed/simple;
	bh=Bs6Z3lpuSRV+A2CX6f/az+If/2PZZeKu/D8GSGP8ml4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQFlb2lbYk4GGOLTomy3nJ/XVKy9GY9DJI4CB+RutdSTJxVbD3d+CI2NUB/aSeoz0ByWnsxCmrpMUvAg9goq7oUsZ5UEASLxuKDs/GZb5m1a+Msm7ljDk1QfA3/Oou1bkgJYTohp5eXjew8QKk1NBUmN+8dmOyD0wIqbbHcisKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OO2onYgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OO2onYgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5CBC4CEDD;
	Sun, 16 Mar 2025 04:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742100155;
	bh=Bs6Z3lpuSRV+A2CX6f/az+If/2PZZeKu/D8GSGP8ml4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OO2onYgKRbEYqvlAnthY7GmEppAF/kLjZRzOXa+97cXPhPb0e6lG13upW/+RLH7Mf
	 +pq+At8tg+aHiGc4bXIeTkbwnnjkDP7Cr6xFj4KBHxHYVVJKfydjcIHjOo89yYrJzS
	 lV3+9L37zFCC7ojkHofDT5utJ5/w+VD1o1ulw1sW4RrS9yfeuBBMyVw/gE/eDTSYch
	 vqwRiTsBkOm9prMn0PYmgB/SfLkgSPRIUkcTZx++C2ZDwvit7LaQMjz5ihpqmTa/00
	 uuZz+sGbqL0474eZtngwgTThyxPkIrVvhHuC0rPlU3f9jE+KB+ad3JAdJ7JHJEtq/D
	 5wspV+qvhlTKg==
Date: Sat, 15 Mar 2025 21:42:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of
 doing it by hand
Message-ID: <20250316044234.GD117195@sol.localdomain>
References: <cover.1741922689.git.herbert@gondor.apana.org.au>
 <96553040a4b37d8b54b9959e859fc057889dfdac.1741922689.git.herbert@gondor.apana.org.au>
 <20250316033141.GA117195@sol.localdomain>
 <Z9ZTaAjbWefXw6Dz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9ZTaAjbWefXw6Dz@gondor.apana.org.au>

On Sun, Mar 16, 2025 at 12:28:24PM +0800, Herbert Xu wrote:
> On Sat, Mar 15, 2025 at 08:31:41PM -0700, Eric Biggers wrote:
> >
> > > @@ -189,14 +195,18 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
> > >  	 * reliably optimized out or not.
> > >  	 */
> > >  	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
> > > -		struct page *base_page, *start_page, *end_page, *page;
> > > +		struct page *base_page;
> > > +		unsigned int offset;
> > > +		int start, end, i;
> > >  
> > >  		base_page = sg_page(walk->sg);
> > > -		start_page = base_page + (walk->offset >> PAGE_SHIFT);
> > > -		end_page = base_page + ((walk->offset + nbytes +
> > > -					 PAGE_SIZE - 1) >> PAGE_SHIFT);
> > > -		for (page = start_page; page < end_page; page++)
> > > -			flush_dcache_page(page);
> > > +		offset = walk->offset;
> > > +		start = offset >> PAGE_SHIFT;
> > > +		end = start + (nbytes >> PAGE_SHIFT);
> > > +		end += (offset_in_page(offset) + offset_in_page(nbytes) +
> > > +			PAGE_SIZE - 1) >> PAGE_SHIFT;
> > 
> > The change to how the end page index is calculated is unrelated to the nth_page
> > fix, and it makes the code slower and harder to understand.  My original code
> > just rounded the new offset up to a page boundary to get the end page index.
> 
> The original code is open to overflows in the addition.  The new
> version is not.

If you think you are fixing a separate issue, you need to say so.

But I also don't think it's worth worrying about lengths so close to UINT_MAX.
No one is using them, they have no testing, and there are likely to be other
overflows like this one too.

- Eric
