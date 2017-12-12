From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 12/24] staging: ccree: fix cipher naming convention
Date: Tue, 12 Dec 2017 14:52:58 +0000
Message-ID: <1513090395-7938-13-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The blkcipher files were using a func naming convention which was
inconsistent (ssi vs. cc), included a long prefix (ssi_ablkcipher)
and often too long.

Make the code more readable by switching to a simpler, consistent naming
convention.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 221 ++++++++++++++++++-------------------
 drivers/staging/ccree/ssi_cipher.h |   8 +-
 drivers/staging/ccree/ssi_driver.c |   8 +-
 3 files changed, 118 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 0dc63f1..d7687a4 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -38,9 +38,9 @@
 
 #define template_ablkcipher	template_u.ablkcipher
 
-#define SSI_MIN_AES_XTS_SIZE 0x10
-#define SSI_MAX_AES_XTS_SIZE 0x2000
-struct ssi_blkcipher_handle {
+#define CC_MIN_AES_XTS_SIZE 0x10
+#define CC_MAX_AES_XTS_SIZE 0x2000
+struct cc_cipher_handle {
 	struct list_head blkcipher_alg_list;
 };
 
@@ -54,7 +54,7 @@ struct cc_hw_key_info {
 	enum cc_hw_crypto_key key2_slot;
 };
 
-struct ssi_ablkcipher_ctx {
+struct cc_cipher_ctx {
 	struct ssi_drvdata *drvdata;
 	int keylen;
 	int key_round_number;
@@ -67,9 +67,9 @@ struct ssi_ablkcipher_ctx {
 	struct crypto_shash *shash_tfm;
 };
 
-static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req);
+static void cc_cipher_complete(struct device *dev, void *ssi_req);
 
-static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
+static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 {
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
@@ -109,15 +109,15 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
 	return -EINVAL;
 }
 
-static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p,
+static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 			      unsigned int size)
 {
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
 		switch (ctx_p->cipher_mode) {
 		case DRV_CIPHER_XTS:
-			if (size >= SSI_MIN_AES_XTS_SIZE &&
-			    size <= SSI_MAX_AES_XTS_SIZE &&
+			if (size >= CC_MIN_AES_XTS_SIZE &&
+			    size <= CC_MAX_AES_XTS_SIZE &&
 			    IS_ALIGNED(size, AES_BLOCK_SIZE))
 				return 0;
 			break;
@@ -180,9 +180,9 @@ static unsigned int get_max_keysize(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
+static int cc_cipher_init(struct crypto_tfm *tfm)
 {
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct crypto_alg *alg = tfm->__crt_alg;
 	struct ssi_crypto_alg *ssi_alg =
 			container_of(alg, struct ssi_crypto_alg, crypto_alg);
@@ -232,9 +232,9 @@ static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
 	return rc;
 }
 
-static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
+static void cc_cipher_exit(struct crypto_tfm *tfm)
 {
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
@@ -270,7 +270,7 @@ static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
 
 /* The function verifies that tdes keys are not weak.*/
-static int ssi_verify_3des_keys(const u8 *key, unsigned int keylen)
+static int cc_verify_3des_keys(const u8 *key, unsigned int keylen)
 {
 	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
 
@@ -300,11 +300,11 @@ static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
 	return END_OF_KEYS;
 }
 
-static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
-				unsigned int keylen)
+static int cc_cipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
+			    unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(atfm);
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	u32 tmp[DES_EXPKEY_WORDS];
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
@@ -329,7 +329,7 @@ static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 		return -EINVAL;
 	}
 
-	if (ssi_is_hw_key(tfm)) {
+	if (cc_is_hw_key(tfm)) {
 		/* setting HW key slots */
 		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
 
@@ -363,7 +363,7 @@ static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 		}
 
 		ctx_p->keylen = keylen;
-		dev_dbg(dev, "ssi_is_hw_key ret 0");
+		dev_dbg(dev, "cc_is_hw_key ret 0");
 
 		return 0;
 	}
@@ -384,7 +384,7 @@ static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 	}
 	if (ctx_p->flow_mode == S_DIN_to_DES &&
 	    keylen == DES3_EDE_KEY_SIZE &&
-	    ssi_verify_3des_keys(key, keylen)) {
+	    cc_verify_3des_keys(key, keylen)) {
 		dev_dbg(dev, "weak 3DES key");
 		return -EINVAL;
 	}
@@ -436,7 +436,7 @@ static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 }
 
 static void
-ssi_blkcipher_create_setup_desc(
+cc_setup_cipher_desc(
 	struct crypto_tfm *tfm,
 	struct blkcipher_req_ctx *req_ctx,
 	unsigned int ivsize,
@@ -444,7 +444,7 @@ ssi_blkcipher_create_setup_desc(
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	int cipher_mode = ctx_p->cipher_mode;
 	int flow_mode = ctx_p->flow_mode;
@@ -491,7 +491,7 @@ ssi_blkcipher_create_setup_desc(
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
 		if (flow_mode == S_DIN_to_AES) {
-			if (ssi_is_hw_key(tfm)) {
+			if (cc_is_hw_key(tfm)) {
 				set_hw_crypto_key(&desc[*seq_size],
 						  ctx_p->hw.key1_slot);
 			} else {
@@ -518,7 +518,7 @@ ssi_blkcipher_create_setup_desc(
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
-		if (ssi_is_hw_key(tfm)) {
+		if (cc_is_hw_key(tfm)) {
 			set_hw_crypto_key(&desc[*seq_size],
 					  ctx_p->hw.key1_slot);
 		} else {
@@ -534,7 +534,7 @@ ssi_blkcipher_create_setup_desc(
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
-		if (ssi_is_hw_key(tfm)) {
+		if (cc_is_hw_key(tfm)) {
 			set_hw_crypto_key(&desc[*seq_size],
 					  ctx_p->hw.key2_slot);
 		} else {
@@ -565,14 +565,14 @@ ssi_blkcipher_create_setup_desc(
 }
 
 #if SSI_CC_HAS_MULTI2
-static void ssi_blkcipher_create_multi2_setup_desc(
+static void cc_setup_multi2_desc(
 	struct crypto_tfm *tfm,
 	struct blkcipher_req_ctx *req_ctx,
 	unsigned int ivsize,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 
 	int direction = req_ctx->gen_ctx.op_type;
 	/* Load system key */
@@ -610,7 +610,7 @@ static void ssi_blkcipher_create_multi2_setup_desc(
 #endif /*SSI_CC_HAS_MULTI2*/
 
 static void
-ssi_blkcipher_create_data_desc(
+cc_setup_cipher_data(
 	struct crypto_tfm *tfm,
 	struct blkcipher_req_ctx *req_ctx,
 	struct scatterlist *dst, struct scatterlist *src,
@@ -619,7 +619,7 @@ ssi_blkcipher_create_data_desc(
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	unsigned int flow_mode = ctx_p->flow_mode;
 
@@ -703,7 +703,7 @@ ssi_blkcipher_create_data_desc(
 	}
 }
 
-static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req)
+static void cc_cipher_complete(struct device *dev, void *ssi_req)
 {
 	struct ablkcipher_request *areq = (struct ablkcipher_request *)ssi_req;
 	struct scatterlist *dst = areq->dst;
@@ -747,7 +747,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	struct scatterlist *src = req->src;
 	unsigned int nbytes = req->nbytes;
 	void *info = req->info;
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct ssi_crypto_req ssi_req = {};
@@ -790,7 +790,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)ssi_ablkcipher_complete;
+	ssi_req.user_cb = (void *)cc_cipher_complete;
 	ssi_req.user_arg = (void *)req;
 
 #ifdef ENABLE_CYCLE_COUNT
@@ -816,15 +816,14 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	/* Setup processing */
 #if SSI_CC_HAS_MULTI2
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
-		ssi_blkcipher_create_multi2_setup_desc(tfm, req_ctx, ivsize,
-						       desc, &seq_len);
+		cc_setup_multi2_desc(tfm, req_ctx, ivsize, desc, &seq_len);
 	else
 #endif /*SSI_CC_HAS_MULTI2*/
-		ssi_blkcipher_create_setup_desc(tfm, req_ctx, ivsize, nbytes,
-						desc, &seq_len);
+		cc_setup_cipher_desc(tfm, req_ctx, ivsize, nbytes, desc,
+				     &seq_len);
 	/* Data processing */
-	ssi_blkcipher_create_data_desc(tfm, req_ctx, dst, src, nbytes, req,
-				       desc, &seq_len);
+	cc_setup_cipher_data(tfm, req_ctx, dst, src, nbytes, req, desc,
+			     &seq_len);
 
 	/* do we need to generate IV? */
 	if (req_ctx->is_giv) {
@@ -856,7 +855,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	return rc;
 }
 
-static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
+static int cc_cipher_encrypt(struct ablkcipher_request *req)
 {
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 
@@ -866,7 +865,7 @@ static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 }
 
-static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
+static int cc_cipher_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
@@ -896,9 +895,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -913,9 +912,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -929,9 +928,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -947,9 +946,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -963,9 +962,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -979,9 +978,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -997,9 +996,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1013,9 +1012,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1029,9 +1028,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1046,9 +1045,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = 0,
@@ -1062,9 +1061,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1078,9 +1077,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1095,9 +1094,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1112,9 +1111,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1128,9 +1127,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -1144,9 +1143,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = 0,
@@ -1160,9 +1159,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = DES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
@@ -1176,9 +1175,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = DES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = 0,
@@ -1193,9 +1192,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = CC_MULTI2_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_decrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
 			.min_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
 			.max_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
 			.ivsize = CC_MULTI2_IV_SIZE,
@@ -1209,9 +1208,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_ablkcipher = {
-			.setkey = ssi_ablkcipher_setkey,
-			.encrypt = ssi_ablkcipher_encrypt,
-			.decrypt = ssi_ablkcipher_encrypt,
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_encrypt,
 			.min_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
 			.max_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
 			.ivsize = CC_MULTI2_IV_SIZE,
@@ -1223,8 +1222,8 @@ static struct ssi_alg_template blkcipher_algs[] = {
 };
 
 static
-struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template
-						 *template, struct device *dev)
+struct ssi_crypto_alg *cc_cipher_create_alg(struct ssi_alg_template *template,
+					    struct device *dev)
 {
 	struct ssi_crypto_alg *t_alg;
 	struct crypto_alg *alg;
@@ -1242,10 +1241,10 @@ struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template
 	alg->cra_priority = SSI_CRA_PRIO;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_ctxsize = sizeof(struct ssi_ablkcipher_ctx);
+	alg->cra_ctxsize = sizeof(struct cc_cipher_ctx);
 
-	alg->cra_init = ssi_ablkcipher_init;
-	alg->cra_exit = ssi_blkcipher_exit;
+	alg->cra_init = cc_cipher_init;
+	alg->cra_exit = cc_cipher_exit;
 	alg->cra_type = &crypto_ablkcipher_type;
 	alg->cra_ablkcipher = template->template_ablkcipher;
 	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
@@ -1257,10 +1256,10 @@ struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template
 	return t_alg;
 }
 
-int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
+int cc_cipher_free(struct ssi_drvdata *drvdata)
 {
 	struct ssi_crypto_alg *t_alg, *n;
-	struct ssi_blkcipher_handle *blkcipher_handle =
+	struct cc_cipher_handle *blkcipher_handle =
 						drvdata->blkcipher_handle;
 	if (blkcipher_handle) {
 		/* Remove registered algs */
@@ -1277,9 +1276,9 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
+int cc_cipher_alloc(struct ssi_drvdata *drvdata)
 {
-	struct ssi_blkcipher_handle *ablkcipher_handle;
+	struct cc_cipher_handle *ablkcipher_handle;
 	struct ssi_crypto_alg *t_alg;
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = -ENOMEM;
@@ -1297,7 +1296,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 		ARRAY_SIZE(blkcipher_algs));
 	for (alg = 0; alg < ARRAY_SIZE(blkcipher_algs); alg++) {
 		dev_dbg(dev, "creating %s\n", blkcipher_algs[alg].driver_name);
-		t_alg = ssi_ablkcipher_create_alg(&blkcipher_algs[alg], dev);
+		t_alg = cc_cipher_create_alg(&blkcipher_algs[alg], dev);
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			dev_err(dev, "%s alg allocation failed\n",
@@ -1326,6 +1325,6 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 	return 0;
 
 fail0:
-	ssi_ablkcipher_free(drvdata);
+	cc_cipher_free(drvdata);
 	return rc;
 }
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 14c0ad9..ef6d6e9 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -51,9 +51,9 @@ struct blkcipher_req_ctx {
 	struct mlli_params mlli_params;
 };
 
-int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata);
+int cc_cipher_alloc(struct ssi_drvdata *drvdata);
 
-int ssi_ablkcipher_free(struct ssi_drvdata *drvdata);
+int cc_cipher_free(struct ssi_drvdata *drvdata);
 
 #ifndef CRYPTO_ALG_BULK_MASK
 
@@ -65,7 +65,7 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata);
 
 #ifdef CRYPTO_TFM_REQ_HW_KEY
 
-static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
+static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
 {
 	return (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_HW_KEY);
 }
@@ -77,7 +77,7 @@ struct arm_hw_key_info {
 	int hw_key2;
 };
 
-static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
+static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
 {
 	return false;
 }
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 491e2b9..2a0dd85 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -351,9 +351,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	/* Allocate crypto algs */
-	rc = ssi_ablkcipher_alloc(new_drvdata);
+	rc = cc_cipher_alloc(new_drvdata);
 	if (rc) {
-		dev_err(dev, "ssi_ablkcipher_alloc failed\n");
+		dev_err(dev, "cc_cipher_alloc failed\n");
 		goto post_ivgen_err;
 	}
 
@@ -381,7 +381,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_hash_err:
 	cc_hash_free(new_drvdata);
 post_cipher_err:
-	ssi_ablkcipher_free(new_drvdata);
+	cc_cipher_free(new_drvdata);
 post_ivgen_err:
 	ssi_ivgen_fini(new_drvdata);
 post_power_mgr_err:
@@ -418,7 +418,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 
 	cc_aead_free(drvdata);
 	cc_hash_free(drvdata);
-	ssi_ablkcipher_free(drvdata);
+	cc_cipher_free(drvdata);
 	ssi_ivgen_fini(drvdata);
 	cc_pm_fini(drvdata);
 	cc_buffer_mgr_fini(drvdata);
-- 
2.7.4
