From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v5 1/4] crypto: rockchip/crypto - add DT bindings documentation
Date: Wed, 25 Nov 2015 13:43:30 +0800
Message-ID: <1448430213-27203-2-git-send-email-zain.wang@rock-chips.com>
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

Add DT bindings documentation for the rk3288 crypto drivers.

Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
Acked-by: Rob Herring <robh@kernel.org>
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
- remove the description of status

 .../devicetree/bindings/crypto/rockchip-crypto.txt | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
new file mode 100644
index 0000000..096df34
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
@@ -0,0 +1,29 @@
+Rockchip Electronics And Security Accelerator
+
+Required properties:
+- compatible: Should be "rockchip,rk3288-crypto"
+- reg: Base physical address of the engine and length of memory mapped
+       region
+- interrupts: Interrupt number
+- clocks: Reference to the clocks about crypto
+- clock-names: "aclk" used to clock data
+	       "hclk" used to clock data
+	       "sclk" used to clock crypto accelerator
+	       "apb_pclk" used to clock dma
+- resets: Must contain an entry for each entry in reset-names.
+	  See ../reset/reset.txt for details.
+- reset-names: Must include the name "crypto-rst".
+
+Examples:
+
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
-- 
1.9.1
