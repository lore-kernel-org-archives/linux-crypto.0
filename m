Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8148DC636D3
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBHSiV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBHSiU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:20 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B904659A
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:10 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id rp23so2292386ejb.7
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ITYwvQKOh1EHW+/stMcAlY0XUScWUl1QlZHx90l/TYw=;
        b=OpSPzq2XkHHy09BppC3vzCg4uFSGXrbQbunpO1o+TcH0OlSBlkIrRi+dFpa+EholoB
         UPA5wsguCk2P3165vybbPmT4DfWDFeP4UgHK5oeU1c8p8mvmsldOY20bLV0j8ducU0bv
         n0AdRj9Ikm6vVwqdh+C8eLsFur8ECMHdG6HR8SGwd6XHeAZ9vX2U45+eCLk/B03Q9uRT
         QXDuHtpE/gHGRhNQZsv38JGSIaRsh1ajoVBFw5nsaf3L3l5fc4BdaItcKK4UGyM1Rccz
         3Bb69rA1jPRiYFWpOPrcZY+LYNIi70SlOrnkC7L2pedMmQgu4kq8LM87I8kVXJBR6V+D
         wvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ITYwvQKOh1EHW+/stMcAlY0XUScWUl1QlZHx90l/TYw=;
        b=U31RyikpAcmwPqziX6nf2vdoetzd8Eo3a73GNFtD141O5I3+CxRWHc3B/DiR05np42
         cOb9PKMd/JGNMJCI8lhS3z6/c4DAlSFeXu01RJ2YE9weJVhNn89u3xmxflihh+24m900
         id7ljqfvzupVOWEaEPYc/U2bsGqAQzpWJMM4/l4idaRXpYRNChvKiKVf3gtDLtoxbc2o
         soyFSBHP3FGiL/lY2U91vEAFQVctuK1hEqPuLQq8XSL1z+i3yCMkF1Eth8n2Yi2QsX4P
         LeGhxuiZJK5inj6p1QYoYRt49rIXVTtexx8QsnQClKF0ZjChrsIC8Tzn67tphC/pifVM
         63Wg==
X-Gm-Message-State: AO0yUKU4u2YYJ3MNmijFl5DPtoig4H2h6pLQPsThXHtL0SLxgjRP1uGn
        Zo7+qUd77NCE5MMdq9Tsmvv5BQ==
X-Google-Smtp-Source: AK7set8DKCReVwHT9EMd9k0fgLQH/HefKLeTt92hYll39OEPFsA7rFjPN02mBMvHDBMke/kBetdHSw==
X-Received: by 2002:a17:906:2085:b0:8aa:a9df:b7f0 with SMTP id 5-20020a170906208500b008aaa9dfb7f0mr7026593ejq.7.1675881488728;
        Wed, 08 Feb 2023 10:38:08 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:08 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v9 00/14] crypto: qcom-qce: Add YAML bindings & support for newer SoCs
Date:   Wed,  8 Feb 2023 20:37:41 +0200
Message-Id: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The series contains Qualcomm Crypto Engine dts and driver changes,
which modify a set of accepted compatible property values, this is
needed to provide a unified and fine-grained support of the driver
on old and new platforms. In addition due to QCE IP changes on new
Qualcomm platforms, it is reflected in updates to valid device tree
properties, namely added iommu, interconnects and optional clocks.

Changes since v8:
=================
- v8 can be found here: https://lore.kernel.org/all/20230202135036.2635376-1-vladimir.zapolskiy@linaro.org/
- Rebased the series on top of linux-next, sm8550 qce support is already
  found in the tree,
- Reduced the list of QCE IP compatibles in the driver, added one more
  compatible for backward DTB ABI compatibility,
- Replaced a documentation change from Neil Armstrong by a more advanced
  version of it per review comments from Krzysztof Kozlowski about clock
  and clock-names properties,
- Added changes to all relevant Qualcomm platform dtsi files according to
  the changes in the scheme file,
- Added QCE support on SM8250 platform.

Changes since v7:
=================
- v7 can be found here: https://lore.kernel.org/linux-arm-msm/20220920114051.1116441-1-bhupesh.sharma@linaro.org
- Added a change by Neil Armstrong to document clocks and clock-names
  properties as optional,
- At the moment do not add Bhupesh as a new QCE driver maintainer,
- Minor updates to device tree binding documentation and qce driver,
  in particular added more compatibles and fixed lesser issues.

Changes since v6:
=================
- v6 can be seen here: https://lore.kernel.org/linux-arm-msm/30756e6f-952f-ccf2-b493-e515ba4f0a64@linaro.org/
- As per Krzysztof's suggestion on v6, clubbed the crypto driver and
  dt-bindings changes together. Now the overall v5 patchset into 3
  separate patchsets, one each for the following areas to allow easier
  review and handling from the maintainer:
	arm-msm, crypto and dma

Changes since v5:
=================
- v5 can be seen here: https://lore.kernel.org/lkml/20211110105922.217895-1-bhupesh.sharma@linaro.org/
- As per Bjorn's suggestion on irc, broke down the patchset into 4
  separate patchsets, one each for the following areas to allow easier
  review and handling from the maintainer:
	arm-msm, crypto, dma and devicetree
- Addressed Rob's, Vladimir's and Bjorn's review comments received on
  v5.
- Added Tested-by from Jordan received on the v5.

Changes since v4:
=================
- v4 for sm8250 can be seen here: https://lore.kernel.org/linux-arm-msm/20211013105541.68045-1-bhupesh.sharma@linaro.org/
- v1 for sm8150 qce enablement can be seen here: https://lore.kernel.org/linux-arm-msm/20211013165823.88123-1-bhupesh.sharma@linaro.org/
- Merged the sm8150 and sm8250 enablement patches in the same patchset,
  as per suggestions from Bjorn.
- Dropped a couple of patches from v4, as these have been picked by
  Bjorn already via his tree.
- Addressed review comments from Vladimir, Thara and Rob.
- Collect Reviewed-by from Rob and Thara on some of the patches from the
  v4 patchset.

Changes since v3:
=================
- v3 can be seen here: https://lore.kernel.org/linux-arm-msm/20210519143700.27392-1-bhupesh.sharma@linaro.org/
- Dropped a couple of patches from v3, on basis of the review comments:
   ~ [PATCH 13/17] crypto: qce: core: Make clocks optional
   ~ [PATCH 15/17] crypto: qce: Convert the device found dev_dbg() to dev_info()
- Addressed review comments from Thara, Rob and Stephan Gerhold.
- Collect Reviewed-by from Rob and Thara on some of the patches from the
  v3 patchset.

Changes since v2:
=================
- v2 can be seen here: https://lore.kernel.org/dmaengine/20210505213731.538612-1-bhupesh.sharma@linaro.org/
- Drop a couple of patches from v1, which tried to address the defered
  probing of qce driver in case bam dma driver is not yet probed.
  Replace it instead with a single (simpler) patch [PATCH 16/17].
- Convert bam dma and qce crypto dt-bindings to YAML.
- Addressed review comments from Thara, Bjorn, Vinod and Rob.

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

Qualcomm crypto engine (qce) is available on several Snapdragon SoCs.
The qce block supports hardware accelerated algorithms for encryption
and authentication. It also provides support for aes, des, 3des
encryption algorithms and sha1, sha256, hmac(sha1), hmac(sha256)
authentication algorithms.

Bhupesh Sharma (4):
  dt-bindings: qcom-qce: Convert bindings to yaml
  MAINTAINERS: Add qcom-qce dt-binding file to QUALCOMM CRYPTO DRIVERS section
  dt-bindings: qcom-qce: Add 'interconnects' and 'interconnect-names'
  dt-bindings: qcom-qce: Add 'iommus' to optional properties

Thara Gopinath (2):
  crypto: qce: core: Add support to initialize interconnect path
  crypto: qce: core: Make clocks optional

Vladimir Zapolskiy (8):
  dt-bindings: qcom-qce: Add new SoC compatible strings for qcom-qce
  dt-bindings: qcom-qce: document optional clocks and clock-names properties
  arm: dts: qcom: ipq4019: update a compatible for QCE IP on IPQ4019 SoC
  arm64: dts: qcom: msm8996: update QCE compatible according to a new scheme
  arm64: dts: qcom: sdm845: update QCE compatible according to a new scheme
  arm64: dts: qcom: sm8550: add a family compatible for QCE IP
  arm64: dts: qcom: sm8250: add description of Qualcomm Crypto Engine IP
  crypto: qce: core: Add a compatible based on a SoC name

 .../devicetree/bindings/crypto/qcom-qce.txt   |  25 ----
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 116 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi         |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi          |  24 ++++
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |   2 +-
 drivers/crypto/qce/core.c                     |  24 +++-
 drivers/crypto/qce/core.h                     |   1 +
 10 files changed, 166 insertions(+), 33 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.yaml

-- 
2.33.0

