From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 09/12] ARM: dts: mx6qdl: Add CAAM device node
Date: Thu, 30 Jul 2015 08:12:51 +0200
Message-ID: <20150730061251.GJ18700@pengutronix.de>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438228709-27650-10-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, ruchika.gupta@freescale.com,
	kernel@pengutronix.de, shawnguo@kernel.org,
	horia.geanta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbG3GMx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 02:12:53 -0400
Content-Disposition: inline
In-Reply-To: <1438228709-27650-10-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 29, 2015 at 08:58:26PM -0700, Victoria Milhoan wrote:
> Add CAAM device node to the i.MX6 device tree.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index e6d1359..4df9f1e 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -836,10 +836,32 @@
>  			reg = <0x02100000 0x100000>;
>  			ranges;
>  
> -			caam@02100000 {
> -				reg = <0x02100000 0x40000>;
> -				interrupts = <0 105 IRQ_TYPE_LEVEL_HIGH>,
> -					     <0 106 IRQ_TYPE_LEVEL_HIGH>;
> +			crypto: caam@2100000 {
> +				compatible = "fsl,sec-v4.0";
> +				fsl,sec-era = <4>;
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				reg = <0x2100000 0x10000>;
> +				ranges = <0 0x2100000 0x10000>;
> +				interrupt-parent = <&intc>;
> +				clocks = <&clks IMX6QDL_CAAM_MEM>,
> +					 <&clks IMX6QDL_CAAM_ACLK>,
> +					 <&clks IMX6QDL_CAAM_IPG>,
> +					 <&clks IMX6QDL_CLK_EIM_SLOW>;
> +				clock-names = "caam_mem", "caam_aclk",
> +					      "caam_ipg", "caam_emi_slow";

The binding document should be updated for these additional properties.
The namespace caam_ is already clear from the context, you can drop
these prefixes.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
