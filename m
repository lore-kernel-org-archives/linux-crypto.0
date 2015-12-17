From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 19/24] crypto: atmel-aes: create sections to regroup functions by usage
Date: Thu, 17 Dec 2015 18:13:03 +0100
Message-ID: <757be55c418001e327ade19668523e9618a4a4be.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58742 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbbLQRNl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 12:13:41 -0500
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch only creates sections to regroup functions by usage.
This will help to integrate the GCM support patch later by making the
difference between shared/common and specific code. Hence current
sections are:

- Shared functions: common code which will be reused by the GCM support.
- CPU transfer: handles transfers monitored by the CPU (PIO accesses).
- DMA transfer: handles transfers monitored by the DMA controller.
- AES async block ciphers: dedicated to the already supported block ciphers
- Probe functions: used to register all crypto algorithms.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 210 +++++++++++++++++++++++----------------------
 1 file changed, 108 insertions(+), 102 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 208fa8dce7f7..e964cb03cca5 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -166,6 +166,7 @@ static struct atmel_aes_drv atmel_aes = {
 	.lock = __SPIN_LOCK_UNLOCKED(atmel_aes.lock),
 };
 
+/* Shared functions */
 
 static inline u32 atmel_aes_read(struct atmel_aes_dev *dd, u32 offset)
 {
@@ -302,6 +303,38 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	return err;
 }
 
+static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
+				 const u32 *iv)
+{
+	u32 valmr = 0;
+
+	/* MR register must be set before IV registers */
+	if (dd->ctx->keylen == AES_KEYSIZE_128)
+		valmr |= AES_MR_KEYSIZE_128;
+	else if (dd->ctx->keylen == AES_KEYSIZE_192)
+		valmr |= AES_MR_KEYSIZE_192;
+	else
+		valmr |= AES_MR_KEYSIZE_256;
+
+	valmr |= dd->flags & AES_FLAGS_MODE_MASK;
+
+	if (use_dma) {
+		valmr |= AES_MR_SMOD_IDATAR0;
+		if (dd->caps.has_dualbuff)
+			valmr |= AES_MR_DUALBUFF;
+	} else {
+		valmr |= AES_MR_SMOD_AUTO;
+	}
+
+	atmel_aes_write(dd, AES_MR, valmr);
+
+	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
+			  SIZE_IN_WORDS(dd->ctx->keylen));
+
+	if (iv && (valmr & AES_MR_OPMOD_MASK) != AES_MR_OPMOD_ECB)
+		atmel_aes_write_block(dd, AES_IVR(0), iv);
+}
+
 
 /* CPU transfer */
 
@@ -661,38 +694,6 @@ static void atmel_aes_dma_callback(void *data)
 	(void)dd->resume(dd);
 }
 
-static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
-				 const u32 *iv)
-{
-	u32 valmr = 0;
-
-	/* MR register must be set before IV registers */
-	if (dd->ctx->keylen == AES_KEYSIZE_128)
-		valmr |= AES_MR_KEYSIZE_128;
-	else if (dd->ctx->keylen == AES_KEYSIZE_192)
-		valmr |= AES_MR_KEYSIZE_192;
-	else
-		valmr |= AES_MR_KEYSIZE_256;
-
-	valmr |= dd->flags & AES_FLAGS_MODE_MASK;
-
-	if (use_dma) {
-		valmr |= AES_MR_SMOD_IDATAR0;
-		if (dd->caps.has_dualbuff)
-			valmr |= AES_MR_DUALBUFF;
-	} else {
-		valmr |= AES_MR_SMOD_AUTO;
-	}
-
-	atmel_aes_write(dd, AES_MR, valmr);
-
-	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
-			  SIZE_IN_WORDS(dd->ctx->keylen));
-
-	if (iv && (valmr & AES_MR_OPMOD_MASK) != AES_MR_OPMOD_ECB)
-		atmel_aes_write_block(dd, AES_IVR(0), iv);
-}
-
 static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 				  struct crypto_async_request *new_areq)
 {
@@ -730,6 +731,9 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	return (dd->is_async) ? ret : err;
 }
 
+
+/* AES async block ciphers */
+
 static int atmel_aes_transfer_complete(struct atmel_aes_dev *dd)
 {
 	return atmel_aes_complete(dd, 0);
@@ -758,26 +762,6 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 				   atmel_aes_transfer_complete);
 }
 
-
-static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
-{
-	dd->buf = (void *)__get_free_pages(GFP_KERNEL, ATMEL_AES_BUFFER_ORDER);
-	dd->buflen = ATMEL_AES_BUFFER_SIZE;
-	dd->buflen &= ~(AES_BLOCK_SIZE - 1);
-
-	if (!dd->buf) {
-		dev_err(dd->dev, "unable to alloc pages.\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
-{
-	free_page((unsigned long)dd->buf);
-}
-
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
 	struct atmel_aes_base_ctx *ctx;
@@ -817,56 +801,6 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	return atmel_aes_handle_queue(dd, &req->base);
 }
 
-static bool atmel_aes_filter(struct dma_chan *chan, void *slave)
-{
-	struct at_dma_slave	*sl = slave;
-
-	if (sl && sl->dma_dev == chan->device->dev) {
-		chan->private = sl;
-		return true;
-	} else {
-		return false;
-	}
-}
-
-static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
-			      struct crypto_platform_data *pdata)
-{
-	struct at_dma_slave *slave;
-	int err = -ENOMEM;
-	dma_cap_mask_t mask;
-
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
-	/* Try to grab 2 DMA channels */
-	slave = &pdata->dma_slave->rxdata;
-	dd->src.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
-							slave, dd->dev, "tx");
-	if (!dd->src.chan)
-		goto err_dma_in;
-
-	slave = &pdata->dma_slave->txdata;
-	dd->dst.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
-							slave, dd->dev, "rx");
-	if (!dd->dst.chan)
-		goto err_dma_out;
-
-	return 0;
-
-err_dma_out:
-	dma_release_channel(dd->src.chan);
-err_dma_in:
-	dev_warn(dd->dev, "no DMA channel available\n");
-	return err;
-}
-
-static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
-{
-	dma_release_channel(dd->dst.chan);
-	dma_release_channel(dd->src.chan);
-}
-
 static int atmel_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
@@ -1181,6 +1115,78 @@ static struct crypto_alg aes_cfb64_alg = {
 	}
 };
 
+
+/* Probe functions */
+
+static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
+{
+	dd->buf = (void *)__get_free_pages(GFP_KERNEL, ATMEL_AES_BUFFER_ORDER);
+	dd->buflen = ATMEL_AES_BUFFER_SIZE;
+	dd->buflen &= ~(AES_BLOCK_SIZE - 1);
+
+	if (!dd->buf) {
+		dev_err(dd->dev, "unable to alloc pages.\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
+{
+	free_page((unsigned long)dd->buf);
+}
+
+static bool atmel_aes_filter(struct dma_chan *chan, void *slave)
+{
+	struct at_dma_slave	*sl = slave;
+
+	if (sl && sl->dma_dev == chan->device->dev) {
+		chan->private = sl;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
+			      struct crypto_platform_data *pdata)
+{
+	struct at_dma_slave *slave;
+	int err = -ENOMEM;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	/* Try to grab 2 DMA channels */
+	slave = &pdata->dma_slave->rxdata;
+	dd->src.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
+							slave, dd->dev, "tx");
+	if (!dd->src.chan)
+		goto err_dma_in;
+
+	slave = &pdata->dma_slave->txdata;
+	dd->dst.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
+							slave, dd->dev, "rx");
+	if (!dd->dst.chan)
+		goto err_dma_out;
+
+	return 0;
+
+err_dma_out:
+	dma_release_channel(dd->src.chan);
+err_dma_in:
+	dev_warn(dd->dev, "no DMA channel available\n");
+	return err;
+}
+
+static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
+{
+	dma_release_channel(dd->dst.chan);
+	dma_release_channel(dd->src.chan);
+}
+
 static void atmel_aes_queue_task(unsigned long data)
 {
 	struct atmel_aes_dev *dd = (struct atmel_aes_dev *)data;
-- 
1.8.2.2
