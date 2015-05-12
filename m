From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 8/8] ARM: mvebu: a38x: Enable A38x XOR engine features
Date: Tue, 12 May 2015 17:37:43 +0200
Message-ID: <1431445063-20226-9-git-send-email-maxime.ripard@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Lior Amsalem <alior@marvell.com>

The new XOR engine has a new compatible of its own, together with new
channel capabilities.

Use that new compatible now that we have a driver that can handle it.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Ofer Heifetz <oferh@marvell.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Tested-by: Nadav Haklai <nadavh@marvell.com>
---
 arch/arm/boot/dts/armada-38x.dtsi | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index ed2dd8ba4080..6d07b7389415 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -448,7 +448,7 @@
 			};
 
 			xor@60800 {
-				compatible = "marvell,orion-xor";
+				compatible = "marvell,a38x-xor";
 				reg = <0x60800 0x100
 				       0x60a00 0x100>;
 				clocks = <&gateclk 22>;
@@ -458,17 +458,13 @@
 					interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
 					dmacap,memcpy;
 					dmacap,xor;
-				};
-				xor01 {
-					interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-					dmacap,memcpy;
-					dmacap,xor;
-					dmacap,memset;
+					dmacap,pq;
+					dmacap,interrupt;
 				};
 			};
 
 			xor@60900 {
-				compatible = "marvell,orion-xor";
+				compatible = "marvell,a38x-xor";
 				reg = <0x60900 0x100
 				       0x60b00 0x100>;
 				clocks = <&gateclk 28>;
@@ -478,12 +474,8 @@
 					interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 					dmacap,memcpy;
 					dmacap,xor;
-				};
-				xor11 {
-					interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
-					dmacap,memcpy;
-					dmacap,xor;
-					dmacap,memset;
+					dmacap,pq;
+					dmacap,interrupt;
 				};
 			};
 
-- 
2.4.0
