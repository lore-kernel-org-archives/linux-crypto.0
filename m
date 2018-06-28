From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 14/14] arm64: dts: marvell: armada-37xx: update the crypto engine compatible
Date: Thu, 28 Jun 2018 17:15:44 +0200
Message-ID: <20180628151544.22134-15-antoine.tenart@bootlin.com>
References: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, oferh@marvell.com,
        igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        gregory.clement@bootlin.com, andrew@lunn.ch, jason@lakedaemon.net,
        sebastian.hesselbarth@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

New compatibles are now supported by the Inside Secure SafeXcel driver.
As they are more specific than the old ones, they should be used
whenever possible. This patch updates the Marvell Armada 37xx device
tree accordingly.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 3353252d78a0..2d68614aa66c 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -287,7 +287,7 @@
 			};
 
 			crypto: crypto@90000 {
-				compatible = "inside-secure,safexcel-eip97";
+				compatible = "inside-secure,safexcel-eip97ies";
 				reg = <0x90000 0x20000>;
 				interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.17.1
