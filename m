From: Nathan Royce <nroycea+kernel@gmail.com>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for 4.10.1.
Date: Fri, 3 Mar 2017 08:08:44 -0600
Message-ID: <CALaQ_hpCsPtAPM8irV6WnSYCT1z6uh-410++kSj1jEb+egK_4w@mail.gmail.com>
References: <CALaQ_hoafES-K1ds-XUPC6h4VnHX_ebym4LYjeuq1jHdbLYuDQ@mail.gmail.com>
 <20170303120432.GA26540@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170303120432.GA26540@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Yup, when I disabled the s5p driver, xts DID show in the /proc/crypto list.

Heh, I was about to ask if it was something I should push towards
another maintainer for s5p stuff, but found you listed in that as
well.
If I am incorrect in that assumption, do let me know whom else I
should make aware of this issue.
Also let me know if you would like the rest of the kernel panic. Maybe
you already have enough to go on and don't need it.

Thanks for all that clarity.

On Fri, Mar 3, 2017 at 6:04 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Mar 03, 2017 at 04:36:18AM -0600, Nathan Royce wrote:
>> I do have ECB selected as well:
>> DM_CRYPT=y
>> CRYPTO_ECB=y
>> CRYPTO_XTS=y
>>
>> name         : ecb(aes)
>> driver       : ecb-aes-s5p
>> module       : kernel
>> priority     : 100
>> refcnt       : 1
>> selftest     : passed
>> internal     : no
>> type         : ablkcipher
>> async        : yes
>> blocksize    : 16
>> min keysize  : 16
>> max keysize  : 32
>> ivsize       : 0
>> geniv        : <default>
>> //still no "xts" can be found in the list
>
> Weird.  So you can't find any instances of xts in /proc/crypto
> at all? Even if the self-test fails it should still register an
> entry there...
>
> In any case, I think disabling the s5p driver should work at
> least.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
