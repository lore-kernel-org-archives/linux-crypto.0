From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell - Update cache with input sg only when it is unmapped
Date: Fri, 22 Jul 2016 15:46:24 +0200
Message-ID: <1469195184-4700-1-git-send-email-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:46474 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753803AbcGVNqd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jul 2016 09:46:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So far, the cache of the ahash requests was updated from the 'complete'
operation. This complete operation is called from mv_cesa_tdma_process
before the cleanup operation, which means that the content of req->src
can be read and copied when it is still mapped. This commit fixes the
issue by moving this cache update from mv_cesa_ahash_complete to
mv_cesa_ahash_req_cleanup, so the copy is done once the sglist is
unmapped.

Fixes: 1bf6682cb31d ("crypto: marvell - Add a complete operation for..")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index c35912b..82e0f4e6 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -315,12 +315,6 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 	for (i = 0; i < digsize / 4; i++)
 		creq->state[i] = readl_relaxed(engine->regs + CESA_IVDIG(i));
 
-	if (creq->cache_ptr)
-		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
-				   creq->cache,
-				   creq->cache_ptr,
-				   ahashreq->nbytes - creq->cache_ptr);
-
 	if (creq->last_req) {
 		/*
 		 * Hardware's MD5 digest is in little endian format, but
@@ -365,6 +359,12 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
 		mv_cesa_ahash_last_cleanup(ahashreq);
 
 	mv_cesa_ahash_cleanup(ahashreq);
+
+	if (creq->cache_ptr)
+		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
+				   creq->cache,
+				   creq->cache_ptr,
+				   ahashreq->nbytes - creq->cache_ptr);
 }
 
 static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
-- 
2.8.1
