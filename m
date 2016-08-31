From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [PATCH] crypto: caam - fix rfc3686(ctr(aes)) IV load
Date: Wed, 31 Aug 2016 15:57:55 +0300
Message-ID: <1472648275-2542-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, Catalin Vasile <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0052.outbound.protection.outlook.com ([104.47.36.52]:15072
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933835AbcHaOcv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 10:32:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-nonce is being loaded using append_load_imm_u32() instead of
append_load_as_imm() (nonce is a byte array / stream, not a 4-byte
variable)
-counter is not being added in big endian format, as mandatated by
RFC3686 and expected by the crypto engine

Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 82 +++++++++++++++++++--------------------
 drivers/crypto/caam/desc_constr.h | 17 ++++++++
 2 files changed, 57 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 6dc5971..f1116e7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -227,8 +227,9 @@ static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
 	if (is_rfc3686) {
 		nonce = (u32 *)((void *)ctx->key + ctx->split_key_pad_len +
 			       enckeylen);
-		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
-				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
+				   LDST_CLASS_IND_CCB |
+				   LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
 		append_move(desc,
 			    MOVE_SRC_OUTFIFO |
 			    MOVE_DEST_CLASS1CTX |
@@ -500,11 +501,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
-		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
-				    LDST_CLASS_1_CCB |
-				    LDST_SRCDST_BYTE_CONTEXT |
-				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				     LDST_OFFSET_SHIFT));
+		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
+				     LDST_SRCDST_BYTE_CONTEXT |
+				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				      LDST_OFFSET_SHIFT));
 
 	/* Class 1 operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -567,11 +567,10 @@ skip_enc:
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
-		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
-				    LDST_CLASS_1_CCB |
-				    LDST_SRCDST_BYTE_CONTEXT |
-				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				     LDST_OFFSET_SHIFT));
+		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
+				     LDST_SRCDST_BYTE_CONTEXT |
+				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				      LDST_OFFSET_SHIFT));
 
 	/* Choose operation */
 	if (ctr_mode)
@@ -672,11 +671,10 @@ copy_iv:
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
-		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
-				    LDST_CLASS_1_CCB |
-				    LDST_SRCDST_BYTE_CONTEXT |
-				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				     LDST_OFFSET_SHIFT));
+		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
+				     LDST_SRCDST_BYTE_CONTEXT |
+				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				      LDST_OFFSET_SHIFT));
 
 	/* Class 1 operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -1467,7 +1465,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	int ret = 0;
 	u32 *key_jump_cmd;
 	u32 *desc;
-	u32 *nonce;
+	u8 *nonce;
 	u32 geniv;
 	u32 ctx1_iv_off = 0;
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
@@ -1520,9 +1518,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		nonce = (u32 *)(key + keylen);
-		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
-				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		nonce = (u8 *)key + keylen;
+		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
+				   LDST_CLASS_IND_CCB |
+				   LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
 		append_move(desc, MOVE_WAITCOMP |
 			    MOVE_SRC_OUTFIFO |
 			    MOVE_DEST_CLASS1CTX |
@@ -1538,11 +1537,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* Load counter into CONTEXT1 reg */
 	if (is_rfc3686)
-		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
-				    LDST_CLASS_1_CCB |
-				    LDST_SRCDST_BYTE_CONTEXT |
-				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				     LDST_OFFSET_SHIFT));
+		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
+				     LDST_SRCDST_BYTE_CONTEXT |
+				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				      LDST_OFFSET_SHIFT));
 
 	/* Load operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -1579,9 +1577,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		nonce = (u32 *)(key + keylen);
-		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
-				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		nonce = (u8 *)key + keylen;
+		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
+				   LDST_CLASS_IND_CCB |
+				   LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
 		append_move(desc, MOVE_WAITCOMP |
 			    MOVE_SRC_OUTFIFO |
 			    MOVE_DEST_CLASS1CTX |
@@ -1597,11 +1596,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* Load counter into CONTEXT1 reg */
 	if (is_rfc3686)
-		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
-				    LDST_CLASS_1_CCB |
-				    LDST_SRCDST_BYTE_CONTEXT |
-				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				     LDST_OFFSET_SHIFT));
+		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
+				     LDST_SRCDST_BYTE_CONTEXT |
+				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				      LDST_OFFSET_SHIFT));
 
 	/* Choose operation */
 	if (ctr_mode)
@@ -1642,9 +1640,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* Load Nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		nonce = (u32 *)(key + keylen);
-		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
-				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		nonce = (u8 *)key + keylen;
+		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
+				   LDST_CLASS_IND_CCB |
+				   LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
 		append_move(desc, MOVE_WAITCOMP |
 			    MOVE_SRC_OUTFIFO |
 			    MOVE_DEST_CLASS1CTX |
@@ -1674,11 +1673,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
-		append_load_imm_u32(desc, (u32)1, LDST_IMM |
-				    LDST_CLASS_1_CCB |
-				    LDST_SRCDST_BYTE_CONTEXT |
-				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				     LDST_OFFSET_SHIFT));
+		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
+				     LDST_SRCDST_BYTE_CONTEXT |
+				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				      LDST_OFFSET_SHIFT));
 
 	if (ctx1_iv_off)
 		append_jump(desc, JUMP_JSL | JUMP_TEST_ALL | JUMP_COND_NCP |
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index d3869b9..a8cd8a7 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -325,6 +325,23 @@ static inline void append_##cmd##_imm_##type(u32 *desc, type immediate, \
 APPEND_CMD_RAW_IMM(load, LOAD, u32);
 
 /*
+ * ee - endianness
+ * size - size of immediate type in bytes
+ */
+#define APPEND_CMD_RAW_IMM2(cmd, op, ee, size) \
+static inline void append_##cmd##_imm_##ee##size(u32 *desc, \
+						   u##size immediate, \
+						   u32 options) \
+{ \
+	__##ee##size data = cpu_to_##ee##size(immediate); \
+	PRINT_POS; \
+	append_cmd(desc, CMD_##op | IMMEDIATE | options | sizeof(data)); \
+	append_data(desc, &data, sizeof(data)); \
+}
+
+APPEND_CMD_RAW_IMM2(load, LOAD, be, 32);
+
+/*
  * Append math command. Only the last part of destination and source need to
  * be specified
  */
-- 
1.8.3.1
