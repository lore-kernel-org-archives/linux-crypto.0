Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324E8C64E75
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 11:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E478B20DD4
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 11:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388143AbgKZL5f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 06:57:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:7383 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387979AbgKZL5f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 06:57:35 -0500
IronPort-SDR: aXxzvWBuvMMB8HszVPUfSZH2JKS26+vhP3IRepXdn/OQD9cgN+B/Bf/Crq78CxLjzSh88lPJ30
 PjoD2BMcLgkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="160048307"
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="160048307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 03:52:09 -0800
IronPort-SDR: A1rdn4mptNgb2ms/3ml6yti9bF3yh+2w+OyEM0u6ulsmPG0vtjYetEODCsXvyjBatTHq7tZYAK
 KeO8UAX1K5dw==
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="362781569"
Received: from smaciag-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.85.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 03:52:07 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: [PATCH 1/2] dt-bindings: Add Keem Bay OCS AES bindings
Date:   Thu, 26 Nov 2020 11:51:47 +0000
Message-Id: <20201126115148.68039-2-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126115148.68039-1-daniele.alessandrelli@linux.intel.com>
References: <20201126115148.68039-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Add device-tree bindings for Intel Keem Bay Offload and Crypto Subsystem
(OCS) AES crypto driver.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
---
 .../crypto/intel,keembay-ocs-aes.yaml         | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml

diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
new file mode 100644
index 000000000000..ee2c099981b2
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/intel,keembay-ocs-aes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Intel Keem Bay OCS AES Device Tree Bindings
+
+maintainers:
+  - Daniele Alessandrelli <daniele.alessandrelli@intel.com>
+
+description:
+  The Intel Keem Bay Offload and Crypto Subsystem (OCS) AES engine provides
+  hardware-accelerated AES/SM4 encryption/decryption.
+
+properties:
+  compatible:
+    const: intel,keembay-ocs-aes
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
+    crypto@30008000 {
+      compatible = "intel,keembay-ocs-aes";
+      reg = <0x30008000 0x1000>;
+      interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&scmi_clk 95>;
+    };
-- 
2.26.2

