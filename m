From: Mogens Lauridsen <mlauridsen171@gmail.com>
Subject: Fix dma unmap direction in iMX sahara aes calculation
Date: Sun, 16 Jul 2017 23:21:04 +0200
Message-ID: <CACA-NJv69LnyR-xcJC8OU-_WRfg1Mtawq9UapswQczrdAonFDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34103 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdGPVVF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jul 2017 17:21:05 -0400
Received: by mail-it0-f68.google.com with SMTP id o202so16604372itc.1
        for <linux-crypto@vger.kernel.org>; Sun, 16 Jul 2017 14:21:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The direction used in dma_unmap_sg in aes calc in sahara.c is wrong.
This result in the cache not being invalidated correct when aes
calculation is done and result is dma'ed to memory.
This is seen as sporadic wrong result from aes calc.

Thanks,
Mogens

Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 1d9ecd3..9538c52 100644ae
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -543,10 +543,10 @@ static int sahara_hw_descriptor_create(struct sahara_dev *

 unmap_out:
        dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-               DMA_TO_DEVICE);
+               DMA_FROM_DEVICE);
 unmap_in:
        dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
-               DMA_FROM_DEVICE);
+               DMA_TO_DEVICE);

        return -EINVAL;
 }
@@ -594,9 +594,9 @@ static int sahara_aes_process(struct ablkcipher_request *req
        }

        dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-               DMA_TO_DEVICE);
-       dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
                DMA_FROM_DEVICE);
+       dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+               DMA_TO_DEVICE);

        return 0;
 }
