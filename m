Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8025C2F3A6
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 13:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 992B42085A
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 13:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfAUNXv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:23:51 -0500
Received: from inva021.nxp.com ([92.121.34.21]:56072 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfAUNXu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 08:23:50 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1472C200392;
        Mon, 21 Jan 2019 14:23:47 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0737F20038E;
        Mon, 21 Jan 2019 14:23:47 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B1F362061D;
        Mon, 21 Jan 2019 14:23:46 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH] crypto: caam - add support for cmac(aes)
Date:   Mon, 21 Jan 2019 15:22:42 +0200
Message-Id: <20190121132242.22928-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Add cmac(aes) keyed hash offloading support.

Similar to xcbc implementation, driver must make sure there are still
some bytes buffered when ahash_final() is called. This way HW is able to
decide whether padding is needed and which key to derive (L -> K1 / K2)
for the last block.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c      | 132 ++++++++++++++++++++++++++++++------
 drivers/crypto/caam/caamhash_desc.c |  30 +++++---
 drivers/crypto/caam/caamhash_desc.h |  10 ++-
 3 files changed, 139 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 6c379bef938e..2eb8959e2fdc 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -3,7 +3,7 @@
  * caam - Freescale FSL CAAM support for ahash functions of crypto API
  *
  * Copyright 2011 Freescale Semiconductor, Inc.
- * Copyright 2018 NXP
+ * Copyright 2018-2019 NXP
  *
  * Based on caamalg.c crypto API driver.
  *
@@ -159,12 +159,11 @@ static inline int *alt_buflen(struct caam_hash_state *state)
 	return state->current_buf ? &state->buflen_0 : &state->buflen_1;
 }
 
-static inline bool is_xcbc_aes(u32 algtype)
+static inline bool is_cmac_aes(u32 algtype)
 {
 	return (algtype & (OP_ALG_ALGSEL_MASK | OP_ALG_AAI_MASK)) ==
-	       (OP_ALG_ALGSEL_AES | OP_ALG_AAI_XCBC_MAC);
+	       (OP_ALG_ALGSEL_AES | OP_ALG_AAI_CMAC);
 }
-
 /* Common job descriptor seq in/out ptr routines */
 
 /* Map state->caam_ctx, and append seq_out_ptr command that points to it */
@@ -311,8 +310,8 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* shared descriptor for ahash_update */
 	desc = ctx->sh_desc_update;
-	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_UPDATE, ctx->ctx_len,
-			  ctx->ctx_len, 0);
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_UPDATE,
+			    ctx->ctx_len, ctx->ctx_len, 0);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc update shdesc@" __stringify(__LINE__)" : ",
@@ -321,8 +320,8 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* shared descriptor for ahash_{final,finup} */
 	desc = ctx->sh_desc_fin;
-	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_FINALIZE, digestsize,
-			  ctx->ctx_len, 0);
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_FINALIZE,
+			    digestsize, ctx->ctx_len, 0);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc finup shdesc@" __stringify(__LINE__)" : ",
@@ -334,8 +333,8 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* shared descriptor for first invocation of ahash_update */
 	desc = ctx->sh_desc_update_first;
-	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
-			  ctx->ctx_len, ctx->key_dma);
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
+			    ctx->ctx_len, ctx->key_dma);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc update first shdesc@" __stringify(__LINE__)" : ",
@@ -344,13 +343,62 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* shared descriptor for ahash_digest */
 	desc = ctx->sh_desc_digest;
-	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_INITFINAL, digestsize,
-			  ctx->ctx_len, 0);
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INITFINAL,
+			    digestsize, ctx->ctx_len, 0);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc digest shdesc@" __stringify(__LINE__)" : ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
+	return 0;
+}
+
+static int acmac_set_sh_desc(struct crypto_ahash *ahash)
+{
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	int digestsize = crypto_ahash_digestsize(ahash);
+	struct device *jrdev = ctx->jrdev;
+	u32 *desc;
+
+	/* shared descriptor for ahash_update */
+	desc = ctx->sh_desc_update;
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_UPDATE,
+			    ctx->ctx_len, ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("acmac update shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
+
+	/* shared descriptor for ahash_{final,finup} */
+	desc = ctx->sh_desc_fin;
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_FINALIZE,
+			    digestsize, ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("acmac finup shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
+
+	/* shared descriptor for first invocation of ahash_update */
+	desc = ctx->sh_desc_update_first;
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
+			    ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("acmac update first shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
+
+	/* shared descriptor for ahash_digest */
+	desc = ctx->sh_desc_digest;
+	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INITFINAL,
+			    digestsize, ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("acmac digest shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
 
 	return 0;
 }
@@ -502,6 +550,22 @@ static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
 
 	return axcbc_set_sh_desc(ahash);
 }
+
+static int acmac_setkey(struct crypto_ahash *ahash, const u8 *key,
+			unsigned int keylen)
+{
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+
+	/* key is immediate data for all cmac shared descriptors */
+	ctx->adata.key_virt = key;
+	ctx->adata.keylen = keylen;
+
+	print_hex_dump_debug("acmac ctx.key@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
+
+	return acmac_set_sh_desc(ahash);
+}
+
 /*
  * ahash_edesc - s/w-extended ahash descriptor
  * @dst_dma: physical mapped address of req->result
@@ -779,11 +843,12 @@ static int ahash_update_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	/*
-	 * For XCBC, if to_hash is multiple of block size,
+	 * For XCBC and CMAC, if to_hash is multiple of block size,
 	 * keep last block in internal buffer
 	 */
-	if (is_xcbc_aes(ctx->adata.algtype) && to_hash >= blocksize &&
-	    (*next_buflen == 0)) {
+	if ((is_xcbc_aes(ctx->adata.algtype) ||
+	     is_cmac_aes(ctx->adata.algtype)) && to_hash >= blocksize &&
+	     (*next_buflen == 0)) {
 		*next_buflen = blocksize;
 		to_hash -= blocksize;
 	}
@@ -1224,11 +1289,12 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	/*
-	 * For XCBC, if to_hash is multiple of block size,
+	 * For XCBC and CMAC, if to_hash is multiple of block size,
 	 * keep last block in internal buffer
 	 */
-	if (is_xcbc_aes(ctx->adata.algtype) && to_hash >= blocksize &&
-	    (*next_buflen == 0)) {
+	if ((is_xcbc_aes(ctx->adata.algtype) ||
+	     is_cmac_aes(ctx->adata.algtype)) && to_hash >= blocksize &&
+	     (*next_buflen == 0)) {
 		*next_buflen = blocksize;
 		to_hash -= blocksize;
 	}
@@ -1448,11 +1514,12 @@ static int ahash_update_first(struct ahash_request *req)
 	to_hash = req->nbytes - *next_buflen;
 
 	/*
-	 * For XCBC, if to_hash is multiple of block size,
+	 * For XCBC and CMAC, if to_hash is multiple of block size,
 	 * keep last block in internal buffer
 	 */
-	if (is_xcbc_aes(ctx->adata.algtype) && to_hash >= blocksize &&
-	    (*next_buflen == 0)) {
+	if ((is_xcbc_aes(ctx->adata.algtype) ||
+	     is_cmac_aes(ctx->adata.algtype)) && to_hash >= blocksize &&
+	     (*next_buflen == 0)) {
 		*next_buflen = blocksize;
 		to_hash -= blocksize;
 	}
@@ -1783,6 +1850,25 @@ static struct caam_hash_template driver_hash[] = {
 			},
 		 },
 		.alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XCBC_MAC,
+	}, {
+		.hmac_name = "cmac(aes)",
+		.hmac_driver_name = "cmac-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_ahash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.export = ahash_export,
+			.import = ahash_import,
+			.setkey = acmac_setkey,
+			.halg = {
+				.digestsize = AES_BLOCK_SIZE,
+				.statesize = sizeof(struct caam_export_state),
+			},
+		 },
+		.alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CMAC,
 	},
 };
 
@@ -1839,6 +1925,10 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 			caam_jr_free(ctx->jrdev);
 			return -ENOMEM;
 		}
+	} else if (is_cmac_aes(caam_hash->alg_type)) {
+		ctx->dir = DMA_TO_DEVICE;
+		ctx->adata.algtype = OP_TYPE_CLASS1_ALG | caam_hash->alg_type;
+		ctx->ctx_len = 32;
 	} else {
 		ctx->dir = priv->era >= 6 ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
 		ctx->adata.algtype = OP_TYPE_CLASS2_ALG | caam_hash->alg_type;
diff --git a/drivers/crypto/caam/caamhash_desc.c b/drivers/crypto/caam/caamhash_desc.c
index 053d3a15ef3c..71d018343ee4 100644
--- a/drivers/crypto/caam/caamhash_desc.c
+++ b/drivers/crypto/caam/caamhash_desc.c
@@ -2,7 +2,7 @@
 /*
  * Shared descriptors for ahash algorithms
  *
- * Copyright 2017-2018 NXP
+ * Copyright 2017-2019 NXP
  */
 
 #include "compat.h"
@@ -76,7 +76,8 @@ void cnstr_shdsc_ahash(u32 * const desc, struct alginfo *adata, u32 state,
 EXPORT_SYMBOL(cnstr_shdsc_ahash);
 
 /**
- * cnstr_shdsc_axcbc - axcbc shared descriptor
+ * cnstr_shdsc_sk_hash - shared descriptor for symmetric key cipher-based
+ *                       hash algorithms
  * @desc: pointer to buffer used for descriptor construction
  * @adata: pointer to authentication transform definitions.
  * @state: algorithm state OP_ALG_AS_{INIT, FINALIZE, INITFINALIZE, UPDATE}
@@ -84,8 +85,8 @@ EXPORT_SYMBOL(cnstr_shdsc_ahash);
  * @ctx_len: size of Context Register
  * @key_dma: I/O Virtual Address of the key
  */
-void cnstr_shdsc_axcbc(u32 * const desc, struct alginfo *adata, u32 state,
-		       int digestsize, int ctx_len, dma_addr_t key_dma)
+void cnstr_shdsc_sk_hash(u32 * const desc, struct alginfo *adata, u32 state,
+			 int digestsize, int ctx_len, dma_addr_t key_dma)
 {
 	u32 *skip_key_load;
 
@@ -98,9 +99,14 @@ void cnstr_shdsc_axcbc(u32 * const desc, struct alginfo *adata, u32 state,
 		append_key_as_imm(desc, adata->key_virt, adata->keylen,
 				  adata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 	} else { /* UPDATE, FINALIZE */
-		/* Load K1 */
-		append_key(desc, adata->key_dma, adata->keylen,
-			   CLASS_1 | KEY_DEST_CLASS_REG | KEY_ENC);
+		if (is_xcbc_aes(adata->algtype))
+			/* Load K1 */
+			append_key(desc, adata->key_dma, adata->keylen,
+				   CLASS_1 | KEY_DEST_CLASS_REG | KEY_ENC);
+		else /* CMAC */
+			append_key_as_imm(desc, adata->key_virt, adata->keylen,
+					  adata->keylen, CLASS_1 |
+					  KEY_DEST_CLASS_REG);
 		/* Restore context */
 		append_seq_load(desc, ctx_len, LDST_CLASS_1_CCB |
 				LDST_SRCDST_BYTE_CONTEXT);
@@ -121,15 +127,19 @@ void cnstr_shdsc_axcbc(u32 * const desc, struct alginfo *adata, u32 state,
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_LAST1 |
 			     FIFOLD_TYPE_MSG | FIFOLDST_VLF);
 
-	/* Save context (partial hash, K2, K3) */
+	/*
+	 * Save context:
+	 * - xcbc: partial hash, keys K2 and K3
+	 * - cmac: partial hash, constant L = E(K,0)
+	 */
 	append_seq_store(desc, digestsize, LDST_CLASS_1_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
-	if (state == OP_ALG_AS_INIT)
+	if (is_xcbc_aes(adata->algtype) && state == OP_ALG_AS_INIT)
 		/* Save K1 */
 		append_fifo_store(desc, key_dma, adata->keylen,
 				  LDST_CLASS_1_CCB | FIFOST_TYPE_KEY_KEK);
 }
-EXPORT_SYMBOL(cnstr_shdsc_axcbc);
+EXPORT_SYMBOL(cnstr_shdsc_sk_hash);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL CAAM ahash descriptors support");
diff --git a/drivers/crypto/caam/caamhash_desc.h b/drivers/crypto/caam/caamhash_desc.h
index cf4a437d4c02..6947ee1f200c 100644
--- a/drivers/crypto/caam/caamhash_desc.h
+++ b/drivers/crypto/caam/caamhash_desc.h
@@ -15,9 +15,15 @@
 #define DESC_AHASH_FINAL_LEN		(DESC_AHASH_BASE + 5 * CAAM_CMD_SZ)
 #define DESC_AHASH_DIGEST_LEN		(DESC_AHASH_BASE + 4 * CAAM_CMD_SZ)
 
+static inline bool is_xcbc_aes(u32 algtype)
+{
+	return (algtype & (OP_ALG_ALGSEL_MASK | OP_ALG_AAI_MASK)) ==
+	       (OP_ALG_ALGSEL_AES | OP_ALG_AAI_XCBC_MAC);
+}
+
 void cnstr_shdsc_ahash(u32 * const desc, struct alginfo *adata, u32 state,
 		       int digestsize, int ctx_len, bool import_ctx, int era);
 
-void cnstr_shdsc_axcbc(u32 * const desc, struct alginfo *adata, u32 state,
-		       int digestsize, int ctx_len, dma_addr_t key_dma);
+void cnstr_shdsc_sk_hash(u32 * const desc, struct alginfo *adata, u32 state,
+			 int digestsize, int ctx_len, dma_addr_t key_dma);
 #endif /* _CAAMHASH_DESC_H_ */
-- 
2.16.2

