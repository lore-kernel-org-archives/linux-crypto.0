Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9189C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8139B20659
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QpEo/GnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfJJSX7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:23:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54908 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfJJSX6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:23:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so7954723wmp.4;
        Thu, 10 Oct 2019 11:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1FMzJIIyw4z/wqW7e42wz5NIx7jF256+N5mF2lPv9Ug=;
        b=QpEo/GnRkai8NNa+QWMvtXcFWa9Q5DycFBkMC2Q6z9IiLbjtRRyHUqnaBC/tSD75gB
         d2+Iduaj3ZEjNsSKxotbCsnYWW4fOSeBPN7r3WHswD1hjmec8Zn9Tb6q9LRscBM6SCDF
         E2rtfziCQUXEImJpkOuCR3+xCNBqneLI14f0J6dsphh70OKJ/fzTDEYwmJ9Ui5WA4qRQ
         f22sTQQxsvi0UTixfjwThSgwTLlFSICR8M9WLTkur2rIBxRZJ/XpxrDvRFfBtJpWMVJ4
         7x36pfBMn95Od51H26thWUdZUNgEl4+EZYpTrQmiggEH58bF4MGMdLDtdk0TEx0S6PCW
         BROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1FMzJIIyw4z/wqW7e42wz5NIx7jF256+N5mF2lPv9Ug=;
        b=E8C/vU7RPKTolSvaQLTwD4WFLmt5fWqc6MAU4aDcctG1IZLJbDZg0oMHMo+G93xz2R
         LzFRNKbNvcaoME5SkohTAWUOO/56U7otoeqIehYsbMBbMHFsjyFEbjFWv4ZU4gk90CLC
         weB8MLSjUscw87Iq6YCvlJgo01qi9oVjFT64Iw9fYDtd1vZyJvjTYwpDd0hox5wXstIH
         xoo3JmAza2H00YvOxP0oRzycc2SEPq2p18iPrD7cD8tUR5S/ln29CNXkENxf1TiY1Q+D
         e3TB/8j6zyvMf2b1sFm9VSxi/He+i69fwAFr9pB82KdIGUBG7OUQj/Gp4eMI0iFqCOle
         7OXQ==
X-Gm-Message-State: APjAAAW7uq/KU4rjAEcpAJxy7vzu03PoXi+ZoRIeKiRYThhpbcVIT9C6
        d/aEdLMVa/eW30KyRtDLgBM=
X-Google-Smtp-Source: APXvYqzAJTnCoh1W/7nHXKHA7V3gqZzMl3fnZehxL1H/ZYsMDzH5oxLVlCdICBmUcwhle8kEtEaC2Q==
X-Received: by 2002:a7b:ce07:: with SMTP id m7mr8893122wmc.117.1570731836816;
        Thu, 10 Oct 2019 11:23:56 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.23.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:23:55 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 03/11] dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto Engine
Date:   Thu, 10 Oct 2019 20:23:20 +0200
Message-Id: <20191010182328.15826-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
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
 .../bindings/crypto/allwinner,sun8i-ce.yaml   | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
new file mode 100644
index 000000000000..a5c8f90d267f
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -0,0 +1,92 @@
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
+  reset-names:
+    const: bus
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
+      reset-names = "bus";
+    };
+
-- 
2.21.0

