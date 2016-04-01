From: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] ARM: i.MX25: add RNGC node to dtsi
Date: Fri, 1 Apr 2016 16:52:59 +0800
Message-ID: <20160401085259.GH18833@tiger>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1457705200-16951-2-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org
To: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457705200-16951-2-git-send-email-s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 11, 2016 at 03:06:39PM +0100, Steffen Trumtrar wrote:
> Add a devicetree entry for the Random Number Generator Version C (RNGC).
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
> ---
> Changes in v2:
>   - remove interrupt-names from dtsi
> 
>  arch/arm/boot/dts/imx25.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
> index cde329e9b9e3..ebf11d9f123e 100644
> --- a/arch/arm/boot/dts/imx25.dtsi
> +++ b/arch/arm/boot/dts/imx25.dtsi
> @@ -397,6 +397,14 @@
>  				interrupts = <41>;
>  			};
>  
> +			rng: rng@53fb0000 {
> +				compatible = "fsl,imx25-rng";
> +				reg = <0x53fb0000 0x4000>;
> +				clocks = <&clks 109>;
> +				clock-names = "ipg";

I think clock-names can be dropped too.

Shawn

> +				interrupts = <22>;
> +			};
> +
>  			esdhc1: esdhc@53fb4000 {
>  				compatible = "fsl,imx25-esdhc";
>  				reg = <0x53fb4000 0x4000>;
> -- 
> 2.7.0
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
