Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B86C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiGUNoe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiGUNnX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:23 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA3784ECB
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a9so2823324lfk.11
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rVMziS2gK6F8Ul17CTqouVgo6gQ0LapeQ4hzWQIcyy4=;
        b=SYjOlPf1cAqlODqUyBPXO//eShu/N3znxopvhxE+fjSvrd8flnJQbwRNHX1U6DbMxy
         HMonZjgigfdxiVWbbZ1cFxgn9kIOnIAOovdO6csGRjmyauyUMth4iRqkp2ISuNetZ4/x
         EZ47kmLdrap0zd8sb5avVQ1woj6B1Id3UcjYXGm3ZceWIPeRQhn+67r8zVuh4izqbVs1
         VCy12E9rtnR2EjUV9xrDomrAew+kHwFYh4zdpRH/TSA+g0M9FjMYWVd3rmKQndNkoNrP
         DGJq/Ucb2Azyqv9/15Ss1L3810LKLJTw2e9cWdA017CS0GGYJZSE5lLQDTS7Yy7+nT6R
         Gu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rVMziS2gK6F8Ul17CTqouVgo6gQ0LapeQ4hzWQIcyy4=;
        b=ZyIOeJOfZ+Fz5rdepllP7hNLlImRXqmsExDVrDGBWBb696tNUUgc9O3RUsSbM39MxO
         oX8w2+soCq3lc//6Ozd3O+BJGIiXr7vLO1FgjbRiSFxVjlcBsrFOZ6PN9UvZ9QEOnXNG
         zWv1xK6cdt5R8yN6c4ElmZQpgv4yX9Wz8HTwkHsmNB+LaPOEyYQJtD2JrYApHq60Y76t
         Cg7C8/oGoE5Q3SZOiJWHqgTQj1qz0Z573GTj1fDNC7CV2uK/WlWSalHYUh4fKKM0boz1
         X9A3Mu8hlDSbsAFoKYcsHPgAiWD6AjO48+UajCG2NzGq3cOHWk5Mx1fm0uEllRUKFgND
         8Yhw==
X-Gm-Message-State: AJIora9bl4svYusAL4uqCCcie1lp6MyaQ8K5ArBS7ySuLvXI/EjGEudZ
        H0p1epJgVc7eDFTuDmkbENio/Z2s409qkg==
X-Google-Smtp-Source: AGRyM1uy1ncvXrCVToQw4cQD0wfxojkoilzylRtCF1kLNmDdLVeSbqJhQYapplH7JF0p4tGXCOOQXg==
X-Received: by 2002:a05:6512:2527:b0:489:ec08:7ada with SMTP id be39-20020a056512252700b00489ec087adamr21822553lfb.621.1658410981954;
        Thu, 21 Jul 2022 06:43:01 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:01 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/15] crypto: ux500/hash: Drop custom state save/restore
Date:   Thu, 21 Jul 2022 15:40:39 +0200
Message-Id: <20220721134050.1047866-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the code that is saving and restoring the device state
as part of the PM operations: this is the job of .import and
.export, do not try to work around the framework.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 52 +++++----------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 884046e87262..e6e3a91ae795 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -243,13 +243,11 @@ static int get_empty_message_digest(
 /**
  * hash_disable_power - Request to disable power and clock.
  * @device_data:	Structure for the hash device.
- * @save_device_state:	If true, saves the current hw state.
  *
  * This function request for disabling power (regulator) and clock,
  * and could also save current hw state.
  */
-static int hash_disable_power(struct hash_device_data *device_data,
-			      bool save_device_state)
+static int hash_disable_power(struct hash_device_data *device_data)
 {
 	int ret = 0;
 	struct device *dev = device_data->dev;
@@ -258,12 +256,6 @@ static int hash_disable_power(struct hash_device_data *device_data,
 	if (!device_data->power_state)
 		goto out;
 
-	if (save_device_state) {
-		hash_save_state(device_data,
-				&device_data->state);
-		device_data->restore_dev_state = true;
-	}
-
 	clk_disable(device_data->clk);
 	ret = regulator_disable(device_data->regulator);
 	if (ret)
@@ -280,13 +272,11 @@ static int hash_disable_power(struct hash_device_data *device_data,
 /**
  * hash_enable_power - Request to enable power and clock.
  * @device_data:		Structure for the hash device.
- * @restore_device_state:	If true, restores a previous saved hw state.
  *
  * This function request for enabling power (regulator) and clock,
  * and could also restore a previously saved hw state.
  */
-static int hash_enable_power(struct hash_device_data *device_data,
-			     bool restore_device_state)
+static int hash_enable_power(struct hash_device_data *device_data)
 {
 	int ret = 0;
 	struct device *dev = device_data->dev;
@@ -309,12 +299,6 @@ static int hash_enable_power(struct hash_device_data *device_data,
 		device_data->power_state = true;
 	}
 
-	if (device_data->restore_dev_state) {
-		if (restore_device_state) {
-			device_data->restore_dev_state = false;
-			hash_resume_state(device_data, &device_data->state);
-		}
-	}
 out:
 	spin_unlock(&device_data->power_state_lock);
 
@@ -1597,7 +1581,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	}
 
 	/* Enable device power (and clock) */
-	ret = hash_enable_power(device_data, false);
+	ret = hash_enable_power(device_data);
 	if (ret) {
 		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 		goto out_clk_unprepare;
@@ -1625,7 +1609,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	return 0;
 
 out_power:
-	hash_disable_power(device_data, false);
+	hash_disable_power(device_data);
 
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
@@ -1666,7 +1650,7 @@ static int ux500_hash_remove(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
-	if (hash_disable_power(device_data, false))
+	if (hash_disable_power(device_data))
 		dev_err(dev, "%s: hash_disable_power() failed\n",
 			__func__);
 
@@ -1706,7 +1690,7 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
-	if (hash_disable_power(device_data, false))
+	if (hash_disable_power(device_data))
 		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
 			__func__);
 }
@@ -1720,7 +1704,6 @@ static int ux500_hash_suspend(struct device *dev)
 {
 	int ret;
 	struct hash_device_data *device_data;
-	struct hash_ctx *temp_ctx = NULL;
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
@@ -1728,18 +1711,7 @@ static int ux500_hash_suspend(struct device *dev)
 		return -ENOMEM;
 	}
 
-	spin_lock(&device_data->ctx_lock);
-	if (!device_data->current_ctx)
-		device_data->current_ctx++;
-	spin_unlock(&device_data->ctx_lock);
-
-	if (device_data->current_ctx == ++temp_ctx) {
-		ret = hash_disable_power(device_data, false);
-
-	} else {
-		ret = hash_disable_power(device_data, true);
-	}
-
+	ret = hash_disable_power(device_data);
 	if (ret)
 		dev_err(dev, "%s: hash_disable_power()\n", __func__);
 
@@ -1754,7 +1726,6 @@ static int ux500_hash_resume(struct device *dev)
 {
 	int ret = 0;
 	struct hash_device_data *device_data;
-	struct hash_ctx *temp_ctx = NULL;
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
@@ -1762,14 +1733,7 @@ static int ux500_hash_resume(struct device *dev)
 		return -ENOMEM;
 	}
 
-	spin_lock(&device_data->ctx_lock);
-	if (device_data->current_ctx == ++temp_ctx)
-		device_data->current_ctx = NULL;
-	spin_unlock(&device_data->ctx_lock);
-
-	if (device_data->current_ctx)
-		ret = hash_enable_power(device_data, true);
-
+	ret = hash_enable_power(device_data);
 	if (ret)
 		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 
-- 
2.36.1

