Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0350AC77B7C
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 19:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbjEZTWm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 15:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjEZTWl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 15:22:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CA0194
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:22:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b011cffef2so9242595ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685128956; x=1687720956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrjvdZSqXKi+MzhLUYpp9EjIDqVatd4GVNSMEpyYnzM=;
        b=HTFoP4m/KzdkNWwsXmOkyw8oHw3x66dQjBNKv5POjSNBeIlLOuM7UCjCf15eu3hiXY
         W0JzoeIac8HudaGgcWYGRPf7w3rYQC2JR4896NrFutHzV9M5KRzhc+KAYFZ4UGT7bTBj
         VTbb+hyZvo5PiLzVDP1C1h1Z9MXVWNcWQZ9WLMB4LkbV9TBUy498c+cYLVScqo5cdZq9
         YzSZ0uKE9V/RN7wuXkfsyBjqUjk5qpEWOC8L9JKzTR31Xih/qODE96T5YItlJjZzlK9d
         7OdR+aqHoJXlAOenOC3DM57WXruMmSOwSUEwmG9dmt4RbRVdUYmPg6pEJ+hzd7gHqqO5
         KrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685128956; x=1687720956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrjvdZSqXKi+MzhLUYpp9EjIDqVatd4GVNSMEpyYnzM=;
        b=WAo4MOKx9ROvY5f6e4r9DnAyVypGLbDWCjF5ncXqEvi3bLOHYVErTZPrOJDdxKSep+
         6MKf8yVi9aAw0/x+7inVJowIi8/Wzah3rd8UgMn+8/AMKLyPvHjaDmTxYuvax1YA/ywB
         ULzt+byIOz4SkU67l8M4z7uFO6TCtNZ0i12AgtwtER8BknORumivCOR9mljB/OEP0KKN
         o/lSQDlJgAGXvbZSV5NLriNF5QwhI59a6ARGf/ODv3mrM3+MwrknQCnB+HqCaCHuati3
         e557HAm5Jf8WyAx6iXBM+fAeTRiKYIsTugSUpoenzNR0EaSwmqEXUdPw3t7KO7zZBmc9
         QzQQ==
X-Gm-Message-State: AC+VfDyQzg4T7jZ91ZTgLXK6JDEcBnelGT9NTsoLMAUzWr+uxXqrZI4J
        OoND2vfE/kGo9hhK/oCrI14iLB4YUV3p1oH1/bY=
X-Google-Smtp-Source: ACHHUZ4UArCDjWuEi+cSUtH0hktf8DnI6jWN5twY18OKujfYmlgy7/MVEUVN4Sfe6pUoZjmI3d2ylg==
X-Received: by 2002:a17:902:eacb:b0:1a6:84be:a08f with SMTP id p11-20020a170902eacb00b001a684bea08fmr3481356pld.64.1685128956253;
        Fri, 26 May 2023 12:22:36 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1f3a:6990:1a5c:b29f:f8cf:923c])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b001b008b3dee2sm1955079plh.287.2023.05.26.12.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 12:22:35 -0700 (PDT)
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
Subject: [PATCH v8 01/11] dt-bindings: dma: Add support for SM6115 and QCM2290 SoCs
Date:   Sat, 27 May 2023 00:52:00 +0530
Message-Id: <20230526192210.3146896-2-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
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

