Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BDCC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiGYOHa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbiGYOH1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:27 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044CF14087
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:25 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b16so5762637lfb.7
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZBy4mH3tH/mKdYrWAHsE8vj+OWKXhvzJV2v2xxRnpkk=;
        b=BoZYnRmPSAfvA0ruBqvQ3onCm2I/HVp0JbBxyUZ0IlOj6pCAxsM1kcMvqd0Mc7JFsS
         Lqk4A6xPAxhCY9KBy2CjH3478VC2EovsVOPBvkNaPMSOOOY3M52DbfTNNg3Lz15YoYjE
         tAtmvbKHFpa6heq/jMSD2QLGxunld9FrWsIkEt5xVsdHiJNsrfLRF/zlE1j/Oejhy8Ly
         sZDq0As1Qi7UQ44B6jEMOp2jQ7KColdNUysi5rJJv5gPEB6YljU2LrIzZeJL13290TvD
         n9QUGo/UbSzOtbNHC9j53s79b7QRjLrpjOXKYb/ctvkhRI/5XeNhsSDM8zi60G4K1tl3
         6rxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBy4mH3tH/mKdYrWAHsE8vj+OWKXhvzJV2v2xxRnpkk=;
        b=BndH6sGz6ECJRNnvU6+9qdZ45lKkEgq/eAK2j0yOz6GiExcKBw4rDfFVWKk4+SkDU6
         4PfG7vS+YiqdI1UK6M7E4ZgFPGtrWd4Dn6rxnbNOKYGVOCQxBT/jLGwAcI95HqBcDhOq
         pOLzz1mIsmcNYG2sg6U7yc6eC+Ure2+Dy6dW9dQaWKdGi7jk1whYLruv12ZCXmVYJtWk
         5hQ6PbNDP57ZuYD4dMGJZEAbqJvPnO9oSQlUUoml6Z+EOn2kzO11zbzfCwtDhe84/Sbb
         2BjqjjhL6WAfpKZO0pXlFFRq6zEVRaXUzJtlgKgfDAiAqjMHfWZ7vCJx3tJ1csSb5hhx
         DppQ==
X-Gm-Message-State: AJIora86zLHsKeOKEgWP5liujAJXLG/l2HuWFeGCuV6nLeCsPUs1bcCZ
        cIRv+aPWXRJSCwB6lXt82vJCudqoXHz23w==
X-Google-Smtp-Source: AGRyM1sYgcqD+1vlk+ePPVy+Hs9MZJ8Zce8GL7/S4pHY6bp+oaUSCtUHmQ3Lqw+ruf1ecI0QaGXK8Q==
X-Received: by 2002:a05:6512:258b:b0:48a:83da:4f0a with SMTP id bf11-20020a056512258b00b0048a83da4f0amr3326060lfb.256.1658758042940;
        Mon, 25 Jul 2022 07:07:22 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:22 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/15 v2] crypto: ux500/hash: Get rid of custom device list
Date:   Mon, 25 Jul 2022 16:04:51 +0200
Message-Id: <20220725140504.2398965-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
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
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 194 +++-----------------------
 1 file changed, 17 insertions(+), 177 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index dfdf3e35d94f..fd7a862244ac 100644
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
2.36.1

