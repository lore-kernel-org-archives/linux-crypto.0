From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v3 04/15] staging: ccree: add IV generation support
Date: Sun, 23 Apr 2017 12:26:12 +0300
Message-ID: <1492939583-25688-5-git-send-email-gilad@benyossef.com>
References: <1492939583-25688-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gilad.benyossef-5wv7dgnIgG8@public.gmane.org,
        Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>,
        Stuart Yoder <stuart.yoder-5wv7dgnIgG8@public.gmane.org>,
        Stephan Muller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492939583-25688-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add CryptoCell IV hardware generation support.

This patch adds the needed support to drive the HW but does not expose
the ability via the kernel crypto API yet.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 drivers/staging/ccree/Makefile          |   2 +-
 drivers/staging/ccree/ssi_buffer_mgr.c  |   2 +
 drivers/staging/ccree/ssi_cipher.c      |  11 ++
 drivers/staging/ccree/ssi_cipher.h      |   1 +
 drivers/staging/ccree/ssi_driver.c      |   9 +
 drivers/staging/ccree/ssi_driver.h      |   7 +
 drivers/staging/ccree/ssi_ivgen.c       | 301 ++++++++++++++++++++++++++++++++
 drivers/staging/ccree/ssi_ivgen.h       |  72 ++++++++
 drivers/staging/ccree/ssi_pm.c          |   2 +
 drivers/staging/ccree/ssi_request_mgr.c |  33 +++-
 10 files changed, 438 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/ccree/ssi_ivgen.c
 create mode 100644 drivers/staging/ccree/ssi_ivgen.h

diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index 21a80d5..89afe9a 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
+ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index d0d5352..6ff5d6b 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -534,6 +534,7 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_ctx->gen_ctx.iv_dma_addr);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr, 
 				 ivsize, 
+				 req_ctx->is_giv ? DMA_BIDIRECTIONAL :
 				 DMA_TO_DEVICE);
 	}
 	/* Release pool */
@@ -587,6 +588,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 		req_ctx->gen_ctx.iv_dma_addr = 
 			dma_map_single(dev, (void *)info, 
 				       ivsize, 
+				       req_ctx->is_giv ? DMA_BIDIRECTIONAL:
 				       DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, 
 					req_ctx->gen_ctx.iv_dma_addr))) {
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index d22a1b3..4a95f13 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -819,6 +819,13 @@ static int ssi_blkcipher_process(
 			      areq,
 			      desc, &seq_len);
 
+	/* do we need to generate IV? */
+	if (req_ctx->is_giv == true) {
+		ssi_req.ivgen_dma_addr[0] = req_ctx->gen_ctx.iv_dma_addr;
+		ssi_req.ivgen_dma_addr_len = 1;
+		/* set the IV size (8/16 B long)*/
+		ssi_req.ivgen_size = ivsize;
+	}
 	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_2);
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
@@ -901,6 +908,7 @@ static int ssi_sblkcipher_encrypt(struct blkcipher_desc *desc,
 	unsigned int ivsize = crypto_blkcipher_ivsize(blk_tfm);
 
 	req_ctx->backup_info = desc->info;
+	req_ctx->is_giv = false;
 
 	return ssi_blkcipher_process(tfm, req_ctx, dst, src, nbytes, desc->info, ivsize, NULL, DRV_CRYPTO_DIRECTION_ENCRYPT);
 }
@@ -916,6 +924,7 @@ static int ssi_sblkcipher_decrypt(struct blkcipher_desc *desc,
 	unsigned int ivsize = crypto_blkcipher_ivsize(blk_tfm);
 
 	req_ctx->backup_info = desc->info;
+	req_ctx->is_giv = false;
 
 	return ssi_blkcipher_process(tfm, req_ctx, dst, src, nbytes, desc->info, ivsize, NULL, DRV_CRYPTO_DIRECTION_DECRYPT);
 }
@@ -948,6 +957,7 @@ static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
 	req_ctx->backup_info = req->info;
+	req_ctx->is_giv = false;
 
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 }
@@ -960,6 +970,7 @@ static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
 	req_ctx->backup_info = req->info;
+	req_ctx->is_giv = false;
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_DECRYPT);
 }
 
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 9ceb0b6..ba4eb7c 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -45,6 +45,7 @@ struct blkcipher_req_ctx {
 	uint32_t out_nents;
 	uint32_t out_mlli_nents;
 	uint8_t *backup_info; /*store iv for generated IV flow*/
+	bool is_giv;
 	struct mlli_params mlli_params;
 };
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 7f7807d..ac1b61b 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -64,6 +64,7 @@
 #include "ssi_sysfs.h"
 #include "ssi_cipher.h"
 #include "ssi_hash.h"
+#include "ssi_ivgen.h"
 #include "ssi_sram_mgr.h"
 #include "ssi_pm.h"
 
@@ -348,6 +349,12 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 
+	rc = ssi_ivgen_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("ssi_ivgen_init failed\n");
+		goto init_cc_res_err;
+	}
+
 	/* Allocate crypto algs */
 	rc = ssi_ablkcipher_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
@@ -369,6 +376,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (new_drvdata != NULL) {
 		ssi_hash_free(new_drvdata);
 		ssi_ablkcipher_free(new_drvdata);
+		ssi_ivgen_fini(new_drvdata);
 		ssi_power_mgr_fini(new_drvdata);
 		ssi_buffer_mgr_fini(new_drvdata);
 		request_mgr_fini(new_drvdata);
@@ -410,6 +418,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 
         ssi_hash_free(drvdata);
         ssi_ablkcipher_free(drvdata);
+	ssi_ivgen_fini(drvdata);
 	ssi_power_mgr_fini(drvdata);
 	ssi_buffer_mgr_fini(drvdata);
 	request_mgr_fini(drvdata);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 49931be..a5a2427 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -106,9 +106,15 @@
 #define MIN(a, b) (((a) < (b)) ? (a) : (b))
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
 
+#define SSI_MAX_IVGEN_DMA_ADDRESSES 	3
 struct ssi_crypto_req {
 	void (*user_cb)(struct device *dev, void *req, void __iomem *cc_base);
 	void *user_arg;
+	dma_addr_t ivgen_dma_addr[SSI_MAX_IVGEN_DMA_ADDRESSES]; /* For the first 'ivgen_dma_addr_len' addresses of this array,
+					 generated IV would be placed in it by send_request().
+					 Same generated IV for all addresses! */
+	unsigned int ivgen_dma_addr_len; /* Amount of 'ivgen_dma_addr' elements to be filled. */
+	unsigned int ivgen_size; /* The generated IV size required, 8/16 B allowed. */
 	struct completion seq_compl; /* request completion */
 #ifdef ENABLE_CYCLE_COUNT
 	enum stat_op op_type;
@@ -144,6 +150,7 @@ struct ssi_drvdata {
 	void *hash_handle;
 	void *blkcipher_handle;
 	void *request_mgr_handle;
+	void *ivgen_handle;
 	void *sram_mgr_handle;
 
 #ifdef ENABLE_CYCLE_COUNT
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
new file mode 100644
index 0000000..f16f469
--- /dev/null
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -0,0 +1,301 @@
+/*
+ * Copyright (C) 2012-2017 ARM Limited or its affiliates.
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/platform_device.h>
+#include <crypto/ctr.h>
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "ssi_ivgen.h"
+#include "ssi_request_mgr.h"
+#include "ssi_sram_mgr.h"
+#include "ssi_buffer_mgr.h"
+
+/* The max. size of pool *MUST* be <= SRAM total size */
+#define SSI_IVPOOL_SIZE 1024
+/* The first 32B fraction of pool are dedicated to the
+   next encryption "key" & "IV" for pool regeneration */
+#define SSI_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
+#define SSI_IVPOOL_GEN_SEQ_LEN	4
+
+/**
+ * struct ssi_ivgen_ctx -IV pool generation context 
+ * @pool:          the start address of the iv-pool resides in internal RAM 
+ * @ctr_key_dma:   address of pool's encryption key material in internal RAM
+ * @ctr_iv_dma:    address of pool's counter iv in internal RAM
+ * @next_iv_ofs:   the offset to the next available IV in pool
+ * @pool_meta:     virt. address of the initial enc. key/IV
+ * @pool_meta_dma: phys. address of the initial enc. key/IV
+ */
+struct ssi_ivgen_ctx {
+	ssi_sram_addr_t pool;
+	ssi_sram_addr_t ctr_key;
+	ssi_sram_addr_t ctr_iv;
+	uint32_t next_iv_ofs;
+	uint8_t *pool_meta;
+	dma_addr_t pool_meta_dma;
+};
+
+/*!
+ * Generates SSI_IVPOOL_SIZE of random bytes by 
+ * encrypting 0's using AES128-CTR.
+ * 
+ * \param ivgen iv-pool context
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length 
+ */
+static int ssi_ivgen_generate_pool(
+	struct ssi_ivgen_ctx *ivgen_ctx,
+	HwDesc_s iv_seq[],
+	unsigned int *iv_seq_len)
+{
+	unsigned int idx = *iv_seq_len;
+
+	if ( (*iv_seq_len + SSI_IVPOOL_GEN_SEQ_LEN) > SSI_IVPOOL_SEQ_LEN) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+	/* Setup key */
+	HW_DESC_INIT(&iv_seq[idx]);
+	HW_DESC_SET_DIN_SRAM(&iv_seq[idx], ivgen_ctx->ctr_key, AES_KEYSIZE_128);
+	HW_DESC_SET_SETUP_MODE(&iv_seq[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_CONFIG0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], S_DIN_to_AES);
+	HW_DESC_SET_KEY_SIZE_AES(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_CIPHER_MODE(&iv_seq[idx], DRV_CIPHER_CTR);
+	idx++;
+
+	/* Setup cipher state */
+	HW_DESC_INIT(&iv_seq[idx]);
+	HW_DESC_SET_DIN_SRAM(&iv_seq[idx], ivgen_ctx->ctr_iv, CC_AES_IV_SIZE);
+	HW_DESC_SET_CIPHER_CONFIG0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], S_DIN_to_AES);
+	HW_DESC_SET_SETUP_MODE(&iv_seq[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_KEY_SIZE_AES(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_CIPHER_MODE(&iv_seq[idx], DRV_CIPHER_CTR);
+	idx++;
+
+	/* Perform dummy encrypt to skip first block */
+	HW_DESC_INIT(&iv_seq[idx]);
+	HW_DESC_SET_DIN_CONST(&iv_seq[idx], 0, CC_AES_IV_SIZE);
+	HW_DESC_SET_DOUT_SRAM(&iv_seq[idx], ivgen_ctx->pool, CC_AES_IV_SIZE);
+	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], DIN_AES_DOUT);
+	idx++;
+
+	/* Generate IV pool */
+	HW_DESC_INIT(&iv_seq[idx]);
+	HW_DESC_SET_DIN_CONST(&iv_seq[idx], 0, SSI_IVPOOL_SIZE);
+	HW_DESC_SET_DOUT_SRAM(&iv_seq[idx], ivgen_ctx->pool, SSI_IVPOOL_SIZE);
+	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], DIN_AES_DOUT);
+	idx++;
+
+	*iv_seq_len = idx; /* Update sequence length */
+
+	/* queue ordering assures pool readiness */
+	ivgen_ctx->next_iv_ofs = SSI_IVPOOL_META_SIZE;
+
+	return 0;
+}
+
+/*!
+ * Generates the initial pool in SRAM. 
+ * This function should be invoked when resuming DX driver. 
+ * 
+ * \param drvdata 
+ *  
+ * \return int Zero for success, negative value otherwise.
+ */
+int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
+{
+	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	HwDesc_s iv_seq[SSI_IVPOOL_SEQ_LEN];
+	unsigned int iv_seq_len = 0;
+	int rc;
+
+	/* Generate initial enc. key/iv */
+	get_random_bytes(ivgen_ctx->pool_meta, SSI_IVPOOL_META_SIZE);
+
+	/* The first 32B reserved for the enc. Key/IV */
+	ivgen_ctx->ctr_key = ivgen_ctx->pool;
+	ivgen_ctx->ctr_iv = ivgen_ctx->pool + AES_KEYSIZE_128;
+
+	/* Copy initial enc. key and IV to SRAM at a single descriptor */
+	HW_DESC_INIT(&iv_seq[iv_seq_len]);
+	HW_DESC_SET_DIN_TYPE(&iv_seq[iv_seq_len], DMA_DLLI,
+		ivgen_ctx->pool_meta_dma, SSI_IVPOOL_META_SIZE,
+		NS_BIT);
+	HW_DESC_SET_DOUT_SRAM(&iv_seq[iv_seq_len], ivgen_ctx->pool,
+		SSI_IVPOOL_META_SIZE);
+	HW_DESC_SET_FLOW_MODE(&iv_seq[iv_seq_len], BYPASS);
+	iv_seq_len++;
+
+	/* Generate initial pool */
+	rc = ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, &iv_seq_len);
+	if (unlikely(rc != 0)) {
+		return rc;
+	}
+	/* Fire-and-forget */
+	return send_request_init(drvdata, iv_seq, iv_seq_len);
+}
+
+/*!
+ * Free iv-pool and ivgen context.
+ *  
+ * \param drvdata 
+ */
+void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
+{
+	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct device *device = &(drvdata->plat_dev->dev);
+
+	if (ivgen_ctx == NULL)
+		return;
+
+	if (ivgen_ctx->pool_meta != NULL) {
+		memset(ivgen_ctx->pool_meta, 0, SSI_IVPOOL_META_SIZE);
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(ivgen_ctx->pool_meta_dma);
+		dma_free_coherent(device, SSI_IVPOOL_META_SIZE,
+			ivgen_ctx->pool_meta, ivgen_ctx->pool_meta_dma);
+	}
+
+	ivgen_ctx->pool = NULL_SRAM_ADDR;
+
+	/* release "this" context */
+	kfree(ivgen_ctx);
+}
+
+/*!
+ * Allocates iv-pool and maps resources. 
+ * This function generates the first IV pool.  
+ * 
+ * \param drvdata Driver's private context
+ * 
+ * \return int Zero for success, negative value otherwise.
+ */
+int ssi_ivgen_init(struct ssi_drvdata *drvdata)
+{
+	struct ssi_ivgen_ctx *ivgen_ctx;
+	struct device *device = &drvdata->plat_dev->dev;
+	int rc;
+
+	/* Allocate "this" context */
+	drvdata->ivgen_handle = kzalloc(sizeof(struct ssi_ivgen_ctx), GFP_KERNEL);
+	if (!drvdata->ivgen_handle) {
+		SSI_LOG_ERR("Not enough memory to allocate IVGEN context "
+			   "(%zu B)\n", sizeof(struct ssi_ivgen_ctx));
+		rc = -ENOMEM;
+		goto out;
+	}
+	ivgen_ctx = drvdata->ivgen_handle;
+
+	/* Allocate pool's header for intial enc. key/IV */
+	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
+			&ivgen_ctx->pool_meta_dma, GFP_KERNEL);
+	if (!ivgen_ctx->pool_meta) {
+		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta "
+			   "(%u B)\n", SSI_IVPOOL_META_SIZE);
+		rc = -ENOMEM;
+		goto out;
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(ivgen_ctx->pool_meta_dma,
+							SSI_IVPOOL_META_SIZE);
+	/* Allocate IV pool in SRAM */
+	ivgen_ctx->pool = ssi_sram_mgr_alloc(drvdata, SSI_IVPOOL_SIZE);
+	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
+		SSI_LOG_ERR("SRAM pool exhausted\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	return ssi_ivgen_init_sram_pool(drvdata);
+
+out:
+	ssi_ivgen_fini(drvdata);
+	return rc;
+}
+
+/*!
+ * Acquires 16 Bytes IV from the iv-pool
+ * 
+ * \param drvdata Driver private context
+ * \param iv_out_dma Array of physical IV out addresses
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements of iv_out_dma array are ignore)
+ * \param iv_out_size May be 8 or 16 bytes long 
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length 
+ *  
+ * \return int Zero for success, negative value otherwise. 
+ */
+int ssi_ivgen_getiv(
+	struct ssi_drvdata *drvdata,
+	dma_addr_t iv_out_dma[],
+	unsigned int iv_out_dma_len,
+	unsigned int iv_out_size,
+	HwDesc_s iv_seq[],
+	unsigned int *iv_seq_len)
+{
+	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	unsigned int idx = *iv_seq_len;
+	unsigned int t;
+
+	if ((iv_out_size != CC_AES_IV_SIZE) &&
+	    (iv_out_size != CTR_RFC3686_IV_SIZE)) {
+		return -EINVAL;
+	}
+	if ( (iv_out_dma_len + 1) > SSI_IVPOOL_SEQ_LEN) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+
+	//check that number of generated IV is limited to max dma address iv buffer size
+	if ( iv_out_dma_len > SSI_MAX_IVGEN_DMA_ADDRESSES) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+
+	for (t = 0; t < iv_out_dma_len; t++) {
+		/* Acquire IV from pool */
+		HW_DESC_INIT(&iv_seq[idx]);
+		HW_DESC_SET_DIN_SRAM(&iv_seq[idx],
+			ivgen_ctx->pool + ivgen_ctx->next_iv_ofs,
+			iv_out_size);
+		HW_DESC_SET_DOUT_DLLI(&iv_seq[idx], iv_out_dma[t],
+			iv_out_size, NS_BIT, 0);
+		HW_DESC_SET_FLOW_MODE(&iv_seq[idx], BYPASS);
+		idx++;
+	}
+
+	/* Bypass operation is proceeded by crypto sequence, hence must
+	*  assure bypass-write-transaction by a memory barrier */
+	HW_DESC_INIT(&iv_seq[idx]);
+	HW_DESC_SET_DIN_NO_DMA(&iv_seq[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_NO_DMA(&iv_seq[idx], 0, 0, 1);
+	idx++;
+
+	*iv_seq_len = idx; /* update seq length */
+
+	/* Update iv index */
+	ivgen_ctx->next_iv_ofs += iv_out_size;
+
+	if ((SSI_IVPOOL_SIZE - ivgen_ctx->next_iv_ofs) < CC_AES_IV_SIZE) {
+		SSI_LOG_DEBUG("Pool exhausted, regenerating iv-pool\n");
+		/* pool is drained -regenerate it! */
+		return ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, iv_seq_len);
+	}
+
+	return 0;
+}
+
+
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
new file mode 100644
index 0000000..bc69cd8
--- /dev/null
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2012-2017 ARM Limited or its affiliates.
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __SSI_IVGEN_H__
+#define __SSI_IVGEN_H__
+
+#include "cc_hw_queue_defs.h"
+
+
+#define SSI_IVPOOL_SEQ_LEN 8
+
+/*!
+ * Allocates iv-pool and maps resources. 
+ * This function generates the first IV pool.  
+ * 
+ * \param drvdata Driver's private context
+ * 
+ * \return int Zero for success, negative value otherwise.
+ */
+int ssi_ivgen_init(struct ssi_drvdata *drvdata);
+
+/*!
+ * Free iv-pool and ivgen context.
+ *  
+ * \param drvdata 
+ */
+void ssi_ivgen_fini(struct ssi_drvdata *drvdata);
+
+/*!
+ * Generates the initial pool in SRAM. 
+ * This function should be invoked when resuming DX driver. 
+ * 
+ * \param drvdata 
+ *  
+ * \return int Zero for success, negative value otherwise.
+ */
+int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata);
+
+/*!
+ * Acquires 16 Bytes IV from the iv-pool
+ * 
+ * \param drvdata Driver private context
+ * \param iv_out_dma Array of physical IV out addresses
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements of iv_out_dma array are ignore)
+ * \param iv_out_size May be 8 or 16 bytes long 
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length 
+ *  
+ * \return int Zero for success, negative value otherwise. 
+ */
+int ssi_ivgen_getiv(
+	struct ssi_drvdata *drvdata,
+	dma_addr_t iv_out_dma[],
+	unsigned int iv_out_dma_len,
+	unsigned int iv_out_size,
+	HwDesc_s iv_seq[],
+	unsigned int *iv_seq_len);
+
+#endif /*__SSI_IVGEN_H__*/
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index ec6d655..dd399f2 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -26,6 +26,7 @@
 #include "ssi_request_mgr.h"
 #include "ssi_sram_mgr.h"
 #include "ssi_sysfs.h"
+#include "ssi_ivgen.h"
 #include "ssi_hash.h"
 #include "ssi_pm.h"
 #include "ssi_pm_ext.h"
@@ -83,6 +84,7 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 	/* must be after the queue resuming as it uses the HW queue*/
 	ssi_hash_init_sram_digest_consts(drvdata);
 	
+	ssi_ivgen_init_sram_pool(drvdata);
 	return 0;
 }
 
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 62ef6e7..88f475d 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -28,6 +28,7 @@
 #include "ssi_buffer_mgr.h"
 #include "ssi_request_mgr.h"
 #include "ssi_sysfs.h"
+#include "ssi_ivgen.h"
 #include "ssi_pm.h"
 
 #define SSI_MAX_POLL_ITER	10
@@ -359,9 +360,14 @@ int send_request(
 	void __iomem *cc_base = drvdata->cc_base;
 	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int used_sw_slots;
+	unsigned int iv_seq_len = 0;
 	unsigned int total_seq_len = len; /*initial sequence length*/
+	HwDesc_s iv_seq[SSI_IVPOOL_SEQ_LEN];
 	int rc;
-	unsigned int max_required_seq_len = total_seq_len + ((is_dout == 0) ? 1 : 0);
+	unsigned int max_required_seq_len = (total_seq_len +
+					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
+					SSI_IVPOOL_SEQ_LEN ) +
+					((is_dout == 0 )? 1 : 0));
 	DECL_CYCLE_COUNT_RESOURCES;
 
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
@@ -410,6 +416,30 @@ int send_request(
 		total_seq_len++;
 	}
 
+	if (ssi_req->ivgen_dma_addr_len > 0) {
+		SSI_LOG_DEBUG("Acquire IV from pool into %d DMA addresses 0x%llX, 0x%llX, 0x%llX, IV-size=%u\n",
+			ssi_req->ivgen_dma_addr_len,
+			(unsigned long long)ssi_req->ivgen_dma_addr[0],
+			(unsigned long long)ssi_req->ivgen_dma_addr[1],
+			(unsigned long long)ssi_req->ivgen_dma_addr[2],
+			ssi_req->ivgen_size);
+
+		/* Acquire IV from pool */
+		rc = ssi_ivgen_getiv(drvdata, ssi_req->ivgen_dma_addr, ssi_req->ivgen_dma_addr_len,
+			ssi_req->ivgen_size, iv_seq, &iv_seq_len);
+
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("Failed to generate IV (rc=%d)\n", rc);
+			spin_unlock_bh(&req_mgr_h->hw_lock);
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
+#endif
+			return rc;
+		}
+
+		total_seq_len += iv_seq_len;
+	}
+	
 	used_sw_slots = ((req_mgr_h->req_queue_head - req_mgr_h->req_queue_tail) & (MAX_REQUEST_QUEUE_SIZE-1));
 	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots)) {
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
@@ -432,6 +462,7 @@ int send_request(
 
 	/* STAT_PHASE_4: Push sequence */
 	START_CYCLE_COUNT();
+	enqueue_seq(cc_base, iv_seq, iv_seq_len);
 	enqueue_seq(cc_base, desc, len);
 	enqueue_seq(cc_base, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
 	END_CYCLE_COUNT(ssi_req->op_type, STAT_PHASE_4);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
