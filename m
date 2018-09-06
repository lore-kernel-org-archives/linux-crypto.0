From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 6 Sep 2018 09:21:40 +0200
Message-ID: <CAKv+Gu8bKcPksgoryaVjoD9G5KeCYrqWOCgVhqrBqGw5dCzXag@mail.gmail.com>
References: <20180904181629.20712-1-keescook@chromium.org> <20180904181629.20712-3-keescook@chromium.org>
 <CAKv+Gu9uJ+ZjBSCM=aU0GDvYR72cy2k8reXdLV5on3dOVw8KdQ@mail.gmail.com>
 <CAGXu5jKmcuhULMR=O9B_hJAxEK8uV36uoMxm4F3F8yYSuMzYNA@mail.gmail.com>
 <CAKv+Gu_0vWUqkUex45iW=pAfUbKVsqzP9MDf6OOwTg-nUVPZNg@mail.gmail.com> <CAOtvUMfu4-DWD4n4c5itjArAYWhGaBnPBEnkh6cbCubG-k9cCA@mail.gmail.com>
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
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMfu4-DWD4n4c5itjArAYWhGaBnPBEnkh6cbCubG-k9cCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6 September 2018 at 06:53, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Thu, Sep 6, 2018 at 1:49 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 5 September 2018 at 23:05, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Sep 5, 2018 at 2:18 AM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> On 4 September 2018 at 20:16, Kees Cook <keescook@chromium.org> wrote:
>>>>> In the quest to remove all stack VLA usage from the kernel[1], this
>>>>> caps the skcipher request size similar to other limits and adds a san=
ity
>>>>> check at registration. Looking at instrumented tcrypt output, the lar=
gest
>>>>> is for lrw:
>>>>>
>>>>>         crypt: testing lrw(aes)
>>>>>         crypto_skcipher_set_reqsize: 8
>>>>>         crypto_skcipher_set_reqsize: 88
>>>>>         crypto_skcipher_set_reqsize: 472
>>>>>
>>>>
>>>> Are you sure this is a representative sampling? I haven't double
>>>> checked myself, but we have plenty of drivers for peripherals in
>>>> drivers/crypto that implement block ciphers, and they would not turn
>>>> up in tcrypt unless you are running on a platform that provides the
>>>> hardware in question.
>>>
>>> Hrm, excellent point. Looking at this again:
>>>
>>> The core part of the VLA is using this in the ON_STACK macro:
>>>
>>> static inline unsigned int crypto_skcipher_reqsize(struct crypto_skciph=
er *tfm)
>>> {
>>>         return tfm->reqsize;
>>> }
>>>
>>> I don't find any struct crypto_skcipher .reqsize static initializers,
>>> and the initial reqsize is here:
>>>
>>> static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
>>> {
>>> ...
>>>         skcipher->reqsize =3D crypto_ablkcipher_reqsize(ablkcipher) +
>>>                             sizeof(struct ablkcipher_request);
>>>
>>> with updates via crypto_skcipher_set_reqsize().
>>>
>>> So I have to examine ablkcipher reqsize too:
>>>
>>> static inline unsigned int crypto_ablkcipher_reqsize(
>>>         struct crypto_ablkcipher *tfm)
>>> {
>>>         return crypto_ablkcipher_crt(tfm)->reqsize;
>>> }
>>>
>>> And of the crt_ablkcipher.reqsize assignments/initializers, I found:
>>>
>>> ablkcipher reqsize:
>>> 1       struct dcp_aes_req_ctx
>>> 8       struct atmel_tdes_reqctx
>>> 8       struct cryptd_blkcipher_request_ctx
>>> 8       struct mtk_aes_reqctx
>>> 8       struct omap_des_reqctx
>>> 8       struct s5p_aes_reqctx
>>> 8       struct sahara_aes_reqctx
>>> 8       struct stm32_cryp_reqctx
>>> 8       struct stm32_cryp_reqctx
>>> 16      struct ablk_ctx
>>> 24      struct atmel_aes_reqctx
>>> 48      struct omap_aes_reqctx
>>> 48      struct omap_aes_reqctx
>>> 48      struct qat_crypto_request
>>> 56      struct artpec6_crypto_request_context
>>> 64      struct chcr_blkcipher_req_ctx
>>> 80      struct spacc_req
>>> 80      struct virtio_crypto_sym_request
>>> 136     struct qce_cipher_reqctx
>>> 168     struct n2_request_context
>>> 328     struct ccp_des3_req_ctx
>>> 400     struct ccp_aes_req_ctx
>>> 536     struct hifn_request_context
>>> 992     struct cvm_req_ctx
>>> 2456    struct iproc_reqctx_s
>>>
>>> The base ablkcipher wrapper is:
>>> 80      struct ablkcipher_request
>>>
>>> And in my earlier skcipher wrapper analysis, lrw was the largest
>>> skcipher wrapper:
>>> 384     struct rctx
>>>
>>> iproc_reqctx_s is an extreme outlier, with cvm_req_ctx at a bit less th=
an half.
>>>
>>> Making this a 2920 byte fixed array doesn't seem sensible at all
>>> (though that's what's already possible to use with existing
>>> SKCIPHER_REQUEST_ON_STACK users).
>>>
>>> What's the right path forward here?
>>>
>>
>> The skcipher implementations based on crypto IP blocks are typically
>> asynchronous, and I wouldn't be surprised if a fair number of
>> SKCIPHER_REQUEST_ON_STACK() users are limited to synchronous
>> skciphers.
>
> According to Herbert, SKCIPHER_REQUEST_ON_STACK() may only be used
> for invoking synchronous ciphers.
>
> In fact, due to the way the crypto API is built, if you try using it
> with any transformation that uses DMA
> you would most probably end up trying to DMA to/from the stack which
> as we all know is not a great idea.
>

Ah yes, I found [0] which contains that quote.

So that means that Kees can disregard the occurrences that are async
only, but it still implies that we cannot limit the reqsize like he
proposes unless we take the sync/async nature into account.
It also means we should probably BUG() or WARN() in
SKCIPHER_REQUEST_ON_STACK() when used with an async algo.

>>
>> So we could formalize this and limit SKCIPHER_REQUEST_ON_STACK() to
>> synchronous skciphers, which implies that the reqsize limit only has
>> to apply synchronous skciphers as well. But before we can do this, we
>> have to identify the remaining occurrences that allow asynchronous
>> skciphers to be used, and replace them with heap allocations.
>
> Any such occurrences are almost for sure broken already due to the DMA
> issue I've mentioned.
>

I am not convinced of this. The skcipher request struct does not
contain any payload buffers, and whether the algo specific ctx struct
is used for DMA is completely up to the driver. So I am quite sure
there are plenty of async algos that work fine with
SKCIPHER_REQUEST_ON_STACK() and vmapped stacks.

> Gilad
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> values of =CE=B2 will give rise to dom!

[0] https://www.redhat.com/archives/dm-devel/2018-January/msg00087.html
