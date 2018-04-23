From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] crypto: ccree: limit build to plausible archs
Date: Mon, 23 Apr 2018 14:13:04 +0200
Message-ID: <CAMuHMdXNAkCVpyGyQMKRMRGuXyjOHAGgvHT4QGkuYdZetOr-9Q@mail.gmail.com>
References: <1524484097-8315-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524484097-8315-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On Mon, Apr 23, 2018 at 1:48 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Limit option to compile ccree to plausible architectures.

Thanks for your patch!

> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index d1ea1a0..7302785 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -726,6 +726,7 @@ config CRYPTO_DEV_ARTPEC6
>  config CRYPTO_DEV_CCREE
>         tristate "Support for ARM TrustZone CryptoCell family of security processors"
>         depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
> +       depends on (XTENSA || X86 || UNICORE32 || SUPERH || RISCV || PPC32 || OPENRISC || NIOS2 || NDS32 || MIPS || MICROBLAZE || HEXAGON || H8300 || ARM || ARM64 || ARC || COMPILE_TEST)

That list looks a bit excessive to me...

>         default n
>         select CRYPTO_HASH
>         select CRYPTO_BLKCIPHER

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
