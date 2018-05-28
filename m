From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH] crypto: morus - Hide Kconfig option for glue code
Date: Mon, 28 May 2018 19:53:03 +0200
Message-ID: <CAAUqJDtAopg0aTy3ea3xqXEqnzQD5C4mHs7YVMMKC5_z-HjO2A@mail.gmail.com>
References: <20180528154806.2621106-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180528154806.2621106-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(Resending in plaintext because Gmail for Android sucks...)

Hi Arnd,

I have already addressed that in a follow-up patch here:

https://patchwork.kernel.org/patch/10416245/

Regards,
Ondrej

2018-05-28 17:47 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> Enabling the glue drivers for morus640 and/or morus1280 leads to a build failure
> on all non-x86 architectures:
>
> crypto/morus1280_glue.c:24:10: fatal error: asm/fpu/api.h: No such file or directory
> scripts/Makefile.build:311: recipe for target 'crypto/morus1280_glue.o' failed
> crypto/morus640_glue.c:24:10: fatal error: asm/fpu/api.h: No such file or directory
> scripts/Makefile.build:311: recipe for target 'crypto/morus640_glue.o' failed
>
> There really is no reason to enable these unless we also have a real
> driver using the glue, so the Kconfig option can be hidden and remain
> selected by the x86 specific SIMD drivers or any others getting added
> in the future.
>
> Fixes: 56e8e57fc3a7 ("crypto: morus - Add common SIMD glue code for MORUS")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 75f5efde9aa3..e11c59d26ac5 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -341,7 +341,7 @@ config CRYPTO_MORUS640
>           Support for the MORUS-640 dedicated AEAD algorithm.
>
>  config CRYPTO_MORUS640_GLUE
> -       tristate "MORUS-640 AEAD algorithm (glue for SIMD optimizations)"
> +       tristate
>         select CRYPTO_AEAD
>         select CRYPTO_CRYPTD
>         help
> @@ -363,7 +363,7 @@ config CRYPTO_MORUS1280
>           Support for the MORUS-1280 dedicated AEAD algorithm.
>
>  config CRYPTO_MORUS1280_GLUE
> -       tristate "MORUS-1280 AEAD algorithm (glue for SIMD optimizations)"
> +       tristate
>         select CRYPTO_AEAD
>         select CRYPTO_CRYPTD
>         help
> --
> 2.9.0
>
