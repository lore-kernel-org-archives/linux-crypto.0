From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 4/7] crypto: marvell: Moving the tdma chain out of mv_cesa_tdma_req
Date: Wed, 15 Jun 2016 21:15:31 +0200
Message-ID: <1466018134-10779-5-git-send-email-romain.perier@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52774 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932655AbcFOTQo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 15:16:44 -0400
In-Reply-To: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Actually the only way to access the tdma chain is to use the 'req' union
from a mv_cesa_{ablkcipher,ahash}. This will soon become a problem if we
want to handle the TDMA chaining vs standard/non-DMA processing in a
generic way (with generic functions at the cesa.c level detecting
whether the request should be queued at the DMA level or not). Hence the
decision to move the chain field a the mv_cesa_req level at the expense
of adding 2 void * fields to all request contexts (including non-DMA
ones). To limit the overhead, we get rid of the type field, which can
now be deduced from the req->chain.first value.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c   |  3 ++-
 drivers/crypto/marvell/cesa.h   | 31 +++++++++++++------------------
 drivers/crypto/marvell/cipher.c | 40 ++++++++++++++++++++++------------------
 drivers/crypto/marvell/hash.c   | 36 +++++++++++++++---------------------
 drivers/crypto/marvell/tdma.c   |  8 ++++----
 5 files changed, 56 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 93700cd..fe04d1b 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -111,7 +111,8 @@ static irqreturn_t mv_cesa_int(int irq, void *priv)
 	return ret;
 }
 
-int mv_cesa_queue_req(struct crypto_async_request *req)
+int mv_cesa_queue_req(struct crypto_async_request *req,
+		      struct mv_cesa_req *creq)
 {
 	int ret;
 	int i;
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 74b84bd..158ff82 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -509,21 +509,11 @@ enum mv_cesa_req_type {
 
 /**
  * struct mv_cesa_req - CESA request
- * @type:	request type
  * @engine:	engine associated with this request
+ * @chain:	list of tdma descriptors associated  with this request
  */
 struct mv_cesa_req {
-	enum mv_cesa_req_type type;
 	struct mv_cesa_engine *engine;
-};
-
-/**
- * struct mv_cesa_tdma_req - CESA TDMA request
- * @base:	base information
- * @chain:	TDMA chain
- */
-struct mv_cesa_tdma_req {
-	struct mv_cesa_req base;
 	struct mv_cesa_tdma_chain chain;
 };
 
@@ -562,7 +552,6 @@ struct mv_cesa_ablkcipher_std_req {
 struct mv_cesa_ablkcipher_req {
 	union {
 		struct mv_cesa_req base;
-		struct mv_cesa_tdma_req dma;
 		struct mv_cesa_ablkcipher_std_req std;
 	} req;
 	int src_nents;
@@ -587,7 +576,6 @@ struct mv_cesa_ahash_std_req {
  * @cache_dma:		DMA address of the cache buffer
  */
 struct mv_cesa_ahash_dma_req {
-	struct mv_cesa_tdma_req base;
 	u8 *padding;
 	dma_addr_t padding_dma;
 	u8 *cache;
@@ -625,6 +613,12 @@ struct mv_cesa_ahash_req {
 
 extern struct mv_cesa_dev *cesa_dev;
 
+static inline enum mv_cesa_req_type
+mv_cesa_req_get_type(struct mv_cesa_req *req)
+{
+	return req->chain.first ? CESA_DMA_REQ : CESA_STD_REQ;
+}
+
 static inline void mv_cesa_update_op_cfg(struct mv_cesa_op_ctx *op,
 					 u32 cfg, u32 mask)
 {
@@ -697,7 +691,8 @@ static inline bool mv_cesa_mac_op_is_first_frag(const struct mv_cesa_op_ctx *op)
 		CESA_SA_DESC_CFG_FIRST_FRAG;
 }
 
-int mv_cesa_queue_req(struct crypto_async_request *req);
+int mv_cesa_queue_req(struct crypto_async_request *req,
+		      struct mv_cesa_req *creq);
 
 /*
  * Helper function that indicates whether a crypto request needs to be
@@ -767,9 +762,9 @@ static inline bool mv_cesa_req_dma_iter_next_op(struct mv_cesa_dma_iter *iter)
 	return iter->op_len;
 }
 
-void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq);
+void mv_cesa_dma_step(struct mv_cesa_req *dreq);
 
-static inline int mv_cesa_dma_process(struct mv_cesa_tdma_req *dreq,
+static inline int mv_cesa_dma_process(struct mv_cesa_req *dreq,
 				      u32 status)
 {
 	if (!(status & CESA_SA_INT_ACC0_IDMA_DONE))
@@ -781,10 +776,10 @@ static inline int mv_cesa_dma_process(struct mv_cesa_tdma_req *dreq,
 	return 0;
 }
 
-void mv_cesa_dma_prepare(struct mv_cesa_tdma_req *dreq,
+void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 			 struct mv_cesa_engine *engine);
+void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq);
 
-void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq);
 
 static inline void
 mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index f42620e..15d2c5a 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -70,14 +70,14 @@ mv_cesa_ablkcipher_dma_cleanup(struct ablkcipher_request *req)
 		dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
 			     DMA_BIDIRECTIONAL);
 	}
-	mv_cesa_dma_cleanup(&creq->req.dma);
+	mv_cesa_dma_cleanup(&creq->req.base);
 }
 
 static inline void mv_cesa_ablkcipher_cleanup(struct ablkcipher_request *req)
 {
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 
-	if (creq->req.base.type == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		mv_cesa_ablkcipher_dma_cleanup(req);
 }
 
@@ -141,19 +141,19 @@ static int mv_cesa_ablkcipher_process(struct crypto_async_request *req,
 	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
 
-	if (creq->req.base.type == CESA_DMA_REQ) {
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ) {
 		int ret;
-		struct mv_cesa_tdma_req *dreq;
+		struct mv_cesa_req *basereq;
 		unsigned int ivsize;
 
-		ret = mv_cesa_dma_process(&creq->req.dma, status);
+		ret = mv_cesa_dma_process(&creq->req.base, status);
 		if (ret)
 			return ret;
 
-		dreq = &creq->req.dma;
+		basereq = &creq->req.base;
 		ivsize = crypto_ablkcipher_ivsize(
 					     crypto_ablkcipher_reqtfm(ablkreq));
-		memcpy_fromio(ablkreq->info, dreq->chain.last->data, ivsize);
+		memcpy_fromio(ablkreq->info, basereq->chain.last->data, ivsize);
 		return ret;
 	}
 	return mv_cesa_ablkcipher_std_process(ablkreq, status);
@@ -164,8 +164,8 @@ static void mv_cesa_ablkcipher_step(struct crypto_async_request *req)
 	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
 
-	if (creq->req.base.type == CESA_DMA_REQ)
-		mv_cesa_dma_step(&creq->req.dma);
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->req.base);
 	else
 		mv_cesa_ablkcipher_std_step(ablkreq);
 }
@@ -174,9 +174,9 @@ static inline void
 mv_cesa_ablkcipher_dma_prepare(struct ablkcipher_request *req)
 {
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
-	struct mv_cesa_tdma_req *dreq = &creq->req.dma;
+	struct mv_cesa_req *dreq = &creq->req.base;
 
-	mv_cesa_dma_prepare(dreq, dreq->base.engine);
+	mv_cesa_dma_prepare(dreq, dreq->engine);
 }
 
 static inline void
@@ -199,7 +199,7 @@ static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
 	creq->req.base.engine = engine;
 
-	if (creq->req.base.type == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		mv_cesa_ablkcipher_dma_prepare(ablkreq);
 	else
 		mv_cesa_ablkcipher_std_prepare(ablkreq);
@@ -302,14 +302,13 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
-	struct mv_cesa_tdma_req *dreq = &creq->req.dma;
+	struct mv_cesa_req *dreq = &creq->req.base;
 	struct mv_cesa_ablkcipher_dma_iter iter;
 	struct mv_cesa_tdma_chain chain;
 	bool skip_ctx = false;
 	int ret;
 	unsigned int ivsize;
 
-	dreq->base.type = CESA_DMA_REQ;
 	dreq->chain.first = NULL;
 	dreq->chain.last = NULL;
 
@@ -397,10 +396,12 @@ mv_cesa_ablkcipher_std_req_init(struct ablkcipher_request *req,
 {
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
+	struct mv_cesa_req *basereq = &creq->req.base;
 
-	sreq->base.type = CESA_STD_REQ;
 	sreq->op = *op_templ;
 	sreq->skip_ctx = false;
+	basereq->chain.first = NULL;
+	basereq->chain.last = NULL;
 
 	return 0;
 }
@@ -442,6 +443,7 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
 static int mv_cesa_des_op(struct ablkcipher_request *req,
 			  struct mv_cesa_op_ctx *tmpl)
 {
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	int ret;
 
@@ -454,7 +456,7 @@ static int mv_cesa_des_op(struct ablkcipher_request *req,
 	if (ret)
 		return ret;
 
-	ret = mv_cesa_queue_req(&req->base);
+	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ablkcipher_cleanup(req);
 
@@ -562,6 +564,7 @@ struct crypto_alg mv_cesa_cbc_des_alg = {
 static int mv_cesa_des3_op(struct ablkcipher_request *req,
 			   struct mv_cesa_op_ctx *tmpl)
 {
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_des3_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	int ret;
 
@@ -574,7 +577,7 @@ static int mv_cesa_des3_op(struct ablkcipher_request *req,
 	if (ret)
 		return ret;
 
-	ret = mv_cesa_queue_req(&req->base);
+	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ablkcipher_cleanup(req);
 
@@ -688,6 +691,7 @@ struct crypto_alg mv_cesa_cbc_des3_ede_alg = {
 static int mv_cesa_aes_op(struct ablkcipher_request *req,
 			  struct mv_cesa_op_ctx *tmpl)
 {
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	int ret, i;
 	u32 *key;
@@ -716,7 +720,7 @@ static int mv_cesa_aes_op(struct ablkcipher_request *req,
 	if (ret)
 		return ret;
 
-	ret = mv_cesa_queue_req(&req->base);
+	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ablkcipher_cleanup(req);
 
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 0fae351..cc7c5b0 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -103,14 +103,14 @@ static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
 
 	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
 	mv_cesa_ahash_dma_free_cache(&creq->req.dma);
-	mv_cesa_dma_cleanup(&creq->req.dma.base);
+	mv_cesa_dma_cleanup(&creq->req.base);
 }
 
 static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 
-	if (creq->req.base.type == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		mv_cesa_ahash_dma_cleanup(req);
 }
 
@@ -118,7 +118,7 @@ static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 
-	if (creq->req.base.type == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		mv_cesa_ahash_dma_last_cleanup(req);
 }
 
@@ -256,9 +256,9 @@ static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 status)
 static inline void mv_cesa_ahash_dma_prepare(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_tdma_req *dreq = &creq->req.dma.base;
+	struct mv_cesa_req *dreq = &creq->req.base;
 
-	mv_cesa_dma_prepare(dreq, dreq->base.engine);
+	mv_cesa_dma_prepare(dreq, dreq->engine);
 }
 
 static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
@@ -277,8 +277,8 @@ static void mv_cesa_ahash_step(struct crypto_async_request *req)
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
 
-	if (creq->req.base.type == CESA_DMA_REQ)
-		mv_cesa_dma_step(&creq->req.dma.base);
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->req.base);
 	else
 		mv_cesa_ahash_std_step(ahashreq);
 }
@@ -291,8 +291,8 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 	unsigned int digsize;
 	int ret, i;
 
-	if (creq->req.base.type == CESA_DMA_REQ)
-		ret = mv_cesa_dma_process(&creq->req.dma.base, status);
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
+		ret = mv_cesa_dma_process(&creq->req.base, status);
 	else
 		ret = mv_cesa_ahash_std_process(ahashreq, status);
 
@@ -340,7 +340,7 @@ static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
 
 	creq->req.base.engine = engine;
 
-	if (creq->req.base.type == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		mv_cesa_ahash_dma_prepare(ahashreq);
 	else
 		mv_cesa_ahash_std_prepare(ahashreq);
@@ -555,8 +555,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
-	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
-	struct mv_cesa_tdma_req *dreq = &ahashdreq->base;
+	struct mv_cesa_req *dreq = &creq->req.base;
 	struct mv_cesa_ahash_dma_iter iter;
 	struct mv_cesa_op_ctx *op = NULL;
 	unsigned int frag_len;
@@ -662,11 +661,6 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	int ret;
 
-	if (cesa_dev->caps->has_tdma)
-		creq->req.base.type = CESA_DMA_REQ;
-	else
-		creq->req.base.type = CESA_STD_REQ;
-
 	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (creq->src_nents < 0) {
 		dev_err(cesa_dev->dev, "Invalid number of src SG");
@@ -680,7 +674,7 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
 	if (*cached)
 		return 0;
 
-	if (creq->req.base.type == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		ret = mv_cesa_ahash_dma_req_init(req);
 
 	return ret;
@@ -700,7 +694,7 @@ static int mv_cesa_ahash_update(struct ahash_request *req)
 	if (cached)
 		return 0;
 
-	ret = mv_cesa_queue_req(&req->base);
+	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ahash_cleanup(req);
 
@@ -725,7 +719,7 @@ static int mv_cesa_ahash_final(struct ahash_request *req)
 	if (cached)
 		return 0;
 
-	ret = mv_cesa_queue_req(&req->base);
+	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ahash_cleanup(req);
 
@@ -750,7 +744,7 @@ static int mv_cesa_ahash_finup(struct ahash_request *req)
 	if (cached)
 		return 0;
 
-	ret = mv_cesa_queue_req(&req->base);
+	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ahash_cleanup(req);
 
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 88c87be..9a424f9 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -37,9 +37,9 @@ bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *iter,
 	return true;
 }
 
-void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
+void mv_cesa_dma_step(struct mv_cesa_req *dreq)
 {
-	struct mv_cesa_engine *engine = dreq->base.engine;
+	struct mv_cesa_engine *engine = dreq->engine;
 
 	writel_relaxed(0, engine->regs + CESA_SA_CFG);
 
@@ -58,7 +58,7 @@ void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
-void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq)
+void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq)
 {
 	struct mv_cesa_tdma_desc *tdma;
 
@@ -81,7 +81,7 @@ void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq)
 	dreq->chain.last = NULL;
 }
 
-void mv_cesa_dma_prepare(struct mv_cesa_tdma_req *dreq,
+void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 			 struct mv_cesa_engine *engine)
 {
 	struct mv_cesa_tdma_desc *tdma;
-- 
2.7.4
