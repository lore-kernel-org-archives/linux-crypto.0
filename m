From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH crypto-next 07/23] block: cryptoloop: Remove VLA usage of skcipher
Date: Mon, 24 Sep 2018 10:53:30 -0700
Message-ID: <CAGXu5jLw3+nvb9opPeoCyH0MhyVK5UY7H5qeQ2b8GFTUGDGrUQ@mail.gmail.com>
References: <20180919021100.3380-1-keescook@chromium.org> <20180919021100.3380-8-keescook@chromium.org>
 <CAKv+Gu8ynaVi1KCMNsjCU0ucAjFFku=ourh9Yc9Rizoc4ztvOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8ynaVi1KCMNsjCU0ucAjFFku=ourh9Yc9Rizoc4ztvOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 4:52 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On Wed, 19 Sep 2018 at 04:11, Kees Cook <keescook@chromium.org> wrote:
>> @@ -119,7 +119,7 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
>>         unsigned in_offs, out_offs;
>>         int err;
>>
>> -       skcipher_request_set_tfm(req, tfm);
>> +       skcipher_request_set_sync_tfm(req, tfm);
>>         skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
>>                                       NULL, NULL);
>>
>
> Does this work?

Everything is a direct wrapper for existing types and functions, so I
wouldn't expect any functional change. I haven't been able to test
this particular interface, though. cryptoloop is very deprecated,
isn't it?

-Kees

-- 
Kees Cook
Pixel Security
