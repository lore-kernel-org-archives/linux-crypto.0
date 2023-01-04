Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B5EC3DA7D
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Jan 2023 01:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbjADBfe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 20:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238732AbjADBfN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 20:35:13 -0500
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17AF1789A
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 17:35:06 -0800 (PST)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 3041Oc2b076238;
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
Subject: [PATCH v5 4/4] dt-bindings: bus: add documentation for Aspeed AHBC
Date:   Wed, 4 Jan 2023 09:34:36 +0800
Message-ID: <20230104013436.203427-5-neal_liu@aspeedtech.com>
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
X-MAIL: twspam01.aspeedtech.com 3041Oc2b076238
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add device tree binding documentation for the Aspeed
Advanced High-Performance Bus (AHB) Controller.

Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/bus/aspeed,ast2600-ahbc.yaml     | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/aspeed,ast2600-ahbc.yaml

diff --git a/Documentation/devicetree/bindings/bus/aspeed,ast2600-ahbc.yaml b/Documentation/devicetree/bindings/bus/aspeed,ast2600-ahbc.yaml
new file mode 100644
index 000000000000..2894256c976d
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/aspeed,ast2600-ahbc.yaml
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/bus/aspeed,ast2600-ahbc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ASPEED Advanced High-Performance Bus Controller (AHBC)
+
+maintainers:
+  - Neal Liu <neal_liu@aspeedtech.com>
+  - Chia-Wei Wang <chiawei_wang@aspeedtech.com>
+
+description: |
+  Advanced High-performance Bus Controller (AHBC) supports plenty of mechanisms
+  including a priority arbiter, an address decoder and a data multiplexer
+  to control the overall operations of Advanced High-performance Bus (AHB).
+
+properties:
+  compatible:
+    enum:
+      - aspeed,ast2600-ahbc
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    ahbc@1e600000 {
+        compatible = "aspeed,ast2600-ahbc";
+        reg = <0x1e600000 0x100>;
+    };
-- 
2.25.1

