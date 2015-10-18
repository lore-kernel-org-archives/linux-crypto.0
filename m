From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 11/18] crypto: marvell: use presence of scatterlist to
 determine data load
Date: Sun, 18 Oct 2015 17:24:21 +0100
Message-ID: <E1Znqkv-0005X9-Rp@rmk-PC.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45260 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQYf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:24:35 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the presence of the scatterlist to determine whether we should load
any new user data to the engine.  The following shall always be true at
this point:

	iter.base.op_len == 0 === iter.src.sg

In doing so, we can:

1. eliminate the test for iter.base.op_len inside the loop, which
   makes the loop operation more obvious and understandable.

2. move the operation generation for the cache-only case.

This prepares the code for the next step in its transformation, and also
uncovers a bug that will be fixed in the next patch.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 787cec1715ed..c4693321fdc8 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -627,7 +627,27 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (creq->cache_ptr && !iter.base.op_len) {
+	if (iter.src.sg) {
+		/*
+		 * Add all the new data, inserting an operation block and
+		 * launch command between each full SRAM block-worth of
+		 * data.
+		 */
+		do {
+			ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+							   &iter.src, flags);
+			if (ret)
+				goto err_free_tdma;
+
+			op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl,
+						  iter.base.op_len, flags);
+			if (IS_ERR(op)) {
+				ret = PTR_ERR(op);
+				goto err_free_tdma;
+			}
+		} while (mv_cesa_ahash_req_iter_next_op(&iter));
+	} else if (creq->cache_ptr) {
+		/* Account for the data that was in the cache. */
 		op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl,
 					  creq->cache_ptr, flags);
 		if (IS_ERR(op)) {
@@ -636,23 +656,6 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 		}
 	}
 
-	do {
-		if (!iter.base.op_len)
-			break;
-
-		ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
-						   &iter.src, flags);
-		if (ret)
-			goto err_free_tdma;
-
-		op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl,
-					  iter.base.op_len, flags);
-		if (IS_ERR(op)) {
-			ret = PTR_ERR(op);
-			goto err_free_tdma;
-		}
-	} while (mv_cesa_ahash_req_iter_next_op(&iter));
-
 	op = mv_cesa_ahash_dma_last_req(&chain, &iter, creq, op, flags);
 	if (IS_ERR(op)) {
 		ret = PTR_ERR(op);
-- 
2.1.0
