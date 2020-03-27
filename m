Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0FEC2D0ED
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 06:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ED4320717
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 06:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgC0GK4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 02:10:56 -0400
Received: from foss.arm.com ([217.140.110.172]:40798 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgC0GK4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 02:10:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6427D1045;
        Thu, 26 Mar 2020 23:10:55 -0700 (PDT)
Received: from ssg-dev-vb.arm.com (unknown [10.57.25.3])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACE303F71F;
        Thu, 26 Mar 2020 23:14:56 -0700 (PDT)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: [PATCH v7 1/3] dt-bindings: add device tree binding for Arm CryptoCell trng engine
Date:   Fri, 27 Mar 2020 09:10:21 +0300
Message-Id: <1585289423-18440-2-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Arm CryptoCell is a hardware security engine. This patch adds DT
bindings for its TRNG (True Random Number Generator) engine.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
---
 .../devicetree/bindings/rng/arm-cctrng.yaml        | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml

diff --git a/Documentation/devicetree/bindings/rng/arm-cctrng.yaml b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
new file mode 100644
index 0000000..ca6aad1
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/arm-cctrng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Arm TrustZone CryptoCell TRNG engine
+
+maintainers:
+  - Hadar Gat <hadar.gat@arm.com>
+
+description: |+
+  Arm TrustZone CryptoCell TRNG (True Random Number Generator) engine.
+
+properties:
+  compatible:
+    enum:
+      - arm,cryptocell-713-trng
+      - arm,cryptocell-703-trng
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+  arm,rosc-ratio:
+    description:
+      Arm TrustZone CryptoCell TRNG engine has 4 ring oscillators.
+      Sampling ratio values for these 4 ring oscillators. (from calibration)
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32-array
+      - items:
+          maxItems: 4
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - interrupts
+  - reg
+  - arm,rosc-ratio
+
+additionalProperties: false
+
+examples:
+  - |
+    arm_cctrng: rng@60000000 {
+        compatible = "arm,cryptocell-713-trng";
+        interrupts = <0 29 4>;
+        reg = <0x60000000 0x10000>;
+        arm,rosc-ratio = <5000 1000 500 0>;
+    };
-- 
2.7.4

