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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD9BC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 19:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8060C64E02
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 19:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbhBVTqB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhBVTpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Feb 2021 14:45:54 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383C7C061574;
        Mon, 22 Feb 2021 11:45:14 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t15so20252379wrx.13;
        Mon, 22 Feb 2021 11:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPbE9zIO7C3ZegNNseiEJ5pJf5Z9XxS+fBY7BI4UsKc=;
        b=X1ewBr7YDN88ESxbLjTLm4sAgEXHDtKXYXhlg5FRiO3hEA1/ef+z1xr96Z7VOxiFqt
         Z5z+kDH8HhduClkAKR7A6kRHgQVsG6q/6yLCnFkDkKAkpDqq3gpMqc/fw9MCseVd4kRm
         3hKwxaF3sqEj2IuLC2U1/6b5YrnvlUMZNVA4crWWOMW+LU+kS4xDtfusy//QI29WtbUL
         1jcLtSywLxzfR+8nCVsaumCND0JXCTI9c0x9yJkSqoJEaAskdK/6iVq5ntls2ytmhfQF
         L51k4lisGwVyCWOM27NjSgsbYe/OMSu7L22QhLTaV+aq1vT2qewffHPgBzrQB4WuESL+
         78zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPbE9zIO7C3ZegNNseiEJ5pJf5Z9XxS+fBY7BI4UsKc=;
        b=QQj3cjZwAR0DprwkbXiUcQVZiIYxvHgtqGgs4xdweBs2iqpHQ/4iL4BxCY8MvyaZ1+
         BKQ2nh0usa3zDLBYmJ5p0LYHrPXqj9Vf/PPfR+Yq1dRWSvCsXA9M5A44TX2NmCUclhsY
         0E6zQZnM9GAiuWKxVoDTT2Bpf868yogbgoE0jQqVFdb0BpwDNBzgXQj+67yoZHEJhZO7
         hMgV4hXenLb/9gn84o9y8Cpke3DYkP8YeZ0MQCxwazyoy6OZ6x8LNDayw3O3hdaMbnuL
         byIcA8DV2GCnqZ9ME6moY7yxdMkZq65Mjwn5kxiRdSwaoSp2a23wWBgEpK0ImTJ1dZSV
         RjwA==
X-Gm-Message-State: AOAM5306qFpgOq9Eqn9xKKjfn6jbqqGKF7q97GX34Qh8zzw/rpkBF3PP
        dsXFYMX7b6Yr4ymATy556BU=
X-Google-Smtp-Source: ABdhPJzvvU7tVJfdPp9/d3eTZl7uQuGm9uJru4YNr48hffjIToW/ZPyg0ap4JTVyYe8ionAO6H5Drg==
X-Received: by 2002:adf:8545:: with SMTP id 63mr22346800wrh.128.1614023112982;
        Mon, 22 Feb 2021 11:45:12 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id w11sm7376427wru.3.2021.02.22.11.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 11:45:12 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: bcm2835: add reset support
Date:   Mon, 22 Feb 2021 20:45:10 +0100
Message-Id: <20210222194510.14004-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
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

