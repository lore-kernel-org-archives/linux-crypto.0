From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 02/11] crypto: omap-sham: add support for flushing the buffer
Date: Thu, 4 Aug 2016 13:28:37 +0300
Message-ID: <1470306526-27219-3-git-send-email-t-kristo@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>, <davem@davemloft.net>,
 <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
 <linux-omap@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
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

This flushes any full blocks of data from the data buffer. Required for
implementing the export/import APIs for the driver, as the flush allows
saving a much smaller context; basically only one block of buffer is
required.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 60 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index fd50005..6e53944 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -112,6 +112,7 @@
 #define FLAGS_DMA_READY		6
 #define FLAGS_AUTO_XOR		7
 #define FLAGS_BE32_SHA1		8
+#define FLAGS_FLUSH		9
 /* context flags */
 #define FLAGS_FINUP		16
 #define FLAGS_SG		17
@@ -996,15 +997,16 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 		ctx->flags |= BIT(FLAGS_ERROR);
 	}
 
-	/* atomic operation is not needed here */
-	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
-			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
-
 	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
 
-	if (req->base.complete)
+	if (!test_bit(FLAGS_FLUSH, &dd->flags) && req->base.complete)
 		req->base.complete(&req->base, err);
+
+	/* atomic operation is not needed here */
+	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
+		       BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY) |
+		       BIT(FLAGS_FLUSH));
 }
 
 static int omap_sham_handle_queue(struct omap_sham_dev *dd,
@@ -1329,6 +1331,54 @@ static void omap_sham_cra_exit(struct crypto_tfm *tfm)
 	}
 }
 
+static int omap_sham_flush(struct ahash_request *req)
+{
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+	struct omap_sham_dev *dd = rctx->dd;
+	int ret, len, bs;
+	unsigned long flags;
+
+	bs = get_block_size(rctx);
+
+	len = rctx->bufcnt / bs * bs;
+
+	spin_lock_irqsave(&dd->lock, flags);
+
+	if (test_bit(FLAGS_BUSY, &dd->flags)) {
+		ret = -EINPROGRESS;
+		goto exit_unlock;
+	}
+
+	if (!len) {
+		ret = 0;
+		goto exit_unlock;
+	}
+
+	set_bit(FLAGS_BUSY, &dd->flags);
+
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	rctx->total = 0;
+
+	ret = omap_sham_hw_init(dd);
+	if (ret)
+		goto exit_unlock;
+
+	set_bit(FLAGS_FLUSH, &dd->flags);
+
+	ret = omap_sham_xmit_cpu(dd, rctx->buffer, len, 0);
+	if (ret == -EINPROGRESS) {
+		memcpy(rctx->buffer, rctx->buffer + len, rctx->bufcnt - len);
+		rctx->bufcnt -= len;
+	}
+
+	return ret;
+
+exit_unlock:
+	spin_unlock_irqrestore(&dd->lock, flags);
+	return ret;
+}
+
 static struct ahash_alg algs_sha1_md5[] = {
 {
 	.init		= omap_sham_init,
-- 
1.9.1
