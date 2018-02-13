From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 4/8] crypto: inside-secure - fix the cache_len computation
Date: Tue, 13 Feb 2018 09:26:53 +0100
Message-ID: <20180213082657.4759-5-antoine.tenart@bootlin.com>
References: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44267 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933682AbeBMIaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:13 -0500
In-Reply-To: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the cache length computation as cache_len could end up
being a negative value. The check between the queued size and the
block size is updated to reflect the caching mechanism which can cache
up to a full block size (included!).

Fixes: 809778e02cd4 ("crypto: inside-secure - fix hash when length is a multiple of a block")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 8fac23b78da5..2951101e1831 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -184,7 +184,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	int i, queued, len, cache_len, extra, n_cdesc = 0, ret = 0;
 
 	queued = len = req->len - req->processed;
-	if (queued < crypto_ahash_blocksize(ahash))
+	if (queued <= crypto_ahash_blocksize(ahash))
 		cache_len = queued;
 	else
 		cache_len = queued - areq->nbytes;
-- 
2.14.3
