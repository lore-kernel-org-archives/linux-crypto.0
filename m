Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0BDC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0AD23356
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbhAGMb0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbhAGMb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:31:26 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B82C0612F4;
        Thu,  7 Jan 2021 04:30:45 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q20so484531pfu.8;
        Thu, 07 Jan 2021 04:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HNZLvmQAqbtAqMEvJP1wVGbLyEu2FmrY5NiRBOEZCk0=;
        b=r/Samj46HFOW22YwxxLKb7kXMfMJZkv+fNvz018vr4h6HXcjxcSKw5uY/aUxVaNcbo
         KH5B6prk28ejw3y5Ryfrz5Km9447Lb354jWKYqAmIXuoiCXbzseR9s1/hc3Pbu5madIw
         59WJV5JdKd1D4B2VAz5IGa35TZtVnrMQxgNLe8wD/s24o3Ejm29SxHAcxFG+Ca8yfayr
         h8FI+MQ4no59/kwrzdc6usou78p/m/y4ubf8AfkQjlVGHlk2s6QUG3oeuyzU/5xbvqNE
         7UJCTmQ2GQvzKNskROlUCWNiGtQyjcl4p1atnUflE1tNsKbjAVTJ2X+FzPOGqWR6xn5K
         Cktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HNZLvmQAqbtAqMEvJP1wVGbLyEu2FmrY5NiRBOEZCk0=;
        b=dc3HPosJWvreaMbYB4p1kkX2JNzG/9a91rycu3Nw+0YQrPAVU6mLw8tUX6bgOZSrFm
         95ZXI5ss+2cIoaJ63Y+U23bPKcmx1ZxwqmfTOyhAxkD+ofthpQxmJscJnBB8Yn4lq034
         zRPoL/RL9GdiqGIhEB6pDuuJELW7gqv0AWlH9+siYQbKFyLRdNnqQKx7YTVwBzqLm2+6
         wfNe5SEO4RUYI7CCd2MOlAZ+sLH1qpBe2Nr2jjcqzUX3lZk2+/dw3AbmXRoIsIp5OLQi
         MjsPh5EarHHyg2RNwIQAj4BPNT5YHYPvl10WbtCPl0XJutqebg5idCpawJQ/7Et7EuT1
         O5nQ==
X-Gm-Message-State: AOAM533BwyDBLJmGkb8o2xNJF/FqcaG1ww+FHhdGcxbWARQxHXLRRRt4
        kHCL9/PqNn87+iRYDCrXPUA=
X-Google-Smtp-Source: ABdhPJwyAj4F5Fhuw4gMLL7mw2TuD871TGVzFmlexoKSH7il+8JqllUpDbrl6cfZ8d+zKs+UvJn9zw==
X-Received: by 2002:a63:3549:: with SMTP id c70mr1607262pga.361.1610022645408;
        Thu, 07 Jan 2021 04:30:45 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:30:44 -0800 (PST)
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
Subject: [PATCH v2 09/19] crypto: img-hash: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:34 +0530
Message-Id: <20210107122944.16363-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
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
 drivers/crypto/img-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index e813115d5432..72b65cdff856 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -355,9 +355,9 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_dma_task(unsigned long d)
+static void img_hash_dma_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)d;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, dma_task);
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 	u8 *addr;
 	size_t nbytes, bleft, wsend, len, tbc;
@@ -887,9 +887,9 @@ static int img_unregister_algs(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_done_task(unsigned long data)
+static void img_hash_done_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)data;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, done_task);
 	int err = 0;
 
 	if (hdev->err == -EINVAL) {
@@ -954,8 +954,8 @@ static int img_hash_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&hdev->list);
 
-	tasklet_init(&hdev->done_task, img_hash_done_task, (unsigned long)hdev);
-	tasklet_init(&hdev->dma_task, img_hash_dma_task, (unsigned long)hdev);
+	tasklet_setup(&hdev->done_task, img_hash_done_task);
+	tasklet_setup(&hdev->dma_task, img_hash_dma_task);
 
 	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
 
-- 
2.25.1

