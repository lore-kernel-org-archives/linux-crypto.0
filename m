Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4041EC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Dec 2021 18:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhL0SdF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Dec 2021 13:33:05 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45336
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhL0SdD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Dec 2021 13:33:03 -0500
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 97C193FFDE
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640629978;
        bh=Ha91ZDV5aCOHeV4K+0XvZy0cP8PcDx+1Y/WeQ3R169I=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=bz8aWCzJhPborglQ6dQTuo5DBiWfOehSPenCvx6PtASXuIeSeQcIwadEu1gRJofcr
         T0YyDeNyW0zK94wR9UgLWZ3OEBJBmiA3GKiGtHxwwkaSedit4P80erOED4LwuEGmIy
         j5MwB1NWYkd850x6O/bNbz537EiJuzropU2M9EIDawUUSBjlDfmNECnjrQtq7frTgU
         14UbxMlOdj6hw5CqpAIVjGLf5IBjVQ7iCvDNwxYbcjGztkD6y3KJI0HVDpIR1NvKDN
         Q4wbz5/YjxccdAL8PO+cqDsRdpOQdyBbAuT4f2VbAMXC36m4uxIhBLxdqSsHnpDuqZ
         TUcufQ1hCWUOQ==
Received: by mail-lj1-f197.google.com with SMTP id k11-20020a05651c0a0b00b0022dc4d55f14so2296593ljq.22
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 10:32:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ha91ZDV5aCOHeV4K+0XvZy0cP8PcDx+1Y/WeQ3R169I=;
        b=nc4PTsSny1fJjrQLEMOwCt1cflMqle1OmC9TMeBNE8zKI2JEKbucBkgN7MJyVo4cF7
         5rpiVRVNq0T7kT2SA255c2ZCvOx9A1tr7JgDejNqdiPvaUDzm1tKLSaPHHIvwLT3yL/X
         p9oUMWcNGtvJAOEEL8AcwOUMroYyyXZeHAnx4jRwNCy2ptw6AHKpb1jYiCM3n2oeyaW5
         lFwYDq1KGxsz06F2ayab4nEB/0Jc20kmWHZ1uGlNrQ57+D2d5WI9LrPOEdxy9CvBIMYm
         hfHv+BBvpJXEgqRPZvPL24rIpnuTe/rxciaTdzJ+ebZN6INKYXcEVoFL3rNrqJquP6zT
         qqXg==
X-Gm-Message-State: AOAM5324j9cLRSQ2hFCZLyijc1orwLSxL2KnshBj/g3mdOmCLb1RC8EJ
        bKYvNBfsFkSMgyFSWj5h7OgFOG+hQe3m6MTJ5WiXQthHdCskE6PMlKkvhX8PHPQrUPl+9qLiZnR
        XgEZ0WWqGed+OWbt7BYSa0hpMK9DfkQ10DZYMSumgrA==
X-Received: by 2002:ac2:4d34:: with SMTP id h20mr16342027lfk.617.1640629977839;
        Mon, 27 Dec 2021 10:32:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxw2ascN7H6LYQsbejqKJs7k+yaXgGe30MRDmj5xMYPmLPKoxgkmpwR4T2jbxwJKJSp1I0tQg==
X-Received: by 2002:ac2:4d34:: with SMTP id h20mr16342015lfk.617.1640629977677;
        Mon, 27 Dec 2021 10:32:57 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o12sm1299622ljc.5.2021.12.27.10.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 10:32:57 -0800 (PST)
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
Subject: [PATCH 2/8] dt-bindings: rng: atmel,at91-trng: convert Atmel TRNG to dtschema
Date:   Mon, 27 Dec 2021 19:32:45 +0100
Message-Id: <20211227183251.132525-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
References: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the Atmel TRNG bindings to DT schema.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/rng/atmel,at91-trng.yaml         | 46 +++++++++++++++++++
 .../devicetree/bindings/rng/atmel-trng.txt    | 16 -------
 2 files changed, 46 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
 delete mode 100644 Documentation/devicetree/bindings/rng/atmel-trng.txt

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
new file mode 100644
index 000000000000..0324e863dab8
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/atmel,at91-trng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Atmel AT91 True Random Number Generator
+
+maintainers:
+  - Nicolas Ferre <nicolas.ferre@microchip.com>
+  - Alexandre Belloni <alexandre.belloni@bootlin.com>
+  - Ludovic Desroches <ludovic.desroches@microchip.com>
+
+properties:
+  compatible:
+    enum:
+      - atmel,at91sam9g45-trng
+      - microchip,sam9x60-trng
+
+  clocks:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - clocks
+  - interrupts
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    rng@fffcc000 {
+        compatible = "atmel,at91sam9g45-trng";
+        reg = <0xfffcc000 0x4000>;
+        interrupts = <6 IRQ_TYPE_LEVEL_HIGH 0>;
+        clocks = <&trng_clk>;
+    };
diff --git a/Documentation/devicetree/bindings/rng/atmel-trng.txt b/Documentation/devicetree/bindings/rng/atmel-trng.txt
deleted file mode 100644
index 3900ee4f3532..000000000000
--- a/Documentation/devicetree/bindings/rng/atmel-trng.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-Atmel TRNG (True Random Number Generator) block
-
-Required properties:
-- compatible : Should be "atmel,at91sam9g45-trng" or "microchip,sam9x60-trng"
-- reg : Offset and length of the register set of this block
-- interrupts : the interrupt number for the TRNG block
-- clocks: should contain the TRNG clk source
-
-Example:
-
-trng@fffcc000 {
-	compatible = "atmel,at91sam9g45-trng";
-	reg = <0xfffcc000 0x4000>;
-	interrupts = <6 IRQ_TYPE_LEVEL_HIGH 0>;
-	clocks = <&trng_clk>;
-};
-- 
2.32.0

