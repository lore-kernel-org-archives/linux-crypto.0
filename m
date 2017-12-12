From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 11/24] staging: ccree: remove cipher sync blkcipher remains
Date: Tue, 12 Dec 2017 14:52:57 +0000
Message-ID: <1513090395-7938-12-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Remove the remains of no longer existing support for running
blkcipher is sync mode.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 156 ++++++++++++-------------------------
 1 file changed, 51 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 7b484f1..0dc63f1 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -180,7 +180,7 @@ static unsigned int get_max_keysize(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int ssi_blkcipher_init(struct crypto_tfm *tfm)
+static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
 {
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct crypto_alg *alg = tfm->__crt_alg;
@@ -189,10 +189,13 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	struct device *dev = drvdata_to_dev(ssi_alg->drvdata);
 	int rc = 0;
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
+	struct ablkcipher_tfm *ablktfm = &tfm->crt_ablkcipher;
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
 		crypto_tfm_alg_name(tfm));
 
+	ablktfm->reqsize = sizeof(struct blkcipher_req_ctx);
+
 	ctx_p->cipher_mode = ssi_alg->cipher_mode;
 	ctx_p->flow_mode = ssi_alg->flow_mode;
 	ctx_p->drvdata = ssi_alg->drvdata;
@@ -297,10 +300,10 @@ static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
 	return END_OF_KEYS;
 }
 
-static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
-				const u8 *key,
+static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 				unsigned int keylen)
 {
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(atfm);
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	u32 tmp[DES_EXPKEY_WORDS];
@@ -700,62 +703,59 @@ ssi_blkcipher_create_data_desc(
 	}
 }
 
-static int ssi_blkcipher_complete(struct device *dev,
-				  struct ssi_ablkcipher_ctx *ctx_p,
-				  struct blkcipher_req_ctx *req_ctx,
-				  struct scatterlist *dst,
-				  struct scatterlist *src,
-				  unsigned int ivsize,
-				  void *areq)
+static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req)
 {
+	struct ablkcipher_request *areq = (struct ablkcipher_request *)ssi_req;
+	struct scatterlist *dst = areq->dst;
+	struct scatterlist *src = areq->src;
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
 	int completion_error = 0;
 	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
 
 	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 	kfree(req_ctx->iv);
 
-	if (areq) {
-		/*
-		 * The crypto API expects us to set the req->info to the last
-		 * ciphertext block. For encrypt, simply copy from the result.
-		 * For decrypt, we must copy from a saved buffer since this
-		 * could be an in-place decryption operation and the src is
-		 * lost by this point.
-		 */
-		if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
-			memcpy(req->info, req_ctx->backup_info, ivsize);
-			kfree(req_ctx->backup_info);
-		} else {
-			scatterwalk_map_and_copy(req->info, req->dst,
-						 (req->nbytes - ivsize),
-						 ivsize, 0);
-		}
-
-		ablkcipher_request_complete(areq, completion_error);
-		return 0;
+	/*
+	 * The crypto API expects us to set the req->info to the last
+	 * ciphertext block. For encrypt, simply copy from the result.
+	 * For decrypt, we must copy from a saved buffer since this
+	 * could be an in-place decryption operation and the src is
+	 * lost by this point.
+	 */
+	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
+		memcpy(req->info, req_ctx->backup_info, ivsize);
+		kfree(req_ctx->backup_info);
+	} else {
+		scatterwalk_map_and_copy(req->info, req->dst,
+					 (req->nbytes - ivsize),
+					 ivsize, 0);
 	}
-	return completion_error;
+
+	ablkcipher_request_complete(areq, completion_error);
 }
 
-static int ssi_blkcipher_process(
-	struct crypto_tfm *tfm,
-	struct blkcipher_req_ctx *req_ctx,
-	struct scatterlist *dst, struct scatterlist *src,
-	unsigned int nbytes,
-	void *info, //req info
-	unsigned int ivsize,
-	void *areq,
-	enum drv_crypto_direction direction)
+static int cc_cipher_process(struct ablkcipher_request *req,
+			     enum drv_crypto_direction direction)
 {
+	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
+	struct scatterlist *dst = req->dst;
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	void *info = req->info;
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct ssi_crypto_req ssi_req = {};
 	int rc, seq_len = 0, cts_restore_flag = 0;
 
-	dev_dbg(dev, "%s areq=%p info=%p nbytes=%d\n",
+	dev_dbg(dev, "%s req=%p info=%p nbytes=%d\n",
 		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-		"Encrypt" : "Decrypt"), areq, info, nbytes);
+		"Encrypt" : "Decrypt"), req, info, nbytes);
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
@@ -791,7 +791,7 @@ static int ssi_blkcipher_process(
 
 	/* Setup DX request structure */
 	ssi_req.user_cb = (void *)ssi_ablkcipher_complete;
-	ssi_req.user_arg = (void *)areq;
+	ssi_req.user_arg = (void *)req;
 
 #ifdef ENABLE_CYCLE_COUNT
 	ssi_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
@@ -823,7 +823,7 @@ static int ssi_blkcipher_process(
 		ssi_blkcipher_create_setup_desc(tfm, req_ctx, ivsize, nbytes,
 						desc, &seq_len);
 	/* Data processing */
-	ssi_blkcipher_create_data_desc(tfm, req_ctx, dst, src, nbytes, areq,
+	ssi_blkcipher_create_data_desc(tfm, req_ctx, dst, src, nbytes, req,
 				       desc, &seq_len);
 
 	/* do we need to generate IV? */
@@ -836,25 +836,12 @@ static int ssi_blkcipher_process(
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len,
-			  (!areq) ? 0 : 1);
-	if (areq) {
-		if (rc != -EINPROGRESS) {
-			/* Failed to send the request or request completed
-			 * synchronously
-			 */
-			cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src,
-						   dst);
-		}
-
-	} else {
-		if (rc) {
-			cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src,
-						   dst);
-		} else {
-			rc = ssi_blkcipher_complete(dev, ctx_p, req_ctx, dst,
-						    src, ivsize, NULL);
-		}
+	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, 1);
+	if (rc != -EINPROGRESS) {
+		/* Failed to send the request or request completed
+		 * synchronously
+		 */
+		cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 	}
 
 exit_process:
@@ -869,56 +856,19 @@ static int ssi_blkcipher_process(
 	return rc;
 }
 
-static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req)
-{
-	struct ablkcipher_request *areq = (struct ablkcipher_request *)ssi_req;
-	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_ablkcipher_ctx(tfm);
-	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
-
-	ssi_blkcipher_complete(dev, ctx_p, req_ctx, areq->dst, areq->src,
-			       ivsize, areq);
-}
-
-/* Async wrap functions */
-
-static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
-{
-	struct ablkcipher_tfm *ablktfm = &tfm->crt_ablkcipher;
-
-	ablktfm->reqsize = sizeof(struct blkcipher_req_ctx);
-
-	return ssi_blkcipher_init(tfm);
-}
-
-static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
-				 const u8 *key,
-				 unsigned int keylen)
-{
-	return ssi_blkcipher_setkey(crypto_ablkcipher_tfm(tfm), key, keylen);
-}
-
 static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
-	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
-	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
 	req_ctx->is_giv = false;
 	req_ctx->backup_info = NULL;
 
-	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
-				     req->nbytes, req->info, ivsize,
-				     (void *)req,
-				     DRV_CRYPTO_DIRECTION_ENCRYPT);
+	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 }
 
 static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
@@ -934,15 +884,11 @@ static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
 				 (req->nbytes - ivsize), ivsize, 0);
 	req_ctx->is_giv = false;
 
-	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
-				     req->nbytes, req->info, ivsize,
-				     (void *)req,
-				     DRV_CRYPTO_DIRECTION_DECRYPT);
+	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 }
 
 /* DX Block cipher alg */
 static struct ssi_alg_template blkcipher_algs[] = {
-/* Async template */
 #if SSI_CC_HAS_AES_XTS
 	{
 		.name = "xts(aes)",
-- 
2.7.4
