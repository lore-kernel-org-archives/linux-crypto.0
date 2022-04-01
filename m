Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396D4C43219
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351894AbiDAUUI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351921AbiDAUUF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:05 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD4C270868
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r64so2414381wmr.4
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/VLG1dlj3zpu6COMXUYDrFqGjEneQqP9DO34Aaku7s=;
        b=EiPseX6Gpfx03bsIDzXCEdv0z3bo1Lvo/H0g8YJlDyGlku4PLP9ex+oAlWyGprHbgd
         mq4iQYbOgtxDnRpi51HAKGd1YpEy/C7I/acsOuhLV3Drng7XLNJFDd7XBNUep2tSJnBq
         N/49Zsa0Iu/KqEw+PVFFInUGzuIsgXc66ky+aU78rH3XQHgCqQNiyP6Havx3xXCanwZK
         w3pszdJqVEPuigLZqM3n5kB+cmx1dEbHznOBjKFUGl6pzQmGqMflKZeoXjyUb2Z4yKPI
         ApqMDXh0ATyjfFOsP+fTIkNmljWeAXndjPHgQBX72eUFdh/JP1bGLu31IIfDUGeVgApH
         68Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/VLG1dlj3zpu6COMXUYDrFqGjEneQqP9DO34Aaku7s=;
        b=zAh1PrAiFDtAqoO4TCNTXvNX+u/LBpQeAkf4NmMsB0OTEEgjqLYTTh9KtE43pjIsj3
         RVtpmxqrosRonXN9wDIg53GE5X0lBgnFdPxJPFJClxMQs12HOO9mcB4/jh6zUg7Ztr58
         tF8hFdsCxnccZNogmyfhAQCZeTDVowIGDczzodimnxpnbnx9ItU9vjBMXgIr18xMw29g
         2iyOkE7SdomlsxmLzZwtneVefnL7yYHCJ+SbH/2u3u+V/tYPgQ2HytH5jHwvI/Fhm0UK
         b/tgQ/sm7k69ramGzBrTrg2O4qOaKK1Rh5LMFCSnQO0LW2XLxvRCL9tuO3pDrXnNufdG
         mHDw==
X-Gm-Message-State: AOAM530nqgdv96l2zKH8mXG4VWUmJp+saCjCD5hr8WuUtDzrSKIaZbWt
        A0YHtQUU+F3N0nWGaEvNzGMcIg==
X-Google-Smtp-Source: ABdhPJzuN/+3NhVy18YgEAbd0UcDUJ0caiNJuvhTP+flQOwxqxYYNXMiqOPjZDhP3qp1f7wSi4yMWA==
X-Received: by 2002:a05:600c:2e02:b0:38c:8390:d8ca with SMTP id o2-20020a05600c2e0200b0038c8390d8camr10094615wmf.15.1648844292893;
        Fri, 01 Apr 2022 13:18:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:12 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 03/33] crypto: rockchip: do not do custom power management
Date:   Fri,  1 Apr 2022 20:17:34 +0000
Message-Id: <20220401201804.2867154-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The clock enable/disable at tfm init/exit is fragile,
if 2 tfm are init in the same time and one is removed just after,
it will leave the hardware uncloked even if a user remains.

Instead simply enable clocks at probe time.
We will do PM later.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c          | 4 ++--
 drivers/crypto/rockchip/rk3288_crypto.h          | 2 --
 drivers/crypto/rockchip/rk3288_crypto_ahash.c    | 3 +--
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 5 +++--
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 21d3f1458584..4cff49b82983 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -394,8 +394,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		     rk_crypto_done_task_cb, (unsigned long)crypto_info);
 	crypto_init_queue(&crypto_info->queue, 50);
 
-	crypto_info->enable_clk = rk_crypto_enable_clk;
-	crypto_info->disable_clk = rk_crypto_disable_clk;
+	rk_crypto_enable_clk(crypto_info);
 	crypto_info->load_data = rk_load_data;
 	crypto_info->unload_data = rk_unload_data;
 	crypto_info->enqueue = rk_crypto_enqueue;
@@ -422,6 +421,7 @@ static int rk_crypto_remove(struct platform_device *pdev)
 	struct rk_crypto_info *crypto_tmp = platform_get_drvdata(pdev);
 
 	rk_crypto_unregister();
+	rk_crypto_disable_clk(crypto_tmp);
 	tasklet_kill(&crypto_tmp->done_task);
 	tasklet_kill(&crypto_tmp->queue_task);
 	return 0;
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 97278c2574ff..2fa7131e4060 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -220,8 +220,6 @@ struct rk_crypto_info {
 	int (*start)(struct rk_crypto_info *dev);
 	int (*update)(struct rk_crypto_info *dev);
 	void (*complete)(struct crypto_async_request *base, int err);
-	int (*enable_clk)(struct rk_crypto_info *dev);
-	void (*disable_clk)(struct rk_crypto_info *dev);
 	int (*load_data)(struct rk_crypto_info *dev,
 			 struct scatterlist *sg_src,
 			 struct scatterlist *sg_dst);
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index ed03058497bc..49017d1fb510 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -301,7 +301,7 @@ static int rk_cra_hash_init(struct crypto_tfm *tfm)
 				 sizeof(struct rk_ahash_rctx) +
 				 crypto_ahash_reqsize(tctx->fallback_tfm));
 
-	return tctx->dev->enable_clk(tctx->dev);
+	return 0;
 }
 
 static void rk_cra_hash_exit(struct crypto_tfm *tfm)
@@ -309,7 +309,6 @@ static void rk_cra_hash_exit(struct crypto_tfm *tfm)
 	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
 
 	free_page((unsigned long)tctx->dev->addr_vir);
-	return tctx->dev->disable_clk(tctx->dev);
 }
 
 struct rk_crypto_tmp rk_ahash_sha1 = {
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 5bbf0d2722e1..8c44a19eab75 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -388,8 +388,10 @@ static int rk_ablk_init_tfm(struct crypto_skcipher *tfm)
 	ctx->dev->update = rk_ablk_rx;
 	ctx->dev->complete = rk_crypto_complete;
 	ctx->dev->addr_vir = (char *)__get_free_page(GFP_KERNEL);
+	if (!ctx->dev->addr_vir)
+		return -ENOMEM;
 
-	return ctx->dev->addr_vir ? ctx->dev->enable_clk(ctx->dev) : -ENOMEM;
+	return 0;
 }
 
 static void rk_ablk_exit_tfm(struct crypto_skcipher *tfm)
@@ -397,7 +399,6 @@ static void rk_ablk_exit_tfm(struct crypto_skcipher *tfm)
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	free_page((unsigned long)ctx->dev->addr_vir);
-	ctx->dev->disable_clk(ctx->dev);
 }
 
 struct rk_crypto_tmp rk_ecb_aes_alg = {
-- 
2.35.1

