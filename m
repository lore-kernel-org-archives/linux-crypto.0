Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D2AC433E3
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 02:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E076122CAE
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 02:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgHECsQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 22:48:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:53242 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgHECsP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 22:48:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AE71D1A1487;
        Wed,  5 Aug 2020 04:48:13 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E2AE1A04CF;
        Wed,  5 Aug 2020 04:48:08 +0200 (CEST)
Received: from 10.192.242.69 (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 99ABF402E5;
        Wed,  5 Aug 2020 04:48:00 +0200 (CEST)
From:   Anson Huang <Anson.Huang@nxp.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, shawnguo@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, festevam@gmail.com, marex@denx.de,
        s.trumtrar@pengutronix.de, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH 2/3] dt-bindings: crypto: Convert i.MX SCC to json-schema
Date:   Wed,  5 Aug 2020 10:43:29 +0800
Message-Id: <1596595410-26921-2-git-send-email-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596595410-26921-1-git-send-email-Anson.Huang@nxp.com>
References: <1596595410-26921-1-git-send-email-Anson.Huang@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the i.MX SCC binding to DT schema format using json-schema.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 .../devicetree/bindings/crypto/fsl-imx-scc.txt     | 21 ---------
 .../devicetree/bindings/crypto/fsl-imx-scc.yaml    | 52 ++++++++++++++++++++++
 2 files changed, 52 insertions(+), 21 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
deleted file mode 100644
index 7aad448..0000000
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-Freescale Security Controller (SCC)
-
-Required properties:
-- compatible : Should be "fsl,imx25-scc".
-- reg : Should contain register location and length.
-- interrupts : Should contain interrupt numbers for SCM IRQ and SMN IRQ.
-- interrupt-names : Should specify the names "scm" and "smn" for the
-		    SCM IRQ and SMN IRQ.
-- clocks: Should contain the clock driving the SCC core.
-- clock-names: Should be set to "ipg".
-
-Example:
-
-	scc: crypto@53fac000 {
-		compatible = "fsl,imx25-scc";
-		reg = <0x53fac000 0x4000>;
-		clocks = <&clks 111>;
-		clock-names = "ipg";
-		interrupts = <49>, <50>;
-		interrupt-names = "scm", "smn";
-	};
diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.yaml
new file mode 100644
index 0000000..b259192
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.yaml
@@ -0,0 +1,52 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/fsl-imx-scc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale Security Controller (SCC)
+
+maintainers:
+  - Steffen Trumtrar <s.trumtrar@pengutronix.de>
+
+properties:
+  compatible:
+    const: fsl,imx25-scc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: SCC SCM interrupt
+      - description: SCC SMN interrupt
+
+  interrupt-names:
+    items:
+      - const: scm
+      - const: smn
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: ipg
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    crypto@53fac000 {
+        compatible = "fsl,imx25-scc";
+        reg = <0x53fac000 0x4000>;
+        clocks = <&clks 111>;
+        clock-names = "ipg";
+        interrupts = <49>, <50>;
+        interrupt-names = "scm", "smn";
+    };
-- 
2.7.4

