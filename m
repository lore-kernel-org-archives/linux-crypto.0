From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH 2/3] crypto: cavium: Remove the individual encrypt/decrypt function for each algorithm
Date: Fri, 21 Apr 2017 11:16:05 +0000
Message-ID: <1492773366-17899-3-git-send-email-george.cherian@cavium.com>
References: <1492773366-17899-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0076.outbound.protection.outlook.com ([104.47.41.76]:12096
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1035655AbdDUFr1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 01:47:27 -0400
In-Reply-To: <1492773366-17899-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the individual encrypt/decrypt function for easch algorithm.
This is in prepration of adding more crypto algorithms supported by
hardware. While at that simplify create_ctx_hdr/create_input_list
function interfaces.

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 133 +++++++++++++++++----------------
 drivers/crypto/cavium/cpt/cptvf_algs.h |   7 ++
 2 files changed, 77 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index cc853f9..c365fc6 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -98,7 +98,6 @@ static inline void update_output_data(struct cpt_request_info *req_info,
 }
 
 static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
-				 u32 cipher_type, u32 aes_key_type,
 				 u32 *argcnt)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
@@ -124,11 +123,11 @@ static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
 	req_info->req.param1 = req->nbytes; /* Encryption Data length */
 	req_info->req.param2 = 0; /*Auth data length */
 
-	fctx->enc.enc_ctrl.e.enc_cipher = cipher_type;
-	fctx->enc.enc_ctrl.e.aes_key = aes_key_type;
+	fctx->enc.enc_ctrl.e.enc_cipher = ctx->cipher_type;
+	fctx->enc.enc_ctrl.e.aes_key = ctx->key_type;
 	fctx->enc.enc_ctrl.e.iv_source = FROM_DPTR;
 
-	if (cipher_type == AES_XTS)
+	if (ctx->cipher_type == AES_XTS)
 		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len * 2);
 	else
 		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len);
@@ -154,14 +153,13 @@ static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
 }
 
 static inline u32 create_input_list(struct ablkcipher_request  *req, u32 enc,
-				    u32 cipher_type, u32 aes_key_type,
 				    u32 enc_iv_len)
 {
 	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
 	struct cpt_request_info *req_info = &rctx->cpt_req;
 	u32 argcnt =  0;
 
-	create_ctx_hdr(req, enc, cipher_type, aes_key_type, &argcnt);
+	create_ctx_hdr(req, enc, &argcnt);
 	update_input_iv(req_info, req->info, enc_iv_len, &argcnt);
 	update_input_data(req_info, req->src, req->nbytes, &argcnt);
 	req_info->incnt = argcnt;
@@ -177,7 +175,6 @@ static inline void store_cb_info(struct ablkcipher_request *req,
 }
 
 static inline void create_output_list(struct ablkcipher_request *req,
-				      u32 cipher_type,
 				      u32 enc_iv_len)
 {
 	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
@@ -197,12 +194,9 @@ static inline void create_output_list(struct ablkcipher_request *req,
 	req_info->outcnt = argcnt;
 }
 
-static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc,
-			      u32 cipher_type)
+static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	u32 key_type = AES_128_BIT;
 	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
 	u32 enc_iv_len = crypto_ablkcipher_ivsize(tfm);
 	struct fc_context *fctx = &rctx->fctx;
@@ -210,36 +204,10 @@ static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc,
 	void *cdev = NULL;
 	int status;
 
-	switch (ctx->key_len) {
-	case 16:
-		key_type = AES_128_BIT;
-		break;
-	case 24:
-		key_type = AES_192_BIT;
-		break;
-	case 32:
-		if (cipher_type == AES_XTS)
-			key_type = AES_128_BIT;
-		else
-			key_type = AES_256_BIT;
-		break;
-	case 64:
-		if (cipher_type == AES_XTS)
-			key_type = AES_256_BIT;
-		else
-			return -EINVAL;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (cipher_type == DES3_CBC)
-		key_type = 0;
-
 	memset(req_info, 0, sizeof(struct cpt_request_info));
 	memset(fctx, 0, sizeof(struct fc_context));
-	create_input_list(req, enc, cipher_type, key_type, enc_iv_len);
-	create_output_list(req, cipher_type, enc_iv_len);
+	create_input_list(req, enc, enc_iv_len);
+	create_output_list(req, enc_iv_len);
 	store_cb_info(req, req_info);
 	cdev = dev_handle.cdev[smp_processor_id()];
 	status = cptvf_do_request(cdev, req_info);
@@ -254,34 +222,41 @@ static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc,
 		return -EINPROGRESS;
 }
 
-int cvm_des3_encrypt_cbc(struct ablkcipher_request *req)
+int cvm_encrypt(struct ablkcipher_request *req)
 {
-	return cvm_enc_dec(req, true, DES3_CBC);
+	return cvm_enc_dec(req, true);
 }
 
-int cvm_des3_decrypt_cbc(struct ablkcipher_request *req)
+int cvm_decrypt(struct ablkcipher_request *req)
 {
-	return cvm_enc_dec(req, false, DES3_CBC);
+	return cvm_enc_dec(req, false);
 }
 
-int cvm_aes_encrypt_xts(struct ablkcipher_request *req)
-{
-	return cvm_enc_dec(req, true, AES_XTS);
-}
+static const struct cvm_cipher cvm_cipher_table[] = {
+	{ "cbc(des3_ede)", DES3_CBC },
+	{ "ecb(des3_ede)", DES3_ECB},
+	{ "cbc(aes)", AES_CBC},
+	{ "ecb(aes)", AES_ECB},
+	{ "cfb(aes)", AES_CFB},
+	{ "rfc3686(ctr(aes))", AES_CTR},
+	{ "xts(aes)", AES_XTS},
+	{ "cts(cbc(aes))", AES_GCM},
+	{ NULL, -1}
+};
 
-int cvm_aes_decrypt_xts(struct ablkcipher_request *req)
-{
-	return cvm_enc_dec(req, false, AES_XTS);
-}
 
-int cvm_aes_encrypt_cbc(struct ablkcipher_request *req)
+static inline u32 cvm_cipher_type(const char *name)
 {
-	return cvm_enc_dec(req, true, AES_CBC);
-}
 
-int cvm_aes_decrypt_cbc(struct ablkcipher_request *req)
-{
-	return cvm_enc_dec(req, false, AES_CBC);
+	const struct cvm_cipher *cipher = cvm_cipher_table;
+
+	while (cipher->name) {
+		if (!strcmp(cipher->name, name))
+			break;
+		cipher++;
+	}
+
+	return cipher->value;
 }
 
 int cvm_xts_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
@@ -299,6 +274,17 @@ int cvm_xts_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	ctx->key_len = keylen;
 	memcpy(ctx->enc_key, key1, keylen / 2);
 	memcpy(ctx->enc_key + KEY2_OFFSET, key2, keylen / 2);
+	ctx->cipher_type = AES_XTS;
+	switch (ctx->key_len) {
+	case 32:
+		ctx->key_type = AES_128_BIT;
+		break;
+	case 64:
+		ctx->key_type = AES_256_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -308,12 +294,33 @@ int cvm_enc_dec_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
+	const char *name;
 
+	name = crypto_tfm_alg_name(tfm);
+	ctx->cipher_type = cvm_cipher_type(name);
 	if ((keylen == 16) || (keylen == 24) || (keylen == 32)) {
 		ctx->key_len = keylen;
 		memcpy(ctx->enc_key, key, keylen);
+		switch (ctx->key_len) {
+		case 16:
+			ctx->key_type = AES_128_BIT;
+			break;
+		case 24:
+			ctx->key_type = AES_192_BIT;
+			break;
+		case 32:
+			ctx->key_type = AES_256_BIT;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (ctx->cipher_type == DES3_CBC)
+			ctx->key_type = 0;
+
 		return 0;
 	}
+
 	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	return -EINVAL;
@@ -349,8 +356,8 @@ struct crypto_alg algs[] = { {
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.setkey = cvm_xts_setkey,
-			.encrypt = cvm_aes_encrypt_xts,
-			.decrypt = cvm_aes_decrypt_xts,
+			.encrypt = cvm_encrypt,
+			.decrypt = cvm_decrypt,
 		},
 	},
 	.cra_init = cvm_enc_dec_init,
@@ -370,8 +377,8 @@ struct crypto_alg algs[] = { {
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.setkey = cvm_enc_dec_setkey,
-			.encrypt = cvm_aes_encrypt_cbc,
-			.decrypt = cvm_aes_decrypt_cbc,
+			.encrypt = cvm_encrypt,
+			.decrypt = cvm_decrypt,
 		},
 	},
 	.cra_init = cvm_enc_dec_init,
@@ -391,8 +398,8 @@ struct crypto_alg algs[] = { {
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
 			.setkey = cvm_enc_dec_setkey,
-			.encrypt = cvm_des3_encrypt_cbc,
-			.decrypt = cvm_des3_decrypt_cbc,
+			.encrypt = cvm_encrypt,
+			.decrypt = cvm_decrypt,
 		},
 	},
 	.cra_init = cvm_enc_dec_init,
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.h b/drivers/crypto/cavium/cpt/cptvf_algs.h
index a12050d..902f257 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.h
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.h
@@ -77,6 +77,11 @@ union encr_ctrl {
 	} e;
 };
 
+struct cvm_cipher {
+	const char *name;
+	u8 value;
+};
+
 struct enc_context {
 	union encr_ctrl enc_ctrl;
 	u8 encr_key[32];
@@ -96,6 +101,8 @@ struct fc_context {
 struct cvm_enc_ctx {
 	u32 key_len;
 	u8 enc_key[MAX_KEY_SIZE];
+	u8 cipher_type:4;
+	u8 key_type:2;
 };
 
 struct cvm_des3_ctx {
-- 
2.1.4
