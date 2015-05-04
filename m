From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 6/7] ARM: marvell/dt: add crypto node to armada 370 SoC
Date: Mon,  4 May 2015 14:27:05 +0200
Message-ID: <1430742426-21202-7-git-send-email-boris.brezillon@free-electrons.com>
References: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57772 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbbEDM10 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 08:27:26 -0400
In-Reply-To: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Arnaud Ebalard <arno@natisbad.org>

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
---
 arch/arm/boot/dts/armada-370.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 27397f1..a04f5aa 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -306,6 +306,28 @@
 					dmacap,memset;
 				};
 			};
+
+			crypto@90000 {
+				compatible = "marvell,armada-370-crypto";
+				reg = <0x90000 0x10000>;
+				reg-names = "regs";
+				interrupts = <48>;
+				clocks = <&gateclk 23>;
+				clock-names = "cesa0";
+				marvell,crypto-srams = <&crypto_sram>;
+				marvell,crypto-sram-size = <0x800>;
+				status = "okay";
+			};
+		};
+
+		crypto_sram: sa-sram {
+			compatible = "mmio-sram";
+			reg = <MBUS_ID(0x09, 0x01) 0 0x800>;
+			reg-names = "sram";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 MBUS_ID(0x09, 0x01) 0 0x800>;
+			status = "okay";
 		};
 	};
 };
-- 
1.9.1
