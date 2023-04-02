Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F064C76196
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 10:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjDBKHi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Apr 2023 06:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjDBKHg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2023 06:07:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C587FA256
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 03:07:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so27745166pjz.1
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 03:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wgd39WnlXQz4tbC4i1NLP3F+sroosdBDzPGDIcLrLlo=;
        b=s4g1ikQ+ejs90B/h+ovPQPulj/2nnkWFkwF/BWJhTgGHftvFNZnL24rvn30DXcNU50
         nnAL0fowvVZyVv5jbVqQSCokgGs6oa4xgi74jaRbXdfS3hM7xqyOuLKbxRp9RJJe+NwP
         qHCyhVg8yVCCsJHUMvX3ev6XhKqkCyk8M+d3P0Mvigr9uk5uy+bPxxOZ+mtB/Ytm0PFG
         8lcbogFR8mCIxHH+/6/hSzcxnpTmQQ5yx+gRIyNEsVwtlcGXGsWuf1F43ETKUcjeCa4h
         wleDwDhBwFqkXKx6lgitC9ACgb0bkVhzO6zfyThTvLxYEDr2bbIVfrnV8IP6x4mG+xS4
         28kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wgd39WnlXQz4tbC4i1NLP3F+sroosdBDzPGDIcLrLlo=;
        b=GWusGIIv7hjIl3dYTWTYeTWLzHa4ev8Bnre8l/zAupQYJ7hTrDk2oWlFHSsE02BGso
         cUQAAXVet/Jia13SViv1LgJyCjGPuoZnjAKMxSXbLbhWDLbBKT530KMky1zURz7BGz5k
         OJkoJpC5bDL7hKXBBNVmHna+ZxhJwFkkGpZeX1nSfJgxtd+ummRN2oQtm75t9DGYeGDe
         Wz4aNAa+U6KInYBA1cZG80yt5H4mVdne5HR+RXmDhsLU6N68RgVuejUZy6gLugMhKAnN
         8qDehAs4zRxD2p2UghbD1vwHJ/eLD5uG3cz3EZs/15/Huvt2wNCt4aBCaMC9mL3eYaOK
         jVNg==
X-Gm-Message-State: AO0yUKVNX4bZu7uklnfS+7zxWSdFMIj8J1gHc7k7MQ8Ae0GCsbtbLTda
        RG8Q2SK5e35FxXUwW49iQtpbxA==
X-Google-Smtp-Source: AK7set9kCxxfQ4C59fJFyCT5aLCMfMeEI0o+RAvOdLaYmW91DsAXt1m3mFm2bW4qUJDjDKk7LuQM6g==
X-Received: by 2002:a05:6a20:2e90:b0:da:2fdf:385e with SMTP id bj16-20020a056a202e9000b000da2fdf385emr28030089pzb.49.1680430048593;
        Sun, 02 Apr 2023 03:07:28 -0700 (PDT)
Received: from localhost.localdomain ([223.233.66.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0062dba4e4706sm4788739pff.191.2023.04.02.03.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 03:07:28 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v5 02/11] dt-bindings: dma: Increase iommu maxItems for BAM DMA
Date:   Sun,  2 Apr 2023 15:35:00 +0530
Message-Id: <20230402100509.1154220-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
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

