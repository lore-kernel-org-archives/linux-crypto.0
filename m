From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v2 5/5] arm64: dts: renesas: r8a7795: add ccree binding
Date: Sat, 2 Jun 2018 09:12:45 -0400
Message-ID: <20180602131241.5cl4hkbxydvcy6mu@verge.net.au>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
 <1527171551-21979-6-git-send-email-gilad@benyossef.com>
 <20180529161936.prhp4oikzamr6u3n@verge.net.au>
 <CAOtvUMeBCH+23c3FDWncMwPPe5N=7yjRKzhyLmFXrYazgGbcJw@mail.gmail.com>
 <CAMuHMdUX874g6pAz-Ze-yA3S+6aOhzUkfGN9wmQUhy-y0f7dMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
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
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdUX874g6pAz-Ze-yA3S+6aOhzUkfGN9wmQUhy-y0f7dMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 01, 2018 at 10:12:24AM +0200, Geert Uytterhoeven wrote:
> Hi Gilad,
> 
> On Thu, May 31, 2018 at 1:55 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > On Tue, May 29, 2018 at 7:19 PM, Simon Horman <horms@verge.net.au> wrote:
> >> On Thu, May 24, 2018 at 03:19:10PM +0100, Gilad Ben-Yossef wrote:
> >>> Add bindings for CryptoCell instance in the SoC.
> >>>
> >>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >>
> >> In so far as I can review the details of this (which is not much) this
> >> looks fine to me. I am, however, a little unclear in when it should be
> >> accepted.
> >
> > Since Herbert Xu ACKed the driver changes, I would say the only gating
> > commit is Geert's CR clock patch.
> 
> These are queued for v4.19.
> 
> > If that one is in, than I would say this one should go in as well.
> 
> As the device node now has a power-domains property, the genpd code will
> try to attach it to the CPG/MSSR PM Domain, which is a clock domain.
> In the absence of the clock patch, the device's module clock cannot be
> found, and dev_pm_domain_attach() and thus platform_drv_probe() will fail,
> before calling the device driver's .probe() function.
> 
> So there is no longer a dependency on the clock patch, and the DT patch can
> go in in parallel (although I prefer its subject to be changed
> s/binding/device device/).

Thanks, I have applied the following (but may not push until next week).

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] arm64: dts: renesas: r8a7795: add ccree to device tree

Add bindings for CryptoCell instance in the SoC.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm64/boot/dts/renesas/r8a7795.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a7795.dtsi b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
index d842940b2f43..3ac75dbf2d93 100644
--- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
@@ -528,6 +528,15 @@
 			status = "disabled";
 		};
 
+		arm_cc630p: crypto@e6601000 {
+			compatible = "arm,cryptocell-630p-ree";
+			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x0 0xe6601000 0 0x1000>;
+			clocks = <&cpg CPG_MOD 229>;
+			resets = <&cpg 229>;
+			power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+		};
+
 		i2c3: i2c@e66d0000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.11.0
