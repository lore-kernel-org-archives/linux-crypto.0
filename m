Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6920C7EE23
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 19:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjEZTWq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 15:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242430AbjEZTWo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 15:22:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFA2198
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:22:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b01d7b3ee8so4413865ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685128962; x=1687720962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeTyHFbJy5rhBfWD0hnvFzbXupDmLYxqq1Exk7EAP/w=;
        b=ZL28kT6giCxmUR4KbNlszsaCvOIkmmxXrArlq9gzG28NUSNGZS0d060fkS8h/yG2ob
         p67OqTG14X94RPFNbEQn5uPRCkkt5MhdTtvGDmXiuk5Qt0Fj2LiBn8NvhQv3MIT4oBUb
         qIubhaxXsg1Jn1S73vFLcdu9T7jdRv3uer6F8L9M5juE9aLNe77K+5p5VcdfD+AbB3Gp
         F7RNCjOD+/hhf1jzqhPERjSpJOSwiOeLQf5Sk66YcUcK+mxx/u1BEAfnEulwx76XDmFQ
         CuK/OSB8BLs+/ToXrZI27HU7Y4S/4aT6Ae5DuE+mYQf0LXDW9Ea10iZgwKYjZKLFkzPR
         OT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685128962; x=1687720962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeTyHFbJy5rhBfWD0hnvFzbXupDmLYxqq1Exk7EAP/w=;
        b=OSE3FGa3VplJZu4jYpqu6yeJMz9XLfMefA0w1g1y1hrZ8Jw+WCz2Ljiu/JG5IYuP+K
         ZLhXlyqQPVWKX4sIdaOjcs/5nJ1FX0PMmgP0W1ttpGicRYD59W40ru4GgEBr93Bm3vOB
         xCCGKnXlCWTSTDqlGLinlfwlMMHadmQ4yOsFs35sekKx2wrL9a0zRztZZxeLfQ9r+sxo
         VCPaGDf/YHrgCJ5fSJ/ymY2LF+0beyV3rqA2DvckrJJ5VV+U87IXIm+NX4xeQjRLG9FN
         bn1+dqTeWFkbhtzTamd/4tZ0DxJlVJwHUxVT9z2MjzpXEwKEvpdUzH8tZckeCARrZrti
         B79A==
X-Gm-Message-State: AC+VfDxZaGZpmlATMHgg6RaqPZT6dVCoz2Lc+WjZfMqk1eh7Rp5L8A1p
        w4fPe6kNbU74eVqSpgcXQP+4dQ==
X-Google-Smtp-Source: ACHHUZ6adnhF1iUNUSKna36v1dpD9ONH+lLUYROkCaDsTwsPBSQkg2PW5L2Ru+BtAKVxDeIayGLhdg==
X-Received: by 2002:a17:902:c1c4:b0:1ac:b4db:6a62 with SMTP id c4-20020a170902c1c400b001acb4db6a62mr3794057plc.65.1685128962376;
        Fri, 26 May 2023 12:22:42 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1f3a:6990:1a5c:b29f:f8cf:923c])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b001b008b3dee2sm1955079plh.287.2023.05.26.12.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 12:22:42 -0700 (PDT)
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
Subject: [PATCH v8 02/11] dt-bindings: dma: Increase iommu maxItems for BAM DMA
Date:   Sat, 27 May 2023 00:52:01 +0530
Message-Id: <20230526192210.3146896-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
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

