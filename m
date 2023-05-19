Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D018AC7EE26
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 21:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjESVse (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 17:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjESVsd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 17:48:33 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95104110
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so979544b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684532912; x=1687124912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zau2qsQhDV1bV+FMZBbLle6RPe9ivNDcr7IgnOjplHE=;
        b=IMAwsr9+5YpQkpjpZW1wfxFE419+51fvECkQ//gzJPWu+Ym5syz5uYmop1IrWnHqdX
         OXTkDjceuLKn/gxeZFArNWe0DqX2O3IQuJ6gzbhP2S6HDfdPUmTtIDyUxe7tAjgYlsf3
         iEW0ApPGQekcmHedcd1pzdR1DgEtlvos/27mjFIM/vvPDUbWY98OPGu/0qEoT15Kf5x5
         mTCqQROwCJKhPauYPn80TvWK7lXJD8dW7B1XXP17ou0xUiBwwL42H/qwdZfNicRB/cow
         ETp4P7vhaS4JQDesCY54+cd9h5mkgno+3+rKrAyIJtJQDYrC7284UNacABL9c0PXGdeD
         ieKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684532912; x=1687124912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zau2qsQhDV1bV+FMZBbLle6RPe9ivNDcr7IgnOjplHE=;
        b=IVr+KAcBUOOCKNVM1XASuYO+h9f7k7yocmXfuaO6ovpCIfyqiqswbQ9SgPoGH4VbtL
         zlmWXf2DWWN1Y4P17Vu6E2DLse0Iju9jWy/oLYPZVQa4l/zJpSP2oU7hYBErl4Cl7Jwm
         8hQktvqomZNpaYUldr06Ok9KZrh1EV7/c0rqE1Cef0Wl4xzvdVCvrRn38OWPT4TFibzn
         ud/mSgmZXL2DrbM6HH+2ISsya0Pq4h0JV8g0W3Si3Fg9weuufI7Y0oLZKD/assd1fcox
         wsTnCmkJp0wWcGvDOEc7kt4dbI6H1DeO3In4ffzmYSEhzEusUEnczJayAg2Teoah0Lo4
         tNUw==
X-Gm-Message-State: AC+VfDzXUSVULZhhtzRXh6ytk/gYik/O4d8F5QMRzM08sdzeLvWszJtJ
        HrpLU2H0a4YAguQwAD8GYbbrnA==
X-Google-Smtp-Source: ACHHUZ4h5q/mZRzPyIqULeKtyzgLrq5KYlThiD42UFvTU6gxmHsk/Wh1DL4/bZlqVwqR2vaYQWZyDQ==
X-Received: by 2002:a05:6a00:2d90:b0:64d:2487:5b3c with SMTP id fb16-20020a056a002d9000b0064d24875b3cmr4608384pfb.29.1684532911929;
        Fri, 19 May 2023 14:48:31 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d309:883d:817e:8e91:be39])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b006470a6ef529sm144891pfo.88.2023.05.19.14.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 14:48:31 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net
Subject: [PATCH v7 00/11] arm64: qcom: Enable Crypto Engine for a few Qualcomm SoCs
Date:   Sat, 20 May 2023 03:18:02 +0530
Message-Id: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes since v6:
-----------------
- v6 can be viewed here: https://lore.kernel.org/linux-arm-msm/20230405072836.1690248-1-bhupesh.sharma@linaro.org/
- Collected Acks, R-Bs and Tested-by for various patches.
- Addressed Konrad's comment about iommu sids for sm8150 and sm8250
  crypto node entries.
- Addressed Konrad's and Stephan's comments about adding RPM clock for
  crypto blocks on qcm2290 and sm6115.

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

 .../devicetree/bindings/crypto/qcom-qce.yaml  | 50 +++++++++++++++----
 .../devicetree/bindings/dma/qcom,bam-dma.yaml | 22 +++++---
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  2 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi          | 25 ++++++++++
 arch/arm64/boot/dts/qcom/sm8150.dtsi          | 30 +++++++++++
 arch/arm64/boot/dts/qcom/sm8250.dtsi          | 32 ++++++++++++
 arch/arm64/boot/dts/qcom/sm8350.dtsi          | 22 ++++++++
 arch/arm64/boot/dts/qcom/sm8450.dtsi          | 28 +++++++++++
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |  2 +-
 9 files changed, 194 insertions(+), 19 deletions(-)

-- 
2.38.1

