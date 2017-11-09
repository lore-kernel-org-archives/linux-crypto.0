From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 10/10] staging: ccree: remove unused cc_base parameter
Date: Thu,  9 Nov 2017 09:16:18 +0000
Message-ID: <1510218980-3549-11-git-send-email-gilad@benyossef.com>
References: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove a common parameter named cc_base with the pointer
to the mapped command registers which was used by the
old register access macros that are not longer in use.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  2 +-
 drivers/staging/ccree/ssi_cipher.c      | 12 +++++-------
 drivers/staging/ccree/ssi_driver.c      |  3 ---
 drivers/staging/ccree/ssi_driver.h      |  2 +-
 drivers/staging/ccree/ssi_hash.c        |  6 +++---
 drivers/staging/ccree/ssi_request_mgr.c |  5 ++---
 6 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index e036168..9e24783 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -225,7 +225,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	return -ENOMEM;
 }
 
-static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_aead_complete(struct device *dev, void *ssi_req)
 {
 	struct aead_request *areq = (struct aead_request *)ssi_req;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 4d05b4a..b5bb97c 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -67,7 +67,7 @@ struct ssi_ablkcipher_ctx {
 	struct crypto_shash *shash_tfm;
 };
 
-static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base);
+static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req);
 
 static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
 {
@@ -688,8 +688,7 @@ static int ssi_blkcipher_complete(struct device *dev,
 				  struct scatterlist *dst,
 				  struct scatterlist *src,
 				  unsigned int ivsize,
-				  void *areq,
-				  void __iomem *cc_base)
+				  void *areq)
 {
 	int completion_error = 0;
 	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
@@ -832,8 +831,7 @@ static int ssi_blkcipher_process(
 						   dst);
 		} else {
 			rc = ssi_blkcipher_complete(dev, ctx_p, req_ctx, dst,
-						    src, ivsize, NULL,
-						    ctx_p->drvdata->cc_base);
+						    src, ivsize, NULL);
 		}
 	}
 
@@ -849,7 +847,7 @@ static int ssi_blkcipher_process(
 	return rc;
 }
 
-static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req)
 {
 	struct ablkcipher_request *areq = (struct ablkcipher_request *)ssi_req;
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
@@ -858,7 +856,7 @@ static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __io
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
 
 	ssi_blkcipher_complete(dev, ctx_p, req_ctx, areq->dst, areq->src,
-			       ivsize, areq, cc_base);
+			       ivsize, areq);
 }
 
 /* Async wrap functions */
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 7b77f3f..0d5c1a9 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -199,7 +199,6 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 static int init_cc_resources(struct platform_device *plat_dev)
 {
 	struct resource *req_mem_cc_regs = NULL;
-	void __iomem *cc_base = NULL;
 	struct ssi_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
@@ -232,8 +231,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
 		&req_mem_cc_regs->start, new_drvdata->cc_base);
 
-	cc_base = new_drvdata->cc_base;
-
 	/* Then IRQ */
 	new_drvdata->irq = platform_get_irq(plat_dev, 0);
 	if (new_drvdata->irq < 0) {
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 94c755c..f4967ca 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -100,7 +100,7 @@
 
 #define SSI_MAX_IVGEN_DMA_ADDRESSES	3
 struct ssi_crypto_req {
-	void (*user_cb)(struct device *dev, void *req, void __iomem *cc_base);
+	void (*user_cb)(struct device *dev, void *req);
 	void *user_arg;
 	dma_addr_t ivgen_dma_addr[SSI_MAX_IVGEN_DMA_ADDRESSES];
 	/* For the first 'ivgen_dma_addr_len' addresses of this array,
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 5485372..472d3b7 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -357,7 +357,7 @@ static void ssi_hash_unmap_result(struct device *dev,
 	state->digest_result_dma_addr = 0;
 }
 
-static void ssi_hash_update_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_hash_update_complete(struct device *dev, void *ssi_req)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -368,7 +368,7 @@ static void ssi_hash_update_complete(struct device *dev, void *ssi_req, void __i
 	req->base.complete(&req->base, 0);
 }
 
-static void ssi_hash_digest_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_hash_digest_complete(struct device *dev, void *ssi_req)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -384,7 +384,7 @@ static void ssi_hash_digest_complete(struct device *dev, void *ssi_req, void __i
 	req->base.complete(&req->base, 0);
 }
 
-static void ssi_hash_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_hash_complete(struct device *dev, void *ssi_req)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 8fa3fc1..e9a09b3 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -189,7 +189,7 @@ static inline void enqueue_seq(
  * \param dev
  * \param dx_compl_h The completion event to signal
  */
-static void request_mgr_complete(struct device *dev, void *dx_compl_h, void __iomem *cc_base)
+static void request_mgr_complete(struct device *dev, void *dx_compl_h)
 {
 	struct completion *this_compl = dx_compl_h;
 
@@ -491,8 +491,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 #endif /* COMPLETION_DELAY */
 
 		if (likely(ssi_req->user_cb))
-			ssi_req->user_cb(dev, ssi_req->user_arg,
-					 drvdata->cc_base);
+			ssi_req->user_cb(dev, ssi_req->user_arg);
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		dev_dbg(dev, "Dequeue request tail=%u\n",
 			request_mgr_handle->req_queue_tail);
-- 
2.7.4
