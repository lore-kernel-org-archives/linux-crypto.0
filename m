Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0E6C35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 16:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E79F3222BE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570032848;
	bh=kO8M38DmM9I+02SfH1lZx8c4kQqQUy1vQcjLyNx6/UI=;
	h=From:To:Subject:Date:List-ID:From;
	b=bpLre4MdnyrEJefQgS5IexTIXJWr9l5abbn1pJjk4nypXrBrLMpxkcfKaDg9UKAzr
	 40Wefj6BoyjtcZsBkbNl2mYURBWwYwCchAhvCcxTGrdMV2FzkZOVYdd8qRfQFuPZKR
	 EITpjwzIrxXwyaCnZfClIPXHnsyKAtrKKPwi3QGE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJBQOH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 12:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfJBQOG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 12:14:06 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4882121D81;
        Wed,  2 Oct 2019 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570032845;
        bh=kO8M38DmM9I+02SfH1lZx8c4kQqQUy1vQcjLyNx6/UI=;
        h=From:To:Subject:Date:From;
        b=pTAciPHwF/1ekI5rhATeOVb8L8s04YFa4IDtpwye5eD2HwpcrP8u9snStb72j0OQe
         G9ymOpPTDfJDoGksbnBOvrC2FeRLF7Kfn1SNbF2/GdUMvGf3gbj4Tn7K0e7M1ll4vF
         hajl3K1m4oB7OKu+EQOX+Dp4i73QkHkl3KN7vgOw=
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
Subject: [PATCH v3] dt-bindings: rng: exynos4-rng: Convert Exynos PRNG bindings to json-schema
Date:   Wed,  2 Oct 2019 18:13:40 +0200
Message-Id: <20191002161340.11846-1-krzk@kernel.org>
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

Changes since v2:
1. Add additionalProperties false,
2. Include clock header and use defines instead of clock numbers.

Changes since v1:
1. Indent example with four spaces (more readable).
---
 .../bindings/rng/samsung,exynos4-rng.txt      | 19 --------
 .../bindings/rng/samsung,exynos4-rng.yaml     | 45 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 3 files changed, 46 insertions(+), 20 deletions(-)
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
index 000000000000..3362cb1213c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
@@ -0,0 +1,45 @@
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
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/exynos4.h>
+
+    rng@10830400 {
+        compatible = "samsung,exynos4-rng";
+        reg = <0x10830400 0x200>;
+        clocks = <&clock CLK_SSS>;
+        clock-names = "secss";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 00b75028b280..b26b2009c230 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14212,7 +14212,7 @@ L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/exynos-rng.c
-F:	Documentation/devicetree/bindings/rng/samsung,exynos4-rng.txt
+F:	Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
 
 SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
 M:	Łukasz Stelmach <l.stelmach@samsung.com>
-- 
2.17.1

