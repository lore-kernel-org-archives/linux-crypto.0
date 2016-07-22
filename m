From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell - Fix memory leaks in TDMA chain for cipher requests
Date: Fri, 22 Jul 2016 14:40:39 +0200
Message-ID: <1469191239-17296-1-git-send-email-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:44715 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788AbcGVMkx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jul 2016 08:40:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So far in mv_cesa_ablkcipher_dma_req_init, if an error is thrown while
the tdma chain is built there is a memory leak. This issue exists
because the chain is assigned later at the end of the function, so the
cleanup function is called with the wrong version of the chain.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cipher.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 48df03a..8391aba 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -320,7 +320,6 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 		      GFP_KERNEL : GFP_ATOMIC;
 	struct mv_cesa_req *basereq = &creq->base;
 	struct mv_cesa_ablkcipher_dma_iter iter;
-	struct mv_cesa_tdma_chain chain;
 	bool skip_ctx = false;
 	int ret;
 	unsigned int ivsize;
@@ -347,13 +346,13 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 			return -ENOMEM;
 	}
 
-	mv_cesa_tdma_desc_iter_init(&chain);
+	mv_cesa_tdma_desc_iter_init(&basereq->chain);
 	mv_cesa_ablkcipher_req_iter_init(&iter, req);
 
 	do {
 		struct mv_cesa_op_ctx *op;
 
-		op = mv_cesa_dma_add_op(&chain, op_templ, skip_ctx, flags);
+		op = mv_cesa_dma_add_op(&basereq->chain, op_templ, skip_ctx, flags);
 		if (IS_ERR(op)) {
 			ret = PTR_ERR(op);
 			goto err_free_tdma;
@@ -363,18 +362,18 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 		mv_cesa_set_crypt_op_len(op, iter.base.op_len);
 
 		/* Add input transfers */
-		ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+		ret = mv_cesa_dma_add_op_transfers(&basereq->chain, &iter.base,
 						   &iter.src, flags);
 		if (ret)
 			goto err_free_tdma;
 
 		/* Add dummy desc to launch the crypto operation */
-		ret = mv_cesa_dma_add_dummy_launch(&chain, flags);
+		ret = mv_cesa_dma_add_dummy_launch(&basereq->chain, flags);
 		if (ret)
 			goto err_free_tdma;
 
 		/* Add output transfers */
-		ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+		ret = mv_cesa_dma_add_op_transfers(&basereq->chain, &iter.base,
 						   &iter.dst, flags);
 		if (ret)
 			goto err_free_tdma;
@@ -383,13 +382,12 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 
 	/* Add output data for IV */
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
-	ret = mv_cesa_dma_add_iv_op(&chain, CESA_SA_CRYPT_IV_SRAM_OFFSET,
+	ret = mv_cesa_dma_add_iv_op(&basereq->chain, CESA_SA_CRYPT_IV_SRAM_OFFSET,
 				    ivsize, CESA_TDMA_SRC_IN_SRAM, flags);
 
 	if (ret)
 		goto err_free_tdma;
 
-	basereq->chain = chain;
 	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
 
 	return 0;
-- 
2.8.1
