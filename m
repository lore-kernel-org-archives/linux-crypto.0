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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F213FC1B0D9
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9035233A1
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgLGJBW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJBW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:22 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9CEC0613D2
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:45 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id e23so8323930pgk.12
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TLIrEr5wIXMbPu/4ewr5f4rk76+fGINRwBQrZI3OqEw=;
        b=LKi32KPFqNL3vsQH95/IP3J4ZnxdIbx6nTb41ksojqyqu8D5bqYJ0PMWBWl8K2Lgjx
         qOW2uT/woyfMJcsFUn4K3xNCyM21dIi+UuLHklEo3t5E5LfGe9EsXXbrQzguU0ACH5NE
         dNIlhG8o8hQWZr8KLtT8FSF9dJD6xGJmRUS8C7iejl7NEoEXwwIJYfTnDiD9E2j5cuBb
         pJEkZC3aSVw/Ji6XEVx+WQeREfTMiyGSINg58WWpIoq0udwWnyr44PeuPESoVGXvGfxM
         pZVHHjEJavlk8GI51ZR0gUM1BuyZkD1IizB0GB8LdwI3qByTG0UMdtd34ZohwlmlpXGW
         tVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TLIrEr5wIXMbPu/4ewr5f4rk76+fGINRwBQrZI3OqEw=;
        b=i4YTgwCK0xbwBaOYTOjSE0iP2ww/ajZElzHeq25HbK8+o/S22mx/4h0d60BoR8acxq
         a54fm0CR0lPlR2ja8tNBS9iVtEWL8+HK5USvQ0tHE3ASMxBfQFt857/thQP1BrNN6+xI
         epTGcueXROGojW4kAYeBciAgEtLaNvxjm3UH8kUQbGT06ZZCnQeIRhwQceOgLHgz0TS/
         pt5p8w91MBCrboayfMdNR+mlwxb6wlgj/oOp6ujLpzRd1cz3onTosb88QL6A4E0I5iJY
         TTdHdi0+FkYksZMIq/PWPbwhJtGz5MhnYgkn71BJzKWq/y1C0r6CRxfDLnaRA98E+woa
         7UiA==
X-Gm-Message-State: AOAM531gbYilzZNDOBDgb4fWzQKdMk54p6Cqu9s72h3Q9kCBWG+uH50y
        jSjy/i0P3qNslEFe3jY3ZCM=
X-Google-Smtp-Source: ABdhPJw2neGee+CSqL2cvtMD7aGaxj+EyJNO7rpepJpVskZmSn3ulrUj6CKN0KUNYz9FfWiYUf++nA==
X-Received: by 2002:a65:4887:: with SMTP id n7mr17818622pgs.85.1607331644974;
        Mon, 07 Dec 2020 01:00:44 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:44 -0800 (PST)
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
Subject: [RESEND 09/19] crypto: img-hash: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:21 +0530
Message-Id: <20201207085931.661267-10-allen.lkml@gmail.com>
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
 drivers/crypto/img-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 91f555ccbb31..9b66f9d8c52a 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -354,9 +354,9 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
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
@@ -886,9 +886,9 @@ static int img_unregister_algs(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_done_task(unsigned long data)
+static void img_hash_done_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)data;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, done_task);
 	int err = 0;
 
 	if (hdev->err == -EINVAL) {
@@ -953,8 +953,8 @@ static int img_hash_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&hdev->list);
 
-	tasklet_init(&hdev->done_task, img_hash_done_task, (unsigned long)hdev);
-	tasklet_init(&hdev->dma_task, img_hash_dma_task, (unsigned long)hdev);
+	tasklet_setup(&hdev->done_task, img_hash_done_task);
+	tasklet_setup(&hdev->dma_task, img_hash_dma_task);
 
 	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
 
-- 
2.25.1

