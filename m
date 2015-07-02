From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 09/10] crypto: omap-aes: gcm: Add support for PIO mode
Date: Thu, 2 Jul 2015 10:48:39 +0530
Message-ID: <1435814320-30347-10-git-send-email-lokeshvutla@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35933 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbGBFWJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 01:22:09 -0400
In-Reply-To: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for PIO mode for GCM mode.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes-gcm.c |   10 ++++++----
 drivers/crypto/omap-aes.c     |   24 ++++++++++++++++++------
 drivers/crypto/omap-aes.h     |    3 ++-
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 9c68ff0..370891b 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -52,8 +52,8 @@ static void omap_aes_gcm_done_task(struct omap_aes_dev *dd)
 	u8 *tag;
 	int pages, alen, clen, i, ret = 0, nsg;
 
-	alen = ALIGN(dd->assoc_len, AES_BLOCK_SIZE);
-	clen = ALIGN(dd->total, AES_BLOCK_SIZE);
+	alen = ALIGN(dd->assoc_len_save, AES_BLOCK_SIZE);
+	clen = ALIGN(dd->total_save, AES_BLOCK_SIZE);
 
 	nsg = 1 + !!(dd->assoc_len && dd->total);
 
@@ -161,7 +161,9 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 
 	dd->in_sg = dd->in_sgl;
 	dd->total = cryptlen;
+	dd->total_save = cryptlen;
 	dd->assoc_len = req->assoclen;
+	dd->assoc_len_save = req->assoclen;
 	dd->authsize = authlen;
 
 	if (omap_aes_check_aligned(req->dst, cryptlen)) {
@@ -248,14 +250,14 @@ static int do_encrypt_iv(struct aead_request *req, u32 *tag)
 	return ret;
 }
 
-void omap_aes_gcm_dma_out_callback(void *data)
+void omap_aes_gcm_process_auth_tag(void *data)
 {
 	struct omap_aes_dev *dd = data;
 	int i, val;
 	u32 *auth_tag, tag[4];
 
 	if (!(dd->flags & FLAGS_ENCRYPT))
-		scatterwalk_map_and_copy(tag, dd->aead_req->src, dd->total,
+		scatterwalk_map_and_copy(tag, dd->aead_req->src, dd->total_save,
 					 dd->authsize, 0);
 
 	auth_tag = dd->ctx->auth_tag;
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 11f3850..8aeb913 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -340,7 +340,7 @@ static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
 	}
 
 	if (dd->flags & FLAGS_GCM)
-		tx_out->callback = omap_aes_gcm_dma_out_callback;
+		tx_out->callback = omap_aes_gcm_process_auth_tag;
 	else
 		tx_out->callback = omap_aes_dma_out_callback;
 	tx_out->callback_param = dd;
@@ -927,8 +927,15 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 		status &= ~AES_REG_IRQ_DATA_IN;
 		omap_aes_write(dd, AES_REG_IRQ_STATUS(dd), status);
 
-		/* Enable DATA_OUT interrupt */
-		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x4);
+		/*
+		 * if GCM mode enable DATA_IN till assoc data is copied
+		 * else Enable DATA_OUT interrupt
+		 * */
+		if ((dd->flags & FLAGS_GCM) && dd->assoc_len)
+			dd->assoc_len -= min((size_t)AES_BLOCK_SIZE,
+					     dd->assoc_len);
+		else
+			omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x4);
 
 	} else if (status & AES_REG_IRQ_DATA_OUT) {
 		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x0);
@@ -961,12 +968,17 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 		status &= ~AES_REG_IRQ_DATA_OUT;
 		omap_aes_write(dd, AES_REG_IRQ_STATUS(dd), status);
 
-		if (!dd->total)
+		if (!dd->total) {
 			/* All bytes read! */
-			tasklet_schedule(&dd->done_task);
-		else
+			if (dd->flags & FLAGS_GCM)
+				/* Process auth tag and call done_task */
+				omap_aes_gcm_process_auth_tag(dd);
+			else
+				tasklet_schedule(&dd->done_task);
+		} else {
 			/* Enable DATA_IN interrupt for next block */
 			omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x2);
+		}
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index 0863874..e0621dd 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -164,6 +164,7 @@ struct omap_aes_dev {
 	size_t				total;
 	size_t				total_save;
 	size_t				assoc_len;
+	size_t				assoc_len_save;
 	size_t				authsize;
 
 	struct scatterlist		*in_sg;
@@ -199,7 +200,7 @@ int omap_aes_gcm_decrypt(struct aead_request *req);
 int omap_aes_write_ctrl(struct omap_aes_dev *dd);
 int omap_aes_check_aligned(struct scatterlist *sg, int total);
 int omap_aes_crypt_dma_start(struct omap_aes_dev *dd);
-void omap_aes_gcm_dma_out_callback(void *data);
+void omap_aes_gcm_process_auth_tag(void *data);
 int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd);
 
 #endif
-- 
1.7.9.5
