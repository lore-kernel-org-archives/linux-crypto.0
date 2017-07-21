From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 21:44:58 +0800
Message-ID: <20170721134458.GA21781@gondor.apana.org.au>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
 <20170721124255.GA19913@gondor.apana.org.au>
 <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
 <20170721131130.GA21464@gondor.apana.org.au>
 <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
 <20170721133105.GA21666@gondor.apana.org.au>
 <CAKv+Gu9TshpUDk7BmkC=Ehv5adqa6QiYbonb1hfeESPoJoGL1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36874 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdGUNpY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 09:45:24 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9TshpUDk7BmkC=Ehv5adqa6QiYbonb1hfeESPoJoGL1g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 02:42:20PM +0100, Ard Biesheuvel wrote:
> 
> >> - Would you mind a patch that makes the code only use the per-CPU
> >> buffers if we are running atomically to begin with?
> >
> > That would mean dropping the first packet so no.
> >
> 
> I think you misunderstood me: the idea is not to allocate the per-CPU
> buffers at that time, but avoiding them and use the heap directly (as
> my patch does now). This way, we don't unnecessarily disable
> preemption for calls executing in process context.

When we actually have a user other than IPcomp then we could
try this optimisation.  Otherwise I think it'd be a waste of
time.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
