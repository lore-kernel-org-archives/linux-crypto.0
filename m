Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1AFC4708E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Jan 2023 01:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjADBfd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 20:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238672AbjADBfD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 20:35:03 -0500
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB494DAA
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 17:35:01 -0800 (PST)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 3041Oc2a076238;
        Wed, 4 Jan 2023 09:24:39 +0800 (GMT-8)
        (envelope-from neal_liu@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.10) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Jan
 2023 09:34:42 +0800
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        "Andrew Jeffery" <andrew@aj.id.au>,
        Neal Liu <neal_liu@aspeedtech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Chia-Wei Wang <chiawei_wang@aspeedtech.com>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH v5 3/4] dt-bindings: crypto: add documentation for Aspeed ACRY
Date:   Wed, 4 Jan 2023 09:34:35 +0800
Message-ID: <20230104013436.203427-4-neal_liu@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230104013436.203427-1-neal_liu@aspeedtech.com>
References: <20230104013436.203427-1-neal_liu@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.10.10]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 3041Oc2a076238
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add device tree binding documentation for the Aspeed
ECDSA/RSA ACRY Engines Controller.

Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/crypto/aspeed,ast2600-acry.yaml  | 49 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 2 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/aspeed,ast2600-acry.yaml

diff --git a/Documentation/devicetree/bindings/crypto/aspeed,ast2600-acry.yaml b/Documentation/devicetree/bindings/crypto/aspeed,ast2600-acry.yaml
new file mode 100644
index 000000000000..b18f178aac06
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/aspeed,ast2600-acry.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/aspeed,ast2600-acry.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ASPEED ACRY ECDSA/RSA Hardware Accelerator Engines
+
+maintainers:
+  - Neal Liu <neal_liu@aspeedtech.com>
+
+description:
+  The ACRY ECDSA/RSA engines is designed to accelerate the throughput
+  of ECDSA/RSA signature and verification. Basically, ACRY can be
+  divided into two independent engines - ECC Engine and RSA Engine.
+
+properties:
+  compatible:
+    enum:
+      - aspeed,ast2600-acry
+
+  reg:
+    items:
+      - description: acry base address & size
+      - description: acry sram base address & size
+
+  clocks:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/ast2600-clock.h>
+    acry: crypto@1e6fa000 {
+        compatible = "aspeed,ast2600-acry";
+        reg = <0x1e6fa000 0x400>, <0x1e710000 0x1800>;
+        interrupts = <160>;
+        clocks = <&syscon ASPEED_CLK_GATE_RSACLK>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 164f67e59e5f..e6157d18d804 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3214,7 +3214,7 @@ ASPEED CRYPTO DRIVER
 M:	Neal Liu <neal_liu@aspeedtech.com>
 L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
 S:	Maintained
-F:	Documentation/devicetree/bindings/crypto/aspeed,ast2500-hace.yaml
+F:	Documentation/devicetree/bindings/crypto/aspeed,*
 F:	drivers/crypto/aspeed/
 
 ASUS NOTEBOOKS AND EEEPC ACPI/WMI EXTRAS DRIVERS
-- 
2.25.1

