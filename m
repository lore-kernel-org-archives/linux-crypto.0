From: Paul Burton <paul.burton@imgtec.com>
Subject: Re: [PATCH v2 3/4] hw_random: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Fri, 2 Sep 2016 13:47:18 +0100
Message-ID: <4a7fb1cb-e0d4-31b7-7016-35adb63a659d@imgtec.com>
References: <1472321697-3094-1-git-send-email-prasannatsmkumar@gmail.com>
 <1472321697-3094-4-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <ralf@linux-mips.org>, <gregkh@linuxfoundation.org>,
        <boris.brezillon@free-electrons.com>, <harvey.hunt@imgtec.com>,
        <prarit@redhat.com>, <f.fainelli@gmail.com>,
        <joshua.henderson@microchip.com>, <narmstrong@baylibre.com>,
        <linus.walleij@linaro.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mips@linux-mips.org>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:50104 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbcIBMrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 08:47:32 -0400
In-Reply-To: <1472321697-3094-4-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 27/08/16 19:14, PrasannaKumar Muralidharan wrote:
> This patch adds RNG node to jz4780.dtsi.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  arch/mips/boot/dts/ingenic/jz4780.dtsi | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> index b868b42..f11d139 100644
> --- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
> +++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> @@ -36,7 +36,7 @@
>  
>  	cgu: jz4780-cgu@10000000 {
>  		compatible = "ingenic,jz4780-cgu";
> -		reg = <0x10000000 0x100>;
> +		reg = <0x10000000 0xD8>;

Hi PrasannaKumar,

I don't like this change. The RNG registers are documented as a part of
the same hardware block as the clock & power stuff which the CGU driver
handles, and indeed in the M200 SoC there is a power-related register
after the RNG registers. So shortening the range covered by the CGU
driver is not the right way to go.

Perhaps you could instead have the CGU driver make use of the syscon
infrastructure to expose a regmap which your RNG driver could pick up & use?

Thanks,
    Paul

>  
>  		clocks = <&ext>, <&rtc>;
>  		clock-names = "ext", "rtc";
> @@ -44,6 +44,11 @@
>  		#clock-cells = <1>;
>  	};
>  
> +	rng: jz4780-rng@100000D8 {
> +		compatible = "ingenic,jz4780-rng";
> +		reg = <0x100000D8 0x8>;
> +	};
> +
>  	uart0: serial@10030000 {
>  		compatible = "ingenic,jz4780-uart";
>  		reg = <0x10030000 0x100>;
> 
