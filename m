Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15589C6FD1C
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Mar 2023 11:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCMLwW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Mar 2023 07:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCMLwT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2023 07:52:19 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1182B5FA43
        for <linux-crypto@vger.kernel.org>; Mon, 13 Mar 2023 04:52:10 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso10732328wmq.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Mar 2023 04:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678708328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o5gykfX2bmfwMlcyaSUJHUuynXbdEn2Jn2hMntaBdA8=;
        b=jTPVoMmYB82d+INXPTCISg1Ni/0nJkR1rU6+eaE7FcvtlCNWJT/Mlsc+FjBMCr1Vlt
         3bs1xgcdwKd1WYS4l/cW0AxBXFRi/mXoDN5xEzUNIsIOrOlAdBvBm5NP6JBMC/1akx7G
         KSbPa+1uzWgMjNjo4rArzyeAZSjJ2YWXbB16br78OsG6ycjc6z/4245XPpkKPSsXeD+G
         DWfluqUrOriW991v1pUiTdBN3QQ6/P/ixTJ8cU23wnjIVcLQCQmXuahDekfNMWYLbS9b
         UlWL+0S7YYUY5AokG9VIrL1D4vdiuTAkN+XDgPj0uPIjUj5w2Rl4zHVRZ+k+tuzFFT0o
         3kgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678708328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5gykfX2bmfwMlcyaSUJHUuynXbdEn2Jn2hMntaBdA8=;
        b=kOojAES2s02ra2OKp+8OF6yTbYvGtnBQ8ZAVNcu9gj4xR+VGvUNRXCJJV4RHHCFiGt
         E4ZtVnLFGBh5MTZ9nvbESz6xoT9OlKRG96xVeAxOb7zXWD/PDrDwEF0U52WFiKfm5PjU
         YZEvfzERg/E91Pbr3P1+ZZ88IQjSnaPzfuDTJJjEEZAZMZATBq8hjjdl7JgyKwBR1QjT
         tehsdwPwcVscLMqwvHYqwuthsD9L77Y37akp0XzmxmDj+FVECZup8TWpTnJ5AOEdyZzE
         qo8YOnPB03Q2xjdeQKuDMPCaaNGubYlfiF122jK4LbMg4mgKWKgtVL+wI4gyhaa1gs4t
         Dwiw==
X-Gm-Message-State: AO0yUKUN3+3+n7DoA4vi9iqier+AYvBuorSR9fW0HY/9AJVuvZu8+E7H
        LnmfZfrXOvBM9iRRJk9ilAzhJw==
X-Google-Smtp-Source: AK7set9uAdyrBT0fMJ/+4ExIf42UZdHhoPSYbzui/SAELuql13PVvWwSgyB6mJmYoXS75woY9Wll/w==
X-Received: by 2002:a05:600c:c10:b0:3eb:248f:a13e with SMTP id fm16-20020a05600c0c1000b003eb248fa13emr10803608wmb.22.1678708328527;
        Mon, 13 Mar 2023 04:52:08 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id u15-20020a05600c440f00b003e21dcccf9fsm8801090wmn.16.2023.03.13.04.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 04:52:08 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC PATCH v3 0/7] Add dedicated Qcom ICE driver
Date:   Mon, 13 Mar 2023 13:51:55 +0200
Message-Id: <20230313115202.3960700-1-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As both SDCC and UFS drivers use the ICE with duplicated implementation,
while none of the currently supported platforms make use concomitantly
of the same ICE IP block instance, the new SM8550 allows both UFS and
SDCC to do so. In order to support such scenario, there is a need for
a unified implementation and a devicetree node to be shared between
both types of storage devices. So lets drop the duplicate implementation
of the ICE from both SDCC and UFS and make it a dedicated (soc) driver.
Also, switch all UFS and SDCC devicetree nodes to use the new ICE
approach.

See each individual patch for changelogs.

The v2 is here:
https://lore.kernel.org/all/20230308155838.1094920-1-abel.vesa@linaro.org/

Abel Vesa (7):
  dt-bindings: crypto: Add Qualcomm Inline Crypto Engine
  dt-bindings: mmc: sdhci-msm: Add ICE phandle and drop core clock
  dt-bindings: ufs: qcom: Add ICE phandle and drop core clock
  soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver
  scsi: ufs: ufs-qcom: Switch to the new ICE API
  mmc: sdhci-msm: Switch to the new ICE API
  arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node

 .../crypto/qcom,inline-crypto-engine.yaml     |  42 +++
 .../devicetree/bindings/mmc/sdhci-msm.yaml    |   4 +
 .../devicetree/bindings/ufs/qcom,ufs.yaml     |   4 +
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |  10 +
 drivers/mmc/host/Kconfig                      |   2 +-
 drivers/mmc/host/sdhci-msm.c                  | 215 ++---------
 drivers/soc/qcom/Kconfig                      |   4 +
 drivers/soc/qcom/Makefile                     |   1 +
 drivers/soc/qcom/ice.c                        | 347 ++++++++++++++++++
 drivers/ufs/host/Kconfig                      |   2 +-
 drivers/ufs/host/Makefile                     |   1 -
 drivers/ufs/host/ufs-qcom-ice.c               | 244 ------------
 drivers/ufs/host/ufs-qcom.c                   |  83 ++++-
 drivers/ufs/host/ufs-qcom.h                   |  32 +-
 include/soc/qcom/ice.h                        |  39 ++
 15 files changed, 575 insertions(+), 455 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
 create mode 100644 drivers/soc/qcom/ice.c
 delete mode 100644 drivers/ufs/host/ufs-qcom-ice.c
 create mode 100644 include/soc/qcom/ice.h

-- 
2.34.1

