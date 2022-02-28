Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6433C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiB1TrR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiB1TrQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:47:16 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA0712AE6
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:38 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg16-20020a05600c3c9000b00380f6f473b0so65562wmb.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Jtav+ye5zt0JLObFlHB/P1ii2kpmM4YgE+fQMwFycY=;
        b=CNNLF4MgGchbX1I+o+yz78iK3EtrZSEGilx7b+5yATKdv5i5cZER41P0/dGoVDR8mQ
         fTe3qip40qKi7OwttqXMqJ7Cp5Sgu/sYYHARdf7AgJzA1hCAADBkMYFnmzHo1qO0mikl
         vyj2eERIXqi7TP4cE+FvV06xleJBlcz4yVJWPYE1qCJDDtR9tSTsy1XT1iNNQ7hD4RI/
         VAp1cpltliP6jmAkFxfDrVbVt2TyQ8hXwDDdkXI1x+WYrsEfabJTNtJp3HjVmUiZwz2f
         rO3Z9sJar52q22MXGp1BCeV/pMGqAb7kb7Yv9KgN+6gtbN1ZjdR2nGNy83cuwYgkwCEP
         hoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Jtav+ye5zt0JLObFlHB/P1ii2kpmM4YgE+fQMwFycY=;
        b=po5mV6FHJmOSOwDPXw9LdfxoheSN/3uQh3+8B/YVsOLPUKmCMJR9o2fd5s4cwCtHuE
         u+hH/CmMXTqdNYiAlB8fCIz76xKHqwbXUoC1y0lePCG1fspNU5NDjaOz+5HjKnkUQPLe
         nxpE9c2DSgzfW1518L3/h5DGICwCqrEWwQBN0L0llRkQpD5b8YooRNM4GgH01UoCHJKr
         3ipg7IRIu2O11/wy80HYDWG4MGFc2A9hEVtGijimkecrb6GRXwpnTMP/OVSY7KRoJ7Rf
         fPwEHpl+A1m80Y9f44/WoFjWcY0FW8NmvOZJwm5dWX7iYVq3fhYM5gnYAeTJFwTCbjLQ
         feGg==
X-Gm-Message-State: AOAM530/11iJl5AmcvKgVoXfBPDjquks0fgYxwSVFx+wBhgbqPyPPgll
        Oh51/fA+muhQekztRBorSmNv3w==
X-Google-Smtp-Source: ABdhPJwyJWqzDklkz7cVxk89jp/moqyfQCBYnpDhUWCT5StXL++rHv+NFwmzQLD2FTRIqS2G8tWanA==
X-Received: by 2002:a1c:f003:0:b0:381:17f5:21b8 with SMTP id a3-20020a1cf003000000b0038117f521b8mr14441311wmb.158.1646077243764;
        Mon, 28 Feb 2022 11:40:43 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:43 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 00/16] crypto: rockchip: permit to pass self-tests
Date:   Mon, 28 Feb 2022 19:40:21 +0000
Message-Id: <20220228194037.1600509-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The rockchip crypto driver is broken and do not pass self-tests.
This serie's goal is to permit to become usable and pass self-tests.

This whole serie is tested on a rk3328-rock64 with selftests (with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)

Regards

Corentin Labbe (16):
  crypto: rockchip: use dev_err for error message about interrupt
  crypto: rockchip: do not use uninit variable
  crypto: rockchip: do not do custom power management
  crypto: rockchip: fix privete/private typo
  crypto: rockchip: do not store mode globally
  crypto: rockchip: add fallback for cipher
  crypto: rockchip: add fallback for ahash
  crypto: rockchip: better handle cipher key
  crypto: rockchip: remove non-aligned handling
  crypto: rockchip: rework by using crypto_engine
  crypto: rockhip: do not handle dma clock
  ARM: dts: rk3288: crypto do not need dma clock
  crypto: rockchip: rewrite type
  crypto: rockchip: add debugfs
  arm64: dts: rockchip: add rk3328 crypto node
  crypto: rockchip: add myself as maintainer

 MAINTAINERS                                   |   6 +
 arch/arm/boot/dts/rk3288.dtsi                 |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi      |  12 +
 drivers/crypto/Kconfig                        |  10 +
 drivers/crypto/rockchip/rk3288_crypto.c       | 283 +++--------
 drivers/crypto/rockchip/rk3288_crypto.h       |  68 ++-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 214 +++++----
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 449 +++++++++++-------
 8 files changed, 533 insertions(+), 513 deletions(-)

-- 
2.34.1

