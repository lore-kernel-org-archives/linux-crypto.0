From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 03/12] crypto: atmel-sha: make atmel_sha_done_task more
 generic
Date: Thu, 26 Jan 2017 17:07:48 +0100
Message-ID: <5989b03be520fc8e0f420fde675ced47ba0d33dc.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
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
