From: Neil Horman <nhorman@redhat.com>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Thu, 13 Aug 2009 10:41:56 -0400
Message-ID: <20090813144156.GA31826@shamino.rdu.redhat.com>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org> <20090813112955.GA25239@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38708 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZHMOm7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2009 10:42:59 -0400
Content-Disposition: inline
In-Reply-To: <20090813112955.GA25239@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2009 at 09:29:55PM +1000, Herbert Xu wrote:
> On Fri, Jun 19, 2009 at 08:55:00AM -0400, Neil Horman wrote:
> >
> > Thanks!  Thats definately an oversight.  Likely I included it because I was
> > implementing it as part of the FIPS effort.  The CPRNG definately works fine,
> > even if fips is disabled.  Although I think the relationship should be reversed,
> > not just removed, as FIPS support requires the use of the CPRNG.  Something like
> > this:
> > 
> >  
> > commit d9645d88d97e81c6528f311ee126df79a0d27501
> > Author: Neil Horman <nhorman@tuxdriver.com>
> > Date:   Fri Jun 19 08:52:37 2009 -0400
> > 
> >     Fix CPRNG/FIPS dependency
> >     
> >     The ANSI CPRNG has no dependence on FIPS support.  FIPS support however,
> >     requires the use of the CPRNG.  Adjust that depedency relationship in Kconfig
> >     
> >     Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Hmm, I just noticed that all my crypto modules have been marked
> as built-in again because of this patch.
> 
> As you're selecting a tristate from a bool, it causes CPRNG
> and everything under it to be built-in.
> 
> I'm going to revert this patch.
> 
Is there a good way to select a tristate from a bool?  The logic is the right
thing to do above, it just seems the mechanism comes up a bit short
Neil

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
