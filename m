Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B377C4332D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 07:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F59964F0A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 07:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhCDHeX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 02:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhCDHdy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 02:33:54 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AC9C06175F;
        Wed,  3 Mar 2021 23:33:14 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v15so26485454wrx.4;
        Wed, 03 Mar 2021 23:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nKsLCh+6twuWj2QnD4IJjKFGoE1CDwaYbrWfJko6FQg=;
        b=PM7DH0DCgsIy5KSnYy4NPGqpPLALl4pHepSUZZp+7gOWJK/nz8Cz3HaJfTuSI0XoDj
         7W6ocLN/+Ck53cPaHif72uqdFR8IiKtjfe8ZzgHHNZ1zEw+4iNtm+im5JY0byoAfaanA
         yTZSJK/DA5FsOdDzB0svKlw5k5Y4rfUPR46dUY89crhuOIdq9vSRSKke3o1tazJSV1sv
         kP6vDEogVfnhL8SMMwesYUuAv8T1j3EyIJRwWqsT6RYdQ63KyXMi7maXcIhXTrxD7dh9
         D9UElGzyGEqZ8eEciUuFBUautAbwuNulbr2Vh8bZVL1wnWpXLZqxoOUSwcGOJoDZ1I81
         By0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nKsLCh+6twuWj2QnD4IJjKFGoE1CDwaYbrWfJko6FQg=;
        b=rjPhipiA2RT73TihznkBWeSgsMLkdS6TTGYRPt1JrSUdqQqwQDNsc6gWFhpZQVvoui
         flDo+YbG/6RcU6A9yjhgdfJC2zUBa2bhB5hd1qMcCWV4564oWG27vmw1QXbYeq0FN1UE
         kFWRFvqbwhfjCwCdCJaZs74BkezTuyuwktWKyRPenyJ0UDuhAL8G0EqKJ41USiiGRgoU
         cmynDfRhYIFKawGBH1rJpdBrFM1GPz8zBuiMfJU7pt4LgCMpPTOCVdC8+6l9SzyWOwV0
         s818y0SpzhFtnNgmQpv4KEUEu0t4UHR4751yrz3+PbtuEExBJ0U8gBkVR2XFgSuS2v2O
         nZ9Q==
X-Gm-Message-State: AOAM530394qZCV8BoQe9/uVOnTaL6ePiK9dcS6mPtw5EtQipooBcMx0m
        plvVmOglPe/aoKrQFsFhXdo=
X-Google-Smtp-Source: ABdhPJwnhIZqeUh7kvfjBKqyBCUniY00joSs9fOdx+kTifv4VoGxHTeO1PV7UoAn6mVxjXF8LRcCjw==
X-Received: by 2002:a5d:5051:: with SMTP id h17mr2538503wrt.80.1614843193036;
        Wed, 03 Mar 2021 23:33:13 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id j30sm18328811wrj.62.2021.03.03.23.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 23:33:12 -0800 (PST)
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
Subject: [PATCH v5 2/2] hwrng: bcm2835: add reset support
Date:   Thu,  4 Mar 2021 08:33:08 +0100
Message-Id: <20210304073308.25906-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304073308.25906-1-noltari@gmail.com>
References: <20210304073308.25906-1-noltari@gmail.com>
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
cat: write error: Broken pipe

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v5: remove reset_control_rearm().
 v4: add reset_control_rearm().
 v3: no changes.
 v2: no changes.

 drivers/char/hw_random/bcm2835-rng.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index be5be395b341..e7dd457e9b22 100644
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
@@ -92,6 +94,10 @@ static int bcm2835_rng_init(struct hwrng *rng)
 	if (ret)
 		return ret;
 
+	ret = reset_control_reset(priv->reset);
+	if (ret)
+		return ret;
+
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */
 		val = rng_readl(priv, RNG_INT_MASK);
@@ -156,6 +162,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
+	priv->reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(priv->reset))
+		return PTR_ERR(priv->reset);
+
 	priv->rng.name = pdev->name;
 	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
-- 
2.20.1

