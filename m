Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7152DC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiGYOIF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiGYOH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:58 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B1D17A94
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:38 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u20so5466992ljk.0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yi2lvCepVGwm5m2nCvkz5wHi60hhFaZd2WavgA33JOY=;
        b=nV1yHgodszVgqTT0PRJYaE3rLNkXFMwuZc/Ahb8HqL0mY/KHLAcHSZ8JJlqt6YwnW0
         QeLD5UJFti4ggBKJxaEV66nykmHrwfxFbhiHdSasBhRxHtbPHD5sVpp0x0S4LH1j6pkd
         tzDovRmoAIJ1l+2QLHTEKCzMk8lBbsWcHJ/Dr6q18jLUtSbV4giipH0LCWaIkECDnlfz
         fTpT8i+NWskM4ZebkuRxxjcMCmJA8a3t9FOWaDJpUZvH4sF1KQzQhKUzIYqPWA82+NPb
         /725E390S3N9gWCDIJ+VFvIkV0YFmWSvxNAzBwAGdoNquUK3bGk5Igi6j/gggiADhRRz
         1QnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yi2lvCepVGwm5m2nCvkz5wHi60hhFaZd2WavgA33JOY=;
        b=YKttJfvfLu1KA9/Br860zEVRUgV13TycXa6Dw97VpD0e60w7CHPCXpG3doclYU/dfw
         DE5CA1HexqT0Cp1h3qB8xY/67wPOPEr1aBVwJ504A7CSRYGuypZNMLLOaA2AJ82g/u7D
         OWhF7mtiuBjZlQvG+xgF1XVtq6dAgSzONDcxEC2iWY6pw7eFsKVNHV/kfYvJMKrRkFf/
         DxRDaKH6ZuGf7l3q9SysxVT+BI3R6G9KFIX+c82o2PD/ybOdia+c8BuVN+ulMXJyrsAv
         bJsic6ddxEv4c26v9vbctEZ9IcyNtSgqhPm/TY6LeDD6auvFQ/G5bq8/nBcpbC87fVzp
         u8VQ==
X-Gm-Message-State: AJIora83bfW6Kc55BWVTyL1C//RP4L0dh04bgSrHfzoVzEuWbQq4fng1
        fIad1EpBby93PmW1gpTq/Eq6CQWIEzWgKQ==
X-Google-Smtp-Source: AGRyM1vqpWKxgUjA7sTYscL5OkgIL6QlfPeVDFZYgyIRf7MHZLt+8BRJyTOCKlQqWHRwv/7irOFx4Q==
X-Received: by 2002:a2e:3109:0:b0:25a:8a0c:40e2 with SMTP id x9-20020a2e3109000000b0025a8a0c40e2mr4155142ljx.26.1658758056835;
        Mon, 25 Jul 2022 07:07:36 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:36 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 12/15 v2] crypto: ux500/hash: Drop regulator handling
Date:   Mon, 25 Jul 2022 16:05:01 +0200
Message-Id: <20220725140504.2398965-13-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This "APE" voltage is not handled by a regulator but by the
power domain, drop it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- New patch after noticing the power domain is handling this
  voltage.
---
 drivers/crypto/ux500/hash/hash_core.c | 38 +++------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 390e50b2b1d2..3bd58b60aade 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -24,8 +24,6 @@
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/crypto.h>
-
-#include <linux/regulator/consumer.h>
 #include <linux/dmaengine.h>
 #include <linux/bitops.h>
 
@@ -244,22 +242,17 @@ static int get_empty_message_digest(
  * hash_disable_power - Request to disable power and clock.
  * @device_data:	Structure for the hash device.
  *
- * This function request for disabling power (regulator) and clock,
- * and could also save current hw state.
+ * This function request for disabling the clock.
  */
 static int hash_disable_power(struct hash_device_data *device_data)
 {
 	int ret = 0;
-	struct device *dev = device_data->dev;
 
 	spin_lock(&device_data->power_state_lock);
 	if (!device_data->power_state)
 		goto out;
 
 	clk_disable(device_data->clk);
-	ret = regulator_disable(device_data->regulator);
-	if (ret)
-		dev_err(dev, "%s: regulator_disable() failed!\n", __func__);
 
 	device_data->power_state = false;
 
@@ -273,8 +266,7 @@ static int hash_disable_power(struct hash_device_data *device_data)
  * hash_enable_power - Request to enable power and clock.
  * @device_data:		Structure for the hash device.
  *
- * This function request for enabling power (regulator) and clock,
- * and could also restore a previously saved hw state.
+ * This function request for enabling the clock.
  */
 static int hash_enable_power(struct hash_device_data *device_data)
 {
@@ -283,17 +275,9 @@ static int hash_enable_power(struct hash_device_data *device_data)
 
 	spin_lock(&device_data->power_state_lock);
 	if (!device_data->power_state) {
-		ret = regulator_enable(device_data->regulator);
-		if (ret) {
-			dev_err(dev, "%s: regulator_enable() failed!\n",
-				__func__);
-			goto out;
-		}
 		ret = clk_enable(device_data->clk);
 		if (ret) {
 			dev_err(dev, "%s: clk_enable() failed!\n", __func__);
-			ret = regulator_disable(
-					device_data->regulator);
 			goto out;
 		}
 		device_data->power_state = true;
@@ -1487,27 +1471,17 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	spin_lock_init(&device_data->ctx_lock);
 	spin_lock_init(&device_data->power_state_lock);
 
-	/* Enable power for HASH1 hardware block */
-	device_data->regulator = regulator_get(dev, "v-ape");
-	if (IS_ERR(device_data->regulator)) {
-		dev_err(dev, "%s: regulator_get() failed!\n", __func__);
-		ret = PTR_ERR(device_data->regulator);
-		device_data->regulator = NULL;
-		goto out;
-	}
-
-	/* Enable the clock for HASH1 hardware block */
 	device_data->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(device_data->clk)) {
 		dev_err(dev, "%s: clk_get() failed!\n", __func__);
 		ret = PTR_ERR(device_data->clk);
-		goto out_regulator;
+		goto out;
 	}
 
 	ret = clk_prepare(device_data->clk);
 	if (ret) {
 		dev_err(dev, "%s: clk_prepare() failed!\n", __func__);
-		goto out_regulator;
+		goto out;
 	}
 
 	/* Enable device power (and clock) */
@@ -1544,9 +1518,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
 
-out_regulator:
-	regulator_put(device_data->regulator);
-
 out:
 	return ret;
 }
@@ -1585,7 +1556,6 @@ static int ux500_hash_remove(struct platform_device *pdev)
 			__func__);
 
 	clk_unprepare(device_data->clk);
-	regulator_put(device_data->regulator);
 
 	return 0;
 }
-- 
2.36.1

