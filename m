Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0AEC6FD1C
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Mar 2023 11:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjCVLpu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Mar 2023 07:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVLpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Mar 2023 07:45:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EE75D249
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 04:45:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o11so19018198ple.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 04:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679485543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45NVBVpYiF52cvaoHl0w4JJTLlfK1ZDLXhzA7w3zmPk=;
        b=QCpJz+I0YyR3Y8UkVEK9iQ/AZAdzUodv2rQnOxKrEWSDxgDV8DY3JtFwCbJO3t7JDj
         Hob3jgIEaE9lZrWnPa51rwhT6QLJPKYyxoWIx2O8OMR9uNx30QTb7rYeeeCvC3s13pgs
         FCOkhAlHaCtfQWJjPqj3eleMj1fK1fSQ+lnWysUNn8qgmb8OIbL5ZOeneaqpdiHptTMj
         nz5mMwZgXyKpHqt+brMwl2eWRlXy19BoENSXjZaGvpbN9i2H0hIUStbYS+rUbE5qztd1
         1dWyqLnzkSERcbqocR3FCVVj7pRHI7QTWS9cIOn6ruJMn5BMFfa9EmVoOGuHyWjOypwR
         mPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679485543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45NVBVpYiF52cvaoHl0w4JJTLlfK1ZDLXhzA7w3zmPk=;
        b=Ye/AYzheQvEvi6UM4QZTJX0gIftOTf0l0eQMGDs7z0FQxOs3MZu0+hVjUWLIx9b6XP
         rCsOzoFvHDvxJzBznVvYkw+JuoourD6089d3ikXB4QB+Hs2ogHV08mj+RDwlO2G0Irbe
         U4i29S86zGzsigF4cwk5EtQHzipQdbIHx3b02llGKbrC6rYrxlqOiTPIeJNwS0OsfwJc
         RYjvo0N/ncGmEahesy0OXdIzA5VnWLTyc5pRhP4D9kK0AyeVvcpo9NJ8QO7ntvBY4aIq
         iEB2DNfB9dGCmkjbGbolpion5u+Xj37HWjID/ybkFvKDSxP/jVYzhgvRh8t/PEf2R6Ez
         XtMQ==
X-Gm-Message-State: AO0yUKXmSl9KUDZ9Q6pW9+eoJPS6xMx4uCNLv/xR3M7TkB3FMtmiYgJp
        bQvAR8eXt9KRnQ6V5tNQpMaZwA==
X-Google-Smtp-Source: AK7set+7LE4DiuKvUMqEeTlogwTHF5bRE41vSvH34T1W4F5A9KNupKEL1ddxRbsh/OcpIErQ4Jog8Q==
X-Received: by 2002:a17:90b:4c43:b0:23d:21c9:193 with SMTP id np3-20020a17090b4c4300b0023d21c90193mr3430944pjb.2.1679485542718;
        Wed, 22 Mar 2023 04:45:42 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d4c3:8671:83c0:33ae:5a96])
        by smtp.gmail.com with ESMTPSA id jd1-20020a170903260100b0019b0afc24e8sm10386649plb.250.2023.03.22.04.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:45:42 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v2 02/10] dt-bindings: dma: Increase iommu maxItems for BAM DMA
Date:   Wed, 22 Mar 2023 17:15:11 +0530
Message-Id: <20230322114519.3412469-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230322114519.3412469-1-bhupesh.sharma@linaro.org>
References: <20230322114519.3412469-1-bhupesh.sharma@linaro.org>
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

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
index 624208d20a34..5469c9c2a1df 100644
--- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
@@ -46,7 +46,7 @@ properties:
 
   iommus:
     minItems: 1
-    maxItems: 4
+    maxItems: 5
 
   num-channels:
     $ref: /schemas/types.yaml#/definitions/uint32
-- 
2.38.1

