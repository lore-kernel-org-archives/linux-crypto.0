Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93EE12EBE7
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742099311; cv=none; b=tY03hIIuJ5dV+PwJPfaLstGLo4OMx56gkDv1dLRK7dG1nvZSRFo8lalBdoAsJfMml+O320PwWNEyCG7Q8bkgghQop/5gxxp0loupk3ov5Ge4TxuulCoosB98Jceu8hZiuPrz0bPNPALkSkqf6QV3G0zQPVd2oSoJ8M5U17xcOlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742099311; c=relaxed/simple;
	bh=vWzInt3r7jcSdzHm+tGO5Z5cmzVMvpLbMGeLQ/Q7lnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1oC9roWTbeHXTyL+D3ePIhW5Uy74kez9bKu4aQDLsd0I06llrzekrf5tx3b73xRjTtC6r/0mQ2svwSBG8TtFXH31Jjgwc+GJXJOMVbL0tJARobeg6e7HEGYHLDena0E/RsvI17C4d/4a73vb+EarjsHvRNUFie6+msSQcvojkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UHnnwp3N; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UHnnwp3N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7LGozGdsUwb1bsusCakYed8oDS2PZwrpRyWs3GYWubI=; b=UHnnwp3N8yj133ZL9uNAcDivJI
	xGDvpPfTR4Y+C8n1f0TqVFwastOTpdML27rylkm+bS95PkNu9Um6GlN1HYtvGOh5/o9NpJf5xvilB
	inmhArn4Dl/QuQ8xYkVBH/G8LtId3WdqBYGnPYxLBe2AQj+UIfZbz7XmH59hIWV4obKPmIKJME/0t
	RZ544/8ySWl7LBRsT9S3vVxbjFnW9OaB8JB7SrCTF9209odLlc8MLmRiDE50bEi3SmrOEod+3k62k
	UqWVhX7MkzQdlDfBNuEXAR+O04rExm0t6E0EuD/4Hq7wGXgnFI80ZgynfDhWj6+qm4M0GHwB93HYd
	S9F2//1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttfbs-006ysZ-2i;
	Sun, 16 Mar 2025 12:28:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 12:28:24 +0800
Date: Sun, 16 Mar 2025 12:28:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of
 doing it by hand
Message-ID: <Z9ZTaAjbWefXw6Dz@gondor.apana.org.au>
References: <cover.1741922689.git.herbert@gondor.apana.org.au>
 <96553040a4b37d8b54b9959e859fc057889dfdac.1741922689.git.herbert@gondor.apana.org.au>
 <20250316033141.GA117195@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316033141.GA117195@sol.localdomain>

On Sat, Mar 15, 2025 at 08:31:41PM -0700, Eric Biggers wrote:
>
> > @@ -189,14 +195,18 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
> >  	 * reliably optimized out or not.
> >  	 */
> >  	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
> > -		struct page *base_page, *start_page, *end_page, *page;
> > +		struct page *base_page;
> > +		unsigned int offset;
> > +		int start, end, i;
> >  
> >  		base_page = sg_page(walk->sg);
> > -		start_page = base_page + (walk->offset >> PAGE_SHIFT);
> > -		end_page = base_page + ((walk->offset + nbytes +
> > -					 PAGE_SIZE - 1) >> PAGE_SHIFT);
> > -		for (page = start_page; page < end_page; page++)
> > -			flush_dcache_page(page);
> > +		offset = walk->offset;
> > +		start = offset >> PAGE_SHIFT;
> > +		end = start + (nbytes >> PAGE_SHIFT);
> > +		end += (offset_in_page(offset) + offset_in_page(nbytes) +
> > +			PAGE_SIZE - 1) >> PAGE_SHIFT;
> 
> The change to how the end page index is calculated is unrelated to the nth_page
> fix, and it makes the code slower and harder to understand.  My original code
> just rounded the new offset up to a page boundary to get the end page index.

The original code is open to overflows in the addition.  The new
version is not.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
