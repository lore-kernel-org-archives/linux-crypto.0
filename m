From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v3 4/4] ARM: dts: rockchip: Add Crypto node for rk3288
Date: Wed, 11 Nov 2015 14:35:59 +0800
Message-ID: <1447223759-20730-5-git-send-email-zain.wang@rock-chips.com>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Zain Wang <zain.wang@rock-chips.com>
To: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.132]:54655 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbbKKGiY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 01:38:24 -0500
In-Reply-To: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Crypto node for rk3288 including crypto controller and dma clk.

Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
---
Changed in v3:
- add reset property

Changed in v2:
- None

Changed in v1:
- remove the _crypto suffix
- use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"

 arch/arm/boot/dts/rk3288.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 6a79c9c..f0d1217 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -778,6 +778,18 @@
 		status = "disabled";
 	};
 
+	crypto: cypto-controller@ff8a0000 {
+		compatible = "rockchip,rk3288-crypto";
+		reg = <0xff8a0000 0x4000>;
+		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
+			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
+		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
+		resets = <&cru SRST_CRYPTO>;
+		reset-names = "crypto-rst";
+		status = "okay";
+	};
+
 	vopb: vop@ff930000 {
 		compatible = "rockchip,rk3288-vop";
 		reg = <0xff930000 0x19c>;
-- 
1.9.1
