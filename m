Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91F1C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85BB02183F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389271AbfDRNkO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:14 -0400
Received: from foss.arm.com ([217.140.101.70]:33544 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfDRNkO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 546E11688;
        Thu, 18 Apr 2019 06:40:13 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8F9E3F5AF;
        Thu, 18 Apr 2019 06:40:11 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/35] crypto: ccree: read next IV from HW
Date:   Thu, 18 Apr 2019 16:38:44 +0300
Message-Id: <20190418133913.9122-10-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We were computing the next IV in software instead of reading it from HW
on the premise that this can be quicker due to the small size of IVs but
this proved to be much more hassle and bug ridden than expected.

Move to reading the next IV as computed by the HW.

This fixes a number of issue with next IV being wrong for OFB, CTS-CBC
and probably most of the other ciphers as well.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c |   4 +-
 drivers/crypto/ccree/cc_cipher.c     | 179 +++++++++++++--------------
 drivers/crypto/ccree/cc_cipher.h     |   1 -
 3 files changed, 85 insertions(+), 99 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 0ee1c52da0a4..adef3cfa1251 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -457,7 +457,7 @@ void cc_unmap_cipher_request(struct device *dev, void *ctx,
 		dev_dbg(dev, "Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
 			&req_ctx->gen_ctx.iv_dma_addr, ivsize);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
-				 ivsize, DMA_TO_DEVICE);
+				 ivsize, DMA_BIDIRECTIONAL);
 	}
 	/* Release pool */
 	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI &&
@@ -499,7 +499,7 @@ int cc_map_cipher_request(struct cc_drvdata *drvdata, void *ctx,
 		dump_byte_array("iv", (u8 *)info, ivsize);
 		req_ctx->gen_ctx.iv_dma_addr =
 			dma_map_single(dev, (void *)info,
-				       ivsize, DMA_TO_DEVICE);
+				       ivsize, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, req_ctx->gen_ctx.iv_dma_addr)) {
 			dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
 				ivsize, info);
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 4c7231d24631..15da3a35a6a1 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -464,6 +464,76 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	return 0;
 }
 
+static int cc_out_setup_mode(struct cc_cipher_ctx *ctx_p)
+{
+	switch (ctx_p->flow_mode) {
+	case S_DIN_to_AES:
+		return S_AES_to_DOUT;
+	case S_DIN_to_DES:
+		return S_DES_to_DOUT;
+	case S_DIN_to_SM4:
+		return S_SM4_to_DOUT;
+	default:
+		return ctx_p->flow_mode;
+	}
+}
+
+static void cc_setup_readiv_desc(struct crypto_tfm *tfm,
+				 struct cipher_req_ctx *req_ctx,
+				 unsigned int ivsize, struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	int cipher_mode = ctx_p->cipher_mode;
+	int flow_mode = cc_out_setup_mode(ctx_p);
+	int direction = req_ctx->gen_ctx.op_type;
+	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
+
+	if (ctx_p->key_type == CC_POLICY_PROTECTED_KEY)
+		return;
+
+	switch (cipher_mode) {
+	case DRV_CIPHER_ECB:
+		break;
+	case DRV_CIPHER_CBC:
+	case DRV_CIPHER_CBC_CTS:
+	case DRV_CIPHER_CTR:
+	case DRV_CIPHER_OFB:
+		/* Read next IV */
+		hw_desc_init(&desc[*seq_size]);
+		set_dout_dlli(&desc[*seq_size], iv_dma_addr, ivsize, NS_BIT, 1);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		if (cipher_mode == DRV_CIPHER_CTR ||
+		    cipher_mode == DRV_CIPHER_OFB) {
+			set_setup_mode(&desc[*seq_size], SETUP_WRITE_STATE1);
+		} else {
+			set_setup_mode(&desc[*seq_size], SETUP_WRITE_STATE0);
+		}
+		set_queue_last_ind(ctx_p->drvdata, &desc[*seq_size]);
+		(*seq_size)++;
+		break;
+	case DRV_CIPHER_XTS:
+	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
+		/*  IV */
+		hw_desc_init(&desc[*seq_size]);
+		set_setup_mode(&desc[*seq_size], SETUP_WRITE_STATE1);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_dout_dlli(&desc[*seq_size], iv_dma_addr, CC_AES_BLOCK_SIZE,
+			     NS_BIT, 1);
+		set_queue_last_ind(ctx_p->drvdata, &desc[*seq_size]);
+		(*seq_size)++;
+		break;
+	default:
+		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
+	}
+}
+
 static void cc_setup_state_desc(struct crypto_tfm *tfm,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, unsigned int nbytes,
@@ -681,12 +751,14 @@ static void cc_setup_mlli_desc(struct crypto_tfm *tfm,
 static void cc_setup_flow_desc(struct crypto_tfm *tfm,
 			       struct cipher_req_ctx *req_ctx,
 			       struct scatterlist *dst, struct scatterlist *src,
-			       unsigned int nbytes, void *areq,
-			       struct cc_hw_desc desc[], unsigned int *seq_size)
+			       unsigned int nbytes, struct cc_hw_desc desc[],
+			       unsigned int *seq_size)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	unsigned int flow_mode = cc_out_flow_mode(ctx_p);
+	bool last_desc = (ctx_p->key_type == CC_POLICY_PROTECTED_KEY ||
+			  ctx_p->cipher_mode == DRV_CIPHER_ECB);
 
 	/* Process */
 	if (req_ctx->dma_buf_type == CC_DMA_BUF_DLLI) {
@@ -698,8 +770,8 @@ static void cc_setup_flow_desc(struct crypto_tfm *tfm,
 		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
 			     nbytes, NS_BIT);
 		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
-			      nbytes, NS_BIT, (!areq ? 0 : 1));
-		if (areq)
+			      nbytes, NS_BIT, (!last_desc ? 0 : 1));
+		if (last_desc)
 			set_queue_last_ind(ctx_p->drvdata, &desc[*seq_size]);
 
 		set_flow_mode(&desc[*seq_size], flow_mode);
@@ -716,7 +788,7 @@ static void cc_setup_flow_desc(struct crypto_tfm *tfm,
 			set_dout_mlli(&desc[*seq_size],
 				      ctx_p->drvdata->mlli_sram_addr,
 				      req_ctx->in_mlli_nents, NS_BIT,
-				      (!areq ? 0 : 1));
+				      (!last_desc ? 0 : 1));
 		} else {
 			dev_dbg(dev, " din/dout params addr 0x%08X addr 0x%08X\n",
 				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
@@ -727,9 +799,9 @@ static void cc_setup_flow_desc(struct crypto_tfm *tfm,
 				       (LLI_ENTRY_BYTE_SIZE *
 					req_ctx->in_mlli_nents)),
 				      req_ctx->out_mlli_nents, NS_BIT,
-				      (!areq ? 0 : 1));
+				      (!last_desc ? 0 : 1));
 		}
-		if (areq)
+		if (last_desc)
 			set_queue_last_ind(ctx_p->drvdata, &desc[*seq_size]);
 
 		set_flow_mode(&desc[*seq_size], flow_mode);
@@ -737,38 +809,6 @@ static void cc_setup_flow_desc(struct crypto_tfm *tfm,
 	}
 }
 
-/*
- * Update a CTR-AES 128 bit counter
- */
-static void cc_update_ctr(u8 *ctr, unsigned int increment)
-{
-	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
-	    IS_ALIGNED((unsigned long)ctr, 8)) {
-
-		__be64 *high_be = (__be64 *)ctr;
-		__be64 *low_be = high_be + 1;
-		u64 orig_low = __be64_to_cpu(*low_be);
-		u64 new_low = orig_low + (u64)increment;
-
-		*low_be = __cpu_to_be64(new_low);
-
-		if (new_low < orig_low)
-			*high_be = __cpu_to_be64(__be64_to_cpu(*high_be) + 1);
-	} else {
-		u8 *pos = (ctr + AES_BLOCK_SIZE);
-		u8 val;
-		unsigned int size;
-
-		for (; increment; increment--)
-			for (size = AES_BLOCK_SIZE; size; size--) {
-				val = *--pos + 1;
-				*pos = val;
-				if (val)
-					break;
-			}
-	}
-}
-
 static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 {
 	struct skcipher_request *req = (struct skcipher_request *)cc_req;
@@ -776,44 +816,11 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 	struct scatterlist *src = req->src;
 	struct cipher_req_ctx *req_ctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *sk_tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(sk_tfm);
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
-	unsigned int len;
 
 	cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
-
-	switch (ctx_p->cipher_mode) {
-	case DRV_CIPHER_CBC:
-		/*
-		 * The crypto API expects us to set the req->iv to the last
-		 * ciphertext block. For encrypt, simply copy from the result.
-		 * For decrypt, we must copy from a saved buffer since this
-		 * could be an in-place decryption operation and the src is
-		 * lost by this point.
-		 */
-		if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
-			memcpy(req->iv, req_ctx->backup_info, ivsize);
-			kzfree(req_ctx->backup_info);
-		} else if (!err) {
-			len = req->cryptlen - ivsize;
-			scatterwalk_map_and_copy(req->iv, req->dst, len,
-						 ivsize, 0);
-		}
-		break;
-
-	case DRV_CIPHER_CTR:
-		/* Compute the counter of the last block */
-		len = ALIGN(req->cryptlen, AES_BLOCK_SIZE) / AES_BLOCK_SIZE;
-		cc_update_ctr((u8 *)req->iv, len);
-		break;
-
-	default:
-		break;
-	}
-
+	memcpy(req->iv, req_ctx->iv, ivsize);
 	kzfree(req_ctx->iv);
-
 	skcipher_request_complete(req, err);
 }
 
@@ -896,7 +903,9 @@ static int cc_cipher_process(struct skcipher_request *req,
 	/* Setup key */
 	cc_setup_key_desc(tfm, req_ctx, nbytes, desc, &seq_len);
 	/* Data processing */
-	cc_setup_flow_desc(tfm, req_ctx, dst, src, nbytes, req, desc, &seq_len);
+	cc_setup_flow_desc(tfm, req_ctx, dst, src, nbytes, desc, &seq_len);
+	/* Read next IV */
+	cc_setup_readiv_desc(tfm, req_ctx, ivsize, desc, &seq_len);
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
@@ -911,7 +920,6 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 exit_process:
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		kzfree(req_ctx->backup_info);
 		kzfree(req_ctx->iv);
 	}
 
@@ -929,31 +937,10 @@ static int cc_cipher_encrypt(struct skcipher_request *req)
 
 static int cc_cipher_decrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *sk_tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(sk_tfm);
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct cipher_req_ctx *req_ctx = skcipher_request_ctx(req);
-	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
-	gfp_t flags = cc_gfp_flags(&req->base);
-	unsigned int len;
 
 	memset(req_ctx, 0, sizeof(*req_ctx));
 
-	if ((ctx_p->cipher_mode == DRV_CIPHER_CBC) &&
-	    (req->cryptlen >= ivsize)) {
-
-		/* Allocate and save the last IV sized bytes of the source,
-		 * which will be lost in case of in-place decryption.
-		 */
-		req_ctx->backup_info = kzalloc(ivsize, flags);
-		if (!req_ctx->backup_info)
-			return -ENOMEM;
-
-		len = req->cryptlen - ivsize;
-		scatterwalk_map_and_copy(req_ctx->backup_info, req->src, len,
-					 ivsize, 0);
-	}
-
 	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 }
 
diff --git a/drivers/crypto/ccree/cc_cipher.h b/drivers/crypto/ccree/cc_cipher.h
index 4dbc0a1e6d5c..312d67f88414 100644
--- a/drivers/crypto/ccree/cc_cipher.h
+++ b/drivers/crypto/ccree/cc_cipher.h
@@ -20,7 +20,6 @@ struct cipher_req_ctx {
 	u32 in_mlli_nents;
 	u32 out_nents;
 	u32 out_mlli_nents;
-	u8 *backup_info; /*store iv for generated IV flow*/
 	u8 *iv;
 	struct mlli_params mlli_params;
 };
-- 
2.21.0

