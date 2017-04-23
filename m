From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 05/15] staging: ccree: add AEAD support
Date: Sun, 23 Apr 2017 12:26:13 +0300
Message-ID: <1492939583-25688-6-git-send-email-gilad@benyossef.com>
References: <1492939583-25688-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, gilad.benyossef@arm.com,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>,
        Stephan Muller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46928 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1044389AbdDWJ1A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 05:27:00 -0400
In-Reply-To: <1492939583-25688-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CryptoCell AEAD support

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig          |    1 +
 drivers/staging/ccree/Makefile         |    2 +-
 drivers/staging/ccree/cc_crypto_ctx.h  |   21 +
 drivers/staging/ccree/ssi_aead.c       | 2826 ++++++++++++++++++++++++++++++++
 drivers/staging/ccree/ssi_aead.h       |  120 ++
 drivers/staging/ccree/ssi_buffer_mgr.c |  899 ++++++++++
 drivers/staging/ccree/ssi_buffer_mgr.h |    4 +
 drivers/staging/ccree/ssi_driver.c     |   11 +
 drivers/staging/ccree/ssi_driver.h     |    4 +
 9 files changed, 3887 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/ccree/ssi_aead.c
 create mode 100644 drivers/staging/ccree/ssi_aead.h

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 3fff040..2d11223 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -5,6 +5,7 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
+	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_SHA1
 	select CRYPTO_MD5
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index 89afe9a..b9285c0 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
+ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index a7f7d95..9e10b26 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -263,6 +263,27 @@ struct drv_ctx_cipher {
 		(CC_AES_KEY_SIZE_MAX/sizeof(uint32_t))];
 };
 
+/* authentication and encryption with associated data class */
+struct drv_ctx_aead {
+	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_AES */
+	enum drv_cipher_mode mode;
+	enum drv_crypto_direction direction;
+	uint32_t key_size; /* numeric value in bytes   */
+	uint32_t nonce_size; /* nonce size (octets) */
+	uint32_t header_size; /* finit additional data size (octets) */
+	uint32_t text_size; /* finit text data size (octets) */
+	uint32_t tag_size; /* mac size, element of {4, 6, 8, 10, 12, 14, 16} */
+	/* block_state1/2 is the AES engine block state */
+	uint8_t block_state[CC_AES_BLOCK_SIZE];
+	uint8_t mac_state[CC_AES_BLOCK_SIZE]; /* MAC result */
+	uint8_t nonce[CC_AES_BLOCK_SIZE]; /* nonce buffer */
+	uint8_t key[CC_AES_KEY_SIZE_MAX];
+	/* reserve to end of allocated context size */
+	uint32_t reserved[CC_DRV_CTX_SIZE_WORDS - 8 -
+		3 * (CC_AES_BLOCK_SIZE/sizeof(uint32_t)) -
+		CC_AES_KEY_SIZE_MAX/sizeof(uint32_t)];
+};
+
 /*******************************************************************/
 /***************** MESSAGE BASED CONTEXTS **************************/
 /*******************************************************************/
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
new file mode 100644
index 0000000..33d72d2
--- /dev/null
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -0,0 +1,2826 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/aead.h>
+#include <crypto/sha.h>
+#include <crypto/ctr.h>
+#include <crypto/authenc.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <linux/rtnetlink.h>
+#include <linux/version.h>
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "ssi_buffer_mgr.h"
+#include "ssi_aead.h"
+#include "ssi_request_mgr.h"
+#include "ssi_hash.h"
+#include "ssi_sysfs.h"
+#include "ssi_sram_mgr.h"
+
+#define template_aead	template_u.aead
+
+#define MAX_AEAD_SETKEY_SEQ 12
+#define MAX_AEAD_PROCESS_SEQ 23
+
+#define MAX_HMAC_DIGEST_SIZE (SHA256_DIGEST_SIZE)
+#define MAX_HMAC_BLOCK_SIZE (SHA256_BLOCK_SIZE)
+
+#define AES_CCM_RFC4309_NONCE_SIZE 3
+#define MAX_NONCE_SIZE CTR_RFC3686_NONCE_SIZE
+
+
+/* Value of each ICV_CMP byte (of 8) in case of success */
+#define ICV_VERIF_OK 0x01	
+
+struct ssi_aead_handle {
+	ssi_sram_addr_t sram_workspace_addr;
+	struct list_head aead_list;
+};
+
+struct ssi_aead_ctx {
+	struct ssi_drvdata *drvdata;
+	uint8_t ctr_nonce[MAX_NONCE_SIZE]; /* used for ctr3686 iv and aes ccm */
+	uint8_t *enckey;
+	dma_addr_t enckey_dma_addr;
+	union {
+		struct {
+			uint8_t *padded_authkey;
+			uint8_t *ipad_opad; /* IPAD, OPAD*/
+			dma_addr_t padded_authkey_dma_addr;
+			dma_addr_t ipad_opad_dma_addr;
+		} hmac;
+		struct {
+			uint8_t *xcbc_keys; /* K1,K2,K3 */
+			dma_addr_t xcbc_keys_dma_addr;
+		} xcbc;
+	} auth_state;
+	unsigned int enc_keylen;
+	unsigned int auth_keylen;
+	unsigned int authsize; /* Actual (reduced?) size of the MAC/ICv */
+	enum drv_cipher_mode cipher_mode;
+	enum FlowMode flow_mode;
+	enum drv_hash_mode auth_mode;
+};
+
+static inline bool valid_assoclen(struct aead_request *req)
+{
+	return ((req->assoclen == 16) || (req->assoclen == 20));
+}
+
+static void ssi_aead_exit(struct crypto_aead *tfm)
+{
+	struct device *dev = NULL;
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
+		crypto_aead_ctx(tfm), crypto_tfm_alg_name(&(tfm->base)));
+
+ 	dev = &ctx->drvdata->plat_dev->dev;
+	/* Unmap enckey buffer */
+	if (ctx->enckey != NULL) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->enckey_dma_addr);
+		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
+		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=0x%llX\n",
+			(unsigned long long)ctx->enckey_dma_addr);
+		ctx->enckey_dma_addr = 0;
+		ctx->enckey = NULL;
+	}
+	
+	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
+		if (ctx->auth_state.xcbc.xcbc_keys != NULL) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(
+				ctx->auth_state.xcbc.xcbc_keys_dma_addr);
+			dma_free_coherent(dev, CC_AES_128_BIT_KEY_SIZE * 3,
+				ctx->auth_state.xcbc.xcbc_keys, 
+				ctx->auth_state.xcbc.xcbc_keys_dma_addr);
+		}
+		SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=0x%llX\n",
+			(unsigned long long)ctx->auth_state.xcbc.xcbc_keys_dma_addr);
+		ctx->auth_state.xcbc.xcbc_keys_dma_addr = 0;
+		ctx->auth_state.xcbc.xcbc_keys = NULL;
+	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
+		if (ctx->auth_state.hmac.ipad_opad != NULL) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(
+				ctx->auth_state.hmac.ipad_opad_dma_addr);
+			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
+				ctx->auth_state.hmac.ipad_opad,
+				ctx->auth_state.hmac.ipad_opad_dma_addr);
+			SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=0x%llX\n",
+				(unsigned long long)ctx->auth_state.hmac.ipad_opad_dma_addr);
+			ctx->auth_state.hmac.ipad_opad_dma_addr = 0;
+			ctx->auth_state.hmac.ipad_opad = NULL;
+		}
+		if (ctx->auth_state.hmac.padded_authkey != NULL) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(
+				ctx->auth_state.hmac.padded_authkey_dma_addr);
+			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
+				ctx->auth_state.hmac.padded_authkey,
+				ctx->auth_state.hmac.padded_authkey_dma_addr);
+			SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=0x%llX\n",
+				(unsigned long long)ctx->auth_state.hmac.padded_authkey_dma_addr);
+			ctx->auth_state.hmac.padded_authkey_dma_addr = 0;
+			ctx->auth_state.hmac.padded_authkey = NULL;
+		}
+	}
+}
+
+static int ssi_aead_init(struct crypto_aead *tfm)
+{
+	struct device *dev;
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct ssi_crypto_alg *ssi_alg =
+			container_of(alg, struct ssi_crypto_alg, aead_alg);
+	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx, crypto_tfm_alg_name(&(tfm->base)));
+
+	/* Initialize modes in instance */
+	ctx->cipher_mode = ssi_alg->cipher_mode;
+	ctx->flow_mode = ssi_alg->flow_mode;
+	ctx->auth_mode = ssi_alg->auth_mode;
+	ctx->drvdata = ssi_alg->drvdata;
+	dev = &ctx->drvdata->plat_dev->dev;
+	crypto_aead_set_reqsize(tfm,sizeof(struct aead_req_ctx));
+
+	/* Allocate key buffer, cache line aligned */
+	ctx->enckey = dma_alloc_coherent(dev, AES_MAX_KEY_SIZE,
+		&ctx->enckey_dma_addr, GFP_KERNEL);
+	if (ctx->enckey == NULL) {
+		SSI_LOG_ERR("Failed allocating key buffer\n");
+		goto init_failed;
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->enckey_dma_addr, AES_MAX_KEY_SIZE);
+	SSI_LOG_DEBUG("Allocated enckey buffer in context ctx->enckey=@%p\n", ctx->enckey);
+
+	/* Set default authlen value */
+
+	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
+		/* Allocate dma-coherent buffer for XCBC's K1+K2+K3 */
+		/* (and temporary for user key - up to 256b) */
+		ctx->auth_state.xcbc.xcbc_keys = dma_alloc_coherent(dev,
+			CC_AES_128_BIT_KEY_SIZE * 3,
+			&ctx->auth_state.xcbc.xcbc_keys_dma_addr, GFP_KERNEL);
+		if (ctx->auth_state.xcbc.xcbc_keys == NULL) {
+			SSI_LOG_ERR("Failed allocating buffer for XCBC keys\n");
+			goto init_failed;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(
+			ctx->auth_state.xcbc.xcbc_keys_dma_addr,
+			CC_AES_128_BIT_KEY_SIZE * 3);
+	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC authentication */
+		/* Allocate dma-coherent buffer for IPAD + OPAD */
+		ctx->auth_state.hmac.ipad_opad = dma_alloc_coherent(dev,
+			2 * MAX_HMAC_DIGEST_SIZE,
+			&ctx->auth_state.hmac.ipad_opad_dma_addr, GFP_KERNEL);
+		if (ctx->auth_state.hmac.ipad_opad == NULL) {
+			SSI_LOG_ERR("Failed allocating IPAD/OPAD buffer\n");
+			goto init_failed;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(
+			ctx->auth_state.hmac.ipad_opad_dma_addr,
+			2 * MAX_HMAC_DIGEST_SIZE);
+		SSI_LOG_DEBUG("Allocated authkey buffer in context ctx->authkey=@%p\n",
+			ctx->auth_state.hmac.ipad_opad);
+	
+		ctx->auth_state.hmac.padded_authkey = dma_alloc_coherent(dev,
+			MAX_HMAC_BLOCK_SIZE,
+			&ctx->auth_state.hmac.padded_authkey_dma_addr, GFP_KERNEL);
+		if (ctx->auth_state.hmac.padded_authkey == NULL) {
+			SSI_LOG_ERR("failed to allocate padded_authkey\n");
+			goto init_failed;
+		}	
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(
+			ctx->auth_state.hmac.padded_authkey_dma_addr,
+			MAX_HMAC_BLOCK_SIZE);
+	} else {
+		ctx->auth_state.hmac.ipad_opad = NULL;
+		ctx->auth_state.hmac.padded_authkey = NULL;
+	}
+
+	return 0;
+
+init_failed:
+	ssi_aead_exit(tfm);
+	return -ENOMEM;
+}
+ 
+
+static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+{
+	struct aead_request *areq = (struct aead_request *)ssi_req;
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(ssi_req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	int err = 0;
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	START_CYCLE_COUNT();
+
+	ssi_buffer_mgr_unmap_aead_request(dev, areq);
+
+	/* Restore ordinary iv pointer */
+	areq->iv = areq_ctx->backup_iv;
+
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
+			ctx->authsize) != 0) {
+			SSI_LOG_DEBUG("Payload authentication failure, "
+				"(auth-size=%d, cipher=%d).\n",
+				ctx->authsize, ctx->cipher_mode);
+			/* In case of payload authentication failure, MUST NOT
+			   revealed the decrypted message --> zero its memory. */
+			ssi_buffer_mgr_zero_sgl(areq->dst, areq_ctx->cryptlen);
+			err = -EBADMSG;
+		}
+	} else { /*ENCRYPT*/
+		if (unlikely(areq_ctx->is_icv_fragmented == true))
+			ssi_buffer_mgr_copy_scatterlist_portion(
+				areq_ctx->mac_buf, areq_ctx->dstSgl, areq->cryptlen+areq_ctx->dstOffset,
+				areq->cryptlen+areq_ctx->dstOffset + ctx->authsize, SSI_SG_FROM_BUF);
+
+		/* If an IV was generated, copy it back to the user provided buffer. */
+		if (areq_ctx->backup_giv != NULL) {
+			if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
+			} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
+			}
+		}
+	}
+
+	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_4);
+	aead_request_complete(areq, err);
+}
+
+static int xcbc_setkey(HwDesc_s *desc, struct ssi_aead_ctx *ctx)
+{
+	/* Load the AES key */
+	HW_DESC_INIT(&desc[0]);
+	/* We are using for the source/user key the same buffer as for the output keys,
+	   because after this key loading it is not needed anymore */
+	HW_DESC_SET_DIN_TYPE(&desc[0], DMA_DLLI, ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen, NS_BIT);
+	HW_DESC_SET_CIPHER_MODE(&desc[0], DRV_CIPHER_ECB);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[0], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[0], ctx->auth_keylen);
+	HW_DESC_SET_FLOW_MODE(&desc[0], S_DIN_to_AES);
+	HW_DESC_SET_SETUP_MODE(&desc[0], SETUP_LOAD_KEY0);
+
+	HW_DESC_INIT(&desc[1]);
+	HW_DESC_SET_DIN_CONST(&desc[1], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[1], DIN_AES_DOUT);
+	HW_DESC_SET_DOUT_DLLI(&desc[1], ctx->auth_state.xcbc.xcbc_keys_dma_addr, AES_KEYSIZE_128, NS_BIT, 0);
+
+	HW_DESC_INIT(&desc[2]);
+	HW_DESC_SET_DIN_CONST(&desc[2], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[2], DIN_AES_DOUT);
+	HW_DESC_SET_DOUT_DLLI(&desc[2], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
+					 + AES_KEYSIZE_128),
+			      AES_KEYSIZE_128, NS_BIT, 0);
+
+	HW_DESC_INIT(&desc[3]);
+	HW_DESC_SET_DIN_CONST(&desc[3], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[3], DIN_AES_DOUT);
+	HW_DESC_SET_DOUT_DLLI(&desc[3], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
+					  + 2 * AES_KEYSIZE_128),
+			      AES_KEYSIZE_128, NS_BIT, 0);
+
+	return 4;
+}
+
+static int hmac_setkey(HwDesc_s *desc, struct ssi_aead_ctx *ctx)
+{
+	unsigned int hmacPadConst[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
+	unsigned int digest_ofs = 0;
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ? 
+			DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ? 
+			CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+
+	int idx = 0;
+	int i;
+
+	/* calc derived HMAC key */
+	for (i = 0; i < 2; i++) {
+		/* Load hash initial state */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		HW_DESC_SET_DIN_SRAM(&desc[idx],
+			ssi_ahash_get_larval_digest_sram_addr(
+				ctx->drvdata, ctx->auth_mode),
+			digest_size);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		idx++;
+
+		/* Load the hash current length*/
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+
+		/* Prepare ipad key */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_XOR_VAL(&desc[idx], hmacPadConst[i]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		idx++;
+
+		/* Perform HASH update */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				   ctx->auth_state.hmac.padded_authkey_dma_addr,
+				     SHA256_BLOCK_SIZE, NS_BIT);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		HW_DESC_SET_XOR_ACTIVE(&desc[idx]);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		idx++;
+
+		/* Get the digset */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		HW_DESC_SET_DOUT_DLLI(&desc[idx], 
+				      (ctx->auth_state.hmac.ipad_opad_dma_addr +
+				       digest_ofs),
+				      digest_size, NS_BIT, 0);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+		idx++;
+
+		digest_ofs += digest_size;
+	}
+
+	return idx;
+}
+
+static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
+{
+	SSI_LOG_DEBUG("enc_keylen=%u  authkeylen=%u\n",
+		ctx->enc_keylen, ctx->auth_keylen);
+
+	switch (ctx->auth_mode) {
+	case DRV_HASH_SHA1:
+	case DRV_HASH_SHA256:
+		break;
+	case DRV_HASH_XCBC_MAC:
+		if ((ctx->auth_keylen != AES_KEYSIZE_128) &&
+		    (ctx->auth_keylen != AES_KEYSIZE_192) &&
+		    (ctx->auth_keylen != AES_KEYSIZE_256))
+			return -ENOTSUPP;
+		break;
+	case DRV_HASH_NULL: /* Not authenc (e.g., CCM) - no auth_key) */
+		if (ctx->auth_keylen > 0)
+			return -EINVAL;
+		break;
+	default:
+		SSI_LOG_ERR("Invalid auth_mode=%d\n", ctx->auth_mode);
+		return -EINVAL;
+	}
+	/* Check cipher key size */
+	if (unlikely(ctx->flow_mode == S_DIN_to_DES)) {
+		if (ctx->enc_keylen != DES3_EDE_KEY_SIZE) {
+			SSI_LOG_ERR("Invalid cipher(3DES) key size: %u\n",
+				ctx->enc_keylen);
+			return -EINVAL;
+		}
+	} else { /* Default assumed to be AES ciphers */
+		if ((ctx->enc_keylen != AES_KEYSIZE_128) &&
+		    (ctx->enc_keylen != AES_KEYSIZE_192) &&
+		    (ctx->enc_keylen != AES_KEYSIZE_256)) {
+			SSI_LOG_ERR("Invalid cipher(AES) key size: %u\n",
+				ctx->enc_keylen);
+			return -EINVAL;
+		}
+	}
+
+	return 0; /* All tests of keys sizes passed */
+}
+/*This function prepers the user key so it can pass to the hmac processing 
+  (copy to intenral buffer or hash in case of key longer than block */
+static int
+ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	dma_addr_t key_dma_addr = 0;
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	uint32_t larval_addr = ssi_ahash_get_larval_digest_sram_addr(
+					ctx->drvdata, ctx->auth_mode);
+	struct ssi_crypto_req ssi_req = {};
+	unsigned int blocksize;
+	unsigned int digestsize;
+	unsigned int hashmode;
+	unsigned int idx = 0;
+	int rc = 0;
+	HwDesc_s desc[MAX_AEAD_SETKEY_SEQ];
+	dma_addr_t padded_authkey_dma_addr = 
+		ctx->auth_state.hmac.padded_authkey_dma_addr;
+
+	switch (ctx->auth_mode) { /* auth_key required and >0 */
+	case DRV_HASH_SHA1:
+		blocksize = SHA1_BLOCK_SIZE;
+		digestsize = SHA1_DIGEST_SIZE;
+		hashmode = DRV_HASH_HW_SHA1;
+		break;
+	case DRV_HASH_SHA256:
+	default:
+		blocksize = SHA256_BLOCK_SIZE;
+		digestsize = SHA256_DIGEST_SIZE;
+		hashmode = DRV_HASH_HW_SHA256;
+	}
+
+	if (likely(keylen != 0)) {
+		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
+			SSI_LOG_ERR("Mapping key va=0x%p len=%u for"
+				   " DMA failed\n", key, keylen);
+			return -ENOMEM;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(key_dma_addr, keylen);
+		if (keylen > blocksize) {
+			/* Load hash initial state */
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], hashmode);
+			HW_DESC_SET_DIN_SRAM(&desc[idx], larval_addr, digestsize);
+			HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+			idx++;
+	
+			/* Load the hash current length*/
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], hashmode);
+			HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
+			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
+			HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+			idx++;
+	
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+					     key_dma_addr, 
+					     keylen, NS_BIT);
+			HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+			idx++;
+	
+			/* Get hashed key */
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], hashmode); 
+			HW_DESC_SET_DOUT_DLLI(&desc[idx],
+					 padded_authkey_dma_addr,
+					 digestsize,
+					 NS_BIT, 0);
+			HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx],
+							HASH_PADDING_DISABLED);
+			HW_DESC_SET_CIPHER_CONFIG0(&desc[idx],
+						   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+			idx++;
+	
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_DIN_CONST(&desc[idx], 0, (blocksize - digestsize));
+			HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+			HW_DESC_SET_DOUT_DLLI(&desc[idx], 
+					      (padded_authkey_dma_addr + digestsize),
+					      (blocksize - digestsize),
+					      NS_BIT, 0);
+			idx++;
+		} else {
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+					     key_dma_addr, 
+					     keylen, NS_BIT);
+			HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+			HW_DESC_SET_DOUT_DLLI(&desc[idx], 
+					      (padded_authkey_dma_addr),
+					      keylen, NS_BIT, 0);
+			idx++;
+	
+			if ((blocksize - keylen) != 0) {
+				HW_DESC_INIT(&desc[idx]);
+				HW_DESC_SET_DIN_CONST(&desc[idx], 0,
+						      (blocksize - keylen));
+				HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+				HW_DESC_SET_DOUT_DLLI(&desc[idx], 
+					(padded_authkey_dma_addr + keylen),
+					(blocksize - keylen),
+					NS_BIT, 0);
+				idx++;
+			}
+		}
+	} else {
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_CONST(&desc[idx], 0,
+				      (blocksize - keylen));
+		HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+		HW_DESC_SET_DOUT_DLLI(&desc[idx], 
+			padded_authkey_dma_addr,
+			blocksize,
+			NS_BIT, 0);
+		idx++;
+	}
+
+#ifdef ENABLE_CYCLE_COUNT
+	ssi_req.op_type = STAT_OP_TYPE_SETKEY;
+#endif
+
+	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
+	if (unlikely(rc != 0))
+		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
+
+	if (likely(key_dma_addr != 0)) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(key_dma_addr);
+		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
+	}
+
+	return rc;
+}
+
+
+static int
+ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct rtattr *rta = (struct rtattr *)key;
+	struct ssi_crypto_req ssi_req = {};
+	struct crypto_authenc_key_param *param;
+	HwDesc_s desc[MAX_AEAD_SETKEY_SEQ];
+	int seq_len = 0, rc = -EINVAL;
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	SSI_LOG_DEBUG("Setting key in context @%p for %s. key=%p keylen=%u\n",
+		ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key, keylen);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+	START_CYCLE_COUNT();
+
+	if (ctx->auth_mode != DRV_HASH_NULL) { /* authenc() alg. */
+		if (!RTA_OK(rta, keylen))
+			goto badkey;
+		if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+			goto badkey;
+		if (RTA_PAYLOAD(rta) < sizeof(*param))
+			goto badkey;
+		param = RTA_DATA(rta);
+		ctx->enc_keylen = be32_to_cpu(param->enckeylen);
+		key += RTA_ALIGN(rta->rta_len);
+		keylen -= RTA_ALIGN(rta->rta_len);
+		if (keylen < ctx->enc_keylen)
+			goto badkey;
+		ctx->auth_keylen = keylen - ctx->enc_keylen;
+
+		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+			/* the nonce is stored in bytes at end of key */
+			if (ctx->enc_keylen <
+			    (AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE))
+				goto badkey;
+			/* Copy nonce from last 4 bytes in CTR key to
+			*  first 4 bytes in CTR IV */
+			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen + ctx->enc_keylen -
+				CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
+			/* Set CTR key size */
+			ctx->enc_keylen -= CTR_RFC3686_NONCE_SIZE;
+		}
+	} else { /* non-authenc - has just one key */
+		ctx->enc_keylen = keylen;
+		ctx->auth_keylen = 0;
+	}
+
+	rc = validate_keys_sizes(ctx);
+	if (unlikely(rc != 0))
+		goto badkey;
+
+	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
+	/* STAT_PHASE_1: Copy key to ctx */
+	START_CYCLE_COUNT();
+
+	/* Get key material */
+	memcpy(ctx->enckey, key + ctx->auth_keylen, ctx->enc_keylen);
+	if (ctx->enc_keylen == 24)
+		memset(ctx->enckey + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
+		memcpy(ctx->auth_state.xcbc.xcbc_keys, key, ctx->auth_keylen);
+	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC */
+		rc = ssi_get_plain_hmac_key(tfm, key, ctx->auth_keylen);
+		if (rc != 0)
+			goto badkey;
+	}
+
+	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
+	
+	/* STAT_PHASE_2: Create sequence */
+	START_CYCLE_COUNT();
+
+	switch (ctx->auth_mode) {
+	case DRV_HASH_SHA1:
+	case DRV_HASH_SHA256:
+		seq_len = hmac_setkey(desc, ctx);
+		break;
+	case DRV_HASH_XCBC_MAC:
+		seq_len = xcbc_setkey(desc, ctx);
+		break;
+	case DRV_HASH_NULL: /* non-authenc modes, e.g., CCM */
+		break; /* No auth. key setup */
+	default:
+		SSI_LOG_ERR("Unsupported authenc (%d)\n", ctx->auth_mode);
+		rc = -ENOTSUPP;
+		goto badkey;
+	}
+
+	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_2);
+
+	/* STAT_PHASE_3: Submit sequence to HW */
+	START_CYCLE_COUNT();
+	
+	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
+#ifdef ENABLE_CYCLE_COUNT
+		ssi_req.op_type = STAT_OP_TYPE_SETKEY;
+#endif
+		rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 0);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
+			goto setkey_error;
+		}
+	}
+
+	/* Update STAT_PHASE_3 */
+	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_3);
+	return rc;
+
+badkey:
+	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+setkey_error:
+	return rc;
+}
+
+#if SSI_CC_HAS_AES_CCM
+static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	int rc = 0;
+	
+	if (keylen < 3)
+		return -EINVAL;
+
+	keylen -= 3;
+	memcpy(ctx->ctr_nonce, key + keylen, 3);
+
+	rc = ssi_aead_setkey(tfm, key, keylen);
+
+	return rc;
+}
+#endif /*SSI_CC_HAS_AES_CCM*/
+
+static int ssi_aead_setauthsize(
+	struct crypto_aead *authenc,
+	unsigned int authsize)
+{
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	
+	/* Unsupported auth. sizes */
+	if ((authsize == 0) ||
+	    (authsize >crypto_aead_maxauthsize(authenc))) {
+		return -ENOTSUPP;
+	}
+
+	ctx->authsize = authsize;
+	SSI_LOG_DEBUG("authlen=%d\n", ctx->authsize);
+
+	return 0;
+}
+
+#if SSI_CC_HAS_AES_CCM
+static int ssi_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ssi_aead_setauthsize(authenc, authsize);
+}
+
+static int ssi_ccm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 6:
+	case 8:
+	case 10:
+	case 12:
+	case 14:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ssi_aead_setauthsize(authenc, authsize);
+}
+#endif /*SSI_CC_HAS_AES_CCM*/
+
+static inline void 
+ssi_aead_create_assoc_desc(
+	struct aead_request *areq, 
+	unsigned int flow_mode,
+	HwDesc_s desc[], 
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	enum ssi_req_dma_buf_type assoc_dma_type = areq_ctx->assoc_buff_type;
+	unsigned int idx = *seq_size;
+
+	switch (assoc_dma_type) {
+	case SSI_DMA_BUF_DLLI:
+		SSI_LOG_DEBUG("ASSOC buffer type DLLI\n");
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+			sg_dma_address(areq->src),
+			areq->assoclen, NS_BIT);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC && (areq_ctx->cryptlen > 0) )
+			HW_DESC_SET_DIN_NOT_LAST_INDICATION(&desc[idx]);
+		break;
+	case SSI_DMA_BUF_MLLI:
+		SSI_LOG_DEBUG("ASSOC buffer type MLLI\n");
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
+				     areq_ctx->assoc.sram_addr,
+				     areq_ctx->assoc.mlli_nents,
+				     NS_BIT);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC && (areq_ctx->cryptlen > 0) )
+			HW_DESC_SET_DIN_NOT_LAST_INDICATION(&desc[idx]);
+		break;
+	case SSI_DMA_BUF_NULL:
+	default:
+		SSI_LOG_ERR("Invalid ASSOC buffer type\n");
+	}
+
+	*seq_size = (++idx);
+}
+
+static inline void
+ssi_aead_process_authenc_data_desc(
+	struct aead_request *areq, 
+	unsigned int flow_mode,
+	HwDesc_s desc[], 
+	unsigned int *seq_size,
+	int direct)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
+	unsigned int idx = *seq_size;
+
+	switch (data_dma_type) {
+	case SSI_DMA_BUF_DLLI:
+	{
+		struct scatterlist *cipher =
+			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			areq_ctx->dstSgl : areq_ctx->srcSgl;
+
+		unsigned int offset = 
+			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			areq_ctx->dstOffset : areq_ctx->srcOffset;
+		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type DLLI\n");
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			(sg_dma_address(cipher)+ offset), areq_ctx->cryptlen,
+			NS_BIT);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		break;
+	}
+	case SSI_DMA_BUF_MLLI:
+	{
+		/* DOUBLE-PASS flow (as default)
+		 * assoc. + iv + data -compact in one table
+		 * if assoclen is ZERO only IV perform */
+		ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
+		uint32_t mlli_nents = areq_ctx->assoc.mlli_nents;
+
+		if (likely(areq_ctx->is_single_pass == true)) {
+			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT){
+				mlli_addr = areq_ctx->dst.sram_addr;
+				mlli_nents = areq_ctx->dst.mlli_nents;
+			} else {
+				mlli_addr = areq_ctx->src.sram_addr;
+				mlli_nents = areq_ctx->src.mlli_nents;
+			}
+		}
+
+		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type MLLI\n");
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
+			mlli_addr, mlli_nents, NS_BIT);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		break;
+	}
+	case SSI_DMA_BUF_NULL:
+	default:
+		SSI_LOG_ERR("AUTHENC: Invalid SRC/DST buffer type\n");
+	}
+
+	*seq_size = (++idx);
+}
+
+static inline void
+ssi_aead_process_cipher_data_desc(
+	struct aead_request *areq, 
+	unsigned int flow_mode,
+	HwDesc_s desc[], 
+	unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
+
+	if (areq_ctx->cryptlen == 0)
+		return; /*null processing*/
+
+	switch (data_dma_type) {
+	case SSI_DMA_BUF_DLLI:
+		SSI_LOG_DEBUG("CIPHER: SRC/DST buffer type DLLI\n");
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			(sg_dma_address(areq_ctx->srcSgl)+areq_ctx->srcOffset),
+			areq_ctx->cryptlen, NS_BIT);
+		HW_DESC_SET_DOUT_DLLI(&desc[idx],
+			(sg_dma_address(areq_ctx->dstSgl)+areq_ctx->dstOffset),
+			areq_ctx->cryptlen, NS_BIT, 0);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		break;
+	case SSI_DMA_BUF_MLLI:
+		SSI_LOG_DEBUG("CIPHER: SRC/DST buffer type MLLI\n");
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
+			areq_ctx->src.sram_addr,
+			areq_ctx->src.mlli_nents, NS_BIT);
+		HW_DESC_SET_DOUT_MLLI(&desc[idx],
+			areq_ctx->dst.sram_addr,
+			areq_ctx->dst.mlli_nents, NS_BIT, 0);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		break;
+	case SSI_DMA_BUF_NULL:
+	default:
+		SSI_LOG_ERR("CIPHER: Invalid SRC/DST buffer type\n");
+	}
+
+	*seq_size = (++idx);
+}
+
+static inline void ssi_aead_process_digest_result_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	int direct = req_ctx->gen_ctx.op_type;
+
+	/* Get final ICV result */
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+		HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->icv_dma_addr,
+			ctx->authsize, NS_BIT, 1);
+		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
+			HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC); 
+		} else {
+			HW_DESC_SET_CIPHER_CONFIG0(&desc[idx],
+				HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		}
+	} else { /*Decrypt*/
+		/* Get ICV out from hardware */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+		HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->mac_buf_dma_addr,
+			ctx->authsize, NS_BIT, 1);
+		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
+			HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+		} else {
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+		}
+	}
+
+	*seq_size = (++idx);
+}
+
+static inline void ssi_aead_setup_cipher_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int hw_iv_size = req_ctx->hw_iv_size;
+	unsigned int idx = *seq_size;
+	int direct = req_ctx->gen_ctx.op_type;
+
+	/* Setup cipher state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direct);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], ctx->flow_mode);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+		req_ctx->gen_ctx.iv_dma_addr, hw_iv_size, NS_BIT);
+	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	} else {
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	}
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->cipher_mode);
+	idx++;
+
+	/* Setup enc. key */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direct);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], ctx->flow_mode);
+	if (ctx->flow_mode == S_DIN_to_AES) {
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr, 
+			((ctx->enc_keylen == 24) ?
+			 CC_AES_KEY_SIZE_MAX : ctx->enc_keylen), NS_BIT);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	} else {
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+			ctx->enc_keylen, NS_BIT);
+		HW_DESC_SET_KEY_SIZE_DES(&desc[idx], ctx->enc_keylen);
+	}
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->cipher_mode);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_process_cipher(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size,
+	unsigned int data_flow_mode)
+{
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	int direct = req_ctx->gen_ctx.op_type;
+	unsigned int idx = *seq_size;
+
+	if (req_ctx->cryptlen == 0)
+		return; /*null processing*/
+
+	ssi_aead_setup_cipher_desc(req, desc, &idx);
+	ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, &idx);
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		/* We must wait for DMA to write all cipher */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+		HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+		idx++;
+	}
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_hmac_setup_digest_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ? 
+				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	unsigned int idx = *seq_size;
+
+	/* Loading hash ipad xor key state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+		ctx->auth_state.hmac.ipad_opad_dma_addr,
+		digest_size, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load init. digest len (64 bytes) */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	HW_DESC_SET_DIN_SRAM(&desc[idx],
+		ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, hash_mode),
+		HASH_LEN_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_xcbc_setup_digest_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int idx = *seq_size;
+
+	/* Loading MAC state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_CONST(&desc[idx], 0, CC_AES_BLOCK_SIZE);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* Setup XCBC MAC K1 */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     ctx->auth_state.xcbc.xcbc_keys_dma_addr,
+			     AES_KEYSIZE_128, NS_BIT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* Setup XCBC MAC K2 */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     (ctx->auth_state.xcbc.xcbc_keys_dma_addr + 
+			      AES_KEYSIZE_128),
+			     AES_KEYSIZE_128, NS_BIT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* Setup XCBC MAC K3 */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
+			      2 * AES_KEYSIZE_128),
+			     AES_KEYSIZE_128, NS_BIT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE2);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_process_digest_header_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	/* Hash associated data */
+	if (req->assoclen > 0)
+		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, &idx);
+
+	/* Hash IV */
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_process_digest_scheme_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct ssi_aead_handle *aead_handle = ctx->drvdata->aead_handle;
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ? 
+				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	unsigned int idx = *seq_size;
+
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	HW_DESC_SET_DOUT_SRAM(&desc[idx], aead_handle->sram_workspace_addr,
+			HASH_LEN_SIZE);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
+	HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
+	idx++;
+
+	/* Get final ICV result */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DOUT_SRAM(&desc[idx], aead_handle->sram_workspace_addr,
+			digest_size);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	idx++;
+
+	/* Loading hash opad xor key state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+		(ctx->auth_state.hmac.ipad_opad_dma_addr + digest_size),
+		digest_size, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load init. digest len (64 bytes) */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	HW_DESC_SET_DIN_SRAM(&desc[idx],
+		ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, hash_mode),
+		HASH_LEN_SIZE);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Perform HASH update */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_SRAM(&desc[idx], aead_handle->sram_workspace_addr,
+			digest_size);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_load_mlli_to_sram(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (unlikely(
+		(req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
+		(req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
+		(req_ctx->is_single_pass == false))) {
+		SSI_LOG_DEBUG("Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
+			(unsigned int)ctx->drvdata->mlli_sram_addr,
+			req_ctx->mlli_params.mlli_len);
+		/* Copy MLLI table host-to-sram */
+		HW_DESC_INIT(&desc[*seq_size]);
+		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
+			req_ctx->mlli_params.mlli_dma_addr,
+			req_ctx->mlli_params.mlli_len, NS_BIT);
+		HW_DESC_SET_DOUT_SRAM(&desc[*seq_size],
+			ctx->drvdata->mlli_sram_addr,
+			req_ctx->mlli_params.mlli_len);
+		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], BYPASS);
+		(*seq_size)++;
+	}
+}
+
+static inline enum FlowMode ssi_aead_get_data_flow_mode(
+	enum drv_crypto_direction direct,
+	enum FlowMode setup_flow_mode,
+	bool is_single_pass)
+{
+	enum FlowMode data_flow_mode;
+
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		if (setup_flow_mode == S_DIN_to_AES)
+			data_flow_mode = likely(is_single_pass) ?
+				AES_to_HASH_and_DOUT : DIN_AES_DOUT;
+		else
+			data_flow_mode = likely(is_single_pass) ?
+				DES_to_HASH_and_DOUT : DIN_DES_DOUT;
+	} else { /* Decrypt */
+		if (setup_flow_mode == S_DIN_to_AES)
+			data_flow_mode = likely(is_single_pass) ?
+					AES_and_HASH : DIN_AES_DOUT;
+		else
+			data_flow_mode = likely(is_single_pass) ?
+					DES_and_HASH : DIN_DES_DOUT;
+	}
+
+	return data_flow_mode;
+}
+
+static inline void ssi_aead_hmac_authenc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	int direct = req_ctx->gen_ctx.op_type;
+	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
+		direct, ctx->flow_mode, req_ctx->is_single_pass);
+
+	if (req_ctx->is_single_pass == true) {
+		/**
+		 * Single-pass flow
+		 */
+		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
+		ssi_aead_setup_cipher_desc(req, desc, seq_size);
+		ssi_aead_process_digest_header_desc(req, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
+		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		return;
+	}
+
+	/** 
+	 * Double-pass flow
+	 * Fallback for unsupported single-pass modes, 
+	 * i.e. using assoc. data of non-word-multiple */
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		/* encrypt first.. */
+		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		/* authenc after..*/
+		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
+		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+
+	} else { /*DECRYPT*/
+		/* authenc first..*/
+		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
+		/* decrypt after.. */
+		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		/* read the digest result with setting the completion bit
+		   must be after the cipher operation */
+		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+	}
+}
+
+static inline void
+ssi_aead_xcbc_authenc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	int direct = req_ctx->gen_ctx.op_type;
+	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
+		direct, ctx->flow_mode, req_ctx->is_single_pass);
+
+	if (req_ctx->is_single_pass == true) {
+		/**
+		 * Single-pass flow
+		 */
+		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
+		ssi_aead_setup_cipher_desc(req, desc, seq_size);
+		ssi_aead_process_digest_header_desc(req, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		return;
+	}
+
+	/** 
+	 * Double-pass flow
+	 * Fallback for unsupported single-pass modes, 
+	 * i.e. using assoc. data of non-word-multiple */
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		/* encrypt first.. */
+		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		/* authenc after.. */
+		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+	} else { /*DECRYPT*/
+		/* authenc first.. */
+		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		/* decrypt after..*/
+		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		/* read the digest result with setting the completion bit
+		   must be after the cipher operation */
+		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+	}
+}
+
+static int validate_data_size(struct ssi_aead_ctx *ctx,
+	enum drv_crypto_direction direct, struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	unsigned int assoclen = req->assoclen;
+	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
+			(req->cryptlen - ctx->authsize) : req->cryptlen;
+
+	if (unlikely((direct == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+		(req->cryptlen < ctx->authsize)))
+		goto data_size_err;
+
+	areq_ctx->is_single_pass = true; /*defaulted to fast flow*/
+
+	switch (ctx->flow_mode) {
+	case S_DIN_to_AES:
+		if (unlikely((ctx->cipher_mode == DRV_CIPHER_CBC) &&
+			!IS_ALIGNED(cipherlen, AES_BLOCK_SIZE)))
+			goto data_size_err;
+		if (ctx->cipher_mode == DRV_CIPHER_CCM)
+			break;
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
+		{
+			if (areq_ctx->plaintext_authenticate_only == true)
+				areq_ctx->is_single_pass = false; 
+			break;
+		}
+
+		if (!IS_ALIGNED(assoclen, sizeof(uint32_t)))
+			areq_ctx->is_single_pass = false;
+
+		if ((ctx->cipher_mode == DRV_CIPHER_CTR) &&
+		    !IS_ALIGNED(cipherlen, sizeof(uint32_t)))
+			areq_ctx->is_single_pass = false;
+
+		break;
+	case S_DIN_to_DES:
+		if (unlikely(!IS_ALIGNED(cipherlen, DES_BLOCK_SIZE)))
+			goto data_size_err;
+		if (unlikely(!IS_ALIGNED(assoclen, DES_BLOCK_SIZE)))
+			areq_ctx->is_single_pass = false;
+		break;
+	default:
+		SSI_LOG_ERR("Unexpected flow mode (%d)\n", ctx->flow_mode);
+		goto data_size_err;
+	}
+
+	return 0;
+
+data_size_err:
+	return -EINVAL;
+}
+
+#if SSI_CC_HAS_AES_CCM
+static unsigned int format_ccm_a0(uint8_t *pA0Buff, uint32_t headerSize)
+{
+	unsigned int len = 0;
+	if ( headerSize == 0 ) {
+		return 0;
+	} 
+	if ( headerSize < ((1UL << 16) - (1UL << 8) )) {
+		len = 2;
+
+		pA0Buff[0] = (headerSize >> 8) & 0xFF;
+		pA0Buff[1] = headerSize & 0xFF;
+	} else {
+		len = 6;
+
+		pA0Buff[0] = 0xFF;
+		pA0Buff[1] = 0xFE;
+		pA0Buff[2] = (headerSize >> 24) & 0xFF;
+		pA0Buff[3] = (headerSize >> 16) & 0xFF;
+		pA0Buff[4] = (headerSize >> 8) & 0xFF;
+		pA0Buff[5] = headerSize & 0xFF;
+	}
+
+	return len;
+}
+
+static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
+{
+	__be32 data;
+
+	memset(block, 0, csize);
+	block += csize;
+
+	if (csize >= 4)
+		csize = 4;
+	else if (msglen > (1 << (8 * csize)))
+		return -EOVERFLOW;
+
+	data = cpu_to_be32(msglen);
+	memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
+
+	return 0;
+}
+
+static inline int ssi_aead_ccm(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+	unsigned int cipher_flow_mode;
+	dma_addr_t mac_result;
+
+
+	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		cipher_flow_mode = AES_to_HASH_and_DOUT;
+		mac_result = req_ctx->mac_buf_dma_addr;
+	} else { /* Encrypt */
+		cipher_flow_mode = AES_and_HASH;
+		mac_result = req_ctx->icv_dma_addr;
+	}
+
+	/* load key */
+	HW_DESC_INIT(&desc[idx]);	
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);	
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr, 
+			((ctx->enc_keylen == 24) ? 
+			 CC_AES_KEY_SIZE_MAX : ctx->enc_keylen), 
+			 NS_BIT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load ctr state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			req_ctx->gen_ctx.iv_dma_addr, 
+			     AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load MAC key */
+	HW_DESC_INIT(&desc[idx]);	
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);	
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr, 
+			((ctx->enc_keylen == 24) ? 
+			 CC_AES_KEY_SIZE_MAX : ctx->enc_keylen), 
+			 NS_BIT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* load MAC state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			req_ctx->mac_buf_dma_addr, 
+			     AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+
+	/* process assoc data */
+	if (req->assoclen > 0) {
+		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, &idx);
+	} else {
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+				      sg_dma_address(&req_ctx->ccm_adata_sg),
+				     AES_BLOCK_SIZE + req_ctx->ccm_hdr_size,
+				     NS_BIT);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		idx++;
+	}
+
+	/* process the cipher */
+	if (req_ctx->cryptlen != 0) {
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
+	}
+
+	/* Read temporal MAC */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->mac_buf_dma_addr,
+			      ctx->authsize, NS_BIT, 0);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* load AES-CTR state (for last MAC calculation)*/
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     req_ctx->ccm_iv0_dma_addr ,
+			     AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* encrypt the "T" value and store MAC in mac_state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			req_ctx->mac_buf_dma_addr , ctx->authsize, NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_result , ctx->authsize, NS_BIT, 1);
+	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	idx++;	
+
+	*seq_size = idx;
+	return 0;
+}
+
+static int config_ccm_adata(struct aead_request *req) {
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	//unsigned int size_of_a = 0, rem_a_size = 0;
+	unsigned int lp = req->iv[0];
+	/* Note: The code assume that req->iv[0] already contains the value of L' of RFC3610 */
+	unsigned int l = lp + 1;  /* This is L' of RFC 3610. */
+	unsigned int m = ctx->authsize;  /* This is M' of RFC 3610. */
+	uint8_t *b0 = req_ctx->ccm_config + CCM_B0_OFFSET;
+	uint8_t *a0 = req_ctx->ccm_config + CCM_A0_OFFSET;
+	uint8_t *ctr_count_0 = req_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
+	unsigned int cryptlen = (req_ctx->gen_ctx.op_type == 
+				 DRV_CRYPTO_DIRECTION_ENCRYPT) ? 
+				req->cryptlen : 
+				(req->cryptlen - ctx->authsize);
+	int rc;
+	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
+	memset(req_ctx->ccm_config, 0, AES_BLOCK_SIZE*3);
+
+	/* taken from crypto/ccm.c */
+	/* 2 <= L <= 8, so 1 <= L' <= 7. */
+	if (2 > l || l > 8) {
+		SSI_LOG_ERR("illegal iv value %X\n",req->iv[0]);
+		return -EINVAL;
+	}
+	memcpy(b0, req->iv, AES_BLOCK_SIZE);
+
+	/* format control info per RFC 3610 and
+	 * NIST Special Publication 800-38C
+	 */
+	*b0 |= (8 * ((m - 2) / 2));
+	if (req->assoclen > 0)
+		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
+	
+	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
+	if (rc != 0) {
+		return rc;
+	}
+	 /* END of "taken from crypto/ccm.c" */
+	
+	/* l(a) - size of associated data. */
+	req_ctx->ccm_hdr_size = format_ccm_a0 (a0, req->assoclen);
+
+	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
+	req->iv [15] = 1;
+
+	memcpy(ctr_count_0, req->iv, AES_BLOCK_SIZE) ;
+	ctr_count_0[15] = 0;
+
+	return 0;
+}
+
+static void ssi_rfc4309_ccm_process(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+
+	/* L' */
+	memset(areq_ctx->ctr_iv, 0, AES_BLOCK_SIZE);
+	areq_ctx->ctr_iv[0] = 3;  /* For RFC 4309, always use 4 bytes for message length (at most 2^32-1 bytes). */
+
+	/* In RFC 4309 there is an 11-bytes nonce+IV part, that we build here. */
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce, CCM_BLOCK_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET,    req->iv,        CCM_BLOCK_IV_SIZE);
+	req->iv = areq_ctx->ctr_iv;	
+	req->assoclen -= CCM_BLOCK_IV_SIZE;
+}
+#endif /*SSI_CC_HAS_AES_CCM*/
+
+#if SSI_CC_HAS_AES_GCM
+
+static inline void ssi_aead_gcm_setup_ghash_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+
+	/* load key to AES*/
+	HW_DESC_INIT(&desc[idx]);	
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_ECB);	
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr, 
+			ctx->enc_keylen, NS_BIT); 
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* process one zero block to generate hkey */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx],
+				  req_ctx->hkey_dma_addr,
+				  AES_BLOCK_SIZE,
+				  NS_BIT, 0); 
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	idx++;
+
+	/* Memory Barrier */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* Load GHASH subkey */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			req_ctx->hkey_dma_addr, 
+				 AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);	
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Configure Hash Engine to work with GHASH.
+	   Since it was not possible to extend HASH submodes to add GHASH,
+	   The following command is necessary in order to select GHASH (according to HW designers)*/
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);	
+	HW_DESC_SET_CIPHER_DO(&desc[idx], 1); //1=AES_SK RKEK
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED); 
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Load GHASH initial STATE (which is 0). (for any hash there is an initial state) */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED); 
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_gcm_setup_gctr_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+
+	/* load key to AES*/
+	HW_DESC_INIT(&desc[idx]);	
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);	
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr, 
+			ctx->enc_keylen, NS_BIT); 
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only==false)){
+		/* load AES/CTR initial CTR value inc by 2*/
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				req_ctx->gcm_iv_inc2_dma_addr, 
+					 AES_BLOCK_SIZE, NS_BIT);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);	
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+		idx++;
+	}
+
+	*seq_size = idx;
+}
+
+static inline void ssi_aead_process_gcm_result_desc(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	dma_addr_t mac_result; 
+	unsigned int idx = *seq_size;
+
+	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		mac_result = req_ctx->mac_buf_dma_addr;
+	} else { /* Encrypt */
+		mac_result = req_ctx->icv_dma_addr;
+	}
+
+	/* process(ghash) gcm_block_len */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+		req_ctx->gcm_block_len_dma_addr,
+		AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->mac_buf_dma_addr,
+				  AES_BLOCK_SIZE, NS_BIT, 0);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+
+	idx++; 
+
+	/* load AES/CTR initial CTR value inc by 1*/
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				 req_ctx->gcm_iv_inc1_dma_addr, 
+				 AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Memory Barrier */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* process GCTR on stored GHASH and store MAC in mac_state*/
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+		req_ctx->mac_buf_dma_addr,
+		AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
+	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	idx++;	
+
+	*seq_size = idx;
+}
+
+static inline int ssi_aead_gcm(
+	struct aead_request *req,
+	HwDesc_s desc[],
+	unsigned int *seq_size)
+{
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+	unsigned int cipher_flow_mode;
+
+	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		cipher_flow_mode = AES_and_HASH;
+	} else { /* Encrypt */
+		cipher_flow_mode = AES_to_HASH_and_DOUT;
+	}
+
+
+	//in RFC4543 no data to encrypt. just copy data from src to dest.
+	if (req_ctx->plaintext_authenticate_only==true){     
+		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
+		ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
+		/* process(ghash) assoc data */
+		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
+		ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
+		ssi_aead_process_gcm_result_desc(req, desc, seq_size);
+		idx = *seq_size;
+		return 0;
+	}
+
+	// for gcm and rfc4106.
+	ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
+	/* process(ghash) assoc data */
+	if (req->assoclen > 0)
+		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
+	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
+	/* process(gctr+ghash) */
+	if (req_ctx->cryptlen != 0)
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size); 
+	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
+
+	idx = *seq_size;
+	return 0;
+}
+
+#ifdef CC_DEBUG
+static inline void ssi_aead_dump_gcm(
+	const char* title,
+	struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+
+	if (ctx->cipher_mode != DRV_CIPHER_GCTR)
+		return;
+
+	if (title != NULL) {
+		SSI_LOG_DEBUG("----------------------------------------------------------------------------------");
+		SSI_LOG_DEBUG("%s\n", title);
+	}
+
+	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d \n", \
+				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen );
+
+	if ( ctx->enckey != NULL ) {
+		dump_byte_array("mac key",ctx->enckey, 16);
+	}
+
+	dump_byte_array("req->iv",req->iv, AES_BLOCK_SIZE);
+
+	dump_byte_array("gcm_iv_inc1",req_ctx->gcm_iv_inc1, AES_BLOCK_SIZE);
+
+	dump_byte_array("gcm_iv_inc2",req_ctx->gcm_iv_inc2, AES_BLOCK_SIZE);
+
+	dump_byte_array("hkey",req_ctx->hkey, AES_BLOCK_SIZE);
+
+	dump_byte_array("mac_buf",req_ctx->mac_buf, AES_BLOCK_SIZE);
+
+	dump_byte_array("gcm_len_block",req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
+
+	if (req->src!=NULL && req->cryptlen) {
+		dump_byte_array("req->src",sg_virt(req->src), req->cryptlen+req->assoclen);
+	}
+
+	if (req->dst!=NULL) {
+		dump_byte_array("req->dst",sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
+    }
+}
+#endif
+
+static int config_gcm_context(struct aead_request *req) {
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	
+	unsigned int cryptlen = (req_ctx->gen_ctx.op_type == 
+				 DRV_CRYPTO_DIRECTION_ENCRYPT) ? 
+				req->cryptlen : 
+				(req->cryptlen - ctx->authsize);
+	__be32 counter = cpu_to_be32(2);
+
+	SSI_LOG_DEBUG("config_gcm_context() cryptlen = %d, req->assoclen = %d ctx->authsize = %d \n", cryptlen, req->assoclen, ctx->authsize);
+
+	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
+
+	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
+
+	memcpy(req->iv + 12, &counter, 4);
+	memcpy(req_ctx->gcm_iv_inc2, req->iv, 16);
+
+	counter = cpu_to_be32(1);
+	memcpy(req->iv + 12, &counter, 4);
+	memcpy(req_ctx->gcm_iv_inc1, req->iv, 16);
+
+
+	if (req_ctx->plaintext_authenticate_only == false)
+	{
+		__be64 temp64;
+		temp64 = cpu_to_be64(req->assoclen * 8);
+		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
+		temp64 = cpu_to_be64(cryptlen * 8);
+		memcpy ( &req_ctx->gcm_len_block.lenC , &temp64, 8 );
+	}
+	else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
+		__be64 temp64;
+		temp64 = cpu_to_be64((req->assoclen+GCM_BLOCK_RFC4_IV_SIZE+cryptlen) * 8);
+		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
+		temp64 = 0;
+		memcpy ( &req_ctx->gcm_len_block.lenC , &temp64, 8 );
+	}
+
+	return 0;
+}
+
+static void ssi_rfc4_gcm_process(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET, ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET,    req->iv, GCM_BLOCK_RFC4_IV_SIZE);
+	req->iv = areq_ctx->ctr_iv;	
+	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
+}
+
+
+#endif /*SSI_CC_HAS_AES_GCM*/
+
+static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction direct)
+{
+	int rc = 0;
+	int seq_len = 0;
+	HwDesc_s desc[MAX_AEAD_PROCESS_SEQ]; 
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct ssi_crypto_req ssi_req = {};
+
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
+		((direct==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"), ctx, req, req->iv,
+		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+	START_CYCLE_COUNT();
+	
+	/* Check data length according to mode */
+	if (unlikely(validate_data_size(ctx, direct, req) != 0)) {
+		SSI_LOG_ERR("Unsupported crypt/assoc len %d/%d.\n",
+				req->cryptlen, req->assoclen);
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
+		return -EINVAL;
+	}
+
+	/* Setup DX request structure */
+	ssi_req.user_cb = (void *)ssi_aead_complete;
+	ssi_req.user_arg = (void *)req;
+
+#ifdef ENABLE_CYCLE_COUNT
+	ssi_req.op_type = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
+		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
+#endif
+	/* Setup request context */
+	areq_ctx->gen_ctx.op_type = direct;
+	areq_ctx->req_authsize = ctx->authsize;
+	areq_ctx->cipher_mode = ctx->cipher_mode;
+
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_0);
+
+	/* STAT_PHASE_1: Map buffers */
+	START_CYCLE_COUNT();
+	
+	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+		/* Build CTR IV - Copy nonce from last 4 bytes in
+		*  CTR key to first 4 bytes in CTR IV */
+		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
+		if (areq_ctx->backup_giv == NULL) /*User none-generated IV*/
+			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
+				req->iv, CTR_RFC3686_IV_SIZE);
+		/* Initialize counter portion of counter block */
+		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
+			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
+
+		/* Replace with counter iv */
+		req->iv = areq_ctx->ctr_iv;
+		areq_ctx->hw_iv_size = CTR_RFC3686_BLOCK_SIZE;
+	} else if ((ctx->cipher_mode == DRV_CIPHER_CCM) || 
+		   (ctx->cipher_mode == DRV_CIPHER_GCTR) ) {
+		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
+		if (areq_ctx->ctr_iv != req->iv) {
+			memcpy(areq_ctx->ctr_iv, req->iv, crypto_aead_ivsize(tfm));
+			req->iv = areq_ctx->ctr_iv;
+		}
+	}  else {
+		areq_ctx->hw_iv_size = crypto_aead_ivsize(tfm);
+	}
+
+#if SSI_CC_HAS_AES_CCM
+	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+		rc = config_ccm_adata(req);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("config_ccm_adata() returned with a failure %d!", rc);
+			goto exit; 
+		}
+	} else {
+		areq_ctx->ccm_hdr_size = ccm_header_size_null;		
+	}
+#else
+	areq_ctx->ccm_hdr_size = ccm_header_size_null;		
+#endif /*SSI_CC_HAS_AES_CCM*/
+
+#if SSI_CC_HAS_AES_GCM 
+	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		rc = config_gcm_context(req);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("config_gcm_context() returned with a failure %d!", rc);
+			goto exit; 
+		}
+	} 
+#endif /*SSI_CC_HAS_AES_GCM*/
+
+	rc = ssi_buffer_mgr_map_aead_request(ctx->drvdata, req);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("map_request() failed\n");
+		goto exit;
+	}
+
+	/* do we need to generate IV? */
+	if (areq_ctx->backup_giv != NULL) {
+
+		/* set the DMA mapped IV address*/
+		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CTR_RFC3686_NONCE_SIZE;
+			ssi_req.ivgen_dma_addr_len = 1;
+		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+			/* In ccm, the IV needs to exist both inside B0 and inside the counter.
+			   It is also copied to iv_dma_addr for other reasons (like returning
+			   it to the user).
+			   So, using 3 (identical) IV outputs. */
+			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[1] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_B0_OFFSET          + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[2] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr_len = 3;
+		} else {
+			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr;
+			ssi_req.ivgen_dma_addr_len = 1;
+		}
+
+		/* set the IV size (8/16 B long)*/
+		ssi_req.ivgen_size = crypto_aead_ivsize(tfm);
+	}
+
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_1);
+
+	/* STAT_PHASE_2: Create sequence */
+	START_CYCLE_COUNT();
+
+	/* Load MLLI tables to SRAM if necessary */
+	ssi_aead_load_mlli_to_sram(req, desc, &seq_len);
+
+	/*TODO: move seq len by reference */
+	switch (ctx->auth_mode) {
+	case DRV_HASH_SHA1:
+	case DRV_HASH_SHA256:
+		ssi_aead_hmac_authenc(req, desc, &seq_len);
+		break;
+	case DRV_HASH_XCBC_MAC:
+		ssi_aead_xcbc_authenc(req, desc, &seq_len);
+		break;
+#if ( SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM )
+	case DRV_HASH_NULL:
+#if SSI_CC_HAS_AES_CCM
+		if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+			ssi_aead_ccm(req, desc, &seq_len);
+		}
+#endif /*SSI_CC_HAS_AES_CCM*/
+#if SSI_CC_HAS_AES_GCM
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
+			ssi_aead_gcm(req, desc, &seq_len);
+		}
+#endif /*SSI_CC_HAS_AES_GCM*/
+			break;
+#endif
+	default:	
+		SSI_LOG_ERR("Unsupported authenc (%d)\n", ctx->auth_mode);
+		ssi_buffer_mgr_unmap_aead_request(dev, req);
+		rc = -ENOTSUPP;
+		goto exit;
+	}
+
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_2);
+
+	/* STAT_PHASE_3: Lock HW and push sequence */
+	START_CYCLE_COUNT();
+
+	rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 1);
+
+	if (unlikely(rc != -EINPROGRESS)) {
+		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
+		ssi_buffer_mgr_unmap_aead_request(dev, req);
+	}
+
+	
+	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
+exit:
+	return rc;
+}
+
+static int ssi_aead_encrypt(struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc;
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	areq_ctx->is_gcm4543 = false;
+
+	areq_ctx->plaintext_authenticate_only = false;
+
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+
+#if SSI_CC_HAS_AES_CCM
+static int ssi_rfc4309_ccm_encrypt(struct aead_request *req)
+{
+	/* Very similar to ssi_aead_encrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen );
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	areq_ctx->is_gcm4543 = true;
+	
+	ssi_rfc4309_ccm_process(req);
+	
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+out:
+	return rc;
+}
+#endif /* SSI_CC_HAS_AES_CCM */
+
+static int ssi_aead_decrypt(struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc;
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	areq_ctx->is_gcm4543 = false;
+
+	areq_ctx->plaintext_authenticate_only = false;
+
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+
+}
+
+#if SSI_CC_HAS_AES_CCM
+static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
+{
+	/* Very similar to ssi_aead_decrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	
+	areq_ctx->is_gcm4543 = true;
+	ssi_rfc4309_ccm_process(req);
+	
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+
+out:
+	return rc;
+}
+#endif /* SSI_CC_HAS_AES_CCM */
+
+#if SSI_CC_HAS_AES_GCM
+
+static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	int rc = 0;
+	
+	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p \n", keylen, key );
+
+	if (keylen < 4)
+		return -EINVAL;
+
+	keylen -= 4;
+	memcpy(ctx->ctr_nonce, key + keylen, 4);
+
+	rc = ssi_aead_setkey(tfm, key, keylen);
+
+	return rc;
+}
+
+static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	int rc = 0;
+	
+	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p \n", keylen, key );
+
+	if (keylen < 4)
+		return -EINVAL;
+
+	keylen -= 4;
+	memcpy(ctx->ctr_nonce, key + keylen, 4);
+
+	rc = ssi_aead_setkey(tfm, key, keylen);
+
+	return rc;
+}
+
+static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ssi_aead_setauthsize(authenc, authsize);
+}
+
+static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+        SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize );
+
+        switch (authsize) {
+        case 8:
+        case 12:
+        case 16:
+                break;
+        default:
+                return -EINVAL;
+        }
+
+        return ssi_aead_setauthsize(authenc, authsize);
+}
+
+static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d \n", authsize );
+
+	if (authsize != 16)
+		return -EINVAL;
+
+	return ssi_aead_setauthsize(authenc, authsize);
+}
+
+static int ssi_rfc4106_gcm_encrypt(struct aead_request *req)
+{
+	/* Very similar to ssi_aead_encrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+        int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	
+	areq_ctx->plaintext_authenticate_only = false;
+
+	ssi_rfc4_gcm_process(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+out:
+	return rc;
+}
+
+static int ssi_rfc4543_gcm_encrypt(struct aead_request *req)
+{
+	/* Very similar to ssi_aead_encrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc;
+	
+	//plaintext is not encryped with rfc4543
+	areq_ctx->plaintext_authenticate_only = true;
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	
+	ssi_rfc4_gcm_process(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+
+static int ssi_rfc4106_gcm_decrypt(struct aead_request *req)
+{
+	/* Very similar to ssi_aead_decrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+        int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	
+	areq_ctx->plaintext_authenticate_only = false;
+
+	ssi_rfc4_gcm_process(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+out:
+	return rc;
+}
+
+static int ssi_rfc4543_gcm_decrypt(struct aead_request *req)
+{
+	/* Very similar to ssi_aead_decrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc;
+
+	//plaintext is not decryped with rfc4543
+	areq_ctx->plaintext_authenticate_only = true;
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	
+	ssi_rfc4_gcm_process(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+#endif /* SSI_CC_HAS_AES_GCM */
+
+/* DX Block aead alg */
+static struct ssi_alg_template aead_algs[] = {
+	{
+		.name = "authenc(hmac(sha1),cbc(aes))",
+		.driver_name = "authenc-hmac-sha1-cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_SHA1,
+	},
+	{
+		.name = "authenc(hmac(sha1),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha1-cbc-des3-dx",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_DES,
+		.auth_mode = DRV_HASH_SHA1,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(aes))",
+		.driver_name = "authenc-hmac-sha256-cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_SHA256,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha256-cbc-des3-dx",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_DES,
+		.auth_mode = DRV_HASH_SHA256,
+	},
+	{
+		.name = "authenc(xcbc(aes),cbc(aes))",
+		.driver_name = "authenc-xcbc-aes-cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_XCBC_MAC,
+	},
+	{
+		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_SHA1,
+	},
+	{
+		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_SHA256,
+	},
+	{
+		.name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-xcbc-aes-rfc3686-ctr-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_aead_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_XCBC_MAC,
+	},
+#if SSI_CC_HAS_AES_CCM
+	{
+		.name = "ccm(aes)",
+		.driver_name = "ccm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_ccm_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CCM,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	},
+	{
+		.name = "rfc4309(ccm(aes))",
+		.driver_name = "rfc4309-ccm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_rfc4309_ccm_setkey,
+			.setauthsize = ssi_rfc4309_ccm_setauthsize,
+			.encrypt = ssi_rfc4309_ccm_encrypt,
+			.decrypt = ssi_rfc4309_ccm_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = CCM_BLOCK_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CCM,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	},
+#endif /*SSI_CC_HAS_AES_CCM*/
+#if SSI_CC_HAS_AES_GCM
+	{
+		.name = "gcm(aes)",
+		.driver_name = "gcm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_aead_setkey,
+			.setauthsize = ssi_gcm_setauthsize,
+			.encrypt = ssi_aead_encrypt,
+			.decrypt = ssi_aead_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = 12,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_GCTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	},
+	{
+		.name = "rfc4106(gcm(aes))",
+		.driver_name = "rfc4106-gcm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_rfc4106_gcm_setkey,
+			.setauthsize = ssi_rfc4106_gcm_setauthsize,
+			.encrypt = ssi_rfc4106_gcm_encrypt,
+			.decrypt = ssi_rfc4106_gcm_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_GCTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	},
+	{
+		.name = "rfc4543(gcm(aes))",
+		.driver_name = "rfc4543-gcm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = ssi_rfc4543_gcm_setkey,
+			.setauthsize = ssi_rfc4543_gcm_setauthsize,
+			.encrypt = ssi_rfc4543_gcm_encrypt,
+			.decrypt = ssi_rfc4543_gcm_decrypt,
+			.init = ssi_aead_init,
+			.exit = ssi_aead_exit,
+			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_GCTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	}, 
+#endif /*SSI_CC_HAS_AES_GCM*/
+};
+
+static struct ssi_crypto_alg *ssi_aead_create_alg(struct ssi_alg_template *template)
+{
+	struct ssi_crypto_alg *t_alg;
+	struct aead_alg *alg;
+
+	t_alg = kzalloc(sizeof(struct ssi_crypto_alg), GFP_KERNEL);
+	if (!t_alg) {
+		SSI_LOG_ERR("failed to allocate t_alg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	alg = &template->template_aead;
+
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 template->driver_name);
+	alg->base.cra_module = THIS_MODULE;
+	alg->base.cra_priority = SSI_CRA_PRIO;
+
+	alg->base.cra_ctxsize = sizeof(struct ssi_aead_ctx);
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			 template->type;
+	alg->init = ssi_aead_init;
+	alg->exit = ssi_aead_exit;
+
+	t_alg->aead_alg = *alg;
+
+	t_alg->cipher_mode = template->cipher_mode;
+	t_alg->flow_mode = template->flow_mode;
+	t_alg->auth_mode = template->auth_mode;
+
+	return t_alg;
+}
+
+int ssi_aead_free(struct ssi_drvdata *drvdata)
+{
+	struct ssi_crypto_alg *t_alg, *n;
+	struct ssi_aead_handle *aead_handle =
+		(struct ssi_aead_handle *)drvdata->aead_handle;
+
+	if (aead_handle != NULL) {
+		/* Remove registered algs */
+		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list, entry) {
+			crypto_unregister_aead(&t_alg->aead_alg);
+			list_del(&t_alg->entry);
+			kfree(t_alg);
+		}
+		kfree(aead_handle);
+		drvdata->aead_handle = NULL;
+	}
+
+	return 0;
+}
+
+int ssi_aead_alloc(struct ssi_drvdata *drvdata)
+{
+	struct ssi_aead_handle *aead_handle;
+	struct ssi_crypto_alg *t_alg;
+	int rc = -ENOMEM;
+	int alg;
+
+	aead_handle = kmalloc(sizeof(struct ssi_aead_handle), GFP_KERNEL);
+	if (aead_handle == NULL) {
+		rc = -ENOMEM;
+		goto fail0;
+	}
+
+	drvdata->aead_handle = aead_handle;
+
+	aead_handle->sram_workspace_addr = ssi_sram_mgr_alloc(
+		drvdata, MAX_HMAC_DIGEST_SIZE);
+	if (aead_handle->sram_workspace_addr == NULL_SRAM_ADDR) {
+		SSI_LOG_ERR("SRAM pool exhausted\n");
+		rc = -ENOMEM;
+		goto fail1;
+	}
+
+	INIT_LIST_HEAD(&aead_handle->aead_list);
+
+	/* Linux crypto */
+	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
+		t_alg = ssi_aead_create_alg(&aead_algs[alg]);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			SSI_LOG_ERR("%s alg allocation failed\n",
+				 aead_algs[alg].driver_name);
+			goto fail1;
+		}
+		t_alg->drvdata = drvdata;
+		rc = crypto_register_aead(&t_alg->aead_alg);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("%s alg registration failed\n",
+				t_alg->aead_alg.base.cra_driver_name);
+			goto fail2;
+		} else {
+			list_add_tail(&t_alg->entry, &aead_handle->aead_list);
+			SSI_LOG_DEBUG("Registered %s\n", t_alg->aead_alg.base.cra_driver_name);
+		}
+	}
+
+	return 0;
+
+fail2:
+	kfree(t_alg);
+fail1:
+	ssi_aead_free(drvdata);
+fail0:
+	return rc;
+}
+
+
+
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
new file mode 100644
index 0000000..fe88c9e
--- /dev/null
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -0,0 +1,120 @@
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
+/* \file ssi_aead.h
+   ARM CryptoCell AEAD Crypto API
+ */
+
+#ifndef __SSI_AEAD_H__
+#define __SSI_AEAD_H__
+
+#include <linux/kernel.h>
+#include <crypto/algapi.h>
+#include <crypto/ctr.h>
+
+
+/* mac_cmp - HW writes 8 B but all bytes hold the same value */
+#define ICV_CMP_SIZE 8
+#define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE*3)
+#define MAX_MAC_SIZE MAX(SHA256_DIGEST_SIZE, AES_BLOCK_SIZE)
+
+
+/* defines for AES GCM configuration buffer */
+#define GCM_BLOCK_LEN_SIZE 8
+
+#define GCM_BLOCK_RFC4_IV_OFFSET    	4  
+#define GCM_BLOCK_RFC4_IV_SIZE  	    8  /* IV size for rfc's */
+#define GCM_BLOCK_RFC4_NONCE_OFFSET 	0  
+#define GCM_BLOCK_RFC4_NONCE_SIZE   	4  
+
+
+
+/* Offsets into AES CCM configuration buffer */
+#define CCM_B0_OFFSET 0
+#define CCM_A0_OFFSET 16
+#define CCM_CTR_COUNT_0_OFFSET 32
+/* CCM B0 and CTR_COUNT constants. */
+#define CCM_BLOCK_NONCE_OFFSET 1  /* Nonce offset inside B0 and CTR_COUNT */
+#define CCM_BLOCK_NONCE_SIZE   3  /* Nonce size inside B0 and CTR_COUNT */
+#define CCM_BLOCK_IV_OFFSET    4  /* IV offset inside B0 and CTR_COUNT */
+#define CCM_BLOCK_IV_SIZE      8  /* IV size inside B0 and CTR_COUNT */
+
+enum aead_ccm_header_size {
+	ccm_header_size_null = -1,
+	ccm_header_size_zero = 0,
+	ccm_header_size_2 = 2,
+	ccm_header_size_6 = 6,
+	ccm_header_size_max = INT32_MAX
+};
+
+struct aead_req_ctx {
+	/* Allocate cache line although only 4 bytes are needed to
+	*  assure next field falls @ cache line 
+	*  Used for both: digest HW compare and CCM/GCM MAC value */
+	uint8_t mac_buf[MAX_MAC_SIZE] ____cacheline_aligned;
+	uint8_t ctr_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
+
+	//used in gcm 
+	uint8_t gcm_iv_inc1[AES_BLOCK_SIZE] ____cacheline_aligned;
+	uint8_t gcm_iv_inc2[AES_BLOCK_SIZE] ____cacheline_aligned;
+	uint8_t hkey[AES_BLOCK_SIZE] ____cacheline_aligned;
+	struct {
+		uint8_t lenA[GCM_BLOCK_LEN_SIZE] ____cacheline_aligned;
+		uint8_t lenC[GCM_BLOCK_LEN_SIZE] ;
+	} gcm_len_block;
+
+	uint8_t ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
+	unsigned int hw_iv_size ____cacheline_aligned; /*HW actual size input*/
+	uint8_t backup_mac[MAX_MAC_SIZE]; /*used to prevent cache coherence problem*/
+	uint8_t *backup_iv; /*store iv for generated IV flow*/
+	uint8_t *backup_giv; /*store iv for rfc3686(ctr) flow*/
+	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
+	dma_addr_t ccm_iv0_dma_addr; /* buffer for internal ccm configurations */
+	dma_addr_t icv_dma_addr; /* Phys. address of ICV */
+
+	//used in gcm 
+	dma_addr_t gcm_iv_inc1_dma_addr; /* buffer for internal gcm configurations */
+	dma_addr_t gcm_iv_inc2_dma_addr; /* buffer for internal gcm configurations */
+	dma_addr_t hkey_dma_addr; /* Phys. address of hkey */
+	dma_addr_t gcm_block_len_dma_addr; /* Phys. address of gcm block len */
+	bool is_gcm4543;
+
+	uint8_t *icv_virt_addr; /* Virt. address of ICV */
+	struct async_gen_req_ctx gen_ctx;
+	struct ssi_mlli assoc;
+	struct ssi_mlli src;
+	struct ssi_mlli dst;
+	struct scatterlist* srcSgl;
+	struct scatterlist* dstSgl;
+	unsigned int srcOffset;
+	unsigned int dstOffset;
+	enum ssi_req_dma_buf_type assoc_buff_type;
+	enum ssi_req_dma_buf_type data_buff_type;
+	struct mlli_params mlli_params;
+	unsigned int cryptlen;
+	struct scatterlist ccm_adata_sg;
+	enum aead_ccm_header_size ccm_hdr_size;
+	unsigned int req_authsize;
+	enum drv_cipher_mode cipher_mode;
+	bool is_icv_fragmented;
+	bool is_single_pass;
+	bool plaintext_authenticate_only; //for gcm_rfc4543
+};
+
+int ssi_aead_alloc(struct ssi_drvdata *drvdata);
+int ssi_aead_free(struct ssi_drvdata *drvdata);
+
+#endif /*__SSI_AEAD_H__*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 6ff5d6b..0140199 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -17,6 +17,7 @@
 #include <linux/crypto.h>
 #include <linux/version.h>
 #include <crypto/algapi.h>
+#include <crypto/internal/aead.h>
 #include <crypto/hash.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
@@ -30,6 +31,7 @@
 #include "cc_lli_defs.h"
 #include "ssi_cipher.h"
 #include "ssi_hash.h"
+#include "ssi_aead.h"
 
 #define LLI_MAX_NUM_OF_DATA_ENTRIES 128
 #define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
@@ -486,6 +488,42 @@ static int ssi_buffer_mgr_map_scatterlist(
 	return 0;
 }
 
+static inline int
+ssi_aead_handle_config_buf(struct device *dev,
+	struct aead_req_ctx *areq_ctx,
+	uint8_t* config_data,
+	struct buffer_array *sg_data,
+	unsigned int assoclen)
+{
+	SSI_LOG_DEBUG(" handle additional data config set to   DLLI \n");
+	/* create sg for the current buffer */
+	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
+	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1, 
+				DMA_TO_DEVICE) != 1)) {
+			SSI_LOG_ERR("dma_map_sg() "
+			   "config buffer failed\n");
+			return -ENOMEM;
+	}
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
+		     "page_link=0x%08lX addr=%pK "
+		     "offset=%u length=%u\n",
+		     (unsigned long long)sg_dma_address(&areq_ctx->ccm_adata_sg), 
+		     areq_ctx->ccm_adata_sg.page_link, 
+		     sg_virt(&areq_ctx->ccm_adata_sg),
+		     areq_ctx->ccm_adata_sg.offset, 
+		     areq_ctx->ccm_adata_sg.length);
+	/* prepare for case of MLLI */
+	if (assoclen > 0) {
+		ssi_buffer_mgr_add_scatterlist_entry(sg_data, 1, 
+						    &areq_ctx->ccm_adata_sg,
+						    (AES_BLOCK_SIZE + 
+						    areq_ctx->ccm_hdr_size), 0,
+						    false, NULL);
+	}
+	return 0;
+}
+
+
 static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 					   struct ahash_req_ctx *areq_ctx,
 					   uint8_t* curr_buff,
@@ -666,6 +704,867 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	return rc;
 }
 
+void ssi_buffer_mgr_unmap_aead_request(
+	struct device *dev, struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	uint32_t dummy;
+	bool chained;
+	uint32_t size_to_unmap = 0;
+
+	if (areq_ctx->mac_buf_dma_addr != 0) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->mac_buf_dma_addr);
+		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr, 
+			MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
+	}
+
+#if SSI_CC_HAS_AES_GCM
+	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		if (areq_ctx->hkey_dma_addr != 0) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->hkey_dma_addr);
+			dma_unmap_single(dev, areq_ctx->hkey_dma_addr,
+					 AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
+		}
+	
+		if (areq_ctx->gcm_block_len_dma_addr != 0) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_block_len_dma_addr);
+			dma_unmap_single(dev, areq_ctx->gcm_block_len_dma_addr,
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+	
+		if (areq_ctx->gcm_iv_inc1_dma_addr != 0) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc1_dma_addr);
+			dma_unmap_single(dev, areq_ctx->gcm_iv_inc1_dma_addr, 
+				AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+	
+		if (areq_ctx->gcm_iv_inc2_dma_addr != 0) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc2_dma_addr);
+			dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr, 
+				AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+	}
+#endif
+
+	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
+		if (areq_ctx->ccm_iv0_dma_addr != 0) {
+			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->ccm_iv0_dma_addr);
+			dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr, 
+				AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+
+		if (&areq_ctx->ccm_adata_sg != NULL)
+			dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg,
+				1, DMA_TO_DEVICE);
+	}
+	if (areq_ctx->gen_ctx.iv_dma_addr != 0) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gen_ctx.iv_dma_addr);
+		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
+				 hw_iv_size, DMA_BIDIRECTIONAL);
+	}
+
+	/*In case a pool was set, a table was 
+	  allocated and should be released */
+	if (areq_ctx->mlli_params.curr_pool != NULL) {
+		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%08llX virt=%pK\n", 
+			(unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
+			areq_ctx->mlli_params.mlli_virt_addr);
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->mlli_params.mlli_dma_addr);
+		dma_pool_free(areq_ctx->mlli_params.curr_pool,
+			      areq_ctx->mlli_params.mlli_virt_addr,
+			      areq_ctx->mlli_params.mlli_dma_addr);
+	}
+
+	SSI_LOG_DEBUG("Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n", sg_virt(req->src),areq_ctx->src.nents,areq_ctx->assoc.nents,req->assoclen,req->cryptlen);
+	SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(req->src));
+	size_to_unmap = req->assoclen+req->cryptlen;
+	if(areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT){
+		size_to_unmap += areq_ctx->req_authsize;
+	}
+	if (areq_ctx->is_gcm4543)
+		size_to_unmap += crypto_aead_ivsize(tfm);
+
+	dma_unmap_sg(dev, req->src, ssi_buffer_mgr_get_sgl_nents(req->src,size_to_unmap,&dummy,&chained) , DMA_BIDIRECTIONAL);
+	if (unlikely(req->src != req->dst)) {
+		SSI_LOG_DEBUG("Unmapping dst sgl: req->dst=%pK\n", 
+			sg_virt(req->dst));
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(req->dst));
+		dma_unmap_sg(dev, req->dst, ssi_buffer_mgr_get_sgl_nents(req->dst,size_to_unmap,&dummy,&chained),
+			DMA_BIDIRECTIONAL);
+	}
+#if DX_HAS_ACP
+	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+	    likely(req->src == req->dst))
+	{
+		uint32_t size_to_skip = req->assoclen;
+		if (areq_ctx->is_gcm4543) {
+			size_to_skip += crypto_aead_ivsize(tfm);
+		}
+		/* copy mac to a temporary location to deal with possible
+		  data memory overriding that caused by cache coherence problem. */
+		ssi_buffer_mgr_copy_scatterlist_portion(
+			areq_ctx->backup_mac, req->src,
+			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
+			size_to_skip+ req->cryptlen, SSI_SG_FROM_BUF);
+	}
+#endif
+}
+
+static inline int ssi_buffer_mgr_get_aead_icv_nents(
+	struct scatterlist *sgl,
+	unsigned int sgl_nents,
+	unsigned int authsize,
+	uint32_t last_entry_data_size,
+	bool *is_icv_fragmented)
+{
+	unsigned int icv_max_size = 0;
+	unsigned int icv_required_size = authsize > last_entry_data_size ? (authsize - last_entry_data_size) : authsize;
+	unsigned int nents;
+	unsigned int i;
+	
+	if (sgl_nents < MAX_ICV_NENTS_SUPPORTED) {
+		*is_icv_fragmented = false;
+		return 0;
+	}
+	
+	for( i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
+		if (sgl == NULL) {
+			break;
+		}
+		sgl = sg_next(sgl);
+	}
+
+	if (sgl != NULL) {
+		icv_max_size = sgl->length;
+	}
+
+	if (last_entry_data_size > authsize) {
+		nents = 0; /* ICV attached to data in last entry (not fragmented!) */
+		*is_icv_fragmented = false;
+	} else if (last_entry_data_size == authsize) {
+		nents = 1; /* ICV placed in whole last entry (not fragmented!) */
+		*is_icv_fragmented = false;
+	} else if (icv_max_size > icv_required_size) {
+		nents = 1;
+		*is_icv_fragmented = true;
+	} else if (icv_max_size == icv_required_size) {
+		nents = 2;
+		*is_icv_fragmented = true;
+	} else {
+		SSI_LOG_ERR("Unsupported num. of ICV fragments (> %d)\n",
+			MAX_ICV_NENTS_SUPPORTED);
+		nents = -1; /*unsupported*/
+	}
+	SSI_LOG_DEBUG("is_frag=%s icv_nents=%u\n",
+		(*is_icv_fragmented ? "true" : "false"), nents);
+
+	return nents;
+}
+
+static inline int ssi_buffer_mgr_aead_chain_iv(
+	struct ssi_drvdata *drvdata,
+	struct aead_request *req,
+	struct buffer_array *sg_data,
+	bool is_last, bool do_chain)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
+	struct device *dev = &drvdata->plat_dev->dev;
+	int rc = 0;
+
+	if (unlikely(req->iv == NULL)) {
+		areq_ctx->gen_ctx.iv_dma_addr = 0;
+		goto chain_iv_exit;
+	}
+
+	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
+		hw_iv_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
+		SSI_LOG_ERR("Mapping iv %u B at va=%pK for DMA failed\n",
+			hw_iv_size, req->iv);
+		rc = -ENOMEM;
+		goto chain_iv_exit; 
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gen_ctx.iv_dma_addr, hw_iv_size);
+
+	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
+		hw_iv_size, req->iv, 
+		(unsigned long long)areq_ctx->gen_ctx.iv_dma_addr);
+	if (do_chain == true && areq_ctx->plaintext_authenticate_only == true){  // TODO: what about CTR?? ask Ron
+		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
+		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
+		/* Chain to given list */
+		ssi_buffer_mgr_add_buffer_entry(
+			sg_data, areq_ctx->gen_ctx.iv_dma_addr + iv_ofs,
+			iv_size_to_authenc, is_last,
+			&areq_ctx->assoc.mlli_nents);
+		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
+	}
+
+chain_iv_exit:
+	return rc;
+}
+
+static inline int ssi_buffer_mgr_aead_chain_assoc(
+	struct ssi_drvdata *drvdata,
+	struct aead_request *req,
+	struct buffer_array *sg_data,
+	bool is_last, bool do_chain)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = 0;
+	uint32_t mapped_nents = 0;
+	struct scatterlist *current_sg = req->src;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned int sg_index = 0;
+	uint32_t size_of_assoc = req->assoclen;
+
+	if (areq_ctx->is_gcm4543) {
+		size_of_assoc += crypto_aead_ivsize(tfm);
+	}
+
+	if (sg_data == NULL) {
+		rc = -EINVAL;
+		goto chain_assoc_exit;
+	}
+
+	if (unlikely(req->assoclen == 0)) {
+		areq_ctx->assoc_buff_type = SSI_DMA_BUF_NULL;
+		areq_ctx->assoc.nents = 0;
+		areq_ctx->assoc.mlli_nents = 0;
+		SSI_LOG_DEBUG("Chain assoc of length 0: buff_type=%s nents=%u\n",
+			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			areq_ctx->assoc.nents);
+		goto chain_assoc_exit;
+	}
+
+	//iterate over the sgl to see how many entries are for associated data
+	//it is assumed that if we reach here , the sgl is already mapped
+	sg_index = current_sg->length;
+	if (sg_index > size_of_assoc) { //the first entry in the scatter list contains all the associated data
+		mapped_nents++;        
+	}
+	else{
+		while (sg_index <= size_of_assoc) {
+			current_sg = sg_next(current_sg);
+			//if have reached the end of the sgl, then this is unexpected
+			if (current_sg == NULL) {
+				SSI_LOG_ERR("reached end of sg list. unexpected \n");
+				BUG();
+			}
+			sg_index += current_sg->length;
+			mapped_nents++;
+		}
+	}
+	if (unlikely(mapped_nents > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
+		SSI_LOG_ERR("Too many fragments. current %d max %d\n",
+			    mapped_nents, LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
+		return -ENOMEM;
+	}
+	areq_ctx->assoc.nents = mapped_nents;
+
+	/* in CCM case we have additional entry for
+	*  ccm header configurations */
+	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
+		if (unlikely((mapped_nents + 1) >
+			LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
+
+			SSI_LOG_ERR("CCM case.Too many fragments. "
+				"Current %d max %d\n",
+				(areq_ctx->assoc.nents + 1),
+				LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
+			rc = -ENOMEM;
+			goto chain_assoc_exit;
+		}
+	}
+
+	if (likely(mapped_nents == 1) &&
+	    (areq_ctx->ccm_hdr_size == ccm_header_size_null))
+		areq_ctx->assoc_buff_type = SSI_DMA_BUF_DLLI;
+	else
+		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
+
+	if (unlikely((do_chain == true) ||
+		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
+
+		SSI_LOG_DEBUG("Chain assoc: buff_type=%s nents=%u\n",
+			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			areq_ctx->assoc.nents);
+		ssi_buffer_mgr_add_scatterlist_entry(
+			sg_data, areq_ctx->assoc.nents,
+			req->src, req->assoclen, 0, is_last,
+			&areq_ctx->assoc.mlli_nents);
+		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
+	}
+
+chain_assoc_exit:
+	return rc;
+}
+
+static inline void ssi_buffer_mgr_prepare_aead_data_dlli(
+	struct aead_request *req,
+	uint32_t *src_last_bytes, uint32_t *dst_last_bytes)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
+	unsigned int authsize = areq_ctx->req_authsize;
+
+	areq_ctx->is_icv_fragmented = false;
+	if (likely(req->src == req->dst)) {
+		/*INPLACE*/
+		areq_ctx->icv_dma_addr = sg_dma_address(
+			areq_ctx->srcSgl)+
+			(*src_last_bytes - authsize);
+		areq_ctx->icv_virt_addr = sg_virt(
+			areq_ctx->srcSgl) +
+			(*src_last_bytes - authsize);
+	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		/*NON-INPLACE and DECRYPT*/
+		areq_ctx->icv_dma_addr = sg_dma_address(
+			areq_ctx->srcSgl) +
+			(*src_last_bytes - authsize);
+		areq_ctx->icv_virt_addr = sg_virt(
+			areq_ctx->srcSgl) +
+			(*src_last_bytes - authsize);
+	} else {
+		/*NON-INPLACE and ENCRYPT*/
+		areq_ctx->icv_dma_addr = sg_dma_address(
+			areq_ctx->dstSgl) +
+			(*dst_last_bytes - authsize);
+		areq_ctx->icv_virt_addr = sg_virt(
+			areq_ctx->dstSgl)+
+			(*dst_last_bytes - authsize);
+	}
+}
+
+static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
+	struct ssi_drvdata *drvdata,
+	struct aead_request *req,
+	struct buffer_array *sg_data,
+	uint32_t *src_last_bytes, uint32_t *dst_last_bytes,
+	bool is_last_table)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
+	unsigned int authsize = areq_ctx->req_authsize;
+	int rc = 0, icv_nents;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	if (likely(req->src == req->dst)) {
+		/*INPLACE*/
+		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
+			areq_ctx->src.nents, areq_ctx->srcSgl,
+			areq_ctx->cryptlen,areq_ctx->srcOffset, is_last_table,
+			&areq_ctx->src.mlli_nents);
+
+		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
+			areq_ctx->src.nents, authsize, *src_last_bytes,
+			&areq_ctx->is_icv_fragmented);
+		if (unlikely(icv_nents < 0)) {
+			rc = -ENOTSUPP;
+			goto prepare_data_mlli_exit;
+		}
+
+		if (unlikely(areq_ctx->is_icv_fragmented == true)) {
+			/* Backup happens only when ICV is fragmented, ICV
+			   verification is made by CPU compare in order to simplify
+			   MAC verification upon request completion */
+			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+#if !DX_HAS_ACP
+				/* In ACP platform we already copying ICV
+				   for any INPLACE-DECRYPT operation, hence
+				   we must neglect this code. */
+				uint32_t size_to_skip = req->assoclen;
+				if (areq_ctx->is_gcm4543) {
+					size_to_skip += crypto_aead_ivsize(tfm);
+				}
+				ssi_buffer_mgr_copy_scatterlist_portion(
+					areq_ctx->backup_mac, req->src,
+					size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
+					size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
+#endif
+				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
+			} else {
+				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
+				areq_ctx->icv_dma_addr = areq_ctx->mac_buf_dma_addr;
+			}
+		} else { /* Contig. ICV */
+			/*Should hanlde if the sg is not contig.*/
+			areq_ctx->icv_dma_addr = sg_dma_address(
+				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				(*src_last_bytes - authsize);
+			areq_ctx->icv_virt_addr = sg_virt(
+				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) + 
+				(*src_last_bytes - authsize);
+		}
+
+	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		/*NON-INPLACE and DECRYPT*/
+		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
+			areq_ctx->src.nents, areq_ctx->srcSgl,
+			areq_ctx->cryptlen, areq_ctx->srcOffset,is_last_table,
+			&areq_ctx->src.mlli_nents);
+		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
+			areq_ctx->dst.nents, areq_ctx->dstSgl,
+			areq_ctx->cryptlen,areq_ctx->dstOffset, is_last_table,
+			&areq_ctx->dst.mlli_nents);
+
+		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
+			areq_ctx->src.nents, authsize, *src_last_bytes,
+			&areq_ctx->is_icv_fragmented);
+		if (unlikely(icv_nents < 0)) {
+			rc = -ENOTSUPP;
+			goto prepare_data_mlli_exit;
+		}
+
+		if (unlikely(areq_ctx->is_icv_fragmented == true)) {
+			/* Backup happens only when ICV is fragmented, ICV
+			   verification is made by CPU compare in order to simplify
+			   MAC verification upon request completion */
+			  uint32_t size_to_skip = req->assoclen;
+			  if (areq_ctx->is_gcm4543) {
+				  size_to_skip += crypto_aead_ivsize(tfm);
+			  }
+			  ssi_buffer_mgr_copy_scatterlist_portion(
+				  areq_ctx->backup_mac, req->src,
+				  size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
+				  size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
+			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
+		} else { /* Contig. ICV */
+			/*Should hanlde if the sg is not contig.*/
+			areq_ctx->icv_dma_addr = sg_dma_address(
+				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				(*src_last_bytes - authsize);
+			areq_ctx->icv_virt_addr = sg_virt(
+				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				(*src_last_bytes - authsize);
+		}
+
+	} else {
+		/*NON-INPLACE and ENCRYPT*/
+		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
+			areq_ctx->dst.nents, areq_ctx->dstSgl,
+			areq_ctx->cryptlen,areq_ctx->dstOffset, is_last_table,
+			&areq_ctx->dst.mlli_nents);
+		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
+			areq_ctx->src.nents, areq_ctx->srcSgl,
+			areq_ctx->cryptlen, areq_ctx->srcOffset,is_last_table,
+			&areq_ctx->src.mlli_nents);
+
+		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->dstSgl,
+			areq_ctx->dst.nents, authsize, *dst_last_bytes,
+			&areq_ctx->is_icv_fragmented);
+		if (unlikely(icv_nents < 0)) {
+			rc = -ENOTSUPP;
+			goto prepare_data_mlli_exit;
+		}
+
+		if (likely(areq_ctx->is_icv_fragmented == false)) {
+			/* Contig. ICV */
+			areq_ctx->icv_dma_addr = sg_dma_address(
+				&areq_ctx->dstSgl[areq_ctx->dst.nents - 1]) +
+				(*dst_last_bytes - authsize);
+			areq_ctx->icv_virt_addr = sg_virt(
+				&areq_ctx->dstSgl[areq_ctx->dst.nents - 1]) +
+				(*dst_last_bytes - authsize);
+		} else {
+			areq_ctx->icv_dma_addr = areq_ctx->mac_buf_dma_addr;
+			areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
+		}
+	}
+
+prepare_data_mlli_exit:
+	return rc;
+}
+
+static inline int ssi_buffer_mgr_aead_chain_data(
+	struct ssi_drvdata *drvdata,
+	struct aead_request *req,
+	struct buffer_array *sg_data,
+	bool is_last_table, bool do_chain)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct device *dev = &drvdata->plat_dev->dev;
+	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
+	unsigned int authsize = areq_ctx->req_authsize;
+	int src_last_bytes = 0, dst_last_bytes = 0;
+	int rc = 0;
+	uint32_t src_mapped_nents = 0, dst_mapped_nents = 0;
+	uint32_t offset = 0;
+	unsigned int size_for_map = req->assoclen +req->cryptlen; /*non-inplace mode*/
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	uint32_t sg_index = 0;
+	bool chained = false;
+	bool is_gcm4543 = areq_ctx->is_gcm4543;
+	uint32_t size_to_skip = req->assoclen;
+	if (is_gcm4543) {
+		size_to_skip += crypto_aead_ivsize(tfm);
+	}
+	offset = size_to_skip;
+
+	if (sg_data == NULL) {
+		rc = -EINVAL;
+		goto chain_data_exit;
+	}
+	areq_ctx->srcSgl = req->src;
+	areq_ctx->dstSgl = req->dst;
+
+	if (is_gcm4543) {
+		size_for_map += crypto_aead_ivsize(tfm);
+	}
+
+	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize:0;	
+	src_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->src,size_for_map,&src_last_bytes, &chained);  
+	sg_index = areq_ctx->srcSgl->length;
+	//check where the data starts
+	while (sg_index <= size_to_skip) {
+		offset -= areq_ctx->srcSgl->length;
+		areq_ctx->srcSgl = sg_next(areq_ctx->srcSgl);
+		//if have reached the end of the sgl, then this is unexpected
+		if (areq_ctx->srcSgl == NULL) {
+			SSI_LOG_ERR("reached end of sg list. unexpected \n");
+			BUG();
+		}
+		sg_index += areq_ctx->srcSgl->length;
+		src_mapped_nents--;
+	}
+	if (unlikely(src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES))
+	{
+		SSI_LOG_ERR("Too many fragments. current %d max %d\n",
+				src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
+			return -ENOMEM;
+	}
+
+	areq_ctx->src.nents = src_mapped_nents;
+
+	areq_ctx->srcOffset = offset;  
+
+	if (req->src != req->dst) {
+		size_for_map = req->assoclen +req->cryptlen;
+		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
+		if (is_gcm4543) {
+			size_for_map += crypto_aead_ivsize(tfm);
+		}
+
+		rc = ssi_buffer_mgr_map_scatterlist(dev, req->dst, size_for_map,
+			 DMA_BIDIRECTIONAL, &(areq_ctx->dst.nents),
+			 LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
+						   &dst_mapped_nents);
+		if (unlikely(rc != 0)) {
+			rc = -ENOMEM;
+			goto chain_data_exit; 
+		}
+	}
+
+	dst_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->dst,size_for_map,&dst_last_bytes, &chained);
+	sg_index = areq_ctx->dstSgl->length;
+	offset = size_to_skip;
+
+	//check where the data starts
+	while (sg_index <= size_to_skip) {
+
+		offset -= areq_ctx->dstSgl->length;
+		areq_ctx->dstSgl = sg_next(areq_ctx->dstSgl);
+		//if have reached the end of the sgl, then this is unexpected
+		if (areq_ctx->dstSgl == NULL) {
+			SSI_LOG_ERR("reached end of sg list. unexpected \n");
+			BUG();
+		}
+		sg_index += areq_ctx->dstSgl->length;
+		dst_mapped_nents--;
+	}
+	if (unlikely(dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES))
+	{
+		SSI_LOG_ERR("Too many fragments. current %d max %d\n",
+			    dst_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
+		return -ENOMEM;
+	}
+	areq_ctx->dst.nents = dst_mapped_nents;
+	areq_ctx->dstOffset = offset;
+	if ((src_mapped_nents > 1) ||
+	    (dst_mapped_nents  > 1) ||
+	    (do_chain == true)) {
+		areq_ctx->data_buff_type = SSI_DMA_BUF_MLLI;
+		rc = ssi_buffer_mgr_prepare_aead_data_mlli(drvdata, req, sg_data,
+			&src_last_bytes, &dst_last_bytes, is_last_table);
+	} else {
+		areq_ctx->data_buff_type = SSI_DMA_BUF_DLLI;
+		ssi_buffer_mgr_prepare_aead_data_dlli(
+				req, &src_last_bytes, &dst_last_bytes);
+	}
+
+chain_data_exit:
+	return rc;
+}
+
+static void ssi_buffer_mgr_update_aead_mlli_nents( struct ssi_drvdata *drvdata,
+					   struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	uint32_t curr_mlli_size = 0;
+	
+	if (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) {
+		areq_ctx->assoc.sram_addr = drvdata->mlli_sram_addr;
+		curr_mlli_size = areq_ctx->assoc.mlli_nents * 
+						LLI_ENTRY_BYTE_SIZE;
+	}
+
+	if (areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI) {
+		/*Inplace case dst nents equal to src nents*/
+		if (req->src == req->dst) {
+			areq_ctx->dst.mlli_nents = areq_ctx->src.mlli_nents;
+			areq_ctx->src.sram_addr = drvdata->mlli_sram_addr +
+								curr_mlli_size;
+			areq_ctx->dst.sram_addr = areq_ctx->src.sram_addr;
+			if (areq_ctx->is_single_pass == false)
+				areq_ctx->assoc.mlli_nents += 
+					areq_ctx->src.mlli_nents;
+		} else {
+			if (areq_ctx->gen_ctx.op_type == 
+					DRV_CRYPTO_DIRECTION_DECRYPT) {
+				areq_ctx->src.sram_addr = 
+						drvdata->mlli_sram_addr +
+								curr_mlli_size;
+				areq_ctx->dst.sram_addr = 
+						areq_ctx->src.sram_addr + 
+						areq_ctx->src.mlli_nents * 
+						LLI_ENTRY_BYTE_SIZE;
+				if (areq_ctx->is_single_pass == false)
+					areq_ctx->assoc.mlli_nents += 
+						areq_ctx->src.mlli_nents;
+			} else {
+				areq_ctx->dst.sram_addr = 
+						drvdata->mlli_sram_addr +
+								curr_mlli_size;
+				areq_ctx->src.sram_addr = 
+						areq_ctx->dst.sram_addr +
+						areq_ctx->dst.mlli_nents * 
+						LLI_ENTRY_BYTE_SIZE;
+				if (areq_ctx->is_single_pass == false)
+					areq_ctx->assoc.mlli_nents += 
+						areq_ctx->dst.mlli_nents;
+			}
+		}
+	}
+}
+
+int ssi_buffer_mgr_map_aead_request(
+	struct ssi_drvdata *drvdata, struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
+	struct device *dev = &drvdata->plat_dev->dev;
+	struct buffer_array sg_data;
+	unsigned int authsize = areq_ctx->req_authsize;
+	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
+	int rc = 0;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	bool is_gcm4543 = areq_ctx->is_gcm4543;
+
+	uint32_t mapped_nents = 0;
+	uint32_t dummy = 0; /*used for the assoc data fragments */
+	uint32_t size_to_map = 0;
+
+	mlli_params->curr_pool = NULL;
+	sg_data.num_of_buffers = 0;
+
+#if DX_HAS_ACP
+	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+	    likely(req->src == req->dst))
+	{
+		uint32_t size_to_skip = req->assoclen;
+		if (is_gcm4543) {
+			size_to_skip += crypto_aead_ivsize(tfm);
+		}
+		/* copy mac to a temporary location to deal with possible
+		   data memory overriding that caused by cache coherence problem. */
+		ssi_buffer_mgr_copy_scatterlist_portion(
+			areq_ctx->backup_mac, req->src,
+			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
+			size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
+	}
+#endif
+
+	/* cacluate the size for cipher remove ICV in decrypt*/
+	areq_ctx->cryptlen = (areq_ctx->gen_ctx.op_type == 
+				 DRV_CRYPTO_DIRECTION_ENCRYPT) ? 
+				req->cryptlen :
+				(req->cryptlen - authsize);
+
+	areq_ctx->mac_buf_dma_addr = dma_map_single(dev,
+		areq_ctx->mac_buf, MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, areq_ctx->mac_buf_dma_addr))) {
+		SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK for DMA failed\n",
+			MAX_MAC_SIZE, areq_ctx->mac_buf);
+		rc = -ENOMEM;
+		goto aead_map_failure;
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->mac_buf_dma_addr, MAX_MAC_SIZE);
+
+	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
+		areq_ctx->ccm_iv0_dma_addr = dma_map_single(dev,
+			(areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET),
+			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
+			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK "
+			"for DMA failed\n", AES_BLOCK_SIZE,
+			(areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET));
+			areq_ctx->ccm_iv0_dma_addr = 0;
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->ccm_iv0_dma_addr,
+								AES_BLOCK_SIZE);
+		if (ssi_aead_handle_config_buf(dev, areq_ctx,
+			areq_ctx->ccm_config, &sg_data, req->assoclen) != 0) {
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+	}
+
+#if SSI_CC_HAS_AES_GCM
+	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		areq_ctx->hkey_dma_addr = dma_map_single(dev,
+			areq_ctx->hkey, AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(dev, areq_ctx->hkey_dma_addr))) {
+			SSI_LOG_ERR("Mapping hkey %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, areq_ctx->hkey);
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->hkey_dma_addr, AES_BLOCK_SIZE);
+
+		areq_ctx->gcm_block_len_dma_addr = dma_map_single(dev,
+			&areq_ctx->gcm_len_block, AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_block_len_dma_addr))) {
+			SSI_LOG_ERR("Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_block_len_dma_addr, AES_BLOCK_SIZE);
+
+		areq_ctx->gcm_iv_inc1_dma_addr = dma_map_single(dev,
+			areq_ctx->gcm_iv_inc1,
+			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
+			SSI_LOG_ERR("Mapping gcm_iv_inc1 %u B at va=%pK "
+			"for DMA failed\n", AES_BLOCK_SIZE,
+			(areq_ctx->gcm_iv_inc1));
+			areq_ctx->gcm_iv_inc1_dma_addr = 0;
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc1_dma_addr,
+								AES_BLOCK_SIZE);
+
+		areq_ctx->gcm_iv_inc2_dma_addr = dma_map_single(dev,
+			areq_ctx->gcm_iv_inc2,
+			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
+			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK "
+			"for DMA failed\n", AES_BLOCK_SIZE,
+			(areq_ctx->gcm_iv_inc2));
+			areq_ctx->gcm_iv_inc2_dma_addr = 0;
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc2_dma_addr,
+								AES_BLOCK_SIZE);
+	}
+#endif /*SSI_CC_HAS_AES_GCM*/
+
+	size_to_map = req->cryptlen + req->assoclen;
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		size_to_map += authsize;
+	}
+	if (is_gcm4543)
+		size_to_map += crypto_aead_ivsize(tfm);
+	rc = ssi_buffer_mgr_map_scatterlist(dev, req->src,
+					    size_to_map, DMA_BIDIRECTIONAL, &(areq_ctx->src.nents),
+					    LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES+LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
+	if (unlikely(rc != 0)) {
+		rc = -ENOMEM;
+		goto aead_map_failure; 
+	}
+
+	if (likely(areq_ctx->is_single_pass == true)) {
+		/*
+		* Create MLLI table for: 
+		*   (1) Assoc. data
+		*   (2) Src/Dst SGLs
+		*   Note: IV is contg. buffer (not an SGL) 
+		*/
+		rc = ssi_buffer_mgr_aead_chain_assoc(drvdata, req, &sg_data, true, false);
+		if (unlikely(rc != 0))
+			goto aead_map_failure;
+		rc = ssi_buffer_mgr_aead_chain_iv(drvdata, req, &sg_data, true, false);
+		if (unlikely(rc != 0))
+			goto aead_map_failure;
+		rc = ssi_buffer_mgr_aead_chain_data(drvdata, req, &sg_data, true, false);
+		if (unlikely(rc != 0))
+			goto aead_map_failure;
+	} else { /* DOUBLE-PASS flow */
+		/*
+		* Prepare MLLI table(s) in this order:
+		*  
+		* If ENCRYPT/DECRYPT (inplace):
+		*   (1) MLLI table for assoc
+		*   (2) IV entry (chained right after end of assoc)
+		*   (3) MLLI for src/dst (inplace operation)
+		*  
+		* If ENCRYPT (non-inplace) 
+		*   (1) MLLI table for assoc
+		*   (2) IV entry (chained right after end of assoc)
+		*   (3) MLLI for dst
+		*   (4) MLLI for src
+		*  
+		* If DECRYPT (non-inplace) 
+		*   (1) MLLI table for assoc
+		*   (2) IV entry (chained right after end of assoc)
+		*   (3) MLLI for src
+		*   (4) MLLI for dst
+		*/
+		rc = ssi_buffer_mgr_aead_chain_assoc(drvdata, req, &sg_data, false, true);
+		if (unlikely(rc != 0))
+			goto aead_map_failure;
+		rc = ssi_buffer_mgr_aead_chain_iv(drvdata, req, &sg_data, false, true);
+		if (unlikely(rc != 0))
+			goto aead_map_failure;
+		rc = ssi_buffer_mgr_aead_chain_data(drvdata, req, &sg_data, true, true);
+		if (unlikely(rc != 0))
+			goto aead_map_failure;
+	}
+
+	/* Mlli support -start building the MLLI according to the above results */
+	if (unlikely(
+		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
+		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
+
+		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
+		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
+		if (unlikely(rc != 0)) {
+			goto aead_map_failure;
+		}
+
+		ssi_buffer_mgr_update_aead_mlli_nents(drvdata, req);
+		SSI_LOG_DEBUG("assoc params mn %d\n",areq_ctx->assoc.mlli_nents);
+		SSI_LOG_DEBUG("src params mn %d\n",areq_ctx->src.mlli_nents);
+		SSI_LOG_DEBUG("dst params mn %d\n",areq_ctx->dst.mlli_nents);
+	}
+	return 0;
+
+aead_map_failure:
+	ssi_buffer_mgr_unmap_aead_request(dev, req);
+	return rc;
+}
+
 int ssi_buffer_mgr_map_hash_request_final(
 	struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update)
 {
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 41412b2..5f4b032 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -71,6 +71,10 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 	struct scatterlist *src,
 	struct scatterlist *dst);
 
+int ssi_buffer_mgr_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req);
+
+void ssi_buffer_mgr_unmap_aead_request(struct device *dev, struct aead_request *req);
+
 int ssi_buffer_mgr_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update);
 
 int ssi_buffer_mgr_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, unsigned int block_size);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index ac1b61b..45d90c4 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -21,6 +21,7 @@
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
+#include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/skcipher.h>
@@ -63,6 +64,7 @@
 #include "ssi_buffer_mgr.h"
 #include "ssi_sysfs.h"
 #include "ssi_cipher.h"
+#include "ssi_aead.h"
 #include "ssi_hash.h"
 #include "ssi_ivgen.h"
 #include "ssi_sram_mgr.h"
@@ -362,18 +364,26 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 
+	/* hash must be allocated before aead since hash exports APIs */
 	rc = ssi_hash_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_hash_alloc failed\n");
 		goto init_cc_res_err;
 	}
 
+	rc = ssi_aead_alloc(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("ssi_aead_alloc failed\n");
+		goto init_cc_res_err;
+	}
+
 	return 0;
 
 init_cc_res_err:
 	SSI_LOG_ERR("Freeing CC HW resources!\n");
 	
 	if (new_drvdata != NULL) {
+		ssi_aead_free(new_drvdata);
 		ssi_hash_free(new_drvdata);
 		ssi_ablkcipher_free(new_drvdata);
 		ssi_ivgen_fini(new_drvdata);
@@ -416,6 +426,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	struct ssi_drvdata *drvdata =
 		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
 
+        ssi_aead_free(drvdata);
         ssi_hash_free(drvdata);
         ssi_ablkcipher_free(drvdata);
 	ssi_ivgen_fini(drvdata);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index a5a2427..06e685e 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -32,6 +32,7 @@
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
+#include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/hash.h>
 #include <linux/version.h>
@@ -148,6 +149,7 @@ struct ssi_drvdata {
 	struct completion icache_setup_completion;
 	void *buff_mgr_handle;
 	void *hash_handle;
+	void *aead_handle;
 	void *blkcipher_handle;
 	void *request_mgr_handle;
 	void *ivgen_handle;
@@ -167,6 +169,7 @@ struct ssi_crypto_alg {
 	int auth_mode;
 	struct ssi_drvdata *drvdata;
 	struct crypto_alg crypto_alg;
+	struct aead_alg aead_alg;
 };
 
 struct ssi_alg_template {
@@ -176,6 +179,7 @@ struct ssi_alg_template {
 	u32 type;
 	union {
 		struct ablkcipher_alg ablkcipher;
+		struct aead_alg aead;
 		struct blkcipher_alg blkcipher;
 		struct cipher_alg cipher;
 		struct compress_alg compress;
-- 
2.1.4
