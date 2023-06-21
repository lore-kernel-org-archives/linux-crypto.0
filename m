Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29E8EB64DC
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jun 2023 06:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjFUGmu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jun 2023 02:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjFUGmt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2023 02:42:49 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC2910E6
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:42:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-978863fb00fso856487866b.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687329766; x=1689921766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SoN7Ok0SKP6e+nvIGPL/uYRmtK4NznFFx8jgBVW/pBE=;
        b=AbD59zvH1tTgwvomAGUGfyLAWF3DAthn6QVcEsI+AByRTknJ9nIVZyjFobgZOsCVW7
         cVLERghOduu+RFbvXBlN7r9wHr1/i9+4hJ7M1SczfyrHO23otQxTmGX9D5Z98iVan28P
         EdIG2XOGZ7RxmbVwwGdYIAl4cQiJuqeNLYnltZkn3dgIOmz7vR+RxdUkoog0i4/RSxmZ
         AjywleZgvHZOj0+oUzDc0f2ssSug4MIzqPTXUzS06ZGjJlJg2G5F/D6AROqSZvxiwKnc
         m9rEaSDFV8+Z5ymev4EIeMIw8GP8QoRjqZ0nlRtx8I2Z9y7AlbDh2TleJclYlRawcNa7
         Kb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687329766; x=1689921766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SoN7Ok0SKP6e+nvIGPL/uYRmtK4NznFFx8jgBVW/pBE=;
        b=kNBKGCPlb/fu+sroovVMi3V5Me1uCRIHcebvinSrO2YVkNd9H5Q7XlX3omIukQdem/
         lW3lXx1JToRhdRUfqbVtE8QNSCNIQ2t5EQkZYS+9RmiKQ4YiyLTq76jN/ab+2m3VWicH
         1dKWTir+F4unhbfg2/pj8vGn+UWxewGnHtw4EJ9aNYQLbSJIDFazcTFQE2f5xjyO6hcA
         7xO32+ECef2vxDIw7J9LNM7gg1VMu2hf1I+IFPbtz5OrkYk3FOJbD2I61MvC04Xk12qu
         F3BfzjklILo5m2eT77BSuV+4pvFx7XCgjenAXBz2teeb9owsOpAl80ub7q8wF/m9+OMw
         GmDQ==
X-Gm-Message-State: AC+VfDx9Juln0AEnEK+JpMPsdBbZY+mfI/ZPXbR3UpGWL4x5G18Gvw2F
        ConKjlF8GWbHMTzaGOx1d8A3nQ==
X-Google-Smtp-Source: ACHHUZ7/YRtI6xTdzg7eKWCRpduuZtiAGjXikYaa0aAlnnfaWsyaDbSoYbh0y2HyCIQ8aMTBS9rOtw==
X-Received: by 2002:a17:907:3e0a:b0:8b1:7de3:cfaa with SMTP id hp10-20020a1709073e0a00b008b17de3cfaamr14522289ejc.3.1687329766084;
        Tue, 20 Jun 2023 23:42:46 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id z17-20020a1709063ad100b009821ce1ea33sm2549254ejd.7.2023.06.20.23.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 23:42:45 -0700 (PDT)
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
Subject: [PATCH v2] dt-bindings: crypto: intel,ixp4xx: drop unneeded quotes
Date:   Wed, 21 Jun 2023 08:42:42 +0200
Message-Id: <20230621064242.9038-1-krzysztof.kozlowski@linaro.org>
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

