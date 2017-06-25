From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 5/6] staging: ccree: add DT bus coherency detection
Date: Sun, 25 Jun 2017 10:47:23 +0300
Message-ID: <1498376846-24136-6-git-send-email-gilad@benyossef.com>
References: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ccree driver has build time configurable support
to work on top of coherent (e.g. ACP) vs. none coherent bus
connections. Turn it to run-time configurable option
based on device tree.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig          |  9 ---------
 drivers/staging/ccree/ssi_buffer_mgr.c | 37 ++++++++++++++++++----------------
 drivers/staging/ccree/ssi_config.h     | 20 ------------------
 drivers/staging/ccree/ssi_driver.c     | 12 ++++++++---
 drivers/staging/ccree/ssi_driver.h     |  3 +++
 5 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 4be87f5..ec3749d 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -32,12 +32,3 @@ config CCREE_FIPS_SUPPORT
 	  Say 'Y' to enable support for FIPS compliant mode by the
 	  CCREE driver.
 	  If unsure say N.
-
-config CCREE_DISABLE_COHERENT_DMA_OPS
-	bool "Disable Coherent DMA operations for the CCREE driver"
-	depends on CRYPTO_DEV_CCREE
-	default n
-	help
-	  Say 'Y' to disable the use of coherent DMA operations by the
-	  CCREE driver for debugging purposes.  
-	  If unsure say N.
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 88ebda8..4373d1d 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -627,6 +627,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
 	u32 dummy;
 	bool chained;
 	u32 size_to_unmap = 0;
@@ -700,8 +701,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 		dma_unmap_sg(dev, req->dst, ssi_buffer_mgr_get_sgl_nents(req->dst,size_to_unmap,&dummy,&chained),
 			DMA_BIDIRECTIONAL);
 	}
-#if DX_HAS_ACP
-	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+	if (drvdata->coherent &&
+	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
 	    likely(req->src == req->dst))
 	{
 		u32 size_to_skip = req->assoclen;
@@ -716,7 +717,6 @@ void ssi_buffer_mgr_unmap_aead_request(
 			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
 			size_to_skip+ req->cryptlen, SSI_SG_FROM_BUF);
 	}
-#endif
 }
 
 static inline int ssi_buffer_mgr_get_aead_icv_nents(
@@ -981,20 +981,24 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			 * MAC verification upon request completion
 			 */
 			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
-#if !DX_HAS_ACP
-				/* In ACP platform we already copying ICV
-				 * for any INPLACE-DECRYPT operation, hence
+				if (!drvdata->coherent) {
+				/* In coherent platforms (e.g. ACP)
+				 * already copying ICV for any
+				 * INPLACE-DECRYPT operation, hence
 				 * we must neglect this code.
 				 */
-				u32 size_to_skip = req->assoclen;
-				if (areq_ctx->is_gcm4543) {
-					size_to_skip += crypto_aead_ivsize(tfm);
+					u32 skip = req->assoclen;
+
+					if (areq_ctx->is_gcm4543)
+						skip += crypto_aead_ivsize(tfm);
+
+					ssi_buffer_mgr_copy_scatterlist_portion(
+						areq_ctx->backup_mac, req->src,
+						(skip + req->cryptlen -
+						 areq_ctx->req_authsize),
+						skip + req->cryptlen,
+						SSI_SG_TO_BUF);
 				}
-				ssi_buffer_mgr_copy_scatterlist_portion(
-					areq_ctx->backup_mac, req->src,
-					size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
-					size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
-#endif
 				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 			} else {
 				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
@@ -1281,8 +1285,8 @@ int ssi_buffer_mgr_map_aead_request(
 	mlli_params->curr_pool = NULL;
 	sg_data.num_of_buffers = 0;
 
-#if DX_HAS_ACP
-	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+	if (drvdata->coherent &&
+	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
 	    likely(req->src == req->dst))
 	{
 		u32 size_to_skip = req->assoclen;
@@ -1297,7 +1301,6 @@ int ssi_buffer_mgr_map_aead_request(
 			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
 			size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
 	}
-#endif
 
 	/* cacluate the size for cipher remove ICV in decrypt*/
 	areq_ctx->cryptlen = (areq_ctx->gen_ctx.op_type ==
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index b7c0576..ff7597c 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -23,7 +23,6 @@
 
 #include <linux/version.h>
 
-#define DISABLE_COHERENT_DMA_OPS
 //#define FLUSH_CACHE_ALL
 //#define COMPLETION_DELAY
 //#define DX_DUMP_DESCS
@@ -33,24 +32,5 @@
 //#define DX_IRQ_DELAY 100000
 #define DMA_BIT_MASK_LEN	48	/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
 
-#if defined (CONFIG_ARM64)	// TODO currently only this mode was test on Juno (which is ARM64), need to enable coherent also.
-#define DISABLE_COHERENT_DMA_OPS
-#endif
-
-/* Define the CryptoCell DMA cache coherency signals configuration */
-#if defined (DISABLE_COHERENT_DMA_OPS)
-	/* Software Controlled Cache Coherency (SCCC) */
-	#define SSI_CACHE_PARAMS (0x000)
-	/* CC attached to NONE-ACP such as HPP/ACE/AMBA4.
-	 * The customer is responsible to enable/disable this feature
-	 * according to his platform type.
-	 */
-	#define DX_HAS_ACP 0
-#else
-	#define SSI_CACHE_PARAMS (0xEEE)
-	/* CC attached to ACP */
-	#define DX_HAS_ACP 1
-#endif
-
 #endif /*__DX_CONFIG_H__*/
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index c516675..151afcf 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/of.h>
 #include <linux/clk.h>
+#include <linux/of_address.h>
 
 #include "ssi_config.h"
 #include "ssi_driver.h"
@@ -172,7 +173,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 
 int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 {
-	unsigned int val;
+	unsigned int val, cache_params;
 	void __iomem *cc_base = drvdata->cc_base;
 
 	/* Unmask all AXI interrupt sources AXI_CFG1 register */
@@ -201,14 +202,18 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	}
 #endif
 
+	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
+
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
 	if (is_probe == true) {
 		SSI_LOG_INFO("Cache params previous: 0x%08X\n", val);
 	}
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS), SSI_CACHE_PARAMS);
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS),
+			      cache_params);
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
 	if (is_probe == true) {
-		SSI_LOG_INFO("Cache params current: 0x%08X  (expected: 0x%08X)\n", val, SSI_CACHE_PARAMS);
+		SSI_LOG_INFO("Cache params current: 0x%08X (expect: 0x%08X)\n",
+			     val, cache_params);
 	}
 
 	return 0;
@@ -232,6 +237,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	new_drvdata->clk = of_clk_get(np, 0);
+	new_drvdata->coherent = of_dma_is_coherent(np);
 
 	/*Initialize inflight counter used in dx_ablkcipher_secure_complete used for count of BYSPASS blocks operations*/
 	new_drvdata->inflight_counter = 0;
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index faf47b1..1b8471b 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -55,6 +55,8 @@
 #define DRV_MODULE_VERSION "3.0"
 
 #define SSI_DEV_NAME_STR "cc715ree"
+#define CC_COHERENT_CACHE_PARAMS 0xEEE
+
 #define SSI_CC_HAS_AES_CCM 1
 #define SSI_CC_HAS_AES_GCM 1
 #define SSI_CC_HAS_AES_XTS 1
@@ -150,6 +152,7 @@ struct ssi_drvdata {
 	void *sram_mgr_handle;
 	u32 inflight_counter;
 	struct clk *clk;
+	bool coherent;
 };
 
 struct ssi_crypto_alg {
-- 
2.1.4
