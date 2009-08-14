From: Neil Horman <nhorman@redhat.com>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 14 Aug 2009 06:58:29 -0400
Message-ID: <20090814105829.GB20601@hmsreliant.think-freely.org>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org> <20090813112955.GA25239@gondor.apana.org.au> <20090813144156.GA31826@shamino.rdu.redhat.com> <20090814031340.GA2380@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbZHNK6c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 06:58:32 -0400
Content-Disposition: inline
In-Reply-To: <20090814031340.GA2380@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2009 at 01:13:40PM +1000, Herbert Xu wrote:
> On Thu, Aug 13, 2009 at 10:41:56AM -0400, Neil Horman wrote:
> >
> > Is there a good way to select a tristate from a bool?  The logic is the right
> > thing to do above, it just seems the mechanism comes up a bit short
> 
> I suppose you could turn FIPS itself into a tristate.  As it
> should be used in just one spot, that would be easy to fix up.
> 
> Cheers,
Yeah, I suppose, it just seemed like a hack to me, since it really is a logical
boolean, and we use it as such.  Ok, I'll look at fixing this soon.  Thanks!
Neil

> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
