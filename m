From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 20/24] staging: ccree: rename vars/structs/enums from ssi_ to
 cc_
Date: Tue, 12 Dec 2017 14:53:06 +0000
Message-ID: <1513090395-7938-21-git-send-email-gilad@benyossef.com>
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

Unify naming convention by renaming all ssi_ vars/structs/enums
and variables to cc_*

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  82 +++++++++----------
 drivers/staging/ccree/ssi_aead.h        |  14 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  |  30 +++----
 drivers/staging/ccree/ssi_buffer_mgr.h  |  22 +++---
 drivers/staging/ccree/ssi_cipher.c      |  72 ++++++++---------
 drivers/staging/ccree/ssi_cipher.h      |   6 +-
 drivers/staging/ccree/ssi_driver.c      |  16 ++--
 drivers/staging/ccree/ssi_driver.h      |  30 +++----
 drivers/staging/ccree/ssi_fips.c        |  20 ++---
 drivers/staging/ccree/ssi_fips.h        |  16 ++--
 drivers/staging/ccree/ssi_hash.c        | 136 ++++++++++++++++----------------
 drivers/staging/ccree/ssi_hash.h        |  12 +--
 drivers/staging/ccree/ssi_ivgen.c       |  14 ++--
 drivers/staging/ccree/ssi_ivgen.h       |   8 +-
 drivers/staging/ccree/ssi_pm.c          |  12 +--
 drivers/staging/ccree/ssi_pm.h          |   4 +-
 drivers/staging/ccree/ssi_request_mgr.c |  70 ++++++++--------
 drivers/staging/ccree/ssi_request_mgr.h |  18 ++---
 drivers/staging/ccree/ssi_sram_mgr.c    |  12 +--
 drivers/staging/ccree/ssi_sram_mgr.h    |  14 ++--
 drivers/staging/ccree/ssi_sysfs.c       |  12 +--
 drivers/staging/ccree/ssi_sysfs.h       |   4 +-
 22 files changed, 312 insertions(+), 312 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index d07b38d..73ae970 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -52,7 +52,7 @@
 #define ICV_VERIF_OK 0x01
 
 struct cc_aead_handle {
-	ssi_sram_addr_t sram_workspace_addr;
+	cc_sram_addr_t sram_workspace_addr;
 	struct list_head aead_list;
 };
 
@@ -69,7 +69,7 @@ struct cc_xcbc_s {
 };
 
 struct cc_aead_ctx {
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 	u8 ctr_nonce[MAX_NONCE_SIZE]; /* used for ctr3686 iv and aes ccm */
 	u8 *enckey;
 	dma_addr_t enckey_dma_addr;
@@ -148,18 +148,18 @@ static int cc_aead_init(struct crypto_aead *tfm)
 {
 	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct ssi_crypto_alg *ssi_alg =
-			container_of(alg, struct ssi_crypto_alg, aead_alg);
-	struct device *dev = drvdata_to_dev(ssi_alg->drvdata);
+	struct cc_crypto_alg *cc_alg =
+			container_of(alg, struct cc_crypto_alg, aead_alg);
+	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx,
 		crypto_tfm_alg_name(&tfm->base));
 
 	/* Initialize modes in instance */
-	ctx->cipher_mode = ssi_alg->cipher_mode;
-	ctx->flow_mode = ssi_alg->flow_mode;
-	ctx->auth_mode = ssi_alg->auth_mode;
-	ctx->drvdata = ssi_alg->drvdata;
+	ctx->cipher_mode = cc_alg->cipher_mode;
+	ctx->flow_mode = cc_alg->flow_mode;
+	ctx->auth_mode = cc_alg->auth_mode;
+	ctx->drvdata = cc_alg->drvdata;
 	crypto_aead_set_reqsize(tfm, sizeof(struct aead_req_ctx));
 
 	/* Allocate key buffer, cache line aligned */
@@ -226,11 +226,11 @@ static int cc_aead_init(struct crypto_aead *tfm)
 	return -ENOMEM;
 }
 
-static void cc_aead_complete(struct device *dev, void *ssi_req)
+static void cc_aead_complete(struct device *dev, void *cc_req)
 {
-	struct aead_request *areq = (struct aead_request *)ssi_req;
+	struct aead_request *areq = (struct aead_request *)cc_req;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	struct crypto_aead *tfm = crypto_aead_reqtfm(ssi_req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(cc_req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int err = 0;
 
@@ -442,7 +442,7 @@ cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	u32 larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->auth_mode);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	unsigned int blocksize;
 	unsigned int digestsize;
 	unsigned int hashmode;
@@ -546,7 +546,7 @@ cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 		idx++;
 	}
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
 	if (rc)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 
@@ -561,7 +561,7 @@ cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct rtattr *rta = (struct rtattr *)key;
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct crypto_authenc_key_param *param;
 	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
 	int seq_len = 0, rc = -EINVAL;
@@ -645,7 +645,7 @@ cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	/* STAT_PHASE_3: Submit sequence to HW */
 
 	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
-		rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 0);
+		rc = send_request(ctx->drvdata, &cc_req, desc, seq_len, 0);
 		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto setkey_error;
@@ -734,7 +734,7 @@ static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	enum ssi_req_dma_buf_type assoc_dma_type = areq_ctx->assoc_buff_type;
+	enum cc_req_dma_buf_type assoc_dma_type = areq_ctx->assoc_buff_type;
 	unsigned int idx = *seq_size;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
@@ -773,7 +773,7 @@ static void cc_proc_authen_desc(struct aead_request *areq,
 				unsigned int *seq_size, int direct)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
+	enum cc_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
 	unsigned int idx = *seq_size;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -803,7 +803,7 @@ static void cc_proc_authen_desc(struct aead_request *areq,
 		 * assoc. + iv + data -compact in one table
 		 * if assoclen is ZERO only IV perform
 		 */
-		ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
+		cc_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
 		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
 
 		if (areq_ctx->is_single_pass) {
@@ -838,7 +838,7 @@ static void cc_proc_cipher_desc(struct aead_request *areq,
 {
 	unsigned int idx = *seq_size;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
+	enum cc_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -1954,7 +1954,7 @@ static int cc_proc_aead(struct aead_request *req,
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 
 	dev_dbg(dev, "%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
 		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Enc" : "Dec"),
@@ -1972,8 +1972,8 @@ static int cc_proc_aead(struct aead_request *req,
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)cc_aead_complete;
-	ssi_req.user_arg = (void *)req;
+	cc_req.user_cb = (void *)cc_aead_complete;
+	cc_req.user_arg = (void *)req;
 
 	/* Setup request context */
 	areq_ctx->gen_ctx.op_type = direct;
@@ -2040,34 +2040,34 @@ static int cc_proc_aead(struct aead_request *req,
 	if (areq_ctx->backup_giv) {
 		/* set the DMA mapped IV address*/
 		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-			ssi_req.ivgen_dma_addr[0] =
+			cc_req.ivgen_dma_addr[0] =
 				areq_ctx->gen_ctx.iv_dma_addr +
 				CTR_RFC3686_NONCE_SIZE;
-			ssi_req.ivgen_dma_addr_len = 1;
+			cc_req.ivgen_dma_addr_len = 1;
 		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 			/* In ccm, the IV needs to exist both inside B0 and
 			 * inside the counter.It is also copied to iv_dma_addr
 			 * for other reasons (like returning it to the user).
 			 * So, using 3 (identical) IV outputs.
 			 */
-			ssi_req.ivgen_dma_addr[0] =
+			cc_req.ivgen_dma_addr[0] =
 				areq_ctx->gen_ctx.iv_dma_addr +
 				CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr[1] =
+			cc_req.ivgen_dma_addr[1] =
 				sg_dma_address(&areq_ctx->ccm_adata_sg) +
 				CCM_B0_OFFSET + CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr[2] =
+			cc_req.ivgen_dma_addr[2] =
 				sg_dma_address(&areq_ctx->ccm_adata_sg) +
 				CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr_len = 3;
+			cc_req.ivgen_dma_addr_len = 3;
 		} else {
-			ssi_req.ivgen_dma_addr[0] =
+			cc_req.ivgen_dma_addr[0] =
 				areq_ctx->gen_ctx.iv_dma_addr;
-			ssi_req.ivgen_dma_addr_len = 1;
+			cc_req.ivgen_dma_addr_len = 1;
 		}
 
 		/* set the IV size (8/16 B long)*/
-		ssi_req.ivgen_size = crypto_aead_ivsize(tfm);
+		cc_req.ivgen_size = crypto_aead_ivsize(tfm);
 	}
 
 	/* STAT_PHASE_2: Create sequence */
@@ -2099,7 +2099,7 @@ static int cc_proc_aead(struct aead_request *req,
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, seq_len, 1);
 
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
@@ -2403,7 +2403,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 }
 
 /* DX Block aead alg */
-static struct ssi_alg_template aead_algs[] = {
+static struct cc_alg_template aead_algs[] = {
 	{
 		.name = "authenc(hmac(sha1),cbc(aes))",
 		.driver_name = "authenc-hmac-sha1-cbc-aes-dx",
@@ -2653,10 +2653,10 @@ static struct ssi_alg_template aead_algs[] = {
 	},
 };
 
-static struct ssi_crypto_alg *cc_create_aead_alg(struct ssi_alg_template *tmpl,
-						 struct device *dev)
+static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
+						struct device *dev)
 {
-	struct ssi_crypto_alg *t_alg;
+	struct cc_crypto_alg *t_alg;
 	struct aead_alg *alg;
 
 	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
@@ -2687,9 +2687,9 @@ static struct ssi_crypto_alg *cc_create_aead_alg(struct ssi_alg_template *tmpl,
 	return t_alg;
 }
 
-int cc_aead_free(struct ssi_drvdata *drvdata)
+int cc_aead_free(struct cc_drvdata *drvdata)
 {
-	struct ssi_crypto_alg *t_alg, *n;
+	struct cc_crypto_alg *t_alg, *n;
 	struct cc_aead_handle *aead_handle =
 		(struct cc_aead_handle *)drvdata->aead_handle;
 
@@ -2708,10 +2708,10 @@ int cc_aead_free(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-int cc_aead_alloc(struct ssi_drvdata *drvdata)
+int cc_aead_alloc(struct cc_drvdata *drvdata)
 {
 	struct cc_aead_handle *aead_handle;
-	struct ssi_crypto_alg *t_alg;
+	struct cc_crypto_alg *t_alg;
 	int rc = -ENOMEM;
 	int alg;
 	struct device *dev = drvdata_to_dev(drvdata);
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index e41040e..2507be1 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -96,15 +96,15 @@ struct aead_req_ctx {
 
 	u8 *icv_virt_addr; /* Virt. address of ICV */
 	struct async_gen_req_ctx gen_ctx;
-	struct ssi_mlli assoc;
-	struct ssi_mlli src;
-	struct ssi_mlli dst;
+	struct cc_mlli assoc;
+	struct cc_mlli src;
+	struct cc_mlli dst;
 	struct scatterlist *src_sgl;
 	struct scatterlist *dst_sgl;
 	unsigned int src_offset;
 	unsigned int dst_offset;
-	enum ssi_req_dma_buf_type assoc_buff_type;
-	enum ssi_req_dma_buf_type data_buff_type;
+	enum cc_req_dma_buf_type assoc_buff_type;
+	enum cc_req_dma_buf_type data_buff_type;
 	struct mlli_params mlli_params;
 	unsigned int cryptlen;
 	struct scatterlist ccm_adata_sg;
@@ -116,7 +116,7 @@ struct aead_req_ctx {
 	bool plaintext_authenticate_only; //for gcm_rfc4543
 };
 
-int cc_aead_alloc(struct ssi_drvdata *drvdata);
-int cc_aead_free(struct ssi_drvdata *drvdata);
+int cc_aead_alloc(struct cc_drvdata *drvdata);
+int cc_aead_free(struct cc_drvdata *drvdata);
 
 #endif /*__CC_AEAD_H__*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index ee5c086..8649bcb 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -58,7 +58,7 @@ struct buffer_array {
 	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 };
 
-static inline char *cc_dma_buf_type(enum ssi_req_dma_buf_type type)
+static inline char *cc_dma_buf_type(enum cc_req_dma_buf_type type)
 {
 	switch (type) {
 	case CC_DMA_BUF_NULL:
@@ -80,7 +80,7 @@ static inline char *cc_dma_buf_type(enum ssi_req_dma_buf_type type)
  * @dir: [IN] copy from/to sgl
  */
 static void cc_copy_mac(struct device *dev, struct aead_request *req,
-			enum ssi_sg_cpy_direct dir)
+			enum cc_sg_cpy_direct dir)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -157,7 +157,7 @@ void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
  * @direct:
  */
 void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
-			u32 to_skip, u32 end, enum ssi_sg_cpy_direct direct)
+			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct)
 {
 	u32 nents, lbytes;
 
@@ -496,7 +496,7 @@ void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
 	}
 }
 
-int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
+int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
 			     unsigned int ivsize, unsigned int nbytes,
 			     void *info, struct scatterlist *src,
 			     struct scatterlist *dst)
@@ -594,7 +594,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 	u32 dummy;
 	bool chained;
 	u32 size_to_unmap = 0;
@@ -734,7 +734,7 @@ static int cc_get_aead_icv_nents(struct device *dev, struct scatterlist *sgl,
 	return nents;
 }
 
-static int cc_aead_chain_iv(struct ssi_drvdata *drvdata,
+static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 			    struct aead_request *req,
 			    struct buffer_array *sg_data,
 			    bool is_last, bool do_chain)
@@ -778,7 +778,7 @@ static int cc_aead_chain_iv(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-static int cc_aead_chain_assoc(struct ssi_drvdata *drvdata,
+static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 			       struct aead_request *req,
 			       struct buffer_array *sg_data,
 			       bool is_last, bool do_chain)
@@ -898,7 +898,7 @@ static void cc_prepare_aead_data_dlli(struct aead_request *req,
 	}
 }
 
-static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
+static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
 				     struct aead_request *req,
 				     struct buffer_array *sg_data,
 				     u32 *src_last_bytes, u32 *dst_last_bytes,
@@ -1030,7 +1030,7 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-static int cc_aead_chain_data(struct ssi_drvdata *drvdata,
+static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 			      struct aead_request *req,
 			      struct buffer_array *sg_data,
 			      bool is_last_table, bool do_chain)
@@ -1150,7 +1150,7 @@ static int cc_aead_chain_data(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-static void cc_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
+static void cc_update_aead_mlli_nents(struct cc_drvdata *drvdata,
 				      struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
@@ -1201,7 +1201,7 @@ static void cc_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 	}
 }
 
-int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
+int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
@@ -1400,7 +1400,7 @@ int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
 	return rc;
 }
 
-int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
+int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 			      struct scatterlist *src, unsigned int nbytes,
 			      bool do_update)
 {
@@ -1481,7 +1481,7 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	return -ENOMEM;
 }
 
-int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
+int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 			       struct scatterlist *src, unsigned int nbytes,
 			       unsigned int block_size)
 {
@@ -1639,7 +1639,7 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 	}
 }
 
-int cc_buffer_mgr_init(struct ssi_drvdata *drvdata)
+int cc_buffer_mgr_init(struct cc_drvdata *drvdata)
 {
 	struct buff_mgr_handle *buff_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1666,7 +1666,7 @@ int cc_buffer_mgr_init(struct ssi_drvdata *drvdata)
 	return -ENOMEM;
 }
 
-int cc_buffer_mgr_fini(struct ssi_drvdata *drvdata)
+int cc_buffer_mgr_fini(struct cc_drvdata *drvdata)
 {
 	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
 
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 77744a6..da43354 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -26,19 +26,19 @@
 #include "ssi_config.h"
 #include "ssi_driver.h"
 
-enum ssi_req_dma_buf_type {
+enum cc_req_dma_buf_type {
 	CC_DMA_BUF_NULL = 0,
 	CC_DMA_BUF_DLLI,
 	CC_DMA_BUF_MLLI
 };
 
-enum ssi_sg_cpy_direct {
+enum cc_sg_cpy_direct {
 	CC_SG_TO_BUF = 0,
 	CC_SG_FROM_BUF = 1
 };
 
-struct ssi_mlli {
-	ssi_sram_addr_t sram_addr;
+struct cc_mlli {
+	cc_sram_addr_t sram_addr;
 	unsigned int nents; //sg nents
 	unsigned int mlli_nents; //mlli nents might be different than the above
 };
@@ -50,11 +50,11 @@ struct mlli_params {
 	u32 mlli_len;
 };
 
-int cc_buffer_mgr_init(struct ssi_drvdata *drvdata);
+int cc_buffer_mgr_init(struct cc_drvdata *drvdata);
 
-int cc_buffer_mgr_fini(struct ssi_drvdata *drvdata);
+int cc_buffer_mgr_fini(struct cc_drvdata *drvdata);
 
-int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
+int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
 			     unsigned int ivsize, unsigned int nbytes,
 			     void *info, struct scatterlist *src,
 			     struct scatterlist *dst);
@@ -64,15 +64,15 @@ void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
 				struct scatterlist *src,
 				struct scatterlist *dst);
 
-int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req);
+int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req);
 
 void cc_unmap_aead_request(struct device *dev, struct aead_request *req);
 
-int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
+int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 			      struct scatterlist *src, unsigned int nbytes,
 			      bool do_update);
 
-int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
+int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 			       struct scatterlist *src, unsigned int nbytes,
 			       unsigned int block_size);
 
@@ -80,7 +80,7 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 			   struct scatterlist *src, bool do_revert);
 
 void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
-			u32 to_skip, u32 end, enum ssi_sg_cpy_direct direct);
+			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct);
 
 void cc_zero_sgl(struct scatterlist *sgl, u32 data_len);
 
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index c437a79..791fe75 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -55,7 +55,7 @@ struct cc_hw_key_info {
 };
 
 struct cc_cipher_ctx {
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 	int keylen;
 	int key_round_number;
 	int cipher_mode;
@@ -67,7 +67,7 @@ struct cc_cipher_ctx {
 	struct crypto_shash *shash_tfm;
 };
 
-static void cc_cipher_complete(struct device *dev, void *ssi_req);
+static void cc_cipher_complete(struct device *dev, void *cc_req);
 
 static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 {
@@ -145,17 +145,17 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 
 static unsigned int get_max_keysize(struct crypto_tfm *tfm)
 {
-	struct ssi_crypto_alg *ssi_alg =
-		container_of(tfm->__crt_alg, struct ssi_crypto_alg,
+	struct cc_crypto_alg *cc_alg =
+		container_of(tfm->__crt_alg, struct cc_crypto_alg,
 			     crypto_alg);
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
 	    CRYPTO_ALG_TYPE_ABLKCIPHER)
-		return ssi_alg->crypto_alg.cra_ablkcipher.max_keysize;
+		return cc_alg->crypto_alg.cra_ablkcipher.max_keysize;
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
 	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return ssi_alg->crypto_alg.cra_blkcipher.max_keysize;
+		return cc_alg->crypto_alg.cra_blkcipher.max_keysize;
 
 	return 0;
 }
@@ -164,9 +164,9 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct crypto_alg *alg = tfm->__crt_alg;
-	struct ssi_crypto_alg *ssi_alg =
-			container_of(alg, struct ssi_crypto_alg, crypto_alg);
-	struct device *dev = drvdata_to_dev(ssi_alg->drvdata);
+	struct cc_crypto_alg *cc_alg =
+			container_of(alg, struct cc_crypto_alg, crypto_alg);
+	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 	int rc = 0;
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 	struct ablkcipher_tfm *ablktfm = &tfm->crt_ablkcipher;
@@ -176,9 +176,9 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 
 	ablktfm->reqsize = sizeof(struct blkcipher_req_ctx);
 
-	ctx_p->cipher_mode = ssi_alg->cipher_mode;
-	ctx_p->flow_mode = ssi_alg->flow_mode;
-	ctx_p->drvdata = ssi_alg->drvdata;
+	ctx_p->cipher_mode = cc_alg->cipher_mode;
+	ctx_p->flow_mode = cc_alg->flow_mode;
+	ctx_p->drvdata = cc_alg->drvdata;
 
 	/* Allocate key buffer, cache line aligned */
 	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL | GFP_DMA);
@@ -408,14 +408,14 @@ static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
 	unsigned int du_size = nbytes;
 
-	struct ssi_crypto_alg *ssi_alg =
-		container_of(tfm->__crt_alg, struct ssi_crypto_alg,
+	struct cc_crypto_alg *cc_alg =
+		container_of(tfm->__crt_alg, struct cc_crypto_alg,
 			     crypto_alg);
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
 	    CRYPTO_ALG_BULK_DU_512)
 		du_size = 512;
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
 	    CRYPTO_ALG_BULK_DU_4096)
 		du_size = 4096;
 
@@ -604,9 +604,9 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 	}
 }
 
-static void cc_cipher_complete(struct device *dev, void *ssi_req)
+static void cc_cipher_complete(struct device *dev, void *cc_req)
 {
-	struct ablkcipher_request *areq = (struct ablkcipher_request *)ssi_req;
+	struct ablkcipher_request *areq = (struct ablkcipher_request *)cc_req;
 	struct scatterlist *dst = areq->dst;
 	struct scatterlist *src = areq->src;
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
@@ -651,7 +651,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	int rc, seq_len = 0, cts_restore_flag = 0;
 
 	dev_dbg(dev, "%s req=%p info=%p nbytes=%d\n",
@@ -691,11 +691,11 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)cc_cipher_complete;
-	ssi_req.user_arg = (void *)req;
+	cc_req.user_cb = (void *)cc_cipher_complete;
+	cc_req.user_arg = (void *)req;
 
 #ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
+	cc_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
 		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
 
 #endif
@@ -722,15 +722,15 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 
 	/* do we need to generate IV? */
 	if (req_ctx->is_giv) {
-		ssi_req.ivgen_dma_addr[0] = req_ctx->gen_ctx.iv_dma_addr;
-		ssi_req.ivgen_dma_addr_len = 1;
+		cc_req.ivgen_dma_addr[0] = req_ctx->gen_ctx.iv_dma_addr;
+		cc_req.ivgen_dma_addr_len = 1;
 		/* set the IV size (8/16 B long)*/
-		ssi_req.ivgen_size = ivsize;
+		cc_req.ivgen_size = ivsize;
 	}
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, 1);
+	rc = send_request(ctx_p->drvdata, &cc_req, desc, seq_len, 1);
 	if (rc != -EINPROGRESS) {
 		/* Failed to send the request or request completed
 		 * synchronously
@@ -782,7 +782,7 @@ static int cc_cipher_decrypt(struct ablkcipher_request *req)
 }
 
 /* DX Block cipher alg */
-static struct ssi_alg_template blkcipher_algs[] = {
+static struct cc_alg_template blkcipher_algs[] = {
 	{
 		.name = "xts(aes)",
 		.driver_name = "xts-aes-dx",
@@ -1075,10 +1075,10 @@ static struct ssi_alg_template blkcipher_algs[] = {
 };
 
 static
-struct ssi_crypto_alg *cc_cipher_create_alg(struct ssi_alg_template *template,
-					    struct device *dev)
+struct cc_crypto_alg *cc_cipher_create_alg(struct cc_alg_template *template,
+					   struct device *dev)
 {
-	struct ssi_crypto_alg *t_alg;
+	struct cc_crypto_alg *t_alg;
 	struct crypto_alg *alg;
 
 	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
@@ -1109,9 +1109,9 @@ struct ssi_crypto_alg *cc_cipher_create_alg(struct ssi_alg_template *template,
 	return t_alg;
 }
 
-int cc_cipher_free(struct ssi_drvdata *drvdata)
+int cc_cipher_free(struct cc_drvdata *drvdata)
 {
-	struct ssi_crypto_alg *t_alg, *n;
+	struct cc_crypto_alg *t_alg, *n;
 	struct cc_cipher_handle *blkcipher_handle =
 						drvdata->blkcipher_handle;
 	if (blkcipher_handle) {
@@ -1129,10 +1129,10 @@ int cc_cipher_free(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-int cc_cipher_alloc(struct ssi_drvdata *drvdata)
+int cc_cipher_alloc(struct cc_drvdata *drvdata)
 {
 	struct cc_cipher_handle *ablkcipher_handle;
-	struct ssi_crypto_alg *t_alg;
+	struct cc_crypto_alg *t_alg;
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = -ENOMEM;
 	int alg;
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 977b543..5d94cd3 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -40,7 +40,7 @@
 
 struct blkcipher_req_ctx {
 	struct async_gen_req_ctx gen_ctx;
-	enum ssi_req_dma_buf_type dma_buf_type;
+	enum cc_req_dma_buf_type dma_buf_type;
 	u32 in_nents;
 	u32 in_mlli_nents;
 	u32 out_nents;
@@ -51,9 +51,9 @@ struct blkcipher_req_ctx {
 	struct mlli_params mlli_params;
 };
 
-int cc_cipher_alloc(struct ssi_drvdata *drvdata);
+int cc_cipher_alloc(struct cc_drvdata *drvdata);
 
-int cc_cipher_free(struct ssi_drvdata *drvdata);
+int cc_cipher_free(struct cc_drvdata *drvdata);
 
 #ifndef CRYPTO_ALG_BULK_MASK
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 078d146..3f02ceb 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -89,7 +89,7 @@ void dump_byte_array(const char *name, const u8 *buf, size_t len)
 
 static irqreturn_t cc_isr(int irq, void *dev_id)
 {
-	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)dev_id;
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)dev_id;
 	struct device *dev = drvdata_to_dev(drvdata);
 	u32 irr;
 	u32 imr;
@@ -150,7 +150,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
+int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
 {
 	unsigned int val, cache_params;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -202,7 +202,7 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 static int init_cc_resources(struct platform_device *plat_dev)
 {
 	struct resource *req_mem_cc_regs = NULL;
-	struct ssi_drvdata *new_drvdata;
+	struct cc_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
@@ -405,7 +405,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	return rc;
 }
 
-void fini_cc_regs(struct ssi_drvdata *drvdata)
+void fini_cc_regs(struct cc_drvdata *drvdata)
 {
 	/* Mask all interrupts */
 	cc_iowrite(drvdata, CC_REG(HOST_IMR), 0xFFFFFFFF);
@@ -413,8 +413,8 @@ void fini_cc_regs(struct ssi_drvdata *drvdata)
 
 static void cleanup_cc_resources(struct platform_device *plat_dev)
 {
-	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)platform_get_drvdata(plat_dev);
+	struct cc_drvdata *drvdata =
+		(struct cc_drvdata *)platform_get_drvdata(plat_dev);
 
 	cc_aead_free(drvdata);
 	cc_hash_free(drvdata);
@@ -432,7 +432,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_clk_off(drvdata);
 }
 
-int cc_clk_on(struct ssi_drvdata *drvdata)
+int cc_clk_on(struct cc_drvdata *drvdata)
 {
 	struct clk *clk = drvdata->clk;
 	int rc;
@@ -448,7 +448,7 @@ int cc_clk_on(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-void cc_clk_off(struct ssi_drvdata *drvdata)
+void cc_clk_off(struct cc_drvdata *drvdata)
 {
 	struct clk *clk = drvdata->clk;
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 4d94a06..35e1b72 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -89,7 +89,7 @@
  */
 
 #define CC_MAX_IVGEN_DMA_ADDRESSES	3
-struct ssi_crypto_req {
+struct cc_crypto_req {
 	void (*user_cb)(struct device *dev, void *req);
 	void *user_arg;
 	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
@@ -105,20 +105,20 @@ struct ssi_crypto_req {
 };
 
 /**
- * struct ssi_drvdata - driver private data context
+ * struct cc_drvdata - driver private data context
  * @cc_base:	virt address of the CC registers
  * @irq:	device IRQ number
  * @irq_mask:	Interrupt mask shadow (1 for masked interrupts)
  * @fw_ver:	SeP loaded firmware version
  */
-struct ssi_drvdata {
+struct cc_drvdata {
 	void __iomem *cc_base;
 	int irq;
 	u32 irq_mask;
 	u32 fw_ver;
 	struct completion hw_queue_avail; /* wait for HW queue availability */
 	struct platform_device *plat_dev;
-	ssi_sram_addr_t mlli_sram_addr;
+	cc_sram_addr_t mlli_sram_addr;
 	void *buff_mgr_handle;
 	void *hash_handle;
 	void *aead_handle;
@@ -131,17 +131,17 @@ struct ssi_drvdata {
 	bool coherent;
 };
 
-struct ssi_crypto_alg {
+struct cc_crypto_alg {
 	struct list_head entry;
 	int cipher_mode;
 	int flow_mode; /* Note: currently, refers to the cipher mode only. */
 	int auth_mode;
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 	struct crypto_alg crypto_alg;
 	struct aead_alg aead_alg;
 };
 
-struct ssi_alg_template {
+struct cc_alg_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int blocksize;
@@ -156,7 +156,7 @@ struct ssi_alg_template {
 	int cipher_mode;
 	int flow_mode; /* Note: currently, refers to the cipher mode only. */
 	int auth_mode;
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 };
 
 struct async_gen_req_ctx {
@@ -164,7 +164,7 @@ struct async_gen_req_ctx {
 	enum drv_crypto_direction op_type;
 };
 
-static inline struct device *drvdata_to_dev(struct ssi_drvdata *drvdata)
+static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
 {
 	return &drvdata->plat_dev->dev;
 }
@@ -177,17 +177,17 @@ static inline void dump_byte_array(const char *name, const u8 *the_array,
 				   unsigned long size) {};
 #endif
 
-int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe);
-void fini_cc_regs(struct ssi_drvdata *drvdata);
-int cc_clk_on(struct ssi_drvdata *drvdata);
-void cc_clk_off(struct ssi_drvdata *drvdata);
+int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
+void fini_cc_regs(struct cc_drvdata *drvdata);
+int cc_clk_on(struct cc_drvdata *drvdata);
+void cc_clk_off(struct cc_drvdata *drvdata);
 
-static inline void cc_iowrite(struct ssi_drvdata *drvdata, u32 reg, u32 val)
+static inline void cc_iowrite(struct cc_drvdata *drvdata, u32 reg, u32 val)
 {
 	iowrite32(val, (drvdata->cc_base + reg));
 }
 
-static inline u32 cc_ioread(struct ssi_drvdata *drvdata, u32 reg)
+static inline u32 cc_ioread(struct cc_drvdata *drvdata, u32 reg)
 {
 	return ioread32(drvdata->cc_base + reg);
 }
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 273b414..036215f 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -23,14 +23,14 @@
 
 static void fips_dsr(unsigned long devarg);
 
-struct ssi_fips_handle {
+struct cc_fips_handle {
 	struct tasklet_struct tasklet;
 };
 
 /* The function called once at driver entry point to check
  * whether TEE FIPS error occurred.
  */
-static bool cc_get_tee_fips_status(struct ssi_drvdata *drvdata)
+static bool cc_get_tee_fips_status(struct cc_drvdata *drvdata)
 {
 	u32 reg;
 
@@ -42,7 +42,7 @@ static bool cc_get_tee_fips_status(struct ssi_drvdata *drvdata)
  * This function should push the FIPS REE library status towards the TEE library
  * by writing the error state to HOST_GPR0 register.
  */
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool status)
+void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool status)
 {
 	int val = CC_FIPS_SYNC_REE_STATUS;
 
@@ -51,9 +51,9 @@ void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool status)
 	cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
 }
 
-void ssi_fips_fini(struct ssi_drvdata *drvdata)
+void ssi_fips_fini(struct cc_drvdata *drvdata)
 {
-	struct ssi_fips_handle *fips_h = drvdata->fips_handle;
+	struct cc_fips_handle *fips_h = drvdata->fips_handle;
 
 	if (!fips_h)
 		return; /* Not allocated */
@@ -65,9 +65,9 @@ void ssi_fips_fini(struct ssi_drvdata *drvdata)
 	drvdata->fips_handle = NULL;
 }
 
-void fips_handler(struct ssi_drvdata *drvdata)
+void fips_handler(struct cc_drvdata *drvdata)
 {
-	struct ssi_fips_handle *fips_handle_ptr =
+	struct cc_fips_handle *fips_handle_ptr =
 		drvdata->fips_handle;
 
 	tasklet_schedule(&fips_handle_ptr->tasklet);
@@ -84,7 +84,7 @@ static inline void tee_fips_error(struct device *dev)
 /* Deferred service handler, run as interrupt-fired tasklet */
 static void fips_dsr(unsigned long devarg)
 {
-	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
 	struct device *dev = drvdata_to_dev(drvdata);
 	u32 irq, state, val;
 
@@ -105,9 +105,9 @@ static void fips_dsr(unsigned long devarg)
 }
 
 /* The function called once at driver entry point .*/
-int ssi_fips_init(struct ssi_drvdata *p_drvdata)
+int ssi_fips_init(struct cc_drvdata *p_drvdata)
 {
-	struct ssi_fips_handle *fips_h;
+	struct cc_fips_handle *fips_h;
 	struct device *dev = drvdata_to_dev(p_drvdata);
 
 	fips_h = kzalloc(sizeof(*fips_h), GFP_KERNEL);
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 1889c74..5eed9f6 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -27,22 +27,22 @@ enum cc_fips_status {
 	CC_FIPS_SYNC_STATUS_RESERVE32B = S32_MAX
 };
 
-int ssi_fips_init(struct ssi_drvdata *p_drvdata);
-void ssi_fips_fini(struct ssi_drvdata *drvdata);
-void fips_handler(struct ssi_drvdata *drvdata);
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok);
+int ssi_fips_init(struct cc_drvdata *p_drvdata);
+void ssi_fips_fini(struct cc_drvdata *drvdata);
+void fips_handler(struct cc_drvdata *drvdata);
+void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
 
 #else  /* CONFIG_CRYPTO_FIPS */
 
-static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
+static inline int ssi_fips_init(struct cc_drvdata *p_drvdata)
 {
 	return 0;
 }
 
-static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata,
+static inline void ssi_fips_fini(struct cc_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
 					  bool ok) {}
-static inline void fips_handler(struct ssi_drvdata *drvdata) {}
+static inline void fips_handler(struct cc_drvdata *drvdata) {}
 
 #endif /* CONFIG_CRYPTO_FIPS */
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 5a041bb..e5e71c2 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -35,8 +35,8 @@
 #define CC_MAX_OPAD_KEYS_SIZE CC_MAX_HASH_BLCK_SIZE
 
 struct cc_hash_handle {
-	ssi_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
-	ssi_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
+	cc_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
+	cc_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
 	struct list_head hash_list;
 	struct completion init_comp;
 };
@@ -75,7 +75,7 @@ struct cc_hash_alg {
 	int hash_mode;
 	int hw_mode;
 	int inter_digestsize;
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 	struct ahash_alg ahash_alg;
 };
 
@@ -86,7 +86,7 @@ struct hash_key_req_ctx {
 
 /* hash per-session context */
 struct cc_hash_ctx {
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 	/* holds the origin digest; the digest after "setkey" if HMAC,*
 	 * the initial digest if HASH.
 	 */
@@ -141,9 +141,9 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		      struct cc_hash_ctx *ctx)
 {
 	bool is_hmac = ctx->is_hmac;
-	ssi_sram_addr_t larval_digest_addr =
+	cc_sram_addr_t larval_digest_addr =
 		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
@@ -244,7 +244,7 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 			      ctx->inter_digestsize, NS_BIT, 0);
 		set_flow_mode(&desc, BYPASS);
 
-		rc = send_request(ctx->drvdata, &ssi_req, &desc, 1, 0);
+		rc = send_request(ctx->drvdata, &cc_req, &desc, 1, 0);
 		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto fail4;
@@ -373,9 +373,9 @@ static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
 	state->digest_result_dma_addr = 0;
 }
 
-static void cc_update_complete(struct device *dev, void *ssi_req)
+static void cc_update_complete(struct device *dev, void *cc_req)
 {
-	struct ahash_request *req = (struct ahash_request *)ssi_req;
+	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 
 	dev_dbg(dev, "req=%pK\n", req);
@@ -384,9 +384,9 @@ static void cc_update_complete(struct device *dev, void *ssi_req)
 	req->base.complete(&req->base, 0);
 }
 
-static void cc_digest_complete(struct device *dev, void *ssi_req)
+static void cc_digest_complete(struct device *dev, void *cc_req)
 {
-	struct ahash_request *req = (struct ahash_request *)ssi_req;
+	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -400,9 +400,9 @@ static void cc_digest_complete(struct device *dev, void *ssi_req)
 	req->base.complete(&req->base, 0);
 }
 
-static void cc_hash_complete(struct device *dev, void *ssi_req)
+static void cc_hash_complete(struct device *dev, void *cc_req)
 {
-	struct ahash_request *req = (struct ahash_request *)ssi_req;
+	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -427,9 +427,9 @@ static int cc_hash_digest(struct ahash_request *req)
 	u8 *result = req->result;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	ssi_sram_addr_t larval_digest_addr =
+	cc_sram_addr_t larval_digest_addr =
 		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 	int idx = 0;
 	int rc = 0;
@@ -453,8 +453,8 @@ static int cc_hash_digest(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = cc_digest_complete;
-	ssi_req.user_arg = req;
+	cc_req.user_cb = cc_digest_complete;
+	cc_req.user_arg = req;
 
 	/* If HMAC then load hash IPAD xor key, if HASH then load initial
 	 * digest
@@ -561,7 +561,7 @@ static int cc_hash_digest(struct ahash_request *req)
 	cc_set_endianity(ctx->hash_mode, &desc[idx]);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -580,7 +580,7 @@ static int cc_hash_update(struct ahash_request *req)
 	struct scatterlist *src = req->src;
 	unsigned int nbytes = req->nbytes;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	u32 idx = 0;
 	int rc;
@@ -607,8 +607,8 @@ static int cc_hash_update(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = cc_update_complete;
-	ssi_req.user_arg = req;
+	cc_req.user_cb = cc_update_complete;
+	cc_req.user_arg = req;
 
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
@@ -648,7 +648,7 @@ static int cc_hash_update(struct ahash_request *req)
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -667,7 +667,7 @@ static int cc_hash_finup(struct ahash_request *req)
 	u8 *result = req->result;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc;
@@ -685,8 +685,8 @@ static int cc_hash_finup(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = cc_hash_complete;
-	ssi_req.user_arg = req;
+	cc_req.user_cb = cc_hash_complete;
+	cc_req.user_arg = req;
 
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
@@ -767,7 +767,7 @@ static int cc_hash_finup(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -787,7 +787,7 @@ static int cc_hash_final(struct ahash_request *req)
 	u8 *result = req->result;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc;
@@ -806,8 +806,8 @@ static int cc_hash_final(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = cc_hash_complete;
-	ssi_req.user_arg = req;
+	cc_req.user_cb = cc_hash_complete;
+	cc_req.user_arg = req;
 
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
@@ -897,7 +897,7 @@ static int cc_hash_final(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -925,13 +925,13 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 			  unsigned int keylen)
 {
 	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hash_ctx *ctx = NULL;
 	int blocksize = 0;
 	int digestsize = 0;
 	int i, idx = 0, rc = 0;
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	ssi_sram_addr_t larval_addr;
+	cc_sram_addr_t larval_addr;
 	struct device *dev;
 
 	ctx = crypto_ahash_ctx(ahash);
@@ -1037,7 +1037,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		idx++;
 	}
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
 	if (rc) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		goto out;
@@ -1094,7 +1094,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		idx++;
 	}
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
 
 out:
 	if (rc)
@@ -1112,7 +1112,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 			  const u8 *key, unsigned int keylen)
 {
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	int idx = 0, rc = 0;
@@ -1177,7 +1177,7 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 			       CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
 
 	if (rc)
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -1300,17 +1300,17 @@ static int cc_cra_init(struct crypto_tfm *tfm)
 		container_of(tfm->__crt_alg, struct hash_alg_common, base);
 	struct ahash_alg *ahash_alg =
 		container_of(hash_alg_common, struct ahash_alg, halg);
-	struct cc_hash_alg *ssi_alg =
+	struct cc_hash_alg *cc_alg =
 			container_of(ahash_alg, struct cc_hash_alg,
 				     ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct ahash_req_ctx));
 
-	ctx->hash_mode = ssi_alg->hash_mode;
-	ctx->hw_mode = ssi_alg->hw_mode;
-	ctx->inter_digestsize = ssi_alg->inter_digestsize;
-	ctx->drvdata = ssi_alg->drvdata;
+	ctx->hash_mode = cc_alg->hash_mode;
+	ctx->hw_mode = cc_alg->hw_mode;
+	ctx->inter_digestsize = cc_alg->inter_digestsize;
+	ctx->drvdata = cc_alg->drvdata;
 
 	return cc_alloc_ctx(ctx);
 }
@@ -1331,7 +1331,7 @@ static int cc_mac_update(struct ahash_request *req)
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int rc;
 	u32 idx = 0;
@@ -1374,10 +1374,10 @@ static int cc_mac_update(struct ahash_request *req)
 	idx++;
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)cc_update_complete;
-	ssi_req.user_arg = (void *)req;
+	cc_req.user_cb = (void *)cc_update_complete;
+	cc_req.user_arg = (void *)req;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1391,7 +1391,7 @@ static int cc_mac_final(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc = 0;
@@ -1424,8 +1424,8 @@ static int cc_mac_final(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)cc_hash_complete;
-	ssi_req.user_arg = (void *)req;
+	cc_req.user_cb = (void *)cc_hash_complete;
+	cc_req.user_arg = (void *)req;
 
 	if (state->xcbc_count && rem_cnt == 0) {
 		/* Load key for ECB decryption */
@@ -1490,7 +1490,7 @@ static int cc_mac_final(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1505,7 +1505,7 @@ static int cc_mac_finup(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc = 0;
@@ -1529,8 +1529,8 @@ static int cc_mac_finup(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)cc_hash_complete;
-	ssi_req.user_arg = (void *)req;
+	cc_req.user_cb = (void *)cc_hash_complete;
+	cc_req.user_arg = (void *)req;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_len = CC_AES_128_BIT_KEY_SIZE;
@@ -1562,7 +1562,7 @@ static int cc_mac_finup(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1578,7 +1578,7 @@ static int cc_mac_digest(struct ahash_request *req)
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
-	struct ssi_crypto_req ssi_req = {};
+	struct cc_crypto_req cc_req = {};
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	u32 key_len;
 	int idx = 0;
@@ -1602,8 +1602,8 @@ static int cc_mac_digest(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)cc_digest_complete;
-	ssi_req.user_arg = (void *)req;
+	cc_req.user_cb = (void *)cc_digest_complete;
+	cc_req.user_arg = (void *)req;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_len = CC_AES_128_BIT_KEY_SIZE;
@@ -1635,7 +1635,7 @@ static int cc_mac_digest(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1757,7 +1757,7 @@ struct cc_hash_template {
 	int hash_mode;
 	int hw_mode;
 	int inter_digestsize;
-	struct ssi_drvdata *drvdata;
+	struct cc_drvdata *drvdata;
 };
 
 #define CC_STATE_SIZE(_x) \
@@ -2005,10 +2005,10 @@ static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template *template,
 	return t_crypto_alg;
 }
 
-int cc_init_hash_sram(struct ssi_drvdata *drvdata)
+int cc_init_hash_sram(struct cc_drvdata *drvdata)
 {
 	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
-	ssi_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
+	cc_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
 	unsigned int larval_seq_len = 0;
 	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -2125,10 +2125,10 @@ int cc_init_hash_sram(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-int cc_hash_alloc(struct ssi_drvdata *drvdata)
+int cc_hash_alloc(struct cc_drvdata *drvdata)
 {
 	struct cc_hash_handle *hash_handle;
-	ssi_sram_addr_t sram_buff;
+	cc_sram_addr_t sram_buff;
 	u32 sram_size_to_alloc;
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = 0;
@@ -2228,7 +2228,7 @@ int cc_hash_alloc(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-int cc_hash_free(struct ssi_drvdata *drvdata)
+int cc_hash_free(struct cc_drvdata *drvdata)
 {
 	struct cc_hash_alg *t_hash_alg, *hash_n;
 	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
@@ -2390,9 +2390,9 @@ static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
  *
  * \return u32 The address of the initial digest in SRAM
  */
-ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
+cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 {
-	struct ssi_drvdata *_drvdata = (struct ssi_drvdata *)drvdata;
+	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
 	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
 	struct device *dev = drvdata_to_dev(_drvdata);
 
@@ -2436,12 +2436,12 @@ ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 	return hash_handle->larval_digest_sram_addr;
 }
 
-ssi_sram_addr_t
+cc_sram_addr_t
 cc_digest_len_addr(void *drvdata, u32 mode)
 {
-	struct ssi_drvdata *_drvdata = (struct ssi_drvdata *)drvdata;
+	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
 	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
-	ssi_sram_addr_t digest_len_addr = hash_handle->digest_len_sram_addr;
+	cc_sram_addr_t digest_len_addr = hash_handle->digest_len_sram_addr;
 
 	switch (mode) {
 	case DRV_HASH_SHA1:
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 9d1af96..81f57fc 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -56,7 +56,7 @@ struct ahash_req_ctx {
 	u8 *buff1;
 	u8 *digest_result_buff;
 	struct async_gen_req_ctx gen_ctx;
-	enum ssi_req_dma_buf_type data_dma_buf_type;
+	enum cc_req_dma_buf_type data_dma_buf_type;
 	u8 *digest_buff;
 	u8 *opad_digest_buff;
 	u8 *digest_bytes_len;
@@ -75,9 +75,9 @@ struct ahash_req_ctx {
 	struct mlli_params mlli_params;
 };
 
-int cc_hash_alloc(struct ssi_drvdata *drvdata);
-int cc_init_hash_sram(struct ssi_drvdata *drvdata);
-int cc_hash_free(struct ssi_drvdata *drvdata);
+int cc_hash_alloc(struct cc_drvdata *drvdata);
+int cc_init_hash_sram(struct cc_drvdata *drvdata);
+int cc_hash_free(struct cc_drvdata *drvdata);
 
 /*!
  * Gets the initial digest length
@@ -88,7 +88,7 @@ int cc_hash_free(struct ssi_drvdata *drvdata);
  *
  * \return u32 returns the address of the initial digest length in SRAM
  */
-ssi_sram_addr_t
+cc_sram_addr_t
 cc_digest_len_addr(void *drvdata, u32 mode);
 
 /*!
@@ -101,7 +101,7 @@ cc_digest_len_addr(void *drvdata, u32 mode);
  *
  * \return u32 The address of the initial digest in SRAM
  */
-ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
+cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
 
 #endif /*__CC_HASH_H__*/
 
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index d362bf6..0303c85 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -41,9 +41,9 @@
  * @pool_meta_dma: phys. address of the initial enc. key/IV
  */
 struct cc_ivgen_ctx {
-	ssi_sram_addr_t pool;
-	ssi_sram_addr_t ctr_key;
-	ssi_sram_addr_t ctr_iv;
+	cc_sram_addr_t pool;
+	cc_sram_addr_t ctr_key;
+	cc_sram_addr_t ctr_iv;
 	u32 next_iv_ofs;
 	u8 *pool_meta;
 	dma_addr_t pool_meta_dma;
@@ -116,7 +116,7 @@ static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_init_iv_sram(struct ssi_drvdata *drvdata)
+int cc_init_iv_sram(struct cc_drvdata *drvdata)
 {
 	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
@@ -153,7 +153,7 @@ int cc_init_iv_sram(struct ssi_drvdata *drvdata)
  *
  * \param drvdata
  */
-void cc_ivgen_fini(struct ssi_drvdata *drvdata)
+void cc_ivgen_fini(struct cc_drvdata *drvdata)
 {
 	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	struct device *device = &drvdata->plat_dev->dev;
@@ -182,7 +182,7 @@ void cc_ivgen_fini(struct ssi_drvdata *drvdata)
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_ivgen_init(struct ssi_drvdata *drvdata)
+int cc_ivgen_init(struct cc_drvdata *drvdata)
 {
 	struct cc_ivgen_ctx *ivgen_ctx;
 	struct device *device = &drvdata->plat_dev->dev;
@@ -234,7 +234,7 @@ int cc_ivgen_init(struct ssi_drvdata *drvdata)
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
+int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
 	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
 	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
 {
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index 9890f62..eeca45e3 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -29,14 +29,14 @@
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_ivgen_init(struct ssi_drvdata *drvdata);
+int cc_ivgen_init(struct cc_drvdata *drvdata);
 
 /*!
  * Free iv-pool and ivgen context.
  *
  * \param drvdata
  */
-void cc_ivgen_fini(struct ssi_drvdata *drvdata);
+void cc_ivgen_fini(struct cc_drvdata *drvdata);
 
 /*!
  * Generates the initial pool in SRAM.
@@ -46,7 +46,7 @@ void cc_ivgen_fini(struct ssi_drvdata *drvdata);
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_init_iv_sram(struct ssi_drvdata *drvdata);
+int cc_init_iv_sram(struct cc_drvdata *drvdata);
 
 /*!
  * Acquires 16 Bytes IV from the iv-pool
@@ -61,7 +61,7 @@ int cc_init_iv_sram(struct ssi_drvdata *drvdata);
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
+int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
 	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
 	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len);
 
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index e387d46..3c4892b 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -36,7 +36,7 @@
 
 int cc_pm_suspend(struct device *dev)
 {
-	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
@@ -55,7 +55,7 @@ int cc_pm_suspend(struct device *dev)
 int cc_pm_resume(struct device *dev)
 {
 	int rc;
-	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
 	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
@@ -88,7 +88,7 @@ int cc_pm_resume(struct device *dev)
 int cc_pm_get(struct device *dev)
 {
 	int rc = 0;
-	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
 	if (cc_req_queue_suspended(drvdata))
 		rc = pm_runtime_get_sync(dev);
@@ -101,7 +101,7 @@ int cc_pm_get(struct device *dev)
 int cc_pm_put_suspend(struct device *dev)
 {
 	int rc = 0;
-	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
 	if (!cc_req_queue_suspended(drvdata)) {
 		pm_runtime_mark_last_busy(dev);
@@ -116,7 +116,7 @@ int cc_pm_put_suspend(struct device *dev)
 
 #endif
 
-int cc_pm_init(struct ssi_drvdata *drvdata)
+int cc_pm_init(struct cc_drvdata *drvdata)
 {
 	int rc = 0;
 #if defined(CONFIG_PM)
@@ -135,7 +135,7 @@ int cc_pm_init(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-void cc_pm_fini(struct ssi_drvdata *drvdata)
+void cc_pm_fini(struct cc_drvdata *drvdata)
 {
 #if defined(CONFIG_PM)
 	pm_runtime_disable(drvdata_to_dev(drvdata));
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 940ef2d..a5f2b1b 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -25,9 +25,9 @@
 
 #define CC_SUSPEND_TIMEOUT 3000
 
-int cc_pm_init(struct ssi_drvdata *drvdata);
+int cc_pm_init(struct cc_drvdata *drvdata);
 
-void cc_pm_fini(struct ssi_drvdata *drvdata);
+void cc_pm_fini(struct cc_drvdata *drvdata);
 
 #if defined(CONFIG_PM)
 int cc_pm_suspend(struct device *dev);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index f1356d1..480e6d3 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -38,7 +38,7 @@ struct cc_req_mgr_handle {
 	unsigned int hw_queue_size; /* HW capability */
 	unsigned int min_free_hw_slots;
 	unsigned int max_used_sw_slots;
-	struct ssi_crypto_req req_queue[MAX_REQUEST_QUEUE_SIZE];
+	struct cc_crypto_req req_queue[MAX_REQUEST_QUEUE_SIZE];
 	u32 req_queue_head;
 	u32 req_queue_tail;
 	u32 axi_completed;
@@ -68,7 +68,7 @@ static void comp_handler(unsigned long devarg);
 static void comp_work_handler(struct work_struct *work);
 #endif
 
-void cc_req_mgr_fini(struct ssi_drvdata *drvdata)
+void cc_req_mgr_fini(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -97,7 +97,7 @@ void cc_req_mgr_fini(struct ssi_drvdata *drvdata)
 	drvdata->request_mgr_handle = NULL;
 }
 
-int cc_req_mgr_init(struct ssi_drvdata *drvdata)
+int cc_req_mgr_init(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *req_mgr_h;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -201,7 +201,7 @@ static void request_mgr_complete(struct device *dev, void *dx_compl_h)
 	complete(this_compl);
 }
 
-static int cc_queues_status(struct ssi_drvdata *drvdata,
+static int cc_queues_status(struct cc_drvdata *drvdata,
 			    struct cc_req_mgr_handle *req_mgr_h,
 			    unsigned int total_seq_len)
 {
@@ -248,7 +248,7 @@ static int cc_queues_status(struct ssi_drvdata *drvdata,
  * Enqueue caller request to crypto hardware.
  *
  * \param drvdata
- * \param ssi_req The request to enqueue
+ * \param cc_req The request to enqueue
  * \param desc The crypto sequence
  * \param len The crypto sequence length
  * \param is_dout If "true": completion is handled by the caller
@@ -257,7 +257,7 @@ static int cc_queues_status(struct ssi_drvdata *drvdata,
  *
  * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
  */
-int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
+int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 		 struct cc_hw_desc *desc, unsigned int len, bool is_dout)
 {
 	void __iomem *cc_base = drvdata->cc_base;
@@ -270,7 +270,7 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
 	int rc;
 	unsigned int max_required_seq_len =
 		(total_seq_len +
-		 ((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
+		 ((cc_req->ivgen_dma_addr_len == 0) ? 0 :
 		  CC_IVPOOL_SEQ_LEN) + (!is_dout ? 1 : 0));
 
 #if defined(CONFIG_PM)
@@ -314,24 +314,24 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
 	 * enabled any DLLI/MLLI DOUT bit in the given sequence
 	 */
 	if (!is_dout) {
-		init_completion(&ssi_req->seq_compl);
-		ssi_req->user_cb = request_mgr_complete;
-		ssi_req->user_arg = &ssi_req->seq_compl;
+		init_completion(&cc_req->seq_compl);
+		cc_req->user_cb = request_mgr_complete;
+		cc_req->user_arg = &cc_req->seq_compl;
 		total_seq_len++;
 	}
 
-	if (ssi_req->ivgen_dma_addr_len > 0) {
+	if (cc_req->ivgen_dma_addr_len > 0) {
 		dev_dbg(dev, "Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
-			ssi_req->ivgen_dma_addr_len,
-			&ssi_req->ivgen_dma_addr[0],
-			&ssi_req->ivgen_dma_addr[1],
-			&ssi_req->ivgen_dma_addr[2],
-			ssi_req->ivgen_size);
+			cc_req->ivgen_dma_addr_len,
+			&cc_req->ivgen_dma_addr[0],
+			&cc_req->ivgen_dma_addr[1],
+			&cc_req->ivgen_dma_addr[2],
+			cc_req->ivgen_size);
 
 		/* Acquire IV from pool */
-		rc = cc_get_iv(drvdata, ssi_req->ivgen_dma_addr,
-			       ssi_req->ivgen_dma_addr_len,
-			       ssi_req->ivgen_size,
+		rc = cc_get_iv(drvdata, cc_req->ivgen_dma_addr,
+			       cc_req->ivgen_dma_addr_len,
+			       cc_req->ivgen_size,
 			       iv_seq, &iv_seq_len);
 
 		if (rc) {
@@ -353,7 +353,7 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
 
 	/* Enqueue request - must be locked with HW lock*/
-	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *ssi_req;
+	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *cc_req;
 	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) &
 				    (MAX_REQUEST_QUEUE_SIZE - 1);
 	/* TODO: Use circ_buf.h ? */
@@ -393,7 +393,7 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
 		/* Wait upon sequence completion.
 		 *  Return "0" -Operation done successfully.
 		 */
-		wait_for_completion(&ssi_req->seq_compl);
+		wait_for_completion(&cc_req->seq_compl);
 		return 0;
 	}
 	/* Operation still in process */
@@ -411,7 +411,7 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
  *
  * \return int Returns "0" upon success
  */
-int send_request_init(struct ssi_drvdata *drvdata, struct cc_hw_desc *desc,
+int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
 		      unsigned int len)
 {
 	void __iomem *cc_base = drvdata->cc_base;
@@ -442,7 +442,7 @@ int send_request_init(struct ssi_drvdata *drvdata, struct cc_hw_desc *desc,
 	return 0;
 }
 
-void complete_request(struct ssi_drvdata *drvdata)
+void complete_request(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
@@ -459,16 +459,16 @@ void complete_request(struct ssi_drvdata *drvdata)
 #ifdef COMP_IN_WQ
 static void comp_work_handler(struct work_struct *work)
 {
-	struct ssi_drvdata *drvdata =
-		container_of(work, struct ssi_drvdata, compwork.work);
+	struct cc_drvdata *drvdata =
+		container_of(work, struct cc_drvdata, compwork.work);
 
 	comp_handler((unsigned long)drvdata);
 }
 #endif
 
-static void proc_completions(struct ssi_drvdata *drvdata)
+static void proc_completions(struct cc_drvdata *drvdata)
 {
-	struct ssi_crypto_req *ssi_req;
+	struct cc_crypto_req *cc_req;
 	struct device *dev = drvdata_to_dev(drvdata);
 	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
@@ -492,7 +492,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 			break;
 		}
 
-		ssi_req = &request_mgr_handle->req_queue[*tail];
+		cc_req = &request_mgr_handle->req_queue[*tail];
 
 #ifdef FLUSH_CACHE_ALL
 		flush_cache_all();
@@ -511,8 +511,8 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		}
 #endif /* COMPLETION_DELAY */
 
-		if (ssi_req->user_cb)
-			ssi_req->user_cb(dev, ssi_req->user_arg);
+		if (cc_req->user_cb)
+			cc_req->user_cb(dev, cc_req->user_arg);
 		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
@@ -526,7 +526,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 	}
 }
 
-static inline u32 cc_axi_comp_count(struct ssi_drvdata *drvdata)
+static inline u32 cc_axi_comp_count(struct cc_drvdata *drvdata)
 {
 	return FIELD_GET(AXIM_MON_COMP_VALUE,
 			 cc_ioread(drvdata, CC_REG(AXIM_MON_COMP)));
@@ -535,7 +535,7 @@ static inline u32 cc_axi_comp_count(struct ssi_drvdata *drvdata)
 /* Deferred service handler, run as interrupt-fired tasklet */
 static void comp_handler(unsigned long devarg)
 {
-	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
 	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
@@ -584,7 +584,7 @@ static void comp_handler(unsigned long devarg)
  * inside the spin lock protection
  */
 #if defined(CONFIG_PM)
-int cc_resume_req_queue(struct ssi_drvdata *drvdata)
+int cc_resume_req_queue(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *request_mgr_handle =
 		drvdata->request_mgr_handle;
@@ -600,7 +600,7 @@ int cc_resume_req_queue(struct ssi_drvdata *drvdata)
  * suspend the queue configuration. Since it is used for the runtime suspend
  * only verify that the queue can be suspended.
  */
-int cc_suspend_req_queue(struct ssi_drvdata *drvdata)
+int cc_suspend_req_queue(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
@@ -618,7 +618,7 @@ int cc_suspend_req_queue(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-bool cc_req_queue_suspended(struct ssi_drvdata *drvdata)
+bool cc_req_queue_suspended(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index 91e0d47..eb068bf 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -23,13 +23,13 @@
 
 #include "cc_hw_queue_defs.h"
 
-int cc_req_mgr_init(struct ssi_drvdata *drvdata);
+int cc_req_mgr_init(struct cc_drvdata *drvdata);
 
 /*!
  * Enqueue caller request to crypto hardware.
  *
  * \param drvdata
- * \param ssi_req The request to enqueue
+ * \param cc_req The request to enqueue
  * \param desc The crypto sequence
  * \param len The crypto sequence length
  * \param is_dout If "true": completion is handled by the caller
@@ -38,22 +38,22 @@ int cc_req_mgr_init(struct ssi_drvdata *drvdata);
  *
  * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
  */
-int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
+int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 		 struct cc_hw_desc *desc, unsigned int len, bool is_dout);
 
-int send_request_init(struct ssi_drvdata *drvdata, struct cc_hw_desc *desc,
+int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
 		      unsigned int len);
 
-void complete_request(struct ssi_drvdata *drvdata);
+void complete_request(struct cc_drvdata *drvdata);
 
-void cc_req_mgr_fini(struct ssi_drvdata *drvdata);
+void cc_req_mgr_fini(struct cc_drvdata *drvdata);
 
 #if defined(CONFIG_PM)
-int cc_resume_req_queue(struct ssi_drvdata *drvdata);
+int cc_resume_req_queue(struct cc_drvdata *drvdata);
 
-int cc_suspend_req_queue(struct ssi_drvdata *drvdata);
+int cc_suspend_req_queue(struct cc_drvdata *drvdata);
 
-bool cc_req_queue_suspended(struct ssi_drvdata *drvdata);
+bool cc_req_queue_suspended(struct cc_drvdata *drvdata);
 #endif
 
 #endif /*__REQUEST_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index cbe5e3b..5d83af5 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -22,7 +22,7 @@
  * @sram_free_offset:   the offset to the non-allocated area
  */
 struct ssi_sram_mgr_ctx {
-	ssi_sram_addr_t sram_free_offset;
+	cc_sram_addr_t sram_free_offset;
 };
 
 /**
@@ -30,7 +30,7 @@ struct ssi_sram_mgr_ctx {
  *
  * @drvdata: Associated device driver context
  */
-void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata)
+void ssi_sram_mgr_fini(struct cc_drvdata *drvdata)
 {
 	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
 
@@ -48,7 +48,7 @@ void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata)
  *
  * @drvdata: Associated device driver context
  */
-int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
+int ssi_sram_mgr_init(struct cc_drvdata *drvdata)
 {
 	/* Allocate "this" context */
 	drvdata->sram_mgr_handle = kzalloc(sizeof(*drvdata->sram_mgr_handle),
@@ -69,11 +69,11 @@ int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
  * \param drvdata
  * \param size The requested bytes to allocate
  */
-ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size)
+cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size)
 {
 	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
-	ssi_sram_addr_t p;
+	cc_sram_addr_t p;
 
 	if ((size & 0x3)) {
 		dev_err(dev, "Requested buffer size (%u) is not multiple of 4",
@@ -103,7 +103,7 @@ ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size)
  * @seq:	  A pointer to the given IN/OUT descriptor sequence
  * @seq_len:	  A pointer to the given IN/OUT sequence length
  */
-void cc_set_sram_desc(const u32 *src, ssi_sram_addr_t dst,
+void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
 		      unsigned int nelement, struct cc_hw_desc *seq,
 		      unsigned int *seq_len)
 {
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index fdd325b..52f5288 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -21,15 +21,15 @@
 #define CC_CC_SRAM_SIZE 4096
 #endif
 
-struct ssi_drvdata;
+struct cc_drvdata;
 
 /**
  * Address (offset) within CC internal SRAM
  */
 
-typedef u64 ssi_sram_addr_t;
+typedef u64 cc_sram_addr_t;
 
-#define NULL_SRAM_ADDR ((ssi_sram_addr_t)-1)
+#define NULL_SRAM_ADDR ((cc_sram_addr_t)-1)
 
 /*!
  * Initializes SRAM pool.
@@ -40,14 +40,14 @@ typedef u64 ssi_sram_addr_t;
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_sram_mgr_init(struct ssi_drvdata *drvdata);
+int ssi_sram_mgr_init(struct cc_drvdata *drvdata);
 
 /*!
  * Uninits SRAM pool.
  *
  * \param drvdata
  */
-void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata);
+void ssi_sram_mgr_fini(struct cc_drvdata *drvdata);
 
 /*!
  * Allocated buffer from SRAM pool.
@@ -58,7 +58,7 @@ void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata);
  * \param drvdata
  * \param size The requested bytes to allocate
  */
-ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size);
+cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size);
 
 /**
  * cc_set_sram_desc() - Create const descriptors sequence to
@@ -71,7 +71,7 @@ ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size);
  * @seq:	  A pointer to the given IN/OUT descriptor sequence
  * @seq_len:	  A pointer to the given IN/OUT sequence length
  */
-void cc_set_sram_desc(const u32 *src, ssi_sram_addr_t dst,
+void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
 		      unsigned int nelement, struct cc_hw_desc *seq,
 		      unsigned int *seq_len);
 
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 6b11a72..b2e58f5 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -22,12 +22,12 @@
 
 #ifdef ENABLE_CC_SYSFS
 
-static struct ssi_drvdata *sys_get_drvdata(void);
+static struct cc_drvdata *sys_get_drvdata(void);
 
 static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *buf)
 {
-	struct ssi_drvdata *drvdata = sys_get_drvdata();
+	struct cc_drvdata *drvdata = sys_get_drvdata();
 	u32 register_value;
 	int offset = 0;
 
@@ -86,7 +86,7 @@ struct sys_dir {
 	struct attribute_group sys_dir_attr_group;
 	struct attribute **sys_dir_attr_list;
 	u32 num_of_attrs;
-	struct ssi_drvdata *drvdata; /* Associated driver context */
+	struct cc_drvdata *drvdata; /* Associated driver context */
 };
 
 /* top level directory structures */
@@ -105,7 +105,7 @@ static struct kobj_attribute ssi_sys_top_level_attrs[] = {
 
 };
 
-static struct ssi_drvdata *sys_get_drvdata(void)
+static struct cc_drvdata *sys_get_drvdata(void)
 {
 	/* TODO: supporting multiple SeP devices would require avoiding
 	 * global "top_dir" and finding associated "top_dir" by traversing
@@ -114,7 +114,7 @@ static struct ssi_drvdata *sys_get_drvdata(void)
 	return sys_top_dir.drvdata;
 }
 
-static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
+static int sys_init_dir(struct sys_dir *sys_dir, struct cc_drvdata *drvdata,
 			struct kobject *parent_dir_kobj, const char *dir_name,
 			struct kobj_attribute *attrs, u32 num_of_attrs)
 {
@@ -169,7 +169,7 @@ static void sys_free_dir(struct sys_dir *sys_dir)
 	}
 }
 
-int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
+int ssi_sysfs_init(struct kobject *sys_dev_obj, struct cc_drvdata *drvdata)
 {
 	int retval;
 	struct device *dev = drvdata_to_dev(drvdata);
diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
index de68bc6..9833d18 100644
--- a/drivers/staging/ccree/ssi_sysfs.h
+++ b/drivers/staging/ccree/ssi_sysfs.h
@@ -24,9 +24,9 @@
 #include <asm/timex.h>
 
 /* forward declaration */
-struct ssi_drvdata;
+struct cc_drvdata;
 
-int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata);
+int ssi_sysfs_init(struct kobject *sys_dev_obj, struct cc_drvdata *drvdata);
 void ssi_sysfs_fini(void);
 
 #endif /*__CC_SYSFS_H__*/
-- 
2.7.4
