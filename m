Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C94C433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C56D22CA0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgHEGcw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 02:32:52 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35786 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgHEGcv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 02:32:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C42C62010A4;
        Wed,  5 Aug 2020 08:32:48 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 17F872001B6;
        Wed,  5 Aug 2020 08:32:43 +0200 (CEST)
Received: from 10.192.242.69 (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id D45E54024E;
        Wed,  5 Aug 2020 08:32:35 +0200 (CEST)
From:   Anson Huang <Anson.Huang@nxp.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, horia.geanta@nxp.com, vz@mleia.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH] dt-bindings: rng: Convert i.MX to json-schema
Date:   Wed,  5 Aug 2020 14:28:04 +0800
Message-Id: <1596608884-13205-1-git-send-email-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the i.MX rng binding to DT schema format using json-schema.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 Documentation/devicetree/bindings/rng/imx-rng.txt  | 23 ----------
 Documentation/devicetree/bindings/rng/imx-rng.yaml | 50 ++++++++++++++++++++++
 2 files changed, 50 insertions(+), 23 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/imx-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/imx-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/imx-rng.txt b/Documentation/devicetree/bindings/rng/imx-rng.txt
deleted file mode 100644
index 659d4ef..0000000
--- a/Documentation/devicetree/bindings/rng/imx-rng.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-Freescale RNGA/RNGB/RNGC (Random Number Generator Versions A, B and C)
-
-Required properties:
-- compatible : should be one of
-               "fsl,imx21-rnga"
-               "fsl,imx31-rnga" (backward compatible with "fsl,imx21-rnga")
-               "fsl,imx25-rngb"
-               "fsl,imx6sl-rngb" (backward compatible with "fsl,imx25-rngb")
-               "fsl,imx6sll-rngb" (backward compatible with "fsl,imx25-rngb")
-               "fsl,imx6ull-rngb" (backward compatible with "fsl,imx25-rngb")
-               "fsl,imx35-rngc"
-- reg : offset and length of the register set of this block
-- interrupts : the interrupt number for the RNG block
-- clocks : the RNG clk source
-
-Example:
-
-rng@53fb0000 {
-	compatible = "fsl,imx25-rngb";
-	reg = <0x53fb0000 0x4000>;
-	interrupts = <22>;
-	clocks = <&trng_clk>;
-};
diff --git a/Documentation/devicetree/bindings/rng/imx-rng.yaml b/Documentation/devicetree/bindings/rng/imx-rng.yaml
new file mode 100644
index 0000000..cf5b8ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/imx-rng.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/imx-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale RNGA/RNGB/RNGC (Random Number Generator Versions A, B and C)
+
+maintainers:
+  - Vladimir Zapolskiy <vz@mleia.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: fsl,imx21-rnga
+      - const: fsl,imx25-rngb
+      - items:
+          - const: fsl,imx31-rnga
+          - const: fsl,imx21-rnga
+      - items:
+          - enum:
+            - fsl,imx6sl-rngb
+            - fsl,imx6sll-rngb
+            - fsl,imx6ull-rngb
+          - const: fsl,imx25-rngb
+      - const: fsl,imx35-rngc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+examples:
+  - |
+    rngb@53fb0000 {
+        compatible = "fsl,imx25-rngb";
+        reg = <0x53fb0000 0x4000>;
+        clocks = <&clks 109>;
+        interrupts = <22>;
+    };
-- 
2.7.4

