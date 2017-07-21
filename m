From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 21:11:30 +0800
Message-ID: <20170721131130.GA21464@gondor.apana.org.au>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
 <20170721124255.GA19913@gondor.apana.org.au>
 <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36046 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdGUNMD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 09:12:03 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 02:09:39PM +0100, Ard Biesheuvel wrote:
>
> Right. And is req->dst guaranteed to be assigned in that case? Because
> crypto_scomp_sg_alloc() happily allocates pages and kmalloc()s the
> scatterlist if req->dst == NULL.
> 
> Is there any way we could make these scratch buffers part of the
> request structure instead? Or at least defer allocating them until the
> first call to crypto_scomp_init_tfm()? And on top of that, we should
> probably only use the per-CPU scratch buffers if
> CRYPTO_TFM_REQ_MAY_SLEEP is cleared, because in that case, we are not
> pre-emptible to begin with, and the concern does not apply.

Well for now scomp is new code so nothing actually uses it.  But
the idea is to convert IPcomp over to acomp and scomp will fill in
as the compatibility glue.

The medium/long-term plan is to convert IPcomp over to a partial
decompression model so that we can allocate pages instead of a
contiguous chunk as we do now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
