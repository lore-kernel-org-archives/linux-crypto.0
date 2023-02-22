Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B73C64ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 17:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjBVRWw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjBVRWu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 12:22:50 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A853E60A
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:22:46 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id e9so8562003ljn.9
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677086565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=33MmnVbpLNpHInBJ1LkL8c+ST2MPMOgAuayPQD7XuKo=;
        b=BR9KXT2+YyrzbXf+M8isgWywBs23Hs7BtgvlV25s3TFL9kSH122GcbvuftTnjF3Nv1
         XZEFkffK+efwwj5N0touG0giSMQq06p2Uo+jpcbiqy6yZlVzqNxAaMk4fc6U+4rWXFW5
         O9Mz7WsxV/eOTxkTcodt4quzVfHl9x5I7LCxE8V32RP47SSea6M4C+7DUqbhpg0aVDfL
         9uguTA4IGNAhqLF4Uw7nQLoyD49QIowS34mOjfxGZQqIu/Vk3wrcQ2BBpaSTaZ2FbRZS
         wIvSPbCV6kw8wnS2iQ8AX+unDEyUyTV4Mi/vhAmmmB/k9QhNL572nDqFgc+/wSVSQwfA
         3xZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677086565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=33MmnVbpLNpHInBJ1LkL8c+ST2MPMOgAuayPQD7XuKo=;
        b=YThx4YD4Ot+7DT/luuxVX2p88FlHaodE7blz9WPQidiXmoPG3F4BwxOgfYaRwc4PAf
         Kz63NVNnd0oEVFZ+kYrgjaRTLK9H9XfQVOY6Wb+r99HqA/Rjec5QMEGqIakDOVm9tWP6
         1sy3OYoVtWQOl9cyIRDWW6OL9TEw9dJH+dbamr4MW2sKoH0Uap8NjScxtOp547Yrh5Ul
         swsWU9wXA4GSXOcK5zoTOzpXpeB0ev4PGdgOteQ5QytY9c992sAe6tnN8gpquhaOgSg2
         2f7A2We4K31Ib5xBG+GfDusEPSxA2CUGb7aBDjmTvl6ZImT2RvlJ6V/1pbtlTnZ1U/3t
         XqLg==
X-Gm-Message-State: AO0yUKWXPl+VlJUniWMf64yOnPludUeGYEWrPHI/m1ullq3jLskP4sew
        6U/oiniuIpISx7TvoK/V1NhaMg==
X-Google-Smtp-Source: AK7set8DeZ/3oWVzcnEeYCJD2cKQ1dg2EWJMX+RacoDUfo9XVV1TGUsvgHuUbT33jHvjdARlxtCmOw==
X-Received: by 2002:a05:651c:ba8:b0:293:253c:a435 with SMTP id bg40-20020a05651c0ba800b00293253ca435mr3151933ljb.5.1677086564781;
        Wed, 22 Feb 2023 09:22:44 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r3-20020a2e80c3000000b0029358afcc9esm805233ljg.34.2023.02.22.09.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:22:43 -0800 (PST)
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
Subject: [PATCH v11 00/10] crypto: qcom-qce: Add YAML bindings and support for newer SoCs
Date:   Wed, 22 Feb 2023 19:22:30 +0200
Message-Id: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The series contains Qualcomm Crypto Engine DT bindings documentation and
driver changes, which modify a set of accepted compatible property values,
which is needed to provide a unified and fine-grained support of the driver
on old and new platforms. In addition due to QCE IP changes on new Qualcomm
platforms, it is reflected in updates to valid device tree properties,
namely added iommu, interconnects and optional clocks.

Qualcomm crypto engine (QCE) is available on several Snapdragon SoCs.
The QCE block supports hardware accelerated algorithms for encryption
and authentication. It also provides support for aes, des, 3des
encryption algorithms and sha1, sha256, hmac(sha1), hmac(sha256)
authentication algorithms.

Changes since v10:
=================
- v10 can be found here: https://lore.kernel.org/all/20230216131430.3107308-1-vladimir.zapolskiy@linaro.org/
- Fixed 05/10 commit message per request from Krzysztof and added his
  reviewed-by tag.
- Rebased the series on top of the linux-next.

Changes since v9:
=================
- v9 can be found here: https://lore.kernel.org/linux-crypto/20230208183755.2907771-1-vladimir.zapolskiy@linaro.org/
- Added a new generic 'qcom,qce' compatible name, since IP is runtime
  discoverable, however two new SoC name based compatibles are left
  due to necessity to differentiate various lists of required properties.
- Updated documentation according to review comments by Krzysztof.
- Removed platform specific changes in dtsi files, only one bisectable
  change in sm8550.dtsi is left in the series.
- Added some commit tags, however a few given tags by Krzysztof are not
  added, since the previous tagged changes were noticeably reworked.

Changes since v8:
=================
- v8 can be found here: https://lore.kernel.org/all/20230202135036.2635376-1-vladimir.zapolskiy@linaro.org/
- Rebased the series on top of linux-next, sm8550 qce support is already
  found in the tree.
- Reduced the list of QCE IP compatibles in the driver, added one more
  compatible for backward DTB ABI compatibility.
- Replaced a documentation change from Neil Armstrong by a more advanced
  version of it per review comments from Krzysztof Kozlowski about clock
  and clock-names properties.
- Added changes to all relevant Qualcomm platform dtsi files according to
  the changes in the scheme file.
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
  review and handling from the maintainer: arm-msm, crypto and dma

Changes since v5:
=================
- v5 can be seen here: https://lore.kernel.org/lkml/20211110105922.217895-1-bhupesh.sharma@linaro.org/
- As per Bjorn's suggestion on irc, broke down the patchset into 4
  separate patchsets, one each for the following areas to allow easier
  review and handling from the maintainer: arm-msm, crypto, dma and devicetree
- Addressed Rob's, Vladimir's and Bjorn's review comments received on v5.
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

Bhupesh Sharma (4):
  dt-bindings: qcom-qce: Convert bindings to yaml
  MAINTAINERS: Add qcom-qce dt-binding file to QUALCOMM CRYPTO DRIVERS section
  dt-bindings: qcom-qce: Add 'interconnects' and 'interconnect-names'
  dt-bindings: qcom-qce: Add 'iommus' to optional properties

Thara Gopinath (2):
  crypto: qce: core: Add support to initialize interconnect path
  crypto: qce: core: Make clocks optional

Vladimir Zapolskiy (4):
  dt-bindings: qcom-qce: Add new SoC compatible strings for Qualcomm QCE IP
  dt-bindings: qcom-qce: document optional clocks and clock-names properties
  arm64: dts: qcom: sm8550: add QCE IP family compatible values
  crypto: qce: core: Add a QCE IP family compatible 'qcom,qce'

 .../devicetree/bindings/crypto/qcom-qce.txt   |  25 ----
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 123 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |   2 +-
 drivers/crypto/qce/core.c                     |  23 +++-
 drivers/crypto/qce/core.h                     |   1 +
 6 files changed, 145 insertions(+), 30 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.yaml

-- 
2.33.0

