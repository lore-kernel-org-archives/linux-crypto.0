Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D1FC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815E3610FA
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343957AbhERPSZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 11:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243998AbhERPSZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 11:18:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4141CC061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:07 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b7so5043365wmh.5
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5XLrgKcPuW2RG/QFYOJNs7m0wLKHrRqbQaYGQgA+6jA=;
        b=g4AInn37TKs+rHdDQiuIinOGabpILvy3qmlYk+SMzlruGluvo8uixEh+z7/Q3IlxwY
         J8L5kcP7Gg98g4ZrWIWmypriG/Euzb3ff9fJQPZc9XT+wIJbxSkZNuyFiGdkFnLR6B35
         cgymxAK/Td0s0WPtICoFOWX81nwn5sj8kgCgtv2CX2RjZS8L0H2VrEbdJUBU1kKXRpOp
         AJB6rXjYYdG/xFrZ8cLcTjN/3EiHBgcFYjUG+bwSdaAfYDuk8jTyMsDy0aD+kpUfTVgL
         /yhKhKpOitAziTeotUeLd2dos6v9vz8Tiz78it7ANeOA6LJutPEZa9uHYmM9VrgGHGCK
         /LKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5XLrgKcPuW2RG/QFYOJNs7m0wLKHrRqbQaYGQgA+6jA=;
        b=nTerT2rPx8MTZj17uDFZTWdoxB5KZSroqC+kmDdFKLpJZIv3DfySGJKjoSl6zptsIr
         szjUbXn9vJcbVQHDPn7oON4Bbe364x+dCFWrqpBNzxu/aTYW5x3BqOQJ8ydzLDMi8pyF
         FkP8Sc9QZDLIh1piotwZl70KfMHKgRR0VjhOW9Xbb2p5jyfHS2e2+zjD+u8nNJqE4kX+
         Zh8EbC1SWVRNPQ/6nDIINifEZaGvsMxDWZZtIQ99mfo6C4QR6SEIXtC5F7mr4CTrNgU+
         ryU6Zp+Cl1QM3dYmeIaoVlB/svey59sPr4Qg91Ik0f0zL5x+2HNuPuWk6fnGaysYXzcC
         KWkw==
X-Gm-Message-State: AOAM531Fn871xtIZ0k4gCwUNT4OIz3J5B7PAx+0EU2SVU1BlzQEbU3BK
        0/u/N9GKwxIE/JOSpYTFFF9I3w==
X-Google-Smtp-Source: ABdhPJz9tQZ2SLQ0Asp0Uyces/FpCqs/O53si9jg9n0aLuVZ+a18Wfv+jVeWz87PqJ4uQIK8K0pFXA==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr5463476wmk.23.1621351025895;
        Tue, 18 May 2021 08:17:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z9sm18005808wmi.17.2021.05.18.08.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 08:17:05 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/5] crypto: add gemini/sl3516 crypto driver
Date:   Tue, 18 May 2021 15:16:50 +0000
Message-Id: <20210518151655.125153-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gemini SL3516 SoC has a crypto IP.
This serie had support for it.

Corentin Labbe (5):
  db-dinding: crypto: Add DT bindings documentation for sl3516-ce
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
 drivers/crypto/gemini/sl3516-ce.h             | 349 ++++++++++++
 11 files changed, 1421 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml
 create mode 100644 drivers/crypto/gemini/Makefile
 create mode 100644 drivers/crypto/gemini/sl3516-ce-cipher.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-core.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-rng.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce.h

-- 
2.26.3

