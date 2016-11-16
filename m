From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for
 output
Date: Wed, 16 Nov 2016 16:59:24 +0800
Message-ID: <20161116085924.GA29898@gondor.apana.org.au>
References: <3302668.EORF2jai5r@positron.chronox.de>
 <11739696.UFOoJjMX73@positron.chronox.de>
 <20161112021302.GA32425@gondor.apana.org.au>
 <4916573.RdN3EB8qT2@positron.chronox.de>
 <20161116085742.GA29644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54860 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932281AbcKPI7c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 03:59:32 -0500
Content-Disposition: inline
In-Reply-To: <20161116085742.GA29644@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2016 at 04:57:42PM +0800, Herbert Xu wrote:
> On Tue, Nov 15, 2016 at 08:06:47PM +0100, Stephan Mueller wrote:
> >
> > Shall the fix be rolled into the patch together with the fix for the tag value 
> > as well as the crash fix? Or can we have a stand-alone patch fixing this.
> 
> I think these are two separate issues and we don't need to fix them
> all in one go.
> 
> > Btw., how do you suggest that should be fixed? I would assume that this needs 
> > to be fixed on a per-implementation basis. I tested authenc and it copies the 
> > buffers over. gcm_base(ctr-aes-aesni,ghash-clmulni), rfc4106-gcm-aesni or 
> > ccm_base(ctr-aes-aesni,aes-aesni) do not copy the AD over.
> 
> We should fix as much as we can and then add a testmgr test to find
> the rest.

Alternatively we can add the copying code to algif_aead when src !=
dst.  I think that's probably the easier fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
