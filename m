From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 1/6] crypto: jz4780-rng: Add devicetree bindings for RNG in JZ4780 SoC
Date: Thu, 17 Aug 2017 23:55:15 +0530
Message-ID: <20170817182520.20102-2-prasannatsmkumar@gmail.com>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, mturquette@baylibre.com,
        sboyd@codeaurora.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34510 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdHQS0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 14:26:10 -0400
Received: by mail-pg0-f67.google.com with SMTP id y192so11080789pgd.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2017 11:26:09 -0700 (PDT)
In-Reply-To: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add devicetree bindings for hardware pseudo random number generator
present in Ingenic JZ4780 SoC.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 .../devicetree/bindings/rng/ingenic,jz4780-rng.txt | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt b/Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
new file mode 100644
index 0000000..88a0a92
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
@@ -0,0 +1,24 @@
+Ingenic jz4780 RNG driver
+
+Required properties:
+- compatible : Should be "ingenic,jz4780-rng"
+
+Example:
+
+cgu_registers {
+	compatible = "simple-mfd", "syscon";
+	reg = <0x10000000 0x100>;
+
+	cgu: jz4780-cgu@10000000 {
+		compatible = "ingenic,jz4780-cgu";
+
+		clocks = <&ext>, <&rtc>;
+		clock-names = "ext", "rtc";
+
+		#clock-cells = <1>;
+	};
+
+	rng: rng@d8 {
+		compatible = "ingenic,jz480-rng";
+	};
+};
-- 
2.10.0
