From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v1 3/4] ARM: dts: rockchip: Add Crypto drivers for rk3288
Date: Tue,  3 Nov 2015 13:52:07 +0800
Message-ID: <1446529928-12521-4-git-send-email-zain.wang@rock-chips.com>
References: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Zain Wang <zain.wang@rock-chips.com>
To: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add Crypto drivers for rk3288 including crypto controller and dma clk.

Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 6a79c9c..7b7914e 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -170,6 +170,21 @@
 		};
 	};
 
+	crypto: cypto-controller@ff8a0000 {
+		compatible = "rockchip,rk3288-crypto";
+		reg = <0xff8a0000 0x4000>;
+		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_CRYPTO>,
+			 <&cru HCLK_CRYPTO>,
+			 <&cru SCLK_CRYPTO>,
+			 <&cru ACLK_DMAC1>;
+		clock-names = "aclk",
+			      "hclk",
+			      "sclk",
+			      "apb_pclk";
+		status = "okay";
+	};
+
 	reserved-memory {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.9.1
