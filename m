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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D44C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 08:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 314EA64EC8
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 08:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhBXIX1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhBXIXV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 03:23:21 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45CBC06178B;
        Wed, 24 Feb 2021 00:22:40 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 7so1000057wrz.0;
        Wed, 24 Feb 2021 00:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BAE1Kf2xIrmHE4CG7BguHd5TjWIGOPY8aBCToqo40i8=;
        b=ON9GDxXWl4h3rVmqaA5nrpo6rfrokVBk8WnqQJNPuEJChQJMKxHMfMkDO/IPttlRmo
         CG/KT7FuD0UYCnJMpvrUsAF8aozpxxuI23sH68noZOIHEk/hBeAsY32hfNtnkblkiIKL
         cvzlrmMBFYpmqWK0nTnJiAy8gyWL59EhlJ/Jp/M0GMtMxEHV0+vDuUbEXPnzcFVe7UNo
         el6+0Ifm2SWXhDhaqNOMmtm1mMp06Gf58D06eXh8nYdF0+0IFKMm6XAIEHpz1NvfbNkz
         wQGmdQeW8dGnR/ON+XFCWVn3A46cCQ7y3/bRjqlAJh1uJ2NrtfHdZaOFsaM6WiqRR70V
         dSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BAE1Kf2xIrmHE4CG7BguHd5TjWIGOPY8aBCToqo40i8=;
        b=Dosf9ZMZrHmlM/ewSIY9XOobtG+enggw2aDoYUtAdhZrw7Dg8BGzn0vgFOos9rhATB
         U4WU0rw2GOVoxruXuJsHe37N44YLv6COBb4yua3Wc5/qyi25xQzLke2MxyUuh48ENYi1
         AaXcXm2q5Rb6TnKEgDYgsry5Nm6XF7OdSZ1dP/aVv4jxyR0YpwVxcjChajUKaP96NuI2
         Ewj0eC8gALZuvsSy2iTTNzJu7fp8CAS0npb4GBJDq45UbP9PP4Bj2DGPHMRJyJ0EJMgP
         a8oSkOve9kBA5/winS61z1c2TUf7+j6RhK4UTPFyvYZfm1nKsh3a4uFX9f1l1x2ECokx
         s+fg==
X-Gm-Message-State: AOAM533+iACYvO1qGguuK6muCNZMJBUbIc7VTmZytExK/NSqwE7TMkpb
        ysT2ucC8zqV7z9twAbFxcSA=
X-Google-Smtp-Source: ABdhPJxch8/aZDZYHTx5t2OcR8JeSykfALOIoALHNOtek/GvbLq3PLOnVPo32xcrsVXe9UlVxg9OcQ==
X-Received: by 2002:adf:d0c5:: with SMTP id z5mr8562622wrh.289.1614154959564;
        Wed, 24 Feb 2021 00:22:39 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id u19sm1501628wmm.46.2021.02.24.00.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:22:39 -0800 (PST)
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
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] hwrng: bcm2835: add reset support
Date:   Wed, 24 Feb 2021 09:22:30 +0100
Message-Id: <20210224082230.29015-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210224082230.29015-1-noltari@gmail.com>
References: <20210223160131.29053-1-noltari@gmail.com>
 <20210224082230.29015-1-noltari@gmail.com>
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
 v4: add reset_control_rearm().
 v3: no changes.
 v2: no changes.

 drivers/char/hw_random/bcm2835-rng.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 1a7c43b43c6b..92658edaff22 100644
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
@@ -115,6 +121,8 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
 	/* disable rng hardware */
 	rng_writel(priv, 0, RNG_CTRL);
 
+	reset_control_rearm(priv->reset);
+
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
 }
@@ -159,6 +167,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
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

