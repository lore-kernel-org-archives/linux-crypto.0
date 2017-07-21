From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 14:28:52 +0100
Message-ID: <CAKv+Gu9wEVuNj78cUr570GX7BCHf+WKoUB5Tfn4uASgwn-R49A@mail.gmail.com>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
 <20170721124255.GA19913@gondor.apana.org.au> <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
 <20170721131130.GA21464@gondor.apana.org.au> <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35872 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdGUN2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 09:28:54 -0400
Received: by mail-io0-f182.google.com with SMTP id q2so22307145ioe.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 06:28:53 -0700 (PDT)
In-Reply-To: <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 July 2017 at 14:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 21 July 2017 at 14:11, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Fri, Jul 21, 2017 at 02:09:39PM +0100, Ard Biesheuvel wrote:
>>>
>>> Right. And is req->dst guaranteed to be assigned in that case? Because
>>> crypto_scomp_sg_alloc() happily allocates pages and kmalloc()s the
>>> scatterlist if req->dst == NULL.
>>>
>>> Is there any way we could make these scratch buffers part of the
>>> request structure instead? Or at least defer allocating them until the
>>> first call to crypto_scomp_init_tfm()? And on top of that, we should
>>> probably only use the per-CPU scratch buffers if
>>> CRYPTO_TFM_REQ_MAY_SLEEP is cleared, because in that case, we are not
>>> pre-emptible to begin with, and the concern does not apply.
>>
>> Well for now scomp is new code so nothing actually uses it.  But
>> the idea is to convert IPcomp over to acomp and scomp will fill in
>> as the compatibility glue.
>>
>
> Yes, I guessed as much.
>
>> The medium/long-term plan is to convert IPcomp over to a partial
>> decompression model so that we can allocate pages instead of a
>> contiguous chunk as we do now.
>>
>
> OK, but that doesn't really answer any of my questions:
> - Should we enforce that CRYPTO_ACOMP_ALLOC_OUTPUT is mutually
> exclusive with CRYPTO_TFM_REQ_MAY_SLEEP, or should
> crypto_scomp_sg_alloc() always use GFP_ATOMIC? We need one or the
> other, because the current situation is buggy.

I mean CRYPTO_ACOMP_ALLOC_OUTPUT should not be set if
CRYPTO_TFM_REQ_MAY_SLEEP is cleared.

> - Could we move the scratch buffers to the request structure instead?
> Or may that be allocated from softirq context as well?
> - Would you mind a patch that defers the allocation of the per-CPU
> buffers to the first invocation of crypto_scomp_init_tfm()?
> - Would you mind a patch that makes the code only use the per-CPU
> buffers if we are running atomically to begin with?
>
> Thanks,
> Ard.
