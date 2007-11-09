From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN: schedule callback invocation to tasklet.
Date: Fri, 9 Nov 2007 21:31:56 +0300
Message-ID: <20071109183154.GA27736@2ka.mipt.ru>
References: <20071109161214.GA18200@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40823 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbXKISbg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2007 13:31:36 -0500
Content-Disposition: inline
In-Reply-To: <20071109161214.GA18200@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 09, 2007 at 07:12:14PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> This patch forces HIFN driver to invoke crypto request callbacks from
> tasklet (softirq context) instead of hardirq context, since network
> stack expects it to be called from bottom halves.

And first patch is obviously wrong, since it does not stop tasklet on
exit path, please apply given one.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e152917..0a7c07b 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/interrupt.h>
 #include <linux/crypto.h>
 
 #include <crypto/algapi.h>
@@ -425,6 +426,8 @@ struct hifn_device
 
 	u8			snum;
 
+	struct tasklet_struct	tasklet;
+
 	struct crypto_queue 	queue;
 	struct list_head	alg_list;
 };
@@ -1881,7 +1884,7 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
 	}
 
-	hifn_check_for_completion(dev, 0);
+	tasklet_schedule(&dev->tasklet);
 	hifn_clear_rings(dev);
 
 	return IRQ_HANDLED;
@@ -2414,6 +2417,19 @@ err_out_exit:
 	return err;
 }
 
+static void hifn_tasklet_callback(unsigned long data)
+{
+	struct hifn_device *dev = (struct hifn_device *)data;
+
+	/*
+	 * This is ok to call this without lock being held,
+	 * althogh it modifies some parameters used in parallel,
+	 * (like dev->success), but they are used in process
+	 * context or update is atomic (like setting dev->sa[i] to NULL).
+	 */
+	hifn_check_for_completion(dev, 0);
+}
+
 static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err, i;
@@ -2495,6 +2511,8 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, dev);
 
+	tasklet_init(&dev->tasklet, hifn_tasklet_callback, (unsigned long)dev);
+
 	crypto_init_queue(&dev->queue, 1);
 
 	err = request_irq(dev->irq, hifn_interrupt, IRQF_SHARED, dev->name, dev);
@@ -2530,6 +2548,7 @@ err_out_stop_device:
 	hifn_stop_device(dev);
 err_out_free_irq:
 	free_irq(dev->irq, dev->name);
+	tasklet_kill(&dev->tasklet);
 err_out_free_desc:
 	pci_free_consistent(pdev, sizeof(struct hifn_dma),
 			dev->desc_virt, dev->desc_dma);
@@ -2569,6 +2588,7 @@ static void hifn_remove(struct pci_dev *pdev)
 		hifn_stop_device(dev);
 
 		free_irq(dev->irq, dev->name);
+		tasklet_kill(&dev->tasklet);
 
 		hifn_flush(dev);
 

-- 
	Evgeniy Polyakov
