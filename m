From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/2] crypto: ccree: enable support for hardware keys
Date: Mon, 9 Apr 2018 11:47:32 +0300
Message-ID: <CAOtvUMf6gU7EN2NL0wfFpmaqHFBP5xxAjYBJXdyhA03yVc9b5w@mail.gmail.com>
References: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
 <1522049540-10042-3-git-send-email-gilad@benyossef.com> <20180330172616.GB28120@gondor.apana.org.au>
 <CAOtvUMd6MMyQBHU4E=5DKXndhZw90=K1V1apD0uRRaMLyp-0Ag@mail.gmail.com> <13b816b2-cae1-a926-d60b-734c77a6361c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13b816b2-cae1-a926-d60b-734c77a6361c@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 3, 2018 at 3:22 PM, Milan Broz <gmazyland@gmail.com> wrote:
> On 03/31/2018 07:30 PM, Gilad Ben-Yossef wrote:
> ...
>>> Are there other crypto drivers doing this?
>>
>> I thought the exact same thing until I ran into a presentation about the s390
>> secure keys implementation. I basically imitated their use (or abuse?)
>> of the Crypto API
>> assuming it is the way to go.
>>
>> Take a look at arch/s390/crypto/paes_s390.c
>>
>> The slide for the presentation describing this is here:
>> http://schd.ws/hosted_files/ossna2017/89/LC2017SecKeyDmCryptV5.pdf
>>
>> And they seem to even have support for it in the DM-Crypt tools, which at
>> the time they claimed to be in the process of getting it up-streamed.
>
> It is "in the process", but definitely not accepted.
>
> We are just discussing how to integrate paes wrapped keys in cryptsetup and
> it will definitely not be the way presented in the slides above.
>
> If you plan more such ciphers, I would welcome some unified way in crypto API
> how to handle these HSM keys flavors.

That would be good. Note however the fine difference - the s390 usage
is a wrapped key.
Ours is a token for a key (a slot number really). Probably makes no
difference for any
practical sense, but I thought it is worth mentioning it.

>
> For kernel dm-crypt, there is no change needed (dmcrypt just treats it as a normal cipher key).
> (I would say that it is not the best idea either, IMHO it would be better to use
> kernel keyring reference instead and somehow handle hw keys through keyring.)
>

I am all for the keyring approach. In fact, that was the way I wanted
to to go to introduce this feature
for cryptocell when I discovered that was already upstream code using
a different approach.

Any suggestion how this would work vis a vis the crypto API usage?

e.g. - have a parallel setkey variant added to crypto APi that takes a
kernel keyring object rather than actual key?


Thanks,
Gilad





-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
