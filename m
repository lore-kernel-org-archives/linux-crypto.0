From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - add support for cbc(aes) ablkcipher
Date: Mon, 08 Dec 2014 12:08:49 -0800
Message-ID: <20141208200849.15367.87433.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:22897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbaLHULw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 15:11:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for cbc(aes) ablkcipher.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Acked-by: Bruce W. Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_hw.h |    2 
 drivers/crypto/qat/qat_common/qat_algs.c   |  528 ++++++++++++++++++++++------
 drivers/crypto/qat/qat_common/qat_crypto.h |   15 +
 3 files changed, 433 insertions(+), 112 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
index 5031f8c..68f191b 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -301,5 +301,5 @@ struct icp_qat_hw_cipher_aes256_f8 {
 
 struct icp_qat_hw_cipher_algo_blk {
 	struct icp_qat_hw_cipher_aes256_f8 aes;
-};
+} __aligned(64);
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index e4e32d8..f32d0a5 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -63,15 +63,15 @@
 #include "icp_qat_fw.h"
 #include "icp_qat_fw_la.h"
 
-#define QAT_AES_HW_CONFIG_ENC(alg) \
+#define QAT_AES_HW_CONFIG_CBC_ENC(alg) \
 	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
-			ICP_QAT_HW_CIPHER_NO_CONVERT, \
-			ICP_QAT_HW_CIPHER_ENCRYPT)
+				       ICP_QAT_HW_CIPHER_NO_CONVERT, \
+				       ICP_QAT_HW_CIPHER_ENCRYPT)
 
-#define QAT_AES_HW_CONFIG_DEC(alg) \
+#define QAT_AES_HW_CONFIG_CBC_DEC(alg) \
 	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
-			ICP_QAT_HW_CIPHER_KEY_CONVERT, \
-			ICP_QAT_HW_CIPHER_DECRYPT)
+				       ICP_QAT_HW_CIPHER_KEY_CONVERT, \
+				       ICP_QAT_HW_CIPHER_DECRYPT)
 
 static atomic_t active_dev;
 
@@ -108,19 +108,31 @@ struct qat_auth_state {
 	uint8_t data[MAX_AUTH_STATE_SIZE + 64];
 } __aligned(64);
 
-struct qat_alg_session_ctx {
+struct qat_alg_aead_ctx {
 	struct qat_alg_cd *enc_cd;
-	dma_addr_t enc_cd_paddr;
 	struct qat_alg_cd *dec_cd;
+	dma_addr_t enc_cd_paddr;
 	dma_addr_t dec_cd_paddr;
-	struct icp_qat_fw_la_bulk_req enc_fw_req_tmpl;
-	struct icp_qat_fw_la_bulk_req dec_fw_req_tmpl;
-	struct qat_crypto_instance *inst;
-	struct crypto_tfm *tfm;
+	struct icp_qat_fw_la_bulk_req enc_fw_req;
+	struct icp_qat_fw_la_bulk_req dec_fw_req;
 	struct crypto_shash *hash_tfm;
 	enum icp_qat_hw_auth_algo qat_hash_alg;
+	struct qat_crypto_instance *inst;
+	struct crypto_tfm *tfm;
 	uint8_t salt[AES_BLOCK_SIZE];
-	spinlock_t lock;	/* protects qat_alg_session_ctx struct */
+	spinlock_t lock;	/* protects qat_alg_aead_ctx struct */
+};
+
+struct qat_alg_ablkcipher_ctx {
+	struct icp_qat_hw_cipher_algo_blk *enc_cd;
+	struct icp_qat_hw_cipher_algo_blk *dec_cd;
+	dma_addr_t enc_cd_paddr;
+	dma_addr_t dec_cd_paddr;
+	struct icp_qat_fw_la_bulk_req enc_fw_req;
+	struct icp_qat_fw_la_bulk_req dec_fw_req;
+	struct qat_crypto_instance *inst;
+	struct crypto_tfm *tfm;
+	spinlock_t lock;	/* protects qat_alg_ablkcipher_ctx struct */
 };
 
 static int get_current_node(void)
@@ -144,7 +156,7 @@ static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 }
 
 static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
-				  struct qat_alg_session_ctx *ctx,
+				  struct qat_alg_aead_ctx *ctx,
 				  const uint8_t *auth_key,
 				  unsigned int auth_keylen)
 {
@@ -267,8 +279,6 @@ static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 	header->comn_req_flags =
 		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
 					    QAT_COMN_PTR_TYPE_SGL);
-	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
-					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
 	ICP_QAT_FW_LA_PARTIAL_SET(header->serv_specif_flags,
 				  ICP_QAT_FW_LA_PARTIAL_NONE);
 	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
@@ -279,8 +289,9 @@ static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
 }
 
-static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
-				    int alg, struct crypto_authenc_keys *keys)
+static int qat_alg_aead_init_enc_session(struct qat_alg_aead_ctx *ctx,
+					 int alg,
+					 struct crypto_authenc_keys *keys)
 {
 	struct crypto_aead *aead_tfm = __crypto_aead_cast(ctx->tfm);
 	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
@@ -289,7 +300,7 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	struct icp_qat_hw_auth_algo_blk *hash =
 		(struct icp_qat_hw_auth_algo_blk *)((char *)enc_ctx +
 		sizeof(struct icp_qat_hw_auth_setup) + keys->enckeylen);
-	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->enc_fw_req_tmpl;
+	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->enc_fw_req;
 	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req_tmpl->cd_pars;
 	struct icp_qat_fw_comn_req_hdr *header = &req_tmpl->comn_hdr;
 	void *ptr = &req_tmpl->cd_ctrl;
@@ -297,7 +308,7 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	struct icp_qat_fw_auth_cd_ctrl_hdr *hash_cd_ctrl = ptr;
 
 	/* CD setup */
-	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_ENC(alg);
+	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_ENC(alg);
 	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
 	hash->sha.inner_setup.auth_config.config =
 		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
@@ -311,6 +322,8 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	/* Request setup */
 	qat_alg_init_common_hdr(header);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER_HASH;
+	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
 	ICP_QAT_FW_LA_RET_AUTH_SET(header->serv_specif_flags,
 				   ICP_QAT_FW_LA_RET_AUTH_RES);
 	ICP_QAT_FW_LA_CMP_AUTH_SET(header->serv_specif_flags,
@@ -356,8 +369,9 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	return 0;
 }
 
-static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
-				    int alg, struct crypto_authenc_keys *keys)
+static int qat_alg_aead_init_dec_session(struct qat_alg_aead_ctx *ctx,
+					 int alg,
+					 struct crypto_authenc_keys *keys)
 {
 	struct crypto_aead *aead_tfm = __crypto_aead_cast(ctx->tfm);
 	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
@@ -367,7 +381,7 @@ static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
 		(struct icp_qat_hw_cipher_algo_blk *)((char *)dec_ctx +
 		sizeof(struct icp_qat_hw_auth_setup) +
 		roundup(crypto_shash_digestsize(ctx->hash_tfm), 8) * 2);
-	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->dec_fw_req_tmpl;
+	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->dec_fw_req;
 	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req_tmpl->cd_pars;
 	struct icp_qat_fw_comn_req_hdr *header = &req_tmpl->comn_hdr;
 	void *ptr = &req_tmpl->cd_ctrl;
@@ -379,7 +393,7 @@ static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
 		sizeof(struct icp_qat_fw_la_cipher_req_params));
 
 	/* CD setup */
-	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_DEC(alg);
+	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_DEC(alg);
 	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
 	hash->sha.inner_setup.auth_config.config =
 		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
@@ -394,6 +408,8 @@ static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
 	/* Request setup */
 	qat_alg_init_common_hdr(header);
 	header->service_cmd_id = ICP_QAT_FW_LA_CMD_HASH_CIPHER;
+	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
 	ICP_QAT_FW_LA_RET_AUTH_SET(header->serv_specif_flags,
 				   ICP_QAT_FW_LA_NO_RET_AUTH_RES);
 	ICP_QAT_FW_LA_CMP_AUTH_SET(header->serv_specif_flags,
@@ -444,36 +460,91 @@ static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
 	return 0;
 }
 
-static int qat_alg_init_sessions(struct qat_alg_session_ctx *ctx,
-				 const uint8_t *key, unsigned int keylen)
+static void qat_alg_ablkcipher_init_com(struct qat_alg_ablkcipher_ctx *ctx,
+					struct icp_qat_fw_la_bulk_req *req,
+					struct icp_qat_hw_cipher_algo_blk *cd,
+					const uint8_t *key, unsigned int keylen)
 {
-	struct crypto_authenc_keys keys;
-	int alg;
+	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req->cd_pars;
+	struct icp_qat_fw_comn_req_hdr *header = &req->comn_hdr;
+	struct icp_qat_fw_cipher_cd_ctrl_hdr *cd_ctrl = (void *)&req->cd_ctrl;
 
-	if (crypto_rng_get_bytes(crypto_default_rng, ctx->salt, AES_BLOCK_SIZE))
-		return -EFAULT;
+	memcpy(cd->aes.key, key, keylen);
+	qat_alg_init_common_hdr(header);
+	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER;
+	cd_pars->u.s.content_desc_params_sz =
+				sizeof(struct icp_qat_hw_cipher_algo_blk) >> 3;
+	/* Cipher CD config setup */
+	cd_ctrl->cipher_key_sz = keylen >> 3;
+	cd_ctrl->cipher_state_sz = AES_BLOCK_SIZE >> 3;
+	cd_ctrl->cipher_cfg_offset = 0;
+	ICP_QAT_FW_COMN_CURR_ID_SET(cd_ctrl, ICP_QAT_FW_SLICE_CIPHER);
+	ICP_QAT_FW_COMN_NEXT_ID_SET(cd_ctrl, ICP_QAT_FW_SLICE_DRAM_WR);
+}
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen))
-		goto bad_key;
+static void qat_alg_ablkcipher_init_enc(struct qat_alg_ablkcipher_ctx *ctx,
+					int alg, const uint8_t *key,
+					unsigned int keylen)
+{
+	struct icp_qat_hw_cipher_algo_blk *enc_cd = ctx->enc_cd;
+	struct icp_qat_fw_la_bulk_req *req = &ctx->enc_fw_req;
+	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req->cd_pars;
 
-	switch (keys.enckeylen) {
+	qat_alg_ablkcipher_init_com(ctx, req, enc_cd, key, keylen);
+	cd_pars->u.s.content_desc_addr = ctx->enc_cd_paddr;
+	enc_cd->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_ENC(alg);
+}
+
+static void qat_alg_ablkcipher_init_dec(struct qat_alg_ablkcipher_ctx *ctx,
+					int alg, const uint8_t *key,
+					unsigned int keylen)
+{
+	struct icp_qat_hw_cipher_algo_blk *dec_cd = ctx->dec_cd;
+	struct icp_qat_fw_la_bulk_req *req = &ctx->dec_fw_req;
+	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req->cd_pars;
+
+	qat_alg_ablkcipher_init_com(ctx, req, dec_cd, key, keylen);
+	cd_pars->u.s.content_desc_addr = ctx->dec_cd_paddr;
+	dec_cd->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_DEC(alg);
+}
+
+static int qat_alg_validate_key(int key_len, int *alg)
+{
+	switch (key_len) {
 	case AES_KEYSIZE_128:
-		alg = ICP_QAT_HW_CIPHER_ALGO_AES128;
+		*alg = ICP_QAT_HW_CIPHER_ALGO_AES128;
 		break;
 	case AES_KEYSIZE_192:
-		alg = ICP_QAT_HW_CIPHER_ALGO_AES192;
+		*alg = ICP_QAT_HW_CIPHER_ALGO_AES192;
 		break;
 	case AES_KEYSIZE_256:
-		alg = ICP_QAT_HW_CIPHER_ALGO_AES256;
+		*alg = ICP_QAT_HW_CIPHER_ALGO_AES256;
 		break;
 	default:
-		goto bad_key;
+		return -EINVAL;
 	}
+	return 0;
+}
 
-	if (qat_alg_init_enc_session(ctx, alg, &keys))
+static int qat_alg_aead_init_sessions(struct qat_alg_aead_ctx *ctx,
+				      const uint8_t *key, unsigned int keylen)
+{
+	struct crypto_authenc_keys keys;
+	int alg;
+
+	if (crypto_rng_get_bytes(crypto_default_rng, ctx->salt, AES_BLOCK_SIZE))
+		return -EFAULT;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen))
+		goto bad_key;
+
+	if (qat_alg_validate_key(keys.enckeylen, &alg))
+		goto bad_key;
+
+	if (qat_alg_aead_init_enc_session(ctx, alg, &keys))
 		goto error;
 
-	if (qat_alg_init_dec_session(ctx, alg, &keys))
+	if (qat_alg_aead_init_dec_session(ctx, alg, &keys))
 		goto error;
 
 	return 0;
@@ -484,22 +555,37 @@ error:
 	return -EFAULT;
 }
 
-static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
-			  unsigned int keylen)
+static int qat_alg_ablkcipher_init_sessions(struct qat_alg_ablkcipher_ctx *ctx,
+					    const uint8_t *key,
+					    unsigned int keylen)
 {
-	struct qat_alg_session_ctx *ctx = crypto_aead_ctx(tfm);
+	int alg;
+
+	if (qat_alg_validate_key(keylen, &alg))
+		goto bad_key;
+
+	qat_alg_ablkcipher_init_enc(ctx, alg, key, keylen);
+	qat_alg_ablkcipher_init_dec(ctx, alg, key, keylen);
+	return 0;
+bad_key:
+	crypto_tfm_set_flags(ctx->tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
+			       unsigned int keylen)
+{
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev;
 
 	spin_lock(&ctx->lock);
 	if (ctx->enc_cd) {
 		/* rekeying */
 		dev = &GET_DEV(ctx->inst->accel_dev);
-		memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
-		memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
-		memzero_explicit(&ctx->enc_fw_req_tmpl,
-				 sizeof(struct icp_qat_fw_la_bulk_req));
-		memzero_explicit(&ctx->dec_fw_req_tmpl,
-				 sizeof(struct icp_qat_fw_la_bulk_req));
+		memzero_explicit(ctx->enc_cd, sizeof(*ctx->enc_cd));
+		memzero_explicit(ctx->dec_cd, sizeof(*ctx->dec_cd));
+		memzero_explicit(&ctx->enc_fw_req, sizeof(ctx->enc_fw_req));
+		memzero_explicit(&ctx->dec_fw_req, sizeof(ctx->dec_fw_req));
 	} else {
 		/* new key */
 		int node = get_current_node();
@@ -512,16 +598,14 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 
 		dev = &GET_DEV(inst->accel_dev);
 		ctx->inst = inst;
-		ctx->enc_cd = dma_zalloc_coherent(dev,
-						  sizeof(struct qat_alg_cd),
+		ctx->enc_cd = dma_zalloc_coherent(dev, sizeof(*ctx->enc_cd),
 						  &ctx->enc_cd_paddr,
 						  GFP_ATOMIC);
 		if (!ctx->enc_cd) {
 			spin_unlock(&ctx->lock);
 			return -ENOMEM;
 		}
-		ctx->dec_cd = dma_zalloc_coherent(dev,
-						  sizeof(struct qat_alg_cd),
+		ctx->dec_cd = dma_zalloc_coherent(dev, sizeof(*ctx->dec_cd),
 						  &ctx->dec_cd_paddr,
 						  GFP_ATOMIC);
 		if (!ctx->dec_cd) {
@@ -530,7 +614,7 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 		}
 	}
 	spin_unlock(&ctx->lock);
-	if (qat_alg_init_sessions(ctx, key, keylen))
+	if (qat_alg_aead_init_sessions(ctx, key, keylen))
 		goto out_free_all;
 
 	return 0;
@@ -722,14 +806,12 @@ err:
 	return -ENOMEM;
 }
 
-void qat_alg_callback(void *resp)
+static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
+				  struct qat_crypto_request *qat_req)
 {
-	struct icp_qat_fw_la_resp *qat_resp = resp;
-	struct qat_crypto_request *qat_req =
-				(void *)(__force long)qat_resp->opaque_data;
-	struct qat_alg_session_ctx *ctx = qat_req->ctx;
+	struct qat_alg_aead_ctx *ctx = qat_req->aead_ctx;
 	struct qat_crypto_instance *inst = ctx->inst;
-	struct aead_request *areq = qat_req->areq;
+	struct aead_request *areq = qat_req->aead_req;
 	uint8_t stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
@@ -739,11 +821,35 @@ void qat_alg_callback(void *resp)
 	areq->base.complete(&areq->base, res);
 }
 
-static int qat_alg_dec(struct aead_request *areq)
+static void qat_ablkcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
+					struct qat_crypto_request *qat_req)
+{
+	struct qat_alg_ablkcipher_ctx *ctx = qat_req->ablkcipher_ctx;
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct ablkcipher_request *areq = qat_req->ablkcipher_req;
+	uint8_t stat_filed = qat_resp->comn_resp.comn_status;
+	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
+
+	qat_alg_free_bufl(inst, qat_req);
+	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
+		res = -EINVAL;
+	areq->base.complete(&areq->base, res);
+}
+
+void qat_alg_callback(void *resp)
+{
+	struct icp_qat_fw_la_resp *qat_resp = resp;
+	struct qat_crypto_request *qat_req =
+				(void *)(__force long)qat_resp->opaque_data;
+
+	qat_req->cb(qat_resp, qat_req);
+}
+
+static int qat_alg_aead_dec(struct aead_request *areq)
 {
 	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(areq);
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
-	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_crypto_request *qat_req = aead_request_ctx(areq);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_auth_req_params *auth_param;
@@ -757,9 +863,10 @@ static int qat_alg_dec(struct aead_request *areq)
 		return ret;
 
 	msg = &qat_req->req;
-	*msg = ctx->dec_fw_req_tmpl;
-	qat_req->ctx = ctx;
-	qat_req->areq = areq;
+	*msg = ctx->dec_fw_req;
+	qat_req->aead_ctx = ctx;
+	qat_req->aead_req = areq;
+	qat_req->cb = qat_aead_alg_callback;
 	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
@@ -782,12 +889,12 @@ static int qat_alg_dec(struct aead_request *areq)
 	return -EINPROGRESS;
 }
 
-static int qat_alg_enc_internal(struct aead_request *areq, uint8_t *iv,
-				int enc_iv)
+static int qat_alg_aead_enc_internal(struct aead_request *areq, uint8_t *iv,
+				     int enc_iv)
 {
 	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(areq);
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
-	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_crypto_request *qat_req = aead_request_ctx(areq);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_auth_req_params *auth_param;
@@ -800,9 +907,10 @@ static int qat_alg_enc_internal(struct aead_request *areq, uint8_t *iv,
 		return ret;
 
 	msg = &qat_req->req;
-	*msg = ctx->enc_fw_req_tmpl;
-	qat_req->ctx = ctx;
-	qat_req->areq = areq;
+	*msg = ctx->enc_fw_req;
+	qat_req->aead_ctx = ctx;
+	qat_req->aead_req = areq;
+	qat_req->cb = qat_aead_alg_callback;
 	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
@@ -831,29 +939,167 @@ static int qat_alg_enc_internal(struct aead_request *areq, uint8_t *iv,
 	return -EINPROGRESS;
 }
 
-static int qat_alg_enc(struct aead_request *areq)
+static int qat_alg_aead_enc(struct aead_request *areq)
 {
-	return qat_alg_enc_internal(areq, areq->iv, 0);
+	return qat_alg_aead_enc_internal(areq, areq->iv, 0);
 }
 
-static int qat_alg_genivenc(struct aead_givcrypt_request *req)
+static int qat_alg_aead_genivenc(struct aead_givcrypt_request *req)
 {
 	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(&req->areq);
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
-	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 	__be64 seq;
 
 	memcpy(req->giv, ctx->salt, AES_BLOCK_SIZE);
 	seq = cpu_to_be64(req->seq);
 	memcpy(req->giv + AES_BLOCK_SIZE - sizeof(uint64_t),
 	       &seq, sizeof(uint64_t));
-	return qat_alg_enc_internal(&req->areq, req->giv, 1);
+	return qat_alg_aead_enc_internal(&req->areq, req->giv, 1);
 }
 
-static int qat_alg_init(struct crypto_tfm *tfm,
-			enum icp_qat_hw_auth_algo hash, const char *hash_name)
+static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
+				     const uint8_t *key,
+				     unsigned int keylen)
 {
-	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct device *dev;
+
+	spin_lock(&ctx->lock);
+	if (ctx->enc_cd) {
+		/* rekeying */
+		dev = &GET_DEV(ctx->inst->accel_dev);
+		memzero_explicit(ctx->enc_cd, sizeof(*ctx->enc_cd));
+		memzero_explicit(ctx->dec_cd, sizeof(*ctx->dec_cd));
+		memzero_explicit(&ctx->enc_fw_req, sizeof(ctx->enc_fw_req));
+		memzero_explicit(&ctx->dec_fw_req, sizeof(ctx->dec_fw_req));
+	} else {
+		/* new key */
+		int node = get_current_node();
+		struct qat_crypto_instance *inst =
+				qat_crypto_get_instance_node(node);
+		if (!inst) {
+			spin_unlock(&ctx->lock);
+			return -EINVAL;
+		}
+
+		dev = &GET_DEV(inst->accel_dev);
+		ctx->inst = inst;
+		ctx->enc_cd = dma_zalloc_coherent(dev, sizeof(*ctx->enc_cd),
+						  &ctx->enc_cd_paddr,
+						  GFP_ATOMIC);
+		if (!ctx->enc_cd) {
+			spin_unlock(&ctx->lock);
+			return -ENOMEM;
+		}
+		ctx->dec_cd = dma_zalloc_coherent(dev, sizeof(*ctx->dec_cd),
+						  &ctx->dec_cd_paddr,
+						  GFP_ATOMIC);
+		if (!ctx->dec_cd) {
+			spin_unlock(&ctx->lock);
+			goto out_free_enc;
+		}
+	}
+	spin_unlock(&ctx->lock);
+	if (qat_alg_ablkcipher_init_sessions(ctx, key, keylen))
+		goto out_free_all;
+
+	return 0;
+
+out_free_all:
+	memzero_explicit(ctx->dec_cd, sizeof(*ctx->enc_cd));
+	dma_free_coherent(dev, sizeof(*ctx->enc_cd),
+			  ctx->dec_cd, ctx->dec_cd_paddr);
+	ctx->dec_cd = NULL;
+out_free_enc:
+	memzero_explicit(ctx->enc_cd, sizeof(*ctx->dec_cd));
+	dma_free_coherent(dev, sizeof(*ctx->dec_cd),
+			  ctx->enc_cd, ctx->enc_cd_paddr);
+	ctx->enc_cd = NULL;
+	return -ENOMEM;
+}
+
+static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *atfm = crypto_ablkcipher_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(atfm);
+	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_crypto_request *qat_req = ablkcipher_request_ctx(req);
+	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	struct icp_qat_fw_la_bulk_req *msg;
+	int ret, ctr = 0;
+
+	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, req->src, req->dst,
+				  NULL, 0, qat_req);
+	if (unlikely(ret))
+		return ret;
+
+	msg = &qat_req->req;
+	*msg = ctx->enc_fw_req;
+	qat_req->ablkcipher_ctx = ctx;
+	qat_req->ablkcipher_req = req;
+	qat_req->cb = qat_ablkcipher_alg_callback;
+	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
+	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
+	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
+	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
+	cipher_param->cipher_length = req->nbytes;
+	cipher_param->cipher_offset = 0;
+	memcpy(cipher_param->u.cipher_IV_array, req->info, AES_BLOCK_SIZE);
+	do {
+		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+	} while (ret == -EAGAIN && ctr++ < 10);
+
+	if (ret == -EAGAIN) {
+		qat_alg_free_bufl(ctx->inst, qat_req);
+		return -EBUSY;
+	}
+	return -EINPROGRESS;
+}
+
+static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *atfm = crypto_ablkcipher_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(atfm);
+	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_crypto_request *qat_req = ablkcipher_request_ctx(req);
+	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	struct icp_qat_fw_la_bulk_req *msg;
+	int ret, ctr = 0;
+
+	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, req->src, req->dst,
+				  NULL, 0, qat_req);
+	if (unlikely(ret))
+		return ret;
+
+	msg = &qat_req->req;
+	*msg = ctx->dec_fw_req;
+	qat_req->ablkcipher_ctx = ctx;
+	qat_req->ablkcipher_req = req;
+	qat_req->cb = qat_ablkcipher_alg_callback;
+	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
+	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
+	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
+	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
+	cipher_param->cipher_length = req->nbytes;
+	cipher_param->cipher_offset = 0;
+	memcpy(cipher_param->u.cipher_IV_array, req->info, AES_BLOCK_SIZE);
+	do {
+		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+	} while (ret == -EAGAIN && ctr++ < 10);
+
+	if (ret == -EAGAIN) {
+		qat_alg_free_bufl(ctx->inst, qat_req);
+		return -EBUSY;
+	}
+	return -EINPROGRESS;
+}
+
+static int qat_alg_aead_init(struct crypto_tfm *tfm,
+			     enum icp_qat_hw_auth_algo hash,
+			     const char *hash_name)
+{
+	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	memzero_explicit(ctx, sizeof(*ctx));
 	ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
@@ -867,24 +1113,24 @@ static int qat_alg_init(struct crypto_tfm *tfm,
 	return 0;
 }
 
-static int qat_alg_sha1_init(struct crypto_tfm *tfm)
+static int qat_alg_aead_sha1_init(struct crypto_tfm *tfm)
 {
-	return qat_alg_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA1, "sha1");
+	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA1, "sha1");
 }
 
-static int qat_alg_sha256_init(struct crypto_tfm *tfm)
+static int qat_alg_aead_sha256_init(struct crypto_tfm *tfm)
 {
-	return qat_alg_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA256, "sha256");
+	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA256, "sha256");
 }
 
-static int qat_alg_sha512_init(struct crypto_tfm *tfm)
+static int qat_alg_aead_sha512_init(struct crypto_tfm *tfm)
 {
-	return qat_alg_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA512, "sha512");
+	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA512, "sha512");
 }
 
-static void qat_alg_exit(struct crypto_tfm *tfm)
+static void qat_alg_aead_exit(struct crypto_tfm *tfm)
 {
-	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev;
 
@@ -908,24 +1154,63 @@ static void qat_alg_exit(struct crypto_tfm *tfm)
 	qat_crypto_put_instance(inst);
 }
 
+static int qat_alg_ablkcipher_init(struct crypto_tfm *tfm)
+{
+	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	memzero_explicit(ctx, sizeof(*ctx));
+	spin_lock_init(&ctx->lock);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+					sizeof(struct qat_crypto_request);
+	ctx->tfm = tfm;
+	return 0;
+}
+
+static void qat_alg_ablkcipher_exit(struct crypto_tfm *tfm)
+{
+	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct device *dev;
+
+	if (!inst)
+		return;
+
+	dev = &GET_DEV(inst->accel_dev);
+	if (ctx->enc_cd) {
+		memzero_explicit(ctx->enc_cd,
+				 sizeof(struct icp_qat_hw_cipher_algo_blk));
+		dma_free_coherent(dev,
+				  sizeof(struct icp_qat_hw_cipher_algo_blk),
+				  ctx->enc_cd, ctx->enc_cd_paddr);
+	}
+	if (ctx->dec_cd) {
+		memzero_explicit(ctx->dec_cd,
+				 sizeof(struct icp_qat_hw_cipher_algo_blk));
+		dma_free_coherent(dev,
+				  sizeof(struct icp_qat_hw_cipher_algo_blk),
+				  ctx->dec_cd, ctx->dec_cd_paddr);
+	}
+	qat_crypto_put_instance(inst);
+}
+
 static struct crypto_alg qat_algs[] = { {
 	.cra_name = "authenc(hmac(sha1),cbc(aes))",
 	.cra_driver_name = "qat_aes_cbc_hmac_sha1",
 	.cra_priority = 4001,
 	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct qat_alg_session_ctx),
+	.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 	.cra_alignmask = 0,
 	.cra_type = &crypto_aead_type,
 	.cra_module = THIS_MODULE,
-	.cra_init = qat_alg_sha1_init,
-	.cra_exit = qat_alg_exit,
+	.cra_init = qat_alg_aead_sha1_init,
+	.cra_exit = qat_alg_aead_exit,
 	.cra_u = {
 		.aead = {
-			.setkey = qat_alg_setkey,
-			.decrypt = qat_alg_dec,
-			.encrypt = qat_alg_enc,
-			.givencrypt = qat_alg_genivenc,
+			.setkey = qat_alg_aead_setkey,
+			.decrypt = qat_alg_aead_dec,
+			.encrypt = qat_alg_aead_enc,
+			.givencrypt = qat_alg_aead_genivenc,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
@@ -936,18 +1221,18 @@ static struct crypto_alg qat_algs[] = { {
 	.cra_priority = 4001,
 	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct qat_alg_session_ctx),
+	.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 	.cra_alignmask = 0,
 	.cra_type = &crypto_aead_type,
 	.cra_module = THIS_MODULE,
-	.cra_init = qat_alg_sha256_init,
-	.cra_exit = qat_alg_exit,
+	.cra_init = qat_alg_aead_sha256_init,
+	.cra_exit = qat_alg_aead_exit,
 	.cra_u = {
 		.aead = {
-			.setkey = qat_alg_setkey,
-			.decrypt = qat_alg_dec,
-			.encrypt = qat_alg_enc,
-			.givencrypt = qat_alg_genivenc,
+			.setkey = qat_alg_aead_setkey,
+			.decrypt = qat_alg_aead_dec,
+			.encrypt = qat_alg_aead_enc,
+			.givencrypt = qat_alg_aead_genivenc,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
@@ -958,22 +1243,44 @@ static struct crypto_alg qat_algs[] = { {
 	.cra_priority = 4001,
 	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct qat_alg_session_ctx),
+	.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 	.cra_alignmask = 0,
 	.cra_type = &crypto_aead_type,
 	.cra_module = THIS_MODULE,
-	.cra_init = qat_alg_sha512_init,
-	.cra_exit = qat_alg_exit,
+	.cra_init = qat_alg_aead_sha512_init,
+	.cra_exit = qat_alg_aead_exit,
 	.cra_u = {
 		.aead = {
-			.setkey = qat_alg_setkey,
-			.decrypt = qat_alg_dec,
-			.encrypt = qat_alg_enc,
-			.givencrypt = qat_alg_genivenc,
+			.setkey = qat_alg_aead_setkey,
+			.decrypt = qat_alg_aead_dec,
+			.encrypt = qat_alg_aead_enc,
+			.givencrypt = qat_alg_aead_genivenc,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
 	},
+}, {
+	.cra_name = "cbc(aes)",
+	.cra_driver_name = "qat_aes_cbc",
+	.cra_priority = 4001,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct qat_alg_ablkcipher_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = qat_alg_ablkcipher_init,
+	.cra_exit = qat_alg_ablkcipher_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.setkey = qat_alg_ablkcipher_setkey,
+			.decrypt = qat_alg_ablkcipher_decrypt,
+			.encrypt = qat_alg_ablkcipher_encrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+	},
 } };
 
 int qat_algs_register(void)
@@ -982,8 +1289,11 @@ int qat_algs_register(void)
 		int i;
 
 		for (i = 0; i < ARRAY_SIZE(qat_algs); i++)
-			qat_algs[i].cra_flags =	CRYPTO_ALG_TYPE_AEAD |
-						CRYPTO_ALG_ASYNC;
+			qat_algs[i].cra_flags =
+				(qat_algs[i].cra_type == &crypto_aead_type) ?
+				CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC :
+				CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+
 		return crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
 	}
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index fcb3231..d503007 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -75,10 +75,21 @@ struct qat_crypto_request_buffs {
 	size_t sz_out;
 };
 
+struct qat_crypto_request;
+
 struct qat_crypto_request {
 	struct icp_qat_fw_la_bulk_req req;
-	struct qat_alg_session_ctx *ctx;
-	struct aead_request *areq;
+	union {
+		struct qat_alg_aead_ctx *aead_ctx;
+		struct qat_alg_ablkcipher_ctx *ablkcipher_ctx;
+	};
+	union {
+		struct aead_request *aead_req;
+		struct ablkcipher_request *ablkcipher_req;
+	};
 	struct qat_crypto_request_buffs buf;
+	void (*cb)(struct icp_qat_fw_la_resp *resp,
+		   struct qat_crypto_request *req);
 };
+
 #endif
