From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH 09/12] ARM: dts: mx6qdl: Add CAAM device node
Date: Wed, 29 Jul 2015 20:58:26 -0700
Message-ID: <1438228709-27650-10-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0111.outbound.protection.outlook.com ([207.46.100.111]:46984
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074AbbG3EOK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 00:14:10 -0400
In-Reply-To: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CAAM device node to the i.MX6 device tree.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index e6d1359..4df9f1e 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -836,10 +836,32 @@
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
+				clocks = <&clks IMX6QDL_CAAM_MEM>,
+					 <&clks IMX6QDL_CAAM_ACLK>,
+					 <&clks IMX6QDL_CAAM_IPG>,
+					 <&clks IMX6QDL_CLK_EIM_SLOW>;
+				clock-names = "caam_mem", "caam_aclk",
+					      "caam_ipg", "caam_emi_slow";
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
