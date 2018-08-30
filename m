From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 0/6] crypto: vf-crc - Add new driver (and required clk, DTS...)
Date: Thu, 30 Aug 2018 19:15:33 +0200
Message-ID: <20180830171539.20008-1-krzk@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Add new driver for Freescale/NXP Vybrid CRC HW accelerator along with
prerequisities:
1. Clock,
2. Bindings,
3. CRC16 test tables for testing.

Patch 3/6 (ARM: dts: vfxxx: Add node for CRC hardware block) depends on patch
2/6 (clk) so it should go in following cycle (after clk change hits mainline).

Best regards,
Krzysztof


Krzysztof Kozlowski (6):
  dt-bindings: crypto: Add Freescale Vybrid CRC
  clk: imx: vf610: Add CRC clock
  ARM: dts: vfxxx: Add node for CRC hardware block
  crypto: testmgr - Add CRC16 test tables
  crypto - Group Freescale/NXP ARM architecture Kconfig entires together
  crypto: vf-crc - Add new driver for Freescale Vybrid CRC

 .../devicetree/bindings/crypto/fsl-vf610-crc.txt   |  16 +
 MAINTAINERS                                        |   7 +
 arch/arm/boot/dts/vfxxx.dtsi                       |   7 +
 crypto/testmgr.c                                   |   6 +
 crypto/testmgr.h                                   | 386 ++++++++++++++++++++
 drivers/clk/imx/clk-vf610.c                        |   1 +
 drivers/crypto/Kconfig                             |  42 ++-
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/vf-crc.c                            | 387 +++++++++++++++++++++
 include/dt-bindings/clock/vf610-clock.h            |   3 +-
 include/linux/crc32poly.h                          |   7 +
 11 files changed, 846 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-vf610-crc.txt
 create mode 100644 drivers/crypto/vf-crc.c

-- 
2.14.1
