From: Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v3 4/4] ARM: dts: rockchip: Add Crypto node for rk3288
Date: Thu, 12 Nov 2015 11:00:23 +0100
Message-ID: <2270449.oxEXk1fLcI@phil>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com> <1447223759-20730-5-git-send-email-zain.wang@rock-chips.com>
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
In-Reply-To: <1447223759-20730-5-git-send-email-zain.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 11. November 2015, 14:35:59 schrieb Zain Wang:
> Add Crypto node for rk3288 including crypto controller and dma clk.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>

I'd like to pick this one and the clock-patch2 up, once the crypto
driver itself got accepted and we have an Ack from the clock-maintainers
for the clock-id patch.


Heiko

> ---
> Changed in v3:
> - add reset property
> 
> Changed in v2:
> - None
> 
> Changed in v1:
> - remove the _crypto suffix
> - use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"
> 
>  arch/arm/boot/dts/rk3288.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 6a79c9c..f0d1217 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -778,6 +778,18 @@
>  		status = "disabled";
>  	};
>  
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
> +
>  	vopb: vop@ff930000 {
>  		compatible = "rockchip,rk3288-vop";
>  		reg = <0xff930000 0x19c>;
> 
