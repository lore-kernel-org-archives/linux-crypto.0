From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/6] ARM: dts: vfxxx: Add node for CRC hardware block
Date: Thu, 30 Aug 2018 19:15:36 +0200
Message-ID: <20180830171539.20008-4-krzk@kernel.org>
References: <20180830171539.20008-1-krzk@kernel.org>
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
In-Reply-To: <20180830171539.20008-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add node for HW CRC16/CRC32 accelerator present on VF500 and VF610 SoCs.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm/boot/dts/vfxxx.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index d392794d9c13..d6d0eca02939 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -276,6 +276,13 @@
 				status = "disabled";
 			};
 
+			crc: crc@40033000 {
+				compatible = "fsl,vf610-crc";
+				reg = <0x40033000 0x10>;
+				clocks = <&clks VF610_CLK_CRC>;
+				clock-names = "crc";
+			};
+
 			pit: pit@40037000 {
 				compatible = "fsl,vf610-pit";
 				reg = <0x40037000 0x1000>;
-- 
2.14.1
