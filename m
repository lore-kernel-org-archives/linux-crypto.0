From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 4/5] clk: renesas: r8a7795: add ccree clock bindings
Date: Tue, 29 May 2018 10:48:58 +0200
Message-ID: <CAMuHMdVxcnw5Qy4JPo5r-VvgSxDpp==g6sandNeNji+8CgKOqQ@mail.gmail.com>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com> <1527171551-21979-5-git-send-email-gilad@benyossef.com>
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
        Ofir Drang <ofir.drang@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        L
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527171551-21979-5-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 24, 2018 at 4:19 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> This patch adds the clock used by the CryptoCell 630p instance in the SoC.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Thanks, queueing in clk-renesas-for-v4.19, with "bindings" dropped from the
one-line summary.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
