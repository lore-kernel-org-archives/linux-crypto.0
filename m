From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 4/4] crypto: rockchip/crypto - add DT bindings
 documentation
Date: Thu, 5 Nov 2015 20:27:45 -0600
Message-ID: <20151106022745.GA16227@rob-hp-laptop>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-5-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54463 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031154AbbKFC1v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2015 21:27:51 -0500
Content-Disposition: inline
In-Reply-To: <1446772644-2352-5-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 06, 2015 at 09:17:24AM +0800, Zain Wang wrote:
> Add DT bindings documentation for the rk3288 crypto drivers.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>

Acked-by: Rob Herring <robh@kernel.org>

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
>  .../devicetree/bindings/crypto/rockchip-crypto.txt | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
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
> -- 
> 1.9.1
> 
> 
