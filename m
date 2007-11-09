From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/1] HIFN: schedule callback invocation to tasklet.
Date: Fri, 9 Nov 2007 19:12:14 +0300
Message-ID: <20071109161214.GA18200@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60918 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXKIQLx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2007 11:11:53 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

This patch forces HIFN driver to invoke crypto request callbacks from
tasklet (softirq context) instead of hardirq context, since network
stack expects it to be called from bottom halves.

It is done by simply scheduling callback invocation via dedicated
tasklet. Workqueue solution was dropped because of tooo slow
rescheduling performance (7 times slower than tasklet, for mode details
one can check this link:
http://tservice.net.ru/~s0mbre/blog/devel/other/2007_11_09.html).

Driver passed all AES and DES tests in tcryt.c module.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e152917..f5aa939 100644
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

-- 
	Evgeniy Polyakov
