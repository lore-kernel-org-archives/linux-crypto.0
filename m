Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAC1C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 12:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8C2206A5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 12:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="H9aI1ieI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgENMuX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 08:50:23 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56614 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENMuX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 08:50:23 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04ECo80g126913;
        Thu, 14 May 2020 07:50:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589460608;
        bh=Fkq9j3sMdZa+zOtHYp3Cdxd3KNG03i48ARRIFHUTQPw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=H9aI1ieIPQj0AMIsAxyQ6840x9W+fe6Rawe0b4geeqCoETBUwsolpMszQgv3qwUnx
         0luaurEBckMB/uMk7Y5OhLKu2ESmFoGNKjotbvpG0LuS+RmJeUEy/JbRWlWDu5IgKW
         fCwAPXflnzFsEHQYyytnrF8WhYfXjP0gSk6i0S8c=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04ECo8j6043105
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 07:50:08 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 07:50:07 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 07:50:07 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04ECo5o7108688;
        Thu, 14 May 2020 07:50:06 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     Keerthy <j-keerthy@ti.com>, Rob Herring <robh@kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCHv3 1/7] dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation
Date:   Thu, 14 May 2020 15:50:05 +0300
Message-ID: <20200514125005.23641-1-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511215343.GA10123@bogus>
References: <20200511215343.GA10123@bogus>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

The Security Accelerator Ultra Lite (SA2UL) subsystem provides hardware
cryptographic acceleration for the following use cases:

* Encryption and authentication for secure boot
* Encryption and authentication of content in applications
  requiring DRM (digital rights management) and
  content/asset protection

SA2UL provides support for number of different cryptographic algorithms
including SHA1, SHA256, SHA512, AES, 3DES, and various combinations of
the previous for AEAD use.

Cc: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Keerthy <j-keerthy@ti.com>
[t-kristo@ti.com: converted documentation to yaml]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
v3:
  - fixed a typo in rng child node regex

 .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml

diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
new file mode 100644
index 000000000000..27bb3a7e2b87
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: (GPL-2.0-only or BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/ti,sa2ul.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: K3 SoC SA2UL crypto module
+
+maintainers:
+  - Tero Kristo <t-kristo@ti.com>
+
+properties:
+  compatible:
+    enum:
+      - ti,j721e-sa2ul
+      - ti,am654-sa2ul
+
+  reg:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  dmas:
+    items:
+      - description: TX DMA Channel
+      - description: RX DMA Channel #1
+      - description: RX DMA Channel #2
+
+  dma-names:
+    items:
+      - const: tx
+      - const: rx1
+      - const: rx2
+
+  dma-coherent: true
+
+  "#address-cells":
+    const: 2
+
+  "#size-cells":
+    const: 2
+
+  ranges:
+    description:
+      Address translation for the possible RNG child node for SA2UL
+
+patternProperties:
+  "^rng@[a-f0-9]+$":
+    type: object
+    description:
+      Child RNG node for SA2UL
+
+required:
+  - compatible
+  - reg
+  - power-domains
+  - dmas
+  - dma-names
+  - dma-coherent
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/soc/ti,sci_pm_domain.h>
+
+    main_crypto: crypto@4e00000 {
+        compatible = "ti,j721-sa2ul";
+        reg = <0x0 0x4e00000 0x0 0x1200>;
+        power-domains = <&k3_pds 264 TI_SCI_PD_EXCLUSIVE>;
+        dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
+               <&main_udmap 0x4001>;
+        dma-names = "tx", "rx1", "rx2";
+        dma-coherent;
+    };
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
