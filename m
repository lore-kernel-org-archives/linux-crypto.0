From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment v2
Date: Thu, 6 Mar 2008 18:57:17 +0800
Message-ID: <20080306105717.GA6738@gondor.apana.org.au>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au> <20080305120153.GA18425@Chamillionaire.breakpoint.cc> <47CEA7F5.2080700@the2masters.de> <20080305163753.GA20787@Chamillionaire.breakpoint.cc> <20080305221746.GA32072@Chamillionaire.breakpoint.cc> <47CF2321.6020100@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46120 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764422AbYCFK5Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Mar 2008 05:57:25 -0500
Content-Disposition: inline
In-Reply-To: <47CF2321.6020100@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 05, 2008 at 11:48:01PM +0100, Stefan Hellermann wrote:
> > The XTS blockmode uses a copy of the IV which is saved on the stack
> > and may or may not be properly aligned. If it is not, it will break
> > hardware cipher like the geode or padlock.
> > This patch encrypts the IV in place so we don't have to worry about
> > alignment.
> > 
> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> > ---
> > Herbert, I tried the small patch thing :)
> > It passed tcrypt on my geode, dunno about dm-crypt & friends.
> > Stefan if you could test it with dm-crypt than we have a small fix :)
> 
> Yes, this passwd my tests, too! Nice :)
> 
> Tested-by: Stefan Hellermann <stefan@the2masters.de

Patch applied.  Thanks everyeone!

I'll push this to stable too.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
