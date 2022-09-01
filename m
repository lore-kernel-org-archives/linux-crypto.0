Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5401ECAAD1
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 13:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiIANAE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbiIAM6m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:58:42 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472938D3E6
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:44 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so1313545wmk.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=a7kQbSuJBA+hO+22/DPT0818Q67abekR8AZbfSsKp0c=;
        b=u9zUrow7UUAI2VuY0iwmPzhV8W5dimlC/350NOd2L3tXR2TZ/Nejbgiu/1bUp5pYcO
         k9S3Fj5VZEa8osLdkf+cvWPER3AuYQHXUEKzBTff2yUHC2iPzTceaJnWcADh24dpOKpm
         jDRWx7WJyXWqyuzNAK3YlbLpMPZmXq4Ci18YqdMYtKaqWfu4eoXbvMj/3N2q7FGw9E15
         QS9377Jv3ULe3GZXDAD8/3QySkbxZF9Q0tfdSJezyhxJcUgU5qavpXwifl1vDJ4MqpK3
         hcsHBmoAcbV1R/bSB2zmafCBfNXA/xyugF9qGieoy0Cx5yR4dEG+/gMfOLtMrSR53/1x
         7CnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=a7kQbSuJBA+hO+22/DPT0818Q67abekR8AZbfSsKp0c=;
        b=kx+DEEvFaE+UDfaTjkJ4bJrTPeCfEWcH1fyCB9EU/Rx74eg4yeOyKTwaNn87dy0b7y
         zdXPEN1WmwQL4JfUxwEHv/xDDUlC5t3fhR0n5WNEUvyixggoI5z7Q+0ES9XpUJLATwl6
         ZmyyW/p/ppXK7XgG8r8Swx4avXrWtyJdzHPtZ09xBSYD2W9p85PfTjRo511JXAyIZZy6
         GCPqmVoF9yDb/p6W6j49tK/MCKJB1W8aE6huJCyJXsbdhzDG/bGT8NSg1ga9uPMyWecA
         9Uy5Ry1VDDCecvveFrV+sRxRPUzec4yQ7YecHK0vm0T5EvJ48gbzfLsA2dGW2eMF/p1M
         hKyQ==
X-Gm-Message-State: ACgBeo2yfTr7sGDu83EO0w2J3X0Nq+kZoXIiDP17NtxzvQ2WXYrLXnRL
        Xmo5T4rnUc8tI3oxOQLjY+k87Q==
X-Google-Smtp-Source: AA6agR5VvcCXGzWQESlA+LLQuf2ieHTUv+0KU0BzRwd+V6NbSjvJ0o3/pRpLlVr4iK7FMU49/1c9LQ==
X-Received: by 2002:a05:600c:1e88:b0:3a6:2ca3:f7f2 with SMTP id be8-20020a05600c1e8800b003a62ca3f7f2mr5334042wmb.7.1662037062715;
        Thu, 01 Sep 2022 05:57:42 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:42 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v9 25/33] dt-bindings: crypto: rockchip: convert to new driver bindings
Date:   Thu,  1 Sep 2022 12:57:02 +0000
Message-Id: <20220901125710.3733083-26-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The latest addition to the rockchip crypto driver need to update the
driver bindings.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/rockchip,rk3288-crypto.yaml        | 79 +++++++++++++++++--
 1 file changed, 71 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
index 8a219d439d02..b7870a4cbdbe 100644
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
@@ -21,21 +23,82 @@ properties:
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
+            - const: aclk
+            - const: hclk
+            - const: sclk
+            - const: apb_pclk
+        resets:
+          maxItems: 1
+        reset-names:
+          items:
+            - const: crypto-rst
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
+            - const: hclk_master
+            - const: hclk_slave
+            - const: sclk
+        resets:
+          maxItems: 1
+        reset-names:
+          items:
+            - const: crypto-rst
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
+            - const: hclk_master
+            - const: hclk_slave
+            - const: sclk
+        resets:
+          minItems: 3
+        reset-names:
+          items:
+            - const: rst_master
+            - const: rst_slave
+            - const: crypto-rst
 
 required:
   - compatible
-- 
2.35.1

