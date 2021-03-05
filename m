Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10541C43381
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE59865019
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCEHBn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 02:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCEHBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 02:01:40 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84D2C06175F;
        Thu,  4 Mar 2021 23:01:38 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a18so864075wrc.13;
        Thu, 04 Mar 2021 23:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=z1XetKjHCD1nkGlnf/Dumzc1flLXCFdZJxrK1LQl/AU=;
        b=AncSwcHaKNhaUNvGU/ZDEHzZwdWwZWWSSJWgBASMhdDbzmmsxO75PY9Pgdp41K5p2Z
         wzwndus7xmuAK+ZSgL9pgoir6UA5gN5ehlvu61j6E1vLwWMbdnRI8wlCKnC5UFwRaG43
         aWhpqDD2D4eRB6FIZVf/XWj/QJFJCSNp8/5PrssVOEA1caVP/AgmadhAMHq7fgiy29nU
         Ef2sEf7BTBJ8E01fhP2dEyRNzOQ5qKTDClCiqgEMlozwcdsb5ycQx/57+jwEnjOycDvp
         DKTeNcjPujRu8+hUncggvndEGaccke+9+og1uIpQJTGeB9wvQ9WLGWr84A3uQotAjgME
         HfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z1XetKjHCD1nkGlnf/Dumzc1flLXCFdZJxrK1LQl/AU=;
        b=p0uoQAvdPN9JRx+DS/OjnN3+7/PPPzT+NM9zB3Fk/M2hpYnSdajhn/jAlIvDiG+kzR
         1qCOStgFpa3SiUrw5qABEdjd63k0nvXD8qoKnxhmq5Oa1ba6pS/sl9Lc6hVk/hOpiP2u
         wy6y69hS0nXovj44x0VEu2+OWAxpOO49aPMlf/8v9RYDZv2PSRJAr3fC0uCM3YedtWSH
         uZy+wnRG3UYI1c8Jmn6B+PTSISPeTgLIOlb3waqni5TGVNvTEdILNsJcgpWANSFToRmt
         M2fD+cHAEAyZuaEp2kclH2qaKYBIjJDButc3JIhujEiJ0o3r8tEkXacmlC53wsv7mjII
         KqKw==
X-Gm-Message-State: AOAM531E8UUhL+6xNL9a01qwckyioIcq7mYw1Z7pQI4tiGZTcoe4iNQD
        nm+PttChRp0Un/QKG8o3fY0=
X-Google-Smtp-Source: ABdhPJyBljkf3jOAJ6LZyQb5bqYgFgIUFjzoDgfhnXSg5I23sThciOmq9Cxh/hEeu1Jt4qFsUfpbZA==
X-Received: by 2002:adf:a418:: with SMTP id d24mr7554007wra.187.1614927697667;
        Thu, 04 Mar 2021 23:01:37 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id y18sm2799220wrq.61.2021.03.04.23.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 23:01:37 -0800 (PST)
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
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/3] hwrng: bcm2835: add reset support
Date:   Fri,  5 Mar 2021 08:01:32 +0100
Message-Id: <20210305070132.2986-4-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210305070132.2986-1-noltari@gmail.com>
References: <20210305070132.2986-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM6368 devices need to reset the IPSEC controller in order to generate true
random numbers.

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
 v6: fix commit description.
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

