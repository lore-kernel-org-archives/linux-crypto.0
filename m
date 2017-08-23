From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v2 1/4] crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
Date: Wed, 23 Aug 2017 08:27:04 +0530
Message-ID: <20170823025707.27888-2-prasannatsmkumar@gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, ralf@linux-mips.org,
        paul@crapouillou.net, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mips@linux-mips.org,
        malat@debian.org, noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38105 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbdHWC5h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 22:57:37 -0400
In-Reply-To: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add devicetree bindings for hardware pseudo random number generator
present in Ingenic JZ4780 SoC.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
Changes in v2:
* Add "syscon" in CGU node's compatible section
* Make RNG child node of CGU.

 .../bindings/crypto/ingenic,jz4780-rng.txt           | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt

diff --git a/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
new file mode 100644
index 0000000..a0c18e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
@@ -0,0 +1,20 @@
+Ingenic jz4780 RNG driver
+
+Required properties:
+- compatible : Should be "ingenic,jz4780-rng"
+
+Example:
+
+cgu: jz4780-cgu@10000000 {
+	compatible = "ingenic,jz4780-cgu", "syscon";
+	reg = <0x10000000 0x100>;
+
+	clocks = <&ext>, <&rtc>;
+	clock-names = "ext", "rtc";
+
+	#clock-cells = <1>;
+
+	rng: rng@d8 {
+		compatible = "ingenic,jz480-rng";
+	};
+};
-- 
2.10.0
