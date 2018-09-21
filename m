From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH] crypto: mxs-dcp - Fix wait logic on chan threads
Date: Fri, 21 Sep 2018 18:03:18 +0300
Message-ID: <163d1af7d51bfa330f4cc685c5c493cd38aa584b.1537541211.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S . Miller " <davem@davemloft.net>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-crypto@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
To: Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When compiling with CONFIG_DEBUG_ATOMIC_SLEEP=y the mxs-dcp driver
prints warnings such as:

WARNING: CPU: 0 PID: 120 at kernel/sched/core.c:7736 __might_sleep+0x98/0x9c
do not call blocking ops when !TASK_RUNNING; state=1 set at [<8081978c>] dcp_chan_thread_sha+0x3c/0x2ec

The problem is that blocking ops will manipulate current->state
themselves so it is not allowed to call them between
set_current_state(TASK_INTERRUPTIBLE) and schedule().

Fix this by converting the per-chan mutex to a spinlock (it only
protects tiny list ops anyway) and rearranging the wait logic so that
callbacks are called current->state as TASK_RUNNING. Those callbacks
will indeed call blocking ops themselves so this is required.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>

---
 drivers/crypto/mxs-dcp.c | 53 +++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

Some interesting info on this warning: https://lwn.net/Articles/628628/

The sahara driver likely suffers from the same issue, code seems to be
very similar. Maybe some crypto helpers could be used instead?

There are multiple other issues with the mxs-dcp driver and additional
patches are required to get it working well but they're not related to
this queue waiting logic.

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f0df3da71c7a..73015038fc25 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -78,11 +78,11 @@ struct dcp {
 	uint32_t			caps;
 
 	struct dcp_coherent_block	*coh;
 
 	struct completion		completion[DCP_MAX_CHANS];
-	struct mutex			mutex[DCP_MAX_CHANS];
+	spinlock_t			lock[DCP_MAX_CHANS];
 	struct task_struct		*thread[DCP_MAX_CHANS];
 	struct crypto_queue		queue[DCP_MAX_CHANS];
 	struct clk *dcp_clk;
 };
 
@@ -393,29 +393,33 @@ static int dcp_chan_thread_aes(void *data)
 	struct crypto_async_request *backlog;
 	struct crypto_async_request *arq;
 
 	int ret;
 
-	do {
-		__set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
 
-		mutex_lock(&sdcp->mutex[chan]);
+		spin_lock(&sdcp->lock[chan]);
 		backlog = crypto_get_backlog(&sdcp->queue[chan]);
 		arq = crypto_dequeue_request(&sdcp->queue[chan]);
-		mutex_unlock(&sdcp->mutex[chan]);
+		spin_unlock(&sdcp->lock[chan]);
+
+		if (!backlog && !arq) {
+			schedule();
+			continue;
+		}
+
+		set_current_state(TASK_RUNNING);
 
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
 
 		if (arq) {
 			ret = mxs_dcp_aes_block_crypt(arq);
 			arq->complete(arq, ret);
-			continue;
 		}
-
-		schedule();
-	} while (!kthread_should_stop());
+	}
 
 	return 0;
 }
 
 static int mxs_dcp_block_fallback(struct ablkcipher_request *req, int enc)
@@ -453,13 +457,13 @@ static int mxs_dcp_aes_enqueue(struct ablkcipher_request *req, int enc, int ecb)
 
 	rctx->enc = enc;
 	rctx->ecb = ecb;
 	actx->chan = DCP_CHAN_CRYPTO;
 
-	mutex_lock(&sdcp->mutex[actx->chan]);
+	spin_lock(&sdcp->lock[actx->chan]);
 	ret = crypto_enqueue_request(&sdcp->queue[actx->chan], &req->base);
-	mutex_unlock(&sdcp->mutex[actx->chan]);
+	spin_unlock(&sdcp->lock[actx->chan]);
 
 	wake_up_process(sdcp->thread[actx->chan]);
 
 	return -EINPROGRESS;
 }
@@ -695,17 +699,24 @@ static int dcp_chan_thread_sha(void *data)
 	struct dcp_sha_req_ctx *rctx;
 
 	struct ahash_request *req;
 	int ret, fini;
 
-	do {
-		__set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
 
-		mutex_lock(&sdcp->mutex[chan]);
+		spin_lock(&sdcp->lock[chan]);
 		backlog = crypto_get_backlog(&sdcp->queue[chan]);
 		arq = crypto_dequeue_request(&sdcp->queue[chan]);
-		mutex_unlock(&sdcp->mutex[chan]);
+		spin_unlock(&sdcp->lock[chan]);
+
+		if (!backlog && !arq) {
+			schedule();
+			continue;
+		}
+
+		set_current_state(TASK_RUNNING);
 
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
 
 		if (arq) {
@@ -713,16 +724,12 @@ static int dcp_chan_thread_sha(void *data)
 			rctx = ahash_request_ctx(req);
 
 			ret = dcp_sha_req_to_buf(arq);
 			fini = rctx->fini;
 			arq->complete(arq, ret);
-			if (!fini)
-				continue;
 		}
-
-		schedule();
-	} while (!kthread_should_stop());
+	}
 
 	return 0;
 }
 
 static int dcp_sha_init(struct ahash_request *req)
@@ -776,13 +783,13 @@ static int dcp_sha_update_fx(struct ahash_request *req, int fini)
 	if (!actx->hot) {
 		actx->hot = 1;
 		rctx->init = 1;
 	}
 
-	mutex_lock(&sdcp->mutex[actx->chan]);
+	spin_lock(&sdcp->lock[actx->chan]);
 	ret = crypto_enqueue_request(&sdcp->queue[actx->chan], &req->base);
-	mutex_unlock(&sdcp->mutex[actx->chan]);
+	spin_unlock(&sdcp->lock[actx->chan]);
 
 	wake_up_process(sdcp->thread[actx->chan]);
 	mutex_unlock(&actx->mutex);
 
 	return -EINPROGRESS;
@@ -1086,11 +1093,11 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	global_sdcp = sdcp;
 
 	platform_set_drvdata(pdev, sdcp);
 
 	for (i = 0; i < DCP_MAX_CHANS; i++) {
-		mutex_init(&sdcp->mutex[i]);
+		spin_lock_init(&sdcp->lock[i]);
 		init_completion(&sdcp->completion[i]);
 		crypto_init_queue(&sdcp->queue[i], 50);
 	}
 
 	/* Create the SHA and AES handler threads. */
-- 
2.17.1
