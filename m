Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7599C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351922AbiDAUUG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351894AbiDAUUD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265D42706EB
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c7so5895584wrd.0
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DGCkJrK8CjpNQTEj6b9xsgDCufMl9t/fhMg36upVCms=;
        b=38Mjyy4PUG1qifiYjaGuBmEDmQ4cmC1Vw4iv4rSOVWiedsiaKCAgQ52NExOc1pE49w
         Pfx10onQLS+nade8OH/OngJw8Mwhu+Igi6N4asQGVuij6Au/8vRUk1VPSSuCbGLTfMag
         yO9pXlNGNQDXIcumWVkPfzz9S6fw2nwZs+tWyF5SpuvGQap4ze8OGlDit23nsgXqoQGU
         7sJqivbmofTw/UXVRw8mKCmrD7zdGL7U55yAaSrRoQqgNw2gp4CQeBGCDkPG2QRGFuaA
         ebz16tPUHI/5QrSQP+zwxqlOw1tT3YDc1PqdAPFPwHtoo6LUJ62j4p0UQF3FZg7ygBar
         1Usg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DGCkJrK8CjpNQTEj6b9xsgDCufMl9t/fhMg36upVCms=;
        b=dh+FdRibIU5l3i9lIAoEcyu2iDYx1idb0wwomyDTpN2e6punr8oBMOpK9ajqyzI1wS
         WCIxHXPGB1fOvqOwsgXv2iS8Wv2El8xrKFOJNJRGDdWbJtlAAVrcs6BpD2/aSgRmYDaD
         nPQrkz/JvNOdf5Pp0w4Kvp2XgTlW8rrEDX22+1n7resKH4zPCkBLQbqMwl9TcRVRYxxx
         DGdNUPFoVDpzNMNKibW4aLRigi35xl3LHsuPAHhh8y1+U21OppSuFTQgA9z2mxzqj8SV
         M5jRh02m2FsaphiPh+cIaLYllMXjAPedsjCAcFz0wFZHIAWISqe08oX+4r9O+IQnHrP7
         8jRQ==
X-Gm-Message-State: AOAM531v0zauuNXoHyT7LHh0CBaL1JqdMxuh6uyOjydzhAzBpzMZ+2CZ
        8OIxcYI5cqwVlqBdeX9m1eNLVA==
X-Google-Smtp-Source: ABdhPJxCCclvL39vPD0mGH4xeRxi6oEYQtYAcXEue88joWnUg/FnejMfCx7WSBAmHhxBXfdea8nR1A==
X-Received: by 2002:adf:d1e5:0:b0:205:85f5:656c with SMTP id g5-20020adfd1e5000000b0020585f5656cmr8795652wrd.65.1648844290722;
        Fri, 01 Apr 2022 13:18:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:10 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 00/33] crypto: rockchip: permit to pass self-tests
Date:   Fri,  1 Apr 2022 20:17:31 +0000
Message-Id: <20220401201804.2867154-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The rockchip crypto driver is broken and do not pass self-tests.
This serie's goal is to permit to become usable and pass self-tests.

This serie also adds support for 2 more SoCs.

This whole serie is tested on a rk3328-rock64, rk3288-miqi with selftests (with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)
The serie is also tested on a rk3399 by Hugh Cole-Baker
<sigmaris@gmail.com> and Igor Velkov <iav@iav.lv>, Thanks to them for
testing.

Regards

Changes since v1:
- select CRYPTO_ENGINE
- forgot to free fallbacks TFMs
- fixed kernel test robots warning
- add the PM patch

Changes since v2:
- Added DMA clock back to 3288 since it dont work without it
- fallback needed to select CBC and ECB configs
- Added support for rk3399
- Added more patch (style, read_poll_timeout)

Changes since v3:
- full rewrite of support for RK3399
- splited dt-binding patch in two

Corentin Labbe (33):
  crypto: rockchip: use dev_err for error message about interrupt
  crypto: rockchip: do not use uninitialized variable
  crypto: rockchip: do not do custom power management
  crypto: rockchip: fix privete/private typo
  crypto: rockchip: do not store mode globally
  crypto: rockchip: add fallback for cipher
  crypto: rockchip: add fallback for ahash
  crypto: rockchip: better handle cipher key
  crypto: rockchip: remove non-aligned handling
  crypto: rockchip: rework by using crypto_engine
  crypto: rockchip: rewrite type
  crypto: rockchip: add debugfs
  crypto: rockchip: introduce PM
  crypto: rockchip: handle reset also in PM
  crypto: rockchip: use clk_bulk to simplify clock management
  crypto: rockchip: add myself as maintainer
  crypto: rockchip: use read_poll_timeout
  crypto: rockchip: fix style issue
  crypto: rockchip: add support for rk3328
  crypto: rockchip: rename ablk functions to cipher
  crypto: rockchip: rework rk_handle_req function
  crypto: rockchip: use a rk_crypto_info variable instead of lot of indirection
  crypto: rockchip: use the rk_crypto_info given as parameter
  crypto: rockchip: rename crypto_info to main in TFM context
  crypto: rockchip: store crypto_info in request context
  crypto: rockchip: Add support for rk3399
  dt-bindings: crypto: convert rockchip-crypto to yaml
  dt-bindings: crypto: rockchip: convert to new driver bindings
  clk: rk3399: use proper crypto0 name
  ARM: dts: rk3288: crypto does not need reset-names anymore
  arm64: dts: rockchip: add rk3328 crypto node
  arm64: dts: rockchip: rk3399: add crypto node
  crypto: rockchip: Check for clocks numbers and their frequencies

 .../crypto/rockchip,rk3288-crypto.yaml        | 117 ++++
 .../bindings/crypto/rockchip-crypto.txt       |  28 -
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/rk3288.dtsi                 |   1 -
 arch/arm64/boot/dts/rockchip/rk3328.dtsi      |  10 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |  18 +
 drivers/crypto/Kconfig                        |  15 +
 drivers/crypto/rockchip/rk3288_crypto.c       | 505 ++++++++--------
 drivers/crypto/rockchip/rk3288_crypto.h       |  99 +--
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 256 +++++---
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 571 ++++++++++--------
 include/dt-bindings/clock/rk3399-cru.h        |   6 +-
 12 files changed, 959 insertions(+), 674 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

-- 
2.35.1

