Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BCAC433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D0261057
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhEEU1b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbhEEU11 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:27 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E54C061761
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:30 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a10-20020a05600c068ab029014dcda1971aso2014611wmn.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DPi3GWFf6k778V89ksbErMgoKxDVX/Ki9ZfOEswj8Wc=;
        b=mu8aSZVBwYaPSF8UH/aaPLDoKDGLMm2P7jX1e+72RGxjGqhiquhRbvpngx8ak/j5JG
         vppOayT09Wvbpx3gDY9pVeF60+Qa9BqLJlhCVJCf2uEti+6fChf2+llFon20P2Gy7Bsl
         kV6b32k5xN+MNkKW3ZM1HoWaThc8OSRxs3NdAnoHc9r5J+iJiVkCfEB9qJfaProaEAr/
         eybmzMqRBW12ZoIV5eoouA6UBvlwWJMI0kmjDNkKwJjj/mrVOY7CRUcgmbtZPvF7kF+o
         6feH6cLmdZVe01D8FLQFl5iTOMZgJuf237zVIXD7IHpdPNlh6YB222wxs7UT7EMKrPQO
         sqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPi3GWFf6k778V89ksbErMgoKxDVX/Ki9ZfOEswj8Wc=;
        b=rMWMF5KIGBr0H/lobB7NZc85I19k1oRBFZVJuY2CyA93tX3eFjAdiICB/ckxm7rF/+
         2j6CHYu1n9feHqBV6LlRlHBMzisXyPSZBjGlHbF+TVpGD/lqjWGauBzZPPKF3i6LFmM8
         0ta/5kbG1C3yjBPYfg7tkAu7ULbhWixAGEeO/Bz3NajP9k4TTDGk/x5HZMZBypCm3ltN
         nF1xaRN9npRroSXRI3t8rmjUdzAEFkR8rny0x0I0xLvfOCpnAH8leDeXTv12F6FNALXE
         21kVLP2cZioVlAHrj3nsefjT2gmD0ZDmJlDbF8zQEvRRem3Kl9rIvVw7eS/T7Lvp1Eef
         5eXw==
X-Gm-Message-State: AOAM533r5QKNy7hl7+8jr5nCgVZUWZn4J+LXYs3JfsCOeyZCzGlmxnwh
        02gcsCHOq+Teg2Zy4aTaqoYcJg==
X-Google-Smtp-Source: ABdhPJwKq/kRYVK1eC9epDFRwCi1he4uYcedqIqwnaRlTJ+gR4PxjYAyPW6kePP1pp+RxJJxyZZBQg==
X-Received: by 2002:a7b:c191:: with SMTP id y17mr11586488wmi.19.1620246389196;
        Wed, 05 May 2021 13:26:29 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 05/11] crypto: ixp4xx: convert all printk to dev_xxx
Date:   Wed,  5 May 2021 20:26:12 +0000
Message-Id: <20210505202618.2663889-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert all old printk to dev_xxx.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ixp4xx_crypto.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 17de9e60adad..486a388c909f 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -452,7 +452,7 @@ static int init_ixp_crypto(struct device *dev)
 
 	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
 				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
-		printk(KERN_ERR "ixp_crypto: No HW crypto available\n");
+		dev_err(dev, "ixp_crypto: No HW crypto available\n");
 		return ret;
 	}
 	npe_c = npe_request(NPE_ID);
@@ -475,8 +475,7 @@ static int init_ixp_crypto(struct device *dev)
 
 	switch ((msg[1]>>16) & 0xff) {
 	case 3:
-		printk(KERN_WARNING "Firmware of %s lacks AES support\n",
-				npe_name(npe_c));
+		dev_warn(dev, "Firmware of %s lacks AES support\n", npe_name(npe_c));
 		support_aes = 0;
 		break;
 	case 4:
@@ -484,8 +483,7 @@ static int init_ixp_crypto(struct device *dev)
 		support_aes = 1;
 		break;
 	default:
-		printk(KERN_ERR "Firmware of %s lacks crypto support\n",
-			npe_name(npe_c));
+		dev_err(dev, "Firmware of %s lacks crypto support\n", npe_name(npe_c));
 		ret = -ENODEV;
 		goto npe_release;
 	}
@@ -521,7 +519,7 @@ static int init_ixp_crypto(struct device *dev)
 	return 0;
 
 npe_error:
-	printk(KERN_ERR "%s not responding\n", npe_name(npe_c));
+	dev_err(dev, "%s not responding\n", npe_name(npe_c));
 	ret = -EIO;
 err:
 	dma_pool_destroy(ctx_pool);
@@ -1487,7 +1485,7 @@ static int __init ixp_module_init(void)
 		cra->base.cra_alignmask = 3;
 		cra->base.cra_priority = 300;
 		if (crypto_register_skcipher(cra))
-			printk(KERN_ERR "Failed to register '%s'\n",
+			dev_err(&pdev->dev, "Failed to register '%s'\n",
 				cra->base.cra_name);
 		else
 			ixp4xx_algos[i].registered = 1;
@@ -1520,7 +1518,7 @@ static int __init ixp_module_init(void)
 		cra->base.cra_priority = 300;
 
 		if (crypto_register_aead(cra))
-			printk(KERN_ERR "Failed to register '%s'\n",
+			dev_err(&pdev->dev, "Failed to register '%s'\n",
 				cra->base.cra_driver_name);
 		else
 			ixp4xx_aeads[i].registered = 1;
-- 
2.26.3

