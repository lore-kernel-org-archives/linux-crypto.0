Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78E0C47E49
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6A320663
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxjiPCFq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405444AbfJWUFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37202 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405433AbfJWUFZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so14743666wrv.4;
        Wed, 23 Oct 2019 13:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSMaBnNcLIC/2A/YQA0ncniU4wnlx2r73tbiVGv77iU=;
        b=qxjiPCFqDFEdtTP50g5dELIWeOTq4rW9OWwBEH106Ku4PwBoHFMq1ZmfMXKGRueonD
         6sTdWIA0ufEia32xU7QofsL2fbE0VL8kW1Vbb1+IXyxhdJFckqAk4E1MekTBqxV/AdCV
         5AbfectYLoxVSXXS/6AAWNiO17zOqwcvZjIUZOK43qYpoA5j0Z3ydOqq6bGRU/zuiO5M
         Cx7BPDHlk5JYX7w44EI221C0zpEJunwvhsdMGb58QQqfKzBXN3M1r2OERBZJ5ZzU8vNg
         yTy12K0NipPm6oBxr5GMZQNkJ1+TuPThpJkc7qlhJFc4OR1VyokE42nE/2tGEWuv+Qq7
         QgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSMaBnNcLIC/2A/YQA0ncniU4wnlx2r73tbiVGv77iU=;
        b=mjl7AhU9S3WJwb8CVlfNZVJrdUDr9WlihQjA1ZUsz+VMw7cLCOul6sy7qAs5PZC/aM
         5tyu4fCy4WMXYIKa1nbMilr2UJj//gAQSe8IQwSS+C4kg/2VedjL4IegLr7P2DDqaH5d
         AYywr/U8OCzTow+jkF2K26i1qQ+09YdI0JNgnqRz0ufxQiXny4W8zvACat97Pff/xaVZ
         g6sDdrUDHoyvt5nxKgZ009KhCPHTWFZWLpR4T/Cn4d15Am716MQSjOT223GRsUXA+a2c
         GYNUjCKWl1Nz+DqfEbHFXO9azZfldzwegPpC+ggZsRoTSicTPW4FEAH8nvi0A0A+zr50
         gJkQ==
X-Gm-Message-State: APjAAAWKZK32vQyv7SXMPOpmCQaSkOb+U3czyW4tFhEvwYFX7C1pfM0q
        40Z4KqyUGRfaZkq4/a7yTaA=
X-Google-Smtp-Source: APXvYqxkKsYv+SLGi42ULrVoLAnEzTY36NlrGjW/ZS6V4TyqutUOhjgjf7uUGlhOrPsSxX7lpNzQgA==
X-Received: by 2002:a5d:4aca:: with SMTP id y10mr416770wrs.292.1571861123069;
        Wed, 23 Oct 2019 13:05:23 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:22 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 03/11] dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto Engine
Date:   Wed, 23 Oct 2019 22:05:05 +0200
Message-Id: <20191023200513.22630-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
References: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the
Crypto Engine cryptographic accelerator driver.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../bindings/crypto/allwinner,sun8i-ce.yaml   | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
new file mode 100644
index 000000000000..2c459b8c76ff
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ce.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner Crypto Engine driver
+
+maintainers:
+  - Corentin Labbe <clabbe.montjoie@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - allwinner,sun8i-h3-crypto
+      - allwinner,sun8i-r40-crypto
+      - allwinner,sun50i-a64-crypto
+      - allwinner,sun50i-h5-crypto
+      - allwinner,sun50i-h6-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Bus clock
+      - description: Module clock
+      - description: MBus clock
+    minItems: 2
+    maxItems: 3
+
+  clock-names:
+    items:
+      - const: bus
+      - const: mod
+      - const: ram
+    minItems: 2
+    maxItems: 3
+
+  resets:
+    maxItems: 1
+
+if:
+  properties:
+    compatible:
+      items:
+        const: allwinner,sun50i-h6-crypto
+then:
+  properties:
+      clocks:
+        minItems: 3
+      clock-names:
+        minItems: 3
+else:
+  properties:
+      clocks:
+        maxItems: 2
+      clock-names:
+        maxItems: 2
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+
+additionalProperties: false
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
+      clock-names = "bus", "mod";
+      resets = <&ccu RST_BUS_CE>;
+    };
+
-- 
2.21.0

