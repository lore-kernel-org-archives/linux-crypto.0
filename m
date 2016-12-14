From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell - Copy IVDIG before launching partial DMA ahash requests
Date: Wed, 14 Dec 2016 14:17:37 +0100
Message-ID: <20161214131737.3884-1-romain.perier@free-electrons.com>
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
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, inner IV/DIGEST data are only copied once into the hash
engines and not set explicitly before launching a request that is not a
first frag. This is an issue especially when multiple ahash reqs are
computed in parallel or chained with cipher request, as the state of the
request being computed is not updated into the hash engine. It leads to
non-deterministic corrupted digest results.

Fixes: commit 2786cee8e50b ("crypto: marvell - Move SRAM I/O operat...")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Cc: <stable@vger.kernel.org>
---
 drivers/crypto/marvell/cesa.h |  3 ++-
 drivers/crypto/marvell/hash.c | 29 ++++++++++++++++++++++++++++-
 drivers/crypto/marvell/tdma.c |  9 ++++++++-
 3 files changed, 38 insertions(+), 3 deletions(-)

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
index 317cf02..4eb4564 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -285,8 +285,21 @@ static void mv_cesa_ahash_step(struct crypto_async_request *req)
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
 
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
+
+		/* We must explicitely set the digest state. */
+		if (creq->base.chain.first->flags & CESA_TDMA_SET_STATE) {
+			struct mv_cesa_engine *engine = creq->base.engine;
+			int i;
+
+			/* Set the hash state in the IVDIG regs. */
+			for (i = 0; i < ARRAY_SIZE(creq->state); i++)
+				writel_relaxed(creq->state[i], engine->regs +
+					       CESA_IVDIG(i));
+		}
+
 		mv_cesa_dma_step(&creq->base);
+	}
 	else
 		mv_cesa_ahash_std_step(ahashreq);
 }
@@ -586,10 +599,14 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	unsigned int frag_len;
 	int ret;
 	u32 type;
+	bool set_state = false;
 
 	basereq->chain.first = NULL;
 	basereq->chain.last = NULL;
 
+	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
+		set_state = true;
+
 	if (creq->src_nents) {
 		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
 				 DMA_TO_DEVICE);
@@ -683,6 +700,16 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (type != CESA_TDMA_RESULT)
 		basereq->chain.last->flags |= CESA_TDMA_BREAK_CHAIN;
 
+	if (set_state) {
+
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
