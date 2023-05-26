Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2073C7EE23
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 19:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbjEZTXX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 15:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243826AbjEZTXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 15:23:13 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB79E55
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:23:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b010338d82so7373025ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685128988; x=1687720988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prFhwvSxBQ/UQ8d4CbWdnfwjRcrN8xUyHXxMGOEWxfk=;
        b=NZpF0bEaiJ64NKcd0IR9qeUnMib3NkOs5ZN6tMGQtVc6S9eyXNxuLqp36iIypZKrEs
         t+FAvfflBOhUraeyz5P0Vf/rt2pVio9P3b/l5xFrqajyS5X4L0WBxiZMNLvcARzlW5j4
         xvIvJr+U63Ed26XkG5Pfz7Rzy59JuUXNhVA5PGSSNJ70W/OYmgssepxSbYFdtflV9vaZ
         bZYPxzU0Ia+/zpWxFv1QVbL2QlF24Hi4yUMpxaJD9QmQXt0MW4oY0rWB4dWOzn75jkbU
         e/BNCajd5h8EByWnBb7qXGp2f4+d8lWKyLjck6LVM2kq8aBWgg1/qJlpy7BH7l41i+EZ
         Souw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685128988; x=1687720988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prFhwvSxBQ/UQ8d4CbWdnfwjRcrN8xUyHXxMGOEWxfk=;
        b=X4EhMnEmcQ13dtrxk/r24PXWS6rMXa7RT2hrZfjv0GHT0/ZSOavAPhMvynvryFwb4V
         h/ngc5VLPYf+p4h574xCm9SU6k7r7MBm8uC1hXaCliWROtrFAjrSj/lDhWyjCMWZgvay
         hVRso+Zn64pUeUCruYF7aBg0uljE4fHJtlYSI6EfkRMeLAaxjahcW5NT1rDxjvMCiZXm
         eSxW8MLj30b842BX1VfupvqRMAZwF9JB/sftEyhaouYtt56Wqb2+Ctw1iKWRPkMy48zJ
         HxfVyiwe3B9ODYKXjQDOMpOebio5Pnu5ExPwDsDuFwG1IT7kVO9t9zDynpbiRmzlGcyO
         B41w==
X-Gm-Message-State: AC+VfDwVuLj0BUFiYPXPjgtn+6odwhxyxabPDp+ihx/jqB8kLsmgAWAs
        /zWkliJFq3W0JZ9dXy4lTw/SBA==
X-Google-Smtp-Source: ACHHUZ60c6AQTj4K3Aeo78Ha1u4XyOFEb9uQ4viBNyubuHN3rC3+0L5JFqBYaNSBovMUc2Xk8c8C1Q==
X-Received: by 2002:a17:902:d483:b0:1b0:12e:3bfd with SMTP id c3-20020a170902d48300b001b0012e3bfdmr4463175plg.7.1685128988620;
        Fri, 26 May 2023 12:23:08 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1f3a:6990:1a5c:b29f:f8cf:923c])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b001b008b3dee2sm1955079plh.287.2023.05.26.12.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 12:23:08 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH v8 06/11] dt-bindings: qcom-qce: Add compatibles for SM6115 and QCM2290
Date:   Sat, 27 May 2023 00:52:05 +0530
Message-Id: <20230526192210.3146896-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The core clock for the Crypto Engine block on Qualcomm SoCs SM6115 and
QCM2290 are provided via the RPM block.

So mark the compatibles for these SoCs to indicate that only 'core'
clock is required for such SoCs.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 44 +++++++++++++++----
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 90ddf98a6df9..bb828068c3b8 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -35,7 +35,9 @@ properties:
               - qcom,ipq6018-qce
               - qcom,ipq8074-qce
               - qcom,msm8996-qce
+              - qcom,qcm2290-qce
               - qcom,sdm845-qce
+              - qcom,sm6115-qce
           - const: qcom,ipq4019-qce
           - const: qcom,qce
 
@@ -52,16 +54,12 @@ properties:
     maxItems: 1
 
   clocks:
-    items:
-      - description: iface clocks register interface.
-      - description: bus clocks data transfer interface.
-      - description: core clocks rest of the crypto block.
+    minItems: 1
+    maxItems: 3
 
   clock-names:
-    items:
-      - const: iface
-      - const: bus
-      - const: core
+    minItems: 1
+    maxItems: 3
 
   iommus:
     minItems: 1
@@ -95,9 +93,37 @@ allOf:
             enum:
               - qcom,crypto-v5.1
               - qcom,crypto-v5.4
-              - qcom,ipq4019-qce
+              - qcom,ipq6018-qce
+              - qcom,ipq8074-qce
+              - qcom,msm8996-qce
+              - qcom,sdm845-qce
+    then:
+      properties:
+        clocks:
+          maxItems: 3
+        clock-names:
+          items:
+            - const: iface
+            - const: bus
+            - const: core
+      required:
+        - clocks
+        - clock-names
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,qcm2290-qce
+              - qcom,sm6115-qce
     then:
+      properties:
+        clocks:
+          maxItems: 1
+        clock-names:
+          items:
+            - const: core
       required:
         - clocks
         - clock-names
-- 
2.38.1

