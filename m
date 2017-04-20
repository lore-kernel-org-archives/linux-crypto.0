From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 3/9] staging: ccree: add skcipher support
Date: Thu, 20 Apr 2017 16:12:57 +0300
Message-ID: <1492693983-8175-4-git-send-email-gilad@benyossef.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, devicetree@vger.kernel.org,
 gilad.benyossef@arm.com, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Stuart Yoder <stuart.yoder@arm.com>,
 Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Add CryptoCell skcipher support

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig          |    8 +
 drivers/staging/ccree/Makefile         |    2 +-
 drivers/staging/ccree/cc_crypto_ctx.h  |   21 +
 drivers/staging/ccree/ssi_buffer_mgr.c |  147 ++++
 drivers/staging/ccree/ssi_buffer_mgr.h |   16 +
 drivers/staging/ccree/ssi_cipher.c     | 1440 ++++++++++++++++++++++++++++++++
 drivers/staging/ccree/ssi_cipher.h     |   88 ++
 drivers/staging/ccree/ssi_driver.c     |   14 +
 drivers/staging/ccree/ssi_driver.h     |   30 +
 9 files changed, 1765 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/ccree/ssi_cipher.c
 create mode 100644 drivers/staging/ccree/ssi_cipher.h

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index a528a99..3fff040 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -3,11 +3,19 @@ config CRYPTO_DEV_CCREE
 	depends on CRYPTO_HW && OF && HAS_DMA
 	default n
 	select CRYPTO_HASH
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_DES
+	select CRYPTO_AUTHENC
 	select CRYPTO_SHA1
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_HMAC
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_CTR
+	select CRYPTO_XTS
 	help
 	  Say 'Y' to enable a driver for the Arm TrustZone CryptoCell 
 	  C7xx. Currently only the CryptoCell 712 REE is supported.
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index f94e225..21a80d5 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_hash.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
+ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index fedf259..f198779 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -242,6 +242,27 @@ struct drv_ctx_hmac {
 			CC_DIGEST_SIZE_MAX - CC_HMAC_BLOCK_SIZE_MAX];
 };
 
+struct drv_ctx_cipher {
+	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_AES */
+	enum drv_cipher_mode mode;
+	enum drv_crypto_direction direction;
+	enum drv_crypto_key_type crypto_key_type;
+	enum drv_crypto_padding_type padding_type;
+	uint32_t key_size; /* numeric value in bytes   */
+	uint32_t data_unit_size; /* required for XTS */
+	/* block_state is the AES engine block state.
+	*  It is used by the host to pass IV or counter at initialization.
+	*  It is used by SeP for intermediate block chaining state and for
+	*  returning MAC algorithms results.           */
+	uint8_t block_state[CC_AES_BLOCK_SIZE];
+	uint8_t key[CC_AES_KEY_SIZE_MAX];
+	uint8_t xex_key[CC_AES_KEY_SIZE_MAX];
+	/* reserve to end of allocated context size */
+	uint32_t reserved[CC_DRV_CTX_SIZE_WORDS - 7 -
+		CC_AES_BLOCK_SIZE/sizeof(uint32_t) - 2 *
+		(CC_AES_KEY_SIZE_MAX/sizeof(uint32_t))];
+};
+
 /*******************************************************************/
 /***************** MESSAGE BASED CONTEXTS **************************/
 /*******************************************************************/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 5144eaa..a0fafa9 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -28,6 +28,7 @@
 
 #include "ssi_buffer_mgr.h"
 #include "cc_lli_defs.h"
+#include "ssi_cipher.h"
 #include "ssi_hash.h"
 
 #define LLI_MAX_NUM_OF_DATA_ENTRIES 128
@@ -517,6 +518,152 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	return 0;
 }
 
+void ssi_buffer_mgr_unmap_blkcipher_request(
+	struct device *dev,
+	void *ctx,
+	unsigned int ivsize,
+	struct scatterlist *src,
+	struct scatterlist *dst)
+{
+	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
+
+	if (likely(req_ctx->gen_ctx.iv_dma_addr != 0)) {
+		SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=0x%llX iv_size=%u\n", 
+			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr,
+			ivsize);
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_ctx->gen_ctx.iv_dma_addr);
+		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr, 
+				 ivsize, 
+				 DMA_TO_DEVICE);
+	}
+	/* Release pool */
+	if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_ctx->mlli_params.mlli_dma_addr);
+		dma_pool_free(req_ctx->mlli_params.curr_pool,
+			      req_ctx->mlli_params.mlli_virt_addr,
+			      req_ctx->mlli_params.mlli_dma_addr);
+	}
+
+	SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(src));
+	dma_unmap_sg(dev, src, req_ctx->in_nents,
+		DMA_BIDIRECTIONAL);
+	SSI_LOG_DEBUG("Unmapped req->src=%pK\n", 
+		     sg_virt(src));
+
+	if (src != dst) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(dst));
+		dma_unmap_sg(dev, dst, req_ctx->out_nents, 
+			DMA_BIDIRECTIONAL);
+		SSI_LOG_DEBUG("Unmapped req->dst=%pK\n",
+			sg_virt(dst));
+	}
+}
+
+int ssi_buffer_mgr_map_blkcipher_request(
+	struct ssi_drvdata *drvdata,
+	void *ctx,
+	unsigned int ivsize,
+	unsigned int nbytes,
+	void *info,
+	struct scatterlist *src,
+	struct scatterlist *dst)
+{
+	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
+	struct mlli_params *mlli_params = &req_ctx->mlli_params;	
+	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
+	struct device *dev = &drvdata->plat_dev->dev;
+	struct buffer_array sg_data;
+	uint32_t dummy = 0;
+	int rc = 0;
+	uint32_t mapped_nents = 0;
+
+	req_ctx->dma_buf_type = SSI_DMA_BUF_DLLI;
+	mlli_params->curr_pool = NULL;
+	sg_data.num_of_buffers = 0;
+
+	/* Map IV buffer */
+	if (likely(ivsize != 0) ) {
+		dump_byte_array("iv", (uint8_t *)info, ivsize);
+		req_ctx->gen_ctx.iv_dma_addr = 
+			dma_map_single(dev, (void *)info, 
+				       ivsize, 
+				       DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, 
+					req_ctx->gen_ctx.iv_dma_addr))) {
+			SSI_LOG_ERR("Mapping iv %u B at va=%pK "
+				   "for DMA failed\n", ivsize, info);
+			return -ENOMEM;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(req_ctx->gen_ctx.iv_dma_addr,
+								ivsize);
+		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
+			ivsize, info,
+			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr);
+	} else
+		req_ctx->gen_ctx.iv_dma_addr = 0;
+	
+	/* Map the src SGL */
+	rc = ssi_buffer_mgr_map_scatterlist(dev, src,
+		nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
+		LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
+	if (unlikely(rc != 0)) {
+		rc = -ENOMEM;
+		goto ablkcipher_exit;
+	}
+	if (mapped_nents > 1)
+		req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
+
+	if (unlikely(src == dst)) {
+		/* Handle inplace operation */
+		if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
+			req_ctx->out_nents = 0;
+			ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
+				req_ctx->in_nents, src,
+				nbytes, 0, true, &req_ctx->in_mlli_nents);
+		}
+	} else {
+		/* Map the dst sg */
+		if (unlikely(ssi_buffer_mgr_map_scatterlist(
+			dev,dst, nbytes,
+			DMA_BIDIRECTIONAL, &req_ctx->out_nents,
+			LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
+			&mapped_nents))){
+			rc = -ENOMEM;
+			goto ablkcipher_exit;
+		}
+		if (mapped_nents > 1)
+			req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
+
+		if (unlikely((req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI))) {
+			ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
+				req_ctx->in_nents, src,
+				nbytes, 0, true,
+				&req_ctx->in_mlli_nents);
+			ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
+				req_ctx->out_nents, dst,
+				nbytes, 0, true, 
+				&req_ctx->out_mlli_nents);
+		}
+	}
+	
+	if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
+		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
+		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
+		if (unlikely(rc!= 0))
+			goto ablkcipher_exit;
+
+	}
+
+	SSI_LOG_DEBUG("areq_ctx->dma_buf_type = %s\n",
+		GET_DMA_BUFFER_TYPE(req_ctx->dma_buf_type));
+
+	return 0;
+
+ablkcipher_exit:
+	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	return rc;
+}
+
 int ssi_buffer_mgr_map_hash_request_final(
 	struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update)
 {
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index ccac5ce..2c58a63 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -55,6 +55,22 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata);
 
 int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata);
 
+int ssi_buffer_mgr_map_blkcipher_request(
+	struct ssi_drvdata *drvdata,
+	void *ctx,
+	unsigned int ivsize,
+	unsigned int nbytes,
+	void *info,
+	struct scatterlist *src,
+	struct scatterlist *dst);
+
+void ssi_buffer_mgr_unmap_blkcipher_request(
+	struct device *dev, 
+	void *ctx,
+	unsigned int ivsize,
+	struct scatterlist *src,
+	struct scatterlist *dst);
+
 int ssi_buffer_mgr_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update);
 
 int ssi_buffer_mgr_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, unsigned int block_size);
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
new file mode 100644
index 0000000..01467e8
--- /dev/null
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -0,0 +1,1440 @@
+/*
+ * Copyright (C) 2012-2016 ARM Limited or its affiliates.
+ * 
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/semaphore.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/aes.h>
+#include <crypto/ctr.h>
+#include <crypto/des.h>
+
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "cc_lli_defs.h"
+#include "ssi_buffer_mgr.h"
+#include "ssi_cipher.h"
+#include "ssi_request_mgr.h"
+#include "ssi_sysfs.h"
+
+#define MAX_ABLKCIPHER_SEQ_LEN 6
+
+#define template_ablkcipher	template_u.ablkcipher
+#define template_sblkcipher	template_u.blkcipher
+
+#define SSI_MIN_AES_XTS_SIZE 0x10
+#define SSI_MAX_AES_XTS_SIZE 0x2000
+struct ssi_blkcipher_handle {
+	struct list_head blkcipher_alg_list;
+};
+
+struct cc_user_key_info {
+	uint8_t *key;
+	dma_addr_t key_dma_addr;
+};
+struct cc_hw_key_info {
+	enum HwCryptoKey key1_slot;
+	enum HwCryptoKey key2_slot;
+};
+
+struct ssi_ablkcipher_ctx {
+	struct ssi_drvdata *drvdata;
+	int keylen;
+	int key_round_number;
+	int cipher_mode;
+	int flow_mode;
+	unsigned int flags;
+	struct blkcipher_req_ctx *sync_ctx;
+	struct cc_user_key_info user;
+	struct cc_hw_key_info hw;
+	struct crypto_shash *shash_tfm;
+};
+
+static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base);
+
+
+static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, uint32_t size) {
+	switch (ctx_p->flow_mode){
+	case S_DIN_to_AES:
+		switch (size){
+		case CC_AES_128_BIT_KEY_SIZE:
+		case CC_AES_192_BIT_KEY_SIZE:
+			if (likely((ctx_p->cipher_mode != DRV_CIPHER_XTS) &&
+				   (ctx_p->cipher_mode != DRV_CIPHER_ESSIV) &&
+				   (ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)))
+				return 0;
+			break;
+		case CC_AES_256_BIT_KEY_SIZE:
+			return 0;
+		case (CC_AES_192_BIT_KEY_SIZE*2):
+		case (CC_AES_256_BIT_KEY_SIZE*2):
+			if (likely((ctx_p->cipher_mode == DRV_CIPHER_XTS) ||
+				   (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) ||
+				   (ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)))
+				return 0;
+			break;
+		default:
+			break;
+		}
+	case S_DIN_to_DES:
+		if (likely(size == DES3_EDE_KEY_SIZE ||
+		    size == DES_KEY_SIZE))
+			return 0;
+		break;
+#if SSI_CC_HAS_MULTI2
+	case S_DIN_to_MULTI2:
+		if (likely(size == CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE))
+			return 0;
+		break;
+#endif
+	default:
+		break;
+
+	}
+	return -EINVAL;
+}
+
+
+static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size) {
+	switch (ctx_p->flow_mode){
+	case S_DIN_to_AES:
+		switch (ctx_p->cipher_mode){
+		case DRV_CIPHER_XTS:
+			if ((size >= SSI_MIN_AES_XTS_SIZE) &&
+			    (size <= SSI_MAX_AES_XTS_SIZE) && 
+			    IS_ALIGNED(size, AES_BLOCK_SIZE))
+				return 0;
+			break;
+		case DRV_CIPHER_CBC_CTS:
+			if (likely(size >= AES_BLOCK_SIZE))
+				return 0;
+			break;
+		case DRV_CIPHER_OFB:
+		case DRV_CIPHER_CTR:
+				return 0;
+		case DRV_CIPHER_ECB:
+		case DRV_CIPHER_CBC:
+		case DRV_CIPHER_ESSIV:
+		case DRV_CIPHER_BITLOCKER:
+			if (likely(IS_ALIGNED(size, AES_BLOCK_SIZE)))
+				return 0;
+			break;
+		default:
+			break;
+		}
+		break;
+	case S_DIN_to_DES:
+		if (likely(IS_ALIGNED(size, DES_BLOCK_SIZE)))
+				return 0;
+		break;
+#if SSI_CC_HAS_MULTI2
+	case S_DIN_to_MULTI2:
+		switch (ctx_p->cipher_mode) {
+		case DRV_MULTI2_CBC:
+			if (likely(IS_ALIGNED(size, CC_MULTI2_BLOCK_SIZE)))
+				return 0;
+			break;
+		case DRV_MULTI2_OFB:
+			return 0;
+		default:
+			break;
+		}
+		break;
+#endif /*SSI_CC_HAS_MULTI2*/
+	default:
+		break;
+
+	}
+	return -EINVAL;
+}
+
+static unsigned int get_max_keysize(struct crypto_tfm *tfm)
+{
+	struct ssi_crypto_alg *ssi_alg = container_of(tfm->__crt_alg, struct ssi_crypto_alg, crypto_alg);
+
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_ABLKCIPHER) {
+		return ssi_alg->crypto_alg.cra_ablkcipher.max_keysize;
+	}
+
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_BLKCIPHER) {
+		return ssi_alg->crypto_alg.cra_blkcipher.max_keysize;
+	}
+
+	return 0;
+}
+
+static int ssi_blkcipher_init(struct crypto_tfm *tfm)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct ssi_crypto_alg *ssi_alg =
+			container_of(alg, struct ssi_crypto_alg, crypto_alg);
+	struct device *dev;
+	int rc = 0;
+	unsigned int max_key_buf_size = get_max_keysize(tfm);
+
+	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx_p, 
+						crypto_tfm_alg_name(tfm));
+
+	ctx_p->cipher_mode = ssi_alg->cipher_mode;
+	ctx_p->flow_mode = ssi_alg->flow_mode;
+	ctx_p->drvdata = ssi_alg->drvdata;
+	dev = &ctx_p->drvdata->plat_dev->dev;
+
+	/* Allocate key buffer, cache line aligned */
+	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL|GFP_DMA);
+	if (!ctx_p->user.key) {
+		SSI_LOG_ERR("Allocating key buffer in context failed\n");
+		rc = -ENOMEM;
+	}
+	SSI_LOG_DEBUG("Allocated key buffer in context. key=@%p\n",
+		      ctx_p->user.key);
+
+	/* Map key buffer */
+	ctx_p->user.key_dma_addr = dma_map_single(dev, (void *)ctx_p->user.key,
+					     max_key_buf_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
+		SSI_LOG_ERR("Mapping Key %u B at va=%pK for DMA failed\n",
+			max_key_buf_size, ctx_p->user.key);
+		return -ENOMEM;
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr, max_key_buf_size);
+	SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=0x%llX\n",
+		max_key_buf_size, ctx_p->user.key,
+		(unsigned long long)ctx_p->user.key_dma_addr);
+
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Alloc hash tfm for essiv */
+		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
+		if (IS_ERR(ctx_p->shash_tfm)) {
+			SSI_LOG_ERR("Error allocating hash tfm for ESSIV.\n");
+			return PTR_ERR(ctx_p->shash_tfm);
+		}
+	}
+
+	return rc;
+}
+
+static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
+	unsigned int max_key_buf_size = get_max_keysize(tfm);
+
+	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
+		crypto_tfm_ctx(tfm), crypto_tfm_alg_name(tfm));
+
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Free hash tfm for essiv */
+		crypto_free_shash(ctx_p->shash_tfm);
+		ctx_p->shash_tfm = NULL;
+	}
+
+	/* Unmap key buffer */
+	SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr);
+	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
+								DMA_TO_DEVICE);
+	SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=0x%llX\n", 
+		(unsigned long long)ctx_p->user.key_dma_addr);
+
+	/* Free key buffer in context */
+	kfree(ctx_p->user.key);
+	SSI_LOG_DEBUG("Free key buffer in context. key=@%p\n", ctx_p->user.key);
+}
+
+
+typedef struct tdes_keys{
+        u8      key1[DES_KEY_SIZE];
+        u8      key2[DES_KEY_SIZE];
+        u8      key3[DES_KEY_SIZE];
+}tdes_keys_t;
+
+static const u8 zero_buff[] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
+                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
+                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
+
+static enum HwCryptoKey hw_key_to_cc_hw_key(int slot_num)
+{
+	switch (slot_num) {
+	case 0:
+		return KFDE0_KEY;
+	case 1:
+		return KFDE1_KEY;
+	case 2:
+		return KFDE2_KEY;
+	case 3:
+		return KFDE3_KEY;
+	}
+	return END_OF_KEYS;
+}
+
+static int ssi_blkcipher_setkey(struct crypto_tfm *tfm, 
+				const u8 *key, 
+				unsigned int keylen)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
+	u32 tmp[DES_EXPKEY_WORDS];
+	unsigned int max_key_buf_size = get_max_keysize(tfm);
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	SSI_LOG_DEBUG("Setting key in context @%p for %s. keylen=%u\n",
+		ctx_p, crypto_tfm_alg_name(tfm), keylen);
+	dump_byte_array("key", (uint8_t *)key, keylen);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+	START_CYCLE_COUNT();
+
+#if SSI_CC_HAS_MULTI2
+	/*last byte of key buffer is round number and should not be a part of key size*/
+	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
+		keylen -=1;
+	}
+#endif /*SSI_CC_HAS_MULTI2*/
+
+	if (unlikely(validate_keys_sizes(ctx_p,keylen) != 0)) {
+		SSI_LOG_ERR("Unsupported key size %d.\n", keylen);
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (ssi_is_hw_key(tfm)) {
+		/* setting HW key slots */
+		struct arm_hw_key_info *hki = (struct arm_hw_key_info*)key;
+
+		if (unlikely(ctx_p->flow_mode != S_DIN_to_AES)) {
+			SSI_LOG_ERR("HW key not supported for non-AES flows\n");
+			return -EINVAL;
+		}
+
+		ctx_p->hw.key1_slot = hw_key_to_cc_hw_key(hki->hw_key1);
+		if (unlikely(ctx_p->hw.key1_slot == END_OF_KEYS)) {
+			SSI_LOG_ERR("Unsupported hw key1 number (%d)\n", hki->hw_key1);
+			return -EINVAL;
+		}
+
+		if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) ||
+		    (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) ||
+		    (ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)) {
+			if (unlikely(hki->hw_key1 == hki->hw_key2)) {
+				SSI_LOG_ERR("Illegal hw key numbers (%d,%d)\n", hki->hw_key1, hki->hw_key2);
+				return -EINVAL;
+			}
+			ctx_p->hw.key2_slot = hw_key_to_cc_hw_key(hki->hw_key2);
+			if (unlikely(ctx_p->hw.key2_slot == END_OF_KEYS)) {
+				SSI_LOG_ERR("Unsupported hw key2 number (%d)\n", hki->hw_key2);
+				return -EINVAL;
+			}
+		}
+
+		ctx_p->keylen = keylen;
+		END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
+		SSI_LOG_DEBUG("ssi_blkcipher_setkey: ssi_is_hw_key ret 0");
+
+		return 0;
+	}
+
+	// verify weak keys
+	if (ctx_p->flow_mode == S_DIN_to_DES) {
+		if (unlikely(!des_ekey(tmp, key)) &&
+		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+			SSI_LOG_DEBUG("ssi_blkcipher_setkey:  weak DES key");
+			return -EINVAL;
+		}
+	}
+
+	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
+
+	/* STAT_PHASE_1: Copy key to ctx */
+	START_CYCLE_COUNT();
+	SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr);
+	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr, 
+					max_key_buf_size, DMA_TO_DEVICE);
+#if SSI_CC_HAS_MULTI2
+	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
+		memcpy(ctx_p->user.key, key, CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE);
+		ctx_p->key_round_number = key[CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE];
+		if (ctx_p->key_round_number < CC_MULTI2_MIN_NUM_ROUNDS ||
+		    ctx_p->key_round_number > CC_MULTI2_MAX_NUM_ROUNDS) {
+			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+			SSI_LOG_DEBUG("ssi_blkcipher_setkey: SSI_CC_HAS_MULTI2 einval");
+			return -EINVAL;
+		}
+	} else 
+#endif /*SSI_CC_HAS_MULTI2*/
+	{
+		memcpy(ctx_p->user.key, key, keylen);
+		if (keylen == 24)
+			memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+
+		if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+			/* sha256 for key2 - use sw implementation */
+			int key_len = keylen >> 1;
+			int err;
+			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
+			desc->tfm = ctx_p->shash_tfm;
+
+			err = crypto_shash_digest(desc, ctx_p->user.key, key_len, ctx_p->user.key + key_len);
+			if (err) {
+				SSI_LOG_ERR("Failed to hash ESSIV key.\n");
+				return err;
+			}
+		}
+	}
+	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr, 
+					max_key_buf_size, DMA_TO_DEVICE);
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr ,max_key_buf_size);
+	ctx_p->keylen = keylen;
+	
+	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
+
+	 SSI_LOG_DEBUG("ssi_blkcipher_setkey: return safely");
+	return 0;
+}
+
+static inline void
+ssi_blkcipher_create_setup_desc(
+	struct crypto_tfm *tfm,
+	struct blkcipher_req_ctx *req_ctx,
+	unsigned int ivsize,
+	unsigned int nbytes,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	int cipher_mode = ctx_p->cipher_mode;
+	int flow_mode = ctx_p->flow_mode;
+	int direction = req_ctx->gen_ctx.op_type;
+	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
+	unsigned int key_len = ctx_p->keylen;
+	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
+	unsigned int du_size = nbytes;
+
+	struct ssi_crypto_alg *ssi_alg = container_of(tfm->__crt_alg, struct ssi_crypto_alg, crypto_alg);
+
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) == CRYPTO_ALG_BULK_DU_512)
+		du_size = 512;
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) == CRYPTO_ALG_BULK_DU_4096)
+		du_size = 4096;
+
+	switch (cipher_mode) {
+	case DRV_CIPHER_CBC:
+	case DRV_CIPHER_CBC_CTS:
+	case DRV_CIPHER_CTR:
+	case DRV_CIPHER_OFB:
+		/* Load cipher state */
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+				     iv_dma_addr, ivsize,
+				     NS_BIT);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
+		if ((cipher_mode == DRV_CIPHER_CTR) || 
+		    (cipher_mode == DRV_CIPHER_OFB) ) {
+			HW_DESC_SET_SETUP_MODE(&desc[*seq_size],
+					       SETUP_LOAD_STATE1);
+		} else {
+			HW_DESC_SET_SETUP_MODE(&desc[*seq_size],
+					       SETUP_LOAD_STATE0);
+		}
+		(*seq_size)++;
+		/*FALLTHROUGH*/
+	case DRV_CIPHER_ECB:
+		/* Load key */
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		if (flow_mode == S_DIN_to_AES) {
+
+			if (ssi_is_hw_key(tfm)) {
+				HW_DESC_SET_HW_CRYPTO_KEY(&desc[*seq_size], ctx_p->hw.key1_slot);
+			} else {
+				HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+						     key_dma_addr, 
+						     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len),
+						     NS_BIT);
+			}
+			HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len);
+		} else {
+			/*des*/
+			HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+					     key_dma_addr, key_len,
+					     NS_BIT);
+			HW_DESC_SET_KEY_SIZE_DES(&desc[*seq_size], key_len);
+		}
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_KEY0);
+		(*seq_size)++;
+		break;
+	case DRV_CIPHER_XTS:
+	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
+		/* Load AES key */
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		if (ssi_is_hw_key(tfm)) {
+			HW_DESC_SET_HW_CRYPTO_KEY(&desc[*seq_size], ctx_p->hw.key1_slot);
+		} else {
+			HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+					     key_dma_addr, key_len/2,
+					     NS_BIT);
+		}
+		HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len/2);
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_KEY0);
+		(*seq_size)++;
+
+		/* load XEX key */
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		if (ssi_is_hw_key(tfm)) {
+			HW_DESC_SET_HW_CRYPTO_KEY(&desc[*seq_size], ctx_p->hw.key2_slot);
+		} else {
+			HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI, 
+					     (key_dma_addr+key_len/2), key_len/2,
+					     NS_BIT);
+		}
+		HW_DESC_SET_XEX_DATA_UNIT_SIZE(&desc[*seq_size], du_size);
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], S_DIN_to_AES2);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len/2);
+		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
+		(*seq_size)++;
+	
+		/* Set state */
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE1);
+		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len/2);
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+				     iv_dma_addr, CC_AES_BLOCK_SIZE,
+				     NS_BIT);
+		(*seq_size)++;
+		break;
+	default:
+		SSI_LOG_ERR("Unsupported cipher mode (%d)\n", cipher_mode);
+		BUG();
+	}
+}
+
+#if SSI_CC_HAS_MULTI2
+static inline void ssi_blkcipher_create_multi2_setup_desc(
+	struct crypto_tfm *tfm,
+	struct blkcipher_req_ctx *req_ctx,
+	unsigned int ivsize,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	
+	int direction = req_ctx->gen_ctx.op_type;
+	/* Load system key */
+	HW_DESC_INIT(&desc[*seq_size]);
+	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+	HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI, ctx_p->user.key_dma_addr,
+						CC_MULTI2_SYSTEM_KEY_SIZE,
+						NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
+	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_KEY0);
+	(*seq_size)++;
+
+	/* load data key */
+	HW_DESC_INIT(&desc[*seq_size]);
+	HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI, 
+					(ctx_p->user.key_dma_addr + 
+						CC_MULTI2_SYSTEM_KEY_SIZE),
+				CC_MULTI2_DATA_KEY_SIZE, NS_BIT);
+	HW_DESC_SET_MULTI2_NUM_ROUNDS(&desc[*seq_size],
+						ctx_p->key_round_number);
+	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
+	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE0 );
+	(*seq_size)++;
+	
+	
+	/* Set state */
+	HW_DESC_INIT(&desc[*seq_size]);
+	HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+			     req_ctx->gen_ctx.iv_dma_addr,
+			     ivsize, NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
+	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
+	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE1);	
+	(*seq_size)++;
+	
+}
+#endif /*SSI_CC_HAS_MULTI2*/
+
+static inline void
+ssi_blkcipher_create_data_desc(
+	struct crypto_tfm *tfm,
+	struct blkcipher_req_ctx *req_ctx,
+	struct scatterlist *dst, struct scatterlist *src,
+	unsigned int nbytes,
+	void *areq,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	unsigned int flow_mode = ctx_p->flow_mode;
+
+	switch (ctx_p->flow_mode) {
+	case S_DIN_to_AES:
+		flow_mode = DIN_AES_DOUT;
+		break;
+	case S_DIN_to_DES:
+		flow_mode = DIN_DES_DOUT;
+		break;
+#if SSI_CC_HAS_MULTI2
+	case S_DIN_to_MULTI2:
+		flow_mode = DIN_MULTI2_DOUT;
+		break;
+#endif /*SSI_CC_HAS_MULTI2*/
+	default:
+		SSI_LOG_ERR("invalid flow mode, flow_mode = %d \n", flow_mode);
+		return;
+	}
+	/* Process */
+	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)){
+		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
+			     (unsigned long long)sg_dma_address(src),
+			     nbytes);
+		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
+			     (unsigned long long)sg_dma_address(dst),
+			     nbytes);
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+				     sg_dma_address(src),
+				     nbytes, NS_BIT);
+		HW_DESC_SET_DOUT_DLLI(&desc[*seq_size],
+				      sg_dma_address(dst),
+				      nbytes,
+				      NS_BIT, (areq == NULL)? 0:1);
+		if (areq != NULL) {
+			HW_DESC_SET_QUEUE_LAST_IND(&desc[*seq_size]);
+		}
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		(*seq_size)++;
+	} else {
+		/* bypass */
+		SSI_LOG_DEBUG(" bypass params addr 0x%llX "
+			     "length 0x%X addr 0x%08X\n",
+			(unsigned long long)req_ctx->mlli_params.mlli_dma_addr,
+			req_ctx->mlli_params.mlli_len,
+			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+				     req_ctx->mlli_params.mlli_dma_addr,
+				     req_ctx->mlli_params.mlli_len,
+				     NS_BIT);
+		HW_DESC_SET_DOUT_SRAM(&desc[*seq_size],
+				      ctx_p->drvdata->mlli_sram_addr,
+				      req_ctx->mlli_params.mlli_len);
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], BYPASS);
+		(*seq_size)++;
+
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_MLLI,
+			ctx_p->drvdata->mlli_sram_addr,
+				     req_ctx->in_mlli_nents, NS_BIT);
+		if (req_ctx->out_nents == 0) {
+			SSI_LOG_DEBUG(" din/dout params addr 0x%08X "
+				     "addr 0x%08X\n",
+			(unsigned int)ctx_p->drvdata->mlli_sram_addr,
+			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+			HW_DESC_SET_DOUT_MLLI(&desc[*seq_size], 
+			ctx_p->drvdata->mlli_sram_addr,
+					      req_ctx->in_mlli_nents,
+					      NS_BIT,(areq == NULL)? 0:1);
+		} else {
+			SSI_LOG_DEBUG(" din/dout params "
+				     "addr 0x%08X addr 0x%08X\n",
+				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
+				(unsigned int)ctx_p->drvdata->mlli_sram_addr + 
+				(uint32_t)LLI_ENTRY_BYTE_SIZE * 
+							req_ctx->in_nents);
+			HW_DESC_SET_DOUT_MLLI(&desc[*seq_size], 
+				(ctx_p->drvdata->mlli_sram_addr +
+				LLI_ENTRY_BYTE_SIZE * 
+						req_ctx->in_mlli_nents), 
+				req_ctx->out_mlli_nents, NS_BIT,(areq == NULL)? 0:1);
+		}
+		if (areq != NULL) {
+			HW_DESC_SET_QUEUE_LAST_IND(&desc[*seq_size]);
+		}
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		(*seq_size)++;
+	}
+}
+
+static int ssi_blkcipher_complete(struct device *dev,
+                                  struct ssi_ablkcipher_ctx *ctx_p, 
+                                  struct blkcipher_req_ctx *req_ctx,
+                                  struct scatterlist *dst, struct scatterlist *src,
+                                  void *info, //req info
+                                  unsigned int ivsize,
+                                  void *areq,
+                                  void __iomem *cc_base)
+{
+	int completion_error = 0;
+	uint32_t inflight_counter;
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	START_CYCLE_COUNT();
+	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	info = req_ctx->backup_info;
+	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_4);
+
+
+	/*Set the inflight couter value to local variable*/
+	inflight_counter =  ctx_p->drvdata->inflight_counter;
+	/*Decrease the inflight counter*/
+	if(ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
+		ctx_p->drvdata->inflight_counter--;
+
+	if(areq){
+		ablkcipher_request_complete(areq, completion_error);
+		return 0;
+	}
+	return completion_error;
+}
+
+static int ssi_blkcipher_process(
+	struct crypto_tfm *tfm,
+	struct blkcipher_req_ctx *req_ctx,
+	struct scatterlist *dst, struct scatterlist *src,
+	unsigned int nbytes,
+	void *info, //req info
+	unsigned int ivsize,
+	void *areq, 
+	enum drv_crypto_direction direction)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
+	HwDesc_s desc[MAX_ABLKCIPHER_SEQ_LEN];
+	struct ssi_crypto_req ssi_req = {};
+	int rc, seq_len = 0,cts_restore_flag = 0;
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	SSI_LOG_DEBUG("%s areq=%p info=%p nbytes=%d\n",
+		((direction==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"),
+		     areq, info, nbytes);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+	START_CYCLE_COUNT();
+	
+	/* TODO: check data length according to mode */
+	if (unlikely(validate_data_size(ctx_p, nbytes))) {
+		SSI_LOG_ERR("Unsupported data size %d.\n", nbytes);
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
+		return -EINVAL;
+	}
+	if (nbytes == 0) {
+		/* No data to process is valid */
+		return 0;
+	}
+        /*For CTS in case of data size aligned to 16 use CBC mode*/
+	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)){
+
+		ctx_p->cipher_mode = DRV_CIPHER_CBC;
+		cts_restore_flag = 1;
+	}
+
+	/* Setup DX request structure */
+	ssi_req.user_cb = (void *)ssi_ablkcipher_complete;
+	ssi_req.user_arg = (void *)areq;
+
+#ifdef ENABLE_CYCLE_COUNT
+	ssi_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
+		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
+
+#endif
+
+	/* Setup request context */
+	req_ctx->gen_ctx.op_type = direction;
+	
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_0);
+
+	/* STAT_PHASE_1: Map buffers */
+	START_CYCLE_COUNT();
+	
+	rc = ssi_buffer_mgr_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes, info, src, dst);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("map_request() failed\n");
+		goto exit_process;
+	}
+
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_1);
+
+	/* STAT_PHASE_2: Create sequence */
+	START_CYCLE_COUNT();
+
+	/* Setup processing */
+#if SSI_CC_HAS_MULTI2
+	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
+		ssi_blkcipher_create_multi2_setup_desc(tfm,
+						       req_ctx,
+						       ivsize,
+						       desc,
+						       &seq_len);
+	} else
+#endif /*SSI_CC_HAS_MULTI2*/
+	{
+		ssi_blkcipher_create_setup_desc(tfm,
+						req_ctx,
+						ivsize,
+						nbytes,
+						desc,
+						&seq_len);
+	}
+	/* Data processing */
+	ssi_blkcipher_create_data_desc(tfm,
+			      req_ctx, 
+			      dst, src,
+			      nbytes,
+			      areq,
+			      desc, &seq_len);
+
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_2);
+
+	/* STAT_PHASE_3: Lock HW and push sequence */
+	START_CYCLE_COUNT();
+	
+	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL)? 0:1);
+	if(areq != NULL) {
+		if (unlikely(rc != -EINPROGRESS)) {
+			/* Failed to send the request or request completed synchronously */
+			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+		}
+
+		END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
+	} else {
+		if (rc != 0) {
+			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+			END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);            
+		} else {
+			END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
+			rc = ssi_blkcipher_complete(dev, ctx_p, req_ctx, dst, src, info, ivsize, NULL, ctx_p->drvdata->cc_base);
+		} 
+	}
+
+exit_process:
+	if (cts_restore_flag != 0)
+		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
+	
+	return rc;
+}
+
+static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+{
+	struct ablkcipher_request *areq = (struct ablkcipher_request *)ssi_req;
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_ablkcipher_ctx(tfm);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
+
+	ssi_blkcipher_complete(dev, ctx_p, req_ctx, areq->dst, areq->src, areq->info, ivsize, areq, cc_base);
+}
+
+
+
+static int ssi_sblkcipher_init(struct crypto_tfm *tfm)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+
+	/* Allocate sync ctx buffer */
+	ctx_p->sync_ctx = kmalloc(sizeof(struct blkcipher_req_ctx), GFP_KERNEL|GFP_DMA);
+	if (!ctx_p->sync_ctx) {
+		SSI_LOG_ERR("Allocating sync ctx buffer in context failed\n");
+		return -ENOMEM;
+	}
+	SSI_LOG_DEBUG("Allocated sync ctx buffer in context ctx_p->sync_ctx=@%p\n",
+								ctx_p->sync_ctx);
+
+	return ssi_blkcipher_init(tfm);
+}
+
+
+static void ssi_sblkcipher_exit(struct crypto_tfm *tfm)
+{
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	
+	kfree(ctx_p->sync_ctx);
+	SSI_LOG_DEBUG("Free sync ctx buffer in context ctx_p->sync_ctx=@%p\n", ctx_p->sync_ctx);
+
+	ssi_blkcipher_exit(tfm);
+}
+
+#ifdef SYNC_ALGS
+static int ssi_sblkcipher_encrypt(struct blkcipher_desc *desc,
+                        struct scatterlist *dst, struct scatterlist *src,
+                        unsigned int nbytes)
+{
+	struct crypto_blkcipher *blk_tfm = desc->tfm;
+	struct crypto_tfm *tfm = crypto_blkcipher_tfm(blk_tfm);
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct blkcipher_req_ctx *req_ctx = ctx_p->sync_ctx;
+	unsigned int ivsize = crypto_blkcipher_ivsize(blk_tfm);
+
+	req_ctx->backup_info = desc->info;
+
+	return ssi_blkcipher_process(tfm, req_ctx, dst, src, nbytes, desc->info, ivsize, NULL, DRV_CRYPTO_DIRECTION_ENCRYPT);
+}
+
+static int ssi_sblkcipher_decrypt(struct blkcipher_desc *desc,
+                        struct scatterlist *dst, struct scatterlist *src,
+                        unsigned int nbytes)
+{
+	struct crypto_blkcipher *blk_tfm = desc->tfm;
+	struct crypto_tfm *tfm = crypto_blkcipher_tfm(blk_tfm);
+	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct blkcipher_req_ctx *req_ctx = ctx_p->sync_ctx;
+	unsigned int ivsize = crypto_blkcipher_ivsize(blk_tfm);
+
+	req_ctx->backup_info = desc->info;
+
+	return ssi_blkcipher_process(tfm, req_ctx, dst, src, nbytes, desc->info, ivsize, NULL, DRV_CRYPTO_DIRECTION_DECRYPT);
+}
+#endif
+
+/* Async wrap functions */
+
+static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
+{
+	struct ablkcipher_tfm *ablktfm = &tfm->crt_ablkcipher;
+	
+	ablktfm->reqsize = sizeof(struct blkcipher_req_ctx);
+
+	return ssi_blkcipher_init(tfm);
+}
+
+
+static int ssi_ablkcipher_setkey(struct crypto_ablkcipher *tfm, 
+				const u8 *key, 
+				unsigned int keylen)
+{
+	return ssi_blkcipher_setkey(crypto_ablkcipher_tfm(tfm), key, keylen);
+}
+
+static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
+
+	req_ctx->backup_info = req->info;
+
+	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+}
+
+static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
+
+	req_ctx->backup_info = req->info;
+	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_DECRYPT);
+}
+
+
+/* DX Block cipher alg */
+static struct ssi_alg_template blkcipher_algs[] = {
+/* Async template */
+#if SSI_CC_HAS_AES_XTS
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			.geniv = "eseqiv",
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+        .synchronous = false,
+	},
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-du512-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+	.synchronous = false,
+	},
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-du4096-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+	.synchronous = false,
+	},
+#endif /*SSI_CC_HAS_AES_XTS*/
+#if SSI_CC_HAS_AES_ESSIV
+	{
+		.name = "essiv(aes)",
+		.driver_name = "essiv-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+		.synchronous = false,
+	},
+	{
+		.name = "essiv(aes)",
+		.driver_name = "essiv-aes-du512-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+		.synchronous = false,
+	},
+	{
+		.name = "essiv(aes)",
+		.driver_name = "essiv-aes-du4096-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+		.synchronous = false,
+	},
+#endif /*SSI_CC_HAS_AES_ESSIV*/
+#if SSI_CC_HAS_AES_BITLOCKER
+	{
+		.name = "bitlocker(aes)",
+		.driver_name = "bitlocker-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.synchronous = false,
+	},
+	{
+		.name = "bitlocker(aes)",
+		.driver_name = "bitlocker-aes-du512-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.synchronous = false,
+	},
+	{
+		.name = "bitlocker(aes)",
+		.driver_name = "bitlocker-aes-du4096-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.synchronous = false,
+	},
+#endif /*SSI_CC_HAS_AES_BITLOCKER*/
+	{
+		.name = "ecb(aes)",
+		.driver_name = "ecb-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_AES,
+        .synchronous = false,
+	},
+	{
+		.name = "cbc(aes)",
+		.driver_name = "cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_AES,
+        .synchronous = false,
+	},
+	{
+		.name = "ofb(aes)",
+		.driver_name = "ofb-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_OFB,
+		.flow_mode = S_DIN_to_AES,
+        .synchronous = false,
+	},
+#if SSI_CC_HAS_AES_CTS
+	{
+		.name = "cts1(cbc(aes))",
+		.driver_name = "cts1-cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC_CTS,
+		.flow_mode = S_DIN_to_AES,
+        .synchronous = false,
+	},
+#endif
+	{
+		.name = "ctr(aes)",
+		.driver_name = "ctr-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+        .synchronous = false,
+	},
+	{
+		.name = "cbc(des3_ede)",
+		.driver_name = "cbc-3des-dx",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_DES,
+        .synchronous = false,
+	},
+	{
+		.name = "ecb(des3_ede)",
+		.driver_name = "ecb-3des-dx",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_DES,
+        .synchronous = false,
+	},
+	{
+		.name = "cbc(des)",
+		.driver_name = "cbc-des-dx",
+		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_DES,
+        .synchronous = false,
+	},
+	{
+		.name = "ecb(des)",
+		.driver_name = "ecb-des-dx",
+		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_DES,
+        .synchronous = false,
+	},
+#if SSI_CC_HAS_MULTI2
+	{
+		.name = "cbc(multi2)",
+		.driver_name = "cbc-multi2-dx",
+		.blocksize = CC_MULTI2_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_decrypt,
+			.min_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
+			.max_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
+			.ivsize = CC_MULTI2_IV_SIZE,
+			},
+		.cipher_mode = DRV_MULTI2_CBC,
+		.flow_mode = S_DIN_to_MULTI2,
+        .synchronous = false,
+	},
+	{
+		.name = "ofb(multi2)",
+		.driver_name = "ofb-multi2-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ssi_ablkcipher_setkey,
+			.encrypt = ssi_ablkcipher_encrypt,
+			.decrypt = ssi_ablkcipher_encrypt,
+			.min_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
+			.max_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
+			.ivsize = CC_MULTI2_IV_SIZE,
+			},
+		.cipher_mode = DRV_MULTI2_OFB,
+		.flow_mode = S_DIN_to_MULTI2,
+        .synchronous = false,
+	},
+#endif /*SSI_CC_HAS_MULTI2*/
+};
+
+static 
+struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template *template)
+{
+	struct ssi_crypto_alg *t_alg;
+	struct crypto_alg *alg;
+
+	t_alg = kzalloc(sizeof(struct ssi_crypto_alg), GFP_KERNEL);
+	if (!t_alg) {
+		SSI_LOG_ERR("failed to allocate t_alg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	alg = &t_alg->crypto_alg;
+
+	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
+	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 template->driver_name);
+	alg->cra_module = THIS_MODULE;
+	alg->cra_priority = SSI_CRA_PRIO;
+	alg->cra_blocksize = template->blocksize;
+	alg->cra_alignmask = 0;
+	alg->cra_ctxsize = sizeof(struct ssi_ablkcipher_ctx);
+	
+	alg->cra_init = template->synchronous? ssi_sblkcipher_init:ssi_ablkcipher_init;
+	alg->cra_exit = template->synchronous? ssi_sblkcipher_exit:ssi_blkcipher_exit;
+	alg->cra_type = template->synchronous? &crypto_blkcipher_type:&crypto_ablkcipher_type;
+	if(template->synchronous) {
+		alg->cra_blkcipher = template->template_sblkcipher;
+		alg->cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+				template->type;
+	} else {
+		alg->cra_ablkcipher = template->template_ablkcipher;
+		alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+				template->type;
+	}
+
+	t_alg->cipher_mode = template->cipher_mode;
+	t_alg->flow_mode = template->flow_mode;
+
+	return t_alg;
+}
+
+int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
+{
+	struct ssi_crypto_alg *t_alg, *n;
+	struct ssi_blkcipher_handle *blkcipher_handle = 
+						drvdata->blkcipher_handle;
+	struct device *dev;
+	dev = &drvdata->plat_dev->dev;
+
+	if (blkcipher_handle != NULL) {
+		/* Remove registered algs */
+		list_for_each_entry_safe(t_alg, n,
+				&blkcipher_handle->blkcipher_alg_list,
+					 entry) {
+			crypto_unregister_alg(&t_alg->crypto_alg);
+			list_del(&t_alg->entry);
+			kfree(t_alg);
+		}
+		kfree(blkcipher_handle);
+		drvdata->blkcipher_handle = NULL;
+	}
+	return 0;
+}
+
+
+
+int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
+{
+	struct ssi_blkcipher_handle *ablkcipher_handle;
+	struct ssi_crypto_alg *t_alg;
+	int rc = -ENOMEM;
+	int alg;
+
+	ablkcipher_handle = kmalloc(sizeof(struct ssi_blkcipher_handle),
+		GFP_KERNEL);
+	if (ablkcipher_handle == NULL)
+		return -ENOMEM;
+
+	drvdata->blkcipher_handle = ablkcipher_handle;
+
+	INIT_LIST_HEAD(&ablkcipher_handle->blkcipher_alg_list);
+
+	/* Linux crypto */
+	SSI_LOG_DEBUG("Number of algorithms = %zu\n", ARRAY_SIZE(blkcipher_algs));
+	for (alg = 0; alg < ARRAY_SIZE(blkcipher_algs); alg++) {
+		SSI_LOG_DEBUG("creating %s\n", blkcipher_algs[alg].driver_name);
+		t_alg = ssi_ablkcipher_create_alg(&blkcipher_algs[alg]);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			SSI_LOG_ERR("%s alg allocation failed\n",
+				 blkcipher_algs[alg].driver_name);
+			goto fail0;
+		}
+		t_alg->drvdata = drvdata;
+
+		SSI_LOG_DEBUG("registering %s\n", blkcipher_algs[alg].driver_name);
+		rc = crypto_register_alg(&t_alg->crypto_alg);
+		SSI_LOG_DEBUG("%s alg registration rc = %x\n",
+			t_alg->crypto_alg.cra_driver_name, rc);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("%s alg registration failed\n",
+				t_alg->crypto_alg.cra_driver_name);
+			kfree(t_alg);
+			goto fail0;
+		} else {
+			list_add_tail(&t_alg->entry, 
+				      &ablkcipher_handle->blkcipher_alg_list);
+			SSI_LOG_DEBUG("Registered %s\n", 
+					t_alg->crypto_alg.cra_driver_name);
+		}
+	}
+	return 0;
+
+fail0:
+	ssi_ablkcipher_free(drvdata);
+	return rc;
+}
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
new file mode 100644
index 0000000..511800f1
--- /dev/null
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) 2012-2016 ARM Limited or its affiliates.
+ * 
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+/* \file ssi_cipher.h
+   ARM CryptoCell Cipher Crypto API
+ */
+
+#ifndef __SSI_CIPHER_H__
+#define __SSI_CIPHER_H__
+
+#include <linux/kernel.h>
+#include <crypto/algapi.h>
+#include "ssi_driver.h"
+#include "ssi_buffer_mgr.h"
+
+
+/* Crypto cipher flags */
+#define CC_CRYPTO_CIPHER_KEY_KFDE0    (1 << 0)
+#define CC_CRYPTO_CIPHER_KEY_KFDE1    (1 << 1)
+#define CC_CRYPTO_CIPHER_KEY_KFDE2    (1 << 2)
+#define CC_CRYPTO_CIPHER_KEY_KFDE3    (1 << 3)
+#define CC_CRYPTO_CIPHER_DU_SIZE_512B (1 << 4)
+
+#define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | CC_CRYPTO_CIPHER_KEY_KFDE1 | CC_CRYPTO_CIPHER_KEY_KFDE2 | CC_CRYPTO_CIPHER_KEY_KFDE3)
+
+
+struct blkcipher_req_ctx {
+	struct async_gen_req_ctx gen_ctx;
+	enum ssi_req_dma_buf_type dma_buf_type;
+	uint32_t in_nents;
+	uint32_t in_mlli_nents;
+	uint32_t out_nents;
+	uint32_t out_mlli_nents;
+	uint8_t *backup_info; /*store iv for generated IV flow*/
+	struct mlli_params mlli_params;
+};
+
+
+
+int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata);
+
+int ssi_ablkcipher_free(struct ssi_drvdata *drvdata);
+
+#ifndef CRYPTO_ALG_BULK_MASK
+
+#define CRYPTO_ALG_BULK_DU_512	0x00002000
+#define CRYPTO_ALG_BULK_DU_4096	0x00004000
+#define CRYPTO_ALG_BULK_MASK	(CRYPTO_ALG_BULK_DU_512 |\
+				CRYPTO_ALG_BULK_DU_4096)
+#endif /* CRYPTO_ALG_BULK_MASK */
+
+
+#ifdef CRYPTO_TFM_REQ_HW_KEY
+
+static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
+{
+	return (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_HW_KEY);
+}
+
+#else 
+
+struct arm_hw_key_info {
+	int hw_key1;
+	int hw_key2;
+};
+
+static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+#endif /* CRYPTO_TFM_REQ_HW_KEY */
+
+
+#endif /*__SSI_CIPHER_H__*/
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 95e27c2..1310ac5 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -23,6 +23,7 @@
 #include <crypto/sha.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
 
 #include <linux/init.h>
 #include <linux/moduleparam.h>
@@ -61,6 +62,7 @@
 #include "ssi_request_mgr.h"
 #include "ssi_buffer_mgr.h"
 #include "ssi_sysfs.h"
+#include "ssi_cipher.h"
 #include "ssi_hash.h"
 #include "ssi_sram_mgr.h"
 #include "ssi_pm.h"
@@ -219,6 +221,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 
+	/*Initialize inflight counter used in dx_ablkcipher_secure_complete used for count of BYSPASS blocks operations*/
+	new_drvdata->inflight_counter = 0;
+
 	dev_set_drvdata(&plat_dev->dev, new_drvdata);
 	/* Get device resources */
 	/* First CC registers space */
@@ -343,6 +348,13 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 
+	/* Allocate crypto algs */
+	rc = ssi_ablkcipher_alloc(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("ssi_ablkcipher_alloc failed\n");
+		goto init_cc_res_err;
+	}
+
 	rc = ssi_hash_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_hash_alloc failed\n");
@@ -356,6 +368,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	
 	if (new_drvdata != NULL) {
 		ssi_hash_free(new_drvdata);
+		ssi_ablkcipher_free(new_drvdata);
 		ssi_power_mgr_fini(new_drvdata);
 		ssi_buffer_mgr_fini(new_drvdata);
 		request_mgr_fini(new_drvdata);
@@ -396,6 +409,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
 
         ssi_hash_free(drvdata);
+        ssi_ablkcipher_free(drvdata);
 	ssi_power_mgr_fini(drvdata);
 	ssi_buffer_mgr_fini(drvdata);
 	request_mgr_fini(drvdata);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 9aa5d30..baac9bf 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -29,6 +29,7 @@
 #endif
 #include <linux/dma-mapping.h>
 #include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/authenc.h>
@@ -141,15 +142,44 @@ struct ssi_drvdata {
 	struct completion icache_setup_completion;
 	void *buff_mgr_handle;
 	void *hash_handle;
+	void *blkcipher_handle;
 	void *request_mgr_handle;
 	void *sram_mgr_handle;
 
 #ifdef ENABLE_CYCLE_COUNT
 	cycles_t isr_exit_cycles; /* Save for isr-to-tasklet latency */
 #endif
+	uint32_t inflight_counter;
 
 };
 
+struct ssi_crypto_alg {
+	struct list_head entry;
+	int cipher_mode;
+	int flow_mode; /* Note: currently, refers to the cipher mode only. */
+	int auth_mode;
+	struct ssi_drvdata *drvdata;
+	struct crypto_alg crypto_alg;
+};
+
+struct ssi_alg_template {
+	char name[CRYPTO_MAX_ALG_NAME];
+	char driver_name[CRYPTO_MAX_ALG_NAME];
+	unsigned int blocksize;
+	u32 type;
+	union {
+		struct ablkcipher_alg ablkcipher;
+		struct blkcipher_alg blkcipher;
+		struct cipher_alg cipher;
+		struct compress_alg compress;
+	} template_u;
+	int cipher_mode;
+	int flow_mode; /* Note: currently, refers to the cipher mode only. */
+	int auth_mode;
+	bool synchronous;
+	struct ssi_drvdata *drvdata;
+};
+
 struct async_gen_req_ctx {
 	dma_addr_t iv_dma_addr;
 	enum drv_crypto_direction op_type;
-- 
2.1.4
