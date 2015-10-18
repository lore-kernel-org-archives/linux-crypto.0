From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 18/18] crypto: marvell/cesa: fix memory leak
Date: Sun, 18 Oct 2015 17:24:57 +0100
Message-ID: <E1ZnqlV-0005Xr-N2@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45306 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQZL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:25:11 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,Arnaud Ebalard <arno@natisbad.org>,Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,Jason Cooper <jason@lakedaemon.net>

The local chain variable is not cleaned up if an error occurs in the middle
of DMA chain creation. Fix that by dropping the local chain variable and
using the dreq->chain field which will be cleaned up by
mv_cesa_dma_cleanup() in case of errors.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 34271e9eb3a5..7cd0f0decf6c 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -602,7 +602,6 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 		      GFP_KERNEL : GFP_ATOMIC;
 	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
 	struct mv_cesa_tdma_req *dreq = &ahashdreq->base;
-	struct mv_cesa_tdma_chain chain;
 	struct mv_cesa_ahash_dma_iter iter;
 	struct mv_cesa_op_ctx *op = NULL;
 	unsigned int frag_len;
@@ -620,14 +619,14 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 		}
 	}
 
-	mv_cesa_tdma_desc_iter_init(&chain);
+	mv_cesa_tdma_desc_iter_init(&dreq->chain);
 	mv_cesa_ahash_req_iter_init(&iter, req);
 
 	/*
 	 * Add the cache (left-over data from a previous block) first.
 	 * This will never overflow the SRAM size.
 	 */
-	ret = mv_cesa_ahash_dma_add_cache(&chain, &iter, creq, flags);
+	ret = mv_cesa_ahash_dma_add_cache(&dreq->chain, &iter, creq, flags);
 	if (ret)
 		goto err_free_tdma;
 
@@ -638,7 +637,8 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 		 * data. We intentionally do not add the final op block.
 		 */
 		while (true) {
-			ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+			ret = mv_cesa_dma_add_op_transfers(&dreq->chain,
+							   &iter.base,
 							   &iter.src, flags);
 			if (ret)
 				goto err_free_tdma;
@@ -648,7 +648,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 			if (!mv_cesa_ahash_req_iter_next_op(&iter))
 				break;
 
-			op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl,
+			op = mv_cesa_dma_add_frag(&dreq->chain, &creq->op_tmpl,
 						  frag_len, flags);
 			if (IS_ERR(op)) {
 				ret = PTR_ERR(op);
@@ -666,11 +666,11 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	 * operation, which depends whether this is the final request.
 	 */
 	if (creq->last_req)
-		op = mv_cesa_ahash_dma_last_req(&chain, &iter, creq, frag_len,
-						flags);
+		op = mv_cesa_ahash_dma_last_req(&dreq->chain, &iter, creq,
+						frag_len, flags);
 	else if (frag_len)
-		op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl, frag_len,
-					  flags);
+		op = mv_cesa_dma_add_frag(&dreq->chain, &creq->op_tmpl,
+					  frag_len, flags);
 
 	if (IS_ERR(op)) {
 		ret = PTR_ERR(op);
@@ -679,7 +679,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 
 	if (op) {
 		/* Add dummy desc to wait for crypto operation end */
-		ret = mv_cesa_dma_add_dummy_end(&chain, flags);
+		ret = mv_cesa_dma_add_dummy_end(&dreq->chain, flags);
 		if (ret)
 			goto err_free_tdma;
 	}
@@ -690,8 +690,6 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	else
 		creq->cache_ptr = 0;
 
-	dreq->chain = chain;
-
 	return 0;
 
 err_free_tdma:
-- 
2.1.0
