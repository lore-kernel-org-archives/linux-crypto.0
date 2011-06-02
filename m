From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 08/11] omap-sham: irq and dma handling changes
Date: Thu,  2 Jun 2011 21:10:10 +0300
Message-ID: <78103fe2a0299012ae1ea846b930c4bc35df6d86.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58398 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1FBSKl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2011 14:10:41 -0400
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

It could be a situation, that tasklet is executed twice because of
certain delay between dma callback and irq handler execution.
In that case, second tasklet execution could actually corrupt the data
of the new started dma transactions.

This patch improves tasklet logic and prevents above described cases.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 24de4ace..a8de7b8 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -79,6 +79,7 @@
 #define FLAGS_OUTPUT_READY	3
 #define FLAGS_INIT		4
 #define FLAGS_CPU		5
+#define FLAGS_DMA_READY		6
 /* context flags */
 #define FLAGS_FINUP		16
 #define FLAGS_SG		17
@@ -304,6 +305,8 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 	if (final)
 		set_bit(FLAGS_FINAL, &dd->flags); /* catch last interrupt */
 
+	set_bit(FLAGS_CPU, &dd->flags);
+
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
 	for (count = 0; count < len32; count++)
@@ -1033,29 +1036,39 @@ static struct ahash_alg algs[] = {
 static void omap_sham_done_task(unsigned long data)
 {
 	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
-	int ready = 0, err = 0;
+	int err = 0;
 
 	if (!test_bit(FLAGS_BUSY, &dd->flags)) {
 		omap_sham_handle_queue(dd, NULL);
 		return;
 	}
 
-	if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
-		ready = 1;
-
-	if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
-		omap_sham_update_dma_stop(dd);
-		if (!dd->err)
+	if (test_bit(FLAGS_CPU, &dd->flags)) {
+		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
+			goto finish;
+	} else if (test_bit(FLAGS_DMA_READY, &dd->flags)) {
+		if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
+			omap_sham_update_dma_stop(dd);
+			if (dd->err) {
+				err = dd->err;
+				goto finish;
+			}
+		}
+		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags)) {
+			/* hash or semi-hash ready */
+			clear_bit(FLAGS_DMA_READY, &dd->flags);
 			err = omap_sham_update_dma_start(dd);
+			if (err != -EINPROGRESS)
+				goto finish;
+		}
 	}
 
-	err = dd->err ? : err;
+	return;
 
-	if (err != -EINPROGRESS && (ready || err)) {
-		dev_dbg(dd->dev, "update done: err: %d\n", err);
-		/* finish curent request */
-		omap_sham_finish_req(dd->req, err);
-	}
+finish:
+	dev_dbg(dd->dev, "update done: err: %d\n", err);
+	/* finish curent request */
+	omap_sham_finish_req(dd->req, err);
 }
 
 static irqreturn_t omap_sham_irq(int irq, void *dev_id)
@@ -1087,6 +1100,7 @@ static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
 		clear_bit(FLAGS_INIT, &dd->flags);/* request to re-initialize */
 	}
 
+	set_bit(FLAGS_DMA_READY, &dd->flags);
 	tasklet_schedule(&dd->done_task);
 }
 
-- 
1.7.4.1
