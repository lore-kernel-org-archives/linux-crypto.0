Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6A8C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 11:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiITLlG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiITLlE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 07:41:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B031971712
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id go6so2751187pjb.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=BKjZnui/74EAfnubeZm1LLf2eM600BaSxEaHjLfpBFk=;
        b=EOlgV+e5Sda6wibY/4bLFSjg4s8D+0VVy6rbs8vXC1/SSLbvDbsOTUVdiO5QcZ/WGH
         hCwLxzjphe4AjGnoK3PTgSvUun0p71H6rW4el9neg4Te60MiE4yHYCEKznwuww25LKqH
         1em4kjKOS+peOuLeaRgY4f2svj6j5RtaBqkRM/hgVk6q8vzhEUXF8bmqqchbaPe9S7v9
         nC2yGIvK7QPXHfAGU+12T0fT8sKp7QH9QoCHiMIoiW7JHvMBloGlL84aOMwO4z/Eykvl
         3xZ8U2txSvDuwoBl3tionELjIT0h4zBI/3DxbUKID60PxmScdm2Fx+BQO+PEKsnhtlve
         tutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=BKjZnui/74EAfnubeZm1LLf2eM600BaSxEaHjLfpBFk=;
        b=D/sjtfZvSghLV0H6lR+i6w7B83QSZxkBEIh2k8sF8PqP+JGSYK4qw/uaqIA1e8mNkE
         7DO3iJ1WMLmM4wbFh8f0fmbjn1nmEg5sf8jKU86Tn/QSbAXCiUrfUzzJ3INJ77ma9xNT
         4Suytf/qlzTBT2WM3tdk+Z7K4oHnhHEHy0kYGLDjpfbcZ7bwT1c4WRyX8fGs8O5qOYHs
         eklfd6LeKJaaUItX/xtcg0yjRSavBPkVDA5tUykl+jk8LfKYmnK0WhlasK661cO0M28E
         1zO10Cof18E/x2ETx2+eHa/IDS2He9FFcKGSNPl4BRLWfmT0k/iopYJ32tV6cKCBhuXC
         ltog==
X-Gm-Message-State: ACrzQf0I6uj2xb7X2vG7yl5JfmAOYp+xdCcyZQNtHJHgdtPvdSOW/3D+
        4UZDbVobr51y4rLKMnzXOQLR5dh8khPrtw==
X-Google-Smtp-Source: AMsMyM70EhZ+lrswAobxdYRjYUawNXnVSSLzq/2SLdbl5DEbZMIqSuZ9bu6McRUAOy1NoiJozmriHg==
X-Received: by 2002:a17:902:db12:b0:178:1f91:74e6 with SMTP id m18-20020a170902db1200b001781f9174e6mr4471360plx.100.1663674061568;
        Tue, 20 Sep 2022 04:41:01 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:6535:ca5f:67d1:670d:e188])
        by smtp.gmail.com with ESMTPSA id p30-20020a63741e000000b00434e57bfc6csm1348793pgc.56.2022.09.20.04.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:41:00 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, krzysztof.kozlowski@linaro.org,
        andersson@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, davem@davemloft.net,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v7 0/9] crypto: qcom-qce: Add YAML bindings & support for newer SoCs
Date:   Tue, 20 Sep 2022 17:10:42 +0530
Message-Id: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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

Tested the enabled crypto algorithms with cryptsetup test utilities
on sm8150-mtp, sa8155p-adp, sm8250-mtp and RB5 boards (see [1]) and
also with crypto self-tests, including the fuzz tests
 (CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y).

[1]. https://linux.die.net/man/8/cryptsetup

Cc: herbert@gondor.apana.org.au 
Cc: thara.gopinath@gmail.com
Cc: robh@kernel.org
Cc: andersson@kernel.org
Tested-by: Jordan Crouse <jorcrous@amazon.com>

Bhupesh Sharma (7):
  dt-bindings: qcom-qce: Convert bindings to yaml
  dt-bindings: qcom-qce: Add 'interconnects' and 'interconnect-names'
  dt-bindings: qcom-qce: Add 'iommus' to optional properties
  dt-bindings: qcom-qce: Add new SoC compatible strings for qcom-qce
  crypto: qce: core: Add new compatibles for qce crypto driver
  MAINTAINERS: Add qcom-qce dt-binding file to QUALCOMM CRYPTO DRIVERS
    section
  MAINTAINERS: Add myself as a co-maintainer for Qualcomm Crypto Drivers

Thara Gopinath (2):
  crypto: qce: core: Add support to initialize interconnect path
  crypto: qce: core: Make clocks optional

 .../devicetree/bindings/crypto/qcom-qce.txt   | 25 -----
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 93 +++++++++++++++++++
 MAINTAINERS                                   |  2 +
 drivers/crypto/qce/core.c                     | 31 ++++++-
 drivers/crypto/qce/core.h                     |  1 +
 5 files changed, 123 insertions(+), 29 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.yaml

-- 
2.37.1

