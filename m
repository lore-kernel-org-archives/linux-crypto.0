Return-Path: <SRS0=r27M=OJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:51020 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbeLAAN3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 19:13:29 -0500
Received: by mail-it1-f194.google.com with SMTP id z7so9046808iti.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2018 05:04:14 -0800 (PST)
MIME-Version: 1.0
References: <20181129063422.24307-1-ebiggers@kernel.org> <20181129063422.24307-5-ebiggers@kernel.org>
In-Reply-To: <20181129063422.24307-5-ebiggers@kernel.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 30 Nov 2018 14:04:03 +0100
Message-ID: <CAKv+Gu_Hu7+_0cec7CkPkONYXjmJ2az2XEpuzLv12FT7=0Tpaw@mail.gmail.com>
Subject: Re: [PATCH 4/4] crypto: arm64/chacha - add XChaCha12 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 29 Nov 2018 at 07:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Now that the ARM64 NEON implementation of ChaCha20 and XChaCha20 has
> been refactored to support varying the number of rounds, add support for
> XChaCha12.  This is identical to XChaCha20 except for the number of
> rounds, which is 12 instead of 20.  This can be used by Adiantum.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/Kconfig            |  2 +-
>  arch/arm64/crypto/chacha-neon-glue.c | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index d54ddb8468ef5..d9a523ecdd836 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -101,7 +101,7 @@ config CRYPTO_AES_ARM64_NEON_BLK
>         select CRYPTO_SIMD
>
>  config CRYPTO_CHACHA20_NEON
> -       tristate "ChaCha20 and XChaCha20 stream ciphers using NEON instructions"
> +       tristate "ChaCha20, XChaCha20, and XChaCha12 stream ciphers using NEON instructions"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_BLKCIPHER
>         select CRYPTO_CHACHA20
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index 4d992029b9121..346eb85498a1e 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -161,6 +161,22 @@ static struct skcipher_alg algs[] = {
>                 .setkey                 = crypto_chacha20_setkey,
>                 .encrypt                = xchacha_neon,
>                 .decrypt                = xchacha_neon,
> +       }, {
> +               .base.cra_name          = "xchacha12",
> +               .base.cra_driver_name   = "xchacha12-neon",
> +               .base.cra_priority      = 300,
> +               .base.cra_blocksize     = 1,
> +               .base.cra_ctxsize       = sizeof(struct chacha_ctx),
> +               .base.cra_module        = THIS_MODULE,
> +
> +               .min_keysize            = CHACHA_KEY_SIZE,
> +               .max_keysize            = CHACHA_KEY_SIZE,
> +               .ivsize                 = XCHACHA_IV_SIZE,
> +               .chunksize              = CHACHA_BLOCK_SIZE,
> +               .walksize               = 4 * CHACHA_BLOCK_SIZE,
> +               .setkey                 = crypto_chacha12_setkey,
> +               .encrypt                = xchacha_neon,
> +               .decrypt                = xchacha_neon,
>         }
>  };
>
> @@ -187,3 +203,5 @@ MODULE_ALIAS_CRYPTO("chacha20");
>  MODULE_ALIAS_CRYPTO("chacha20-neon");
>  MODULE_ALIAS_CRYPTO("xchacha20");
>  MODULE_ALIAS_CRYPTO("xchacha20-neon");
> +MODULE_ALIAS_CRYPTO("xchacha12");
> +MODULE_ALIAS_CRYPTO("xchacha12-neon");
> --
> 2.19.2
>
