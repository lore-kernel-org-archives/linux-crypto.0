From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 01/11] crypto: omap-sham: avoid executing tasklet where not
 needed
Date: Thu, 4 Aug 2016 13:28:36 +0300
Message-ID: <1470306526-27219-2-git-send-email-t-kristo@ti.com>
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

Some of the call paths of OMAP SHA driver can avoid executing the next
step of the crypto queue under tasklet; instead, execute the next step
directly via function call. This avoids a costly round-trip via the
scheduler giving a slight performance boost.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 7fe4eef..fd50005 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1005,9 +1005,6 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
-
-	/* handle new request */
-	tasklet_schedule(&dd->done_task);
 }
 
 static int omap_sham_handle_queue(struct omap_sham_dev *dd,
@@ -1018,6 +1015,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	unsigned long flags;
 	int err = 0, ret = 0;
 
+retry:
 	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
 		ret = ahash_enqueue_request(&dd->queue, req);
@@ -1061,11 +1059,19 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 		err = omap_sham_final_req(dd);
 	}
 err1:
-	if (err != -EINPROGRESS)
+	dev_dbg(dd->dev, "exit, err: %d\n", err);
+
+	if (err != -EINPROGRESS) {
 		/* done_task will not finish it, so do it here */
 		omap_sham_finish_req(req, err);
+		req = NULL;
 
-	dev_dbg(dd->dev, "exit, err: %d\n", err);
+		/*
+		 * Execute next request immediately if there is anything
+		 * in queue.
+		 */
+		goto retry;
+	}
 
 	return ret;
 }
@@ -1653,6 +1659,10 @@ finish:
 	dev_dbg(dd->dev, "update done: err: %d\n", err);
 	/* finish curent request */
 	omap_sham_finish_req(dd->req, err);
+
+	/* If we are not busy, process next req */
+	if (!test_bit(FLAGS_BUSY, &dd->flags))
+		omap_sham_handle_queue(dd, NULL);
 }
 
 static irqreturn_t omap_sham_irq_common(struct omap_sham_dev *dd)
-- 
1.9.1
