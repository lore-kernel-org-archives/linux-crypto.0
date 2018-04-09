From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] crypto: ccree: enable support for hardware keys
Date: Mon, 9 Apr 2018 11:12:19 +0200
Message-ID: <45fa8c6c-a518-92de-0ad2-f1fbe470282e@linux.vnet.ibm.com>
References: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
 <1522049540-10042-3-git-send-email-gilad@benyossef.com>
 <20180330172616.GB28120@gondor.apana.org.au>
 <CAOtvUMd6MMyQBHU4E=5DKXndhZw90=K1V1apD0uRRaMLyp-0Ag@mail.gmail.com>
 <20180403101905.GA4245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403101905.GA4245@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/03/2018 12:19 PM, Herbert Xu wrote:
> On Sat, Mar 31, 2018 at 08:30:46PM +0300, Gilad Ben-Yossef wrote:
>> However, as it uses the exact same mechanism of the regular xts-aes-ccree
>> but takes the key from another source, I've marked it with a test of
>> alg_test_null() on the premise that if the xts-aes-ccree works, so must this.
> Well it appears to be stubbed out as cc_is_hw_key always returns
> false.
>
>>> Are there other crypto drivers doing this?
>> I thought the exact same thing until I ran into a presentation about the s390
>> secure keys implementation. I basically imitated their use (or abuse?)
>> of the Crypto API
>> assuming it is the way to go.
>>
>> Take a look at arch/s390/crypto/paes_s390.c
> It's always nice to discover code that was never reviewed.
>
> The general approach seems sane though.
>
>> Anyway, if this is not the way to go I'd be more than happy to do whatever
>> work is needed to create the right interface.
>>
>> PS. I'd be out of the office and away from email access to the coming week, so
>> kindly excuse any delay in response.
> I think it's fine.  However, I don't really like the idea of everyone
> coming up with their own "paes", i.e., your patch's use of "haes".
> It should be OK to just use paes for everyone, no?
>
> As to your patch specifically, there is one issue where you're
> directly dereferencing the key as a struct.  This is a no-no because
> the key may have come from user-space.  You must treat it as a
> binary blob.  The s390 code seems to do this correctly.
>
> Cheers,
I would be happy to have a generic kernel interface for some kind
of key token as a binary blob. I am also open to use the kernel key
ring for future extensions. But please understand we needed a way
to support our hardware keys and I think the chosen design isn't
so bad.

regards Harald Freudenberger
using the kernel key ring in future extensions.
