Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010F6C43462
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B8E613D6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhEEVi4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhEEViz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:38:55 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7512C0613ED
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:37:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gq14-20020a17090b104eb029015be008ab0fso1745328pjb.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AOMS6IBtYK4GCN5aJilBpg+eMXlWTT02T7otyBl8KZQ=;
        b=BalkvDf/iWZ8GIiso1q899MkyIwtB95yvg1XqjJBOi96J7wbZX+oW4M99Nu+wtpvyy
         V74hSLshsDNSXs+Z+1p8bNakZfJs4rui0Koy1OlDpWM83C130eBfD6Dyu11FNBE31V0D
         D/z3r8M/ASQitInRU9TZcCcMDDWePbLht8hS2BNUZtoNolqiWmS7OAM0vyUhbhpj07xt
         MEkO6zxhcOKFWstRQdoN4Wr38E3W00Ju+E4zu+feZXwn0+iM79Dc7yiq0GntvSVVXtYm
         qTxfh/k/qSvODO3QmpWvUuzqEZQ+6bKBSne5JMPAriq/o2ESRss4eQBabPOhhVrcP2mY
         zTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AOMS6IBtYK4GCN5aJilBpg+eMXlWTT02T7otyBl8KZQ=;
        b=BkfBpE8Z41hmcTX2d/8yKt2bVftfre7S1JiABT7cASKfgV2EEC3ljkCYFkZVlEJZsA
         d9lJX7n5KP2ZK6OnemwHXM3P8/0ne/kIlVCSoWecvNeZCg0dBjp0uv95l6133gC/qCEd
         fhuMoFJicMxXjw4iLrsXDSgVsuHrhFK+nysyiDaAGhXoBnM4rJvCYduz4SRZme5WSKNt
         QZiurHFMpKrtlR9O6C+qT1PYHPeWYU8QcmScngcCxFB0vAHM+5KIuw7fKqNynJdCafZF
         pGfm46EPA6i9FKBGLEMXm3yjWpblCYtp/nLT/n61sXBfQGcPWpG/IipNjjyLzLJu51Jp
         9jcw==
X-Gm-Message-State: AOAM53350W/LxigSp8MunWUKXAcBVewMIH/ZDr7o5wp22+Kc2FYAkjwM
        zdVprUl88dCQrOFRu2yXqyTHCQ==
X-Google-Smtp-Source: ABdhPJyt54U3YHt0F3NblKI+1f7T3ZFxciXTCgBY1YK1kClLxIxZrxFpyE13KTATCquAqS6C+oK9qg==
X-Received: by 2002:a17:90a:a081:: with SMTP id r1mr685582pjp.101.1620250678082;
        Wed, 05 May 2021 14:37:58 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:37:57 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH v2 00/17]  Enable Qualcomm Crypto Engine on sm8250
Date:   Thu,  6 May 2021 03:07:14 +0530
Message-Id: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes since v1:
=================
- v1 can be seen here: https://lore.kernel.org/linux-arm-msm/20210310052503.3618486-1-bhupesh.sharma@linaro.org/ 
- v1 did not work well as reported earlier by Dmitry, so v2 contains the following
  changes/fixes:
  ~ Enable the interconnect path b/w BAM DMA and main memory first
    before trying to access the BAM DMA registers.
  ~ Enable the interconnect path b/w qce crytpo and main memory first
    before trying to access the qce crypto registers.
  ~ Make sure to document the required and optional properties for both
    BAM DMA and qce crypto drivers.
  ~ Add a few debug related print messages in case the qce crypto driver
    passes or fails to probe.
  ~ Convert the qce crypto driver probe to a defered one in case the BAM DMA
    or the interconnect driver(s) (needed on specific Qualcomm parts) are not
    yet probed.

Qualcomm crypto engine is also available on sm8250 SoC.
It supports hardware accelerated algorithms for encryption
and authentication. It also provides support for aes, des, 3des
encryption algorithms and sha1, sha256, hmac(sha1), hmac(sha256)
authentication algorithms.

Tested the enabled crypto algorithms with cryptsetup test utilities
on sm8250-mtp and RB5 board (see [1]).

While at it, also make a minor fix in 'sdm845.dtsi', to make
sure it confirms with the other .dtsi files which expose
crypto nodes on qcom SoCs.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
 
Bhupesh Sharma (14):
  dt-bindings: qcom-bam: Add 'interconnects' & 'interconnect-names' to
    optional properties
  dt-bindings: qcom-bam: Add 'iommus' to required properties
  dt-bindings: qcom-qce: Add 'iommus' to required properties
  dt-bindings: qcom-qce: Add 'interconnects' and move 'clocks' to
    optional properties
  arm64/dts: qcom: sdm845: Use RPMH_CE_CLK macro directly
  dt-bindings: crypto : Add new compatible strings for qcom-qce
  arm64/dts: qcom: Use new compatibles for crypto nodes
  crypto: qce: Add new compatibles for qce crypto driver
  crypto: qce: Print a failure msg in case probe() fails
  crypto: qce: Convert the device found dev_dbg() to dev_info()
  dma: qcom: bam_dma: Create a new header file for BAM DMA driver
  crypto: qce: Defer probing if BAM dma is not yet initialized
  crypto: qce: Defer probe in case interconnect is not yet initialized
  arm64/dts: qcom: sm8250: Add dt entries to support crypto engine.

Thara Gopinath (3):
  dma: qcom: bam_dma: Add support to initialize interconnect path
  crypto: qce: core: Add support to initialize interconnect path
  crypto: qce: core: Make clocks optional

 .../devicetree/bindings/crypto/qcom-qce.txt   |  22 +-
 .../devicetree/bindings/dma/qcom_bam_dma.txt  |   5 +
 arch/arm64/boot/dts/qcom/ipq6018.dtsi         |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |   6 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi          |  28 ++
 drivers/crypto/qce/core.c                     | 112 +++++--
 drivers/crypto/qce/core.h                     |   3 +
 drivers/dma/qcom/bam_dma.c                    | 306 ++----------------
 include/soc/qcom/bam_dma.h                    | 290 +++++++++++++++++
 9 files changed, 457 insertions(+), 317 deletions(-)
 create mode 100644 include/soc/qcom/bam_dma.h

-- 
2.30.2

