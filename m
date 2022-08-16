Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF321C28B2B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiHPOE1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiHPODq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:46 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAF02C135
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:32 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id o2so15087953lfb.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tcxO47ygEsHC0iu9hAyWTaXnRiHqq4d+JFjoMEvLaVk=;
        b=I7Jie9Kg8eCs+8zKf4I6NnTalBPaSnt7OdI3w9AJCVCtUKJGXD1x1eohAJ6cepkuFy
         aiLRrLxGAofV7Mb2Cp9xC53w8DI4MugwcPWzU/zWVPCHAhfTbuAynCmmlKIBUYQpLUno
         HUgG+4JiI5/ADKKbVmOq1h4p/U+Q1uOUE3AwHtRxA3WG04aglO81QZq0erwdw9Be2I3m
         IxSqjv3+I/vD/BG5rLJ/Lee32aeBKe+m8xpWkgiBoQZfEV8FVsanR4MGRjS6Alb8GdYS
         NeCbzL4dxb7AnMheV843unejVpb10vKvBm82xtlW0PaNuEFQG+6YbKt1Ms3pBEN9jfed
         0gPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tcxO47ygEsHC0iu9hAyWTaXnRiHqq4d+JFjoMEvLaVk=;
        b=SbyZPimTcA2ZnzHdXlIicMUNYoJJJJ2ovXIUmnFVDZnMWbUduyeXlm1CvIuAhQsgfN
         rFWv3FxHqq7ZZe2SQ/BtPTckJa9BTrUx70DlY3peGnV9qZQU9UhfFQMsZb6uX//WxVuj
         xomaRwcE5WjoiKdcZPulWlzMpXwqnONoykejIroQ8hGWta1RyGcKPHGJhkWdNZGfkb7D
         U+hnOU3vBKaq6uW5fGVWGfxgE0y/VYpMQrTOKEkVUIl4fRRz3+LnjQu9QEDPtj5o1+FN
         frQlMjTmqx2PevueJHF3XWgAVmNb7S51RScTS2in7VcWY/ooPJAMmL/PNqFsQ9itWunp
         2+8A==
X-Gm-Message-State: ACgBeo2dc2VrZqTKVgG/JsCtp5ORKlXAygs0FnaljOYurYCtvlaJx6TO
        HDwqsRQ2iNwdC6LTfUF0j/pql/Mo8jC/MQ==
X-Google-Smtp-Source: AA6agR4Q9L3NZYtBSA9gZA8H7YFNUHhj95pn2oCaYdy45v5bd+zyE/hh4GJAAs6YWij4fo20xxXZSg==
X-Received: by 2002:a19:4f56:0:b0:48b:205f:91a9 with SMTP id a22-20020a194f56000000b0048b205f91a9mr7081096lfk.543.1660658611358;
        Tue, 16 Aug 2022 07:03:31 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:31 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 15/16] crypto: ux500/hash: Implement runtime PM
Date:   Tue, 16 Aug 2022 16:00:48 +0200
Message-Id: <20220816140049.102306-16-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This implements runtime PM to gate the clock and regulator
when the hash block is unused.

Drop the own-invented "power state" and its associated lock:
we don't need that when we have runtime PM.

Delete the specific power functions and just enable/disable
the clock in the runtime PM functions. Use the full
*_prepare_enable() and *disable_unprepare() calls for
really making sure the clock is off.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- New patch to clean up also the custom PM.
---
 drivers/crypto/ux500/hash/hash_alg.h  |   3 +-
 drivers/crypto/ux500/hash/hash_core.c | 164 +++++++++++---------------
 2 files changed, 71 insertions(+), 96 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 96c614444fa2..344f2294a938 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -16,6 +16,7 @@
 #define HASH_DMA_ALIGN_SIZE		4
 #define HASH_DMA_PERFORMANCE_MIN_SIZE	1024
 #define HASH_BYTES_PER_WORD		4
+#define UX500_HASH_AUTOSUSPEND_DELAY_MS	50
 
 /* Number of context swap registers */
 #define HASH_CSR_COUNT			52
@@ -221,8 +222,6 @@ struct hash_device_data {
 	struct device		*dev;
 	spinlock_t		ctx_lock;
 	struct hash_ctx		*current_ctx;
-	bool			power_state;
-	spinlock_t		power_state_lock;
 	struct regulator	*regulator;
 	struct clk		*clk;
 	struct hash_dma		dma;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 188e309406b2..be703fe4d0ec 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/crypto.h>
 #include <linux/dmaengine.h>
@@ -240,57 +241,6 @@ static int get_empty_message_digest(
 	return ret;
 }
 
-/**
- * hash_disable_power - Request to disable power and clock.
- * @device_data:	Structure for the hash device.
- *
- * This function request for disabling the clock.
- */
-static int hash_disable_power(struct hash_device_data *device_data)
-{
-	int ret = 0;
-
-	spin_lock(&device_data->power_state_lock);
-	if (!device_data->power_state)
-		goto out;
-
-	clk_disable(device_data->clk);
-
-	device_data->power_state = false;
-
-out:
-	spin_unlock(&device_data->power_state_lock);
-
-	return ret;
-}
-
-/**
- * hash_enable_power - Request to enable power and clock.
- * @device_data:		Structure for the hash device.
- *
- * This function request for enabling the clock.
- */
-static int hash_enable_power(struct hash_device_data *device_data)
-{
-	int ret = 0;
-	struct device *dev = device_data->dev;
-
-	spin_lock(&device_data->power_state_lock);
-	if (!device_data->power_state) {
-		ret = clk_enable(device_data->clk);
-		if (ret) {
-			dev_err(dev, "%s: clk_enable() failed!\n", __func__);
-			goto out;
-		}
-		device_data->power_state = true;
-	}
-
-out:
-	spin_unlock(&device_data->power_state_lock);
-
-	return ret;
-}
-
 static void hash_wait_for_dcal(struct hash_device_data *device_data)
 {
 	unsigned int val;
@@ -449,6 +399,10 @@ static int ux500_hash_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct hash_device_data *device_data = ctx->device;
+
+	/* Power up on init() power down on final() */
+	pm_runtime_get_sync(device_data->dev);
 
 	if (!ctx->key)
 		ctx->keylen = 0;
@@ -474,6 +428,7 @@ static int ux500_hash_init(struct ahash_request *req)
 			}
 		}
 	}
+
 	return 0;
 }
 
@@ -782,6 +737,8 @@ static int hash_dma_final(struct ahash_request *req)
 	memcpy(req->result, digest, ctx->digestsize);
 
 out:
+	pm_runtime_mark_last_busy(device_data->dev);
+	pm_runtime_put_autosuspend(device_data->dev);
 	/**
 	 * Allocated in setkey, and only used in HMAC.
 	 */
@@ -1040,8 +997,11 @@ static int ahash_update(struct ahash_request *req)
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
 
@@ -1050,6 +1010,9 @@ static int ahash_final(struct ahash_request *req)
 	else
 		ret = hash_hw_final(req);
 
+	pm_runtime_mark_last_busy(device_data->dev);
+	pm_runtime_put_autosuspend(device_data->dev);
+
 	if (ret) {
 		pr_err("%s: hash_hw/dma_final() failed\n", __func__);
 	}
@@ -1150,6 +1113,9 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	req_ctx->hw_initialized = hstate->hw_initialized;
 	memcpy(req_ctx->buffer, hstate->buffer, HASH_BLOCK_SIZE);
 
+	/* Power up as we may have lost power being exported */
+	pm_runtime_get_sync(device_data->dev);
+
 	/*
 	 * Restore hardware state
 	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
@@ -1217,6 +1183,10 @@ static int ahash_export(struct ahash_request *req, void *out)
 	hstate->hw_initialized = req_ctx->hw_initialized;
 	memcpy(hstate->buffer, req_ctx->buffer, HASH_BLOCK_SIZE);
 
+	/* We can power down while exported */
+	pm_runtime_mark_last_busy(device_data->dev);
+	pm_runtime_put_autosuspend(device_data->dev);
+
 	return 0;
 }
 
@@ -1593,7 +1563,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	 */
 	regcache_cache_bypass(device_data->map, true);
 	spin_lock_init(&device_data->ctx_lock);
-	spin_lock_init(&device_data->power_state_lock);
 
 	device_data->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(device_data->clk)) {
@@ -1602,25 +1571,24 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	ret = clk_prepare(device_data->clk);
+	ret = clk_prepare_enable(device_data->clk);
 	if (ret) {
-		dev_err(dev, "%s: clk_prepare() failed!\n", __func__);
+		dev_err(dev, "%s: clk_prepare_enable() failed!\n", __func__);
 		goto out;
 	}
 
-	/* Enable device power (and clock) */
-	ret = hash_enable_power(device_data);
-	if (ret) {
-		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
-		goto out_clk_unprepare;
-	}
-
 	ret = hash_check_hw(device_data);
 	if (ret) {
 		dev_err(dev, "%s: hash_check_hw() failed!\n", __func__);
-		goto out_power;
+		goto out_clk;
 	}
 
+	pm_runtime_set_autosuspend_delay(dev, UX500_HASH_AUTOSUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	if (hash_mode == HASH_MODE_DMA)
 		hash_dma_setup_channel(device_data, dev);
 
@@ -1630,18 +1598,20 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "%s: ahash_algs_register_all() failed!\n",
 			__func__);
-		goto out_power;
+		goto out_pm_disable;
 	}
 
+	pm_runtime_put_sync(dev);
 	dev_info(dev, "successfully registered\n");
-	return 0;
-
-out_power:
-	hash_disable_power(device_data);
 
-out_clk_unprepare:
-	clk_unprepare(device_data->clk);
+	return 0;
 
+out_pm_disable:
+	pm_runtime_get_sync(device_data->dev);
+	pm_runtime_put_noidle(device_data->dev);
+	pm_runtime_disable(device_data->dev);
+out_clk:
+	clk_disable_unprepare(device_data->clk);
 out:
 	return ret;
 }
@@ -1675,11 +1645,10 @@ static int ux500_hash_remove(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
-	if (hash_disable_power(device_data))
-		dev_err(dev, "%s: hash_disable_power() failed\n",
-			__func__);
-
-	clk_unprepare(device_data->clk);
+	pm_runtime_get_sync(device_data->dev);
+	pm_runtime_put_noidle(device_data->dev);
+	pm_runtime_disable(device_data->dev);
+	clk_disable_unprepare(device_data->clk);
 
 	return 0;
 }
@@ -1714,17 +1683,17 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
-	if (hash_disable_power(device_data))
-		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
-			__func__);
+	pm_runtime_get_sync(device_data->dev);
+	pm_runtime_put_noidle(device_data->dev);
+	pm_runtime_disable(device_data->dev);
+	clk_disable_unprepare(device_data->clk);
 }
 
-#ifdef CONFIG_PM_SLEEP
 /**
- * ux500_hash_suspend - Function that suspends the hash device.
+ * ux500_hash_runtime_suspend - Function that suspends the hash device.
  * @dev:	Device to suspend.
  */
-static int ux500_hash_suspend(struct device *dev)
+static int __maybe_unused ux500_hash_runtime_suspend(struct device *dev)
 {
 	int ret;
 	struct hash_device_data *device_data;
@@ -1735,21 +1704,20 @@ static int ux500_hash_suspend(struct device *dev)
 		return -ENOMEM;
 	}
 
-	ret = hash_disable_power(device_data);
-	if (ret)
-		dev_err(dev, "%s: hash_disable_power()\n", __func__);
+	clk_disable_unprepare(device_data->clk);
 
+	dev_info(dev, "runtime suspended\n");
 	return ret;
 }
 
 /**
- * ux500_hash_resume - Function that resume the hash device.
+ * ux500_hash_runtime_resume - Function that resume the hash device.
  * @dev:	Device to resume.
  */
-static int ux500_hash_resume(struct device *dev)
+static int __maybe_unused ux500_hash_runtime_resume(struct device *dev)
 {
-	int ret = 0;
 	struct hash_device_data *device_data;
+	int ret;
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
@@ -1757,15 +1725,23 @@ static int ux500_hash_resume(struct device *dev)
 		return -ENOMEM;
 	}
 
-	ret = hash_enable_power(device_data);
-	if (ret)
-		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
+	ret = clk_prepare_enable(device_data->clk);
+	if (ret) {
+		dev_err(dev, "%s: clk_enable() failed!\n", __func__);
+		return ret;
+	}
 
-	return ret;
+	dev_info(dev, "runtime resumed\n");
+
+	return 0;
 }
-#endif
 
-static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
+static const struct dev_pm_ops ux500_hash_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(ux500_hash_runtime_suspend,
+			   ux500_hash_runtime_resume, NULL)
+};
 
 static const struct of_device_id ux500_hash_match[] = {
 	{ .compatible = "stericsson,ux500-hash" },
@@ -1780,7 +1756,7 @@ static struct platform_driver ux500_hash_driver = {
 	.driver = {
 		.name  = "hash1",
 		.of_match_table = ux500_hash_match,
-		.pm    = &ux500_hash_pm,
+		.pm    = &ux500_hash_pm_ops,
 	}
 };
 module_platform_driver(ux500_hash_driver);
-- 
2.37.2

