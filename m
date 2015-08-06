From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v3 11/14] ARM: dts: mx6sx: Add CAAM device node
Date: Thu, 6 Aug 2015 11:42:37 -0700
Message-ID: <1438886557-28431-1-git-send-email-vicki.milhoan@freescale.com>
References: <55C321F6.1040801@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:14215
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755669AbbHFSmm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 14:42:42 -0400
In-Reply-To: <55C321F6.1040801@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CAAM device node to the i.MX6SX device tree.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 arch/arm/boot/dts/imx6sx.dtsi | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 708175d..e6223d8 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -738,6 +738,33 @@
 			reg = <0x02100000 0x100000>;
 			ranges;
 
+			crypto: caam@2100000 {
+				compatible = "fsl,sec-v4.0";
+				fsl,sec-era = <4>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0x2100000 0x10000>;
+				ranges = <0 0x2100000 0x10000>;
+				interrupt-parent = <&intc>;
+				clocks = <&clks IMX6SX_CLK_CAAM_MEM>,
+					 <&clks IMX6SX_CLK_CAAM_ACLK>,
+					 <&clks IMX6SX_CLK_CAAM_IPG>,
+					 <&clks IMX6SX_CLK_EIM_SLOW>;
+				clock-names = "mem", "aclk", "ipg", "emi_slow";
+
+				sec_jr0: jr0@1000 {
+					compatible = "fsl,sec-v4.0-job-ring";
+					reg = <0x1000 0x1000>;
+					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
+				};
+
+				sec_jr1: jr1@2000 {
+					compatible = "fsl,sec-v4.0-job-ring";
+					reg = <0x2000 0x1000>;
+					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
+				};
+			};
+
 			usbotg1: usb@02184000 {
 				compatible = "fsl,imx6sx-usb", "fsl,imx27-usb";
 				reg = <0x02184000 0x200>;
-- 
2.1.4
