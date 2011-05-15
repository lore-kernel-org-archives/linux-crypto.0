From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/4] crypto: caam - add support for sha512 variants of
 existing AEAD algorithms
Date: Sat, 14 May 2011 22:08:17 -0500
Message-ID: <20110514220817.33d6d8c3.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3884 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753650Ab1EODIY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 May 2011 23:08:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In doing so, sha512 sized keys would not fit with the current
descriptor inlining mechanism, so we now calculate whether keys
should be referenced instead by pointers in the shared descriptor.

also, use symbols for descriptor text lengths, and, ahem, unmap and
free key i/o memory in cra_exit.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c     |  119 +++++++++++++++++++++++++++++++++----
 drivers/crypto/caam/desc_constr.h |    1 +
 2 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 672abf3..d0e65d6 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -61,6 +61,12 @@
 /* max IV is max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 #define CAAM_MAX_IV_LENGTH		16
 
+/* length of descriptors text */
+#define DESC_AEAD_SHARED_TEXT_LEN	4
+#define DESC_AEAD_ENCRYPT_TEXT_LEN 	21
+#define DESC_AEAD_DECRYPT_TEXT_LEN 	24
+#define DESC_AEAD_GIVENCRYPT_TEXT_LEN 	27
+
 #ifdef DEBUG
 /* for print_hex_dumps with line references */
 #define xstr(s) str(s)
@@ -219,10 +225,22 @@ static int build_sh_desc_ipsec(struct caam_ctx *ctx)
 	struct device *jrdev = ctx->jrdev;
 	u32 *sh_desc;
 	u32 *jump_cmd;
+	bool keys_fit_inline = 0;
+
+	/*
+	 * largest Job Descriptor and its Shared Descriptor
+	 * must both fit into the 64-word Descriptor h/w Buffer
+	 */
+	if ((DESC_AEAD_GIVENCRYPT_TEXT_LEN +
+	     DESC_AEAD_SHARED_TEXT_LEN) * CAAM_CMD_SZ +
+	    ctx->split_key_pad_len + ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
+		keys_fit_inline = 1;
 
 	/* build shared descriptor for this session */
-	sh_desc = kmalloc(CAAM_CMD_SZ * 4 + ctx->split_key_pad_len +
-			  ctx->enckeylen, GFP_DMA | GFP_KERNEL);
+	sh_desc = kmalloc(CAAM_CMD_SZ * DESC_AEAD_SHARED_TEXT_LEN +
+			  keys_fit_inline ?
+			  ctx->split_key_pad_len + ctx->enckeylen :
+			  CAAM_PTR_SZ * 2, GFP_DMA | GFP_KERNEL);
 	if (!sh_desc) {
 		dev_err(jrdev, "could not allocate shared descriptor\n");
 		return -ENOMEM;
@@ -233,14 +251,23 @@ static int build_sh_desc_ipsec(struct caam_ctx *ctx)
 	jump_cmd = append_jump(sh_desc, CLASS_BOTH | JUMP_TEST_ALL |
 			       JUMP_COND_SHRD | JUMP_COND_SELF);
 
-	/* process keys, starting with class 2/authentication */
-	append_key_as_imm(sh_desc, ctx->key, ctx->split_key_pad_len,
-			  ctx->split_key_len,
-			  CLASS_2 | KEY_DEST_MDHA_SPLIT | KEY_ENC);
-
-	append_key_as_imm(sh_desc, (void *)ctx->key + ctx->split_key_pad_len,
-			  ctx->enckeylen, ctx->enckeylen,
-			  CLASS_1 | KEY_DEST_CLASS_REG);
+	/*
+	 * process keys, starting with class 2/authentication.
+	 */
+	if (keys_fit_inline) {
+		append_key_as_imm(sh_desc, ctx->key, ctx->split_key_pad_len,
+				  ctx->split_key_len,
+				  CLASS_2 | KEY_DEST_MDHA_SPLIT | KEY_ENC);
+
+		append_key_as_imm(sh_desc, (void *)ctx->key +
+				  ctx->split_key_pad_len, ctx->enckeylen,
+				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	} else {
+		append_key(sh_desc, ctx->key_phys, ctx->split_key_len, CLASS_2 |
+			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
+		append_key(sh_desc, ctx->key_phys + ctx->split_key_pad_len,
+			   ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	}
 
 	/* update jump cmd now that we are at the jump target */
 	set_jump_tgt_here(sh_desc, jump_cmd);
@@ -746,7 +773,8 @@ static int aead_authenc_encrypt(struct aead_request *areq)
 	dma_addr_t iv_dma;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(areq, 21 * sizeof(u32));
+	edesc = ipsec_esp_edesc_alloc(areq, DESC_AEAD_ENCRYPT_TEXT_LEN *
+				      CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -778,7 +806,8 @@ static int aead_authenc_decrypt(struct aead_request *req)
 	req->cryptlen -= ctx->authsize;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(req, 24 * sizeof(u32));
+	edesc = ipsec_esp_edesc_alloc(req, DESC_AEAD_DECRYPT_TEXT_LEN *
+				      CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -813,7 +842,8 @@ static int aead_authenc_givencrypt(struct aead_givcrypt_request *req)
 	debug("%s: giv %p\n", __func__, req->giv);
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(areq, 27 * sizeof(u32));
+	edesc = ipsec_esp_edesc_alloc(areq, DESC_AEAD_GIVENCRYPT_TEXT_LEN *
+				      CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -904,6 +934,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha512),cbc(aes))",
+		.driver_name = "authenc-hmac-sha512-cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha1-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
@@ -941,6 +990,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha512),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha512-cbc-des3_ede-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha1),cbc(des))",
 		.driver_name = "authenc-hmac-sha1-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
@@ -977,6 +1045,25 @@ static struct caam_alg_template driver_algs[] = {
 				   OP_ALG_AAI_HMAC_PRECOMP,
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	},
+	{
+		.name = "authenc(hmac(sha512),cbc(des))",
+		.driver_name = "authenc-hmac-sha512-cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+	},
 };
 
 struct caam_crypto_alg {
@@ -1019,6 +1106,12 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 		dma_unmap_single(ctx->jrdev, ctx->shared_desc_phys,
 				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
 	kfree(ctx->sh_desc);
+
+	if (!dma_mapping_error(ctx->jrdev, ctx->key_phys))
+		dma_unmap_single(ctx->jrdev, ctx->key_phys,
+				 ctx->split_key_pad_len + ctx->enckeylen,
+				 DMA_TO_DEVICE);
+	kfree(ctx->key);
 }
 
 static void __exit caam_algapi_exit(void)
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index c224f39..4691580 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -9,6 +9,7 @@
 #define IMMEDIATE (1 << 23)
 #define CAAM_CMD_SZ sizeof(u32)
 #define CAAM_PTR_SZ sizeof(dma_addr_t)
+#define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * 64)
 
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
-- 
1.7.5.1
