From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 27/28] ARM: dts: AM43xx: clk: Add RNG clk node
Date: Wed, 1 Jun 2016 12:06:45 +0300
Message-ID: <1464772006-11254-8-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:50619 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbcFAJHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:07:54 -0400
In-Reply-To: <1464772006-11254-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

Add clk node for RNG module.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 arch/arm/boot/dts/am43xx-clocks.dtsi | 8 ++++++++
 drivers/clk/ti/clk-43xx.c            | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/am43xx-clocks.dtsi b/arch/arm/boot/dts/am43xx-clocks.dtsi
index 7630ba1..d1d73b7 100644
--- a/arch/arm/boot/dts/am43xx-clocks.dtsi
+++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
@@ -104,6 +104,14 @@
 		clock-div = <1>;
 	};
 
+	rng_fck: rng_fck {
+		#clock-cells = <0>;
+		compatible = "fixed-factor-clock";
+		clocks = <&sys_clkin_ck>;
+		clock-mult = <1>;
+		clock-div = <1>;
+	};
+
 	ehrpwm0_tbclk: ehrpwm0_tbclk@664 {
 		#clock-cells = <0>;
 		compatible = "ti,gate-clock";
diff --git a/drivers/clk/ti/clk-43xx.c b/drivers/clk/ti/clk-43xx.c
index 097fc90..3f157a4 100644
--- a/drivers/clk/ti/clk-43xx.c
+++ b/drivers/clk/ti/clk-43xx.c
@@ -58,6 +58,7 @@ static struct ti_dt_clk am43xx_clks[] = {
 	DT_CLK(NULL, "smartreflex1_fck", "smartreflex1_fck"),
 	DT_CLK(NULL, "sha0_fck", "sha0_fck"),
 	DT_CLK(NULL, "aes0_fck", "aes0_fck"),
+	DT_CLK(NULL, "rng_fck", "rng_fck"),
 	DT_CLK(NULL, "timer1_fck", "timer1_fck"),
 	DT_CLK(NULL, "timer2_fck", "timer2_fck"),
 	DT_CLK(NULL, "timer3_fck", "timer3_fck"),
-- 
1.9.1
