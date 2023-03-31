Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC21AC77B6F
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjCaQpV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCaQpE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:45:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0237C7EC3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:43:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u10so21759438plz.7
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wgd39WnlXQz4tbC4i1NLP3F+sroosdBDzPGDIcLrLlo=;
        b=T6LwrBpZBlSDlLaXwtNMnDKJwfBivOvvmenmVRj1msSrG4nrSMx0xry1DhpgJIaS3y
         bz42OmdWMnzIILNT4SYz166gpg8+wZW/PKiTeBTKY9ZqFlkK4OE4D1T084ANV13SwkrG
         jTQajOdzNiP6odJmO0L4yPFLO9e2RvlYFTJSKOiWaeJ/8HqgkLX82FwwEWC1rChl6aLC
         k21/XEgQ4OcibpohIb7yLyuYK2Vi5aoKmJXpmqLYlMxN2d/6/unHhp0OnQxt6s4mHPTl
         Ba6ybeyaXNutFfhVn6kogJTKxopD1xrBnII79KSWBFr7W6WASwXB+fWGN06d9+Ig+wrF
         drHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wgd39WnlXQz4tbC4i1NLP3F+sroosdBDzPGDIcLrLlo=;
        b=RztqsMx0f2JcktuboT8/+7zi4nyWi/YFkCNVn8shEEHuX3n/mz1vJbPnpMUW5UMTs2
         5HsDSiVqZWTaInnfiB99EbxBg3/Yv+qL+uO6+KkKCHizdSNFORXalzg3BMMnRF8F6lY3
         2+mK0rtQhZCzc2sOIh9X2mzmiQJrczdnMGwhTlMEmgfffIlnoAEVoUXeN8UQNsTbfJWv
         ImcOSGAWy84Ra9c642jwhBDrdLhMomx438KwvH4828Fq2iRGebqHeSf7ymnc/wT7LaJ6
         ZmffHRpHYf65lElwyiCf/bDwGJDMdaKPdgEfaP06D/9fAmTGKj6KJd8VQ5jMh3/zlzdf
         jESQ==
X-Gm-Message-State: AAQBX9diiX/ZZJcqVlyUovnVDyD87OZRK9bTVjA9Z/K7/HXgfTI2dJdT
        aw/WNRqR9zZeBlEzTYZaSZritg==
X-Google-Smtp-Source: AKy350bIjZHRfW1uqNsImLTp6bWMpGVbFLVr+SEmEmYzN7xWZMsVSQUhAU3AeWmpD4zbf9rqRxdOrg==
X-Received: by 2002:a17:902:e1d3:b0:1a2:9183:a49c with SMTP id t19-20020a170902e1d300b001a29183a49cmr4782053pla.32.1680281023592;
        Fri, 31 Mar 2023 09:43:43 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:43:43 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v4 02/11] dt-bindings: dma: Increase iommu maxItems for BAM DMA
Date:   Fri, 31 Mar 2023 22:13:14 +0530
Message-Id: <20230331164323.729093-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
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

