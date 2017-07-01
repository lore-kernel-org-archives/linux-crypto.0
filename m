From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 03/10] staging: ccree: Fix alignment issues in ssi_cipher.c
Date: Sun,  2 Jul 2017 01:25:48 +0200
Message-ID: <20170701232555.5538-4-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35609 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbdGAX0b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:31 -0400
Received: by mail-lf0-f50.google.com with SMTP id b207so86272756lfg.2
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:30 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_cipher.c | 75 +++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index cd2eafc04232..f217e1ab1b08 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -92,8 +92,7 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 			break;
 		}
 	case S_DIN_to_DES:
-		if (likely(size == DES3_EDE_KEY_SIZE ||
-		    size == DES_KEY_SIZE))
+		if (likely(size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE))
 			return 0;
 		break;
 #if SSI_CC_HAS_MULTI2
@@ -183,8 +182,8 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	int rc = 0;
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
-	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx_p,
-						crypto_tfm_alg_name(tfm));
+	SSI_LOG_DEBUG("Initializing context @%p for %s\n",
+		      ctx_p, crypto_tfm_alg_name(tfm));
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	ctx_p->cipher_mode = ssi_alg->cipher_mode;
@@ -206,12 +205,12 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 					     max_key_buf_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
 		SSI_LOG_ERR("Mapping Key %u B at va=%pK for DMA failed\n",
-			max_key_buf_size, ctx_p->user.key);
+			    max_key_buf_size, ctx_p->user.key);
 		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=0x%llX\n",
-		max_key_buf_size, ctx_p->user.key,
-		(unsigned long long)ctx_p->user.key_dma_addr);
+		      max_key_buf_size, ctx_p->user.key,
+		      (unsigned long long)ctx_p->user.key_dma_addr);
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 		/* Alloc hash tfm for essiv */
@@ -232,7 +231,7 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
 	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
-		crypto_tfm_ctx(tfm), crypto_tfm_alg_name(tfm));
+		      crypto_tfm_ctx(tfm), crypto_tfm_alg_name(tfm));
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 		/* Free hash tfm for essiv */
@@ -242,9 +241,9 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 
 	/* Unmap key buffer */
 	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
-								DMA_TO_DEVICE);
+			 DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=0x%llX\n",
-		(unsigned long long)ctx_p->user.key_dma_addr);
+		      (unsigned long long)ctx_p->user.key_dma_addr);
 
 	/* Free key buffer in context */
 	kfree(ctx_p->user.key);
@@ -270,7 +269,7 @@ static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
 
 	/* verify key1 != key2 and key3 != key2*/
 	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
-		      (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
+		     (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
 		return -ENOEXEC;
 	}
 #endif /* CCREE_FIPS_SUPPORT */
@@ -317,7 +316,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
 	SSI_LOG_DEBUG("Setting key in context @%p for %s. keylen=%u\n",
-		ctx_p, crypto_tfm_alg_name(tfm), keylen);
+		      ctx_p, crypto_tfm_alg_name(tfm), keylen);
 	dump_byte_array("key", (u8 *)key, keylen);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
@@ -396,7 +395,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 	/* STAT_PHASE_1: Copy key to ctx */
 	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
-					max_key_buf_size, DMA_TO_DEVICE);
+				max_key_buf_size, DMA_TO_DEVICE);
 
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
 #if SSI_CC_HAS_MULTI2
@@ -429,7 +428,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		}
 	}
 	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
-					max_key_buf_size, DMA_TO_DEVICE);
+				   max_key_buf_size, DMA_TO_DEVICE);
 	ctx_p->keylen = keylen;
 
 	 SSI_LOG_DEBUG("ssi_blkcipher_setkey: return safely");
@@ -638,11 +637,9 @@ ssi_blkcipher_create_data_desc(
 	/* Process */
 	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
 		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
-			     (unsigned long long)sg_dma_address(src),
-			     nbytes);
+			      (unsigned long long)sg_dma_address(src), nbytes);
 		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
-			     (unsigned long long)sg_dma_address(dst),
-			     nbytes);
+			      (unsigned long long)sg_dma_address(dst), nbytes);
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
 			     nbytes, NS_BIT);
@@ -706,13 +703,13 @@ ssi_blkcipher_create_data_desc(
 }
 
 static int ssi_blkcipher_complete(struct device *dev,
-				struct ssi_ablkcipher_ctx *ctx_p,
-				struct blkcipher_req_ctx *req_ctx,
-				struct scatterlist *dst,
-				struct scatterlist *src,
-				unsigned int ivsize,
-				void *areq,
-				void __iomem *cc_base)
+				  struct ssi_ablkcipher_ctx *ctx_p,
+				  struct blkcipher_req_ctx *req_ctx,
+				  struct scatterlist *dst,
+				  struct scatterlist *src,
+				  unsigned int ivsize,
+				  void *areq,
+				  void __iomem *cc_base)
 {
 	int completion_error = 0;
 	u32 inflight_counter;
@@ -749,8 +746,8 @@ static int ssi_blkcipher_process(
 	int rc, seq_len = 0, cts_restore_flag = 0;
 
 	SSI_LOG_DEBUG("%s areq=%p info=%p nbytes=%d\n",
-		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"),
-		     areq, info, nbytes);
+		      ((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"),
+		      areq, info, nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* STAT_PHASE_0: Init and sanity checks */
@@ -804,12 +801,8 @@ static int ssi_blkcipher_process(
 		ssi_blkcipher_create_setup_desc(tfm, req_ctx, ivsize, nbytes,
 						desc, &seq_len);
 	/* Data processing */
-	ssi_blkcipher_create_data_desc(tfm,
-			      req_ctx,
-			      dst, src,
-			      nbytes,
-			      areq,
-			      desc, &seq_len);
+	ssi_blkcipher_create_data_desc(tfm, req_ctx, dst, src, nbytes, areq,
+				       desc, &seq_len);
 
 	/* do we need to generate IV? */
 	if (req_ctx->is_giv) {
@@ -871,8 +864,8 @@ static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
 }
 
 static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
-				const u8 *key,
-				unsigned int keylen)
+				 const u8 *key,
+				 unsigned int keylen)
 {
 	return ssi_blkcipher_setkey(crypto_ablkcipher_tfm(tfm), key, keylen);
 }
@@ -1286,7 +1279,7 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	if (blkcipher_handle) {
 		/* Remove registered algs */
 		list_for_each_entry_safe(t_alg, n,
-				&blkcipher_handle->blkcipher_alg_list,
+					 &blkcipher_handle->blkcipher_alg_list,
 					 entry) {
 			crypto_unregister_alg(&t_alg->crypto_alg);
 			list_del(&t_alg->entry);
@@ -1306,7 +1299,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 	int alg;
 
 	ablkcipher_handle = kmalloc(sizeof(struct ssi_blkcipher_handle),
-		GFP_KERNEL);
+				    GFP_KERNEL);
 	if (!ablkcipher_handle)
 		return -ENOMEM;
 
@@ -1322,7 +1315,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			SSI_LOG_ERR("%s alg allocation failed\n",
-				 blkcipher_algs[alg].driver_name);
+				    blkcipher_algs[alg].driver_name);
 			goto fail0;
 		}
 		t_alg->drvdata = drvdata;
@@ -1330,17 +1323,17 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 		SSI_LOG_DEBUG("registering %s\n", blkcipher_algs[alg].driver_name);
 		rc = crypto_register_alg(&t_alg->crypto_alg);
 		SSI_LOG_DEBUG("%s alg registration rc = %x\n",
-			t_alg->crypto_alg.cra_driver_name, rc);
+			      t_alg->crypto_alg.cra_driver_name, rc);
 		if (unlikely(rc != 0)) {
 			SSI_LOG_ERR("%s alg registration failed\n",
-				t_alg->crypto_alg.cra_driver_name);
+				    t_alg->crypto_alg.cra_driver_name);
 			kfree(t_alg);
 			goto fail0;
 		} else {
 			list_add_tail(&t_alg->entry,
 				      &ablkcipher_handle->blkcipher_alg_list);
 			SSI_LOG_DEBUG("Registered %s\n",
-					t_alg->crypto_alg.cra_driver_name);
+				      t_alg->crypto_alg.cra_driver_name);
 		}
 	}
 	return 0;
-- 
2.11.0
