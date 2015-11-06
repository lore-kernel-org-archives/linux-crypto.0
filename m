From: Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 4/4] crypto: rockchip/crypto - add DT bindings documentation
Date: Fri, 06 Nov 2015 10:00:22 +0100
Message-ID: <5400475.WGQH63T0iE@phil>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com> <1446772644-2352-5-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446772644-2352-5-git-send-email-zain.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 6. November 2015, 09:17:24 schrieb Zain Wang:
> Add DT bindings documentation for the rk3288 crypto drivers.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> ---
> 
> Changde in v2:
> - None
> 
> Changed in v1:
> - remove the _crypto suffix
> - use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"
> - remove the description of status
> 
>  .../devicetree/bindings/crypto/rockchip-crypto.txt | 29 
++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-
crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt 
b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> new file mode 100644
> index 0000000..d27e203
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> @@ -0,0 +1,29 @@
> +Rockchip Electronics And Security Accelerator
> +
> +Required properties:
> +- compatible: Should be "rockchip,rk3288-crypto"
> +- reg: base physical address of the engine and length of memory mapped
> +       region
> +- interrupts: interrupt number
> +- clocks: reference to the clocks about crypto
> +- clock-names: "aclk" used to clock data
> +	       "hclk" used to clock data
> +	       "srst" used to clock crypto accelerator

mistmatch between description and example. I think you mean "sclk" instead of 
"srst", like we talked about in the first version.

> +	       "apb_pclk" used to clock dma
> +
> +Examples:
> +
> +	crypto: cypto-controller@ff8a0000 {
> +		compatible = "rockchip,rk3288-crypto";
> +		reg = <0xff8a0000 0x4000>;
> +		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru ACLK_CRYPTO>,
> +			 <&cru HCLK_CRYPTO>,
> +			 <&cru SCLK_CRYPTO>,
> +			 <&cru ACLK_DMAC1>;
> +		clock-names = "aclk",
> +			      "hclk",
> +			      "sclk",
> +			      "apb_pclk";
> +		status = "okay";
> +	};
> 
