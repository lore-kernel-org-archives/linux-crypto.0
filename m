From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2 1/7] crypto: omap-aes: Fix CTR mode
Date: Tue, 7 Jul 2015 21:01:43 +0530
Message-ID: <1436283109-13318-2-git-send-email-lokeshvutla@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36812 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbbGGPew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 11:34:52 -0400
In-Reply-To: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Algo self tests are failing for CTR mode with omap-aes driver,
giving the following error:

[  150.053644]       omap_aes_crypt: request size is not exact amount of AES blocks
[  150.061262] alg: skcipher: encryption failed on test 5 for ctr-aes-omap: ret=22

This is because the input length is not aligned with AES_BLOCK_SIZE.
Adding support for omap-aes driver for inputs with length not aligned
with AES_BLOCK_SIZE.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9a28b7e..4a0e808 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -558,6 +558,9 @@ static int omap_aes_check_aligned(struct scatterlist *sg, int total)
 {
 	int len = 0;
 
+	if (!IS_ALIGNED(total, AES_BLOCK_SIZE))
+		return -EINVAL;
+
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, 4))
 			return -1;
@@ -577,9 +580,10 @@ static int omap_aes_check_aligned(struct scatterlist *sg, int total)
 static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
 {
 	void *buf_in, *buf_out;
-	int pages;
+	int pages, total;
 
-	pages = get_order(dd->total);
+	total = ALIGN(dd->total, AES_BLOCK_SIZE);
+	pages = get_order(total);
 
 	buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
 	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
@@ -594,11 +598,11 @@ static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
 	sg_copy_buf(buf_in, dd->in_sg, 0, dd->total, 0);
 
 	sg_init_table(&dd->in_sgl, 1);
-	sg_set_buf(&dd->in_sgl, buf_in, dd->total);
+	sg_set_buf(&dd->in_sgl, buf_in, total);
 	dd->in_sg = &dd->in_sgl;
 
 	sg_init_table(&dd->out_sgl, 1);
-	sg_set_buf(&dd->out_sgl, buf_out, dd->total);
+	sg_set_buf(&dd->out_sgl, buf_out, total);
 	dd->out_sg = &dd->out_sgl;
 
 	return 0;
@@ -611,7 +615,7 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	struct omap_aes_ctx *ctx;
 	struct omap_aes_reqctx *rctx;
 	unsigned long flags;
-	int err, ret = 0;
+	int err, ret = 0, len;
 
 	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
@@ -650,8 +654,9 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 		dd->sgs_copied = 0;
 	}
 
-	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, dd->total);
-	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, dd->total);
+	len = ALIGN(dd->total, AES_BLOCK_SIZE);
+	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, len);
+	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, len);
 	BUG_ON(dd->in_sg_len < 0 || dd->out_sg_len < 0);
 
 	rctx = ablkcipher_request_ctx(req);
@@ -678,7 +683,7 @@ static void omap_aes_done_task(unsigned long data)
 {
 	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
 	void *buf_in, *buf_out;
-	int pages;
+	int pages, len;
 
 	pr_debug("enter done_task\n");
 
@@ -697,7 +702,8 @@ static void omap_aes_done_task(unsigned long data)
 
 		sg_copy_buf(buf_out, dd->orig_out, 0, dd->total_save, 1);
 
-		pages = get_order(dd->total_save);
+		len = ALIGN(dd->total_save, AES_BLOCK_SIZE);
+		pages = get_order(len);
 		free_pages((unsigned long)buf_in, pages);
 		free_pages((unsigned long)buf_out, pages);
 	}
@@ -726,11 +732,6 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		  !!(mode & FLAGS_ENCRYPT),
 		  !!(mode & FLAGS_CBC));
 
-	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
-		pr_err("request size is not exact amount of AES blocks\n");
-		return -EINVAL;
-	}
-
 	dd = omap_aes_find_dev(ctx);
 	if (!dd)
 		return -ENODEV;
@@ -1046,9 +1047,7 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 			}
 		}
 
-		dd->total -= AES_BLOCK_SIZE;
-
-		BUG_ON(dd->total < 0);
+		dd->total -= min_t(size_t, AES_BLOCK_SIZE, dd->total);
 
 		/* Clear IRQ status */
 		status &= ~AES_REG_IRQ_DATA_OUT;
-- 
1.9.1
