Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9F1C2BB9A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC39238EC
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgLQRYk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:24:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:47109 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgLQRYj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:24:39 -0500
IronPort-SDR: 3TY521B3o+xarBHs6J+k6DB24pUJiLzklGRPPVac6WL+edawXgSHWkoih4RweRIBrSYUqidZlZ
 Mdy/+BJBMP1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="260017916"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="260017916"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:41 -0800
IronPort-SDR: NJNLB2SZd9BxNICwHxqSRbBix9TigjxXeEZD2UKWehFTkn/mZqGIxaMSrErsMKgaDni0zn52gp
 fRNMZ2L1+kag==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="369930987"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:38 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH 5/6] dt-bindings: crypto: Add Keem Bay ECC bindings
Date:   Thu, 17 Dec 2020 17:21:00 +0000
Message-Id: <20201217172101.381772-6-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
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
index f5eafee83bc6..fa5bc7c4c9fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9070,6 +9070,13 @@ F:	drivers/crypto/keembay/keembay-ocs-aes-core.c
 F:	drivers/crypto/keembay/ocs-aes.c
 F:	drivers/crypto/keembay/ocs-aes.h
 
+INTEL KEEM BAY OCS ECC CRYPTO DRIVER
+M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
+M:	Prabhjot Khurana <prabhjot.khurana@intel.com>
+M:	Mark Gross <mgross@linux.intel.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
+
 INTEL MANAGEMENT ENGINE (mei)
 M:	Tomas Winkler <tomas.winkler@intel.com>
 L:	linux-kernel@vger.kernel.org
-- 
2.26.2

