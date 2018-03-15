From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 08/12] crypto: inside-secure - do not access buffers mapped to the device
Date: Thu, 15 Mar 2018 16:38:47 +0100
Message-ID: <20180315153851.9958-9-antoine.tenart@bootlin.com>
References: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patches update the way the digest is copied from the state buffer
to the result buffer, so that the copy only happen after the state
buffer was DMA unmapped, as otherwise the buffer would be owned by the
device.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ef3e0c1c0f2c..b9ec82f3dee1 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -156,10 +156,6 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	safexcel_complete(priv, ring);
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
-	if (sreq->finish)
-		memcpy(areq->result, sreq->state,
-		       crypto_ahash_digestsize(ahash));
-
 	if (sreq->nents) {
 		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
 		sreq->nents = 0;
@@ -177,6 +173,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 		sreq->cache_dma = 0;
 	}
 
+	if (sreq->finish)
+		memcpy(areq->result, sreq->state,
+		       crypto_ahash_digestsize(ahash));
+
 	cache_len = sreq->len - sreq->processed;
 	if (cache_len)
 		memcpy(sreq->cache, sreq->cache_next, cache_len);
-- 
2.14.3
