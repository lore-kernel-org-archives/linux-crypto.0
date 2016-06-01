From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 24/28] ARM: dts: DRA7: Add DT nodes for AES IP
Date: Wed, 1 Jun 2016 12:06:42 +0300
Message-ID: <1464772006-11254-5-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43609 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667AbcFAJHt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:07:49 -0400
In-Reply-To: <1464772006-11254-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel Fernandes <joelf@ti.com>

DRA7 SoC has the same AES IP as OMAP4. Add DT entries for both AES cores.

Signed-off-by: Joel Fernandes <joelf@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
[t-kristo@ti.com: squashed in the change to use EDMA, squashed in
                  support for two AES cores]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 959f99b..da31a72 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1744,6 +1744,28 @@
 			};
 		};
 
+		aes1: aes@4b500000 {
+			compatible = "ti,omap4-aes";
+			ti,hwmods = "aes1";
+			reg = <0x4b500000 0xa0>;
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			dmas = <&edma_xbar 111 0>, <&edma_xbar 110 0>;
+			dma-names = "tx", "rx";
+			clocks = <&l3_iclk_div>;
+			clock-names = "fck";
+		};
+
+		aes2: aes@4b700000 {
+			compatible = "ti,omap4-aes";
+			ti,hwmods = "aes2";
+			reg = <0x4b700000 0xa0>;
+			interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
+			dmas = <&edma_xbar 114 0>, <&edma_xbar 113 0>;
+			dma-names = "tx", "rx";
+			clocks = <&l3_iclk_div>;
+			clock-names = "fck";
+		};
+
 		des: des@480a5000 {
 			compatible = "ti,omap4-des";
 			ti,hwmods = "des";
-- 
1.9.1
