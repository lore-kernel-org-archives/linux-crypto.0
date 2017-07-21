From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 14:42:20 +0100
Message-ID: <CAKv+Gu9TshpUDk7BmkC=Ehv5adqa6QiYbonb1hfeESPoJoGL1g@mail.gmail.com>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
 <20170721124255.GA19913@gondor.apana.org.au> <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
 <20170721131130.GA21464@gondor.apana.org.au> <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
 <20170721133105.GA21666@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37830 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdGUNmW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 09:42:22 -0400
Received: by mail-it0-f42.google.com with SMTP id v127so7504786itd.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 06:42:22 -0700 (PDT)
In-Reply-To: <20170721133105.GA21666@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 July 2017 at 14:31, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Jul 21, 2017 at 02:24:02PM +0100, Ard Biesheuvel wrote:
>>
>> OK, but that doesn't really answer any of my questions:
>> - Should we enforce that CRYPTO_ACOMP_ALLOC_OUTPUT is mutually
>> exclusive with CRYPTO_TFM_REQ_MAY_SLEEP, or should
>> crypto_scomp_sg_alloc() always use GFP_ATOMIC? We need one or the
>> other, because the current situation is buggy.
>
> Yeah I'm not surprised that it is broken, because there are currently
> no users of the API.  We should fix the acomp API.
>
>> - Could we move the scratch buffers to the request structure instead?
>> Or may that be allocated from softirq context as well?
>
> Yes the IPcomp requests would be allocated from softirq context.
>

__acomp_request_alloc() currently uses GFP_KERNEL explicitly, so that
needs to be fixed as well then.

>> - Would you mind a patch that defers the allocation of the per-CPU
>> buffers to the first invocation of crypto_scomp_init_tfm()?
>
> Sure.  That's what we currently do for IPcomp too.
>

OK.

>> - Would you mind a patch that makes the code only use the per-CPU
>> buffers if we are running atomically to begin with?
>
> That would mean dropping the first packet so no.
>

I think you misunderstood me: the idea is not to allocate the per-CPU
buffers at that time, but avoiding them and use the heap directly (as
my patch does now). This way, we don't unnecessarily disable
preemption for calls executing in process context.

I.e..

if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
  cpu = get_cpu();
  scratch_src = *per_cpu_ptr(scomp_src_scratches, cpu);
  ...
} else {
  scratch_src = (u8 *)__get_free_pages(gfp, alloc_order);
}

and make the put_cpu() at the end conditional in the same way.

In any case, my main gripe with this code is the unconditional
allocation of the scratch buffers (taking up memory and vmalloc space)
so if we can defer that to crypto_scomp_init_tfm() instead, I already
have most of what I need.

-- 
Ard.
