Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C0EC47096
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C22C61287
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhFAPNX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 11:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhFAPNV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 11:13:21 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D52C061760
        for <linux-crypto@vger.kernel.org>; Tue,  1 Jun 2021 08:11:39 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j14so14722496wrq.5
        for <linux-crypto@vger.kernel.org>; Tue, 01 Jun 2021 08:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gvFMmHfd1QAvd4odZ60W0gHJvaO9sQdIVoHfn0ziLzo=;
        b=OETe/M0NDxdyFgb2tcObhXOQI+9uiSA6tIzaoow8w7KTvB8aKGM6AVAwOT9Vz+21x/
         rS5je9hNXUAx4qw7jfq2v+vajcn98J+bqYTdL/Zq+fA567ipuKFBjxljqzdoXxPm6Djw
         n0CN3UAB5By9mRTyMk+a2x4c4cDrlHkY3+KUIh0iRuHyumzlUok1TWKujiP2bEfjz+AE
         HNQ6VGQsZQFbjOQEBbY7Dy9qnuzw4HrzXeYj0iLvJUSP5AEtQ13syOYYltuuLNsNg/i5
         5PZ6qkBuwzM6K0/DTi0t88aOy2egNYiKN8Hza5j8Sr5/ESPl8ZDjluap2bpzP+1Vt8x0
         HrOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gvFMmHfd1QAvd4odZ60W0gHJvaO9sQdIVoHfn0ziLzo=;
        b=T+X6eH5cmc46OVB46Ubc0ULjbsXZ/WTPEYNkIei2aUgG4WURHzRnehieKPUbEgnlbJ
         kEu9F7ti5o87/2WyUaTUQfa4o3WTNrGfp6SktLwEJmigTjmazcrKWR3LgWzBLwkrnU1C
         K/Ayn/R5gOmLImAn/DXgET4Ga5aLNntqGH0UvC90bbxONzxY9fR3+2LNqznfeg5188x2
         JPG/sB0ZsbiAimdRoo4fMM2xjIQAAD0euhNRTMYVn7nE4w/NOiqoGQYftNi8ArnpQeAx
         Iz8zx0HwQwyXq4+aHPjYl292vciTRnSH5FFlc+AJwj3yq6AAWJz63DHypxrao3Z0dVvu
         DSCw==
X-Gm-Message-State: AOAM530p24KcZanvqpHZ52yzez4xUj3CyVGmlmh2Vw9BD1eVFKGTAibz
        S9ECPNKhPo59cAFgTrFz4K/cgA==
X-Google-Smtp-Source: ABdhPJyu3vRuq8G/vnmF9Cp0cuxCRlnzDlsen2cu1StRDcTqjLwGH9suC7meaIha9/X408jxbld/PQ==
X-Received: by 2002:a5d:664c:: with SMTP id f12mr15059467wrw.206.1622560298189;
        Tue, 01 Jun 2021 08:11:38 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id f20sm22344163wmh.41.2021.06.01.08.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 08:11:37 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 0/5] crypto: add gemini/sl3516 crypto driver
Date:   Tue,  1 Jun 2021 15:11:27 +0000
Message-Id: <20210601151132.1893443-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gemini SL3516 SoC has a crypto IP.
This serie had support for it.

It was tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
Furthermore, it survives hours and gigs of write/read to a luks2 using xts(ecb-aes-sl3516).

Performance is quite good.
On a luks2 partition (2To with bs=4096), a fsck comes from 14m26(without CE) to 8m48(with CE).
So it is really usefull.

With bs=512, the performance is similar with software.

Changes since v1:
- reworded dt-binding subject patch
- fixed build with CRYPTO_DEV_SL3516_DEBUG

Corentin Labbe (5):
  dt-bindings: crypto: Add documentation for sl3516-ce
  crypto: Add sl3516 crypto engine
  ARM: dts: gemini: add crypto node
  ARM: gemini_config: enable sl3516-ce crypto
  MAINTAINERS: add gemini crypto sl3516-ce

 .../crypto/cortina,sl3516-crypto.yaml         |  50 ++
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/gemini.dtsi                 |   8 +
 arch/arm/configs/gemini_defconfig             |   1 +
 drivers/crypto/Kconfig                        |  19 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/gemini/Makefile                |   2 +
 drivers/crypto/gemini/sl3516-ce-cipher.c      | 388 +++++++++++++
 drivers/crypto/gemini/sl3516-ce-core.c        | 535 ++++++++++++++++++
 drivers/crypto/gemini/sl3516-ce-rng.c         |  61 ++
 drivers/crypto/gemini/sl3516-ce.h             | 347 ++++++++++++
 11 files changed, 1419 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml
 create mode 100644 drivers/crypto/gemini/Makefile
 create mode 100644 drivers/crypto/gemini/sl3516-ce-cipher.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-core.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-rng.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce.h

-- 
2.31.1

