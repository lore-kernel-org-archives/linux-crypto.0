From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell - Don't chain at DMA level when backlog is disabled
Date: Fri, 22 Jul 2016 14:40:55 +0200
Message-ID: <1469191255-17443-1-git-send-email-romain.perier@free-electrons.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44734 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788AbcGVMk6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jul 2016 08:40:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The flag CRYPTO_TFM_REQ_MAY_BACKLOG is optional and can be set from the
user to put requests into the backlog queue when the main cryptographic
queue is full. Before calling mv_cesa_tdma_chain we must check the value
of the return status to be sure that the current request has been
correctly queued or added to the backlog.

Fixes: 85030c5168f1 ("crypto: marvell - Add support for chaining...")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index e373cc6..d64af86 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -180,10 +180,11 @@ int mv_cesa_queue_req(struct crypto_async_request *req,
 	struct mv_cesa_engine *engine = creq->engine;
 
 	spin_lock_bh(&engine->lock);
-	if (mv_cesa_req_get_type(creq) == CESA_DMA_REQ)
-		mv_cesa_tdma_chain(engine, creq);
-
 	ret = crypto_enqueue_request(&engine->queue, req);
+	if ((mv_cesa_req_get_type(creq) == CESA_DMA_REQ) &&
+	    (ret == -EINPROGRESS ||
+	    (ret == -EBUSY && req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+		mv_cesa_tdma_chain(engine, creq);
 	spin_unlock_bh(&engine->lock);
 
 	if (ret != -EINPROGRESS)
-- 
2.8.1
