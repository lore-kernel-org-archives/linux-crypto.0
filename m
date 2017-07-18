From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 4/4] arm64: dts: freescale: ls1088a: add crypto node
Date: Tue, 18 Jul 2017 18:30:50 +0300
Message-ID: <20170718153050.15330-5-horia.geanta@nxp.com>
References: <20170718153050.15330-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Shawn Guo <shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0082.outbound.protection.outlook.com ([104.47.33.82]:4692
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751446AbdGRPbd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 11:31:33 -0400
In-Reply-To: <20170718153050.15330-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LS1088A has a SEC v5.3 security engine.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 43 ++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index c144d06a6e33..6c22d75bc504 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -52,6 +52,10 @@
 	#address-cells = <2>;
 	#size-cells = <2>;
 
+	aliases {
+		crypto = &crypto;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -369,6 +373,45 @@
 			dma-coherent;
 			status = "disabled";
 		};
+
+		crypto: crypto@8000000 {
+			compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
+			fsl,sec-era = <8>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x00 0x8000000 0x100000>;
+			reg = <0x00 0x8000000 0x0 0x100000>;
+			interrupts = <GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>;
+			dma-coherent;
+
+			sec_jr0: jr@10000 {
+				compatible = "fsl,sec-v5.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
+				reg	   = <0x10000 0x10000>;
+				interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
+			sec_jr1: jr@20000 {
+				compatible = "fsl,sec-v5.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
+				reg	   = <0x20000 0x10000>;
+				interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
+			sec_jr2: jr@30000 {
+				compatible = "fsl,sec-v5.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
+				reg	   = <0x30000 0x10000>;
+				interrupts = <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
+			sec_jr3: jr@40000 {
+				compatible = "fsl,sec-v5.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
+				reg	   = <0x40000 0x10000>;
+				interrupts = <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
 	};
 
 };
-- 
2.12.0.264.gd6db3f216544
