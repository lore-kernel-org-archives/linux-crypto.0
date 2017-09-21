From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - remove SGL end indicator when chaining
Date: Thu, 21 Sep 2017 16:04:26 +0800
Message-ID: <20170921080426.GA8137@gondor.apana.org.au>
References: <1913314.pET67Fvxje@positron.chronox.de>
 <4784255.BN0h4dhmNf@tauon.chronox.de>
 <20170920173133.GA16691@kroah.com>
 <2756839.ZIDvqujQOX@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <greg@kroah.com>, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44846 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdIUIEy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:04:54 -0400
Content-Disposition: inline
In-Reply-To: <2756839.ZIDvqujQOX@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 21, 2017 at 08:43:28AM +0200, Stephan Mueller wrote:
> Am Mittwoch, 20. September 2017, 19:31:33 CEST schrieb Greg KH:
> 
> Hi Herbert,
> 
> > On Wed, Sep 20, 2017 at 03:47:46PM +0200, Stephan Mueller wrote:
> > > Am Mittwoch, 20. September 2017, 10:32:09 CEST schrieb Herbert Xu:
> > > 
> > > Hi Herbert,
> > > 
> > > > Hmm, this patch does not apply against the current tree.  Is this
> > > > a stable-only patch?
> > > 
> > > This would be a stable-only patch. With the overhauling of the AF_ALG
> > > memory handling, this is a no-issue any more.
> > 
> > If you want this as a stable-only patch, you need to resend it and
> > justify it a bunch as to why it isn't in Linus's tree as well.
> 
> Would you push it or shall I send it?

Please resend it with details as to why this isn't needed on the
mainline kernel, i.e., due to the new code-base which has addressed
the bug in a different way but is too invasive for stable.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
