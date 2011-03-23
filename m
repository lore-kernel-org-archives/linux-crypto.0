From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH] picoxcell-crypto: fix possible status FIFO overflow
Date: Wed, 23 Mar 2011 13:26:21 +0000
Message-ID: <1300886781-19415-1-git-send-email-jamie@jamieiles.com>
Cc: herbert@gondor.hengli.com.au, Jamie Iles <jamie@jamieiles.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39384 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CWN00 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2011 09:26:26 -0400
Received: by wwa36 with SMTP id 36so10115814wwa.1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2011 06:26:25 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SPAcc's have 2 equally sized FIFO's - a command FIFO and a status
FIFO.  The command FIFO takes the requests that are to be performed and
the status FIFO reports the results.  It is possible to get into the
situation where there are more free spaces in the command FIFO than the
status FIFO if we don't empty the status FIFO quickly enough resulting
in a possible overflow of the status FIFO.  This can result in incorrect
status being reported in the status FIFO.

Make sure that when we are submitting requests the number of requests
that have been dispatched but not yet popped from the status FIFO does
not exceed the size of a single FIFO.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/picoxcell_crypto.c |   64 ++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index b092d0a..230b5b8 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -176,6 +176,8 @@ struct spacc_aead_ctx {
 	u8				salt[AES_BLOCK_SIZE];
 };
 
+static int spacc_ablk_submit(struct spacc_req *req);
+
 static inline struct spacc_alg *to_spacc_alg(struct crypto_alg *alg)
 {
 	return alg ? container_of(alg, struct spacc_alg, alg) : NULL;
@@ -666,6 +668,24 @@ static int spacc_aead_submit(struct spacc_req *req)
 	return -EINPROGRESS;
 }
 
+static int spacc_req_submit(struct spacc_req *req);
+
+static void spacc_push(struct spacc_engine *engine)
+{
+	struct spacc_req *req;
+
+	while (!list_empty(&engine->pending) &&
+	       engine->in_flight + 1 <= engine->fifo_sz) {
+
+		++engine->in_flight;
+		req = list_first_entry(&engine->pending, struct spacc_req,
+				       list);
+		list_move_tail(&req->list, &engine->in_progress);
+
+		req->result = spacc_req_submit(req);
+	}
+}
+
 /*
  * Setup an AEAD request for processing. This will configure the engine, load
  * the context and then start the packet processing.
@@ -698,7 +718,8 @@ static int spacc_aead_setup(struct aead_request *req, u8 *giv,
 
 	err = -EINPROGRESS;
 	spin_lock_irqsave(&engine->hw_lock, flags);
-	if (unlikely(spacc_fifo_cmd_full(engine))) {
+	if (unlikely(spacc_fifo_cmd_full(engine)) ||
+	    engine->in_flight + 1 > engine->fifo_sz) {
 		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 			err = -EBUSY;
 			spin_unlock_irqrestore(&engine->hw_lock, flags);
@@ -706,9 +727,8 @@ static int spacc_aead_setup(struct aead_request *req, u8 *giv,
 		}
 		list_add_tail(&dev_req->list, &engine->pending);
 	} else {
-		++engine->in_flight;
-		list_add_tail(&dev_req->list, &engine->in_progress);
-		spacc_aead_submit(dev_req);
+		list_add_tail(&dev_req->list, &engine->pending);
+		spacc_push(engine);
 	}
 	spin_unlock_irqrestore(&engine->hw_lock, flags);
 
@@ -1041,7 +1061,8 @@ static int spacc_ablk_setup(struct ablkcipher_request *req, unsigned alg_type,
 	 * we either stick it on the end of a pending list if we can backlog,
 	 * or bailout with an error if not.
 	 */
-	if (unlikely(spacc_fifo_cmd_full(engine))) {
+	if (unlikely(spacc_fifo_cmd_full(engine)) ||
+	    engine->in_flight + 1 > engine->fifo_sz) {
 		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 			err = -EBUSY;
 			spin_unlock_irqrestore(&engine->hw_lock, flags);
@@ -1049,9 +1070,8 @@ static int spacc_ablk_setup(struct ablkcipher_request *req, unsigned alg_type,
 		}
 		list_add_tail(&dev_req->list, &engine->pending);
 	} else {
-		++engine->in_flight;
-		list_add_tail(&dev_req->list, &engine->in_progress);
-		spacc_ablk_submit(dev_req);
+		list_add_tail(&dev_req->list, &engine->pending);
+		spacc_push(engine);
 	}
 	spin_unlock_irqrestore(&engine->hw_lock, flags);
 
@@ -1139,6 +1159,7 @@ static void spacc_process_done(struct spacc_engine *engine)
 		req = list_first_entry(&engine->in_progress, struct spacc_req,
 				       list);
 		list_move_tail(&req->list, &engine->completed);
+		--engine->in_flight;
 
 		/* POP the status register. */
 		writel(~0, engine->regs + SPA_STAT_POP_REG_OFFSET);
@@ -1208,36 +1229,21 @@ static void spacc_spacc_complete(unsigned long data)
 	struct spacc_engine *engine = (struct spacc_engine *)data;
 	struct spacc_req *req, *tmp;
 	unsigned long flags;
-	int num_removed = 0;
 	LIST_HEAD(completed);
 
 	spin_lock_irqsave(&engine->hw_lock, flags);
+
 	list_splice_init(&engine->completed, &completed);
+	spacc_push(engine);
+	if (engine->in_flight)
+		mod_timer(&engine->packet_timeout, jiffies + PACKET_TIMEOUT);
+
 	spin_unlock_irqrestore(&engine->hw_lock, flags);
 
 	list_for_each_entry_safe(req, tmp, &completed, list) {
-		++num_removed;
 		req->complete(req);
+		list_del(&req->list);
 	}
-
-	/* Try and fill the engine back up again. */
-	spin_lock_irqsave(&engine->hw_lock, flags);
-
-	engine->in_flight -= num_removed;
-
-	list_for_each_entry_safe(req, tmp, &engine->pending, list) {
-		if (spacc_fifo_cmd_full(engine))
-			break;
-
-		list_move_tail(&req->list, &engine->in_progress);
-		++engine->in_flight;
-		req->result = spacc_req_submit(req);
-	}
-
-	if (engine->in_flight)
-		mod_timer(&engine->packet_timeout, jiffies + PACKET_TIMEOUT);
-
-	spin_unlock_irqrestore(&engine->hw_lock, flags);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.4
