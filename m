Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76536C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245338AbiDYU0r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245412AbiDYUZh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:37 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9961A12D214
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:59 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u3so22499847wrg.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D9cjlrLVeM5eQ7C/euT61wRVQvdXmZsaTd4EP2AIO+8=;
        b=HDiaEKbctP/PoZzCcg6Y/UZ9i+TMTsG/paw7EACujRBL1ZlsU30GscUQZSS7lzpJxJ
         +Zx12C5u8mIxldNHKRflqtZHvsTTquBwOiugc/26CCyWHCgXTFneKA2mVeFMcumyJzGG
         xqlelCiomC9Qes137XQvBLU7ivMyP+eVy375wb1elS04yqdnSsAC9933MyH0hc5YCebR
         sJCbugPVcU3HaWdaEKkxecxqv2Sdd71qtHFVP2SoVQMWRYjcqBL6Q6pW6kRLt3Vg8nJg
         j+h5MiDrSJk6GJS2tLYVZNVEQP0QiTAjSjXTokosWBHjogBbaUPedUDAys2k6/F93AeE
         SjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D9cjlrLVeM5eQ7C/euT61wRVQvdXmZsaTd4EP2AIO+8=;
        b=fSpSTdDzd81KvyqGAa39VyzimU+b4QGnDUMU5TOTE9fljDCrlrNEMo0vxeHDf2M7dB
         wx6blq1r1BLBU0gCBbyqW6F1AOjWAVELSp4tatkLFA6nznp+sDVujCE/eo9MBQm1oddJ
         RO6m06KxnXOExbs5UTkh0kpnHV7BJzrkPTqYsLqonYQdKK0FKI1Cx5Noyv1+qVJ+Hs9h
         2Xn3j33mJFFHlL0I9HIjy8XNltAika6ikmdTVS1EGKFglqvYkGM2TPy39MAAQpjP39ia
         USORiVdNJ1zIf+xZuiysek7rmKaHGDJt0ENP1GE0JuY6hXUuQnOlt9sMOCkDRhgU2eBS
         BIOw==
X-Gm-Message-State: AOAM532WPBeJRgcPP0eqSmLFxiB4UHQtVKxYmRWCTm7ZT8ASdMqop3eC
        sUPsq1f177JNEjQ9wL6RFnVw7A==
X-Google-Smtp-Source: ABdhPJxMszpw1oraGi5oAhibxLOcQ55EGl2CReCfpRGXUikz3P2++wn1JFE51XVm1Twax0Lseq7Y3Q==
X-Received: by 2002:a5d:474f:0:b0:20a:cb5c:bbd7 with SMTP id o15-20020a5d474f000000b0020acb5cbbd7mr13345457wrs.21.1650918110690;
        Mon, 25 Apr 2022 13:21:50 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:50 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 24/33] dt-bindings: crypto: convert rockchip-crypto to YAML
Date:   Mon, 25 Apr 2022 20:21:10 +0000
Message-Id: <20220425202119.3566743-25-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert rockchip-crypto to YAML.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/rockchip,rk3288-crypto.yaml        | 64 +++++++++++++++++++
 .../bindings/crypto/rockchip-crypto.txt       | 28 --------
 2 files changed, 64 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
new file mode 100644
index 000000000000..8a219d439d02
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip Electronics Security Accelerator
+
+maintainers:
+  - Heiko Stuebner <heiko@sntech.de>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3288-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 4
+
+  clock-names:
+    items:
+      - const: aclk
+      - const: hclk
+      - const: sclk
+      - const: apb_pclk
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: crypto-rst
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/rk3288-cru.h>
+    crypto@ff8a0000 {
+      compatible = "rockchip,rk3288-crypto";
+      reg = <0xff8a0000 0x4000>;
+      interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
+               <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
+      clock-names = "aclk", "hclk", "sclk", "apb_pclk";
+      resets = <&cru SRST_CRYPTO>;
+      reset-names = "crypto-rst";
+    };
diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
deleted file mode 100644
index 5e2ba385b8c9..000000000000
--- a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
+++ /dev/null
@@ -1,28 +0,0 @@
-Rockchip Electronics And Security Accelerator
-
-Required properties:
-- compatible: Should be "rockchip,rk3288-crypto"
-- reg: Base physical address of the engine and length of memory mapped
-       region
-- interrupts: Interrupt number
-- clocks: Reference to the clocks about crypto
-- clock-names: "aclk" used to clock data
-	       "hclk" used to clock data
-	       "sclk" used to clock crypto accelerator
-	       "apb_pclk" used to clock dma
-- resets: Must contain an entry for each entry in reset-names.
-	  See ../reset/reset.txt for details.
-- reset-names: Must include the name "crypto-rst".
-
-Examples:
-
-	crypto: cypto-controller@ff8a0000 {
-		compatible = "rockchip,rk3288-crypto";
-		reg = <0xff8a0000 0x4000>;
-		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
-			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
-		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
-		resets = <&cru SRST_CRYPTO>;
-		reset-names = "crypto-rst";
-	};
-- 
2.35.1

