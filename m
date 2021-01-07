Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085F3C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C576522D75
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbhAGM2I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbhAGM2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:28:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26328C0612F6;
        Thu,  7 Jan 2021 04:27:27 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w1so3998098pjc.0;
        Thu, 07 Jan 2021 04:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ChEdTs09dQ0RBgzbeZxLNBVFnUFhvXMwpM6L2ZZDSyQ=;
        b=kAoid7v3FFbiH7oBR3uCo/5IkT/s0C/4bktioTxr1/loZe/W5KibwOVR52gcw1e5/A
         4/d+YGm05IwecPjuh5EMd/RqRZXfjbDWSUqSueab0WaimcV8GlM4wtvcBvEVL0F628e4
         LvScvGROPJr/WtqXrJFmpUHlu14ZAhR6MyynIKgr6qftmzU1VDZeUbfLP/4rMglys9RZ
         9raw70l7X0PJlt4hvT05S50I6+k3GfUJOiNttjxs8G0NEPHfoMj9h/2V2EHBkBBmA6BM
         IxD9gPR6n63Bt/Fs3LYBjjdBLKExxxPHQjMkCfFIK95n3kg5oR+wcut7W24c22/FAPbX
         mW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ChEdTs09dQ0RBgzbeZxLNBVFnUFhvXMwpM6L2ZZDSyQ=;
        b=JV675MYcN2M5ZBnT45/F6i4IV3ZQB+RS+tAZqEfCwuCQC47DBU2kraUrTVLW4K+z91
         YtklWmlwWm722sz7vvA89f6xD3FMxI6A8VT4Upp2pFBQMDeSE/plqQEAA73tS1UPkrcD
         89Ju3h1ZPEF4a5ittMoGnWh39+JX2rQKwHe7NXl9qn8Ps+Ph9G7d8lV4TU7BmSOopWZH
         BKZ8OVd8GYzKfKk91vx1xOhd0AjLLJcD/HkIqEBBXz3LAPIGZZYPoielgkZKHU9oWSBd
         nrLDY7GV8Vg7lAKnx8m79lcCNLOVqKwqD+jAFveSn9u9D33q7nvUTZT3zJ+xxFihspuP
         fcMA==
X-Gm-Message-State: AOAM532jHOiqPxmZ3vdp5P2dcXyy6jh+gr+QU4WmDi07pQaGW4dckXd/
        SXS+G7PcnkevjInaWRPoPtY=
X-Google-Smtp-Source: ABdhPJydfhet9xlKM8LSiwmiP9ivKiEWjw5v+sep8vL8Nxz74x1JQp9iAk5faH/2yMMCOKbW/KMHWg==
X-Received: by 2002:a17:90a:7087:: with SMTP id g7mr9055469pjk.200.1610022446738;
        Thu, 07 Jan 2021 04:27:26 -0800 (PST)
Received: from localhost.localdomain ([49.207.207.140])
        by smtp.gmail.com with ESMTPSA id x28sm5860403pff.182.2021.01.07.04.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:27:26 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 02/19] crypto: atmel: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:56:29 +0530
Message-Id: <20210107122646.16055-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122646.16055-1-allen.lkml@gmail.com>
References: <20210107122646.16055-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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
index 352d80cb5ae9..8ec8a32606e8 100644
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

