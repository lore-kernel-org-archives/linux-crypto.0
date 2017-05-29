From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v2 12/12] ARM: sun5i: add a cryptographic engine node
Date: Mon, 29 May 2017 22:27:38 +0200
Message-ID: <20170529202738.2167-13-antoine.tenart@free-electrons.com>
References: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36644 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbdE2U2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 16:28:31 -0400
In-Reply-To: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a node for the cryptographic engine that can be found on sun5i SoCs.
This cryptographic engine is compatible with the Allwinner cryptographic
accelerator driver.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/sun5i.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
index 5175f9cc9bed..9bfefa2c7224 100644
--- a/arch/arm/boot/dts/sun5i.dtsi
+++ b/arch/arm/boot/dts/sun5i.dtsi
@@ -355,6 +355,14 @@
 			status = "disabled";
 		};
 
+		crypto: crypto-engine@01c15000 {
+			compatible = "allwinner,sun4i-a10-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <54>;
+			clocks = <&ccu CLK_AHB_SS>, <&ccu CLK_SS>;
+			clock-names = "ahb", "mod";
+		};
+
 		spi2: spi@01c17000 {
 			compatible = "allwinner,sun4i-a10-spi";
 			reg = <0x01c17000 0x1000>;
-- 
2.9.4
