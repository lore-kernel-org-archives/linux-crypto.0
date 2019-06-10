Return-Path: <SRS0=e/ms=UJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BF1C28D16
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 13:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B563212F5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 13:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390387AbfFJNbR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 09:31:17 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41944 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390360AbfFJNbQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 09:31:16 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DD2BD1A0847;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CDA821A02AE;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7B577205E4;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 2/2] crypto: caam - update IV using HW support
Date:   Mon, 10 Jun 2019 16:30:59 +0300
Message-Id: <20190610133059.1059-3-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610133059.1059-1-horia.geanta@nxp.com>
References: <20190610133059.1059-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Modify drivers to perform skcipher IV update using the crypto engine,
instead of performing the operation in SW.

Besides being more efficient, this also fixes IV update for CTR mode.

Output HW S/G table is appended with an entry pointing to the same
IV buffer used as input (which is now mapped BIDIRECTIONAL).

AS (Algorithm State) parameter of the OPERATION command is changed
from INIFINAL to INIT in descriptors used by ctr(aes), cbc(aes).
This is needed since in case FINAL bit is set, HW skips IV updating
in the Context Register for the last data block.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c      | 88 +++++++++++++++------------
 drivers/crypto/caam/caamalg_desc.c | 31 ++++++++--
 drivers/crypto/caam/caamalg_desc.h |  4 +-
 drivers/crypto/caam/caamalg_qi.c   | 90 ++++++++++++----------------
 drivers/crypto/caam/caamalg_qi2.c  | 96 ++++++++++++++----------------
 5 files changed, 163 insertions(+), 146 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 95ef70bffd12..43f18253e5b6 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -898,7 +898,7 @@ static void caam_unmap(struct device *dev, struct scatterlist *src,
 	}
 
 	if (iv_dma)
-		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
+		dma_unmap_single(dev, iv_dma, ivsize, DMA_BIDIRECTIONAL);
 	if (sec4_sg_bytes)
 		dma_unmap_single(dev, sec4_sg_dma, sec4_sg_bytes,
 				 DMA_TO_DEVICE);
@@ -977,7 +977,6 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
-	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -991,16 +990,17 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block when running in CBC mode.
+	 * ciphertext block (CBC mode) or last counter (CTR mode).
+	 * This is used e.g. by the CTS mode.
 	 */
-	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
-		scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen -
-					 ivsize, ivsize, 0);
+	if (ivsize) {
+		memcpy(req->iv, (u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,
+		       ivsize);
 
-	if (ivsize)
 		print_hex_dump_debug("dstiv  @"__stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 				     edesc->src_nents > 1 ? 100 : ivsize, 1);
+	}
 
 	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
@@ -1027,8 +1027,20 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	skcipher_unmap(jrdev, edesc, req);
 
-	print_hex_dump_debug("dstiv  @"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, req->iv, ivsize, 1);
+	/*
+	 * The crypto API expects us to set the IV (req->iv) to the last
+	 * ciphertext block (CBC mode) or last counter (CTR mode).
+	 * This is used e.g. by the CTS mode.
+	 */
+	if (ivsize) {
+		memcpy(req->iv, (u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,
+		       ivsize);
+
+		print_hex_dump_debug("dstiv  @" __stringify(__LINE__)": ",
+				     DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
+				     ivsize, 1);
+	}
+
 	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
@@ -1260,7 +1272,7 @@ static void init_skcipher_job(struct skcipher_request *req,
 	if (likely(req->src == req->dst)) {
 		dst_dma = src_dma + !!ivsize * sizeof(struct sec4_sg_entry);
 		out_options = in_options;
-	} else if (edesc->mapped_dst_nents == 1) {
+	} else if (!ivsize && edesc->mapped_dst_nents == 1) {
 		dst_dma = sg_dma_address(req->dst);
 	} else {
 		dst_dma = edesc->sec4_sg_dma + sec4_sg_index *
@@ -1268,7 +1280,7 @@ static void init_skcipher_job(struct skcipher_request *req,
 		out_options = LDST_SGF;
 	}
 
-	append_seq_out_ptr(desc, dst_dma, req->cryptlen, out_options);
+	append_seq_out_ptr(desc, dst_dma, req->cryptlen + ivsize, out_options);
 }
 
 /*
@@ -1699,22 +1711,26 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	dst_sg_idx = sec4_sg_ents;
 
 	/*
+	 * Input, output HW S/G tables: [IV, src][dst, IV]
+	 * IV entries point to the same buffer
+	 * If src == dst, S/G entries are reused (S/G tables overlap)
+	 *
 	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
 	 * the end of the table by allocating more S/G entries. Logic:
-	 * if (src != dst && output S/G)
+	 * if (output S/G)
 	 *      pad output S/G, if needed
-	 * else if (src == dst && S/G)
-	 *      overlapping S/Gs; pad one of them
 	 * else if (input S/G) ...
 	 *      pad input S/G, if needed
 	 */
-	if (mapped_dst_nents > 1)
-		sec4_sg_ents += pad_sg_nents(mapped_dst_nents);
-	else if ((req->src == req->dst) && (mapped_src_nents > 1))
-		sec4_sg_ents = max(pad_sg_nents(sec4_sg_ents),
-				   !!ivsize + pad_sg_nents(mapped_src_nents));
-	else
+	if (ivsize || mapped_dst_nents > 1) {
+		if (req->src == req->dst)
+			sec4_sg_ents = !!ivsize + pad_sg_nents(sec4_sg_ents);
+		else
+			sec4_sg_ents += pad_sg_nents(mapped_dst_nents +
+						     !!ivsize);
+	} else {
 		sec4_sg_ents = pad_sg_nents(sec4_sg_ents);
+	}
 
 	sec4_sg_bytes = sec4_sg_ents * sizeof(struct sec4_sg_entry);
 
@@ -1740,10 +1756,10 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	/* Make sure IV is located in a DMAable area */
 	if (ivsize) {
-		iv = (u8 *)edesc->hw_desc + desc_bytes + sec4_sg_bytes;
+		iv = (u8 *)edesc->sec4_sg + sec4_sg_bytes;
 		memcpy(iv, req->iv, ivsize);
 
-		iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_TO_DEVICE);
+		iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(jrdev, iv_dma)) {
 			dev_err(jrdev, "unable to map IV\n");
 			caam_unmap(jrdev, req->src, req->dst, src_nents,
@@ -1755,13 +1771,20 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		dma_to_sec4_sg_one(edesc->sec4_sg, iv_dma, ivsize, 0);
 	}
 	if (dst_sg_idx)
-		sg_to_sec4_sg_last(req->src, req->cryptlen, edesc->sec4_sg +
-				   !!ivsize, 0);
+		sg_to_sec4_sg(req->src, req->cryptlen, edesc->sec4_sg +
+			      !!ivsize, 0);
 
-	if (mapped_dst_nents > 1) {
-		sg_to_sec4_sg_last(req->dst, req->cryptlen,
-				   edesc->sec4_sg + dst_sg_idx, 0);
-	}
+	if (req->src != req->dst && (ivsize || mapped_dst_nents > 1))
+		sg_to_sec4_sg(req->dst, req->cryptlen, edesc->sec4_sg +
+			      dst_sg_idx, 0);
+
+	if (ivsize)
+		dma_to_sec4_sg_one(edesc->sec4_sg + dst_sg_idx +
+				   mapped_dst_nents, iv_dma, ivsize, 0);
+
+	if (ivsize || mapped_dst_nents > 1)
+		sg_to_sec4_set_last(edesc->sec4_sg + dst_sg_idx +
+				    mapped_dst_nents);
 
 	if (sec4_sg_bytes) {
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -1824,7 +1847,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	int ivsize = crypto_skcipher_ivsize(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc;
 	int ret = 0;
@@ -1834,14 +1856,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	/*
-	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block when running in CBC mode.
-	 */
-	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
-		scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
-					 ivsize, ivsize, 0);
-
 	/* Create and submit job descriptor*/
 	init_skcipher_job(req, edesc, false);
 	desc = edesc->hw_desc;
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index a73b79c5d46c..72531837571e 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -33,12 +33,11 @@ static inline void append_dec_op1(u32 *desc, u32 type)
 	}
 
 	jump_cmd = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
-	append_operation(desc, type | OP_ALG_AS_INITFINAL |
-			 OP_ALG_DECRYPT);
+	append_operation(desc, type | OP_ALG_AS_INIT | OP_ALG_DECRYPT);
 	uncond_jump_cmd = append_jump(desc, JUMP_TEST_ALL);
 	set_jump_tgt_here(desc, jump_cmd);
-	append_operation(desc, type | OP_ALG_AS_INITFINAL |
-			 OP_ALG_DECRYPT | OP_ALG_AAI_DK);
+	append_operation(desc, type | OP_ALG_AS_INIT | OP_ALG_DECRYPT |
+			 OP_ALG_AAI_DK);
 	set_jump_tgt_here(desc, uncond_jump_cmd);
 }
 
@@ -1392,12 +1391,18 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 				      LDST_OFFSET_SHIFT));
 
 	/* Load operation */
-	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
+	append_operation(desc, cdata->algtype | OP_ALG_AS_INIT |
 			 OP_ALG_ENCRYPT);
 
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
+	/* Store IV */
+	if (ivsize)
+		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+				 LDST_CLASS_1_CCB | (ctx1_iv_off <<
+				 LDST_OFFSET_SHIFT));
+
 	print_hex_dump_debug("skcipher enc shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -1459,7 +1464,7 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 
 	/* Choose operation */
 	if (ctx1_iv_off)
-		append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
+		append_operation(desc, cdata->algtype | OP_ALG_AS_INIT |
 				 OP_ALG_DECRYPT);
 	else
 		append_dec_op1(desc, cdata->algtype);
@@ -1467,6 +1472,12 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
+	/* Store IV */
+	if (ivsize)
+		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+				 LDST_CLASS_1_CCB | (ctx1_iv_off <<
+				 LDST_OFFSET_SHIFT));
+
 	print_hex_dump_debug("skcipher dec shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -1516,6 +1527,10 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
+	/* Store upper 8B of IV */
+	append_seq_store(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			 (0x20 << LDST_OFFSET_SHIFT));
+
 	print_hex_dump_debug("xts skcipher enc shdesc@" __stringify(__LINE__)
 			     ": ", DUMP_PREFIX_ADDRESS, 16, 4,
 			     desc, desc_bytes(desc), 1);
@@ -1564,6 +1579,10 @@ void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata)
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
+	/* Store upper 8B of IV */
+	append_seq_store(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			 (0x20 << LDST_OFFSET_SHIFT));
+
 	print_hex_dump_debug("xts skcipher dec shdesc@" __stringify(__LINE__)
 			     ": ", DUMP_PREFIX_ADDRESS, 16, 4, desc,
 			     desc_bytes(desc), 1);
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index d5ca42ff961a..da4a4ee60c80 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -44,9 +44,9 @@
 
 #define DESC_SKCIPHER_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_SKCIPHER_ENC_LEN		(DESC_SKCIPHER_BASE + \
-					 20 * CAAM_CMD_SZ)
+					 21 * CAAM_CMD_SZ)
 #define DESC_SKCIPHER_DEC_LEN		(DESC_SKCIPHER_BASE + \
-					 15 * CAAM_CMD_SZ)
+					 16 * CAAM_CMD_SZ)
 
 void cnstr_shdsc_aead_null_encap(u32 * const desc, struct alginfo *adata,
 				 unsigned int icvsize, int era);
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index cec54344787c..32f0f8a72067 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -831,7 +831,8 @@ static struct caam_drv_ctx *get_drv_ctx(struct caam_ctx *ctx,
 static void caam_unmap(struct device *dev, struct scatterlist *src,
 		       struct scatterlist *dst, int src_nents,
 		       int dst_nents, dma_addr_t iv_dma, int ivsize,
-		       dma_addr_t qm_sg_dma, int qm_sg_bytes)
+		       enum dma_data_direction iv_dir, dma_addr_t qm_sg_dma,
+		       int qm_sg_bytes)
 {
 	if (dst != src) {
 		if (src_nents)
@@ -843,7 +844,7 @@ static void caam_unmap(struct device *dev, struct scatterlist *src,
 	}
 
 	if (iv_dma)
-		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
+		dma_unmap_single(dev, iv_dma, ivsize, iv_dir);
 	if (qm_sg_bytes)
 		dma_unmap_single(dev, qm_sg_dma, qm_sg_bytes, DMA_TO_DEVICE);
 }
@@ -856,7 +857,8 @@ static void aead_unmap(struct device *dev,
 	int ivsize = crypto_aead_ivsize(aead);
 
 	caam_unmap(dev, req->src, req->dst, edesc->src_nents, edesc->dst_nents,
-		   edesc->iv_dma, ivsize, edesc->qm_sg_dma, edesc->qm_sg_bytes);
+		   edesc->iv_dma, ivsize, DMA_TO_DEVICE, edesc->qm_sg_dma,
+		   edesc->qm_sg_bytes);
 	dma_unmap_single(dev, edesc->assoclen_dma, 4, DMA_TO_DEVICE);
 }
 
@@ -867,7 +869,8 @@ static void skcipher_unmap(struct device *dev, struct skcipher_edesc *edesc,
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 	caam_unmap(dev, req->src, req->dst, edesc->src_nents, edesc->dst_nents,
-		   edesc->iv_dma, ivsize, edesc->qm_sg_dma, edesc->qm_sg_bytes);
+		   edesc->iv_dma, ivsize, DMA_BIDIRECTIONAL, edesc->qm_sg_dma,
+		   edesc->qm_sg_bytes);
 }
 
 static void aead_done(struct caam_drv_req *drv_req, u32 status)
@@ -1036,7 +1039,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1051,7 +1054,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (dma_mapping_error(qidev, iv_dma)) {
 			dev_err(qidev, "unable to map IV\n");
 			caam_unmap(qidev, req->src, req->dst, src_nents,
-				   dst_nents, 0, 0, 0, 0);
+				   dst_nents, 0, 0, DMA_NONE, 0, 0);
 			qi_cache_free(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
@@ -1070,7 +1073,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	if (dma_mapping_error(qidev, edesc->assoclen_dma)) {
 		dev_err(qidev, "unable to map assoclen\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
+			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1092,7 +1095,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dev_err(qidev, "unable to map S/G table\n");
 		dma_unmap_single(qidev, edesc->assoclen_dma, 4, DMA_TO_DEVICE);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
+			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1206,11 +1209,10 @@ static void skcipher_done(struct caam_drv_req *drv_req, u32 status)
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block. This is used e.g. by the CTS mode.
+	 * ciphertext block (CBC mode) or last counter (CTR mode).
+	 * This is used e.g. by the CTS mode.
 	 */
-	if (edesc->drv_req.drv_ctx->op_type == ENCRYPT)
-		scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen -
-					 ivsize, ivsize, 0);
+	memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes, ivsize);
 
 	qi_cache_free(edesc);
 	skcipher_request_complete(req, status);
@@ -1279,22 +1281,17 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	dst_sg_idx = qm_sg_ents;
 
 	/*
+	 * Input, output HW S/G tables: [IV, src][dst, IV]
+	 * IV entries point to the same buffer
+	 * If src == dst, S/G entries are reused (S/G tables overlap)
+	 *
 	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
-	 * the end of the table by allocating more S/G entries. Logic:
-	 * if (src != dst && output S/G)
-	 *      pad output S/G, if needed
-	 * else if (src == dst && S/G)
-	 *      overlapping S/Gs; pad one of them
-	 * else if (input S/G) ...
-	 *      pad input S/G, if needed
+	 * the end of the table by allocating more S/G entries.
 	 */
-	if (mapped_dst_nents > 1)
-		qm_sg_ents += pad_sg_nents(mapped_dst_nents);
-	else if ((req->src == req->dst) && (mapped_src_nents > 1))
-		qm_sg_ents = max(pad_sg_nents(qm_sg_ents),
-				 1 + pad_sg_nents(mapped_src_nents));
+	if (req->src != req->dst)
+		qm_sg_ents += pad_sg_nents(mapped_dst_nents + 1);
 	else
-		qm_sg_ents = pad_sg_nents(qm_sg_ents);
+		qm_sg_ents = 1 + pad_sg_nents(qm_sg_ents);
 
 	qm_sg_bytes = qm_sg_ents * sizeof(struct qm_sg_entry);
 	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
@@ -1302,7 +1299,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1311,7 +1308,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	if (unlikely(!edesc)) {
 		dev_err(qidev, "could not allocate extended descriptor\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1320,11 +1317,11 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	iv = (u8 *)(sg_table + qm_sg_ents);
 	memcpy(iv, req->iv, ivsize);
 
-	iv_dma = dma_map_single(qidev, iv, ivsize, DMA_TO_DEVICE);
+	iv_dma = dma_map_single(qidev, iv, ivsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(qidev, iv_dma)) {
 		dev_err(qidev, "unable to map IV\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1338,18 +1335,20 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	edesc->drv_req.drv_ctx = drv_ctx;
 
 	dma_to_qm_sg_one(sg_table, iv_dma, ivsize, 0);
-	sg_to_qm_sg_last(req->src, req->cryptlen, sg_table + 1, 0);
+	sg_to_qm_sg(req->src, req->cryptlen, sg_table + 1, 0);
 
-	if (mapped_dst_nents > 1)
-		sg_to_qm_sg_last(req->dst, req->cryptlen, sg_table +
-				 dst_sg_idx, 0);
+	if (req->src != req->dst)
+		sg_to_qm_sg(req->dst, req->cryptlen, sg_table + dst_sg_idx, 0);
+
+	dma_to_qm_sg_one(sg_table + dst_sg_idx + mapped_dst_nents, iv_dma,
+			 ivsize, 0);
 
 	edesc->qm_sg_dma = dma_map_single(qidev, sg_table, edesc->qm_sg_bytes,
 					  DMA_TO_DEVICE);
 	if (dma_mapping_error(qidev, edesc->qm_sg_dma)) {
 		dev_err(qidev, "unable to map S/G table\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
+			   iv_dma, ivsize, DMA_BIDIRECTIONAL, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1359,16 +1358,14 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	dma_to_qm_sg_one_last_ext(&fd_sgt[1], edesc->qm_sg_dma,
 				  ivsize + req->cryptlen, 0);
 
-	if (req->src == req->dst) {
+	if (req->src == req->dst)
 		dma_to_qm_sg_one_ext(&fd_sgt[0], edesc->qm_sg_dma +
-				     sizeof(*sg_table), req->cryptlen, 0);
-	} else if (mapped_dst_nents > 1) {
+				     sizeof(*sg_table), req->cryptlen + ivsize,
+				     0);
+	else
 		dma_to_qm_sg_one_ext(&fd_sgt[0], edesc->qm_sg_dma + dst_sg_idx *
-				     sizeof(*sg_table), req->cryptlen, 0);
-	} else {
-		dma_to_qm_sg_one(&fd_sgt[0], sg_dma_address(req->dst),
-				 req->cryptlen, 0);
-	}
+				     sizeof(*sg_table), req->cryptlen + ivsize,
+				     0);
 
 	return edesc;
 }
@@ -1378,7 +1375,6 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	int ivsize = crypto_skcipher_ivsize(skcipher);
 	int ret;
 
 	if (unlikely(caam_congested))
@@ -1389,14 +1385,6 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	/*
-	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block.
-	 */
-	if (!encrypt)
-		scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
-					 ivsize, ivsize, 0);
-
 	ret = caam_qi_enqueue(ctx->qidev, &edesc->drv_req);
 	if (!ret) {
 		ret = -EINPROGRESS;
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 1652fa26cf96..06bf32c32cbd 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -140,7 +140,8 @@ static struct caam_request *to_caam_req(struct crypto_async_request *areq)
 static void caam_unmap(struct device *dev, struct scatterlist *src,
 		       struct scatterlist *dst, int src_nents,
 		       int dst_nents, dma_addr_t iv_dma, int ivsize,
-		       dma_addr_t qm_sg_dma, int qm_sg_bytes)
+		       enum dma_data_direction iv_dir, dma_addr_t qm_sg_dma,
+		       int qm_sg_bytes)
 {
 	if (dst != src) {
 		if (src_nents)
@@ -152,7 +153,7 @@ static void caam_unmap(struct device *dev, struct scatterlist *src,
 	}
 
 	if (iv_dma)
-		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
+		dma_unmap_single(dev, iv_dma, ivsize, iv_dir);
 
 	if (qm_sg_bytes)
 		dma_unmap_single(dev, qm_sg_dma, qm_sg_bytes, DMA_TO_DEVICE);
@@ -485,7 +486,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dev_err(dev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_nents, ivsize);
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -500,7 +501,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (dma_mapping_error(dev, iv_dma)) {
 			dev_err(dev, "unable to map IV\n");
 			caam_unmap(dev, req->src, req->dst, src_nents,
-				   dst_nents, 0, 0, 0, 0);
+				   dst_nents, 0, 0, DMA_NONE, 0, 0);
 			qi_cache_free(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
@@ -524,7 +525,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	if (dma_mapping_error(dev, edesc->assoclen_dma)) {
 		dev_err(dev, "unable to map assoclen\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
+			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -546,7 +547,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dev_err(dev, "unable to map S/G table\n");
 		dma_unmap_single(dev, edesc->assoclen_dma, 4, DMA_TO_DEVICE);
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
+			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1101,22 +1102,17 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	dst_sg_idx = qm_sg_ents;
 
 	/*
+	 * Input, output HW S/G tables: [IV, src][dst, IV]
+	 * IV entries point to the same buffer
+	 * If src == dst, S/G entries are reused (S/G tables overlap)
+	 *
 	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
-	 * the end of the table by allocating more S/G entries. Logic:
-	 * if (src != dst && output S/G)
-	 *      pad output S/G, if needed
-	 * else if (src == dst && S/G)
-	 *      overlapping S/Gs; pad one of them
-	 * else if (input S/G) ...
-	 *      pad input S/G, if needed
+	 * the end of the table by allocating more S/G entries.
 	 */
-	if (mapped_dst_nents > 1)
-		qm_sg_ents += pad_sg_nents(mapped_dst_nents);
-	else if ((req->src == req->dst) && (mapped_src_nents > 1))
-		qm_sg_ents = max(pad_sg_nents(qm_sg_ents),
-				 1 + pad_sg_nents(mapped_src_nents));
+	if (req->src != req->dst)
+		qm_sg_ents += pad_sg_nents(mapped_dst_nents + 1);
 	else
-		qm_sg_ents = pad_sg_nents(qm_sg_ents);
+		qm_sg_ents = 1 + pad_sg_nents(qm_sg_ents);
 
 	qm_sg_bytes = qm_sg_ents * sizeof(struct dpaa2_sg_entry);
 	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
@@ -1124,7 +1120,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 		dev_err(dev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1133,7 +1129,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	if (unlikely(!edesc)) {
 		dev_err(dev, "could not allocate extended descriptor\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1142,11 +1138,11 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	iv = (u8 *)(sg_table + qm_sg_ents);
 	memcpy(iv, req->iv, ivsize);
 
-	iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
+	iv_dma = dma_map_single(dev, iv, ivsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, iv_dma)) {
 		dev_err(dev, "unable to map IV\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
+			   0, DMA_NONE, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1157,18 +1153,20 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	edesc->qm_sg_bytes = qm_sg_bytes;
 
 	dma_to_qm_sg_one(sg_table, iv_dma, ivsize, 0);
-	sg_to_qm_sg_last(req->src, req->cryptlen, sg_table + 1, 0);
+	sg_to_qm_sg(req->src, req->cryptlen, sg_table + 1, 0);
 
-	if (mapped_dst_nents > 1)
-		sg_to_qm_sg_last(req->dst, req->cryptlen, sg_table +
-				 dst_sg_idx, 0);
+	if (req->src != req->dst)
+		sg_to_qm_sg(req->dst, req->cryptlen, sg_table + dst_sg_idx, 0);
+
+	dma_to_qm_sg_one(sg_table + dst_sg_idx + mapped_dst_nents, iv_dma,
+			 ivsize, 0);
 
 	edesc->qm_sg_dma = dma_map_single(dev, sg_table, edesc->qm_sg_bytes,
 					  DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, edesc->qm_sg_dma)) {
 		dev_err(dev, "unable to map S/G table\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents,
-			   iv_dma, ivsize, 0, 0);
+			   iv_dma, ivsize, DMA_BIDIRECTIONAL, 0, 0);
 		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1176,23 +1174,19 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	memset(&req_ctx->fd_flt, 0, sizeof(req_ctx->fd_flt));
 	dpaa2_fl_set_final(in_fle, true);
 	dpaa2_fl_set_len(in_fle, req->cryptlen + ivsize);
-	dpaa2_fl_set_len(out_fle, req->cryptlen);
+	dpaa2_fl_set_len(out_fle, req->cryptlen + ivsize);
 
 	dpaa2_fl_set_format(in_fle, dpaa2_fl_sg);
 	dpaa2_fl_set_addr(in_fle, edesc->qm_sg_dma);
 
-	if (req->src == req->dst) {
-		dpaa2_fl_set_format(out_fle, dpaa2_fl_sg);
+	dpaa2_fl_set_format(out_fle, dpaa2_fl_sg);
+
+	if (req->src == req->dst)
 		dpaa2_fl_set_addr(out_fle, edesc->qm_sg_dma +
 				  sizeof(*sg_table));
-	} else if (mapped_dst_nents > 1) {
-		dpaa2_fl_set_format(out_fle, dpaa2_fl_sg);
+	else
 		dpaa2_fl_set_addr(out_fle, edesc->qm_sg_dma + dst_sg_idx *
 				  sizeof(*sg_table));
-	} else {
-		dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-		dpaa2_fl_set_addr(out_fle, sg_dma_address(req->dst));
-	}
 
 	return edesc;
 }
@@ -1204,7 +1198,8 @@ static void aead_unmap(struct device *dev, struct aead_edesc *edesc,
 	int ivsize = crypto_aead_ivsize(aead);
 
 	caam_unmap(dev, req->src, req->dst, edesc->src_nents, edesc->dst_nents,
-		   edesc->iv_dma, ivsize, edesc->qm_sg_dma, edesc->qm_sg_bytes);
+		   edesc->iv_dma, ivsize, DMA_TO_DEVICE, edesc->qm_sg_dma,
+		   edesc->qm_sg_bytes);
 	dma_unmap_single(dev, edesc->assoclen_dma, 4, DMA_TO_DEVICE);
 }
 
@@ -1215,7 +1210,8 @@ static void skcipher_unmap(struct device *dev, struct skcipher_edesc *edesc,
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 	caam_unmap(dev, req->src, req->dst, edesc->src_nents, edesc->dst_nents,
-		   edesc->iv_dma, ivsize, edesc->qm_sg_dma, edesc->qm_sg_bytes);
+		   edesc->iv_dma, ivsize, DMA_BIDIRECTIONAL, edesc->qm_sg_dma,
+		   edesc->qm_sg_bytes);
 }
 
 static void aead_encrypt_done(void *cbk_ctx, u32 status)
@@ -1372,10 +1368,10 @@ static void skcipher_encrypt_done(void *cbk_ctx, u32 status)
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block. This is used e.g. by the CTS mode.
+	 * ciphertext block (CBC mode) or last counter (CTR mode).
+	 * This is used e.g. by the CTS mode.
 	 */
-	scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen - ivsize,
-				 ivsize, 0);
+	memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes, ivsize);
 
 	qi_cache_free(edesc);
 	skcipher_request_complete(req, ecode);
@@ -1407,6 +1403,14 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
 	skcipher_unmap(ctx->dev, edesc, req);
+
+	/*
+	 * The crypto API expects us to set the IV (req->iv) to the last
+	 * ciphertext block (CBC mode) or last counter (CTR mode).
+	 * This is used e.g. by the CTS mode.
+	 */
+	memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes, ivsize);
+
 	qi_cache_free(edesc);
 	skcipher_request_complete(req, ecode);
 }
@@ -1445,7 +1449,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
-	int ivsize = crypto_skcipher_ivsize(skcipher);
 	int ret;
 
 	/* allocate extended descriptor */
@@ -1453,13 +1456,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	/*
-	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block.
-	 */
-	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
-				 ivsize, 0);
-
 	caam_req->flc = &ctx->flc[DECRYPT];
 	caam_req->flc_dma = ctx->flc_dma[DECRYPT];
 	caam_req->cbk = skcipher_decrypt_done;
-- 
2.17.1

