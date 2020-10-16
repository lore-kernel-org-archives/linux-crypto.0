Return-Path: <SRS0=63hd=DX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17441C43467
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C445B21775
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390960AbgJPR2b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Oct 2020 13:28:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:5405 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390536AbgJPR2b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Oct 2020 13:28:31 -0400
IronPort-SDR: pxZsePdNXyprMyUqWC1Y0OBJPUlYlX+gAhg1PnsHnyxKLzROWdm4CMQqkXsGJu1t+CIbCgRav7
 i88CgtbwwZOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="153570050"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="153570050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:28:25 -0700
IronPort-SDR: Zt4X295OqxbfRy/wJEjLEYjVR9QhyB3ersgyD+h0zauMIBlCOmZOXc71oEr8PPY10xf3ERCFm8
 +UbzRIV6ImzQ==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="464750846"
Received: from apurdea-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.84.178])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:28:23 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
Date:   Fri, 16 Oct 2020 18:27:57 +0100
Message-Id: <20201016172759.1260407-2-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
References: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
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
---
 .../crypto/intel,keembay-ocs-hcu.yaml         | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml

diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
new file mode 100644
index 000000000000..dd4b82ee872b
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
@@ -0,0 +1,52 @@
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
+  - Daniele Alessandrelli <deniele.alessandrelli@intel.com>
+
+description: |
+  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash Control Unit (HCU)
+  crypto driver enables use of the hardware accelerated hashing module embedded
+  in the Intel Movidius SoC code name Keem Bay, via the kernel crypto API.
+
+properties:
+  compatible:
+    const: intel,keembay-ocs-hcu
+
+  reg:
+    items:
+      - description: The OCS HCU base register address
+
+  interrupts:
+    items:
+      - description: OCS HCU interrupt
+
+  clocks:
+    items:
+      - description: OCS clock
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
+    hcu@3000b000 {
+      compatible = "intel,keembay-ocs-hcu";
+      reg = <0x3000b000 0x1000>;
+      interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&scmi_clk 94>;
+    };
+
+...
-- 
2.26.2

