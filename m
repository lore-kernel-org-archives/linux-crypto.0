From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v3 1/4] crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
Date: Mon, 18 Sep 2017 19:32:38 +0530
Message-ID: <20170918140241.24003-2-prasannatsmkumar@gmail.com>
References: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        ralf@linux-mips.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
        malat@debian.org, noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33486 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdIROED (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 10:04:03 -0400
Received: by mail-pf0-f194.google.com with SMTP id h4so233078pfk.0
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2017 07:04:03 -0700 (PDT)
In-Reply-To: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add devicetree bindings for hardware pseudo random number generator
present in Ingenic JZ4780 SoC.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
Changes in v3:
* Create a cgublock node with "simple-bus" compatible
* Make CGU and RNG node as children of cgublock node.

Changes in v2:                                                                   
* Add "syscon" in CGU node's compatible section                                  
* Make RNG child node of CGU.                                                    

 .../devicetree/bindings/rng/ingenic,jz4780-rng.txt  | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt b/Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
new file mode 100644
index 0000000..765df9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
@@ -0,0 +1,21 @@
+Ingenic jz4780 RNG driver
+
+Required properties:
+- compatible : Should be "ingenic,jz4780-rng"
+
+Example:
+
+cgublock {
+	compatible = "simple-bus";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	reg = <0x10000000 0x100>;
+	ranges;
+
+	rng: rng@d8 {
+		compatible = "ingenic,jz4780-rng";
+		reg = <0x100000d8 0x8>;
+	};
+};
-- 
2.10.0
