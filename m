From: Catalin Vasile <catalin.vasile@freescale.com>
Subject: [PATCH 1/4] crypto: caam - add support for ctr(aes)
Date: Fri, 31 Oct 2014 12:45:35 +0200
Message-ID: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:7857
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757608AbaJaLAz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2014 07:00:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for AES working in Counter Mode

Signed-off-by: Catalin Vasile <catalin.vasile@freescale.com>
---
 drivers/crypto/caam/caamalg.c     | 40 ++++++++++++++++++++++++++++++++++-----
 drivers/crypto/caam/desc_constr.h |  2 ++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c17154c..859ebe8 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1301,11 +1301,21 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	int ret = 0;
 	u32 *key_jump_cmd;
 	u32 *desc;
+	u32 ctx1_iv_off = 0;
+	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
+			       OP_ALG_AAI_CTR_MOD128);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 #endif
+	/*
+	 * AES-CTR needs to load IV in CONTEXT1 reg
+	 * at an offset of 128bits (16bytes)
+	 * CONTEXT1[255:128] = IV
+	 */
+	if (ctr_mode)
+		ctx1_iv_off = 16;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->key_dma = dma_map_single(jrdev, ctx->key, keylen,
@@ -1331,8 +1341,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* Load iv */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | tfm->ivsize);
+	append_seq_load(desc, tfm->ivsize, LDST_SRCDST_BYTE_CONTEXT |
+			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
 
 	/* Load operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -1370,11 +1380,15 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* load IV */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | tfm->ivsize);
+	append_seq_load(desc, tfm->ivsize, LDST_SRCDST_BYTE_CONTEXT |
+			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
 
 	/* Choose operation */
-	append_dec_op1(desc, ctx->class1_alg_type);
+	if (ctr_mode)
+		append_operation(desc, ctx->class1_alg_type |
+				 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT);
+	else
+		append_dec_op1(desc, ctx->class1_alg_type);
 
 	/* Perform operation */
 	ablkcipher_append_src_dst(desc);
@@ -3076,6 +3090,22 @@ static struct caam_alg_template driver_algs[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			},
 		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+	},
+	{
+		.name = "ctr(aes)",
+		.driver_name = "ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "chainiv",
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
 	}
 };
 
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 7eec20b..9f79fd7 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -192,6 +192,8 @@ static inline void append_##cmd(u32 *desc, unsigned int len, u32 options) \
 	PRINT_POS; \
 	append_cmd(desc, CMD_##op | len | options); \
 }
+
+APPEND_CMD_LEN(seq_load, SEQ_LOAD)
 APPEND_CMD_LEN(seq_store, SEQ_STORE)
 APPEND_CMD_LEN(seq_fifo_load, SEQ_FIFO_LOAD)
 APPEND_CMD_LEN(seq_fifo_store, SEQ_FIFO_STORE)
-- 
1.8.3.1
