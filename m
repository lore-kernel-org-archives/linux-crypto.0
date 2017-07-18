From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/4] arm64: dts: freescale: ls208xa: share aliases node
Date: Tue, 18 Jul 2017 18:30:48 +0300
Message-ID: <20170718153050.15330-3-horia.geanta@nxp.com>
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
Received: from mail-cys01nam02on0050.outbound.protection.outlook.com ([104.47.37.50]:65056
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751338AbdGRPb1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 11:31:27 -0400
In-Reply-To: <20170718153050.15330-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

aliases node is identical for all boards, thus move it
to the common file ls208xa.dtsi.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls2080a-qds.dts  | 5 -----
 arch/arm64/boot/dts/freescale/fsl-ls2080a-rdb.dts  | 5 -----
 arch/arm64/boot/dts/freescale/fsl-ls2080a-simu.dts | 5 -----
 arch/arm64/boot/dts/freescale/fsl-ls2088a-qds.dts  | 5 -----
 arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts  | 5 -----
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     | 5 +++++
 6 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2080a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls2080a-qds.dts
index ed209cd57283..3c99608b9b45 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2080a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2080a-qds.dts
@@ -55,11 +55,6 @@
 	model = "Freescale Layerscape 2080a QDS Board";
 	compatible = "fsl,ls2080a-qds", "fsl,ls2080a";
 
-	aliases {
-		serial0 = &serial0;
-		serial1 = &serial1;
-	};
-
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2080a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls2080a-rdb.dts
index 67ec3f9c81a1..a4e7de9f70d8 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2080a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2080a-rdb.dts
@@ -55,11 +55,6 @@
 	model = "Freescale Layerscape 2080a RDB Board";
 	compatible = "fsl,ls2080a-rdb", "fsl,ls2080a";
 
-	aliases {
-		serial0 = &serial0;
-		serial1 = &serial1;
-	};
-
 	chosen {
 		stdout-path = "serial1:115200n8";
 	};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2080a-simu.dts b/arch/arm64/boot/dts/freescale/fsl-ls2080a-simu.dts
index 3ee718f0aaf8..fbbb73e571c0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2080a-simu.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2080a-simu.dts
@@ -52,11 +52,6 @@
 	model = "Freescale Layerscape 2080a software Simulator model";
 	compatible = "fsl,ls2080a-simu", "fsl,ls2080a";
 
-	aliases {
-		serial0 = &serial0;
-		serial1 = &serial1;
-	};
-
 	ethernet@2210000 {
 		compatible = "smsc,lan91c111";
 		reg = <0x0 0x2210000 0x0 0x100>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2088a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls2088a-qds.dts
index 4a1df5ce3229..eaee5b1c3a44 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2088a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2088a-qds.dts
@@ -54,11 +54,6 @@
 	model = "Freescale Layerscape 2088A QDS Board";
 	compatible = "fsl,ls2088a-qds", "fsl,ls2088a";
 
-	aliases {
-		serial0 = &serial0;
-		serial1 = &serial1;
-	};
-
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
index a76d4b4debd1..c411442cac62 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
@@ -54,11 +54,6 @@
 	model = "Freescale Layerscape 2088A RDB Board";
 	compatible = "fsl,ls2088a-rdb", "fsl,ls2088a";
 
-	aliases {
-		serial0 = &serial0;
-		serial1 = &serial1;
-	};
-
 	chosen {
 		stdout-path = "serial1:115200n8";
 	};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 94cdd3045037..f135b987d13b 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -53,6 +53,11 @@
 	#address-cells = <2>;
 	#size-cells = <2>;
 
+	aliases {
+		serial0 = &serial0;
+		serial1 = &serial1;
+	};
+
 	cpu: cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.12.0.264.gd6db3f216544
