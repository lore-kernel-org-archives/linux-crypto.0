From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 16/27] ARM: dts: DRA7: Add DT nodes for AES IP
Date: Wed, 22 Jun 2016 16:23:49 +0300
Message-ID: <1466601840-18486-17-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41178 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbcFVNZa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:30 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
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
