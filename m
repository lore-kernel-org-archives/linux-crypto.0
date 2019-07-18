Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300C9C76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03DA92184B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390754AbfGROpr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:45:47 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49544 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390689AbfGROpn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:45:43 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 869431A035F;
        Thu, 18 Jul 2019 16:45:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 78BE51A0006;
        Thu, 18 Jul 2019 16:45:40 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2A139205C7;
        Thu, 18 Jul 2019 16:45:40 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 10/14] crypto: caam - fix DKP for certain key lengths
Date:   Thu, 18 Jul 2019 17:45:20 +0300
Message-Id: <1563461124-24641-11-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
References: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

DKP cannot be used with immediate input key if |user key| > |derived key|,
since the resulting descriptor (after DKP execution) would be invalid -
having a few bytes from user key left in descriptor buffer
as incorrect opcodes.

Fix DKP usage both in standalone hmac and in authenc algorithms.
For authenc the logic is simplified, by always storing both virtual
and dma key addresses.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 42 +++++++----------------
 drivers/crypto/caam/caamalg_qi.c  | 42 +++++++----------------
 drivers/crypto/caam/caamalg_qi2.c | 70 ++++++++++++++++++++++++++++-----------
 drivers/crypto/caam/caamhash.c    | 54 +++++++++++++++++++++---------
 drivers/crypto/caam/desc_constr.h | 24 ++++++++++----
 5 files changed, 131 insertions(+), 101 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 9a7bb06..22d9fa0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -206,6 +206,18 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 				ctx->cdata.keylen - CTR_RFC3686_NONCE_SIZE);
 	}
 
+	/*
+	 * In case |user key| > |derived key|, using DKP<imm,imm>
+	 * would result in invalid opcodes (last bytes of user key) in
+	 * the resulting descriptor. Use DKP<ptr,imm> instead => both
+	 * virtual and dma key addresses are needed.
+	 */
+	ctx->adata.key_virt = ctx->key;
+	ctx->adata.key_dma = ctx->key_dma;
+
+	ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
+	ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
+
 	data_len[0] = ctx->adata.keylen_pad;
 	data_len[1] = ctx->cdata.keylen;
 
@@ -222,16 +234,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
@@ -254,16 +256,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
@@ -288,16 +280,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index b2dd4f3..c7cebd6 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -106,6 +106,18 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 				ctx->cdata.keylen - CTR_RFC3686_NONCE_SIZE);
 	}
 
+	/*
+	 * In case |user key| > |derived key|, using DKP<imm,imm> would result
+	 * in invalid opcodes (last bytes of user key) in the resulting
+	 * descriptor. Use DKP<ptr,imm> instead => both virtual and dma key
+	 * addresses are needed.
+	 */
+	ctx->adata.key_virt = ctx->key;
+	ctx->adata.key_dma = ctx->key_dma;
+
+	ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
+	ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
+
 	data_len[0] = ctx->adata.keylen_pad;
 	data_len[1] = ctx->cdata.keylen;
 
@@ -119,16 +131,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
@@ -144,16 +146,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
@@ -172,16 +164,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 285e3c9..6541b10 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -199,6 +199,18 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 				ctx->cdata.keylen - CTR_RFC3686_NONCE_SIZE);
 	}
 
+	/*
+	 * In case |user key| > |derived key|, using DKP<imm,imm> would result
+	 * in invalid opcodes (last bytes of user key) in the resulting
+	 * descriptor. Use DKP<ptr,imm> instead => both virtual and dma key
+	 * addresses are needed.
+	 */
+	ctx->adata.key_virt = ctx->key;
+	ctx->adata.key_dma = ctx->key_dma;
+
+	ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
+	ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
+
 	data_len[0] = ctx->adata.keylen_pad;
 	data_len[1] = ctx->cdata.keylen;
 
@@ -210,16 +222,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
@@ -248,16 +250,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			      ARRAY_SIZE(data_len)) < 0)
 		return -EINVAL;
 
-	if (inl_mask & 1)
-		ctx->adata.key_virt = ctx->key;
-	else
-		ctx->adata.key_dma = ctx->key_dma;
-
-	if (inl_mask & 2)
-		ctx->cdata.key_virt = ctx->key + ctx->adata.keylen_pad;
-	else
-		ctx->cdata.key_dma = ctx->key_dma + ctx->adata.keylen_pad;
-
 	ctx->adata.key_inline = !!(inl_mask & 1);
 	ctx->cdata.key_inline = !!(inl_mask & 2);
 
@@ -2999,14 +2991,18 @@ enum hash_optype {
 /**
  * caam_hash_ctx - ahash per-session context
  * @flc: Flow Contexts array
+ * @key: authentication key
  * @flc_dma: I/O virtual addresses of the Flow Contexts
+ * @key_dma: I/O virtual address of the key
  * @dev: dpseci device
  * @ctx_len: size of Context Register
  * @adata: hashing algorithm details
  */
 struct caam_hash_ctx {
 	struct caam_flc flc[HASH_NUM_OP];
+	u8 key[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
 	dma_addr_t flc_dma[HASH_NUM_OP];
+	dma_addr_t key_dma;
 	struct device *dev;
 	int ctx_len;
 	struct alginfo adata;
@@ -3306,6 +3302,20 @@ static int ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	ctx->adata.key_virt = key;
 	ctx->adata.key_inline = true;
 
+	/*
+	 * In case |user key| > |derived key|, using DKP<imm,imm> would result
+	 * in invalid opcodes (last bytes of user key) in the resulting
+	 * descriptor. Use DKP<ptr,imm> instead => both virtual and dma key
+	 * addresses are needed.
+	 */
+	if (keylen > ctx->adata.keylen_pad) {
+		ctx->adata.key_dma = ctx->key_dma;
+		memcpy(ctx->key, key, keylen);
+		dma_sync_single_for_device(ctx->dev, ctx->key_dma,
+					   ctx->adata.keylen_pad,
+					   DMA_TO_DEVICE);
+	}
+
 	ret = ahash_set_sh_desc(ahash);
 	kfree(hashed_key);
 	return ret;
@@ -4536,11 +4546,27 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 
 	ctx->dev = caam_hash->dev;
 
+	if (alg->setkey) {
+		ctx->key_dma = dma_map_single_attrs(ctx->dev, ctx->key,
+						    ARRAY_SIZE(ctx->key),
+						    DMA_TO_DEVICE,
+						    DMA_ATTR_SKIP_CPU_SYNC);
+		if (dma_mapping_error(ctx->dev, ctx->key_dma)) {
+			dev_err(ctx->dev, "unable to map key\n");
+			return -ENOMEM;
+		}
+	}
+
 	dma_addr = dma_map_single_attrs(ctx->dev, ctx->flc, sizeof(ctx->flc),
 					DMA_BIDIRECTIONAL,
 					DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(ctx->dev, dma_addr)) {
 		dev_err(ctx->dev, "unable to map shared descriptors\n");
+		if (ctx->key_dma)
+			dma_unmap_single_attrs(ctx->dev, ctx->key_dma,
+					       ARRAY_SIZE(ctx->key),
+					       DMA_TO_DEVICE,
+					       DMA_ATTR_SKIP_CPU_SYNC);
 		return -ENOMEM;
 	}
 
@@ -4566,6 +4592,10 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 
 	dma_unmap_single_attrs(ctx->dev, ctx->flc_dma[0], sizeof(ctx->flc),
 			       DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
+	if (ctx->key_dma)
+		dma_unmap_single_attrs(ctx->dev, ctx->key_dma,
+				       ARRAY_SIZE(ctx->key), DMA_TO_DEVICE,
+				       DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static struct caam_hash_alg *caam_hash_alloc(struct device *dev,
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 14fdfa1..e89913b 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -98,6 +98,7 @@ struct caam_hash_ctx {
 	dma_addr_t sh_desc_digest_dma;
 	dma_addr_t key_dma;
 	enum dma_data_direction dir;
+	enum dma_data_direction key_dir;
 	struct device *jrdev;
 	int ctx_len;
 	struct alginfo adata;
@@ -475,6 +476,19 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 			goto bad_free_key;
 
 		memcpy(ctx->key, key, keylen);
+
+		/*
+		 * In case |user key| > |derived key|, using DKP<imm,imm>
+		 * would result in invalid opcodes (last bytes of user key) in
+		 * the resulting descriptor. Use DKP<ptr,imm> instead => both
+		 * virtual and dma key addresses are needed.
+		 */
+		if (keylen > ctx->adata.keylen_pad) {
+			ctx->adata.key_dma = ctx->key_dma;
+			dma_sync_single_for_device(ctx->jrdev, ctx->key_dma,
+						   ctx->adata.keylen_pad,
+						   DMA_TO_DEVICE);
+		}
 	} else {
 		ret = gen_split_key(ctx->jrdev, ctx->key, &ctx->adata, key,
 				    keylen, CAAM_MAX_HASH_KEY_SIZE);
@@ -1825,40 +1839,50 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 
 	if (is_xcbc_aes(caam_hash->alg_type)) {
 		ctx->dir = DMA_TO_DEVICE;
+		ctx->key_dir = DMA_BIDIRECTIONAL;
 		ctx->adata.algtype = OP_TYPE_CLASS1_ALG | caam_hash->alg_type;
 		ctx->ctx_len = 48;
-
-		ctx->key_dma = dma_map_single_attrs(ctx->jrdev, ctx->key,
-						    ARRAY_SIZE(ctx->key),
-						    DMA_BIDIRECTIONAL,
-						    DMA_ATTR_SKIP_CPU_SYNC);
-		if (dma_mapping_error(ctx->jrdev, ctx->key_dma)) {
-			dev_err(ctx->jrdev, "unable to map key\n");
-			caam_jr_free(ctx->jrdev);
-			return -ENOMEM;
-		}
 	} else if (is_cmac_aes(caam_hash->alg_type)) {
 		ctx->dir = DMA_TO_DEVICE;
+		ctx->key_dir = DMA_NONE;
 		ctx->adata.algtype = OP_TYPE_CLASS1_ALG | caam_hash->alg_type;
 		ctx->ctx_len = 32;
 	} else {
-		ctx->dir = priv->era >= 6 ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
+		if (priv->era >= 6) {
+			ctx->dir = DMA_BIDIRECTIONAL;
+			ctx->key_dir = DMA_TO_DEVICE;
+		} else {
+			ctx->dir = DMA_TO_DEVICE;
+			ctx->key_dir = DMA_NONE;
+		}
 		ctx->adata.algtype = OP_TYPE_CLASS2_ALG | caam_hash->alg_type;
 		ctx->ctx_len = runninglen[(ctx->adata.algtype &
 					   OP_ALG_ALGSEL_SUBMASK) >>
 					  OP_ALG_ALGSEL_SHIFT];
 	}
 
+	if (ctx->key_dir != DMA_NONE) {
+		ctx->key_dma = dma_map_single_attrs(ctx->jrdev, ctx->key,
+						    ARRAY_SIZE(ctx->key),
+						    ctx->key_dir,
+						    DMA_ATTR_SKIP_CPU_SYNC);
+		if (dma_mapping_error(ctx->jrdev, ctx->key_dma)) {
+			dev_err(ctx->jrdev, "unable to map key\n");
+			caam_jr_free(ctx->jrdev);
+			return -ENOMEM;
+		}
+	}
+
 	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,
 					offsetof(struct caam_hash_ctx, key),
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
 		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
 
-		if (is_xcbc_aes(caam_hash->alg_type))
+		if (ctx->key_dir != DMA_NONE)
 			dma_unmap_single_attrs(ctx->jrdev, ctx->key_dma,
 					       ARRAY_SIZE(ctx->key),
-					       DMA_BIDIRECTIONAL,
+					       ctx->key_dir,
 					       DMA_ATTR_SKIP_CPU_SYNC);
 
 		caam_jr_free(ctx->jrdev);
@@ -1891,9 +1915,9 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_update_dma,
 			       offsetof(struct caam_hash_ctx, key),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (is_xcbc_aes(ctx->adata.algtype))
+	if (ctx->key_dir != DMA_NONE)
 		dma_unmap_single_attrs(ctx->jrdev, ctx->key_dma,
-				       ARRAY_SIZE(ctx->key), DMA_BIDIRECTIONAL,
+				       ARRAY_SIZE(ctx->key), ctx->key_dir,
 				       DMA_ATTR_SKIP_CPU_SYNC);
 	caam_jr_free(ctx->jrdev);
 }
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 8154174..536f360 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -533,14 +533,26 @@ static inline void append_proto_dkp(u32 * const desc, struct alginfo *adata)
 	if (adata->key_inline) {
 		int words;
 
-		append_operation(desc, OP_TYPE_UNI_PROTOCOL | protid |
-				 OP_PCL_DKP_SRC_IMM | OP_PCL_DKP_DST_IMM |
-				 adata->keylen);
-		append_data(desc, adata->key_virt, adata->keylen);
+		if (adata->keylen > adata->keylen_pad) {
+			append_operation(desc, OP_TYPE_UNI_PROTOCOL | protid |
+					 OP_PCL_DKP_SRC_PTR |
+					 OP_PCL_DKP_DST_IMM | adata->keylen);
+			append_ptr(desc, adata->key_dma);
+
+			words = (ALIGN(adata->keylen_pad, CAAM_CMD_SZ) -
+				 CAAM_PTR_SZ) / CAAM_CMD_SZ;
+		} else {
+			append_operation(desc, OP_TYPE_UNI_PROTOCOL | protid |
+					 OP_PCL_DKP_SRC_IMM |
+					 OP_PCL_DKP_DST_IMM | adata->keylen);
+			append_data(desc, adata->key_virt, adata->keylen);
+
+			words = (ALIGN(adata->keylen_pad, CAAM_CMD_SZ) -
+				 ALIGN(adata->keylen, CAAM_CMD_SZ)) /
+				CAAM_CMD_SZ;
+		}
 
 		/* Reserve space in descriptor buffer for the derived key */
-		words = (ALIGN(adata->keylen_pad, CAAM_CMD_SZ) -
-			 ALIGN(adata->keylen, CAAM_CMD_SZ)) / CAAM_CMD_SZ;
 		if (words)
 			(*desc) = cpu_to_caam32(caam32_to_cpu(*desc) + words);
 	} else {
-- 
2.1.0

