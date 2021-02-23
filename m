Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D8DC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 16:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC0764E60
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 16:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhBWQCY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhBWQCW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 11:02:22 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91691C06174A;
        Tue, 23 Feb 2021 08:01:39 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b3so23092088wrj.5;
        Tue, 23 Feb 2021 08:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s5r6aoP8yUhDgWY4u8j/36byZXYgA21Asmj6U6dj7SQ=;
        b=Z6dUngibA3k2Zhdndsnjl7qXctPhCY0w7C9P9gjVTv8imnAyzSJn0bI5LDTWyIJfbA
         9fmGK7lYVVJmslUpoG7zLGtN62SB4i3w/4HlJMRcMaoX4BhRWnxH+WyP9M3jYWGQr//L
         ZL7UbFQja2YtcTPHeDh3pnrj7HOQF2NF3cCcTK7ziy4a5Ue2/hhVl/j01FNLQ6xM2knY
         M6cVgnFkw6TfTgN5zuBD/2JVOLUPGAnN7gOOTwtsB0YaXNZs+wm30PyZZqv5F+I2JRul
         BlnhwGYwhEAZ4Z59y5Z5oY/O7kY+Gvcg630FOankem2YkWX6NCLPMjbfUjb6eMh6GFTZ
         xa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s5r6aoP8yUhDgWY4u8j/36byZXYgA21Asmj6U6dj7SQ=;
        b=HG9EfCYqe8gjuj1Gr3zut8Hh8ZNqowKSCvHX4YoeA2OuO/q5BfxoyByfGR1yVh636n
         mAu/eJwjnJvrFY/Rt/vpJ8JcovZFodYjLEPx5zFDGghUp6FegLCoaZb+cIDCpLhMvWGj
         ED5kRYOdBAziRdCLDlDUNkBjCOs7zeJHAhLfVxqiRowZMyuzulI1leAqOVFpZhJFnlWd
         WT4b2tcz1XcA9aDnEO3Pu2kUj4bGQj69s2FxsAI1VST4NfcS0CnJr/zNizeMlxEPDaVB
         0B4ap7pe2phSxE5XpUQ5iTcr11ctdcvXUJwLmSZgRAUTaV6reI1VczCwIPT/zIg8qJRK
         I9fA==
X-Gm-Message-State: AOAM532Rr9b7YEMmT1z8QSjU1OEHOnRcPD+FXKu3bCjx6ZkaBl6L5WSK
        SOusVr4HhYN3yWp7Zq2L9yk=
X-Google-Smtp-Source: ABdhPJwupnnvXFwHC3i/kzK26c7qamwCkq7cEOkWgqeQU0/8URXkmDCziwuLip7VcGDHeBw3PlTXLw==
X-Received: by 2002:a05:6000:1a8c:: with SMTP id f12mr26949127wry.173.1614096098283;
        Tue, 23 Feb 2021 08:01:38 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id h15sm33999381wrh.13.2021.02.23.08.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 08:01:37 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= 
        <nfraprado@protonmail.com>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwrng: bcm2835: add reset support
Date:   Tue, 23 Feb 2021 17:01:31 +0100
Message-Id: <20210223160131.29053-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210223160131.29053-1-noltari@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
 <20210223160131.29053-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM6368 devices need to reset the in order to generate true random numbers.
This is what BCM6368 produces without a reset:
root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
rngtest 6.10
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 0
rngtest: FIPS 140-2 failures: 1000
rngtest: FIPS 140-2(2001-10-10) Monobit: 2
rngtest: FIPS 140-2(2001-10-10) Poker: 1000
rngtest: FIPS 140-2(2001-10-10) Runs: 1000
rngtest: FIPS 140-2(2001-10-10) Long run: 30
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=37.253; avg=320.827; max=635.783)Mibits/s
rngtest: FIPS tests speed: (min=12.141; avg=15.034; max=16.428)Mibits/s
rngtest: Program run time: 1336176 microseconds

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: no changes.

 drivers/char/hw_random/bcm2835-rng.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 1a7c43b43c6b..1b93a896d8e8 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/printk.h>
 #include <linux/clk.h>
+#include <linux/reset.h>
 
 #define RNG_CTRL	0x0
 #define RNG_STATUS	0x4
@@ -32,6 +33,7 @@ struct bcm2835_rng_priv {
 	void __iomem *base;
 	bool mask_interrupts;
 	struct clk *clk;
+	struct reset_control *reset;
 };
 
 static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
@@ -94,6 +96,10 @@ static int bcm2835_rng_init(struct hwrng *rng)
 			return ret;
 	}
 
+	ret = reset_control_reset(priv->reset);
+	if (ret)
+		return ret;
+
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */
 		val = rng_readl(priv, RNG_INT_MASK);
@@ -159,6 +165,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
+	priv->reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(priv->reset))
+		return PTR_ERR(priv->reset);
+
 	priv->rng.name = pdev->name;
 	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
-- 
2.20.1

