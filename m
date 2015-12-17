From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 11/24] crypto: atmel-aes: rework crypto request completion
Date: Thu, 17 Dec 2015 17:48:42 +0100
Message-ID: <1237ced97e6c1b8f676c8e8d68899a503a35f260.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch introduces a new callback 'resume' in the struct atmel_aes_dev.
This callback is run to resume/complete the processing of the crypto
request when woken up by I/O events such as AES interrupts or DMA
completion.

This callback will help implementing the GCM mode support in further
patches.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 74 +++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index c10c54ccc606..ac551ee2d624 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -119,6 +119,9 @@ struct atmel_aes_dev {
 	struct crypto_async_request	*areq;
 	struct atmel_aes_base_ctx	*ctx;
 
+	bool			is_async;
+	atmel_aes_fn_t		resume;
+
 	struct device		*dev;
 	struct clk		*iclk;
 	int	irq;
@@ -319,14 +322,17 @@ static inline void atmel_aes_set_mode(struct atmel_aes_dev *dd,
 	dd->flags = (dd->flags & AES_FLAGS_PERSISTENT) | rctx->mode;
 }
 
-static void atmel_aes_finish_req(struct atmel_aes_dev *dd, int err)
+static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
-
 	clk_disable_unprepare(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
-	req->base.complete(&req->base, err);
+	if (dd->is_async)
+		dd->areq->complete(dd->areq, err);
+
+	tasklet_schedule(&dd->queue_task);
+
+	return err;
 }
 
 static void atmel_aes_dma_callback(void *data)
@@ -423,6 +429,8 @@ static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
 	return 0;
 }
 
+static int atmel_aes_cpu_complete(struct atmel_aes_dev *dd);
+
 static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
@@ -455,9 +463,12 @@ static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 	atmel_aes_write_n(dd, AES_IDATAR(0), (u32 *) dd->buf_in,
 				dd->bufcnt >> 2);
 
-	return 0;
+	dd->resume = atmel_aes_cpu_complete;
+	return -EINPROGRESS;
 }
 
+static int atmel_aes_dma_complete(struct atmel_aes_dev *dd);
+
 static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 {
 	int err, fast = 0, in, out;
@@ -524,7 +535,8 @@ static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
 	}
 
-	return err;
+	dd->resume = atmel_aes_dma_complete;
+	return err ? : -EINPROGRESS;
 }
 
 static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
@@ -590,9 +602,10 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 
 	dd->areq = areq;
 	dd->ctx = ctx;
+	dd->is_async = (areq != new_areq);
 
 	err = ctx->start(dd);
-	return (areq != new_areq) ? ret : err;
+	return (dd->is_async) ? ret : err;
 }
 
 static int atmel_aes_start(struct atmel_aes_dev *dd)
@@ -621,10 +634,9 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 		else
 			err = atmel_aes_crypt_cpu_start(dd);
 	}
-	if (err) {
+	if (err && err != -EINPROGRESS) {
 		/* aes_task will not finish it, so do it here */
-		atmel_aes_finish_req(dd, err);
-		tasklet_schedule(&dd->queue_task);
+		return atmel_aes_complete(dd, err);
 	}
 
 	return -EINPROGRESS;
@@ -1149,20 +1161,14 @@ static void atmel_aes_queue_task(unsigned long data)
 static void atmel_aes_done_task(unsigned long data)
 {
 	struct atmel_aes_dev *dd = (struct atmel_aes_dev *) data;
-	int err;
-
-	if (!(dd->flags & AES_FLAGS_DMA)) {
-		atmel_aes_read_n(dd, AES_ODATAR(0), (u32 *) dd->buf_out,
-				dd->bufcnt >> 2);
 
-		if (sg_copy_from_buffer(dd->out_sg, dd->nb_out_sg,
-			dd->buf_out, dd->bufcnt))
-			err = 0;
-		else
-			err = -EINVAL;
+	dd->is_async = true;
+	(void)dd->resume(dd);
+}
 
-		goto cpu_end;
-	}
+static int atmel_aes_dma_complete(struct atmel_aes_dev *dd)
+{
+	int err;
 
 	err = atmel_aes_crypt_dma_stop(dd);
 
@@ -1177,13 +1183,27 @@ static void atmel_aes_done_task(unsigned long data)
 		}
 		if (!err)
 			err = atmel_aes_crypt_dma_start(dd);
-		if (!err)
-			return; /* DMA started. Not fininishing. */
+		if (!err || err == -EINPROGRESS)
+			return -EINPROGRESS; /* DMA started. Not fininishing. */
 	}
 
-cpu_end:
-	atmel_aes_finish_req(dd, err);
-	atmel_aes_handle_queue(dd, NULL);
+	return atmel_aes_complete(dd, err);
+}
+
+static int atmel_aes_cpu_complete(struct atmel_aes_dev *dd)
+{
+	int err;
+
+	atmel_aes_read_n(dd, AES_ODATAR(0), (u32 *) dd->buf_out,
+			 dd->bufcnt >> 2);
+
+	if (sg_copy_from_buffer(dd->out_sg, dd->nb_out_sg,
+				dd->buf_out, dd->bufcnt))
+		err = 0;
+	else
+		err = -EINVAL;
+
+	return atmel_aes_complete(dd, err);
 }
 
 static irqreturn_t atmel_aes_irq(int irq, void *dev_id)
-- 
1.8.2.2
