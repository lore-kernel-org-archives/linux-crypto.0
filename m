Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B95C2BBCD
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D0D523382
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgLPLsy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 06:48:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:28004 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgLPLsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 06:48:53 -0500
IronPort-SDR: jAl/macTD0yEQpFlaLg8gBIVMAnC6fCsP6Q2R+WxfOXa6n1AIVhcu+DgizGTlzXnWB9CMPn2Qa
 tABDjPZJYs7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="154856597"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="154856597"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:08 -0800
IronPort-SDR: yGp4+XNQxX54tsKh85k5jsNN3pK/0LeqQDR0E0fOdYk9cZf6Xx/LQ9s626LgwzeSJthcnoHOHE
 80KP9FpMFh/w==
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="368985145"
Received: from johnlyon-mobl.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.90.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:05 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v4 1/5] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
Date:   Wed, 16 Dec 2020 11:46:35 +0000
Message-Id: <20201216114639.3451399-2-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
References: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Declan Murphy <declan.murphy@intel.com>

Add device-tree bindings for the Intel Keem Bay Offload Crypto Subsystem
(OCS) Hashing Control Unit (HCU) crypto driver.

Signed-off-by: Declan Murphy <declan.murphy@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../crypto/intel,keembay-ocs-hcu.yaml         | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml

diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
new file mode 100644
index 000000000000..acb92706d280
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/intel,keembay-ocs-hcu.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Intel Keem Bay OCS HCU Device Tree Bindings
+
+maintainers:
+  - Declan Murphy <declan.murphy@intel.com>
+  - Daniele Alessandrelli <daniele.alessandrelli@intel.com>
+
+description:
+  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash Control Unit (HCU)
+  provides hardware-accelerated hashing and HMAC.
+
+properties:
+  compatible:
+    const: intel,keembay-ocs-hcu
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
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    crypto@3000b000 {
+      compatible = "intel,keembay-ocs-hcu";
+      reg = <0x3000b000 0x1000>;
+      interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&scmi_clk 94>;
+    };
-- 
2.26.2

