From: Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 2/3] ARM: i.MX25: add RNGC node to dtsi
Date: Tue, 1 Mar 2016 21:37:10 +0800
Message-ID: <20160301133710.GV22051@tiger>
References: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
 <1456761156-27664-2-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbcCANhX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 08:37:23 -0500
Content-Disposition: inline
In-Reply-To: <1456761156-27664-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 29, 2016 at 04:52:35PM +0100, Steffen Trumtrar wrote:
> Add a devicetree entry for the Random Number Generator Version C (RNGC).
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  arch/arm/boot/dts/imx25.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
> index cde329e9b9e3..ec44ed125057 100644
> --- a/arch/arm/boot/dts/imx25.dtsi
> +++ b/arch/arm/boot/dts/imx25.dtsi
> @@ -397,6 +397,15 @@
>  				interrupts = <41>;
>  			};
>  
> +			rng: rng@53fb0000 {
> +				compatible = "fsl,imx25-rng";
> +				reg = <0x53fb0000 0x4000>;
> +				clocks = <&clks 109>;
> +				clock-names = "ipg";
> +				interrupts = <22>;
> +				interrupt-names = "rng";

I do not see interrupt-names in the binding doc (patch #1).  IMO, it
should be dropped.

Shawn

> +			};
> +
>  			esdhc1: esdhc@53fb4000 {
>  				compatible = "fsl,imx25-esdhc";
>  				reg = <0x53fb4000 0x4000>;
> -- 
> 2.7.0
> 
> 
