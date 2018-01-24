From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [RESEND PATCH 3/6] ARM: dts: imx7s: add CAAM device node
Date: Wed, 24 Jan 2018 14:50:32 +0000
Message-ID: <1516805435-15034-4-git-send-email-pure.logic@nexus-software.ie>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:42605 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933837AbeAXOus (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 09:50:48 -0500
Received: by mail-wm0-f65.google.com with SMTP id r71so9038224wmd.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2018 06:50:47 -0800 (PST)
In-Reply-To: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rui Miguel Silva <rui.silva@linaro.org>

Add CAAM device node to the i.MX7s device tree.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/arm/boot/dts/imx7s.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 82ad26e..0da146e 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -805,6 +805,32 @@
 				status = "disabled";
 			};
 
+			crypto: caam@30900000 {
+				compatible = "fsl,sec-v4.0";
+				fsl,sec-era = <4>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0x30900000 0x10000>;
+				ranges = <0 0x30900000 0x10000>;
+				clocks = <&clks IMX7D_CAAM_MEM_CLK>,
+					 <&clks IMX7D_CAAM_ACLK_CLK>,
+					 <&clks IMX7D_CAAM_IPG_CLK>,
+					 <&clks IMX7D_EIM_ROOT_CLK>;
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
 			flexcan1: can@30a00000 {
 				compatible = "fsl,imx7d-flexcan", "fsl,imx6q-flexcan";
 				reg = <0x30a00000 0x10000>;
-- 
2.7.4
