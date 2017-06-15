From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 07/13] crypto: inside-secure - update the context and request later
Date: Thu, 15 Jun 2017 09:56:23 +0200
Message-ID: <20170615075629.30907-8-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53416 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752120AbdFOIAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:06 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This move the context and request updates at the end of the cipher and
hash send() functions. This way the context and request fields are set
only when everything else was successful in the send() functions.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 7 +++----
 drivers/crypto/inside-secure/safexcel_hash.c   | 8 ++++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8eea4d30db31..6037cdfc1f16 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -190,8 +190,6 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = req->cryptlen;
 	int i, ret = 0;
 
-	request->req = &req->base;
-
 	if (req->src == req->dst) {
 		nr_src = dma_map_sg(priv->dev, req->src,
 				    sg_nents_for_len(req->src, req->cryptlen),
@@ -264,10 +262,11 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 		n_rdesc++;
 	}
 
-	ctx->base.handle_result = safexcel_handle_result;
-
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
+	request->req = &req->base;
+	ctx->base.handle_result = safexcel_handle_result;
+
 	*commands = n_cdesc;
 	*results = n_rdesc;
 	return 0;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 6eee1a502225..4e526372464f 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -198,9 +198,6 @@ static int safexcel_ahash_send(struct crypto_async_request *async, int ring,
 		len -= extra;
 	}
 
-	request->req = &areq->base;
-	ctx->base.handle_result = safexcel_handle_result;
-
 	spin_lock_bh(&priv->ring[ring].egress_lock);
 
 	/* Add a command descriptor for the cached data, if any */
@@ -291,9 +288,12 @@ static int safexcel_ahash_send(struct crypto_async_request *async, int ring,
 		goto cdesc_rollback;
 	}
 
-	req->processed += len;
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
+	req->processed += len;
+	request->req = &areq->base;
+	ctx->base.handle_result = safexcel_handle_result;
+
 	*commands = n_cdesc;
 	*results = 1;
 	return 0;
-- 
2.9.4
