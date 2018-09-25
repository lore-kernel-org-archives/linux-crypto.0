From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH crypto-next 00/23] crypto: skcipher - Remove VLA usage
Date: Mon, 24 Sep 2018 17:49:37 -0700
Message-ID: <CAGXu5jKFdMXYGJ9AmR9=OkTqrU9_RqtMXeOmXfivv0VvwPfOmg@mail.gmail.com>
References: <20180919021100.3380-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 18, 2018 at 7:10 PM, Kees Cook <keescook@chromium.org> wrote:
> This is the full follow-up to earlier discussions[1] that suggested
> adding a new struct crypto_sync_skcipher to handle the VLA removal from
> SKCIPHER_REQUEST_ON_STACK.
>
> This series is effectively a no-op change: everything is a wrapper
> around struct crypto_skcipher, but provides compile-time enforcement
> for not putting an ASYNC skcipher on the stack, which allows us to
> declare the on-stack requests with a fixed stack size.
>
> [1] https://lkml.kernel.org/r/CAGXu5j+bpLK=EQ9LHkO8V=sdaQwt==6fbGhgn2Vi1E9_WxSGRQ@mail.gmail.com
>
> -Kees
>
> Kees Cook (23):
>   crypto: skcipher - Introduce crypto_sync_skcipher
>   gss_krb5: Remove VLA usage of skcipher
>   lib80211: Remove VLA usage of skcipher
>   mac802154: Remove VLA usage of skcipher
>   s390/crypto: Remove VLA usage of skcipher
>   x86/fpu: Remove VLA usage of skcipher
>   block: cryptoloop: Remove VLA usage of skcipher
>   libceph: Remove VLA usage of skcipher
>   ppp: mppe: Remove VLA usage of skcipher
>   rxrpc: Remove VLA usage of skcipher
>   wusb: Remove VLA usage of skcipher
>   crypto: ccp - Remove VLA usage of skcipher
>   crypto: vmx - Remove VLA usage of skcipher
>   crypto: null - Remove VLA usage of skcipher
>   crypto: cryptd - Remove VLA usage of skcipher
>   crypto: sahara - Remove VLA usage of skcipher
>   crypto: qce - Remove VLA usage of skcipher
>   crypto: artpec6 - Remove VLA usage of skcipher
>   crypto: chelsio - Remove VLA usage of skcipher
>   crypto: mxs-dcp - Remove VLA usage of skcipher
>   crypto: omap-aes - Remove VLA usage of skcipher
>   crypto: picoxcell - Remove VLA usage of skcipher
>   crypto: skcipher - Remove SKCIPHER_REQUEST_ON_STACK()

How do these look to you, Herbert? I'd really like to make sure these
make it for the next merge window -- they're the last VLAs left in the
kernel now. :)

-Kees

-- 
Kees Cook
Pixel Security
