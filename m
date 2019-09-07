Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB98AC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 11:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964B8218AF
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 11:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567856032;
	bh=P50xo7m/hUx5iwji95aKRMlv0t3ad1ikhaodbFQe45s=;
	h=From:To:Subject:Date:List-ID:From;
	b=hrwvdkzURRa99Ji7sb6Dl8GTh53SNxSdaoaH34Kv4yHMsoLC8mDO1I7bGkq2AaKil
	 ehSfkQG8cDyr4kOsG7jtHgPZzsbpVsCGaWnG1e87ZazGPy90ONZo2PE6LsRfIJDHAi
	 JvVgSL71deevTpIme4h052WAJIpjJDgrz53pLmUE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390553AbfIGLdt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 07:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731266AbfIGLdt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 07:33:49 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3960E20854;
        Sat,  7 Sep 2019 11:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567856028;
        bh=P50xo7m/hUx5iwji95aKRMlv0t3ad1ikhaodbFQe45s=;
        h=From:To:Subject:Date:From;
        b=kQnJwuopno6wn2b1m0kIb1H/0+B0zHoerIfOkUqKzMVusUelej/q5l+lMKc1yUEGv
         Cc1DOvVkXMwxq5SY+YD8Y6GGXyq993ZCLzGbGTkpvYphtz7Gmx+YfTRv2gp5ISnZmi
         FTVJnW5e/WqMzzsXVHwKgpLYTHR0URvG19ArkPiA=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: rng: exynos4-rng: Convert Exynos PRNG bindings to json-schema
Date:   Sat,  7 Sep 2019 13:33:27 +0200
Message-Id: <20190907113327.3477-1-krzk@kernel.org>
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
index 000000000000..994b0ba10d2e
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
+      compatible = "samsung,exynos4-rng";
+      reg = <0x10830400 0x200>;
+      clocks = <&clock 255>; // CLK_SSS
+      clock-names = "secss";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 331c40ae6a01..cdd2f1f3e1f4 100644
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

