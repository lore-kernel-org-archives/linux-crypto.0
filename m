From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] typo in crypto/rng.c
Date: Thu, 13 Aug 2009 11:54:14 +1000
Message-ID: <20090813015414.GA18002@gondor.apana.org.au>
References: <alpine.DEB.2.01.0908072346000.5831@bogon.housecafe.de> <20090808112208.GA18518@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40238 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696AbZHMByX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2009 21:54:23 -0400
Content-Disposition: inline
In-Reply-To: <20090808112208.GA18518@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 08, 2009 at 07:22:08AM -0400, Neil Horman wrote:
> On Fri, Aug 07, 2009 at 11:49:20PM -0700, Christian Kujau wrote:
> > 
> > Correct a typo in crypto/rng.c
> > 
> > Signed-off-by: Christian Kujau <lists@nerdbynature.de>
> > 
> > --- linux-2.6-git/crypto/rng.c.orig	2009-08-08 08:43:49.227693375 +0200
> > +++ linux-2.6-git/crypto/rng.c	2009-08-08 08:44:54.735426448 +0200
> > @@ -123,4 +123,4 @@ void crypto_put_default_rng(void)
> >  EXPORT_SYMBOL_GPL(crypto_put_default_rng);
> >  
> >  MODULE_LICENSE("GPL");
> > -MODULE_DESCRIPTION("Random Number Genertor");
> > +MODULE_DESCRIPTION("Random Number Generator");
> > 
> > -- 
> > BOFH excuse #229:
> > 
> > wrong polarity of neutron flow
> > 
> 
> Thanks!
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
