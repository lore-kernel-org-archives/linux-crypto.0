Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC631A83;
	Tue,  7 Nov 2023 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1078F2695;
	Tue,  7 Nov 2023 07:59:52 -0800 (PST)
Received: from i53875a93.versanet.de ([83.135.90.147] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1r0OUR-0005mz-Ot; Tue, 07 Nov 2023 16:59:43 +0100
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
 krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
 p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org,
 Corentin Labbe <clabbe@baylibre.com>
Cc: ricardo@pardini.net, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rockchip@lists.infradead.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH 3/6] ARM64: dts: rk3588: add crypto node
Date: Tue, 07 Nov 2023 16:59:42 +0100
Message-ID: <10382065.T7Z3S40VBb@diego>
In-Reply-To: <20231107155532.3747113-4-clabbe@baylibre.com>
References:
 <20231107155532.3747113-1-clabbe@baylibre.com>
 <20231107155532.3747113-4-clabbe@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

Am Dienstag, 7. November 2023, 16:55:29 CET schrieb Corentin Labbe:
> The rk3588 has a crypto IP handled by the rk3588 crypto driver so adds a
> node for it.

please follow other commits in the subject line, i.e.:

"arm64: dts: rockchip: add rk3588 crypto node"


Thanks
Heiko

> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  arch/arm64/boot/dts/rockchip/rk3588s.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3588s.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
> index 7064c0e9179f..a2ba5ebec38d 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
> @@ -1523,6 +1523,18 @@ sdhci: mmc@fe2e0000 {
>  		status = "disabled";
>  	};
>  
> +	crypto: crypto@fe370000 {
> +		compatible = "rockchip,rk3588-crypto";
> +		reg = <0x0 0xfe370000 0x0 0x2000>;
> +		interrupts = <GIC_SPI 209 IRQ_TYPE_LEVEL_HIGH 0>;
> +		clocks = <&scmi_clk SCMI_CRYPTO_CORE>, <&scmi_clk SCMI_ACLK_SECURE_NS>,
> +			 <&scmi_clk SCMI_HCLK_SECURE_NS>;
> +		clock-names = "core", "aclk", "hclk";
> +		resets = <&scmi_reset SRST_CRYPTO_CORE>;
> +		reset-names = "core";
> +		status = "okay";
> +	};
> +
>  	i2s0_8ch: i2s@fe470000 {
>  		compatible = "rockchip,rk3588-i2s-tdm";
>  		reg = <0x0 0xfe470000 0x0 0x1000>;
> 




