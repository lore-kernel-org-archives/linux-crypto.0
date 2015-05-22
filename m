From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 13/16] ARM: marvell/dt: add crypto node to armada-xp.dtsi
Date: Fri, 22 May 2015 15:33:59 +0200
Message-ID: <1432301642-11470-14-git-send-email-boris.brezillon@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47410 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946080AbbEVNeZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 09:34:25 -0400
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add crypto related nodes to armada-xp.dtsi.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/armada-xp.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 013d63f..a12a81f 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -220,6 +220,19 @@
 				};
 			};
 
+			crypto@90000 {
+				compatible = "marvell,armada-xp-crypto";
+				reg = <0x90000 0x10000>;
+				reg-names = "regs";
+				interrupts = <48>, <49>;
+				clocks = <&gateclk 23>, <&gateclk 23>;
+				clock-names = "cesa0", "cesa1";
+				marvell,crypto-srams = <&crypto_sram0>,
+						       <&crypto_sram1>;
+				marvell,crypto-sram-size = <0x600>;
+				status = "okay";
+			};
+
 			xor@f0900 {
 				compatible = "marvell,orion-xor";
 				reg = <0xF0900 0x100
@@ -240,6 +253,24 @@
 				};
 			};
 		};
+
+		crypto_sram0: sa-sram0 {
+			compatible = "mmio-sram";
+			reg = <MBUS_ID(0x09, 0x09) 0 0x800>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 MBUS_ID(0x09, 0x09) 0 0x800>;
+			status = "okay";
+		};
+
+		crypto_sram1: sa-sram1 {
+			compatible = "mmio-sram";
+			reg = <MBUS_ID(0x09, 0x05) 0 0x800>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 MBUS_ID(0x09, 0x05) 0 0x800>;
+			status = "okay";
+		};
 	};
 
 	clocks {
-- 
1.9.1
