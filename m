Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D04C3F2CD
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 13:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E24F22146E
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 13:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgCEN7v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 08:59:51 -0500
Received: from inva021.nxp.com ([92.121.34.21]:49458 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCEN7q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 08:59:46 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1C4E620057C;
        Thu,  5 Mar 2020 14:59:43 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0F03A2002ED;
        Thu,  5 Mar 2020 14:59:43 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7C9182059D;
        Thu,  5 Mar 2020 14:59:42 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: dts: imx: align name for crypto node and child nodes
Date:   Thu,  5 Mar 2020 15:59:08 +0200
Message-Id: <20200305135909.8180-5-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305135909.8180-1-horia.geanta@nxp.com>
References: <20200305135909.8180-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto node should use the "crypto" generic naming,
and not a specific one ("sahara", "dcp", "caam").

Child nodes of the crypto node for caam crypto engine
should use the "jr" name (without an index),
as indicated in the DT binding.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm/boot/dts/imx23.dtsi   | 2 +-
 arch/arm/boot/dts/imx27.dtsi   | 2 +-
 arch/arm/boot/dts/imx28.dtsi   | 2 +-
 arch/arm/boot/dts/imx6qdl.dtsi | 6 +++---
 arch/arm/boot/dts/imx6sl.dtsi  | 2 +-
 arch/arm/boot/dts/imx6sll.dtsi | 2 +-
 arch/arm/boot/dts/imx6sx.dtsi  | 6 +++---
 arch/arm/boot/dts/imx6ul.dtsi  | 8 ++++----
 arch/arm/boot/dts/imx7s.dtsi   | 8 ++++----
 arch/arm/boot/dts/imx7ulp.dtsi | 4 ++--
 10 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index 8257630f7a49..eb0aeda1682c 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -422,7 +422,7 @@
 				clocks = <&clks 16>;
 			};
 
-			dcp@80028000 {
+			dcp: crypto@80028000 {
 				compatible = "fsl,imx23-dcp";
 				reg = <0x80028000 0x2000>;
 				interrupts = <53 54>;
diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index f3464cf52e49..002cd223f22d 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -525,7 +525,7 @@
 				reg = <0x10024600 0x200>;
 			};
 
-			sahara2: sahara@10025000 {
+			sahara2: crypto@10025000 {
 				compatible = "fsl,imx27-sahara";
 				reg = <0x10025000 0x1000>;
 				interrupts = <59>;
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index e14d8ef0158b..a1cbbeb39a4f 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -998,7 +998,7 @@
 				clocks = <&clks 26>;
 			};
 
-			dcp: dcp@80028000 {
+			dcp: crypto@80028000 {
 				compatible = "fsl,imx28-dcp", "fsl,imx23-dcp";
 				reg = <0x80028000 0x2000>;
 				interrupts = <52 53 54>;
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 70fb8b56b1d7..f87085db3f5e 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -942,7 +942,7 @@
 			reg = <0x02100000 0x100000>;
 			ranges;
 
-			crypto: caam@2100000 {
+			crypto: crypto@2100000 {
 				compatible = "fsl,sec-v4.0";
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -954,13 +954,13 @@
 					 <&clks IMX6QDL_CLK_EIM_SLOW>;
 				clock-names = "mem", "aclk", "ipg", "emi_slow";
 
-				sec_jr0: jr0@1000 {
+				sec_jr0: jr@1000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x1000 0x1000>;
 					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 				};
 
-				sec_jr1: jr1@2000 {
+				sec_jr1: jr@2000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x2000 0x1000>;
 					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index c8ec46fe8302..94e428b7759d 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -777,7 +777,7 @@
 				power-domains = <&pd_disp>;
 			};
 
-			dcp: dcp@20fc000 {
+			dcp: crypto@20fc000 {
 				compatible = "fsl,imx6sl-dcp", "fsl,imx28-dcp";
 				reg = <0x020fc000 0x4000>;
 				interrupts = <0 99 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index 797f850492fe..e8e0fb334cfb 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -652,7 +652,7 @@
 				status = "disabled";
 			};
 
-			dcp: dcp@20fc000 {
+			dcp: crypto@20fc000 {
 				compatible = "fsl,imx28-dcp";
 				reg = <0x020fc000 0x4000>;
 				interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index e47d346a3543..5ecbac85c87a 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -837,7 +837,7 @@
 			reg = <0x02100000 0x100000>;
 			ranges;
 
-			crypto: caam@2100000 {
+			crypto: crypto@2100000 {
 				compatible = "fsl,sec-v4.0";
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -850,13 +850,13 @@
 					 <&clks IMX6SX_CLK_EIM_SLOW>;
 				clock-names = "mem", "aclk", "ipg", "emi_slow";
 
-				sec_jr0: jr0@1000 {
+				sec_jr0: jr@1000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x1000 0x1000>;
 					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 				};
 
-				sec_jr1: jr1@2000 {
+				sec_jr1: jr@2000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x2000 0x1000>;
 					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index e1807e9d385a..b4a8f6a858b9 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -778,7 +778,7 @@
 			reg = <0x02100000 0x100000>;
 			ranges;
 
-			crypto: caam@2140000 {
+			crypto: crypto@2140000 {
 				compatible = "fsl,imx6ul-caam", "fsl,sec-v4.0";
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -789,19 +789,19 @@
 					 <&clks IMX6UL_CLK_CAAM_MEM>;
 				clock-names = "ipg", "aclk", "mem";
 
-				sec_jr0: jr0@1000 {
+				sec_jr0: jr@1000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x1000 0x1000>;
 					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 				};
 
-				sec_jr1: jr1@2000 {
+				sec_jr1: jr@2000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x2000 0x1000>;
 					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
 				};
 
-				sec_jr2: jr2@3000 {
+				sec_jr2: jr@3000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x3000 0x1000>;
 					interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 196bbd6f6fcc..dad529564fe1 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -932,7 +932,7 @@
 				};
 			};
 
-			crypto: caam@30900000 {
+			crypto: crypto@30900000 {
 				compatible = "fsl,sec-v4.0";
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -943,19 +943,19 @@
 					 <&clks IMX7D_AHB_CHANNEL_ROOT_CLK>;
 				clock-names = "ipg", "aclk";
 
-				sec_jr0: jr0@1000 {
+				sec_jr0: jr@1000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x1000 0x1000>;
 					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 				};
 
-				sec_jr1: jr1@2000 {
+				sec_jr1: jr@2000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x2000 0x1000>;
 					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
 				};
 
-				sec_jr2: jr1@3000 {
+				sec_jr2: jr@3000 {
 					compatible = "fsl,sec-v4.0-job-ring";
 					reg = <0x3000 0x1000>;
 					interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx7ulp.dtsi b/arch/arm/boot/dts/imx7ulp.dtsi
index ab91c98f2124..f7c4878534c8 100644
--- a/arch/arm/boot/dts/imx7ulp.dtsi
+++ b/arch/arm/boot/dts/imx7ulp.dtsi
@@ -132,13 +132,13 @@
 				 <&scg1 IMX7ULP_CLK_NIC1_BUS_DIV>;
 			clock-names = "aclk", "ipg";
 
-			sec_jr0: jr0@1000 {
+			sec_jr0: jr@1000 {
 				compatible = "fsl,sec-v4.0-job-ring";
 				reg = <0x1000 0x1000>;
 				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
 			};
 
-			sec_jr1: jr1@2000 {
+			sec_jr1: jr@2000 {
 				compatible = "fsl,sec-v4.0-job-ring";
 				reg = <0x2000 0x1000>;
 				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.17.1

