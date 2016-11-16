From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for
 output
Date: Wed, 16 Nov 2016 17:05:37 +0800
Message-ID: <20161116090537.GA30100@gondor.apana.org.au>
References: <3302668.EORF2jai5r@positron.chronox.de>
 <4916573.RdN3EB8qT2@positron.chronox.de>
 <20161116085742.GA29644@gondor.apana.org.au>
 <2184005.6LaQaNuGm1@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51406 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935196AbcKPJFq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:46 -0500
Content-Disposition: inline
In-Reply-To: <2184005.6LaQaNuGm1@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2016 at 10:02:59AM +0100, Stephan Mueller wrote:
> Am Mittwoch, 16. November 2016, 16:57:42 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Tue, Nov 15, 2016 at 08:06:47PM +0100, Stephan Mueller wrote:
> > > Shall the fix be rolled into the patch together with the fix for the tag
> > > value as well as the crash fix? Or can we have a stand-alone patch fixing
> > > this.
> > I think these are two separate issues and we don't need to fix them
> > all in one go.
> 
> I will resubmit the patches regarding the tag and the bug fix then.

Also if we go the route of doing the copy in algif_aead then we don't
need to touch the crypto code at all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
