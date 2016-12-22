From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2 03/12] crypto: atmel-sha: make atmel_sha_done_task more generic
Date: Thu, 22 Dec 2016 17:37:52 +0100
Message-ID: <ab60d2a275a0ee7c544325c63e8d51444e887804.1482424395.git.cyrille.pitchen@atmel.com>
References: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch is a transitional patch. It updates atmel_sha_done_task() to
make it more generic. Indeed, it adds a new .resume() member in the
atmel_sha_dev structure. This hook is called from atmel_sha_done_task()
to resume processing an asynchronous request.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 2dbed8bb8d26..643d79a05dda 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -138,6 +138,7 @@ struct atmel_sha_dev {
 	struct crypto_queue	queue;
 	struct ahash_request	*req;
 	bool			is_async;
+	atmel_sha_fn_t		resume;
 
 	struct atmel_sha_dma	dma_lch_in;
 
@@ -946,6 +947,8 @@ static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 	return (start_async) ? ret : err;
 }
 
+static int atmel_sha_done(struct atmel_sha_dev *dd);
+
 static int atmel_sha_start(struct atmel_sha_dev *dd)
 {
 	struct ahash_request *req = dd->req;
@@ -960,6 +963,7 @@ static int atmel_sha_start(struct atmel_sha_dev *dd)
 	if (err)
 		goto err1;
 
+	dd->resume = atmel_sha_done;
 	if (ctx->op == SHA_OP_UPDATE) {
 		err = atmel_sha_update_req(dd);
 		if (err != -EINPROGRESS && (ctx->flags & SHA_FLAGS_FINUP))
@@ -1215,13 +1219,10 @@ static void atmel_sha_queue_task(unsigned long data)
 	atmel_sha_handle_queue(dd, NULL);
 }
 
-static void atmel_sha_done_task(unsigned long data)
+static int atmel_sha_done(struct atmel_sha_dev *dd)
 {
-	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
 	int err = 0;
 
-	dd->is_async = true;
-
 	if (SHA_FLAGS_CPU & dd->flags) {
 		if (SHA_FLAGS_OUTPUT_READY & dd->flags) {
 			dd->flags &= ~SHA_FLAGS_OUTPUT_READY;
@@ -1245,11 +1246,21 @@ static void atmel_sha_done_task(unsigned long data)
 				goto finish;
 		}
 	}
-	return;
+	return err;
 
 finish:
 	/* finish curent request */
 	atmel_sha_finish_req(dd->req, err);
+
+	return err;
+}
+
+static void atmel_sha_done_task(unsigned long data)
+{
+	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
+
+	dd->is_async = true;
+	(void)dd->resume(dd);
 }
 
 static irqreturn_t atmel_sha_irq(int irq, void *dev_id)
-- 
2.7.4
