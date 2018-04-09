From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/2] crypto: ccree: enable support for hardware keys
Date: Mon, 9 Apr 2018 11:42:31 +0300
Message-ID: <CAOtvUMdCBky5Ay1WOSjNZYm=4O63bBaT_mV589xPXJdZ=EPOHg@mail.gmail.com>
References: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
 <1522049540-10042-3-git-send-email-gilad@benyossef.com> <20180330172616.GB28120@gondor.apana.org.au>
 <CAOtvUMd6MMyQBHU4E=5DKXndhZw90=K1V1apD0uRRaMLyp-0Ag@mail.gmail.com> <20180403101905.GA4245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403101905.GA4245@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 3, 2018 at 1:19 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Mar 31, 2018 at 08:30:46PM +0300, Gilad Ben-Yossef wrote:
>>
>> However, as it uses the exact same mechanism of the regular xts-aes-ccree
>> but takes the key from another source, I've marked it with a test of
>> alg_test_null() on the premise that if the xts-aes-ccree works, so must this.
>
> Well it appears to be stubbed out as cc_is_hw_key always returns
> false.

Please look again. The stub version of cc_is_hw_key() doing that is being
replaced in this patch.

>> > Are there other crypto drivers doing this?
>>
>> I thought the exact same thing until I ran into a presentation about the s390
>> secure keys implementation. I basically imitated their use (or abuse?)
>> of the Crypto API
>> assuming it is the way to go.
>>
>> Take a look at arch/s390/crypto/paes_s390.c
>
> It's always nice to discover code that was never reviewed.

 :-)

>
> The general approach seems sane though.
>
>> Anyway, if this is not the way to go I'd be more than happy to do whatever
>> work is needed to create the right interface.
>>
>> PS. I'd be out of the office and away from email access to the coming week, so
>> kindly excuse any delay in response.
>
> I think it's fine.  However, I don't really like the idea of everyone
> coming up with their own "paes", i.e., your patch's use of "haes".
> It should be OK to just use paes for everyone, no?

The s390 key and the cryptocell keys are not the same:

Their is, I believe, is an AES key encrypted by some internal key/algorithm.

The cryptocell "key" is a token, which is internally comprised of one
or two indexes, referencing slots in the internal memory in the
hardware, and a key size, that describe the size of the key.

I thought it would be confusing to use "paes" to describe both, since
they are not interchangeable.
You would not be able to feed an paes key that works with the s390
version to cryptocell and vice verse and get it work.

Having said, if you prefer to have "paes" simply designate
"implementation specific token for an AES key" I'm perfectly fine with
that.

>
> As to your patch specifically, there is one issue where you're
> directly dereferencing the key as a struct.  This is a no-no because
> the key may have come from user-space.  You must treat it as a
> binary blob.  The s390 code seems to do this correctly.
>

As noted above, the haes "key" is really a token encoding 3 different
pieces of information:
1. The index of the first key slot to use
2. Potentially, the index of a 2nd key slot to use (for XTS)
3. a key size, denoting the actual key size used, not the slot number

I than have to parse this information encoded in the token and feed it
to the HW (via 3 different registers)

Therefore, I do not see how I can avoid parsing the token.

I hope I've managed to explain things better now.

Thanks,
Gilad
-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
