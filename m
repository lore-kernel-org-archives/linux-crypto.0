Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D41C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 12:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiBIMrc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 07:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiBIMrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 07:47:32 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B84AC05CB96
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 04:47:34 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v12so3899601wrv.2
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 04:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8KKYJ6eDy6KSnsSKdeEJDtLtm3smSqg5GzRuwnz+AbE=;
        b=RS6jPHtzTIJDhkk3PdljqHoRS37P6K6YLpDOj8DRjIol0d5IU22yJ5omh4BClCAY9d
         8rj4iecxAZASniAHLurbjkx8FR6SCkc/tGj9gx/yrSyLlZWd3oSA3IkFSf+ZeyrDOYGX
         KS6ZBnauyFzSVGx83yorjIBc/7qN0vtan67xMzLXWd/s2CpYCLpvgqXN45YBBEP2Ss12
         3KxhZM7iaTS9OoAorjP8/rmH2N2chrNYepuCrz7Tfm7OJS1Lupfx9Qj2GF65QiKk7CW1
         4EIsdXJxevbr6zkb/1dXtonKvKeLlols1WCO+Jku/A1OLyDveOB81Mlg/xtfpIq7Tntl
         T2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8KKYJ6eDy6KSnsSKdeEJDtLtm3smSqg5GzRuwnz+AbE=;
        b=u4eTFFOQT4f7yj1PCAm53VEHn1aC21CApj1ZeYKnUg+HDR8utyyqr94sTl6wi15Gbd
         kCgxadKqgy3q6BQITxVuGNTfkvX7jmVuCv8CWFdzULevsjmgt1YYA8LCRpJX3ThiGZBl
         4UEe1aU6fUBctdWmA6Ijt1Hip8bNd/Zh4bIW6WMxOrGCAOxDxhRMFP253bjwGohaUVFT
         rFBPmxkeG4g0X0KCxiEroSVHeIYGadfdTo7/TDvOSlZj9vG4GlZcKaEN5Mz64Cy4Y5CB
         F2K7N0iULEGmWhLOGEiRlWdvzqqj4UtS/7kJ9ucb4+QBcBjizvLBuo1ClpYJwnEQfDDD
         5uXw==
X-Gm-Message-State: AOAM5325E1sFSF50qkmg0ryyOBWsbWuYFnWcwgOs/wzNLva5KMl1Gw79
        rNIZb2YHAt+dV5Oys+9LxlaSWQ==
X-Google-Smtp-Source: ABdhPJwSsJ8mWCJ3s7wNHrs1Ze3j6HvXeNSDhG9u3iAU2F4IW/6g3LKiNDG5Xk9tl6gLMze4VGEXjA==
X-Received: by 2002:adf:f50a:: with SMTP id q10mr2006142wro.252.1644410852767;
        Wed, 09 Feb 2022 04:47:32 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o20sm5137834wmq.35.2022.02.09.04.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 04:47:32 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] dt-bindings: crypto: convert rockchip-crypto to yaml
Date:   Wed,  9 Feb 2022 12:47:25 +0000
Message-Id: <20220209124725.2080986-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert rockchip-crypto to yaml.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../bindings/crypto/rockchip-crypto.txt       | 28 --------
 .../bindings/crypto/rockchip-crypto.yaml      | 64 +++++++++++++++++++
 2 files changed, 64 insertions(+), 28 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.yaml

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
diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip-crypto.yaml
new file mode 100644
index 000000000000..392d89055398
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rockchip-crypto.yaml#
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
+    minItems: 1
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
+    crypto: crypto@ff8a0000 {
+      compatible = "rockchip,rk3288-crypto";
+      reg = <0xff8a0000 0x4000>;
+      interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
+               <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
+      clock-names = "aclk", "hclk", "sclk", "apb_pclk";
+      resets = <&cru SRST_CRYPTO>;
+      reset-names = "crypto-rst";
+    };
-- 
2.34.1

