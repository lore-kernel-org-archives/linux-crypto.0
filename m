Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E55C10F14
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67FC02087E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPNVLmWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfJLStE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:04 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40671 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfJLStE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so13036073wmj.5;
        Sat, 12 Oct 2019 11:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSMaBnNcLIC/2A/YQA0ncniU4wnlx2r73tbiVGv77iU=;
        b=NPNVLmWAeFcXj3knWuqJnAxJ+1GylRrTwiTa77k1yTT3oxlyyyBt8UNmnledAaDpI1
         u6djkoPktc+ZxrfozJgsNZTrWPituND1cSkVXNqka6R00deTXKitvsGSNk3+t0qPVyW8
         yT7XSpCqhxzmpJpriicVF036kpd4rUTTMWSXi+T2cFU5hpL/5lUGiUOEJ/W6JBcGWYhl
         3vAHmdsKXaouQWUf/de7nSu2uvT4Uo/S9AevCKik2kgA2uR+3SBp60kTeEnNnf1bRyYO
         jOKz3Ex8yRvHwQI90qtb1BAs2iTY6ePGgL3ShQ+9AfQF5dXluk5hqD/AULQ4qleu/JmN
         7h7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSMaBnNcLIC/2A/YQA0ncniU4wnlx2r73tbiVGv77iU=;
        b=niml7z4aHa6AV4r9pDi+MCqURS/Wo8Rj06kgZgnr1pX+QwpVUYFYDIPybfj1t7d+8I
         BuhX685PKFtb4sT5ExhtDajVRUZs2rwOmS71t3aRQFereUBMI5CfvYtsAIm/DfCrYejq
         Hs9bRqiXoIJIeKmdv4JsSX4D74YjjIc3uPRECMgUqUNQnOVqoY3kWPaQNDaPgKV9P+76
         +63pLPaVJdobze18B4dY75lhCoc3Y8lvqvljcK5524DYTQ035gH5ncfwsaVcAlLZNDbA
         4s7D59U6RaG0BVyvBBg+NVZjK02ZxV++fdnlrClyeNrEcqqXbpJmziPJBP+JPhjz+NMm
         GTWg==
X-Gm-Message-State: APjAAAX0sHAcWXnTdG6auxX8nBwQ1h8PLwTiWF2WqGFdXMy+K0RKBYeW
        a0UyZSl9sYSU3roBz+iNM0Q=
X-Google-Smtp-Source: APXvYqxgq2hv3i+rHpHikEMKw1s6a8GqUoLKsHkTq1qlgD7lEHfX/LfAbBnGE7cDTzg8cuhDZLNTzg==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr8103167wmj.91.1570906141381;
        Sat, 12 Oct 2019 11:49:01 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:00 -0700 (PDT)
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
Subject: [PATCH v4 03/11] dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto Engine
Date:   Sat, 12 Oct 2019 20:48:44 +0200
Message-Id: <20191012184852.28329-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
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

