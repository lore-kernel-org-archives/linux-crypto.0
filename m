From: Megha Dey <megha.dey@intel.com>
Subject: Re: [Patch V5 1/7] crypto: Multi-buffer encryption infrastructure
 support
Date: Thu, 08 Jun 2017 12:52:54 -0700
Message-ID: <1496951574.8042.15.camel@megha-Z97X-UD7-TH>
References: <1492721440-3698-1-git-send-email-megha.dey@linux.intel.com>
         <1492721440-3698-2-git-send-email-megha.dey@linux.intel.com>
         <20170424090024.GA20535@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6755 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdFHTmZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Jun 2017 15:42:25 -0400
In-Reply-To: <20170424090024.GA20535@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-04-24 at 17:00 +0800, Herbert Xu wrote:
> On Thu, Apr 20, 2017 at 01:50:34PM -0700, Megha Dey wrote:
> >
> > +static int simd_skcipher_decrypt_mb(struct skcipher_request *req)
> > +{
> > +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +	struct simd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
> > +	struct skcipher_request *subreq;
> > +	struct crypto_skcipher *child;
> > +
> > +	subreq = skcipher_request_ctx(req);
> > +	*subreq = *req;
> > +
> > +	child = &ctx->mcryptd_tfm->base;
> > +
> > +	skcipher_request_set_tfm(subreq, child);
> > +
> > +	return crypto_skcipher_decrypt(subreq);
> > +}
> 
> Why did you add the code here in simd.c? This doesn't seem to have
> anything to do with kernel SIMD instructions.
> 
> From your later patch I see that what you want is simply a wrapper
> around a synchronous internal algorithm.  That is indeed similar
> in purpose to simd.c, but I still find it weird to be adding this
> code here.
> 
> My suggestion is to instead move this code to mcryptd.c.  It's
> a bit fiddly because mcryptd already exists as a template.  But
> you should still be able to create a seaprate mcryptd interface
> for skcipher in the way that simd does it.  In time we can convert
> mcryptd hash to this model too.
> 
> Also you adopted the simd compat naming scheme.  Please don't do
> that as you're creating something brand new so there is no need
> to keep the existing compat (i.e., __XXX) naming scheme.  In the
> new naming scheme, the internal algorithm should just carry the
> normal alg name (e.g., ecb(aes)) and driver name, while the mcryptd
> wrapped version will have the same algorithm name but carry a
> prefix on the driver name (which is simd- for simd.c, but you
> should probably used mcryptd-).
> 
> Cheers,

I will move this code to the mcryptd.c.

About the naming scheme, could you give me an example where the internal
and external algorithm have the same name? I tried searching but did not
find any.

When the outer and inner algorithm have the same name, I see a crash
when testing using tcrypt. This is because the wrong algortihm (with a
higher priority) is being picked up in __crypto_alg_lookup.  

Inner alg:
Currently:
alg name:__cbc(aes), driver name:__cbc-aes-aesni-mb

expected:
alg name:cbc(aes), driver name: cbc-aes-aesni-mb

Outer alg:
Currently:
alg name:cbc(aes), driver name:cbc-aes-aesni-mb

expected:
alg name:cbc(aes), driver name:mcryptd-cbc-aes-aesni-mb

Thanks,
Megha
