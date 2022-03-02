Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36F6C4321E
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245178AbiCBVNX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbiCBVMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:38 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE0ADEA0F
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:35 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id u1so4714576wrg.11
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hD068yvCJVz7diE/pqMBYrQcMNXiKRUWce+U3Y/ygL4=;
        b=NEN5f3SCzE4S/BhtzpnNylPdmuqxGGt7/ksv+AT2BkVx5kAHsE7E64pLUsII7n49ol
         cfHCJG27cm1GasSgfBNPGMcs/xW1ARn4l2SlRiQpLX3lf8/Uiesd99M9X6FgFP6cB+VB
         reFGUVI7tIk4FmbYkusSFrkO6Fg0gVl8+4mjscmE2d8U9i4wJiUkyTwyKmHWvduHWaal
         dr5EcK2dplvSL9IffsIuNUjvzBxX59K0dH3JsiLzvn95W2+mvfIhVt99JcRU4i8z9+x4
         IBN+SCFNBm6R5boNHQc3Rd64RRtC8NV48P+3Fpf3SqNPYX/p0JGZuTaNpwzFfL65JejU
         rovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hD068yvCJVz7diE/pqMBYrQcMNXiKRUWce+U3Y/ygL4=;
        b=tAoexzeEYZi2XsTbfNdeilplAcYbI730rpecDhz6ddBrYKAKl9f9XeNmOKARB5EkAz
         quYvuR8CDjDefmf29IMwv4NdGxpGgvaIAE4hWwZxVLY8kx5ntGPbnTEZ+LNJbvRlZSas
         pYtkW/z+lI0qEY/n3RqpyHPiTU9YNcOrGjR0lPh5ASV1FQ2FHdb/3rNXnvVgeXNXU/35
         Y6M8F4ieIJEJnI6Ssbt7ySSXTQaFy1R1BeVlvJrSkxqO4H06bmzjjD96sve1yVcxyvTr
         Lm3bS4L87+RYVNT52V2yu+RzUEbg608SjBRh+0wP9MIhp5jCBK6Nv2eNdl6Mtw+CGT7e
         py9w==
X-Gm-Message-State: AOAM530ZGO0J+9xmt9G7LWd6lxPQF5NVztdb2j7sU66R9BzVrISqriBs
        hPUZ2ZYxrubYU80ujIlAD+Y2cg==
X-Google-Smtp-Source: ABdhPJzF3BD+XPvDJLGS3kvRnzSb8RFBxVQn6yv/i4Afa7uSh8aBsJCkYudwUShkYrzvZ1aB4QkkHA==
X-Received: by 2002:a5d:6103:0:b0:1ed:9e65:b090 with SMTP id v3-20020a5d6103000000b001ed9e65b090mr23743441wrt.332.1646255494454;
        Wed, 02 Mar 2022 13:11:34 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:34 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 15/18] crypto: rockchip: introduce PM
Date:   Wed,  2 Mar 2022 21:11:10 +0000
Message-Id: <20220302211113.4003816-16-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add runtime PM support for rockchip crypto.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/Kconfig                        |  1 +
 drivers/crypto/rockchip/rk3288_crypto.c       | 50 ++++++++++++++++++-
 drivers/crypto/rockchip/rk3288_crypto.h       |  1 +
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 11 ++++
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 10 ++++
 5 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 04c8e332c5a1..685631a5cbea 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -784,6 +784,7 @@ config CRYPTO_DEV_IMGTEC_HASH
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
+	depends on PM
 	select CRYPTO_AES
 	select CRYPTO_ENGINE
 	select CRYPTO_LIB_DES
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index cd0755731cf7..ba56f8ff97c3 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -57,6 +57,48 @@ static void rk_crypto_disable_clk(struct rk_crypto_info *dev)
 	clk_disable_unprepare(dev->sclk);
 }
 
+/*
+ * Power management strategy: The device is suspended unless a TFM exists for
+ * one of the algorithms proposed by this driver.
+ */
+static int rk_crypto_pm_suspend(struct device *dev)
+{
+	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
+
+	rk_crypto_disable_clk(rkdev);
+	return 0;
+}
+
+static int rk_crypto_pm_resume(struct device *dev)
+{
+	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
+
+	return rk_crypto_enable_clk(rkdev);
+}
+
+static const struct dev_pm_ops rk_crypto_pm_ops = {
+	SET_RUNTIME_PM_OPS(rk_crypto_pm_suspend, rk_crypto_pm_resume, NULL)
+};
+
+static int rk_crypto_pm_init(struct rk_crypto_info *rkdev)
+{
+	int err;
+
+	pm_runtime_use_autosuspend(rkdev->dev);
+	pm_runtime_set_autosuspend_delay(rkdev->dev, 2000);
+
+	err = pm_runtime_set_suspended(rkdev->dev);
+	if (err)
+		return err;
+	pm_runtime_enable(rkdev->dev);
+	return err;
+}
+
+static void rk_crypto_pm_exit(struct rk_crypto_info *rkdev)
+{
+	pm_runtime_disable(rkdev->dev);
+}
+
 static irqreturn_t rk_crypto_irq_handle(int irq, void *dev_id)
 {
 	struct rk_crypto_info *dev  = platform_get_drvdata(dev_id);
@@ -259,7 +301,9 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	crypto_engine_start(crypto_info->engine);
 	init_completion(&crypto_info->complete);
 
-	rk_crypto_enable_clk(crypto_info);
+	err = rk_crypto_pm_init(crypto_info);
+	if (err)
+		goto err_crypto;
 
 	err = rk_crypto_register(crypto_info);
 	if (err) {
@@ -280,6 +324,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	return 0;
 
 err_register_alg:
+	rk_crypto_pm_exit(crypto_info);
 err_crypto:
 	dev_err(dev, "Crypto Accelerator not successfully registered\n");
 	return err;
@@ -293,7 +338,7 @@ static int rk_crypto_remove(struct platform_device *pdev)
 	debugfs_remove_recursive(crypto_tmp->dbgfs_dir);
 #endif
 	rk_crypto_unregister();
-	rk_crypto_disable_clk(crypto_tmp);
+	rk_crypto_pm_exit(crypto_tmp);
 	return 0;
 }
 
@@ -302,6 +347,7 @@ static struct platform_driver crypto_driver = {
 	.remove		= rk_crypto_remove,
 	.driver		= {
 		.name	= "rk3288-crypto",
+		.pm		= &rk_crypto_pm_ops,
 		.of_match_table	= crypto_of_id_table,
 	},
 };
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index e2a6d735f2e2..06b2d9f52a80 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <crypto/engine.h>
 #include <crypto/internal/hash.h>
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 8856c6226be6..a41e21c7141b 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -328,6 +328,7 @@ static int rk_cra_hash_init(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
 
 	const char *alg_name = crypto_tfm_alg_name(tfm);
+	int err;
 
 	algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
 
@@ -349,7 +350,16 @@ static int rk_cra_hash_init(struct crypto_tfm *tfm)
 	tctx->enginectx.op.prepare_request = rk_hash_prepare;
 	tctx->enginectx.op.unprepare_request = rk_hash_unprepare;
 
+	err = pm_runtime_get_sync(tctx->dev->dev);
+	if (err < 0)
+		goto error_pm;
+
 	return 0;
+error_pm:
+	pm_runtime_put_noidle(tctx->dev->dev);
+	crypto_free_ahash(tctx->fallback_tfm);
+
+	return err;
 }
 
 static void rk_cra_hash_exit(struct crypto_tfm *tfm)
@@ -357,6 +367,7 @@ static void rk_cra_hash_exit(struct crypto_tfm *tfm)
 	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
 
 	crypto_free_ahash(tctx->fallback_tfm);
+	pm_runtime_put_sync_suspend(tctx->dev->dev);
 }
 
 struct rk_crypto_tmp rk_ahash_sha1 = {
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index a8cfb520eaf8..55efda6ea3e7 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -458,6 +458,7 @@ static int rk_ablk_init_tfm(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	const char *name = crypto_tfm_alg_name(&tfm->base);
 	struct rk_crypto_tmp *algt;
+	int err;
 
 	algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
 
@@ -475,7 +476,15 @@ static int rk_ablk_init_tfm(struct crypto_skcipher *tfm)
 
 	ctx->enginectx.op.do_one_request = rk_cipher_run;
 
+	err = pm_runtime_get_sync(ctx->dev->dev);
+	if (err < 0)
+		goto error_pm;
+
 	return 0;
+error_pm:
+	pm_runtime_put_noidle(ctx->dev->dev);
+	crypto_free_skcipher(ctx->fallback_tfm);
+	return err;
 }
 
 static void rk_ablk_exit_tfm(struct crypto_skcipher *tfm)
@@ -484,6 +493,7 @@ static void rk_ablk_exit_tfm(struct crypto_skcipher *tfm)
 
 	memzero_explicit(ctx->key, ctx->keylen);
 	crypto_free_skcipher(ctx->fallback_tfm);
+	pm_runtime_put_sync_suspend(ctx->dev->dev);
 }
 
 struct rk_crypto_tmp rk_ecb_aes_alg = {
-- 
2.34.1

