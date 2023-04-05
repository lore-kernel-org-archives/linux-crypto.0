Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5934C76188
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 07:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbjDEHax (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 03:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbjDEHaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 03:30:52 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638A949D6
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 00:30:50 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id d22so21163254pgw.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 00:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680679850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vIbgVrcpaNBA8DY35aYw8I18NZLqzjpmqSaIZu+NMMY=;
        b=pa6uT+dFYoCMpahPH4F38vo7VSpejBOS+001hZ7WxdZdpBres0Gg/GgGdS/Xh3RmY8
         67NN6pKZOjoIjnIYF3h3qNXa+CMfO3ijPtFWz+ezix1otGsPslBKM1cy09mIfCVpeRRF
         TLCn9aM9zDBQG2BcIbmGnVwDfhN5XP/N23srUVr6q5NESeDfohU9zysQ58d5q+xMSkoT
         RECZ+Zcplkr1fKHsScore86BKlyW3v5birQ0pPzdjTtlHB21GXnT42Qd1Sb2CSVAudLJ
         0f3R39/T4Bxlx5JBV46lVP5OlK/+GOFs99arlt68dpDGykCmCrXNMlqr9hYc4bkBbYVg
         b3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680679850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vIbgVrcpaNBA8DY35aYw8I18NZLqzjpmqSaIZu+NMMY=;
        b=FQc9D7C7BECyYvS0SN1OrJrVzHfvUzpAh6izG3uY/5ouu5tIJ+PfzmBThTsbI3pelv
         G9ZsWG113WCx05zEm+89LU4NEOpVIBXIG4BqgFH2XCnKrTnAoSOfbrqeVUJnfNdqX0xj
         D3cVKe0gd3FVdGkxb+oQsaJc1PTMrh8Ut4sDwvU4c7IRCLt/4D8+xjtDkUf5veSF4LVh
         AimS8KUk4NdjldZw64vmmBHLiGo3BZT6ubrsFh0Zf6RXti27CYlLARB34yYGnECpn25s
         eG++5U0Q9X9VD8d5Nsm19b1HFBqlvY0y+U9iAZYPBxARKEXtEL7riLUvO26s2G04aQgS
         9MlQ==
X-Gm-Message-State: AAQBX9crOiiTVDpM4ZWOvYuAG05jMUWQFDgJbzAzBrBBYe+Wm2TDwiqE
        Pam6bwQgbNdPAZad0u7FULLYag==
X-Google-Smtp-Source: AKy350a3mX6noLmdtwDOWkF9QSkssWELfKR/ta0z692FuGbmVURq7Q++Gsp/t3M1iJJjwhII1L3mnw==
X-Received: by 2002:aa7:9aee:0:b0:628:1638:441f with SMTP id y14-20020aa79aee000000b006281638441fmr3666312pfp.26.1680679849814;
        Wed, 05 Apr 2023 00:30:49 -0700 (PDT)
Received: from localhost.localdomain ([223.233.67.41])
        by smtp.gmail.com with ESMTPSA id l7-20020a635b47000000b004facdf070d6sm8781507pgm.39.2023.04.05.00.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:30:49 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
Subject: [PATCH v6 00/11] arm64: qcom: Enable Crypto Engine for a few Qualcomm SoCs
Date:   Wed,  5 Apr 2023 12:58:25 +0530
Message-Id: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes since v5:
-----------------
- v5 can be viewed here: https://lore.kernel.org/linux-arm-msm/20230402100509.1154220-1-bhupesh.sharma@linaro.org/
- Collected Ack from Rob for [PATCH 01/11].
- Addressed Georgi's comment about interconnect cells in [PATCH 10/11].

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

