Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8342CAB;
	Sun, 11 Aug 2024 01:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723340744; cv=none; b=AP7gXKO2mz7Gbgx+cIMKJ67KHGfCDHXaM3+pk2sxzsPVvJ/ULYideO0Jr9KgzEqvxAyn6NuqXc+wXS1NuY3U8vWUxC/K06NNSV/VMc6b2tbMdpC3kcHnRLRPOiupfQe23UGTFsHtgK0H1UrE1V2y4R11ZCUkW+947/SYzbvwDRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723340744; c=relaxed/simple;
	bh=JmT28+TBMuZcOyjx/5/tYNxaf4lJLe0caRL7v51jJKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8U4wcitDDGNaWZ+3NeKeIznmlwsRYAA+RBhoG/wCceKB3MLi1VDwABD96PS2gDVOzSWngLheEGHoE4+GYJ+dVWxGVI/9GFO442B+6WtRjFtJYWsm0bLxGxl9k0EyDkv73kO0WhhwQUu0zlMy74lvz/mizPWckKk4l13gX+wrQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scxVf-003qJD-2W;
	Sun, 11 Aug 2024 09:45:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 Aug 2024 09:45:24 +0800
Date: Sun, 11 Aug 2024 09:45:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Waiman Long <longman@redhat.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
References: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
 <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>

On Sat, Aug 10, 2024 at 09:30:25PM -0400, Waiman Long wrote:
> 
> On 8/10/24 00:05, Herbert Xu wrote:
> > Waiman Long <longman@redhat.com> wrote:
> > > diff --git a/kernel/padata.c b/kernel/padata.c
> > > index 53f4bc912712..0fa6c2895460 100644
> > > --- a/kernel/padata.c
> > > +++ b/kernel/padata.c
> > > @@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
> > >         ps.chunk_size = max(ps.chunk_size, job->min_chunk);
> > >         ps.chunk_size = roundup(ps.chunk_size, job->align);
> > > 
> > > +       /*
> > > +        * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
> > > +        * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
> > > +        */
> > > +       if (!ps.chunk_size)
> > > +               ps.chunk_size = 1U;
> > Perhaps change the first ps.chunk_size assignment to use DIV_ROUND_UP
> > instead?
> 
> I think DIV_ROUND_UP() will exactly the same problem that if chunk_size is
> 0, you still got a 0 result. round_up() only if the 2nd argument is a power
> of 2 while with DIV_ROUND_UP(), the second argument can be any number except
> 0.

Unless I'm missing something chunk_size cannot be zero before the
division because that's the first thing we check upon entry into
this function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
