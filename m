From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 03/13] mv_cesa: prepare the full sram config in dram
Date: Fri, 25 May 2012 18:08:29 +0200
Message-ID: <1337962119-5509-4-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47907 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2EYQJC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:09:02 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This way reconfiguring the cryptographic accelerator consists of a
single step (memcpy here), which in future can be done by the tdma
engine.

This patch introduces some ugly IV copying, necessary for input buffers
above 1920bytes. But this will go away later.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   83 ++++++++++++++++++++++++++++-----------------
 1 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 3862a93..68b83d8 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -76,6 +76,24 @@ struct req_progress {
 	int hw_processed_bytes;
 };
 
+struct sec_accel_sram {
+	struct sec_accel_config op;
+	union {
+		struct {
+			u32 key[8];
+			u32 iv[4];
+		} crypt;
+		struct {
+			u32 ivi[5];
+			u32 ivo[5];
+		} hash;
+	} type;
+#define sa_key	type.crypt.key
+#define sa_iv	type.crypt.iv
+#define sa_ivi	type.hash.ivi
+#define sa_ivo	type.hash.ivo
+} __attribute__((packed));
+
 struct crypto_priv {
 	void __iomem *reg;
 	void __iomem *sram;
@@ -93,6 +111,8 @@ struct crypto_priv {
 	int sram_size;
 	int has_sha1;
 	int has_hmac_sha1;
+
+	struct sec_accel_sram sa_sram;
 };
 
 static struct crypto_priv *cpg;
@@ -250,48 +270,49 @@ static void mv_process_current_q(int first_block)
 	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
 	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
-	struct sec_accel_config op;
+	struct sec_accel_config *op = &cpg->sa_sram.op;
 
 	switch (req_ctx->op) {
 	case COP_AES_ECB:
-		op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
+		op->config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
 		break;
 	case COP_AES_CBC:
 	default:
-		op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
-		op.enc_iv = ENC_IV_POINT(SRAM_DATA_IV) |
+		op->config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
+		op->enc_iv = ENC_IV_POINT(SRAM_DATA_IV) |
 			ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);
-		if (first_block)
-			memcpy(cpg->sram + SRAM_DATA_IV, req->info, 16);
+		if (!first_block)
+			memcpy(req->info, cpg->sram + SRAM_DATA_IV_BUF, 16);
+		memcpy(cpg->sa_sram.sa_iv, req->info, 16);
 		break;
 	}
 	if (req_ctx->decrypt) {
-		op.config |= CFG_DIR_DEC;
-		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_dec_key, AES_KEY_LEN);
+		op->config |= CFG_DIR_DEC;
+		memcpy(cpg->sa_sram.sa_key, ctx->aes_dec_key, AES_KEY_LEN);
 	} else {
-		op.config |= CFG_DIR_ENC;
-		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_enc_key, AES_KEY_LEN);
+		op->config |= CFG_DIR_ENC;
+		memcpy(cpg->sa_sram.sa_key, ctx->aes_enc_key, AES_KEY_LEN);
 	}
 
 	switch (ctx->key_len) {
 	case AES_KEYSIZE_128:
-		op.config |= CFG_AES_LEN_128;
+		op->config |= CFG_AES_LEN_128;
 		break;
 	case AES_KEYSIZE_192:
-		op.config |= CFG_AES_LEN_192;
+		op->config |= CFG_AES_LEN_192;
 		break;
 	case AES_KEYSIZE_256:
-		op.config |= CFG_AES_LEN_256;
+		op->config |= CFG_AES_LEN_256;
 		break;
 	}
-	op.enc_p = ENC_P_SRC(SRAM_DATA_IN_START) |
+	op->enc_p = ENC_P_SRC(SRAM_DATA_IN_START) |
 		ENC_P_DST(SRAM_DATA_OUT_START);
-	op.enc_key_p = SRAM_DATA_KEY_P;
+	op->enc_key_p = SRAM_DATA_KEY_P;
 
 	setup_data_in();
-	op.enc_len = cpg->p.crypt_len;
-	memcpy(cpg->sram + SRAM_CONFIG, &op,
-			sizeof(struct sec_accel_config));
+	op->enc_len = cpg->p.crypt_len;
+	memcpy(cpg->sram + SRAM_CONFIG, &cpg->sa_sram,
+			sizeof(struct sec_accel_sram));
 
 	/* GO */
 	mv_setup_timer();
@@ -315,30 +336,30 @@ static void mv_process_hash_current(int first_block)
 	const struct mv_tfm_hash_ctx *tfm_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
 	struct req_progress *p = &cpg->p;
-	struct sec_accel_config op = { 0 };
+	struct sec_accel_config *op = &cpg->sa_sram.op;
 	int is_last;
 
 	switch (req_ctx->op) {
 	case COP_SHA1:
 	default:
-		op.config = CFG_OP_MAC_ONLY | CFG_MACM_SHA1;
+		op->config = CFG_OP_MAC_ONLY | CFG_MACM_SHA1;
 		break;
 	case COP_HMAC_SHA1:
-		op.config = CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
-		memcpy(cpg->sram + SRAM_HMAC_IV_IN,
+		op->config = CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
+		memcpy(cpg->sa_sram.sa_ivi,
 				tfm_ctx->ivs, sizeof(tfm_ctx->ivs));
 		break;
 	}
 
-	op.mac_src_p =
+	op->mac_src_p =
 		MAC_SRC_DATA_P(SRAM_DATA_IN_START) |
 		MAC_SRC_TOTAL_LEN((u32)req_ctx->count);
 
 	setup_data_in();
 
-	op.mac_digest =
+	op->mac_digest =
 		MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
-	op.mac_iv =
+	op->mac_iv =
 		MAC_INNER_IV_P(SRAM_HMAC_IV_IN) |
 		MAC_OUTER_IV_P(SRAM_HMAC_IV_OUT);
 
@@ -347,16 +368,16 @@ static void mv_process_hash_current(int first_block)
 		&& (req_ctx->count <= MAX_HW_HASH_SIZE);
 	if (req_ctx->first_hash) {
 		if (is_last)
-			op.config |= CFG_NOT_FRAG;
+			op->config |= CFG_NOT_FRAG;
 		else
-			op.config |= CFG_FIRST_FRAG;
+			op->config |= CFG_FIRST_FRAG;
 
 		req_ctx->first_hash = 0;
 	} else {
 		if (is_last)
-			op.config |= CFG_LAST_FRAG;
+			op->config |= CFG_LAST_FRAG;
 		else
-			op.config |= CFG_MID_FRAG;
+			op->config |= CFG_MID_FRAG;
 
 		if (first_block) {
 			writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
@@ -367,8 +388,8 @@ static void mv_process_hash_current(int first_block)
 		}
 	}
 
-	memcpy(cpg->sram + SRAM_CONFIG, &op,
-			sizeof(struct sec_accel_config));
+	memcpy(cpg->sram + SRAM_CONFIG, &cpg->sa_sram,
+			sizeof(struct sec_accel_sram));
 
 	/* GO */
 	mv_setup_timer();
-- 
1.7.3.4
