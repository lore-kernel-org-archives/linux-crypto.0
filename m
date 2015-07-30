From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Thu, 30 Jul 2015 17:53:20 +0800
Message-ID: <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41512 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbbG3Jx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts qat to the new AEAD interface.  IV generation
has been removed since it's equivalent to a software implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qat/qat_common/qat_algs.c |  319 +++++++++++--------------------
 1 file changed, 116 insertions(+), 203 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 9b25ab1..45420a6 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -53,7 +53,6 @@
 #include <crypto/hash.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/rng.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -113,9 +112,6 @@ struct qat_alg_aead_ctx {
 	struct crypto_shash *hash_tfm;
 	enum icp_qat_hw_auth_algo qat_hash_alg;
 	struct qat_crypto_instance *inst;
-	struct crypto_tfm *tfm;
-	uint8_t salt[AES_BLOCK_SIZE];
-	spinlock_t lock;	/* protects qat_alg_aead_ctx struct */
 };
 
 struct qat_alg_ablkcipher_ctx {
@@ -273,11 +269,11 @@ static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
 }
 
-static int qat_alg_aead_init_enc_session(struct qat_alg_aead_ctx *ctx,
+static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 					 int alg,
 					 struct crypto_authenc_keys *keys)
 {
-	struct crypto_aead *aead_tfm = __crypto_aead_cast(ctx->tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(aead_tfm);
 	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
 	struct qat_enc *enc_ctx = &ctx->enc_cd->qat_enc_cd;
 	struct icp_qat_hw_cipher_algo_blk *cipher = &enc_ctx->cipher;
@@ -353,11 +349,11 @@ static int qat_alg_aead_init_enc_session(struct qat_alg_aead_ctx *ctx,
 	return 0;
 }
 
-static int qat_alg_aead_init_dec_session(struct qat_alg_aead_ctx *ctx,
+static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 					 int alg,
 					 struct crypto_authenc_keys *keys)
 {
-	struct crypto_aead *aead_tfm = __crypto_aead_cast(ctx->tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(aead_tfm);
 	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
 	struct qat_dec *dec_ctx = &ctx->dec_cd->qat_dec_cd;
 	struct icp_qat_hw_auth_algo_blk *hash = &dec_ctx->hash;
@@ -510,30 +506,27 @@ static int qat_alg_validate_key(int key_len, int *alg)
 	return 0;
 }
 
-static int qat_alg_aead_init_sessions(struct qat_alg_aead_ctx *ctx,
+static int qat_alg_aead_init_sessions(struct crypto_aead *tfm,
 				      const uint8_t *key, unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
 	int alg;
 
-	if (crypto_rng_get_bytes(crypto_default_rng, ctx->salt, AES_BLOCK_SIZE))
-		return -EFAULT;
-
 	if (crypto_authenc_extractkeys(&keys, key, keylen))
 		goto bad_key;
 
 	if (qat_alg_validate_key(keys.enckeylen, &alg))
 		goto bad_key;
 
-	if (qat_alg_aead_init_enc_session(ctx, alg, &keys))
+	if (qat_alg_aead_init_enc_session(tfm, alg, &keys))
 		goto error;
 
-	if (qat_alg_aead_init_dec_session(ctx, alg, &keys))
+	if (qat_alg_aead_init_dec_session(tfm, alg, &keys))
 		goto error;
 
 	return 0;
 bad_key:
-	crypto_tfm_set_flags(ctx->tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
 error:
 	return -EFAULT;
@@ -562,7 +555,6 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev;
 
-	spin_lock(&ctx->lock);
 	if (ctx->enc_cd) {
 		/* rekeying */
 		dev = &GET_DEV(ctx->inst->accel_dev);
@@ -576,7 +568,6 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 		struct qat_crypto_instance *inst =
 				qat_crypto_get_instance_node(node);
 		if (!inst) {
-			spin_unlock(&ctx->lock);
 			return -EINVAL;
 		}
 
@@ -586,19 +577,16 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 						  &ctx->enc_cd_paddr,
 						  GFP_ATOMIC);
 		if (!ctx->enc_cd) {
-			spin_unlock(&ctx->lock);
 			return -ENOMEM;
 		}
 		ctx->dec_cd = dma_zalloc_coherent(dev, sizeof(*ctx->dec_cd),
 						  &ctx->dec_cd_paddr,
 						  GFP_ATOMIC);
 		if (!ctx->dec_cd) {
-			spin_unlock(&ctx->lock);
 			goto out_free_enc;
 		}
 	}
-	spin_unlock(&ctx->lock);
-	if (qat_alg_aead_init_sessions(ctx, key, keylen))
+	if (qat_alg_aead_init_sessions(tfm, key, keylen))
 		goto out_free_all;
 
 	return 0;
@@ -649,22 +637,20 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 }
 
 static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
-			       struct scatterlist *assoc, int assoclen,
 			       struct scatterlist *sgl,
-			       struct scatterlist *sglout, uint8_t *iv,
-			       uint8_t ivlen,
+			       struct scatterlist *sglout,
 			       struct qat_crypto_request *qat_req)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
-	int i, bufs = 0, sg_nctr = 0;
-	int n = sg_nents(sgl), assoc_n = sg_nents(assoc);
+	int i, sg_nctr = 0;
+	int n = sg_nents(sgl);
 	struct qat_alg_buf_list *bufl;
 	struct qat_alg_buf_list *buflout = NULL;
 	dma_addr_t blp;
 	dma_addr_t bloutp = 0;
 	struct scatterlist *sg;
 	size_t sz_out, sz = sizeof(struct qat_alg_buf_list) +
-			((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
+			((1 + n) * sizeof(struct qat_alg_buf));
 
 	if (unlikely(!n))
 		return -EINVAL;
@@ -678,35 +664,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (unlikely(dma_mapping_error(dev, blp)))
 		goto err;
 
-	for_each_sg(assoc, sg, assoc_n, i) {
-		if (!sg->length)
-			continue;
-
-		if (!(assoclen > 0))
-			break;
-
-		bufl->bufers[bufs].addr =
-			dma_map_single(dev, sg_virt(sg),
-				       min_t(int, assoclen, sg->length),
-				       DMA_BIDIRECTIONAL);
-		bufl->bufers[bufs].len = min_t(int, assoclen, sg->length);
-		if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
-			goto err;
-		bufs++;
-		assoclen -= sg->length;
-	}
-
-	if (ivlen) {
-		bufl->bufers[bufs].addr = dma_map_single(dev, iv, ivlen,
-							 DMA_BIDIRECTIONAL);
-		bufl->bufers[bufs].len = ivlen;
-		if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
-			goto err;
-		bufs++;
-	}
-
 	for_each_sg(sgl, sg, n, i) {
-		int y = sg_nctr + bufs;
+		int y = sg_nctr;
 
 		if (!sg->length)
 			continue;
@@ -719,7 +678,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			goto err;
 		sg_nctr++;
 	}
-	bufl->num_bufs = sg_nctr + bufs;
+	bufl->num_bufs = sg_nctr;
 	qat_req->buf.bl = bufl;
 	qat_req->buf.blp = blp;
 	qat_req->buf.sz = sz;
@@ -729,7 +688,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 
 		n = sg_nents(sglout);
 		sz_out = sizeof(struct qat_alg_buf_list) +
-			((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
+			((1 + n) * sizeof(struct qat_alg_buf));
 		sg_nctr = 0;
 		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
 				       dev_to_node(&GET_DEV(inst->accel_dev)));
@@ -739,14 +698,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		if (unlikely(dma_mapping_error(dev, bloutp)))
 			goto err;
 		bufers = buflout->bufers;
-		/* For out of place operation dma map only data and
-		 * reuse assoc mapping and iv */
-		for (i = 0; i < bufs; i++) {
-			bufers[i].len = bufl->bufers[i].len;
-			bufers[i].addr = bufl->bufers[i].addr;
-		}
 		for_each_sg(sglout, sg, n, i) {
-			int y = sg_nctr + bufs;
+			int y = sg_nctr;
 
 			if (!sg->length)
 				continue;
@@ -759,7 +712,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			bufers[y].len = sg->length;
 			sg_nctr++;
 		}
-		buflout->num_bufs = sg_nctr + bufs;
+		buflout->num_bufs = sg_nctr;
 		buflout->num_mapped_bufs = sg_nctr;
 		qat_req->buf.blout = buflout;
 		qat_req->buf.bloutp = bloutp;
@@ -773,7 +726,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 err:
 	dev_err(dev, "Failed to map buf for dma\n");
 	sg_nctr = 0;
-	for (i = 0; i < n + bufs; i++)
+	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
 			dma_unmap_single(dev, bufl->bufers[i].addr,
 					 bufl->bufers[i].len,
@@ -784,7 +737,7 @@ err:
 	kfree(bufl);
 	if (sgl != sglout && buflout) {
 		n = sg_nents(sglout);
-		for (i = bufs; i < n + bufs; i++)
+		for (i = 0; i < n; i++)
 			if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 				dma_unmap_single(dev, buflout->bufers[i].addr,
 						 buflout->bufers[i].len,
@@ -847,9 +800,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	int digst_size = crypto_aead_crt(aead_tfm)->authsize;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->assoclen,
-				  areq->src, areq->dst, areq->iv,
-				  AES_BLOCK_SIZE, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
 
@@ -863,12 +814,11 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = areq->cryptlen - digst_size;
-	cipher_param->cipher_offset = areq->assoclen + AES_BLOCK_SIZE;
+	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
 	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
 	auth_param->auth_off = 0;
-	auth_param->auth_len = areq->assoclen +
-				cipher_param->cipher_length + AES_BLOCK_SIZE;
+	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
@@ -880,8 +830,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	return -EINPROGRESS;
 }
 
-static int qat_alg_aead_enc_internal(struct aead_request *areq, uint8_t *iv,
-				     int enc_iv)
+static int qat_alg_aead_enc(struct aead_request *areq)
 {
 	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(areq);
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
@@ -890,11 +839,10 @@ static int qat_alg_aead_enc_internal(struct aead_request *areq, uint8_t *iv,
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
+	uint8_t *iv = areq->iv;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->assoclen,
-				  areq->src, areq->dst, iv, AES_BLOCK_SIZE,
-				  qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
 
@@ -909,16 +857,12 @@ static int qat_alg_aead_enc_internal(struct aead_request *areq, uint8_t *iv,
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
 
-	if (enc_iv) {
-		cipher_param->cipher_length = areq->cryptlen + AES_BLOCK_SIZE;
-		cipher_param->cipher_offset = areq->assoclen;
-	} else {
-		memcpy(cipher_param->u.cipher_IV_array, iv, AES_BLOCK_SIZE);
-		cipher_param->cipher_length = areq->cryptlen;
-		cipher_param->cipher_offset = areq->assoclen + AES_BLOCK_SIZE;
-	}
+	memcpy(cipher_param->u.cipher_IV_array, iv, AES_BLOCK_SIZE);
+	cipher_param->cipher_length = areq->cryptlen;
+	cipher_param->cipher_offset = areq->assoclen;
+
 	auth_param->auth_off = 0;
-	auth_param->auth_len = areq->assoclen + areq->cryptlen + AES_BLOCK_SIZE;
+	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
 	do {
 		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
@@ -931,25 +875,6 @@ static int qat_alg_aead_enc_internal(struct aead_request *areq, uint8_t *iv,
 	return -EINPROGRESS;
 }
 
-static int qat_alg_aead_enc(struct aead_request *areq)
-{
-	return qat_alg_aead_enc_internal(areq, areq->iv, 0);
-}
-
-static int qat_alg_aead_genivenc(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(&req->areq);
-	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
-	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
-	__be64 seq;
-
-	memcpy(req->giv, ctx->salt, AES_BLOCK_SIZE);
-	seq = cpu_to_be64(req->seq);
-	memcpy(req->giv + AES_BLOCK_SIZE - sizeof(uint64_t),
-	       &seq, sizeof(uint64_t));
-	return qat_alg_aead_enc_internal(&req->areq, req->giv, 1);
-}
-
 static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 				     const uint8_t *key,
 				     unsigned int keylen)
@@ -1021,8 +946,7 @@ static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, 0, req->src, req->dst,
-				  NULL, 0, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
 
@@ -1059,8 +983,7 @@ static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, 0, req->src, req->dst,
-				  NULL, 0, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
 
@@ -1087,47 +1010,43 @@ static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return -EINPROGRESS;
 }
 
-static int qat_alg_aead_init(struct crypto_tfm *tfm,
+static int qat_alg_aead_init(struct crypto_aead *tfm,
 			     enum icp_qat_hw_auth_algo hash,
 			     const char *hash_name)
 {
-	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
 	ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
 	if (IS_ERR(ctx->hash_tfm))
-		return -EFAULT;
-	spin_lock_init(&ctx->lock);
+		return PTR_ERR(ctx->hash_tfm);
 	ctx->qat_hash_alg = hash;
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-		sizeof(struct aead_request) +
-		sizeof(struct qat_crypto_request));
-	ctx->tfm = tfm;
+	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
+				     sizeof(struct qat_crypto_request));
 	return 0;
 }
 
-static int qat_alg_aead_sha1_init(struct crypto_tfm *tfm)
+static int qat_alg_aead_sha1_init(struct crypto_aead *tfm)
 {
 	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA1, "sha1");
 }
 
-static int qat_alg_aead_sha256_init(struct crypto_tfm *tfm)
+static int qat_alg_aead_sha256_init(struct crypto_aead *tfm)
 {
 	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA256, "sha256");
 }
 
-static int qat_alg_aead_sha512_init(struct crypto_tfm *tfm)
+static int qat_alg_aead_sha512_init(struct crypto_aead *tfm)
 {
 	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA512, "sha512");
 }
 
-static void qat_alg_aead_exit(struct crypto_tfm *tfm)
+static void qat_alg_aead_exit(struct crypto_aead *tfm)
 {
-	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev;
 
-	if (!IS_ERR(ctx->hash_tfm))
-		crypto_free_shash(ctx->hash_tfm);
+	crypto_free_shash(ctx->hash_tfm);
 
 	if (!inst)
 		return;
@@ -1184,73 +1103,61 @@ static void qat_alg_ablkcipher_exit(struct crypto_tfm *tfm)
 	qat_crypto_put_instance(inst);
 }
 
-static struct crypto_alg qat_algs[] = { {
-	.cra_name = "authenc(hmac(sha1),cbc(aes))",
-	.cra_driver_name = "qat_aes_cbc_hmac_sha1",
-	.cra_priority = 4001,
-	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
-	.cra_alignmask = 0,
-	.cra_type = &crypto_aead_type,
-	.cra_module = THIS_MODULE,
-	.cra_init = qat_alg_aead_sha1_init,
-	.cra_exit = qat_alg_aead_exit,
-	.cra_u = {
-		.aead = {
-			.setkey = qat_alg_aead_setkey,
-			.decrypt = qat_alg_aead_dec,
-			.encrypt = qat_alg_aead_enc,
-			.givencrypt = qat_alg_aead_genivenc,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
+
+static struct aead_alg qat_aeads[] = { {
+	.base = {
+		.cra_name = "authenc(hmac(sha1),cbc(aes))",
+		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
+		.cra_priority = 4001,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_AEAD_NEW,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
+		.cra_module = THIS_MODULE,
 	},
+	.init = qat_alg_aead_sha1_init,
+	.exit = qat_alg_aead_exit,
+	.setkey = qat_alg_aead_setkey,
+	.decrypt = qat_alg_aead_dec,
+	.encrypt = qat_alg_aead_enc,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA1_DIGEST_SIZE,
 }, {
-	.cra_name = "authenc(hmac(sha256),cbc(aes))",
-	.cra_driver_name = "qat_aes_cbc_hmac_sha256",
-	.cra_priority = 4001,
-	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
-	.cra_alignmask = 0,
-	.cra_type = &crypto_aead_type,
-	.cra_module = THIS_MODULE,
-	.cra_init = qat_alg_aead_sha256_init,
-	.cra_exit = qat_alg_aead_exit,
-	.cra_u = {
-		.aead = {
-			.setkey = qat_alg_aead_setkey,
-			.decrypt = qat_alg_aead_dec,
-			.encrypt = qat_alg_aead_enc,
-			.givencrypt = qat_alg_aead_genivenc,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
+	.base = {
+		.cra_name = "authenc(hmac(sha256),cbc(aes))",
+		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
+		.cra_priority = 4001,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_AEAD_NEW,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
+		.cra_module = THIS_MODULE,
 	},
+	.init = qat_alg_aead_sha256_init,
+	.exit = qat_alg_aead_exit,
+	.setkey = qat_alg_aead_setkey,
+	.decrypt = qat_alg_aead_dec,
+	.encrypt = qat_alg_aead_enc,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA256_DIGEST_SIZE,
 }, {
-	.cra_name = "authenc(hmac(sha512),cbc(aes))",
-	.cra_driver_name = "qat_aes_cbc_hmac_sha512",
-	.cra_priority = 4001,
-	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
-	.cra_alignmask = 0,
-	.cra_type = &crypto_aead_type,
-	.cra_module = THIS_MODULE,
-	.cra_init = qat_alg_aead_sha512_init,
-	.cra_exit = qat_alg_aead_exit,
-	.cra_u = {
-		.aead = {
-			.setkey = qat_alg_aead_setkey,
-			.decrypt = qat_alg_aead_dec,
-			.encrypt = qat_alg_aead_enc,
-			.givencrypt = qat_alg_aead_genivenc,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA512_DIGEST_SIZE,
-		},
+	.base = {
+		.cra_name = "authenc(hmac(sha512),cbc(aes))",
+		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
+		.cra_priority = 4001,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_AEAD_NEW,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
+		.cra_module = THIS_MODULE,
 	},
-}, {
+	.init = qat_alg_aead_sha512_init,
+	.exit = qat_alg_aead_exit,
+	.setkey = qat_alg_aead_setkey,
+	.decrypt = qat_alg_aead_dec,
+	.encrypt = qat_alg_aead_enc,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA512_DIGEST_SIZE,
+} };
+
+static struct crypto_alg qat_algs[] = { {
 	.cra_name = "cbc(aes)",
 	.cra_driver_name = "qat_aes_cbc",
 	.cra_priority = 4001,
@@ -1279,39 +1186,45 @@ int qat_algs_register(void)
 	int ret = 0;
 
 	mutex_lock(&algs_lock);
-	if (++active_devs == 1) {
-		int i;
+	if (++active_devs != 1)
+		goto unlock;
 
-		for (i = 0; i < ARRAY_SIZE(qat_algs); i++)
-			qat_algs[i].cra_flags =
-				(qat_algs[i].cra_type == &crypto_aead_type) ?
-				CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC :
-				CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	ret = crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
+	if (ret)
+		goto unlock;
 
-		ret = crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
-	}
+	ret = crypto_register_aeads(qat_aeads, ARRAY_SIZE(qat_aeads));
+	if (ret)
+		goto unreg_algs;
+
+unlock:
 	mutex_unlock(&algs_lock);
 	return ret;
+
+unreg_algs:
+	crypto_unregister_algs(qat_algs, ARRAY_SIZE(qat_algs));
+	goto unlock;
 }
 
 int qat_algs_unregister(void)
 {
-	int ret = 0;
-
 	mutex_lock(&algs_lock);
-	if (--active_devs == 0)
-		ret = crypto_unregister_algs(qat_algs, ARRAY_SIZE(qat_algs));
+	if (--active_devs != 0)
+		goto unlock;
+
+	crypto_unregister_aeads(qat_aeads, ARRAY_SIZE(qat_aeads));
+	crypto_unregister_algs(qat_algs, ARRAY_SIZE(qat_algs));
+
+unlock:
 	mutex_unlock(&algs_lock);
-	return ret;
+	return 0;
 }
 
 int qat_algs_init(void)
 {
-	crypto_get_default_rng();
 	return 0;
 }
 
 void qat_algs_exit(void)
 {
-	crypto_put_default_rng();
 }
