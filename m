Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2D4C761AF
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 07:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbjDEHbC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 03:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbjDEHa5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 03:30:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E2146B7
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 00:30:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d13so33112416pjh.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680679855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/g4kaJcKEIEGpxh3HTZ71OY8Yt6EI1bEj6s43nrskNY=;
        b=D364yvfyqZBI9m7sjZ2pUoOrnPu3/Wl0SDkfXycf+1ytSsKjfhFTeDY099SOcdsalQ
         0WSeXZ2JJ8ofqJ7Fl1161CRMZ3+Oky/ez/UwWzIrOc/pvYZpAIj2KwGmwKAx3S2muJtO
         eBIWKak4YYDsCZXb5RiugbzUrh2iYm3+5NTlBI/TmZ3CiyGngd0C7h6QK7rBPhoYEOk5
         3nDQZYu0IcCm3NFXXbgLe7PGFx7E2ItpSkAsp2g1BCIR/7DVKiICgIF0gXp6Vbo0Jt6o
         L2gnbqYiHk4Spldf1caoALNOj2mLV+jF/bDCQYG9HdeCCIYZl8POhFNO29SFuNtRGLLx
         auZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680679855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/g4kaJcKEIEGpxh3HTZ71OY8Yt6EI1bEj6s43nrskNY=;
        b=wqX73exagZRbryAa48j808VqYgREjjv+PRRAkf5YJtkMmOyyRMw9+0+gG4LSGd0suH
         rZFoIEgyANJ7P5Ih6mwcu4OtVippiiH83V4DNAqPnpO7TJGhrzsBAe3awi5R1lTUbOZP
         b3t9PpLaYf6uSgXCZ+lW1YimiHtuzT9dgXxq+38rYpVmgaDJkftm2eVI3j8eOKubM9ee
         0ObBZ0Btb8z+w78OaMwoyGUsRCgOeCZcraPb7Bc3Vc7riwOvvU8aHUalkgGK1uVisEqD
         EZZEHTyEW5qcJ1UQ15zMZK1KBdv4DwLWFKfoPuVil+Dk4WRRNWlfAdqNxzRRg3bXXOiu
         Ov3g==
X-Gm-Message-State: AAQBX9dgMNvaSYtcpLQszhEQO4vIE3R1mPy/qPrFUKnDt3rFApsXOzUh
        iyVcHx1rhAfYVfBSqWU+y5UH6g==
X-Google-Smtp-Source: AKy350Z6wOMil4uJ6TjA6UdhREn/zFJj31DX1KZ3FwORjRmPTob7/irK2hIQ7qN5G8Evef3XudQ+cg==
X-Received: by 2002:a05:6a21:868f:b0:d4:fcb2:7966 with SMTP id ox15-20020a056a21868f00b000d4fcb27966mr1766853pzb.11.1680679854890;
        Wed, 05 Apr 2023 00:30:54 -0700 (PDT)
Received: from localhost.localdomain ([223.233.67.41])
        by smtp.gmail.com with ESMTPSA id l7-20020a635b47000000b004facdf070d6sm8781507pgm.39.2023.04.05.00.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:30:54 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 01/11] dt-bindings: dma: Add support for SM6115 and QCM2290 SoCs
Date:   Wed,  5 Apr 2023 12:58:26 +0530
Message-Id: <20230405072836.1690248-2-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
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

