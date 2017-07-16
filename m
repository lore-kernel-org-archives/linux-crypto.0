From: Mogens Lauridsen <mlauridsen171@gmail.com>
Subject: Patch: Remove leftover from spinlock previous used in sahara driver
Date: Sun, 16 Jul 2017 23:29:04 +0200
Message-ID: <CACA-NJvmTCkBP1fTuLb71BVeXubuwKj9Gu1ZcgCMXgt9w2-N9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33556 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdGPV3F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jul 2017 17:29:05 -0400
Received: by mail-io0-f195.google.com with SMTP id z62so6176219ioi.0
        for <linux-crypto@vger.kernel.org>; Sun, 16 Jul 2017 14:29:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The Freescale sahara driver has previously used a spinlock. This
spinlock has been removed, but the spinlock variable is still there
and is also being initialized. This patch removes the leftover.

Thanks,
Mogens Lauridsen

Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 9538c52..b35cbda 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -202,7 +202,6 @@ struct sahara_dev {
     struct completion    dma_completion;

     struct sahara_ctx    *ctx;
-    spinlock_t        lock;
     struct crypto_queue    queue;
     unsigned long        flags;

@@ -1487,7 +1486,6 @@ static int sahara_probe(struct platform_device *pdev)

     crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);

-    spin_lock_init(&dev->lock);
     mutex_init(&dev->queue_mutex);

     dev_ptr = dev;
