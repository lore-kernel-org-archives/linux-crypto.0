From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 9/9 v5] crypto:s5p-sss: Look for the next request in the queue
Date: Wed, 29 Jan 2014 14:57:01 +0530
Message-ID: <1390987621-19019-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, devicetree@vger.kernel.org,
	Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

Currently, the driver enqueues a request only if the busy bit is
false. And every request initiates a dequeue. If 2 requests arrive
simultaneously, only one of them will be dequeued.

To avoid this senario, we will enqueue the next request irrespective
of the system condition (that is what queue is here for). Also
schedule at a tasklet immediatly after the current request is done.
The tasklet will dequeue the next request in the queue, giving
continuous loop. tasklet will exit if there are no requests in the
queue.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
---
This is a new fix in this patchset, tested with dm-crypt/ecryptfs

 drivers/crypto/s5p-sss.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 5bd3bd9..d37cbfc 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -330,8 +330,12 @@ static void s5p_aes_tx(struct s5p_aes_dev *dev)
 		}
 
 		s5p_set_dma_outdata(dev, dev->sg_dst);
-	} else
+	} else {
 		s5p_aes_complete(dev, err);
+
+		dev->busy = true;
+		tasklet_schedule(&dev->tasklet);
+	}
 }
 
 static void s5p_aes_rx(struct s5p_aes_dev *dev)
@@ -469,10 +473,13 @@ static void s5p_tasklet_cb(unsigned long data)
 	spin_lock_irqsave(&dev->lock, flags);
 	backlog   = crypto_get_backlog(&dev->queue);
 	async_req = crypto_dequeue_request(&dev->queue);
-	spin_unlock_irqrestore(&dev->lock, flags);
 
-	if (!async_req)
+	if (!async_req) {
+		dev->busy = false;
+		spin_unlock_irqrestore(&dev->lock, flags);
 		return;
+	}
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -491,14 +498,13 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 	int err;
 
 	spin_lock_irqsave(&dev->lock, flags);
+	err = ablkcipher_enqueue_request(&dev->queue, req);
 	if (dev->busy) {
-		err = -EAGAIN;
 		spin_unlock_irqrestore(&dev->lock, flags);
 		goto exit;
 	}
 	dev->busy = true;
 
-	err = ablkcipher_enqueue_request(&dev->queue, req);
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	tasklet_schedule(&dev->tasklet);
@@ -688,6 +694,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		}
 	}
 
+	pdata->busy = false;
 	pdata->variant = variant;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
-- 
1.7.9.5
