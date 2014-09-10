From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/3] crypto: qat: Removed unneeded partial state
Date: Wed, 10 Sep 2014 14:07:36 -0700
Message-ID: <20140910210736.25455.16440.stgit@tstruk-mobl1>
References: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com, qat-linux@intel.com,
	conor.mcloughlin@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44156 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbaIJVJ3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Sep 2014 17:09:29 -0400
In-Reply-To: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Removed additional bufer for HW state for partial requests, which are not going
to be supported.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |   66 +++---------------------------
 1 file changed, 7 insertions(+), 59 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 59df488..3e26fa2 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -105,7 +105,7 @@ struct qat_alg_cd {
 #define MAX_AUTH_STATE_SIZE sizeof(struct icp_qat_hw_auth_algo_blk)
 
 struct qat_auth_state {
-	uint8_t data[MAX_AUTH_STATE_SIZE];
+	uint8_t data[MAX_AUTH_STATE_SIZE + 64];
 } __aligned(64);
 
 struct qat_alg_session_ctx {
@@ -113,10 +113,6 @@ struct qat_alg_session_ctx {
 	dma_addr_t enc_cd_paddr;
 	struct qat_alg_cd *dec_cd;
 	dma_addr_t dec_cd_paddr;
-	struct qat_auth_state *auth_hw_state_enc;
-	dma_addr_t auth_state_enc_paddr;
-	struct qat_auth_state *auth_hw_state_dec;
-	dma_addr_t auth_state_dec_paddr;
 	struct icp_qat_fw_la_bulk_req enc_fw_req_tmpl;
 	struct icp_qat_fw_la_bulk_req dec_fw_req_tmpl;
 	struct qat_crypto_instance *inst;
@@ -150,8 +146,9 @@ static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 				  struct qat_alg_session_ctx *ctx,
 				  const uint8_t *auth_key,
-				  unsigned int auth_keylen, uint8_t *auth_state)
+				  unsigned int auth_keylen)
 {
+	struct qat_auth_state auth_state;
 	struct {
 		struct shash_desc shash;
 		char ctx[crypto_shash_descsize(ctx->hash_tfm)];
@@ -161,12 +158,13 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	struct sha512_state sha512;
 	int block_size = crypto_shash_blocksize(ctx->hash_tfm);
 	int digest_size = crypto_shash_digestsize(ctx->hash_tfm);
-	uint8_t *ipad = auth_state;
+	uint8_t *ipad = auth_state.data;
 	uint8_t *opad = ipad + block_size;
 	__be32 *hash_state_out;
 	__be64 *hash512_state_out;
 	int i, offset;
 
+	memset(auth_state.data, '\0', MAX_AUTH_STATE_SIZE + 64);
 	desc.shash.tfm = ctx->hash_tfm;
 	desc.shash.flags = 0x0;
 
@@ -298,10 +296,6 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	void *ptr = &req_tmpl->cd_ctrl;
 	struct icp_qat_fw_cipher_cd_ctrl_hdr *cipher_cd_ctrl = ptr;
 	struct icp_qat_fw_auth_cd_ctrl_hdr *hash_cd_ctrl = ptr;
-	struct icp_qat_fw_la_auth_req_params *auth_param =
-		(struct icp_qat_fw_la_auth_req_params *)
-		((char *)&req_tmpl->serv_specif_rqpars +
-		 sizeof(struct icp_qat_fw_la_cipher_req_params));
 
 	/* CD setup */
 	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_ENC(alg);
@@ -312,8 +306,7 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	hash->sha.inner_setup.auth_counter.counter =
 		cpu_to_be32(crypto_shash_blocksize(ctx->hash_tfm));
 
-	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen,
-				   (uint8_t *)ctx->auth_hw_state_enc))
+	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
 		return -EFAULT;
 
 	/* Request setup */
@@ -359,9 +352,6 @@ static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
 	hash_cd_ctrl->inner_state2_offset = hash_cd_ctrl->hash_cfg_offset +
 			((sizeof(struct icp_qat_hw_auth_setup) +
 			 round_up(hash_cd_ctrl->inner_state1_sz, 8)) >> 3);
-	auth_param->u1.auth_partial_st_prefix = ctx->auth_state_enc_paddr +
-			sizeof(struct icp_qat_hw_auth_counter) +
-			round_up(hash_cd_ctrl->inner_state1_sz, 8);
 	ICP_QAT_FW_COMN_CURR_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_AUTH);
 	ICP_QAT_FW_COMN_NEXT_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_DRAM_WR);
 	return 0;
@@ -399,8 +389,7 @@ static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
 	hash->sha.inner_setup.auth_counter.counter =
 		cpu_to_be32(crypto_shash_blocksize(ctx->hash_tfm));
 
-	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen,
-				   (uint8_t *)ctx->auth_hw_state_dec))
+	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
 		return -EFAULT;
 
 	/* Request setup */
@@ -450,9 +439,6 @@ static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
 	hash_cd_ctrl->inner_state2_offset = hash_cd_ctrl->hash_cfg_offset +
 			((sizeof(struct icp_qat_hw_auth_setup) +
 			 round_up(hash_cd_ctrl->inner_state1_sz, 8)) >> 3);
-	auth_param->u1.auth_partial_st_prefix = ctx->auth_state_enc_paddr +
-			sizeof(struct icp_qat_hw_auth_counter) +
-			round_up(hash_cd_ctrl->inner_state1_sz, 8);
 	auth_param->auth_res_sz = digestsize;
 	ICP_QAT_FW_COMN_CURR_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_AUTH);
 	ICP_QAT_FW_COMN_NEXT_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_CIPHER);
@@ -512,10 +498,6 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 		dev = &GET_DEV(ctx->inst->accel_dev);
 		memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
 		memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
-		memset(ctx->auth_hw_state_enc, 0,
-		       sizeof(struct qat_auth_state));
-		memset(ctx->auth_hw_state_dec, 0,
-		       sizeof(struct qat_auth_state));
 		memset(&ctx->enc_fw_req_tmpl, 0,
 		       sizeof(struct icp_qat_fw_la_bulk_req));
 		memset(&ctx->dec_fw_req_tmpl, 0,
@@ -548,22 +530,6 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 			spin_unlock(&ctx->lock);
 			goto out_free_enc;
 		}
-		ctx->auth_hw_state_enc =
-			dma_zalloc_coherent(dev, sizeof(struct qat_auth_state),
-					    &ctx->auth_state_enc_paddr,
-					    GFP_ATOMIC);
-		if (!ctx->auth_hw_state_enc) {
-			spin_unlock(&ctx->lock);
-			goto out_free_dec;
-		}
-		ctx->auth_hw_state_dec =
-			dma_zalloc_coherent(dev, sizeof(struct qat_auth_state),
-					    &ctx->auth_state_dec_paddr,
-					    GFP_ATOMIC);
-		if (!ctx->auth_hw_state_dec) {
-			spin_unlock(&ctx->lock);
-			goto out_free_auth_enc;
-		}
 	}
 	spin_unlock(&ctx->lock);
 	if (qat_alg_init_sessions(ctx, key, keylen))
@@ -572,14 +538,6 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	return 0;
 
 out_free_all:
-	dma_free_coherent(dev, sizeof(struct qat_auth_state),
-			  ctx->auth_hw_state_dec, ctx->auth_state_dec_paddr);
-	ctx->auth_hw_state_dec = NULL;
-out_free_auth_enc:
-	dma_free_coherent(dev, sizeof(struct qat_auth_state),
-			  ctx->auth_hw_state_enc, ctx->auth_state_enc_paddr);
-	ctx->auth_hw_state_enc = NULL;
-out_free_dec:
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
@@ -924,16 +882,6 @@ static void qat_alg_exit(struct crypto_tfm *tfm)
 	if (ctx->dec_cd)
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
-	if (ctx->auth_hw_state_enc)
-		dma_free_coherent(dev, sizeof(struct qat_auth_state),
-				  ctx->auth_hw_state_enc,
-				  ctx->auth_state_enc_paddr);
-
-	if (ctx->auth_hw_state_dec)
-		dma_free_coherent(dev, sizeof(struct qat_auth_state),
-				  ctx->auth_hw_state_dec,
-				  ctx->auth_state_dec_paddr);
-
 	qat_crypto_put_instance(inst);
 }
 
