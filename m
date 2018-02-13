From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 8/8] crypto: inside-secure - unmap the result in the hash send error path
Date: Tue, 13 Feb 2018 09:26:57 +0100
Message-ID: <20180213082657.4759-9-antoine.tenart@bootlin.com>
References: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44287 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933695AbeBMIaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:23 -0500
In-Reply-To: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a label to unmap the result buffer in the hash send
function error path.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 43e94cd59c86..a4960a934eef 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -303,7 +303,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 				   req->state_sz);
 	if (IS_ERR(rdesc)) {
 		ret = PTR_ERR(rdesc);
-		goto cdesc_rollback;
+		goto unmap_result;
 	}
 
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
@@ -315,6 +315,8 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	*results = 1;
 	return 0;
 
+unmap_result:
+	dma_unmap_sg(priv->dev, areq->src, req->nents, DMA_TO_DEVICE);
 cdesc_rollback:
 	for (i = 0; i < n_cdesc; i++)
 		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
-- 
2.14.3
