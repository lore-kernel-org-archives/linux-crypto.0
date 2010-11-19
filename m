From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 4/8] omap-sham: removed redundunt locking
Date: Fri, 19 Nov 2010 16:04:25 +0200
Message-ID: <53d610dbd84e3d333c485162a33eb5799c8997e6.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:58023 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0KSOD5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Nov 2010 09:03:57 -0500
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Locking for queuing and dequeuing is combined.
test_and_set_bit() is also replaced with checking under dd->lock.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   47 +++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index db20628..6340c5e 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -84,9 +84,7 @@
 #define FLAGS_CPU		0x0200
 #define FLAGS_HMAC		0x0400
 #define FLAGS_ERROR		0x0800
-
-/* 3rd byte */
-#define FLAGS_BUSY		16
+#define FLAGS_BUSY		0x1000
 
 #define OP_UPDATE	1
 #define OP_FINAL	2
@@ -629,32 +627,37 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	if ((ctx->flags & FLAGS_FINAL) || err)
 		omap_sham_cleanup(req);
 
-	clear_bit(FLAGS_BUSY, &ctx->dd->flags);
+	ctx->dd->flags &= ~FLAGS_BUSY;
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
 }
 
-static int omap_sham_handle_queue(struct omap_sham_dev *dd)
+static int omap_sham_handle_queue(struct omap_sham_dev *dd,
+				  struct ahash_request *req)
 {
 	struct crypto_async_request *async_req, *backlog;
 	struct omap_sham_reqctx *ctx;
-	struct ahash_request *req, *prev_req;
+	struct ahash_request *prev_req;
 	unsigned long flags;
-	int err = 0;
-
-	if (test_and_set_bit(FLAGS_BUSY, &dd->flags))
-		return 0;
+	int err = 0, ret = 0;
 
 	spin_lock_irqsave(&dd->lock, flags);
-	backlog = crypto_get_backlog(&dd->queue);
+	if (req)
+		ret = ahash_enqueue_request(&dd->queue, req);
+	if (dd->flags & FLAGS_BUSY) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		return ret;
+	}
 	async_req = crypto_dequeue_request(&dd->queue);
-	if (!async_req)
-		clear_bit(FLAGS_BUSY, &dd->flags);
+	if (async_req) {
+		dd->flags |= FLAGS_BUSY;
+		backlog = crypto_get_backlog(&dd->queue);
+	}
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
-		return 0;
+		return ret;
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -690,7 +693,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd)
 
 	dev_dbg(dd->dev, "exit, err: %d\n", err);
 
-	return err;
+	return ret;
 }
 
 static int omap_sham_enqueue(struct ahash_request *req, unsigned int op)
@@ -698,18 +701,10 @@ static int omap_sham_enqueue(struct ahash_request *req, unsigned int op)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	struct omap_sham_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
 	struct omap_sham_dev *dd = tctx->dd;
-	unsigned long flags;
-	int err;
 
 	ctx->op = op;
 
-	spin_lock_irqsave(&dd->lock, flags);
-	err = ahash_enqueue_request(&dd->queue, req);
-	spin_unlock_irqrestore(&dd->lock, flags);
-
-	omap_sham_handle_queue(dd);
-
-	return err;
+	return omap_sham_handle_queue(dd, req);
 }
 
 static int omap_sham_update(struct ahash_request *req)
@@ -1041,7 +1036,7 @@ static void omap_sham_done_task(unsigned long data)
 		/* finish curent request */
 		omap_sham_finish_req(req, err);
 		/* start new request */
-		omap_sham_handle_queue(dd);
+		omap_sham_handle_queue(dd, NULL);
 	}
 }
 
@@ -1049,7 +1044,7 @@ static void omap_sham_queue_task(unsigned long data)
 {
 	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
 
-	omap_sham_handle_queue(dd);
+	omap_sham_handle_queue(dd, NULL);
 }
 
 static irqreturn_t omap_sham_irq(int irq, void *dev_id)
-- 
1.7.0.4
