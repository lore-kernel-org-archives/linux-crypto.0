From: Marek Vasut <marex@denx.de>
Subject: [PATCH 3/3] ARM: mxs: dts: Enable DCP for MXS
Date: Thu, 26 Sep 2013 13:18:26 +0200
Message-ID: <1380194306-5243-3-git-send-email-marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de>
Cc: linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:42433 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3IZLSl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 07:18:41 -0400
In-Reply-To: <1380194306-5243-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable the DCP by default on both i.MX23 and i.MX28.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
To: linux-crypto@vger.kernel.org
---
 arch/arm/boot/dts/imx23.dtsi | 4 +++-
 arch/arm/boot/dts/imx28.dtsi | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index 87faa6e..0630a9a 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -337,8 +337,10 @@
 			};
 
 			dcp@80028000 {
+				compatible = "fsl,mxs-dcp";
 				reg = <0x80028000 0x2000>;
-				status = "disabled";
+				interrupts = <53 54>;
+				status = "okay";
 			};
 
 			pxp@8002a000 {
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 918d419..8b5ad60 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -782,9 +782,10 @@
 			};
 
 			dcp: dcp@80028000 {
+				compatible = "fsl,mxs-dcp";
 				reg = <0x80028000 0x2000>;
-				interrupts = <52 53 54>;
-				compatible = "fsl-dcp";
+				interrupts = <53 54>;
+				status = "okay";
 			};
 
 			pxp: pxp@8002a000 {
-- 
1.8.4.rc3
