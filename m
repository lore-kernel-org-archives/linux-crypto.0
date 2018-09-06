From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 6 Sep 2018 12:18:28 -0700
Message-ID: <CAGXu5jKg2GTPxo=N2xLoxbLM3LQHhE+TButPJQeP-Ze1zqEs_w@mail.gmail.com>
References: <20180904181629.20712-1-keescook@chromium.org> <20180904181629.20712-3-keescook@chromium.org>
 <CAKv+Gu9uJ+ZjBSCM=aU0GDvYR72cy2k8reXdLV5on3dOVw8KdQ@mail.gmail.com>
 <CAGXu5jKmcuhULMR=O9B_hJAxEK8uV36uoMxm4F3F8yYSuMzYNA@mail.gmail.com>
 <CAKv+Gu_0vWUqkUex45iW=pAfUbKVsqzP9MDf6OOwTg-nUVPZNg@mail.gmail.com>
 <CAOtvUMfu4-DWD4n4c5itjArAYWhGaBnPBEnkh6cbCubG-k9cCA@mail.gmail.com>
 <CAKv+Gu8bKcPksgoryaVjoD9G5KeCYrqWOCgVhqrBqGw5dCzXag@mail.gmail.com>
 <CAKv+Gu-QkCE0pY4+5anEZ0eWv-FTH1QJtOQfPcTVLcvNf7XNiA@mail.gmail.com>
 <20180906085100.xcqqftgqg4sizkec@gondor.apana.org.au> <CAKv+Gu_0ehX9sLCtUYR00D4iQw+ytwmsLKmG6dgq9EnLjidKFw@mail.gmail.com>
 <20180906131149.ge2db74nxffs2tbz@gondor.apana.org.au> <CAKv+Gu9tSFg9ekEagfn4sPbK-NLYHmmEtij=iMm7szGGQD9B1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9tSFg9ekEagfn4sPbK-NLYHmmEtij=iMm7szGGQD9B1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 6, 2018 at 7:49 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 6 September 2018 at 15:11, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Thu, Sep 06, 2018 at 11:29:41AM +0200, Ard Biesheuvel wrote:
>>>
>>> Perhaps not, but it is not enforced atm.
>>>
>>> In any case, limiting the reqsize is going to break things, so that
>>> needs to occur based on the sync/async nature of the algo. That also
>>> means we'll corrupt the stack if we ever end up using
>>> SKCIPHER_REQUEST_ON_STACK() with an async algo whose reqsize is
>>> greater than the sync reqsize limit, so I do think some additional
>>> sanity check is appropriate.
>>
>> I'd prefer compile-time based checks.  Perhaps we can introduce
>> a wrapper around crypto_skcipher, say crypto_skcipher_sync which
>> could then be used by SKCIPHER_REQUEST_ON_STACK to ensure that
>> only sync algorithms can use this construct.
>>
>
> That would require lots of changes in the callers, including ones that
> already take care to use sync algos only.
>
> How about we do something like the below instead?

Oh, I like this, thanks!

-Kees

-- 
Kees Cook
Pixel Security
