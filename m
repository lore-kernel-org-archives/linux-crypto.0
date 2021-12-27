Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA3EC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Dec 2021 18:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhL0SdN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Dec 2021 13:33:13 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45440
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231768AbhL0SdJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Dec 2021 13:33:09 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A3CE1407AC
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640629986;
        bh=NkhG/x29/01OwnwUW7nLUUqEe+ov12qsWpqmInTRQ8g=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=IrgiBy2Pfak1drSxYRPNny77La2lWm5txxP9Fg0Cda1ue5vt37en+UHVgCJaHdLrH
         aqBSBKqP+cNUDLmkC725t+XOTyLvEnGWe5AqyV2k67c6UxaeTcVW2rRYdxjBzotVvh
         fHi/h74CiobLg7HV32D24cITo8DNLZBnGlJi6iGLn4YGYwMIF3jvLT/kMwD5DbCtnN
         NPVN0WD4gkL7HGVZb/QWjolL+pPifeMvk4DQP0T2r5uf2z+Q1vBMbdiTfqqNe+OCjw
         bpSi0KsGVeWwZRjykiJ+TxaGthNThzEmx8NzrE9hFZo9s7xFJ1VVYuV078ggNoRgYj
         sYXflvCqlVPzQ==
Received: by mail-lj1-f200.google.com with SMTP id b20-20020a2e9894000000b0022dc5a5f841so2253683ljj.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 10:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NkhG/x29/01OwnwUW7nLUUqEe+ov12qsWpqmInTRQ8g=;
        b=dKTmWAtbtcvpc4vKw9OX9B1ZItMlS0fvQkREJsGlyIoK7PVjButuILGCZJ/+K3NoxL
         9sC8g1nvMhnImZtcfczDhw1slbhNZ6KgNCaZ6j6GKraavhmDyUDF/h/MzAvbhCmuiLSS
         xh224iaz9W7AelkyzSL/8NEpqNegJpjhQjCE0LwWCGiMe2xyGl1Han9+8pyv8fsSaRQn
         6M5e27YehHqeiqre5sctDCshJ5iPo0HkOZf0ZbeCyhGOUey4kBWKc1E0U57KEqyBAReB
         Ovjx7SjM3qSYU/LCMOJNBZo17x2/EupV0BwSiN1d1flMq0nImPidRTB3vFKukp2myYy7
         m7RQ==
X-Gm-Message-State: AOAM531532vUrUICxpv3nHl0REK/EOvYO8fleb5J8sYLZwKeveiEWeq0
        q8nROlw3okqSagE1hhK43th9yJZx0w9ZISL+EPieZRwnfgy/1CVnhFNyvbmRQHARObIs7z5u8HZ
        doiVfDjLeB5XjNYaSoTBn7oAVPNANoo/tUtLUdLAqaw==
X-Received: by 2002:a05:651c:1788:: with SMTP id bn8mr15237857ljb.521.1640629983719;
        Mon, 27 Dec 2021 10:33:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPduPoQbsa0sy+uH2eNHIhEtE/sohO5iVYWenQxdkMncrOkJ+IgNQ7Hd0WQR7JT8kWLRV0CA==
X-Received: by 2002:a05:651c:1788:: with SMTP id bn8mr15237828ljb.521.1640629983480;
        Mon, 27 Dec 2021 10:33:03 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o12sm1299622ljc.5.2021.12.27.10.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 10:33:03 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, openbmc@lists.ozlabs.org
Subject: [PATCH 6/8] dt-bindings: rng: ti,omap-rom-rng: convert OMAP ROM RNG to dtschema
Date:   Mon, 27 Dec 2021 19:32:49 +0100
Message-Id: <20211227183251.132525-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
References: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the OMAP ROM RNG bindings to DT schema.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/rng/omap3_rom_rng.txt | 27 ------------
 .../bindings/rng/ti,omap-rom-rng.yaml         | 41 +++++++++++++++++++
 2 files changed, 41 insertions(+), 27 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/omap3_rom_rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/ti,omap-rom-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/omap3_rom_rng.txt b/Documentation/devicetree/bindings/rng/omap3_rom_rng.txt
deleted file mode 100644
index f315c9723bd2..000000000000
--- a/Documentation/devicetree/bindings/rng/omap3_rom_rng.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-OMAP ROM RNG driver binding
-
-Secure SoCs may provide RNG via secure ROM calls like Nokia N900 does. The
-implementation can depend on the SoC secure ROM used.
-
-- compatible:
-	Usage: required
-	Value type: <string>
-	Definition: must be "nokia,n900-rom-rng"
-
-- clocks:
-	Usage: required
-	Value type: <prop-encoded-array>
-	Definition: reference to the the RNG interface clock
-
-- clock-names:
-	Usage: required
-	Value type: <stringlist>
-	Definition: must be "ick"
-
-Example:
-
-	rom_rng: rng {
-		compatible = "nokia,n900-rom-rng";
-		clocks = <&rng_ick>;
-		clock-names = "ick";
-	};
diff --git a/Documentation/devicetree/bindings/rng/ti,omap-rom-rng.yaml b/Documentation/devicetree/bindings/rng/ti,omap-rom-rng.yaml
new file mode 100644
index 000000000000..9a58440b1ab1
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ti,omap-rom-rng.yaml
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/ti,omap-rom-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: OMAP ROM Random Number Generator
+
+maintainers:
+  - Pali Rohár <pali@kernel.org>
+  - Tony Lindgren <tony@atomide.com>
+
+description:
+  Secure SoCs may provide RNG via secure ROM calls like Nokia N900 does.
+  The implementation can depend on the SoC secure ROM used.
+
+properties:
+  compatible:
+    const: nokia,n900-rom-rng
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: ick
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    rng {
+        compatible = "nokia,n900-rom-rng";
+        clocks = <&rng_ick>;
+        clock-names = "ick";
+    };
-- 
2.32.0

