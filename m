From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 11/12] crypto: caam - move caamalg shared descs in RTA library
Date: Thu, 14 Aug 2014 15:54:33 +0300
Message-ID: <1408020874-2211-12-git-send-email-horia.geanta@freescale.com>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:14515
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754839AbaHNM4N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:13 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

aead shared descriptors are moved from caamalg in RTA library
(ipsec.h), since in this way they can be shared with other applications.

ablkcipher encrypt / decrypt shared descriptors are refactored into
a single descriptor and moved in RTA (algo.h) for the same reason.

Other descriptors (for e.g. from caamhash) are left as is,
since they are not general purpose.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c         | 592 +++++-----------------------------
 drivers/crypto/caam/flib/desc/algo.h  |  88 +++++
 drivers/crypto/caam/flib/desc/ipsec.h | 550 +++++++++++++++++++++++++++++++
 3 files changed, 720 insertions(+), 510 deletions(-)
 create mode 100644 drivers/crypto/caam/flib/desc/algo.h
 create mode 100644 drivers/crypto/caam/flib/desc/ipsec.h

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 9090fc8c04e0..746bb0b21695 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -50,6 +50,8 @@
 #include "intern.h"
 #include "flib/rta.h"
 #include "flib/desc/common.h"
+#include "flib/desc/algo.h"
+#include "flib/desc/ipsec.h"
 #include "jr.h"
 #include "error.h"
 #include "sg_sw_sec4.h"
@@ -65,22 +67,7 @@
 /* max IV is max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 #define CAAM_MAX_IV_LENGTH		16
 
-/* length of descriptors text */
-#define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
-#define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 18 * CAAM_CMD_SZ)
-#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
-
-#define DESC_AEAD_NULL_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_AEAD_NULL_ENC_LEN		(DESC_AEAD_NULL_BASE + 14 * CAAM_CMD_SZ)
-#define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
-
-#define DESC_ABLKCIPHER_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_ABLKCIPHER_ENC_LEN		(DESC_ABLKCIPHER_BASE + \
-					 20 * CAAM_CMD_SZ)
-#define DESC_ABLKCIPHER_DEC_LEN		(DESC_ABLKCIPHER_BASE + \
-					 15 * CAAM_CMD_SZ)
-
+/* maximum length of descriptors text */
 #define DESC_MAX_USED_BYTES		(DESC_AEAD_GIVENC_LEN + \
 					 CAAM_MAX_KEY_SIZE)
 #define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
@@ -124,96 +111,33 @@ struct caam_ctx {
 
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
-	struct aead_tfm *tfm = &aead->base.crt_aead;
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	bool keys_fit_inline = false;
 	u32 *desc;
-	struct program prg;
-	struct program *p = &prg;
 	unsigned desc_bytes;
-	LABEL(skip_key_load);
-	REFERENCE(pskip_key_load);
-	LABEL(nop_cmd);
-	REFERENCE(pnop_cmd);
-	LABEL(read_move_cmd);
-	REFERENCE(pread_move_cmd);
-	LABEL(write_move_cmd);
-	REFERENCE(pwrite_move_cmd);
+	struct alginfo authdata;
+	int rem_bytes = CAAM_DESC_BYTES_MAX - (DESC_JOB_IO_LEN +
+			ctx->split_key_pad_len);
+
+	authdata.algtype = ctx->class2_alg_type;
+	authdata.key_enc_flags = ENC;
+	authdata.keylen = ctx->split_key_len;
 
 	/*
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
-	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
+	if (rem_bytes >= DESC_AEAD_NULL_ENC_LEN) {
+		authdata.key = (uintptr_t)ctx->key;
+		authdata.key_type = RTA_DATA_IMM;
+	} else {
+		authdata.key = ctx->key_dma;
+		authdata.key_type = RTA_DATA_PTR;
+	}
 
 	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-	if (keys_fit_inline)
-		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-		    ctx->split_key_len, IMMED | COPY);
-	else
-		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
-		    0);
-	SET_LABEL(p, skip_key_load);
-
-	/* cryptlen = seqoutlen - authsize */
-	MATHB(p, SEQOUTSZ, SUB, ctx->authsize, MATH3, CAAM_CMD_SZ, IMMED2);
-
-	/*
-	 * NULL encryption; IV is zero
-	 * assoclen = (assoclen + cryptlen) - cryptlen
-	 */
-	MATHB(p, SEQINSZ, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* read assoc before reading payload */
-	SEQFIFOLOAD(p, MSG2, 0 , VLF);
-
-	/* Prepare to read and write cryptlen bytes */
-	MATHB(p, ZERO, ADD, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
-	MATHB(p, ZERO, ADD, MATH3, VSEQOUTSZ, CAAM_CMD_SZ, 0);
-
-	/*
-	 * MOVE_LEN opcode is not available in all SEC HW revisions,
-	 * thus need to do some magic, i.e. self-patch the descriptor
-	 * buffer.
-	 */
-	pread_move_cmd = MOVE(p, DESCBUF, 0, MATH3, 0, 6, IMMED);
-	pwrite_move_cmd = MOVE(p, MATH3, 0, DESCBUF, 0, 8, WAITCOMP | IMMED);
-
-	/* Class 2 operation */
-	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* Read and write cryptlen bytes */
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-	SEQFIFOLOAD(p, MSGINSNOOP, 0, VLF | LAST1 | LAST2 | FLUSH1);
-
-	SET_LABEL(p, read_move_cmd);
-	SET_LABEL(p, write_move_cmd);
-	LOAD(p, 0, DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, IMMED);
-	MOVE(p, IFIFOAB1, 0, OFIFO, 0, 0, IMMED);
-
-	/* Write ICV */
-	SEQSTORE(p, CONTEXT2, 0, ctx->authsize, 0);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-	PATCH_MOVE(p, pread_move_cmd, read_move_cmd);
-	PATCH_MOVE(p, pwrite_move_cmd, write_move_cmd);
-
-	PROGRAM_FINALIZE(p);
-
+	cnstr_shdsc_aead_null_encap(desc, ps, &authdata, ctx->authsize);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
@@ -231,83 +155,17 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
-	keys_fit_inline = false;
-	if (DESC_AEAD_NULL_DEC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
+	if (rem_bytes >= DESC_AEAD_NULL_DEC_LEN) {
+		authdata.key = (uintptr_t)ctx->key;
+		authdata.key_type = RTA_DATA_IMM;
+	} else {
+		authdata.key = ctx->key_dma;
+		authdata.key_type = RTA_DATA_PTR;
+	}
 
 	/* aead_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-	if (keys_fit_inline)
-		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-		    ctx->split_key_len, IMMED | COPY);
-	else
-		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
-		    0);
-	SET_LABEL(p, skip_key_load);
-
-	/* Class 2 operation */
-	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_ENABLE, DIR_DEC);
-
-	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
-	MATHB(p, SEQINSZ, SUB, ctx->authsize + tfm->ivsize, MATH3, CAAM_CMD_SZ,
-	      IMMED2);
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	MATHB(p, SEQOUTSZ, SUB, MATH0, MATH2, CAAM_CMD_SZ, 0);
-	MATHB(p, MATH3, SUB, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* read assoc before reading payload */
-	SEQFIFOLOAD(p, MSG2, 0 , VLF);
-
-	/* Prepare to read and write cryptlen bytes */
-	MATHB(p, ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
-	MATHB(p, ZERO, ADD, MATH2, VSEQOUTSZ, CAAM_CMD_SZ, 0);
-
-	/*
-	 * MOVE_LEN opcode is not available in all SEC HW revisions,
-	 * thus need to do some magic, i.e. self-patch the descriptor
-	 * buffer.
-	 */
-	pread_move_cmd = MOVE(p, DESCBUF, 0, MATH2, 0, 6, IMMED);
-	pwrite_move_cmd = MOVE(p, MATH2, 0, DESCBUF, 0, 8, WAITCOMP | IMMED);
-
-	/* Read and write cryptlen bytes */
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-	SEQFIFOLOAD(p, MSGINSNOOP, 0, VLF | LAST1 | LAST2 | FLUSH1);
-
-	/*
-	 * Insert a NOP here, since we need at least 4 instructions between
-	 * code patching the descriptor buffer and the location being patched.
-	 */
-	pnop_cmd = JUMP(p, nop_cmd, LOCAL_JUMP, ALL_TRUE, 0);
-	SET_LABEL(p, nop_cmd);
-
-	SET_LABEL(p, read_move_cmd);
-	SET_LABEL(p, write_move_cmd);
-	LOAD(p, 0, DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, IMMED);
-	MOVE(p, IFIFOAB1, 0, OFIFO, 0, 0, IMMED);
-	LOAD(p, 0, DCTRL, LDOFF_ENABLE_AUTO_NFIFO, 0, IMMED);
-
-	/* Load ICV */
-	SEQFIFOLOAD(p, ICV2, ctx->authsize, LAST2);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-	PATCH_JUMP(p, pnop_cmd, nop_cmd);
-	PATCH_MOVE(p, pread_move_cmd, read_move_cmd);
-	PATCH_MOVE(p, pwrite_move_cmd, write_move_cmd);
-
-	PROGRAM_FINALIZE(p);
-
+	cnstr_shdsc_aead_null_decap(desc, ps, &authdata, ctx->authsize);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
@@ -329,18 +187,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	struct aead_tfm *tfm = &aead->base.crt_aead;
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	bool keys_fit_inline = false;
-	u32 geniv, moveiv;
 	u32 *desc;
-	struct program prg;
-	struct program *p = &prg;
 	unsigned desc_bytes;
-	LABEL(skip_key_load);
-	REFERENCE(pskip_key_load);
-	LABEL(set_dk);
-	REFERENCE(pset_dk);
-	LABEL(skip_dk);
-	REFERENCE(pskip_dk);
+	struct alginfo cipherdata, authdata;
+	int rem_bytes;
 
 	if (!ctx->authsize)
 		return 0;
@@ -349,81 +199,34 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (!ctx->enckeylen)
 		return aead_null_set_sh_desc(aead);
 
+	cipherdata.algtype = ctx->class1_alg_type;
+	cipherdata.key_enc_flags = 0;
+	cipherdata.keylen = ctx->enckeylen;
+	authdata.algtype = ctx->class2_alg_type;
+	authdata.key_enc_flags = ENC;
+	authdata.keylen = ctx->split_key_len;
+
+	rem_bytes = CAAM_DESC_BYTES_MAX - (DESC_JOB_IO_LEN +
+		    ctx->split_key_pad_len + ctx->enckeylen);
+
 	/*
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
-	if (DESC_AEAD_ENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
-	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
-
-	/* aead_encrypt shared descriptor */
-	desc = ctx->sh_desc_enc;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip key loading if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	if (keys_fit_inline) {
-		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-		    ctx->split_key_len, IMMED | COPY);
-		KEY(p, KEY1, 0, (uintptr_t)(ctx->key + ctx->split_key_pad_len),
-		    ctx->enckeylen, IMMED | COPY);
+	if (rem_bytes >= DESC_AEAD_ENC_LEN) {
+		authdata.key = (uintptr_t)ctx->key;
+		authdata.key_type = RTA_DATA_IMM;
 	} else {
-		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
-		    0);
-		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
-		    ctx->enckeylen, 0);
+		authdata.key = ctx->key_dma;
+		authdata.key_type = RTA_DATA_PTR;
 	}
+	cipherdata.key = authdata.key + ctx->split_key_pad_len;
+	cipherdata.key_type = authdata.key_type;
 
-	SET_LABEL(p, skip_key_load);
-
-	/* Class 2 operation */
-	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* cryptlen = seqoutlen - authsize */
-	MATHB(p, SEQOUTSZ, SUB, ctx->authsize, MATH3, CAAM_CMD_SZ, IMMED2);
-
-	/* assoclen + cryptlen = seqinlen - ivsize */
-	MATHB(p, SEQINSZ, SUB, tfm->ivsize, MATH2, CAAM_CMD_SZ, IMMED2);
-
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	MATHB(p, MATH2, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* read assoc before reading payload */
-	SEQFIFOLOAD(p, MSG2, 0 , VLF);
-
-	/* read iv for both classes */
-	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
-	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, tfm->ivsize, IMMED);
-
-	/* Class 1 operation */
-	ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* Read and write cryptlen bytes */
-	MATHB(p, ZERO, ADD, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
-	MATHB(p, ZERO, ADD, MATH3, VSEQOUTSZ, CAAM_CMD_SZ, 0);
-
-	/* Read and write payload */
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-	SEQFIFOLOAD(p, MSGOUTSNOOP, 0, VLF | LAST1 | LAST2);
-
-	/* Write ICV */
-	SEQSTORE(p, CONTEXT2, 0, ctx->authsize, 0);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-
-	PROGRAM_FINALIZE(p);
-
+	/* aead_encrypt shared descriptor */
+	desc = ctx->sh_desc_enc;
+	cnstr_shdsc_aead_encap(desc, ps, &cipherdata, &authdata, tfm->ivsize,
+			       ctx->authsize);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
@@ -440,93 +243,20 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
-	keys_fit_inline = false;
-	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
-	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
-
-	/* aead_decrypt shared descriptor */
-	desc = ctx->sh_desc_dec;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	/* aead_decrypt shared descriptor */
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip key loading if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	if (keys_fit_inline) {
-		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-		    ctx->split_key_len, IMMED | COPY);
-		KEY(p, KEY1, 0, (uintptr_t)(ctx->key + ctx->split_key_pad_len),
-		    ctx->enckeylen, IMMED | COPY);
+	if (rem_bytes >= DESC_AEAD_DEC_LEN) {
+		authdata.key = (uintptr_t)ctx->key;
+		authdata.key_type = RTA_DATA_IMM;
 	} else {
-		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
-		    0);
-		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
-		    ctx->enckeylen, 0);
+		authdata.key = ctx->key_dma;
+		authdata.key_type = RTA_DATA_PTR;
 	}
+	cipherdata.key = authdata.key + ctx->split_key_pad_len;
+	cipherdata.key_type = authdata.key_type;
 
-	SET_LABEL(p, skip_key_load);
-
-	/* Class 2 operation */
-	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_ENABLE, DIR_DEC);
-
-	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
-	MATHB(p, SEQINSZ, SUB, ctx->authsize + tfm->ivsize, MATH3, CAAM_CMD_SZ,
-	      IMMED2);
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	MATHB(p, SEQOUTSZ, SUB, MATH0, MATH2, CAAM_CMD_SZ, 0);
-	MATHB(p, MATH3, SUB, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* read assoc before reading payload */
-	SEQFIFOLOAD(p, MSG2, 0 , VLF);
-
-	/* read iv for both classes */
-	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
-	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, tfm->ivsize, IMMED);
-
-	/* Set DK bit in class 1 operation if shared (AES only) */
-	if ((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
-		pset_dk = JUMP(p, set_dk, LOCAL_JUMP, ALL_TRUE, SHRD);
-		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
-		pskip_dk = JUMP(p, skip_dk, LOCAL_JUMP, ALL_TRUE, 0);
-		SET_LABEL(p, set_dk);
-		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-			      (ctx->class1_alg_type & OP_ALG_AAI_MASK) |
-			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
-			      ICV_CHECK_DISABLE, DIR_DEC);
-		SET_LABEL(p, skip_dk);
-	} else {
-		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
-	}
-
-	/* Read and write cryptlen bytes */
-	MATHB(p, ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
-	MATHB(p, ZERO, ADD, MATH2, VSEQOUTSZ, CAAM_CMD_SZ, 0);
-
-	/* Read and write payload */
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-	SEQFIFOLOAD(p, MSGINSNOOP, 0, VLF | LAST1 | LAST2);
-
-	/* Load ICV */
-	SEQFIFOLOAD(p, ICV2, ctx->authsize, LAST2);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-	PATCH_JUMP(p, pset_dk, set_dk);
-	PATCH_JUMP(p, pskip_dk, skip_dk);
-
-	PROGRAM_FINALIZE(p);
-
+	/* aead_decrypt shared descriptor */
+	desc = ctx->sh_desc_dec;
+	cnstr_shdsc_aead_decap(desc, ps, &cipherdata, &authdata, tfm->ivsize,
+			       ctx->authsize);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
@@ -543,95 +273,20 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
-	keys_fit_inline = false;
-	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
-	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
-
-	/* aead_givencrypt shared descriptor */
-	desc = ctx->sh_desc_givenc;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip key loading if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	if (keys_fit_inline) {
-		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-		    ctx->split_key_len, IMMED | COPY);
-		KEY(p, KEY1, 0,
-		    (uintptr_t)(ctx->key + ctx->split_key_pad_len),
-		    ctx->enckeylen, IMMED | COPY);
+	if (rem_bytes >= DESC_AEAD_GIVENC_LEN) {
+		authdata.key = (uintptr_t)ctx->key;
+		authdata.key_type = RTA_DATA_IMM;
 	} else {
-		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
-		    0);
-		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
-		    ctx->enckeylen, 0);
+		authdata.key = ctx->key_dma;
+		authdata.key_type = RTA_DATA_PTR;
 	}
+	cipherdata.key = authdata.key + ctx->split_key_pad_len;
+	cipherdata.key_type = authdata.key_type;
 
-	SET_LABEL(p, skip_key_load);
-
-	/* Generate IV */
-	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
-		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
-	LOAD(p, geniv, NFIFO, 0, CAAM_CMD_SZ, IMMED);
-	LOAD(p, 0, DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, IMMED);
-	MOVE(p, IFIFOABD, 0, CONTEXT1, 0, tfm->ivsize, IMMED);
-	LOAD(p, 0, DCTRL, LDOFF_ENABLE_AUTO_NFIFO, 0, IMMED);
-
-	/* Copy IV to class 1 context */
-	MOVE(p, CONTEXT1, 0, OFIFO, 0, tfm->ivsize, IMMED);
-
-	/* Return to encryption */
-	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* ivsize + cryptlen = seqoutlen - authsize */
-	MATHB(p, SEQOUTSZ, SUB, ctx->authsize, MATH3, CAAM_CMD_SZ, IMMED2);
-
-	/* assoclen = seqinlen - (ivsize + cryptlen) */
-	MATHB(p, SEQINSZ, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* read assoc before reading payload */
-	SEQFIFOLOAD(p, MSG2, 0, VLF);
-
-	/* Copy iv from class 1 ctx to class 2 fifo*/
-	moveiv = NFIFOENTRY_STYPE_OFIFO | NFIFOENTRY_DEST_CLASS2 |
-		 NFIFOENTRY_DTYPE_MSG | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
-	LOAD(p, moveiv, NFIFO, 0, CAAM_CMD_SZ, IMMED);
-	LOAD(p, tfm->ivsize, DATA2SZ, 0, CAAM_CMD_SZ, IMMED);
-
-	/* Class 1 operation */
-	ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* Will write ivsize + cryptlen */
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, CAAM_CMD_SZ, 0);
-
-	/* Not need to reload iv */
-	SEQFIFOLOAD(p, SKIP, tfm->ivsize, 0);
-
-	/* Will read cryptlen */
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* Read and write payload */
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-	SEQFIFOLOAD(p, MSGOUTSNOOP, 0, VLF | LAST1 | LAST2);
-
-	/* Write ICV */
-	SEQSTORE(p, CONTEXT2, 0, ctx->authsize, 0);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-
-	PROGRAM_FINALIZE(p);
-
+	/* aead_givencrypt shared descriptor */
+	desc = ctx->sh_desc_givenc;
+	cnstr_shdsc_aead_givencap(desc, ps, &cipherdata, &authdata, tfm->ivsize,
+				  ctx->authsize);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc, desc_bytes,
 						 DMA_TO_DEVICE);
@@ -737,15 +392,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	struct device *jrdev = ctx->jrdev;
 	int ret = 0;
 	u32 *desc;
-	struct program prg;
-	struct program *p = &prg;
 	unsigned desc_bytes;
-	LABEL(skip_key_load);
-	REFERENCE(pskip_key_load);
-	LABEL(set_dk);
-	REFERENCE(pset_dk);
-	LABEL(skip_dk);
-	REFERENCE(pskip_dk);
+	struct alginfo cipherdata;
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
@@ -753,48 +401,18 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 #endif
 
 	memcpy(ctx->key, key, keylen);
-	ctx->key_dma = dma_map_single(jrdev, ctx->key, keylen,
-				      DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->key_dma)) {
-		dev_err(jrdev, "unable to map key i/o memory\n");
-		return -ENOMEM;
-	}
 	ctx->enckeylen = keylen;
 
+	cipherdata.algtype = ctx->class1_alg_type & OP_ALG_ALGSEL_MASK;
+	cipherdata.key_enc_flags = 0;
+	cipherdata.keylen = ctx->enckeylen;
+	cipherdata.key = (uintptr_t)ctx->key;
+	cipherdata.key_type = RTA_DATA_IMM;
+
 	/* ablkcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip key loading if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	/* Load class1 key only */
-	KEY(p, KEY1, 0, (uintptr_t)ctx->key, ctx->enckeylen, IMMED | COPY);
-
-	SET_LABEL(p, skip_key_load);
-
-	/* Load IV */
-	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
-
-	/* Load operation */
-	ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* Perform operation */
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
-	SEQFIFOLOAD(p, MSG1, 0, VLF | LAST1);
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-
-	PROGRAM_FINALIZE(p);
-
+	cnstr_shdsc_cbc_blkcipher(desc, ps, &cipherdata, NULL, tfm->ivsize,
+				  DIR_ENC);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
@@ -810,54 +428,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* ablkcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip key loading if already shared */
-	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	/* Load class1 key only */
-	KEY(p, KEY1, 0, (uintptr_t)ctx->key, ctx->enckeylen, IMMED | COPY);
-
-	SET_LABEL(p, skip_key_load);
-
-	/* load IV */
-	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
-
-	/* Set DK bit in class 1 operation if shared (AES only) */
-	if ((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
-		pset_dk = JUMP(p, set_dk, LOCAL_JUMP, ALL_TRUE, SHRD);
-		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
-		pskip_dk = JUMP(p, skip_dk, LOCAL_JUMP, ALL_TRUE, 0);
-		SET_LABEL(p, set_dk);
-		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-			      (ctx->class1_alg_type & OP_ALG_AAI_MASK) |
-			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
-			      ICV_CHECK_DISABLE, DIR_DEC);
-		SET_LABEL(p, skip_dk);
-	} else {
-		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
-			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
-			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
-	}
-
-	/* Perform operation */
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
-	SEQFIFOLOAD(p, MSG1, 0, VLF | LAST1);
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-
-	PATCH_JUMP(p, pskip_key_load, skip_key_load);
-	PATCH_JUMP(p, pset_dk, set_dk);
-	PATCH_JUMP(p, pskip_dk, skip_dk);
-
-	PROGRAM_FINALIZE(p);
-
+	cnstr_shdsc_cbc_blkcipher(desc, ps, &cipherdata, NULL, tfm->ivsize,
+				  DIR_DEC);
 	desc_bytes = DESC_BYTES(desc);
 	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/flib/desc/algo.h b/drivers/crypto/caam/flib/desc/algo.h
new file mode 100644
index 000000000000..652d7f55f5e6
--- /dev/null
+++ b/drivers/crypto/caam/flib/desc/algo.h
@@ -0,0 +1,88 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __DESC_ALGO_H__
+#define __DESC_ALGO_H__
+
+#include "flib/rta.h"
+#include "common.h"
+
+/**
+ * DOC: Algorithms - Shared Descriptor Constructors
+ *
+ * Shared descriptors for algorithms (i.e. not for protocols).
+ */
+
+/**
+ * cnstr_shdsc_cbc_blkcipher - CBC block cipher
+ * @descbuf: pointer to descriptor-under-construction buffer
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @cipherdata: pointer to block cipher transform definitions
+ * @iv: IV data; if NULL, "ivlen" bytes from the input frame will be read as IV
+ * @ivlen: IV length
+ * @dir: DIR_ENCRYPT/DIR_DECRYPT
+ *
+ * Return: size of descriptor written in words
+ */
+static inline int cnstr_shdsc_cbc_blkcipher(uint32_t *descbuf, bool ps,
+			       struct alginfo *cipherdata, uint8_t *iv,
+			       uint32_t ivlen, uint8_t dir)
+{
+	struct program prg;
+	struct program *p = &prg;
+	const bool is_aes_dec = (dir == DIR_DEC) &&
+				(cipherdata->algtype == OP_ALG_ALGSEL_AES);
+	LABEL(keyjmp);
+	LABEL(skipdk);
+	REFERENCE(pkeyjmp);
+	REFERENCE(pskipdk);
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	SHR_HDR(p, SHR_SERIAL, 1, SC);
+
+	pkeyjmp = JUMP(p, keyjmp, LOCAL_JUMP, ALL_TRUE, SHRD);
+	/* Insert Key */
+	KEY(p, KEY1, cipherdata->key_enc_flags, cipherdata->key,
+	    cipherdata->keylen, INLINE_KEY(cipherdata));
+
+	if (is_aes_dec) {
+		ALG_OPERATION(p, cipherdata->algtype, OP_ALG_AAI_CBC,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, dir);
+
+		pskipdk = JUMP(p, skipdk, LOCAL_JUMP, ALL_TRUE, 0);
+	}
+	SET_LABEL(p, keyjmp);
+
+	if (is_aes_dec) {
+		ALG_OPERATION(p, OP_ALG_ALGSEL_AES, OP_ALG_AAI_CBC |
+			      OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
+			      ICV_CHECK_DISABLE, dir);
+		SET_LABEL(p, skipdk);
+	} else {
+		ALG_OPERATION(p, cipherdata->algtype, OP_ALG_AAI_CBC,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, dir);
+	}
+
+	if (iv)
+		/* IV load, convert size */
+		LOAD(p, (uintptr_t)iv, CONTEXT1, 0, ivlen, IMMED | COPY);
+	else
+		/* IV is present first before the actual message */
+		SEQLOAD(p, CONTEXT1, 0, ivlen, 0);
+
+	MATHB(p, SEQINSZ, SUB, MATH2, VSEQINSZ, 4, 0);
+	MATHB(p, SEQINSZ, SUB, MATH2, VSEQOUTSZ, 4, 0);
+
+	/* Insert sequence load/store with VLF */
+	SEQFIFOLOAD(p, MSG1, 0, VLF | LAST1);
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
+
+	PATCH_JUMP(p, pkeyjmp, keyjmp);
+	if (is_aes_dec)
+		PATCH_JUMP(p, pskipdk, skipdk);
+
+	return PROGRAM_FINALIZE(p);
+}
+
+#endif /* __DESC_ALGO_H__ */
diff --git a/drivers/crypto/caam/flib/desc/ipsec.h b/drivers/crypto/caam/flib/desc/ipsec.h
new file mode 100644
index 000000000000..b5436133d26c
--- /dev/null
+++ b/drivers/crypto/caam/flib/desc/ipsec.h
@@ -0,0 +1,550 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __DESC_IPSEC_H__
+#define __DESC_IPSEC_H__
+
+#include "flib/rta.h"
+#include "common.h"
+
+/**
+ * DOC: IPsec Shared Descriptor Constructors
+ *
+ * Shared descriptors for IPsec protocol.
+ */
+
+#define DESC_AEAD_BASE		(4 * CAAM_CMD_SZ)
+
+/**
+ * DESC_AEAD_ENC_LEN - Length of descriptor built by cnstr_shdsc_aead_encap().
+ *
+ * Does not account for the key lengths. It is intended to be used by upper
+ * layers to determine whether keys can be inlined or not.
+ */
+#define DESC_AEAD_ENC_LEN	(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
+
+/**
+ * cnstr_shdsc_aead_encap - IPSec ESP encapsulation shared descriptor
+ *                          (non-protocol).
+ * @descbuf: pointer to buffer used for descriptor construction
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @cipherdata: pointer to block cipher transform definitions
+ *              Valid algorithm values - one of OP_ALG_ALGSEL_{AES, DES, 3DES}
+ *              ANDed with OP_ALG_AAI_CBC.
+ * @authdata: pointer to authentication transform definitions. Note that since a
+ *            split key is to be used, the size of the split key itself is
+ *            specified. Valid algorithm values - one of OP_ALG_ALGSEL_{MD5,
+ *            SHA1, SHA224, SHA256, SHA384, SHA512} ANDed with
+ *            OP_ALG_AAI_HMAC_PRECOMP.
+ * @ivsize: initialization vector size
+ * @icvsize: integrity check value (ICV) size (truncated or full)
+ *
+ * Note: Requires an MDHA split key.
+ *
+ * Return: size of descriptor written in words
+ */
+static inline int cnstr_shdsc_aead_encap(uint32_t *descbuf, bool ps,
+					 struct alginfo *cipherdata,
+					 struct alginfo *authdata,
+					 unsigned int ivsize,
+					 unsigned int icvsize)
+{
+	struct program prg;
+	struct program *p = &prg;
+
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+	KEY(p, MDHA_SPLIT_KEY, authdata->key_enc_flags, authdata->key,
+	    authdata->keylen, INLINE_KEY(authdata));
+	KEY(p, KEY1, cipherdata->key_enc_flags, cipherdata->key,
+	    cipherdata->keylen, INLINE_KEY(cipherdata));
+	SET_LABEL(p, skip_key_load);
+
+	/* Class 2 operation */
+	ALG_OPERATION(p, authdata->algtype & OP_ALG_ALGSEL_MASK,
+		      authdata->algtype & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
+		      ICV_CHECK_DISABLE, DIR_ENC);
+
+	/* cryptlen = seqoutlen - authsize */
+	MATHB(p, SEQOUTSZ, SUB, icvsize, MATH3, CAAM_CMD_SZ, IMMED2);
+
+	/* assoclen + cryptlen = seqinlen - ivsize */
+	MATHB(p, SEQINSZ, SUB, ivsize, MATH2, CAAM_CMD_SZ, IMMED2);
+
+	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	MATHB(p, MATH2, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* read assoc before reading payload */
+	SEQFIFOLOAD(p, MSG2, 0 , VLF);
+
+	/* read iv for both classes */
+	SEQLOAD(p, CONTEXT1, 0, ivsize, 0);
+	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, ivsize, IMMED);
+
+	/* Class 1 operation */
+	ALG_OPERATION(p, cipherdata->algtype & OP_ALG_ALGSEL_MASK,
+		      cipherdata->algtype & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
+
+	/* Read and write cryptlen bytes */
+	MATHB(p, ZERO, ADD, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(p, ZERO, ADD, MATH3, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/* Read and write payload */
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
+	SEQFIFOLOAD(p, MSGOUTSNOOP, 0, VLF | LAST1 | LAST2);
+
+	/* Write ICV */
+	SEQSTORE(p, CONTEXT2, 0, icvsize, 0);
+
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+
+	return PROGRAM_FINALIZE(p);
+}
+
+/**
+ * DESC_AEAD_GIVENC_LEN - Length of descriptor built by
+ *                        cnstr_shdsc_aead_givencap().
+ *
+ * Does not account for the key lengths. It is intended to be used by upper
+ * layers to determine whether keys can be inlined or not.
+ */
+#define DESC_AEAD_GIVENC_LEN	(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
+
+/**
+ * cnstr_shdsc_aead_givencap - IPSec ESP encapsulation shared descriptor
+ *                             (non-protocol) with HW-generated initialization
+ *                             vector.
+ * @descbuf: pointer to buffer used for descriptor construction
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @cipherdata: pointer to block cipher transform definitions
+ *              Valid algorithm values - one of OP_ALG_ALGSEL_{AES, DES, 3DES}
+ *              ANDed with OP_ALG_AAI_CBC.
+ * @authdata: pointer to authentication transform definitions. Note that since a
+ *            split key is to be used, the size of the split key itself is
+ *            specified. Valid algorithm values - one of OP_ALG_ALGSEL_{MD5,
+ *            SHA1, SHA224, SHA256, SHA384, SHA512} ANDed with
+ *            OP_ALG_AAI_HMAC_PRECOMP.
+ * @ivsize: initialization vector size
+ * @icvsize: integrity check value (ICV) size (truncated or full)
+ *
+ * Note: Requires an MDHA split key.
+ *
+ * Return: size of descriptor written in words
+ */
+static inline int cnstr_shdsc_aead_givencap(uint32_t *descbuf, bool ps,
+					    struct alginfo *cipherdata,
+					    struct alginfo *authdata,
+					    unsigned int ivsize,
+					    unsigned int icvsize)
+{
+	struct program prg;
+	struct program *p = &prg;
+	uint32_t geniv, moveiv;
+
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+	KEY(p, MDHA_SPLIT_KEY, authdata->key_enc_flags, authdata->key,
+	    authdata->keylen, INLINE_KEY(authdata));
+	KEY(p, KEY1, cipherdata->key_enc_flags, cipherdata->key,
+	    cipherdata->keylen, INLINE_KEY(cipherdata));
+	SET_LABEL(p, skip_key_load);
+
+	/* Generate IV */
+	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
+		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
+		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
+	LOAD(p, geniv, NFIFO, 0, CAAM_CMD_SZ, IMMED);
+	LOAD(p, 0, DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, IMMED);
+	MOVE(p, IFIFOABD, 0, CONTEXT1, 0, ivsize, IMMED);
+	LOAD(p, 0, DCTRL, LDOFF_ENABLE_AUTO_NFIFO, 0, IMMED);
+
+	/* Copy IV to class 1 context */
+	MOVE(p, CONTEXT1, 0, OFIFO, 0, ivsize, IMMED);
+
+	/* Return to encryption */
+	ALG_OPERATION(p, authdata->algtype & OP_ALG_ALGSEL_MASK,
+		      authdata->algtype & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
+		      ICV_CHECK_DISABLE, DIR_ENC);
+
+	/* ivsize + cryptlen = seqoutlen - authsize */
+	MATHB(p, SEQOUTSZ, SUB, icvsize, MATH3, CAAM_CMD_SZ, IMMED2);
+
+	/* assoclen = seqinlen - (ivsize + cryptlen) */
+	MATHB(p, SEQINSZ, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* read assoc before reading payload */
+	SEQFIFOLOAD(p, MSG2, 0, VLF);
+
+	/* Copy iv from class 1 ctx to class 2 fifo*/
+	moveiv = NFIFOENTRY_STYPE_OFIFO | NFIFOENTRY_DEST_CLASS2 |
+		 NFIFOENTRY_DTYPE_MSG | (ivsize << NFIFOENTRY_DLEN_SHIFT);
+	LOAD(p, moveiv, NFIFO, 0, CAAM_CMD_SZ, IMMED);
+	LOAD(p, ivsize, DATA2SZ, 0, CAAM_CMD_SZ, IMMED);
+
+	/* Class 1 operation */
+	ALG_OPERATION(p, cipherdata->algtype & OP_ALG_ALGSEL_MASK,
+		      cipherdata->algtype & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
+
+	/* Will write ivsize + cryptlen */
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/* Not need to reload iv */
+	SEQFIFOLOAD(p, SKIP, ivsize, 0);
+
+	/* Will read cryptlen */
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* Read and write payload */
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
+	SEQFIFOLOAD(p, MSGOUTSNOOP, 0, VLF | LAST1 | LAST2);
+
+	/* Write ICV */
+	SEQSTORE(p, CONTEXT2, 0, icvsize, 0);
+
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+
+	return PROGRAM_FINALIZE(p);
+}
+
+/**
+ * DESC_AEAD_DEC_LEN - Length of descriptor built by cnstr_shdsc_aead_decap().
+ *
+ * Does not account for the key lengths. It is intended to be used by upper
+ * layers to determine whether keys can be inlined or not.
+ */
+#define DESC_AEAD_DEC_LEN	(DESC_AEAD_BASE + 18 * CAAM_CMD_SZ)
+
+/**
+ * cnstr_shdsc_aead_decap - IPSec ESP decapsulation shared descriptor
+ *                          (non-protocol).
+ * @descbuf: pointer to buffer used for descriptor construction
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @cipherdata: pointer to block cipher transform definitions
+ *              Valid algorithm values - one of OP_ALG_ALGSEL_{AES, DES, 3DES}
+ *              ANDed with OP_ALG_AAI_CBC.
+ * @authdata: pointer to authentication transform definitions. Note that since a
+ *            split key is to be used, the size of the split key itself is
+ *            specified. Valid algorithm values - one of OP_ALG_ALGSEL_{MD5,
+ *            SHA1, SHA224, SHA256, SHA384, SHA512} ANDed with
+ *            OP_ALG_AAI_HMAC_PRECOMP.
+ * @ivsize: initialization vector size
+ * @icvsize: integrity check value (ICV) size (truncated or full)
+ *
+ * Note: Requires an MDHA split key.
+ *
+ * Return: size of descriptor written in words
+ */
+static inline int cnstr_shdsc_aead_decap(uint32_t *descbuf, bool ps,
+					 struct alginfo *cipherdata,
+					 struct alginfo *authdata,
+					 unsigned int ivsize,
+					 unsigned int icvsize)
+{
+	struct program prg;
+	struct program *p = &prg;
+
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(set_dk);
+	REFERENCE(pset_dk);
+	LABEL(skip_dk);
+	REFERENCE(pskip_dk);
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+
+	/* aead_decrypt shared descriptor */
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+	KEY(p, MDHA_SPLIT_KEY, authdata->key_enc_flags, authdata->key,
+	    authdata->keylen, INLINE_KEY(authdata));
+	KEY(p, KEY1, cipherdata->key_enc_flags, cipherdata->key,
+	    cipherdata->keylen, INLINE_KEY(cipherdata));
+	SET_LABEL(p, skip_key_load);
+
+	/* Class 2 operation */
+	ALG_OPERATION(p, authdata->algtype & OP_ALG_ALGSEL_MASK,
+		      authdata->algtype & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
+		      ICV_CHECK_ENABLE, DIR_DEC);
+
+	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
+	MATHB(p, SEQINSZ, SUB, icvsize + ivsize, MATH3, CAAM_CMD_SZ, IMMED2);
+	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	MATHB(p, SEQOUTSZ, SUB, MATH0, MATH2, CAAM_CMD_SZ, 0);
+	MATHB(p, MATH3, SUB, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* read assoc before reading payload */
+	SEQFIFOLOAD(p, MSG2, 0 , VLF);
+
+	/* read iv for both classes */
+	SEQLOAD(p, CONTEXT1, 0, ivsize, 0);
+	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, ivsize, IMMED);
+
+	/* Set DK bit in class 1 operation if shared (AES only) */
+	if ((cipherdata->algtype & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
+		pset_dk = JUMP(p, set_dk, LOCAL_JUMP, ALL_TRUE, SHRD);
+		ALG_OPERATION(p, cipherdata->algtype & OP_ALG_ALGSEL_MASK,
+			      cipherdata->algtype & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      DIR_DEC);
+		pskip_dk = JUMP(p, skip_dk, LOCAL_JUMP, ALL_TRUE, 0);
+		SET_LABEL(p, set_dk);
+		ALG_OPERATION(p, cipherdata->algtype & OP_ALG_ALGSEL_MASK,
+			      (cipherdata->algtype & OP_ALG_AAI_MASK) |
+			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
+			      ICV_CHECK_DISABLE, DIR_DEC);
+		SET_LABEL(p, skip_dk);
+	} else {
+		ALG_OPERATION(p, cipherdata->algtype & OP_ALG_ALGSEL_MASK,
+			      cipherdata->algtype & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      DIR_DEC);
+	}
+
+	/* Read and write cryptlen bytes */
+	MATHB(p, ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(p, ZERO, ADD, MATH2, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/* Read and write payload */
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
+	SEQFIFOLOAD(p, MSGINSNOOP, 0, VLF | LAST1 | LAST2);
+
+	/* Load ICV */
+	SEQFIFOLOAD(p, ICV2, icvsize, LAST2);
+
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+	PATCH_JUMP(p, pset_dk, set_dk);
+	PATCH_JUMP(p, pskip_dk, skip_dk);
+
+	return PROGRAM_FINALIZE(p);
+}
+
+#define DESC_AEAD_NULL_BASE		(3 * CAAM_CMD_SZ)
+
+/**
+ * DESC_AEAD_NULL_ENC_LEN - Length of descriptor built by
+ *                          cnstr_shdsc_aead_null_encap().
+ *
+ * Does not account for the key lengths. It is intended to be used by upper
+ * layers to determine whether keys can be inlined or not.
+ */
+#define DESC_AEAD_NULL_ENC_LEN	(DESC_AEAD_NULL_BASE + 14 * CAAM_CMD_SZ)
+
+/**
+ * cnstr_shdsc_aead_null_encap - IPSec ESP encapsulation shared descriptor
+ *                               (non-protocol) with no (null) encryption.
+ * @descbuf: pointer to buffer used for descriptor construction
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @authdata: pointer to authentication transform definitions. Note that since a
+ *            split key is to be used, the size of the split key itself is
+ *            specified. Valid algorithm values - one of OP_ALG_ALGSEL_{MD5,
+ *            SHA1, SHA224, SHA256, SHA384, SHA512} ANDed with
+ *            OP_ALG_AAI_HMAC_PRECOMP.
+ * @icvsize: integrity check value (ICV) size (truncated or full)
+ *
+ * Note: Requires an MDHA split key.
+ *
+ * Return: size of descriptor written in words
+ */
+static inline int cnstr_shdsc_aead_null_encap(uint32_t *descbuf, bool ps,
+					      struct alginfo *authdata,
+					      unsigned int icvsize)
+{
+	struct program prg;
+	struct program *p = &prg;
+
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(read_move_cmd);
+	REFERENCE(pread_move_cmd);
+	LABEL(write_move_cmd);
+	REFERENCE(pwrite_move_cmd);
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+	KEY(p, MDHA_SPLIT_KEY, authdata->key_enc_flags, authdata->key,
+	    authdata->keylen, INLINE_KEY(authdata));
+	SET_LABEL(p, skip_key_load);
+
+	/* cryptlen = seqoutlen - authsize */
+	MATHB(p, SEQOUTSZ, SUB, icvsize, MATH3, CAAM_CMD_SZ, IMMED2);
+
+	/*
+	 * NULL encryption; IV is zero
+	 * assoclen = (assoclen + cryptlen) - cryptlen
+	 */
+	MATHB(p, SEQINSZ, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* read assoc before reading payload */
+	SEQFIFOLOAD(p, MSG2, 0 , VLF);
+
+	/* Prepare to read and write cryptlen bytes */
+	MATHB(p, ZERO, ADD, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(p, ZERO, ADD, MATH3, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/*
+	 * MOVE_LEN opcode is not available in all SEC HW revisions,
+	 * thus need to do some magic, i.e. self-patch the descriptor buffer.
+	 */
+	pread_move_cmd = MOVE(p, DESCBUF, 0, MATH3, 0, 6, IMMED);
+	pwrite_move_cmd = MOVE(p, MATH3, 0, DESCBUF, 0, 8, WAITCOMP | IMMED);
+
+	/* Class 2 operation */
+	ALG_OPERATION(p, authdata->algtype & OP_ALG_ALGSEL_MASK,
+		      authdata->algtype & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
+		      ICV_CHECK_DISABLE, DIR_ENC);
+
+	/* Read and write cryptlen bytes */
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
+	SEQFIFOLOAD(p, MSGINSNOOP, 0, VLF | LAST1 | LAST2 | FLUSH1);
+
+	SET_LABEL(p, read_move_cmd);
+	SET_LABEL(p, write_move_cmd);
+	LOAD(p, 0, DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, IMMED);
+	MOVE(p, IFIFOAB1, 0, OFIFO, 0, 0, IMMED);
+
+	/* Write ICV */
+	SEQSTORE(p, CONTEXT2, 0, icvsize, 0);
+
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+	PATCH_MOVE(p, pread_move_cmd, read_move_cmd);
+	PATCH_MOVE(p, pwrite_move_cmd, write_move_cmd);
+
+	return PROGRAM_FINALIZE(p);
+}
+
+/**
+ * DESC_AEAD_NULL_DEC_LEN - Length of descriptor built by
+ *                          cnstr_shdsc_aead_null_decap().
+ *
+ * Does not account for the key lengths. It is intended to be used by upper
+ * layers to determine whether keys can be inlined or not.
+ */
+#define DESC_AEAD_NULL_DEC_LEN	(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
+
+/**
+ * cnstr_shdsc_aead_null_decap - IPSec ESP decapsulation shared descriptor
+ *                               (non-protocol) with no (null) decryption.
+ * @descbuf: pointer to buffer used for descriptor construction
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @authdata: pointer to authentication transform definitions. Note that since a
+ *            split key is to be used, the size of the split key itself is
+ *            specified. Valid algorithm values - one of OP_ALG_ALGSEL_{MD5,
+ *            SHA1, SHA224, SHA256, SHA384, SHA512} ANDed with
+ *            OP_ALG_AAI_HMAC_PRECOMP.
+ * @icvsize: integrity check value (ICV) size (truncated or full)
+ *
+ * Note: Requires an MDHA split key.
+ *
+ * Return: size of descriptor written in words
+ */
+static inline int cnstr_shdsc_aead_null_decap(uint32_t *descbuf, bool ps,
+					      struct alginfo *authdata,
+					      unsigned int icvsize)
+{
+	struct program prg;
+	struct program *p = &prg;
+
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(nop_cmd);
+	REFERENCE(pnop_cmd);
+	LABEL(read_move_cmd);
+	REFERENCE(pread_move_cmd);
+	LABEL(write_move_cmd);
+	REFERENCE(pwrite_move_cmd);
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+	KEY(p, MDHA_SPLIT_KEY, authdata->key_enc_flags, authdata->key,
+	    authdata->keylen, INLINE_KEY(authdata));
+	SET_LABEL(p, skip_key_load);
+
+	/* Class 2 operation */
+	ALG_OPERATION(p, authdata->algtype & OP_ALG_ALGSEL_MASK,
+		      authdata->algtype & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
+		      ICV_CHECK_ENABLE, DIR_DEC);
+
+	/* assoclen + cryptlen = seqinlen - authsize */
+	MATHB(p, SEQINSZ, SUB, icvsize, MATH3, CAAM_CMD_SZ, IMMED2);
+	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	MATHB(p, SEQOUTSZ, SUB, MATH0, MATH2, CAAM_CMD_SZ, 0);
+	MATHB(p, MATH3, SUB, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* read assoc before reading payload */
+	SEQFIFOLOAD(p, MSG2, 0 , VLF);
+
+	/* Prepare to read and write cryptlen bytes */
+	MATHB(p, ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(p, ZERO, ADD, MATH2, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/*
+	 * MOVE_LEN opcode is not available in all SEC HW revisions,
+	 * thus need to do some magic, i.e. self-patch the descriptor buffer.
+	 */
+	pread_move_cmd = MOVE(p, DESCBUF, 0, MATH2, 0, 6, IMMED);
+	pwrite_move_cmd = MOVE(p, MATH2, 0, DESCBUF, 0, 8, WAITCOMP | IMMED);
+
+	/* Read and write cryptlen bytes */
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
+	SEQFIFOLOAD(p, MSGINSNOOP, 0, VLF | LAST1 | LAST2 | FLUSH1);
+
+	/*
+	 * Insert a NOP here, since we need at least 4 instructions between
+	 * code patching the descriptor buffer and the location being patched.
+	 */
+	pnop_cmd = JUMP(p, nop_cmd, LOCAL_JUMP, ALL_TRUE, 0);
+	SET_LABEL(p, nop_cmd);
+
+	SET_LABEL(p, read_move_cmd);
+	SET_LABEL(p, write_move_cmd);
+	LOAD(p, 0, DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, IMMED);
+	MOVE(p, IFIFOAB1, 0, OFIFO, 0, 0, IMMED);
+	LOAD(p, 0, DCTRL, LDOFF_ENABLE_AUTO_NFIFO, 0, IMMED);
+
+	/* Load ICV */
+	SEQFIFOLOAD(p, ICV2, icvsize, LAST2);
+
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+	PATCH_JUMP(p, pnop_cmd, nop_cmd);
+	PATCH_MOVE(p, pread_move_cmd, read_move_cmd);
+	PATCH_MOVE(p, pwrite_move_cmd, write_move_cmd);
+
+	return PROGRAM_FINALIZE(p);
+}
+
+#endif /* __DESC_IPSEC_H__ */
-- 
1.8.3.1
