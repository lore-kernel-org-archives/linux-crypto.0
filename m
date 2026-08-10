Received: from mail.zlab.su (mail.zlab.su [109.73.193.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAC23C276D;
	Mon, 10 Aug 2026 12:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.73.193.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786364141; cv=none; b=UfrzdYqDfLD7ZmLkg6b4U8KHFD8Hnyun4OXWreznDxuUiBerLnMFrJT8hizknAz++Zh5nGsqFbhThv8LS//Z0Jgmm2BfhehrJLpZCtV6A7j4JPrKplnPd6ubczrgil0QlXpdtc9/WnlrQdj91iZFHoHN7o+9c1o9aVIcP4vhQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786364141; c=relaxed/simple;
	bh=khwQ1GsiVveOlP9AEL24r6N74e9UZZB8TnsSYugi5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e2jrs+Y6vSQCctM0G5Mpgoum8LZtzVEi411Z0jqzbKCrPWZ5rc3rJzAc7BkrTUgRgWIhuyHHdESsJF3FGX6iiW7XpHxUOSz2uskKDrLCauRdKsMKjYc/MLqwzewXhKgsBCMX+KeLKXhSAPsHZQV37mEkzFUMoff2BqlCOUBF9ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zlab.su; spf=pass smtp.mailfrom=zlab.su; dkim=pass (2048-bit key) header.d=zlab.su header.i=@zlab.su header.b=CTVbEZk1; arc=none smtp.client-ip=109.73.193.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zlab.su
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zlab.su
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zlab.su header.i=@zlab.su header.b="CTVbEZk1"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9EC0CBFAE6;
	Mon, 10 Aug 2026 15:15:04 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zlab.su; s=dkim;
	t=1786364134; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=2dK3m+M9aIXkQVgnJfJNEQmr51pr+7ZSZ5wBURiQagI=;
	b=CTVbEZk1O91g22l73hfrLfK/HDBLrNdVqWaJoUlOFyMh6T/aNVysy/LqWgNcYYbkV5vNzw
	gtAKqm+dARKLrZGZrSm3/XKCLRDSZ4ERyvE0b+dkq/s5O0oyHlNwLq4oBFale7R1oRa03R
	ojkB6VmEHXLVBH8V/ZJ1uaH0DlLdlHSCbgow9PIHETTYMV+MWsmWeeTqDRipse8jg+yBvL
	j/rfIH8SRFimjK3u+AcfZcPd7+fXS3NRILgxdoAFwPCm9rIGh5AxUTLGVlVMgjYCT8WOJA
	Qk9z4FiBS7NcfBZGDwudfbosAqeicDMRze0Q9fd6eWlmryJZX3O6N+1esyqs8Q==
From: Vladislav Leonov <vlad@zlab.su>
To: linux-rockchip@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org,
	Simon Glass <sjg@chromium.org>,
	linux-clk@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vladislav Leonov <vlad@zlab.su>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Brian Masney <bmasney@redhat.com>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Wu <david.wu@rock-chips.com>,
	Eric Dumazet <edumazet@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robh@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-pwm@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
Date: Mon, 10 Aug 2026 15:10:51 +0300
Message-ID: <20260810121121.210040-1-vlad@zlab.su>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Basic support for the Rockchip RV1106/RV1103 SoCs currently under review.
This series builds on top of that and enables the peripherals needed to
bring up a board beyond a serial console:

 - CRU reset controller support (dt-bindings + clk driver), needed
   by most of the other peripherals below.
 - Ethernet (GMAC) via dwmac-rk.
 - USB2 PHY and USB3-OTG (DWC3).
 - I2C (rk3x).
 - DMA (PL330) + support DMA for the UART nodes.
 - SPI, including a new SCLK_IN_SPI1 clock gate.
 - RNG.
 - SDMMC1.
 - A dts-only quirk (arm,cpu-registers-not-fw-configured) needed on
   the ARM timer node when booting without a secure firmware that
   pre-configures the CPU timer registers.
 - PWM.

Each new dt-binding is added ahead of the driver and dts nodes that
depend on it, so the series bisects cleanly.

This series depends on:
 - "Add support for the Rockchip RV1106 and RV1103" (v3)
   https://lore.kernel.org/all/20260729133609.3465563-1-sjg@chromium.org

 - "pinctrl: Add support for the Rockchip RV1106" (v3)
   https://lore.kernel.org/all/20260729132736.3807082-1-sjg@chromium.org

Testing: boot-tested on custom RV1106 board, with every peripheral
touched by this series: reset/CRU, Ethernet, USB2 PHY/USB3 DWC3,
I2C, DMA+UART, SPI, RNG, SDMMC1 and PWM - exercised and confirmed working.


Vladislav Leonov (25):
  dt-bindings: reset: Add RV1106 CRU reset definitions
  clk: rockchip: Add reset controller support for RV1106
  ARM: dts: rockchip: Add reset bindings to RV1106
  dt-bindings: net: rockchip-dwmac: add RV1106 compatible
  net: ethernet: stmicro: stmmac: dwmac-rk: Add RV1106 support
  ARM: dts: rockchip: Add Ethernet GMAC node for RV1106
  dt-bindings: phy: rockchip,inno-usb2phy: Add RV1106 compatible
  phy: rockchip: inno-usb2: Add support for RV1106
  dt-bindings: usb: rockchip,dwc3: add RV1106 SoC support
  ARM: dts: rockchip: Add USB2 PHY and USB3-OTG (DWC3) nodes for RV1106
  dt-bindings: i2c: rk3x: Add RV1106 compatible
  ARM: dts: rockchip: Add I2C nodes for RV1106
  ARM: dts: rockchip: Add DMAC node for RV1106
  ARM: dts: rockchip: Add DMA support to UART nodes
  dt-bindings: clock: rockchip: Add SCLK_IN_SPI1 for RV1106
  clk: rockchip: Add SCLK_IN_SPI1 gate for RV1106
  dt-bindings: spi: rockchip: Add RV1106 compatible
  spi: rockchip: Add support for RV1106
  ARM: dts: rockchip: Add SPI nodes for RV1106
  dt-bindings: rng: rockchip: Add RV1106 compatible
  ARM: dts: rockchip: Add RNG node for RV1106
  ARM: dts: rockchip: Add SDMMC1 node for RV1106
  ARM: dts: rockchip: add arm,cpu-registers-not-fw-configured to RV1106
    timer node
  dt-bindings: pwm: rockchip: Add RV1106 compatible
  ARM: dts: rockchip: Add PWM nodes for RV1106

 .../devicetree/bindings/i2c/i2c-rk3x.yaml     |   1 +
 .../bindings/net/rockchip-dwmac.yaml          |   2 +
 .../bindings/phy/rockchip,inno-usb2phy.yaml   |   9 +-
 .../devicetree/bindings/pwm/pwm-rockchip.yaml |   8 +
 .../bindings/rng/rockchip,rk3588-rng.yaml     |  11 +-
 .../devicetree/bindings/spi/spi-rockchip.yaml |   5 +
 .../bindings/usb/rockchip,dwc3.yaml           |  35 +-
 arch/arm/boot/dts/rockchip/rv1106.dtsi        | 426 ++++++++++++++++++
 drivers/clk/rockchip/Makefile                 |   2 +-
 drivers/clk/rockchip/clk-rv1106.c             |   4 +
 drivers/clk/rockchip/clk.h                    |   1 +
 drivers/clk/rockchip/rst-rv1106.c             | 340 ++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |  55 +++
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |  76 ++++
 drivers/spi/spi-rockchip.c                    |   1 +
 .../dt-bindings/clock/rockchip,rv1106-cru.h   |   2 +
 .../dt-bindings/reset/rockchip,rv1106-cru.h   | 305 +++++++++++++
 17 files changed, 1272 insertions(+), 11 deletions(-)
 create mode 100644 drivers/clk/rockchip/rst-rv1106.c
 create mode 100644 include/dt-bindings/reset/rockchip,rv1106-cru.h

---
base-commit: ac414f5eda0814030636177593400acdacfe5e1e
branch: rv1106

-- 
2.47.3

