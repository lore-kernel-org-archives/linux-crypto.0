Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457830D1E;
	Tue,  7 Nov 2023 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B2B7AA3;
	Tue,  7 Nov 2023 08:00:16 -0800 (PST)
Received: from i53875a93.versanet.de ([83.135.90.147] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1r0OUt-0005nU-7g; Tue, 07 Nov 2023 17:00:11 +0100
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
 krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
 p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org,
 Corentin Labbe <clabbe@baylibre.com>
Cc: ricardo@pardini.net, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rockchip@lists.infradead.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH 4/6] ARM64: dts: rk356x: add crypto node
Date: Tue, 07 Nov 2023 17:00:10 +0100
Message-ID: <4334358.iZASKD2KPV@diego>
In-Reply-To: <20231107155532.3747113-5-clabbe@baylibre.com>
References:
 <20231107155532.3747113-1-clabbe@baylibre.com>
 <20231107155532.3747113-5-clabbe@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 7. November 2023, 16:55:30 CET schrieb Corentin Labbe:
> Both RK3566 and RK3568 have a crypto IP handled by the rk3588 crypto driver so adds a
> node for it.

please follow other commits in the subject line, i.e.:

"arm64: dts: rockchip: add rk356x crypto node"


Thanks
Heiko
> 
> Tested-by: Ricardo Pardini <ricardo@pardini.net>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> index 0964761e3ce9..c94a1b535c32 100644
> --- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> @@ -1070,6 +1070,18 @@ sdhci: mmc@fe310000 {
>  		status = "disabled";
>  	};
>  
> +	crypto: crypto@fe380000 {
> +		compatible = "rockchip,rk3568-crypto";
> +		reg = <0x0 0xfe380000 0x0 0x2000>;
> +		interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru ACLK_CRYPTO_NS>, <&cru HCLK_CRYPTO_NS>,
> +			 <&cru CLK_CRYPTO_NS_CORE>;
> +		clock-names = "aclk", "hclk", "core";
> +		resets = <&cru SRST_CRYPTO_NS_CORE>;
> +		reset-names = "core";
> +		status = "okay";
> +	};
> +
>  	i2s0_8ch: i2s@fe400000 {
>  		compatible = "rockchip,rk3568-i2s-tdm";
>  		reg = <0x0 0xfe400000 0x0 0x1000>;
> 




