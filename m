From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 2/5] crypto: atmel-sha: fix a race between the 'done' tasklet and the crypto client
Date: Fri, 15 Jan 2016 15:49:32 +0100
Message-ID: <0c8e5e042b213c73a1ace265b9612782cbc5c17f.1452867917.git.cyrille.pitchen@atmel.com>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The 'done' tasklet handler used to check the 'BUSY' flag to either
finalize the processing of a crypto request which had just completed or
manage the crypto queue to start the next crypto request.

On request R1 completion, the driver calls atmel_sha_finish_req(), which:
1 - clears the 'BUSY' flag since the hardware is no longer used and is
    ready again to process new crypto requests.
2 - notifies the above layer (the client) about the completion of the
    asynchronous crypto request R1 by calling its base.complete()
    callback.
3 - schedules the 'done' task to check the crypto queue and start to
    process the next crypto request (the 'BUSY' flag is supposed to be
    cleared at that moment) if such a pending request exists.

However step 2 might wake the client up so it can now ask our driver to
process a new crypto request R2. This request is enqueued by calling the
atmel_sha_handle_queue() function, which sets the 'BUSY' flags then
starts to process R2.

If the 'done' tasklet, scheduled by step 3, runs just after, it would see
that the 'BUSY' flag is set then understand that R2 has just completed,
which is wrong!

So the state of 'BUSY' flag is not a proper way to detect and handle
crypto request completion.

This patch fixes this race condition by using two different tasklets, one
to handle the crypto request completion events, the other to manage the
crypto queue if needed.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 006b2aefba30..75a8cbcf3121 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -122,6 +122,7 @@ struct atmel_sha_dev {
 	spinlock_t		lock;
 	int			err;
 	struct tasklet_struct	done_task;
+	struct tasklet_struct	queue_task;
 
 	unsigned long		flags;
 	struct crypto_queue	queue;
@@ -788,7 +789,7 @@ static void atmel_sha_finish_req(struct ahash_request *req, int err)
 		req->base.complete(&req->base, err);
 
 	/* handle new request */
-	tasklet_schedule(&dd->done_task);
+	tasklet_schedule(&dd->queue_task);
 }
 
 static int atmel_sha_hw_init(struct atmel_sha_dev *dd)
@@ -1101,16 +1102,18 @@ static struct ahash_alg sha_384_512_algs[] = {
 },
 };
 
+static void atmel_sha_queue_task(unsigned long data)
+{
+	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
+
+	atmel_sha_handle_queue(dd, NULL);
+}
+
 static void atmel_sha_done_task(unsigned long data)
 {
 	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
 	int err = 0;
 
-	if (!(SHA_FLAGS_BUSY & dd->flags)) {
-		atmel_sha_handle_queue(dd, NULL);
-		return;
-	}
-
 	if (SHA_FLAGS_CPU & dd->flags) {
 		if (SHA_FLAGS_OUTPUT_READY & dd->flags) {
 			dd->flags &= ~SHA_FLAGS_OUTPUT_READY;
@@ -1367,6 +1370,8 @@ static int atmel_sha_probe(struct platform_device *pdev)
 
 	tasklet_init(&sha_dd->done_task, atmel_sha_done_task,
 					(unsigned long)sha_dd);
+	tasklet_init(&sha_dd->queue_task, atmel_sha_queue_task,
+					(unsigned long)sha_dd);
 
 	crypto_init_queue(&sha_dd->queue, ATMEL_SHA_QUEUE_LENGTH);
 
@@ -1459,6 +1464,7 @@ err_algs:
 		atmel_sha_dma_cleanup(sha_dd);
 err_sha_dma:
 res_err:
+	tasklet_kill(&sha_dd->queue_task);
 	tasklet_kill(&sha_dd->done_task);
 sha_dd_err:
 	dev_err(dev, "initialization failed.\n");
@@ -1479,6 +1485,7 @@ static int atmel_sha_remove(struct platform_device *pdev)
 
 	atmel_sha_unregister_algs(sha_dd);
 
+	tasklet_kill(&sha_dd->queue_task);
 	tasklet_kill(&sha_dd->done_task);
 
 	if (sha_dd->caps.has_dma)
-- 
1.8.2.2
