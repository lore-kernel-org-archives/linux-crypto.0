From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: sun7i: dt: Add Security System to A20 SoC DTS
Date: Sat, 24 May 2014 13:23:04 +0200
Message-ID: <201405241323.04179.marex@denx.de>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-3-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	rdunlap@infradead.org, maxime.ripard@free-electrons.com,
	linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
	davem@davemloft.net, grant.likely@linaro.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40078 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaEXRvl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 May 2014 13:51:41 -0400
In-Reply-To: <1400771396-9686-3-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, May 22, 2014 at 05:09:55 PM, LABBE Corentin wrote:

Commit message ... damn, there is a reason why you _should_ write the commit 
message, even if the $subject is descriptive enough. You should elaborate on 
what you did here and _why_ you did it. The _why_ part is also really important 
since when you read this patch 5 years from now, you won't be looking at this in 
a confused fashion.

> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi
> b/arch/arm/boot/dts/sun7i-a20.dtsi index f4b00a5..ea56552 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -523,6 +523,14 @@
>  			status = "disabled";
>  		};
> 
> +		crypto: crypto-engine@01c15000 {
> +			compatible = "allwinner,sun7i-a20-crypto";
> +			reg = <0x01c15000 0x1000>;
> +			interrupts = <0 86 4>;
> +			clocks = <&ahb_gates 5>, <&ss_clk>;
> +			clock-names = "ahb", "mod";
> +		};
> +
>  		spi2: spi@01c17000 {
>  			compatible = "allwinner,sun4i-a10-spi";
>  			reg = <0x01c17000 0x1000>;

Best regards,
Marek Vasut
