From: Anson Huang <Anson.Huang@nxp.com>
Subject: [PATCH V2 2/2] ARM: dts: imx7s: add snvs rtc clock
Date: Tue, 9 Jan 2018 10:51:16 +0800
Message-ID: <1515466276-5541-2-git-send-email-Anson.Huang@nxp.com>
References: <1515466276-5541-1-git-send-email-Anson.Huang@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
To: <horia.geanta@nxp.com>, <aymen.sghaier@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <shawnguo@kernel.org>, <kernel@pengutronix.de>,
        <fabio.estevam@nxp.com>, <linux@armlinux.org.uk>,
        <mturquette@baylibre.com>, <sboyd@codeaurora.org>,
        <adriana.reus@nxp.com>, <stefan@agner.ch>, <dongas86@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515466276-5541-1-git-send-email-Anson.Huang@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add i.MX7 SNVS RTC clock.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
changes since v1:
	update snvs lp rtc binding-doc for clock info.
 Documentation/devicetree/bindings/crypto/fsl-sec4.txt | 16 ++++++++++++++++
 arch/arm/boot/dts/imx7s.dtsi                          |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index 76aec8a..da66ac4 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -415,12 +415,26 @@ Secure Non-Volatile Storage (SNVS) Low Power (LP) RTC Node
 	value type: <u32>
 	Definition: LP register offset. default it is 0x34.
 
+   - clocks
+      Usage: required if SNVS LP RTC requires explicit enablement of clocks
+      Value type: <prop_encoded-array>
+      Definition:  A list of phandle and clock specifier pairs describing
+          the clocks required for enabling and disabling SNVS LP RTC.
+
+   - clock-names
+      Usage: required if SNVS LP RTC requires explicit enablement of clocks
+      Value type: <string>
+      Definition: A list of clock name strings in the same order as the
+          clocks property.
+
 EXAMPLE
 	sec_mon_rtc_lp@1 {
 		compatible = "fsl,sec-v4.0-mon-rtc-lp";
 		interrupts = <93 2>;
 		regmap = <&snvs>;
 		offset = <0x34>;
+		clocks = <&clks IMX7D_SNVS_CLK>;
+		clock-names = "snvs-rtc";
 	};
 
 =====================================================================
@@ -543,6 +557,8 @@ FULL EXAMPLE
 			regmap = <&sec_mon>;
 			offset = <0x34>;
 			interrupts = <93 2>;
+			clocks = <&clks IMX7D_SNVS_CLK>;
+			clock-names = "snvs-rtc";
 		};
 
 		snvs-pwrkey@020cc000 {
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 9aa2bb9..02baf42 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -551,6 +551,8 @@
 					offset = <0x34>;
 					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+					clocks = <&clks IMX7D_SNVS_CLK>;
+					clock-names = "snvs-rtc";
 				};
 
 				snvs_poweroff: snvs-poweroff {
-- 
1.9.1
