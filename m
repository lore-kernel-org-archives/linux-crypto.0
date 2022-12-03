Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E467DC352A1
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Dec 2022 09:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiLCJP2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Dec 2022 04:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiLCJP2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Dec 2022 04:15:28 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68D45AE31
        for <linux-crypto@vger.kernel.org>; Sat,  3 Dec 2022 01:15:25 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id d3so7938875ljl.1
        for <linux-crypto@vger.kernel.org>; Sat, 03 Dec 2022 01:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YuE7G0Zuy+PD6cWtPenlDgVRxm7weRAeqkpn2x6Okns=;
        b=qcqSWJs+QhUdRNk416qswmQSd0DEVPaIZ8o89Fr0ha5DUab5ikm4bdY1aycjMvqV6+
         57mKiHt8r7ldO840a5S0HPEuWrG961nI75ojMzKoVfgAfhMPph5zcDd501JaccVzQ5eT
         FTZYPUXFyv9H9OktBTlY9WEhnWNLCSheDXBppVRyUzAFPBq675yxBfdhlEelDueMV+S9
         zkU0kisE0hLlOzxnceWLj4ZyfncoZYNQgVv1GNTzqm3xAw6a2VPAW4EyO7O8uFUCq/1n
         5TYAmQDfUwCYtjsY25ajiMjHRhXYrVmXyZkzxyhSFbYxmaH6OZl3He2DHRA05UH9PlMb
         aGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YuE7G0Zuy+PD6cWtPenlDgVRxm7weRAeqkpn2x6Okns=;
        b=K679UzPl8zEHY/AFCiEtortcnUhD+kZtGwssfeVyvkPGAL5tlsGi3xwHuCnkYL1Jhz
         nhvjYanp0AJ1ikK11Az2ZdFNBOFS0E3lKILlWpoHq2iMexWfYJgWSS/l0nvrT5VuaU6C
         soFKaS2BuYy4y3XSBvD5xtLoO5w2nLNEbKsfeIWMKUSVqKS2nCHzklPNT0BojrITTYjY
         6Y+Z5YC2HxiGN80Hh56IBZFqPazQDQPNVKAfqbHgugZrPhyLU17LRYOYRcXIyZ3yJa3p
         BDddtLPbX999/9hWcvvWswca5k3KYLL1szDRbWcnaHelq+Ixkp5sq9eHWDqDioOXxw5k
         MllA==
X-Gm-Message-State: ANoB5pmV+soDRBli8nw9CxLmA6q4srOVD+5xeCrMD0EpmH3hMDnLAIz4
        244LIks4NTO05AebVSxm3U34EDyn1U9PnYjH
X-Google-Smtp-Source: AA0mqf7zz1jLQJg5imib3q6HD0zLM8oYjK1JmfBTTUMrobcuqFN9hWrfobjmUGIN49FDVr9wR1fxlQ==
X-Received: by 2002:a05:651c:200c:b0:278:eef5:8d18 with SMTP id s12-20020a05651c200c00b00278eef58d18mr25114878ljo.240.1670058923708;
        Sat, 03 Dec 2022 01:15:23 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id v4-20020a2ea604000000b0026dce0a5ca9sm800132ljp.70.2022.12.03.01.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 01:15:22 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 0/4] crypto: stm32 - reuse for Ux500
Date:   Sat,  3 Dec 2022 10:15:14 +0100
Message-Id: <20221203091518.3235950-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Experimenting by taking some small portions of the Ux500
CRYP driver and adding to the STM32 driver, it turns out
we can support both platforms with the more modern STM32
driver.

ChanegLog v2->v3:
- Fix a kerneldoc warning.
- Collect ACKs.
ChangeLog v1->v2:
- Minor changes to the base patches, see per-patch
  ChangeLog.

Upsides:

- We delete ~2400 lines of code and 8 files with intact
  crypto support for Ux500 and not properly maintained
  and supported.

- The STM32 driver is more modern and compact thanks to
  using things like the crypto engine.

Caveats:

- The STM32 driver does not support DMA. On the U8500
  this only works with AES (DES support is broken with
  DMA). If this is desired to be kept I can migrate
  it to the STM32 driver as well.

I have looked at doing the same for the Ux500 hash, which
is related but I am reluctant about this one, because
the Ux500 hardware has no interrupt and only supports
polling. I have a series of modernizations for that
driver that I have worked on and will think about how
to move forward.


Linus Walleij (4):
  dt-bindings: crypto: Let STM32 define Ux500 CRYP
  crypto: stm32 - enable drivers to be used on Ux500
  crypto: stm32/cryp - enable for use with Ux500
  crypto: ux500/cryp - delete driver

 .../bindings/crypto/st,stm32-cryp.yaml        |   19 +
 drivers/crypto/Makefile                       |    2 +-
 drivers/crypto/stm32/Kconfig                  |    4 +-
 drivers/crypto/stm32/stm32-cryp.c             |  413 ++++-
 drivers/crypto/ux500/Kconfig                  |   10 -
 drivers/crypto/ux500/Makefile                 |    1 -
 drivers/crypto/ux500/cryp/Makefile            |   10 -
 drivers/crypto/ux500/cryp/cryp.c              |  394 ----
 drivers/crypto/ux500/cryp/cryp.h              |  315 ----
 drivers/crypto/ux500/cryp/cryp_core.c         | 1600 -----------------
 drivers/crypto/ux500/cryp/cryp_irq.c          |   45 -
 drivers/crypto/ux500/cryp/cryp_irq.h          |   31 -
 drivers/crypto/ux500/cryp/cryp_irqp.h         |  125 --
 drivers/crypto/ux500/cryp/cryp_p.h            |  122 --
 14 files changed, 344 insertions(+), 2747 deletions(-)
 delete mode 100644 drivers/crypto/ux500/cryp/Makefile
 delete mode 100644 drivers/crypto/ux500/cryp/cryp.c
 delete mode 100644 drivers/crypto/ux500/cryp/cryp.h
 delete mode 100644 drivers/crypto/ux500/cryp/cryp_core.c
 delete mode 100644 drivers/crypto/ux500/cryp/cryp_irq.c
 delete mode 100644 drivers/crypto/ux500/cryp/cryp_irq.h
 delete mode 100644 drivers/crypto/ux500/cryp/cryp_irqp.h
 delete mode 100644 drivers/crypto/ux500/cryp/cryp_p.h

-- 
2.38.1

