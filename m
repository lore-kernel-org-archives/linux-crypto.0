From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 2/4] crypto: skcipher - Enforce non-ASYNC for on-stack requests
Date: Thu, 13 Sep 2018 10:40:16 -0700
Message-ID: <CAGXu5j+bpLK=EQ9LHkO8V=sdaQwt==6fbGhgn2Vi1E9_WxSGRQ@mail.gmail.com>
References: <20180906225854.40989-1-keescook@chromium.org> <20180906225854.40989-3-keescook@chromium.org>
 <20180907034242.zhm4dglzkldhvh3x@gondor.apana.org.au> <CAKv+Gu9kHpBTKjQKA3W4Q424FeY+Zq4srq2-r0MxjfCNKHT_5A@mail.gmail.com>
 <20180911055230.iiiq2uu5gczlwjon@gondor.apana.org.au> <CAGXu5j+ti_nzxeu64e-X+igNEsnXiW1rjkn7R63DMBCxBOeTNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+ti_nzxeu64e-X+igNEsnXiW1rjkn7R63DMBCxBOeTNg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 13, 2018 at 9:46 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Sep 10, 2018 at 10:52 PM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
>> On Fri, Sep 07, 2018 at 08:56:23AM +0200, Ard Biesheuvel wrote:
>>>
>>> OK, so given that all SKCIPHER_REQUEST_ON_STACK occurrences are
>>> updated in this series anyway, perhaps we should add
>>> skcipher_[en|de]crypt_onstack() flavors that encapsulate the
>>> additional check? Only question is how to enforce at compile time that
>>> those are used instead of the ordinary ones when using a stack
>>> allocated request. Would you mind using some macro foo here involving
>>> __builtin_types_compatible_p() ?
>>
>> Something like a completely new type which in reality is just a
>> wrapper around skcipher:
>>
>>         struct crypto_sync_skcipher {
>>                 struct crypto_skcipher base;
>>         } tfm;
>>
>>         tfm = crypto_alloc_sync_skcipher(...);
>>
>>         crypto_sync_skcipher_encrypt(...)
>>         crypto_sync_skcipher_decrypt(...)
>>
>> These functions would just be trivial inline functions around their
>> crypto_skcipher counterparts.
>
> This means new wrappers for the other helpers too, yes? For example:
>
>         SKCIPHER_REQUEST_ON_STACK(nreq, ctx->null);
>
>         skcipher_request_set_tfm(nreq, ctx->null);
>         skcipher_request_set_callback(nreq, req->base.flags, NULL, NULL);
>         skcipher_request_set_crypt(nreq, req->src, req->dst, nbytes, NULL);
>
>         return crypto_skcipher_encrypt(nreq);
>
> For the above, we'd also need:
>
> sync_skcipher_request_set_tfm()
> sync_skcipher_request_set_callback()
> sync_skcipher_request_set_crypt()

Wait, I think I misunderstood you. Did you mean a new top-level thing
(tfm?) not a new request type?

That would mean at least replacing skcipher_request_set_tfm() with a
wrapper (since the tfm argument is different), but _not_
encrypt/decrypt like you mention. I could perform a type test in
SKCIPHER_REQUEST_ON_STACK().

Globally:
- add struct crypto_sync_skcipher wrapper
- add crypto_alloc_sync_skcipher() to check non-ASYNC and request size
of actual tfm
- add skcipher_request_set_sync_tfm() to attach the wrapped tfm to the request
- SKCIPHER_REQUEST_ON_STACK() would verify the tfm was a struct
crypto_sync_skcipher.

Two changes per user:
- change allocation to use new crypto_alloc_sync_skcipher() which does
the runtime checking
- change skcipher_request_set_tfm() to skcipher_request_set_sync_tfm()

This means struct skcipher_request is unchanged, along with
_set_callback, _set_crypt, _zero, and en/decrypt.

API misuse would be caught at build-time (via
SKCIPHER_REQUEST_ON_STACK type checking) and any request size problems
would be caught at allocation time.

Does this sound like what you had in mind?

-Kees

-- 
Kees Cook
Pixel Security
