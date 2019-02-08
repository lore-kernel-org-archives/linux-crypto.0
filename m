Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5934C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0CE20869
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfBHNvf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:51:35 -0500
Received: from inva020.nxp.com ([92.121.34.13]:53880 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfBHNvU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 08:51:20 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DA7411A0272;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CD0501A000E;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 81E6D20138;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 3/4] crypto: caam - add ecb(*) support
Date:   Fri,  8 Feb 2019 15:50:09 +0200
Message-Id: <1549633810-10380-4-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ecb mode support for aes, des, 3des and arc4 ciphers.
ecb(*) reuses existing skcipher implementation, updating it with support
for no IV.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/Kconfig        |   1 +
 drivers/crypto/caam/caamalg.c      | 190 +++++++++++++++++++++++++++++--------
 drivers/crypto/caam/caamalg_desc.c |  18 ++--
 drivers/crypto/caam/compat.h       |   1 +
 4 files changed, 161 insertions(+), 49 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index c4b1cad..577c984 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -91,6 +91,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_DES
 	help
 	  Selecting this will offload crypto for users of the
 	  scatterlist crypto API (such as the linux native IPSec
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 6a52115..90d83ae 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3,7 +3,7 @@
  * caam - Freescale FSL CAAM support for crypto API
  *
  * Copyright 2008-2011 Freescale Semiconductor, Inc.
- * Copyright 2016-2018 NXP
+ * Copyright 2016-2019 NXP
  *
  * Based on talitos crypto API driver.
  *
@@ -766,6 +766,27 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return 0;
 }
 
+static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	u32 tmp[DES3_EDE_EXPKEY_WORDS];
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
+
+	if (keylen == DES3_EDE_KEY_SIZE &&
+	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
+		return -EINVAL;
+	}
+
+	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
+	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_WEAK_KEY);
+		return -EINVAL;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen);
+}
+
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			       unsigned int keylen)
 {
@@ -970,8 +991,9 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	 * The crypto API expects us to set the IV (req->iv) to the last
 	 * ciphertext block. This is used e.g. by the CTS mode.
 	 */
-	scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen - ivsize,
-				 ivsize, 0);
+	if (ivsize)
+		scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen -
+					 ivsize, ivsize, 0);
 
 	kfree(edesc);
 
@@ -1196,9 +1218,9 @@ static void init_skcipher_job(struct skcipher_request *req,
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc = edesc->hw_desc;
 	u32 *sh_desc;
-	u32 out_options = 0;
-	dma_addr_t dst_dma, ptr;
-	int len;
+	u32 in_options = 0, out_options = 0;
+	dma_addr_t src_dma, dst_dma, ptr;
+	int len, sec4_sg_index = 0;
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
@@ -1216,21 +1238,27 @@ static void init_skcipher_job(struct skcipher_request *req,
 	len = desc_len(sh_desc);
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
 
-	append_seq_in_ptr(desc, edesc->sec4_sg_dma, req->cryptlen + ivsize,
-			  LDST_SGF);
+	if (ivsize || edesc->mapped_src_nents > 1) {
+		src_dma = edesc->sec4_sg_dma;
+		sec4_sg_index = edesc->mapped_src_nents + !!ivsize;
+		in_options = LDST_SGF;
+	} else {
+		src_dma = sg_dma_address(req->src);
+	}
+
+	append_seq_in_ptr(desc, src_dma, req->cryptlen + ivsize, in_options);
 
 	if (likely(req->src == req->dst)) {
-		dst_dma = edesc->sec4_sg_dma + sizeof(struct sec4_sg_entry);
-		out_options = LDST_SGF;
+		dst_dma = src_dma + !!ivsize * sizeof(struct sec4_sg_entry);
+		out_options = in_options;
+	} else if (edesc->mapped_dst_nents == 1) {
+		dst_dma = sg_dma_address(req->dst);
 	} else {
-		if (edesc->mapped_dst_nents == 1) {
-			dst_dma = sg_dma_address(req->dst);
-		} else {
-			dst_dma = edesc->sec4_sg_dma + (edesc->mapped_src_nents
-				  + 1) * sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
-		}
+		dst_dma = edesc->sec4_sg_dma + sec4_sg_index *
+			  sizeof(struct sec4_sg_entry);
+		out_options = LDST_SGF;
 	}
+
 	append_seq_out_ptr(desc, dst_dma, req->cryptlen, out_options);
 }
 
@@ -1608,7 +1636,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct skcipher_edesc *edesc;
-	dma_addr_t iv_dma;
+	dma_addr_t iv_dma = 0;
 	u8 *iv;
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 	int dst_sg_idx, sec4_sg_ents, sec4_sg_bytes;
@@ -1643,7 +1671,6 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 			dev_err(jrdev, "unable to map source\n");
 			return ERR_PTR(-ENOMEM);
 		}
-
 		mapped_dst_nents = dma_map_sg(jrdev, req->dst, dst_nents,
 					      DMA_FROM_DEVICE);
 		if (unlikely(!mapped_dst_nents)) {
@@ -1653,7 +1680,10 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		}
 	}
 
-	sec4_sg_ents = 1 + mapped_src_nents;
+	if (!ivsize && mapped_src_nents == 1)
+		sec4_sg_ents = 0; // no need for an input hw s/g table
+	else
+		sec4_sg_ents = mapped_src_nents + !!ivsize;
 	dst_sg_idx = sec4_sg_ents;
 	sec4_sg_ents += mapped_dst_nents > 1 ? mapped_dst_nents : 0;
 	sec4_sg_bytes = sec4_sg_ents * sizeof(struct sec4_sg_entry);
@@ -1679,34 +1709,41 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 						  desc_bytes);
 
 	/* Make sure IV is located in a DMAable area */
-	iv = (u8 *)edesc->hw_desc + desc_bytes + sec4_sg_bytes;
-	memcpy(iv, req->iv, ivsize);
+	if (ivsize) {
+		iv = (u8 *)edesc->hw_desc + desc_bytes + sec4_sg_bytes;
+		memcpy(iv, req->iv, ivsize);
+
+		iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_TO_DEVICE);
+		if (dma_mapping_error(jrdev, iv_dma)) {
+			dev_err(jrdev, "unable to map IV\n");
+			caam_unmap(jrdev, req->src, req->dst, src_nents,
+				   dst_nents, 0, 0, 0, 0);
+			kfree(edesc);
+			return ERR_PTR(-ENOMEM);
+		}
 
-	iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, iv_dma)) {
-		dev_err(jrdev, "unable to map IV\n");
-		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
-		kfree(edesc);
-		return ERR_PTR(-ENOMEM);
+		dma_to_sec4_sg_one(edesc->sec4_sg, iv_dma, ivsize, 0);
 	}
-
-	dma_to_sec4_sg_one(edesc->sec4_sg, iv_dma, ivsize, 0);
-	sg_to_sec4_sg_last(req->src, mapped_src_nents, edesc->sec4_sg + 1, 0);
+	if (dst_sg_idx)
+		sg_to_sec4_sg_last(req->src, mapped_src_nents, edesc->sec4_sg +
+				   !!ivsize, 0);
 
 	if (mapped_dst_nents > 1) {
 		sg_to_sec4_sg_last(req->dst, mapped_dst_nents,
 				   edesc->sec4_sg + dst_sg_idx, 0);
 	}
 
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-		dev_err(jrdev, "unable to map S/G table\n");
-		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
-		kfree(edesc);
-		return ERR_PTR(-ENOMEM);
+	if (sec4_sg_bytes) {
+		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+						    sec4_sg_bytes,
+						    DMA_TO_DEVICE);
+		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
+			dev_err(jrdev, "unable to map S/G table\n");
+			caam_unmap(jrdev, req->src, req->dst, src_nents,
+				   dst_nents, iv_dma, ivsize, 0, 0);
+			kfree(edesc);
+			return ERR_PTR(-ENOMEM);
+		}
 	}
 
 	edesc->iv_dma = iv_dma;
@@ -1773,8 +1810,9 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	 * The crypto API expects us to set the IV (req->iv) to the last
 	 * ciphertext block.
 	 */
-	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
-				 ivsize, 0);
+	if (ivsize)
+		scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
+					 ivsize, ivsize, 0);
 
 	/* Create and submit job descriptor*/
 	init_skcipher_job(req, edesc, false);
@@ -1902,6 +1940,66 @@ static struct caam_skcipher_alg driver_algs[] = {
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
 	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "ecb(des)",
+				.cra_driver_name = "ecb-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
+			.setkey = des_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_ECB,
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "ecb(aes)",
+				.cra_driver_name = "ecb-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_ECB,
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "ecb(des3_ede)",
+				.cra_driver_name = "ecb-des3-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
+			.setkey = des_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_ECB,
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "ecb(arc4)",
+				.cra_driver_name = "ecb-arc4-caam",
+				.cra_blocksize = ARC4_BLOCK_SIZE,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = ARC4_MIN_KEY_SIZE,
+			.max_keysize = ARC4_MAX_KEY_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_ARC4 | OP_ALG_AAI_ECB,
+	},
 };
 
 static struct caam_aead_alg driver_aeads[] = {
@@ -3361,6 +3459,7 @@ static int __init caam_algapi_init(void)
 	struct caam_drv_private *priv;
 	int i = 0, err = 0;
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
+	u32 arc4_inst;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	bool registered = false;
 
@@ -3405,6 +3504,8 @@ static int __init caam_algapi_init(void)
 			   CHA_ID_LS_DES_SHIFT;
 		aes_inst = cha_inst & CHA_ID_LS_AES_MASK;
 		md_inst = (cha_inst & CHA_ID_LS_MD_MASK) >> CHA_ID_LS_MD_SHIFT;
+		arc4_inst = (cha_inst & CHA_ID_LS_ARC4_MASK) >>
+			    CHA_ID_LS_ARC4_SHIFT;
 		ccha_inst = 0;
 		ptha_inst = 0;
 	} else {
@@ -3421,6 +3522,7 @@ static int __init caam_algapi_init(void)
 		md_inst = mdha & CHA_VER_NUM_MASK;
 		ccha_inst = rd_reg32(&priv->ctrl->vreg.ccha) & CHA_VER_NUM_MASK;
 		ptha_inst = rd_reg32(&priv->ctrl->vreg.ptha) & CHA_VER_NUM_MASK;
+		arc4_inst = rd_reg32(&priv->ctrl->vreg.afha) & CHA_VER_NUM_MASK;
 	}
 
 	/* If MD is present, limit digest size based on LP256 */
@@ -3441,6 +3543,10 @@ static int __init caam_algapi_init(void)
 		if (!aes_inst && (alg_sel == OP_ALG_ALGSEL_AES))
 				continue;
 
+		/* Skip ARC4 algorithms if not supported by device */
+		if (!arc4_inst && alg_sel == OP_ALG_ALGSEL_ARC4)
+			continue;
+
 		/*
 		 * Check support for AES modes not available
 		 * on LP devices.
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 7db1640..1e1a376 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -2,7 +2,7 @@
 /*
  * Shared descriptors for aead, skcipher algorithms
  *
- * Copyright 2016-2018 NXP
+ * Copyright 2016-2019 NXP
  */
 
 #include "compat.h"
@@ -1396,9 +1396,11 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/* Load iv */
-	append_seq_load(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
-			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
+	/* Load IV, if there is one */
+	if (ivsize)
+		append_seq_load(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+				LDST_CLASS_1_CCB | (ctx1_iv_off <<
+				LDST_OFFSET_SHIFT));
 
 	/* Load counter into CONTEXT1 reg */
 	if (is_rfc3686)
@@ -1462,9 +1464,11 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/* load IV */
-	append_seq_load(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
-			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
+	/* Load IV, if there is one */
+	if (ivsize)
+		append_seq_load(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+				LDST_CLASS_1_CCB | (ctx1_iv_off <<
+				LDST_OFFSET_SHIFT));
 
 	/* Load counter into CONTEXT1 reg */
 	if (is_rfc3686)
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 87d9efe..8639b2df 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -43,6 +43,7 @@
 #include <crypto/akcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
+#include <crypto/arc4.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/rsa.h>
-- 
2.1.0

