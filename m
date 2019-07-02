Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B00EC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C5E121473
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfGBLjf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 07:39:35 -0400
Received: from foss.arm.com ([217.140.110.172]:48102 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfGBLje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 07:39:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A5D0CFC;
        Tue,  2 Jul 2019 04:39:33 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB8803F246;
        Tue,  2 Jul 2019 04:39:31 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] crypto: ccree: drop legacy ivgen support
Date:   Tue,  2 Jul 2019 14:39:18 +0300
Message-Id: <20190702113922.24911-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702113922.24911-1-gilad@benyossef.com>
References: <20190702113922.24911-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ccree had a mechanism for IV generation which was not compatible
with the Linux seqiv or echainiv iv generator and was never used
in any of the upstream versions so drop all the code implementing it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/Makefile         |   2 +-
 drivers/crypto/ccree/cc_aead.c        |  76 +------
 drivers/crypto/ccree/cc_aead.h        |   3 +-
 drivers/crypto/ccree/cc_driver.c      |  12 +-
 drivers/crypto/ccree/cc_driver.h      |  10 -
 drivers/crypto/ccree/cc_ivgen.c       | 276 --------------------------
 drivers/crypto/ccree/cc_ivgen.h       |  55 -----
 drivers/crypto/ccree/cc_pm.c          |   2 -
 drivers/crypto/ccree/cc_request_mgr.c |  47 +----
 9 files changed, 17 insertions(+), 466 deletions(-)
 delete mode 100644 drivers/crypto/ccree/cc_ivgen.c
 delete mode 100644 drivers/crypto/ccree/cc_ivgen.h

diff --git a/drivers/crypto/ccree/Makefile b/drivers/crypto/ccree/Makefile
index 145e50bdbf16..5cfda508ee41 100644
--- a/drivers/crypto/ccree/Makefile
+++ b/drivers/crypto/ccree/Makefile
@@ -2,7 +2,7 @@
 # Copyright (C) 2012-2019 ARM Limited (or its affiliates).
 
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_cipher.o cc_hash.o cc_aead.o cc_ivgen.o cc_sram_mgr.o
+ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_cipher.o cc_hash.o cc_aead.o cc_sram_mgr.o
 ccree-$(CONFIG_CRYPTO_FIPS) += cc_fips.o
 ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
 ccree-$(CONFIG_PM) += cc_pm.o
diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 83d1c8c45a1c..d69eee8b9a67 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -271,28 +271,13 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
 			err = -EBADMSG;
 		}
-	} else { /*ENCRYPT*/
-		if (areq_ctx->is_icv_fragmented) {
-			u32 skip = areq->cryptlen + areq_ctx->dst_offset;
-
-			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
-					   areq_ctx->dst_sgl, skip,
-					   (skip + ctx->authsize),
-					   CC_SG_FROM_BUF);
-		}
+	/*ENCRYPT*/
+	} else if (areq_ctx->is_icv_fragmented) {
+		u32 skip = areq->cryptlen + areq_ctx->dst_offset;
 
-		/* If an IV was generated, copy it back to the user provided
-		 * buffer.
-		 */
-		if (areq_ctx->backup_giv) {
-			if (ctx->cipher_mode == DRV_CIPHER_CTR)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv +
-				       CTR_RFC3686_NONCE_SIZE,
-				       CTR_RFC3686_IV_SIZE);
-			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv +
-				       CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
-		}
+		cc_copy_sg_portion(dev, areq_ctx->mac_buf, areq_ctx->dst_sgl,
+				   skip, (skip + ctx->authsize),
+				   CC_SG_FROM_BUF);
 	}
 done:
 	aead_request_complete(areq, err);
@@ -2007,9 +1992,8 @@ static int cc_proc_aead(struct aead_request *req,
 		 */
 		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce,
 		       CTR_RFC3686_NONCE_SIZE);
-		if (!areq_ctx->backup_giv) /*User none-generated IV*/
-			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
-			       req->iv, CTR_RFC3686_IV_SIZE);
+		memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, req->iv,
+		       CTR_RFC3686_IV_SIZE);
 		/* Initialize counter portion of counter block */
 		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
 			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
@@ -2055,40 +2039,6 @@ static int cc_proc_aead(struct aead_request *req,
 		goto exit;
 	}
 
-	/* do we need to generate IV? */
-	if (areq_ctx->backup_giv) {
-		/* set the DMA mapped IV address*/
-		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-			cc_req.ivgen_dma_addr[0] =
-				areq_ctx->gen_ctx.iv_dma_addr +
-				CTR_RFC3686_NONCE_SIZE;
-			cc_req.ivgen_dma_addr_len = 1;
-		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
-			/* In ccm, the IV needs to exist both inside B0 and
-			 * inside the counter.It is also copied to iv_dma_addr
-			 * for other reasons (like returning it to the user).
-			 * So, using 3 (identical) IV outputs.
-			 */
-			cc_req.ivgen_dma_addr[0] =
-				areq_ctx->gen_ctx.iv_dma_addr +
-				CCM_BLOCK_IV_OFFSET;
-			cc_req.ivgen_dma_addr[1] =
-				sg_dma_address(&areq_ctx->ccm_adata_sg) +
-				CCM_B0_OFFSET + CCM_BLOCK_IV_OFFSET;
-			cc_req.ivgen_dma_addr[2] =
-				sg_dma_address(&areq_ctx->ccm_adata_sg) +
-				CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
-			cc_req.ivgen_dma_addr_len = 3;
-		} else {
-			cc_req.ivgen_dma_addr[0] =
-				areq_ctx->gen_ctx.iv_dma_addr;
-			cc_req.ivgen_dma_addr_len = 1;
-		}
-
-		/* set the IV size (8/16 B long)*/
-		cc_req.ivgen_size = crypto_aead_ivsize(tfm);
-	}
-
 	/* STAT_PHASE_2: Create sequence */
 
 	/* Load MLLI tables to SRAM if necessary */
@@ -2139,7 +2089,6 @@ static int cc_aead_encrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = false;
 
 	areq_ctx->plaintext_authenticate_only = false;
@@ -2171,7 +2120,6 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = true;
 
 	cc_proc_rfc4309_ccm(req);
@@ -2193,7 +2141,6 @@ static int cc_aead_decrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = false;
 
 	areq_ctx->plaintext_authenticate_only = false;
@@ -2223,7 +2170,6 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->is_gcm4543 = true;
 	cc_proc_rfc4309_ccm(req);
@@ -2343,8 +2289,6 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
-
 	areq_ctx->plaintext_authenticate_only = false;
 
 	cc_proc_rfc4_gcm(req);
@@ -2372,7 +2316,6 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
 
 	cc_proc_rfc4_gcm(req);
 	areq_ctx->is_gcm4543 = true;
@@ -2404,8 +2347,6 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
-
 	areq_ctx->plaintext_authenticate_only = false;
 
 	cc_proc_rfc4_gcm(req);
@@ -2433,7 +2374,6 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->assoclen = req->assoclen;
-	areq_ctx->backup_giv = NULL;
 
 	cc_proc_rfc4_gcm(req);
 	areq_ctx->is_gcm4543 = true;
diff --git a/drivers/crypto/ccree/cc_aead.h b/drivers/crypto/ccree/cc_aead.h
index e51724b96c56..f12169b57f9d 100644
--- a/drivers/crypto/ccree/cc_aead.h
+++ b/drivers/crypto/ccree/cc_aead.h
@@ -65,8 +65,7 @@ struct aead_req_ctx {
 	unsigned int hw_iv_size ____cacheline_aligned;
 	/* used to prevent cache coherence problem */
 	u8 backup_mac[MAX_MAC_SIZE];
-	u8 *backup_iv; /*store iv for generated IV flow*/
-	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
+	u8 *backup_iv; /* store orig iv */
 	u32 assoclen; /* internal assoclen */
 	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
 	/* buffer for internal ccm configurations */
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 980aa04b655b..330650a3e023 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -22,7 +22,6 @@
 #include "cc_cipher.h"
 #include "cc_aead.h"
 #include "cc_hash.h"
-#include "cc_ivgen.h"
 #include "cc_sram_mgr.h"
 #include "cc_pm.h"
 #include "cc_fips.h"
@@ -503,17 +502,11 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_buf_mgr_err;
 	}
 
-	rc = cc_ivgen_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_ivgen_init failed\n");
-		goto post_buf_mgr_err;
-	}
-
 	/* Allocate crypto algs */
 	rc = cc_cipher_alloc(new_drvdata);
 	if (rc) {
 		dev_err(dev, "cc_cipher_alloc failed\n");
-		goto post_ivgen_err;
+		goto post_buf_mgr_err;
 	}
 
 	/* hash must be allocated before aead since hash exports APIs */
@@ -544,8 +537,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_hash_free(new_drvdata);
 post_cipher_err:
 	cc_cipher_free(new_drvdata);
-post_ivgen_err:
-	cc_ivgen_fini(new_drvdata);
 post_buf_mgr_err:
 	 cc_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
@@ -577,7 +568,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_aead_free(drvdata);
 	cc_hash_free(drvdata);
 	cc_cipher_free(drvdata);
-	cc_ivgen_fini(drvdata);
 	cc_pm_fini(drvdata);
 	cc_buffer_mgr_fini(drvdata);
 	cc_req_mgr_fini(drvdata);
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 6448b2b9794b..01724f40f626 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -131,15 +131,6 @@ struct cc_cpp_req {
 struct cc_crypto_req {
 	void (*user_cb)(struct device *dev, void *req, int err);
 	void *user_arg;
-	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
-	/* For the first 'ivgen_dma_addr_len' addresses of this array,
-	 * generated IV would be placed in it by send_request().
-	 * Same generated IV for all addresses!
-	 */
-	/* Amount of 'ivgen_dma_addr' elements to be filled. */
-	unsigned int ivgen_dma_addr_len;
-	/* The generated IV size required, 8/16 B allowed. */
-	unsigned int ivgen_size;
 	struct completion seq_compl; /* request completion */
 	struct cc_cpp_req cpp;
 };
@@ -163,7 +154,6 @@ struct cc_drvdata {
 	void *aead_handle;
 	void *request_mgr_handle;
 	void *fips_handle;
-	void *ivgen_handle;
 	void *sram_mgr_handle;
 	void *debugfs;
 	struct clk *clk;
diff --git a/drivers/crypto/ccree/cc_ivgen.c b/drivers/crypto/ccree/cc_ivgen.c
deleted file mode 100644
index 99dc69383e20..000000000000
--- a/drivers/crypto/ccree/cc_ivgen.c
+++ /dev/null
@@ -1,276 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
-
-#include <crypto/ctr.h>
-#include "cc_driver.h"
-#include "cc_ivgen.h"
-#include "cc_request_mgr.h"
-#include "cc_sram_mgr.h"
-#include "cc_buffer_mgr.h"
-
-/* The max. size of pool *MUST* be <= SRAM total size */
-#define CC_IVPOOL_SIZE 1024
-/* The first 32B fraction of pool are dedicated to the
- * next encryption "key" & "IV" for pool regeneration
- */
-#define CC_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
-#define CC_IVPOOL_GEN_SEQ_LEN	4
-
-/**
- * struct cc_ivgen_ctx -IV pool generation context
- * @pool:          the start address of the iv-pool resides in internal RAM
- * @ctr_key_dma:   address of pool's encryption key material in internal RAM
- * @ctr_iv_dma:    address of pool's counter iv in internal RAM
- * @next_iv_ofs:   the offset to the next available IV in pool
- * @pool_meta:     virt. address of the initial enc. key/IV
- * @pool_meta_dma: phys. address of the initial enc. key/IV
- */
-struct cc_ivgen_ctx {
-	cc_sram_addr_t pool;
-	cc_sram_addr_t ctr_key;
-	cc_sram_addr_t ctr_iv;
-	u32 next_iv_ofs;
-	u8 *pool_meta;
-	dma_addr_t pool_meta_dma;
-};
-
-/*!
- * Generates CC_IVPOOL_SIZE of random bytes by
- * encrypting 0's using AES128-CTR.
- *
- * \param ivgen iv-pool context
- * \param iv_seq IN/OUT array to the descriptors sequence
- * \param iv_seq_len IN/OUT pointer to the sequence length
- */
-static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
-			  struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
-{
-	unsigned int idx = *iv_seq_len;
-
-	if ((*iv_seq_len + CC_IVPOOL_GEN_SEQ_LEN) > CC_IVPOOL_SEQ_LEN) {
-		/* The sequence will be longer than allowed */
-		return -EINVAL;
-	}
-	/* Setup key */
-	hw_desc_init(&iv_seq[idx]);
-	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_key, AES_KEYSIZE_128);
-	set_setup_mode(&iv_seq[idx], SETUP_LOAD_KEY0);
-	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
-	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
-	idx++;
-
-	/* Setup cipher state */
-	hw_desc_init(&iv_seq[idx]);
-	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_iv, CC_AES_IV_SIZE);
-	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
-	set_setup_mode(&iv_seq[idx], SETUP_LOAD_STATE1);
-	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
-	idx++;
-
-	/* Perform dummy encrypt to skip first block */
-	hw_desc_init(&iv_seq[idx]);
-	set_din_const(&iv_seq[idx], 0, CC_AES_IV_SIZE);
-	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_AES_IV_SIZE);
-	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
-	idx++;
-
-	/* Generate IV pool */
-	hw_desc_init(&iv_seq[idx]);
-	set_din_const(&iv_seq[idx], 0, CC_IVPOOL_SIZE);
-	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_IVPOOL_SIZE);
-	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
-	idx++;
-
-	*iv_seq_len = idx; /* Update sequence length */
-
-	/* queue ordering assures pool readiness */
-	ivgen_ctx->next_iv_ofs = CC_IVPOOL_META_SIZE;
-
-	return 0;
-}
-
-/*!
- * Generates the initial pool in SRAM.
- * This function should be invoked when resuming driver.
- *
- * \param drvdata
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_init_iv_sram(struct cc_drvdata *drvdata)
-{
-	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
-	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
-	unsigned int iv_seq_len = 0;
-	int rc;
-
-	/* Generate initial enc. key/iv */
-	get_random_bytes(ivgen_ctx->pool_meta, CC_IVPOOL_META_SIZE);
-
-	/* The first 32B reserved for the enc. Key/IV */
-	ivgen_ctx->ctr_key = ivgen_ctx->pool;
-	ivgen_ctx->ctr_iv = ivgen_ctx->pool + AES_KEYSIZE_128;
-
-	/* Copy initial enc. key and IV to SRAM at a single descriptor */
-	hw_desc_init(&iv_seq[iv_seq_len]);
-	set_din_type(&iv_seq[iv_seq_len], DMA_DLLI, ivgen_ctx->pool_meta_dma,
-		     CC_IVPOOL_META_SIZE, NS_BIT);
-	set_dout_sram(&iv_seq[iv_seq_len], ivgen_ctx->pool,
-		      CC_IVPOOL_META_SIZE);
-	set_flow_mode(&iv_seq[iv_seq_len], BYPASS);
-	iv_seq_len++;
-
-	/* Generate initial pool */
-	rc = cc_gen_iv_pool(ivgen_ctx, iv_seq, &iv_seq_len);
-	if (rc)
-		return rc;
-
-	/* Fire-and-forget */
-	return send_request_init(drvdata, iv_seq, iv_seq_len);
-}
-
-/*!
- * Free iv-pool and ivgen context.
- *
- * \param drvdata
- */
-void cc_ivgen_fini(struct cc_drvdata *drvdata)
-{
-	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
-	struct device *device = &drvdata->plat_dev->dev;
-
-	if (!ivgen_ctx)
-		return;
-
-	if (ivgen_ctx->pool_meta) {
-		memset(ivgen_ctx->pool_meta, 0, CC_IVPOOL_META_SIZE);
-		dma_free_coherent(device, CC_IVPOOL_META_SIZE,
-				  ivgen_ctx->pool_meta,
-				  ivgen_ctx->pool_meta_dma);
-	}
-
-	ivgen_ctx->pool = NULL_SRAM_ADDR;
-}
-
-/*!
- * Allocates iv-pool and maps resources.
- * This function generates the first IV pool.
- *
- * \param drvdata Driver's private context
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_ivgen_init(struct cc_drvdata *drvdata)
-{
-	struct cc_ivgen_ctx *ivgen_ctx;
-	struct device *device = &drvdata->plat_dev->dev;
-	int rc;
-
-	/* Allocate "this" context */
-	ivgen_ctx = devm_kzalloc(device, sizeof(*ivgen_ctx), GFP_KERNEL);
-	if (!ivgen_ctx)
-		return -ENOMEM;
-
-	drvdata->ivgen_handle = ivgen_ctx;
-
-	/* Allocate pool's header for initial enc. key/IV */
-	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
-						  &ivgen_ctx->pool_meta_dma,
-						  GFP_KERNEL);
-	if (!ivgen_ctx->pool_meta) {
-		dev_err(device, "Not enough memory to allocate DMA of pool_meta (%u B)\n",
-			CC_IVPOOL_META_SIZE);
-		rc = -ENOMEM;
-		goto out;
-	}
-	/* Allocate IV pool in SRAM */
-	ivgen_ctx->pool = cc_sram_alloc(drvdata, CC_IVPOOL_SIZE);
-	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
-		dev_err(device, "SRAM pool exhausted\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	return cc_init_iv_sram(drvdata);
-
-out:
-	cc_ivgen_fini(drvdata);
-	return rc;
-}
-
-/*!
- * Acquires 16 Bytes IV from the iv-pool
- *
- * \param drvdata Driver private context
- * \param iv_out_dma Array of physical IV out addresses
- * \param iv_out_dma_len Length of iv_out_dma array (additional elements
- *                       of iv_out_dma array are ignore)
- * \param iv_out_size May be 8 or 16 bytes long
- * \param iv_seq IN/OUT array to the descriptors sequence
- * \param iv_seq_len IN/OUT pointer to the sequence length
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
-	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
-	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
-{
-	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
-	unsigned int idx = *iv_seq_len;
-	struct device *dev = drvdata_to_dev(drvdata);
-	unsigned int t;
-
-	if (iv_out_size != CC_AES_IV_SIZE &&
-	    iv_out_size != CTR_RFC3686_IV_SIZE) {
-		return -EINVAL;
-	}
-	if ((iv_out_dma_len + 1) > CC_IVPOOL_SEQ_LEN) {
-		/* The sequence will be longer than allowed */
-		return -EINVAL;
-	}
-
-	/* check that number of generated IV is limited to max dma address
-	 * iv buffer size
-	 */
-	if (iv_out_dma_len > CC_MAX_IVGEN_DMA_ADDRESSES) {
-		/* The sequence will be longer than allowed */
-		return -EINVAL;
-	}
-
-	for (t = 0; t < iv_out_dma_len; t++) {
-		/* Acquire IV from pool */
-		hw_desc_init(&iv_seq[idx]);
-		set_din_sram(&iv_seq[idx], (ivgen_ctx->pool +
-					    ivgen_ctx->next_iv_ofs),
-			     iv_out_size);
-		set_dout_dlli(&iv_seq[idx], iv_out_dma[t], iv_out_size,
-			      NS_BIT, 0);
-		set_flow_mode(&iv_seq[idx], BYPASS);
-		idx++;
-	}
-
-	/* Bypass operation is proceeded by crypto sequence, hence must
-	 *  assure bypass-write-transaction by a memory barrier
-	 */
-	hw_desc_init(&iv_seq[idx]);
-	set_din_no_dma(&iv_seq[idx], 0, 0xfffff0);
-	set_dout_no_dma(&iv_seq[idx], 0, 0, 1);
-	idx++;
-
-	*iv_seq_len = idx; /* update seq length */
-
-	/* Update iv index */
-	ivgen_ctx->next_iv_ofs += iv_out_size;
-
-	if ((CC_IVPOOL_SIZE - ivgen_ctx->next_iv_ofs) < CC_AES_IV_SIZE) {
-		dev_dbg(dev, "Pool exhausted, regenerating iv-pool\n");
-		/* pool is drained -regenerate it! */
-		return cc_gen_iv_pool(ivgen_ctx, iv_seq, iv_seq_len);
-	}
-
-	return 0;
-}
diff --git a/drivers/crypto/ccree/cc_ivgen.h b/drivers/crypto/ccree/cc_ivgen.h
deleted file mode 100644
index a9f5e8bba4f1..000000000000
--- a/drivers/crypto/ccree/cc_ivgen.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
-
-#ifndef __CC_IVGEN_H__
-#define __CC_IVGEN_H__
-
-#include "cc_hw_queue_defs.h"
-
-#define CC_IVPOOL_SEQ_LEN 8
-
-/*!
- * Allocates iv-pool and maps resources.
- * This function generates the first IV pool.
- *
- * \param drvdata Driver's private context
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_ivgen_init(struct cc_drvdata *drvdata);
-
-/*!
- * Free iv-pool and ivgen context.
- *
- * \param drvdata
- */
-void cc_ivgen_fini(struct cc_drvdata *drvdata);
-
-/*!
- * Generates the initial pool in SRAM.
- * This function should be invoked when resuming DX driver.
- *
- * \param drvdata
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_init_iv_sram(struct cc_drvdata *drvdata);
-
-/*!
- * Acquires 16 Bytes IV from the iv-pool
- *
- * \param drvdata Driver private context
- * \param iv_out_dma Array of physical IV out addresses
- * \param iv_out_dma_len Length of iv_out_dma array (additional elements of
- *                       iv_out_dma array are ignore)
- * \param iv_out_size May be 8 or 16 bytes long
- * \param iv_seq IN/OUT array to the descriptors sequence
- * \param iv_seq_len IN/OUT pointer to the sequence length
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
-	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
-	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len);
-
-#endif /*__CC_IVGEN_H__*/
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 899a52f05b7a..dbc508fb719b 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -8,7 +8,6 @@
 #include "cc_buffer_mgr.h"
 #include "cc_request_mgr.h"
 #include "cc_sram_mgr.h"
-#include "cc_ivgen.h"
 #include "cc_hash.h"
 #include "cc_pm.h"
 #include "cc_fips.h"
@@ -73,7 +72,6 @@ int cc_pm_resume(struct device *dev)
 	/* must be after the queue resuming as it uses the HW queue*/
 	cc_init_hash_sram(drvdata);
 
-	cc_init_iv_sram(drvdata);
 	return 0;
 }
 
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 0bc6ccb0b899..a947d5a2cf35 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -6,7 +6,6 @@
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
 #include "cc_request_mgr.h"
-#include "cc_ivgen.h"
 #include "cc_pm.h"
 
 #define CC_MAX_POLL_ITER	10
@@ -281,36 +280,12 @@ static int cc_queues_status(struct cc_drvdata *drvdata,
 static int cc_do_send_request(struct cc_drvdata *drvdata,
 			      struct cc_crypto_req *cc_req,
 			      struct cc_hw_desc *desc, unsigned int len,
-				bool add_comp, bool ivgen)
+				bool add_comp)
 {
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int used_sw_slots;
-	unsigned int iv_seq_len = 0;
 	unsigned int total_seq_len = len; /*initial sequence length*/
-	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
 	struct device *dev = drvdata_to_dev(drvdata);
-	int rc;
-
-	if (ivgen) {
-		dev_dbg(dev, "Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
-			cc_req->ivgen_dma_addr_len,
-			&cc_req->ivgen_dma_addr[0],
-			&cc_req->ivgen_dma_addr[1],
-			&cc_req->ivgen_dma_addr[2],
-			cc_req->ivgen_size);
-
-		/* Acquire IV from pool */
-		rc = cc_get_iv(drvdata, cc_req->ivgen_dma_addr,
-			       cc_req->ivgen_dma_addr_len,
-			       cc_req->ivgen_size, iv_seq, &iv_seq_len);
-
-		if (rc) {
-			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
-			return rc;
-		}
-
-		total_seq_len += iv_seq_len;
-	}
 
 	used_sw_slots = ((req_mgr_h->req_queue_head -
 			  req_mgr_h->req_queue_tail) &
@@ -334,8 +309,6 @@ static int cc_do_send_request(struct cc_drvdata *drvdata,
 	wmb();
 
 	/* STAT_PHASE_4: Push sequence */
-	if (ivgen)
-		enqueue_seq(drvdata, iv_seq, iv_seq_len);
 
 	enqueue_seq(drvdata, desc, len);
 
@@ -380,8 +353,6 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 	struct cc_bl_item *bli;
 	struct cc_crypto_req *creq;
 	void *req;
-	bool ivgen;
-	unsigned int total_len;
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc;
 
@@ -406,12 +377,9 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 			bli->notif = true;
 		}
 
-		ivgen = !!creq->ivgen_dma_addr_len;
-		total_len = bli->len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
-
 		spin_lock(&mgr->hw_lock);
 
-		rc = cc_queues_status(drvdata, mgr, total_len);
+		rc = cc_queues_status(drvdata, mgr, bli->len);
 		if (rc) {
 			/*
 			 * There is still not room in the FIFO for
@@ -423,7 +391,7 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 		}
 
 		rc = cc_do_send_request(drvdata, &bli->creq, bli->desc,
-					bli->len, false, ivgen);
+					bli->len, false);
 
 		spin_unlock(&mgr->hw_lock);
 
@@ -447,8 +415,6 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 {
 	int rc;
 	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
-	bool ivgen = !!cc_req->ivgen_dma_addr_len;
-	unsigned int total_len = len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
 	struct device *dev = drvdata_to_dev(drvdata);
 	bool backlog_ok = req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG;
 	gfp_t flags = cc_gfp_flags(req);
@@ -461,7 +427,7 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	}
 
 	spin_lock_bh(&mgr->hw_lock);
-	rc = cc_queues_status(drvdata, mgr, total_len);
+	rc = cc_queues_status(drvdata, mgr, len);
 
 #ifdef CC_DEBUG_FORCE_BACKLOG
 	if (backlog_ok)
@@ -486,8 +452,7 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	}
 
 	if (!rc)
-		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
-					ivgen);
+		rc = cc_do_send_request(drvdata, cc_req, desc, len, false);
 
 	spin_unlock_bh(&mgr->hw_lock);
 	return rc;
@@ -527,7 +492,7 @@ int cc_send_sync_request(struct cc_drvdata *drvdata,
 		reinit_completion(&drvdata->hw_queue_avail);
 	}
 
-	rc = cc_do_send_request(drvdata, cc_req, desc, len, true, false);
+	rc = cc_do_send_request(drvdata, cc_req, desc, len, true);
 	spin_unlock_bh(&mgr->hw_lock);
 
 	if (rc != -EINPROGRESS) {
-- 
2.21.0

