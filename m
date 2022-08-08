Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA007C25B08
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Aug 2022 19:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244287AbiHHTNx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Aug 2022 15:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244270AbiHHTNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Aug 2022 15:13:52 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408AC17068;
        Mon,  8 Aug 2022 12:13:51 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 278JDb08049802;
        Mon, 8 Aug 2022 14:13:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1659986017;
        bh=r2vGi/35L8hnWartK7W5Vb0wEswoy+DdforiFp5cATI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vGD3cBv7KATi0SNe7MTYBKupJ2QHSOlEexWReTdZCAjmfXCpbC/5HknpExwakfcZP
         bBkGZjlPX8fnpDK/CoWoMT7Z/zAXwrPpLl9xAXBtI9tNix6Lrtx4MstPJoEqAmkBD+
         lkhEM+cU26Gi8EgbtNLiar9u7iCeqy+9kQOFSXX4=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 278JDbYv084007
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 8 Aug 2022 14:13:37 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 8
 Aug 2022 14:13:37 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 8 Aug 2022 14:13:37 -0500
Received: from uda0500628.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 278JDaYP054740;
        Mon, 8 Aug 2022 14:13:37 -0500
From:   Daniel Parks <danielrparks@ti.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 2/6] dt-bindings: crypto: add binding for eip29t2 public key accelerator (PKA)
Date:   Mon, 8 Aug 2022 14:12:51 -0500
Message-ID: <856cbf3a002b5d400bbbdb7aa914ab5b8681a96e.1659985696.git.danielrparks@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1659985696.git.danielrparks@ti.com>
References: <cover.1659985696.git.danielrparks@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PKA is a mmio-only asymmetric crypto accelerator available on
certain K3 devices.

Signed-off-by: Daniel Parks <danielrparks@ti.com>
---
 .../inside-secure,safexcel-eip29t2.yaml       | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml
new file mode 100644
index 000000000000..b1e195a108cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only or BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip29t2.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: K3 SoC SA2UL PKA crypto module
+
+maintainers:
+  - Daniel Parks <danielrparks@ti.com>
+
+description: |
+  Asymmetric crypto accelerator
+
+properties:
+  compatible:
+    const: inside-secure,safexcel-eip29t2
+
+  reg:
+    items:
+      - description: control registers
+      - description: mapped memory
+
+  interrupts:
+    items:
+      - description: PKA interrupt
+
+  clocks:
+    items:
+      - description: PKA in clock
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    pka: pka@40920000 {
+      compatible = "inside-secure,safexcel-eip29t2";
+      reg = <0x00 0x40920000 0x00 0x2000>,
+            <0x00 0x40924000 0x00 0x8000>;
+      interrupts = <GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&k3_clks 133 0>;
+    };
-- 
2.17.1

