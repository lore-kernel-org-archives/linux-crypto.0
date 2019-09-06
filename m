Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D79C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C97821670
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgPusha7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391458AbfIFSqL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:46:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54470 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395370AbfIFSqK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:46:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id k2so7494917wmj.4;
        Fri, 06 Sep 2019 11:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8335uoZd+LT0PenZntX1wYZZQovMh2HBfgED4ylV1H8=;
        b=BgPusha78ZW/cPNKiDFgfhvWxRZaVKbdmGqlpkN9MmEUQktGlSSLP85gzEKKdcG+xP
         R6H7X1DYibgG0M62pnrgldIQaGA9UJlmG1nHfiBS7ry8k+ilpUVzDFCKM7f5AIqVOuDy
         ZiZCX7vKtwcszA3pOF0unJtONhlGfLebCfAvwIj6+9rIhBgPhqLgg9W9LZFM/4Qg7lSg
         ytKiCyPelDioNz+j2NNhKt5opOQ2wDEY5m1A4sFOYfOgtBt0yRMq4mEmhha4Qai0b2Gh
         xoe+ogn4tPmcf7PZAc6KAg3InfAZuKTD5C2YmGU3Hpp3EMhFuZ4r/fCU8b9iL6RRjXfx
         Jxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8335uoZd+LT0PenZntX1wYZZQovMh2HBfgED4ylV1H8=;
        b=AMyWvSPg4tWEN9QPPgpC+jdEqBQS+YD6UP8FeqW0QCZ0rdMeWftbeK/KPJtITKqeD0
         NwpCLkcrDy7vHGwrzsKJw8cvXsUj68zdoN9hlF238ZpC16Ic4+78ejpq5pBQCcZ246A0
         yNZDM15xhZIJJoEU9rMYa+yOd1O1RpXUXioqNkWIlr3K0Ljc5zafIVd9hD3jT+xmu37o
         8hPZy6Cphjxg0rxqC7e7rll+IAU0LGsxMlSajoBxYAaGXo6mK8tOsrZ8wqm3pQAl2nIr
         xRZj5Ck5fQ+ct+YYgt+OzOxOrMKyX4qfuC7mOiBuHL37lk8y+zAABAq9H1aB5tvX4biK
         KSQg==
X-Gm-Message-State: APjAAAWC7sjjq8EL/omPfjYECTe19mdXuvhHvquUqvmNgZ3hBWh5xYAc
        7zumA49uNssbcsh4WChhGAA=
X-Google-Smtp-Source: APXvYqwlofFwIAS7bR3rWQccQzImXsxRbREbRmVniVdJMI2PcVuPwBl+72P3N6n+EXqq318ogp/CYg==
X-Received: by 2002:a7b:cb9a:: with SMTP id m26mr5027714wmi.57.1567795567864;
        Fri, 06 Sep 2019 11:46:07 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j1sm8677577wrg.24.2019.09.06.11.46.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:46:07 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto Engine
Date:   Fri,  6 Sep 2019 20:45:45 +0200
Message-Id: <20190906184551.17858-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the
Crypto Engine cryptographic accelerator driver.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../bindings/crypto/allwinner,sun8i-ce.yaml   | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
new file mode 100644
index 000000000000..bd8ccedd6059
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -0,0 +1,84 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ce.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner Crypto Engine driver
+
+maintainers:
+  - Corentin Labbe <clabbe@baylibre.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: allwinner,sun8i-h3-crypto
+      - const: allwinner,sun8i-r40-crypto
+      - const: allwinner,sun50i-a64-crypto
+      - const: allwinner,sun50i-h5-crypto
+      - const: allwinner,sun50i-h6-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+if:
+  properties:
+    compatible:
+      contains:
+        const: allwinner,sun50i-h6-crypto
+then:
+  clocks:
+    items:
+      - description: Bus clock
+      - description: Module clock
+      - description: MBus clock
+
+  clock-names:
+    items:
+      - const: ahb
+      - const: mod
+      - const: mbus
+else:
+  clocks:
+    items:
+      - description: Bus clock
+      - description: Module clock
+
+  clock-names:
+    items:
+      - const: ahb
+      - const: mod
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: ahb
+
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/sun50i-a64-ccu.h>
+    #include <dt-bindings/reset/sun50i-a64-ccu.h>
+
+    crypto: crypto@1c15000 {
+      compatible = "allwinner,sun8i-h3-crypto";
+      reg = <0x01c15000 0x1000>;
+      interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+      clock-names = "ahb", "mod";
+      resets = <&ccu RST_BUS_CE>;
+      reset-names = "ahb";
+    };
+
-- 
2.21.0

