From: Catalin Vasile <catalin.vasile@freescale.com>
Subject: [PATCH 2/4] crypto: caam - add support for rfc3686(ctr(aes))
Date: Fri, 31 Oct 2014 12:45:36 +0200
Message-ID: <1414752338-5711-2-git-send-email-catalin.vasile@freescale.com>
References: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:19520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757608AbaJaLA6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2014 07:00:58 -0400
In-Reply-To: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for Advanced Encryption Standard (AES) in Counter Mode (CTR)
as provided in IPsec implementation standard RFC3686.

ablkcipher shared descriptors now save context registers after job
execution. This is used to load Nonce specific to RFC3686 only at
first execution of shared job descriptor.

Signed-off-by: Catalin Vasile <catalin.vasile@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 83 ++++++++++++++++++++++++++++++++++++++++---
 drivers/crypto/caam/compat.h  |  1 +
 2 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 859ebe8..2909efc 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1296,14 +1296,19 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 			     const u8 *key, unsigned int keylen)
 {
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
-	struct ablkcipher_tfm *tfm = &ablkcipher->base.crt_ablkcipher;
+	struct ablkcipher_tfm *crt = &ablkcipher->base.crt_ablkcipher;
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablkcipher);
+	const char *alg_name = crypto_tfm_alg_name(tfm);
 	struct device *jrdev = ctx->jrdev;
 	int ret = 0;
 	u32 *key_jump_cmd;
 	u32 *desc;
+	u32 *nonce;
 	u32 ctx1_iv_off = 0;
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
+	const bool is_rfc3686 = (ctr_mode &&
+				 (strstr(alg_name, "rfc3686") != NULL));
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
@@ -1317,6 +1322,16 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	if (ctr_mode)
 		ctx1_iv_off = 16;
 
+	/*
+	 * RFC3686 specific:
+	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
+	 *	| *key = {KEY, NONCE}
+	 */
+	if (is_rfc3686) {
+		ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
+		keylen -= CTR_RFC3686_NONCE_SIZE;
+	}
+
 	memcpy(ctx->key, key, keylen);
 	ctx->key_dma = dma_map_single(jrdev, ctx->key, keylen,
 				      DMA_TO_DEVICE);
@@ -1328,7 +1343,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* ablkcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
@@ -1338,12 +1353,32 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 			  ctx->enckeylen, CLASS_1 |
 			  KEY_DEST_CLASS_REG);
 
+	/* Load nonce into CONTEXT1 reg */
+	if (is_rfc3686) {
+		nonce = (u32 *)(key + keylen);
+		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
+				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		append_move(desc, MOVE_WAITCOMP |
+			    MOVE_SRC_OUTFIFO |
+			    MOVE_DEST_CLASS1CTX |
+			    (16 << MOVE_OFFSET_SHIFT) |
+			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
+	}
+
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* Load iv */
-	append_seq_load(desc, tfm->ivsize, LDST_SRCDST_BYTE_CONTEXT |
+	append_seq_load(desc, crt->ivsize, LDST_SRCDST_BYTE_CONTEXT |
 			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
 
+	/* Load counter into CONTEXT1 reg */
+	if (is_rfc3686)
+		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
+				    LDST_CLASS_1_CCB |
+				    LDST_SRCDST_BYTE_CONTEXT |
+				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				     LDST_OFFSET_SHIFT));
+
 	/* Load operation */
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
@@ -1367,7 +1402,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	/* ablkcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
@@ -1377,12 +1412,32 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 			  ctx->enckeylen, CLASS_1 |
 			  KEY_DEST_CLASS_REG);
 
+	/* Load nonce into CONTEXT1 reg */
+	if (is_rfc3686) {
+		nonce = (u32 *)(key + keylen);
+		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
+				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		append_move(desc, MOVE_WAITCOMP |
+			    MOVE_SRC_OUTFIFO |
+			    MOVE_DEST_CLASS1CTX |
+			    (16 << MOVE_OFFSET_SHIFT) |
+			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
+	}
+
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* load IV */
-	append_seq_load(desc, tfm->ivsize, LDST_SRCDST_BYTE_CONTEXT |
+	append_seq_load(desc, crt->ivsize, LDST_SRCDST_BYTE_CONTEXT |
 			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
 
+	/* Load counter into CONTEXT1 reg */
+	if (is_rfc3686)
+		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
+				    LDST_CLASS_1_CCB |
+				    LDST_SRCDST_BYTE_CONTEXT |
+				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				     LDST_OFFSET_SHIFT));
+
 	/* Choose operation */
 	if (ctr_mode)
 		append_operation(desc, ctx->class1_alg_type |
@@ -3106,6 +3161,24 @@ static struct caam_alg_template driver_algs[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			},
 		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+	},
+	{
+		.name = "rfc3686(ctr(aes))",
+		.driver_name = "rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "seqiv",
+			.min_keysize = AES_MIN_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
 	}
 };
 
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index f227922..acd7743 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -28,6 +28,7 @@
 #include <crypto/algapi.h>
 #include <crypto/null.h>
 #include <crypto/aes.h>
+#include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
-- 
1.8.3.1
