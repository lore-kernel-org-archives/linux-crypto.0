Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F82FC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 02:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5141122CB2
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 02:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgHECsP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 22:48:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:53210 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgHECsO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 22:48:14 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6335B1A04E6;
        Wed,  5 Aug 2020 04:48:12 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B49B91A1487;
        Wed,  5 Aug 2020 04:48:06 +0200 (CEST)
Received: from 10.192.242.69 (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4FDAD402E1;
        Wed,  5 Aug 2020 04:47:59 +0200 (CEST)
From:   Anson Huang <Anson.Huang@nxp.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, shawnguo@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, festevam@gmail.com, marex@denx.de,
        s.trumtrar@pengutronix.de, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH 1/3] dt-bindings: crypto: Convert MXS DCP to json-schema
Date:   Wed,  5 Aug 2020 10:43:28 +0800
Message-Id: <1596595410-26921-1-git-send-email-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the MXS DCP binding to DT schema format using json-schema.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 .../devicetree/bindings/crypto/fsl-dcp.txt         | 18 --------
 .../devicetree/bindings/crypto/fsl-dcp.yaml        | 49 ++++++++++++++++++++++
 2 files changed, 49 insertions(+), 18 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-dcp.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-dcp.yaml

diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt b/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
deleted file mode 100644
index 513499f..0000000
--- a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-Freescale DCP (Data Co-Processor) found on i.MX23/i.MX28 .
-
-Required properties:
-- compatible : Should be "fsl,<soc>-dcp"
-- reg : Should contain MXS DCP registers location and length
-- interrupts : Should contain MXS DCP interrupt numbers, VMI IRQ and DCP IRQ
-               must be supplied, optionally Secure IRQ can be present, but
-	       is currently not implemented and not used.
-- clocks : Clock reference (only required on some SOCs: 6ull and 6sll).
-- clock-names : Must be "dcp".
-
-Example:
-
-dcp: crypto@80028000 {
-	compatible = "fsl,imx28-dcp", "fsl,imx23-dcp";
-	reg = <0x80028000 0x2000>;
-	interrupts = <52 53>;
-};
diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml b/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
new file mode 100644
index 0000000..1ed86cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/fsl-dcp.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale DCP (Data Co-Processor) found on i.MX23/i.MX28
+
+maintainers:
+  - Marek Vasut <marex@denx.de>
+
+properties:
+  compatible:
+    enum:
+      - fsl,imx23-dcp
+      - fsl,imx28-dcp
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    description: Should contain MXS DCP interrupt numbers, VMI IRQ and DCP IRQ
+      must be supplied, optionally Secure IRQ can be present, but is currently
+      not implemented and not used.
+    items:
+      - description: MXS DCP VMI interrupt
+      - description: MXS DCP DCP interrupt
+      - description: MXS DCP secure interrupt
+    minItems: 2
+    maxItems: 3
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: dcp
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+examples:
+  - |
+    crypto@80028000 {
+        compatible = "fsl,imx23-dcp";
+        reg = <0x80028000 0x2000>;
+        interrupts = <53>, <54>;
+    };
-- 
2.7.4

