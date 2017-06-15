From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 09/13] crypto: inside-secure - stop requeueing failed requests
Date: Thu, 15 Jun 2017 09:56:25 +0200
Message-ID: <20170615075629.30907-10-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53405 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdFOIAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:06 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This update the dequeue function of the inside-secure safexcel driver so
that failed requests aren't requeued when they fail (for whatever
reason, which can be because the hw ring is full).

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 8956b23803a8..8ae133a9e3f2 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -439,20 +439,22 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 			goto finalize;
 
 		request = kzalloc(sizeof(*request), EIP197_GFP_FLAGS(*req));
-		if (!request)
-			goto requeue;
+		if (!request) {
+			spin_lock_bh(&priv->ring[ring].queue_lock);
+			crypto_enqueue_request(&priv->ring[ring].queue, req);
+			spin_unlock_bh(&priv->ring[ring].queue_lock);
+
+			priv->ring[ring].need_dequeue = true;
+			goto finalize;
+		}
 
 		ctx = crypto_tfm_ctx(req->tfm);
 		ret = ctx->send(req, ring, request, &commands, &results);
 		if (ret) {
 			kfree(request);
-requeue:
-			spin_lock_bh(&priv->ring[ring].queue_lock);
-			crypto_enqueue_request(&priv->ring[ring].queue, req);
-			spin_unlock_bh(&priv->ring[ring].queue_lock);
-
+			req->complete(req, ret);
 			priv->ring[ring].need_dequeue = true;
-			continue;
+			goto finalize;
 		}
 
 		if (backlog)
-- 
2.9.4
