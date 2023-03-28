Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B604C77B6E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 09:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjC1J2x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Mar 2023 05:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjC1J2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2023 05:28:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C108A5FFD
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 02:28:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so11893871pjb.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 02:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679995705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TwOeeM0Gc4tN+QYu8+Z9WuguitIgi90Sd1+U++iusLY=;
        b=s72MT9nY/6jH9o35SvPW523lbHGEmGn7+JEP2R8hz0I6//1W7BiS6BRqO92l0Q7IWJ
         5gsJwuqiIyaOrgyfMdPtrk18Ve1s8dFzTFxK0ejRtADaNYszk57CHuYubHBBe1mQZozX
         ue7SySqUxsxmzKJXxltkkSwmmyWO+qTwpxj9Wji80Ybg6aF+swYc0pzsq7DDazUmKTdG
         lJyZI2bdfpqzauwAuc8KLIWhIZzE52syRlJba6PWpyMwzkrzXGGCVimyNc8ePLXkMzOG
         z+FqQU0FIzC+4SXlyL2gRLtgY+PmuvLu8Y1Q4FfoLrHcczRzlsRnVN/HgJqgsGJu8Dyt
         x1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TwOeeM0Gc4tN+QYu8+Z9WuguitIgi90Sd1+U++iusLY=;
        b=qs7pDd5BLG9IYDaFfOkA61FIacCqZ4JcUOWgsMHJpmIkKuc1W+SbPMzpdYgHvQs/RG
         QUqs1+U3yfsoQyU+NCFh8mfDb9pTnFpedb1Z6kJEAGjT7/uqRyXV84vWZCoYDTH1Z1hR
         qRK8k4YHAkzDKH/TAG4Yxm4vrS/8HekEwDiiKkziQa1w+Ii4qCl1KLElK4pX3kMfZdT3
         M8fzlXUJRHo/7H6GRqt64gUQ9fLMXu8cL+anZzzZbwhmusJkrRFttSd/JDL83WLFngL1
         pVe+lX5C95IZfIN+LWq8rVZKXg6gq4r5wuq+pp8ugonSX0uEZHeq9seykhINcyJzF6nE
         6p2Q==
X-Gm-Message-State: AO0yUKWKQFZgUcYQOTRaJqij/Eh3iIc5FgXAN7UIo42YKrjORAlv+zTr
        58uuxbJvL92oCFoQgqVRgTmQbw==
X-Google-Smtp-Source: AK7set/gqVQvlh1dYk1GKB0z0VrICqZ6/xVXx8jSzvzqqoBg9TGalA4//LSCrdA1mFhcFd1qvSSnJA==
X-Received: by 2002:a05:6a20:3a87:b0:da:dc14:33d with SMTP id d7-20020a056a203a8700b000dadc14033dmr11444261pzh.53.1679995704945;
        Tue, 28 Mar 2023 02:28:24 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:449a:10df:e7c1:9bdd:74f0])
        by smtp.gmail.com with ESMTPSA id a24-20020aa78658000000b005a8bc11d259sm21261518pfo.141.2023.03.28.02.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:28:24 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v3 0/9] arm64: qcom: Enable Crypto Engine for a few Qualcomm SoCs
Date:   Tue, 28 Mar 2023 14:58:06 +0530
Message-Id: <20230328092815.292665-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes since v2:
-----------------
- v2 can be viewed here: https://lore.kernel.org/linux-arm-msm/20230322114519.3412469-1-bhupesh.sharma@linaro.org/
- No functional change since v2. As the sdm845 patch from v1 was accepted in linux-next,
  dropped it from this version.

Changes since v1:
-----------------
- v1 can be viewed here: https://lore.kernel.org/linux-arm-msm/20230321190118.3327360-1-bhupesh.sharma@linaro.org/
- Folded the BAM DMA dt-binding change.
  (sent earlier as: https://lore.kernel.org/linux-arm-msm/20230321184811.3325725-1-bhupesh.sharma@linaro.org/)
- Folded the QCE dt-binding change.
  (sent earlier as: https://lore.kernel.org/linux-arm-msm/20230320073816.3012198-1-bhupesh.sharma@linaro.org/)
- Folded Neil's SM8450 dts patch in this series.
- Addressed review comments from Rob, Stephan and Konrad.
- Collected Konrad's R-B for [PATCH 5/9].

This patchset enables Crypto Engine support for Qualcomm SoCs like
SM6115, SM8150, SM8250, SM8350 and SM8450.

Note that:
- SM8250 crypto engine patch utilizes the work already done by myself and
  Vladimir.
- SM8350 crypto engine patch utilizes the work already done by Robert.
- SM8450 crypto engine patch utilizes the work already done by Neil.

Also this patchset is rebased on linux-next/master.

Bhupesh Sharma (8):
  dt-bindings: dma: Add support for SM6115 and QCM2290 SoCs
  dt-bindings: dma: Increase iommu maxItems for BAM DMA
  dt-bindings: qcom-qce: Fix compatibles combinations for SM8150 and
    IPQ4019 SoCs
  dt-bindings: qcom-qce: Add compatibles for SM6115 and QCM2290
  arm64: dts: qcom: sm6115: Add Crypto Engine support
  arm64: dts: qcom: sm8150: Add Crypto Engine support
  arm64: dts: qcom: sm8250: Add Crypto Engine support
  arm64: dts: qcom: sm8350: Add Crypto Engine support

Neil Armstrong (1):
  arm64: dts: qcom: sm8450: add crypto nodes

 .../devicetree/bindings/crypto/qcom-qce.yaml  |  8 ++++++
 .../devicetree/bindings/dma/qcom,bam-dma.yaml | 24 ++++++++++------
 arch/arm64/boot/dts/qcom/sm6115.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8150.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8250.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8350.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8450.dtsi          | 28 +++++++++++++++++++
 7 files changed, 140 insertions(+), 8 deletions(-)

-- 
2.38.1

