From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC PATCH 05/10] crypto: caam/qi - prepare for gcm(aes) support
Date: Thu, 10 Aug 2017 20:42:48 +0300
Message-ID: <20170810174253.20951-6-horia.geanta@nxp.com>
References: <20170810174253.20951-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devel@driverdev.osuosl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0062.outbound.protection.outlook.com ([104.47.34.62]:46720
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753180AbdHJRnt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 13:43:49 -0400
In-Reply-To: <20170810174253.20951-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update gcm(aes) descriptors (generic, rfc4106 and rfc4543) such that
they would also work when submitted via the QI interface.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c      |  19 +++--
 drivers/crypto/caam/caamalg_desc.c | 165 ++++++++++++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_desc.h |  24 ++++--
 3 files changed, 183 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e0d1b5c3c1ba..94e12ec8141c 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -290,6 +290,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - GCM_DESC_JOB_IO_LEN -
 			ctx->cdata.keylen;
@@ -311,7 +312,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	}
 
 	desc = ctx->sh_desc_enc;
-	cnstr_shdsc_gcm_encap(desc, &ctx->cdata, ctx->authsize);
+	cnstr_shdsc_gcm_encap(desc, &ctx->cdata, ivsize, ctx->authsize, false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
 				   desc_bytes(desc), DMA_TO_DEVICE);
 
@@ -328,7 +329,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	}
 
 	desc = ctx->sh_desc_dec;
-	cnstr_shdsc_gcm_decap(desc, &ctx->cdata, ctx->authsize);
+	cnstr_shdsc_gcm_decap(desc, &ctx->cdata, ivsize, ctx->authsize, false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
 				   desc_bytes(desc), DMA_TO_DEVICE);
 
@@ -349,6 +350,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - GCM_DESC_JOB_IO_LEN -
 			ctx->cdata.keylen;
@@ -370,7 +372,8 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	}
 
 	desc = ctx->sh_desc_enc;
-	cnstr_shdsc_rfc4106_encap(desc, &ctx->cdata, ctx->authsize);
+	cnstr_shdsc_rfc4106_encap(desc, &ctx->cdata, ivsize, ctx->authsize,
+				  false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
 				   desc_bytes(desc), DMA_TO_DEVICE);
 
@@ -387,7 +390,8 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	}
 
 	desc = ctx->sh_desc_dec;
-	cnstr_shdsc_rfc4106_decap(desc, &ctx->cdata, ctx->authsize);
+	cnstr_shdsc_rfc4106_decap(desc, &ctx->cdata, ivsize, ctx->authsize,
+				  false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
 				   desc_bytes(desc), DMA_TO_DEVICE);
 
@@ -409,6 +413,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - GCM_DESC_JOB_IO_LEN -
 			ctx->cdata.keylen;
@@ -430,7 +435,8 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	}
 
 	desc = ctx->sh_desc_enc;
-	cnstr_shdsc_rfc4543_encap(desc, &ctx->cdata, ctx->authsize);
+	cnstr_shdsc_rfc4543_encap(desc, &ctx->cdata, ivsize, ctx->authsize,
+				  false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
 				   desc_bytes(desc), DMA_TO_DEVICE);
 
@@ -447,7 +453,8 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	}
 
 	desc = ctx->sh_desc_dec;
-	cnstr_shdsc_rfc4543_decap(desc, &ctx->cdata, ctx->authsize);
+	cnstr_shdsc_rfc4543_decap(desc, &ctx->cdata, ivsize, ctx->authsize,
+				  false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
 				   desc_bytes(desc), DMA_TO_DEVICE);
 
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 530c14ee32de..54c6ff2ff975 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -587,10 +587,13 @@ EXPORT_SYMBOL(cnstr_shdsc_aead_givencap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - OP_ALG_ALGSEL_AES ANDed with OP_ALG_AAI_GCM.
+ * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
-			   unsigned int icvsize)
+			   unsigned int ivsize, unsigned int icvsize,
+			   const bool is_qi)
 {
 	u32 *key_jump_cmd, *zero_payload_jump_cmd, *zero_assoc_jump_cmd1,
 	    *zero_assoc_jump_cmd2;
@@ -612,11 +615,35 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_ENCRYPT);
 
+	if (is_qi) {
+		u32 *wait_load_cmd;
+
+		/* REG3 = assoclen */
+		append_seq_load(desc, 4, LDST_CLASS_DECO |
+				LDST_SRCDST_WORD_DECO_MATH3 |
+				(4 << LDST_OFFSET_SHIFT));
+
+		wait_load_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+					    JUMP_COND_CALM | JUMP_COND_NCP |
+					    JUMP_COND_NOP | JUMP_COND_NIP |
+					    JUMP_COND_NIFP);
+		set_jump_tgt_here(desc, wait_load_cmd);
+
+		append_math_sub_imm_u32(desc, VARSEQOUTLEN, SEQINLEN, IMM,
+					ivsize);
+	} else {
+		append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0,
+				CAAM_CMD_SZ);
+	}
+
 	/* if assoclen + cryptlen is ZERO, skip to ICV write */
-	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
 						 JUMP_COND_MATH_Z);
 
+	if (is_qi)
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+
 	/* if assoclen is ZERO, skip reading the assoc data */
 	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
@@ -648,8 +675,11 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
 
-	/* jump the zero-payload commands */
-	append_jump(desc, JUMP_TEST_ALL | 2);
+	/* jump to ICV writing */
+	if (is_qi)
+		append_jump(desc, JUMP_TEST_ALL | 4);
+	else
+		append_jump(desc, JUMP_TEST_ALL | 2);
 
 	/* zero-payload commands */
 	set_jump_tgt_here(desc, zero_payload_jump_cmd);
@@ -657,10 +687,18 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
 	/* read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST1);
+	if (is_qi)
+		/* jump to ICV writing */
+		append_jump(desc, JUMP_TEST_ALL | 2);
 
 	/* There is no input data */
 	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
 
+	if (is_qi)
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 |
+				     FIFOLD_TYPE_LAST1);
+
 	/* write ICV */
 	append_seq_store(desc, icvsize, LDST_CLASS_1_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
@@ -677,10 +715,13 @@ EXPORT_SYMBOL(cnstr_shdsc_gcm_encap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - OP_ALG_ALGSEL_AES ANDed with OP_ALG_AAI_GCM.
+ * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_gcm_decap(u32 * const desc, struct alginfo *cdata,
-			   unsigned int icvsize)
+			   unsigned int ivsize, unsigned int icvsize,
+			   const bool is_qi)
 {
 	u32 *key_jump_cmd, *zero_payload_jump_cmd, *zero_assoc_jump_cmd1;
 
@@ -701,6 +742,24 @@ void cnstr_shdsc_gcm_decap(u32 * const desc, struct alginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
+	if (is_qi) {
+		u32 *wait_load_cmd;
+
+		/* REG3 = assoclen */
+		append_seq_load(desc, 4, LDST_CLASS_DECO |
+				LDST_SRCDST_WORD_DECO_MATH3 |
+				(4 << LDST_OFFSET_SHIFT));
+
+		wait_load_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+					    JUMP_COND_CALM | JUMP_COND_NCP |
+					    JUMP_COND_NOP | JUMP_COND_NIP |
+					    JUMP_COND_NIFP);
+		set_jump_tgt_here(desc, wait_load_cmd);
+
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	}
+
 	/* if assoclen is ZERO, skip reading the assoc data */
 	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
@@ -753,10 +812,13 @@ EXPORT_SYMBOL(cnstr_shdsc_gcm_decap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - OP_ALG_ALGSEL_AES ANDed with OP_ALG_AAI_GCM.
+ * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize)
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi)
 {
 	u32 *key_jump_cmd;
 
@@ -777,7 +839,29 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_ENCRYPT);
 
-	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, 8);
+	if (is_qi) {
+		u32 *wait_load_cmd;
+
+		/* REG3 = assoclen */
+		append_seq_load(desc, 4, LDST_CLASS_DECO |
+				LDST_SRCDST_WORD_DECO_MATH3 |
+				(4 << LDST_OFFSET_SHIFT));
+
+		wait_load_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+					    JUMP_COND_CALM | JUMP_COND_NCP |
+					    JUMP_COND_NOP | JUMP_COND_NIP |
+					    JUMP_COND_NIFP);
+		set_jump_tgt_here(desc, wait_load_cmd);
+
+		/* Read salt and IV */
+		append_fifo_load_as_imm(desc, (void *)(cdata->key_virt +
+					cdata->keylen), 4, FIFOLD_CLASS_CLASS1 |
+					FIFOLD_TYPE_IV);
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	}
+
+	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, ivsize);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
 	/* Read assoc data */
@@ -785,7 +869,7 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
 
 	/* Skip IV */
-	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
 
 	/* Will read cryptlen bytes */
 	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
@@ -824,10 +908,13 @@ EXPORT_SYMBOL(cnstr_shdsc_rfc4106_encap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - OP_ALG_ALGSEL_AES ANDed with OP_ALG_AAI_GCM.
+ * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_rfc4106_decap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize)
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi)
 {
 	u32 *key_jump_cmd;
 
@@ -849,7 +936,29 @@ void cnstr_shdsc_rfc4106_decap(u32 * const desc, struct alginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
-	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, 8);
+	if (is_qi) {
+		u32 *wait_load_cmd;
+
+		/* REG3 = assoclen */
+		append_seq_load(desc, 4, LDST_CLASS_DECO |
+				LDST_SRCDST_WORD_DECO_MATH3 |
+				(4 << LDST_OFFSET_SHIFT));
+
+		wait_load_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+					    JUMP_COND_CALM | JUMP_COND_NCP |
+					    JUMP_COND_NOP | JUMP_COND_NIP |
+					    JUMP_COND_NIFP);
+		set_jump_tgt_here(desc, wait_load_cmd);
+
+		/* Read salt and IV */
+		append_fifo_load_as_imm(desc, (void *)(cdata->key_virt +
+					cdata->keylen), 4, FIFOLD_CLASS_CLASS1 |
+					FIFOLD_TYPE_IV);
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	}
+
+	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, ivsize);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
 	/* Read assoc data */
@@ -857,7 +966,7 @@ void cnstr_shdsc_rfc4106_decap(u32 * const desc, struct alginfo *cdata,
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
 
 	/* Skip IV */
-	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
 
 	/* Will read cryptlen bytes */
 	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG3, CAAM_CMD_SZ);
@@ -896,10 +1005,13 @@ EXPORT_SYMBOL(cnstr_shdsc_rfc4106_decap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - OP_ALG_ALGSEL_AES ANDed with OP_ALG_AAI_GCM.
+ * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_rfc4543_encap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize)
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi)
 {
 	u32 *key_jump_cmd, *read_move_cmd, *write_move_cmd;
 
@@ -920,6 +1032,18 @@ void cnstr_shdsc_rfc4543_encap(u32 * const desc, struct alginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_ENCRYPT);
 
+	if (is_qi) {
+		/* assoclen is not needed, skip it */
+		append_seq_fifo_load(desc, 4, FIFOLD_CLASS_SKIP);
+
+		/* Read salt and IV */
+		append_fifo_load_as_imm(desc, (void *)(cdata->key_virt +
+					cdata->keylen), 4, FIFOLD_CLASS_CLASS1 |
+					FIFOLD_TYPE_IV);
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	}
+
 	/* assoclen + cryptlen = seqinlen */
 	append_math_sub(desc, REG3, SEQINLEN, REG0, CAAM_CMD_SZ);
 
@@ -966,10 +1090,13 @@ EXPORT_SYMBOL(cnstr_shdsc_rfc4543_encap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - OP_ALG_ALGSEL_AES ANDed with OP_ALG_AAI_GCM.
+ * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_rfc4543_decap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize)
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi)
 {
 	u32 *key_jump_cmd, *read_move_cmd, *write_move_cmd;
 
@@ -990,6 +1117,18 @@ void cnstr_shdsc_rfc4543_decap(u32 * const desc, struct alginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
+	if (is_qi) {
+		/* assoclen is not needed, skip it */
+		append_seq_fifo_load(desc, 4, FIFOLD_CLASS_SKIP);
+
+		/* Read salt and IV */
+		append_fifo_load_as_imm(desc, (void *)(cdata->key_virt +
+					cdata->keylen), 4, FIFOLD_CLASS_CLASS1 |
+					FIFOLD_TYPE_IV);
+		append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	}
+
 	/* assoclen + cryptlen = seqoutlen */
 	append_math_sub(desc, REG3, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index 8731e4a7ff05..2a874cdb74af 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -26,14 +26,20 @@
 #define DESC_GCM_BASE			(3 * CAAM_CMD_SZ)
 #define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 16 * CAAM_CMD_SZ)
 #define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 12 * CAAM_CMD_SZ)
+#define DESC_QI_GCM_ENC_LEN		(DESC_GCM_ENC_LEN + 6 * CAAM_CMD_SZ)
+#define DESC_QI_GCM_DEC_LEN		(DESC_GCM_DEC_LEN + 3 * CAAM_CMD_SZ)
 
 #define DESC_RFC4106_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 13 * CAAM_CMD_SZ)
 #define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 13 * CAAM_CMD_SZ)
+#define DESC_QI_RFC4106_ENC_LEN		(DESC_RFC4106_ENC_LEN + 5 * CAAM_CMD_SZ)
+#define DESC_QI_RFC4106_DEC_LEN		(DESC_RFC4106_DEC_LEN + 5 * CAAM_CMD_SZ)
 
 #define DESC_RFC4543_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_RFC4543_ENC_LEN		(DESC_RFC4543_BASE + 11 * CAAM_CMD_SZ)
 #define DESC_RFC4543_DEC_LEN		(DESC_RFC4543_BASE + 12 * CAAM_CMD_SZ)
+#define DESC_QI_RFC4543_ENC_LEN		(DESC_RFC4543_ENC_LEN + 4 * CAAM_CMD_SZ)
+#define DESC_QI_RFC4543_DEC_LEN		(DESC_RFC4543_DEC_LEN + 4 * CAAM_CMD_SZ)
 
 #define DESC_ABLKCIPHER_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_ABLKCIPHER_ENC_LEN		(DESC_ABLKCIPHER_BASE + \
@@ -66,22 +72,28 @@ void cnstr_shdsc_aead_givencap(u32 * const desc, struct alginfo *cdata,
 			       const bool is_qi);
 
 void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
-			   unsigned int icvsize);
+			   unsigned int ivsize, unsigned int icvsize,
+			   const bool is_qi);
 
 void cnstr_shdsc_gcm_decap(u32 * const desc, struct alginfo *cdata,
-			   unsigned int icvsize);
+			   unsigned int ivsize, unsigned int icvsize,
+			   const bool is_qi);
 
 void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize);
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi);
 
 void cnstr_shdsc_rfc4106_decap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize);
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi);
 
 void cnstr_shdsc_rfc4543_encap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize);
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi);
 
 void cnstr_shdsc_rfc4543_decap(u32 * const desc, struct alginfo *cdata,
-			       unsigned int icvsize);
+			       unsigned int ivsize, unsigned int icvsize,
+			       const bool is_qi);
 
 void cnstr_shdsc_ablkcipher_encap(u32 * const desc, struct alginfo *cdata,
 				  unsigned int ivsize, const bool is_rfc3686,
-- 
2.12.0.264.gd6db3f216544
