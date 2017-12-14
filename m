From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 15/17] crypto: inside-secure - retry to proceed the request later on fail
Date: Thu, 14 Dec 2017 15:26:57 +0100
Message-ID: <20171214142659.16987-16-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36767 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbdLNOaE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:04 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The dequeueing function was putting back a request in the crypto queue
on failure (when not enough resources are available) which is not
perfect as the request will be handled much later. This patch updates
this logic by keeping a reference on the failed request to try
proceeding it later when enough resources are available.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 32 +++++++++++++++++++++++---------
 drivers/crypto/inside-secure/safexcel.h |  6 ++++++
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 8042922b4ed8..4c7f205d83f0 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -446,29 +446,36 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	struct safexcel_request *request;
 	int ret, nreq = 0, cdesc = 0, rdesc = 0, commands, results;
 
+	/* If a request wasn't properly dequeued because of a lack of resources,
+	 * proceeded it first,
+	 */
+	req = priv->ring[ring].req;
+	backlog = priv->ring[ring].backlog;
+	if (req)
+		goto handle_req;
+
 	while (true) {
 		spin_lock_bh(&priv->ring[ring].queue_lock);
 		backlog = crypto_get_backlog(&priv->ring[ring].queue);
 		req = crypto_dequeue_request(&priv->ring[ring].queue);
 		spin_unlock_bh(&priv->ring[ring].queue_lock);
 
-		if (!req)
+		if (!req) {
+			priv->ring[ring].req = NULL;
+			priv->ring[ring].backlog = NULL;
 			goto finalize;
+		}
 
+handle_req:
 		request = kzalloc(sizeof(*request), EIP197_GFP_FLAGS(*req));
-		if (!request) {
-			spin_lock_bh(&priv->ring[ring].queue_lock);
-			crypto_enqueue_request(&priv->ring[ring].queue, req);
-			spin_unlock_bh(&priv->ring[ring].queue_lock);
-			goto finalize;
-		}
+		if (!request)
+			goto request_failed;
 
 		ctx = crypto_tfm_ctx(req->tfm);
 		ret = ctx->send(req, ring, request, &commands, &results);
 		if (ret) {
 			kfree(request);
-			req->complete(req, ret);
-			goto finalize;
+			goto request_failed;
 		}
 
 		if (backlog)
@@ -483,6 +490,13 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 		nreq++;
 	}
 
+request_failed:
+	/* Not enough resources to handle all the requests. Bail out and save
+	 * the request and the backlog for the next dequeue call (per-ring).
+	 */
+	priv->ring[ring].req = req;
+	priv->ring[ring].backlog = backlog;
+
 finalize:
 	if (!nreq)
 		return;
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 0c47e792192d..d4955abf873b 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -499,6 +499,12 @@ struct safexcel_crypto_priv {
 
 		/* The ring is currently handling at least one request */
 		bool busy;
+
+		/* Store for current requests when bailing out of the dequeueing
+		 * function when no enough resources are available.
+		 */
+		struct crypto_async_request *req;
+		struct crypto_async_request *backlog;
 	} ring[EIP197_MAX_RINGS];
 };
 
-- 
2.14.3
