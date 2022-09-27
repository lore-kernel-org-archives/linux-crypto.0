Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC87C07E9D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 07:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiI0Hzh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI0Hzh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:55:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4121D7EFDF
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:55:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so4991113wmb.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=EkRR0v4G8ofAqP0Ws7FzBj1ighAgVhnEvfou5TdghMc=;
        b=s9pMIR9CgB0cOWbWfGf0csNlRX6iruaDGJ9YoZvCuaxLeL49RTkhiuSIGJMEc3p6MN
         H6ibXp68+bZTduTG/zokic03qEUwKzK1xTfPaiHocVD28WFj2ZKsI84WzR1hHBUDLue4
         Kxxxfgj/Psn0XtmKJ7kMtWNEO+Y3IR6bqtlpKGfdCuZe9UdPg6ufYxkSOUo0OxrnVbzr
         CMVazCw09LG7zb5Ur32Bvo/DLvP3Ve0XGoMMfU0iplmdfPSOsVApYAIdm7L3G4paOfcQ
         HNhrx5F9a5hmNWztehhRzKymyVNavGMuHLiOvRcv0qbyTcmOZZpvcbK3yK1mpUvWJRt7
         LCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=EkRR0v4G8ofAqP0Ws7FzBj1ighAgVhnEvfou5TdghMc=;
        b=5xlQQ8eMeEbz7NFHJRTo2WdpFF0U36eACJSxx/RieAv42MOCuK8u2dzDXAfIdm5JYF
         sr42PT5r8vGePgfxytDKrwr7WC5xjv8j4TxyiFABfjCiFMTizipVvQUXsQvNkQ6ZWmGq
         0v1doPP2auWM3NAzyfQvxMhG+g4+2slST1FtD14+DreSIFVxBt2GBFFrYkoPSqMlGDNH
         st1x3AM4bGSWw4HHC6AZ6+k9j5UM9QxpRkdgCy1CV3Zo2E7cd8Q36o4DqZDiGMcHU+IR
         vsBs3sHYz8Zhos1nJvPVdLmM1GRRp36iB2qka7fMVnnsIXb6u+3xJQLcS7SKZPRuK8XC
         Zj3A==
X-Gm-Message-State: ACrzQf0zxJbZ1rlKi6ujr66L+4Bhi1Gk49ab/CxPSdUMHplhJgLaUXFr
        Tf/xsDxLyQhuzkAGoXyYCFtC7Q==
X-Google-Smtp-Source: AMsMyM6q51eUecwVRkTgS+bNASlnTW4m2r8gUYUbzMw20c/e1XRnJt7Cck3a15gsqaDieemNNmYoXg==
X-Received: by 2002:a7b:c8d6:0:b0:3b4:868b:afc3 with SMTP id f22-20020a7bc8d6000000b003b4868bafc3mr1576471wml.66.1664265332801;
        Tue, 27 Sep 2022 00:55:32 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:55:31 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v10 00/33] crypto: rockchip: permit to pass self-tests
Date:   Tue, 27 Sep 2022 07:54:38 +0000
Message-Id: <20220927075511.3147847-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The rockchip crypto driver is broken and do not pass self-tests.
This serie's goal is to permit to become usable and pass self-tests.

This whole serie is tested on a rk3328-rock64, rk3288-miqi and
rk3399-khadas-edge-v with selftests (with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)

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

Changes since v4:
- Another full rewrite of support for RK3399
- Fixed dt-binding from Krzysztof Kozlowski's comments
- Use readl_poll_timeout() instead of read_poll_timeout()
- Rewrite the fallback SG tests

Changes since v5:
- fixed errors in DT binding patch

Change since v6:
- remove quotes around const values in dt-bindings

Changes since v7:
- added lot of reviewed/tested by
- In patch 14: keep initial reset pulse.

Changes since v8:
- Removed some useless min/maxitems from dt-binding as reported by dt_binding_check

Change since v9:
- removed redundant rst_ from reset-names
- reworked patch #25 commit message

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
  crypto: rockchip: use a rk_crypto_info variable instead of lot of
    indirection
  crypto: rockchip: use the rk_crypto_info given as parameter
  dt-bindings: crypto: convert rockchip-crypto to YAML
  dt-bindings: crypto: rockchip: add new compatible
  clk: rk3399: use proper crypto0 name
  arm64: dts: rockchip: add rk3328 crypto node
  arm64: dts: rockchip: rk3399: add crypto node
  crypto: rockchip: store crypto_info in request context
  crypto: rockchip: Check for clocks numbers and their frequencies
  crypto: rockchip: rk_ahash_reg_init use crypto_info from parameter
  crypto: rockchip: permit to have more than one reset
  crypto: rockchip: Add support for RK3399

 .../crypto/rockchip,rk3288-crypto.yaml        | 127 ++++
 .../bindings/crypto/rockchip-crypto.txt       |  28 -
 MAINTAINERS                                   |   7 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi      |  11 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |  20 +
 drivers/crypto/Kconfig                        |  15 +
 drivers/crypto/rockchip/rk3288_crypto.c       | 506 ++++++++--------
 drivers/crypto/rockchip/rk3288_crypto.h       | 107 ++--
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 267 +++++----
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 543 ++++++++++--------
 include/dt-bindings/clock/rk3399-cru.h        |   6 +-
 11 files changed, 949 insertions(+), 688 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

-- 
2.35.1

