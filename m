From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v1 4/4] crypto: rk_crypto - add DT bindings documentation
Date: Tue,  3 Nov 2015 13:52:08 +0800
Message-ID: <1446529928-12521-5-git-send-email-zain.wang@rock-chips.com>
References: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Zain Wang <zain.wang@rock-chips.com>
To: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:53588 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbKCFyn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Nov 2015 00:54:43 -0500
In-Reply-To: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add DT bindings documentation for the rk3288 crypto drivers.

Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
---
 .../devicetree/bindings/crypto/rockchip-crypto.txt | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
new file mode 100644
index 0000000..d27e203
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
@@ -0,0 +1,29 @@
+Rockchip Electronics And Security Accelerator
+
+Required properties:
+- compatible: Should be "rockchip,rk3288-crypto"
+- reg: base physical address of the engine and length of memory mapped
+       region
+- interrupts: interrupt number
+- clocks: reference to the clocks about crypto
+- clock-names: "aclk" used to clock data
+	       "hclk" used to clock data
+	       "srst" used to clock crypto accelerator
+	       "apb_pclk" used to clock dma
+
+Examples:
+
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
-- 
1.9.1
