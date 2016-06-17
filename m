From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 07/10] crypto: marvell: Move SRAM I/O operations to step functions
Date: Fri, 17 Jun 2016 13:24:06 +0200
Message-ID: <1466162649-29911-8-git-send-email-romain.perier@free-electrons.com>
References: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47991 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbcFQLYg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 07:24:36 -0400
In-Reply-To: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently the crypto requests were sent to engines sequentially.
This commit moves the SRAM I/O operations from the prepare to the step
functions. It provides flexibility for future works and allow to prepare
a request while the engine is running.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cipher.c |  6 +++---
 drivers/crypto/marvell/hash.c   | 18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 175ce76..79d4175 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -89,6 +89,9 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
 	size_t  len = min_t(size_t, req->nbytes - sreq->offset,
 			    CESA_SA_SRAM_PAYLOAD_SIZE);
 
+	mv_cesa_adjust_op(engine, &sreq->op);
+	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
+
 	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
 				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
 				 len, sreq->offset);
@@ -177,12 +180,9 @@ mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
 {
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_ablkcipher_std_req *sreq = &creq->std;
-	struct mv_cesa_engine *engine = creq->base.engine;
 
 	sreq->size = 0;
 	sreq->offset = 0;
-	mv_cesa_adjust_op(engine, &sreq->op);
-	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
 }
 
 static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 09665a7..e1f8acd 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -162,6 +162,15 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	unsigned int new_cache_ptr = 0;
 	u32 frag_mode;
 	size_t  len;
+	unsigned int digsize;
+	int i;
+
+	mv_cesa_adjust_op(engine, &creq->op_tmpl);
+	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+
+	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	for (i = 0; i < digsize / 4; i++)
+		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 
 	if (creq->cache_ptr)
 		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
@@ -265,11 +274,8 @@ static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
-	struct mv_cesa_engine *engine = creq->base.engine;
 
 	sreq->offset = 0;
-	mv_cesa_adjust_op(engine, &creq->op_tmpl);
-	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
 }
 
 static void mv_cesa_ahash_step(struct crypto_async_request *req)
@@ -336,8 +342,6 @@ static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
 {
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-	unsigned int digsize;
-	int i;
 
 	creq->base.engine = engine;
 
@@ -345,10 +349,6 @@ static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
 		mv_cesa_ahash_dma_prepare(ahashreq);
 	else
 		mv_cesa_ahash_std_prepare(ahashreq);
-
-	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
-	for (i = 0; i < digsize / 4; i++)
-		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 }
 
 static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
-- 
2.7.4
