Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29B5C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5B260F8F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhJTKiL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:38:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:7393 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhJTKiL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:38:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228622906"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="228622906"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:57 -0700
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="527005579"
Received: from dhicke3x-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.29.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:54 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 4/5] dt-bindings: crypto: Add Keem Bay ECC bindings
Date:   Wed, 20 Oct 2021 11:35:37 +0100
Message-Id: <20211020103538.360614-5-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
References: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Prabhjot Khurana <prabhjot.khurana@intel.com>

Add Keem Bay Offload and Crypto Subsystem (OCS) Elliptic Curve
Cryptography (ECC) device tree bindings.

Signed-off-by: Prabhjot Khurana <prabhjot.khurana@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 .../crypto/intel,keembay-ocs-ecc.yaml         | 47 +++++++++++++++++++
 MAINTAINERS                                   |  7 +++
 2 files changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
new file mode 100644
index 000000000000..a3c16451b1ad
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/intel,keembay-ocs-ecc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Intel Keem Bay OCS ECC Device Tree Bindings
+
+maintainers:
+  - Daniele Alessandrelli <daniele.alessandrelli@intel.com>
+  - Prabhjot Khurana <prabhjot.khurana@intel.com>
+
+description:
+  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Elliptic Curve
+  Cryptography (ECC) device provides hardware acceleration for elliptic curve
+  cryptography using the NIST P-256 and NIST P-384 elliptic curves.
+
+properties:
+  compatible:
+    const: intel,keembay-ocs-ecc
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
+    crypto@30001000 {
+      compatible = "intel,keembay-ocs-ecc";
+      reg = <0x30001000 0x1000>;
+      interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&scmi_clk 95>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index eeb4c70b3d5b..c588801a7b12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9512,6 +9512,13 @@ F:	drivers/crypto/keembay/keembay-ocs-aes-core.c
 F:	drivers/crypto/keembay/ocs-aes.c
 F:	drivers/crypto/keembay/ocs-aes.h
 
+INTEL KEEM BAY OCS ECC CRYPTO DRIVER
+M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
+M:	Prabhjot Khurana <prabhjot.khurana@intel.com>
+M:	Mark Gross <mgross@linux.intel.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
+
 INTEL KEEM BAY OCS HCU CRYPTO DRIVER
 M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
 M:	Declan Murphy <declan.murphy@intel.com>
-- 
2.31.1

