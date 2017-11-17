From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -stable] arm: crypto: reduce priority of bit-sliced AES cipher
Date: Fri, 17 Nov 2017 20:07:36 +0000
Message-ID: <CAKv+Gu8cSz1OK3W-g8qtYwU65GkRL11V7--yx0sCzTc1ewgJxA@mail.gmail.com>
References: <20171117195027.88288-1-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171117195027.88288-1-ebiggers@google.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 17 November 2017 at 19:50, Eric Biggers <ebiggers@google.com> wrote:
> Hi,
>
> I'd like the following patch to be applied to stable for versions
> between 4.1 and 4.10 (inclusively).
>
> This is a minimal fix for a bug where arm32 kernels can use a much
> slower implementation of AES than is actually available, potentially
> forcing vendors to disable encryption on their devices.
>
> Min version is 4.1 because that was the first version to include the
> aes-ce algorithms.
>
> Max version is 4.10 because in 4.11, this bug was fixed incidentally as
> part of a complete rewrite of the bit-sliced AES implementation.
>
> ---8<---
>
> All the aes-bs (bit-sliced) and aes-ce (cryptographic extensions)
> algorithms had a priority of 300.  This is undesirable because it means
> an aes-bs algorithm may be used when an aes-ce algorithm is available.
> The aes-ce algorithms have much better performance (up to 10x faster).
>

I'd say up to 20x is more accurate.

> Fix it by decreasing the priority of the aes-bs algorithms to 250.
>
> This was fixed upstream by commit cc477bf64573 ("crypto: arm/aes -
> replace bit-sliced OpenSSL NEON code"), but it was just a small part of
> a complete rewrite.  This patch just fixes the priority bug for older
> kernels.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/aesbs-glue.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
> index 0511a6cafe24..5d934a0039d7 100644
> --- a/arch/arm/crypto/aesbs-glue.c
> +++ b/arch/arm/crypto/aesbs-glue.c
> @@ -363,7 +363,7 @@ static struct crypto_alg aesbs_algs[] = { {
>  }, {
>         .cra_name               = "cbc(aes)",
>         .cra_driver_name        = "cbc-aes-neonbs",
> -       .cra_priority           = 300,
> +       .cra_priority           = 250,
>         .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
>         .cra_blocksize          = AES_BLOCK_SIZE,
>         .cra_ctxsize            = sizeof(struct async_helper_ctx),
> @@ -383,7 +383,7 @@ static struct crypto_alg aesbs_algs[] = { {
>  }, {
>         .cra_name               = "ctr(aes)",
>         .cra_driver_name        = "ctr-aes-neonbs",
> -       .cra_priority           = 300,
> +       .cra_priority           = 250,
>         .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
>         .cra_blocksize          = 1,
>         .cra_ctxsize            = sizeof(struct async_helper_ctx),
> @@ -403,7 +403,7 @@ static struct crypto_alg aesbs_algs[] = { {
>  }, {
>         .cra_name               = "xts(aes)",
>         .cra_driver_name        = "xts-aes-neonbs",
> -       .cra_priority           = 300,
> +       .cra_priority           = 250,
>         .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
>         .cra_blocksize          = AES_BLOCK_SIZE,
>         .cra_ctxsize            = sizeof(struct async_helper_ctx),
> --
> 2.15.0.448.gf294e3d99a-goog
>
