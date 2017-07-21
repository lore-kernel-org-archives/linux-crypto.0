From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 21:31:05 +0800
Message-ID: <20170721133105.GA21666@gondor.apana.org.au>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
 <20170721124255.GA19913@gondor.apana.org.au>
 <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
 <20170721131130.GA21464@gondor.apana.org.au>
 <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36536 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdGUNbl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 09:31:41 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 02:24:02PM +0100, Ard Biesheuvel wrote:
>
> OK, but that doesn't really answer any of my questions:
> - Should we enforce that CRYPTO_ACOMP_ALLOC_OUTPUT is mutually
> exclusive with CRYPTO_TFM_REQ_MAY_SLEEP, or should
> crypto_scomp_sg_alloc() always use GFP_ATOMIC? We need one or the
> other, because the current situation is buggy.

Yeah I'm not surprised that it is broken, because there are currently
no users of the API.  We should fix the acomp API.

> - Could we move the scratch buffers to the request structure instead?
> Or may that be allocated from softirq context as well?

Yes the IPcomp requests would be allocated from softirq context.

> - Would you mind a patch that defers the allocation of the per-CPU
> buffers to the first invocation of crypto_scomp_init_tfm()?

Sure.  That's what we currently do for IPcomp too.

> - Would you mind a patch that makes the code only use the per-CPU
> buffers if we are running atomically to begin with?

That would mean dropping the first packet so no.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
