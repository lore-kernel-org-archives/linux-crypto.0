Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D33EC10F29
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 15:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08AD121741
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 15:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCHP5j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 11:57:39 -0400
Received: from foss.arm.com ([217.140.110.172]:45784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgCHP5j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 11:57:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6D711FB;
        Sun,  8 Mar 2020 08:57:37 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DA723F6CF;
        Sun,  8 Mar 2020 08:57:36 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] crypto: ccree - refactor AEAD IV in AAD handling
Date:   Sun,  8 Mar 2020 17:57:09 +0200
Message-Id: <20200308155710.14546-7-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200308155710.14546-1-gilad@benyossef.com>
References: <20200308155710.14546-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Our handling of ciphers with IV trailing the AAD was correct
but overly complicated. Refactor to simplify and possibly
save one DMA burst.

This has the added bonus of behaving the same as the generic
rfc4543 implementation for none compliants inputs where the
IV in the iv field was not the same as the IV in the AAD.

There should be no change in behaviour with correct inputs.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c       | 27 ++-------
 drivers/crypto/ccree/cc_aead.h       |  3 +-
 drivers/crypto/ccree/cc_buffer_mgr.c | 89 ++++------------------------
 3 files changed, 16 insertions(+), 103 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index ede16e37d453..875fa79a03eb 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -1609,7 +1609,6 @@ static void cc_proc_rfc4309_ccm(struct aead_request *req)
 	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
 	       CCM_BLOCK_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
-	areq_ctx->assoclen -= CCM_BLOCK_IV_SIZE;
 }
 
 static void cc_set_ghash_desc(struct aead_request *req,
@@ -1868,8 +1867,7 @@ static int config_gcm_context(struct aead_request *req)
 		 */
 		__be64 temp64;
 
-		temp64 = cpu_to_be64((req_ctx->assoclen +
-				      GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
+		temp64 = cpu_to_be64((req_ctx->assoclen + cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1889,7 +1887,6 @@ static void cc_proc_rfc4_gcm(struct aead_request *req)
 	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
 	       GCM_BLOCK_RFC4_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
-	areq_ctx->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
 static int cc_proc_aead(struct aead_request *req,
@@ -2031,9 +2028,6 @@ static int cc_aead_encrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->is_gcm4543 = false;
-
-	areq_ctx->plaintext_authenticate_only = false;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
@@ -2057,8 +2051,7 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
-	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->is_gcm4543 = true;
+	areq_ctx->assoclen = req->assoclen - CCM_BLOCK_IV_SIZE;
 
 	cc_proc_rfc4309_ccm(req);
 
@@ -2079,9 +2072,6 @@ static int cc_aead_decrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->is_gcm4543 = false;
-
-	areq_ctx->plaintext_authenticate_only = false;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
@@ -2103,9 +2093,8 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
-	areq_ctx->assoclen = req->assoclen;
+	areq_ctx->assoclen = req->assoclen - CCM_BLOCK_IV_SIZE;
 
-	areq_ctx->is_gcm4543 = true;
 	cc_proc_rfc4309_ccm(req);
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
@@ -2216,11 +2205,9 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
-	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->plaintext_authenticate_only = false;
+	areq_ctx->assoclen = req->assoclen - GCM_BLOCK_RFC4_IV_SIZE;
 
 	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
@@ -2248,7 +2235,6 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	areq_ctx->assoclen = req->assoclen;
 
 	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
@@ -2270,11 +2256,9 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
-	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->plaintext_authenticate_only = false;
+	areq_ctx->assoclen = req->assoclen - GCM_BLOCK_RFC4_IV_SIZE;
 
 	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
@@ -2302,7 +2286,6 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	areq_ctx->assoclen = req->assoclen;
 
 	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
diff --git a/drivers/crypto/ccree/cc_aead.h b/drivers/crypto/ccree/cc_aead.h
index f12169b57f9d..b69591550730 100644
--- a/drivers/crypto/ccree/cc_aead.h
+++ b/drivers/crypto/ccree/cc_aead.h
@@ -66,7 +66,7 @@ struct aead_req_ctx {
 	/* used to prevent cache coherence problem */
 	u8 backup_mac[MAX_MAC_SIZE];
 	u8 *backup_iv; /* store orig iv */
-	u32 assoclen; /* internal assoclen */
+	u32 assoclen; /* size of AAD buffer to authenticate */
 	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
 	/* buffer for internal ccm configurations */
 	dma_addr_t ccm_iv0_dma_addr;
@@ -79,7 +79,6 @@ struct aead_req_ctx {
 	dma_addr_t gcm_iv_inc2_dma_addr;
 	dma_addr_t hkey_dma_addr; /* Phys. address of hkey */
 	dma_addr_t gcm_block_len_dma_addr; /* Phys. address of gcm block len */
-	bool is_gcm4543;
 
 	u8 *icv_virt_addr; /* Virt. address of ICV */
 	struct async_gen_req_ctx gen_ctx;
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 526da532a0a3..b2bd093e7013 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -13,12 +13,6 @@
 #include "cc_hash.h"
 #include "cc_aead.h"
 
-enum dma_buffer_type {
-	DMA_NULL_TYPE = -1,
-	DMA_SGL_TYPE = 1,
-	DMA_BUFF_TYPE = 2,
-};
-
 union buffer_array_entry {
 	struct scatterlist *sgl;
 	dma_addr_t buffer_dma;
@@ -30,7 +24,6 @@ struct buffer_array {
 	unsigned int offset[MAX_NUM_OF_BUFFERS_IN_MLLI];
 	int nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 	int total_data_len[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	enum dma_buffer_type type[MAX_NUM_OF_BUFFERS_IN_MLLI];
 	bool is_last[MAX_NUM_OF_BUFFERS_IN_MLLI];
 	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 };
@@ -60,11 +53,7 @@ static void cc_copy_mac(struct device *dev, struct aead_request *req,
 			enum cc_sg_cpy_direct dir)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	u32 skip = areq_ctx->assoclen + req->cryptlen;
-
-	if (areq_ctx->is_gcm4543)
-		skip += crypto_aead_ivsize(tfm);
+	u32 skip = req->assoclen + req->cryptlen;
 
 	cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
 			   (skip - areq_ctx->req_authsize), skip, dir);
@@ -216,14 +205,8 @@ static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
 		u32 tot_len = sg_data->total_data_len[i];
 		u32 offset = sg_data->offset[i];
 
-		if (sg_data->type[i] == DMA_SGL_TYPE)
-			rc = cc_render_sg_to_mlli(dev, entry->sgl, tot_len,
-						  offset, &total_nents,
-						  &mlli_p);
-		else /*DMA_BUFF_TYPE*/
-			rc = cc_render_buff_to_mlli(dev, entry->buffer_dma,
-						    tot_len, &total_nents,
-						    &mlli_p);
+		rc = cc_render_sg_to_mlli(dev, entry->sgl, tot_len, offset,
+					  &total_nents, &mlli_p);
 		if (rc)
 			return rc;
 
@@ -249,27 +232,6 @@ static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
 	return rc;
 }
 
-static void cc_add_buffer_entry(struct device *dev,
-				struct buffer_array *sgl_data,
-				dma_addr_t buffer_dma, unsigned int buffer_len,
-				bool is_last_entry, u32 *mlli_nents)
-{
-	unsigned int index = sgl_data->num_of_buffers;
-
-	dev_dbg(dev, "index=%u single_buff=%pad buffer_len=0x%08X is_last=%d\n",
-		index, &buffer_dma, buffer_len, is_last_entry);
-	sgl_data->nents[index] = 1;
-	sgl_data->entry[index].buffer_dma = buffer_dma;
-	sgl_data->offset[index] = 0;
-	sgl_data->total_data_len[index] = buffer_len;
-	sgl_data->type[index] = DMA_BUFF_TYPE;
-	sgl_data->is_last[index] = is_last_entry;
-	sgl_data->mlli_nents[index] = mlli_nents;
-	if (sgl_data->mlli_nents[index])
-		*sgl_data->mlli_nents[index] = 0;
-	sgl_data->num_of_buffers++;
-}
-
 static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
 			    unsigned int nents, struct scatterlist *sgl,
 			    unsigned int data_len, unsigned int data_offset,
@@ -283,7 +245,6 @@ static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
 	sgl_data->entry[index].sgl = sgl;
 	sgl_data->offset[index] = data_offset;
 	sgl_data->total_data_len[index] = data_len;
-	sgl_data->type[index] = DMA_SGL_TYPE;
 	sgl_data->is_last[index] = is_last_table;
 	sgl_data->mlli_nents[index] = mlli_nents;
 	if (sgl_data->mlli_nents[index])
@@ -606,17 +567,6 @@ static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 
 	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
 		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
-	if (do_chain && areq_ctx->plaintext_authenticate_only) {
-		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
-		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
-		/* Chain to given list */
-		cc_add_buffer_entry(dev, sg_data,
-				    (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
-				    iv_size_to_authenc, is_last,
-				    &areq_ctx->assoc.mlli_nents);
-		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
-	}
 
 chain_iv_exit:
 	return rc;
@@ -630,13 +580,8 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc = 0;
 	int mapped_nents = 0;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	unsigned int size_of_assoc = areq_ctx->assoclen;
 	struct device *dev = drvdata_to_dev(drvdata);
 
-	if (areq_ctx->is_gcm4543)
-		size_of_assoc += crypto_aead_ivsize(tfm);
-
 	if (!sg_data) {
 		rc = -EINVAL;
 		goto chain_assoc_exit;
@@ -652,7 +597,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 		goto chain_assoc_exit;
 	}
 
-	mapped_nents = sg_nents_for_len(req->src, size_of_assoc);
+	mapped_nents = sg_nents_for_len(req->src, areq_ctx->assoclen);
 	if (mapped_nents < 0)
 		return mapped_nents;
 
@@ -845,16 +790,11 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
 	u32 offset = 0;
 	/* non-inplace mode */
-	unsigned int size_for_map = areq_ctx->assoclen + req->cryptlen;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned int size_for_map = req->assoclen + req->cryptlen;
 	u32 sg_index = 0;
-	bool is_gcm4543 = areq_ctx->is_gcm4543;
-	u32 size_to_skip = areq_ctx->assoclen;
+	u32 size_to_skip = req->assoclen;
 	struct scatterlist *sgl;
 
-	if (is_gcm4543)
-		size_to_skip += crypto_aead_ivsize(tfm);
-
 	offset = size_to_skip;
 
 	if (!sg_data)
@@ -863,9 +803,6 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	areq_ctx->src_sgl = req->src;
 	areq_ctx->dst_sgl = req->dst;
 
-	if (is_gcm4543)
-		size_for_map += crypto_aead_ivsize(tfm);
-
 	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
 			authsize : 0;
 	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
@@ -892,16 +829,13 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	areq_ctx->src_offset = offset;
 
 	if (req->src != req->dst) {
-		size_for_map = areq_ctx->assoclen + req->cryptlen;
+		size_for_map = req->assoclen + req->cryptlen;
 
 		if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT)
 			size_for_map += authsize;
 		else
 			size_for_map -= authsize;
 
-		if (is_gcm4543)
-			size_for_map += crypto_aead_ivsize(tfm);
-
 		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
 			       &areq_ctx->dst.mapped_nents,
 			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
@@ -1008,12 +942,10 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	struct buffer_array sg_data;
 	unsigned int authsize = areq_ctx->req_authsize;
 	int rc = 0;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	bool is_gcm4543 = areq_ctx->is_gcm4543;
 	dma_addr_t dma_addr;
 	u32 mapped_nents = 0;
 	u32 dummy = 0; /*used for the assoc data fragments */
-	u32 size_to_map = 0;
+	u32 size_to_map;
 	gfp_t flags = cc_gfp_flags(&req->base);
 
 	mlli_params->curr_pool = NULL;
@@ -1110,14 +1042,13 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
 	}
 
-	size_to_map = req->cryptlen + areq_ctx->assoclen;
+	size_to_map = req->cryptlen + req->assoclen;
 	/* If we do in-place encryption, we also need the auth tag */
 	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) &&
 	   (req->src == req->dst)) {
 		size_to_map += authsize;
 	}
-	if (is_gcm4543)
-		size_to_map += crypto_aead_ivsize(tfm);
+
 	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
 		       &areq_ctx->src.mapped_nents,
 		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
-- 
2.25.1

