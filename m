From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 0/5] crypto: ccree: cleanup, fixes and R-Car enabling
Date: Tue, 19 Jun 2018 14:58:10 +0200
Message-ID: <CAMuHMdVXrppnFEBmR3xhwNu3i0N3mVE1+FJRjEcWBYpHHbsAsw@mail.gmail.com>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On Thu, May 24, 2018 at 4:19 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> The patch set enables the use of CryptoCell found in some Renesas R-Car
> Salvator-X boards and fixes some driver issues uncovered that prevented
> to work properly.

With DEBUG enabled on R-Car H3, I see lots of

    ccree e6601000.crypto: IRR includes unknown cause bits (0x00000098)
    ccree e6601000.crypto: IRR includes unknown cause bits (0x000000C0)
    ccree e6601000.crypto: IRR includes unknown cause bits (0x000000D0)
    ccree e6601000.crypto: IRR includes unknown cause bits (0x000000D8)
    ccree e6601000.crypto: IRR includes unknown cause bits (0x000000E0)
    ccree e6601000.crypto: IRR includes unknown cause bits (0x000000F0)
    ccree e6601000.crypto: IRR includes unknown cause bits (0x000000F8)

during boot. Is that expected?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
