From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Use memzero_explicit
Date: Fri, 14 Nov 2014 11:23:52 -0800
Message-ID: <20141114192352.6976.50621.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965808AbaKNT0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Nov 2014 14:26:31 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the new memzero_explicit function to cleanup sensitive data.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |   36 ++++++++++++++++++------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2269fda..19eea1c 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -161,7 +161,7 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	__be64 *hash512_state_out;
 	int i, offset;
 
-	memset(auth_state.data, '\0', MAX_AUTH_STATE_SIZE + 64);
+	memzero_explicit(auth_state.data, MAX_AUTH_STATE_SIZE + 64);
 	shash->tfm = ctx->hash_tfm;
 	shash->flags = 0x0;
 
@@ -174,13 +174,13 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 		memcpy(ipad, buff, digest_size);
 		memcpy(opad, buff, digest_size);
-		memset(ipad + digest_size, 0, block_size - digest_size);
-		memset(opad + digest_size, 0, block_size - digest_size);
+		memzero_explicit(ipad + digest_size, block_size - digest_size);
+		memzero_explicit(opad + digest_size, block_size - digest_size);
 	} else {
 		memcpy(ipad, auth_key, auth_keylen);
 		memcpy(opad, auth_key, auth_keylen);
-		memset(ipad + auth_keylen, 0, block_size - auth_keylen);
-		memset(opad + auth_keylen, 0, block_size - auth_keylen);
+		memzero_explicit(ipad + auth_keylen, block_size - auth_keylen);
+		memzero_explicit(opad + auth_keylen, block_size - auth_keylen);
 	}
 
 	for (i = 0; i < block_size; i++) {
@@ -254,6 +254,8 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	default:
 		return -EFAULT;
 	}
+	memzero_explicit(ipad, block_size);
+	memzero_explicit(opad, block_size);
 	return 0;
 }
 
@@ -492,12 +494,12 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	if (ctx->enc_cd) {
 		/* rekeying */
 		dev = &GET_DEV(ctx->inst->accel_dev);
-		memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
-		memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
-		memset(&ctx->enc_fw_req_tmpl, 0,
-		       sizeof(struct icp_qat_fw_la_bulk_req));
-		memset(&ctx->dec_fw_req_tmpl, 0,
-		       sizeof(struct icp_qat_fw_la_bulk_req));
+		memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
+		memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
+		memzero_explicit(&ctx->enc_fw_req_tmpl,
+				 sizeof(struct icp_qat_fw_la_bulk_req));
+		memzero_explicit(&ctx->dec_fw_req_tmpl,
+				 sizeof(struct icp_qat_fw_la_bulk_req));
 	} else {
 		/* new key */
 		int node = get_current_node();
@@ -534,10 +536,12 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	return 0;
 
 out_free_all:
+	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
 out_free_enc:
+	memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
@@ -835,7 +839,7 @@ static int qat_alg_init(struct crypto_tfm *tfm,
 {
 	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	memset(ctx, '\0', sizeof(*ctx));
+	memzero_explicit(ctx, sizeof(*ctx));
 	ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
 	if (IS_ERR(ctx->hash_tfm))
 		return -EFAULT;
@@ -875,12 +879,16 @@ static void qat_alg_exit(struct crypto_tfm *tfm)
 		return;
 
 	dev = &GET_DEV(inst->accel_dev);
-	if (ctx->enc_cd)
+	if (ctx->enc_cd) {
+		memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->enc_cd, ctx->enc_cd_paddr);
-	if (ctx->dec_cd)
+	}
+	if (ctx->dec_cd) {
+		memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
+	}
 	qat_crypto_put_instance(inst);
 }
 
