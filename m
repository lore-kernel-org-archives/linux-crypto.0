From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 17/27] ARM: dts: DRA7: Add support for SHA IP
Date: Wed, 22 Jun 2016 16:23:50 +0300
Message-ID: <1466601840-18486-18-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50642 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbcFVNZm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:42 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

DRA7 SoC has the same SHA IP as OMAP5. Add DT entry for the same.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
[t-kristo@ti.com: changed SHA to use EDMA instead of SDMA]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index da31a72..64759e1 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1776,6 +1776,17 @@
 			clocks = <&l3_iclk_div>;
 			clock-names = "fck";
 		};
+
+		sham: sham@53100000 {
+			compatible = "ti,omap5-sham";
+			ti,hwmods = "sham";
+			reg = <0x4b101000 0x300>;
+			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+			dmas = <&edma_xbar 119 0>;
+			dma-names = "rx";
+			clocks = <&l3_iclk_div>;
+			clock-names = "fck";
+		};
 	};
 
 	thermal_zones: thermal-zones {
-- 
1.9.1
