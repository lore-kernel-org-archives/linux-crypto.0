From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2] crypto: marvell - Copy IVDIG before launching partial DMA ahash requests
Date: Wed, 14 Dec 2016 15:15:07 +0100
Message-ID: <20161214141507.19105-1-romain.perier@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>, radioconfusion@gmail.com,
        Romain Perier <romain.perier@free-electrons.com>,
        stable@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53021 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753481AbcLNOQh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 09:16:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, inner IV/DIGEST data are only copied once into the hash
engines and not set explicitly before launching a request that is not a
first frag. This is an issue especially when multiple ahash reqs are
computed in parallel or chained with cipher request, as the state of the
request being computed is not updated into the hash engine. It leads to
non-deterministic corrupted digest results.

Fixes: commit 2786cee8e50b ("crypto: marvell - Move SRAM I/O operations to step functions")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: <stable@vger.kernel.org>
---

Changes in v2:
 - Moved the code from mv_cesa_ahash_step() to mv_cesa_ahash_dma_step() (create
   a new static function)
 - Fixed warnings with checkpatch in strict mode
 - Added tag 'Acked-by' by Boris
 - Cosmetic changes

 drivers/crypto/marvell/cesa.h |  3 ++-
 drivers/crypto/marvell/hash.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/crypto/marvell/tdma.c |  9 ++++++++-
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index a768da7..b7872f6 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -273,7 +273,8 @@ struct mv_cesa_op_ctx {
 #define CESA_TDMA_SRC_IN_SRAM			BIT(30)
 #define CESA_TDMA_END_OF_REQ			BIT(29)
 #define CESA_TDMA_BREAK_CHAIN			BIT(28)
-#define CESA_TDMA_TYPE_MSK			GENMASK(27, 0)
+#define CESA_TDMA_SET_STATE			BIT(27)
+#define CESA_TDMA_TYPE_MSK			GENMASK(26, 0)
 #define CESA_TDMA_DUMMY				0
 #define CESA_TDMA_DATA				1
 #define CESA_TDMA_OP				2
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 317cf02..77c0fb9 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -280,13 +280,32 @@ static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
 	sreq->offset = 0;
 }
 
+static void mv_cesa_ahash_dma_step(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_req *base = &creq->base;
+
+	/* We must explicitly set the digest state. */
+	if (base->chain.first->flags & CESA_TDMA_SET_STATE) {
+		struct mv_cesa_engine *engine = base->engine;
+		int i;
+
+		/* Set the hash state in the IVDIG regs. */
+		for (i = 0; i < ARRAY_SIZE(creq->state); i++)
+			writel_relaxed(creq->state[i], engine->regs +
+				       CESA_IVDIG(i));
+	}
+
+	mv_cesa_dma_step(base);
+}
+
 static void mv_cesa_ahash_step(struct crypto_async_request *req)
 {
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_dma_step(&creq->base);
+		mv_cesa_ahash_dma_step(ahashreq);
 	else
 		mv_cesa_ahash_std_step(ahashreq);
 }
@@ -584,12 +603,16 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	struct mv_cesa_ahash_dma_iter iter;
 	struct mv_cesa_op_ctx *op = NULL;
 	unsigned int frag_len;
+	bool set_state = false;
 	int ret;
 	u32 type;
 
 	basereq->chain.first = NULL;
 	basereq->chain.last = NULL;
 
+	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
+		set_state = true;
+
 	if (creq->src_nents) {
 		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
 				 DMA_TO_DEVICE);
@@ -683,6 +706,15 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (type != CESA_TDMA_RESULT)
 		basereq->chain.last->flags |= CESA_TDMA_BREAK_CHAIN;
 
+	if (set_state) {
+		/*
+		 * Put the CESA_TDMA_SET_STATE flag on the first tdma desc to
+		 * let the step logic know that the IVDIG registers should be
+		 * explicitly set before launching a TDMA chain.
+		 */
+		basereq->chain.first->flags |= CESA_TDMA_SET_STATE;
+	}
+
 	return 0;
 
 err_free_tdma:
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 4416b88..c76375f 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -109,7 +109,14 @@ void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 		last->next = dreq->chain.first;
 		engine->chain.last = dreq->chain.last;
 
-		if (!(last->flags & CESA_TDMA_BREAK_CHAIN))
+		/*
+		 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
+		 * the last element of the current chain, or if the request
+		 * being queued needs the IV regs to be set before lauching
+		 * the request.
+		 */
+		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
+		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
 			last->next_dma = dreq->chain.first->cur_dma;
 	}
 }
-- 
2.9.3
