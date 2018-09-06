From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 6 Sep 2018 11:25:02 +0300
Message-ID: <CAOtvUMdMgG944iYdmMPCPajhuf0MTNNnora_4nfoaj+nHLGYUg@mail.gmail.com>
References: <20180904181629.20712-1-keescook@chromium.org> <20180904181629.20712-3-keescook@chromium.org>
 <CAKv+Gu9uJ+ZjBSCM=aU0GDvYR72cy2k8reXdLV5on3dOVw8KdQ@mail.gmail.com>
 <CAGXu5jKmcuhULMR=O9B_hJAxEK8uV36uoMxm4F3F8yYSuMzYNA@mail.gmail.com>
 <CAKv+Gu_0vWUqkUex45iW=pAfUbKVsqzP9MDf6OOwTg-nUVPZNg@mail.gmail.com>
 <CAOtvUMfu4-DWD4n4c5itjArAYWhGaBnPBEnkh6cbCubG-k9cCA@mail.gmail.com> <CAKv+Gu8bKcPksgoryaVjoD9G5KeCYrqWOCgVhqrBqGw5dCzXag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
In-Reply-To: <CAKv+Gu8bKcPksgoryaVjoD9G5KeCYrqWOCgVhqrBqGw5dCzXag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 6, 2018 at 10:21 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:

>>> The skcipher implementations based on crypto IP blocks are typically
>>> asynchronous, and I wouldn't be surprised if a fair number of
>>> SKCIPHER_REQUEST_ON_STACK() users are limited to synchronous
>>> skciphers.
>>
>> According to Herbert, SKCIPHER_REQUEST_ON_STACK() may only be used
>> for invoking synchronous ciphers.
>>
>> In fact, due to the way the crypto API is built, if you try using it
>> with any transformation that uses DMA
>> you would most probably end up trying to DMA to/from the stack which
>> as we all know is not a great idea.
>>
>
> Ah yes, I found [0] which contains that quote.
>
> So that means that Kees can disregard the occurrences that are async
> only, but it still implies that we cannot limit the reqsize like he
> proposes unless we take the sync/async nature into account.
> It also means we should probably BUG() or WARN() in
> SKCIPHER_REQUEST_ON_STACK() when used with an async algo.
>
>>>
>>> So we could formalize this and limit SKCIPHER_REQUEST_ON_STACK() to
>>> synchronous skciphers, which implies that the reqsize limit only has
>>> to apply synchronous skciphers as well. But before we can do this, we
>>> have to identify the remaining occurrences that allow asynchronous
>>> skciphers to be used, and replace them with heap allocations.
>>
>> Any such occurrences are almost for sure broken already due to the DMA
>> issue I've mentioned.
>>
>
> I am not convinced of this. The skcipher request struct does not
> contain any payload buffers, and whether the algo specific ctx struct
> is used for DMA is completely up to the driver. So I am quite sure
> there are plenty of async algos that work fine with
> SKCIPHER_REQUEST_ON_STACK() and vmapped stacks.


You are right that it is up to the driver but the cost is an extra
memory allocation and release
*per request* for any per request data that needs to be DMAable beyond
the actual plain
and cipher text buffers such as the IV, so driver writers have an
incentive against doing that :-)

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
