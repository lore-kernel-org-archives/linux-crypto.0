Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A8DC4167B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B4F23341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgLGJAf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJAf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:00:35 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D95C0613D2
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 00:59:58 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id e5so6979950pjt.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 00:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQmsB3eRaTqWnNYrdOpAfX6/DjfqVjGaRHnXLnbG4FE=;
        b=NVjazYzkyJFBEGofN0G6piHHeauL0d1lCqUsYHwLEP62AbEcTPXqugfibhgH76AgQC
         o7JZ0HL0qydJ5sokhcydeLzpjAHrR9cY7MjX5GtCL7hgVYqExcCbagyMwHacjzpBkZYL
         g5PRa26b8vzDZdLJ5tZRddTbP3WsAsHkPpGwIotzvteMV2EZ4toDNvJodHMku18/C8em
         qqYE5vfPF/dISMmXJcuzn1M8PXd4Dv/Rs1V8qiy2AL08sj9KbSBCHBHkV4XKr3ZpAx61
         hdGg8bFNG6U0ZlS++fYmTVJt6devZdGyqm+L14SDwuYz4aNZtGhLanYJLAm7qTmVLGcB
         1aOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQmsB3eRaTqWnNYrdOpAfX6/DjfqVjGaRHnXLnbG4FE=;
        b=YbgfJ849WFgCHAn56JNFYtem6sNVZ/wdM7yWM4oAG8avu0DyKcZyhHatz9CZe6K672
         Uvo0zoUWA9sgCpCdtAMBIBA50tJc93+S/WWKz424FcfvB1RQxQisZWZ0bW43hAShB62Y
         BvIrKJqU/k++k46AdsbbOCqjSg1eYo34vFqrYgmhwLk5TpwP96xxbnhHBcMOI4T399v1
         kyc0vRMQYs8B3pll+29fp3I+jCBbi8BahSCZVtvGT8DtPsDlU1buJvApNWGpjxPklYYk
         dNoXVvTQQ7Z5j0lVq7deLUoSw5RFZflKI7W6YCsGrSbjUcU8scz74TzEXG2ZfAP521q1
         vgOA==
X-Gm-Message-State: AOAM530XZQdwE6+8fOQfofl8Vwfv/QLppsADWsMVfVui9JGrzc/nUugS
        ioW5cjZ6XZDqNA0nFlPWom4=
X-Google-Smtp-Source: ABdhPJxHMnul7yrU/QIEWrPq3/O0e45B5Em3LEfX2JjW8Wuh9SMbO36XXv5iE+h2ZpvA2f3fFxfU0Q==
X-Received: by 2002:a17:90a:990f:: with SMTP id b15mr15239943pjp.166.1607331597564;
        Mon, 07 Dec 2020 00:59:57 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.00.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 00:59:57 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 02/19] crypto: atmel: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:14 +0530
Message-Id: <20201207085931.661267-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/atmel-aes.c  | 14 ++++++--------
 drivers/crypto/atmel-sha.c  | 14 ++++++--------
 drivers/crypto/atmel-tdes.c | 14 ++++++--------
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index b1d286004295..804e6a5a39d4 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2300,16 +2300,16 @@ static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
 	dma_release_channel(dd->src.chan);
 }
 
-static void atmel_aes_queue_task(unsigned long data)
+static void atmel_aes_queue_task(struct tasklet_struct *t)
 {
-	struct atmel_aes_dev *dd = (struct atmel_aes_dev *)data;
+	struct atmel_aes_dev *dd = from_tasklet(dd, t, queue_task);
 
 	atmel_aes_handle_queue(dd, NULL);
 }
 
-static void atmel_aes_done_task(unsigned long data)
+static void atmel_aes_done_task(struct tasklet_struct *t)
 {
-	struct atmel_aes_dev *dd = (struct atmel_aes_dev *)data;
+	struct atmel_aes_dev *dd = from_tasklet(dd, t, done_task);
 
 	dd->is_async = true;
 	(void)dd->resume(dd);
@@ -2499,10 +2499,8 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&aes_dd->list);
 	spin_lock_init(&aes_dd->lock);
 
-	tasklet_init(&aes_dd->done_task, atmel_aes_done_task,
-					(unsigned long)aes_dd);
-	tasklet_init(&aes_dd->queue_task, atmel_aes_queue_task,
-					(unsigned long)aes_dd);
+	tasklet_setup(&aes_dd->done_task, atmel_aes_done_task);
+	tasklet_setup(&aes_dd->queue_task, atmel_aes_queue_task);
 
 	crypto_init_queue(&aes_dd->queue, ATMEL_AES_QUEUE_LENGTH);
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 75ccf41a7cb9..84a7c8a9dd02 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1314,9 +1314,9 @@ static struct ahash_alg sha_384_512_algs[] = {
 },
 };
 
-static void atmel_sha_queue_task(unsigned long data)
+static void atmel_sha_queue_task(struct tasklet_struct *t)
 {
-	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
+	struct atmel_sha_dev *dd = from_tasklet(dd, t, queue_task);
 
 	atmel_sha_handle_queue(dd, NULL);
 }
@@ -1353,9 +1353,9 @@ static int atmel_sha_done(struct atmel_sha_dev *dd)
 	return err;
 }
 
-static void atmel_sha_done_task(unsigned long data)
+static void atmel_sha_done_task(struct tasklet_struct *t)
 {
-	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
+	struct atmel_sha_dev *dd = from_tasklet(dd, t, done_task);
 
 	dd->is_async = true;
 	(void)dd->resume(dd);
@@ -2570,10 +2570,8 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&sha_dd->list);
 	spin_lock_init(&sha_dd->lock);
 
-	tasklet_init(&sha_dd->done_task, atmel_sha_done_task,
-					(unsigned long)sha_dd);
-	tasklet_init(&sha_dd->queue_task, atmel_sha_queue_task,
-					(unsigned long)sha_dd);
+	tasklet_setup(&sha_dd->done_task, atmel_sha_done_task);
+	tasklet_setup(&sha_dd->queue_task, atmel_sha_queue_task);
 
 	crypto_init_queue(&sha_dd->queue, ATMEL_SHA_QUEUE_LENGTH);
 
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 4d63cb13a54f..b7a734f666ae 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1049,16 +1049,16 @@ static struct skcipher_alg tdes_algs[] = {
 },
 };
 
-static void atmel_tdes_queue_task(unsigned long data)
+static void atmel_tdes_queue_task(struct tasklet_struct *t)
 {
-	struct atmel_tdes_dev *dd = (struct atmel_tdes_dev *)data;
+	struct atmel_tdes_dev *dd = from_tasklet(dd, t, queue_task);
 
 	atmel_tdes_handle_queue(dd, NULL);
 }
 
-static void atmel_tdes_done_task(unsigned long data)
+static void atmel_tdes_done_task(struct tasklet_struct *t)
 {
-	struct atmel_tdes_dev *dd = (struct atmel_tdes_dev *) data;
+	struct atmel_tdes_dev *dd = from_tasklet(dd, t, done_task);
 	int err;
 
 	if (!(dd->flags & TDES_FLAGS_DMA))
@@ -1177,10 +1177,8 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&tdes_dd->list);
 	spin_lock_init(&tdes_dd->lock);
 
-	tasklet_init(&tdes_dd->done_task, atmel_tdes_done_task,
-					(unsigned long)tdes_dd);
-	tasklet_init(&tdes_dd->queue_task, atmel_tdes_queue_task,
-					(unsigned long)tdes_dd);
+	tasklet_setup(&tdes_dd->done_task, atmel_tdes_done_task);
+	tasklet_setup(&tdes_dd->queue_task, atmel_tdes_queue_task);
 
 	crypto_init_queue(&tdes_dd->queue, ATMEL_TDES_QUEUE_LENGTH);
 
-- 
2.25.1

