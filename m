From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] crypto: hifn_795x - fix to pass correct device identity to free_irq()
Date: Tue, 28 May 2013 17:10:23 +0800
Message-ID: <CAPgLHd-owwK7Yzr15zFx=aak_1vn+uZ_jxJTCM4GqR+u4COQsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64287 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab3E1JKZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 05:10:25 -0400
Received: by mail-bk0-f44.google.com with SMTP id jc3so4074329bkc.17
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2013 02:10:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

free_irq() expects the same device identity that was passed
to request_irq(), otherwise the IRQ is not freed.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/hifn_795x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index ebf130e..12fea3e 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2676,7 +2676,7 @@ err_out_stop_device:
 	hifn_reset_dma(dev, 1);
 	hifn_stop_device(dev);
 err_out_free_irq:
-	free_irq(dev->irq, dev->name);
+	free_irq(dev->irq, dev);
 	tasklet_kill(&dev->tasklet);
 err_out_free_desc:
 	pci_free_consistent(pdev, sizeof(struct hifn_dma),
@@ -2711,7 +2711,7 @@ static void hifn_remove(struct pci_dev *pdev)
 		hifn_reset_dma(dev, 1);
 		hifn_stop_device(dev);
 
-		free_irq(dev->irq, dev->name);
+		free_irq(dev->irq, dev);
 		tasklet_kill(&dev->tasklet);
 
 		hifn_flush(dev);
