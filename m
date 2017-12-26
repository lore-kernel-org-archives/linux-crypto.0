From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [QUESTION] hash import and request initialization
Date: Tue, 26 Dec 2017 11:06:02 +0200
Message-ID: <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
 <20171226030751.GA11758@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:35477 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdLZJGE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 04:06:04 -0500
Received: by mail-ot0-f170.google.com with SMTP id q5so8474236oth.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 Dec 2017 01:06:03 -0800 (PST)
In-Reply-To: <20171226030751.GA11758@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 26, 2017 at 5:07 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Dec 25, 2017 at 10:07:54AM +0200, Gilad Ben-Yossef wrote:
>> Hi there,
>>
>> I have ran into something I am unsure about regarding the ccree driver
>> implementation and would love to get some guidance:
>>
>> I have assumed, based on previous list correspondence, that both of
>> the following sequences are legal:
>>
>> Scenario A
>> 1. ahash_request_alloc
>> 2. ahash_import
>>
>> Scenario B
>> 1. ahash_request_alloc
>> 2. crypto_ahash_init
>> 3. ahash_import
>>
>> However, I've run into the problem that since ahash_request_alloc does
>> not zero the allocated request memory
>> and specifically does not zero the tfm specific context part of it, I
>> have no way to distinguish  between A and B and therefore
>> if I have any initialization sequence that needs to happen once per
>> request (DMA buffer allocation and mapping in my
>> case), I cannot tell if I need to do them in ahash_import callback or not.
>
> crypto_ahash_init is not necessary prior to an ahash_import.  If
> crypto_ahash_init does any hardware initialisations, then the same
> would be needed in ahash_import and crypto_ahash_digest.
>
>> So, am I'm missing something here or is the B scenario simply not legal?
>
> B is completely legal, just as it would be legal to do this:
>
> 1. ahash_request_alloc
> 2. crypto_ahash_init
> 3. crypto_ahash_update
> 4. crypto_ahash_init            // discard previous hash state
>
> Basically you must not hold onto any permanent state at the end
> of a hash operation such as init.  IOW you cannot expect a hash
> state to be finalised.

Thank you. I understand. Many thanks for your assistance.

I do have a follow up question, if I may:

My driver does require a buffer to keep interim hash state.
Ideally, I would allocate this buffer as part of the ahash request
context as I assume was the intent.
Indeed, this is what I've noticed the caam, atmel and chelsio drivers
are doing, at least.

Unfortunately, I don't understand how this is safe:

The hash state needs to be DMAed in and out of the hardware on each operation
and I have no guarantee that the ahash request is allocated from DMAable memory
(i.e. AHASH_REQUEST_ON_STACK).

The only option I see open to me is to allocate a new buffer, copy
into it the interim state stored
in the ahash request context, DMA map it and than reverse the
operation at the end of each op.

That will work, but it sounds less than ideal and since I've noticed
at least some of the other drivers
do not do this (caam, atmel and chelsio as mentioned), I wonder yet
again if I have missed something.

Thanks again!
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
