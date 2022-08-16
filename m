Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC02C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiHPOD1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbiHPODW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:22 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3714137FB2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:17 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id j3so10664893ljo.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zIgIQNH9egSlrVYC+AMp4lopK69544ScTJ4QfR0a69c=;
        b=oRWv3XNAulsRxWqEojLjrniEQIvQx0LzTNMJfjUDvFOeDHsdzyJxaFYb5cRXMyKppC
         /+rNwxjlzSmGGJ4Pv4+W803UfWT0DvcNewRB6hnz/m0gx+Du3mDLCrAjtjrl88kM74qE
         Cp5mFE15Wvhh3f1s27ZSqXkEu5OF+lfGor5Wrfj0l5O3pxi9S1EL7mp4o7Oe/HeiKM9F
         LCpGNA6hlNTzY4yjQMhvU6nc35As2XQMnrf1XX4/15okUeAhhcMCa1Gnmm2K9WIvgmvR
         zl3m+6JwMfnt6h9U4ZHnSdq7urK43SrMEou/+b5uPJ2UacoTG//+bzcX5Daadaw4uXYx
         OCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zIgIQNH9egSlrVYC+AMp4lopK69544ScTJ4QfR0a69c=;
        b=D7d1ibYweehymZuqr48UOol0EiExiQr2oqqq549ZPM8EuHbp895I0dluKtJFPOC8OG
         fzD4zJLcpqqdR9bMLnn8sjlLlg+6brawzku9b3MByq4Ujct34e6OLfr6sD2oo+AJJJ1C
         lIypUKeVqqJqiPaDY+fcNcb1MZYau2nHzCVGIk6+upAZ25hKBvHg204g6ysBe8LAG21Z
         kUOQeonxQXPJTjfSbxHEFwWIRxrAzr8JWJBjFBmHo7ocPqWivta6bjozUFCv+cqfMxXj
         HDfE4bUDHU2aw9EFELmLsF5wXQa/+8+FnxkCOOlwtg98cSiMLuA9TWevJArpfMFmVeFU
         QROg==
X-Gm-Message-State: ACgBeo0OQPfXEQKYlwwds5Be+baTu7mQv6KpozdxKTs9XFBaejt34ZGR
        i/rT6H9OZk05JyHeNsGSs+V9yXFakFX3xg==
X-Google-Smtp-Source: AA6agR5uk6TUYZk9L+excfFGHmpc/AaXOvaka5lWnHGNqZ5L415Ll7yw0UTECfVKJMq5fnbr1HYM2g==
X-Received: by 2002:a2e:97cd:0:b0:261:9bfc:3941 with SMTP id m13-20020a2e97cd000000b002619bfc3941mr531462ljj.110.1660658594241;
        Tue, 16 Aug 2022 07:03:14 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:13 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 02/16] crypto: ux500/hash: Get rid of custom device list
Date:   Tue, 16 Aug 2022 16:00:35 +0200
Message-Id: <20220816140049.102306-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Ux500 hash driver builds a list with one (1) hash engine
as it is all it has, then goes to great lengths to lock the
one device using a semaphore.

Instead do what other drivers do: trust the core to do the
right thing, add the device state to the algorithm template,
fill it in when registering the algorithms and assign
the device state to the context when intializing each context.

This saves us from a lot of complex code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 194 +++-----------------------
 1 file changed, 17 insertions(+), 177 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1662e176de44..5c2da6d42121 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -19,7 +19,6 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/klist.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -59,19 +58,6 @@ static const u8 zero_message_hmac_sha256[SHA256_DIGEST_SIZE] = {
 	0xc6, 0xc7, 0x12, 0x14, 0x42, 0x92, 0xc5, 0xad
 };
 
-/**
- * struct hash_driver_data - data specific to the driver.
- *
- * @device_list:	A list of registered devices to choose from.
- * @device_allocation:	A semaphore initialized with number of devices.
- */
-struct hash_driver_data {
-	struct klist		device_list;
-	struct semaphore	device_allocation;
-};
-
-static struct hash_driver_data	driver_data;
-
 /* Declaration of functions */
 /**
  * hash_messagepad - Pads a message and write the nblw bits.
@@ -86,24 +72,6 @@ static struct hash_driver_data	driver_data;
 static void hash_messagepad(struct hash_device_data *device_data,
 			    const u32 *message, u8 index_bytes);
 
-/**
- * release_hash_device - Releases a previously allocated hash device.
- * @device_data:	Structure for the hash device.
- *
- */
-static void release_hash_device(struct hash_device_data *device_data)
-{
-	spin_lock(&device_data->ctx_lock);
-	device_data->current_ctx->device = NULL;
-	device_data->current_ctx = NULL;
-	spin_unlock(&device_data->ctx_lock);
-
-	/*
-	 * The down_interruptible part for this semaphore is called in
-	 * cryp_get_device_data.
-	 */
-	up(&driver_data.device_allocation);
-}
 
 static void hash_dma_setup_channel(struct hash_device_data *device_data,
 				   struct device *dev)
@@ -354,65 +322,6 @@ static int hash_enable_power(struct hash_device_data *device_data,
 	return ret;
 }
 
-/**
- * hash_get_device_data - Checks for an available hash device and return it.
- * @ctx:		Structure for the hash context.
- * @device_data:	Structure for the hash device.
- *
- * This function check for an available hash device and return it to
- * the caller.
- * Note! Caller need to release the device, calling up().
- */
-static int hash_get_device_data(struct hash_ctx *ctx,
-				struct hash_device_data **device_data)
-{
-	int			ret;
-	struct klist_iter	device_iterator;
-	struct klist_node	*device_node;
-	struct hash_device_data *local_device_data = NULL;
-
-	/* Wait until a device is available */
-	ret = down_interruptible(&driver_data.device_allocation);
-	if (ret)
-		return ret;  /* Interrupted */
-
-	/* Select a device */
-	klist_iter_init(&driver_data.device_list, &device_iterator);
-	device_node = klist_next(&device_iterator);
-	while (device_node) {
-		local_device_data = container_of(device_node,
-					   struct hash_device_data, list_node);
-		spin_lock(&local_device_data->ctx_lock);
-		/* current_ctx allocates a device, NULL = unallocated */
-		if (local_device_data->current_ctx) {
-			device_node = klist_next(&device_iterator);
-		} else {
-			local_device_data->current_ctx = ctx;
-			ctx->device = local_device_data;
-			spin_unlock(&local_device_data->ctx_lock);
-			break;
-		}
-		spin_unlock(&local_device_data->ctx_lock);
-	}
-	klist_iter_exit(&device_iterator);
-
-	if (!device_node) {
-		/**
-		 * No free device found.
-		 * Since we allocated a device with down_interruptible, this
-		 * should not be able to happen.
-		 * Number of available devices, which are contained in
-		 * device_allocation, is therefore decremented by not doing
-		 * an up(device_allocation).
-		 */
-		return -EBUSY;
-	}
-
-	*device_data = local_device_data;
-
-	return 0;
-}
-
 /**
  * hash_hw_write_key - Writes the key to the hardware registries.
  *
@@ -859,14 +768,10 @@ static int hash_dma_final(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
-	struct hash_device_data *device_data;
+	struct hash_device_data *device_data = ctx->device;
 	u8 digest[SHA256_DIGEST_SIZE];
 	int bytes_written = 0;
 
-	ret = hash_get_device_data(ctx, &device_data);
-	if (ret)
-		return ret;
-
 	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
 		(unsigned long)ctx);
 
@@ -944,8 +849,6 @@ static int hash_dma_final(struct ahash_request *req)
 	memcpy(req->result, digest, ctx->digestsize);
 
 out:
-	release_hash_device(device_data);
-
 	/**
 	 * Allocated in setkey, and only used in HMAC.
 	 */
@@ -964,13 +867,9 @@ static int hash_hw_final(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
-	struct hash_device_data *device_data;
+	struct hash_device_data *device_data = ctx->device;
 	u8 digest[SHA256_DIGEST_SIZE];
 
-	ret = hash_get_device_data(ctx, &device_data);
-	if (ret)
-		return ret;
-
 	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
 		(unsigned long)ctx);
 
@@ -1047,7 +946,6 @@ static int hash_hw_final(struct ahash_request *req)
 	memcpy(req->result, digest, ctx->digestsize);
 
 out:
-	release_hash_device(device_data);
 
 	/**
 	 * Allocated in setkey, and only used in HMAC.
@@ -1068,36 +966,29 @@ int hash_hw_update(struct ahash_request *req)
 	int ret = 0;
 	u8 index = 0;
 	u8 *buffer;
-	struct hash_device_data *device_data;
 	u8 *data_buffer;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct hash_device_data *device_data = ctx->device;
 	struct crypto_hash_walk walk;
 	int msg_length;
 
 	index = req_ctx->state.index;
 	buffer = (u8 *)req_ctx->state.buffer;
 
-	ret = hash_get_device_data(ctx, &device_data);
-	if (ret)
-		return ret;
-
 	msg_length = crypto_hash_walk_first(req, &walk);
 
 	/* Empty message ("") is correct indata */
-	if (msg_length == 0) {
-		ret = 0;
-		goto release_dev;
-	}
+	if (msg_length == 0)
+		return 0;
 
 	/* Check if ctx->state.length + msg_length
 	   overflows */
 	if (msg_length > (req_ctx->state.length.low_word + msg_length) &&
 	    HASH_HIGH_WORD_MAX_VAL == req_ctx->state.length.high_word) {
 		pr_err("%s: HASH_MSG_LENGTH_OVERFLOW!\n", __func__);
-		ret = crypto_hash_walk_done(&walk, -EPERM);
-		goto release_dev;
+		return crypto_hash_walk_done(&walk, -EPERM);
 	}
 
 	/* Main loop */
@@ -1110,7 +1001,7 @@ int hash_hw_update(struct ahash_request *req)
 			dev_err(device_data->dev, "%s: hash_internal_hw_update() failed!\n",
 				__func__);
 			crypto_hash_walk_done(&walk, ret);
-			goto release_dev;
+			return ret;
 		}
 
 		msg_length = crypto_hash_walk_done(&walk, 0);
@@ -1120,10 +1011,7 @@ int hash_hw_update(struct ahash_request *req)
 	dev_dbg(device_data->dev, "%s: indata length=%d, bin=%d\n",
 		__func__, req_ctx->state.index, req_ctx->state.bit_index);
 
-release_dev:
-	release_hash_device(device_data);
-
-	return ret;
+	return 0;
 }
 
 /**
@@ -1495,6 +1383,7 @@ static int hmac_sha256_setkey(struct crypto_ahash *tfm,
 struct hash_algo_template {
 	struct hash_config conf;
 	struct ahash_alg hash;
+	struct hash_device_data	*device;
 };
 
 static int hash_cra_init(struct crypto_tfm *tfm)
@@ -1507,6 +1396,8 @@ static int hash_cra_init(struct crypto_tfm *tfm)
 			struct hash_algo_template,
 			hash);
 
+	ctx->device = hash_alg->device;
+
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct hash_req_ctx));
 
@@ -1623,6 +1514,7 @@ static int ahash_algs_register_all(struct hash_device_data *device_data)
 	int count;
 
 	for (i = 0; i < ARRAY_SIZE(hash_algs); i++) {
+		hash_algs[i].device = device_data;
 		ret = crypto_register_ahash(&hash_algs[i].hash);
 		if (ret) {
 			count = i;
@@ -1723,11 +1615,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, device_data);
 
-	/* Put the new device into the device list... */
-	klist_add_tail(&device_data->list_node, &driver_data.device_list);
-	/* ... and signal that a new device is available. */
-	up(&driver_data.device_allocation);
-
 	ret = ahash_algs_register_all(device_data);
 	if (ret) {
 		dev_err(dev, "%s: ahash_algs_register_all() failed!\n",
@@ -1766,10 +1653,6 @@ static int ux500_hash_remove(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	/* Try to decrease the number of available devices. */
-	if (down_trylock(&driver_data.device_allocation))
-		return -EBUSY;
-
 	/* Check that the device is free */
 	spin_lock(&device_data->ctx_lock);
 	/* current_ctx allocates a device, NULL = unallocated */
@@ -1777,19 +1660,12 @@ static int ux500_hash_remove(struct platform_device *pdev)
 		/* The device is busy */
 		spin_unlock(&device_data->ctx_lock);
 		/* Return the device to the pool. */
-		up(&driver_data.device_allocation);
 		return -EBUSY;
 	}
 
 	spin_unlock(&device_data->ctx_lock);
 
-	/* Remove the device from the list */
-	if (klist_node_attached(&device_data->list_node))
-		klist_remove(&device_data->list_node);
-
-	/* If this was the last device, remove the services */
-	if (list_empty(&driver_data.device_list.k_list))
-		ahash_algs_unregister_all(device_data);
+	ahash_algs_unregister_all(device_data);
 
 	if (hash_disable_power(device_data, false))
 		dev_err(dev, "%s: hash_disable_power() failed\n",
@@ -1820,9 +1696,6 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 	spin_lock(&device_data->ctx_lock);
 	/* current_ctx allocates a device, NULL = unallocated */
 	if (!device_data->current_ctx) {
-		if (down_trylock(&driver_data.device_allocation))
-			dev_dbg(&pdev->dev, "%s: Cryp still in use! Shutting down anyway...\n",
-				__func__);
 		/**
 		 * (Allocate the device)
 		 * Need to set this to non-null (dummy) value,
@@ -1832,13 +1705,7 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 	}
 	spin_unlock(&device_data->ctx_lock);
 
-	/* Remove the device from the list */
-	if (klist_node_attached(&device_data->list_node))
-		klist_remove(&device_data->list_node);
-
-	/* If this was the last device, remove the services */
-	if (list_empty(&driver_data.device_list.k_list))
-		ahash_algs_unregister_all(device_data);
+	ahash_algs_unregister_all(device_data);
 
 	if (hash_disable_power(device_data, false))
 		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
@@ -1868,9 +1735,6 @@ static int ux500_hash_suspend(struct device *dev)
 	spin_unlock(&device_data->ctx_lock);
 
 	if (device_data->current_ctx == ++temp_ctx) {
-		if (down_interruptible(&driver_data.device_allocation))
-			dev_dbg(dev, "%s: down_interruptible() failed\n",
-				__func__);
 		ret = hash_disable_power(device_data, false);
 
 	} else {
@@ -1904,9 +1768,7 @@ static int ux500_hash_resume(struct device *dev)
 		device_data->current_ctx = NULL;
 	spin_unlock(&device_data->ctx_lock);
 
-	if (!device_data->current_ctx)
-		up(&driver_data.device_allocation);
-	else
+	if (device_data->current_ctx)
 		ret = hash_enable_power(device_data, true);
 
 	if (ret)
@@ -1924,7 +1786,7 @@ static const struct of_device_id ux500_hash_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ux500_hash_match);
 
-static struct platform_driver hash_driver = {
+static struct platform_driver ux500_hash_driver = {
 	.probe  = ux500_hash_probe,
 	.remove = ux500_hash_remove,
 	.shutdown = ux500_hash_shutdown,
@@ -1934,29 +1796,7 @@ static struct platform_driver hash_driver = {
 		.pm    = &ux500_hash_pm,
 	}
 };
-
-/**
- * ux500_hash_mod_init - The kernel module init function.
- */
-static int __init ux500_hash_mod_init(void)
-{
-	klist_init(&driver_data.device_list, NULL, NULL);
-	/* Initialize the semaphore to 0 devices (locked state) */
-	sema_init(&driver_data.device_allocation, 0);
-
-	return platform_driver_register(&hash_driver);
-}
-
-/**
- * ux500_hash_mod_fini - The kernel module exit function.
- */
-static void __exit ux500_hash_mod_fini(void)
-{
-	platform_driver_unregister(&hash_driver);
-}
-
-module_init(ux500_hash_mod_init);
-module_exit(ux500_hash_mod_fini);
+module_platform_driver(ux500_hash_driver);
 
 MODULE_DESCRIPTION("Driver for ST-Ericsson UX500 HASH engine.");
 MODULE_LICENSE("GPL");
-- 
2.37.2

