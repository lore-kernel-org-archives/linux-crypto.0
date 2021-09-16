Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254A6C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 18:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 077476058D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 18:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbhIPSzr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 14:55:47 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44932 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344030AbhIPSzi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 14:55:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18GIruAR084558;
        Thu, 16 Sep 2021 13:53:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1631818436;
        bh=ofxg2rOoyTHRLO7cygaz8Om7ldfzCv8/JSm+cnOaM94=;
        h=From:To:CC:Subject:Date;
        b=LE5/W7o1G+2F8rb9BnFfpVShf9T2XZvugeR7TwgAOldluQwHIEaTODJsGVWeymYvF
         5I2BTmaivJsgcNdGa7hoOxilmZVT60pkqI+sJsefNVWmKW8FPciuhtZPdVJ5SdJHJo
         wLEu9rY1t4EGKYdY5zDRjdLIb/+DMFa41Qt3A2HI=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18GIrteN098340
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Sep 2021 13:53:56 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 16
 Sep 2021 13:53:55 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 16 Sep 2021 13:53:55 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18GIrrJa097516;
        Thu, 16 Sep 2021 13:53:54 -0500
From:   Jayesh Choudhary <j-choudhary@ti.com>
To:     <devicetree@vger.kernel.org>
CC:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <j-choudhary@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] dt-bindings: rng: convert OMAP and Inside-Secure HWRNG to yaml schema
Date:   Fri, 17 Sep 2021 00:23:52 +0530
Message-ID: <20210916185352.7919-1-j-choudhary@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Converts the RNG bindings for OMAP SoCs and Inside-Secure
HWRNG modules to YAML schema.

Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
---
 .../devicetree/bindings/rng/omap_rng.txt      | 38 --------
 .../devicetree/bindings/rng/omap_rng.yaml     | 94 +++++++++++++++++++
 2 files changed, 94 insertions(+), 38 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/omap_rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/omap_rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
deleted file mode 100644
index ea434ce50f36..000000000000
--- a/Documentation/devicetree/bindings/rng/omap_rng.txt
+++ /dev/null
@@ -1,38 +0,0 @@
-OMAP SoC and Inside-Secure HWRNG Module
-
-Required properties:
-
-- compatible : Should contain entries for this and backward compatible
-  RNG versions:
-  - "ti,omap2-rng" for OMAP2.
-  - "ti,omap4-rng" for OMAP4, OMAP5 and AM33XX.
-  - "inside-secure,safexcel-eip76" for SoCs with EIP76 IP block
-  Note that these two versions are incompatible.
-- ti,hwmods: Name of the hwmod associated with the RNG module
-- reg : Offset and length of the register set for the module
-- interrupts : the interrupt number for the RNG module.
-		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
-- clocks: the trng clock source. Only mandatory for the
-  "inside-secure,safexcel-eip76" compatible, the second clock is
-  needed for the Armada 7K/8K SoCs
-- clock-names: mandatory if there is a second clock, in this case the
-  name must be "core" for the first clock and "reg" for the second
-  one
-
-
-Example:
-/* AM335x */
-rng: rng@48310000 {
-	compatible = "ti,omap4-rng";
-	ti,hwmods = "rng";
-	reg = <0x48310000 0x2000>;
-	interrupts = <111>;
-};
-
-/* SafeXcel IP-76 */
-trng: rng@f2760000 {
-	compatible = "inside-secure,safexcel-eip76";
-	reg = <0xf2760000 0x7d>;
-	interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
-	clocks = <&cpm_syscon0 1 25>;
-};
diff --git a/Documentation/devicetree/bindings/rng/omap_rng.yaml b/Documentation/devicetree/bindings/rng/omap_rng.yaml
new file mode 100644
index 000000000000..86bbc2c53e7d
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/omap_rng.yaml
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/omap_rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: OMAP SoC and Inside-Secure HWRNG Module
+
+maintainers:
+  - Jayesh Choudhary <j-choudhary@ti.com>
+
+properties:
+  compatible:
+    enum:
+      - ti,omap2-rng
+      - ti,omap4-rng
+      - inside-secure,safexcel-eip76
+
+  ti,hwmods:
+    const: rng
+    deprecated: true
+    description: Name of the hwmod associated with the RNG module
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: EIP150 gatable clock
+      - description: Main gatable clock
+
+  clock-names:
+    oneOf:
+      - items:
+          - const: core
+          - const: reg
+      - const: core
+
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - ti,omap4-rng
+              - inside-secure,safexcel-eip76
+
+    then:
+      required:
+        - interrupts
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - inside-secure,safexcel-eip76
+
+    then:
+      required:
+        - clocks
+
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    /* AM335x */
+    rng: rng@48310000 {
+            compatible = "ti,omap4-rng";
+            ti,hwmods = "rng";
+            reg = <0x48310000 0x2000>;
+            interrupts = <111>;
+    };
+  - |
+    /* SafeXcel IP-76 */
+    trng: rng@f2760000 {
+            compatible = "inside-secure,safexcel-eip76";
+            reg = <0xf2760000 0x7d>;
+            interrupts = <0 59 4>;
+            clocks = <&cpm_syscon0 1 25>;
+    };
+
+...
-- 
2.17.1

