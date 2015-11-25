From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v5 4/4] ARM: dts: rockchip: Add Crypto node for rk3288
Date: Wed, 25 Nov 2015 13:43:33 +0800
Message-ID: <1448430213-27203-5-git-send-email-zain.wang@rock-chips.com>
References: <1448430213-27203-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Zain Wang <zain.wang@rock-chips.com>
To: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448430213-27203-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add Crypto node for rk3288 including crypto controller and dma clk.

Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
---
Changed in v5:
- None

Changed in v4:
- None

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
index ad44d80..c6b1aa4 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -781,6 +781,18 @@
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
