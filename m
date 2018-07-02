From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 6/6] crypto: ccree: rate limit debug print
Date: Mon, 2 Jul 2018 14:58:59 +0200
Message-ID: <CAMuHMdW7Sock8Z=L7w58u9-q-gWvkz=VfK-QZDUXPgEw4+NBzA@mail.gmail.com>
References: <1530428560-4440-1-git-send-email-gilad@benyossef.com> <1530428560-4440-7-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, hadar.gat@arm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530428560-4440-7-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On Sun, Jul 1, 2018 at 9:05 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> A debug print about register status post interrupt can happen
> quite often. Rate limit it to avoid cluttering the log.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks for your patch!

> --- a/drivers/crypto/ccree/cc_driver.c
> +++ b/drivers/crypto/ccree/cc_driver.c
> @@ -131,8 +131,8 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
>         }
>
>         if (irr) {
> -               dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
> -                       irr);
> +               dev_dbg_ratelimited(dev, "IRR includes unknown cause bits (0x%08X)\n",
> +                                   irr);
>                 /* Just warning */
>         }

    cc_isr: 932 callbacks suppressed

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Note that it still printed 1410 lines like:

    ccree e6601000.crypto: Got IRR=0x008000D8 (actual value may differ)

but perhaps you do intend to see these during debugging?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
