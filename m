Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E288AC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A74FB20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbfDRNlj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:39 -0400
Received: from foss.arm.com ([217.140.101.70]:33702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRNli (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1E651688;
        Thu, 18 Apr 2019 06:41:37 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 539E43F5AF;
        Thu, 18 Apr 2019 06:41:36 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/35] crypto: ccree: don't mangle the request assoclen
Date:   Thu, 18 Apr 2019 16:38:59 +0300
Message-Id: <20190418133913.9122-25-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We were mangling the request struct assoclen field.
Fix it by keeping an internal version and working on it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c       | 40 +++++++++++++++++-----------
 drivers/crypto/ccree/cc_aead.h       |  1 +
 drivers/crypto/ccree/cc_buffer_mgr.c | 22 +++++++--------
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index f9e410de66a8..7447fd0ff48e 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -731,7 +731,7 @@ static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 		dev_dbg(dev, "ASSOC buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
-			     areq->assoclen, NS_BIT);
+			     areq_ctx->assoclen, NS_BIT);
 		set_flow_mode(&desc[idx], flow_mode);
 		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
 		    areq_ctx->cryptlen > 0)
@@ -1080,9 +1080,11 @@ static void cc_proc_header_desc(struct aead_request *req,
 				struct cc_hw_desc desc[],
 				unsigned int *seq_size)
 {
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
+
 	/* Hash associated data */
-	if (req->assoclen > 0)
+	if (areq_ctx->assoclen > 0)
 		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
 
 	/* Hash IV */
@@ -1310,7 +1312,7 @@ static int validate_data_size(struct cc_aead_ctx *ctx,
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	unsigned int assoclen = req->assoclen;
+	unsigned int assoclen = areq_ctx->assoclen;
 	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
 			(req->cryptlen - ctx->authsize) : req->cryptlen;
 
@@ -1469,7 +1471,7 @@ static int cc_ccm(struct aead_request *req, struct cc_hw_desc desc[],
 	idx++;
 
 	/* process assoc data */
-	if (req->assoclen > 0) {
+	if (req_ctx->assoclen > 0) {
 		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
 	} else {
 		hw_desc_init(&desc[idx]);
@@ -1561,7 +1563,7 @@ static int config_ccm_adata(struct aead_request *req)
 	 * NIST Special Publication 800-38C
 	 */
 	*b0 |= (8 * ((m - 2) / 2));
-	if (req->assoclen > 0)
+	if (req_ctx->assoclen > 0)
 		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
 
 	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
@@ -1572,7 +1574,7 @@ static int config_ccm_adata(struct aead_request *req)
 	 /* END of "taken from crypto/ccm.c" */
 
 	/* l(a) - size of associated data. */
-	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req->assoclen);
+	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req_ctx->assoclen);
 
 	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
 	req->iv[15] = 1;
@@ -1604,7 +1606,7 @@ static void cc_proc_rfc4309_ccm(struct aead_request *req)
 	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
 	       CCM_BLOCK_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
-	req->assoclen -= CCM_BLOCK_IV_SIZE;
+	areq_ctx->assoclen -= CCM_BLOCK_IV_SIZE;
 }
 
 static void cc_set_ghash_desc(struct aead_request *req,
@@ -1812,7 +1814,7 @@ static int cc_gcm(struct aead_request *req, struct cc_hw_desc desc[],
 	// for gcm and rfc4106.
 	cc_set_ghash_desc(req, desc, seq_size);
 	/* process(ghash) assoc data */
-	if (req->assoclen > 0)
+	if (req_ctx->assoclen > 0)
 		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
 	cc_set_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
@@ -1836,8 +1838,8 @@ static int config_gcm_context(struct aead_request *req)
 				(req->cryptlen - ctx->authsize);
 	__be32 counter = cpu_to_be32(2);
 
-	dev_dbg(dev, "%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n",
-		__func__, cryptlen, req->assoclen, ctx->authsize);
+	dev_dbg(dev, "%s() cryptlen = %d, req_ctx->assoclen = %d ctx->authsize = %d\n",
+		__func__, cryptlen, req_ctx->assoclen, ctx->authsize);
 
 	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
 
@@ -1853,7 +1855,7 @@ static int config_gcm_context(struct aead_request *req)
 	if (!req_ctx->plaintext_authenticate_only) {
 		__be64 temp64;
 
-		temp64 = cpu_to_be64(req->assoclen * 8);
+		temp64 = cpu_to_be64(req_ctx->assoclen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1863,8 +1865,8 @@ static int config_gcm_context(struct aead_request *req)
 		 */
 		__be64 temp64;
 
-		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE +
-				      cryptlen) * 8);
+		temp64 = cpu_to_be64((req_ctx->assoclen +
+				      GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1884,7 +1886,7 @@ static void cc_proc_rfc4_gcm(struct aead_request *req)
 	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
 	       GCM_BLOCK_RFC4_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
-	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
+	areq_ctx->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
 static int cc_proc_aead(struct aead_request *req,
@@ -1909,7 +1911,7 @@ static int cc_proc_aead(struct aead_request *req,
 	/* Check data length according to mode */
 	if (validate_data_size(ctx, direct, req)) {
 		dev_err(dev, "Unsupported crypt/assoc len %d/%d.\n",
-			req->cryptlen, req->assoclen);
+			req->cryptlen, areq_ctx->assoclen);
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
 		return -EINVAL;
 	}
@@ -2062,6 +2064,7 @@ static int cc_aead_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = false;
 
@@ -2093,6 +2096,7 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = true;
 
@@ -2114,6 +2118,7 @@ static int cc_aead_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = false;
 
@@ -2143,6 +2148,7 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->is_gcm4543 = true;
@@ -2262,6 +2268,7 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->plaintext_authenticate_only = false;
@@ -2290,6 +2297,7 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	cc_proc_rfc4_gcm(req);
@@ -2321,6 +2329,7 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->plaintext_authenticate_only = false;
@@ -2349,6 +2358,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	cc_proc_rfc4_gcm(req);
diff --git a/drivers/crypto/ccree/cc_aead.h b/drivers/crypto/ccree/cc_aead.h
index 6cfae15f85e5..e51724b96c56 100644
--- a/drivers/crypto/ccree/cc_aead.h
+++ b/drivers/crypto/ccree/cc_aead.h
@@ -67,6 +67,7 @@ struct aead_req_ctx {
 	u8 backup_mac[MAX_MAC_SIZE];
 	u8 *backup_iv; /*store iv for generated IV flow*/
 	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
+	u32 assoclen; /* internal assoclen */
 	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
 	/* buffer for internal ccm configurations */
 	dma_addr_t ccm_iv0_dma_addr;
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 8554cfb2963a..86e498bee0bb 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -65,7 +65,7 @@ static void cc_copy_mac(struct device *dev, struct aead_request *req,
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	u32 skip = req->assoclen + req->cryptlen;
+	u32 skip = areq_ctx->assoclen + req->cryptlen;
 
 	if (areq_ctx->is_gcm4543)
 		skip += crypto_aead_ivsize(tfm);
@@ -575,8 +575,8 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 
 	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
-		req->assoclen, req->cryptlen);
-	size_to_unmap = req->assoclen + req->cryptlen;
+		areq_ctx->assoclen, req->cryptlen);
+	size_to_unmap = areq_ctx->assoclen + req->cryptlen;
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
 		size_to_unmap += areq_ctx->req_authsize;
 	if (areq_ctx->is_gcm4543)
@@ -663,7 +663,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 	struct scatterlist *current_sg = req->src;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned int sg_index = 0;
-	u32 size_of_assoc = req->assoclen;
+	u32 size_of_assoc = areq_ctx->assoclen;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	if (areq_ctx->is_gcm4543)
@@ -674,7 +674,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 		goto chain_assoc_exit;
 	}
 
-	if (req->assoclen == 0) {
+	if (areq_ctx->assoclen == 0) {
 		areq_ctx->assoc_buff_type = CC_DMA_BUF_NULL;
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
@@ -734,7 +734,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
 		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
-				req->assoclen, 0, is_last,
+				areq_ctx->assoclen, 0, is_last,
 				&areq_ctx->assoc.mlli_nents);
 		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
 	}
@@ -893,11 +893,11 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
 	u32 offset = 0;
 	/* non-inplace mode */
-	unsigned int size_for_map = req->assoclen + req->cryptlen;
+	unsigned int size_for_map = areq_ctx->assoclen + req->cryptlen;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
-	u32 size_to_skip = req->assoclen;
+	u32 size_to_skip = areq_ctx->assoclen;
 
 	if (is_gcm4543)
 		size_to_skip += crypto_aead_ivsize(tfm);
@@ -941,7 +941,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	areq_ctx->src_offset = offset;
 
 	if (req->src != req->dst) {
-		size_for_map = req->assoclen + req->cryptlen;
+		size_for_map = areq_ctx->assoclen + req->cryptlen;
 		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
 				authsize : 0;
 		if (is_gcm4543)
@@ -1107,7 +1107,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		areq_ctx->ccm_iv0_dma_addr = dma_addr;
 
 		rc = cc_set_aead_conf_buf(dev, areq_ctx, areq_ctx->ccm_config,
-					  &sg_data, req->assoclen);
+					  &sg_data, areq_ctx->assoclen);
 		if (rc)
 			goto aead_map_failure;
 	}
@@ -1158,7 +1158,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
 	}
 
-	size_to_map = req->cryptlen + req->assoclen;
+	size_to_map = req->cryptlen + areq_ctx->assoclen;
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
 		size_to_map += authsize;
 
-- 
2.21.0

