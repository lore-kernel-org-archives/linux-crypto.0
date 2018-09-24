From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH crypto-next 06/23] x86/fpu: Remove VLA usage of skcipher
Date: Mon, 24 Sep 2018 10:35:24 -0700
Message-ID: <CAGXu5jJxCHHxYzJy2v9sQ03qnDPAjf_biCxudaSuDH6LBEki2A@mail.gmail.com>
References: <20180919021100.3380-1-keescook@chromium.org> <20180919021100.3380-7-keescook@chromium.org>
 <CAKv+Gu8OXbMZqQCM3MOa0Feag94j+wnKKfCCyzit3eRJSN5+_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8OXbMZqQCM3MOa0Feag94j+wnKKfCCyzit3eRJSN5+_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 4:45 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On Wed, 19 Sep 2018 at 04:11, Kees Cook <keescook@chromium.org> wrote:
>>
>> In the quest to remove all stack VLA usage from the kernel[1], this
>> replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
>> with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
>> which uses a fixed stack size.
>>
>> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>
>> Cc: x86@kernel.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Doing some archeology on this driver, it turns out that the FPU
> wrapper was introduced to support combining the generic CTR, LRW, XTS
> and PCBC chaining modes with the AES-NI core transform. In the mean
> time, CTR, LRW and XTS support have been implemented natively, which
> leaves pcbc-aes-aesni as the only remaining user of the fpu template.
>
> Since there are no users of pcbc(aes) in the kernel, could we perhaps
> just remove this driver and all the special handling we have for it in
> aesni-intel_glue.c?

Both options get rid of the VLA, so I'm happy either way. ;)

> If not, or in case we prefer to defer that to the next release:
>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
