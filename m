From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if
 we can
Date: Tue, 27 Dec 2016 18:35:46 +0000
Message-ID: <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com>
References: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org> <20161227085745.GA10121@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35047 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754973AbcL0Sfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 13:35:48 -0500
Received: by mail-it0-f45.google.com with SMTP id c20so194053316itb.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2016 10:35:47 -0800 (PST)
In-Reply-To: <20161227085745.GA10121@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 27 December 2016 at 08:57, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Dec 09, 2016 at 01:47:26PM +0000, Ard Biesheuvel wrote:
>> The bit-sliced NEON implementation of AES only performs optimally if
>> it can process 8 blocks of input in parallel. This is due to the nature
>> of bit slicing, where the n-th bit of each byte of AES state of each input
>> block is collected into NEON register 'n', for registers q0 - q7.
>>
>> This implies that the amount of work for the transform is fixed,
>> regardless of whether we are handling just one block or 8 in parallel.
>>
>> So let's try a bit harder to iterate over the input in suitably sized
>> chunks, by increasing the chunksize to 8 * AES_BLOCK_SIZE, and tweaking
>> the loops to only process multiples of the chunk size, unless we are
>> handling the last chunk in the input stream.
>>
>> Note that the skcipher walk API guarantees that a step in the walk never
>> returns less that 'chunksize' bytes if there are at least that many bytes
>> of input still available. However, it does *not* guarantee that those steps
>> produce an exact multiple of the chunk size.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> I like this patch.  However, I had different plans for the chunksize
> attribute.  It's primarily meant to be a hint to the upper layer
> in case it does partial updates.  It's meant to provide the minimum
> number of bytes a partial update can carry without screwing up
> subsequent updates.
>
> It just happens to be the same value that we were using during
> an skcipher walk.
>
> So I think for your case we should add a new attribute, perhaps
> walk_chunksize or walksize, which doesn't need to be exported to
> the outside at all and can then be used by the walk interface.
>

OK, I will try to hack something up.

One thing to keep in mind though is that stacked chaining modes should
present the data with the same granularity for optimal performance.
E.g., xts(ecb(aes)) should pass 8 blocks at a time. How should this
requirement be incorporated according to you?
