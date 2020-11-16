Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5626AC55ABD
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 18:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21607223FB
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 18:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgKPS7K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:59:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:4394 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgKPS7K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 13:59:10 -0500
IronPort-SDR: PFu/8Yj5iIKMxG7dsJu4QOlgOaUdvIdtiSAihVPwY/Xxcc0WXyWym38AGvWuPlh2QOxiQmFWkU
 yuXMhgGxsQIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="255508833"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="255508833"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:59:09 -0800
IronPort-SDR: FC6gsSVm5bpEvhlGsaFaEKZXNq1FDzOVcKu+vhbR41gnsVuVTw8jj4bG1vAK58zTs1fGiMADZ0
 BuxIwXPUw6Bw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="543709978"
Received: from abarnicl-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.19.98])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:59:07 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v3 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
Date:   Mon, 16 Nov 2020 18:58:44 +0000
Message-Id: <20201116185846.773464-2-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
References: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
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

