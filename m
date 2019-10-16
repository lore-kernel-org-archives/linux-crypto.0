Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E78FA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 114AA21D71
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PLQtZSn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392396AbfJPPBo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54995 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392381AbfJPPBn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so3287349wmp.4;
        Wed, 16 Oct 2019 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSMaBnNcLIC/2A/YQA0ncniU4wnlx2r73tbiVGv77iU=;
        b=PLQtZSn+yUCemUGZyaK473m9JcxsoRBCHnK8mKz/zRj0tErRYuBh0OKyDqaROR1GC5
         Mh6xh9x9uLzTwwGKktHHM0dZjuzSU+KBx4vtVd2mze3+9dwxpgKLTF/PXr8PCr0KMoxX
         yHSxmJhCqFcCVaNaG+WSCiBOfADh+tm5sixlRBTne9F8KHURtnekWoDdXMbty/NyjqQP
         +lehwak7dZxc9G+e327uYJdunwZ0TzBBxiKqMTBZF+0/P4y4m3DP/8I8Kzl+8G/dWGN0
         4BwZu5zF9V1PNhmrLFDwwz1WbevubQhpfziefaGjaTNOIg9eVVWcpLOh6tfi/tPGuwXw
         +heA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSMaBnNcLIC/2A/YQA0ncniU4wnlx2r73tbiVGv77iU=;
        b=pmHuh73XfgWUnG/qs0hIQLGPekmzGl8ME20C3hW6Tc3pLqJvf0gRJdrKrwU/a/zlWV
         WlW0lMIKgtEw1FaOwdUZvMNgyA2JGnbGBxpCPKnZHOkoz1Lt9uMZgohd3BJ/ivF1mor6
         mzq4p8Vlk71i9FBvfvwLKrWn3p++QDOwNlG7+Jm4xmzbOzv85cswdV0qxzHkFaOW/PWf
         Zj/gNetK0xApOYcrgGtr1xKI04HZCiKkG8vvSG/00d97gdH+53k3YGDifkeH2HFSO/lz
         y2i3KHROkDrwZnl1HVdWwfMyz9YdgGpFg/lhtG5MQMUlup3vpcs1i6vUg/NHpR6uTnlX
         lb4g==
X-Gm-Message-State: APjAAAUizW7zSSv24DQ1ASNOXsqUHce9UePnqLd/aHH2GsY5XkzePPLz
        SsrKVaSmiaOSctyAVX0TQDU=
X-Google-Smtp-Source: APXvYqyBZ1qB/ltT/hAuRNTYrYAOkdPTdDbDs8wpfV+2g9pzG0NhOcjvxsBCBCwOCBqByu6ihz8VSw==
X-Received: by 2002:a05:600c:c1:: with SMTP id u1mr3437767wmm.87.1571238100141;
        Wed, 16 Oct 2019 08:01:40 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:39 -0700 (PDT)
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
Subject: [PATCH v5 03/11] dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto Engine
Date:   Wed, 16 Oct 2019 17:01:23 +0200
Message-Id: <20191016150131.15430-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
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

