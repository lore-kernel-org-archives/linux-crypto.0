From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 2/2] crypto: inside-secure - fix hash when length is a multiple of a block
Date: Tue, 26 Dec 2017 17:21:17 +0100
Message-ID: <20171226162117.4885-3-antoine.tenart@free-electrons.com>
References: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53374 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdLZQfE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 11:35:04 -0500
In-Reply-To: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the hash support in the SafeXcel driver when the update
size is a multiple of a block size, and when a final call is made just
after with a size of 0. In such cases the driver should cache the last
block from the update to avoid handling 0 length data on the final call
(that's a hardware limitation).

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 34 ++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index fbc03d6e7db7..122a2a58e98f 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -189,17 +189,31 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	else
 		cache_len = queued - areq->nbytes;
 
-	/*
-	 * If this is not the last request and the queued data does not fit
-	 * into full blocks, cache it for the next send() call.
-	 */
-	extra = queued & (crypto_ahash_blocksize(ahash) - 1);
-	if (!req->last_req && extra) {
-		sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
-				   req->cache_next, extra, areq->nbytes - extra);
+	if (!req->last_req) {
+		/* If this is not the last request and the queued data does not
+		 * fit into full blocks, cache it for the next send() call.
+		 */
+		extra = queued & (crypto_ahash_blocksize(ahash) - 1);
+		if (!extra)
+			/* If this is not the last request and the queued data
+			 * is a multiple of a block, cache the last one for now.
+			 */
+			extra = queued - crypto_ahash_blocksize(ahash);
 
-		queued -= extra;
-		len -= extra;
+		if (extra) {
+			sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
+					   req->cache_next, extra,
+					   areq->nbytes - extra);
+
+			queued -= extra;
+			len -= extra;
+
+			if (!queued) {
+				*commands = 0;
+				*results = 0;
+				return 0;
+			}
+		}
 	}
 
 	spin_lock_bh(&priv->ring[ring].egress_lock);
-- 
2.14.3
