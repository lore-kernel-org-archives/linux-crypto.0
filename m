Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5507CA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 18:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A14F921E6F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 18:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aySJ8aeX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfJYSvi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 14:51:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45282 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfJYSvh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 14:51:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id q13so3470899wrs.12;
        Fri, 25 Oct 2019 11:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CYt7OOCWxMiffTsFLQ4ttpRYBiNr53KKi8gZYEc7rRE=;
        b=aySJ8aeXoWxWPhcU+I0HG5la8rxAm6aFD9Au5YAv6kFfB35LDbcNRkENPsRoTLf8lj
         UdDAzp3DZw2hQ3GYVLFzuQcRqnRcfCtcQ4zUBX1yDscrxz+eB2F6p461h4EvRK+ZbP3x
         oZjxzciRUN/Bqv6/T2aIglqLR4kQOlG/FfQN9gbmfDclKQjDjR0P1HnXAWA7y2hf65wT
         DTD6mt+idA+3GCzKURVM9wkpGFzmjDWGCrF1jGxI9Y1Fj38XWil5WkRNrS2GITyJ8qPi
         nWeFVl9YrC/aPwkm9MVvYJiAD6EEDvPOTdxj1LbYhQimpKd0+uOiloh40LFCrjJqd32x
         Co2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CYt7OOCWxMiffTsFLQ4ttpRYBiNr53KKi8gZYEc7rRE=;
        b=mppJeFhF/DIudiLuMQMGCfALORfKyeD5tFuL8Q3FPf37Bwu3GbpdN/xOwzUfl4RrK4
         8JmUkhdETEsGbbtmblwmlFPVSR4L4rUzta6rwpYBJbsU3LoR3CiEN8uU32PNLFKsDkol
         FvzZ2F7PqGX/QMovnOvCphbF9Pp/714QdA7hSMBr1WhodoGV8vCvpq/9vcdKfwEJZOni
         EAT4I1gRlEm9z7NcvL5rrpPgPc89fxFHkJiOncflIYk+ZmpsMCmL3BR/7L/GTN1I5Szm
         s/o85+7u2BprUttfeGtH4R9ZOFiN/cS4ejOCcnt3G18VQ0QWRDC5o9w9GmQ00VMfP8f+
         TpCg==
X-Gm-Message-State: APjAAAW/B+3NUNCubF28B6zuoTS0lbrSquwvYfLBe9nzBxFjPy1w3Sl/
        /gFAu+cosyLS7rY9o6DZX+k=
X-Google-Smtp-Source: APXvYqwWtYuEhTgXYl330NPayOGwERtmQF3ndif7Arhs4jcmeMBjzj1n9XZD0WNXuCTYrD9LzESc5g==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr4158431wrn.110.1572029495347;
        Fri, 25 Oct 2019 11:51:35 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id l22sm4821683wrb.45.2019.10.25.11.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 11:51:34 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, p.zabel@pengutronix.de,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 2/4] dt-bindings: crypto: Add DT bindings documentation for sun8i-ss Security System
Date:   Fri, 25 Oct 2019 20:51:26 +0200
Message-Id: <20191025185128.24068-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings of the
Security System cryptographic offloader driver.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../bindings/crypto/allwinner,sun8i-ss.yaml   | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
new file mode 100644
index 000000000000..8e9894c9f1bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ss.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner Security System v2 driver
+
+maintainers:
+  - Corentin Labbe <corentin.labbe@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - allwinner,sun8i-a83t-crypto
+      - allwinner,sun9i-a80-crypto
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
+
+  clock-names:
+    items:
+      - const: bus
+      - const: mod
+
+  resets:
+    maxItems: 1
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
+    #include <dt-bindings/clock/sun8i-a83t-ccu.h>
+    #include <dt-bindings/reset/sun8i-a83t-ccu.h>
+
+    crypto: crypto@1c15000 {
+      compatible = "allwinner,sun8i-a83t-crypto";
+      reg = <0x01c15000 0x1000>;
+      interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+      resets = <&ccu RST_BUS_SS>;
+      clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
+      clock-names = "bus", "mod";
+    };
+
-- 
2.21.0

