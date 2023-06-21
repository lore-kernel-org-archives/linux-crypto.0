Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FC8EB64DC
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jun 2023 06:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjFUGpK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jun 2023 02:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjFUGoR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2023 02:44:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90517173F
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:44:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51bdc87feb1so321190a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687329847; x=1689921847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KLhuYBOrCGZ9ZaT1QeXqsJlpupUNcxV0EG+wQuDPKQw=;
        b=sHahl3Ns/0u4RvUhMZoO82Sf8PQLmLQRcnsEw+UnGJ2UXm9Itr81iLndou4in0y4yL
         B7Fnl6luepVR3ZkaljBUUHpTlBoIgMYAm2ZXukNuS4UsT2/ZzIEN5YbqgzqnEIw7rQdB
         KVSbIbiVS6sje9wsJwa7clEYk6aRNb9AImCrMgbSh7o9+ARkCft1Q6GIL7wIkDSAd+3t
         MKJRlyKYkAKh9cizvZxFXRgwf7enoYMkWUxwE2mqVsiP6jWbTKmtlhiP6BkHDkR1FUBJ
         cpLfI1EKC+A1fys2icQILjAMTha+qpo2tzcEuuv/LYSOYXjtjY5QCRjBHJH9a+FSR/1S
         yuQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687329847; x=1689921847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KLhuYBOrCGZ9ZaT1QeXqsJlpupUNcxV0EG+wQuDPKQw=;
        b=fUgLI9sW/kc47UH9LnmOlKNAi+9AudccOoU1ZWb7trKkvQedvGhqOgLit0C+IPLOnv
         I7++OO90idqtPXRkMO2XqTBB9tghuB4FKjEq2f98QA45QUJnT7hrm08w3W697LmqCsIL
         E3npKeRkV+LXWdw1wpdwWOc4j9q0EvJ2Mh9B1WFH9PF9YNlsGj0tYmQ+KSZbFsHpvfzi
         +RwcIgs3P3Z80ataoMRK57oNhYDNQ8/3gJSqCauAQ3DNKYCXdXl0+t1ByQu2dInxqYij
         52jaLwRFtOQS1wdrWUDIC9Dexx/2GZLfCPIy0tmpK5wUKBbXba3omlt1OxV5EO3kpWQK
         aaBQ==
X-Gm-Message-State: AC+VfDyU2NruQgBaLqgAlChXPzVGZrIUsr9FnO2+N564uhaO7EjsZgeq
        F06Hwk/FAMr8LzYHFpX2WbWzXg==
X-Google-Smtp-Source: ACHHUZ5HMbDgNgoWNS0rYY+M0Ya51PmC/vKM8zoehNU+Uj/SEm8quQRkfO01i2Q/6Mlmvdclu4xmcA==
X-Received: by 2002:a05:6402:517:b0:51a:53e0:843e with SMTP id m23-20020a056402051700b0051a53e0843emr6666844edv.23.1687329847026;
        Tue, 20 Jun 2023 23:44:07 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id l9-20020aa7c309000000b005187a57fba1sm2109428edq.77.2023.06.20.23.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 23:44:06 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3] dt-bindings: crypto: drop unneeded quotes
Date:   Wed, 21 Jun 2023 08:44:03 +0200
Message-Id: <20230621064403.9221-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cleanup bindings dropping unneeded quotes. Once all these are fixed,
checking for this can be enabled in yamllint.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

---

Changes in v3:
1. Adjust subject perfix (drop ixp4xx)

Changes in v2:
1. Drop more quotes (also amlogic)
2. Add Linus' tag
---
 .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml      | 4 ++--
 .../devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml     | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index ecf98a9e72b2..948e11ebe4ee 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -19,8 +19,8 @@ properties:
 
   interrupts:
     items:
-      - description: "Interrupt for flow 0"
-      - description: "Interrupt for flow 1"
+      - description: Interrupt for flow 0
+      - description: Interrupt for flow 1
 
   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
index e0fe63957888..a4006237aa89 100644
--- a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
@@ -2,8 +2,8 @@
 # Copyright 2018 Linaro Ltd.
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/crypto/intel,ixp4xx-crypto.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/crypto/intel,ixp4xx-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Intel IXP4xx cryptographic engine
 
@@ -21,7 +21,7 @@ properties:
     const: intel,ixp4xx-crypto
 
   intel,npe-handle:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the NPE this crypto engine
-- 
2.34.1

