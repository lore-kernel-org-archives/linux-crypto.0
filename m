From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 1/2] crypto: marvell - Use an unique pool to copy results of requests
Date: Mon,  3 Oct 2016 17:17:38 +0200
Message-ID: <20161003151739.11615-2-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:41553 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751201AbcJCPRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 11:17:54 -0400
In-Reply-To: <20161003151739.11615-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So far, we used a dedicated dma pool to copy the result of outer IV for
cipher requests. Instead of using a dma pool per outer data, we prefer
use the op dma pool that contains all part of the request from the SRAM.
Then, the outer data that is likely to be used by the 'complete'
operation, is copied later. In this way, any type of result can be
retrieved by DMA for cipher or ahash requests.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---

Changes in v2:
  - Use the dma pool "op" to retrieve outer data intead of introducing
    a new one.

 drivers/crypto/marvell/cesa.c   |  4 ----
 drivers/crypto/marvell/cesa.h   |  5 ++---
 drivers/crypto/marvell/cipher.c |  8 +++++---
 drivers/crypto/marvell/tdma.c   | 17 ++++++++---------
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 37dadb2..6e7a5c7 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -375,10 +375,6 @@ static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
 	if (!dma->padding_pool)
 		return -ENOMEM;
 
-	dma->iv_pool = dmam_pool_create("cesa_iv", dev, 16, 1, 0);
-	if (!dma->iv_pool)
-		return -ENOMEM;
-
 	cesa->dma = dma;
 
 	return 0;
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index e423d33..a768da7 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -277,7 +277,7 @@ struct mv_cesa_op_ctx {
 #define CESA_TDMA_DUMMY				0
 #define CESA_TDMA_DATA				1
 #define CESA_TDMA_OP				2
-#define CESA_TDMA_IV				3
+#define CESA_TDMA_RESULT			3
 
 /**
  * struct mv_cesa_tdma_desc - TDMA descriptor
@@ -393,7 +393,6 @@ struct mv_cesa_dev_dma {
 	struct dma_pool *op_pool;
 	struct dma_pool *cache_pool;
 	struct dma_pool *padding_pool;
-	struct dma_pool *iv_pool;
 };
 
 /**
@@ -839,7 +838,7 @@ mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
 	memset(chain, 0, sizeof(*chain));
 }
 
-int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
+int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
 			  u32 size, u32 flags, gfp_t gfp_flags);
 
 struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index d19dc96..098871a 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -212,7 +212,8 @@ mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
 		struct mv_cesa_req *basereq;
 
 		basereq = &creq->base;
-		memcpy(ablkreq->info, basereq->chain.last->data, ivsize);
+		memcpy(ablkreq->info, basereq->chain.last->op->ctx.blkcipher.iv,
+		       ivsize);
 	} else {
 		memcpy_fromio(ablkreq->info,
 			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
@@ -373,8 +374,9 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 
 	/* Add output data for IV */
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
-	ret = mv_cesa_dma_add_iv_op(&basereq->chain, CESA_SA_CRYPT_IV_SRAM_OFFSET,
-				    ivsize, CESA_TDMA_SRC_IN_SRAM, flags);
+	ret = mv_cesa_dma_add_result_op(&basereq->chain, CESA_SA_CFG_SRAM_OFFSET,
+				    CESA_SA_DATA_SRAM_OFFSET,
+				    CESA_TDMA_SRC_IN_SRAM, flags);
 
 	if (ret)
 		goto err_free_tdma;
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 9fd7a5f..2e15f19 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -69,8 +69,8 @@ void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq)
 		if (type == CESA_TDMA_OP)
 			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
 				      le32_to_cpu(tdma->src));
-		else if (type == CESA_TDMA_IV)
-			dma_pool_free(cesa_dev->dma->iv_pool, tdma->data,
+		else if (type == CESA_TDMA_RESULT)
+			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
 				      le32_to_cpu(tdma->dst));
 
 		tdma = tdma->next;
@@ -209,29 +209,28 @@ mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 	return new_tdma;
 }
 
-int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
+int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
 			  u32 size, u32 flags, gfp_t gfp_flags)
 {
-
 	struct mv_cesa_tdma_desc *tdma;
-	u8 *iv;
+	struct mv_cesa_op_ctx *result;
 	dma_addr_t dma_handle;
 
 	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
 	if (IS_ERR(tdma))
 		return PTR_ERR(tdma);
 
-	iv = dma_pool_alloc(cesa_dev->dma->iv_pool, gfp_flags, &dma_handle);
-	if (!iv)
+	result = dma_pool_alloc(cesa_dev->dma->op_pool, gfp_flags, &dma_handle);
+	if (!result)
 		return -ENOMEM;
 
 	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
 	tdma->src = src;
 	tdma->dst = cpu_to_le32(dma_handle);
-	tdma->data = iv;
+	tdma->op = result;
 
 	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
-	tdma->flags = flags | CESA_TDMA_IV;
+	tdma->flags = flags | CESA_TDMA_RESULT;
 	return 0;
 }
 
-- 
2.9.3
