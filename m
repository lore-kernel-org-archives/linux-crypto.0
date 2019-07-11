Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12397C74A54
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 12:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6D2F21019
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 12:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfGKMXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 08:23:14 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53339 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbfGKMXM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 08:23:12 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 37298E000C;
        Thu, 11 Jul 2019 12:23:09 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dt-bindings: crypto: Convert Allwinner A10 Security Engine to a schema
Date:   Thu, 11 Jul 2019 14:23:01 +0200
Message-Id: <20190711122301.8193-1-maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The older Allwinner SoCs have a crypto engine that is supported in Linux,
with a matching Device Tree binding.

Now that we have the DT validation in place, let's convert the device tree
bindings for that controller over to a YAML schemas.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../crypto/allwinner,sun4i-a10-crypto.yaml    | 79 +++++++++++++++++++
 .../devicetree/bindings/crypto/sun4i-ss.txt   | 23 ------
 2 files changed, 79 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/sun4i-ss.txt

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
new file mode 100644
index 000000000000..80b3e7350a73
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun4i-a10-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner A10 Security System Device Tree Bindings
+
+maintainers:
+  - Chen-Yu Tsai <wens@csie.org>
+  - Maxime Ripard <maxime.ripard@bootlin.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: allwinner,sun4i-a10-crypto
+      - items:
+        - const: allwinner,sun5i-a13-crypto
+        - const: allwinner,sun4i-a10-crypto
+      - items:
+        - const: allwinner,sun6i-a31-crypto
+        - const: allwinner,sun4i-a10-crypto
+      - items:
+        - const: allwinner,sun7i-a20-crypto
+        - const: allwinner,sun4i-a10-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Bus Clock
+      - description: Module Clock
+
+  clock-names:
+    items:
+      - const: ahb
+      - const: mod
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: ahb
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+if:
+  properties:
+    compatible:
+      contains:
+        const: allwinner,sun6i-a31-crypto
+
+then:
+  required:
+    - resets
+    - reset-names
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto: crypto-engine@1c15000 {
+      compatible = "allwinner,sun4i-a10-crypto";
+      reg = <0x01c15000 0x1000>;
+      interrupts = <86>;
+      clocks = <&ahb_gates 5>, <&ss_clk>;
+      clock-names = "ahb", "mod";
+    };
+
+...
diff --git a/Documentation/devicetree/bindings/crypto/sun4i-ss.txt b/Documentation/devicetree/bindings/crypto/sun4i-ss.txt
deleted file mode 100644
index f2dc3d9bca92..000000000000
--- a/Documentation/devicetree/bindings/crypto/sun4i-ss.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-* Allwinner Security System found on A20 SoC
-
-Required properties:
-- compatible : Should be "allwinner,sun4i-a10-crypto".
-- reg: Should contain the Security System register location and length.
-- interrupts: Should contain the IRQ line for the Security System.
-- clocks : List of clock specifiers, corresponding to ahb and ss.
-- clock-names : Name of the functional clock, should be
-	* "ahb" : AHB gating clock
-	* "mod" : SS controller clock
-
-Optional properties:
- - resets : phandle + reset specifier pair
- - reset-names : must contain "ahb"
-
-Example:
-	crypto: crypto-engine@1c15000 {
-		compatible = "allwinner,sun4i-a10-crypto";
-		reg = <0x01c15000 0x1000>;
-		interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&ahb_gates 5>, <&ss_clk>;
-		clock-names = "ahb", "mod";
-	};
-- 
2.21.0

