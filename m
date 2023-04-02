Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89271C7619A
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 10:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjDBKHX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Apr 2023 06:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDBKHW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2023 06:07:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4515AE9
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 03:07:20 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u20so17308719pfk.12
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 03:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LbcpNdii47h7TS2sDEqIBCRRzLggrrEsT68ykuaA9G4=;
        b=R86U4rubSlMu45rTmKuGAh1ipkQWxDqIc2yaQZ85Du3zUVU3JZp41800pHfCldruTL
         KPKq6BNNFQ0rySvQyQyESWp2hOy0Nwk44tENFq9vQTsgIaBZzTjP8Y1N7/7A4QRta6Yh
         dDSdteaVIY/4BHTJ7zM8AKmN8uefWwklMnLqydTVxfws2kPecGsNB+/AktaX8JcQ4a1u
         lpyTQdyxhvpm71bo+GQV56pqgnvM3Nf5Y9NVLsy8YJytVkCo/IlJMC9yEuIfcsHAgjIl
         8JM117lDSm3WacL7KxP27R3suAD4W247audx3IXuGvHIkJAQAwCCj+Rhyn3KPqJ12ut5
         yimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbcpNdii47h7TS2sDEqIBCRRzLggrrEsT68ykuaA9G4=;
        b=qQi8fi3/Q2AHh4I4co8UB8OE+hTcSrquiozeYniBz+Q/uZGns7iYm24kK0AlAYMGaQ
         aeMnjUMKMZWExAAqbMr7mf6dHcnHF1GEbVRI43gW7MuYf/kDVVvWWNgi3srwNwEVtkqp
         NjDyT6NvW/MtkDNd2/5AOpvRkg1sOlCOGqGdXltY/K5EVU71scL0GfQHJYVeY9G7QBDy
         OzkPJC0V8YVdhHpnIBPYOImYsR9C+fZsDqU+8mbrDhvfHhT8M38qLZnq/JDwjSJW2ti6
         +dZ2xHos/Zm3A70T7oWweuEyzFmkCyEZUg4PUPwuqamaEQMM0IMskSEZiTQZRtKbjzMl
         aWaA==
X-Gm-Message-State: AAQBX9efpoDulCvFnBVRgDJTMhbhJft2cRsZOQkV9reqBJjeCrcwrkea
        3wh+jR1Kl9Z+etF1PqED/6f+VQ==
X-Google-Smtp-Source: AKy350ZBYGQQN100axzsFpPvHBD8jqrHFqg3mLi4YgSLtrKJamjsjGuvXDq36mOgNs3Fq6UKyxZbYw==
X-Received: by 2002:a62:1c49:0:b0:626:80f:7a0d with SMTP id c70-20020a621c49000000b00626080f7a0dmr31584270pfc.8.1680430039671;
        Sun, 02 Apr 2023 03:07:19 -0700 (PDT)
Received: from localhost.localdomain ([223.233.66.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0062dba4e4706sm4788739pff.191.2023.04.02.03.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 03:07:19 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v5 00/11] arm64: qcom: Enable Crypto Engine for a few Qualcomm SoCs
Date:   Sun,  2 Apr 2023 15:34:58 +0530
Message-Id: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes since v4:
-----------------
- v4 can be viewed here: https://lore.kernel.org/linux-arm-msm/20230331164323.729093-1-bhupesh.sharma@linaro.org/
- Collected R-Bs from Konrad for a couple of patches sent in v4.
- Fixed incorrect email IDs for a couple of patches sent in v3, which I used for
  some patches created on a different work machine.
- No functional changes since v3.

Changes since v3:
-----------------
- v3 can be viewed here: https://lore.kernel.org/linux-arm-msm/20230328092815.292665-1-bhupesh.sharma@linaro.org/
- Collected Acks from Krzysztof for a couple of patches sent in v3.
- Fixed review comments from Krzysztof regarding DMA binding document
  and also added a couple of new patches which are required to fix the
  'dtbs_check' errors highlighted after this fix.

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

Bhupesh Sharma (10):
  dt-bindings: dma: Add support for SM6115 and QCM2290 SoCs
  dt-bindings: dma: Increase iommu maxItems for BAM DMA
  arm64: dts: qcom: sdm8550: Fix the BAM DMA engine compatible string
  arm64: dts: qcom: sdm845: Fix the slimbam DMA engine compatible string
  dt-bindings: qcom-qce: Fix compatible combinations for SM8150 and
    IPQ4019 SoCs
  dt-bindings: qcom-qce: Add compatibles for SM6115 and QCM2290
  arm64: dts: qcom: sm6115: Add Crypto Engine support
  arm64: dts: qcom: sm8150: Add Crypto Engine support
  arm64: dts: qcom: sm8250: Add Crypto Engine support
  arm64: dts: qcom: sm8350: Add Crypto Engine support

Neil Armstrong (1):
  arm64: dts: qcom: sm8450: add crypto nodes

 .../devicetree/bindings/crypto/qcom-qce.yaml  |  8 ++++++
 .../devicetree/bindings/dma/qcom,bam-dma.yaml | 22 +++++++++------
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  2 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8150.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8250.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8350.dtsi          | 22 +++++++++++++++
 arch/arm64/boot/dts/qcom/sm8450.dtsi          | 28 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |  2 +-
 9 files changed, 140 insertions(+), 10 deletions(-)

-- 
2.38.1

