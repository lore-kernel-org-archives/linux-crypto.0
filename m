Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12A5C77B75
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 21:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjESVst (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 17:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjESVsp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 17:48:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBE41BD
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:38 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643990c5373so3876473b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684532918; x=1687124918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrjvdZSqXKi+MzhLUYpp9EjIDqVatd4GVNSMEpyYnzM=;
        b=pBd3boQLdDsk/iHX9oocj9sS4niYD+XavQIXBumLygIMmhc7YIwiabWjY/EEoChLus
         eMqXOEJJd2JZIJ52NhSF9LK0lIPizzpTwTHAH9477UEY46kqCufDHzK+g+xh9o9Q6qn9
         SNsJuiF/pTcpfxeFlZvuv1ycupJ4WaFQILj97fx+CO5hsHytVru+1RI3IqjVkHFyH/TG
         BLIztj3e6muB64hkNgdIj8yLJ6j44WH0zh1wC6lmDJmeCfWFFVKYsLJKn9/w+ZIvSQ7+
         0fg1H7g/9HiyKN5QmyuQGaPC17YriWCQ6qJsUOZkqUqC6Q8AJL26BkBR2tttwmIp7bSC
         fvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684532918; x=1687124918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrjvdZSqXKi+MzhLUYpp9EjIDqVatd4GVNSMEpyYnzM=;
        b=DBK8RoZn4P27zLoEnXhZHikszHufOOZsAt82qF3WnWTbuXvcoVbUmUOnSE2pUFDKOg
         pUW9dFPCb5/FdF/zSkRXNGeq5+RkO9lE1FRTtY6E2GaKP83k+R+jv5yLjbDybRRFfqiJ
         w3zhlZk9q6IiSfMZgpO51HRdTK8A74Q7Av5VqhxRW9QlMOO5uzdpfB3FJ4Xm5W6ulm0U
         sA4Ryu3Lj1LgrBdsh1c5aqib99CWp49cH6Gdo9nHqKKtjUSuSRh1jeTRgs7gjKSsFMcW
         OgFmREl8Rwj9+fsuYbycn8KKNJELZXA8APAl6TgFRhP5Y2HZVQldBF8LrMzmJ+6bvmAd
         PGmw==
X-Gm-Message-State: AC+VfDyS5WCHjcgIXnaLZZssR1unB6VhH3ZjEaSagZHTZKhNusu38AZ2
        Gi6XN371bgBaTebLol0rWnUWDA==
X-Google-Smtp-Source: ACHHUZ6zYvyzW6Sm+sId1NG82PIvhupYQToF3JqgV+EZpxX154ll1oMSHcEFbpnv4xAyHo68EdghIw==
X-Received: by 2002:a05:6a00:842:b0:647:4dee:62a4 with SMTP id q2-20020a056a00084200b006474dee62a4mr5070407pfk.34.1684532917890;
        Fri, 19 May 2023 14:48:37 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d309:883d:817e:8e91:be39])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b006470a6ef529sm144891pfo.88.2023.05.19.14.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 14:48:37 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Rob Herring <robh@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH v7 01/11] dt-bindings: dma: Add support for SM6115 and QCM2290 SoCs
Date:   Sat, 20 May 2023 03:18:03 +0530
Message-Id: <20230519214813.2593271-2-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
References: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new compatible for BAM DMA engine version v1.7.4 which is
found on Qualcomm SM6115 and QCM2290 SoCs. Since its very similar
to v1.7.0 used on SM8150 like SoCs, mark the comptible scheme
accordingly.

While at it, also update qcom,bam-dma bindings to add comments
which describe the BAM DMA versions used in SM8150 and SM8250 SoCs.
This provides an easy reference for identifying the actual BAM DMA
version available on Qualcomm SoCs.

Acked-by: Rob Herring <robh@kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/dma/qcom,bam-dma.yaml | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
index f1ddcf672261..c663b6102f50 100644
--- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
@@ -15,13 +15,19 @@ allOf:
 
 properties:
   compatible:
-    enum:
-        # APQ8064, IPQ8064 and MSM8960
-      - qcom,bam-v1.3.0
-        # MSM8974, APQ8074 and APQ8084
-      - qcom,bam-v1.4.0
-        # MSM8916 and SDM845
-      - qcom,bam-v1.7.0
+    oneOf:
+      - enum:
+          # APQ8064, IPQ8064 and MSM8960
+          - qcom,bam-v1.3.0
+          # MSM8974, APQ8074 and APQ8084
+          - qcom,bam-v1.4.0
+          # MSM8916, SDM630
+          - qcom,bam-v1.7.0
+      - items:
+          - enum:
+              # SDM845, SM6115, SM8150, SM8250 and QCM2290
+              - qcom,bam-v1.7.4
+          - const: qcom,bam-v1.7.0
 
   clocks:
     maxItems: 1
-- 
2.38.1

