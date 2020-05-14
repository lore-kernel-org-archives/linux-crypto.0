Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424DFC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 13:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1760420728
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 13:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="JSAcLnGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgENNUO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 09:20:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59872 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgENNUO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 09:20:14 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EDJoRa003750;
        Thu, 14 May 2020 08:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589462390;
        bh=dUj5luPHu1YhkdbBoiYQztRz+qbnT9MuBcFThH036h8=;
        h=From:To:CC:Subject:Date;
        b=JSAcLnGN6B3gF7j/k2fuXUpxgxjlvjFGMeJSnlDxUew7ebr4Zcrz9NauxFnlsiHG1
         C/S9d/j22oLiFOXaqu8wnupqCipMOegC5Ykae59u4ZKQRbHQAhA3v9TuHVNqi2MEEj
         BbPKQ9d52i16k+vNCLjKl0dgoP9gOgfFdfibr9Ok=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04EDJo1t045219
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 08:19:50 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 08:19:50 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 08:19:50 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EDJmDV032816;
        Thu, 14 May 2020 08:19:48 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <mpm@selenic.com>
Subject: [PATCH 1/1] dt-bindings: rng: Convert OMAP RNG to schema
Date:   Thu, 14 May 2020 16:19:47 +0300
Message-ID: <20200514131947.28094-1-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert TI OMAP Random number generator bindings to DT schema.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 .../devicetree/bindings/rng/omap_rng.txt      | 38 ---------
 .../devicetree/bindings/rng/ti,omap-rng.yaml  | 77 +++++++++++++++++++
 2 files changed, 77 insertions(+), 38 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/omap_rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/ti,omap-rng.yaml

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
diff --git a/Documentation/devicetree/bindings/rng/ti,omap-rng.yaml b/Documentation/devicetree/bindings/rng/ti,omap-rng.yaml
new file mode 100644
index 000000000000..b37d73295e9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ti,omap-rng.yaml
@@ -0,0 +1,77 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/ti,omap-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: OMAP SoC and Inside-Secure HWRNG Module
+
+maintainers:
+  - Tero Kristo <t-kristo@ti.com>
+
+properties:
+  compatible:
+    enum:
+      - ti,omap2-rng
+      - ti,omap4-rng
+      - inside-secure,safexcel-eip76
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    description:
+      The TRNG clock source. Only mandatory for the
+      "inside-secure,safexcel-eip76" compatible, the second clock is needed
+      for the Armada 7K/8K SoCs
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: core
+      - const: reg
+
+  ti,hwmods:
+    description: TI hwmod name
+    deprecated: true
+    $ref: /schemas/types.yaml#/definitions/string-array
+    items:
+      const: rng
+
+required:
+  - compatible
+  - reg
+
+if:
+  properties:
+    compatible:
+      enum:
+        - inside-secure,safexcel-eip76
+then:
+  required:
+    - clocks
+
+examples:
+  - |
+    /* AM335x */
+    rng: rng@48310000 {
+      compatible = "ti,omap4-rng";
+      ti,hwmods = "rng";
+      reg = <0x48310000 0x2000>;
+      interrupts = <111>;
+    };
+
+  - |+
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    /* SafeXcel IP-76 */
+    trng: rng@f2760000 {
+      compatible = "inside-secure,safexcel-eip76";
+      reg = <0xf2760000 0x7d>;
+      interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&cpm_syscon0 1 25>;
+    };
+...
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
