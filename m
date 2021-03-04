Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47652C43331
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 07:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B3964F13
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 07:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhCDHeW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 02:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCDHdw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 02:33:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404FCC061574;
        Wed,  3 Mar 2021 23:33:12 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b18so19988030wrn.6;
        Wed, 03 Mar 2021 23:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cxz2j8HGUHPiSHzceVEetuYSLp+UMokeayvePliJNIo=;
        b=nxO+pk/+yTm3XNbgFW8Hhz4vJLEsbr4IH/rf4TegEEF/D8dSlm9F/8g/UE6y0ectDu
         ocpCUFAn/vpl9zHd6koMl4JjLW0iferRffhZNKqjV1sx6LzizlSeRy9FulPjMo0Hs19A
         P8Rs2UPA2BiKX4wKCtK/IzJQHgkc7dvTznz4W3o35ECBPkzrWg3jOzlvTTDwpxCb0/m6
         O7F2jim2xgFn2y0Czm0qj5JMZ49YuLZuzNdWrGxqk2hIjEbKGlItFBSpdLd23HS3++H9
         Ojm2+PUl06MF32jvYDNKpbfZS+1NaPplXrco9DnX3eMakVjGNWsomygAFusS0LM9d38X
         MaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cxz2j8HGUHPiSHzceVEetuYSLp+UMokeayvePliJNIo=;
        b=OOIjdrfpurg76JEdvXhQGI2UO+C2gTCOKA6f9iNxd8mzAft/wVuNxBYwyTOZxoE0k0
         CVTrI98F+QH+W7Gr/P3kG/KkNGImQHgbma4Es4nBUJGbCbHI02ZZIww4GclniIZ2zceD
         YN5llFRdCi0Qej85mfcNJfJsp3KQC96A1R325bpo1DB5Z66CsSCHJjBiNm1rlmwyNNcb
         Bmqjob8yfuM6ldWUAANrjLIA0m6STQn5bnz90YUOwqQZs+9VAW0RGU4L4TNTwv/23sw2
         lYCYEWB2MW71G/0SXpWRxq+GDk2MLMJ+T1bo62ayvOj5r9TPEg19CnYl2F6G2ryT5L9o
         zW0g==
X-Gm-Message-State: AOAM532troC++Qixdvd5TG2zwf9dN1qk4DvJWFUkcvvcm3CZwVfZMwDf
        K6bpoo5rLyyKYZO2Z0aVgQYssDnsSXMDqTB6
X-Google-Smtp-Source: ABdhPJwsLaf04ly/s5i0z19++Xyjltzm9ii40XstGgGQPy5CUStuDXmZq8hTa3xWVDDYJ0qR1KHRpQ==
X-Received: by 2002:a5d:528f:: with SMTP id c15mr2546510wrv.142.1614843190972;
        Wed, 03 Mar 2021 23:33:10 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id j30sm18328811wrj.62.2021.03.03.23.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 23:33:10 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v5 0/2] hwrng: bcm2835: add reset support
Date:   Thu,  4 Mar 2021 08:33:06 +0100
Message-Id: <20210304073308.25906-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v5: remove reset_control_rearm() and apply on latest herbert/cryptodev-2.6.git.
v4: fix documentation, add reset_control_rearm().
v3: make resets required if brcm,bcm6368-rng.
v2: document reset support.

Álvaro Fernández Rojas (2):
  dt-bindings: rng: bcm2835: document reset support
  hwrng: bcm2835: add reset support

 .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 +++++++++++++++++
 drivers/char/hw_random/bcm2835-rng.c            | 10 ++++++++++
 2 files changed, 27 insertions(+)

-- 
2.20.1

