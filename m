From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v3 3/4] crypto: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Mon, 18 Sep 2017 19:32:40 +0530
Message-ID: <20170918140241.24003-4-prasannatsmkumar@gmail.com>
References: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        ralf@linux-mips.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
        malat@debian.org, noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34451 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbdIROES (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 10:04:18 -0400
Received: by mail-pg0-f66.google.com with SMTP id u18so179073pgo.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2017 07:04:17 -0700 (PDT)
In-Reply-To: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add RNG node to jz4780 dtsi. This driver uses registers that are part of
the register set used by Ingenic CGU driver. Use regmap in RNG driver to
access its register. Create 'simple-bus' node, make CGU and RNG node as
child of it so that both the nodes are visible without changing CGU
driver code.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
Changes in v3:
* Create a cgublock node with "simple-bus" compatible
* Make CGU and RNG node as children of cgublock node.

Changes in v2:                                                                   
* Add "syscon" in CGU node's compatible section                                  
* Make RNG child node of CGU.                                                    

 arch/mips/boot/dts/ingenic/jz4780.dtsi | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
index 4853ef6..5953b97 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -34,14 +34,29 @@
 		clock-frequency = <32768>;
 	};
 
-	cgu: jz4780-cgu@10000000 {
-		compatible = "ingenic,jz4780-cgu";
+	cgublock {
+		compatible = "simple-bus";
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
 		reg = <0x10000000 0x100>;
+		ranges;
 
-		clocks = <&ext>, <&rtc>;
-		clock-names = "ext", "rtc";
+		cgu: jz4780-cgu@0 {
+			compatible = "ingenic,jz4780-cgu";
+			reg = <0x10000000 0x100>;
 
-		#clock-cells = <1>;
+			clocks = <&ext>, <&rtc>;
+			clock-names = "ext", "rtc";
+
+			#clock-cells = <1>;
+		};
+
+		rng: rng@d8 {
+			compatible = "ingenic,jz4780-rng";
+			reg = <0x100000d8 0x8>;
+		};
 	};
 
 	pinctrl: pin-controller@10010000 {
-- 
2.10.0
