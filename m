Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D86A43BDBA
	for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 11:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226488; cv=pass; b=YGBgrtUxPCNio9tp2Tkf1IJQctAWPqh4Ztsjxu09uQsNDmzLtiM2NVnXYhCtb4eRgPZ7Bi3t88KuQAnOpwrmjuwcLkeSatiiB1jlq80tggRp6JWHZclTNteKhvt7Gyg44YaVS5T+lJ2OV0fq5a6xI0gJmfKB4fP9dB4H4wzyBGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226488; c=relaxed/simple;
	bh=N3XcxuvKeFv0jrHZq7jORW96HDTgTe/U58U3ymleexw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WlEXvm39pBa+qkEE06fJrJGT1sSqMM6dxUVIxZy1wC6+e9gMQgxrwz0ciPfdEBp8H3nHyyQlLcXyr32VSgNeW+52NTGFw6Gq6wRVBKcMrjf5A0MnPlWxCVaa8GZgzvrFP7w0ZhsM52Ya1R/gg0g56T/BvbOZ4INfs2YzjDl7eJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=h18HZxoa; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="h18HZxoa"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c197eaaab00so391253166b.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 04:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787226482; cv=none;
        d=google.com; s=arc-20260327;
        b=BNPqLCoSv+M0kBnQvMjK2eoASIu41kcvTn4teLkXQvFHfJzD/0+GYdMHhQg+0CT1ey
         4aMpkNzUv31gyTXNSAaSNMQu0zbjj8eED6txiKkTsP4a+Q/JfI6i1o9ta8QspvtkTy9H
         GNY7lQXOH1D1MFR2+iIreSLZYCr2ksZv+zc+F6s2YPEv4BfxjV8mvvrFlVgdshKRvtsV
         GATRnZ86ogKj0bb5oa7pZJ/mtJTsR9YwEhwDu/tnty6e6xr7ybsFzM59N0AOSBH8+79/
         dBnmPSLkM7Tec7EJuovTqrne/jpe8ey2HddzVI6rQFiJV53f2R+QcN+ZsSBC2/Fx2tXW
         8vlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=M4ykTKD26brTAJUSy1BqDUBmv6bxfPzSIe8lWvsCYHQ=;
        fh=6PXMQHYlYFzEd0iNrEIdFHzZSexObWCC3zkkeDLbFSc=;
        b=gw3s76LHM+lM/dnMmlAmfGY078hDOAtkZhVxPvx9RgVON3OtxhzbHXwewEwNw/5Gf0
         VWGCW1Z23uBGt8cwkU9tqvS+DiDp6hNwJ4xS/rlXnHKRHYvaFKwB/p2rN500xyH4hDnV
         49rCcJZk1aEEi+9ZyANaDe/UucT/NHraIMUS4YiDSV4IhPCtfZYQ2GWlfHsZGcUCCHvN
         7jjMJt4VXcfitd9K1Wu1gM492el/Nay8KwA13GxQAgWUZENxlIrtGS1YlFqMdHB6Pp6m
         KoXINpS40Xj/vJdGZmAmqUrxbM/BpL5/nuDLB6RSdSnL2zx72vV4EF/CKa7GsG0UI0X/
         MZDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1787226482; x=1787831282; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M4ykTKD26brTAJUSy1BqDUBmv6bxfPzSIe8lWvsCYHQ=;
        b=h18HZxoabvn9m/ScdqEyw2LXvAVg3a8Ks6k+ikg3eexYdUFCrjL54D29ghc9LxQC69
         x9Ih6lttJ/t432qM1uJYNSoVDUi5ARvRmIYuJceIXLw6Vh6PzGybvqvjvr2KFqWwYwak
         J9s7mTgxn3cyEBGN8r+9ztQuC8DUpUagH4QZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787226482; x=1787831282;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=M4ykTKD26brTAJUSy1BqDUBmv6bxfPzSIe8lWvsCYHQ=;
        b=Ch6ai+VqWndFhatoBmxF0shKFuD57nya7Qa3DVQryqgPYjx4QYk4/HnAdyrAXshHXU
         ro96lypsFG76jEBPdzLGAC+G8sYdzaqCbwPR6mViCNpVGai4Mii6RKgF/xIYAFeoR9pU
         Dv47T4vGRHeEXIGj8s+gtz3PnT7TVq2S8E2kqrI3wk/PhvX+YRlaDm0raPVB0ZSXIIQX
         BOq3QcvpiG7QYIWYCgTdiq8dHD04z6YuMrwdpF7BUCEGyTNeBpEvHb3PrXSykj7GU7Xf
         69zOJCBlJV9knhPcURbDMZx6Wd95oIzHeoLoe++Dzo5H2jXs8myZKKAMJbNwow1IMB4T
         TxsQ==
X-Forwarded-Encrypted: i=1; AHgh+RqYGib3wIPUa+SqpN9evA0NiswCYyqwvgx8X4yMjnfsu1sep9jLmauf70Yg7jnVwWT6Umrl4BRvqfLEuY4=@vger.kernel.org
X-Gm-Message-State: AFuF++kofDCg+IVrbYAAjQuHz33h67Dqwobz9t8f27NYOZ1tXw0lhnaH
	ArVo8rVbO3kaax0wO/YlgvgyHI4YPncRCVIZOaU0bX+Fj+muOhyQxCXd1Wmz6WUsPuDl9mrN5Jq
	H+jYXzUahsrzBriG620BKx9yQrJYrR+QDiiL4d2Rc
X-Gm-Gg: AR+sD129fMDW6OhAlhB5SNWJgXMJi4/BjiVGFKfdh8IXpjR6LH8rSjmVRj2zlvZ3VDZ
	SXxnUQpdCmdQuZEAvewb5yccR81aVLHqgOdscthpjven3lnrjCcM/j9zwIJ7S0bIO4yXzzZQSCg
	NhO7Rh7tWlgZUpljssjTr1TyNameXg+S1u2B4gyAKXhaTaOI/n2jSkXsMPTALmAhTDSDVni2zj+
	daOPE+KM8CLHUzcrpcXf/yCZQCPAYBLlbKbt2ZxOnXDPqIh13/Tw9kBgRkM/++AMZAF8jroKw3Y
	t2Ij/fKj5pFvWJubiHe7P0zLM4VYrb8m0chhQuPLpQU=
X-Received: by 2002:a17:907:c08c:b0:c21:96e8:578d with SMTP id
 a640c23a62f3a-c242e22d1e9mr985944566b.15.1787226482262; Thu, 20 Aug 2026
 04:48:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260810121121.210040-1-vlad@zlab.su>
In-Reply-To: <20260810121121.210040-1-vlad@zlab.su>
From: Simon Glass <sjg@chromium.org>
Date: Thu, 20 Aug 2026 05:47:49 -0600
X-Gm-Features: AcwNN1XeIHyrOI_JtbOBD7QmUWCfs6jOmGCxaoJ2CvViBz-nzt4BaJLUZj-8m5s
Message-ID: <CAFLszTiGPVD1UvGcdE64H1To3OWjOYTd9BNV+jHM0=_dEkMsDQ@mail.gmail.com>
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
To: Vladislav Leonov <vlad@zlab.su>
Cc: linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andi Shyti <andi.shyti@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Aurelien Jarno <aurelien@aurel32.net>, Brian Masney <bmasney@redhat.com>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Golle <daniel@makrotopia.org>, 
	"David S. Miller" <davem@davemloft.net>, David Wu <david.wu@rock-chips.com>, 
	Eric Dumazet <edumazet@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heiko Stuebner <heiko@sntech.de>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jakub Kicinski <kuba@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Michael Turquette <mturquette@baylibre.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, Olivia Mackall <olivia@selenic.com>, 
	Paolo Abeni <pabeni@redhat.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pwm@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-usb@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Vladislav,

On Mon, 10 Aug 2026 at 06:15, Vladislav Leonov <vlad@zlab.su> wrote:
>
> Basic support for the Rockchip RV1106/RV1103 SoCs currently under review.
> This series builds on top of that and enables the peripherals needed to
> bring up a board beyond a serial console:
>
>  - CRU reset controller support (dt-bindings + clk driver), needed
>    by most of the other peripherals below.
>  - Ethernet (GMAC) via dwmac-rk.
>  - USB2 PHY and USB3-OTG (DWC3).
>  - I2C (rk3x).
>  - DMA (PL330) + support DMA for the UART nodes.
>  - SPI, including a new SCLK_IN_SPI1 clock gate.
>  - RNG.
>  - SDMMC1.
>  - A dts-only quirk (arm,cpu-registers-not-fw-configured) needed on
>    the ARM timer node when booting without a secure firmware that
>    pre-configures the CPU timer registers.
>  - PWM.
>
> Each new dt-binding is added ahead of the driver and dts nodes that
> depend on it, so the series bisects cleanly.
>
> This series depends on:
>  - "Add support for the Rockchip RV1106 and RV1103" (v3)
>    https://lore.kernel.org/all/20260729133609.3465563-1-sjg@chromium.org
>
>  - "pinctrl: Add support for the Rockchip RV1106" (v3)
>    https://lore.kernel.org/all/20260729132736.3807082-1-sjg@chromium.org
>
> Testing: boot-tested on custom RV1106 board, with every peripheral
> touched by this series: reset/CRU, Ethernet, USB2 PHY/USB3 DWC3,
> I2C, DMA+UART, SPI, RNG, SDMMC1 and PWM - exercised and confirmed working.
>
>
> Vladislav Leonov (25):
>   dt-bindings: reset: Add RV1106 CRU reset definitions
>   clk: rockchip: Add reset controller support for RV1106
>   ARM: dts: rockchip: Add reset bindings to RV1106
>   dt-bindings: net: rockchip-dwmac: add RV1106 compatible
>   net: ethernet: stmicro: stmmac: dwmac-rk: Add RV1106 support
>   ARM: dts: rockchip: Add Ethernet GMAC node for RV1106
>   dt-bindings: phy: rockchip,inno-usb2phy: Add RV1106 compatible
>   phy: rockchip: inno-usb2: Add support for RV1106
>   dt-bindings: usb: rockchip,dwc3: add RV1106 SoC support
>   ARM: dts: rockchip: Add USB2 PHY and USB3-OTG (DWC3) nodes for RV1106
>   dt-bindings: i2c: rk3x: Add RV1106 compatible
>   ARM: dts: rockchip: Add I2C nodes for RV1106
>   ARM: dts: rockchip: Add DMAC node for RV1106
>   ARM: dts: rockchip: Add DMA support to UART nodes
>   dt-bindings: clock: rockchip: Add SCLK_IN_SPI1 for RV1106
>   clk: rockchip: Add SCLK_IN_SPI1 gate for RV1106
>   dt-bindings: spi: rockchip: Add RV1106 compatible
>   spi: rockchip: Add support for RV1106
>   ARM: dts: rockchip: Add SPI nodes for RV1106
>   dt-bindings: rng: rockchip: Add RV1106 compatible
>   ARM: dts: rockchip: Add RNG node for RV1106
>   ARM: dts: rockchip: Add SDMMC1 node for RV1106
>   ARM: dts: rockchip: add arm,cpu-registers-not-fw-configured to RV1106
>     timer node
>   dt-bindings: pwm: rockchip: Add RV1106 compatible
>   ARM: dts: rockchip: Add PWM nodes for RV1106
>
>  .../devicetree/bindings/i2c/i2c-rk3x.yaml     |   1 +
>  .../bindings/net/rockchip-dwmac.yaml          |   2 +
>  .../bindings/phy/rockchip,inno-usb2phy.yaml   |   9 +-
>  .../devicetree/bindings/pwm/pwm-rockchip.yaml |   8 +
>  .../bindings/rng/rockchip,rk3588-rng.yaml     |  11 +-
>  .../devicetree/bindings/spi/spi-rockchip.yaml |   5 +
>  .../bindings/usb/rockchip,dwc3.yaml           |  35 +-
>  arch/arm/boot/dts/rockchip/rv1106.dtsi        | 426 ++++++++++++++++++
>  drivers/clk/rockchip/Makefile                 |   2 +-
>  drivers/clk/rockchip/clk-rv1106.c             |   4 +
>  drivers/clk/rockchip/clk.h                    |   1 +
>  drivers/clk/rockchip/rst-rv1106.c             | 340 ++++++++++++++
>  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |  55 +++
>  drivers/phy/rockchip/phy-rockchip-inno-usb2.c |  76 ++++
>  drivers/spi/spi-rockchip.c                    |   1 +
>  .../dt-bindings/clock/rockchip,rv1106-cru.h   |   2 +
>  .../dt-bindings/reset/rockchip,rv1106-cru.h   | 305 +++++++++++++
>  17 files changed, 1272 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/clk/rockchip/rst-rv1106.c
>  create mode 100644 include/dt-bindings/reset/rockchip,rv1106-cru.h
>
> ---
> base-commit: ac414f5eda0814030636177593400acdacfe5e1e
> branch: rv1106
>
> --
> 2.47.3
>

Just to note that I applied this series and tried it on my Luckfox
Pico Mini B (also RV1103 but more basic) and it boots fine. I enabled
the RNG node and the driver seems to work (i.e. the CRU is good).

For the series:
Tested-by: Simon Glass <sjg@chromium.org>  # Luckfox Pico Mini B (RV1103)

Regards,
Simon
