From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/4] crypto: rockchip/crypto - add DT bindings
 documentation
Date: Wed, 11 Nov 2015 14:24:05 -0600
Message-ID: <20151111202405.GA6512@rob-hp-laptop>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
 <1447223759-20730-2-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org
To: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447223759-20730-2-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 11, 2015 at 02:35:56PM +0800, Zain Wang wrote:
> Add DT bindings documentation for the rk3288 crypto drivers.
> 
> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
> 
> Changed in v3:
> - add reset property
> 
> Changed in v2:
> - None
> 
> Changed in v1:
> - remove the _crypto suffix
> - use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"
> - remove the description of status
> 
> 
>  .../devicetree/bindings/crypto/rockchip-crypto.txt | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> new file mode 100644
> index 0000000..096df34
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> @@ -0,0 +1,29 @@
> +Rockchip Electronics And Security Accelerator
> +
> +Required properties:
> +- compatible: Should be "rockchip,rk3288-crypto"
> +- reg: Base physical address of the engine and length of memory mapped
> +       region
> +- interrupts: Interrupt number
> +- clocks: Reference to the clocks about crypto
> +- clock-names: "aclk" used to clock data
> +	       "hclk" used to clock data
> +	       "sclk" used to clock crypto accelerator
> +	       "apb_pclk" used to clock dma
> +- resets: Must contain an entry for each entry in reset-names.
> +	  See ../reset/reset.txt for details.
> +- reset-names: Must include the name "crypto-rst".
> +
> +Examples:
> +
> +	crypto: cypto-controller@ff8a0000 {
> +		compatible = "rockchip,rk3288-crypto";
> +		reg = <0xff8a0000 0x4000>;
> +		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
> +			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
> +		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
> +		resets = <&cru SRST_CRYPTO>;
> +		reset-names = "crypto-rst";
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
