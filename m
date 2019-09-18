Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8C2C4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 17:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7295421925
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 17:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568827940;
	bh=1TixgpnrbW74TJpZIMBN4jvpzcDubcE9UumV31l30Nk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=M1yfRKnrId4x4cm+JTg4jDEZbyFR5nGsQ6+jY7SYyGihhXB4T/okbt4iOaml6c8w2
	 n0nLZjhiVZNi73CUyBy8/sElICDYNWUBJmIKPp5K1Vw0MyX8AqhlG2V9PMj+J4bKmU
	 1kyw8j3CjhhgASd03fScNcFZhvaDK4Tku5UMZzrs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbfIRRcP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 13:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbfIRRcP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 13:32:15 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6680A208C0;
        Wed, 18 Sep 2019 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568827933;
        bh=1TixgpnrbW74TJpZIMBN4jvpzcDubcE9UumV31l30Nk=;
        h=From:To:Cc:Subject:Date:From;
        b=OzltOak1RI4M1f9eGUSNpFq39Ro2X4jHeAfIiXyq0c34FJmpbNaEv7Cjcemb0poM9
         uE04q4mDU1LrkMk30mY4EX+LhD7KA8S6J8COMeBcIJZj56YzKZ7ZEf8xMUBTP+sWFK
         ojyxY9o/4DOqaRfganDMdAi+8phtDnFnChg4e0II=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-tegra@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-crypto@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2 1/8] dt-bindings: rng: exynos4-rng: Convert Exynos PRNG bindings to json-schema
Date:   Wed, 18 Sep 2019 19:31:34 +0200
Message-Id: <20190918173141.4314-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert Samsung Exynos Pseudo Random Number Generator bindings to DT
schema format using json-schema.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Indent example with four spaces (more readable).
---
 .../bindings/rng/samsung,exynos4-rng.txt      | 19 ---------
 .../bindings/rng/samsung,exynos4-rng.yaml     | 41 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 3 files changed, 42 insertions(+), 20 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos4-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.txt b/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.txt
deleted file mode 100644
index a13fbdb4bd88..000000000000
--- a/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.txt
+++ /dev/null
@@ -1,19 +0,0 @@
-Exynos Pseudo Random Number Generator
-
-Required properties:
-
-- compatible  : One of:
-                - "samsung,exynos4-rng" for Exynos4210 and Exynos4412
-                - "samsung,exynos5250-prng" for Exynos5250+
-- reg         : Specifies base physical address and size of the registers map.
-- clocks      : Phandle to clock-controller plus clock-specifier pair.
-- clock-names : "secss" as a clock name.
-
-Example:
-
-	rng@10830400 {
-		compatible = "samsung,exynos4-rng";
-		reg = <0x10830400 0x200>;
-		clocks = <&clock CLK_SSS>;
-		clock-names = "secss";
-	};
diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml b/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
new file mode 100644
index 000000000000..2d075d6c87b6
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/samsung,exynos4-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung Exynos SoC Pseudo Random Number Generator
+
+maintainers:
+  - Krzysztof Kozlowski <krzk@kernel.org>
+
+properties:
+  compatible:
+    enum:
+      - samsung,exynos4-rng                   # for Exynos4210 and Exynos4412
+      - samsung,exynos5250-prng               # for Exynos5250+
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
+required:
+  - compatible
+  - reg
+  - clock-names
+  - clocks
+
+examples:
+  - |
+    rng@10830400 {
+        compatible = "samsung,exynos4-rng";
+        reg = <0x10830400 0x200>;
+        clocks = <&clock 255>; // CLK_SSS
+        clock-names = "secss";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 00969a90f94c..9cec4494b9a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14181,7 +14181,7 @@ L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/exynos-rng.c
-F:	Documentation/devicetree/bindings/rng/samsung,exynos4-rng.txt
+F:	Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
 
 SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
 M:	Łukasz Stelmach <l.stelmach@samsung.com>
-- 
2.17.1

