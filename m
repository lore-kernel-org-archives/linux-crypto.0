From: Dong Aisheng <dongas86@gmail.com>
Subject: Re: [PATCH V3 2/2] ARM: dts: imx7s: add snvs rtc clock
Date: Tue, 9 Jan 2018 17:47:16 +0800
Message-ID: <20180109094716.GH26312@b29396-OptiPlex-7040>
References: <1515489651-13488-1-git-send-email-Anson.Huang@nxp.com>
 <1515489651-13488-2-git-send-email-Anson.Huang@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mturquette@baylibre.com,
        sboyd@codeaurora.org, adriana.reus@nxp.com, stefan@agner.ch,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-imx@nxp.com
To: Anson Huang <Anson.Huang@nxp.com>
Return-path: <linux-clk-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515489651-13488-2-git-send-email-Anson.Huang@nxp.com>
Sender: linux-clk-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 09, 2018 at 05:20:51PM +0800, Anson Huang wrote:
> Add i.MX7 SNVS RTC clock.
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---
> changes since v2:
> 	improve the binding doc statement about clocks.
>  Documentation/devicetree/bindings/crypto/fsl-sec4.txt | 15 +++++++++++++++
>  arch/arm/boot/dts/imx7s.dtsi                          |  2 ++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> index 76aec8a..7329f29 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> @@ -415,12 +415,25 @@ Secure Non-Volatile Storage (SNVS) Low Power (LP) RTC Node
>  	value type: <u32>
>  	Definition: LP register offset. default it is 0x34.
>  
> +   - clocks
> +      Usage: required if SNVS LP RTC requires explicit enablement of clocks
> +      Value type: <prop_encoded-array>
> +      Definition:  a clock specifier describing the clock required for
> +          enabling and disabling SNVS LP RTC.
> +

This clock seem optional.
Should we indicate it here explicitly?

BTW, i thought we probably could update poweroff and key as well at
the same time since device tree changes can go separately.
Does it make sense?

Regards
Dong Aisheng

> +   - clock-names
> +      Usage: required if SNVS LP RTC requires explicit enablement of clocks
> +      Value type: <string>
> +      Definition: clock name string should be "snvs-rtc".
> +
>  EXAMPLE
>  	sec_mon_rtc_lp@1 {
>  		compatible = "fsl,sec-v4.0-mon-rtc-lp";
>  		interrupts = <93 2>;
>  		regmap = <&snvs>;
>  		offset = <0x34>;
> +		clocks = <&clks IMX7D_SNVS_CLK>;
> +		clock-names = "snvs-rtc";
>  	};
>  
>  =====================================================================
> @@ -543,6 +556,8 @@ FULL EXAMPLE
>  			regmap = <&sec_mon>;
>  			offset = <0x34>;
>  			interrupts = <93 2>;
> +			clocks = <&clks IMX7D_SNVS_CLK>;
> +			clock-names = "snvs-rtc";
>  		};
>  
>  		snvs-pwrkey@020cc000 {
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 9aa2bb9..02baf42 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -551,6 +551,8 @@
>  					offset = <0x34>;
>  					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
>  						     <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
> +					clocks = <&clks IMX7D_SNVS_CLK>;
> +					clock-names = "snvs-rtc";
>  				};
>  
>  				snvs_poweroff: snvs-poweroff {
> -- 
> 1.9.1
> 
