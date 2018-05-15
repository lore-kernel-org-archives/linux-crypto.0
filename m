From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 3/3] arm64: dts: renesas: r8a7795: add ccree binding
Date: Tue, 15 May 2018 16:50:44 +0200
Message-ID: <CAMuHMdWzeNqsho1V6ezZb81T3_HcRzrtuQpmGXsjtFgt9BtZDQ@mail.gmail.com>
References: <1526387370-17142-1-git-send-email-gilad@benyossef.com> <1526387370-17142-4-git-send-email-gilad@benyossef.com>
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
In-Reply-To: <1526387370-17142-4-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On Tue, May 15, 2018 at 2:29 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Add bindings for CryptoCell instance in the SoC.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks for your patch!

> --- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> @@ -528,6 +528,14 @@
>                         status = "disabled";
>                 };
>
> +               arm_cc630p: crypto@e6601000 {
> +                       compatible = "arm,cryptocell-630p-ree";
> +                       interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
> +                       #interrupt-cells = <2>;

I believe the #interrupt-cells property is not needed.

> +                       reg = <0x0 0xe6601000 0 0x1000>;
> +                       clocks = <&cpg CPG_MOD 229>;
> +               };

The rest looks good, but I cannot verify the register block.

> +
>                 i2c3: i2c@e66d0000 {
>                         #address-cells = <1>;
>                         #size-cells = <0>;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
