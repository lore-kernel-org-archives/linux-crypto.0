Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516BFC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 12:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346928AbiBKMDL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:03:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349797AbiBKL7e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 06:59:34 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B38EEAE
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 03:59:33 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j9-20020a05600c190900b0037bff8a24ebso2693231wmq.4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 03:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tx8ZFq8JdO/4oUXF/KhCH6Nf7XCVn/8UewteKqP8h1s=;
        b=qFuJQjxgvlT2bAueQpdORWOfP43xD0e9K9dpxtvEuNkSBmi78JUWnzGS/JJ24WgnT+
         xmsbEsQQ0PS/X6OwzA7TnNT9C6OfK/X7stRvoYNMAu99/yiDTcgwglSlcBW3kfdbBwyj
         JVS3vcWbyRWXaFKBO6IwAoi2vUivUvSgdSKP8mrWFN4wD4N7VQ1p82JzooQtWS7GXNWb
         nzkZ/F+GgntKUs4PqHPwVkdyKnNp5DqeR5rqJyJHhpRqny4w/I9ag2PCyokFPyJEV0Uo
         azUOZmMvsleKSTM+DBPEiBBBNCcxN3n1iMRxd+cAGLtOyMtvr41E0CBkb14hUsEwA0qH
         qSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tx8ZFq8JdO/4oUXF/KhCH6Nf7XCVn/8UewteKqP8h1s=;
        b=xO5pcl4DkHYPHmb1H75J39PpaZ4pZ9zpJHLduCV82xPW+PitNgHtF9ueKWLQYu8mxN
         fr22wdkTQ1lBqJnKpToYfXlngofWioYfqcZM3o5aaA+xpxpPBIqDggQF/y2zqEe4yw+U
         LPlGR8fHOqKMVhcFx8EQit3WQZeI+2W4aSrQqmqLhHAkCDRAaeJxQzTady2G3/AOywaL
         XXkgq9C9wpLbovSGchq+/gUDjMM6TZ/FTAcOyL8kAqLuF+b6Z2cENxGOoLr1sbMoObm6
         6mTYHQK1oJlWjbpq3f4SWcgBlP8TPa6KRNVmmBZQeU4L+JIm+HXF3Iyi8vojkEXKct7b
         siiw==
X-Gm-Message-State: AOAM530Jh42o7iSNUMC35xEgFCLYOecxbjrqbKswWEA36EznCE7vvpYl
        VUJpK7ly3ehetAPh+lLA3AXPrw==
X-Google-Smtp-Source: ABdhPJwYjEPwR7ld+ZHbxRmJzqFRQ73mz77IVh4ygiFj10b1bK4/nIyP38c85s51FxEHBMDjEn43Bg==
X-Received: by 2002:a05:600c:4611:: with SMTP id m17mr17712wmo.94.1644580771686;
        Fri, 11 Feb 2022 03:59:31 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id s187sm4763212wme.14.2022.02.11.03.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 03:59:31 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3] dt-bindings: crypto: convert rockchip-crypto to yaml
Date:   Fri, 11 Feb 2022 11:59:25 +0000
Message-Id: <20220211115925.3382735-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert rockchip-crypto to yaml

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
Changes since v1:
- fixed example
- renamed to a new name
- fixed some maxItems

Change since v2:
- Fixed maintainers section

 .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
 .../bindings/crypto/rockchip-crypto.txt       | 28 --------
 2 files changed, 66 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
new file mode 100644
index 000000000000..2e1e9fa711c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip Electronics And Security Accelerator
+
+maintainers:
+  - Heiko Stuebner <heiko@sntech.de>
+
+properties:
+  compatible:
+    const: rockchip,rk3288-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: clock data
+      - description: clock data
+      - description: clock crypto accelerator
+      - description: clock dma
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
+    const: crypto-rst
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
2.34.1

