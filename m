Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64871F94C
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 03:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741316725; cv=none; b=Nqo5A7Uk0iVbW+qe9Llnc79IYrE16RrqgT5u7jf2XZYWVoiVfBj/35SurtbY8l8P59q1WbxhwQZJGNwQ7ikViaBURLcTPCojb0Ay+ujlbqLf84ALr0e8wg8ddHrP21/KdPQWhZM2ZOy8HM18QtT1PgZypv8c47bzgL7AEELiOCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741316725; c=relaxed/simple;
	bh=Q6pnfOmGg2RVloSZEHvPcehxhgOF/ZjTBSJxScwj2iU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3aCtZMBw94uF2GSnVgCUmNx69ZO6I9vQxFD0F9MUPW6pfkLJYh07VgkNE/RbWgXvG9YePpJAqcM9ejMAGNRVi3TUgGhQdXXxGEUSML38fCOfH4lIRAIY5fIhIFbwmI472tF++c8gEQq5FSoFxDcmwHQv/wYwEPFxLBvZ4NlJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OkbFdZIV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OkbFdZIV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QT9Xryk0jX3dlSR1/PkYJGf+tXe1W6xaLCeDjqUqhO4=; b=OkbFdZIV5cOllYsrSh/ag30VDH
	4W8d/04jnMsDeO0oLTyT3xTCAauHhCKGFObG8j3lfjecfT8N7c4IP35ekZM7aCtpJ1yIzJIYeziUq
	j8d0sn8JOMzQeUGV4D7i6f0DlIx8VrKUIufkkiP7WagVpFSS+xaT7fCa8eq3YxHF6eDk1rdEL2V0L
	Q1MuhNnok1zQXy7J+qayH68hyGNmA3AmCcN0qS9ufnJyZJKbZVmGgSPP9WJkHS4QCbkLd74FgZABG
	V5QeyrQAc0IhQ7SoTB4A+Qa55weqetCkHkRjrLI+d5SDWhvSccuwM9jKgPsbFN+d4lUcWwh6Ds3EE
	WdBFQUlQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqO1X-004UEs-2H;
	Fri, 07 Mar 2025 11:05:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 11:05:19 +0800
Date: Fri, 7 Mar 2025 11:05:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <Z8pib5_aZ61Z131Z@gondor.apana.org.au>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306173438.GG1796@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306173438.GG1796@sol.localdomain>

On Thu, Mar 06, 2025 at 09:34:38AM -0800, Eric Biggers wrote:
> On Thu, Mar 06, 2025 at 10:52:48AM +0800, Herbert Xu wrote:
> > +static inline unsigned int scatterwalk_next(struct scatter_walk *walk,
> > +					    unsigned int total)
> >  {
> > -	*nbytes_ret = scatterwalk_clamp(walk, total);
> > -	return scatterwalk_map(walk);
> > +	total = scatterwalk_clamp(walk, total);
> > +	walk->addr = scatterwalk_map(walk);
> > +	return total;
> >  }
> 
> Maybe do:
> 
>     unsigned int nbytes = scatterwalk_clamp(walk, total);
> 
>     walk->addr = scatterwalk_map(walk);
>     return nbytes;
> 
> Otherwise 'total' is being reused for something that is not the total length,
> which might be confusing.
> 
> > @@ -149,32 +150,30 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
> >  /**
> >   * scatterwalk_done_src() - Finish one step of a walk of source scatterlist
> >   * @walk: the scatter_walk
> > - * @vaddr: the address returned by scatterwalk_next()
> >   * @nbytes: the number of bytes processed this step, less than or equal to the
> >   *	    number of bytes that scatterwalk_next() returned.
> >   *
> >   * Use this if the @vaddr was not written to, i.e. it is source data.
> >   */
> 
> The comment above still mentions @vaddr.
> 
> >  /**
> >   * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
> >   * @walk: the scatter_walk
> > - * @vaddr: the address returned by scatterwalk_next()
> >   * @nbytes: the number of bytes processed this step, less than or equal to the
> >   *	    number of bytes that scatterwalk_next() returned.
> >   *
> >   * Use this if the @vaddr may have been written to, i.e. it is destination data.
> >   */
> 
> The comment above still mentions @vaddr.

OK I will fix these issues.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
