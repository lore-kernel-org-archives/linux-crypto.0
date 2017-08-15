From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 09/22] staging: ccree: Fix format/argument mismatches
Date: Tue, 15 Aug 2017 09:26:37 +0300
Message-ID: <1502778412-16255-10-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Joe Perches <joe@perches.com>

By default, debug logging is disabled by CC_DEBUG not being defined.

Convert SSI_LOG_DEBUG to use no_printk instead of an empty define
to validate formats and arguments.

Fix fallout.

Miscellanea:

o One of the conversions now uses %pR instead of multiple uses of %pad

Signed-off-by: Joe Perches <joe@perches.com>
[ gby: rebase on top of latest changes ]
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  8 ++++----
 drivers/staging/ccree/ssi_buffer_mgr.c  | 29 +++++++++++++---------------
 drivers/staging/ccree/ssi_cipher.c      | 10 +++++-----
 drivers/staging/ccree/ssi_driver.c      | 10 ++++------
 drivers/staging/ccree/ssi_driver.h      |  2 +-
 drivers/staging/ccree/ssi_hash.c        | 34 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_request_mgr.c |  6 +++---
 7 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 66eedbe..03533c8 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -103,7 +103,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	if (ctx->enckey) {
 		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
 		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=%pad\n",
-			      ctx->enckey_dma_addr);
+			      &ctx->enckey_dma_addr);
 		ctx->enckey_dma_addr = 0;
 		ctx->enckey = NULL;
 	}
@@ -117,7 +117,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 					  xcbc->xcbc_keys_dma_addr);
 		}
 		SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
-			      xcbc->xcbc_keys_dma_addr);
+			      &xcbc->xcbc_keys_dma_addr);
 		xcbc->xcbc_keys_dma_addr = 0;
 		xcbc->xcbc_keys = NULL;
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
@@ -128,7 +128,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 					  hmac->ipad_opad,
 					  hmac->ipad_opad_dma_addr);
 			SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
-				      hmac->ipad_opad_dma_addr);
+				      &hmac->ipad_opad_dma_addr);
 			hmac->ipad_opad_dma_addr = 0;
 			hmac->ipad_opad = NULL;
 		}
@@ -137,7 +137,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 					  hmac->padded_authkey,
 					  hmac->padded_authkey_dma_addr);
 			SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
-				      hmac->padded_authkey_dma_addr);
+				      &hmac->padded_authkey_dma_addr);
 			hmac->padded_authkey_dma_addr = 0;
 			hmac->padded_authkey = NULL;
 		}
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index d7ce293..0b81fd5 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -14,6 +14,7 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/version.h>
 #include <crypto/algapi.h>
@@ -33,14 +34,10 @@
 #include "ssi_hash.h"
 #include "ssi_aead.h"
 
-#ifdef CC_DEBUG
 #define GET_DMA_BUFFER_TYPE(buff_type) ( \
 	((buff_type) == SSI_DMA_BUF_NULL) ? "BUF_NULL" : \
 	((buff_type) == SSI_DMA_BUF_DLLI) ? "BUF_DLLI" : \
 	((buff_type) == SSI_DMA_BUF_MLLI) ? "BUF_MLLI" : "BUF_INVALID")
-#else
-#define GET_DMA_BUFFER_TYPE(buff_type)
-#endif
 
 enum dma_buffer_type {
 	DMA_NULL_TYPE = -1,
@@ -260,7 +257,7 @@ static int ssi_buffer_mgr_generate_mlli(
 	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
 
 	SSI_LOG_DEBUG("MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
-		      mlli_params->mlli_virt_addr, mlli_params->mlli_dma_addr,
+		      mlli_params->mlli_virt_addr, &mlli_params->mlli_dma_addr,
 		      mlli_params->mlli_len);
 
 build_mlli_exit:
@@ -275,7 +272,7 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
 	unsigned int index = sgl_data->num_of_buffers;
 
 	SSI_LOG_DEBUG("index=%u single_buff=%pad buffer_len=0x%08X is_last=%d\n",
-		      index, buffer_dma, buffer_len, is_last_entry);
+		      index, &buffer_dma, buffer_len, is_last_entry);
 	sgl_data->nents[index] = 1;
 	sgl_data->entry[index].buffer_dma = buffer_dma;
 	sgl_data->offset[index] = 0;
@@ -358,7 +355,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 		}
 		SSI_LOG_DEBUG("Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u "
 			     "length=%u\n",
-			     sg_dma_address(sg),
+			     &sg_dma_address(sg),
 			     sg_page(sg),
 			     sg_virt(sg),
 			     sg->offset, sg->length);
@@ -420,7 +417,7 @@ ssi_aead_handle_config_buf(struct device *dev,
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK "
 		     "offset=%u length=%u\n",
-		     sg_dma_address(&areq_ctx->ccm_adata_sg),
+		     &sg_dma_address(&areq_ctx->ccm_adata_sg),
 		     sg_page(&areq_ctx->ccm_adata_sg),
 		     sg_virt(&areq_ctx->ccm_adata_sg),
 		     areq_ctx->ccm_adata_sg.offset,
@@ -451,7 +448,7 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK "
 		     "offset=%u length=%u\n",
-		     sg_dma_address(areq_ctx->buff_sg),
+		     &sg_dma_address(areq_ctx->buff_sg),
 		     sg_page(areq_ctx->buff_sg),
 		     sg_virt(areq_ctx->buff_sg),
 		     areq_ctx->buff_sg->offset,
@@ -476,7 +473,7 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 
 	if (likely(req_ctx->gen_ctx.iv_dma_addr != 0)) {
 		SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
-			      req_ctx->gen_ctx.iv_dma_addr,
+			      &req_ctx->gen_ctx.iv_dma_addr,
 			      ivsize);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
 				 ivsize,
@@ -537,7 +534,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 		}
 		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
 			      ivsize, info,
-			      req_ctx->gen_ctx.iv_dma_addr);
+			      &req_ctx->gen_ctx.iv_dma_addr);
 	} else {
 		req_ctx->gen_ctx.iv_dma_addr = 0;
 	}
@@ -667,7 +664,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=%pad virt=%pK\n",
-			      areq_ctx->mlli_params.mlli_dma_addr,
+			      &areq_ctx->mlli_params.mlli_dma_addr,
 			      areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
@@ -786,7 +783,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 
 	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
 		      hw_iv_size, req->iv,
-		      areq_ctx->gen_ctx.iv_dma_addr);
+		      &areq_ctx->gen_ctx.iv_dma_addr);
 	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
@@ -1711,7 +1708,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=%pad virt=%pK\n",
-			      areq_ctx->mlli_params.mlli_dma_addr,
+			      &areq_ctx->mlli_params.mlli_dma_addr,
 			      areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
@@ -1721,7 +1718,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 	if ((src) && likely(areq_ctx->in_nents != 0)) {
 		SSI_LOG_DEBUG("Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
 			      sg_virt(src),
-			      sg_dma_address(src),
+			      &sg_dma_address(src),
 			      sg_dma_len(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
@@ -1730,7 +1727,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 	if (*prev_len != 0) {
 		SSI_LOG_DEBUG("Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
 			      sg_virt(areq_ctx->buff_sg),
-			      sg_dma_address(areq_ctx->buff_sg),
+			      &sg_dma_address(areq_ctx->buff_sg),
 			      sg_dma_len(areq_ctx->buff_sg));
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 		if (!do_revert) {
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 712b21d..8d65e97 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -212,7 +212,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	}
 	SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=%pad\n",
 		      max_key_buf_size, ctx_p->user.key,
-		      ctx_p->user.key_dma_addr);
+		      &ctx_p->user.key_dma_addr);
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 		/* Alloc hash tfm for essiv */
@@ -245,7 +245,7 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
 			 DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=%pad\n",
-		      ctx_p->user.key_dma_addr);
+		      &ctx_p->user.key_dma_addr);
 
 	/* Free key buffer in context */
 	kfree(ctx_p->user.key);
@@ -621,9 +621,9 @@ ssi_blkcipher_create_data_desc(
 	/* Process */
 	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
 		SSI_LOG_DEBUG(" data params addr %pad length 0x%X\n",
-			      sg_dma_address(src), nbytes);
+			      &sg_dma_address(src), nbytes);
 		SSI_LOG_DEBUG(" data params addr %pad length 0x%X\n",
-			      sg_dma_address(dst), nbytes);
+			      &sg_dma_address(dst), nbytes);
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
 			     nbytes, NS_BIT);
@@ -637,7 +637,7 @@ ssi_blkcipher_create_data_desc(
 	} else {
 		/* bypass */
 		SSI_LOG_DEBUG(" bypass params addr %pad length 0x%X addr 0x%08X\n",
-			      req_ctx->mlli_params.mlli_dma_addr,
+			      &req_ctx->mlli_params.mlli_dma_addr,
 			      req_ctx->mlli_params.mlli_len,
 			      (unsigned int)ctx_p->drvdata->mlli_sram_addr);
 		hw_desc_init(&desc[*seq_size]);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 928c988..81cb63d 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -244,6 +244,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* Get device resources */
 	/* First CC registers space */
 	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+
 	/* Map registers space */
 	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
 						     req_mem_cc_regs);
@@ -253,12 +254,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_drvdata_err;
 	}
 
-	SSI_LOG_DEBUG("Got MEM resource (%s): start=%pad end=%pad\n",
-		      req_mem_cc_regs->name,
-		      req_mem_cc_regs->start,
-		      req_mem_cc_regs->end);
-	SSI_LOG_DEBUG("CC registers mapped from %pa to 0x%p\n",
-		      &req_mem_cc_regs->start, new_drvdata->cc_base);
+	SSI_LOG_DEBUG("Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
+		      req_mem_cc_regs);
+	SSI_LOG_DEBUG("CC registers mapped to 0x%p\n", new_drvdata->cc_base);
 
 	cc_base = new_drvdata->cc_base;
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 9b6476d..47c648a 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -100,7 +100,7 @@
 #ifdef CC_DEBUG
 #define SSI_LOG_DEBUG(format, ...) SSI_LOG(KERN_DEBUG, format, ##__VA_ARGS__)
 #else /* Debug log messages are removed at compile time for non-DEBUG config. */
-#define SSI_LOG_DEBUG(format, ...) do {} while (0)
+#define SSI_LOG_DEBUG(format, ...) no_printk(format, ##__VA_ARGS__)
 #endif
 
 #define MIN(a, b) (((a) < (b)) ? (a) : (b))
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 3e7873c..b7d6586 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1,4 +1,4 @@
-/*
+ /*
  * Copyright (C) 2012-2017 ARM Limited or its affiliates.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -140,7 +140,7 @@ static int ssi_hash_map_result(struct device *dev,
 	}
 	SSI_LOG_DEBUG("Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
 		      digestsize, state->digest_result_buff,
-		      state->digest_result_dma_addr);
+		      &state->digest_result_dma_addr);
 
 	return 0;
 }
@@ -204,7 +204,7 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=%pad\n",
 		      ctx->inter_digestsize, state->digest_buff,
-		      state->digest_buff_dma_addr);
+		      &state->digest_buff_dma_addr);
 
 	if (is_hmac) {
 		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
@@ -253,7 +253,7 @@ static int ssi_hash_map_request(struct device *dev,
 		}
 		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=%pad\n",
 			      HASH_LEN_SIZE, state->digest_bytes_len,
-			      state->digest_bytes_len_dma_addr);
+			      &state->digest_bytes_len_dma_addr);
 	} else {
 		state->digest_bytes_len_dma_addr = 0;
 	}
@@ -268,7 +268,7 @@ static int ssi_hash_map_request(struct device *dev,
 		}
 		SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=%pad\n",
 			      ctx->inter_digestsize, state->opad_digest_buff,
-			      state->opad_digest_dma_addr);
+			      &state->opad_digest_dma_addr);
 	} else {
 		state->opad_digest_dma_addr = 0;
 	}
@@ -316,21 +316,21 @@ static void ssi_hash_unmap_request(struct device *dev,
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
-			      state->digest_buff_dma_addr);
+			      &state->digest_buff_dma_addr);
 		state->digest_buff_dma_addr = 0;
 	}
 	if (state->digest_bytes_len_dma_addr != 0) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
 				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
-			      state->digest_bytes_len_dma_addr);
+			      &state->digest_bytes_len_dma_addr);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 	if (state->opad_digest_dma_addr != 0) {
 		dma_unmap_single(dev, state->opad_digest_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
-			      state->opad_digest_dma_addr);
+			      &state->opad_digest_dma_addr);
 		state->opad_digest_dma_addr = 0;
 	}
 
@@ -353,7 +353,7 @@ static void ssi_hash_unmap_result(struct device *dev,
 				  DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
 			      state->digest_result_buff,
-			      state->digest_result_dma_addr,
+			      &state->digest_result_dma_addr,
 			      digestsize);
 		memcpy(result,
 		       state->digest_result_buff,
@@ -997,7 +997,7 @@ static int ssi_hash_setkey(void *hash,
 			return -ENOMEM;
 		}
 		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
-			      ctx->key_params.key_dma_addr,
+			      &ctx->key_params.key_dma_addr,
 			      ctx->key_params.keylen);
 
 		if (keylen > blocksize) {
@@ -1141,7 +1141,7 @@ static int ssi_hash_setkey(void *hash,
 				 ctx->key_params.key_dma_addr,
 				 ctx->key_params.keylen, DMA_TO_DEVICE);
 		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-			      ctx->key_params.key_dma_addr,
+			      &ctx->key_params.key_dma_addr,
 			      ctx->key_params.keylen);
 	}
 	return rc;
@@ -1179,7 +1179,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
-		      ctx->key_params.key_dma_addr,
+		      &ctx->key_params.key_dma_addr,
 		      ctx->key_params.keylen);
 
 	ctx->is_hmac = true;
@@ -1227,7 +1227,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 			 ctx->key_params.key_dma_addr,
 			 ctx->key_params.keylen, DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-		      ctx->key_params.key_dma_addr,
+		      &ctx->key_params.key_dma_addr,
 		      ctx->key_params.keylen);
 
 	return rc;
@@ -1282,7 +1282,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
-			      ctx->digest_buff_dma_addr);
+			      &ctx->digest_buff_dma_addr);
 		ctx->digest_buff_dma_addr = 0;
 	}
 	if (ctx->opad_tmp_keys_dma_addr != 0) {
@@ -1290,7 +1290,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
-			      ctx->opad_tmp_keys_dma_addr);
+			      &ctx->opad_tmp_keys_dma_addr);
 		ctx->opad_tmp_keys_dma_addr = 0;
 	}
 
@@ -1311,7 +1311,7 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 	}
 	SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=%pad\n",
 		      sizeof(ctx->digest_buff), ctx->digest_buff,
-		      ctx->digest_buff_dma_addr);
+		      &ctx->digest_buff_dma_addr);
 
 	ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
@@ -1322,7 +1322,7 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 	}
 	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
 		      sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
-		      ctx->opad_tmp_keys_dma_addr);
+		      &ctx->opad_tmp_keys_dma_addr);
 
 	ctx->is_hmac = false;
 	return 0;
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index cae9904..27324bb 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -323,9 +323,9 @@ int send_request(
 	if (ssi_req->ivgen_dma_addr_len > 0) {
 		SSI_LOG_DEBUG("Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
 			      ssi_req->ivgen_dma_addr_len,
-			      ssi_req->ivgen_dma_addr[0],
-			      ssi_req->ivgen_dma_addr[1],
-			      ssi_req->ivgen_dma_addr[2],
+			      &ssi_req->ivgen_dma_addr[0],
+			      &ssi_req->ivgen_dma_addr[1],
+			      &ssi_req->ivgen_dma_addr[2],
 			      ssi_req->ivgen_size);
 
 		/* Acquire IV from pool */
-- 
2.1.4
