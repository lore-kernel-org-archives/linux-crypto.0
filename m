From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 6/8] crypto: caam - structure renaming
Date: Fri, 8 Jul 2011 17:57:27 -0500
Message-ID: <1310165849-22177-6-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yuan Kang <Yuan.Kang@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9566 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752512Ab1GHW6K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:10 -0400
Received: from mail83-va3 (localhost.localdomain [127.0.0.1])	by
 mail83-va3-R.bigfish.com (Postfix) with ESMTP id F02281B40129	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:09 +0000 (UTC)
Received: from VA3EHSMHS007.bigfish.com (unknown [10.7.14.247])	by
 mail83-va3.bigfish.com (Postfix) with ESMTP id 9CEC1880052	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:09 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yuan Kang <Yuan.Kang@freescale.com>

caam_ctx.key_phys to key_dma

caam_alg_template supports multiple algorithm types
listed in union, which requires cases for
different types in function caam_alg_alloc

Signed-off-by: Yuan Kang <Yuan.Kang@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |   64 +++++++++++++++++++++++++++-------------
 1 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4786a20..403b293 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -87,7 +87,7 @@ struct caam_ctx {
 	u32 class2_alg_type;
 	u32 alg_op;
 	u8 *key;
-	dma_addr_t key_phys;
+	dma_addr_t key_dma;
 	unsigned int enckeylen;
 	unsigned int split_key_len;
 	unsigned int split_key_pad_len;
@@ -263,9 +263,9 @@ static int build_sh_desc_ipsec(struct caam_ctx *ctx)
 				  ctx->split_key_pad_len, ctx->enckeylen,
 				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
 	} else {
-		append_key(sh_desc, ctx->key_phys, ctx->split_key_len, CLASS_2 |
+		append_key(sh_desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
 			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
-		append_key(sh_desc, ctx->key_phys + ctx->split_key_pad_len,
+		append_key(sh_desc, ctx->key_dma + ctx->split_key_pad_len,
 			   ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
 	}
 
@@ -342,9 +342,9 @@ static int aead_setkey(struct crypto_aead *aead,
 	/* postpend encryption key to auth split key */
 	memcpy(ctx->key + ctx->split_key_pad_len, key + authkeylen, enckeylen);
 
-	ctx->key_phys = dma_map_single(jrdev, ctx->key, ctx->split_key_pad_len +
+	ctx->key_dma = dma_map_single(jrdev, ctx->key, ctx->split_key_pad_len +
 				       enckeylen, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->key_phys)) {
+	if (dma_mapping_error(jrdev, ctx->key_dma)) {
 		dev_err(jrdev, "unable to map key i/o memory\n");
 		kfree(ctx->key);
 		return -ENOMEM;
@@ -359,7 +359,7 @@ static int aead_setkey(struct crypto_aead *aead,
 
 	ret = build_sh_desc_ipsec(ctx);
 	if (ret) {
-		dma_unmap_single(jrdev, ctx->key_phys, ctx->split_key_pad_len +
+		dma_unmap_single(jrdev, ctx->key_dma, ctx->split_key_pad_len +
 				 enckeylen, DMA_TO_DEVICE);
 		kfree(ctx->key);
 	}
@@ -884,11 +884,20 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 	return init_aead_job(edesc, req, OP_ALG_ENCRYPT, aead_encrypt_done);
 }
 
+#define template_aead		template_u.aead
 struct caam_alg_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int blocksize;
-	struct aead_alg aead;
+	u32 type;
+	union {
+		struct ablkcipher_alg ablkcipher;
+		struct aead_alg aead;
+		struct blkcipher_alg blkcipher;
+		struct cipher_alg cipher;
+		struct compress_alg compress;
+		struct rng_alg rng;
+	} template_u;
 	u32 class1_alg_type;
 	u32 class2_alg_type;
 	u32 alg_op;
@@ -900,7 +909,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha1),cbc(aes))",
 		.driver_name = "authenc-hmac-sha1-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -918,7 +928,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha256),cbc(aes))",
 		.driver_name = "authenc-hmac-sha256-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -937,7 +948,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha512),cbc(aes))",
 		.driver_name = "authenc-hmac-sha512-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -956,7 +968,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha1-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -974,7 +987,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha256),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha256-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -993,7 +1007,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha512),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha512-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -1012,7 +1027,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha1),cbc(des))",
 		.driver_name = "authenc-hmac-sha1-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -1030,7 +1046,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha256),cbc(des))",
 		.driver_name = "authenc-hmac-sha256-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -1049,7 +1066,8 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha512),cbc(des))",
 		.driver_name = "authenc-hmac-sha512-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
-		.aead = {
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
@@ -1107,8 +1125,8 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
 	kfree(ctx->sh_desc);
 
-	if (!dma_mapping_error(ctx->jrdev, ctx->key_phys))
-		dma_unmap_single(ctx->jrdev, ctx->key_phys,
+	if (!dma_mapping_error(ctx->jrdev, ctx->key_dma))
+		dma_unmap_single(ctx->jrdev, ctx->key_dma,
 				 ctx->split_key_pad_len + ctx->enckeylen,
 				 DMA_TO_DEVICE);
 	kfree(ctx->key);
@@ -1175,12 +1193,16 @@ static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
 	alg->cra_init = caam_cra_init;
 	alg->cra_exit = caam_cra_exit;
 	alg->cra_priority = CAAM_CRA_PRIORITY;
-	alg->cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_type = &crypto_aead_type;
 	alg->cra_ctxsize = sizeof(struct caam_ctx);
-	alg->cra_u.aead = template->aead;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | template->type;
+	switch (template->type) {
+	case CRYPTO_ALG_TYPE_AEAD:
+		alg->cra_type = &crypto_aead_type;
+		alg->cra_aead = template->template_aead;
+		break;
+	}
 
 	t_alg->class1_alg_type = template->class1_alg_type;
 	t_alg->class2_alg_type = template->class2_alg_type;
-- 
1.7.6
