From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RESEND PATCH 4/4] crypto: rk_crypto - add DT bindings
 documentation
Date: Fri, 30 Oct 2015 14:03:34 +0000
Message-ID: <20151030140334.GB31073@leverpostej>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com>
 <1446193369-4453-5-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org
To: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446193369-4453-5-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 30, 2015 at 04:22:49PM +0800, Zain Wang wrote:
> Add DT bindings documentation for the rk3288 crypto drivers.
> 
> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
>  .../devicetree/bindings/crypto/rk-crypto.txt       | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rk-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rk-crypto.txt b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
> new file mode 100644
> index 0000000..1e50768
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
> @@ -0,0 +1,31 @@
> +Rockchip Electronics And Security Accelerator
> +
> +Required properties:
> +- compatible: should be "rockchip,crypto"

Choose a more specific name. Rockchip could easily come up with another
crypto accelerator later.

> +- reg: base physical address of the engine and length of memory mapped
> +       region.
> +- interrupts: interrupt number
> +- clocks: clock specifiers
> +- clock-names: "aclk_crypto" used to clock data
> +			   "hclk_crypto" used to clock data
> +			   "srst_crypto" used to clock crypto accelerator
> +			   "apb_pclk"    used to clock dma
> +-status: Enable

No need to mention the status property.

Thanks,
Mark.

> +
> +Examples:
> +
> +	crypto: cypto-controller@ff8a0000 {
> +		compatible = "rockchip,crypto";
> +		reg = <0xff8a0000 0x4000>;
> +		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru ACLK_CRYPTO>,
> +			 <&cru HCLK_CRYPTO>,
> +			 <&cru SRST_CRYPTO>,
> +			 <&cru ACLK_DMAC1>;
> +
> +		clock-names = "aclk_crypto",
> +			      "hclk_crypto",
> +			      "srst_crypto",
> +				  "apb_pclk";
> +		status = "okay";
> +	};
> -- 
> 1.9.1
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
