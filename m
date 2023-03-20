Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AF8C7618D
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Mar 2023 07:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjCTHio (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Mar 2023 03:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCTHim (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2023 03:38:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC190BBA6
        for <linux-crypto@vger.kernel.org>; Mon, 20 Mar 2023 00:38:40 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so11439222pjz.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Mar 2023 00:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679297920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNoZCqbMgBSH40W4pfEiFDhEI90p6zM5KTABLDNwlQM=;
        b=N5CrJk/HsF7f/yD83EjLqKLRQxEl17o2JpHJWYCXkUPVmlc+nIoq+dafz8LcOYZxQN
         JXIFQIs8kG19LPZZ9xKIMaeZVqyeetLzspjI3E0HyGVxDFYNOhNHLEGLXQTh+uRQdn83
         d9i8zT7wxkR3HMehAea5nhgfER6PgfXpaeundJLB0YILUcId36J7G/dEHpBnrQk/zbd8
         t9G/A9qmLm9rmhpvBJe2Uq1203xpiPtLJPMkUKTkPo6U+V/QVNChawBAlDN7w6+dGGgA
         bZmyK/cq2isLXGe1WDSmwFKLc8P1kwLT/J1/dUGakanCijAdC5hxSKJQeySyk42M+Zzr
         85cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679297920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZNoZCqbMgBSH40W4pfEiFDhEI90p6zM5KTABLDNwlQM=;
        b=MR0osn4pOXMapyHe0QgsMyJz71+l4dUMxD6GQNiZLCmQgi6rCa5QHBzk6fkJYrM+dI
         PKx8I/6FlgbGuVD7VJqanBOqVRo0t2Ore1on0m2JztATYF2nCu2puiJNH48FTj94aaBg
         S8l3PnaJmjrVF1N58RPO39ugVFbVo5Zf7d39egNwxH+F2zTFP9eUF7lC0ZIzkD/4/rKS
         SY/bEh9ykIP7uOiZPO97S1uY60L7FXwsTK6Uw78mhHTaNZLAnyoLCxK5AsQcZNhFVEMr
         cdPxB74h8t7Hv8wy84K0WvzbFGM6/SfAQJhOHu3iq37FgEoaW4ODQnIIgBuPEoPDuIXE
         unsw==
X-Gm-Message-State: AO0yUKUAe9mRqEa0nGbKzj01xdRDceHI/Zd4esjK5aVjx4Q2eYgeJ5ss
        l5ytBtAEddVOJDbvy64dqlmUzY2rTATdL95DDlE=
X-Google-Smtp-Source: AK7set9YbJZDMR6YZ4q3B1kwJTPJHAsZo6yP2x5I+WCbNAh0suT4iofAlq4O4AAF3uOIf9LZ7o/eeg==
X-Received: by 2002:a17:902:fa4f:b0:19c:be03:d1a3 with SMTP id lb15-20020a170902fa4f00b0019cbe03d1a3mr13752029plb.40.1679297920245;
        Mon, 20 Mar 2023 00:38:40 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:7331:922d:c0be:85c4:f0ae])
        by smtp.gmail.com with ESMTPSA id jj5-20020a170903048500b0019edcc30d9bsm6010251plb.155.2023.03.20.00.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:38:39 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-crypto@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, konrad.dybcio@linaro.org,
        vladimir.zapolskiy@linaro.org
Subject: [PATCH 1/1] dt-bindings: qcom-qce: Add compatibles for SM6115 and QCS2290
Date:   Mon, 20 Mar 2023 13:08:16 +0530
Message-Id: <20230320073816.3012198-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto Engine block on Qualcomm SoCs SM6115 and QCS2290
do not require clocks strictly, so add compatibles for these
SoCs, indicating that they are similar to the flavour
found on SM8150.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index e375bd981300..e6840d124af3 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -35,10 +35,12 @@ properties:
 
       - items:
           - enum:
+              - qcom,sm6115-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce
               - qcom,sm8450-qce
               - qcom,sm8550-qce
+              - qcom,qcs2290-qce
           - const: qcom,sm8150-qce
           - const: qcom,qce
 
-- 
2.38.1

