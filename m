From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - add support for ctr(aes) and xts(aes)
Date: Wed, 30 Sep 2015 05:38:39 -0700
Message-ID: <20150930123838.14623.60990.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63290 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbbI3Mkm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Sep 2015 08:40:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for ctr and xts encryption modes.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |  166 +++++++++++++++++++++++-------
 1 file changed, 127 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2bd913a..7a8cbd2 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -62,13 +62,13 @@
 #include "icp_qat_fw.h"
 #include "icp_qat_fw_la.h"
 
-#define QAT_AES_HW_CONFIG_CBC_ENC(alg) \
-	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
+#define QAT_AES_HW_CONFIG_ENC(alg, mode) \
+	ICP_QAT_HW_CIPHER_CONFIG_BUILD(mode, alg, \
 				       ICP_QAT_HW_CIPHER_NO_CONVERT, \
 				       ICP_QAT_HW_CIPHER_ENCRYPT)
 
-#define QAT_AES_HW_CONFIG_CBC_DEC(alg) \
-	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
+#define QAT_AES_HW_CONFIG_DEC(alg, mode) \
+	ICP_QAT_HW_CIPHER_CONFIG_BUILD(mode, alg, \
 				       ICP_QAT_HW_CIPHER_KEY_CONVERT, \
 				       ICP_QAT_HW_CIPHER_DECRYPT)
 
@@ -271,7 +271,8 @@ static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 
 static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 					 int alg,
-					 struct crypto_authenc_keys *keys)
+					 struct crypto_authenc_keys *keys,
+					 int mode)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(aead_tfm);
 	unsigned int digestsize = crypto_aead_authsize(aead_tfm);
@@ -288,7 +289,7 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 	struct icp_qat_fw_auth_cd_ctrl_hdr *hash_cd_ctrl = ptr;
 
 	/* CD setup */
-	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_ENC(alg);
+	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_ENC(alg, mode);
 	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
 	hash->sha.inner_setup.auth_config.config =
 		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
@@ -351,7 +352,8 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 
 static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 					 int alg,
-					 struct crypto_authenc_keys *keys)
+					 struct crypto_authenc_keys *keys,
+					 int mode)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(aead_tfm);
 	unsigned int digestsize = crypto_aead_authsize(aead_tfm);
@@ -373,7 +375,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 		sizeof(struct icp_qat_fw_la_cipher_req_params));
 
 	/* CD setup */
-	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_DEC(alg);
+	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_DEC(alg, mode);
 	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
 	hash->sha.inner_setup.auth_config.config =
 		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
@@ -464,7 +466,7 @@ static void qat_alg_ablkcipher_init_com(struct qat_alg_ablkcipher_ctx *ctx,
 
 static void qat_alg_ablkcipher_init_enc(struct qat_alg_ablkcipher_ctx *ctx,
 					int alg, const uint8_t *key,
-					unsigned int keylen)
+					unsigned int keylen, int mode)
 {
 	struct icp_qat_hw_cipher_algo_blk *enc_cd = ctx->enc_cd;
 	struct icp_qat_fw_la_bulk_req *req = &ctx->enc_fw_req;
@@ -472,12 +474,12 @@ static void qat_alg_ablkcipher_init_enc(struct qat_alg_ablkcipher_ctx *ctx,
 
 	qat_alg_ablkcipher_init_com(ctx, req, enc_cd, key, keylen);
 	cd_pars->u.s.content_desc_addr = ctx->enc_cd_paddr;
-	enc_cd->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_ENC(alg);
+	enc_cd->aes.cipher_config.val = QAT_AES_HW_CONFIG_ENC(alg, mode);
 }
 
 static void qat_alg_ablkcipher_init_dec(struct qat_alg_ablkcipher_ctx *ctx,
 					int alg, const uint8_t *key,
-					unsigned int keylen)
+					unsigned int keylen, int mode)
 {
 	struct icp_qat_hw_cipher_algo_blk *dec_cd = ctx->dec_cd;
 	struct icp_qat_fw_la_bulk_req *req = &ctx->dec_fw_req;
@@ -485,29 +487,48 @@ static void qat_alg_ablkcipher_init_dec(struct qat_alg_ablkcipher_ctx *ctx,
 
 	qat_alg_ablkcipher_init_com(ctx, req, dec_cd, key, keylen);
 	cd_pars->u.s.content_desc_addr = ctx->dec_cd_paddr;
-	dec_cd->aes.cipher_config.val = QAT_AES_HW_CONFIG_CBC_DEC(alg);
+
+	if (mode != ICP_QAT_HW_CIPHER_CTR_MODE)
+		dec_cd->aes.cipher_config.val =
+					QAT_AES_HW_CONFIG_DEC(alg, mode);
+	else
+		dec_cd->aes.cipher_config.val =
+					QAT_AES_HW_CONFIG_ENC(alg, mode);
 }
 
-static int qat_alg_validate_key(int key_len, int *alg)
+static int qat_alg_validate_key(int key_len, int *alg, int mode)
 {
-	switch (key_len) {
-	case AES_KEYSIZE_128:
-		*alg = ICP_QAT_HW_CIPHER_ALGO_AES128;
-		break;
-	case AES_KEYSIZE_192:
-		*alg = ICP_QAT_HW_CIPHER_ALGO_AES192;
-		break;
-	case AES_KEYSIZE_256:
-		*alg = ICP_QAT_HW_CIPHER_ALGO_AES256;
-		break;
-	default:
-		return -EINVAL;
+	if (mode != ICP_QAT_HW_CIPHER_XTS_MODE) {
+		switch (key_len) {
+		case AES_KEYSIZE_128:
+			*alg = ICP_QAT_HW_CIPHER_ALGO_AES128;
+			break;
+		case AES_KEYSIZE_192:
+			*alg = ICP_QAT_HW_CIPHER_ALGO_AES192;
+			break;
+		case AES_KEYSIZE_256:
+			*alg = ICP_QAT_HW_CIPHER_ALGO_AES256;
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		switch (key_len) {
+		case AES_KEYSIZE_128 << 1:
+			*alg = ICP_QAT_HW_CIPHER_ALGO_AES128;
+			break;
+		case AES_KEYSIZE_256 << 1:
+			*alg = ICP_QAT_HW_CIPHER_ALGO_AES256;
+			break;
+		default:
+			return -EINVAL;
+		}
 	}
 	return 0;
 }
 
-static int qat_alg_aead_init_sessions(struct crypto_aead *tfm,
-				      const uint8_t *key, unsigned int keylen)
+static int qat_alg_aead_init_sessions(struct crypto_aead *tfm, const u8 *key,
+				      unsigned int keylen,  int mode)
 {
 	struct crypto_authenc_keys keys;
 	int alg;
@@ -515,13 +536,13 @@ static int qat_alg_aead_init_sessions(struct crypto_aead *tfm,
 	if (crypto_authenc_extractkeys(&keys, key, keylen))
 		goto bad_key;
 
-	if (qat_alg_validate_key(keys.enckeylen, &alg))
+	if (qat_alg_validate_key(keys.enckeylen, &alg, mode))
 		goto bad_key;
 
-	if (qat_alg_aead_init_enc_session(tfm, alg, &keys))
+	if (qat_alg_aead_init_enc_session(tfm, alg, &keys, mode))
 		goto error;
 
-	if (qat_alg_aead_init_dec_session(tfm, alg, &keys))
+	if (qat_alg_aead_init_dec_session(tfm, alg, &keys, mode))
 		goto error;
 
 	return 0;
@@ -534,15 +555,16 @@ error:
 
 static int qat_alg_ablkcipher_init_sessions(struct qat_alg_ablkcipher_ctx *ctx,
 					    const uint8_t *key,
-					    unsigned int keylen)
+					    unsigned int keylen,
+					    int mode)
 {
 	int alg;
 
-	if (qat_alg_validate_key(keylen, &alg))
+	if (qat_alg_validate_key(keylen, &alg, mode))
 		goto bad_key;
 
-	qat_alg_ablkcipher_init_enc(ctx, alg, key, keylen);
-	qat_alg_ablkcipher_init_dec(ctx, alg, key, keylen);
+	qat_alg_ablkcipher_init_enc(ctx, alg, key, keylen, mode);
+	qat_alg_ablkcipher_init_dec(ctx, alg, key, keylen, mode);
 	return 0;
 bad_key:
 	crypto_tfm_set_flags(ctx->tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -586,7 +608,8 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 			goto out_free_enc;
 		}
 	}
-	if (qat_alg_aead_init_sessions(tfm, key, keylen))
+	if (qat_alg_aead_init_sessions(tfm, key, keylen,
+				       ICP_QAT_HW_CIPHER_CBC_MODE))
 		goto out_free_all;
 
 	return 0;
@@ -876,8 +899,8 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 }
 
 static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
-				     const uint8_t *key,
-				     unsigned int keylen)
+				     const u8 *key, unsigned int keylen,
+				     int mode)
 {
 	struct qat_alg_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	struct device *dev;
@@ -918,7 +941,7 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 		}
 	}
 	spin_unlock(&ctx->lock);
-	if (qat_alg_ablkcipher_init_sessions(ctx, key, keylen))
+	if (qat_alg_ablkcipher_init_sessions(ctx, key, keylen, mode))
 		goto out_free_all;
 
 	return 0;
@@ -936,6 +959,27 @@ out_free_enc:
 	return -ENOMEM;
 }
 
+static int qat_alg_ablkcipher_cbc_setkey(struct crypto_ablkcipher *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	return qat_alg_ablkcipher_setkey(tfm, key, keylen,
+					 ICP_QAT_HW_CIPHER_CBC_MODE);
+}
+
+static int qat_alg_ablkcipher_ctr_setkey(struct crypto_ablkcipher *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	return qat_alg_ablkcipher_setkey(tfm, key, keylen,
+					 ICP_QAT_HW_CIPHER_CTR_MODE);
+}
+
+static int qat_alg_ablkcipher_xts_setkey(struct crypto_ablkcipher *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	return qat_alg_ablkcipher_setkey(tfm, key, keylen,
+					 ICP_QAT_HW_CIPHER_XTS_MODE);
+}
+
 static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *atfm = crypto_ablkcipher_reqtfm(req);
@@ -1171,7 +1215,51 @@ static struct crypto_alg qat_algs[] = { {
 	.cra_exit = qat_alg_ablkcipher_exit,
 	.cra_u = {
 		.ablkcipher = {
-			.setkey = qat_alg_ablkcipher_setkey,
+			.setkey = qat_alg_ablkcipher_cbc_setkey,
+			.decrypt = qat_alg_ablkcipher_decrypt,
+			.encrypt = qat_alg_ablkcipher_encrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+	},
+}, {
+	.cra_name = "ctr(aes)",
+	.cra_driver_name = "qat_aes_ctr",
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
+			.setkey = qat_alg_ablkcipher_ctr_setkey,
+			.decrypt = qat_alg_ablkcipher_decrypt,
+			.encrypt = qat_alg_ablkcipher_encrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+	},
+}, {
+	.cra_name = "xts(aes)",
+	.cra_driver_name = "qat_aes_xts",
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
+			.setkey = qat_alg_ablkcipher_xts_setkey,
 			.decrypt = qat_alg_ablkcipher_decrypt,
 			.encrypt = qat_alg_ablkcipher_encrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
