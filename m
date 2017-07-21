From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 15:34:00 +0100
Message-ID: <CAKv+Gu8m=p1hAHZ0c-pCaxx0fauuUdHrxxS2W6RFNk6m52k=oQ@mail.gmail.com>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
 <20170721124255.GA19913@gondor.apana.org.au> <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
 <20170721131130.GA21464@gondor.apana.org.au> <CAKv+Gu9dzDXpqESG7-zR4tndeH6gyw+b0ZnNdeNUGL5auKGtyw@mail.gmail.com>
 <20170721133105.GA21666@gondor.apana.org.au> <CAKv+Gu9TshpUDk7BmkC=Ehv5adqa6QiYbonb1hfeESPoJoGL1g@mail.gmail.com>
 <20170721134458.GA21781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:34731 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdGUOeB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 10:34:01 -0400
Received: by mail-it0-f41.google.com with SMTP id v205so2516390itf.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 07:34:01 -0700 (PDT)
In-Reply-To: <20170721134458.GA21781@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 July 2017 at 14:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Jul 21, 2017 at 02:42:20PM +0100, Ard Biesheuvel wrote:
>>
>> >> - Would you mind a patch that makes the code only use the per-CPU
>> >> buffers if we are running atomically to begin with?
>> >
>> > That would mean dropping the first packet so no.
>> >
>>
>> I think you misunderstood me: the idea is not to allocate the per-CPU
>> buffers at that time, but avoiding them and use the heap directly (as
>> my patch does now). This way, we don't unnecessarily disable
>> preemption for calls executing in process context.
>
> When we actually have a user other than IPcomp then we could
> try this optimisation.  Otherwise I think it'd be a waste of
> time.
>

Fair enough.
