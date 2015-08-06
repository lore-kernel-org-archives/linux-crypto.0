From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 11/14] ARM: dts: mx6sx: Add CAAM device node
Date: Thu, 6 Aug 2015 11:59:34 +0300
Message-ID: <55C321F6.1040801@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-12-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <ruchika.gupta@freescale.com>,
	<shawnguo@kernel.org>, <kernel@pengutronix.de>,
	<linux@arm.linux.org.uk>, <robh+dt@kernel.org>
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:41476
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755022AbbHFI7n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 04:59:43 -0400
In-Reply-To: <1438799328-10757-12-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/5/2015 9:28 PM, Victoria Milhoan wrote:
> Add CAAM device node to the i.MX6SX device tree.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> ---
>  arch/arm/boot/dts/imx6sx.dtsi | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
> index 708175d..20851cb 100644
> --- a/arch/arm/boot/dts/imx6sx.dtsi
> +++ b/arch/arm/boot/dts/imx6sx.dtsi
> @@ -738,6 +738,34 @@
>  			reg = <0x02100000 0x100000>;
>  			ranges;
>  
> +			crypto: caam@2100000 {
> +				compatible = "fsl,sec-v4.0";
> +				fsl,sec-era = <4>;
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				reg = <0x2100000 0x10000>;
> +				ranges = <0 0x2100000 0x10000>;
> +				interrupt-parent = <&intc>;
> +				clocks = <&clks IMX6SX_CLK_CAAM_MEM>,
> +					 <&clks IMX6SX_CLK_CAAM_ACLK>,
> +					 <&clks IMX6SX_CLK_CAAM_IPG>,
> +					 <&clks IMX6SX_CLK_EIM_SLOW>;
> +				clock-names = "mem", "aclk", "ipg", "emi_slow";
> +
> +				sec_jr0: jr0@1000 {
> +					compatible = "fsl,sec-v4.0-job-ring";
> +					reg = <0x1000 0x1000>;
> +					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
> +				};
> +
> +				sec_jr1: jr1@2000 {
> +					compatible = "fsl,sec-v4.0-job-ring";
> +					reg = <0x2000 0x1000>;
> +					interrupts = <0 106 0x4>;
> +					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;

Typo - duplicate property. Remove the first one.

Horia
