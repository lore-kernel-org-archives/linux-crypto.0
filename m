Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548C0C77B7A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 21:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjESVst (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 17:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjESVsp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 17:48:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459EC110
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6439f186366so2802439b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684532924; x=1687124924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeTyHFbJy5rhBfWD0hnvFzbXupDmLYxqq1Exk7EAP/w=;
        b=ColBuOzXXjCFMQOjtPodYD3uMQb4rjLPliuKPNMFxkYd6hOM8gmj/IeuhPJ1qz1CM/
         boorjeMp1fdHD/EXR+4jz9S+6sRQ8ESfS6CGwHBPCcB9ii5A0R/Zwtt5xSD/q4i8jCWg
         lJjOeJ+g6hPitj9KHtfagBPsDMHeXyFpYS1FXJV5soy4RPYU5lt/POhvdnfCd5jUtkR2
         7wxJlyy1itOV0JwbmvGHfeuIAN8teTep2iY5r7AkVh24Z3KwpM3xQo+edQHohnUMIdhC
         EiMYxCSewqZos4sUX75xKzYydGBytRqLbmwN8gw5sUuepkb+RIVLDPIMzaGzRdPzAbpa
         SJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684532924; x=1687124924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeTyHFbJy5rhBfWD0hnvFzbXupDmLYxqq1Exk7EAP/w=;
        b=FBi8+ebomEdFGarfSY9Yy+pnFJZWK476Whjg6+efFDawgtuF4SjINMlVgngA6bHvYk
         Vd9tvPjr1wCCad1zZ0MW++oFH8VPfMpgUZ8GoEh5FvqpBk35nIbmszvzjDJCmlBisjF+
         YJx3lgTpKuWfh6bKrgLbB6ws0kpYjr0obdwUEewYWkKmDtNT3y4IW8xXDDUNMJR0Iqkk
         qlcOANgM5IA1Z6zv9Hpc661D6I1lO68X8o+W7CKa06hlpsdD0D2lZEgvXFnRmzJWaFSZ
         i+VJc5cvoFX67GIrADqdOffEfGogH0okHcQnRKx/e5pjaUXXg2Wh9TRxUuz5g7qWQahQ
         T2hw==
X-Gm-Message-State: AC+VfDxPUA6LuM+l3Vnr/keovGbcW43tywMwxeoGkp1PL6HusdFoEEaW
        lblZdv5nQ89b00A5B4UUpuPlxA==
X-Google-Smtp-Source: ACHHUZ4d+RiqifJAN9YQvB4N1d4cj3vhVizoU37NH5TZBiMe7gQBz7emVyepjc7c2ZZZXOG2gtOxeA==
X-Received: by 2002:a05:6a00:1389:b0:64c:9b56:6215 with SMTP id t9-20020a056a00138900b0064c9b566215mr5339887pfg.25.1684532923753;
        Fri, 19 May 2023 14:48:43 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d309:883d:817e:8e91:be39])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b006470a6ef529sm144891pfo.88.2023.05.19.14.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 14:48:43 -0700 (PDT)
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
Subject: [PATCH v7 02/11] dt-bindings: dma: Increase iommu maxItems for BAM DMA
Date:   Sat, 20 May 2023 03:18:04 +0530
Message-Id: <20230519214813.2593271-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
References: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since SM8450 BAM DMA engine supports five iommu entries,
increase the maxItems in the iommu property section, without
which 'dtbs_check' reports the following error:

  arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx224.dtb:
    dma-controller@1dc4000: iommus: is too long

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
index c663b6102f50..5636d38f712a 100644
--- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
@@ -44,7 +44,7 @@ properties:
 
   iommus:
     minItems: 1
-    maxItems: 4
+    maxItems: 5
 
   num-channels:
     $ref: /schemas/types.yaml#/definitions/uint32
-- 
2.38.1

