Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36081CCA48C
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbiGYOHc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiGYOHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:30 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C8B165B6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:28 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z13so12857887ljj.6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rN8jYOVehuu3dO+n+b32giGGSLgkWgby9u0JmweOpzI=;
        b=aU7gzGVDCfF1zbEJ+RRAnz6f6z/HIkXICO+9eTKQKaKaOtrhDz2OWq0aH1mrF3D9hm
         ztUaNrj/UfrGYhs1fd4BokFaJJEFzmSEGL9/0cim+LpA4yq3sg/mvDIB5g6Kw98VXiOw
         /TgLym8YI7m3W9z5VpG6jD2JahtCfm255zRpgAo91CeNHrreocmcNLdPHp2xzoRvRMyX
         xUY370lSolVSj1PJ1CPh2vF1n7SKEdixPPhChr74MY7MVq2N0ytVdrLYyw3vQ+TfrYKo
         FGIfR7YbBlyWzAbp9zQp3e0BEtZx+nAzfdyWbAwd5e/YFtTgIf5lj+/e4pfapY8rluAe
         1D6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rN8jYOVehuu3dO+n+b32giGGSLgkWgby9u0JmweOpzI=;
        b=nRmba+A1lUYqfWjYGCiYw2LijYon6oJ3P+7f1a3P6R2ewerWVADssUArQgGFubAS73
         RC1vbgz9qbBueS0TLJeH+M78yc8RPuNTRJQF+k8pHadX6xtfzoBn/wrZrXGOEbKCKq+P
         5VkRTWjqDq/INNskV9TWYcRr0H0nSDQC2L6M9xFm5hYf0U/3tKHG8ZMuITBDXCsMCWZx
         M1eq5WLF7yju6+4TctbRC/XNSUHKvi92pg7Z6H6XKrwHvoxU9AYtDs6aIQwaHOJen0Z8
         BfS3ZKPY0nAiNdixpgp+ZhwuO60IiREMG9LlMG4AQtH2cmv/xk/bqswRUjt29rPN5A8t
         WK5Q==
X-Gm-Message-State: AJIora+EVkIguwn8dFwZxjqu6ISRlxZQz5k+CbR/dxHKjeCZKR7pcyXD
        LJU2yw9eeo+lbPdvTtQy5jr9HiZluxXStw==
X-Google-Smtp-Source: AGRyM1ty7gR21SbKWRLehmT4mU90C7+mFpjstmZxS4W5nnmffRbQxvMRTHnOK5DYNIc2/A/5HFfmpw==
X-Received: by 2002:a05:651c:32d:b0:25e:946:2740 with SMTP id b13-20020a05651c032d00b0025e09462740mr1429814ljp.378.1658758046151;
        Mon, 25 Jul 2022 07:07:26 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:25 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/15 v2] crypto: ux500/hash: Drop custom state save/restore
Date:   Mon, 25 Jul 2022 16:04:53 +0200
Message-Id: <20220725140504.2398965-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
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
ChangeLog v1->v2:
- No changes
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

