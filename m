From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 06/10] crypto: marvell: Add a complete operation for async
 requests
Date: Tue, 21 Jun 2016 10:08:36 +0200
Message-ID: <1466496520-28806-7-git-send-email-romain.perier@free-electrons.com>
References: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Russell King <linux@arm.linux.org.uk>, linux-crypto@vger.kernel.org,
 Gregory Clement <gregory.clement@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
 Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

So far, the 'process' operation was used to check if the current request
was correctly handled by the engine, if it was the case it copied
information from the SRAM to the main memory. Now, we split this
operation. We keep the 'process' operation, which still checks if the
request was correctly handled by the engine or not, then we add a new
operation for completion. The 'complete' method copies the content of
the SRAM to memory. This will soon become useful if we want to call
the process and the complete operations from different locations
depending on the type of the request (different cleanup logic).

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---

Changes in v3:
  - Fixed comment for the "complete" field in mv_cesa_req_ops.

Changes in v2:

  - Removed useless cosmetic change added for checkpatch (which
    had nothing to do with the patch itself)
  - Removed duplicated initialization of 'ivsize'
    mv_cesa_ablkcipher_complete.
  - Replace memcpy_fromio by memcpy in mv_cesa_ablkcipher_complete

 drivers/crypto/marvell/cesa.c   |  1 +
 drivers/crypto/marvell/cesa.h   |  3 +++
 drivers/crypto/marvell/cipher.c | 28 +++++++++++++++++++++++-----
 drivers/crypto/marvell/hash.c   | 22 ++++++++++++----------
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index fe04d1b..af96426 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -98,6 +98,7 @@ static irqreturn_t mv_cesa_int(int irq, void *priv)
 				engine->req = NULL;
 				mv_cesa_dequeue_req_unlocked(engine);
 				spin_unlock_bh(&engine->lock);
+				ctx->ops->complete(req);
 				ctx->ops->cleanup(req);
 				local_bh_disable();
 				req->complete(req, res);
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index e67e3f1..d749335 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -456,6 +456,8 @@ struct mv_cesa_engine {
  *		code)
  * @step:	launch the crypto operation on the next chunk
  * @cleanup:	cleanup the crypto request (release associated data)
+ * @complete:	complete the request, i.e copy result or context from sram when
+ * 		needed.
  */
 struct mv_cesa_req_ops {
 	void (*prepare)(struct crypto_async_request *req,
@@ -463,6 +465,7 @@ struct mv_cesa_req_ops {
 	int (*process)(struct crypto_async_request *req, u32 status);
 	void (*step)(struct crypto_async_request *req);
 	void (*cleanup)(struct crypto_async_request *req);
+	void (*complete)(struct crypto_async_request *req);
 };
 
 /**
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index ffe0f4a..175ce76 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -118,7 +118,6 @@ static int mv_cesa_ablkcipher_std_process(struct ablkcipher_request *req,
 	struct mv_cesa_ablkcipher_std_req *sreq = &creq->std;
 	struct mv_cesa_engine *engine = creq->base.engine;
 	size_t len;
-	unsigned int ivsize;
 
 	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
 				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
@@ -128,10 +127,6 @@ static int mv_cesa_ablkcipher_std_process(struct ablkcipher_request *req,
 	if (sreq->offset < req->nbytes)
 		return -EINPROGRESS;
 
-	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
-	memcpy_fromio(req->info,
-		      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET, ivsize);
-
 	return 0;
 }
 
@@ -211,11 +206,34 @@ mv_cesa_ablkcipher_req_cleanup(struct crypto_async_request *req)
 	mv_cesa_ablkcipher_cleanup(ablkreq);
 }
 
+static void
+mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
+{
+	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
+	struct mv_cesa_engine *engine = creq->base.engine;
+	unsigned int ivsize;
+
+	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
+		struct mv_cesa_req *basereq;
+
+		basereq = &creq->base;
+		memcpy(ablkreq->info, basereq->chain.last->data, ivsize);
+	} else {
+		memcpy_fromio(ablkreq->info,
+			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
+			      ivsize);
+	}
+}
+
 static const struct mv_cesa_req_ops mv_cesa_ablkcipher_req_ops = {
 	.step = mv_cesa_ablkcipher_step,
 	.process = mv_cesa_ablkcipher_process,
 	.prepare = mv_cesa_ablkcipher_prepare,
 	.cleanup = mv_cesa_ablkcipher_req_cleanup,
+	.complete = mv_cesa_ablkcipher_complete,
 };
 
 static int mv_cesa_ablkcipher_cra_init(struct crypto_tfm *tfm)
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 21a4737..09665a7 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -287,17 +287,20 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 {
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-	struct mv_cesa_engine *engine = creq->base.engine;
-	unsigned int digsize;
-	int ret, i;
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		ret = mv_cesa_dma_process(&creq->base, status);
-	else
-		ret = mv_cesa_ahash_std_process(ahashreq, status);
+		return mv_cesa_dma_process(&creq->base, status);
 
-	if (ret == -EINPROGRESS)
-		return ret;
+	return mv_cesa_ahash_std_process(ahashreq, status);
+}
+
+static void mv_cesa_ahash_complete(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+	struct mv_cesa_engine *engine = creq->base.engine;
+	unsigned int digsize;
+	int i;
 
 	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
 	for (i = 0; i < digsize / 4; i++)
@@ -326,8 +329,6 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 				result[i] = cpu_to_be32(creq->state[i]);
 		}
 	}
-
-	return ret;
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
@@ -366,6 +367,7 @@ static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
 	.process = mv_cesa_ahash_process,
 	.prepare = mv_cesa_ahash_prepare,
 	.cleanup = mv_cesa_ahash_req_cleanup,
+	.complete = mv_cesa_ahash_complete,
 };
 
 static int mv_cesa_ahash_init(struct ahash_request *req,
-- 
2.7.4
