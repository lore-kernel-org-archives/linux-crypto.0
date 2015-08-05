From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 10/14] ARM: dts: mx6qdl: Add CAAM device node
Date: Wed, 5 Aug 2015 11:28:44 -0700
Message-ID: <1438799328-10757-11-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:17638
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753442AbbHES2z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:55 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CAAM device node to the i.MX6 device tree.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index e6d1359..b5c89cd 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -836,10 +836,31 @@
 			reg = <0x02100000 0x100000>;
 			ranges;
 
-			caam@02100000 {
-				reg = <0x02100000 0x40000>;
-				interrupts = <0 105 IRQ_TYPE_LEVEL_HIGH>,
-					     <0 106 IRQ_TYPE_LEVEL_HIGH>;
+			crypto: caam@2100000 {
+				compatible = "fsl,sec-v4.0";
+				fsl,sec-era = <4>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0x2100000 0x10000>;
+				ranges = <0 0x2100000 0x10000>;
+				interrupt-parent = <&intc>;
+				clocks = <&clks IMX6QDL_CLK_CAAM_MEM>,
+					 <&clks IMX6QDL_CLK_CAAM_ACLK>,
+					 <&clks IMX6QDL_CLK_CAAM_IPG>,
+					 <&clks IMX6QDL_CLK_EIM_SLOW>;
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
 			};
 
 			aipstz@0217c000 { /* AIPSTZ2 */
-- 
2.1.4
