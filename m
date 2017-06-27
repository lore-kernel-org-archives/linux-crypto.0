From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 13/14] staging: ccree: remove/add (un)needed blank lines
Date: Tue, 27 Jun 2017 10:27:25 +0300
Message-ID: <1498548449-10803-14-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52540 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbdF0H2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:28:53 -0400
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove or add blank lines as needed to match coding style.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 20 +++++--------------
 drivers/staging/ccree/ssi_aead.h        |  4 ----
 drivers/staging/ccree/ssi_buffer_mgr.c  |  7 ++++---
 drivers/staging/ccree/ssi_buffer_mgr.h  |  1 -
 drivers/staging/ccree/ssi_cipher.c      | 17 +++-------------
 drivers/staging/ccree/ssi_cipher.h      |  6 ------
 drivers/staging/ccree/ssi_driver.c      |  4 +---
 drivers/staging/ccree/ssi_fips.c        |  2 --
 drivers/staging/ccree/ssi_fips.h        |  3 ---
 drivers/staging/ccree/ssi_fips_data.h   |  8 --------
 drivers/staging/ccree/ssi_fips_ext.c    |  2 --
 drivers/staging/ccree/ssi_fips_ll.c     | 35 +++++++++------------------------
 drivers/staging/ccree/ssi_fips_local.c  | 14 +------------
 drivers/staging/ccree/ssi_fips_local.h  |  4 ++--
 drivers/staging/ccree/ssi_hash.c        | 12 ++++-------
 drivers/staging/ccree/ssi_ivgen.c       |  1 -
 drivers/staging/ccree/ssi_ivgen.h       |  1 -
 drivers/staging/ccree/ssi_pm.c          |  5 -----
 drivers/staging/ccree/ssi_pm.h          |  3 ---
 drivers/staging/ccree/ssi_request_mgr.c |  9 +++------
 drivers/staging/ccree/ssi_sram_mgr.c    |  2 --
 drivers/staging/ccree/ssi_sram_mgr.h    |  1 -
 drivers/staging/ccree/ssi_sysfs.c       |  4 ----
 drivers/staging/ccree/ssi_sysfs.h       |  1 +
 24 files changed, 33 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 53105dd..1fc0b05 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -49,7 +49,6 @@
 #define AES_CCM_RFC4309_NONCE_SIZE 3
 #define MAX_NONCE_SIZE CTR_RFC3686_NONCE_SIZE
 
-
 /* Value of each ICV_CMP byte (of 8) in case of success */
 #define ICV_VERIF_OK 0x01
 
@@ -209,7 +208,6 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	return -ENOMEM;
 }
 
-
 static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
 {
 	struct aead_request *areq = (struct aead_request *)ssi_req;
@@ -402,6 +400,7 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 
 	return 0; /* All tests of keys sizes passed */
 }
+
 /* This function prepers the user key so it can pass to the hmac processing
  * (copy to intenral buffer or hash in case of key longer than block
  */
@@ -526,7 +525,6 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	return rc;
 }
 
-
 static int
 ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
@@ -594,7 +592,6 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 			goto badkey;
 	}
 
-
 	/* STAT_PHASE_2: Create sequence */
 
 	switch (ctx->auth_mode) {
@@ -613,7 +610,6 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 		goto badkey;
 	}
 
-
 	/* STAT_PHASE_3: Submit sequence to HW */
 
 	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
@@ -1372,6 +1368,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
 {
 	unsigned int len = 0;
+
 	if (headerSize == 0)
 		return 0;
 
@@ -1424,7 +1421,6 @@ static inline int ssi_aead_ccm(
 	unsigned int cipher_flow_mode;
 	dma_addr_t mac_result;
 
-
 	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		cipher_flow_mode = AES_to_HASH_and_DOUT;
 		mac_result = req_ctx->mac_buf_dma_addr;
@@ -1481,7 +1477,6 @@ static inline int ssi_aead_ccm(
 	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
-
 	/* process assoc data */
 	if (req->assoclen > 0) {
 		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, &idx);
@@ -1556,6 +1551,7 @@ static int config_ccm_adata(struct aead_request *req)
 				req->cryptlen :
 				(req->cryptlen - ctx->authsize);
 	int rc;
+
 	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
 	memset(req_ctx->ccm_config, 0, AES_BLOCK_SIZE * 3);
 
@@ -1808,7 +1804,6 @@ static inline int ssi_aead_gcm(
 		cipher_flow_mode = AES_to_HASH_and_DOUT;
 	}
 
-
 	//in RFC4543 no data to encrypt. just copy data from src to dest.
 	if (req_ctx->plaintext_authenticate_only) {
 		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
@@ -1904,15 +1899,16 @@ static int config_gcm_context(struct aead_request *req)
 	memcpy(req->iv + 12, &counter, 4);
 	memcpy(req_ctx->gcm_iv_inc1, req->iv, 16);
 
-
 	if (!req_ctx->plaintext_authenticate_only) {
 		__be64 temp64;
+
 		temp64 = cpu_to_be64(req->assoclen * 8);
 		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy(&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
+
 		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = 0;
@@ -1934,7 +1930,6 @@ static void ssi_rfc4_gcm_process(struct aead_request *req)
 	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
-
 #endif /*SSI_CC_HAS_AES_GCM*/
 
 static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction direct)
@@ -1948,7 +1943,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	struct ssi_crypto_req ssi_req = {};
 
-
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
 		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"), ctx, req, req->iv,
 		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
@@ -1973,7 +1967,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	areq_ctx->req_authsize = ctx->authsize;
 	areq_ctx->cipher_mode = ctx->cipher_mode;
 
-
 	/* STAT_PHASE_1: Map buffers */
 
 	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
@@ -2057,7 +2050,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		ssi_req.ivgen_size = crypto_aead_ivsize(tfm);
 	}
 
-
 	/* STAT_PHASE_2: Create sequence */
 
 	/* Load MLLI tables to SRAM if necessary */
@@ -2091,7 +2083,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		goto exit;
 	}
 
-
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 1);
@@ -2101,7 +2092,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		ssi_buffer_mgr_unmap_aead_request(dev, req);
 	}
 
-
 exit:
 	return rc;
 }
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index d69e729..39cc633 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -25,13 +25,11 @@
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
 
-
 /* mac_cmp - HW writes 8 B but all bytes hold the same value */
 #define ICV_CMP_SIZE 8
 #define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE * 3)
 #define MAX_MAC_SIZE MAX(SHA256_DIGEST_SIZE, AES_BLOCK_SIZE)
 
-
 /* defines for AES GCM configuration buffer */
 #define GCM_BLOCK_LEN_SIZE 8
 
@@ -40,8 +38,6 @@
 #define GCM_BLOCK_RFC4_NONCE_OFFSET	0
 #define GCM_BLOCK_RFC4_NONCE_SIZE	4
 
-
-
 /* Offsets into AES CCM configuration buffer */
 #define CCM_B0_OFFSET 0
 #define CCM_A0_OFFSET 16
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 1b41c12..b35871e 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -42,7 +42,6 @@
 #define GET_DMA_BUFFER_TYPE(buff_type)
 #endif
 
-
 enum dma_buffer_type {
 	DMA_NULL_TYPE = -1,
 	DMA_SGL_TYPE = 1,
@@ -80,6 +79,7 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 	struct scatterlist *sg_list, unsigned int nbytes, u32 *lbytes, bool *is_chained)
 {
 	unsigned int nents = 0;
+
 	while (nbytes != 0) {
 		if (sg_is_chain(sg_list)) {
 			SSI_LOG_ERR("Unexpected chained entry "
@@ -181,7 +181,6 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 	return 0;
 }
 
-
 static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 	struct scatterlist *sgl, u32 sgl_data_len, u32 sglOffset, u32 *curr_nents,
 	u32 **mlli_entry_pp)
@@ -322,6 +321,7 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 {
 	u32 i, j;
 	struct scatterlist *l_sg = sg;
+
 	for (i = 0; i < nents; i++) {
 		if (!l_sg)
 			break;
@@ -441,7 +441,6 @@ ssi_aead_handle_config_buf(struct device *dev,
 	return 0;
 }
 
-
 static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 					   struct ahash_req_ctx *areq_ctx,
 					   u8 *curr_buff,
@@ -700,6 +699,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	    likely(req->src == req->dst))
 	{
 		u32 size_to_skip = req->assoclen;
+
 		if (areq_ctx->is_gcm4543)
 			size_to_skip += crypto_aead_ivsize(tfm);
 
@@ -1027,6 +1027,7 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			 * MAC verification upon request completion
 			 */
 			  u32 size_to_skip = req->assoclen;
+
 			  if (areq_ctx->is_gcm4543)
 				  size_to_skip += crypto_aead_ivsize(tfm);
 
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index bb5f8dc..41f5223 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -26,7 +26,6 @@
 #include "ssi_config.h"
 #include "ssi_driver.h"
 
-
 enum ssi_req_dma_buf_type {
 	SSI_DMA_BUF_NULL = 0,
 	SSI_DMA_BUF_DLLI,
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index eb3e8e6..cd2eafc 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -47,6 +47,7 @@ struct cc_user_key_info {
 	u8 *key;
 	dma_addr_t key_dma_addr;
 };
+
 struct cc_hw_key_info {
 	enum cc_hw_crypto_key key1_slot;
 	enum cc_hw_crypto_key key2_slot;
@@ -67,7 +68,6 @@ struct ssi_ablkcipher_ctx {
 
 static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base);
 
-
 static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
@@ -108,7 +108,6 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 	return -EINVAL;
 }
 
-
 static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size) {
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
@@ -252,7 +251,6 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 	SSI_LOG_DEBUG("Free key buffer in context. key=@%p\n", ctx_p->user.key);
 }
 
-
 struct tdes_keys {
 	u8	key1[DES_KEY_SIZE];
 	u8	key2[DES_KEY_SIZE];
@@ -396,8 +394,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		return -EINVAL;
 	}
 
-
-
 	/* STAT_PHASE_1: Copy key to ctx */
 	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
 					max_key_buf_size, DMA_TO_DEVICE);
@@ -422,6 +418,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			int key_len = keylen >> 1;
 			int err;
 			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
+
 			desc->tfm = ctx_p->shash_tfm;
 
 			err = crypto_shash_digest(desc, ctx_p->user.key, key_len, ctx_p->user.key + key_len);
@@ -435,7 +432,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 					max_key_buf_size, DMA_TO_DEVICE);
 	ctx_p->keylen = keylen;
 
-
 	 SSI_LOG_DEBUG("ssi_blkcipher_setkey: return safely");
 	return 0;
 }
@@ -598,7 +594,6 @@ static inline void ssi_blkcipher_create_multi2_setup_desc(
 	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
 	(*seq_size)++;
 
-
 	/* Set state */
 	hw_desc_init(&desc[*seq_size]);
 	set_din_type(&desc[*seq_size], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
@@ -724,7 +719,6 @@ static int ssi_blkcipher_complete(struct device *dev,
 
 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 
-
 	/*Set the inflight couter value to local variable*/
 	inflight_counter =  ctx_p->drvdata->inflight_counter;
 	/*Decrease the inflight counter*/
@@ -790,7 +784,6 @@ static int ssi_blkcipher_process(
 	/* Setup request context */
 	req_ctx->gen_ctx.op_type = direction;
 
-
 	/* STAT_PHASE_1: Map buffers */
 
 	rc = ssi_buffer_mgr_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes, info, src, dst);
@@ -799,7 +792,6 @@ static int ssi_blkcipher_process(
 		goto exit_process;
 	}
 
-
 	/* STAT_PHASE_2: Create sequence */
 
 	/* Setup processing */
@@ -878,7 +870,6 @@ static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
 	return ssi_blkcipher_init(tfm);
 }
 
-
 static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 				const u8 *key,
 				unsigned int keylen)
@@ -911,7 +902,6 @@ static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_DECRYPT);
 }
 
-
 /* DX Block cipher alg */
 static struct ssi_alg_template blkcipher_algs[] = {
 /* Async template */
@@ -1290,6 +1280,7 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	struct ssi_blkcipher_handle *blkcipher_handle =
 						drvdata->blkcipher_handle;
 	struct device *dev;
+
 	dev = &drvdata->plat_dev->dev;
 
 	if (blkcipher_handle) {
@@ -1307,8 +1298,6 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-
-
 int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 {
 	struct ssi_blkcipher_handle *ablkcipher_handle;
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 22d7b43..296b375 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -26,7 +26,6 @@
 #include "ssi_driver.h"
 #include "ssi_buffer_mgr.h"
 
-
 /* Crypto cipher flags */
 #define CC_CRYPTO_CIPHER_KEY_KFDE0    (1 << 0)
 #define CC_CRYPTO_CIPHER_KEY_KFDE1    (1 << 1)
@@ -36,7 +35,6 @@
 
 #define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | CC_CRYPTO_CIPHER_KEY_KFDE1 | CC_CRYPTO_CIPHER_KEY_KFDE2 | CC_CRYPTO_CIPHER_KEY_KFDE3)
 
-
 struct blkcipher_req_ctx {
 	struct async_gen_req_ctx gen_ctx;
 	enum ssi_req_dma_buf_type dma_buf_type;
@@ -49,8 +47,6 @@ struct blkcipher_req_ctx {
 	struct mlli_params mlli_params;
 };
 
-
-
 int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata);
 
 int ssi_ablkcipher_free(struct ssi_drvdata *drvdata);
@@ -63,7 +59,6 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata);
 				CRYPTO_ALG_BULK_DU_4096)
 #endif /* CRYPTO_ALG_BULK_MASK */
 
-
 #ifdef CRYPTO_TFM_REQ_HW_KEY
 
 static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
@@ -85,5 +80,4 @@ static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
 
 #endif /* CRYPTO_TFM_REQ_HW_KEY */
 
-
 #endif /*__SSI_CIPHER_H__*/
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 5c1d295..78709b92 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -73,7 +73,6 @@
 #include "ssi_pm.h"
 #include "ssi_fips_local.h"
 
-
 #ifdef DX_DUMP_BYTES
 void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 {
@@ -274,7 +273,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	SSI_LOG_DEBUG("CC registers mapped from %pa to 0x%p\n", &new_drvdata->res_mem->start, cc_base);
 	new_drvdata->cc_base = cc_base;
 
-
 	/* Then IRQ */
 	new_drvdata->res_irq = platform_get_resource(plat_dev, IORESOURCE_IRQ, 0);
 	if (unlikely(!new_drvdata->res_irq)) {
@@ -546,6 +544,7 @@ static int cc7x_remove(struct platform_device *plat_dev)
 
 	return 0;
 }
+
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 static struct dev_pm_ops arm_cc7x_driver_pm = {
 	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
@@ -558,7 +557,6 @@ static struct dev_pm_ops arm_cc7x_driver_pm = {
 #define	DX_DRIVER_RUNTIME_PM	NULL
 #endif
 
-
 #ifdef CONFIG_OF
 static const struct of_device_id arm_cc7x_dev_of_match[] = {
 	{.compatible = "arm,cryptocell-712-ree"},
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index d34d9ef..fdc40f3 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-
 /**************************************************************
  * This file defines the driver FIPS APIs                     *
  **************************************************************/
@@ -22,7 +21,6 @@
 #include <linux/module.h>
 #include "ssi_fips.h"
 
-
 extern int ssi_fips_ext_get_state(enum cc_fips_state_t *p_state);
 extern int ssi_fips_ext_get_error(enum cc_fips_error *p_err);
 
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index ce5fa45..4f5c6a9 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -29,7 +29,6 @@ enum cc_fips_state {
 	CC_FIPS_STATE_RESERVE32B = S32_MAX
 };
 
-
 enum cc_fips_error {
 	CC_REE_FIPS_ERROR_OK = 0,
 	CC_REE_FIPS_ERROR_GENERAL,
@@ -55,8 +54,6 @@ enum cc_fips_error {
 	CC_REE_FIPS_ERROR_RESERVE32B = S32_MAX
 };
 
-
-
 int ssi_fips_get_state(enum cc_fips_state *p_state);
 int ssi_fips_get_error(enum cc_fips_error *p_err);
 
diff --git a/drivers/staging/ccree/ssi_fips_data.h b/drivers/staging/ccree/ssi_fips_data.h
index 27b2866..c41671d 100644
--- a/drivers/staging/ccree/ssi_fips_data.h
+++ b/drivers/staging/ccree/ssi_fips_data.h
@@ -98,14 +98,12 @@
 #define NIST_AES_192_CTR_CIPHER { 0x1a, 0xbc, 0x93, 0x24, 0x17, 0x52, 0x1c, 0xa2, 0x4f, 0x2b, 0x04, 0x59, 0xfe, 0x7e, 0x6e, 0x0b }
 #define NIST_AES_256_CTR_CIPHER { 0x60, 0x1e, 0xc3, 0x13, 0x77, 0x57, 0x89, 0xa5, 0xb7, 0xa7, 0xf5, 0x04, 0xbb, 0xf3, 0xd2, 0x28 }
 
-
 #define RFC3962_AES_128_KEY            { 0x63, 0x68, 0x69, 0x63, 0x6b, 0x65, 0x6e, 0x20, 0x74, 0x65, 0x72, 0x69, 0x79, 0x61, 0x6b, 0x69 }
 #define RFC3962_AES_VECTOR_SIZE        17
 #define RFC3962_AES_PLAIN_DATA         { 0x49, 0x20, 0x77, 0x6f, 0x75, 0x6c, 0x64, 0x20, 0x6c, 0x69, 0x6b, 0x65, 0x20, 0x74, 0x68, 0x65, 0x20 }
 #define RFC3962_AES_CBC_CTS_IV         { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
 #define RFC3962_AES_128_CBC_CTS_CIPHER { 0xc6, 0x35, 0x35, 0x68, 0xf2, 0xbf, 0x8c, 0xb4, 0xd8, 0xa5, 0x80, 0x36, 0x2d, 0xa7, 0xff, 0x7f, 0x97 }
 
-
 #define NIST_AES_256_XTS_KEY            { 0xa1, 0xb9, 0x0c, 0xba, 0x3f, 0x06, 0xac, 0x35, 0x3b, 0x2c, 0x34, 0x38, 0x76, 0x08, 0x17, 0x62, \
 					  0x09, 0x09, 0x23, 0x02, 0x6e, 0x91, 0x77, 0x18, 0x15, 0xf2, 0x9d, 0xab, 0x01, 0x93, 0x2f, 0x2f }
 #define NIST_AES_256_XTS_IV             { 0x4f, 0xae, 0xf7, 0x11, 0x7c, 0xda, 0x59, 0xc6, 0x6e, 0x4b, 0x92, 0x01, 0x3e, 0x76, 0x8a, 0xd5 }
@@ -124,7 +122,6 @@
 #define NIST_AES_512_XTS_CIPHER         { 0xcb, 0xaa, 0xd0, 0xe2, 0xf6, 0xce, 0xa3, 0xf5, 0x0b, 0x37, 0xf9, 0x34, 0xd4, 0x6a, 0x9b, 0x13, \
 					  0x0b, 0x9d, 0x54, 0xf0, 0x7e, 0x34, 0xf3, 0x6a, 0xf7, 0x93, 0xe8, 0x6f, 0x73, 0xc6, 0xd7, 0xdb }
 
-
 /* NIST AES-CMAC */
 #define NIST_AES_128_CMAC_KEY           { 0x67, 0x08, 0xc9, 0x88, 0x7b, 0x84, 0x70, 0x84, 0xf1, 0x23, 0xd3, 0xdd, 0x9c, 0x3a, 0x81, 0x36 }
 #define NIST_AES_128_CMAC_PLAIN_DATA    { 0xa8, 0xde, 0x55, 0x17, 0x0c, 0x6d, 0xc0, 0xd8, 0x0d, 0xe3, 0x2f, 0x50, 0x8b, 0xf4, 0x9b, 0x70 }
@@ -147,7 +144,6 @@
 #define NIST_AES_256_CMAC_VECTOR_SIZE   16
 #define NIST_AES_256_CMAC_OUTPUT_SIZE   10
 
-
 /* NIST TDES */
 #define TDES_NUM_OF_KEYS                3
 #define NIST_TDES_VECTOR_SIZE           8
@@ -168,7 +164,6 @@
 #define NIST_TDES_CBC3_PLAIN_DATA	{ 0x3b, 0xb7, 0xa7, 0xdb, 0xa3, 0xd5, 0x92, 0x91 }
 #define NIST_TDES_CBC3_CIPHER		{ 0x5b, 0x84, 0x24, 0xd2, 0x39, 0x3e, 0x55, 0xa2 }
 
-
 /* NIST AES-CCM */
 #define NIST_AESCCM_128_BIT_KEY_SIZE    16
 #define NIST_AESCCM_192_BIT_KEY_SIZE    24
@@ -207,7 +202,6 @@
 #define NIST_AESCCM_256_CIPHER          { 0xcc, 0x17, 0xbf, 0x87, 0x94, 0xc8, 0x43, 0x45, 0x7d, 0x89, 0x93, 0x91, 0x89, 0x8e, 0xd2, 0x2a }
 #define NIST_AESCCM_256_MAC             { 0x6f, 0x9d, 0x28, 0xfc, 0xb6, 0x42, 0x34, 0xe1, 0xcd, 0x79, 0x3c, 0x41, 0x44, 0xf1, 0xda, 0x50 }
 
-
 /* NIST AES-GCM */
 #define NIST_AESGCM_128_BIT_KEY_SIZE    16
 #define NIST_AESGCM_192_BIT_KEY_SIZE    24
@@ -241,7 +235,6 @@
 #define NIST_AESGCM_256_CIPHER          { 0x42, 0x6e, 0x0e, 0xfc, 0x69, 0x3b, 0x7b, 0xe1, 0xf3, 0x01, 0x8d, 0xb7, 0xdd, 0xbb, 0x7e, 0x4d }
 #define NIST_AESGCM_256_MAC             { 0xee, 0x82, 0x57, 0x79, 0x5b, 0xe6, 0xa1, 0x16, 0x4d, 0x7e, 0x1d, 0x2d, 0x6c, 0xac, 0x77, 0xa7 }
 
-
 /* NIST HASH */
 #define NIST_SHA_MSG_SIZE               16
 
@@ -259,7 +252,6 @@
 					  0x8f, 0x2b, 0xa9, 0x1c, 0x3a, 0x9f, 0x0c, 0x16, 0x53, 0xc4, 0xbf, 0x0a, 0xda, 0x35, 0x64, 0x55, \
 					  0xea, 0x36, 0xfd, 0x31, 0xf8, 0xe7, 0x3e, 0x39, 0x51, 0xca, 0xd4, 0xeb, 0xba, 0x8c, 0x6e, 0x04 }
 
-
 /* NIST HMAC */
 #define NIST_HMAC_MSG_SIZE              128
 
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index 295aeb6..e7bf184 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -23,7 +23,6 @@
 #include "ssi_fips_local.h"
 #include "ssi_driver.h"
 
-
 static bool tee_error;
 module_param(tee_error, bool, 0644);
 MODULE_PARM_DESC(tee_error, "Simulate TEE library failure flag: 0 - no error (default), 1 - TEE error occured ");
@@ -91,4 +90,3 @@ int ssi_fips_ext_set_error(enum cc_fips_error err)
 	return 0;
 }
 
-
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index cbb0fe2..3557e20 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -27,7 +27,6 @@
 #include "ssi_hash.h"
 #include "ssi_request_mgr.h"
 
-
 static const u32 digest_len_init[] = {
 	0x00000040, 0x00000000, 0x00000000, 0x00000000 };
 static const u32 sha1_init[] = {
@@ -43,7 +42,6 @@ static const u64 sha512_init[] = {
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
 #endif
 
-
 #define NIST_CIPHER_AES_MAX_VECTOR_SIZE      32
 
 struct fips_cipher_ctx {
@@ -65,7 +63,6 @@ typedef struct _FipsCipherData {
 	size_t                    dataInSize;
 } FipsCipherData;
 
-
 struct fips_cmac_ctx {
 	u8 key[AES_256_BIT_KEY_SIZE];
 	u8 din[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
@@ -82,7 +79,6 @@ typedef struct _FipsCmacData {
 	size_t                    mac_res_size;
 } FipsCmacData;
 
-
 struct fips_hash_ctx {
 	u8 initial_digest[CC_DIGEST_SIZE_MAX];
 	u8 din[NIST_SHA_MSG_SIZE];
@@ -96,7 +92,6 @@ typedef struct _FipsHashData {
 	u8               mac_res[CC_DIGEST_SIZE_MAX];
 } FipsHashData;
 
-
 /* note that the hmac key length must be equal or less than block size (block size is 64 up to sha256 and 128 for sha384/512) */
 struct fips_hmac_ctx {
 	u8 initial_digest[CC_DIGEST_SIZE_MAX];
@@ -117,7 +112,6 @@ typedef struct _FipsHmacData {
 	u8               mac_res[CC_DIGEST_SIZE_MAX];
 } FipsHmacData;
 
-
 #define FIPS_CCM_B0_A0_ADATA_SIZE   (NIST_AESCCM_IV_SIZE + NIST_AESCCM_IV_SIZE + NIST_AESCCM_ADATA_SIZE)
 
 struct fips_ccm_ctx {
@@ -144,7 +138,6 @@ typedef struct _FipsCcmData {
 	u8                   macResOut[NIST_AESCCM_TAG_SIZE];
 } FipsCcmData;
 
-
 struct fips_gcm_ctx {
 	u8 adata[NIST_AESGCM_ADATA_SIZE];
 	u8 key[CC_AES_KEY_SIZE_MAX];
@@ -171,7 +164,6 @@ typedef struct _FipsGcmData {
 	u8                   macResOut[NIST_AESGCM_TAG_SIZE];
 } FipsGcmData;
 
-
 typedef union _fips_ctx {
 	struct fips_cipher_ctx cipher;
 	struct fips_cmac_ctx cmac;
@@ -181,7 +173,6 @@ typedef union _fips_ctx {
 	struct fips_gcm_ctx gcm;
 } fips_ctx;
 
-
 /* test data tables */
 static const FipsCipherData FipsCipherDataTable[] = {
 	/* AES */
@@ -223,6 +214,7 @@ static const FipsCipherData FipsCipherDataTable[] = {
 	{ 0, NIST_TDES_CBC3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_CBC3_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CBC, NIST_TDES_CBC3_PLAIN_DATA, NIST_TDES_CBC3_CIPHER, NIST_TDES_VECTOR_SIZE },
 	{ 0, NIST_TDES_CBC3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_CBC3_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC, NIST_TDES_CBC3_CIPHER, NIST_TDES_CBC3_PLAIN_DATA, NIST_TDES_VECTOR_SIZE },
 };
+
 #define FIPS_CIPHER_NUM_OF_TESTS        (sizeof(FipsCipherDataTable) / sizeof(FipsCipherData))
 
 static const FipsCmacData FipsCmacDataTable[] = {
@@ -230,6 +222,7 @@ static const FipsCmacData FipsCmacDataTable[] = {
 	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AES_192_CMAC_KEY, AES_192_BIT_KEY_SIZE, NIST_AES_192_CMAC_PLAIN_DATA, NIST_AES_192_CMAC_VECTOR_SIZE, NIST_AES_192_CMAC_MAC, NIST_AES_192_CMAC_OUTPUT_SIZE },
 	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AES_256_CMAC_KEY, AES_256_BIT_KEY_SIZE, NIST_AES_256_CMAC_PLAIN_DATA, NIST_AES_256_CMAC_VECTOR_SIZE, NIST_AES_256_CMAC_MAC, NIST_AES_256_CMAC_OUTPUT_SIZE },
 };
+
 #define FIPS_CMAC_NUM_OF_TESTS        (sizeof(FipsCmacDataTable) / sizeof(FipsCmacData))
 
 static const FipsHashData FipsHashDataTable[] = {
@@ -239,6 +232,7 @@ static const FipsHashData FipsHashDataTable[] = {
 //        { DRV_HASH_SHA512, NIST_SHA_512_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_512_MD },
 #endif
 };
+
 #define FIPS_HASH_NUM_OF_TESTS        (sizeof(FipsHashDataTable) / sizeof(FipsHashData))
 
 static const FipsHmacData FipsHmacDataTable[] = {
@@ -248,6 +242,7 @@ static const FipsHmacData FipsHmacDataTable[] = {
 //        { DRV_HASH_SHA512, NIST_HMAC_SHA512_KEY, NIST_HMAC_SHA512_KEY_SIZE, NIST_HMAC_SHA512_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA512_MD },
 #endif
 };
+
 #define FIPS_HMAC_NUM_OF_TESTS        (sizeof(FipsHmacDataTable) / sizeof(FipsHmacData))
 
 static const FipsCcmData FipsCcmDataTable[] = {
@@ -258,6 +253,7 @@ static const FipsCcmData FipsCcmDataTable[] = {
 	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
 	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
 };
+
 #define FIPS_CCM_NUM_OF_TESTS        (sizeof(FipsCcmDataTable) / sizeof(FipsCcmData))
 
 static const FipsGcmData FipsGcmDataTable[] = {
@@ -268,8 +264,8 @@ static const FipsGcmData FipsGcmDataTable[] = {
 	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
 	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
 };
-#define FIPS_GCM_NUM_OF_TESTS        (sizeof(FipsGcmDataTable) / sizeof(FipsGcmData))
 
+#define FIPS_GCM_NUM_OF_TESTS        (sizeof(FipsGcmDataTable) / sizeof(FipsGcmData))
 
 static inline enum cc_fips_error
 FIPS_CipherToFipsError(enum drv_cipher_mode mode, bool is_aes)
@@ -295,7 +291,6 @@ FIPS_CipherToFipsError(enum drv_cipher_mode mode, bool is_aes)
 	return CC_REE_FIPS_ERROR_GENERAL;
 }
 
-
 static inline int
 ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
 			 bool is_aes,
@@ -414,7 +409,6 @@ ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-
 enum cc_fips_error
 ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
@@ -479,7 +473,6 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 	return error;
 }
 
-
 static inline int
 ssi_cmac_fips_run_test(struct ssi_drvdata *drvdata,
 		       dma_addr_t key_dma_addr,
@@ -519,7 +512,6 @@ ssi_cmac_fips_run_test(struct ssi_drvdata *drvdata,
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-
 	//ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	hw_desc_init(&desc[idx]);
 	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, din_len, NS_BIT);
@@ -603,7 +595,6 @@ ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	return error;
 }
 
-
 static inline enum cc_fips_error
 FIPS_HashToFipsError(enum drv_hash_mode hash_mode)
 {
@@ -779,7 +770,6 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	return error;
 }
 
-
 static inline enum cc_fips_error
 FIPS_HmacToFipsError(enum drv_hash_mode hash_mode)
 {
@@ -867,7 +857,6 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
-
 		/* Load the hash current length*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hw_mode);
@@ -981,7 +970,6 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
-
 	/* Get final MAC result */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hw_mode);
@@ -1112,7 +1100,6 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	return error;
 }
 
-
 static inline int
 ssi_ccm_fips_run_test(struct ssi_drvdata *drvdata,
 		      enum drv_crypto_direction direction,
@@ -1277,6 +1264,7 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		{
 			/* build B0 -- B0, nonce, l(m) */
 			__be16 data = cpu_to_be16(NIST_AESCCM_TEXT_SIZE);
+
 			virt_ctx->b0_a0_adata[0] = NIST_AESCCM_B0_VAL;
 			memcpy(virt_ctx->b0_a0_adata + 1, ccmData->nonce, NIST_AESCCM_NONCE_SIZE);
 			memcpy(virt_ctx->b0_a0_adata + 14, (u8 *)&data, sizeof(__be16));
@@ -1340,7 +1328,6 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	return error;
 }
 
-
 static inline int
 ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 		      enum drv_crypto_direction direction,
@@ -1439,8 +1426,6 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
-
-
 /////////////////////////////////   2   ////////////////////////////////////
 	/* prcess(ghash) assoc data */
 //	if (req->assoclen > 0)
@@ -1452,7 +1437,6 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
-
 /////////////////////////////////   3   ////////////////////////////////////
 //	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
 /////////////////////////////////   3   ////////////////////////////////////
@@ -1478,7 +1462,6 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-
 /////////////////////////////////   4   ////////////////////////////////////
 	/* process(gctr+ghash) */
 //	if (req_ctx->cryptlen != 0)
@@ -1491,7 +1474,6 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 	set_flow_mode(&desc[idx], cipher_flow_mode);
 	idx++;
 
-
 /////////////////////////////////   5   ////////////////////////////////////
 //	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
 /////////////////////////////////   5   ////////////////////////////////////
@@ -1579,6 +1561,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		/* len_block */
 		{
 			__be64 len_bits;
+
 			len_bits = cpu_to_be64(gcmData->adataSize * 8);
 			memcpy(virt_ctx->len_block, &len_bits, sizeof(len_bits));
 			len_bits = cpu_to_be64(gcmData->dataInSize * 8);
@@ -1587,6 +1570,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		/* iv_inc1, iv_inc2 */
 		{
 			__be32 counter = cpu_to_be32(1);
+
 			memcpy(virt_ctx->iv_inc1, gcmData->iv, NIST_AESGCM_IV_SIZE);
 			memcpy(virt_ctx->iv_inc1 + NIST_AESGCM_IV_SIZE, &counter, sizeof(counter));
 			counter = cpu_to_be32(2);
@@ -1651,7 +1635,6 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	return error;
 }
 
-
 size_t ssi_fips_max_mem_alloc_size(void)
 {
 	FIPS_DBG("sizeof(struct fips_cipher_ctx) %d \n", sizeof(struct fips_cipher_ctx));
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index 9b84876..aefb71d 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -26,7 +26,6 @@
 #include "ssi_driver.h"
 #include "cc_hal.h"
 
-
 #define FIPS_POWER_UP_TEST_CIPHER	1
 #define FIPS_POWER_UP_TEST_CMAC		1
 #define FIPS_POWER_UP_TEST_HASH		1
@@ -49,7 +48,6 @@ struct ssi_fips_handle {
 #endif
 };
 
-
 extern int ssi_fips_get_state(enum cc_fips_state_t *p_state);
 extern int ssi_fips_get_error(enum cc_fips_error *p_err);
 extern int ssi_fips_ext_set_state(enum cc_fips_state_t state);
@@ -64,7 +62,6 @@ extern enum cc_fips_error ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdat
 extern enum cc_fips_error ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
 extern size_t ssi_fips_max_mem_alloc_size(void);
 
-
 /* The function called once at driver entry point to check whether TEE FIPS error occured.*/
 static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 {
@@ -78,7 +75,6 @@ static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 	return CC_REE_FIPS_ERROR_FROM_TEE;
 }
 
-
 /*
  * This function should push the FIPS REE library status towards the TEE library.
  * By writing the error state to HOST_GPR0 register. The function is called from
@@ -87,14 +83,13 @@ static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, enum cc_fips_error err)
 {
 	void __iomem *cc_base = drvdata->cc_base;
+
 	if (err == CC_REE_FIPS_ERROR_OK)
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS | CC_FIPS_SYNC_MODULE_OK));
 	else
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS | CC_FIPS_SYNC_MODULE_ERROR));
 }
 
-
-
 void ssi_fips_fini(struct ssi_drvdata *drvdata)
 {
 	struct ssi_fips_handle *fips_h = drvdata->fips_handle;
@@ -127,8 +122,6 @@ void fips_handler(struct ssi_drvdata *drvdata)
 #endif
 }
 
-
-
 #ifdef COMP_IN_WQ
 static void fips_wq_handler(struct work_struct *work)
 {
@@ -161,7 +154,6 @@ static void fips_dsr(unsigned long devarg)
 		CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
 }
 
-
 enum cc_fips_error cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 {
 	enum cc_fips_error fips_error = CC_REE_FIPS_ERROR_OK;
@@ -227,8 +219,6 @@ enum cc_fips_error cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 	return fips_error;
 }
 
-
-
 /* The function checks if FIPS supported and FIPS error exists.*
  * It should be used in every driver API.
  */
@@ -247,7 +237,6 @@ int ssi_fips_check_fips_error(void)
 	return 0;
 }
 
-
 /* The function sets the REE FIPS state.*
  * It should be used while driver is being loaded.
  */
@@ -293,7 +282,6 @@ int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, enum cc_fips_error err)
 	return rc;
 }
 
-
 /* The function called once at driver entry point .*/
 int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 {
diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
index 4bc7f37..8c7994f 100644
--- a/drivers/staging/ccree/ssi_fips_local.h
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -17,7 +17,6 @@
 #ifndef __SSI_FIPS_LOCAL_H__
 #define __SSI_FIPS_LOCAL_H__
 
-
 #ifdef CONFIG_CCX7REE_FIPS_SUPPORT
 
 #include "ssi_fips.h"
@@ -28,11 +27,13 @@ struct ssi_drvdata;
 		return -ENOEXEC;\
 	} \
 }
+
 #define CHECK_AND_RETURN_VOID_UPON_FIPS_ERROR() {\
 	if (ssi_fips_check_fips_error() != 0) {\
 		return;\
 	} \
 }
+
 #define SSI_FIPS_INIT(p_drvData)  (ssi_fips_init(p_drvData))
 #define SSI_FIPS_FINI(p_drvData)  (ssi_fips_fini(p_drvData))
 
@@ -62,6 +63,5 @@ void fips_handler(struct ssi_drvdata *drvdata);
 
 #endif  /* CONFIG_CC7XXREE_FIPS_SUPPORT */
 
-
 #endif  /*__SSI_FIPS_LOCAL_H__*/
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 79655bb..ae8f36a 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -83,7 +83,6 @@ struct ssi_hash_alg {
 	struct ahash_alg ahash_alg;
 };
 
-
 struct hash_key_req_ctx {
 	u32 keylen;
 	dma_addr_t key_dma_addr;
@@ -97,6 +96,7 @@ struct ssi_hash_ctx {
 	 */
 	u8 digest_buff[SSI_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
 	u8 opad_tmp_keys_buff[SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE]  ____cacheline_aligned;
+
 	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
 	dma_addr_t digest_buff_dma_addr;
 	/* use for hmac with key large then mode block size */
@@ -429,7 +429,6 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 	int idx = 0;
 	int rc = 0;
 
-
 	SSI_LOG_DEBUG("===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
@@ -962,6 +961,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 {
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
+
 	state->xcbc_count = 0;
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
@@ -1164,7 +1164,6 @@ static int ssi_hash_setkey(void *hash,
 	return rc;
 }
 
-
 static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
 {
@@ -1252,11 +1251,13 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 
 	return rc;
 }
+
 #if SSI_CC_HAS_CMAC
 static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
 {
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+
 	SSI_LOG_DEBUG("===== setkey (%d) ====\n", keylen);
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
@@ -1289,7 +1290,6 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 
 	ctx->key_params.keylen = keylen;
 
-
 	return 0;
 }
 #endif
@@ -1319,7 +1319,6 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	ctx->key_params.keylen = 0;
 }
 
-
 static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 {
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
@@ -1365,7 +1364,6 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 	struct ssi_hash_alg *ssi_alg =
 			container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
 
-
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				sizeof(struct ahash_req_ctx));
@@ -1462,7 +1460,6 @@ static int ssi_mac_final(struct ahash_request *req)
 	u32 rem_cnt = state->buff_index ? state->buff1_cnt :
 			state->buff0_cnt;
 
-
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		keySize = CC_AES_128_BIT_KEY_SIZE;
@@ -1501,7 +1498,6 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
-
 		/* Initiate decryption of block state to previous block_state-XOR-M[n] */
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index a275151..5ff3368 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -296,4 +296,3 @@ int ssi_ivgen_getiv(
 	return 0;
 }
 
-
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index d466124..961aea4 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -19,7 +19,6 @@
 
 #include "cc_hw_queue_defs.h"
 
-
 #define SSI_IVPOOL_SEQ_LEN 8
 
 /*!
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index d3ddfb1..52a8ed5 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-
 #include "ssi_config.h"
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
@@ -30,13 +29,11 @@
 #include "ssi_hash.h"
 #include "ssi_pm.h"
 
-
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
 
-
 int ssi_power_mgr_runtime_suspend(struct device *dev)
 {
 	struct ssi_drvdata *drvdata =
@@ -119,8 +116,6 @@ int ssi_power_mgr_runtime_put_suspend(struct device *dev)
 
 #endif
 
-
-
 int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
 {
 	int rc = 0;
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 4874987..63673f6 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -20,14 +20,11 @@
 #ifndef __SSI_POWER_MGR_H__
 #define __SSI_POWER_MGR_H__
 
-
 #include "ssi_config.h"
 #include "ssi_driver.h"
 
-
 #define SSI_SUSPEND_TIMEOUT 3000
 
-
 int ssi_power_mgr_init(struct ssi_drvdata *drvdata);
 
 void ssi_power_mgr_fini(struct ssi_drvdata *drvdata);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index f6f7ea8..46d9396 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -50,6 +50,7 @@ struct ssi_request_mgr_handle {
 	u8 *dummy_comp_buff;
 	dma_addr_t dummy_comp_buff_dma;
 	struct cc_hw_desc monitor_desc;
+
 	volatile unsigned long monitor_lock;
 #ifdef COMP_IN_WQ
 	struct workqueue_struct *workq;
@@ -135,7 +136,6 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	req_mgr_h->min_free_hw_slots = req_mgr_h->hw_queue_size;
 	req_mgr_h->max_used_sw_slots = 0;
 
-
 	/* Allocate DMA word for "dummy" completion descriptor use */
 	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(&drvdata->plat_dev->dev,
 		sizeof(u32), &req_mgr_h->dummy_comp_buff_dma, GFP_KERNEL);
@@ -192,10 +192,10 @@ static inline void enqueue_seq(
 static void request_mgr_complete(struct device *dev, void *dx_compl_h, void __iomem *cc_base)
 {
 	struct completion *this_compl = dx_compl_h;
+
 	complete(this_compl);
 }
 
-
 static inline int request_mgr_queues_status_check(
 		struct ssi_request_mgr_handle *req_mgr_h,
 		void __iomem *cc_base,
@@ -389,7 +389,6 @@ int send_request(
 	}
 }
 
-
 /*!
  * Enqueue caller request to crypto hardware during init process.
  * assume this function is not called in middle of a flow,
@@ -426,7 +425,6 @@ int send_request_init(
 	return 0;
 }
 
-
 void complete_request(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *request_mgr_handle =
@@ -478,6 +476,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		{
 			u32 axi_err;
 			int i;
+
 			SSI_LOG_INFO("Delay\n");
 			for (i = 0; i < 1000000; i++)
 				axi_err = READ_REGISTER(drvdata->cc_base + CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
@@ -516,8 +515,6 @@ static void comp_handler(unsigned long devarg)
 
 	u32 irq;
 
-
-
 	irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
 
 	if (irq & SSI_COMP_IRQ_MASK) {
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index cf03df3..e05c0c1 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -17,7 +17,6 @@
 #include "ssi_driver.h"
 #include "ssi_sram_mgr.h"
 
-
 /**
  * struct ssi_sram_mgr_ctx -Internal RAM context manager
  * @sram_free_offset:   the offset to the non-allocated area
@@ -26,7 +25,6 @@ struct ssi_sram_mgr_ctx {
 	ssi_sram_addr_t sram_free_offset;
 };
 
-
 /**
  * ssi_sram_mgr_fini() - Cleanup SRAM pool.
  *
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index ece6359..9ba1d59 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -17,7 +17,6 @@
 #ifndef __SSI_SRAM_MGR_H__
 #define __SSI_SRAM_MGR_H__
 
-
 #ifndef SSI_CC_SRAM_SIZE
 #define SSI_CC_SRAM_SIZE 4096
 #endif
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 75c9a89..dbcd163 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -108,7 +108,6 @@ static DEFINE_SPINLOCK(stat_lock);
 static struct stat_item stat_host_db[MAX_STAT_OP_TYPES][MAX_STAT_PHASES];
 static struct stat_item stat_cc_db[MAX_STAT_OP_TYPES][MAX_STAT_PHASES];
 
-
 static void init_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES])
 {
 	unsigned int i, j;
@@ -152,7 +151,6 @@ static void display_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES]
 	}
 }
 
-
 /**************************************
  * Attributes show functions section  *
  **************************************/
@@ -278,8 +276,6 @@ void display_all_stat_db(void)
 }
 #endif /*CC_CYCLE_COUNT*/
 
-
-
 static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
index 4893e01..44ae3d4 100644
--- a/drivers/staging/ccree/ssi_sysfs.h
+++ b/drivers/staging/ccree/ssi_sysfs.h
@@ -36,6 +36,7 @@ enum stat_phase {
 	STAT_PHASE_6,
 	MAX_STAT_PHASES,
 };
+
 enum stat_op {
 	STAT_OP_TYPE_NULL = 0,
 	STAT_OP_TYPE_ENCODE,
-- 
2.1.4
