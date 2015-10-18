From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 10/18] crypto: marvell: move mv_cesa_dma_add_frag() calls
Date: Sun, 18 Oct 2015 17:24:16 +0100
Message-ID: <E1Znqkq-0005X2-OI@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45253 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQYa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:24:30 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the calls to mv_cesa_dma_add_frag() into the parent function,
mv_cesa_ahash_dma_req_init().  This is in preparation to changing
when we generate the operation blocks, as we need to avoid generating
a block for a partial hash block at the end of the user data.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 71 ++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index f567243da005..787cec1715ed 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -499,51 +499,23 @@ mv_cesa_dma_add_frag(struct mv_cesa_tdma_chain *chain,
 	return op;
 }
 
-static struct mv_cesa_op_ctx *
+static int
 mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
 			    struct mv_cesa_ahash_dma_iter *dma_iter,
 			    struct mv_cesa_ahash_req *creq,
 			    gfp_t flags)
 {
 	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
-	struct mv_cesa_op_ctx *op = NULL;
-	int ret;
 
 	if (!creq->cache_ptr)
-		return NULL;
-
-	ret = mv_cesa_dma_add_data_transfer(chain,
-					    CESA_SA_DATA_SRAM_OFFSET,
-					    ahashdreq->cache_dma,
-					    creq->cache_ptr,
-					    CESA_TDMA_DST_IN_SRAM,
-					    flags);
-	if (ret)
-		return ERR_PTR(ret);
-
-	if (!dma_iter->base.op_len)
-		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl,
-					  creq->cache_ptr, flags);
-
-	return op;
-}
-
-static struct mv_cesa_op_ctx *
-mv_cesa_ahash_dma_add_data(struct mv_cesa_tdma_chain *chain,
-			   struct mv_cesa_ahash_dma_iter *dma_iter,
-			   struct mv_cesa_ahash_req *creq,
-			   gfp_t flags)
-{
-	int ret;
-
-	/* Add input transfers */
-	ret = mv_cesa_dma_add_op_transfers(chain, &dma_iter->base,
-					   &dma_iter->src, flags);
-	if (ret)
-		return ERR_PTR(ret);
+		return 0;
 
-	return mv_cesa_dma_add_frag(chain, &creq->op_tmpl, dma_iter->base.op_len,
-				    flags);
+	return mv_cesa_dma_add_data_transfer(chain,
+					     CESA_SA_DATA_SRAM_OFFSET,
+					     ahashdreq->cache_dma,
+					     creq->cache_ptr,
+					     CESA_TDMA_DST_IN_SRAM,
+					     flags);
 }
 
 static struct mv_cesa_op_ctx *
@@ -647,19 +619,34 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	mv_cesa_tdma_desc_iter_init(&chain);
 	mv_cesa_ahash_req_iter_init(&iter, req);
 
-	op = mv_cesa_ahash_dma_add_cache(&chain, &iter,
-					 creq, flags);
-	if (IS_ERR(op)) {
-		ret = PTR_ERR(op);
+	/*
+	 * Add the cache (left-over data from a previous block) first.
+	 * This will never overflow the SRAM size.
+	 */
+	ret = mv_cesa_ahash_dma_add_cache(&chain, &iter, creq, flags);
+	if (ret)
 		goto err_free_tdma;
+
+	if (creq->cache_ptr && !iter.base.op_len) {
+		op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl,
+					  creq->cache_ptr, flags);
+		if (IS_ERR(op)) {
+			ret = PTR_ERR(op);
+			goto err_free_tdma;
+		}
 	}
 
 	do {
 		if (!iter.base.op_len)
 			break;
 
-		op = mv_cesa_ahash_dma_add_data(&chain, &iter,
-						creq, flags);
+		ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+						   &iter.src, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		op = mv_cesa_dma_add_frag(&chain, &creq->op_tmpl,
+					  iter.base.op_len, flags);
 		if (IS_ERR(op)) {
 			ret = PTR_ERR(op);
 			goto err_free_tdma;
-- 
2.1.0
