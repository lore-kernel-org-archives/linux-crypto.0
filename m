From: Mogens Lauridsen <mlauridsen171@gmail.com>
Subject: [PATCH] crypto: sahara - Remove leftover from previous used spinlock
Date: Thu,  3 Aug 2017 15:46:35 +0200
Message-ID: <20170803134635.14726-1-mlauridsen171@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Mogens Lauridsen <mlauridsen171@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37169 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752012AbdHCNql (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 09:46:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id t138so2251199wmt.4
        for <linux-crypto@vger.kernel.org>; Thu, 03 Aug 2017 06:46:41 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This driver previously used a spinlock. The spinlock is not
used any more, but the spinlock variable was still there
and also being initialized.

Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>
---
 drivers/crypto/sahara.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 474da36bdd2c..03a8abad7e76 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -202,7 +202,6 @@ struct sahara_dev {
 	struct completion	dma_completion;
 
 	struct sahara_ctx	*ctx;
-	spinlock_t		lock;
 	struct crypto_queue	queue;
 	unsigned long		flags;
 
@@ -1487,7 +1486,6 @@ static int sahara_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
 
-	spin_lock_init(&dev->lock);
 	mutex_init(&dev->queue_mutex);
 
 	dev_ptr = dev;
-- 
2.13.4
