From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4/4] crypto: s5p-sss - Use mutex instead of spinlock
Date: Fri, 17 Mar 2017 16:49:22 +0200
Message-ID: <20170317144922.27379-5-krzk@kernel.org>
References: <20170317144922.27379-1-krzk@kernel.org>
Cc: Nathan Royce <nroycea+kernel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170317144922.27379-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Driver uses threaded interrupt handler so there is no real need for
using spinlocks for synchronization.  Mutexes would do fine and are
friendlier for overall system preemptivness and real-time behavior.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7ac657f46d15..1893cf5dedc0 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
@@ -214,7 +215,7 @@ struct s5p_aes_dev {
 	struct tasklet_struct		tasklet;
 	struct crypto_queue		queue;
 	bool				busy;
-	spinlock_t			lock;
+	struct mutex			lock;
 };
 
 static struct s5p_aes_dev *s5p_dev;
@@ -443,11 +444,10 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
 	bool tx_end = false;
-	unsigned long flags;
 	uint32_t status;
 	int err;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	mutex_lock(&dev->lock);
 
 	/*
 	 * Handle rx or tx interrupt. If there is still data (scatterlist did not
@@ -481,7 +481,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 	if (tx_end) {
 		s5p_sg_done(dev);
 
-		spin_unlock_irqrestore(&dev->lock, flags);
+		mutex_unlock(&dev->lock);
 
 		s5p_aes_complete(dev, 0);
 		/* Device is still busy */
@@ -498,7 +498,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 		if (err_dma_rx == 1)
 			s5p_set_dma_indata(dev, dev->sg_src);
 
-		spin_unlock_irqrestore(&dev->lock, flags);
+		mutex_unlock(&dev->lock);
 	}
 
 	return IRQ_HANDLED;
@@ -506,7 +506,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 error:
 	s5p_sg_done(dev);
 	dev->busy = false;
-	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock);
 	s5p_aes_complete(dev, err);
 
 	return IRQ_HANDLED;
@@ -599,7 +599,6 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 {
 	struct ablkcipher_request *req = dev->req;
 	uint32_t aes_control;
-	unsigned long flags;
 	int err;
 
 	aes_control = SSS_AES_KEY_CHANGE_MODE;
@@ -625,7 +624,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 		    |  SSS_AES_BYTESWAP_KEY
 		    |  SSS_AES_BYTESWAP_CNT;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	mutex_lock(&dev->lock);
 
 	SSS_WRITE(dev, FCINTENCLR,
 		  SSS_FCINTENCLR_BTDMAINTENCLR | SSS_FCINTENCLR_BRDMAINTENCLR);
@@ -648,7 +647,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	SSS_WRITE(dev, FCINTENSET,
 		  SSS_FCINTENSET_BTDMAINTENSET | SSS_FCINTENSET_BRDMAINTENSET);
 
-	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock);
 
 	return;
 
@@ -658,7 +657,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 indata_error:
 	s5p_sg_done(dev);
 	dev->busy = false;
-	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock);
 	s5p_aes_complete(dev, err);
 }
 
@@ -667,18 +666,17 @@ static void s5p_tasklet_cb(unsigned long data)
 	struct s5p_aes_dev *dev = (struct s5p_aes_dev *)data;
 	struct crypto_async_request *async_req, *backlog;
 	struct s5p_aes_reqctx *reqctx;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	mutex_lock(&dev->lock);
 	backlog   = crypto_get_backlog(&dev->queue);
 	async_req = crypto_dequeue_request(&dev->queue);
 
 	if (!async_req) {
 		dev->busy = false;
-		spin_unlock_irqrestore(&dev->lock, flags);
+		mutex_unlock(&dev->lock);
 		return;
 	}
-	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock);
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -693,18 +691,17 @@ static void s5p_tasklet_cb(unsigned long data)
 static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 			      struct ablkcipher_request *req)
 {
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	mutex_lock(&dev->lock);
 	err = ablkcipher_enqueue_request(&dev->queue, req);
 	if (dev->busy) {
-		spin_unlock_irqrestore(&dev->lock, flags);
+		mutex_unlock(&dev->lock);
 		goto exit;
 	}
 	dev->busy = true;
 
-	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock);
 
 	tasklet_schedule(&dev->tasklet);
 
@@ -856,7 +853,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	spin_lock_init(&pdata->lock);
+	mutex_init(&pdata->lock);
 
 	pdata->aes_ioaddr = pdata->ioaddr + variant->aes_offset;
 
-- 
2.9.3
