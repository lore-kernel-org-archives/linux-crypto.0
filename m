Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CB4CCA48B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiGUNpg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiGUNou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:44:50 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2FE85FB1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:18 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id r14so1879752ljp.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sSiRCl2FNVjumNTyEm6j/Y4BLdUSiRyHccgJSZvX0p8=;
        b=xvYxWLfVPUki9oW3YSagPynzuhJ7u47byExdN/63UgQm1JRrj31prOliILDFlcFmXH
         VMUitC202IBMB1aR4QW4jQ40+Pul/3nBqTW61GkLbY9PRJqKufUfpkkf34+LFvomIHvu
         MqBK1sFZAC/6dX2voqV0S8c7Ebh0Yp3CxUbBHQrBqlO09VBb7q2hzH/YuHU9K+OPmjZN
         PBfzXGekbwCkgNRnJC2u3GtIDiocVQaH8AbzdBvN85Nn6oYhRuXNGo3nNTm8tfaLPOYu
         3nmUgTJjT+bm532g0737pc50VScQ13xDpBuyArdSDf7M5RxlSHw+TeaEgZNPjdlOnurt
         K/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSiRCl2FNVjumNTyEm6j/Y4BLdUSiRyHccgJSZvX0p8=;
        b=L9NipS30ooOcmokFZdF9oK/R1PcNGhWeceAEfu1qlWHi/Z1cOBNyw4qEPBwR5PnSo9
         hj+3LjufR8LK6biwRufsShFSKRPpKuIfT4QGyHrcx2NEwKwSRwrfHUO9eFczmt9qqgKO
         /+p4S1UWHTwf2On6jjxFUBKO3GHccpd8FBsrLHy0sbQeQRNG6xn/tNLMHC+owr1v+RvN
         t1bkJg9o0eFDCd6tf3eK33cUaJeAWpSk6Q4E0boizjtY9tb4JS/YqzrNl5kAQRLcUXYQ
         IIaJOPaaiJylzbMidjQeJrST7o9Jn2v4w/NbVH1FFlIjQI0ReWyFjmggLMGtVw61cxDF
         KZSg==
X-Gm-Message-State: AJIora+Whp13f6PsKCrGWlYou+c9HAMgVn0Ycg/3m9hVZNfCscYDy29b
        uWoPExLdssfkFd0JLKpsCDx6hR3lDHq0MA==
X-Google-Smtp-Source: AGRyM1tjA7s4ANm+gAQnbAcC5qyPURyYcaU0iD3nUCP985Rmqk9Q6D0zIvuqbCX0BEQwJDpxUDaSUA==
X-Received: by 2002:a05:651c:2111:b0:25d:6b28:3c96 with SMTP id a17-20020a05651c211100b0025d6b283c96mr20078491ljq.39.1658410994695;
        Thu, 21 Jul 2022 06:43:14 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:14 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 14/15] crypto: ux500/hash: Implement runtime PM
Date:   Thu, 21 Jul 2022 15:40:49 +0200
Message-Id: <20220721134050.1047866-15-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This implements runtime PM to gate the clock and regulator
when the hash block is unused.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  |  1 +
 drivers/crypto/ux500/hash/hash_core.c | 60 +++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 96c614444fa2..57e4c7df4ac4 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -16,6 +16,7 @@
 #define HASH_DMA_ALIGN_SIZE		4
 #define HASH_DMA_PERFORMANCE_MIN_SIZE	1024
 #define HASH_BYTES_PER_WORD		4
+#define UX500_HASH_AUTOSUSPEND_DELAY_MS	50
 
 /* Number of context swap registers */
 #define HASH_CSR_COUNT			52
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index a64edfb1cd96..55d27af8c9de 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/crypto.h>
 
@@ -438,6 +439,10 @@ static int ux500_hash_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct hash_device_data *device_data = ctx->device;
+
+	/* Power up on init() power down on final() */
+	pm_runtime_get_sync(device_data->dev);
 
 	if (!ctx->key)
 		ctx->keylen = 0;
@@ -463,6 +468,7 @@ static int ux500_hash_init(struct ahash_request *req)
 			}
 		}
 	}
+
 	return 0;
 }
 
@@ -773,6 +779,8 @@ static int hash_dma_final(struct ahash_request *req)
 	memcpy(req->result, digest, ctx->digestsize);
 
 out:
+	pm_runtime_mark_last_busy(device_data->dev);
+	pm_runtime_put_autosuspend(device_data->dev);
 	/**
 	 * Allocated in setkey, and only used in HMAC.
 	 */
@@ -1023,8 +1031,11 @@ static int ahash_update(struct ahash_request *req)
  */
 static int ahash_final(struct ahash_request *req)
 {
-	int ret = 0;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct hash_device_data *device_data = ctx->device;
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
+	int ret = 0;
 
 	pr_debug("%s: data size: %d\n", __func__, req->nbytes);
 
@@ -1033,6 +1044,9 @@ static int ahash_final(struct ahash_request *req)
 	else
 		ret = hash_hw_final(req);
 
+	pm_runtime_mark_last_busy(device_data->dev);
+	pm_runtime_put_autosuspend(device_data->dev);
+
 	if (ret) {
 		pr_err("%s: hash_hw/dma_final() failed\n", __func__);
 	}
@@ -1133,6 +1147,9 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	req_ctx->hw_initialized = hstate->hw_initialized;
 	memcpy(req_ctx->buffer, hstate->buffer, HASH_BLOCK_SIZE);
 
+	/* Power up as we may have lost power being exported */
+	pm_runtime_get_sync(device_data->dev);
+
 	/*
 	 * Restore hardware state
 	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
@@ -1200,6 +1217,10 @@ static int ahash_export(struct ahash_request *req, void *out)
 	hstate->hw_initialized = req_ctx->hw_initialized;
 	memcpy(hstate->buffer, req_ctx->buffer, HASH_BLOCK_SIZE);
 
+	/* We can power down while exported */
+	pm_runtime_mark_last_busy(device_data->dev);
+	pm_runtime_put_autosuspend(device_data->dev);
+
 	return 0;
 }
 
@@ -1554,7 +1575,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	spin_lock_init(&device_data->ctx_lock);
 	spin_lock_init(&device_data->power_state_lock);
 
-	/* Enable power for HASH1 hardware block */
 	device_data->regulator = regulator_get(dev, "v-ape");
 	if (IS_ERR(device_data->regulator)) {
 		dev_err(dev, "%s: regulator_get() failed!\n", __func__);
@@ -1563,7 +1583,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	/* Enable the clock for HASH1 hardware block */
 	device_data->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(device_data->clk)) {
 		dev_err(dev, "%s: clk_get() failed!\n", __func__);
@@ -1590,6 +1609,12 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
+	pm_runtime_set_autosuspend_delay(dev, UX500_HASH_AUTOSUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	if (hash_mode == HASH_MODE_DMA)
 		hash_dma_setup_channel(device_data, dev);
 
@@ -1602,6 +1627,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
+	pm_runtime_put_sync(dev);
 	dev_info(dev, "successfully registered\n");
 	return 0;
 
@@ -1647,6 +1673,10 @@ static int ux500_hash_remove(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
+	pm_runtime_get_sync(device_data->dev);
+	pm_runtime_put_noidle(device_data->dev);
+	pm_runtime_disable(device_data->dev);
+
 	if (hash_disable_power(device_data))
 		dev_err(dev, "%s: hash_disable_power() failed\n",
 			__func__);
@@ -1687,6 +1717,10 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
+	pm_runtime_get_sync(device_data->dev);
+	pm_runtime_put_noidle(device_data->dev);
+	pm_runtime_disable(device_data->dev);
+
 	if (hash_disable_power(device_data))
 		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
 			__func__);
@@ -1694,10 +1728,10 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 
 #ifdef CONFIG_PM_SLEEP
 /**
- * ux500_hash_suspend - Function that suspends the hash device.
+ * ux500_hash_runtime_suspend - Function that suspends the hash device.
  * @dev:	Device to suspend.
  */
-static int ux500_hash_suspend(struct device *dev)
+static int ux500_hash_runtime_suspend(struct device *dev)
 {
 	int ret;
 	struct hash_device_data *device_data;
@@ -1712,14 +1746,15 @@ static int ux500_hash_suspend(struct device *dev)
 	if (ret)
 		dev_err(dev, "%s: hash_disable_power()\n", __func__);
 
+	dev_info(dev, "runtime suspended\n");
 	return ret;
 }
 
 /**
- * ux500_hash_resume - Function that resume the hash device.
+ * ux500_hash_runtime_resume - Function that resume the hash device.
  * @dev:	Device to resume.
  */
-static int ux500_hash_resume(struct device *dev)
+static int ux500_hash_runtime_resume(struct device *dev)
 {
 	int ret = 0;
 	struct hash_device_data *device_data;
@@ -1734,11 +1769,18 @@ static int ux500_hash_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 
+	dev_info(dev, "runtime resumed\n");
+
 	return ret;
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
+static const struct dev_pm_ops ux500_hash_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(ux500_hash_runtime_suspend,
+			   ux500_hash_runtime_resume, NULL)
+};
 
 static const struct of_device_id ux500_hash_match[] = {
 	{ .compatible = "stericsson,ux500-hash" },
@@ -1753,7 +1795,7 @@ static struct platform_driver ux500_hash_driver = {
 	.driver = {
 		.name  = "hash1",
 		.of_match_table = ux500_hash_match,
-		.pm    = &ux500_hash_pm,
+		.pm    = &ux500_hash_pm_ops,
 	}
 };
 module_platform_driver(ux500_hash_driver);
-- 
2.36.1

