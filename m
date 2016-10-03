From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 2/2] crypto: marvell - Don't break chain for computable last ahash requests
Date: Mon,  3 Oct 2016 17:17:39 +0200
Message-ID: <20161003151739.11615-3-romain.perier@free-electrons.com>
References: <20161003151739.11615-1-romain.perier@free-electrons.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:41564 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751260AbcJCPRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 11:17:54 -0400
In-Reply-To: <20161003151739.11615-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, the driver breaks chain for all kind of hash requests in order to
don't override intermediate states of partial ahash updates. However, some final
ahash requests can be directly processed by the engine, and so without
intermediate state. This is typically the case for most for the HMAC requests
processed via IPSec.

This commits adds a TDMA descriptor to copy outer data for these of requests
into the "op" dma pool, then it allow to chain these requests at the DMA level.
The 'complete' operation is also updated to retrieve the MAC digest from the
right location.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---

Changes in v2:
 - Replaced BUG_ON by an error
 - Add a variable "break_chain", with "type" to break the chain
   with ahash requests. It improves code readability.

 drivers/crypto/marvell/cipher.c | 10 +++---
 drivers/crypto/marvell/hash.c   | 79 +++++++++++++++++++++++++++++++++--------
 drivers/crypto/marvell/tdma.c   |  4 +--
 3 files changed, 71 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 098871a..8bc52bf 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -212,8 +212,7 @@ mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
 		struct mv_cesa_req *basereq;
 
 		basereq = &creq->base;
-		memcpy(ablkreq->info, basereq->chain.last->op->ctx.blkcipher.iv,
-		       ivsize);
+		memcpy(ablkreq->info, basereq->chain.last->data, ivsize);
 	} else {
 		memcpy_fromio(ablkreq->info,
 			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
@@ -374,9 +373,10 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 
 	/* Add output data for IV */
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
-	ret = mv_cesa_dma_add_result_op(&basereq->chain, CESA_SA_CFG_SRAM_OFFSET,
-				    CESA_SA_DATA_SRAM_OFFSET,
-				    CESA_TDMA_SRC_IN_SRAM, flags);
+	ret = mv_cesa_dma_add_result_op(&basereq->chain,
+					CESA_SA_CRYPT_IV_SRAM_OFFSET,
+					ivsize,
+					CESA_TDMA_SRC_IN_SRAM, flags);
 
 	if (ret)
 		goto err_free_tdma;
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 9f28468..35baf4f 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -312,24 +312,53 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 	int i;
 
 	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
-	for (i = 0; i < digsize / 4; i++)
-		creq->state[i] = readl_relaxed(engine->regs + CESA_IVDIG(i));
 
-	if (creq->last_req) {
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ &&
+	    !(creq->base.chain.last->flags & CESA_TDMA_BREAK_CHAIN)) {
+		struct mv_cesa_tdma_desc *tdma = NULL;
+		__le32 *data = NULL;
+
+		for (tdma = creq->base.chain.first; tdma; tdma = tdma->next) {
+			u32 type = tdma->flags & CESA_TDMA_TYPE_MSK;
+			if (type ==  CESA_TDMA_RESULT)
+				break;
+		}
+
+		if (!tdma) {
+			dev_err(cesa_dev->dev, "Failed to retrieve tdma "
+					       "descriptor for outer data\n");
+			return;
+		}
+
 		/*
-		 * Hardware's MD5 digest is in little endian format, but
-		 * SHA in big endian format
+		 * Result is already in the correct endianess when the SA is
+		 * used
 		 */
-		if (creq->algo_le) {
-			__le32 *result = (void *)ahashreq->result;
+		data = tdma->data;
+		for (i = 0; i < digsize / 4; i++)
+			creq->state[i] = cpu_to_le32(data[i]);
 
-			for (i = 0; i < digsize / 4; i++)
-				result[i] = cpu_to_le32(creq->state[i]);
-		} else {
-			__be32 *result = (void *)ahashreq->result;
+		memcpy(ahashreq->result, data, digsize);
+	} else {
+		for (i = 0; i < digsize / 4; i++)
+			creq->state[i] = readl_relaxed(engine->regs +
+						       CESA_IVDIG(i));
+		if (creq->last_req) {
+			/*
+			* Hardware's MD5 digest is in little endian format, but
+			* SHA in big endian format
+			*/
+			if (creq->algo_le) {
+				__le32 *result = (void *)ahashreq->result;
+
+				for (i = 0; i < digsize / 4; i++)
+					result[i] = cpu_to_le32(creq->state[i]);
+			} else {
+				__be32 *result = (void *)ahashreq->result;
 
-			for (i = 0; i < digsize / 4; i++)
-				result[i] = cpu_to_be32(creq->state[i]);
+				for (i = 0; i < digsize / 4; i++)
+					result[i] = cpu_to_be32(creq->state[i]);
+			}
 		}
 	}
 
@@ -504,6 +533,12 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 						CESA_SA_DESC_CFG_LAST_FRAG,
 				      CESA_SA_DESC_CFG_FRAG_MSK);
 
+		ret = mv_cesa_dma_add_result_op(chain,
+						CESA_SA_MAC_DIG_SRAM_OFFSET,
+						32,
+						CESA_TDMA_SRC_IN_SRAM, flags);
+		if (ret)
+			return ERR_PTR(-ENOMEM);
 		return op;
 	}
 
@@ -564,6 +599,8 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	struct mv_cesa_op_ctx *op = NULL;
 	unsigned int frag_len;
 	int ret;
+	u32 type;
+	bool break_chain = true;
 
 	basereq->chain.first = NULL;
 	basereq->chain.last = NULL;
@@ -635,6 +672,16 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 		goto err_free_tdma;
 	}
 
+	/*
+	 * If results are copied via DMA, this means that this
+	 * request can be directly processed by the engine,
+	 * without partial updates. So we can chain it at the
+	 * DMA level with other requests.
+	 */
+	type = basereq->chain.last->flags & CESA_TDMA_TYPE_MSK;
+	if (type == CESA_TDMA_RESULT)
+		break_chain = false;
+
 	if (op) {
 		/* Add dummy desc to wait for crypto operation end */
 		ret = mv_cesa_dma_add_dummy_end(&basereq->chain, flags);
@@ -648,8 +695,10 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	else
 		creq->cache_ptr = 0;
 
-	basereq->chain.last->flags |= (CESA_TDMA_END_OF_REQ |
-				       CESA_TDMA_BREAK_CHAIN);
+	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
+
+	if (break_chain)
+		basereq->chain.last->flags |= CESA_TDMA_BREAK_CHAIN;
 
 	return 0;
 
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 2e15f19..8d33003 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -70,7 +70,7 @@ void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq)
 			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
 				      le32_to_cpu(tdma->src));
 		else if (type == CESA_TDMA_RESULT)
-			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
+			dma_pool_free(cesa_dev->dma->op_pool, tdma->data,
 				      le32_to_cpu(tdma->dst));
 
 		tdma = tdma->next;
@@ -227,7 +227,7 @@ int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
 	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
 	tdma->src = src;
 	tdma->dst = cpu_to_le32(dma_handle);
-	tdma->op = result;
+	tdma->data = result;
 
 	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
 	tdma->flags = flags | CESA_TDMA_RESULT;
-- 
2.9.3
