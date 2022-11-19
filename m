Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BDFC433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Nov 2022 22:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiKSWMm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Nov 2022 17:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiKSWMl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Nov 2022 17:12:41 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04E815806
        for <linux-crypto@vger.kernel.org>; Sat, 19 Nov 2022 14:12:39 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id j16so13568836lfe.12
        for <linux-crypto@vger.kernel.org>; Sat, 19 Nov 2022 14:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D5VOb5boGkdAYN6wKDObbKOcC5cfqGCj4Tcvp7hhPw0=;
        b=F5DfA8zjOi7beeJdVQtVgCup1BtOIitT3erlErg9wAmPCv42ZXpSQnLI84+iykBhXw
         0MQFsyMUhsDEv+vO8W+4DxirGQcVpNaUzgk6qsb7rS8f+xBUoUdMptcQRzSxVEBYtY9v
         chwetUJsG8oIFJ8aypQpc3Vt7cvSiy5/efvCAQzhsVTeT1iW8CeiU05lIyTHnCNqHcmr
         Mwak19tK12UGG0bd30rKm2qhWmu13CVFFOLibvZ0j8MChzbcbU9FLKgZkQAkZtxY1qIi
         NAakEpbDLAwXSRXeo44aD5v6IPQzOr6qScdTEbjrI40shdUglBhRYRb0FQeiGJXkKoyB
         86vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5VOb5boGkdAYN6wKDObbKOcC5cfqGCj4Tcvp7hhPw0=;
        b=1RlxOcBSuQlPWBjSfSKa5EBhy4uzDTIhD/O6rzcHE4u5/eA37FO0jOYpuyDgY3A2Eo
         yRFaNtKa6kgeuAZw1d0gpoV5TRMMIIqAI72K+IUXIuotWzmBRSV7khsYj8zEDNBz4Wz8
         6gledisychi2/lcf/cnL11MUwu54bxVV3E6SEbiLpoAV55LW9/6E8awmdRJ6+fAHEXmP
         VQhg1cIZ4KYQxzBOT6Gvwaux7NN2HpIbiTt+EmnZvfhKuJV22ngNN7mhmyunj7nPsRyS
         0BnBvBAzzXsHwh7/qmMOY0nffm8fSKgbVTlK1sGK7U7JOQhhjtIMiqJ+jfkLEA5iJUSq
         /WiA==
X-Gm-Message-State: ANoB5pn80MZxHS9OXRxzMdasTJYK0pYbGjf0/b6xxYN3X0lLgBkDJwYl
        iJ4CjsKcCxAr1mAsBvTqZ4pCzPDFUdo9Ng==
X-Google-Smtp-Source: AA0mqf7MgVPBg/OSTJADJi77bKgVTVEQO6743G5WYfPmcPFNiVsL3ispQYTXT6QXRgKlin6dTwjzcQ==
X-Received: by 2002:a05:6512:b9a:b0:4ae:611c:6549 with SMTP id b26-20020a0565120b9a00b004ae611c6549mr4843424lfv.231.1668895957890;
        Sat, 19 Nov 2022 14:12:37 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id u3-20020a05651220c300b00496d3e6b131sm1234254lfr.234.2022.11.19.14.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 14:12:36 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v1 0/4] crypto: stm32 - reuse for Ux500
Date:   Sat, 19 Nov 2022 23:12:15 +0100
Message-Id: <20221119221219.1232541-1-linus.walleij@linaro.org>
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

 .../bindings/crypto/st,stm32-cryp.yaml        |   32 +
 drivers/crypto/Makefile                       |    2 +-
 drivers/crypto/stm32/Kconfig                  |    4 +-
 drivers/crypto/stm32/stm32-cryp.c             |  334 +++-
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
 14 files changed, 315 insertions(+), 2710 deletions(-)
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

