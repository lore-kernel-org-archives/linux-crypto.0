Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78299C7EE43
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 14:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbjFIOIl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 10:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240549AbjFIOIf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 10:08:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87CB3A8C
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 07:08:08 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f649db9b25so2322809e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2023 07:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686319667; x=1688911667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rFrh4wlGw8fqzifmvwiSox8R6fD/3BKItknrEjhKA6k=;
        b=qc3PcBphPle0Qnl6wCqXAXmVXeMAjQl/D+j76Bw45bh6endmQBuzw23h7+w/7Ded6N
         gCe7Rexac7RF61MDwEJ4fEcS6mGwcNU/HSKA8yZ/AXEjoZesSx5efawrEvjwEojzZ/tO
         1LQL0wEZIpVRS3YSH0Ry7ES0ifWYLp57TZUEseM6r1TSjfAXrNn5GxlKkXBdDFbsn4h0
         /SX/AykOkhlr2kxpTrBuGrf0VtzwaMundsJhI4/wLMwaS8IbLYzh4eG7DZt42nPENwg2
         JMnnagp9Iwncxyea39ImYEH3IfwMBAl2dMlsobXeyZJEOk3cFxvJaWPAD3tuSdvpB0rJ
         LMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686319667; x=1688911667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFrh4wlGw8fqzifmvwiSox8R6fD/3BKItknrEjhKA6k=;
        b=S7lArGFl9GPtJX4/jqE8P17hC5xXteYW2e2fBplU6DkZwfXOtMfzyLm1KJ3kIax5/B
         xgQLl/T9YPNuPfxgZLM9AYFUqIX/lr3rf+rK+De2+RS004EPBMpUOH6sDTlZ7Iw8xGXp
         5YAy28OMXtsvDhe35plnB0svU0rEk5h4NUGtoi9gdcz1plG6VZFLz21qXl6dGGCXjTOh
         G+bN0mD7ScIUhhirjI+cPtehx5iP1A+uOFksOmIzV7wvjX3Ofn8DitObLQWVj04vojwh
         3B+Smp8+WlHkIKuKNf4IuHMauPDkatPsq2inP4BXDvNngH3sZTDgnIByMiw0uB09HCrP
         sVQA==
X-Gm-Message-State: AC+VfDzc6cd/oZFtUbwXkdzmpEU3UtVjrSQT9HkeBEdGF2DNAB9qCy0l
        T39m+6L7xe+vzHb5prf562zZEw==
X-Google-Smtp-Source: ACHHUZ5+Sh9UtA920DLVpsb4vHhRhwsfjCw7gLnHIOYZ/BANqVXrV8MdzIE1/XuSoTpoMEF1+NlobA==
X-Received: by 2002:a19:f20e:0:b0:4f6:54f1:ea36 with SMTP id q14-20020a19f20e000000b004f654f1ea36mr927952lfh.43.1686319667168;
        Fri, 09 Jun 2023 07:07:47 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id p4-20020aa7d304000000b005169ffc81absm1813885edq.51.2023.06.09.07.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 07:07:46 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] dt-bindings: crypto: intel,ixp4xx: drop unneeded quotes
Date:   Fri,  9 Jun 2023 16:07:45 +0200
Message-Id: <20230609140745.65046-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cleanup bindings dropping unneeded quotes. Once all these are fixed,
checking for this can be enabled in yamllint.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
index e0fe63957888..8e2d95d732ba 100644
--- a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
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

