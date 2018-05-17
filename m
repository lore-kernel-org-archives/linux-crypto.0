From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 3/3] arm64: dts: renesas: r8a7795: add ccree binding
Date: Thu, 17 May 2018 16:09:51 +0300
Message-ID: <CAOtvUMdVNX_vBRofpc5rNiVL-a1NvWMDyWSOaXKYPkm57wkR_A@mail.gmail.com>
References: <1526387370-17142-1-git-send-email-gilad@benyossef.com>
 <1526387370-17142-4-git-send-email-gilad@benyossef.com> <CAMuHMdWzeNqsho1V6ezZb81T3_HcRzrtuQpmGXsjtFgt9BtZDQ@mail.gmail.com>
 <20180516074333.i2672u435ymwffk3@verge.net.au> <CAOtvUMfFjokOLCg6aHNQESJ_q4Jiok3izrPtae5wR+cND=XL6g@mail.gmail.com>
 <CAMuHMdVM55S7+PdnKusX-qkTxioc=0kQ6EGSbwv+kbLk5RCUYw@mail.gmail.com>
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVM55S7+PdnKusX-qkTxioc=0kQ6EGSbwv+kbLk5RCUYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 17, 2018 at 1:16 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Gilad,
>
> On Thu, May 17, 2018 at 10:01 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> On Wed, May 16, 2018 at 10:43 AM, Simon Horman <horms@verge.net.au> wrote:
>>> On Tue, May 15, 2018 at 04:50:44PM +0200, Geert Uytterhoeven wrote:
>>>> On Tue, May 15, 2018 at 2:29 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>>> > Add bindings for CryptoCell instance in the SoC.
>>>> >
>>>> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>>>
>>>> Thanks for your patch!
>>>>
>>>> > --- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
>>>> > +++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
>>>> > @@ -528,6 +528,14 @@
>>>> >                         status = "disabled";
>>>> >                 };
>>>> >
>>>> > +               arm_cc630p: crypto@e6601000 {
>>>> > +                       compatible = "arm,cryptocell-630p-ree";
>>>> > +                       interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
>>>> > +                       #interrupt-cells = <2>;
>>>>
>>>> I believe the #interrupt-cells property is not needed.
>>>>
>>>> > +                       reg = <0x0 0xe6601000 0 0x1000>;
>>>> > +                       clocks = <&cpg CPG_MOD 229>;
>
> Missing "power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;", as
> the Secure Engine is part of the CPG/MSSR clock domain (see below [*]).

Thank you. I didn't get this information from Renesas :-)

>
>>>> > +               };
>>>>
>>>> The rest looks good, but I cannot verify the register block.
>>>>
>>>> > +
>>>> >                 i2c3: i2c@e66d0000 {
>>>> >                         #address-cells = <1>;
>>>> >                         #size-cells = <0>;
>>>
>>> Thanks, I have applied this after dropping the #interrupt-cells property.
>>
>> Thanks you!
>>
>> Alas, it will not work without the clk patch (the previous one in the
>> series) so they need to be
>> taken or dropped together.
>
> Indeed. From a quick glance, it looks like drivers/crypto/ccree/cc_driver.c
> does not distinguish between the absence of the clock property, and an
> actual error in getting the clock, and never considers any error a failure
> (incl. -PROBE_DEFER).
>
> As of_clk_get() returns -ENOENT for both a missing clock property and a
> missing clock, you should use (devm_)clk_get() instead, and distinguish
> between NULL (no clock property) and IS_ERR() (actual failure -> abort).
>

Thank you, this is very valuable. I will do as you suggested.


> Hence in the absence of the clock patch, the driver accesses the crypto
> engine while its module clock is turned off, leading to:
>
>     ccree e6601000.crypto: Invalid CC signature: SIGNATURE=0x00000000
> != expected=0xDCC63000
>
> You must be lucky, though, usually you get an imprecise external abort
> later, crashing the whole system ;-)
>
> So I think this patch should be dropped for now.
>
> However, even with your clock patch, the signature checking fails for me,
> on both R-Car H3 ES1.0 and ES2.0.
> Does this need changes to the ARM Trusted Firmware, to allow Linux to
> access the public SCEG module?

Well, this is actually something different. If you look you will
notice that my patch was part of a 3 part patch series,
the first of which disabled this test.

If you take all the 3 patches, it will work.

To make things more interesting, I have since sending the patch
learned WHY the test does not work, so disabling
it is not needed - to make a long story short, I was reading the wrong
register that just happens to have the right value
in our FPGA based tests systems but does not in the real silicon
implementations.

But you are right - if the clock is not enabled and you are try to
read from the register the system does freeze.

I will send a fixed v2. based on your patch enabling the CR clock.

>
> [*] More on the subject of clock control:
> At least for Renesas SoCs, where the module is part of a clock domain, and
> can be controlled automatically by Runtime PM, you could drop the explicit
> clock control, and use Runtime PM instead
> (pm_runtime_{enable,get_sync,put,disable}()).  That would allow the driver
> to work on systems with any kind of PM Domains, too.
> Depending on the other platforms that include a CryptoCell and their
> (non)reliance on PM Domains, you may have to keep the explicit clock
> handling, in addition to Runtime PM.
>



> To decrease power consumption, I suggest to move the clock and/or Runtime
> PM handling to the routines that actually use the hardware, instead of
> powering the module in the probe routine.
>

This is very interesting and I will give it a try.

Thanks again!
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
