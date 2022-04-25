Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47EAC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245342AbiDYU1D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245327AbiDYUZi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:38 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CAB1301BF
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:02 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k2so2043670wrd.5
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RoEkU2wAHdZrSlV4sPqXXxqUUD/tymZLZdlnbgZM9Yc=;
        b=Lx624Hb1v8mbCoeAt514dLkicA4g8cGOsxM5mgr9CfcmzRoRE9QjF3OUuN8qV248cC
         c8cU3Rs6qgQYuJgFIYMb8KB5OmBLRZD5w5fYiZHnFaTrjokX+Rs3xgaVhvEzFK+6rZd7
         ismfGU1HrufI2PtGUz5+q9Q2k0uoX1IntKAMQ1r2PCnPGOcP4pDr3/GgSegDV14jq+jZ
         FuCX5/Hvng38+UBuYrWpF3+i8AgXuWDG9K9lYSKxJKt4+4VFdxgvPxwPsH3X41xhSV/o
         O38ElT7ffu0RIDyR4vikb4ufpR/qlbuiMvDdkDSbYz8307PJdCv2boqKfDEpntsqLxBY
         cPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RoEkU2wAHdZrSlV4sPqXXxqUUD/tymZLZdlnbgZM9Yc=;
        b=O/cAIAdr6LYVZ4uo3g2sx5Wa9uVUgUezEb7ANcqERgdtAOZKcpVhmKJloO22u403RG
         nJOFEQgnOCLafk0r3a1Lk1Fa11jqxTG3orgMEqZHYjSquOxL6Praid4ObfqJRgKwxz37
         i2HRnktYdBOC8Qb6OuE5akh4JVBXjeAztL6opAJk6fkdGPVJ+LMBr18AmoV0se4KyMlK
         a2fR/y36lwvrzv4+1w1gtT4nRxHoRV0bSbVvC8kLWErigufbNTROMBSKnDVTnpkSDl9D
         TLC71UGDXmV9MDSN8nh6EAr0TrIsCW7QZYW20z1psTE+jZI0QGwsQD4MD+pi9a80V1tj
         5EZg==
X-Gm-Message-State: AOAM530KxSTI6++FRIW6hPyZzEdbCiSpjgz6OE+7sySIw/1lhz0Gm1rq
        zyLAiDaW4V0ky0GBlJjPP7EK2g==
X-Google-Smtp-Source: ABdhPJwP7xSsF5UJIq/gGiZBqI8EFC+nzUbUZIbMLeZPHpF3ww+DSMXe+2kgo+zQHk3hV1CpelO9gg==
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id i12-20020adfb64c000000b001e316d03504mr15276335wre.333.1650918111706;
        Mon, 25 Apr 2022 13:21:51 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:51 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 25/33] dt-bindings: crypto: rockchip: convert to new driver bindings
Date:   Mon, 25 Apr 2022 20:21:11 +0000
Message-Id: <20220425202119.3566743-26-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The latest addition to the rockchip crypto driver need to update the
driver bindings.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/rockchip,rk3288-crypto.yaml        | 85 +++++++++++++++++--
 1 file changed, 77 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
index 8a219d439d02..ad604d7e4bc0 100644
--- a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
@@ -13,6 +13,8 @@ properties:
   compatible:
     enum:
       - rockchip,rk3288-crypto
+      - rockchip,rk3328-crypto
+      - rockchip,rk3399-crypto
 
   reg:
     maxItems: 1
@@ -21,21 +23,88 @@ properties:
     maxItems: 1
 
   clocks:
+    minItems: 3
     maxItems: 4
 
   clock-names:
-    items:
-      - const: aclk
-      - const: hclk
-      - const: sclk
-      - const: apb_pclk
+    minItems: 3
+    maxItems: 4
 
   resets:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   reset-names:
-    items:
-      - const: crypto-rst
+    minItems: 1
+    maxItems: 3
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: rockchip,rk3288-crypto
+    then:
+      properties:
+        clocks:
+          minItems: 4
+        clock-names:
+          items:
+            - const: "aclk"
+            - const: "hclk"
+            - const: "sclk"
+            - const: "apb_pclk"
+          minItems: 4
+        resets:
+          maxItems: 1
+        reset-names:
+          items:
+            - const: "crypto-rst"
+          maxItems: 1
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: rockchip,rk3328-crypto
+    then:
+      properties:
+        clocks:
+          maxItems: 3
+        clock-names:
+          items:
+            - const: "hclk_master"
+            - const: "hclk_slave"
+            - const: "sclk"
+          maxItems: 3
+        resets:
+          maxItems: 1
+        reset-names:
+          items:
+            - const: "crypto-rst"
+          maxItems: 1
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: rockchip,rk3399-crypto
+    then:
+      properties:
+        clocks:
+          maxItems: 3
+        clock-names:
+          items:
+            - const: "hclk_master"
+            - const: "hclk_slave"
+            - const: "sclk"
+          maxItems: 3
+        resets:
+          minItems: 3
+        reset-names:
+          items:
+            - const: "rst_master"
+            - const: "rst_slave"
+            - const: "crypto-rst"
+          minItems: 3
 
 required:
   - compatible
-- 
2.35.1

