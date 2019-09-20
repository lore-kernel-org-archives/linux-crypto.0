Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FC8C3A5A2
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 16:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21D8208C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568997409;
	bh=lIE4jV01uzsB+QRyAJS7o47UZFL6GYNBSj+eWiYGAFI=;
	h=From:To:Subject:Date:List-ID:From;
	b=JWKOl2xbdVCHFUSv9BGqBh+KLHGbbhHAc6kpTIfn1LhpilGmt6Iz8yeZ7Mi3dcbYq
	 qxAOf1FKc83PL29t8K/67Yi9dOKJImSGj072c4H0G28ukPpGTyKOSE3hDPPG8Fj/w0
	 2uXX87HoZ92Rm9d1O9cvbjg96VtR1j2YWpNd337Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfITQgo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 12:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfITQgo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 12:36:44 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EFA420717;
        Fri, 20 Sep 2019 16:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568997403;
        bh=lIE4jV01uzsB+QRyAJS7o47UZFL6GYNBSj+eWiYGAFI=;
        h=From:To:Subject:Date:From;
        b=FRBD/clstpILo/t2RsJbrd5nAWmxfF7k1QzAfuNksHIxCuUbX3VbMclnmd1Ga6GGy
         BlyOihuXoajb7Rzbh/qR0gJ5CsqKvcyCQYJukGGwloR5jrTh+twpsq3d23woB/ebce
         dKDSCb39v3/pLRtu9ld0dhUO8/9Sk2bvg+/9lQsU=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2] dt-bindings: crypto: samsung: Convert SSS and SlimSSS bindings to json-schema
Date:   Fri, 20 Sep 2019 18:36:35 +0200
Message-Id: <20190920163635.9186-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert Samsung Exynos Security SubSystem (SSS) and SlimSSS hardware
crypto accelerator bindings to DT schema format using json-schema.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Rebased on linux-next due to conflicting change in MAINTAINERS file
coming through arm-soc tree.

Changes since v1:
1. Add additionalProperties:false
---
 .../bindings/crypto/samsung-slimsss.txt       | 19 ------
 .../bindings/crypto/samsung-slimsss.yaml      | 47 +++++++++++++++
 .../bindings/crypto/samsung-sss.txt           | 32 ----------
 .../bindings/crypto/samsung-sss.yaml          | 58 +++++++++++++++++++
 MAINTAINERS                                   |  4 +-
 5 files changed, 107 insertions(+), 53 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.yaml

diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.txt b/Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
deleted file mode 100644
index 7ec9a5a7727a..000000000000
--- a/Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
+++ /dev/null
@@ -1,19 +0,0 @@
-Samsung SoC SlimSSS (Slim Security SubSystem) module
-
-The SlimSSS module in Exynos5433 SoC supports the following:
--- Feeder (FeedCtrl)
--- Advanced Encryption Standard (AES) with ECB,CBC,CTR,XTS and (CBC/XTS)/CTS
--- SHA-1/SHA-256 and (SHA-1/SHA-256)/HMAC
-
-Required properties:
-
-- compatible : Should contain entry for slimSSS version:
-  - "samsung,exynos5433-slim-sss" for Exynos5433 SoC.
-- reg : Offset and length of the register set for the module
-- interrupts : interrupt specifiers of SlimSSS module interrupts (one feed
-		control interrupt).
-
-- clocks : list of clock phandle and specifier pairs for all clocks listed in
-		clock-names property.
-- clock-names : list of device clock input names; should contain "pclk" and
-		"aclk" for slim-sss in Exynos5433.
diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
new file mode 100644
index 000000000000..04fe5dfa794a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/samsung-slimsss.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung Exynos SoC SlimSSS (Slim Security SubSystem) module
+
+maintainers:
+  - Krzysztof Kozlowski <krzk@kernel.org>
+  - Kamil Konieczny <k.konieczny@partner.samsung.com>
+
+description: |+
+  The SlimSSS module in Exynos5433 SoC supports the following:
+  -- Feeder (FeedCtrl)
+  -- Advanced Encryption Standard (AES) with ECB,CBC,CTR,XTS and (CBC/XTS)/CTS
+  -- SHA-1/SHA-256 and (SHA-1/SHA-256)/HMAC
+
+properties:
+  compatible:
+    items:
+      - const: samsung,exynos5433-slim-ss
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    minItems: 2
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: pclk
+      - const: aclk
+
+  interrupts:
+    description: One feed control interrupt.
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clock-names
+  - clocks
+  - interrupts
+
+additionalProperties: false
diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
deleted file mode 100644
index 7a5ca56683cc..000000000000
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ /dev/null
@@ -1,32 +0,0 @@
-Samsung SoC SSS (Security SubSystem) module
-
-The SSS module in S5PV210 SoC supports the following:
--- Feeder (FeedCtrl)
--- Advanced Encryption Standard (AES)
--- Data Encryption Standard (DES)/3DES
--- Public Key Accelerator (PKA)
--- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
--- PRNG: Pseudo Random Number Generator
-
-The SSS module in Exynos4 (Exynos4210) and
-Exynos5 (Exynos5420 and Exynos5250) SoCs
-supports the following also:
--- ARCFOUR (ARC4)
--- True Random Number Generator (TRNG)
--- Secure Key Manager
-
-Required properties:
-
-- compatible : Should contain entries for this and backward compatible
-  SSS versions:
-  - "samsung,s5pv210-secss" for S5PV210 SoC.
-  - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
-		Exynos5260 and Exynos5420 SoCs.
-- reg : Offset and length of the register set for the module
-- interrupts : interrupt specifiers of SSS module interrupts (one feed
-		control interrupt).
-
-- clocks : list of clock phandle and specifier pairs for all clocks  listed in
-		clock-names property.
-- clock-names : list of device clock input names; should contain one entry
-		"secss".
diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.yaml b/Documentation/devicetree/bindings/crypto/samsung-sss.yaml
new file mode 100644
index 000000000000..cf1c47a81d7f
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/samsung-sss.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung Exynos SoC SSS (Security SubSystem) module
+
+maintainers:
+  - Krzysztof Kozlowski <krzk@kernel.org>
+  - Kamil Konieczny <k.konieczny@partner.samsung.com>
+
+description: |+
+  The SSS module in S5PV210 SoC supports the following:
+  -- Feeder (FeedCtrl)
+  -- Advanced Encryption Standard (AES)
+  -- Data Encryption Standard (DES)/3DES
+  -- Public Key Accelerator (PKA)
+  -- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
+  -- PRNG: Pseudo Random Number Generator
+
+  The SSS module in Exynos4 (Exynos4210) and Exynos5 (Exynos5420 and Exynos5250)
+  SoCs supports the following also:
+  -- ARCFOUR (ARC4)
+  -- True Random Number Generator (TRNG)
+  -- Secure Key Manager
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - samsung,s5pv210-secss           # for S5PV210
+          - samsung,exynos4210-secss        # for Exynos4210, Exynos4212,
+                                            # Exynos4412, Exynos5250,
+                                            # Exynos5260 and Exynos5420
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: secss
+
+  interrupts:
+    description: One feed control interrupt.
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clock-names
+  - clocks
+  - interrupts
+
+additionalProperties: false
diff --git a/MAINTAINERS b/MAINTAINERS
index ee4e873c0f9a..331c40ae6a01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14256,8 +14256,8 @@ M:	Kamil Konieczny <k.konieczny@partner.samsung.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
-F:	Documentation/devicetree/bindings/crypto/samsung-sss.txt
+F:	Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
+F:	Documentation/devicetree/bindings/crypto/samsung-sss.yaml
 F:	drivers/crypto/s5p-sss.c
 
 SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
-- 
2.17.1

