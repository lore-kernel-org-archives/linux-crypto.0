From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 24/27] staging: ccree: use a consistent file naming convention
Date: Sun,  7 Jan 2018 12:14:35 +0000
Message-ID: <1515327285-8948-25-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:57636 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753703AbeAGMTq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Jan 2018 07:19:46 -0500
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccree driver source files were using an inconsistent
naming convention stemming from what the company was called
when they were added.

Move to a single consistent naming convention for better
code readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Makefile           |    6 +-
 drivers/staging/ccree/cc_aead.c          | 2709 ++++++++++++++++++++++++++++++
 drivers/staging/ccree/cc_aead.h          |  109 ++
 drivers/staging/ccree/cc_buffer_mgr.c    | 1657 ++++++++++++++++++
 drivers/staging/ccree/cc_buffer_mgr.h    |   74 +
 drivers/staging/ccree/cc_cipher.c        | 1171 +++++++++++++
 drivers/staging/ccree/cc_cipher.h        |   74 +
 drivers/staging/ccree/cc_debugfs.c       |    2 +-
 drivers/staging/ccree/cc_driver.c        |  508 ++++++
 drivers/staging/ccree/cc_driver.h        |  194 +++
 drivers/staging/ccree/cc_fips.c          |  112 ++
 drivers/staging/ccree/cc_fips.h          |   37 +
 drivers/staging/ccree/cc_hash.c          | 2299 +++++++++++++++++++++++++
 drivers/staging/ccree/cc_hash.h          |  114 ++
 drivers/staging/ccree/cc_host_regs.h     |  142 ++
 drivers/staging/ccree/cc_hw_queue_defs.h |    2 +-
 drivers/staging/ccree/cc_ivgen.c         |  281 ++++
 drivers/staging/ccree/cc_ivgen.h         |   55 +
 drivers/staging/ccree/cc_kernel_regs.h   |  167 ++
 drivers/staging/ccree/cc_pm.c            |  125 ++
 drivers/staging/ccree/cc_pm.h            |   57 +
 drivers/staging/ccree/cc_request_mgr.c   |  719 ++++++++
 drivers/staging/ccree/cc_request_mgr.h   |   51 +
 drivers/staging/ccree/cc_sram_mgr.c      |  107 ++
 drivers/staging/ccree/cc_sram_mgr.h      |   65 +
 drivers/staging/ccree/dx_crys_kernel.h   |  167 --
 drivers/staging/ccree/dx_host.h          |  142 --
 drivers/staging/ccree/ssi_aead.c         | 2709 ------------------------------
 drivers/staging/ccree/ssi_aead.h         |  109 --
 drivers/staging/ccree/ssi_buffer_mgr.c   | 1657 ------------------
 drivers/staging/ccree/ssi_buffer_mgr.h   |   74 -
 drivers/staging/ccree/ssi_cipher.c       | 1171 -------------
 drivers/staging/ccree/ssi_cipher.h       |   74 -
 drivers/staging/ccree/ssi_driver.c       |  508 ------
 drivers/staging/ccree/ssi_driver.h       |  194 ---
 drivers/staging/ccree/ssi_fips.c         |  112 --
 drivers/staging/ccree/ssi_fips.h         |   37 -
 drivers/staging/ccree/ssi_hash.c         | 2299 -------------------------
 drivers/staging/ccree/ssi_hash.h         |  114 --
 drivers/staging/ccree/ssi_ivgen.c        |  281 ----
 drivers/staging/ccree/ssi_ivgen.h        |   55 -
 drivers/staging/ccree/ssi_pm.c           |  125 --
 drivers/staging/ccree/ssi_pm.h           |   57 -
 drivers/staging/ccree/ssi_request_mgr.c  |  719 --------
 drivers/staging/ccree/ssi_request_mgr.h  |   51 -
 drivers/staging/ccree/ssi_sram_mgr.c     |  107 --
 drivers/staging/ccree/ssi_sram_mgr.h     |   65 -
 47 files changed, 10832 insertions(+), 10832 deletions(-)
 create mode 100644 drivers/staging/ccree/cc_aead.c
 create mode 100644 drivers/staging/ccree/cc_aead.h
 create mode 100644 drivers/staging/ccree/cc_buffer_mgr.c
 create mode 100644 drivers/staging/ccree/cc_buffer_mgr.h
 create mode 100644 drivers/staging/ccree/cc_cipher.c
 create mode 100644 drivers/staging/ccree/cc_cipher.h
 create mode 100644 drivers/staging/ccree/cc_driver.c
 create mode 100644 drivers/staging/ccree/cc_driver.h
 create mode 100644 drivers/staging/ccree/cc_fips.c
 create mode 100644 drivers/staging/ccree/cc_fips.h
 create mode 100644 drivers/staging/ccree/cc_hash.c
 create mode 100644 drivers/staging/ccree/cc_hash.h
 create mode 100644 drivers/staging/ccree/cc_host_regs.h
 create mode 100644 drivers/staging/ccree/cc_ivgen.c
 create mode 100644 drivers/staging/ccree/cc_ivgen.h
 create mode 100644 drivers/staging/ccree/cc_kernel_regs.h
 create mode 100644 drivers/staging/ccree/cc_pm.c
 create mode 100644 drivers/staging/ccree/cc_pm.h
 create mode 100644 drivers/staging/ccree/cc_request_mgr.c
 create mode 100644 drivers/staging/ccree/cc_request_mgr.h
 create mode 100644 drivers/staging/ccree/cc_sram_mgr.c
 create mode 100644 drivers/staging/ccree/cc_sram_mgr.h
 delete mode 100644 drivers/staging/ccree/dx_crys_kernel.h
 delete mode 100644 drivers/staging/ccree/dx_host.h
 delete mode 100644 drivers/staging/ccree/ssi_aead.c
 delete mode 100644 drivers/staging/ccree/ssi_aead.h
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_cipher.c
 delete mode 100644 drivers/staging/ccree/ssi_cipher.h
 delete mode 100644 drivers/staging/ccree/ssi_driver.c
 delete mode 100644 drivers/staging/ccree/ssi_driver.h
 delete mode 100644 drivers/staging/ccree/ssi_fips.c
 delete mode 100644 drivers/staging/ccree/ssi_fips.h
 delete mode 100644 drivers/staging/ccree/ssi_hash.c
 delete mode 100644 drivers/staging/ccree/ssi_hash.h
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.c
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.h
 delete mode 100644 drivers/staging/ccree/ssi_pm.c
 delete mode 100644 drivers/staging/ccree/ssi_pm.h
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.h

diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index c107e25..bdc2797 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o
-ccree-$(CONFIG_CRYPTO_FIPS) += ssi_fips.o
+ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_cipher.o cc_hash.o cc_aead.o cc_ivgen.o cc_sram_mgr.o
+ccree-$(CONFIG_CRYPTO_FIPS) += cc_fips.o
 ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
-ccree-$(CONFIG_PM) += ssi_pm.o
+ccree-$(CONFIG_PM) += cc_pm.o
diff --git a/drivers/staging/ccree/cc_aead.c b/drivers/staging/ccree/cc_aead.c
new file mode 100644
index 0000000..da74423
--- /dev/null
+++ b/drivers/staging/ccree/cc_aead.c
@@ -0,0 +1,2709 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
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
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_aead.h"
+#include "cc_request_mgr.h"
+#include "cc_hash.h"
+#include "cc_sram_mgr.h"
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
+/* Value of each ICV_CMP byte (of 8) in case of success */
+#define ICV_VERIF_OK 0x01
+
+struct cc_aead_handle {
+	cc_sram_addr_t sram_workspace_addr;
+	struct list_head aead_list;
+};
+
+struct cc_hmac_s {
+	u8 *padded_authkey;
+	u8 *ipad_opad; /* IPAD, OPAD*/
+	dma_addr_t padded_authkey_dma_addr;
+	dma_addr_t ipad_opad_dma_addr;
+};
+
+struct cc_xcbc_s {
+	u8 *xcbc_keys; /* K1,K2,K3 */
+	dma_addr_t xcbc_keys_dma_addr;
+};
+
+struct cc_aead_ctx {
+	struct cc_drvdata *drvdata;
+	u8 ctr_nonce[MAX_NONCE_SIZE]; /* used for ctr3686 iv and aes ccm */
+	u8 *enckey;
+	dma_addr_t enckey_dma_addr;
+	union {
+		struct cc_hmac_s hmac;
+		struct cc_xcbc_s xcbc;
+	} auth_state;
+	unsigned int enc_keylen;
+	unsigned int auth_keylen;
+	unsigned int authsize; /* Actual (reduced?) size of the MAC/ICv */
+	enum drv_cipher_mode cipher_mode;
+	enum cc_flow_mode flow_mode;
+	enum drv_hash_mode auth_mode;
+};
+
+static inline bool valid_assoclen(struct aead_request *req)
+{
+	return ((req->assoclen == 16) || (req->assoclen == 20));
+}
+
+static void cc_aead_exit(struct crypto_aead *tfm)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "Clearing context @%p for %s\n", crypto_aead_ctx(tfm),
+		crypto_tfm_alg_name(&tfm->base));
+
+	/* Unmap enckey buffer */
+	if (ctx->enckey) {
+		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey,
+				  ctx->enckey_dma_addr);
+		dev_dbg(dev, "Freed enckey DMA buffer enckey_dma_addr=%pad\n",
+			&ctx->enckey_dma_addr);
+		ctx->enckey_dma_addr = 0;
+		ctx->enckey = NULL;
+	}
+
+	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
+		struct cc_xcbc_s *xcbc = &ctx->auth_state.xcbc;
+
+		if (xcbc->xcbc_keys) {
+			dma_free_coherent(dev, CC_AES_128_BIT_KEY_SIZE * 3,
+					  xcbc->xcbc_keys,
+					  xcbc->xcbc_keys_dma_addr);
+		}
+		dev_dbg(dev, "Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
+			&xcbc->xcbc_keys_dma_addr);
+		xcbc->xcbc_keys_dma_addr = 0;
+		xcbc->xcbc_keys = NULL;
+	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
+		struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
+
+		if (hmac->ipad_opad) {
+			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
+					  hmac->ipad_opad,
+					  hmac->ipad_opad_dma_addr);
+			dev_dbg(dev, "Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
+				&hmac->ipad_opad_dma_addr);
+			hmac->ipad_opad_dma_addr = 0;
+			hmac->ipad_opad = NULL;
+		}
+		if (hmac->padded_authkey) {
+			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
+					  hmac->padded_authkey,
+					  hmac->padded_authkey_dma_addr);
+			dev_dbg(dev, "Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
+				&hmac->padded_authkey_dma_addr);
+			hmac->padded_authkey_dma_addr = 0;
+			hmac->padded_authkey = NULL;
+		}
+	}
+}
+
+static int cc_aead_init(struct crypto_aead *tfm)
+{
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_crypto_alg *cc_alg =
+			container_of(alg, struct cc_crypto_alg, aead_alg);
+	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
+
+	dev_dbg(dev, "Initializing context @%p for %s\n", ctx,
+		crypto_tfm_alg_name(&tfm->base));
+
+	/* Initialize modes in instance */
+	ctx->cipher_mode = cc_alg->cipher_mode;
+	ctx->flow_mode = cc_alg->flow_mode;
+	ctx->auth_mode = cc_alg->auth_mode;
+	ctx->drvdata = cc_alg->drvdata;
+	crypto_aead_set_reqsize(tfm, sizeof(struct aead_req_ctx));
+
+	/* Allocate key buffer, cache line aligned */
+	ctx->enckey = dma_alloc_coherent(dev, AES_MAX_KEY_SIZE,
+					 &ctx->enckey_dma_addr, GFP_KERNEL);
+	if (!ctx->enckey) {
+		dev_err(dev, "Failed allocating key buffer\n");
+		goto init_failed;
+	}
+	dev_dbg(dev, "Allocated enckey buffer in context ctx->enckey=@%p\n",
+		ctx->enckey);
+
+	/* Set default authlen value */
+
+	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
+		struct cc_xcbc_s *xcbc = &ctx->auth_state.xcbc;
+		const unsigned int key_size = CC_AES_128_BIT_KEY_SIZE * 3;
+
+		/* Allocate dma-coherent buffer for XCBC's K1+K2+K3 */
+		/* (and temporary for user key - up to 256b) */
+		xcbc->xcbc_keys = dma_alloc_coherent(dev, key_size,
+						     &xcbc->xcbc_keys_dma_addr,
+						     GFP_KERNEL);
+		if (!xcbc->xcbc_keys) {
+			dev_err(dev, "Failed allocating buffer for XCBC keys\n");
+			goto init_failed;
+		}
+	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC authentication */
+		struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
+		const unsigned int digest_size = 2 * MAX_HMAC_DIGEST_SIZE;
+		dma_addr_t *pkey_dma = &hmac->padded_authkey_dma_addr;
+
+		/* Allocate dma-coherent buffer for IPAD + OPAD */
+		hmac->ipad_opad = dma_alloc_coherent(dev, digest_size,
+						     &hmac->ipad_opad_dma_addr,
+						     GFP_KERNEL);
+
+		if (!hmac->ipad_opad) {
+			dev_err(dev, "Failed allocating IPAD/OPAD buffer\n");
+			goto init_failed;
+		}
+
+		dev_dbg(dev, "Allocated authkey buffer in context ctx->authkey=@%p\n",
+			hmac->ipad_opad);
+
+		hmac->padded_authkey = dma_alloc_coherent(dev,
+							  MAX_HMAC_BLOCK_SIZE,
+							  pkey_dma,
+							  GFP_KERNEL);
+
+		if (!hmac->padded_authkey) {
+			dev_err(dev, "failed to allocate padded_authkey\n");
+			goto init_failed;
+		}
+	} else {
+		ctx->auth_state.hmac.ipad_opad = NULL;
+		ctx->auth_state.hmac.padded_authkey = NULL;
+	}
+
+	return 0;
+
+init_failed:
+	cc_aead_exit(tfm);
+	return -ENOMEM;
+}
+
+static void cc_aead_complete(struct device *dev, void *cc_req, int err)
+{
+	struct aead_request *areq = (struct aead_request *)cc_req;
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(cc_req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	cc_unmap_aead_request(dev, areq);
+
+	/* Restore ordinary iv pointer */
+	areq->iv = areq_ctx->backup_iv;
+
+	if (err)
+		goto done;
+
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
+			   ctx->authsize) != 0) {
+			dev_dbg(dev, "Payload authentication failure, (auth-size=%d, cipher=%d)\n",
+				ctx->authsize, ctx->cipher_mode);
+			/* In case of payload authentication failure, MUST NOT
+			 * revealed the decrypted message --> zero its memory.
+			 */
+			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
+			err = -EBADMSG;
+		}
+	} else { /*ENCRYPT*/
+		if (areq_ctx->is_icv_fragmented) {
+			u32 skip = areq->cryptlen + areq_ctx->dst_offset;
+
+			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
+					   areq_ctx->dst_sgl, skip,
+					   (skip + ctx->authsize),
+					   CC_SG_FROM_BUF);
+		}
+
+		/* If an IV was generated, copy it back to the user provided
+		 * buffer.
+		 */
+		if (areq_ctx->backup_giv) {
+			if (ctx->cipher_mode == DRV_CIPHER_CTR)
+				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv +
+				       CTR_RFC3686_NONCE_SIZE,
+				       CTR_RFC3686_IV_SIZE);
+			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
+				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv +
+				       CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
+		}
+	}
+done:
+	aead_request_complete(areq, err);
+}
+
+static int xcbc_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
+{
+	/* Load the AES key */
+	hw_desc_init(&desc[0]);
+	/* We are using for the source/user key the same buffer
+	 * as for the output keys, * because after this key loading it
+	 * is not needed anymore
+	 */
+	set_din_type(&desc[0], DMA_DLLI,
+		     ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen,
+		     NS_BIT);
+	set_cipher_mode(&desc[0], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[0], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_key_size_aes(&desc[0], ctx->auth_keylen);
+	set_flow_mode(&desc[0], S_DIN_to_AES);
+	set_setup_mode(&desc[0], SETUP_LOAD_KEY0);
+
+	hw_desc_init(&desc[1]);
+	set_din_const(&desc[1], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[1], DIN_AES_DOUT);
+	set_dout_dlli(&desc[1], ctx->auth_state.xcbc.xcbc_keys_dma_addr,
+		      AES_KEYSIZE_128, NS_BIT, 0);
+
+	hw_desc_init(&desc[2]);
+	set_din_const(&desc[2], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[2], DIN_AES_DOUT);
+	set_dout_dlli(&desc[2], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
+					 + AES_KEYSIZE_128),
+			      AES_KEYSIZE_128, NS_BIT, 0);
+
+	hw_desc_init(&desc[3]);
+	set_din_const(&desc[3], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[3], DIN_AES_DOUT);
+	set_dout_dlli(&desc[3], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
+					  + 2 * AES_KEYSIZE_128),
+			      AES_KEYSIZE_128, NS_BIT, 0);
+
+	return 4;
+}
+
+static int hmac_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
+{
+	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
+	unsigned int digest_ofs = 0;
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+			DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
+			CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
+
+	int idx = 0;
+	int i;
+
+	/* calc derived HMAC key */
+	for (i = 0; i < 2; i++) {
+		/* Load hash initial state */
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_din_sram(&desc[idx],
+			     cc_larval_digest_addr(ctx->drvdata,
+						   ctx->auth_mode),
+			     digest_size);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+		idx++;
+
+		/* Load the hash current length*/
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+
+		/* Prepare ipad key */
+		hw_desc_init(&desc[idx]);
+		set_xor_val(&desc[idx], hmac_pad_const[i]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+		idx++;
+
+		/* Perform HASH update */
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     hmac->padded_authkey_dma_addr,
+			     SHA256_BLOCK_SIZE, NS_BIT);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_xor_active(&desc[idx]);
+		set_flow_mode(&desc[idx], DIN_HASH);
+		idx++;
+
+		/* Get the digset */
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_dout_dlli(&desc[idx],
+			      (hmac->ipad_opad_dma_addr + digest_ofs),
+			      digest_size, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+		idx++;
+
+		digest_ofs += digest_size;
+	}
+
+	return idx;
+}
+
+static int validate_keys_sizes(struct cc_aead_ctx *ctx)
+{
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "enc_keylen=%u  authkeylen=%u\n",
+		ctx->enc_keylen, ctx->auth_keylen);
+
+	switch (ctx->auth_mode) {
+	case DRV_HASH_SHA1:
+	case DRV_HASH_SHA256:
+		break;
+	case DRV_HASH_XCBC_MAC:
+		if (ctx->auth_keylen != AES_KEYSIZE_128 &&
+		    ctx->auth_keylen != AES_KEYSIZE_192 &&
+		    ctx->auth_keylen != AES_KEYSIZE_256)
+			return -ENOTSUPP;
+		break;
+	case DRV_HASH_NULL: /* Not authenc (e.g., CCM) - no auth_key) */
+		if (ctx->auth_keylen > 0)
+			return -EINVAL;
+		break;
+	default:
+		dev_err(dev, "Invalid auth_mode=%d\n", ctx->auth_mode);
+		return -EINVAL;
+	}
+	/* Check cipher key size */
+	if (ctx->flow_mode == S_DIN_to_DES) {
+		if (ctx->enc_keylen != DES3_EDE_KEY_SIZE) {
+			dev_err(dev, "Invalid cipher(3DES) key size: %u\n",
+				ctx->enc_keylen);
+			return -EINVAL;
+		}
+	} else { /* Default assumed to be AES ciphers */
+		if (ctx->enc_keylen != AES_KEYSIZE_128 &&
+		    ctx->enc_keylen != AES_KEYSIZE_192 &&
+		    ctx->enc_keylen != AES_KEYSIZE_256) {
+			dev_err(dev, "Invalid cipher(AES) key size: %u\n",
+				ctx->enc_keylen);
+			return -EINVAL;
+		}
+	}
+
+	return 0; /* All tests of keys sizes passed */
+}
+
+/* This function prepers the user key so it can pass to the hmac processing
+ * (copy to intenral buffer or hash in case of key longer than block
+ */
+static int
+cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+		      unsigned int keylen)
+{
+	dma_addr_t key_dma_addr = 0;
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	u32 larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->auth_mode);
+	struct cc_crypto_req cc_req = {};
+	unsigned int blocksize;
+	unsigned int digestsize;
+	unsigned int hashmode;
+	unsigned int idx = 0;
+	int rc = 0;
+	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
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
+	if (keylen != 0) {
+		key_dma_addr = dma_map_single(dev, (void *)key, keylen,
+					      DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, key_dma_addr)) {
+			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
+				key, keylen);
+			return -ENOMEM;
+		}
+		if (keylen > blocksize) {
+			/* Load hash initial state */
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hashmode);
+			set_din_sram(&desc[idx], larval_addr, digestsize);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+			idx++;
+
+			/* Load the hash current length*/
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hashmode);
+			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+			idx++;
+
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     key_dma_addr, keylen, NS_BIT);
+			set_flow_mode(&desc[idx], DIN_HASH);
+			idx++;
+
+			/* Get hashed key */
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hashmode);
+			set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
+				      digestsize, NS_BIT, 0);
+			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+			set_cipher_config0(&desc[idx],
+					   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+			idx++;
+
+			hw_desc_init(&desc[idx]);
+			set_din_const(&desc[idx], 0, (blocksize - digestsize));
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], (padded_authkey_dma_addr +
+				      digestsize), (blocksize - digestsize),
+				      NS_BIT, 0);
+			idx++;
+		} else {
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+				     keylen, NS_BIT);
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
+				      keylen, NS_BIT, 0);
+			idx++;
+
+			if ((blocksize - keylen) != 0) {
+				hw_desc_init(&desc[idx]);
+				set_din_const(&desc[idx], 0,
+					      (blocksize - keylen));
+				set_flow_mode(&desc[idx], BYPASS);
+				set_dout_dlli(&desc[idx],
+					      (padded_authkey_dma_addr +
+					       keylen),
+					      (blocksize - keylen), NS_BIT, 0);
+				idx++;
+			}
+		}
+	} else {
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0, (blocksize - keylen));
+		set_flow_mode(&desc[idx], BYPASS);
+		set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
+			      blocksize, NS_BIT, 0);
+		idx++;
+	}
+
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
+	if (rc)
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+
+	if (key_dma_addr)
+		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
+
+	return rc;
+}
+
+static int
+cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct rtattr *rta = (struct rtattr *)key;
+	struct cc_crypto_req cc_req = {};
+	struct crypto_authenc_key_param *param;
+	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
+	int seq_len = 0, rc = -EINVAL;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "Setting key in context @%p for %s. key=%p keylen=%u\n",
+		ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key, keylen);
+
+	/* STAT_PHASE_0: Init and sanity checks */
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
+			 *  first 4 bytes in CTR IV
+			 */
+			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen +
+			       ctx->enc_keylen - CTR_RFC3686_NONCE_SIZE,
+			       CTR_RFC3686_NONCE_SIZE);
+			/* Set CTR key size */
+			ctx->enc_keylen -= CTR_RFC3686_NONCE_SIZE;
+		}
+	} else { /* non-authenc - has just one key */
+		ctx->enc_keylen = keylen;
+		ctx->auth_keylen = 0;
+	}
+
+	rc = validate_keys_sizes(ctx);
+	if (rc)
+		goto badkey;
+
+	/* STAT_PHASE_1: Copy key to ctx */
+
+	/* Get key material */
+	memcpy(ctx->enckey, key + ctx->auth_keylen, ctx->enc_keylen);
+	if (ctx->enc_keylen == 24)
+		memset(ctx->enckey + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
+		memcpy(ctx->auth_state.xcbc.xcbc_keys, key, ctx->auth_keylen);
+	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC */
+		rc = cc_get_plain_hmac_key(tfm, key, ctx->auth_keylen);
+		if (rc)
+			goto badkey;
+	}
+
+	/* STAT_PHASE_2: Create sequence */
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
+		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
+		rc = -ENOTSUPP;
+		goto badkey;
+	}
+
+	/* STAT_PHASE_3: Submit sequence to HW */
+
+	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
+		rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, seq_len);
+		if (rc) {
+			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+			goto setkey_error;
+		}
+	}
+
+	/* Update STAT_PHASE_3 */
+	return rc;
+
+badkey:
+	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+setkey_error:
+	return rc;
+}
+
+static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (keylen < 3)
+		return -EINVAL;
+
+	keylen -= 3;
+	memcpy(ctx->ctr_nonce, key + keylen, 3);
+
+	return cc_aead_setkey(tfm, key, keylen);
+}
+
+static int cc_aead_setauthsize(struct crypto_aead *authenc,
+			       unsigned int authsize)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	/* Unsupported auth. sizes */
+	if (authsize == 0 ||
+	    authsize > crypto_aead_maxauthsize(authenc)) {
+		return -ENOTSUPP;
+	}
+
+	ctx->authsize = authsize;
+	dev_dbg(dev, "authlen=%d\n", ctx->authsize);
+
+	return 0;
+}
+
+static int cc_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
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
+	return cc_aead_setauthsize(authenc, authsize);
+}
+
+static int cc_ccm_setauthsize(struct crypto_aead *authenc,
+			      unsigned int authsize)
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
+	return cc_aead_setauthsize(authenc, authsize);
+}
+
+static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
+			      struct cc_hw_desc desc[], unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	enum cc_req_dma_buf_type assoc_dma_type = areq_ctx->assoc_buff_type;
+	unsigned int idx = *seq_size;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	switch (assoc_dma_type) {
+	case CC_DMA_BUF_DLLI:
+		dev_dbg(dev, "ASSOC buffer type DLLI\n");
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
+			     areq->assoclen, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
+		    areq_ctx->cryptlen > 0)
+			set_din_not_last_indication(&desc[idx]);
+		break;
+	case CC_DMA_BUF_MLLI:
+		dev_dbg(dev, "ASSOC buffer type MLLI\n");
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->assoc.sram_addr,
+			     areq_ctx->assoc.mlli_nents, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
+		    areq_ctx->cryptlen > 0)
+			set_din_not_last_indication(&desc[idx]);
+		break;
+	case CC_DMA_BUF_NULL:
+	default:
+		dev_err(dev, "Invalid ASSOC buffer type\n");
+	}
+
+	*seq_size = (++idx);
+}
+
+static void cc_proc_authen_desc(struct aead_request *areq,
+				unsigned int flow_mode,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size, int direct)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	enum cc_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
+	unsigned int idx = *seq_size;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	switch (data_dma_type) {
+	case CC_DMA_BUF_DLLI:
+	{
+		struct scatterlist *cipher =
+			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			areq_ctx->dst_sgl : areq_ctx->src_sgl;
+
+		unsigned int offset =
+			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			areq_ctx->dst_offset : areq_ctx->src_offset;
+		dev_dbg(dev, "AUTHENC: SRC/DST buffer type DLLI\n");
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (sg_dma_address(cipher) + offset),
+			     areq_ctx->cryptlen, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		break;
+	}
+	case CC_DMA_BUF_MLLI:
+	{
+		/* DOUBLE-PASS flow (as default)
+		 * assoc. + iv + data -compact in one table
+		 * if assoclen is ZERO only IV perform
+		 */
+		cc_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
+		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
+
+		if (areq_ctx->is_single_pass) {
+			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+				mlli_addr = areq_ctx->dst.sram_addr;
+				mlli_nents = areq_ctx->dst.mlli_nents;
+			} else {
+				mlli_addr = areq_ctx->src.sram_addr;
+				mlli_nents = areq_ctx->src.mlli_nents;
+			}
+		}
+
+		dev_dbg(dev, "AUTHENC: SRC/DST buffer type MLLI\n");
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI, mlli_addr, mlli_nents,
+			     NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		break;
+	}
+	case CC_DMA_BUF_NULL:
+	default:
+		dev_err(dev, "AUTHENC: Invalid SRC/DST buffer type\n");
+	}
+
+	*seq_size = (++idx);
+}
+
+static void cc_proc_cipher_desc(struct aead_request *areq,
+				unsigned int flow_mode,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
+	enum cc_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	if (areq_ctx->cryptlen == 0)
+		return; /*null processing*/
+
+	switch (data_dma_type) {
+	case CC_DMA_BUF_DLLI:
+		dev_dbg(dev, "CIPHER: SRC/DST buffer type DLLI\n");
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (sg_dma_address(areq_ctx->src_sgl) +
+			      areq_ctx->src_offset), areq_ctx->cryptlen,
+			      NS_BIT);
+		set_dout_dlli(&desc[idx],
+			      (sg_dma_address(areq_ctx->dst_sgl) +
+			       areq_ctx->dst_offset),
+			      areq_ctx->cryptlen, NS_BIT, 0);
+		set_flow_mode(&desc[idx], flow_mode);
+		break;
+	case CC_DMA_BUF_MLLI:
+		dev_dbg(dev, "CIPHER: SRC/DST buffer type MLLI\n");
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->src.sram_addr,
+			     areq_ctx->src.mlli_nents, NS_BIT);
+		set_dout_mlli(&desc[idx], areq_ctx->dst.sram_addr,
+			      areq_ctx->dst.mlli_nents, NS_BIT, 0);
+		set_flow_mode(&desc[idx], flow_mode);
+		break;
+	case CC_DMA_BUF_NULL:
+	default:
+		dev_err(dev, "CIPHER: Invalid SRC/DST buffer type\n");
+	}
+
+	*seq_size = (++idx);
+}
+
+static void cc_proc_digest_desc(struct aead_request *req,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	int direct = req_ctx->gen_ctx.op_type;
+
+	/* Get final ICV result */
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		hw_desc_init(&desc[idx]);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		set_dout_dlli(&desc[idx], req_ctx->icv_dma_addr, ctx->authsize,
+			      NS_BIT, 1);
+		set_queue_last_ind(&desc[idx]);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
+			set_aes_not_hash_mode(&desc[idx]);
+			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+		} else {
+			set_cipher_config0(&desc[idx],
+					   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+			set_cipher_mode(&desc[idx], hash_mode);
+		}
+	} else { /*Decrypt*/
+		/* Get ICV out from hardware */
+		hw_desc_init(&desc[idx]);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr,
+			      ctx->authsize, NS_BIT, 1);
+		set_queue_last_ind(&desc[idx]);
+		set_cipher_config0(&desc[idx],
+				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
+			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+			set_aes_not_hash_mode(&desc[idx]);
+		} else {
+			set_cipher_mode(&desc[idx], hash_mode);
+		}
+	}
+
+	*seq_size = (++idx);
+}
+
+static void cc_set_cipher_desc(struct aead_request *req,
+			       struct cc_hw_desc desc[],
+			       unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int hw_iv_size = req_ctx->hw_iv_size;
+	unsigned int idx = *seq_size;
+	int direct = req_ctx->gen_ctx.op_type;
+
+	/* Setup cipher state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_config0(&desc[idx], direct);
+	set_flow_mode(&desc[idx], ctx->flow_mode);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
+		     hw_iv_size, NS_BIT);
+	if (ctx->cipher_mode == DRV_CIPHER_CTR)
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	else
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], ctx->cipher_mode);
+	idx++;
+
+	/* Setup enc. key */
+	hw_desc_init(&desc[idx]);
+	set_cipher_config0(&desc[idx], direct);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], ctx->flow_mode);
+	if (ctx->flow_mode == S_DIN_to_AES) {
+		set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+			     ((ctx->enc_keylen == 24) ? CC_AES_KEY_SIZE_MAX :
+			      ctx->enc_keylen), NS_BIT);
+		set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	} else {
+		set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+			     ctx->enc_keylen, NS_BIT);
+		set_key_size_des(&desc[idx], ctx->enc_keylen);
+	}
+	set_cipher_mode(&desc[idx], ctx->cipher_mode);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static void cc_proc_cipher(struct aead_request *req, struct cc_hw_desc desc[],
+			   unsigned int *seq_size, unsigned int data_flow_mode)
+{
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	int direct = req_ctx->gen_ctx.op_type;
+	unsigned int idx = *seq_size;
+
+	if (req_ctx->cryptlen == 0)
+		return; /*null processing*/
+
+	cc_set_cipher_desc(req, desc, &idx);
+	cc_proc_cipher_desc(req, data_flow_mode, desc, &idx);
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		/* We must wait for DMA to write all cipher */
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
+		idx++;
+	}
+
+	*seq_size = idx;
+}
+
+static void cc_set_hmac_desc(struct aead_request *req, struct cc_hw_desc desc[],
+			     unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	unsigned int idx = *seq_size;
+
+	/* Loading hash ipad xor key state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     ctx->auth_state.hmac.ipad_opad_dma_addr, digest_size,
+		     NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load init. digest len (64 bytes) */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
+		     HASH_LEN_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static void cc_set_xcbc_desc(struct aead_request *req, struct cc_hw_desc desc[],
+			     unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int idx = *seq_size;
+
+	/* Loading MAC state */
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0, CC_AES_BLOCK_SIZE);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	/* Setup XCBC MAC K1 */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     ctx->auth_state.xcbc.xcbc_keys_dma_addr,
+		     AES_KEYSIZE_128, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	/* Setup XCBC MAC K2 */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
+		      AES_KEYSIZE_128), AES_KEYSIZE_128, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	/* Setup XCBC MAC K3 */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
+		      2 * AES_KEYSIZE_128), AES_KEYSIZE_128, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static void cc_proc_header_desc(struct aead_request *req,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	/* Hash associated data */
+	if (req->assoclen > 0)
+		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
+
+	/* Hash IV */
+	*seq_size = idx;
+}
+
+static void cc_proc_scheme_desc(struct aead_request *req,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_handle *aead_handle = ctx->drvdata->aead_handle;
+	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
+				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	unsigned int idx = *seq_size;
+
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
+		      HASH_LEN_SIZE);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+	set_cipher_do(&desc[idx], DO_PAD);
+	idx++;
+
+	/* Get final ICV result */
+	hw_desc_init(&desc[idx]);
+	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
+		      digest_size);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	set_cipher_mode(&desc[idx], hash_mode);
+	idx++;
+
+	/* Loading hash opad xor key state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->auth_state.hmac.ipad_opad_dma_addr + digest_size),
+		     digest_size, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load init. digest len (64 bytes) */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
+		     HASH_LEN_SIZE);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Perform HASH update */
+	hw_desc_init(&desc[idx]);
+	set_din_sram(&desc[idx], aead_handle->sram_workspace_addr,
+		     digest_size);
+	set_flow_mode(&desc[idx], DIN_HASH);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static void cc_mlli_to_sram(struct aead_request *req,
+			    struct cc_hw_desc desc[], unsigned int *seq_size)
+{
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	if (req_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
+	    req_ctx->data_buff_type == CC_DMA_BUF_MLLI ||
+	    !req_ctx->is_single_pass) {
+		dev_dbg(dev, "Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
+			(unsigned int)ctx->drvdata->mlli_sram_addr,
+			req_ctx->mlli_params.mlli_len);
+		/* Copy MLLI table host-to-sram */
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI,
+			     req_ctx->mlli_params.mlli_dma_addr,
+			     req_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[*seq_size],
+			      ctx->drvdata->mlli_sram_addr,
+			      req_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[*seq_size], BYPASS);
+		(*seq_size)++;
+	}
+}
+
+static enum cc_flow_mode cc_get_data_flow(enum drv_crypto_direction direct,
+					  enum cc_flow_mode setup_flow_mode,
+					  bool is_single_pass)
+{
+	enum cc_flow_mode data_flow_mode;
+
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		if (setup_flow_mode == S_DIN_to_AES)
+			data_flow_mode = is_single_pass ?
+				AES_to_HASH_and_DOUT : DIN_AES_DOUT;
+		else
+			data_flow_mode = is_single_pass ?
+				DES_to_HASH_and_DOUT : DIN_DES_DOUT;
+	} else { /* Decrypt */
+		if (setup_flow_mode == S_DIN_to_AES)
+			data_flow_mode = is_single_pass ?
+				AES_and_HASH : DIN_AES_DOUT;
+		else
+			data_flow_mode = is_single_pass ?
+				DES_and_HASH : DIN_DES_DOUT;
+	}
+
+	return data_flow_mode;
+}
+
+static void cc_hmac_authenc(struct aead_request *req, struct cc_hw_desc desc[],
+			    unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	int direct = req_ctx->gen_ctx.op_type;
+	unsigned int data_flow_mode =
+		cc_get_data_flow(direct, ctx->flow_mode,
+				 req_ctx->is_single_pass);
+
+	if (req_ctx->is_single_pass) {
+		/**
+		 * Single-pass flow
+		 */
+		cc_set_hmac_desc(req, desc, seq_size);
+		cc_set_cipher_desc(req, desc, seq_size);
+		cc_proc_header_desc(req, desc, seq_size);
+		cc_proc_cipher_desc(req, data_flow_mode, desc, seq_size);
+		cc_proc_scheme_desc(req, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
+		return;
+	}
+
+	/**
+	 * Double-pass flow
+	 * Fallback for unsupported single-pass modes,
+	 * i.e. using assoc. data of non-word-multiple
+	 */
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		/* encrypt first.. */
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
+		/* authenc after..*/
+		cc_set_hmac_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		cc_proc_scheme_desc(req, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
+
+	} else { /*DECRYPT*/
+		/* authenc first..*/
+		cc_set_hmac_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		cc_proc_scheme_desc(req, desc, seq_size);
+		/* decrypt after.. */
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
+		/* read the digest result with setting the completion bit
+		 * must be after the cipher operation
+		 */
+		cc_proc_digest_desc(req, desc, seq_size);
+	}
+}
+
+static void
+cc_xcbc_authenc(struct aead_request *req, struct cc_hw_desc desc[],
+		unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	int direct = req_ctx->gen_ctx.op_type;
+	unsigned int data_flow_mode =
+		cc_get_data_flow(direct, ctx->flow_mode,
+				 req_ctx->is_single_pass);
+
+	if (req_ctx->is_single_pass) {
+		/**
+		 * Single-pass flow
+		 */
+		cc_set_xcbc_desc(req, desc, seq_size);
+		cc_set_cipher_desc(req, desc, seq_size);
+		cc_proc_header_desc(req, desc, seq_size);
+		cc_proc_cipher_desc(req, data_flow_mode, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
+		return;
+	}
+
+	/**
+	 * Double-pass flow
+	 * Fallback for unsupported single-pass modes,
+	 * i.e. using assoc. data of non-word-multiple
+	 */
+	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+		/* encrypt first.. */
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
+		/* authenc after.. */
+		cc_set_xcbc_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		cc_proc_digest_desc(req, desc, seq_size);
+	} else { /*DECRYPT*/
+		/* authenc first.. */
+		cc_set_xcbc_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		/* decrypt after..*/
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
+		/* read the digest result with setting the completion bit
+		 * must be after the cipher operation
+		 */
+		cc_proc_digest_desc(req, desc, seq_size);
+	}
+}
+
+static int validate_data_size(struct cc_aead_ctx *ctx,
+			      enum drv_crypto_direction direct,
+			      struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	unsigned int assoclen = req->assoclen;
+	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
+			(req->cryptlen - ctx->authsize) : req->cryptlen;
+
+	if (direct == DRV_CRYPTO_DIRECTION_DECRYPT &&
+	    req->cryptlen < ctx->authsize)
+		goto data_size_err;
+
+	areq_ctx->is_single_pass = true; /*defaulted to fast flow*/
+
+	switch (ctx->flow_mode) {
+	case S_DIN_to_AES:
+		if (ctx->cipher_mode == DRV_CIPHER_CBC &&
+		    !IS_ALIGNED(cipherlen, AES_BLOCK_SIZE))
+			goto data_size_err;
+		if (ctx->cipher_mode == DRV_CIPHER_CCM)
+			break;
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
+			if (areq_ctx->plaintext_authenticate_only)
+				areq_ctx->is_single_pass = false;
+			break;
+		}
+
+		if (!IS_ALIGNED(assoclen, sizeof(u32)))
+			areq_ctx->is_single_pass = false;
+
+		if (ctx->cipher_mode == DRV_CIPHER_CTR &&
+		    !IS_ALIGNED(cipherlen, sizeof(u32)))
+			areq_ctx->is_single_pass = false;
+
+		break;
+	case S_DIN_to_DES:
+		if (!IS_ALIGNED(cipherlen, DES_BLOCK_SIZE))
+			goto data_size_err;
+		if (!IS_ALIGNED(assoclen, DES_BLOCK_SIZE))
+			areq_ctx->is_single_pass = false;
+		break;
+	default:
+		dev_err(dev, "Unexpected flow mode (%d)\n", ctx->flow_mode);
+		goto data_size_err;
+	}
+
+	return 0;
+
+data_size_err:
+	return -EINVAL;
+}
+
+static unsigned int format_ccm_a0(u8 *pa0_buff, u32 header_size)
+{
+	unsigned int len = 0;
+
+	if (header_size == 0)
+		return 0;
+
+	if (header_size < ((1UL << 16) - (1UL << 8))) {
+		len = 2;
+
+		pa0_buff[0] = (header_size >> 8) & 0xFF;
+		pa0_buff[1] = header_size & 0xFF;
+	} else {
+		len = 6;
+
+		pa0_buff[0] = 0xFF;
+		pa0_buff[1] = 0xFE;
+		pa0_buff[2] = (header_size >> 24) & 0xFF;
+		pa0_buff[3] = (header_size >> 16) & 0xFF;
+		pa0_buff[4] = (header_size >> 8) & 0xFF;
+		pa0_buff[5] = header_size & 0xFF;
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
+static int cc_ccm(struct aead_request *req, struct cc_hw_desc desc[],
+		  unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+	unsigned int cipher_flow_mode;
+	dma_addr_t mac_result;
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
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ((ctx->enc_keylen == 24) ?  CC_AES_KEY_SIZE_MAX :
+		      ctx->enc_keylen), NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load ctr state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     req_ctx->gen_ctx.iv_dma_addr, AES_BLOCK_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load MAC key */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ((ctx->enc_keylen == 24) ?  CC_AES_KEY_SIZE_MAX :
+		      ctx->enc_keylen), NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	/* load MAC state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	/* process assoc data */
+	if (req->assoclen > 0) {
+		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
+	} else {
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     sg_dma_address(&req_ctx->ccm_adata_sg),
+			     AES_BLOCK_SIZE + req_ctx->ccm_hdr_size, NS_BIT);
+		set_flow_mode(&desc[idx], DIN_HASH);
+		idx++;
+	}
+
+	/* process the cipher */
+	if (req_ctx->cryptlen)
+		cc_proc_cipher_desc(req, cipher_flow_mode, desc, &idx);
+
+	/* Read temporal MAC */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr, ctx->authsize,
+		      NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_aes_not_hash_mode(&desc[idx]);
+	idx++;
+
+	/* load AES-CTR state (for last MAC calculation)*/
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->ccm_iv0_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* encrypt the "T" value and store MAC in mac_state */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
+		     ctx->authsize, NS_BIT);
+	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	idx++;
+
+	*seq_size = idx;
+	return 0;
+}
+
+static int config_ccm_adata(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	//unsigned int size_of_a = 0, rem_a_size = 0;
+	unsigned int lp = req->iv[0];
+	/* Note: The code assume that req->iv[0] already contains the value
+	 * of L' of RFC3610
+	 */
+	unsigned int l = lp + 1;  /* This is L' of RFC 3610. */
+	unsigned int m = ctx->authsize;  /* This is M' of RFC 3610. */
+	u8 *b0 = req_ctx->ccm_config + CCM_B0_OFFSET;
+	u8 *a0 = req_ctx->ccm_config + CCM_A0_OFFSET;
+	u8 *ctr_count_0 = req_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
+	unsigned int cryptlen = (req_ctx->gen_ctx.op_type ==
+				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+				req->cryptlen :
+				(req->cryptlen - ctx->authsize);
+	int rc;
+
+	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
+	memset(req_ctx->ccm_config, 0, AES_BLOCK_SIZE * 3);
+
+	/* taken from crypto/ccm.c */
+	/* 2 <= L <= 8, so 1 <= L' <= 7. */
+	if (l < 2 || l > 8) {
+		dev_err(dev, "illegal iv value %X\n", req->iv[0]);
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
+	if (rc) {
+		dev_err(dev, "message len overflow detected");
+		return rc;
+	}
+	 /* END of "taken from crypto/ccm.c" */
+
+	/* l(a) - size of associated data. */
+	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req->assoclen);
+
+	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
+	req->iv[15] = 1;
+
+	memcpy(ctr_count_0, req->iv, AES_BLOCK_SIZE);
+	ctr_count_0[15] = 0;
+
+	return 0;
+}
+
+static void cc_proc_rfc4309_ccm(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+
+	/* L' */
+	memset(areq_ctx->ctr_iv, 0, AES_BLOCK_SIZE);
+	/* For RFC 4309, always use 4 bytes for message length
+	 * (at most 2^32-1 bytes).
+	 */
+	areq_ctx->ctr_iv[0] = 3;
+
+	/* In RFC 4309 there is an 11-bytes nonce+IV part,
+	 * that we build here.
+	 */
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce,
+	       CCM_BLOCK_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
+	       CCM_BLOCK_IV_SIZE);
+	req->iv = areq_ctx->ctr_iv;
+	req->assoclen -= CCM_BLOCK_IV_SIZE;
+}
+
+static void cc_set_ghash_desc(struct aead_request *req,
+			      struct cc_hw_desc desc[], unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+
+	/* load key to AES*/
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ctx->enc_keylen, NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* process one zero block to generate hkey */
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	set_dout_dlli(&desc[idx], req_ctx->hkey_dma_addr, AES_BLOCK_SIZE,
+		      NS_BIT, 0);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	idx++;
+
+	/* Memory Barrier */
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* Load GHASH subkey */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->hkey_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Configure Hash Engine to work with GHASH.
+	 * Since it was not possible to extend HASH submodes to add GHASH,
+	 * The following command is necessary in order to
+	 * select GHASH (according to HW designers)
+	 */
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_do(&desc[idx], 1); //1=AES_SK RKEK
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Load GHASH initial STATE (which is 0). (for any hash there is an
+	 * initial state)
+	 */
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static void cc_set_gctr_desc(struct aead_request *req, struct cc_hw_desc desc[],
+			     unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int idx = *seq_size;
+
+	/* load key to AES*/
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ctx->enc_keylen, NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	if (req_ctx->cryptlen && !req_ctx->plaintext_authenticate_only) {
+		/* load AES/CTR initial CTR value inc by 2*/
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+		set_key_size_aes(&desc[idx], ctx->enc_keylen);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     req_ctx->gcm_iv_inc2_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
+		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
+		idx++;
+	}
+
+	*seq_size = idx;
+}
+
+static void cc_proc_gcm_result(struct aead_request *req,
+			       struct cc_hw_desc desc[],
+			       unsigned int *seq_size)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
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
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gcm_block_len_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
+	idx++;
+
+	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr, AES_BLOCK_SIZE,
+		      NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_aes_not_hash_mode(&desc[idx]);
+
+	idx++;
+
+	/* load AES/CTR initial CTR value inc by 1*/
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gcm_iv_inc1_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Memory Barrier */
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* process GCTR on stored GHASH and store MAC in mac_state*/
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	idx++;
+
+	*seq_size = idx;
+}
+
+static int cc_gcm(struct aead_request *req, struct cc_hw_desc desc[],
+		  unsigned int *seq_size)
+{
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	unsigned int cipher_flow_mode;
+
+	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		cipher_flow_mode = AES_and_HASH;
+	} else { /* Encrypt */
+		cipher_flow_mode = AES_to_HASH_and_DOUT;
+	}
+
+	//in RFC4543 no data to encrypt. just copy data from src to dest.
+	if (req_ctx->plaintext_authenticate_only) {
+		cc_proc_cipher_desc(req, BYPASS, desc, seq_size);
+		cc_set_ghash_desc(req, desc, seq_size);
+		/* process(ghash) assoc data */
+		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
+		cc_set_gctr_desc(req, desc, seq_size);
+		cc_proc_gcm_result(req, desc, seq_size);
+		return 0;
+	}
+
+	// for gcm and rfc4106.
+	cc_set_ghash_desc(req, desc, seq_size);
+	/* process(ghash) assoc data */
+	if (req->assoclen > 0)
+		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
+	cc_set_gctr_desc(req, desc, seq_size);
+	/* process(gctr+ghash) */
+	if (req_ctx->cryptlen)
+		cc_proc_cipher_desc(req, cipher_flow_mode, desc, seq_size);
+	cc_proc_gcm_result(req, desc, seq_size);
+
+	return 0;
+}
+
+static int config_gcm_context(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	unsigned int cryptlen = (req_ctx->gen_ctx.op_type ==
+				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+				req->cryptlen :
+				(req->cryptlen - ctx->authsize);
+	__be32 counter = cpu_to_be32(2);
+
+	dev_dbg(dev, "%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n",
+		__func__, cryptlen, req->assoclen, ctx->authsize);
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
+	if (!req_ctx->plaintext_authenticate_only) {
+		__be64 temp64;
+
+		temp64 = cpu_to_be64(req->assoclen * 8);
+		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
+		temp64 = cpu_to_be64(cryptlen * 8);
+		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
+	} else {
+		/* rfc4543=>  all data(AAD,IV,Plain) are considered additional
+		 * data that is nothing is encrypted.
+		 */
+		__be64 temp64;
+
+		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE +
+				      cryptlen) * 8);
+		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
+		temp64 = 0;
+		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
+	}
+
+	return 0;
+}
+
+static void cc_proc_rfc4_gcm(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET,
+	       ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
+	       GCM_BLOCK_RFC4_IV_SIZE);
+	req->iv = areq_ctx->ctr_iv;
+	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
+}
+
+static int cc_proc_aead(struct aead_request *req,
+			enum drv_crypto_direction direct)
+{
+	int rc = 0;
+	int seq_len = 0;
+	struct cc_hw_desc desc[MAX_AEAD_PROCESS_SEQ];
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct cc_crypto_req cc_req = {};
+
+	dev_dbg(dev, "%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
+		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Enc" : "Dec"),
+		ctx, req, req->iv, sg_virt(req->src), req->src->offset,
+		sg_virt(req->dst), req->dst->offset, req->cryptlen);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+
+	/* Check data length according to mode */
+	if (validate_data_size(ctx, direct, req)) {
+		dev_err(dev, "Unsupported crypt/assoc len %d/%d.\n",
+			req->cryptlen, req->assoclen);
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
+		return -EINVAL;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = (void *)cc_aead_complete;
+	cc_req.user_arg = (void *)req;
+
+	/* Setup request context */
+	areq_ctx->gen_ctx.op_type = direct;
+	areq_ctx->req_authsize = ctx->authsize;
+	areq_ctx->cipher_mode = ctx->cipher_mode;
+
+	/* STAT_PHASE_1: Map buffers */
+
+	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+		/* Build CTR IV - Copy nonce from last 4 bytes in
+		 * CTR key to first 4 bytes in CTR IV
+		 */
+		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce,
+		       CTR_RFC3686_NONCE_SIZE);
+		if (!areq_ctx->backup_giv) /*User none-generated IV*/
+			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
+			       req->iv, CTR_RFC3686_IV_SIZE);
+		/* Initialize counter portion of counter block */
+		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
+			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
+
+		/* Replace with counter iv */
+		req->iv = areq_ctx->ctr_iv;
+		areq_ctx->hw_iv_size = CTR_RFC3686_BLOCK_SIZE;
+	} else if ((ctx->cipher_mode == DRV_CIPHER_CCM) ||
+		   (ctx->cipher_mode == DRV_CIPHER_GCTR)) {
+		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
+		if (areq_ctx->ctr_iv != req->iv) {
+			memcpy(areq_ctx->ctr_iv, req->iv,
+			       crypto_aead_ivsize(tfm));
+			req->iv = areq_ctx->ctr_iv;
+		}
+	}  else {
+		areq_ctx->hw_iv_size = crypto_aead_ivsize(tfm);
+	}
+
+	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+		rc = config_ccm_adata(req);
+		if (rc) {
+			dev_dbg(dev, "config_ccm_adata() returned with a failure %d!",
+				rc);
+			goto exit;
+		}
+	} else {
+		areq_ctx->ccm_hdr_size = ccm_header_size_null;
+	}
+
+	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		rc = config_gcm_context(req);
+		if (rc) {
+			dev_dbg(dev, "config_gcm_context() returned with a failure %d!",
+				rc);
+			goto exit;
+		}
+	}
+
+	rc = cc_map_aead_request(ctx->drvdata, req);
+	if (rc) {
+		dev_err(dev, "map_request() failed\n");
+		goto exit;
+	}
+
+	/* do we need to generate IV? */
+	if (areq_ctx->backup_giv) {
+		/* set the DMA mapped IV address*/
+		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+			cc_req.ivgen_dma_addr[0] =
+				areq_ctx->gen_ctx.iv_dma_addr +
+				CTR_RFC3686_NONCE_SIZE;
+			cc_req.ivgen_dma_addr_len = 1;
+		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+			/* In ccm, the IV needs to exist both inside B0 and
+			 * inside the counter.It is also copied to iv_dma_addr
+			 * for other reasons (like returning it to the user).
+			 * So, using 3 (identical) IV outputs.
+			 */
+			cc_req.ivgen_dma_addr[0] =
+				areq_ctx->gen_ctx.iv_dma_addr +
+				CCM_BLOCK_IV_OFFSET;
+			cc_req.ivgen_dma_addr[1] =
+				sg_dma_address(&areq_ctx->ccm_adata_sg) +
+				CCM_B0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			cc_req.ivgen_dma_addr[2] =
+				sg_dma_address(&areq_ctx->ccm_adata_sg) +
+				CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			cc_req.ivgen_dma_addr_len = 3;
+		} else {
+			cc_req.ivgen_dma_addr[0] =
+				areq_ctx->gen_ctx.iv_dma_addr;
+			cc_req.ivgen_dma_addr_len = 1;
+		}
+
+		/* set the IV size (8/16 B long)*/
+		cc_req.ivgen_size = crypto_aead_ivsize(tfm);
+	}
+
+	/* STAT_PHASE_2: Create sequence */
+
+	/* Load MLLI tables to SRAM if necessary */
+	cc_mlli_to_sram(req, desc, &seq_len);
+
+	/*TODO: move seq len by reference */
+	switch (ctx->auth_mode) {
+	case DRV_HASH_SHA1:
+	case DRV_HASH_SHA256:
+		cc_hmac_authenc(req, desc, &seq_len);
+		break;
+	case DRV_HASH_XCBC_MAC:
+		cc_xcbc_authenc(req, desc, &seq_len);
+		break;
+	case DRV_HASH_NULL:
+		if (ctx->cipher_mode == DRV_CIPHER_CCM)
+			cc_ccm(req, desc, &seq_len);
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
+			cc_gcm(req, desc, &seq_len);
+		break;
+	default:
+		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
+		cc_unmap_aead_request(dev, req);
+		rc = -ENOTSUPP;
+		goto exit;
+	}
+
+	/* STAT_PHASE_3: Lock HW and push sequence */
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, seq_len, &req->base);
+
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_aead_request(dev, req);
+	}
+
+exit:
+	return rc;
+}
+
+static int cc_aead_encrypt(struct aead_request *req)
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
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+
+static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
+{
+	/* Very similar to cc_aead_encrypt() above. */
+
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+	areq_ctx->is_gcm4543 = true;
+
+	cc_proc_rfc4309_ccm(req);
+
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+out:
+	return rc;
+}
+
+static int cc_aead_decrypt(struct aead_request *req)
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
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+
+static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+
+	areq_ctx->is_gcm4543 = true;
+	cc_proc_rfc4309_ccm(req);
+
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+
+out:
+	return rc;
+}
+
+static int cc_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "%s()  keylen %d, key %p\n", __func__, keylen, key);
+
+	if (keylen < 4)
+		return -EINVAL;
+
+	keylen -= 4;
+	memcpy(ctx->ctr_nonce, key + keylen, 4);
+
+	return cc_aead_setkey(tfm, key, keylen);
+}
+
+static int cc_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "%s()  keylen %d, key %p\n", __func__, keylen, key);
+
+	if (keylen < 4)
+		return -EINVAL;
+
+	keylen -= 4;
+	memcpy(ctx->ctr_nonce, key + keylen, 4);
+
+	return cc_aead_setkey(tfm, key, keylen);
+}
+
+static int cc_gcm_setauthsize(struct crypto_aead *authenc,
+			      unsigned int authsize)
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
+	return cc_aead_setauthsize(authenc, authsize);
+}
+
+static int cc_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "authsize %d\n", authsize);
+
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return cc_aead_setauthsize(authenc, authsize);
+}
+
+static int cc_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "authsize %d\n", authsize);
+
+	if (authsize != 16)
+		return -EINVAL;
+
+	return cc_aead_setauthsize(authenc, authsize);
+}
+
+static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
+{
+	/* Very similar to cc_aead_encrypt() above. */
+
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+
+	areq_ctx->plaintext_authenticate_only = false;
+
+	cc_proc_rfc4_gcm(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+out:
+	return rc;
+}
+
+static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
+{
+	/* Very similar to cc_aead_encrypt() above. */
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
+	cc_proc_rfc4_gcm(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+
+static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
+{
+	/* Very similar to cc_aead_decrypt() above. */
+
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
+
+	/* No generated IV required */
+	areq_ctx->backup_iv = req->iv;
+	areq_ctx->backup_giv = NULL;
+
+	areq_ctx->plaintext_authenticate_only = false;
+
+	cc_proc_rfc4_gcm(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+out:
+	return rc;
+}
+
+static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
+{
+	/* Very similar to cc_aead_decrypt() above. */
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
+	cc_proc_rfc4_gcm(req);
+	areq_ctx->is_gcm4543 = true;
+
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	if (rc != -EINPROGRESS && rc != -EBUSY)
+		req->iv = areq_ctx->backup_iv;
+
+	return rc;
+}
+
+/* DX Block aead alg */
+static struct cc_alg_template aead_algs[] = {
+	{
+		.name = "authenc(hmac(sha1),cbc(aes))",
+		.driver_name = "authenc-hmac-sha1-cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_XCBC_MAC,
+	},
+	{
+		.name = "ccm(aes)",
+		.driver_name = "ccm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_ccm_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_rfc4309_ccm_setkey,
+			.setauthsize = cc_rfc4309_ccm_setauthsize,
+			.encrypt = cc_rfc4309_ccm_encrypt,
+			.decrypt = cc_rfc4309_ccm_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
+			.ivsize = CCM_BLOCK_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CCM,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	},
+	{
+		.name = "gcm(aes)",
+		.driver_name = "gcm-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_gcm_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_rfc4106_gcm_setkey,
+			.setauthsize = cc_rfc4106_gcm_setauthsize,
+			.encrypt = cc_rfc4106_gcm_encrypt,
+			.decrypt = cc_rfc4106_gcm_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
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
+			.setkey = cc_rfc4543_gcm_setkey,
+			.setauthsize = cc_rfc4543_gcm_setauthsize,
+			.encrypt = cc_rfc4543_gcm_encrypt,
+			.decrypt = cc_rfc4543_gcm_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
+			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_GCTR,
+		.flow_mode = S_DIN_to_AES,
+		.auth_mode = DRV_HASH_NULL,
+	},
+};
+
+static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
+						struct device *dev)
+{
+	struct cc_crypto_alg *t_alg;
+	struct aead_alg *alg;
+
+	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
+	if (!t_alg)
+		return ERR_PTR(-ENOMEM);
+
+	alg = &tmpl->template_aead;
+
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 tmpl->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 tmpl->driver_name);
+	alg->base.cra_module = THIS_MODULE;
+	alg->base.cra_priority = CC_CRA_PRIO;
+
+	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			 tmpl->type;
+	alg->init = cc_aead_init;
+	alg->exit = cc_aead_exit;
+
+	t_alg->aead_alg = *alg;
+
+	t_alg->cipher_mode = tmpl->cipher_mode;
+	t_alg->flow_mode = tmpl->flow_mode;
+	t_alg->auth_mode = tmpl->auth_mode;
+
+	return t_alg;
+}
+
+int cc_aead_free(struct cc_drvdata *drvdata)
+{
+	struct cc_crypto_alg *t_alg, *n;
+	struct cc_aead_handle *aead_handle =
+		(struct cc_aead_handle *)drvdata->aead_handle;
+
+	if (aead_handle) {
+		/* Remove registered algs */
+		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list,
+					 entry) {
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
+int cc_aead_alloc(struct cc_drvdata *drvdata)
+{
+	struct cc_aead_handle *aead_handle;
+	struct cc_crypto_alg *t_alg;
+	int rc = -ENOMEM;
+	int alg;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	aead_handle = kmalloc(sizeof(*aead_handle), GFP_KERNEL);
+	if (!aead_handle) {
+		rc = -ENOMEM;
+		goto fail0;
+	}
+
+	INIT_LIST_HEAD(&aead_handle->aead_list);
+	drvdata->aead_handle = aead_handle;
+
+	aead_handle->sram_workspace_addr = cc_sram_alloc(drvdata,
+							 MAX_HMAC_DIGEST_SIZE);
+
+	if (aead_handle->sram_workspace_addr == NULL_SRAM_ADDR) {
+		dev_err(dev, "SRAM pool exhausted\n");
+		rc = -ENOMEM;
+		goto fail1;
+	}
+
+	/* Linux crypto */
+	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
+		t_alg = cc_create_aead_alg(&aead_algs[alg], dev);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			dev_err(dev, "%s alg allocation failed\n",
+				aead_algs[alg].driver_name);
+			goto fail1;
+		}
+		t_alg->drvdata = drvdata;
+		rc = crypto_register_aead(&t_alg->aead_alg);
+		if (rc) {
+			dev_err(dev, "%s alg registration failed\n",
+				t_alg->aead_alg.base.cra_driver_name);
+			goto fail2;
+		} else {
+			list_add_tail(&t_alg->entry, &aead_handle->aead_list);
+			dev_dbg(dev, "Registered %s\n",
+				t_alg->aead_alg.base.cra_driver_name);
+		}
+	}
+
+	return 0;
+
+fail2:
+	kfree(t_alg);
+fail1:
+	cc_aead_free(drvdata);
+fail0:
+	return rc;
+}
diff --git a/drivers/staging/ccree/cc_aead.h b/drivers/staging/ccree/cc_aead.h
new file mode 100644
index 0000000..5edf3b3
--- /dev/null
+++ b/drivers/staging/ccree/cc_aead.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_aead.h
+ * ARM CryptoCell AEAD Crypto API
+ */
+
+#ifndef __CC_AEAD_H__
+#define __CC_AEAD_H__
+
+#include <linux/kernel.h>
+#include <crypto/algapi.h>
+#include <crypto/ctr.h>
+
+/* mac_cmp - HW writes 8 B but all bytes hold the same value */
+#define ICV_CMP_SIZE 8
+#define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE * 3)
+#define MAX_MAC_SIZE SHA256_DIGEST_SIZE
+
+/* defines for AES GCM configuration buffer */
+#define GCM_BLOCK_LEN_SIZE 8
+
+#define GCM_BLOCK_RFC4_IV_OFFSET	4
+#define GCM_BLOCK_RFC4_IV_SIZE		8  /* IV size for rfc's */
+#define GCM_BLOCK_RFC4_NONCE_OFFSET	0
+#define GCM_BLOCK_RFC4_NONCE_SIZE	4
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
+	ccm_header_size_max = S32_MAX
+};
+
+struct aead_req_ctx {
+	/* Allocate cache line although only 4 bytes are needed to
+	 *  assure next field falls @ cache line
+	 *  Used for both: digest HW compare and CCM/GCM MAC value
+	 */
+	u8 mac_buf[MAX_MAC_SIZE] ____cacheline_aligned;
+	u8 ctr_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
+
+	//used in gcm
+	u8 gcm_iv_inc1[AES_BLOCK_SIZE] ____cacheline_aligned;
+	u8 gcm_iv_inc2[AES_BLOCK_SIZE] ____cacheline_aligned;
+	u8 hkey[AES_BLOCK_SIZE] ____cacheline_aligned;
+	struct {
+		u8 len_a[GCM_BLOCK_LEN_SIZE] ____cacheline_aligned;
+		u8 len_c[GCM_BLOCK_LEN_SIZE];
+	} gcm_len_block;
+
+	u8 ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
+	/* HW actual size input */
+	unsigned int hw_iv_size ____cacheline_aligned;
+	/* used to prevent cache coherence problem */
+	u8 backup_mac[MAX_MAC_SIZE];
+	u8 *backup_iv; /*store iv for generated IV flow*/
+	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
+	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
+	/* buffer for internal ccm configurations */
+	dma_addr_t ccm_iv0_dma_addr;
+	dma_addr_t icv_dma_addr; /* Phys. address of ICV */
+
+	//used in gcm
+	/* buffer for internal gcm configurations */
+	dma_addr_t gcm_iv_inc1_dma_addr;
+	/* buffer for internal gcm configurations */
+	dma_addr_t gcm_iv_inc2_dma_addr;
+	dma_addr_t hkey_dma_addr; /* Phys. address of hkey */
+	dma_addr_t gcm_block_len_dma_addr; /* Phys. address of gcm block len */
+	bool is_gcm4543;
+
+	u8 *icv_virt_addr; /* Virt. address of ICV */
+	struct async_gen_req_ctx gen_ctx;
+	struct cc_mlli assoc;
+	struct cc_mlli src;
+	struct cc_mlli dst;
+	struct scatterlist *src_sgl;
+	struct scatterlist *dst_sgl;
+	unsigned int src_offset;
+	unsigned int dst_offset;
+	enum cc_req_dma_buf_type assoc_buff_type;
+	enum cc_req_dma_buf_type data_buff_type;
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
+int cc_aead_alloc(struct cc_drvdata *drvdata);
+int cc_aead_free(struct cc_drvdata *drvdata);
+
+#endif /*__CC_AEAD_H__*/
diff --git a/drivers/staging/ccree/cc_buffer_mgr.c b/drivers/staging/ccree/cc_buffer_mgr.c
new file mode 100644
index 0000000..01c786c
--- /dev/null
+++ b/drivers/staging/ccree/cc_buffer_mgr.c
@@ -0,0 +1,1657 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/crypto.h>
+#include <linux/version.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/aead.h>
+#include <crypto/hash.h>
+#include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "cc_buffer_mgr.h"
+#include "cc_lli_defs.h"
+#include "cc_cipher.h"
+#include "cc_hash.h"
+#include "cc_aead.h"
+
+enum dma_buffer_type {
+	DMA_NULL_TYPE = -1,
+	DMA_SGL_TYPE = 1,
+	DMA_BUFF_TYPE = 2,
+};
+
+struct buff_mgr_handle {
+	struct dma_pool *mlli_buffs_pool;
+};
+
+union buffer_array_entry {
+	struct scatterlist *sgl;
+	dma_addr_t buffer_dma;
+};
+
+struct buffer_array {
+	unsigned int num_of_buffers;
+	union buffer_array_entry entry[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	unsigned int offset[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	int nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	int total_data_len[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	enum dma_buffer_type type[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	bool is_last[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
+};
+
+static inline char *cc_dma_buf_type(enum cc_req_dma_buf_type type)
+{
+	switch (type) {
+	case CC_DMA_BUF_NULL:
+		return "BUF_NULL";
+	case CC_DMA_BUF_DLLI:
+		return "BUF_DLLI";
+	case CC_DMA_BUF_MLLI:
+		return "BUF_MLLI";
+	default:
+		return "BUF_INVALID";
+	}
+}
+
+/**
+ * cc_copy_mac() - Copy MAC to temporary location
+ *
+ * @dev: device object
+ * @req: aead request object
+ * @dir: [IN] copy from/to sgl
+ */
+static void cc_copy_mac(struct device *dev, struct aead_request *req,
+			enum cc_sg_cpy_direct dir)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	u32 skip = req->assoclen + req->cryptlen;
+
+	if (areq_ctx->is_gcm4543)
+		skip += crypto_aead_ivsize(tfm);
+
+	cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
+			   (skip - areq_ctx->req_authsize), skip, dir);
+}
+
+/**
+ * cc_get_sgl_nents() - Get scatterlist number of entries.
+ *
+ * @sg_list: SG list
+ * @nbytes: [IN] Total SGL data bytes.
+ * @lbytes: [OUT] Returns the amount of bytes at the last entry
+ */
+static unsigned int cc_get_sgl_nents(struct device *dev,
+				     struct scatterlist *sg_list,
+				     unsigned int nbytes, u32 *lbytes,
+				     bool *is_chained)
+{
+	unsigned int nents = 0;
+
+	while (nbytes && sg_list) {
+		if (sg_list->length) {
+			nents++;
+			/* get the number of bytes in the last entry */
+			*lbytes = nbytes;
+			nbytes -= (sg_list->length > nbytes) ?
+					nbytes : sg_list->length;
+			sg_list = sg_next(sg_list);
+		} else {
+			sg_list = (struct scatterlist *)sg_page(sg_list);
+			if (is_chained)
+				*is_chained = true;
+		}
+	}
+	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
+	return nents;
+}
+
+/**
+ * cc_zero_sgl() - Zero scatter scatter list data.
+ *
+ * @sgl:
+ */
+void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
+{
+	struct scatterlist *current_sg = sgl;
+	int sg_index = 0;
+
+	while (sg_index <= data_len) {
+		if (!current_sg) {
+			/* reached the end of the sgl --> just return back */
+			return;
+		}
+		memset(sg_virt(current_sg), 0, current_sg->length);
+		sg_index += current_sg->length;
+		current_sg = sg_next(current_sg);
+	}
+}
+
+/**
+ * cc_copy_sg_portion() - Copy scatter list data,
+ * from to_skip to end, to dest and vice versa
+ *
+ * @dest:
+ * @sg:
+ * @to_skip:
+ * @end:
+ * @direct:
+ */
+void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
+			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct)
+{
+	u32 nents, lbytes;
+
+	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
+	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
+		       (direct == CC_SG_TO_BUF));
+}
+
+static int cc_render_buff_to_mlli(struct device *dev, dma_addr_t buff_dma,
+				  u32 buff_size, u32 *curr_nents,
+				  u32 **mlli_entry_pp)
+{
+	u32 *mlli_entry_p = *mlli_entry_pp;
+	u32 new_nents;
+
+	/* Verify there is no memory overflow*/
+	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
+	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES)
+		return -ENOMEM;
+
+	/*handle buffer longer than 64 kbytes */
+	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE) {
+		cc_lli_set_addr(mlli_entry_p, buff_dma);
+		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
+		dev_dbg(dev, "entry[%d]: single_buff=0x%08X size=%08X\n",
+			*curr_nents, mlli_entry_p[LLI_WORD0_OFFSET],
+			mlli_entry_p[LLI_WORD1_OFFSET]);
+		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
+		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
+		mlli_entry_p = mlli_entry_p + 2;
+		(*curr_nents)++;
+	}
+	/*Last entry */
+	cc_lli_set_addr(mlli_entry_p, buff_dma);
+	cc_lli_set_size(mlli_entry_p, buff_size);
+	dev_dbg(dev, "entry[%d]: single_buff=0x%08X size=%08X\n",
+		*curr_nents, mlli_entry_p[LLI_WORD0_OFFSET],
+		mlli_entry_p[LLI_WORD1_OFFSET]);
+	mlli_entry_p = mlli_entry_p + 2;
+	*mlli_entry_pp = mlli_entry_p;
+	(*curr_nents)++;
+	return 0;
+}
+
+static int cc_render_sg_to_mlli(struct device *dev, struct scatterlist *sgl,
+				u32 sgl_data_len, u32 sgl_offset,
+				u32 *curr_nents, u32 **mlli_entry_pp)
+{
+	struct scatterlist *curr_sgl = sgl;
+	u32 *mlli_entry_p = *mlli_entry_pp;
+	s32 rc = 0;
+
+	for ( ; (curr_sgl && sgl_data_len);
+	      curr_sgl = sg_next(curr_sgl)) {
+		u32 entry_data_len =
+			(sgl_data_len > sg_dma_len(curr_sgl) - sgl_offset) ?
+				sg_dma_len(curr_sgl) - sgl_offset :
+				sgl_data_len;
+		sgl_data_len -= entry_data_len;
+		rc = cc_render_buff_to_mlli(dev, sg_dma_address(curr_sgl) +
+					    sgl_offset, entry_data_len,
+					    curr_nents, &mlli_entry_p);
+		if (rc)
+			return rc;
+
+		sgl_offset = 0;
+	}
+	*mlli_entry_pp = mlli_entry_p;
+	return 0;
+}
+
+static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
+			    struct mlli_params *mlli_params, gfp_t flags)
+{
+	u32 *mlli_p;
+	u32 total_nents = 0, prev_total_nents = 0;
+	int rc = 0, i;
+
+	dev_dbg(dev, "NUM of SG's = %d\n", sg_data->num_of_buffers);
+
+	/* Allocate memory from the pointed pool */
+	mlli_params->mlli_virt_addr =
+		dma_pool_alloc(mlli_params->curr_pool, flags,
+			       &mlli_params->mlli_dma_addr);
+	if (!mlli_params->mlli_virt_addr) {
+		dev_err(dev, "dma_pool_alloc() failed\n");
+		rc = -ENOMEM;
+		goto build_mlli_exit;
+	}
+	/* Point to start of MLLI */
+	mlli_p = (u32 *)mlli_params->mlli_virt_addr;
+	/* go over all SG's and link it to one MLLI table */
+	for (i = 0; i < sg_data->num_of_buffers; i++) {
+		union buffer_array_entry *entry = &sg_data->entry[i];
+		u32 tot_len = sg_data->total_data_len[i];
+		u32 offset = sg_data->offset[i];
+
+		if (sg_data->type[i] == DMA_SGL_TYPE)
+			rc = cc_render_sg_to_mlli(dev, entry->sgl, tot_len,
+						  offset, &total_nents,
+						  &mlli_p);
+		else /*DMA_BUFF_TYPE*/
+			rc = cc_render_buff_to_mlli(dev, entry->buffer_dma,
+						    tot_len, &total_nents,
+						    &mlli_p);
+		if (rc)
+			return rc;
+
+		/* set last bit in the current table */
+		if (sg_data->mlli_nents[i]) {
+			/*Calculate the current MLLI table length for the
+			 *length field in the descriptor
+			 */
+			*sg_data->mlli_nents[i] +=
+				(total_nents - prev_total_nents);
+			prev_total_nents = total_nents;
+		}
+	}
+
+	/* Set MLLI size for the bypass operation */
+	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
+
+	dev_dbg(dev, "MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
+		mlli_params->mlli_virt_addr, &mlli_params->mlli_dma_addr,
+		mlli_params->mlli_len);
+
+build_mlli_exit:
+	return rc;
+}
+
+static void cc_add_buffer_entry(struct device *dev,
+				struct buffer_array *sgl_data,
+				dma_addr_t buffer_dma, unsigned int buffer_len,
+				bool is_last_entry, u32 *mlli_nents)
+{
+	unsigned int index = sgl_data->num_of_buffers;
+
+	dev_dbg(dev, "index=%u single_buff=%pad buffer_len=0x%08X is_last=%d\n",
+		index, &buffer_dma, buffer_len, is_last_entry);
+	sgl_data->nents[index] = 1;
+	sgl_data->entry[index].buffer_dma = buffer_dma;
+	sgl_data->offset[index] = 0;
+	sgl_data->total_data_len[index] = buffer_len;
+	sgl_data->type[index] = DMA_BUFF_TYPE;
+	sgl_data->is_last[index] = is_last_entry;
+	sgl_data->mlli_nents[index] = mlli_nents;
+	if (sgl_data->mlli_nents[index])
+		*sgl_data->mlli_nents[index] = 0;
+	sgl_data->num_of_buffers++;
+}
+
+static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
+			    unsigned int nents, struct scatterlist *sgl,
+			    unsigned int data_len, unsigned int data_offset,
+			    bool is_last_table, u32 *mlli_nents)
+{
+	unsigned int index = sgl_data->num_of_buffers;
+
+	dev_dbg(dev, "index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
+		index, nents, sgl, data_len, is_last_table);
+	sgl_data->nents[index] = nents;
+	sgl_data->entry[index].sgl = sgl;
+	sgl_data->offset[index] = data_offset;
+	sgl_data->total_data_len[index] = data_len;
+	sgl_data->type[index] = DMA_SGL_TYPE;
+	sgl_data->is_last[index] = is_last_table;
+	sgl_data->mlli_nents[index] = mlli_nents;
+	if (sgl_data->mlli_nents[index])
+		*sgl_data->mlli_nents[index] = 0;
+	sgl_data->num_of_buffers++;
+}
+
+static int cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
+			 enum dma_data_direction direction)
+{
+	u32 i, j;
+	struct scatterlist *l_sg = sg;
+
+	for (i = 0; i < nents; i++) {
+		if (!l_sg)
+			break;
+		if (dma_map_sg(dev, l_sg, 1, direction) != 1) {
+			dev_err(dev, "dma_map_page() sg buffer failed\n");
+			goto err;
+		}
+		l_sg = sg_next(l_sg);
+	}
+	return nents;
+
+err:
+	/* Restore mapped parts */
+	for (j = 0; j < i; j++) {
+		if (!sg)
+			break;
+		dma_unmap_sg(dev, sg, 1, direction);
+		sg = sg_next(sg);
+	}
+	return 0;
+}
+
+static int cc_map_sg(struct device *dev, struct scatterlist *sg,
+		     unsigned int nbytes, int direction, u32 *nents,
+		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
+{
+	bool is_chained = false;
+
+	if (sg_is_last(sg)) {
+		/* One entry only case -set to DLLI */
+		if (dma_map_sg(dev, sg, 1, direction) != 1) {
+			dev_err(dev, "dma_map_sg() single buffer failed\n");
+			return -ENOMEM;
+		}
+		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+			&sg_dma_address(sg), sg_page(sg), sg_virt(sg),
+			sg->offset, sg->length);
+		*lbytes = nbytes;
+		*nents = 1;
+		*mapped_nents = 1;
+	} else {  /*sg_is_last*/
+		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes,
+					  &is_chained);
+		if (*nents > max_sg_nents) {
+			*nents = 0;
+			dev_err(dev, "Too many fragments. current %d max %d\n",
+				*nents, max_sg_nents);
+			return -ENOMEM;
+		}
+		if (!is_chained) {
+			/* In case of mmu the number of mapped nents might
+			 * be changed from the original sgl nents
+			 */
+			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
+			if (*mapped_nents == 0) {
+				*nents = 0;
+				dev_err(dev, "dma_map_sg() sg buffer failed\n");
+				return -ENOMEM;
+			}
+		} else {
+			/*In this case the driver maps entry by entry so it
+			 * must have the same nents before and after map
+			 */
+			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
+						      direction);
+			if (*mapped_nents != *nents) {
+				*nents = *mapped_nents;
+				dev_err(dev, "dma_map_sg() sg buffer failed\n");
+				return -ENOMEM;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int
+cc_set_aead_conf_buf(struct device *dev, struct aead_req_ctx *areq_ctx,
+		     u8 *config_data, struct buffer_array *sg_data,
+		     unsigned int assoclen)
+{
+	dev_dbg(dev, " handle additional data config set to DLLI\n");
+	/* create sg for the current buffer */
+	sg_init_one(&areq_ctx->ccm_adata_sg, config_data,
+		    AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
+	if (dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE) != 1) {
+		dev_err(dev, "dma_map_sg() config buffer failed\n");
+		return -ENOMEM;
+	}
+	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+		&sg_dma_address(&areq_ctx->ccm_adata_sg),
+		sg_page(&areq_ctx->ccm_adata_sg),
+		sg_virt(&areq_ctx->ccm_adata_sg),
+		areq_ctx->ccm_adata_sg.offset, areq_ctx->ccm_adata_sg.length);
+	/* prepare for case of MLLI */
+	if (assoclen > 0) {
+		cc_add_sg_entry(dev, sg_data, 1, &areq_ctx->ccm_adata_sg,
+				(AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
+				0, false, NULL);
+	}
+	return 0;
+}
+
+static int cc_set_hash_buf(struct device *dev, struct ahash_req_ctx *areq_ctx,
+			   u8 *curr_buff, u32 curr_buff_cnt,
+			   struct buffer_array *sg_data)
+{
+	dev_dbg(dev, " handle curr buff %x set to   DLLI\n", curr_buff_cnt);
+	/* create sg for the current buffer */
+	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
+	if (dma_map_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE) != 1) {
+		dev_err(dev, "dma_map_sg() src buffer failed\n");
+		return -ENOMEM;
+	}
+	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+		&sg_dma_address(areq_ctx->buff_sg), sg_page(areq_ctx->buff_sg),
+		sg_virt(areq_ctx->buff_sg), areq_ctx->buff_sg->offset,
+		areq_ctx->buff_sg->length);
+	areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
+	areq_ctx->curr_sg = areq_ctx->buff_sg;
+	areq_ctx->in_nents = 0;
+	/* prepare for case of MLLI */
+	cc_add_sg_entry(dev, sg_data, 1, areq_ctx->buff_sg, curr_buff_cnt, 0,
+			false, NULL);
+	return 0;
+}
+
+void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
+				unsigned int ivsize, struct scatterlist *src,
+				struct scatterlist *dst)
+{
+	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
+
+	if (req_ctx->gen_ctx.iv_dma_addr) {
+		dev_dbg(dev, "Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
+			&req_ctx->gen_ctx.iv_dma_addr, ivsize);
+		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
+				 ivsize,
+				 req_ctx->is_giv ? DMA_BIDIRECTIONAL :
+				 DMA_TO_DEVICE);
+	}
+	/* Release pool */
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI &&
+	    req_ctx->mlli_params.mlli_virt_addr) {
+		dma_pool_free(req_ctx->mlli_params.curr_pool,
+			      req_ctx->mlli_params.mlli_virt_addr,
+			      req_ctx->mlli_params.mlli_dma_addr);
+	}
+
+	dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
+	dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
+
+	if (src != dst) {
+		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped req->dst=%pK\n", sg_virt(dst));
+	}
+}
+
+int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
+			     unsigned int ivsize, unsigned int nbytes,
+			     void *info, struct scatterlist *src,
+			     struct scatterlist *dst, gfp_t flags)
+{
+	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
+	struct mlli_params *mlli_params = &req_ctx->mlli_params;
+	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct buffer_array sg_data;
+	u32 dummy = 0;
+	int rc = 0;
+	u32 mapped_nents = 0;
+
+	req_ctx->dma_buf_type = CC_DMA_BUF_DLLI;
+	mlli_params->curr_pool = NULL;
+	sg_data.num_of_buffers = 0;
+
+	/* Map IV buffer */
+	if (ivsize) {
+		dump_byte_array("iv", (u8 *)info, ivsize);
+		req_ctx->gen_ctx.iv_dma_addr =
+			dma_map_single(dev, (void *)info,
+				       ivsize,
+				       req_ctx->is_giv ? DMA_BIDIRECTIONAL :
+				       DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, req_ctx->gen_ctx.iv_dma_addr)) {
+			dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
+				ivsize, info);
+			return -ENOMEM;
+		}
+		dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
+			ivsize, info, &req_ctx->gen_ctx.iv_dma_addr);
+	} else {
+		req_ctx->gen_ctx.iv_dma_addr = 0;
+	}
+
+	/* Map the src SGL */
+	rc = cc_map_sg(dev, src, nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
+		       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
+	if (rc) {
+		rc = -ENOMEM;
+		goto ablkcipher_exit;
+	}
+	if (mapped_nents > 1)
+		req_ctx->dma_buf_type = CC_DMA_BUF_MLLI;
+
+	if (src == dst) {
+		/* Handle inplace operation */
+		if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
+			req_ctx->out_nents = 0;
+			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
+					nbytes, 0, true,
+					&req_ctx->in_mlli_nents);
+		}
+	} else {
+		/* Map the dst sg */
+		if (cc_map_sg(dev, dst, nbytes, DMA_BIDIRECTIONAL,
+			      &req_ctx->out_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
+			      &dummy, &mapped_nents)) {
+			rc = -ENOMEM;
+			goto ablkcipher_exit;
+		}
+		if (mapped_nents > 1)
+			req_ctx->dma_buf_type = CC_DMA_BUF_MLLI;
+
+		if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
+			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
+					nbytes, 0, true,
+					&req_ctx->in_mlli_nents);
+			cc_add_sg_entry(dev, &sg_data, req_ctx->out_nents, dst,
+					nbytes, 0, true,
+					&req_ctx->out_mlli_nents);
+		}
+	}
+
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
+		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
+		rc = cc_generate_mlli(dev, &sg_data, mlli_params, flags);
+		if (rc)
+			goto ablkcipher_exit;
+	}
+
+	dev_dbg(dev, "areq_ctx->dma_buf_type = %s\n",
+		cc_dma_buf_type(req_ctx->dma_buf_type));
+
+	return 0;
+
+ablkcipher_exit:
+	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	return rc;
+}
+
+void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+	u32 dummy;
+	bool chained;
+	u32 size_to_unmap = 0;
+
+	if (areq_ctx->mac_buf_dma_addr) {
+		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
+				 MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
+	}
+
+	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		if (areq_ctx->hkey_dma_addr) {
+			dma_unmap_single(dev, areq_ctx->hkey_dma_addr,
+					 AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
+		}
+
+		if (areq_ctx->gcm_block_len_dma_addr) {
+			dma_unmap_single(dev, areq_ctx->gcm_block_len_dma_addr,
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+
+		if (areq_ctx->gcm_iv_inc1_dma_addr) {
+			dma_unmap_single(dev, areq_ctx->gcm_iv_inc1_dma_addr,
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+
+		if (areq_ctx->gcm_iv_inc2_dma_addr) {
+			dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr,
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+	}
+
+	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
+		if (areq_ctx->ccm_iv0_dma_addr) {
+			dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr,
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		}
+
+		dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE);
+	}
+	if (areq_ctx->gen_ctx.iv_dma_addr) {
+		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
+				 hw_iv_size, DMA_BIDIRECTIONAL);
+	}
+
+	/*In case a pool was set, a table was
+	 *allocated and should be released
+	 */
+	if (areq_ctx->mlli_params.curr_pool) {
+		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
+			&areq_ctx->mlli_params.mlli_dma_addr,
+			areq_ctx->mlli_params.mlli_virt_addr);
+		dma_pool_free(areq_ctx->mlli_params.curr_pool,
+			      areq_ctx->mlli_params.mlli_virt_addr,
+			      areq_ctx->mlli_params.mlli_dma_addr);
+	}
+
+	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
+		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
+		req->assoclen, req->cryptlen);
+	size_to_unmap = req->assoclen + req->cryptlen;
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
+		size_to_unmap += areq_ctx->req_authsize;
+	if (areq_ctx->is_gcm4543)
+		size_to_unmap += crypto_aead_ivsize(tfm);
+
+	dma_unmap_sg(dev, req->src,
+		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
+				      &dummy, &chained),
+		     DMA_BIDIRECTIONAL);
+	if (req->src != req->dst) {
+		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
+			sg_virt(req->dst));
+		dma_unmap_sg(dev, req->dst,
+			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
+					      &dummy, &chained),
+			     DMA_BIDIRECTIONAL);
+	}
+	if (drvdata->coherent &&
+	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
+	    req->src == req->dst) {
+		/* copy back mac from temporary location to deal with possible
+		 * data memory overriding that caused by cache coherence
+		 * problem.
+		 */
+		cc_copy_mac(dev, req, CC_SG_FROM_BUF);
+	}
+}
+
+static int cc_get_aead_icv_nents(struct device *dev, struct scatterlist *sgl,
+				 unsigned int sgl_nents, unsigned int authsize,
+				 u32 last_entry_data_size,
+				 bool *is_icv_fragmented)
+{
+	unsigned int icv_max_size = 0;
+	unsigned int icv_required_size = authsize > last_entry_data_size ?
+					(authsize - last_entry_data_size) :
+					authsize;
+	unsigned int nents;
+	unsigned int i;
+
+	if (sgl_nents < MAX_ICV_NENTS_SUPPORTED) {
+		*is_icv_fragmented = false;
+		return 0;
+	}
+
+	for (i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
+		if (!sgl)
+			break;
+		sgl = sg_next(sgl);
+	}
+
+	if (sgl)
+		icv_max_size = sgl->length;
+
+	if (last_entry_data_size > authsize) {
+		/* ICV attached to data in last entry (not fragmented!) */
+		nents = 0;
+		*is_icv_fragmented = false;
+	} else if (last_entry_data_size == authsize) {
+		/* ICV placed in whole last entry (not fragmented!) */
+		nents = 1;
+		*is_icv_fragmented = false;
+	} else if (icv_max_size > icv_required_size) {
+		nents = 1;
+		*is_icv_fragmented = true;
+	} else if (icv_max_size == icv_required_size) {
+		nents = 2;
+		*is_icv_fragmented = true;
+	} else {
+		dev_err(dev, "Unsupported num. of ICV fragments (> %d)\n",
+			MAX_ICV_NENTS_SUPPORTED);
+		nents = -1; /*unsupported*/
+	}
+	dev_dbg(dev, "is_frag=%s icv_nents=%u\n",
+		(*is_icv_fragmented ? "true" : "false"), nents);
+
+	return nents;
+}
+
+static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
+			    struct aead_request *req,
+			    struct buffer_array *sg_data,
+			    bool is_last, bool do_chain)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc = 0;
+
+	if (!req->iv) {
+		areq_ctx->gen_ctx.iv_dma_addr = 0;
+		goto chain_iv_exit;
+	}
+
+	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
+						       hw_iv_size,
+						       DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
+		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
+			hw_iv_size, req->iv);
+		rc = -ENOMEM;
+		goto chain_iv_exit;
+	}
+
+	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
+		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
+	// TODO: what about CTR?? ask Ron
+	if (do_chain && areq_ctx->plaintext_authenticate_only) {
+		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
+		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
+		/* Chain to given list */
+		cc_add_buffer_entry(dev, sg_data,
+				    (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
+				    iv_size_to_authenc, is_last,
+				    &areq_ctx->assoc.mlli_nents);
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
+	}
+
+chain_iv_exit:
+	return rc;
+}
+
+static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
+			       struct aead_request *req,
+			       struct buffer_array *sg_data,
+			       bool is_last, bool do_chain)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	int rc = 0;
+	u32 mapped_nents = 0;
+	struct scatterlist *current_sg = req->src;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned int sg_index = 0;
+	u32 size_of_assoc = req->assoclen;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	if (areq_ctx->is_gcm4543)
+		size_of_assoc += crypto_aead_ivsize(tfm);
+
+	if (!sg_data) {
+		rc = -EINVAL;
+		goto chain_assoc_exit;
+	}
+
+	if (req->assoclen == 0) {
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_NULL;
+		areq_ctx->assoc.nents = 0;
+		areq_ctx->assoc.mlli_nents = 0;
+		dev_dbg(dev, "Chain assoc of length 0: buff_type=%s nents=%u\n",
+			cc_dma_buf_type(areq_ctx->assoc_buff_type),
+			areq_ctx->assoc.nents);
+		goto chain_assoc_exit;
+	}
+
+	//iterate over the sgl to see how many entries are for associated data
+	//it is assumed that if we reach here , the sgl is already mapped
+	sg_index = current_sg->length;
+	//the first entry in the scatter list contains all the associated data
+	if (sg_index > size_of_assoc) {
+		mapped_nents++;
+	} else {
+		while (sg_index <= size_of_assoc) {
+			current_sg = sg_next(current_sg);
+			/* if have reached the end of the sgl, then this is
+			 * unexpected
+			 */
+			if (!current_sg) {
+				dev_err(dev, "reached end of sg list. unexpected\n");
+				return -EINVAL;
+			}
+			sg_index += current_sg->length;
+			mapped_nents++;
+		}
+	}
+	if (mapped_nents > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
+		dev_err(dev, "Too many fragments. current %d max %d\n",
+			mapped_nents, LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
+		return -ENOMEM;
+	}
+	areq_ctx->assoc.nents = mapped_nents;
+
+	/* in CCM case we have additional entry for
+	 * ccm header configurations
+	 */
+	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
+		if ((mapped_nents + 1) > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
+			dev_err(dev, "CCM case.Too many fragments. Current %d max %d\n",
+				(areq_ctx->assoc.nents + 1),
+				LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
+			rc = -ENOMEM;
+			goto chain_assoc_exit;
+		}
+	}
+
+	if (mapped_nents == 1 && areq_ctx->ccm_hdr_size == ccm_header_size_null)
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_DLLI;
+	else
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
+
+	if (do_chain || areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI) {
+		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
+			cc_dma_buf_type(areq_ctx->assoc_buff_type),
+			areq_ctx->assoc.nents);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
+				req->assoclen, 0, is_last,
+				&areq_ctx->assoc.mlli_nents);
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
+	}
+
+chain_assoc_exit:
+	return rc;
+}
+
+static void cc_prepare_aead_data_dlli(struct aead_request *req,
+				      u32 *src_last_bytes, u32 *dst_last_bytes)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
+	unsigned int authsize = areq_ctx->req_authsize;
+
+	areq_ctx->is_icv_fragmented = false;
+	if (req->src == req->dst) {
+		/*INPLACE*/
+		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
+			(*src_last_bytes - authsize);
+		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
+			(*src_last_bytes - authsize);
+	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		/*NON-INPLACE and DECRYPT*/
+		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
+			(*src_last_bytes - authsize);
+		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
+			(*src_last_bytes - authsize);
+	} else {
+		/*NON-INPLACE and ENCRYPT*/
+		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->dst_sgl) +
+			(*dst_last_bytes - authsize);
+		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->dst_sgl) +
+			(*dst_last_bytes - authsize);
+	}
+}
+
+static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
+				     struct aead_request *req,
+				     struct buffer_array *sg_data,
+				     u32 *src_last_bytes, u32 *dst_last_bytes,
+				     bool is_last_table)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
+	unsigned int authsize = areq_ctx->req_authsize;
+	int rc = 0, icv_nents;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct scatterlist *sg;
+
+	if (req->src == req->dst) {
+		/*INPLACE*/
+		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
+				areq_ctx->src_sgl, areq_ctx->cryptlen,
+				areq_ctx->src_offset, is_last_table,
+				&areq_ctx->src.mlli_nents);
+
+		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
+						  areq_ctx->src.nents,
+						  authsize, *src_last_bytes,
+						  &areq_ctx->is_icv_fragmented);
+		if (icv_nents < 0) {
+			rc = -ENOTSUPP;
+			goto prepare_data_mlli_exit;
+		}
+
+		if (areq_ctx->is_icv_fragmented) {
+			/* Backup happens only when ICV is fragmented, ICV
+			 * verification is made by CPU compare in order to
+			 * simplify MAC verification upon request completion
+			 */
+			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+				/* In coherent platforms (e.g. ACP)
+				 * already copying ICV for any
+				 * INPLACE-DECRYPT operation, hence
+				 * we must neglect this code.
+				 */
+				if (!drvdata->coherent)
+					cc_copy_mac(dev, req, CC_SG_TO_BUF);
+
+				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
+			} else {
+				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
+				areq_ctx->icv_dma_addr =
+					areq_ctx->mac_buf_dma_addr;
+			}
+		} else { /* Contig. ICV */
+			sg = &areq_ctx->src_sgl[areq_ctx->src.nents - 1];
+			/*Should hanlde if the sg is not contig.*/
+			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
+				(*src_last_bytes - authsize);
+			areq_ctx->icv_virt_addr = sg_virt(sg) +
+				(*src_last_bytes - authsize);
+		}
+
+	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		/*NON-INPLACE and DECRYPT*/
+		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
+				areq_ctx->src_sgl, areq_ctx->cryptlen,
+				areq_ctx->src_offset, is_last_table,
+				&areq_ctx->src.mlli_nents);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->dst.nents,
+				areq_ctx->dst_sgl, areq_ctx->cryptlen,
+				areq_ctx->dst_offset, is_last_table,
+				&areq_ctx->dst.mlli_nents);
+
+		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
+						  areq_ctx->src.nents,
+						  authsize, *src_last_bytes,
+						  &areq_ctx->is_icv_fragmented);
+		if (icv_nents < 0) {
+			rc = -ENOTSUPP;
+			goto prepare_data_mlli_exit;
+		}
+
+		/* Backup happens only when ICV is fragmented, ICV
+		 * verification is made by CPU compare in order to simplify
+		 * MAC verification upon request completion
+		 */
+		if (areq_ctx->is_icv_fragmented) {
+			cc_copy_mac(dev, req, CC_SG_TO_BUF);
+			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
+
+		} else { /* Contig. ICV */
+			sg = &areq_ctx->src_sgl[areq_ctx->src.nents - 1];
+			/*Should hanlde if the sg is not contig.*/
+			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
+				(*src_last_bytes - authsize);
+			areq_ctx->icv_virt_addr = sg_virt(sg) +
+				(*src_last_bytes - authsize);
+		}
+
+	} else {
+		/*NON-INPLACE and ENCRYPT*/
+		cc_add_sg_entry(dev, sg_data, areq_ctx->dst.nents,
+				areq_ctx->dst_sgl, areq_ctx->cryptlen,
+				areq_ctx->dst_offset, is_last_table,
+				&areq_ctx->dst.mlli_nents);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
+				areq_ctx->src_sgl, areq_ctx->cryptlen,
+				areq_ctx->src_offset, is_last_table,
+				&areq_ctx->src.mlli_nents);
+
+		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->dst_sgl,
+						  areq_ctx->dst.nents,
+						  authsize, *dst_last_bytes,
+						  &areq_ctx->is_icv_fragmented);
+		if (icv_nents < 0) {
+			rc = -ENOTSUPP;
+			goto prepare_data_mlli_exit;
+		}
+
+		if (!areq_ctx->is_icv_fragmented) {
+			sg = &areq_ctx->dst_sgl[areq_ctx->dst.nents - 1];
+			/* Contig. ICV */
+			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
+				(*dst_last_bytes - authsize);
+			areq_ctx->icv_virt_addr = sg_virt(sg) +
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
+static int cc_aead_chain_data(struct cc_drvdata *drvdata,
+			      struct aead_request *req,
+			      struct buffer_array *sg_data,
+			      bool is_last_table, bool do_chain)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct device *dev = drvdata_to_dev(drvdata);
+	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
+	unsigned int authsize = areq_ctx->req_authsize;
+	int src_last_bytes = 0, dst_last_bytes = 0;
+	int rc = 0;
+	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
+	u32 offset = 0;
+	/* non-inplace mode */
+	unsigned int size_for_map = req->assoclen + req->cryptlen;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	u32 sg_index = 0;
+	bool chained = false;
+	bool is_gcm4543 = areq_ctx->is_gcm4543;
+	u32 size_to_skip = req->assoclen;
+
+	if (is_gcm4543)
+		size_to_skip += crypto_aead_ivsize(tfm);
+
+	offset = size_to_skip;
+
+	if (!sg_data)
+		return -EINVAL;
+
+	areq_ctx->src_sgl = req->src;
+	areq_ctx->dst_sgl = req->dst;
+
+	if (is_gcm4543)
+		size_for_map += crypto_aead_ivsize(tfm);
+
+	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			authsize : 0;
+	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
+					    &src_last_bytes, &chained);
+	sg_index = areq_ctx->src_sgl->length;
+	//check where the data starts
+	while (sg_index <= size_to_skip) {
+		offset -= areq_ctx->src_sgl->length;
+		areq_ctx->src_sgl = sg_next(areq_ctx->src_sgl);
+		//if have reached the end of the sgl, then this is unexpected
+		if (!areq_ctx->src_sgl) {
+			dev_err(dev, "reached end of sg list. unexpected\n");
+			return -EINVAL;
+		}
+		sg_index += areq_ctx->src_sgl->length;
+		src_mapped_nents--;
+	}
+	if (src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
+		dev_err(dev, "Too many fragments. current %d max %d\n",
+			src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
+			return -ENOMEM;
+	}
+
+	areq_ctx->src.nents = src_mapped_nents;
+
+	areq_ctx->src_offset = offset;
+
+	if (req->src != req->dst) {
+		size_for_map = req->assoclen + req->cryptlen;
+		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+				authsize : 0;
+		if (is_gcm4543)
+			size_for_map += crypto_aead_ivsize(tfm);
+
+		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
+			       &areq_ctx->dst.nents,
+			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
+			       &dst_mapped_nents);
+		if (rc) {
+			rc = -ENOMEM;
+			goto chain_data_exit;
+		}
+	}
+
+	dst_mapped_nents = cc_get_sgl_nents(dev, req->dst, size_for_map,
+					    &dst_last_bytes, &chained);
+	sg_index = areq_ctx->dst_sgl->length;
+	offset = size_to_skip;
+
+	//check where the data starts
+	while (sg_index <= size_to_skip) {
+		offset -= areq_ctx->dst_sgl->length;
+		areq_ctx->dst_sgl = sg_next(areq_ctx->dst_sgl);
+		//if have reached the end of the sgl, then this is unexpected
+		if (!areq_ctx->dst_sgl) {
+			dev_err(dev, "reached end of sg list. unexpected\n");
+			return -EINVAL;
+		}
+		sg_index += areq_ctx->dst_sgl->length;
+		dst_mapped_nents--;
+	}
+	if (dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
+		dev_err(dev, "Too many fragments. current %d max %d\n",
+			dst_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
+		return -ENOMEM;
+	}
+	areq_ctx->dst.nents = dst_mapped_nents;
+	areq_ctx->dst_offset = offset;
+	if (src_mapped_nents > 1 ||
+	    dst_mapped_nents  > 1 ||
+	    do_chain) {
+		areq_ctx->data_buff_type = CC_DMA_BUF_MLLI;
+		rc = cc_prepare_aead_data_mlli(drvdata, req, sg_data,
+					       &src_last_bytes,
+					       &dst_last_bytes, is_last_table);
+	} else {
+		areq_ctx->data_buff_type = CC_DMA_BUF_DLLI;
+		cc_prepare_aead_data_dlli(req, &src_last_bytes,
+					  &dst_last_bytes);
+	}
+
+chain_data_exit:
+	return rc;
+}
+
+static void cc_update_aead_mlli_nents(struct cc_drvdata *drvdata,
+				      struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	u32 curr_mlli_size = 0;
+
+	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI) {
+		areq_ctx->assoc.sram_addr = drvdata->mlli_sram_addr;
+		curr_mlli_size = areq_ctx->assoc.mlli_nents *
+						LLI_ENTRY_BYTE_SIZE;
+	}
+
+	if (areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
+		/*Inplace case dst nents equal to src nents*/
+		if (req->src == req->dst) {
+			areq_ctx->dst.mlli_nents = areq_ctx->src.mlli_nents;
+			areq_ctx->src.sram_addr = drvdata->mlli_sram_addr +
+								curr_mlli_size;
+			areq_ctx->dst.sram_addr = areq_ctx->src.sram_addr;
+			if (!areq_ctx->is_single_pass)
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
+				if (!areq_ctx->is_single_pass)
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
+				if (!areq_ctx->is_single_pass)
+					areq_ctx->assoc.mlli_nents +=
+						areq_ctx->dst.mlli_nents;
+			}
+		}
+	}
+}
+
+int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct buffer_array sg_data;
+	unsigned int authsize = areq_ctx->req_authsize;
+	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
+	int rc = 0;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	bool is_gcm4543 = areq_ctx->is_gcm4543;
+	dma_addr_t dma_addr;
+	u32 mapped_nents = 0;
+	u32 dummy = 0; /*used for the assoc data fragments */
+	u32 size_to_map = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	mlli_params->curr_pool = NULL;
+	sg_data.num_of_buffers = 0;
+
+	/* copy mac to a temporary location to deal with possible
+	 * data memory overriding that caused by cache coherence problem.
+	 */
+	if (drvdata->coherent &&
+	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
+	    req->src == req->dst)
+		cc_copy_mac(dev, req, CC_SG_TO_BUF);
+
+	/* cacluate the size for cipher remove ICV in decrypt*/
+	areq_ctx->cryptlen = (areq_ctx->gen_ctx.op_type ==
+				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+				req->cryptlen :
+				(req->cryptlen - authsize);
+
+	dma_addr = dma_map_single(dev, areq_ctx->mac_buf, MAX_MAC_SIZE,
+				  DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, dma_addr)) {
+		dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
+			MAX_MAC_SIZE, areq_ctx->mac_buf);
+		rc = -ENOMEM;
+		goto aead_map_failure;
+	}
+	areq_ctx->mac_buf_dma_addr = dma_addr;
+
+	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
+		void *addr = areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
+
+		dma_addr = dma_map_single(dev, addr, AES_BLOCK_SIZE,
+					  DMA_TO_DEVICE);
+
+		if (dma_mapping_error(dev, dma_addr)) {
+			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, addr);
+			areq_ctx->ccm_iv0_dma_addr = 0;
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		areq_ctx->ccm_iv0_dma_addr = dma_addr;
+
+		if (cc_set_aead_conf_buf(dev, areq_ctx, areq_ctx->ccm_config,
+					 &sg_data, req->assoclen)) {
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+	}
+
+	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		dma_addr = dma_map_single(dev, areq_ctx->hkey, AES_BLOCK_SIZE,
+					  DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dev, dma_addr)) {
+			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, areq_ctx->hkey);
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		areq_ctx->hkey_dma_addr = dma_addr;
+
+		dma_addr = dma_map_single(dev, &areq_ctx->gcm_len_block,
+					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, dma_addr)) {
+			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		areq_ctx->gcm_block_len_dma_addr = dma_addr;
+
+		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc1,
+					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
+
+		if (dma_mapping_error(dev, dma_addr)) {
+			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
+			areq_ctx->gcm_iv_inc1_dma_addr = 0;
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		areq_ctx->gcm_iv_inc1_dma_addr = dma_addr;
+
+		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc2,
+					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
+
+		if (dma_mapping_error(dev, dma_addr)) {
+			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
+				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
+			areq_ctx->gcm_iv_inc2_dma_addr = 0;
+			rc = -ENOMEM;
+			goto aead_map_failure;
+		}
+		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
+	}
+
+	size_to_map = req->cryptlen + req->assoclen;
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
+		size_to_map += authsize;
+
+	if (is_gcm4543)
+		size_to_map += crypto_aead_ivsize(tfm);
+	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
+		       &areq_ctx->src.nents,
+		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
+			LLI_MAX_NUM_OF_DATA_ENTRIES),
+		       &dummy, &mapped_nents);
+	if (rc) {
+		rc = -ENOMEM;
+		goto aead_map_failure;
+	}
+
+	if (areq_ctx->is_single_pass) {
+		/*
+		 * Create MLLI table for:
+		 *   (1) Assoc. data
+		 *   (2) Src/Dst SGLs
+		 *   Note: IV is contg. buffer (not an SGL)
+		 */
+		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, true, false);
+		if (rc)
+			goto aead_map_failure;
+		rc = cc_aead_chain_iv(drvdata, req, &sg_data, true, false);
+		if (rc)
+			goto aead_map_failure;
+		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, false);
+		if (rc)
+			goto aead_map_failure;
+	} else { /* DOUBLE-PASS flow */
+		/*
+		 * Prepare MLLI table(s) in this order:
+		 *
+		 * If ENCRYPT/DECRYPT (inplace):
+		 *   (1) MLLI table for assoc
+		 *   (2) IV entry (chained right after end of assoc)
+		 *   (3) MLLI for src/dst (inplace operation)
+		 *
+		 * If ENCRYPT (non-inplace)
+		 *   (1) MLLI table for assoc
+		 *   (2) IV entry (chained right after end of assoc)
+		 *   (3) MLLI for dst
+		 *   (4) MLLI for src
+		 *
+		 * If DECRYPT (non-inplace)
+		 *   (1) MLLI table for assoc
+		 *   (2) IV entry (chained right after end of assoc)
+		 *   (3) MLLI for src
+		 *   (4) MLLI for dst
+		 */
+		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, false, true);
+		if (rc)
+			goto aead_map_failure;
+		rc = cc_aead_chain_iv(drvdata, req, &sg_data, false, true);
+		if (rc)
+			goto aead_map_failure;
+		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, true);
+		if (rc)
+			goto aead_map_failure;
+	}
+
+	/* Mlli support -start building the MLLI according to the above
+	 * results
+	 */
+	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
+	    areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
+		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
+		rc = cc_generate_mlli(dev, &sg_data, mlli_params, flags);
+		if (rc)
+			goto aead_map_failure;
+
+		cc_update_aead_mlli_nents(drvdata, req);
+		dev_dbg(dev, "assoc params mn %d\n",
+			areq_ctx->assoc.mlli_nents);
+		dev_dbg(dev, "src params mn %d\n", areq_ctx->src.mlli_nents);
+		dev_dbg(dev, "dst params mn %d\n", areq_ctx->dst.mlli_nents);
+	}
+	return 0;
+
+aead_map_failure:
+	cc_unmap_aead_request(dev, req);
+	return rc;
+}
+
+int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
+			      struct scatterlist *src, unsigned int nbytes,
+			      bool do_update, gfp_t flags)
+{
+	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
+	struct device *dev = drvdata_to_dev(drvdata);
+	u8 *curr_buff = cc_hash_buf(areq_ctx);
+	u32 *curr_buff_cnt = cc_hash_buf_cnt(areq_ctx);
+	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
+	struct buffer_array sg_data;
+	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
+	u32 dummy = 0;
+	u32 mapped_nents = 0;
+
+	dev_dbg(dev, "final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X src=%pK curr_index=%u\n",
+		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
+	/* Init the type of the dma buffer */
+	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
+	mlli_params->curr_pool = NULL;
+	sg_data.num_of_buffers = 0;
+	areq_ctx->in_nents = 0;
+
+	if (nbytes == 0 && *curr_buff_cnt == 0) {
+		/* nothing to do */
+		return 0;
+	}
+
+	/*TODO: copy data in case that buffer is enough for operation */
+	/* map the previous buffer */
+	if (*curr_buff_cnt) {
+		if (cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
+				    &sg_data)) {
+			return -ENOMEM;
+		}
+	}
+
+	if (src && nbytes > 0 && do_update) {
+		if (cc_map_sg(dev, src, nbytes, DMA_TO_DEVICE,
+			      &areq_ctx->in_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
+			      &dummy, &mapped_nents)) {
+			goto unmap_curr_buff;
+		}
+		if (src && mapped_nents == 1 &&
+		    areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
+			memcpy(areq_ctx->buff_sg, src,
+			       sizeof(struct scatterlist));
+			areq_ctx->buff_sg->length = nbytes;
+			areq_ctx->curr_sg = areq_ctx->buff_sg;
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
+		} else {
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_MLLI;
+		}
+	}
+
+	/*build mlli */
+	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_MLLI) {
+		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
+		/* add the src data to the sg_data */
+		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
+				0, true, &areq_ctx->mlli_nents);
+		if (cc_generate_mlli(dev, &sg_data, mlli_params, flags))
+			goto fail_unmap_din;
+	}
+	/* change the buffer index for the unmap function */
+	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
+	dev_dbg(dev, "areq_ctx->data_dma_buf_type = %s\n",
+		cc_dma_buf_type(areq_ctx->data_dma_buf_type));
+	return 0;
+
+fail_unmap_din:
+	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
+
+unmap_curr_buff:
+	if (*curr_buff_cnt)
+		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
+
+	return -ENOMEM;
+}
+
+int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
+			       struct scatterlist *src, unsigned int nbytes,
+			       unsigned int block_size, gfp_t flags)
+{
+	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
+	struct device *dev = drvdata_to_dev(drvdata);
+	u8 *curr_buff = cc_hash_buf(areq_ctx);
+	u32 *curr_buff_cnt = cc_hash_buf_cnt(areq_ctx);
+	u8 *next_buff = cc_next_buf(areq_ctx);
+	u32 *next_buff_cnt = cc_next_buf_cnt(areq_ctx);
+	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
+	unsigned int update_data_len;
+	u32 total_in_len = nbytes + *curr_buff_cnt;
+	struct buffer_array sg_data;
+	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
+	unsigned int swap_index = 0;
+	u32 dummy = 0;
+	u32 mapped_nents = 0;
+
+	dev_dbg(dev, " update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
+		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
+	/* Init the type of the dma buffer */
+	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
+	mlli_params->curr_pool = NULL;
+	areq_ctx->curr_sg = NULL;
+	sg_data.num_of_buffers = 0;
+	areq_ctx->in_nents = 0;
+
+	if (total_in_len < block_size) {
+		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
+			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
+		areq_ctx->in_nents =
+			cc_get_sgl_nents(dev, src, nbytes, &dummy, NULL);
+		sg_copy_to_buffer(src, areq_ctx->in_nents,
+				  &curr_buff[*curr_buff_cnt], nbytes);
+		*curr_buff_cnt += nbytes;
+		return 1;
+	}
+
+	/* Calculate the residue size*/
+	*next_buff_cnt = total_in_len & (block_size - 1);
+	/* update data len */
+	update_data_len = total_in_len - *next_buff_cnt;
+
+	dev_dbg(dev, " temp length : *next_buff_cnt=0x%X update_data_len=0x%X\n",
+		*next_buff_cnt, update_data_len);
+
+	/* Copy the new residue to next buffer */
+	if (*next_buff_cnt) {
+		dev_dbg(dev, " handle residue: next buff %pK skip data %u residue %u\n",
+			next_buff, (update_data_len - *curr_buff_cnt),
+			*next_buff_cnt);
+		cc_copy_sg_portion(dev, next_buff, src,
+				   (update_data_len - *curr_buff_cnt),
+				   nbytes, CC_SG_TO_BUF);
+		/* change the buffer index for next operation */
+		swap_index = 1;
+	}
+
+	if (*curr_buff_cnt) {
+		if (cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
+				    &sg_data)) {
+			return -ENOMEM;
+		}
+		/* change the buffer index for next operation */
+		swap_index = 1;
+	}
+
+	if (update_data_len > *curr_buff_cnt) {
+		if (cc_map_sg(dev, src, (update_data_len - *curr_buff_cnt),
+			      DMA_TO_DEVICE, &areq_ctx->in_nents,
+			      LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
+			      &mapped_nents)) {
+			goto unmap_curr_buff;
+		}
+		if (mapped_nents == 1 &&
+		    areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
+			/* only one entry in the SG and no previous data */
+			memcpy(areq_ctx->buff_sg, src,
+			       sizeof(struct scatterlist));
+			areq_ctx->buff_sg->length = update_data_len;
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
+			areq_ctx->curr_sg = areq_ctx->buff_sg;
+		} else {
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_MLLI;
+		}
+	}
+
+	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_MLLI) {
+		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
+		/* add the src data to the sg_data */
+		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
+				(update_data_len - *curr_buff_cnt), 0, true,
+				&areq_ctx->mlli_nents);
+		if (cc_generate_mlli(dev, &sg_data, mlli_params, flags))
+			goto fail_unmap_din;
+	}
+	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
+
+	return 0;
+
+fail_unmap_din:
+	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
+
+unmap_curr_buff:
+	if (*curr_buff_cnt)
+		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
+
+	return -ENOMEM;
+}
+
+void cc_unmap_hash_request(struct device *dev, void *ctx,
+			   struct scatterlist *src, bool do_revert)
+{
+	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
+	u32 *prev_len = cc_next_buf_cnt(areq_ctx);
+
+	/*In case a pool was set, a table was
+	 *allocated and should be released
+	 */
+	if (areq_ctx->mlli_params.curr_pool) {
+		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
+			&areq_ctx->mlli_params.mlli_dma_addr,
+			areq_ctx->mlli_params.mlli_virt_addr);
+		dma_pool_free(areq_ctx->mlli_params.curr_pool,
+			      areq_ctx->mlli_params.mlli_virt_addr,
+			      areq_ctx->mlli_params.mlli_dma_addr);
+	}
+
+	if (src && areq_ctx->in_nents) {
+		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
+			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
+		dma_unmap_sg(dev, src,
+			     areq_ctx->in_nents, DMA_TO_DEVICE);
+	}
+
+	if (*prev_len) {
+		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
+			sg_virt(areq_ctx->buff_sg),
+			&sg_dma_address(areq_ctx->buff_sg),
+			sg_dma_len(areq_ctx->buff_sg));
+		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
+		if (!do_revert) {
+			/* clean the previous data length for update
+			 * operation
+			 */
+			*prev_len = 0;
+		} else {
+			areq_ctx->buff_index ^= 1;
+		}
+	}
+}
+
+int cc_buffer_mgr_init(struct cc_drvdata *drvdata)
+{
+	struct buff_mgr_handle *buff_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	buff_mgr_handle = kmalloc(sizeof(*buff_mgr_handle), GFP_KERNEL);
+	if (!buff_mgr_handle)
+		return -ENOMEM;
+
+	drvdata->buff_mgr_handle = buff_mgr_handle;
+
+	buff_mgr_handle->mlli_buffs_pool =
+		dma_pool_create("dx_single_mlli_tables", dev,
+				MAX_NUM_OF_TOTAL_MLLI_ENTRIES *
+				LLI_ENTRY_BYTE_SIZE,
+				MLLI_TABLE_MIN_ALIGNMENT, 0);
+
+	if (!buff_mgr_handle->mlli_buffs_pool)
+		goto error;
+
+	return 0;
+
+error:
+	cc_buffer_mgr_fini(drvdata);
+	return -ENOMEM;
+}
+
+int cc_buffer_mgr_fini(struct cc_drvdata *drvdata)
+{
+	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
+
+	if (buff_mgr_handle) {
+		dma_pool_destroy(buff_mgr_handle->mlli_buffs_pool);
+		kfree(drvdata->buff_mgr_handle);
+		drvdata->buff_mgr_handle = NULL;
+	}
+	return 0;
+}
diff --git a/drivers/staging/ccree/cc_buffer_mgr.h b/drivers/staging/ccree/cc_buffer_mgr.h
new file mode 100644
index 0000000..99b752a
--- /dev/null
+++ b/drivers/staging/ccree/cc_buffer_mgr.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_buffer_mgr.h
+ * Buffer Manager
+ */
+
+#ifndef __CC_BUFFER_MGR_H__
+#define __CC_BUFFER_MGR_H__
+
+#include <crypto/algapi.h>
+
+#include "cc_driver.h"
+
+enum cc_req_dma_buf_type {
+	CC_DMA_BUF_NULL = 0,
+	CC_DMA_BUF_DLLI,
+	CC_DMA_BUF_MLLI
+};
+
+enum cc_sg_cpy_direct {
+	CC_SG_TO_BUF = 0,
+	CC_SG_FROM_BUF = 1
+};
+
+struct cc_mlli {
+	cc_sram_addr_t sram_addr;
+	unsigned int nents; //sg nents
+	unsigned int mlli_nents; //mlli nents might be different than the above
+};
+
+struct mlli_params {
+	struct dma_pool *curr_pool;
+	u8 *mlli_virt_addr;
+	dma_addr_t mlli_dma_addr;
+	u32 mlli_len;
+};
+
+int cc_buffer_mgr_init(struct cc_drvdata *drvdata);
+
+int cc_buffer_mgr_fini(struct cc_drvdata *drvdata);
+
+int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
+			     unsigned int ivsize, unsigned int nbytes,
+			     void *info, struct scatterlist *src,
+			     struct scatterlist *dst, gfp_t flags);
+
+void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
+				unsigned int ivsize,
+				struct scatterlist *src,
+				struct scatterlist *dst);
+
+int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req);
+
+void cc_unmap_aead_request(struct device *dev, struct aead_request *req);
+
+int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
+			      struct scatterlist *src, unsigned int nbytes,
+			      bool do_update, gfp_t flags);
+
+int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
+			       struct scatterlist *src, unsigned int nbytes,
+			       unsigned int block_size, gfp_t flags);
+
+void cc_unmap_hash_request(struct device *dev, void *ctx,
+			   struct scatterlist *src, bool do_revert);
+
+void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
+			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct);
+
+void cc_zero_sgl(struct scatterlist *sgl, u32 data_len);
+
+#endif /*__BUFFER_MGR_H__*/
+
diff --git a/drivers/staging/ccree/cc_cipher.c b/drivers/staging/ccree/cc_cipher.c
new file mode 100644
index 0000000..eca0578
--- /dev/null
+++ b/drivers/staging/ccree/cc_cipher.c
@@ -0,0 +1,1171 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
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
+#include <crypto/xts.h>
+#include <crypto/scatterwalk.h>
+
+#include "cc_driver.h"
+#include "cc_lli_defs.h"
+#include "cc_buffer_mgr.h"
+#include "cc_cipher.h"
+#include "cc_request_mgr.h"
+
+#define MAX_ABLKCIPHER_SEQ_LEN 6
+
+#define template_ablkcipher	template_u.ablkcipher
+
+#define CC_MIN_AES_XTS_SIZE 0x10
+#define CC_MAX_AES_XTS_SIZE 0x2000
+struct cc_cipher_handle {
+	struct list_head blkcipher_alg_list;
+};
+
+struct cc_user_key_info {
+	u8 *key;
+	dma_addr_t key_dma_addr;
+};
+
+struct cc_hw_key_info {
+	enum cc_hw_crypto_key key1_slot;
+	enum cc_hw_crypto_key key2_slot;
+};
+
+struct cc_cipher_ctx {
+	struct cc_drvdata *drvdata;
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
+static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
+
+static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
+{
+	switch (ctx_p->flow_mode) {
+	case S_DIN_to_AES:
+		switch (size) {
+		case CC_AES_128_BIT_KEY_SIZE:
+		case CC_AES_192_BIT_KEY_SIZE:
+			if (ctx_p->cipher_mode != DRV_CIPHER_XTS &&
+			    ctx_p->cipher_mode != DRV_CIPHER_ESSIV &&
+			    ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)
+				return 0;
+			break;
+		case CC_AES_256_BIT_KEY_SIZE:
+			return 0;
+		case (CC_AES_192_BIT_KEY_SIZE * 2):
+		case (CC_AES_256_BIT_KEY_SIZE * 2):
+			if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+			    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+			    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)
+				return 0;
+			break;
+		default:
+			break;
+		}
+	case S_DIN_to_DES:
+		if (size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE)
+			return 0;
+		break;
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static int validate_data_size(struct cc_cipher_ctx *ctx_p,
+			      unsigned int size)
+{
+	switch (ctx_p->flow_mode) {
+	case S_DIN_to_AES:
+		switch (ctx_p->cipher_mode) {
+		case DRV_CIPHER_XTS:
+			if (size >= CC_MIN_AES_XTS_SIZE &&
+			    size <= CC_MAX_AES_XTS_SIZE &&
+			    IS_ALIGNED(size, AES_BLOCK_SIZE))
+				return 0;
+			break;
+		case DRV_CIPHER_CBC_CTS:
+			if (size >= AES_BLOCK_SIZE)
+				return 0;
+			break;
+		case DRV_CIPHER_OFB:
+		case DRV_CIPHER_CTR:
+				return 0;
+		case DRV_CIPHER_ECB:
+		case DRV_CIPHER_CBC:
+		case DRV_CIPHER_ESSIV:
+		case DRV_CIPHER_BITLOCKER:
+			if (IS_ALIGNED(size, AES_BLOCK_SIZE))
+				return 0;
+			break;
+		default:
+			break;
+		}
+		break;
+	case S_DIN_to_DES:
+		if (IS_ALIGNED(size, DES_BLOCK_SIZE))
+			return 0;
+		break;
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static unsigned int get_max_keysize(struct crypto_tfm *tfm)
+{
+	struct cc_crypto_alg *cc_alg =
+		container_of(tfm->__crt_alg, struct cc_crypto_alg,
+			     crypto_alg);
+
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_ABLKCIPHER)
+		return cc_alg->crypto_alg.cra_ablkcipher.max_keysize;
+
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return cc_alg->crypto_alg.cra_blkcipher.max_keysize;
+
+	return 0;
+}
+
+static int cc_cipher_init(struct crypto_tfm *tfm)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct cc_crypto_alg *cc_alg =
+			container_of(alg, struct cc_crypto_alg, crypto_alg);
+	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
+	int rc = 0;
+	unsigned int max_key_buf_size = get_max_keysize(tfm);
+	struct ablkcipher_tfm *ablktfm = &tfm->crt_ablkcipher;
+
+	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
+		crypto_tfm_alg_name(tfm));
+
+	ablktfm->reqsize = sizeof(struct blkcipher_req_ctx);
+
+	ctx_p->cipher_mode = cc_alg->cipher_mode;
+	ctx_p->flow_mode = cc_alg->flow_mode;
+	ctx_p->drvdata = cc_alg->drvdata;
+
+	/* Allocate key buffer, cache line aligned */
+	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
+	if (!ctx_p->user.key)
+		return -ENOMEM;
+
+	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
+		ctx_p->user.key);
+
+	/* Map key buffer */
+	ctx_p->user.key_dma_addr = dma_map_single(dev, (void *)ctx_p->user.key,
+						  max_key_buf_size,
+						  DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
+		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
+			max_key_buf_size, ctx_p->user.key);
+		return -ENOMEM;
+	}
+	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
+		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
+
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Alloc hash tfm for essiv */
+		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
+		if (IS_ERR(ctx_p->shash_tfm)) {
+			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
+			return PTR_ERR(ctx_p->shash_tfm);
+		}
+	}
+
+	return rc;
+}
+
+static void cc_cipher_exit(struct crypto_tfm *tfm)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	unsigned int max_key_buf_size = get_max_keysize(tfm);
+
+	dev_dbg(dev, "Clearing context @%p for %s\n",
+		crypto_tfm_ctx(tfm), crypto_tfm_alg_name(tfm));
+
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Free hash tfm for essiv */
+		crypto_free_shash(ctx_p->shash_tfm);
+		ctx_p->shash_tfm = NULL;
+	}
+
+	/* Unmap key buffer */
+	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
+			 DMA_TO_DEVICE);
+	dev_dbg(dev, "Unmapped key buffer key_dma_addr=%pad\n",
+		&ctx_p->user.key_dma_addr);
+
+	/* Free key buffer in context */
+	kfree(ctx_p->user.key);
+	dev_dbg(dev, "Free key buffer in context. key=@%p\n", ctx_p->user.key);
+}
+
+struct tdes_keys {
+	u8	key1[DES_KEY_SIZE];
+	u8	key2[DES_KEY_SIZE];
+	u8	key3[DES_KEY_SIZE];
+};
+
+static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
+
+/* The function verifies that tdes keys are not weak.*/
+static int cc_verify_3des_keys(const u8 *key, unsigned int keylen)
+{
+	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
+
+	/* verify key1 != key2 and key3 != key2*/
+	if ((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
+		    sizeof(tdes_key->key1)) == 0) ||
+	    (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
+		    sizeof(tdes_key->key3)) == 0)) {
+		return -ENOEXEC;
+	}
+
+	return 0;
+}
+
+static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
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
+static int cc_cipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(atfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	u32 tmp[DES_EXPKEY_WORDS];
+	unsigned int max_key_buf_size = get_max_keysize(tfm);
+
+	dev_dbg(dev, "Setting key in context @%p for %s. keylen=%u\n",
+		ctx_p, crypto_tfm_alg_name(tfm), keylen);
+	dump_byte_array("key", (u8 *)key, keylen);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+
+	if (validate_keys_sizes(ctx_p, keylen)) {
+		dev_err(dev, "Unsupported key size %d.\n", keylen);
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (cc_is_hw_key(tfm)) {
+		/* setting HW key slots */
+		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
+
+		if (ctx_p->flow_mode != S_DIN_to_AES) {
+			dev_err(dev, "HW key not supported for non-AES flows\n");
+			return -EINVAL;
+		}
+
+		ctx_p->hw.key1_slot = hw_key_to_cc_hw_key(hki->hw_key1);
+		if (ctx_p->hw.key1_slot == END_OF_KEYS) {
+			dev_err(dev, "Unsupported hw key1 number (%d)\n",
+				hki->hw_key1);
+			return -EINVAL;
+		}
+
+		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
+			if (hki->hw_key1 == hki->hw_key2) {
+				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
+					hki->hw_key1, hki->hw_key2);
+				return -EINVAL;
+			}
+			ctx_p->hw.key2_slot =
+				hw_key_to_cc_hw_key(hki->hw_key2);
+			if (ctx_p->hw.key2_slot == END_OF_KEYS) {
+				dev_err(dev, "Unsupported hw key2 number (%d)\n",
+					hki->hw_key2);
+				return -EINVAL;
+			}
+		}
+
+		ctx_p->keylen = keylen;
+		dev_dbg(dev, "cc_is_hw_key ret 0");
+
+		return 0;
+	}
+
+	// verify weak keys
+	if (ctx_p->flow_mode == S_DIN_to_DES) {
+		if (!des_ekey(tmp, key) &&
+		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+			dev_dbg(dev, "weak DES key");
+			return -EINVAL;
+		}
+	}
+	if (ctx_p->cipher_mode == DRV_CIPHER_XTS &&
+	    xts_check_key(tfm, key, keylen)) {
+		dev_dbg(dev, "weak XTS key");
+		return -EINVAL;
+	}
+	if (ctx_p->flow_mode == S_DIN_to_DES &&
+	    keylen == DES3_EDE_KEY_SIZE &&
+	    cc_verify_3des_keys(key, keylen)) {
+		dev_dbg(dev, "weak 3DES key");
+		return -EINVAL;
+	}
+
+	/* STAT_PHASE_1: Copy key to ctx */
+	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
+				max_key_buf_size, DMA_TO_DEVICE);
+
+	memcpy(ctx_p->user.key, key, keylen);
+	if (keylen == 24)
+		memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* sha256 for key2 - use sw implementation */
+		int key_len = keylen >> 1;
+		int err;
+
+		SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
+
+		desc->tfm = ctx_p->shash_tfm;
+
+		err = crypto_shash_digest(desc, ctx_p->user.key, key_len,
+					  ctx_p->user.key + key_len);
+		if (err) {
+			dev_err(dev, "Failed to hash ESSIV key.\n");
+			return err;
+		}
+	}
+	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
+				   max_key_buf_size, DMA_TO_DEVICE);
+	ctx_p->keylen = keylen;
+
+	 dev_dbg(dev, "return safely");
+	return 0;
+}
+
+static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
+				 struct blkcipher_req_ctx *req_ctx,
+				 unsigned int ivsize, unsigned int nbytes,
+				 struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	int cipher_mode = ctx_p->cipher_mode;
+	int flow_mode = ctx_p->flow_mode;
+	int direction = req_ctx->gen_ctx.op_type;
+	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
+	unsigned int key_len = ctx_p->keylen;
+	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
+	unsigned int du_size = nbytes;
+
+	struct cc_crypto_alg *cc_alg =
+		container_of(tfm->__crt_alg, struct cc_crypto_alg,
+			     crypto_alg);
+
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
+	    CRYPTO_ALG_BULK_DU_512)
+		du_size = 512;
+	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
+	    CRYPTO_ALG_BULK_DU_4096)
+		du_size = 4096;
+
+	switch (cipher_mode) {
+	case DRV_CIPHER_CBC:
+	case DRV_CIPHER_CBC_CTS:
+	case DRV_CIPHER_CTR:
+	case DRV_CIPHER_OFB:
+		/* Load cipher state */
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr, ivsize,
+			     NS_BIT);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		if (cipher_mode == DRV_CIPHER_CTR ||
+		    cipher_mode == DRV_CIPHER_OFB) {
+			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
+		} else {
+			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
+		}
+		(*seq_size)++;
+		/*FALLTHROUGH*/
+	case DRV_CIPHER_ECB:
+		/* Load key */
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		if (flow_mode == S_DIN_to_AES) {
+			if (cc_is_hw_key(tfm)) {
+				set_hw_crypto_key(&desc[*seq_size],
+						  ctx_p->hw.key1_slot);
+			} else {
+				set_din_type(&desc[*seq_size], DMA_DLLI,
+					     key_dma_addr, ((key_len == 24) ?
+							    AES_MAX_KEY_SIZE :
+							    key_len), NS_BIT);
+			}
+			set_key_size_aes(&desc[*seq_size], key_len);
+		} else {
+			/*des*/
+			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
+				     key_len, NS_BIT);
+			set_key_size_des(&desc[*seq_size], key_len);
+		}
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
+		(*seq_size)++;
+		break;
+	case DRV_CIPHER_XTS:
+	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
+		/* Load AES key */
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		if (cc_is_hw_key(tfm)) {
+			set_hw_crypto_key(&desc[*seq_size],
+					  ctx_p->hw.key1_slot);
+		} else {
+			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
+				     (key_len / 2), NS_BIT);
+		}
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
+		(*seq_size)++;
+
+		/* load XEX key */
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		if (cc_is_hw_key(tfm)) {
+			set_hw_crypto_key(&desc[*seq_size],
+					  ctx_p->hw.key2_slot);
+		} else {
+			set_din_type(&desc[*seq_size], DMA_DLLI,
+				     (key_dma_addr + (key_len / 2)),
+				     (key_len / 2), NS_BIT);
+		}
+		set_xex_data_unit_size(&desc[*seq_size], du_size);
+		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
+		(*seq_size)++;
+
+		/* Set state */
+		hw_desc_init(&desc[*seq_size]);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
+			     CC_AES_BLOCK_SIZE, NS_BIT);
+		(*seq_size)++;
+		break;
+	default:
+		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
+	}
+}
+
+static void cc_setup_cipher_data(struct crypto_tfm *tfm,
+				 struct blkcipher_req_ctx *req_ctx,
+				 struct scatterlist *dst,
+				 struct scatterlist *src, unsigned int nbytes,
+				 void *areq, struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	unsigned int flow_mode = ctx_p->flow_mode;
+
+	switch (ctx_p->flow_mode) {
+	case S_DIN_to_AES:
+		flow_mode = DIN_AES_DOUT;
+		break;
+	case S_DIN_to_DES:
+		flow_mode = DIN_DES_DOUT;
+		break;
+	default:
+		dev_err(dev, "invalid flow mode, flow_mode = %d\n", flow_mode);
+		return;
+	}
+	/* Process */
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_DLLI) {
+		dev_dbg(dev, " data params addr %pad length 0x%X\n",
+			&sg_dma_address(src), nbytes);
+		dev_dbg(dev, " data params addr %pad length 0x%X\n",
+			&sg_dma_address(dst), nbytes);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
+			     nbytes, NS_BIT);
+		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
+			      nbytes, NS_BIT, (!areq ? 0 : 1));
+		if (areq)
+			set_queue_last_ind(&desc[*seq_size]);
+
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		(*seq_size)++;
+	} else {
+		/* bypass */
+		dev_dbg(dev, " bypass params addr %pad length 0x%X addr 0x%08X\n",
+			&req_ctx->mlli_params.mlli_dma_addr,
+			req_ctx->mlli_params.mlli_len,
+			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI,
+			     req_ctx->mlli_params.mlli_dma_addr,
+			     req_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[*seq_size],
+			      ctx_p->drvdata->mlli_sram_addr,
+			      req_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[*seq_size], BYPASS);
+		(*seq_size)++;
+
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_MLLI,
+			     ctx_p->drvdata->mlli_sram_addr,
+			     req_ctx->in_mlli_nents, NS_BIT);
+		if (req_ctx->out_nents == 0) {
+			dev_dbg(dev, " din/dout params addr 0x%08X addr 0x%08X\n",
+				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
+				(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+			set_dout_mlli(&desc[*seq_size],
+				      ctx_p->drvdata->mlli_sram_addr,
+				      req_ctx->in_mlli_nents, NS_BIT,
+				      (!areq ? 0 : 1));
+		} else {
+			dev_dbg(dev, " din/dout params addr 0x%08X addr 0x%08X\n",
+				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
+				(unsigned int)ctx_p->drvdata->mlli_sram_addr +
+				(u32)LLI_ENTRY_BYTE_SIZE * req_ctx->in_nents);
+			set_dout_mlli(&desc[*seq_size],
+				      (ctx_p->drvdata->mlli_sram_addr +
+				       (LLI_ENTRY_BYTE_SIZE *
+					req_ctx->in_mlli_nents)),
+				      req_ctx->out_mlli_nents, NS_BIT,
+				      (!areq ? 0 : 1));
+		}
+		if (areq)
+			set_queue_last_ind(&desc[*seq_size]);
+
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		(*seq_size)++;
+	}
+}
+
+static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
+{
+	struct ablkcipher_request *areq = (struct ablkcipher_request *)cc_req;
+	struct scatterlist *dst = areq->dst;
+	struct scatterlist *src = areq->src;
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
+	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
+
+	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	kfree(req_ctx->iv);
+
+	/*
+	 * The crypto API expects us to set the req->info to the last
+	 * ciphertext block. For encrypt, simply copy from the result.
+	 * For decrypt, we must copy from a saved buffer since this
+	 * could be an in-place decryption operation and the src is
+	 * lost by this point.
+	 */
+	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
+		memcpy(req->info, req_ctx->backup_info, ivsize);
+		kfree(req_ctx->backup_info);
+	} else if (!err) {
+		scatterwalk_map_and_copy(req->info, req->dst,
+					 (req->nbytes - ivsize),
+					 ivsize, 0);
+	}
+
+	ablkcipher_request_complete(areq, err);
+}
+
+static int cc_cipher_process(struct ablkcipher_request *req,
+			     enum drv_crypto_direction direction)
+{
+	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
+	struct scatterlist *dst = req->dst;
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	void *info = req->info;
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
+	struct cc_crypto_req cc_req = {};
+	int rc, seq_len = 0, cts_restore_flag = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "%s req=%p info=%p nbytes=%d\n",
+		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+		"Encrypt" : "Decrypt"), req, info, nbytes);
+
+	/* STAT_PHASE_0: Init and sanity checks */
+
+	/* TODO: check data length according to mode */
+	if (validate_data_size(ctx_p, nbytes)) {
+		dev_err(dev, "Unsupported data size %d.\n", nbytes);
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
+		rc = -EINVAL;
+		goto exit_process;
+	}
+	if (nbytes == 0) {
+		/* No data to process is valid */
+		rc = 0;
+		goto exit_process;
+	}
+
+	/* The IV we are handed may be allocted from the stack so
+	 * we must copy it to a DMAable buffer before use.
+	 */
+	req_ctx->iv = kmalloc(ivsize, flags);
+	if (!req_ctx->iv) {
+		rc = -ENOMEM;
+		goto exit_process;
+	}
+	memcpy(req_ctx->iv, info, ivsize);
+
+	/*For CTS in case of data size aligned to 16 use CBC mode*/
+	if (((nbytes % AES_BLOCK_SIZE) == 0) &&
+	    ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
+		ctx_p->cipher_mode = DRV_CIPHER_CBC;
+		cts_restore_flag = 1;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = (void *)cc_cipher_complete;
+	cc_req.user_arg = (void *)req;
+
+#ifdef ENABLE_CYCLE_COUNT
+	cc_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
+		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
+
+#endif
+
+	/* Setup request context */
+	req_ctx->gen_ctx.op_type = direction;
+
+	/* STAT_PHASE_1: Map buffers */
+
+	rc = cc_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes,
+				      req_ctx->iv, src, dst, flags);
+	if (rc) {
+		dev_err(dev, "map_request() failed\n");
+		goto exit_process;
+	}
+
+	/* STAT_PHASE_2: Create sequence */
+
+	/* Setup processing */
+	cc_setup_cipher_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
+	/* Data processing */
+	cc_setup_cipher_data(tfm, req_ctx, dst, src, nbytes, req, desc,
+			     &seq_len);
+
+	/* do we need to generate IV? */
+	if (req_ctx->is_giv) {
+		cc_req.ivgen_dma_addr[0] = req_ctx->gen_ctx.iv_dma_addr;
+		cc_req.ivgen_dma_addr_len = 1;
+		/* set the IV size (8/16 B long)*/
+		cc_req.ivgen_size = ivsize;
+	}
+
+	/* STAT_PHASE_3: Lock HW and push sequence */
+
+	rc = cc_send_request(ctx_p->drvdata, &cc_req, desc, seq_len,
+			     &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		/* Failed to send the request or request completed
+		 * synchronously
+		 */
+		cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	}
+
+exit_process:
+	if (cts_restore_flag)
+		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
+
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		kfree(req_ctx->backup_info);
+		kfree(req_ctx->iv);
+	}
+
+	return rc;
+}
+
+static int cc_cipher_encrypt(struct ablkcipher_request *req)
+{
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+
+	req_ctx->is_giv = false;
+	req_ctx->backup_info = NULL;
+
+	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+}
+
+static int cc_cipher_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
+	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	/*
+	 * Allocate and save the last IV sized bytes of the source, which will
+	 * be lost in case of in-place decryption and might be needed for CTS.
+	 */
+	req_ctx->backup_info = kmalloc(ivsize, flags);
+	if (!req_ctx->backup_info)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(req_ctx->backup_info, req->src,
+				 (req->nbytes - ivsize), ivsize, 0);
+	req_ctx->is_giv = false;
+
+	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+}
+
+/* DX Block cipher alg */
+static struct cc_alg_template blkcipher_algs[] = {
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			.geniv = "eseqiv",
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-du512-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-du4096-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "essiv(aes)",
+		.driver_name = "essiv-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "essiv(aes)",
+		.driver_name = "essiv-aes-du512-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "essiv(aes)",
+		.driver_name = "essiv-aes-du4096-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "bitlocker(aes)",
+		.driver_name = "bitlocker-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "bitlocker(aes)",
+		.driver_name = "bitlocker-aes-du512-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "bitlocker(aes)",
+		.driver_name = "bitlocker-aes-du4096-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE * 2,
+			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "ecb(aes)",
+		.driver_name = "ecb-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "cbc(aes)",
+		.driver_name = "cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "ofb(aes)",
+		.driver_name = "ofb-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_OFB,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "cts1(cbc(aes))",
+		.driver_name = "cts1-cbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC_CTS,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "ctr(aes)",
+		.driver_name = "ctr-aes-dx",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+	},
+	{
+		.name = "cbc(des3_ede)",
+		.driver_name = "cbc-3des-dx",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_DES,
+	},
+	{
+		.name = "ecb(des3_ede)",
+		.driver_name = "ecb-3des-dx",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_DES,
+	},
+	{
+		.name = "cbc(des)",
+		.driver_name = "cbc-des-dx",
+		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_DES,
+	},
+	{
+		.name = "ecb(des)",
+		.driver_name = "ecb-des-dx",
+		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_DES,
+	},
+};
+
+static
+struct cc_crypto_alg *cc_cipher_create_alg(struct cc_alg_template *template,
+					   struct device *dev)
+{
+	struct cc_crypto_alg *t_alg;
+	struct crypto_alg *alg;
+
+	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
+	if (!t_alg)
+		return ERR_PTR(-ENOMEM);
+
+	alg = &t_alg->crypto_alg;
+
+	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
+	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 template->driver_name);
+	alg->cra_module = THIS_MODULE;
+	alg->cra_priority = CC_CRA_PRIO;
+	alg->cra_blocksize = template->blocksize;
+	alg->cra_alignmask = 0;
+	alg->cra_ctxsize = sizeof(struct cc_cipher_ctx);
+
+	alg->cra_init = cc_cipher_init;
+	alg->cra_exit = cc_cipher_exit;
+	alg->cra_type = &crypto_ablkcipher_type;
+	alg->cra_ablkcipher = template->template_ablkcipher;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+				template->type;
+
+	t_alg->cipher_mode = template->cipher_mode;
+	t_alg->flow_mode = template->flow_mode;
+
+	return t_alg;
+}
+
+int cc_cipher_free(struct cc_drvdata *drvdata)
+{
+	struct cc_crypto_alg *t_alg, *n;
+	struct cc_cipher_handle *blkcipher_handle =
+						drvdata->blkcipher_handle;
+	if (blkcipher_handle) {
+		/* Remove registered algs */
+		list_for_each_entry_safe(t_alg, n,
+					 &blkcipher_handle->blkcipher_alg_list,
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
+int cc_cipher_alloc(struct cc_drvdata *drvdata)
+{
+	struct cc_cipher_handle *ablkcipher_handle;
+	struct cc_crypto_alg *t_alg;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc = -ENOMEM;
+	int alg;
+
+	ablkcipher_handle = kmalloc(sizeof(*ablkcipher_handle), GFP_KERNEL);
+	if (!ablkcipher_handle)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ablkcipher_handle->blkcipher_alg_list);
+	drvdata->blkcipher_handle = ablkcipher_handle;
+
+	/* Linux crypto */
+	dev_dbg(dev, "Number of algorithms = %zu\n",
+		ARRAY_SIZE(blkcipher_algs));
+	for (alg = 0; alg < ARRAY_SIZE(blkcipher_algs); alg++) {
+		dev_dbg(dev, "creating %s\n", blkcipher_algs[alg].driver_name);
+		t_alg = cc_cipher_create_alg(&blkcipher_algs[alg], dev);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			dev_err(dev, "%s alg allocation failed\n",
+				blkcipher_algs[alg].driver_name);
+			goto fail0;
+		}
+		t_alg->drvdata = drvdata;
+
+		dev_dbg(dev, "registering %s\n",
+			blkcipher_algs[alg].driver_name);
+		rc = crypto_register_alg(&t_alg->crypto_alg);
+		dev_dbg(dev, "%s alg registration rc = %x\n",
+			t_alg->crypto_alg.cra_driver_name, rc);
+		if (rc) {
+			dev_err(dev, "%s alg registration failed\n",
+				t_alg->crypto_alg.cra_driver_name);
+			kfree(t_alg);
+			goto fail0;
+		} else {
+			list_add_tail(&t_alg->entry,
+				      &ablkcipher_handle->blkcipher_alg_list);
+			dev_dbg(dev, "Registered %s\n",
+				t_alg->crypto_alg.cra_driver_name);
+		}
+	}
+	return 0;
+
+fail0:
+	cc_cipher_free(drvdata);
+	return rc;
+}
diff --git a/drivers/staging/ccree/cc_cipher.h b/drivers/staging/ccree/cc_cipher.h
new file mode 100644
index 0000000..4c181c7
--- /dev/null
+++ b/drivers/staging/ccree/cc_cipher.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_cipher.h
+ * ARM CryptoCell Cipher Crypto API
+ */
+
+#ifndef __CC_CIPHER_H__
+#define __CC_CIPHER_H__
+
+#include <linux/kernel.h>
+#include <crypto/algapi.h>
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+
+/* Crypto cipher flags */
+#define CC_CRYPTO_CIPHER_KEY_KFDE0	BIT(0)
+#define CC_CRYPTO_CIPHER_KEY_KFDE1	BIT(1)
+#define CC_CRYPTO_CIPHER_KEY_KFDE2	BIT(2)
+#define CC_CRYPTO_CIPHER_KEY_KFDE3	BIT(3)
+#define CC_CRYPTO_CIPHER_DU_SIZE_512B	BIT(4)
+
+#define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | \
+					CC_CRYPTO_CIPHER_KEY_KFDE1 | \
+					CC_CRYPTO_CIPHER_KEY_KFDE2 | \
+					CC_CRYPTO_CIPHER_KEY_KFDE3)
+
+struct blkcipher_req_ctx {
+	struct async_gen_req_ctx gen_ctx;
+	enum cc_req_dma_buf_type dma_buf_type;
+	u32 in_nents;
+	u32 in_mlli_nents;
+	u32 out_nents;
+	u32 out_mlli_nents;
+	u8 *backup_info; /*store iv for generated IV flow*/
+	u8 *iv;
+	bool is_giv;
+	struct mlli_params mlli_params;
+};
+
+int cc_cipher_alloc(struct cc_drvdata *drvdata);
+
+int cc_cipher_free(struct cc_drvdata *drvdata);
+
+#ifndef CRYPTO_ALG_BULK_MASK
+
+#define CRYPTO_ALG_BULK_DU_512	0x00002000
+#define CRYPTO_ALG_BULK_DU_4096	0x00004000
+#define CRYPTO_ALG_BULK_MASK	(CRYPTO_ALG_BULK_DU_512 |\
+				CRYPTO_ALG_BULK_DU_4096)
+#endif /* CRYPTO_ALG_BULK_MASK */
+
+#ifdef CRYPTO_TFM_REQ_HW_KEY
+
+static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
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
+static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
+{
+	return false;
+}
+
+#endif /* CRYPTO_TFM_REQ_HW_KEY */
+
+#endif /*__CC_CIPHER_H__*/
diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index 72eb2b3..f927a73 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
 #include <linux/stringify.h>
-#include "ssi_driver.h"
+#include "cc_driver.h"
 #include "cc_crypto_ctx.h"
 
 struct cc_debugfs_ctx {
diff --git a/drivers/staging/ccree/cc_driver.c b/drivers/staging/ccree/cc_driver.c
new file mode 100644
index 0000000..98d491e
--- /dev/null
+++ b/drivers/staging/ccree/cc_driver.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
+
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/random.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/fcntl.h>
+#include <linux/poll.h>
+#include <linux/proc_fs.h>
+#include <linux/mutex.h>
+#include <linux/sysctl.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/platform_device.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/pm.h>
+
+/* cache.h required for L1_CACHE_ALIGN() and cache_line_size() */
+#include <linux/cache.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/of_address.h>
+
+#include "cc_driver.h"
+#include "cc_request_mgr.h"
+#include "cc_buffer_mgr.h"
+#include "cc_debugfs.h"
+#include "cc_cipher.h"
+#include "cc_aead.h"
+#include "cc_hash.h"
+#include "cc_ivgen.h"
+#include "cc_sram_mgr.h"
+#include "cc_pm.h"
+#include "cc_fips.h"
+
+bool cc_dump_desc;
+module_param_named(dump_desc, cc_dump_desc, bool, 0600);
+MODULE_PARM_DESC(cc_dump_desc, "Dump descriptors to kernel log as debugging aid");
+
+bool cc_dump_bytes;
+module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
+MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
+
+void __dump_byte_array(const char *name, const u8 *buf, size_t len)
+{
+	char prefix[64];
+
+	if (!buf)
+		return;
+
+	snprintf(prefix, sizeof(prefix), "%s[%zu]: ", name, len);
+
+	print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_ADDRESS, 16, 1, buf,
+		       len, false);
+}
+
+static irqreturn_t cc_isr(int irq, void *dev_id)
+{
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)dev_id;
+	struct device *dev = drvdata_to_dev(drvdata);
+	u32 irr;
+	u32 imr;
+
+	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
+
+	/* read the interrupt status */
+	irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
+	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
+	if (irr == 0) { /* Probably shared interrupt line */
+		dev_err(dev, "Got interrupt with empty IRR\n");
+		return IRQ_NONE;
+	}
+	imr = cc_ioread(drvdata, CC_REG(HOST_IMR));
+
+	/* clear interrupt - must be before processing events */
+	cc_iowrite(drvdata, CC_REG(HOST_ICR), irr);
+
+	drvdata->irq = irr;
+	/* Completion interrupt - most probable */
+	if (irr & CC_COMP_IRQ_MASK) {
+		/* Mask AXI completion interrupt - will be unmasked in
+		 * Deferred service handler
+		 */
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_COMP_IRQ_MASK);
+		irr &= ~CC_COMP_IRQ_MASK;
+		complete_request(drvdata);
+	}
+#ifdef CONFIG_CRYPTO_FIPS
+	/* TEE FIPS interrupt */
+	if (irr & CC_GPR0_IRQ_MASK) {
+		/* Mask interrupt - will be unmasked in Deferred service
+		 * handler
+		 */
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_GPR0_IRQ_MASK);
+		irr &= ~CC_GPR0_IRQ_MASK;
+		fips_handler(drvdata);
+	}
+#endif
+	/* AXI error interrupt */
+	if (irr & CC_AXI_ERR_IRQ_MASK) {
+		u32 axi_err;
+
+		/* Read the AXI error ID */
+		axi_err = cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
+		dev_dbg(dev, "AXI completion error: axim_mon_err=0x%08X\n",
+			axi_err);
+
+		irr &= ~CC_AXI_ERR_IRQ_MASK;
+	}
+
+	if (irr) {
+		dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
+			irr);
+		/* Just warning */
+	}
+
+	return IRQ_HANDLED;
+}
+
+int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
+{
+	unsigned int val, cache_params;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/* Unmask all AXI interrupt sources AXI_CFG1 register */
+	val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
+	cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~CC_AXI_IRQ_MASK);
+	dev_dbg(dev, "AXIM_CFG=0x%08X\n",
+		cc_ioread(drvdata, CC_REG(AXIM_CFG)));
+
+	/* Clear all pending interrupts */
+	val = cc_ioread(drvdata, CC_REG(HOST_IRR));
+	dev_dbg(dev, "IRR=0x%08X\n", val);
+	cc_iowrite(drvdata, CC_REG(HOST_ICR), val);
+
+	/* Unmask relevant interrupt cause */
+	val = (unsigned int)(~(CC_COMP_IRQ_MASK | CC_AXI_ERR_IRQ_MASK |
+			       CC_GPR0_IRQ_MASK));
+	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
+
+	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
+
+	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
+
+	if (is_probe)
+		dev_info(dev, "Cache params previous: 0x%08X\n", val);
+
+	cc_iowrite(drvdata, CC_REG(AXIM_CACHE_PARAMS), cache_params);
+	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
+
+	if (is_probe)
+		dev_info(dev, "Cache params current: 0x%08X (expect: 0x%08X)\n",
+			 val, cache_params);
+
+	return 0;
+}
+
+static int init_cc_resources(struct platform_device *plat_dev)
+{
+	struct resource *req_mem_cc_regs = NULL;
+	struct cc_drvdata *new_drvdata;
+	struct device *dev = &plat_dev->dev;
+	struct device_node *np = dev->of_node;
+	u32 signature_val;
+	dma_addr_t dma_mask;
+	int rc = 0;
+
+	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
+	if (!new_drvdata)
+		return -ENOMEM;
+
+	platform_set_drvdata(plat_dev, new_drvdata);
+	new_drvdata->plat_dev = plat_dev;
+
+	new_drvdata->clk = of_clk_get(np, 0);
+	new_drvdata->coherent = of_dma_is_coherent(np);
+
+	/* Get device resources */
+	/* First CC registers space */
+	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	/* Map registers space */
+	new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
+	if (IS_ERR(new_drvdata->cc_base)) {
+		dev_err(dev, "Failed to ioremap registers");
+		return PTR_ERR(new_drvdata->cc_base);
+	}
+
+	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
+		req_mem_cc_regs);
+	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
+		&req_mem_cc_regs->start, new_drvdata->cc_base);
+
+	/* Then IRQ */
+	new_drvdata->irq = platform_get_irq(plat_dev, 0);
+	if (new_drvdata->irq < 0) {
+		dev_err(dev, "Failed getting IRQ resource\n");
+		return new_drvdata->irq;
+	}
+
+	rc = devm_request_irq(dev, new_drvdata->irq, cc_isr,
+			      IRQF_SHARED, "arm_cc7x", new_drvdata);
+	if (rc) {
+		dev_err(dev, "Could not register to interrupt %d\n",
+			new_drvdata->irq);
+		return rc;
+	}
+	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
+
+	init_completion(&new_drvdata->hw_queue_avail);
+
+	if (!plat_dev->dev.dma_mask)
+		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
+
+	dma_mask = (dma_addr_t)(DMA_BIT_MASK(DMA_BIT_MASK_LEN));
+	while (dma_mask > 0x7fffffffUL) {
+		if (dma_supported(&plat_dev->dev, dma_mask)) {
+			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
+			if (!rc)
+				break;
+		}
+		dma_mask >>= 1;
+	}
+
+	if (rc) {
+		dev_err(dev, "Failed in dma_set_mask, mask=%par\n",
+			&dma_mask);
+		return rc;
+	}
+
+	rc = cc_clk_on(new_drvdata);
+	if (rc) {
+		dev_err(dev, "Failed to enable clock");
+		return rc;
+	}
+
+	/* Verify correct mapping */
+	signature_val = cc_ioread(new_drvdata, CC_REG(HOST_SIGNATURE));
+	if (signature_val != CC_DEV_SIGNATURE) {
+		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
+			signature_val, (u32)CC_DEV_SIGNATURE);
+		rc = -EINVAL;
+		goto post_clk_err;
+	}
+	dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
+
+	/* Display HW versions */
+	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
+		 CC_DEV_NAME_STR,
+		 cc_ioread(new_drvdata, CC_REG(HOST_VERSION)),
+		 DRV_MODULE_VERSION);
+
+	rc = init_cc_regs(new_drvdata, true);
+	if (rc) {
+		dev_err(dev, "init_cc_regs failed\n");
+		goto post_clk_err;
+	}
+
+	rc = cc_debugfs_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "Failed registering debugfs interface\n");
+		goto post_regs_err;
+	}
+
+	rc = cc_fips_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
+		goto post_debugfs_err;
+	}
+	rc = cc_sram_mgr_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_sram_mgr_init failed\n");
+		goto post_fips_init_err;
+	}
+
+	new_drvdata->mlli_sram_addr =
+		cc_sram_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
+	if (new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR) {
+		dev_err(dev, "Failed to alloc MLLI Sram buffer\n");
+		rc = -ENOMEM;
+		goto post_sram_mgr_err;
+	}
+
+	rc = cc_req_mgr_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_req_mgr_init failed\n");
+		goto post_sram_mgr_err;
+	}
+
+	rc = cc_buffer_mgr_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "buffer_mgr_init failed\n");
+		goto post_req_mgr_err;
+	}
+
+	rc = cc_pm_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_init failed\n");
+		goto post_buf_mgr_err;
+	}
+
+	rc = cc_ivgen_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_ivgen_init failed\n");
+		goto post_power_mgr_err;
+	}
+
+	/* Allocate crypto algs */
+	rc = cc_cipher_alloc(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_cipher_alloc failed\n");
+		goto post_ivgen_err;
+	}
+
+	/* hash must be allocated before aead since hash exports APIs */
+	rc = cc_hash_alloc(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_hash_alloc failed\n");
+		goto post_cipher_err;
+	}
+
+	rc = cc_aead_alloc(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_aead_alloc failed\n");
+		goto post_hash_err;
+	}
+
+	/* If we got here and FIPS mode is enabled
+	 * it means all FIPS test passed, so let TEE
+	 * know we're good.
+	 */
+	cc_set_ree_fips_status(new_drvdata, true);
+
+	return 0;
+
+post_hash_err:
+	cc_hash_free(new_drvdata);
+post_cipher_err:
+	cc_cipher_free(new_drvdata);
+post_ivgen_err:
+	cc_ivgen_fini(new_drvdata);
+post_power_mgr_err:
+	cc_pm_fini(new_drvdata);
+post_buf_mgr_err:
+	 cc_buffer_mgr_fini(new_drvdata);
+post_req_mgr_err:
+	cc_req_mgr_fini(new_drvdata);
+post_sram_mgr_err:
+	cc_sram_mgr_fini(new_drvdata);
+post_fips_init_err:
+	cc_fips_fini(new_drvdata);
+post_debugfs_err:
+	cc_debugfs_fini(new_drvdata);
+post_regs_err:
+	fini_cc_regs(new_drvdata);
+post_clk_err:
+	cc_clk_off(new_drvdata);
+	return rc;
+}
+
+void fini_cc_regs(struct cc_drvdata *drvdata)
+{
+	/* Mask all interrupts */
+	cc_iowrite(drvdata, CC_REG(HOST_IMR), 0xFFFFFFFF);
+}
+
+static void cleanup_cc_resources(struct platform_device *plat_dev)
+{
+	struct cc_drvdata *drvdata =
+		(struct cc_drvdata *)platform_get_drvdata(plat_dev);
+
+	cc_aead_free(drvdata);
+	cc_hash_free(drvdata);
+	cc_cipher_free(drvdata);
+	cc_ivgen_fini(drvdata);
+	cc_pm_fini(drvdata);
+	cc_buffer_mgr_fini(drvdata);
+	cc_req_mgr_fini(drvdata);
+	cc_sram_mgr_fini(drvdata);
+	cc_fips_fini(drvdata);
+	cc_debugfs_fini(drvdata);
+	fini_cc_regs(drvdata);
+	cc_clk_off(drvdata);
+}
+
+int cc_clk_on(struct cc_drvdata *drvdata)
+{
+	struct clk *clk = drvdata->clk;
+	int rc;
+
+	if (IS_ERR(clk))
+		/* Not all devices have a clock associated with CCREE  */
+		return 0;
+
+	rc = clk_prepare_enable(clk);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+void cc_clk_off(struct cc_drvdata *drvdata)
+{
+	struct clk *clk = drvdata->clk;
+
+	if (IS_ERR(clk))
+		/* Not all devices have a clock associated with CCREE */
+		return;
+
+	clk_disable_unprepare(clk);
+}
+
+static int cc7x_probe(struct platform_device *plat_dev)
+{
+	int rc;
+	struct device *dev = &plat_dev->dev;
+
+	/* Map registers space */
+	rc = init_cc_resources(plat_dev);
+	if (rc)
+		return rc;
+
+	dev_info(dev, "ARM ccree device initialized\n");
+
+	return 0;
+}
+
+static int cc7x_remove(struct platform_device *plat_dev)
+{
+	struct device *dev = &plat_dev->dev;
+
+	dev_dbg(dev, "Releasing cc7x resources...\n");
+
+	cleanup_cc_resources(plat_dev);
+
+	dev_info(dev, "ARM ccree device terminated\n");
+
+	return 0;
+}
+
+static const struct of_device_id arm_cc7x_dev_of_match[] = {
+	{.compatible = "arm,cryptocell-712-ree"},
+	{}
+};
+MODULE_DEVICE_TABLE(of, arm_cc7x_dev_of_match);
+
+static struct platform_driver cc7x_driver = {
+	.driver = {
+		   .name = "cc7xree",
+		   .of_match_table = arm_cc7x_dev_of_match,
+#ifdef CONFIG_PM
+		   .pm = &ccree_pm,
+#endif
+	},
+	.probe = cc7x_probe,
+	.remove = cc7x_remove,
+};
+
+static int __init ccree_init(void)
+{
+	int ret;
+
+	cc_hash_global_init();
+
+	ret = cc_debugfs_global_init();
+	if (ret)
+		return ret;
+
+	return platform_driver_register(&cc7x_driver);
+}
+module_init(ccree_init);
+
+static void __exit ccree_exit(void)
+{
+	platform_driver_unregister(&cc7x_driver);
+	cc_debugfs_global_fini();
+}
+module_exit(ccree_exit);
+
+/* Module description */
+MODULE_DESCRIPTION("ARM TrustZone CryptoCell REE Driver");
+MODULE_VERSION(DRV_MODULE_VERSION);
+MODULE_AUTHOR("ARM");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/ccree/cc_driver.h b/drivers/staging/ccree/cc_driver.h
new file mode 100644
index 0000000..773ac59
--- /dev/null
+++ b/drivers/staging/ccree/cc_driver.h
@@ -0,0 +1,194 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_driver.h
+ * ARM CryptoCell Linux Crypto Driver
+ */
+
+#ifndef __CC_DRIVER_H__
+#define __CC_DRIVER_H__
+
+#ifdef COMP_IN_WQ
+#include <linux/workqueue.h>
+#else
+#include <linux/interrupt.h>
+#endif
+#include <linux/dma-mapping.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/hash.h>
+#include <linux/version.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+/* Registers definitions from shared/hw/ree_include */
+#include "cc_host_regs.h"
+#define CC_DEV_SHA_MAX 512
+#include "cc_crypto_ctx.h"
+#include "cc_hw_queue_defs.h"
+#include "cc_sram_mgr.h"
+
+extern bool cc_dump_desc;
+extern bool cc_dump_bytes;
+
+#define DRV_MODULE_VERSION "3.0"
+
+#define CC_DEV_NAME_STR "cc715ree"
+#define CC_COHERENT_CACHE_PARAMS 0xEEE
+
+/* Maximum DMA mask supported by IP */
+#define DMA_BIT_MASK_LEN 48
+
+#define CC_DEV_SIGNATURE 0xDCC71200UL
+
+#define CC_AXI_IRQ_MASK ((1 << CC_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
+			  (1 << CC_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
+			  (1 << CC_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
+			  (1 << CC_AXIM_CFG_COMPMASK_BIT_SHIFT))
+
+#define CC_AXI_ERR_IRQ_MASK BIT(CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
+
+#define CC_COMP_IRQ_MASK BIT(CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
+
+#define AXIM_MON_COMP_VALUE GENMASK(CC_AXIM_MON_COMP_VALUE_BIT_SIZE + \
+				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
+				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
+
+/* Register name mangling macro */
+#define CC_REG(reg_name) CC_ ## reg_name ## _REG_OFFSET
+
+/* TEE FIPS status interrupt */
+#define CC_GPR0_IRQ_MASK BIT(CC_HOST_IRR_GPR0_BIT_SHIFT)
+
+#define CC_CRA_PRIO 3000
+
+#define MIN_HW_QUEUE_SIZE 50 /* Minimum size required for proper function */
+
+#define MAX_REQUEST_QUEUE_SIZE 4096
+#define MAX_MLLI_BUFF_SIZE 2080
+#define MAX_ICV_NENTS_SUPPORTED 2
+
+/* Definitions for HW descriptors DIN/DOUT fields */
+#define NS_BIT 1
+#define AXI_ID 0
+/* AXI_ID is not actually the AXI ID of the transaction but the value of AXI_ID
+ * field in the HW descriptor. The DMA engine +8 that value.
+ */
+
+#define CC_MAX_IVGEN_DMA_ADDRESSES	3
+struct cc_crypto_req {
+	void (*user_cb)(struct device *dev, void *req, int err);
+	void *user_arg;
+	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
+	/* For the first 'ivgen_dma_addr_len' addresses of this array,
+	 * generated IV would be placed in it by send_request().
+	 * Same generated IV for all addresses!
+	 */
+	/* Amount of 'ivgen_dma_addr' elements to be filled. */
+	unsigned int ivgen_dma_addr_len;
+	/* The generated IV size required, 8/16 B allowed. */
+	unsigned int ivgen_size;
+	struct completion seq_compl; /* request completion */
+};
+
+/**
+ * struct cc_drvdata - driver private data context
+ * @cc_base:	virt address of the CC registers
+ * @irq:	device IRQ number
+ * @irq_mask:	Interrupt mask shadow (1 for masked interrupts)
+ * @fw_ver:	SeP loaded firmware version
+ */
+struct cc_drvdata {
+	void __iomem *cc_base;
+	int irq;
+	u32 irq_mask;
+	u32 fw_ver;
+	struct completion hw_queue_avail; /* wait for HW queue availability */
+	struct platform_device *plat_dev;
+	cc_sram_addr_t mlli_sram_addr;
+	void *buff_mgr_handle;
+	void *hash_handle;
+	void *aead_handle;
+	void *blkcipher_handle;
+	void *request_mgr_handle;
+	void *fips_handle;
+	void *ivgen_handle;
+	void *sram_mgr_handle;
+	void *debugfs;
+	struct clk *clk;
+	bool coherent;
+};
+
+struct cc_crypto_alg {
+	struct list_head entry;
+	int cipher_mode;
+	int flow_mode; /* Note: currently, refers to the cipher mode only. */
+	int auth_mode;
+	struct cc_drvdata *drvdata;
+	struct crypto_alg crypto_alg;
+	struct aead_alg aead_alg;
+};
+
+struct cc_alg_template {
+	char name[CRYPTO_MAX_ALG_NAME];
+	char driver_name[CRYPTO_MAX_ALG_NAME];
+	unsigned int blocksize;
+	u32 type;
+	union {
+		struct ablkcipher_alg ablkcipher;
+		struct aead_alg aead;
+		struct blkcipher_alg blkcipher;
+		struct cipher_alg cipher;
+		struct compress_alg compress;
+	} template_u;
+	int cipher_mode;
+	int flow_mode; /* Note: currently, refers to the cipher mode only. */
+	int auth_mode;
+	struct cc_drvdata *drvdata;
+};
+
+struct async_gen_req_ctx {
+	dma_addr_t iv_dma_addr;
+	enum drv_crypto_direction op_type;
+};
+
+static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
+{
+	return &drvdata->plat_dev->dev;
+}
+
+void __dump_byte_array(const char *name, const u8 *buf, size_t len);
+static inline void dump_byte_array(const char *name, const u8 *the_array,
+				   size_t size)
+{
+	if (cc_dump_bytes)
+		__dump_byte_array(name, the_array, size);
+}
+
+int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
+void fini_cc_regs(struct cc_drvdata *drvdata);
+int cc_clk_on(struct cc_drvdata *drvdata);
+void cc_clk_off(struct cc_drvdata *drvdata);
+
+static inline void cc_iowrite(struct cc_drvdata *drvdata, u32 reg, u32 val)
+{
+	iowrite32(val, (drvdata->cc_base + reg));
+}
+
+static inline u32 cc_ioread(struct cc_drvdata *drvdata, u32 reg)
+{
+	return ioread32(drvdata->cc_base + reg);
+}
+
+static inline gfp_t cc_gfp_flags(struct crypto_async_request *req)
+{
+	return (req->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC;
+}
+
+#endif /*__CC_DRIVER_H__*/
+
diff --git a/drivers/staging/ccree/cc_fips.c b/drivers/staging/ccree/cc_fips.c
new file mode 100644
index 0000000..b25c34e
--- /dev/null
+++ b/drivers/staging/ccree/cc_fips.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/fips.h>
+
+#include "cc_driver.h"
+#include "cc_fips.h"
+
+static void fips_dsr(unsigned long devarg);
+
+struct cc_fips_handle {
+	struct tasklet_struct tasklet;
+};
+
+/* The function called once at driver entry point to check
+ * whether TEE FIPS error occurred.
+ */
+static bool cc_get_tee_fips_status(struct cc_drvdata *drvdata)
+{
+	u32 reg;
+
+	reg = cc_ioread(drvdata, CC_REG(GPR_HOST));
+	return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
+}
+
+/*
+ * This function should push the FIPS REE library status towards the TEE library
+ * by writing the error state to HOST_GPR0 register.
+ */
+void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool status)
+{
+	int val = CC_FIPS_SYNC_REE_STATUS;
+
+	val |= (status ? CC_FIPS_SYNC_MODULE_OK : CC_FIPS_SYNC_MODULE_ERROR);
+
+	cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
+}
+
+void cc_fips_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_fips_handle *fips_h = drvdata->fips_handle;
+
+	if (!fips_h)
+		return; /* Not allocated */
+
+	/* Kill tasklet */
+	tasklet_kill(&fips_h->tasklet);
+
+	kfree(fips_h);
+	drvdata->fips_handle = NULL;
+}
+
+void fips_handler(struct cc_drvdata *drvdata)
+{
+	struct cc_fips_handle *fips_handle_ptr =
+		drvdata->fips_handle;
+
+	tasklet_schedule(&fips_handle_ptr->tasklet);
+}
+
+static inline void tee_fips_error(struct device *dev)
+{
+	if (fips_enabled)
+		panic("ccree: TEE reported cryptographic error in fips mode!\n");
+	else
+		dev_err(dev, "TEE reported error!\n");
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void fips_dsr(unsigned long devarg)
+{
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
+	struct device *dev = drvdata_to_dev(drvdata);
+	u32 irq, state, val;
+
+	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
+
+	if (irq) {
+		state = cc_ioread(drvdata, CC_REG(GPR_HOST));
+
+		if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
+			tee_fips_error(dev);
+	}
+
+	/* after verifing that there is nothing to do,
+	 * unmask AXI completion interrupt.
+	 */
+	val = (CC_REG(HOST_IMR) & ~irq);
+	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
+}
+
+/* The function called once at driver entry point .*/
+int cc_fips_init(struct cc_drvdata *p_drvdata)
+{
+	struct cc_fips_handle *fips_h;
+	struct device *dev = drvdata_to_dev(p_drvdata);
+
+	fips_h = kzalloc(sizeof(*fips_h), GFP_KERNEL);
+	if (!fips_h)
+		return -ENOMEM;
+
+	p_drvdata->fips_handle = fips_h;
+
+	dev_dbg(dev, "Initializing fips tasklet\n");
+	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
+
+	if (!cc_get_tee_fips_status(p_drvdata))
+		tee_fips_error(dev);
+
+	return 0;
+}
diff --git a/drivers/staging/ccree/cc_fips.h b/drivers/staging/ccree/cc_fips.h
new file mode 100644
index 0000000..0d52003
--- /dev/null
+++ b/drivers/staging/ccree/cc_fips.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_FIPS_H__
+#define __CC_FIPS_H__
+
+#ifdef CONFIG_CRYPTO_FIPS
+
+enum cc_fips_status {
+	CC_FIPS_SYNC_MODULE_OK = 0x0,
+	CC_FIPS_SYNC_MODULE_ERROR = 0x1,
+	CC_FIPS_SYNC_REE_STATUS = 0x4,
+	CC_FIPS_SYNC_TEE_STATUS = 0x8,
+	CC_FIPS_SYNC_STATUS_RESERVE32B = S32_MAX
+};
+
+int cc_fips_init(struct cc_drvdata *p_drvdata);
+void cc_fips_fini(struct cc_drvdata *drvdata);
+void fips_handler(struct cc_drvdata *drvdata);
+void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
+
+#else  /* CONFIG_CRYPTO_FIPS */
+
+static inline int cc_fips_init(struct cc_drvdata *p_drvdata)
+{
+	return 0;
+}
+
+static inline void cc_fips_fini(struct cc_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
+					  bool ok) {}
+static inline void fips_handler(struct cc_drvdata *drvdata) {}
+
+#endif /* CONFIG_CRYPTO_FIPS */
+
+#endif  /*__CC_FIPS_H__*/
+
diff --git a/drivers/staging/ccree/cc_hash.c b/drivers/staging/ccree/cc_hash.c
new file mode 100644
index 0000000..7c1645d
--- /dev/null
+++ b/drivers/staging/ccree/cc_hash.c
@@ -0,0 +1,2299 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/internal/hash.h>
+
+#include "cc_driver.h"
+#include "cc_request_mgr.h"
+#include "cc_buffer_mgr.h"
+#include "cc_hash.h"
+#include "cc_sram_mgr.h"
+
+#define CC_MAX_HASH_SEQ_LEN 12
+#define CC_MAX_OPAD_KEYS_SIZE CC_MAX_HASH_BLCK_SIZE
+
+struct cc_hash_handle {
+	cc_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
+	cc_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
+	struct list_head hash_list;
+};
+
+static const u32 digest_len_init[] = {
+	0x00000040, 0x00000000, 0x00000000, 0x00000000 };
+static const u32 md5_init[] = {
+	SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
+static const u32 sha1_init[] = {
+	SHA1_H4, SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
+static const u32 sha224_init[] = {
+	SHA224_H7, SHA224_H6, SHA224_H5, SHA224_H4,
+	SHA224_H3, SHA224_H2, SHA224_H1, SHA224_H0 };
+static const u32 sha256_init[] = {
+	SHA256_H7, SHA256_H6, SHA256_H5, SHA256_H4,
+	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
+#if (CC_DEV_SHA_MAX > 256)
+static const u32 digest_len_sha512_init[] = {
+	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
+static u64 sha384_init[] = {
+	SHA384_H7, SHA384_H6, SHA384_H5, SHA384_H4,
+	SHA384_H3, SHA384_H2, SHA384_H1, SHA384_H0 };
+static u64 sha512_init[] = {
+	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
+	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
+#endif
+
+static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size);
+
+static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size);
+
+static const void *cc_larval_digest(struct device *dev, u32 mode);
+
+struct cc_hash_alg {
+	struct list_head entry;
+	int hash_mode;
+	int hw_mode;
+	int inter_digestsize;
+	struct cc_drvdata *drvdata;
+	struct ahash_alg ahash_alg;
+};
+
+struct hash_key_req_ctx {
+	u32 keylen;
+	dma_addr_t key_dma_addr;
+};
+
+/* hash per-session context */
+struct cc_hash_ctx {
+	struct cc_drvdata *drvdata;
+	/* holds the origin digest; the digest after "setkey" if HMAC,*
+	 * the initial digest if HASH.
+	 */
+	u8 digest_buff[CC_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
+	u8 opad_tmp_keys_buff[CC_MAX_OPAD_KEYS_SIZE]  ____cacheline_aligned;
+
+	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
+	dma_addr_t digest_buff_dma_addr;
+	/* use for hmac with key large then mode block size */
+	struct hash_key_req_ctx key_params;
+	int hash_mode;
+	int hw_mode;
+	int inter_digestsize;
+	struct completion setkey_comp;
+	bool is_hmac;
+};
+
+static void cc_set_desc(struct ahash_req_ctx *areq_ctx, struct cc_hash_ctx *ctx,
+			unsigned int flow_mode, struct cc_hw_desc desc[],
+			bool is_not_last_data, unsigned int *seq_size);
+
+static void cc_set_endianity(u32 mode, struct cc_hw_desc *desc)
+{
+	if (mode == DRV_HASH_MD5 || mode == DRV_HASH_SHA384 ||
+	    mode == DRV_HASH_SHA512) {
+		set_bytes_swap(desc, 1);
+	} else {
+		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	}
+}
+
+static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
+			 unsigned int digestsize)
+{
+	state->digest_result_dma_addr =
+		dma_map_single(dev, state->digest_result_buff,
+			       digestsize, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, state->digest_result_dma_addr)) {
+		dev_err(dev, "Mapping digest result buffer %u B for DMA failed\n",
+			digestsize);
+		return -ENOMEM;
+	}
+	dev_dbg(dev, "Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
+		digestsize, state->digest_result_buff,
+		&state->digest_result_dma_addr);
+
+	return 0;
+}
+
+static void cc_init_req(struct device *dev, struct ahash_req_ctx *state,
+			struct cc_hash_ctx *ctx)
+{
+	bool is_hmac = ctx->is_hmac;
+
+	memset(state, 0, sizeof(*state));
+
+	if (is_hmac) {
+		if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC &&
+		    ctx->hw_mode != DRV_CIPHER_CMAC) {
+			dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr,
+						ctx->inter_digestsize,
+						DMA_BIDIRECTIONAL);
+
+			memcpy(state->digest_buff, ctx->digest_buff,
+			       ctx->inter_digestsize);
+#if (CC_DEV_SHA_MAX > 256)
+			if (ctx->hash_mode == DRV_HASH_SHA512 ||
+			    ctx->hash_mode == DRV_HASH_SHA384)
+				memcpy(state->digest_bytes_len,
+				       digest_len_sha512_init, HASH_LEN_SIZE);
+			else
+				memcpy(state->digest_bytes_len,
+				       digest_len_init, HASH_LEN_SIZE);
+#else
+			memcpy(state->digest_bytes_len, digest_len_init,
+			       HASH_LEN_SIZE);
+#endif
+		}
+
+		if (ctx->hash_mode != DRV_HASH_NULL) {
+			dma_sync_single_for_cpu(dev,
+						ctx->opad_tmp_keys_dma_addr,
+						ctx->inter_digestsize,
+						DMA_BIDIRECTIONAL);
+			memcpy(state->opad_digest_buff,
+			       ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
+		}
+	} else { /*hash*/
+		/* Copy the initial digests if hash flow. */
+		const void *larval = cc_larval_digest(dev, ctx->hash_mode);
+
+		memcpy(state->digest_buff, larval, ctx->inter_digestsize);
+	}
+}
+
+static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
+		      struct cc_hash_ctx *ctx)
+{
+	bool is_hmac = ctx->is_hmac;
+
+	state->digest_buff_dma_addr =
+		dma_map_single(dev, state->digest_buff,
+			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
+		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
+			ctx->inter_digestsize, state->digest_buff);
+		return -EINVAL;
+	}
+	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
+		ctx->inter_digestsize, state->digest_buff,
+		&state->digest_buff_dma_addr);
+
+	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
+		state->digest_bytes_len_dma_addr =
+			dma_map_single(dev, state->digest_bytes_len,
+				       HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
+			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
+				HASH_LEN_SIZE, state->digest_bytes_len);
+			goto unmap_digest_buf;
+		}
+		dev_dbg(dev, "Mapped digest len %u B at va=%pK to dma=%pad\n",
+			HASH_LEN_SIZE, state->digest_bytes_len,
+			&state->digest_bytes_len_dma_addr);
+	}
+
+	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
+		state->opad_digest_dma_addr =
+			dma_map_single(dev, state->opad_digest_buff,
+				       ctx->inter_digestsize,
+				       DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
+			dev_err(dev, "Mapping opad digest %d B at va=%pK for DMA failed\n",
+				ctx->inter_digestsize,
+				state->opad_digest_buff);
+			goto unmap_digest_len;
+		}
+		dev_dbg(dev, "Mapped opad digest %d B at va=%pK to dma=%pad\n",
+			ctx->inter_digestsize, state->opad_digest_buff,
+			&state->opad_digest_dma_addr);
+	}
+
+	return 0;
+
+unmap_digest_len:
+	if (state->digest_bytes_len_dma_addr) {
+		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
+				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		state->digest_bytes_len_dma_addr = 0;
+	}
+unmap_digest_buf:
+	if (state->digest_buff_dma_addr) {
+		dma_unmap_single(dev, state->digest_buff_dma_addr,
+				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		state->digest_buff_dma_addr = 0;
+	}
+
+	return -EINVAL;
+}
+
+static void cc_unmap_req(struct device *dev, struct ahash_req_ctx *state,
+			 struct cc_hash_ctx *ctx)
+{
+	if (state->digest_buff_dma_addr) {
+		dma_unmap_single(dev, state->digest_buff_dma_addr,
+				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
+			&state->digest_buff_dma_addr);
+		state->digest_buff_dma_addr = 0;
+	}
+	if (state->digest_bytes_len_dma_addr) {
+		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
+				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
+			&state->digest_bytes_len_dma_addr);
+		state->digest_bytes_len_dma_addr = 0;
+	}
+	if (state->opad_digest_dma_addr) {
+		dma_unmap_single(dev, state->opad_digest_dma_addr,
+				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
+			&state->opad_digest_dma_addr);
+		state->opad_digest_dma_addr = 0;
+	}
+}
+
+static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
+			    unsigned int digestsize, u8 *result)
+{
+	if (state->digest_result_dma_addr) {
+		dma_unmap_single(dev, state->digest_result_dma_addr, digestsize,
+				 DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
+			state->digest_result_buff,
+			&state->digest_result_dma_addr, digestsize);
+		memcpy(result, state->digest_result_buff, digestsize);
+	}
+	state->digest_result_dma_addr = 0;
+}
+
+static void cc_update_complete(struct device *dev, void *cc_req, int err)
+{
+	struct ahash_request *req = (struct ahash_request *)cc_req;
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(dev, "req=%pK\n", req);
+
+	cc_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_req(dev, state, ctx);
+	req->base.complete(&req->base, err);
+}
+
+static void cc_digest_complete(struct device *dev, void *cc_req, int err)
+{
+	struct ahash_request *req = (struct ahash_request *)cc_req;
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+
+	dev_dbg(dev, "req=%pK\n", req);
+
+	cc_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_result(dev, state, digestsize, req->result);
+	cc_unmap_req(dev, state, ctx);
+	req->base.complete(&req->base, err);
+}
+
+static void cc_hash_complete(struct device *dev, void *cc_req, int err)
+{
+	struct ahash_request *req = (struct ahash_request *)cc_req;
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+
+	dev_dbg(dev, "req=%pK\n", req);
+
+	cc_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_result(dev, state, digestsize, req->result);
+	cc_unmap_req(dev, state, ctx);
+	req->base.complete(&req->base, err);
+}
+
+static int cc_fin_result(struct cc_hw_desc *desc, struct ahash_request *req,
+			 int idx)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+
+	/* Get final MAC result */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
+		      NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
+	idx++;
+
+	return idx;
+}
+
+static int cc_fin_hmac(struct cc_hw_desc *desc, struct ahash_request *req,
+		       int idx)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+
+	/* store the hash digest result in the context */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr, digestsize,
+		      NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	idx++;
+
+	/* Loading hash opad xor key state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load the hash current length */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_sram(&desc[idx],
+		     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
+		     HASH_LEN_SIZE);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* Perform HASH update */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
+	idx++;
+
+	return idx;
+}
+
+static int cc_hash_digest(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	u8 *result = req->result;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	bool is_hmac = ctx->is_hmac;
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	cc_sram_addr_t larval_digest_addr =
+		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
+	int idx = 0;
+	int rc = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
+		nbytes);
+
+	cc_init_req(dev, state, ctx);
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -ENOMEM;
+	}
+
+	if (cc_map_result(dev, state, digestsize)) {
+		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
+				      flags)) {
+		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = cc_digest_complete;
+	cc_req.user_arg = req;
+
+	/* If HMAC then load hash IPAD xor key, if HASH then load initial
+	 * digest
+	 */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	if (is_hmac) {
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     ctx->inter_digestsize, NS_BIT);
+	} else {
+		set_din_sram(&desc[idx], larval_digest_addr,
+			     ctx->inter_digestsize);
+	}
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load the hash current length */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+
+	if (is_hmac) {
+		set_din_type(&desc[idx], DMA_DLLI,
+			     state->digest_bytes_len_dma_addr, HASH_LEN_SIZE,
+			     NS_BIT);
+	} else {
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		if (nbytes)
+			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+		else
+			set_cipher_do(&desc[idx], DO_PAD);
+	}
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
+
+	if (is_hmac) {
+		/* HW last hash block padding (aka. "DO_PAD") */
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      HASH_LEN_SIZE, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+		set_cipher_do(&desc[idx], DO_PAD);
+		idx++;
+
+		idx = cc_fin_hmac(desc, req, idx);
+	}
+
+	idx = cc_fin_result(desc, req, idx);
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
+			   struct ahash_req_ctx *state, int idx)
+{
+	/* Restore hash digest */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Restore hash current length */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
+		     HASH_LEN_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
+
+	return idx;
+}
+
+static int cc_hash_update(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	u32 idx = 0;
+	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "===== %s-update (%d) ====\n", ctx->is_hmac ?
+		"hmac" : "hash", nbytes);
+
+	if (nbytes == 0) {
+		/* no real updates required */
+		return 0;
+	}
+
+	rc = cc_map_hash_request_update(ctx->drvdata, state, src, nbytes,
+					block_size, flags);
+	if (rc) {
+		if (rc == 1) {
+			dev_dbg(dev, " data size not require HW update %x\n",
+				nbytes);
+			/* No hardware updates are required */
+			return 0;
+		}
+		dev_err(dev, "map_ahash_request_update() failed\n");
+		return -ENOMEM;
+	}
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		cc_unmap_hash_request(dev, state, src, true);
+		return -EINVAL;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = cc_update_complete;
+	cc_req.user_arg = req;
+
+	idx = cc_restore_hash(desc, ctx, state, idx);
+
+	/* store the hash digest result in context */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+		      ctx->inter_digestsize, NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	idx++;
+
+	/* store current hash length in context */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
+		      HASH_LEN_SIZE, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+	idx++;
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_hash_finup(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	u8 *result = req->result;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	bool is_hmac = ctx->is_hmac;
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	int idx = 0;
+	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
+		nbytes);
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
+				      flags)) {
+		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+	if (cc_map_result(dev, state, digestsize)) {
+		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = cc_hash_complete;
+	cc_req.user_arg = req;
+
+	idx = cc_restore_hash(desc, ctx, state, idx);
+
+	if (is_hmac)
+		idx = cc_fin_hmac(desc, req, idx);
+
+	idx = cc_fin_result(desc, req, idx);
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_hash_final(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	u8 *result = req->result;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	bool is_hmac = ctx->is_hmac;
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	int idx = 0;
+	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
+		nbytes);
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0,
+				      flags)) {
+		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	if (cc_map_result(dev, state, digestsize)) {
+		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = cc_hash_complete;
+	cc_req.user_arg = req;
+
+	idx = cc_restore_hash(desc, ctx, state, idx);
+
+	/* "DO-PAD" must be enabled only when writing current length to HW */
+	hw_desc_init(&desc[idx]);
+	set_cipher_do(&desc[idx], DO_PAD);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
+		      HASH_LEN_SIZE, NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	idx++;
+
+	if (is_hmac)
+		idx = cc_fin_hmac(desc, req, idx);
+
+	idx = cc_fin_result(desc, req, idx);
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_hash_init(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
+
+	cc_init_req(dev, state, ctx);
+
+	return 0;
+}
+
+static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
+			  unsigned int keylen)
+{
+	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
+	struct cc_crypto_req cc_req = {};
+	struct cc_hash_ctx *ctx = NULL;
+	int blocksize = 0;
+	int digestsize = 0;
+	int i, idx = 0, rc = 0;
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	cc_sram_addr_t larval_addr;
+	struct device *dev;
+
+	ctx = crypto_ahash_ctx(ahash);
+	dev = drvdata_to_dev(ctx->drvdata);
+	dev_dbg(dev, "start keylen: %d", keylen);
+
+	blocksize = crypto_tfm_alg_blocksize(&ahash->base);
+	digestsize = crypto_ahash_digestsize(ahash);
+
+	larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
+
+	/* The keylen value distinguishes HASH in case keylen is ZERO bytes,
+	 * any NON-ZERO value utilizes HMAC flow
+	 */
+	ctx->key_params.keylen = keylen;
+	ctx->key_params.key_dma_addr = 0;
+	ctx->is_hmac = true;
+
+	if (keylen) {
+		ctx->key_params.key_dma_addr =
+			dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
+			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
+				key, keylen);
+			return -ENOMEM;
+		}
+		dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
+			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
+
+		if (keylen > blocksize) {
+			/* Load hash initial state */
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], ctx->hw_mode);
+			set_din_sram(&desc[idx], larval_addr,
+				     ctx->inter_digestsize);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+			idx++;
+
+			/* Load the hash current length*/
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], ctx->hw_mode);
+			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+			idx++;
+
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     ctx->key_params.key_dma_addr, keylen,
+				     NS_BIT);
+			set_flow_mode(&desc[idx], DIN_HASH);
+			idx++;
+
+			/* Get hashed key */
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], ctx->hw_mode);
+			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
+				      digestsize, NS_BIT, 0);
+			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+			cc_set_endianity(ctx->hash_mode, &desc[idx]);
+			idx++;
+
+			hw_desc_init(&desc[idx]);
+			set_din_const(&desc[idx], 0, (blocksize - digestsize));
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx],
+				      (ctx->opad_tmp_keys_dma_addr +
+				       digestsize),
+				      (blocksize - digestsize), NS_BIT, 0);
+			idx++;
+		} else {
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     ctx->key_params.key_dma_addr, keylen,
+				     NS_BIT);
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
+				      keylen, NS_BIT, 0);
+			idx++;
+
+			if ((blocksize - keylen)) {
+				hw_desc_init(&desc[idx]);
+				set_din_const(&desc[idx], 0,
+					      (blocksize - keylen));
+				set_flow_mode(&desc[idx], BYPASS);
+				set_dout_dlli(&desc[idx],
+					      (ctx->opad_tmp_keys_dma_addr +
+					       keylen), (blocksize - keylen),
+					      NS_BIT, 0);
+				idx++;
+			}
+		}
+	} else {
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0, blocksize);
+		set_flow_mode(&desc[idx], BYPASS);
+		set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr),
+			      blocksize, NS_BIT, 0);
+		idx++;
+	}
+
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
+	if (rc) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		goto out;
+	}
+
+	/* calc derived HMAC key */
+	for (idx = 0, i = 0; i < 2; i++) {
+		/* Load hash initial state */
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_sram(&desc[idx], larval_addr, ctx->inter_digestsize);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+		idx++;
+
+		/* Load the hash current length*/
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+
+		/* Prepare ipad key */
+		hw_desc_init(&desc[idx]);
+		set_xor_val(&desc[idx], hmac_pad_const[i]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+		idx++;
+
+		/* Perform HASH update */
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
+			     blocksize, NS_BIT);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_xor_active(&desc[idx]);
+		set_flow_mode(&desc[idx], DIN_HASH);
+		idx++;
+
+		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial digest
+		 * of the first HASH "update" state)
+		 */
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		if (i > 0) /* Not first iteration */
+			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
+				      ctx->inter_digestsize, NS_BIT, 0);
+		else /* First iteration */
+			set_dout_dlli(&desc[idx], ctx->digest_buff_dma_addr,
+				      ctx->inter_digestsize, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		idx++;
+	}
+
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
+
+out:
+	if (rc)
+		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	if (ctx->key_params.key_dma_addr) {
+		dma_unmap_single(dev, ctx->key_params.key_dma_addr,
+				 ctx->key_params.keylen, DMA_TO_DEVICE);
+		dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
+			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
+	}
+	return rc;
+}
+
+static int cc_xcbc_setkey(struct crypto_ahash *ahash,
+			  const u8 *key, unsigned int keylen)
+{
+	struct cc_crypto_req cc_req = {};
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	int idx = 0, rc = 0;
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+
+	dev_dbg(dev, "===== setkey (%d) ====\n", keylen);
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ctx->key_params.keylen = keylen;
+
+	ctx->key_params.key_dma_addr =
+		dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
+		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
+			key, keylen);
+		return -ENOMEM;
+	}
+	dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
+		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
+
+	ctx->is_hmac = true;
+	/* 1. Load the AES key */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->key_params.key_dma_addr,
+		     keylen, NS_BIT);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_key_size_aes(&desc[idx], keylen);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	set_dout_dlli(&desc[idx],
+		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K1_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+	idx++;
+
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	set_dout_dlli(&desc[idx],
+		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K2_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+	idx++;
+
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	set_dout_dlli(&desc[idx],
+		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K3_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+	idx++;
+
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
+
+	if (rc)
+		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	dma_unmap_single(dev, ctx->key_params.key_dma_addr,
+			 ctx->key_params.keylen, DMA_TO_DEVICE);
+	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
+		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
+
+	return rc;
+}
+
+static int cc_cmac_setkey(struct crypto_ahash *ahash,
+			  const u8 *key, unsigned int keylen)
+{
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "===== setkey (%d) ====\n", keylen);
+
+	ctx->is_hmac = true;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ctx->key_params.keylen = keylen;
+
+	/* STAT_PHASE_1: Copy key to ctx */
+
+	dma_sync_single_for_cpu(dev, ctx->opad_tmp_keys_dma_addr,
+				keylen, DMA_TO_DEVICE);
+
+	memcpy(ctx->opad_tmp_keys_buff, key, keylen);
+	if (keylen == 24) {
+		memset(ctx->opad_tmp_keys_buff + 24, 0,
+		       CC_AES_KEY_SIZE_MAX - 24);
+	}
+
+	dma_sync_single_for_device(dev, ctx->opad_tmp_keys_dma_addr,
+				   keylen, DMA_TO_DEVICE);
+
+	ctx->key_params.keylen = keylen;
+
+	return 0;
+}
+
+static void cc_free_ctx(struct cc_hash_ctx *ctx)
+{
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	if (ctx->digest_buff_dma_addr) {
+		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
+				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
+			&ctx->digest_buff_dma_addr);
+		ctx->digest_buff_dma_addr = 0;
+	}
+	if (ctx->opad_tmp_keys_dma_addr) {
+		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
+				 sizeof(ctx->opad_tmp_keys_buff),
+				 DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
+			&ctx->opad_tmp_keys_dma_addr);
+		ctx->opad_tmp_keys_dma_addr = 0;
+	}
+
+	ctx->key_params.keylen = 0;
+}
+
+static int cc_alloc_ctx(struct cc_hash_ctx *ctx)
+{
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	ctx->key_params.keylen = 0;
+
+	ctx->digest_buff_dma_addr =
+		dma_map_single(dev, (void *)ctx->digest_buff,
+			       sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
+		dev_err(dev, "Mapping digest len %zu B at va=%pK for DMA failed\n",
+			sizeof(ctx->digest_buff), ctx->digest_buff);
+		goto fail;
+	}
+	dev_dbg(dev, "Mapped digest %zu B at va=%pK to dma=%pad\n",
+		sizeof(ctx->digest_buff), ctx->digest_buff,
+		&ctx->digest_buff_dma_addr);
+
+	ctx->opad_tmp_keys_dma_addr =
+		dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff,
+			       sizeof(ctx->opad_tmp_keys_buff),
+			       DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
+		dev_err(dev, "Mapping opad digest %zu B at va=%pK for DMA failed\n",
+			sizeof(ctx->opad_tmp_keys_buff),
+			ctx->opad_tmp_keys_buff);
+		goto fail;
+	}
+	dev_dbg(dev, "Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
+		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
+		&ctx->opad_tmp_keys_dma_addr);
+
+	ctx->is_hmac = false;
+	return 0;
+
+fail:
+	cc_free_ctx(ctx);
+	return -ENOMEM;
+}
+
+static int cc_cra_init(struct crypto_tfm *tfm)
+{
+	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct hash_alg_common *hash_alg_common =
+		container_of(tfm->__crt_alg, struct hash_alg_common, base);
+	struct ahash_alg *ahash_alg =
+		container_of(hash_alg_common, struct ahash_alg, halg);
+	struct cc_hash_alg *cc_alg =
+			container_of(ahash_alg, struct cc_hash_alg, ahash_alg);
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct ahash_req_ctx));
+
+	ctx->hash_mode = cc_alg->hash_mode;
+	ctx->hw_mode = cc_alg->hw_mode;
+	ctx->inter_digestsize = cc_alg->inter_digestsize;
+	ctx->drvdata = cc_alg->drvdata;
+
+	return cc_alloc_ctx(ctx);
+}
+
+static void cc_cra_exit(struct crypto_tfm *tfm)
+{
+	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	dev_dbg(dev, "cc_cra_exit");
+	cc_free_ctx(ctx);
+}
+
+static int cc_mac_update(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	int rc;
+	u32 idx = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	if (req->nbytes == 0) {
+		/* no real updates required */
+		return 0;
+	}
+
+	state->xcbc_count++;
+
+	rc = cc_map_hash_request_update(ctx->drvdata, state, req->src,
+					req->nbytes, block_size, flags);
+	if (rc) {
+		if (rc == 1) {
+			dev_dbg(dev, " data size not require HW update %x\n",
+				req->nbytes);
+			/* No hardware updates are required */
+			return 0;
+		}
+		dev_err(dev, "map_ahash_request_update() failed\n");
+		return -ENOMEM;
+	}
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
+		cc_setup_xcbc(req, desc, &idx);
+	else
+		cc_setup_cmac(req, desc, &idx);
+
+	cc_set_desc(state, ctx, DIN_AES_DOUT, desc, true, &idx);
+
+	/* store the hash digest result in context */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+		      ctx->inter_digestsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	idx++;
+
+	/* Setup DX request structure */
+	cc_req.user_cb = (void *)cc_update_complete;
+	cc_req.user_arg = (void *)req;
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_mac_final(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	int idx = 0;
+	int rc = 0;
+	u32 key_size, key_len;
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	gfp_t flags = cc_gfp_flags(&req->base);
+	u32 rem_cnt = *cc_hash_buf_cnt(state);
+
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
+		key_size = CC_AES_128_BIT_KEY_SIZE;
+		key_len  = CC_AES_128_BIT_KEY_SIZE;
+	} else {
+		key_size = (ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
+			ctx->key_params.keylen;
+		key_len =  ctx->key_params.keylen;
+	}
+
+	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
+	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
+				      req->nbytes, 0, flags)) {
+		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	if (cc_map_result(dev, state, digestsize)) {
+		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = (void *)cc_hash_complete;
+	cc_req.user_arg = (void *)req;
+
+	if (state->xcbc_count && rem_cnt == 0) {
+		/* Load key for ECB decryption */
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_DECRYPT);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K1_OFFSET),
+			     key_size, NS_BIT);
+		set_key_size_aes(&desc[idx], key_len);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+
+		/* Initiate decryption of block state to previous
+		 * block_state-XOR-M[n]
+		 */
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     CC_AES_BLOCK_SIZE, NS_BIT);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      CC_AES_BLOCK_SIZE, NS_BIT, 0);
+		set_flow_mode(&desc[idx], DIN_AES_DOUT);
+		idx++;
+
+		/* Memory Barrier: wait for axi write to complete */
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
+		idx++;
+	}
+
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
+		cc_setup_xcbc(req, desc, &idx);
+	else
+		cc_setup_cmac(req, desc, &idx);
+
+	if (state->xcbc_count == 0) {
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_key_size_aes(&desc[idx], key_len);
+		set_cmac_size0_mode(&desc[idx]);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
+		idx++;
+	} else if (rem_cnt > 0) {
+		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+	} else {
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
+		set_flow_mode(&desc[idx], DIN_AES_DOUT);
+		idx++;
+	}
+
+	/* Get final MAC result */
+	hw_desc_init(&desc[idx]);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
+		      digestsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	idx++;
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_mac_finup(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	int idx = 0;
+	int rc = 0;
+	u32 key_len = 0;
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "===== finup xcbc(%d) ====\n", req->nbytes);
+	if (state->xcbc_count > 0 && req->nbytes == 0) {
+		dev_dbg(dev, "No data to update. Call to fdx_mac_final\n");
+		return cc_mac_final(req);
+	}
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
+	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
+				      req->nbytes, 1, flags)) {
+		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+	if (cc_map_result(dev, state, digestsize)) {
+		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = (void *)cc_hash_complete;
+	cc_req.user_arg = (void *)req;
+
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
+		key_len = CC_AES_128_BIT_KEY_SIZE;
+		cc_setup_xcbc(req, desc, &idx);
+	} else {
+		key_len = ctx->key_params.keylen;
+		cc_setup_cmac(req, desc, &idx);
+	}
+
+	if (req->nbytes == 0) {
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_key_size_aes(&desc[idx], key_len);
+		set_cmac_size0_mode(&desc[idx]);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
+		idx++;
+	} else {
+		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+	}
+
+	/* Get final MAC result */
+	hw_desc_init(&desc[idx]);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
+		      digestsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	idx++;
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_mac_digest(struct ahash_request *req)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct cc_crypto_req cc_req = {};
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
+	u32 key_len;
+	int idx = 0;
+	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
+
+	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
+
+	cc_init_req(dev, state, ctx);
+
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -ENOMEM;
+	}
+	if (cc_map_result(dev, state, digestsize)) {
+		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
+				      req->nbytes, 1, flags)) {
+		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup DX request structure */
+	cc_req.user_cb = (void *)cc_digest_complete;
+	cc_req.user_arg = (void *)req;
+
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
+		key_len = CC_AES_128_BIT_KEY_SIZE;
+		cc_setup_xcbc(req, desc, &idx);
+	} else {
+		key_len = ctx->key_params.keylen;
+		cc_setup_cmac(req, desc, &idx);
+	}
+
+	if (req->nbytes == 0) {
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_key_size_aes(&desc[idx], key_len);
+		set_cmac_size0_mode(&desc[idx]);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
+		idx++;
+	} else {
+		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+	}
+
+	/* Get final MAC result */
+	hw_desc_init(&desc[idx]);
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
+		      CC_AES_BLOCK_SIZE, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	idx++;
+
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+	return rc;
+}
+
+static int cc_hash_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	u8 *curr_buff = cc_hash_buf(state);
+	u32 curr_buff_cnt = *cc_hash_buf_cnt(state);
+	const u32 tmp = CC_EXPORT_MAGIC;
+
+	memcpy(out, &tmp, sizeof(u32));
+	out += sizeof(u32);
+
+	memcpy(out, state->digest_buff, ctx->inter_digestsize);
+	out += ctx->inter_digestsize;
+
+	memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
+	out += HASH_LEN_SIZE;
+
+	memcpy(out, &curr_buff_cnt, sizeof(u32));
+	out += sizeof(u32);
+
+	memcpy(out, curr_buff, curr_buff_cnt);
+
+	return 0;
+}
+
+static int cc_hash_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	u32 tmp;
+
+	memcpy(&tmp, in, sizeof(u32));
+	if (tmp != CC_EXPORT_MAGIC)
+		return -EINVAL;
+	in += sizeof(u32);
+
+	cc_init_req(dev, state, ctx);
+
+	memcpy(state->digest_buff, in, ctx->inter_digestsize);
+	in += ctx->inter_digestsize;
+
+	memcpy(state->digest_bytes_len, in, HASH_LEN_SIZE);
+	in += HASH_LEN_SIZE;
+
+	/* Sanity check the data as much as possible */
+	memcpy(&tmp, in, sizeof(u32));
+	if (tmp > CC_MAX_HASH_BLCK_SIZE)
+		return -EINVAL;
+	in += sizeof(u32);
+
+	state->buf_cnt[0] = tmp;
+	memcpy(state->buffers[0], in, tmp);
+
+	return 0;
+}
+
+struct cc_hash_template {
+	char name[CRYPTO_MAX_ALG_NAME];
+	char driver_name[CRYPTO_MAX_ALG_NAME];
+	char mac_name[CRYPTO_MAX_ALG_NAME];
+	char mac_driver_name[CRYPTO_MAX_ALG_NAME];
+	unsigned int blocksize;
+	bool synchronize;
+	struct ahash_alg template_ahash;
+	int hash_mode;
+	int hw_mode;
+	int inter_digestsize;
+	struct cc_drvdata *drvdata;
+};
+
+#define CC_STATE_SIZE(_x) \
+	((_x) + HASH_LEN_SIZE + CC_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
+
+/* hash descriptors */
+static struct cc_hash_template driver_hash[] = {
+	//Asynchronize hash template
+	{
+		.name = "sha1",
+		.driver_name = "sha1-dx",
+		.mac_name = "hmac(sha1)",
+		.mac_driver_name = "hmac-sha1-dx",
+		.blocksize = SHA1_BLOCK_SIZE,
+		.synchronize = false,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = SHA1_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(SHA1_DIGEST_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_SHA1,
+		.hw_mode = DRV_HASH_HW_SHA1,
+		.inter_digestsize = SHA1_DIGEST_SIZE,
+	},
+	{
+		.name = "sha256",
+		.driver_name = "sha256-dx",
+		.mac_name = "hmac(sha256)",
+		.mac_driver_name = "hmac-sha256-dx",
+		.blocksize = SHA256_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = SHA256_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(SHA256_DIGEST_SIZE)
+			},
+		},
+		.hash_mode = DRV_HASH_SHA256,
+		.hw_mode = DRV_HASH_HW_SHA256,
+		.inter_digestsize = SHA256_DIGEST_SIZE,
+	},
+	{
+		.name = "sha224",
+		.driver_name = "sha224-dx",
+		.mac_name = "hmac(sha224)",
+		.mac_driver_name = "hmac-sha224-dx",
+		.blocksize = SHA224_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = SHA224_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(SHA224_DIGEST_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_SHA224,
+		.hw_mode = DRV_HASH_HW_SHA256,
+		.inter_digestsize = SHA256_DIGEST_SIZE,
+	},
+#if (CC_DEV_SHA_MAX > 256)
+	{
+		.name = "sha384",
+		.driver_name = "sha384-dx",
+		.mac_name = "hmac(sha384)",
+		.mac_driver_name = "hmac-sha384-dx",
+		.blocksize = SHA384_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = SHA384_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(SHA384_DIGEST_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_SHA384,
+		.hw_mode = DRV_HASH_HW_SHA512,
+		.inter_digestsize = SHA512_DIGEST_SIZE,
+	},
+	{
+		.name = "sha512",
+		.driver_name = "sha512-dx",
+		.mac_name = "hmac(sha512)",
+		.mac_driver_name = "hmac-sha512-dx",
+		.blocksize = SHA512_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = SHA512_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(SHA512_DIGEST_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_SHA512,
+		.hw_mode = DRV_HASH_HW_SHA512,
+		.inter_digestsize = SHA512_DIGEST_SIZE,
+	},
+#endif
+	{
+		.name = "md5",
+		.driver_name = "md5-dx",
+		.mac_name = "hmac(md5)",
+		.mac_driver_name = "hmac-md5-dx",
+		.blocksize = MD5_HMAC_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = MD5_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(MD5_DIGEST_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_MD5,
+		.hw_mode = DRV_HASH_HW_MD5,
+		.inter_digestsize = MD5_DIGEST_SIZE,
+	},
+	{
+		.mac_name = "xcbc(aes)",
+		.mac_driver_name = "xcbc-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_mac_update,
+			.final = cc_mac_final,
+			.finup = cc_mac_finup,
+			.digest = cc_mac_digest,
+			.setkey = cc_xcbc_setkey,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.halg = {
+				.digestsize = AES_BLOCK_SIZE,
+				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_NULL,
+		.hw_mode = DRV_CIPHER_XCBC_MAC,
+		.inter_digestsize = AES_BLOCK_SIZE,
+	},
+	{
+		.mac_name = "cmac(aes)",
+		.mac_driver_name = "cmac-aes-dx",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_mac_update,
+			.final = cc_mac_final,
+			.finup = cc_mac_finup,
+			.digest = cc_mac_digest,
+			.setkey = cc_cmac_setkey,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.halg = {
+				.digestsize = AES_BLOCK_SIZE,
+				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_NULL,
+		.hw_mode = DRV_CIPHER_CMAC,
+		.inter_digestsize = AES_BLOCK_SIZE,
+	},
+};
+
+static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template *template,
+					     struct device *dev, bool keyed)
+{
+	struct cc_hash_alg *t_crypto_alg;
+	struct crypto_alg *alg;
+	struct ahash_alg *halg;
+
+	t_crypto_alg = kzalloc(sizeof(*t_crypto_alg), GFP_KERNEL);
+	if (!t_crypto_alg)
+		return ERR_PTR(-ENOMEM);
+
+	t_crypto_alg->ahash_alg = template->template_ahash;
+	halg = &t_crypto_alg->ahash_alg;
+	alg = &halg->halg.base;
+
+	if (keyed) {
+		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+			 template->mac_name);
+		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+			 template->mac_driver_name);
+	} else {
+		halg->setkey = NULL;
+		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+			 template->name);
+		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+			 template->driver_name);
+	}
+	alg->cra_module = THIS_MODULE;
+	alg->cra_ctxsize = sizeof(struct cc_hash_ctx);
+	alg->cra_priority = CC_CRA_PRIO;
+	alg->cra_blocksize = template->blocksize;
+	alg->cra_alignmask = 0;
+	alg->cra_exit = cc_cra_exit;
+
+	alg->cra_init = cc_cra_init;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_TYPE_AHASH |
+			CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->cra_type = &crypto_ahash_type;
+
+	t_crypto_alg->hash_mode = template->hash_mode;
+	t_crypto_alg->hw_mode = template->hw_mode;
+	t_crypto_alg->inter_digestsize = template->inter_digestsize;
+
+	return t_crypto_alg;
+}
+
+int cc_init_hash_sram(struct cc_drvdata *drvdata)
+{
+	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
+	cc_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
+	unsigned int larval_seq_len = 0;
+	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
+	int rc = 0;
+
+	/* Copy-to-sram digest-len */
+	cc_set_sram_desc(digest_len_init, sram_buff_ofs,
+			 ARRAY_SIZE(digest_len_init), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+
+	sram_buff_ofs += sizeof(digest_len_init);
+	larval_seq_len = 0;
+
+#if (CC_DEV_SHA_MAX > 256)
+	/* Copy-to-sram digest-len for sha384/512 */
+	cc_set_sram_desc(digest_len_sha512_init, sram_buff_ofs,
+			 ARRAY_SIZE(digest_len_sha512_init),
+			 larval_seq, &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+
+	sram_buff_ofs += sizeof(digest_len_sha512_init);
+	larval_seq_len = 0;
+#endif
+
+	/* The initial digests offset */
+	hash_handle->larval_digest_sram_addr = sram_buff_ofs;
+
+	/* Copy-to-sram initial SHA* digests */
+	cc_set_sram_desc(md5_init, sram_buff_ofs,
+			 ARRAY_SIZE(md5_init), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+	sram_buff_ofs += sizeof(md5_init);
+	larval_seq_len = 0;
+
+	cc_set_sram_desc(sha1_init, sram_buff_ofs,
+			 ARRAY_SIZE(sha1_init), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+	sram_buff_ofs += sizeof(sha1_init);
+	larval_seq_len = 0;
+
+	cc_set_sram_desc(sha224_init, sram_buff_ofs,
+			 ARRAY_SIZE(sha224_init), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+	sram_buff_ofs += sizeof(sha224_init);
+	larval_seq_len = 0;
+
+	cc_set_sram_desc(sha256_init, sram_buff_ofs,
+			 ARRAY_SIZE(sha256_init), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+	sram_buff_ofs += sizeof(sha256_init);
+	larval_seq_len = 0;
+
+#if (CC_DEV_SHA_MAX > 256)
+	cc_set_sram_desc((u32 *)sha384_init, sram_buff_ofs,
+			 (ARRAY_SIZE(sha384_init) * 2), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+	sram_buff_ofs += sizeof(sha384_init);
+	larval_seq_len = 0;
+
+	cc_set_sram_desc((u32 *)sha512_init, sram_buff_ofs,
+			 (ARRAY_SIZE(sha512_init) * 2), larval_seq,
+			 &larval_seq_len);
+	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+	if (rc)
+		goto init_digest_const_err;
+#endif
+
+init_digest_const_err:
+	return rc;
+}
+
+static void __init cc_swap_dwords(u32 *buf, unsigned long size)
+{
+	int i;
+	u32 tmp;
+
+	for (i = 0; i < size; i += 2) {
+		tmp = buf[i];
+		buf[i] = buf[i + 1];
+		buf[i + 1] = tmp;
+	}
+}
+
+/*
+ * Due to the way the HW works we need to swap every
+ * double word in the SHA384 and SHA512 larval hashes
+ */
+void __init cc_hash_global_init(void)
+{
+	cc_swap_dwords((u32 *)&sha384_init, (ARRAY_SIZE(sha384_init) * 2));
+	cc_swap_dwords((u32 *)&sha512_init, (ARRAY_SIZE(sha512_init) * 2));
+}
+
+int cc_hash_alloc(struct cc_drvdata *drvdata)
+{
+	struct cc_hash_handle *hash_handle;
+	cc_sram_addr_t sram_buff;
+	u32 sram_size_to_alloc;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc = 0;
+	int alg;
+
+	hash_handle = kzalloc(sizeof(*hash_handle), GFP_KERNEL);
+	if (!hash_handle)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&hash_handle->hash_list);
+	drvdata->hash_handle = hash_handle;
+
+	sram_size_to_alloc = sizeof(digest_len_init) +
+#if (CC_DEV_SHA_MAX > 256)
+			sizeof(digest_len_sha512_init) +
+			sizeof(sha384_init) +
+			sizeof(sha512_init) +
+#endif
+			sizeof(md5_init) +
+			sizeof(sha1_init) +
+			sizeof(sha224_init) +
+			sizeof(sha256_init);
+
+	sram_buff = cc_sram_alloc(drvdata, sram_size_to_alloc);
+	if (sram_buff == NULL_SRAM_ADDR) {
+		dev_err(dev, "SRAM pool exhausted\n");
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	/* The initial digest-len offset */
+	hash_handle->digest_len_sram_addr = sram_buff;
+
+	/*must be set before the alg registration as it is being used there*/
+	rc = cc_init_hash_sram(drvdata);
+	if (rc) {
+		dev_err(dev, "Init digest CONST failed (rc=%d)\n", rc);
+		goto fail;
+	}
+
+	/* ahash registration */
+	for (alg = 0; alg < ARRAY_SIZE(driver_hash); alg++) {
+		struct cc_hash_alg *t_alg;
+		int hw_mode = driver_hash[alg].hw_mode;
+
+		/* register hmac version */
+		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			dev_err(dev, "%s alg allocation failed\n",
+				driver_hash[alg].driver_name);
+			goto fail;
+		}
+		t_alg->drvdata = drvdata;
+
+		rc = crypto_register_ahash(&t_alg->ahash_alg);
+		if (rc) {
+			dev_err(dev, "%s alg registration failed\n",
+				driver_hash[alg].driver_name);
+			kfree(t_alg);
+			goto fail;
+		} else {
+			list_add_tail(&t_alg->entry,
+				      &hash_handle->hash_list);
+		}
+
+		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
+		    hw_mode == DRV_CIPHER_CMAC)
+			continue;
+
+		/* register hash version */
+		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, false);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			dev_err(dev, "%s alg allocation failed\n",
+				driver_hash[alg].driver_name);
+			goto fail;
+		}
+		t_alg->drvdata = drvdata;
+
+		rc = crypto_register_ahash(&t_alg->ahash_alg);
+		if (rc) {
+			dev_err(dev, "%s alg registration failed\n",
+				driver_hash[alg].driver_name);
+			kfree(t_alg);
+			goto fail;
+		} else {
+			list_add_tail(&t_alg->entry, &hash_handle->hash_list);
+		}
+	}
+
+	return 0;
+
+fail:
+	kfree(drvdata->hash_handle);
+	drvdata->hash_handle = NULL;
+	return rc;
+}
+
+int cc_hash_free(struct cc_drvdata *drvdata)
+{
+	struct cc_hash_alg *t_hash_alg, *hash_n;
+	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
+
+	if (hash_handle) {
+		list_for_each_entry_safe(t_hash_alg, hash_n,
+					 &hash_handle->hash_list, entry) {
+			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
+			list_del(&t_hash_alg->entry);
+			kfree(t_hash_alg);
+		}
+
+		kfree(hash_handle);
+		drvdata->hash_handle = NULL;
+	}
+	return 0;
+}
+
+static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	struct ahash_req_ctx *state = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	/* Setup XCBC MAC K1 */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
+					    XCBC_MAC_K1_OFFSET),
+		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Setup XCBC MAC K2 */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K2_OFFSET),
+		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Setup XCBC MAC K3 */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K3_OFFSET),
+		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Loading MAC state */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     CC_AES_BLOCK_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+	*seq_size = idx;
+}
+
+static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	struct ahash_req_ctx *state = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	/* Setup CMAC Key */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
+		     ((ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
+		      ctx->key_params.keylen), NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], ctx->key_params.keylen);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Load MAC state */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     CC_AES_BLOCK_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], ctx->key_params.keylen);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	idx++;
+	*seq_size = idx;
+}
+
+static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
+			struct cc_hash_ctx *ctx, unsigned int flow_mode,
+			struct cc_hw_desc desc[], bool is_not_last_data,
+			unsigned int *seq_size)
+{
+	unsigned int idx = *seq_size;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
+
+	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_DLLI) {
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     sg_dma_address(areq_ctx->curr_sg),
+			     areq_ctx->curr_sg->length, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		idx++;
+	} else {
+		if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
+			dev_dbg(dev, " NULL mode\n");
+			/* nothing to build */
+			return;
+		}
+		/* bypass */
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     areq_ctx->mlli_params.mlli_dma_addr,
+			     areq_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[idx], ctx->drvdata->mlli_sram_addr,
+			      areq_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[idx], BYPASS);
+		idx++;
+		/* process */
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI,
+			     ctx->drvdata->mlli_sram_addr,
+			     areq_ctx->mlli_nents, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		idx++;
+	}
+	if (is_not_last_data)
+		set_din_not_last_indication(&desc[(idx - 1)]);
+	/* return updated desc sequence size */
+	*seq_size = idx;
+}
+
+static const void *cc_larval_digest(struct device *dev, u32 mode)
+{
+	switch (mode) {
+	case DRV_HASH_MD5:
+		return md5_init;
+	case DRV_HASH_SHA1:
+		return sha1_init;
+	case DRV_HASH_SHA224:
+		return sha224_init;
+	case DRV_HASH_SHA256:
+		return sha256_init;
+#if (CC_DEV_SHA_MAX > 256)
+	case DRV_HASH_SHA384:
+		return sha384_init;
+	case DRV_HASH_SHA512:
+		return sha512_init;
+#endif
+	default:
+		dev_err(dev, "Invalid hash mode (%d)\n", mode);
+		return md5_init;
+	}
+}
+
+/*!
+ * Gets the address of the initial digest in SRAM
+ * according to the given hash mode
+ *
+ * \param drvdata
+ * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256
+ *
+ * \return u32 The address of the initial digest in SRAM
+ */
+cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
+{
+	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
+	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
+	struct device *dev = drvdata_to_dev(_drvdata);
+
+	switch (mode) {
+	case DRV_HASH_NULL:
+		break; /*Ignore*/
+	case DRV_HASH_MD5:
+		return (hash_handle->larval_digest_sram_addr);
+	case DRV_HASH_SHA1:
+		return (hash_handle->larval_digest_sram_addr +
+			sizeof(md5_init));
+	case DRV_HASH_SHA224:
+		return (hash_handle->larval_digest_sram_addr +
+			sizeof(md5_init) +
+			sizeof(sha1_init));
+	case DRV_HASH_SHA256:
+		return (hash_handle->larval_digest_sram_addr +
+			sizeof(md5_init) +
+			sizeof(sha1_init) +
+			sizeof(sha224_init));
+#if (CC_DEV_SHA_MAX > 256)
+	case DRV_HASH_SHA384:
+		return (hash_handle->larval_digest_sram_addr +
+			sizeof(md5_init) +
+			sizeof(sha1_init) +
+			sizeof(sha224_init) +
+			sizeof(sha256_init));
+	case DRV_HASH_SHA512:
+		return (hash_handle->larval_digest_sram_addr +
+			sizeof(md5_init) +
+			sizeof(sha1_init) +
+			sizeof(sha224_init) +
+			sizeof(sha256_init) +
+			sizeof(sha384_init));
+#endif
+	default:
+		dev_err(dev, "Invalid hash mode (%d)\n", mode);
+	}
+
+	/*This is valid wrong value to avoid kernel crash*/
+	return hash_handle->larval_digest_sram_addr;
+}
+
+cc_sram_addr_t
+cc_digest_len_addr(void *drvdata, u32 mode)
+{
+	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
+	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
+	cc_sram_addr_t digest_len_addr = hash_handle->digest_len_sram_addr;
+
+	switch (mode) {
+	case DRV_HASH_SHA1:
+	case DRV_HASH_SHA224:
+	case DRV_HASH_SHA256:
+	case DRV_HASH_MD5:
+		return digest_len_addr;
+#if (CC_DEV_SHA_MAX > 256)
+	case DRV_HASH_SHA384:
+	case DRV_HASH_SHA512:
+		return  digest_len_addr + sizeof(digest_len_init);
+#endif
+	default:
+		return digest_len_addr; /*to avoid kernel crash*/
+	}
+}
+
diff --git a/drivers/staging/ccree/cc_hash.h b/drivers/staging/ccree/cc_hash.h
new file mode 100644
index 0000000..aa42b8f
--- /dev/null
+++ b/drivers/staging/ccree/cc_hash.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_hash.h
+ * ARM CryptoCell Hash Crypto API
+ */
+
+#ifndef __CC_HASH_H__
+#define __CC_HASH_H__
+
+#include "cc_buffer_mgr.h"
+
+#define HMAC_IPAD_CONST	0x36363636
+#define HMAC_OPAD_CONST	0x5C5C5C5C
+#if (CC_DEV_SHA_MAX > 256)
+#define HASH_LEN_SIZE 16
+#define CC_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
+#define CC_MAX_HASH_BLCK_SIZE SHA512_BLOCK_SIZE
+#else
+#define HASH_LEN_SIZE 8
+#define CC_MAX_HASH_DIGEST_SIZE	SHA256_DIGEST_SIZE
+#define CC_MAX_HASH_BLCK_SIZE SHA256_BLOCK_SIZE
+#endif
+
+#define XCBC_MAC_K1_OFFSET 0
+#define XCBC_MAC_K2_OFFSET 16
+#define XCBC_MAC_K3_OFFSET 32
+
+#define CC_EXPORT_MAGIC 0xC2EE1070U
+
+/* this struct was taken from drivers/crypto/nx/nx-aes-xcbc.c and it is used
+ * for xcbc/cmac statesize
+ */
+struct aeshash_state {
+	u8 state[AES_BLOCK_SIZE];
+	unsigned int count;
+	u8 buffer[AES_BLOCK_SIZE];
+};
+
+/* ahash state */
+struct ahash_req_ctx {
+	u8 buffers[2][CC_MAX_HASH_BLCK_SIZE] ____cacheline_aligned;
+	u8 digest_result_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 digest_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 opad_digest_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 digest_bytes_len[HASH_LEN_SIZE] ____cacheline_aligned;
+	struct async_gen_req_ctx gen_ctx ____cacheline_aligned;
+	enum cc_req_dma_buf_type data_dma_buf_type;
+	dma_addr_t opad_digest_dma_addr;
+	dma_addr_t digest_buff_dma_addr;
+	dma_addr_t digest_bytes_len_dma_addr;
+	dma_addr_t digest_result_dma_addr;
+	u32 buf_cnt[2];
+	u32 buff_index;
+	u32 xcbc_count; /* count xcbc update operatations */
+	struct scatterlist buff_sg[2];
+	struct scatterlist *curr_sg;
+	u32 in_nents;
+	u32 mlli_nents;
+	struct mlli_params mlli_params;
+};
+
+static inline u32 *cc_hash_buf_cnt(struct ahash_req_ctx *state)
+{
+	return &state->buf_cnt[state->buff_index];
+}
+
+static inline u8 *cc_hash_buf(struct ahash_req_ctx *state)
+{
+	return state->buffers[state->buff_index];
+}
+
+static inline u32 *cc_next_buf_cnt(struct ahash_req_ctx *state)
+{
+	return &state->buf_cnt[state->buff_index ^ 1];
+}
+
+static inline u8 *cc_next_buf(struct ahash_req_ctx *state)
+{
+	return state->buffers[state->buff_index ^ 1];
+}
+
+int cc_hash_alloc(struct cc_drvdata *drvdata);
+int cc_init_hash_sram(struct cc_drvdata *drvdata);
+int cc_hash_free(struct cc_drvdata *drvdata);
+
+/*!
+ * Gets the initial digest length
+ *
+ * \param drvdata
+ * \param mode The Hash mode. Supported modes:
+ *             MD5/SHA1/SHA224/SHA256/SHA384/SHA512
+ *
+ * \return u32 returns the address of the initial digest length in SRAM
+ */
+cc_sram_addr_t
+cc_digest_len_addr(void *drvdata, u32 mode);
+
+/*!
+ * Gets the address of the initial digest in SRAM
+ * according to the given hash mode
+ *
+ * \param drvdata
+ * \param mode The Hash mode. Supported modes:
+ *             MD5/SHA1/SHA224/SHA256/SHA384/SHA512
+ *
+ * \return u32 The address of the initial digest in SRAM
+ */
+cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
+
+void cc_hash_global_init(void);
+
+#endif /*__CC_HASH_H__*/
+
diff --git a/drivers/staging/ccree/cc_host_regs.h b/drivers/staging/ccree/cc_host_regs.h
new file mode 100644
index 0000000..69ef2fa
--- /dev/null
+++ b/drivers/staging/ccree/cc_host_regs.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_HOST_H__
+#define __CC_HOST_H__
+
+// --------------------------------------
+// BLOCK: HOST_P
+// --------------------------------------
+#define CC_HOST_IRR_REG_OFFSET	0xA00UL
+#define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SHIFT	0x2UL
+#define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT	0x8UL
+#define CC_HOST_IRR_AXI_ERR_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_GPR0_BIT_SHIFT	0xBUL
+#define CC_HOST_IRR_GPR0_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SHIFT	0x13UL
+#define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT	0x17UL
+#define CC_HOST_IRR_AXIM_COMP_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REG_OFFSET	0xA04UL
+#define CC_HOST_IMR_NOT_USED_MASK_BIT_SHIFT	0x1UL
+#define CC_HOST_IMR_NOT_USED_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SHIFT	0x2UL
+#define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_AXI_ERR_MASK_BIT_SHIFT	0x8UL
+#define CC_HOST_IMR_AXI_ERR_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_GPR0_BIT_SHIFT	0xBUL
+#define CC_HOST_IMR_GPR0_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SHIFT	0x13UL
+#define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SHIFT	0x17UL
+#define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_REG_OFFSET	0xA08UL
+#define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SHIFT	0x2UL
+#define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_AXI_ERR_CLEAR_BIT_SHIFT	0x8UL
+#define CC_HOST_ICR_AXI_ERR_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_GPR_INT_CLEAR_BIT_SHIFT	0xBUL
+#define CC_HOST_ICR_GPR_INT_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SHIFT	0x13UL
+#define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT	0x17UL
+#define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_SIGNATURE_REG_OFFSET	0xA24UL
+#define CC_HOST_SIGNATURE_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_SIGNATURE_VALUE_BIT_SIZE	0x20UL
+#define CC_HOST_BOOT_REG_OFFSET	0xA28UL
+#define CC_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SHIFT	0x0UL
+#define CC_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SHIFT	0x1UL
+#define CC_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SHIFT	0x2UL
+#define CC_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SHIFT	0x3UL
+#define CC_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SHIFT	0x5UL
+#define CC_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SHIFT	0x6UL
+#define CC_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SIZE	0x3UL
+#define CC_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SHIFT	0x9UL
+#define CC_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SHIFT	0xAUL
+#define CC_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SHIFT	0xBUL
+#define CC_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SHIFT	0xCUL
+#define CC_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SHIFT	0xDUL
+#define CC_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SHIFT	0xEUL
+#define CC_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SHIFT	0xFUL
+#define CC_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SHIFT	0x10UL
+#define CC_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SHIFT	0x11UL
+#define CC_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SHIFT	0x12UL
+#define CC_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SHIFT	0x13UL
+#define CC_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SHIFT	0x14UL
+#define CC_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SHIFT	0x15UL
+#define CC_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SHIFT	0x16UL
+#define CC_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SHIFT	0x17UL
+#define CC_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SHIFT	0x18UL
+#define CC_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SHIFT	0x19UL
+#define CC_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SHIFT	0x1AUL
+#define CC_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SHIFT	0x1BUL
+#define CC_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SHIFT	0x1CUL
+#define CC_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SHIFT	0x1DUL
+#define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SHIFT	0x1EUL
+#define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_VERSION_REG_OFFSET	0xA40UL
+#define CC_HOST_VERSION_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_VERSION_VALUE_BIT_SIZE	0x20UL
+#define CC_HOST_KFDE0_VALID_REG_OFFSET	0xA60UL
+#define CC_HOST_KFDE0_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE0_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_KFDE1_VALID_REG_OFFSET	0xA64UL
+#define CC_HOST_KFDE1_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE1_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_KFDE2_VALID_REG_OFFSET	0xA68UL
+#define CC_HOST_KFDE2_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE2_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_KFDE3_VALID_REG_OFFSET	0xA6CUL
+#define CC_HOST_KFDE3_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE3_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_GPR0_REG_OFFSET	0xA70UL
+#define CC_HOST_GPR0_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_GPR0_VALUE_BIT_SIZE	0x20UL
+#define CC_GPR_HOST_REG_OFFSET	0xA74UL
+#define CC_GPR_HOST_VALUE_BIT_SHIFT	0x0UL
+#define CC_GPR_HOST_VALUE_BIT_SIZE	0x20UL
+#define CC_HOST_POWER_DOWN_EN_REG_OFFSET	0xA78UL
+#define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SIZE	0x1UL
+// --------------------------------------
+// BLOCK: HOST_SRAM
+// --------------------------------------
+#define CC_SRAM_DATA_REG_OFFSET	0xF00UL
+#define CC_SRAM_DATA_VALUE_BIT_SHIFT	0x0UL
+#define CC_SRAM_DATA_VALUE_BIT_SIZE	0x20UL
+#define CC_SRAM_ADDR_REG_OFFSET	0xF04UL
+#define CC_SRAM_ADDR_VALUE_BIT_SHIFT	0x0UL
+#define CC_SRAM_ADDR_VALUE_BIT_SIZE	0xFUL
+#define CC_SRAM_DATA_READY_REG_OFFSET	0xF08UL
+#define CC_SRAM_DATA_READY_VALUE_BIT_SHIFT	0x0UL
+#define CC_SRAM_DATA_READY_VALUE_BIT_SIZE	0x1UL
+
+#endif //__CC_HOST_H__
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index bfc18b3..a79f28ce 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -6,7 +6,7 @@
 
 #include <linux/types.h>
 
-#include "dx_crys_kernel.h"
+#include "cc_kernel_regs.h"
 #include <linux/bitfield.h>
 
 /******************************************************************************
diff --git a/drivers/staging/ccree/cc_ivgen.c b/drivers/staging/ccree/cc_ivgen.c
new file mode 100644
index 0000000..43f70d4
--- /dev/null
+++ b/drivers/staging/ccree/cc_ivgen.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/platform_device.h>
+#include <crypto/ctr.h>
+#include "cc_driver.h"
+#include "cc_ivgen.h"
+#include "cc_request_mgr.h"
+#include "cc_sram_mgr.h"
+#include "cc_buffer_mgr.h"
+
+/* The max. size of pool *MUST* be <= SRAM total size */
+#define CC_IVPOOL_SIZE 1024
+/* The first 32B fraction of pool are dedicated to the
+ * next encryption "key" & "IV" for pool regeneration
+ */
+#define CC_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
+#define CC_IVPOOL_GEN_SEQ_LEN	4
+
+/**
+ * struct cc_ivgen_ctx -IV pool generation context
+ * @pool:          the start address of the iv-pool resides in internal RAM
+ * @ctr_key_dma:   address of pool's encryption key material in internal RAM
+ * @ctr_iv_dma:    address of pool's counter iv in internal RAM
+ * @next_iv_ofs:   the offset to the next available IV in pool
+ * @pool_meta:     virt. address of the initial enc. key/IV
+ * @pool_meta_dma: phys. address of the initial enc. key/IV
+ */
+struct cc_ivgen_ctx {
+	cc_sram_addr_t pool;
+	cc_sram_addr_t ctr_key;
+	cc_sram_addr_t ctr_iv;
+	u32 next_iv_ofs;
+	u8 *pool_meta;
+	dma_addr_t pool_meta_dma;
+};
+
+/*!
+ * Generates CC_IVPOOL_SIZE of random bytes by
+ * encrypting 0's using AES128-CTR.
+ *
+ * \param ivgen iv-pool context
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length
+ */
+static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
+			  struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
+{
+	unsigned int idx = *iv_seq_len;
+
+	if ((*iv_seq_len + CC_IVPOOL_GEN_SEQ_LEN) > CC_IVPOOL_SEQ_LEN) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+	/* Setup key */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_key, AES_KEYSIZE_128);
+	set_setup_mode(&iv_seq[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
+	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
+	idx++;
+
+	/* Setup cipher state */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_iv, CC_AES_IV_SIZE);
+	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
+	set_setup_mode(&iv_seq[idx], SETUP_LOAD_STATE1);
+	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
+	idx++;
+
+	/* Perform dummy encrypt to skip first block */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_const(&iv_seq[idx], 0, CC_AES_IV_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_AES_IV_SIZE);
+	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
+	idx++;
+
+	/* Generate IV pool */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_const(&iv_seq[idx], 0, CC_IVPOOL_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_IVPOOL_SIZE);
+	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
+	idx++;
+
+	*iv_seq_len = idx; /* Update sequence length */
+
+	/* queue ordering assures pool readiness */
+	ivgen_ctx->next_iv_ofs = CC_IVPOOL_META_SIZE;
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
+int cc_init_iv_sram(struct cc_drvdata *drvdata)
+{
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
+	unsigned int iv_seq_len = 0;
+	int rc;
+
+	/* Generate initial enc. key/iv */
+	get_random_bytes(ivgen_ctx->pool_meta, CC_IVPOOL_META_SIZE);
+
+	/* The first 32B reserved for the enc. Key/IV */
+	ivgen_ctx->ctr_key = ivgen_ctx->pool;
+	ivgen_ctx->ctr_iv = ivgen_ctx->pool + AES_KEYSIZE_128;
+
+	/* Copy initial enc. key and IV to SRAM at a single descriptor */
+	hw_desc_init(&iv_seq[iv_seq_len]);
+	set_din_type(&iv_seq[iv_seq_len], DMA_DLLI, ivgen_ctx->pool_meta_dma,
+		     CC_IVPOOL_META_SIZE, NS_BIT);
+	set_dout_sram(&iv_seq[iv_seq_len], ivgen_ctx->pool,
+		      CC_IVPOOL_META_SIZE);
+	set_flow_mode(&iv_seq[iv_seq_len], BYPASS);
+	iv_seq_len++;
+
+	/* Generate initial pool */
+	rc = cc_gen_iv_pool(ivgen_ctx, iv_seq, &iv_seq_len);
+	if (rc)
+		return rc;
+
+	/* Fire-and-forget */
+	return send_request_init(drvdata, iv_seq, iv_seq_len);
+}
+
+/*!
+ * Free iv-pool and ivgen context.
+ *
+ * \param drvdata
+ */
+void cc_ivgen_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct device *device = &drvdata->plat_dev->dev;
+
+	if (!ivgen_ctx)
+		return;
+
+	if (ivgen_ctx->pool_meta) {
+		memset(ivgen_ctx->pool_meta, 0, CC_IVPOOL_META_SIZE);
+		dma_free_coherent(device, CC_IVPOOL_META_SIZE,
+				  ivgen_ctx->pool_meta,
+				  ivgen_ctx->pool_meta_dma);
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
+int cc_ivgen_init(struct cc_drvdata *drvdata)
+{
+	struct cc_ivgen_ctx *ivgen_ctx;
+	struct device *device = &drvdata->plat_dev->dev;
+	int rc;
+
+	/* Allocate "this" context */
+	ivgen_ctx = kzalloc(sizeof(*ivgen_ctx), GFP_KERNEL);
+	if (!ivgen_ctx)
+		return -ENOMEM;
+
+	/* Allocate pool's header for initial enc. key/IV */
+	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
+						  &ivgen_ctx->pool_meta_dma,
+						  GFP_KERNEL);
+	if (!ivgen_ctx->pool_meta) {
+		dev_err(device, "Not enough memory to allocate DMA of pool_meta (%u B)\n",
+			CC_IVPOOL_META_SIZE);
+		rc = -ENOMEM;
+		goto out;
+	}
+	/* Allocate IV pool in SRAM */
+	ivgen_ctx->pool = cc_sram_alloc(drvdata, CC_IVPOOL_SIZE);
+	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
+		dev_err(device, "SRAM pool exhausted\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	drvdata->ivgen_handle = ivgen_ctx;
+
+	return cc_init_iv_sram(drvdata);
+
+out:
+	cc_ivgen_fini(drvdata);
+	return rc;
+}
+
+/*!
+ * Acquires 16 Bytes IV from the iv-pool
+ *
+ * \param drvdata Driver private context
+ * \param iv_out_dma Array of physical IV out addresses
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements
+ *                       of iv_out_dma array are ignore)
+ * \param iv_out_size May be 8 or 16 bytes long
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
+	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
+	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
+{
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	unsigned int idx = *iv_seq_len;
+	struct device *dev = drvdata_to_dev(drvdata);
+	unsigned int t;
+
+	if (iv_out_size != CC_AES_IV_SIZE &&
+	    iv_out_size != CTR_RFC3686_IV_SIZE) {
+		return -EINVAL;
+	}
+	if ((iv_out_dma_len + 1) > CC_IVPOOL_SEQ_LEN) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+
+	/* check that number of generated IV is limited to max dma address
+	 * iv buffer size
+	 */
+	if (iv_out_dma_len > CC_MAX_IVGEN_DMA_ADDRESSES) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+
+	for (t = 0; t < iv_out_dma_len; t++) {
+		/* Acquire IV from pool */
+		hw_desc_init(&iv_seq[idx]);
+		set_din_sram(&iv_seq[idx], (ivgen_ctx->pool +
+					    ivgen_ctx->next_iv_ofs),
+			     iv_out_size);
+		set_dout_dlli(&iv_seq[idx], iv_out_dma[t], iv_out_size,
+			      NS_BIT, 0);
+		set_flow_mode(&iv_seq[idx], BYPASS);
+		idx++;
+	}
+
+	/* Bypass operation is proceeded by crypto sequence, hence must
+	 *  assure bypass-write-transaction by a memory barrier
+	 */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_no_dma(&iv_seq[idx], 0, 0xfffff0);
+	set_dout_no_dma(&iv_seq[idx], 0, 0, 1);
+	idx++;
+
+	*iv_seq_len = idx; /* update seq length */
+
+	/* Update iv index */
+	ivgen_ctx->next_iv_ofs += iv_out_size;
+
+	if ((CC_IVPOOL_SIZE - ivgen_ctx->next_iv_ofs) < CC_AES_IV_SIZE) {
+		dev_dbg(dev, "Pool exhausted, regenerating iv-pool\n");
+		/* pool is drained -regenerate it! */
+		return cc_gen_iv_pool(ivgen_ctx, iv_seq, iv_seq_len);
+	}
+
+	return 0;
+}
+
diff --git a/drivers/staging/ccree/cc_ivgen.h b/drivers/staging/ccree/cc_ivgen.h
new file mode 100644
index 0000000..b6ac169
--- /dev/null
+++ b/drivers/staging/ccree/cc_ivgen.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_IVGEN_H__
+#define __CC_IVGEN_H__
+
+#include "cc_hw_queue_defs.h"
+
+#define CC_IVPOOL_SEQ_LEN 8
+
+/*!
+ * Allocates iv-pool and maps resources.
+ * This function generates the first IV pool.
+ *
+ * \param drvdata Driver's private context
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_ivgen_init(struct cc_drvdata *drvdata);
+
+/*!
+ * Free iv-pool and ivgen context.
+ *
+ * \param drvdata
+ */
+void cc_ivgen_fini(struct cc_drvdata *drvdata);
+
+/*!
+ * Generates the initial pool in SRAM.
+ * This function should be invoked when resuming DX driver.
+ *
+ * \param drvdata
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_init_iv_sram(struct cc_drvdata *drvdata);
+
+/*!
+ * Acquires 16 Bytes IV from the iv-pool
+ *
+ * \param drvdata Driver private context
+ * \param iv_out_dma Array of physical IV out addresses
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements of
+ *                       iv_out_dma array are ignore)
+ * \param iv_out_size May be 8 or 16 bytes long
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
+	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
+	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len);
+
+#endif /*__CC_IVGEN_H__*/
diff --git a/drivers/staging/ccree/cc_kernel_regs.h b/drivers/staging/ccree/cc_kernel_regs.h
new file mode 100644
index 0000000..fa99440
--- /dev/null
+++ b/drivers/staging/ccree/cc_kernel_regs.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_CRYS_KERNEL_H__
+#define __CC_CRYS_KERNEL_H__
+
+// --------------------------------------
+// BLOCK: DSCRPTR
+// --------------------------------------
+#define CC_DSCRPTR_COMPLETION_COUNTER_REG_OFFSET	0xE00UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SIZE	0x6UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SHIFT	0x6UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_SW_RESET_REG_OFFSET	0xE40UL
+#define CC_DSCRPTR_SW_RESET_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_SW_RESET_VALUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_REG_OFFSET	0xE60UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SIZE	0xAUL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SHIFT	0xAUL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SIZE	0xCUL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SHIFT	0x16UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SIZE	0x3UL
+#define CC_DSCRPTR_SINGLE_ADDR_EN_REG_OFFSET	0xE64UL
+#define CC_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_MEASURE_CNTR_REG_OFFSET	0xE68UL
+#define CC_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD0_REG_OFFSET	0xE80UL
+#define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD1_REG_OFFSET	0xE84UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SHIFT	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE	0x18UL
+#define CC_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SHIFT	0x1AUL
+#define CC_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SHIFT	0x1BUL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SHIFT	0x1CUL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SHIFT	0x1DUL
+#define CC_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SHIFT	0x1EUL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD2_REG_OFFSET	0xE88UL
+#define CC_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD3_REG_OFFSET	0xE8CUL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SHIFT	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SIZE	0x18UL
+#define CC_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SHIFT	0x1AUL
+#define CC_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SHIFT	0x1BUL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SHIFT	0x1DUL
+#define CC_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SHIFT	0x1EUL
+#define CC_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SHIFT	0x1FUL
+#define CC_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_REG_OFFSET	0xE90UL
+#define CC_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SIZE	0x6UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SHIFT	0x6UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SHIFT	0x7UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SHIFT	0x8UL
+#define CC_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SHIFT	0xAUL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SIZE	0x4UL
+#define CC_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SHIFT	0xEUL
+#define CC_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SHIFT	0xFUL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SHIFT	0x11UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SHIFT	0x13UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SHIFT	0x14UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SHIFT	0x16UL
+#define CC_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SHIFT	0x18UL
+#define CC_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SIZE	0x4UL
+#define CC_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SHIFT	0x1CUL
+#define CC_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SHIFT	0x1DUL
+#define CC_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SHIFT	0x1EUL
+#define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SHIFT	0x1FUL
+#define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD5_REG_OFFSET	0xE94UL
+#define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SIZE	0x10UL
+#define CC_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SHIFT	0x10UL
+#define CC_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SIZE	0x10UL
+#define CC_DSCRPTR_QUEUE_WATERMARK_REG_OFFSET	0xE98UL
+#define CC_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SIZE	0xAUL
+#define CC_DSCRPTR_QUEUE_CONTENT_REG_OFFSET	0xE9CUL
+#define CC_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SIZE	0xAUL
+// --------------------------------------
+// BLOCK: AXI_P
+// --------------------------------------
+#define CC_AXIM_MON_INFLIGHT_REG_OFFSET	0xB00UL
+#define CC_AXIM_MON_INFLIGHT_VALUE_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_INFLIGHT_VALUE_BIT_SIZE	0x8UL
+#define CC_AXIM_MON_INFLIGHTLAST_REG_OFFSET	0xB40UL
+#define CC_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SIZE	0x8UL
+#define CC_AXIM_MON_COMP_REG_OFFSET	0xB80UL
+#define CC_AXIM_MON_COMP_VALUE_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_COMP_VALUE_BIT_SIZE	0x10UL
+#define CC_AXIM_MON_ERR_REG_OFFSET	0xBC4UL
+#define CC_AXIM_MON_ERR_BRESP_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_ERR_BRESP_BIT_SIZE	0x2UL
+#define CC_AXIM_MON_ERR_BID_BIT_SHIFT	0x2UL
+#define CC_AXIM_MON_ERR_BID_BIT_SIZE	0x4UL
+#define CC_AXIM_MON_ERR_RRESP_BIT_SHIFT	0x10UL
+#define CC_AXIM_MON_ERR_RRESP_BIT_SIZE	0x2UL
+#define CC_AXIM_MON_ERR_RID_BIT_SHIFT	0x12UL
+#define CC_AXIM_MON_ERR_RID_BIT_SIZE	0x4UL
+#define CC_AXIM_CFG_REG_OFFSET	0xBE8UL
+#define CC_AXIM_CFG_BRESPMASK_BIT_SHIFT	0x4UL
+#define CC_AXIM_CFG_BRESPMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_CFG_RRESPMASK_BIT_SHIFT	0x5UL
+#define CC_AXIM_CFG_RRESPMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_CFG_INFLTMASK_BIT_SHIFT	0x6UL
+#define CC_AXIM_CFG_INFLTMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_CFG_COMPMASK_BIT_SHIFT	0x7UL
+#define CC_AXIM_CFG_COMPMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_ACE_CONST_REG_OFFSET	0xBECUL
+#define CC_AXIM_ACE_CONST_ARDOMAIN_BIT_SHIFT	0x0UL
+#define CC_AXIM_ACE_CONST_ARDOMAIN_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_AWDOMAIN_BIT_SHIFT	0x2UL
+#define CC_AXIM_ACE_CONST_AWDOMAIN_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_ARBAR_BIT_SHIFT	0x4UL
+#define CC_AXIM_ACE_CONST_ARBAR_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_AWBAR_BIT_SHIFT	0x6UL
+#define CC_AXIM_ACE_CONST_AWBAR_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_ARSNOOP_BIT_SHIFT	0x8UL
+#define CC_AXIM_ACE_CONST_ARSNOOP_BIT_SIZE	0x4UL
+#define CC_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SHIFT	0xCUL
+#define CC_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SIZE	0x3UL
+#define CC_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SHIFT	0xFUL
+#define CC_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SIZE	0x3UL
+#define CC_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SHIFT	0x12UL
+#define CC_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SIZE	0x7UL
+#define CC_AXIM_ACE_CONST_AWLEN_VAL_BIT_SHIFT	0x19UL
+#define CC_AXIM_ACE_CONST_AWLEN_VAL_BIT_SIZE	0x4UL
+#define CC_AXIM_CACHE_PARAMS_REG_OFFSET	0xBF0UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SHIFT	0x0UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SIZE	0x4UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_BIT_SHIFT	0x4UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_BIT_SIZE	0x4UL
+#define CC_AXIM_CACHE_PARAMS_ARCACHE_BIT_SHIFT	0x8UL
+#define CC_AXIM_CACHE_PARAMS_ARCACHE_BIT_SIZE	0x4UL
+#endif	// __CC_CRYS_KERNEL_H__
diff --git a/drivers/staging/ccree/cc_pm.c b/drivers/staging/ccree/cc_pm.c
new file mode 100644
index 0000000..1f5da86
--- /dev/null
+++ b/drivers/staging/ccree/cc_pm.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <crypto/ctr.h>
+#include <linux/pm_runtime.h>
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_request_mgr.h"
+#include "cc_sram_mgr.h"
+#include "cc_ivgen.h"
+#include "cc_hash.h"
+#include "cc_pm.h"
+
+#define POWER_DOWN_ENABLE 0x01
+#define POWER_DOWN_DISABLE 0x00
+
+const struct dev_pm_ops ccree_pm = {
+	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
+};
+
+int cc_pm_suspend(struct device *dev)
+{
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+	int rc;
+
+	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
+	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
+	rc = cc_suspend_req_queue(drvdata);
+	if (rc) {
+		dev_err(dev, "cc_suspend_req_queue (%x)\n",
+			rc);
+		return rc;
+	}
+	fini_cc_regs(drvdata);
+	cc_clk_off(drvdata);
+	return 0;
+}
+
+int cc_pm_resume(struct device *dev)
+{
+	int rc;
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
+	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
+
+	rc = cc_clk_on(drvdata);
+	if (rc) {
+		dev_err(dev, "failed getting clock back on. We're toast.\n");
+		return rc;
+	}
+
+	rc = init_cc_regs(drvdata, false);
+	if (rc) {
+		dev_err(dev, "init_cc_regs (%x)\n", rc);
+		return rc;
+	}
+
+	rc = cc_resume_req_queue(drvdata);
+	if (rc) {
+		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
+		return rc;
+	}
+
+	/* must be after the queue resuming as it uses the HW queue*/
+	cc_init_hash_sram(drvdata);
+
+	cc_init_iv_sram(drvdata);
+	return 0;
+}
+
+int cc_pm_get(struct device *dev)
+{
+	int rc = 0;
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+
+	if (cc_req_queue_suspended(drvdata))
+		rc = pm_runtime_get_sync(dev);
+	else
+		pm_runtime_get_noresume(dev);
+
+	return rc;
+}
+
+int cc_pm_put_suspend(struct device *dev)
+{
+	int rc = 0;
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+
+	if (!cc_req_queue_suspended(drvdata)) {
+		pm_runtime_mark_last_busy(dev);
+		rc = pm_runtime_put_autosuspend(dev);
+	} else {
+		/* Something wrong happens*/
+		dev_err(dev, "request to suspend already suspended queue");
+		rc = -EBUSY;
+	}
+	return rc;
+}
+
+int cc_pm_init(struct cc_drvdata *drvdata)
+{
+	int rc = 0;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/* must be before the enabling to avoid resdundent suspending */
+	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(dev);
+	/* activate the PM module */
+	rc = pm_runtime_set_active(dev);
+	if (rc)
+		return rc;
+	/* enable the PM module*/
+	pm_runtime_enable(dev);
+
+	return rc;
+}
+
+void cc_pm_fini(struct cc_drvdata *drvdata)
+{
+	pm_runtime_disable(drvdata_to_dev(drvdata));
+}
diff --git a/drivers/staging/ccree/cc_pm.h b/drivers/staging/ccree/cc_pm.h
new file mode 100644
index 0000000..aac8190
--- /dev/null
+++ b/drivers/staging/ccree/cc_pm.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_pm.h
+ */
+
+#ifndef __CC_POWER_MGR_H__
+#define __CC_POWER_MGR_H__
+
+#include "cc_driver.h"
+
+#define CC_SUSPEND_TIMEOUT 3000
+
+#if defined(CONFIG_PM)
+
+extern const struct dev_pm_ops ccree_pm;
+
+int cc_pm_init(struct cc_drvdata *drvdata);
+void cc_pm_fini(struct cc_drvdata *drvdata);
+int cc_pm_suspend(struct device *dev);
+int cc_pm_resume(struct device *dev);
+int cc_pm_get(struct device *dev);
+int cc_pm_put_suspend(struct device *dev);
+
+#else
+
+static inline int cc_pm_init(struct cc_drvdata *drvdata)
+{
+	return 0;
+}
+
+static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
+
+static inline int cc_pm_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_resume(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_get(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_put_suspend(struct device *dev)
+{
+	return 0;
+}
+
+#endif
+
+#endif /*__POWER_MGR_H__*/
+
diff --git a/drivers/staging/ccree/cc_request_mgr.c b/drivers/staging/ccree/cc_request_mgr.c
new file mode 100644
index 0000000..cbcfcc3
--- /dev/null
+++ b/drivers/staging/ccree/cc_request_mgr.c
@@ -0,0 +1,719 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <crypto/ctr.h>
+#include <linux/pm_runtime.h>
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_request_mgr.h"
+#include "cc_ivgen.h"
+#include "cc_pm.h"
+
+#define CC_MAX_POLL_ITER	10
+/* The highest descriptor count in used */
+#define CC_MAX_DESC_SEQ_LEN	23
+
+struct cc_req_mgr_handle {
+	/* Request manager resources */
+	unsigned int hw_queue_size; /* HW capability */
+	unsigned int min_free_hw_slots;
+	unsigned int max_used_sw_slots;
+	struct cc_crypto_req req_queue[MAX_REQUEST_QUEUE_SIZE];
+	u32 req_queue_head;
+	u32 req_queue_tail;
+	u32 axi_completed;
+	u32 q_free_slots;
+	/* This lock protects access to HW register
+	 * that must be single request at a time
+	 */
+	spinlock_t hw_lock;
+	struct cc_hw_desc compl_desc;
+	u8 *dummy_comp_buff;
+	dma_addr_t dummy_comp_buff_dma;
+
+	/* backlog queue */
+	struct list_head backlog;
+	unsigned int bl_len;
+	spinlock_t bl_lock; /* protect backlog queue */
+
+#ifdef COMP_IN_WQ
+	struct workqueue_struct *workq;
+	struct delayed_work compwork;
+#else
+	struct tasklet_struct comptask;
+#endif
+	bool is_runtime_suspended;
+};
+
+struct cc_bl_item {
+	struct cc_crypto_req creq;
+	struct cc_hw_desc desc[CC_MAX_DESC_SEQ_LEN];
+	unsigned int len;
+	struct list_head list;
+	bool notif;
+};
+
+static void comp_handler(unsigned long devarg);
+#ifdef COMP_IN_WQ
+static void comp_work_handler(struct work_struct *work);
+#endif
+
+void cc_req_mgr_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	if (!req_mgr_h)
+		return; /* Not allocated */
+
+	if (req_mgr_h->dummy_comp_buff_dma) {
+		dma_free_coherent(dev, sizeof(u32), req_mgr_h->dummy_comp_buff,
+				  req_mgr_h->dummy_comp_buff_dma);
+	}
+
+	dev_dbg(dev, "max_used_hw_slots=%d\n", (req_mgr_h->hw_queue_size -
+						req_mgr_h->min_free_hw_slots));
+	dev_dbg(dev, "max_used_sw_slots=%d\n", req_mgr_h->max_used_sw_slots);
+
+#ifdef COMP_IN_WQ
+	flush_workqueue(req_mgr_h->workq);
+	destroy_workqueue(req_mgr_h->workq);
+#else
+	/* Kill tasklet */
+	tasklet_kill(&req_mgr_h->comptask);
+#endif
+	memset(req_mgr_h, 0, sizeof(struct cc_req_mgr_handle));
+	kfree(req_mgr_h);
+	drvdata->request_mgr_handle = NULL;
+}
+
+int cc_req_mgr_init(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *req_mgr_h;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc = 0;
+
+	req_mgr_h = kzalloc(sizeof(*req_mgr_h), GFP_KERNEL);
+	if (!req_mgr_h) {
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+
+	drvdata->request_mgr_handle = req_mgr_h;
+
+	spin_lock_init(&req_mgr_h->hw_lock);
+	spin_lock_init(&req_mgr_h->bl_lock);
+	INIT_LIST_HEAD(&req_mgr_h->backlog);
+
+#ifdef COMP_IN_WQ
+	dev_dbg(dev, "Initializing completion workqueue\n");
+	req_mgr_h->workq = create_singlethread_workqueue("arm_cc7x_wq");
+	if (!req_mgr_h->workq) {
+		dev_err(dev, "Failed creating work queue\n");
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
+#else
+	dev_dbg(dev, "Initializing completion tasklet\n");
+	tasklet_init(&req_mgr_h->comptask, comp_handler,
+		     (unsigned long)drvdata);
+#endif
+	req_mgr_h->hw_queue_size = cc_ioread(drvdata,
+					     CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
+	dev_dbg(dev, "hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
+	if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
+		dev_err(dev, "Invalid HW queue size = %u (Min. required is %u)\n",
+			req_mgr_h->hw_queue_size, MIN_HW_QUEUE_SIZE);
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	req_mgr_h->min_free_hw_slots = req_mgr_h->hw_queue_size;
+	req_mgr_h->max_used_sw_slots = 0;
+
+	/* Allocate DMA word for "dummy" completion descriptor use */
+	req_mgr_h->dummy_comp_buff =
+		dma_alloc_coherent(dev, sizeof(u32),
+				   &req_mgr_h->dummy_comp_buff_dma,
+				   GFP_KERNEL);
+	if (!req_mgr_h->dummy_comp_buff) {
+		dev_err(dev, "Not enough memory to allocate DMA (%zu) dropped buffer\n",
+			sizeof(u32));
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+
+	/* Init. "dummy" completion descriptor */
+	hw_desc_init(&req_mgr_h->compl_desc);
+	set_din_const(&req_mgr_h->compl_desc, 0, sizeof(u32));
+	set_dout_dlli(&req_mgr_h->compl_desc, req_mgr_h->dummy_comp_buff_dma,
+		      sizeof(u32), NS_BIT, 1);
+	set_flow_mode(&req_mgr_h->compl_desc, BYPASS);
+	set_queue_last_ind(&req_mgr_h->compl_desc);
+
+	return 0;
+
+req_mgr_init_err:
+	cc_req_mgr_fini(drvdata);
+	return rc;
+}
+
+static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
+			unsigned int seq_len)
+{
+	int i, w;
+	void __iomem *reg = drvdata->cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/*
+	 * We do indeed write all 6 command words to the same
+	 * register. The HW supports this.
+	 */
+
+	for (i = 0; i < seq_len; i++) {
+		for (w = 0; w <= 5; w++)
+			writel_relaxed(seq[i].word[w], reg);
+
+		if (cc_dump_desc)
+			dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
+				i, seq[i].word[0], seq[i].word[1],
+				seq[i].word[2], seq[i].word[3],
+				seq[i].word[4], seq[i].word[5]);
+	}
+}
+
+/*!
+ * Completion will take place if and only if user requested completion
+ * by cc_send_sync_request().
+ *
+ * \param dev
+ * \param dx_compl_h The completion event to signal
+ */
+static void request_mgr_complete(struct device *dev, void *dx_compl_h,
+				 int dummy)
+{
+	struct completion *this_compl = dx_compl_h;
+
+	complete(this_compl);
+}
+
+static int cc_queues_status(struct cc_drvdata *drvdata,
+			    struct cc_req_mgr_handle *req_mgr_h,
+			    unsigned int total_seq_len)
+{
+	unsigned long poll_queue;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/* SW queue is checked only once as it will not
+	 * be chaned during the poll because the spinlock_bh
+	 * is held by the thread
+	 */
+	if (((req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1)) ==
+	    req_mgr_h->req_queue_tail) {
+		dev_err(dev, "SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n",
+			req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
+		return -ENOSPC;
+	}
+
+	if (req_mgr_h->q_free_slots >= total_seq_len)
+		return 0;
+
+	/* Wait for space in HW queue. Poll constant num of iterations. */
+	for (poll_queue = 0; poll_queue < CC_MAX_POLL_ITER ; poll_queue++) {
+		req_mgr_h->q_free_slots =
+			cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
+		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots)
+			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
+
+		if (req_mgr_h->q_free_slots >= total_seq_len) {
+			/* If there is enough place return */
+			return 0;
+		}
+
+		dev_dbg(dev, "HW FIFO is full. q_free_slots=%d total_seq_len=%d\n",
+			req_mgr_h->q_free_slots, total_seq_len);
+	}
+	/* No room in the HW queue try again later */
+	dev_dbg(dev, "HW FIFO full, timeout. req_queue_head=%d sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n",
+		req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE,
+		req_mgr_h->q_free_slots, total_seq_len);
+	return -ENOSPC;
+}
+
+/*!
+ * Enqueue caller request to crypto hardware.
+ * Need to be called with HW lock held and PM running
+ *
+ * \param drvdata
+ * \param cc_req The request to enqueue
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ * \param add_comp If "true": add an artificial dout DMA to mark completion
+ *
+ * \return int Returns -EINPROGRESS or error code
+ */
+static int cc_do_send_request(struct cc_drvdata *drvdata,
+			      struct cc_crypto_req *cc_req,
+			      struct cc_hw_desc *desc, unsigned int len,
+				bool add_comp, bool ivgen)
+{
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	unsigned int used_sw_slots;
+	unsigned int iv_seq_len = 0;
+	unsigned int total_seq_len = len; /*initial sequence length*/
+	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc;
+
+	if (ivgen) {
+		dev_dbg(dev, "Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
+			cc_req->ivgen_dma_addr_len,
+			&cc_req->ivgen_dma_addr[0],
+			&cc_req->ivgen_dma_addr[1],
+			&cc_req->ivgen_dma_addr[2],
+			cc_req->ivgen_size);
+
+		/* Acquire IV from pool */
+		rc = cc_get_iv(drvdata, cc_req->ivgen_dma_addr,
+			       cc_req->ivgen_dma_addr_len,
+			       cc_req->ivgen_size,
+			       iv_seq, &iv_seq_len);
+
+		if (rc) {
+			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
+			return rc;
+		}
+
+		total_seq_len += iv_seq_len;
+	}
+
+	used_sw_slots = ((req_mgr_h->req_queue_head -
+			  req_mgr_h->req_queue_tail) &
+			 (MAX_REQUEST_QUEUE_SIZE - 1));
+	if (used_sw_slots > req_mgr_h->max_used_sw_slots)
+		req_mgr_h->max_used_sw_slots = used_sw_slots;
+
+	/* Enqueue request - must be locked with HW lock*/
+	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *cc_req;
+	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) &
+				    (MAX_REQUEST_QUEUE_SIZE - 1);
+	/* TODO: Use circ_buf.h ? */
+
+	dev_dbg(dev, "Enqueue request head=%u\n", req_mgr_h->req_queue_head);
+
+	/*
+	 * We are about to push command to the HW via the command registers
+	 * that may refernece hsot memory. We need to issue a memory barrier
+	 * to make sure there are no outstnading memory writes
+	 */
+	wmb();
+
+	/* STAT_PHASE_4: Push sequence */
+	if (ivgen)
+		enqueue_seq(drvdata, iv_seq, iv_seq_len);
+
+	enqueue_seq(drvdata, desc, len);
+
+	if (add_comp) {
+		enqueue_seq(drvdata, &req_mgr_h->compl_desc, 1);
+		total_seq_len++;
+	}
+
+	if (req_mgr_h->q_free_slots < total_seq_len) {
+		/* This situation should never occur. Maybe indicating problem
+		 * with resuming power. Set the free slot count to 0 and hope
+		 * for the best.
+		 */
+		dev_err(dev, "HW free slot count mismatch.");
+		req_mgr_h->q_free_slots = 0;
+	} else {
+		/* Update the free slots in HW queue */
+		req_mgr_h->q_free_slots -= total_seq_len;
+	}
+
+	/* Operation still in process */
+	return -EINPROGRESS;
+}
+
+static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
+			       struct cc_bl_item *bli)
+{
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+
+	spin_lock_bh(&mgr->bl_lock);
+	list_add_tail(&bli->list, &mgr->backlog);
+	++mgr->bl_len;
+	spin_unlock_bh(&mgr->bl_lock);
+	tasklet_schedule(&mgr->comptask);
+}
+
+static void cc_proc_backlog(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	struct cc_bl_item *bli;
+	struct cc_crypto_req *creq;
+	struct crypto_async_request *req;
+	bool ivgen;
+	unsigned int total_len;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc;
+
+	spin_lock(&mgr->bl_lock);
+
+	while (mgr->bl_len) {
+		bli = list_first_entry(&mgr->backlog, struct cc_bl_item, list);
+		spin_unlock(&mgr->bl_lock);
+
+		creq = &bli->creq;
+		req = (struct crypto_async_request *)creq->user_arg;
+
+		/*
+		 * Notify the request we're moving out of the backlog
+		 * but only if we haven't done so already.
+		 */
+		if (!bli->notif) {
+			req->complete(req, -EINPROGRESS);
+			bli->notif = true;
+		}
+
+		ivgen = !!creq->ivgen_dma_addr_len;
+		total_len = bli->len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
+
+		spin_lock(&mgr->hw_lock);
+
+		rc = cc_queues_status(drvdata, mgr, total_len);
+		if (rc) {
+			/*
+			 * There is still not room in the FIFO for
+			 * this request. Bail out. We'll return here
+			 * on the next completion irq.
+			 */
+			spin_unlock(&mgr->hw_lock);
+			return;
+		}
+
+		rc = cc_do_send_request(drvdata, &bli->creq, bli->desc,
+					bli->len, false, ivgen);
+
+		spin_unlock(&mgr->hw_lock);
+
+		if (rc != -EINPROGRESS) {
+			cc_pm_put_suspend(dev);
+			creq->user_cb(dev, req, rc);
+		}
+
+		/* Remove ourselves from the backlog list */
+		spin_lock(&mgr->bl_lock);
+		list_del(&bli->list);
+		--mgr->bl_len;
+	}
+
+	spin_unlock(&mgr->bl_lock);
+}
+
+int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
+		    struct cc_hw_desc *desc, unsigned int len,
+		    struct crypto_async_request *req)
+{
+	int rc;
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	bool ivgen = !!cc_req->ivgen_dma_addr_len;
+	unsigned int total_len = len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
+	struct device *dev = drvdata_to_dev(drvdata);
+	bool backlog_ok = req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG;
+	gfp_t flags = cc_gfp_flags(req);
+	struct cc_bl_item *bli;
+
+	rc = cc_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		return rc;
+	}
+
+	spin_lock_bh(&mgr->hw_lock);
+	rc = cc_queues_status(drvdata, mgr, total_len);
+
+#ifdef CC_DEBUG_FORCE_BACKLOG
+	if (backlog_ok)
+		rc = -ENOSPC;
+#endif /* CC_DEBUG_FORCE_BACKLOG */
+
+	if (rc == -ENOSPC && backlog_ok) {
+		spin_unlock_bh(&mgr->hw_lock);
+
+		bli = kmalloc(sizeof(*bli), flags);
+		if (!bli) {
+			cc_pm_put_suspend(dev);
+			return -ENOMEM;
+		}
+
+		memcpy(&bli->creq, cc_req, sizeof(*cc_req));
+		memcpy(&bli->desc, desc, len * sizeof(*desc));
+		bli->len = len;
+		bli->notif = false;
+		cc_enqueue_backlog(drvdata, bli);
+		return -EBUSY;
+	}
+
+	if (!rc)
+		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
+					ivgen);
+
+	spin_unlock_bh(&mgr->hw_lock);
+	return rc;
+}
+
+int cc_send_sync_request(struct cc_drvdata *drvdata,
+			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
+			 unsigned int len)
+{
+	int rc;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+
+	init_completion(&cc_req->seq_compl);
+	cc_req->user_cb = request_mgr_complete;
+	cc_req->user_arg = &cc_req->seq_compl;
+
+	rc = cc_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		return rc;
+	}
+
+	while (true) {
+		spin_lock_bh(&mgr->hw_lock);
+		rc = cc_queues_status(drvdata, mgr, len + 1);
+
+		if (!rc)
+			break;
+
+		spin_unlock_bh(&mgr->hw_lock);
+		if (rc != -EAGAIN) {
+			cc_pm_put_suspend(dev);
+			return rc;
+		}
+		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
+		reinit_completion(&drvdata->hw_queue_avail);
+	}
+
+	rc = cc_do_send_request(drvdata, cc_req, desc, len, true, false);
+	spin_unlock_bh(&mgr->hw_lock);
+
+	if (rc != -EINPROGRESS) {
+		cc_pm_put_suspend(dev);
+		return rc;
+	}
+
+	wait_for_completion(&cc_req->seq_compl);
+	return 0;
+}
+
+/*!
+ * Enqueue caller request to crypto hardware during init process.
+ * assume this function is not called in middle of a flow,
+ * since we set QUEUE_LAST_IND flag in the last descriptor.
+ *
+ * \param drvdata
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ *
+ * \return int Returns "0" upon success
+ */
+int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
+		      unsigned int len)
+{
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	unsigned int total_seq_len = len; /*initial sequence length*/
+	int rc = 0;
+
+	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT.
+	 */
+	rc = cc_queues_status(drvdata, req_mgr_h, total_seq_len);
+	if (rc)
+		return rc;
+
+	set_queue_last_ind(&desc[(len - 1)]);
+
+	/*
+	 * We are about to push command to the HW via the command registers
+	 * that may refernece hsot memory. We need to issue a memory barrier
+	 * to make sure there are no outstnading memory writes
+	 */
+	wmb();
+	enqueue_seq(drvdata, desc, len);
+
+	/* Update the free slots in HW queue */
+	req_mgr_h->q_free_slots =
+		cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
+
+	return 0;
+}
+
+void complete_request(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	complete(&drvdata->hw_queue_avail);
+#ifdef COMP_IN_WQ
+	queue_delayed_work(request_mgr_handle->workq,
+			   &request_mgr_handle->compwork, 0);
+#else
+	tasklet_schedule(&request_mgr_handle->comptask);
+#endif
+}
+
+#ifdef COMP_IN_WQ
+static void comp_work_handler(struct work_struct *work)
+{
+	struct cc_drvdata *drvdata =
+		container_of(work, struct cc_drvdata, compwork.work);
+
+	comp_handler((unsigned long)drvdata);
+}
+#endif
+
+static void proc_completions(struct cc_drvdata *drvdata)
+{
+	struct cc_crypto_req *cc_req;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+	unsigned int *tail = &request_mgr_handle->req_queue_tail;
+	unsigned int *head = &request_mgr_handle->req_queue_head;
+
+	while (request_mgr_handle->axi_completed) {
+		request_mgr_handle->axi_completed--;
+
+		/* Dequeue request */
+		if (*head == *tail) {
+			/* We are supposed to handle a completion but our
+			 * queue is empty. This is not normal. Return and
+			 * hope for the best.
+			 */
+			dev_err(dev, "Request queue is empty head == tail %u\n",
+				*head);
+			break;
+		}
+
+		cc_req = &request_mgr_handle->req_queue[*tail];
+
+		if (cc_req->user_cb)
+			cc_req->user_cb(dev, cc_req->user_arg, 0);
+		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
+		dev_dbg(dev, "Request completed. axi_completed=%d\n",
+			request_mgr_handle->axi_completed);
+		cc_pm_put_suspend(dev);
+	}
+}
+
+static inline u32 cc_axi_comp_count(struct cc_drvdata *drvdata)
+{
+	return FIELD_GET(AXIM_MON_COMP_VALUE,
+			 cc_ioread(drvdata, CC_REG(AXIM_MON_COMP)));
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void comp_handler(unsigned long devarg)
+{
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	u32 irq;
+
+	irq = (drvdata->irq & CC_COMP_IRQ_MASK);
+
+	if (irq & CC_COMP_IRQ_MASK) {
+		/* To avoid the interrupt from firing as we unmask it,
+		 * we clear it now
+		 */
+		cc_iowrite(drvdata, CC_REG(HOST_ICR), CC_COMP_IRQ_MASK);
+
+		/* Avoid race with above clear: Test completion counter
+		 * once more
+		 */
+		request_mgr_handle->axi_completed +=
+				cc_axi_comp_count(drvdata);
+
+		while (request_mgr_handle->axi_completed) {
+			do {
+				proc_completions(drvdata);
+				/* At this point (after proc_completions()),
+				 * request_mgr_handle->axi_completed is 0.
+				 */
+				request_mgr_handle->axi_completed =
+						cc_axi_comp_count(drvdata);
+			} while (request_mgr_handle->axi_completed > 0);
+
+			cc_iowrite(drvdata, CC_REG(HOST_ICR),
+				   CC_COMP_IRQ_MASK);
+
+			request_mgr_handle->axi_completed +=
+					cc_axi_comp_count(drvdata);
+		}
+	}
+	/* after verifing that there is nothing to do,
+	 * unmask AXI completion interrupt
+	 */
+	cc_iowrite(drvdata, CC_REG(HOST_IMR),
+		   cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~irq);
+
+	cc_proc_backlog(drvdata);
+}
+
+/*
+ * resume the queue configuration - no need to take the lock as this happens
+ * inside the spin lock protection
+ */
+#if defined(CONFIG_PM)
+int cc_resume_req_queue(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+		drvdata->request_mgr_handle;
+
+	spin_lock_bh(&request_mgr_handle->hw_lock);
+	request_mgr_handle->is_runtime_suspended = false;
+	spin_unlock_bh(&request_mgr_handle->hw_lock);
+
+	return 0;
+}
+
+/*
+ * suspend the queue configuration. Since it is used for the runtime suspend
+ * only verify that the queue can be suspended.
+ */
+int cc_suspend_req_queue(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	/* lock the send_request */
+	spin_lock_bh(&request_mgr_handle->hw_lock);
+	if (request_mgr_handle->req_queue_head !=
+	    request_mgr_handle->req_queue_tail) {
+		spin_unlock_bh(&request_mgr_handle->hw_lock);
+		return -EBUSY;
+	}
+	request_mgr_handle->is_runtime_suspended = true;
+	spin_unlock_bh(&request_mgr_handle->hw_lock);
+
+	return 0;
+}
+
+bool cc_req_queue_suspended(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	return	request_mgr_handle->is_runtime_suspended;
+}
+
+#endif
+
diff --git a/drivers/staging/ccree/cc_request_mgr.h b/drivers/staging/ccree/cc_request_mgr.h
new file mode 100644
index 0000000..573cb97
--- /dev/null
+++ b/drivers/staging/ccree/cc_request_mgr.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_request_mgr.h
+ * Request Manager
+ */
+
+#ifndef __REQUEST_MGR_H__
+#define __REQUEST_MGR_H__
+
+#include "cc_hw_queue_defs.h"
+
+int cc_req_mgr_init(struct cc_drvdata *drvdata);
+
+/*!
+ * Enqueue caller request to crypto hardware.
+ *
+ * \param drvdata
+ * \param cc_req The request to enqueue
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ * \param is_dout If "true": completion is handled by the caller
+ *	  If "false": this function adds a dummy descriptor completion
+ *	  and waits upon completion signal.
+ *
+ * \return int Returns -EINPROGRESS or error
+ */
+int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
+		    struct cc_hw_desc *desc, unsigned int len,
+		    struct crypto_async_request *req);
+
+int cc_send_sync_request(struct cc_drvdata *drvdata,
+			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
+			 unsigned int len);
+
+int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
+		      unsigned int len);
+
+void complete_request(struct cc_drvdata *drvdata);
+
+void cc_req_mgr_fini(struct cc_drvdata *drvdata);
+
+#if defined(CONFIG_PM)
+int cc_resume_req_queue(struct cc_drvdata *drvdata);
+
+int cc_suspend_req_queue(struct cc_drvdata *drvdata);
+
+bool cc_req_queue_suspended(struct cc_drvdata *drvdata);
+#endif
+
+#endif /*__REQUEST_MGR_H__*/
diff --git a/drivers/staging/ccree/cc_sram_mgr.c b/drivers/staging/ccree/cc_sram_mgr.c
new file mode 100644
index 0000000..d1f8a9c
--- /dev/null
+++ b/drivers/staging/ccree/cc_sram_mgr.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include "cc_driver.h"
+#include "cc_sram_mgr.h"
+
+/**
+ * struct cc_sram_ctx -Internal RAM context manager
+ * @sram_free_offset:   the offset to the non-allocated area
+ */
+struct cc_sram_ctx {
+	cc_sram_addr_t sram_free_offset;
+};
+
+/**
+ * cc_sram_mgr_fini() - Cleanup SRAM pool.
+ *
+ * @drvdata: Associated device driver context
+ */
+void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
+{
+	/* Free "this" context */
+	kfree(drvdata->sram_mgr_handle);
+}
+
+/**
+ * cc_sram_mgr_init() - Initializes SRAM pool.
+ *      The pool starts right at the beginning of SRAM.
+ *      Returns zero for success, negative value otherwise.
+ *
+ * @drvdata: Associated device driver context
+ */
+int cc_sram_mgr_init(struct cc_drvdata *drvdata)
+{
+	struct cc_sram_ctx *ctx;
+
+	/* Allocate "this" context */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+
+	if (!ctx)
+		return -ENOMEM;
+
+	drvdata->sram_mgr_handle = ctx;
+
+	return 0;
+}
+
+/*!
+ * Allocated buffer from SRAM pool.
+ * Note: Caller is responsible to free the LAST allocated buffer.
+ * This function does not taking care of any fragmentation may occur
+ * by the order of calls to alloc/free.
+ *
+ * \param drvdata
+ * \param size The requested bytes to allocate
+ */
+cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size)
+{
+	struct cc_sram_ctx *smgr_ctx = drvdata->sram_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+	cc_sram_addr_t p;
+
+	if ((size & 0x3)) {
+		dev_err(dev, "Requested buffer size (%u) is not multiple of 4",
+			size);
+		return NULL_SRAM_ADDR;
+	}
+	if (size > (CC_CC_SRAM_SIZE - smgr_ctx->sram_free_offset)) {
+		dev_err(dev, "Not enough space to allocate %u B (at offset %llu)\n",
+			size, smgr_ctx->sram_free_offset);
+		return NULL_SRAM_ADDR;
+	}
+
+	p = smgr_ctx->sram_free_offset;
+	smgr_ctx->sram_free_offset += size;
+	dev_dbg(dev, "Allocated %u B @ %u\n", size, (unsigned int)p);
+	return p;
+}
+
+/**
+ * cc_set_sram_desc() - Create const descriptors sequence to
+ *	set values in given array into SRAM.
+ * Note: each const value can't exceed word size.
+ *
+ * @src:	  A pointer to array of words to set as consts.
+ * @dst:	  The target SRAM buffer to set into
+ * @nelements:	  The number of words in "src" array
+ * @seq:	  A pointer to the given IN/OUT descriptor sequence
+ * @seq_len:	  A pointer to the given IN/OUT sequence length
+ */
+void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
+		      unsigned int nelement, struct cc_hw_desc *seq,
+		      unsigned int *seq_len)
+{
+	u32 i;
+	unsigned int idx = *seq_len;
+
+	for (i = 0; i < nelement; i++, idx++) {
+		hw_desc_init(&seq[idx]);
+		set_din_const(&seq[idx], src[i], sizeof(u32));
+		set_dout_sram(&seq[idx], dst + (i * sizeof(u32)), sizeof(u32));
+		set_flow_mode(&seq[idx], BYPASS);
+	}
+
+	*seq_len = idx;
+}
+
diff --git a/drivers/staging/ccree/cc_sram_mgr.h b/drivers/staging/ccree/cc_sram_mgr.h
new file mode 100644
index 0000000..d48649f
--- /dev/null
+++ b/drivers/staging/ccree/cc_sram_mgr.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_SRAM_MGR_H__
+#define __CC_SRAM_MGR_H__
+
+#ifndef CC_CC_SRAM_SIZE
+#define CC_CC_SRAM_SIZE 4096
+#endif
+
+struct cc_drvdata;
+
+/**
+ * Address (offset) within CC internal SRAM
+ */
+
+typedef u64 cc_sram_addr_t;
+
+#define NULL_SRAM_ADDR ((cc_sram_addr_t)-1)
+
+/*!
+ * Initializes SRAM pool.
+ * The first X bytes of SRAM are reserved for ROM usage, hence, pool
+ * starts right after X bytes.
+ *
+ * \param drvdata
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_sram_mgr_init(struct cc_drvdata *drvdata);
+
+/*!
+ * Uninits SRAM pool.
+ *
+ * \param drvdata
+ */
+void cc_sram_mgr_fini(struct cc_drvdata *drvdata);
+
+/*!
+ * Allocated buffer from SRAM pool.
+ * Note: Caller is responsible to free the LAST allocated buffer.
+ * This function does not taking care of any fragmentation may occur
+ * by the order of calls to alloc/free.
+ *
+ * \param drvdata
+ * \param size The requested bytes to allocate
+ */
+cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size);
+
+/**
+ * cc_set_sram_desc() - Create const descriptors sequence to
+ *	set values in given array into SRAM.
+ * Note: each const value can't exceed word size.
+ *
+ * @src:	  A pointer to array of words to set as consts.
+ * @dst:	  The target SRAM buffer to set into
+ * @nelements:	  The number of words in "src" array
+ * @seq:	  A pointer to the given IN/OUT descriptor sequence
+ * @seq_len:	  A pointer to the given IN/OUT sequence length
+ */
+void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
+		      unsigned int nelement, struct cc_hw_desc *seq,
+		      unsigned int *seq_len);
+
+#endif /*__CC_SRAM_MGR_H__*/
diff --git a/drivers/staging/ccree/dx_crys_kernel.h b/drivers/staging/ccree/dx_crys_kernel.h
deleted file mode 100644
index fa99440..0000000
--- a/drivers/staging/ccree/dx_crys_kernel.h
+++ /dev/null
@@ -1,167 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#ifndef __CC_CRYS_KERNEL_H__
-#define __CC_CRYS_KERNEL_H__
-
-// --------------------------------------
-// BLOCK: DSCRPTR
-// --------------------------------------
-#define CC_DSCRPTR_COMPLETION_COUNTER_REG_OFFSET	0xE00UL
-#define CC_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SIZE	0x6UL
-#define CC_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SHIFT	0x6UL
-#define CC_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_SW_RESET_REG_OFFSET	0xE40UL
-#define CC_DSCRPTR_SW_RESET_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_SW_RESET_VALUE_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_REG_OFFSET	0xE60UL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SIZE	0xAUL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SHIFT	0xAUL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SIZE	0xCUL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SHIFT	0x16UL
-#define CC_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SIZE	0x3UL
-#define CC_DSCRPTR_SINGLE_ADDR_EN_REG_OFFSET	0xE64UL
-#define CC_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_MEASURE_CNTR_REG_OFFSET	0xE68UL
-#define CC_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SIZE	0x20UL
-#define CC_DSCRPTR_QUEUE_WORD0_REG_OFFSET	0xE80UL
-#define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SIZE	0x20UL
-#define CC_DSCRPTR_QUEUE_WORD1_REG_OFFSET	0xE84UL
-#define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SHIFT	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE	0x18UL
-#define CC_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SHIFT	0x1AUL
-#define CC_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SHIFT	0x1BUL
-#define CC_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SHIFT	0x1CUL
-#define CC_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SHIFT	0x1DUL
-#define CC_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SHIFT	0x1EUL
-#define CC_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD2_REG_OFFSET	0xE88UL
-#define CC_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SIZE	0x20UL
-#define CC_DSCRPTR_QUEUE_WORD3_REG_OFFSET	0xE8CUL
-#define CC_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SHIFT	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SIZE	0x18UL
-#define CC_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SHIFT	0x1AUL
-#define CC_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SHIFT	0x1BUL
-#define CC_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SHIFT	0x1DUL
-#define CC_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SHIFT	0x1EUL
-#define CC_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SHIFT	0x1FUL
-#define CC_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_REG_OFFSET	0xE90UL
-#define CC_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SIZE	0x6UL
-#define CC_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SHIFT	0x6UL
-#define CC_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SHIFT	0x7UL
-#define CC_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SHIFT	0x8UL
-#define CC_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SHIFT	0xAUL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SIZE	0x4UL
-#define CC_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SHIFT	0xEUL
-#define CC_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SHIFT	0xFUL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SHIFT	0x11UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SHIFT	0x13UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SHIFT	0x14UL
-#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SHIFT	0x16UL
-#define CC_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SIZE	0x2UL
-#define CC_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SHIFT	0x18UL
-#define CC_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SIZE	0x4UL
-#define CC_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SHIFT	0x1CUL
-#define CC_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SHIFT	0x1DUL
-#define CC_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SHIFT	0x1EUL
-#define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SHIFT	0x1FUL
-#define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD5_REG_OFFSET	0xE94UL
-#define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SIZE	0x10UL
-#define CC_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SHIFT	0x10UL
-#define CC_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SIZE	0x10UL
-#define CC_DSCRPTR_QUEUE_WATERMARK_REG_OFFSET	0xE98UL
-#define CC_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SIZE	0xAUL
-#define CC_DSCRPTR_QUEUE_CONTENT_REG_OFFSET	0xE9CUL
-#define CC_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SHIFT	0x0UL
-#define CC_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SIZE	0xAUL
-// --------------------------------------
-// BLOCK: AXI_P
-// --------------------------------------
-#define CC_AXIM_MON_INFLIGHT_REG_OFFSET	0xB00UL
-#define CC_AXIM_MON_INFLIGHT_VALUE_BIT_SHIFT	0x0UL
-#define CC_AXIM_MON_INFLIGHT_VALUE_BIT_SIZE	0x8UL
-#define CC_AXIM_MON_INFLIGHTLAST_REG_OFFSET	0xB40UL
-#define CC_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SHIFT	0x0UL
-#define CC_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SIZE	0x8UL
-#define CC_AXIM_MON_COMP_REG_OFFSET	0xB80UL
-#define CC_AXIM_MON_COMP_VALUE_BIT_SHIFT	0x0UL
-#define CC_AXIM_MON_COMP_VALUE_BIT_SIZE	0x10UL
-#define CC_AXIM_MON_ERR_REG_OFFSET	0xBC4UL
-#define CC_AXIM_MON_ERR_BRESP_BIT_SHIFT	0x0UL
-#define CC_AXIM_MON_ERR_BRESP_BIT_SIZE	0x2UL
-#define CC_AXIM_MON_ERR_BID_BIT_SHIFT	0x2UL
-#define CC_AXIM_MON_ERR_BID_BIT_SIZE	0x4UL
-#define CC_AXIM_MON_ERR_RRESP_BIT_SHIFT	0x10UL
-#define CC_AXIM_MON_ERR_RRESP_BIT_SIZE	0x2UL
-#define CC_AXIM_MON_ERR_RID_BIT_SHIFT	0x12UL
-#define CC_AXIM_MON_ERR_RID_BIT_SIZE	0x4UL
-#define CC_AXIM_CFG_REG_OFFSET	0xBE8UL
-#define CC_AXIM_CFG_BRESPMASK_BIT_SHIFT	0x4UL
-#define CC_AXIM_CFG_BRESPMASK_BIT_SIZE	0x1UL
-#define CC_AXIM_CFG_RRESPMASK_BIT_SHIFT	0x5UL
-#define CC_AXIM_CFG_RRESPMASK_BIT_SIZE	0x1UL
-#define CC_AXIM_CFG_INFLTMASK_BIT_SHIFT	0x6UL
-#define CC_AXIM_CFG_INFLTMASK_BIT_SIZE	0x1UL
-#define CC_AXIM_CFG_COMPMASK_BIT_SHIFT	0x7UL
-#define CC_AXIM_CFG_COMPMASK_BIT_SIZE	0x1UL
-#define CC_AXIM_ACE_CONST_REG_OFFSET	0xBECUL
-#define CC_AXIM_ACE_CONST_ARDOMAIN_BIT_SHIFT	0x0UL
-#define CC_AXIM_ACE_CONST_ARDOMAIN_BIT_SIZE	0x2UL
-#define CC_AXIM_ACE_CONST_AWDOMAIN_BIT_SHIFT	0x2UL
-#define CC_AXIM_ACE_CONST_AWDOMAIN_BIT_SIZE	0x2UL
-#define CC_AXIM_ACE_CONST_ARBAR_BIT_SHIFT	0x4UL
-#define CC_AXIM_ACE_CONST_ARBAR_BIT_SIZE	0x2UL
-#define CC_AXIM_ACE_CONST_AWBAR_BIT_SHIFT	0x6UL
-#define CC_AXIM_ACE_CONST_AWBAR_BIT_SIZE	0x2UL
-#define CC_AXIM_ACE_CONST_ARSNOOP_BIT_SHIFT	0x8UL
-#define CC_AXIM_ACE_CONST_ARSNOOP_BIT_SIZE	0x4UL
-#define CC_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SHIFT	0xCUL
-#define CC_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SIZE	0x3UL
-#define CC_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SHIFT	0xFUL
-#define CC_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SIZE	0x3UL
-#define CC_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SHIFT	0x12UL
-#define CC_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SIZE	0x7UL
-#define CC_AXIM_ACE_CONST_AWLEN_VAL_BIT_SHIFT	0x19UL
-#define CC_AXIM_ACE_CONST_AWLEN_VAL_BIT_SIZE	0x4UL
-#define CC_AXIM_CACHE_PARAMS_REG_OFFSET	0xBF0UL
-#define CC_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SHIFT	0x0UL
-#define CC_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SIZE	0x4UL
-#define CC_AXIM_CACHE_PARAMS_AWCACHE_BIT_SHIFT	0x4UL
-#define CC_AXIM_CACHE_PARAMS_AWCACHE_BIT_SIZE	0x4UL
-#define CC_AXIM_CACHE_PARAMS_ARCACHE_BIT_SHIFT	0x8UL
-#define CC_AXIM_CACHE_PARAMS_ARCACHE_BIT_SIZE	0x4UL
-#endif	// __CC_CRYS_KERNEL_H__
diff --git a/drivers/staging/ccree/dx_host.h b/drivers/staging/ccree/dx_host.h
deleted file mode 100644
index 69ef2fa..0000000
--- a/drivers/staging/ccree/dx_host.h
+++ /dev/null
@@ -1,142 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#ifndef __CC_HOST_H__
-#define __CC_HOST_H__
-
-// --------------------------------------
-// BLOCK: HOST_P
-// --------------------------------------
-#define CC_HOST_IRR_REG_OFFSET	0xA00UL
-#define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SHIFT	0x2UL
-#define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SIZE	0x1UL
-#define CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT	0x8UL
-#define CC_HOST_IRR_AXI_ERR_INT_BIT_SIZE	0x1UL
-#define CC_HOST_IRR_GPR0_BIT_SHIFT	0xBUL
-#define CC_HOST_IRR_GPR0_BIT_SIZE	0x1UL
-#define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SHIFT	0x13UL
-#define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SIZE	0x1UL
-#define CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT	0x17UL
-#define CC_HOST_IRR_AXIM_COMP_INT_BIT_SIZE	0x1UL
-#define CC_HOST_IMR_REG_OFFSET	0xA04UL
-#define CC_HOST_IMR_NOT_USED_MASK_BIT_SHIFT	0x1UL
-#define CC_HOST_IMR_NOT_USED_MASK_BIT_SIZE	0x1UL
-#define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SHIFT	0x2UL
-#define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SIZE	0x1UL
-#define CC_HOST_IMR_AXI_ERR_MASK_BIT_SHIFT	0x8UL
-#define CC_HOST_IMR_AXI_ERR_MASK_BIT_SIZE	0x1UL
-#define CC_HOST_IMR_GPR0_BIT_SHIFT	0xBUL
-#define CC_HOST_IMR_GPR0_BIT_SIZE	0x1UL
-#define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SHIFT	0x13UL
-#define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SIZE	0x1UL
-#define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SHIFT	0x17UL
-#define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SIZE	0x1UL
-#define CC_HOST_ICR_REG_OFFSET	0xA08UL
-#define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SHIFT	0x2UL
-#define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SIZE	0x1UL
-#define CC_HOST_ICR_AXI_ERR_CLEAR_BIT_SHIFT	0x8UL
-#define CC_HOST_ICR_AXI_ERR_CLEAR_BIT_SIZE	0x1UL
-#define CC_HOST_ICR_GPR_INT_CLEAR_BIT_SHIFT	0xBUL
-#define CC_HOST_ICR_GPR_INT_CLEAR_BIT_SIZE	0x1UL
-#define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SHIFT	0x13UL
-#define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE	0x1UL
-#define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT	0x17UL
-#define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE	0x1UL
-#define CC_HOST_SIGNATURE_REG_OFFSET	0xA24UL
-#define CC_HOST_SIGNATURE_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_SIGNATURE_VALUE_BIT_SIZE	0x20UL
-#define CC_HOST_BOOT_REG_OFFSET	0xA28UL
-#define CC_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SHIFT	0x0UL
-#define CC_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SHIFT	0x1UL
-#define CC_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SHIFT	0x2UL
-#define CC_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SHIFT	0x3UL
-#define CC_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SHIFT	0x5UL
-#define CC_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SHIFT	0x6UL
-#define CC_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SIZE	0x3UL
-#define CC_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SHIFT	0x9UL
-#define CC_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SHIFT	0xAUL
-#define CC_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SHIFT	0xBUL
-#define CC_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SHIFT	0xCUL
-#define CC_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SHIFT	0xDUL
-#define CC_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SHIFT	0xEUL
-#define CC_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SHIFT	0xFUL
-#define CC_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SHIFT	0x10UL
-#define CC_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SHIFT	0x11UL
-#define CC_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SHIFT	0x12UL
-#define CC_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SHIFT	0x13UL
-#define CC_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SHIFT	0x14UL
-#define CC_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SHIFT	0x15UL
-#define CC_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SHIFT	0x16UL
-#define CC_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SHIFT	0x17UL
-#define CC_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SHIFT	0x18UL
-#define CC_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SHIFT	0x19UL
-#define CC_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SHIFT	0x1AUL
-#define CC_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SHIFT	0x1BUL
-#define CC_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SHIFT	0x1CUL
-#define CC_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SHIFT	0x1DUL
-#define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SHIFT	0x1EUL
-#define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_VERSION_REG_OFFSET	0xA40UL
-#define CC_HOST_VERSION_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_VERSION_VALUE_BIT_SIZE	0x20UL
-#define CC_HOST_KFDE0_VALID_REG_OFFSET	0xA60UL
-#define CC_HOST_KFDE0_VALID_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_KFDE0_VALID_VALUE_BIT_SIZE	0x1UL
-#define CC_HOST_KFDE1_VALID_REG_OFFSET	0xA64UL
-#define CC_HOST_KFDE1_VALID_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_KFDE1_VALID_VALUE_BIT_SIZE	0x1UL
-#define CC_HOST_KFDE2_VALID_REG_OFFSET	0xA68UL
-#define CC_HOST_KFDE2_VALID_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_KFDE2_VALID_VALUE_BIT_SIZE	0x1UL
-#define CC_HOST_KFDE3_VALID_REG_OFFSET	0xA6CUL
-#define CC_HOST_KFDE3_VALID_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_KFDE3_VALID_VALUE_BIT_SIZE	0x1UL
-#define CC_HOST_GPR0_REG_OFFSET	0xA70UL
-#define CC_HOST_GPR0_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_GPR0_VALUE_BIT_SIZE	0x20UL
-#define CC_GPR_HOST_REG_OFFSET	0xA74UL
-#define CC_GPR_HOST_VALUE_BIT_SHIFT	0x0UL
-#define CC_GPR_HOST_VALUE_BIT_SIZE	0x20UL
-#define CC_HOST_POWER_DOWN_EN_REG_OFFSET	0xA78UL
-#define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SHIFT	0x0UL
-#define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SIZE	0x1UL
-// --------------------------------------
-// BLOCK: HOST_SRAM
-// --------------------------------------
-#define CC_SRAM_DATA_REG_OFFSET	0xF00UL
-#define CC_SRAM_DATA_VALUE_BIT_SHIFT	0x0UL
-#define CC_SRAM_DATA_VALUE_BIT_SIZE	0x20UL
-#define CC_SRAM_ADDR_REG_OFFSET	0xF04UL
-#define CC_SRAM_ADDR_VALUE_BIT_SHIFT	0x0UL
-#define CC_SRAM_ADDR_VALUE_BIT_SIZE	0xFUL
-#define CC_SRAM_DATA_READY_REG_OFFSET	0xF08UL
-#define CC_SRAM_DATA_READY_VALUE_BIT_SHIFT	0x0UL
-#define CC_SRAM_DATA_READY_VALUE_BIT_SIZE	0x1UL
-
-#endif //__CC_HOST_H__
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
deleted file mode 100644
index 6f41a00..0000000
--- a/drivers/staging/ccree/ssi_aead.c
+++ /dev/null
@@ -1,2709 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <crypto/algapi.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/aead.h>
-#include <crypto/sha.h>
-#include <crypto/ctr.h>
-#include <crypto/authenc.h>
-#include <crypto/aes.h>
-#include <crypto/des.h>
-#include <linux/rtnetlink.h>
-#include <linux/version.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_aead.h"
-#include "ssi_request_mgr.h"
-#include "ssi_hash.h"
-#include "ssi_sram_mgr.h"
-
-#define template_aead	template_u.aead
-
-#define MAX_AEAD_SETKEY_SEQ 12
-#define MAX_AEAD_PROCESS_SEQ 23
-
-#define MAX_HMAC_DIGEST_SIZE (SHA256_DIGEST_SIZE)
-#define MAX_HMAC_BLOCK_SIZE (SHA256_BLOCK_SIZE)
-
-#define AES_CCM_RFC4309_NONCE_SIZE 3
-#define MAX_NONCE_SIZE CTR_RFC3686_NONCE_SIZE
-
-/* Value of each ICV_CMP byte (of 8) in case of success */
-#define ICV_VERIF_OK 0x01
-
-struct cc_aead_handle {
-	cc_sram_addr_t sram_workspace_addr;
-	struct list_head aead_list;
-};
-
-struct cc_hmac_s {
-	u8 *padded_authkey;
-	u8 *ipad_opad; /* IPAD, OPAD*/
-	dma_addr_t padded_authkey_dma_addr;
-	dma_addr_t ipad_opad_dma_addr;
-};
-
-struct cc_xcbc_s {
-	u8 *xcbc_keys; /* K1,K2,K3 */
-	dma_addr_t xcbc_keys_dma_addr;
-};
-
-struct cc_aead_ctx {
-	struct cc_drvdata *drvdata;
-	u8 ctr_nonce[MAX_NONCE_SIZE]; /* used for ctr3686 iv and aes ccm */
-	u8 *enckey;
-	dma_addr_t enckey_dma_addr;
-	union {
-		struct cc_hmac_s hmac;
-		struct cc_xcbc_s xcbc;
-	} auth_state;
-	unsigned int enc_keylen;
-	unsigned int auth_keylen;
-	unsigned int authsize; /* Actual (reduced?) size of the MAC/ICv */
-	enum drv_cipher_mode cipher_mode;
-	enum cc_flow_mode flow_mode;
-	enum drv_hash_mode auth_mode;
-};
-
-static inline bool valid_assoclen(struct aead_request *req)
-{
-	return ((req->assoclen == 16) || (req->assoclen == 20));
-}
-
-static void cc_aead_exit(struct crypto_aead *tfm)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "Clearing context @%p for %s\n", crypto_aead_ctx(tfm),
-		crypto_tfm_alg_name(&tfm->base));
-
-	/* Unmap enckey buffer */
-	if (ctx->enckey) {
-		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey,
-				  ctx->enckey_dma_addr);
-		dev_dbg(dev, "Freed enckey DMA buffer enckey_dma_addr=%pad\n",
-			&ctx->enckey_dma_addr);
-		ctx->enckey_dma_addr = 0;
-		ctx->enckey = NULL;
-	}
-
-	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
-		struct cc_xcbc_s *xcbc = &ctx->auth_state.xcbc;
-
-		if (xcbc->xcbc_keys) {
-			dma_free_coherent(dev, CC_AES_128_BIT_KEY_SIZE * 3,
-					  xcbc->xcbc_keys,
-					  xcbc->xcbc_keys_dma_addr);
-		}
-		dev_dbg(dev, "Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
-			&xcbc->xcbc_keys_dma_addr);
-		xcbc->xcbc_keys_dma_addr = 0;
-		xcbc->xcbc_keys = NULL;
-	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
-		struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
-
-		if (hmac->ipad_opad) {
-			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
-					  hmac->ipad_opad,
-					  hmac->ipad_opad_dma_addr);
-			dev_dbg(dev, "Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
-				&hmac->ipad_opad_dma_addr);
-			hmac->ipad_opad_dma_addr = 0;
-			hmac->ipad_opad = NULL;
-		}
-		if (hmac->padded_authkey) {
-			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
-					  hmac->padded_authkey,
-					  hmac->padded_authkey_dma_addr);
-			dev_dbg(dev, "Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
-				&hmac->padded_authkey_dma_addr);
-			hmac->padded_authkey_dma_addr = 0;
-			hmac->padded_authkey = NULL;
-		}
-	}
-}
-
-static int cc_aead_init(struct crypto_aead *tfm)
-{
-	struct aead_alg *alg = crypto_aead_alg(tfm);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct cc_crypto_alg *cc_alg =
-			container_of(alg, struct cc_crypto_alg, aead_alg);
-	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
-
-	dev_dbg(dev, "Initializing context @%p for %s\n", ctx,
-		crypto_tfm_alg_name(&tfm->base));
-
-	/* Initialize modes in instance */
-	ctx->cipher_mode = cc_alg->cipher_mode;
-	ctx->flow_mode = cc_alg->flow_mode;
-	ctx->auth_mode = cc_alg->auth_mode;
-	ctx->drvdata = cc_alg->drvdata;
-	crypto_aead_set_reqsize(tfm, sizeof(struct aead_req_ctx));
-
-	/* Allocate key buffer, cache line aligned */
-	ctx->enckey = dma_alloc_coherent(dev, AES_MAX_KEY_SIZE,
-					 &ctx->enckey_dma_addr, GFP_KERNEL);
-	if (!ctx->enckey) {
-		dev_err(dev, "Failed allocating key buffer\n");
-		goto init_failed;
-	}
-	dev_dbg(dev, "Allocated enckey buffer in context ctx->enckey=@%p\n",
-		ctx->enckey);
-
-	/* Set default authlen value */
-
-	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
-		struct cc_xcbc_s *xcbc = &ctx->auth_state.xcbc;
-		const unsigned int key_size = CC_AES_128_BIT_KEY_SIZE * 3;
-
-		/* Allocate dma-coherent buffer for XCBC's K1+K2+K3 */
-		/* (and temporary for user key - up to 256b) */
-		xcbc->xcbc_keys = dma_alloc_coherent(dev, key_size,
-						     &xcbc->xcbc_keys_dma_addr,
-						     GFP_KERNEL);
-		if (!xcbc->xcbc_keys) {
-			dev_err(dev, "Failed allocating buffer for XCBC keys\n");
-			goto init_failed;
-		}
-	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC authentication */
-		struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
-		const unsigned int digest_size = 2 * MAX_HMAC_DIGEST_SIZE;
-		dma_addr_t *pkey_dma = &hmac->padded_authkey_dma_addr;
-
-		/* Allocate dma-coherent buffer for IPAD + OPAD */
-		hmac->ipad_opad = dma_alloc_coherent(dev, digest_size,
-						     &hmac->ipad_opad_dma_addr,
-						     GFP_KERNEL);
-
-		if (!hmac->ipad_opad) {
-			dev_err(dev, "Failed allocating IPAD/OPAD buffer\n");
-			goto init_failed;
-		}
-
-		dev_dbg(dev, "Allocated authkey buffer in context ctx->authkey=@%p\n",
-			hmac->ipad_opad);
-
-		hmac->padded_authkey = dma_alloc_coherent(dev,
-							  MAX_HMAC_BLOCK_SIZE,
-							  pkey_dma,
-							  GFP_KERNEL);
-
-		if (!hmac->padded_authkey) {
-			dev_err(dev, "failed to allocate padded_authkey\n");
-			goto init_failed;
-		}
-	} else {
-		ctx->auth_state.hmac.ipad_opad = NULL;
-		ctx->auth_state.hmac.padded_authkey = NULL;
-	}
-
-	return 0;
-
-init_failed:
-	cc_aead_exit(tfm);
-	return -ENOMEM;
-}
-
-static void cc_aead_complete(struct device *dev, void *cc_req, int err)
-{
-	struct aead_request *areq = (struct aead_request *)cc_req;
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	struct crypto_aead *tfm = crypto_aead_reqtfm(cc_req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
-	cc_unmap_aead_request(dev, areq);
-
-	/* Restore ordinary iv pointer */
-	areq->iv = areq_ctx->backup_iv;
-
-	if (err)
-		goto done;
-
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
-			   ctx->authsize) != 0) {
-			dev_dbg(dev, "Payload authentication failure, (auth-size=%d, cipher=%d)\n",
-				ctx->authsize, ctx->cipher_mode);
-			/* In case of payload authentication failure, MUST NOT
-			 * revealed the decrypted message --> zero its memory.
-			 */
-			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
-			err = -EBADMSG;
-		}
-	} else { /*ENCRYPT*/
-		if (areq_ctx->is_icv_fragmented) {
-			u32 skip = areq->cryptlen + areq_ctx->dst_offset;
-
-			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
-					   areq_ctx->dst_sgl, skip,
-					   (skip + ctx->authsize),
-					   CC_SG_FROM_BUF);
-		}
-
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
-	}
-done:
-	aead_request_complete(areq, err);
-}
-
-static int xcbc_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
-{
-	/* Load the AES key */
-	hw_desc_init(&desc[0]);
-	/* We are using for the source/user key the same buffer
-	 * as for the output keys, * because after this key loading it
-	 * is not needed anymore
-	 */
-	set_din_type(&desc[0], DMA_DLLI,
-		     ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen,
-		     NS_BIT);
-	set_cipher_mode(&desc[0], DRV_CIPHER_ECB);
-	set_cipher_config0(&desc[0], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_key_size_aes(&desc[0], ctx->auth_keylen);
-	set_flow_mode(&desc[0], S_DIN_to_AES);
-	set_setup_mode(&desc[0], SETUP_LOAD_KEY0);
-
-	hw_desc_init(&desc[1]);
-	set_din_const(&desc[1], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[1], DIN_AES_DOUT);
-	set_dout_dlli(&desc[1], ctx->auth_state.xcbc.xcbc_keys_dma_addr,
-		      AES_KEYSIZE_128, NS_BIT, 0);
-
-	hw_desc_init(&desc[2]);
-	set_din_const(&desc[2], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[2], DIN_AES_DOUT);
-	set_dout_dlli(&desc[2], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
-					 + AES_KEYSIZE_128),
-			      AES_KEYSIZE_128, NS_BIT, 0);
-
-	hw_desc_init(&desc[3]);
-	set_din_const(&desc[3], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[3], DIN_AES_DOUT);
-	set_dout_dlli(&desc[3], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
-					  + 2 * AES_KEYSIZE_128),
-			      AES_KEYSIZE_128, NS_BIT, 0);
-
-	return 4;
-}
-
-static int hmac_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
-{
-	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
-	unsigned int digest_ofs = 0;
-	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-			DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
-	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
-			CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
-	struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
-
-	int idx = 0;
-	int i;
-
-	/* calc derived HMAC key */
-	for (i = 0; i < 2; i++) {
-		/* Load hash initial state */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], hash_mode);
-		set_din_sram(&desc[idx],
-			     cc_larval_digest_addr(ctx->drvdata,
-						   ctx->auth_mode),
-			     digest_size);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-		idx++;
-
-		/* Load the hash current length*/
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], hash_mode);
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-		idx++;
-
-		/* Prepare ipad key */
-		hw_desc_init(&desc[idx]);
-		set_xor_val(&desc[idx], hmac_pad_const[i]);
-		set_cipher_mode(&desc[idx], hash_mode);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-		idx++;
-
-		/* Perform HASH update */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     hmac->padded_authkey_dma_addr,
-			     SHA256_BLOCK_SIZE, NS_BIT);
-		set_cipher_mode(&desc[idx], hash_mode);
-		set_xor_active(&desc[idx]);
-		set_flow_mode(&desc[idx], DIN_HASH);
-		idx++;
-
-		/* Get the digset */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], hash_mode);
-		set_dout_dlli(&desc[idx],
-			      (hmac->ipad_opad_dma_addr + digest_ofs),
-			      digest_size, NS_BIT, 0);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-		idx++;
-
-		digest_ofs += digest_size;
-	}
-
-	return idx;
-}
-
-static int validate_keys_sizes(struct cc_aead_ctx *ctx)
-{
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "enc_keylen=%u  authkeylen=%u\n",
-		ctx->enc_keylen, ctx->auth_keylen);
-
-	switch (ctx->auth_mode) {
-	case DRV_HASH_SHA1:
-	case DRV_HASH_SHA256:
-		break;
-	case DRV_HASH_XCBC_MAC:
-		if (ctx->auth_keylen != AES_KEYSIZE_128 &&
-		    ctx->auth_keylen != AES_KEYSIZE_192 &&
-		    ctx->auth_keylen != AES_KEYSIZE_256)
-			return -ENOTSUPP;
-		break;
-	case DRV_HASH_NULL: /* Not authenc (e.g., CCM) - no auth_key) */
-		if (ctx->auth_keylen > 0)
-			return -EINVAL;
-		break;
-	default:
-		dev_err(dev, "Invalid auth_mode=%d\n", ctx->auth_mode);
-		return -EINVAL;
-	}
-	/* Check cipher key size */
-	if (ctx->flow_mode == S_DIN_to_DES) {
-		if (ctx->enc_keylen != DES3_EDE_KEY_SIZE) {
-			dev_err(dev, "Invalid cipher(3DES) key size: %u\n",
-				ctx->enc_keylen);
-			return -EINVAL;
-		}
-	} else { /* Default assumed to be AES ciphers */
-		if (ctx->enc_keylen != AES_KEYSIZE_128 &&
-		    ctx->enc_keylen != AES_KEYSIZE_192 &&
-		    ctx->enc_keylen != AES_KEYSIZE_256) {
-			dev_err(dev, "Invalid cipher(AES) key size: %u\n",
-				ctx->enc_keylen);
-			return -EINVAL;
-		}
-	}
-
-	return 0; /* All tests of keys sizes passed */
-}
-
-/* This function prepers the user key so it can pass to the hmac processing
- * (copy to intenral buffer or hash in case of key longer than block
- */
-static int
-cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
-		      unsigned int keylen)
-{
-	dma_addr_t key_dma_addr = 0;
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	u32 larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->auth_mode);
-	struct cc_crypto_req cc_req = {};
-	unsigned int blocksize;
-	unsigned int digestsize;
-	unsigned int hashmode;
-	unsigned int idx = 0;
-	int rc = 0;
-	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
-	dma_addr_t padded_authkey_dma_addr =
-		ctx->auth_state.hmac.padded_authkey_dma_addr;
-
-	switch (ctx->auth_mode) { /* auth_key required and >0 */
-	case DRV_HASH_SHA1:
-		blocksize = SHA1_BLOCK_SIZE;
-		digestsize = SHA1_DIGEST_SIZE;
-		hashmode = DRV_HASH_HW_SHA1;
-		break;
-	case DRV_HASH_SHA256:
-	default:
-		blocksize = SHA256_BLOCK_SIZE;
-		digestsize = SHA256_DIGEST_SIZE;
-		hashmode = DRV_HASH_HW_SHA256;
-	}
-
-	if (keylen != 0) {
-		key_dma_addr = dma_map_single(dev, (void *)key, keylen,
-					      DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, key_dma_addr)) {
-			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
-				key, keylen);
-			return -ENOMEM;
-		}
-		if (keylen > blocksize) {
-			/* Load hash initial state */
-			hw_desc_init(&desc[idx]);
-			set_cipher_mode(&desc[idx], hashmode);
-			set_din_sram(&desc[idx], larval_addr, digestsize);
-			set_flow_mode(&desc[idx], S_DIN_to_HASH);
-			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-			idx++;
-
-			/* Load the hash current length*/
-			hw_desc_init(&desc[idx]);
-			set_cipher_mode(&desc[idx], hashmode);
-			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-			set_flow_mode(&desc[idx], S_DIN_to_HASH);
-			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-			idx++;
-
-			hw_desc_init(&desc[idx]);
-			set_din_type(&desc[idx], DMA_DLLI,
-				     key_dma_addr, keylen, NS_BIT);
-			set_flow_mode(&desc[idx], DIN_HASH);
-			idx++;
-
-			/* Get hashed key */
-			hw_desc_init(&desc[idx]);
-			set_cipher_mode(&desc[idx], hashmode);
-			set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
-				      digestsize, NS_BIT, 0);
-			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-			set_cipher_config0(&desc[idx],
-					   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-			idx++;
-
-			hw_desc_init(&desc[idx]);
-			set_din_const(&desc[idx], 0, (blocksize - digestsize));
-			set_flow_mode(&desc[idx], BYPASS);
-			set_dout_dlli(&desc[idx], (padded_authkey_dma_addr +
-				      digestsize), (blocksize - digestsize),
-				      NS_BIT, 0);
-			idx++;
-		} else {
-			hw_desc_init(&desc[idx]);
-			set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
-				     keylen, NS_BIT);
-			set_flow_mode(&desc[idx], BYPASS);
-			set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
-				      keylen, NS_BIT, 0);
-			idx++;
-
-			if ((blocksize - keylen) != 0) {
-				hw_desc_init(&desc[idx]);
-				set_din_const(&desc[idx], 0,
-					      (blocksize - keylen));
-				set_flow_mode(&desc[idx], BYPASS);
-				set_dout_dlli(&desc[idx],
-					      (padded_authkey_dma_addr +
-					       keylen),
-					      (blocksize - keylen), NS_BIT, 0);
-				idx++;
-			}
-		}
-	} else {
-		hw_desc_init(&desc[idx]);
-		set_din_const(&desc[idx], 0, (blocksize - keylen));
-		set_flow_mode(&desc[idx], BYPASS);
-		set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
-			      blocksize, NS_BIT, 0);
-		idx++;
-	}
-
-	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
-	if (rc)
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-
-	if (key_dma_addr)
-		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
-
-	return rc;
-}
-
-static int
-cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct rtattr *rta = (struct rtattr *)key;
-	struct cc_crypto_req cc_req = {};
-	struct crypto_authenc_key_param *param;
-	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
-	int seq_len = 0, rc = -EINVAL;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "Setting key in context @%p for %s. key=%p keylen=%u\n",
-		ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key, keylen);
-
-	/* STAT_PHASE_0: Init and sanity checks */
-
-	if (ctx->auth_mode != DRV_HASH_NULL) { /* authenc() alg. */
-		if (!RTA_OK(rta, keylen))
-			goto badkey;
-		if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
-			goto badkey;
-		if (RTA_PAYLOAD(rta) < sizeof(*param))
-			goto badkey;
-		param = RTA_DATA(rta);
-		ctx->enc_keylen = be32_to_cpu(param->enckeylen);
-		key += RTA_ALIGN(rta->rta_len);
-		keylen -= RTA_ALIGN(rta->rta_len);
-		if (keylen < ctx->enc_keylen)
-			goto badkey;
-		ctx->auth_keylen = keylen - ctx->enc_keylen;
-
-		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-			/* the nonce is stored in bytes at end of key */
-			if (ctx->enc_keylen <
-			    (AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE))
-				goto badkey;
-			/* Copy nonce from last 4 bytes in CTR key to
-			 *  first 4 bytes in CTR IV
-			 */
-			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen +
-			       ctx->enc_keylen - CTR_RFC3686_NONCE_SIZE,
-			       CTR_RFC3686_NONCE_SIZE);
-			/* Set CTR key size */
-			ctx->enc_keylen -= CTR_RFC3686_NONCE_SIZE;
-		}
-	} else { /* non-authenc - has just one key */
-		ctx->enc_keylen = keylen;
-		ctx->auth_keylen = 0;
-	}
-
-	rc = validate_keys_sizes(ctx);
-	if (rc)
-		goto badkey;
-
-	/* STAT_PHASE_1: Copy key to ctx */
-
-	/* Get key material */
-	memcpy(ctx->enckey, key + ctx->auth_keylen, ctx->enc_keylen);
-	if (ctx->enc_keylen == 24)
-		memset(ctx->enckey + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
-	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
-		memcpy(ctx->auth_state.xcbc.xcbc_keys, key, ctx->auth_keylen);
-	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC */
-		rc = cc_get_plain_hmac_key(tfm, key, ctx->auth_keylen);
-		if (rc)
-			goto badkey;
-	}
-
-	/* STAT_PHASE_2: Create sequence */
-
-	switch (ctx->auth_mode) {
-	case DRV_HASH_SHA1:
-	case DRV_HASH_SHA256:
-		seq_len = hmac_setkey(desc, ctx);
-		break;
-	case DRV_HASH_XCBC_MAC:
-		seq_len = xcbc_setkey(desc, ctx);
-		break;
-	case DRV_HASH_NULL: /* non-authenc modes, e.g., CCM */
-		break; /* No auth. key setup */
-	default:
-		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
-		rc = -ENOTSUPP;
-		goto badkey;
-	}
-
-	/* STAT_PHASE_3: Submit sequence to HW */
-
-	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
-		rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, seq_len);
-		if (rc) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			goto setkey_error;
-		}
-	}
-
-	/* Update STAT_PHASE_3 */
-	return rc;
-
-badkey:
-	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
-setkey_error:
-	return rc;
-}
-
-static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
-				 unsigned int keylen)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
-	if (keylen < 3)
-		return -EINVAL;
-
-	keylen -= 3;
-	memcpy(ctx->ctr_nonce, key + keylen, 3);
-
-	return cc_aead_setkey(tfm, key, keylen);
-}
-
-static int cc_aead_setauthsize(struct crypto_aead *authenc,
-			       unsigned int authsize)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	/* Unsupported auth. sizes */
-	if (authsize == 0 ||
-	    authsize > crypto_aead_maxauthsize(authenc)) {
-		return -ENOTSUPP;
-	}
-
-	ctx->authsize = authsize;
-	dev_dbg(dev, "authlen=%d\n", ctx->authsize);
-
-	return 0;
-}
-
-static int cc_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
-{
-	switch (authsize) {
-	case 8:
-	case 12:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return cc_aead_setauthsize(authenc, authsize);
-}
-
-static int cc_ccm_setauthsize(struct crypto_aead *authenc,
-			      unsigned int authsize)
-{
-	switch (authsize) {
-	case 4:
-	case 6:
-	case 8:
-	case 10:
-	case 12:
-	case 14:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return cc_aead_setauthsize(authenc, authsize);
-}
-
-static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
-			      struct cc_hw_desc desc[], unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	enum cc_req_dma_buf_type assoc_dma_type = areq_ctx->assoc_buff_type;
-	unsigned int idx = *seq_size;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	switch (assoc_dma_type) {
-	case CC_DMA_BUF_DLLI:
-		dev_dbg(dev, "ASSOC buffer type DLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
-			     areq->assoclen, NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
-		    areq_ctx->cryptlen > 0)
-			set_din_not_last_indication(&desc[idx]);
-		break;
-	case CC_DMA_BUF_MLLI:
-		dev_dbg(dev, "ASSOC buffer type MLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->assoc.sram_addr,
-			     areq_ctx->assoc.mlli_nents, NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
-		    areq_ctx->cryptlen > 0)
-			set_din_not_last_indication(&desc[idx]);
-		break;
-	case CC_DMA_BUF_NULL:
-	default:
-		dev_err(dev, "Invalid ASSOC buffer type\n");
-	}
-
-	*seq_size = (++idx);
-}
-
-static void cc_proc_authen_desc(struct aead_request *areq,
-				unsigned int flow_mode,
-				struct cc_hw_desc desc[],
-				unsigned int *seq_size, int direct)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	enum cc_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
-	unsigned int idx = *seq_size;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	switch (data_dma_type) {
-	case CC_DMA_BUF_DLLI:
-	{
-		struct scatterlist *cipher =
-			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			areq_ctx->dst_sgl : areq_ctx->src_sgl;
-
-		unsigned int offset =
-			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			areq_ctx->dst_offset : areq_ctx->src_offset;
-		dev_dbg(dev, "AUTHENC: SRC/DST buffer type DLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     (sg_dma_address(cipher) + offset),
-			     areq_ctx->cryptlen, NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		break;
-	}
-	case CC_DMA_BUF_MLLI:
-	{
-		/* DOUBLE-PASS flow (as default)
-		 * assoc. + iv + data -compact in one table
-		 * if assoclen is ZERO only IV perform
-		 */
-		cc_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
-		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
-
-		if (areq_ctx->is_single_pass) {
-			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-				mlli_addr = areq_ctx->dst.sram_addr;
-				mlli_nents = areq_ctx->dst.mlli_nents;
-			} else {
-				mlli_addr = areq_ctx->src.sram_addr;
-				mlli_nents = areq_ctx->src.mlli_nents;
-			}
-		}
-
-		dev_dbg(dev, "AUTHENC: SRC/DST buffer type MLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_MLLI, mlli_addr, mlli_nents,
-			     NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		break;
-	}
-	case CC_DMA_BUF_NULL:
-	default:
-		dev_err(dev, "AUTHENC: Invalid SRC/DST buffer type\n");
-	}
-
-	*seq_size = (++idx);
-}
-
-static void cc_proc_cipher_desc(struct aead_request *areq,
-				unsigned int flow_mode,
-				struct cc_hw_desc desc[],
-				unsigned int *seq_size)
-{
-	unsigned int idx = *seq_size;
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
-	enum cc_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	if (areq_ctx->cryptlen == 0)
-		return; /*null processing*/
-
-	switch (data_dma_type) {
-	case CC_DMA_BUF_DLLI:
-		dev_dbg(dev, "CIPHER: SRC/DST buffer type DLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     (sg_dma_address(areq_ctx->src_sgl) +
-			      areq_ctx->src_offset), areq_ctx->cryptlen,
-			      NS_BIT);
-		set_dout_dlli(&desc[idx],
-			      (sg_dma_address(areq_ctx->dst_sgl) +
-			       areq_ctx->dst_offset),
-			      areq_ctx->cryptlen, NS_BIT, 0);
-		set_flow_mode(&desc[idx], flow_mode);
-		break;
-	case CC_DMA_BUF_MLLI:
-		dev_dbg(dev, "CIPHER: SRC/DST buffer type MLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->src.sram_addr,
-			     areq_ctx->src.mlli_nents, NS_BIT);
-		set_dout_mlli(&desc[idx], areq_ctx->dst.sram_addr,
-			      areq_ctx->dst.mlli_nents, NS_BIT, 0);
-		set_flow_mode(&desc[idx], flow_mode);
-		break;
-	case CC_DMA_BUF_NULL:
-	default:
-		dev_err(dev, "CIPHER: Invalid SRC/DST buffer type\n");
-	}
-
-	*seq_size = (++idx);
-}
-
-static void cc_proc_digest_desc(struct aead_request *req,
-				struct cc_hw_desc desc[],
-				unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int idx = *seq_size;
-	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
-	int direct = req_ctx->gen_ctx.op_type;
-
-	/* Get final ICV result */
-	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-		hw_desc_init(&desc[idx]);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		set_dout_dlli(&desc[idx], req_ctx->icv_dma_addr, ctx->authsize,
-			      NS_BIT, 1);
-		set_queue_last_ind(&desc[idx]);
-		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
-			set_aes_not_hash_mode(&desc[idx]);
-			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-		} else {
-			set_cipher_config0(&desc[idx],
-					   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-			set_cipher_mode(&desc[idx], hash_mode);
-		}
-	} else { /*Decrypt*/
-		/* Get ICV out from hardware */
-		hw_desc_init(&desc[idx]);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr,
-			      ctx->authsize, NS_BIT, 1);
-		set_queue_last_ind(&desc[idx]);
-		set_cipher_config0(&desc[idx],
-				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
-			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-			set_aes_not_hash_mode(&desc[idx]);
-		} else {
-			set_cipher_mode(&desc[idx], hash_mode);
-		}
-	}
-
-	*seq_size = (++idx);
-}
-
-static void cc_set_cipher_desc(struct aead_request *req,
-			       struct cc_hw_desc desc[],
-			       unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int hw_iv_size = req_ctx->hw_iv_size;
-	unsigned int idx = *seq_size;
-	int direct = req_ctx->gen_ctx.op_type;
-
-	/* Setup cipher state */
-	hw_desc_init(&desc[idx]);
-	set_cipher_config0(&desc[idx], direct);
-	set_flow_mode(&desc[idx], ctx->flow_mode);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
-		     hw_iv_size, NS_BIT);
-	if (ctx->cipher_mode == DRV_CIPHER_CTR)
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	else
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	set_cipher_mode(&desc[idx], ctx->cipher_mode);
-	idx++;
-
-	/* Setup enc. key */
-	hw_desc_init(&desc[idx]);
-	set_cipher_config0(&desc[idx], direct);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_flow_mode(&desc[idx], ctx->flow_mode);
-	if (ctx->flow_mode == S_DIN_to_AES) {
-		set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			     ((ctx->enc_keylen == 24) ? CC_AES_KEY_SIZE_MAX :
-			      ctx->enc_keylen), NS_BIT);
-		set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	} else {
-		set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			     ctx->enc_keylen, NS_BIT);
-		set_key_size_des(&desc[idx], ctx->enc_keylen);
-	}
-	set_cipher_mode(&desc[idx], ctx->cipher_mode);
-	idx++;
-
-	*seq_size = idx;
-}
-
-static void cc_proc_cipher(struct aead_request *req, struct cc_hw_desc desc[],
-			   unsigned int *seq_size, unsigned int data_flow_mode)
-{
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int idx = *seq_size;
-
-	if (req_ctx->cryptlen == 0)
-		return; /*null processing*/
-
-	cc_set_cipher_desc(req, desc, &idx);
-	cc_proc_cipher_desc(req, data_flow_mode, desc, &idx);
-	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-		/* We must wait for DMA to write all cipher */
-		hw_desc_init(&desc[idx]);
-		set_din_no_dma(&desc[idx], 0, 0xfffff0);
-		set_dout_no_dma(&desc[idx], 0, 0, 1);
-		idx++;
-	}
-
-	*seq_size = idx;
-}
-
-static void cc_set_hmac_desc(struct aead_request *req, struct cc_hw_desc desc[],
-			     unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
-	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
-	unsigned int idx = *seq_size;
-
-	/* Loading hash ipad xor key state */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], hash_mode);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     ctx->auth_state.hmac.ipad_opad_dma_addr, digest_size,
-		     NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Load init. digest len (64 bytes) */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], hash_mode);
-	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
-		     HASH_LEN_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	*seq_size = idx;
-}
-
-static void cc_set_xcbc_desc(struct aead_request *req, struct cc_hw_desc desc[],
-			     unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	unsigned int idx = *seq_size;
-
-	/* Loading MAC state */
-	hw_desc_init(&desc[idx]);
-	set_din_const(&desc[idx], 0, CC_AES_BLOCK_SIZE);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	/* Setup XCBC MAC K1 */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     ctx->auth_state.xcbc.xcbc_keys_dma_addr,
-		     AES_KEYSIZE_128, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	/* Setup XCBC MAC K2 */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
-		      AES_KEYSIZE_128), AES_KEYSIZE_128, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	/* Setup XCBC MAC K3 */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
-		      2 * AES_KEYSIZE_128), AES_KEYSIZE_128, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	*seq_size = idx;
-}
-
-static void cc_proc_header_desc(struct aead_request *req,
-				struct cc_hw_desc desc[],
-				unsigned int *seq_size)
-{
-	unsigned int idx = *seq_size;
-	/* Hash associated data */
-	if (req->assoclen > 0)
-		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
-
-	/* Hash IV */
-	*seq_size = idx;
-}
-
-static void cc_proc_scheme_desc(struct aead_request *req,
-				struct cc_hw_desc desc[],
-				unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct cc_aead_handle *aead_handle = ctx->drvdata->aead_handle;
-	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
-	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
-	unsigned int idx = *seq_size;
-
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], hash_mode);
-	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
-		      HASH_LEN_SIZE);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
-	set_cipher_do(&desc[idx], DO_PAD);
-	idx++;
-
-	/* Get final ICV result */
-	hw_desc_init(&desc[idx]);
-	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
-		      digest_size);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-	set_cipher_mode(&desc[idx], hash_mode);
-	idx++;
-
-	/* Loading hash opad xor key state */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], hash_mode);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     (ctx->auth_state.hmac.ipad_opad_dma_addr + digest_size),
-		     digest_size, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Load init. digest len (64 bytes) */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], hash_mode);
-	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
-		     HASH_LEN_SIZE);
-	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	/* Perform HASH update */
-	hw_desc_init(&desc[idx]);
-	set_din_sram(&desc[idx], aead_handle->sram_workspace_addr,
-		     digest_size);
-	set_flow_mode(&desc[idx], DIN_HASH);
-	idx++;
-
-	*seq_size = idx;
-}
-
-static void cc_mlli_to_sram(struct aead_request *req,
-			    struct cc_hw_desc desc[], unsigned int *seq_size)
-{
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	if (req_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
-	    req_ctx->data_buff_type == CC_DMA_BUF_MLLI ||
-	    !req_ctx->is_single_pass) {
-		dev_dbg(dev, "Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
-			(unsigned int)ctx->drvdata->mlli_sram_addr,
-			req_ctx->mlli_params.mlli_len);
-		/* Copy MLLI table host-to-sram */
-		hw_desc_init(&desc[*seq_size]);
-		set_din_type(&desc[*seq_size], DMA_DLLI,
-			     req_ctx->mlli_params.mlli_dma_addr,
-			     req_ctx->mlli_params.mlli_len, NS_BIT);
-		set_dout_sram(&desc[*seq_size],
-			      ctx->drvdata->mlli_sram_addr,
-			      req_ctx->mlli_params.mlli_len);
-		set_flow_mode(&desc[*seq_size], BYPASS);
-		(*seq_size)++;
-	}
-}
-
-static enum cc_flow_mode cc_get_data_flow(enum drv_crypto_direction direct,
-					  enum cc_flow_mode setup_flow_mode,
-					  bool is_single_pass)
-{
-	enum cc_flow_mode data_flow_mode;
-
-	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-		if (setup_flow_mode == S_DIN_to_AES)
-			data_flow_mode = is_single_pass ?
-				AES_to_HASH_and_DOUT : DIN_AES_DOUT;
-		else
-			data_flow_mode = is_single_pass ?
-				DES_to_HASH_and_DOUT : DIN_DES_DOUT;
-	} else { /* Decrypt */
-		if (setup_flow_mode == S_DIN_to_AES)
-			data_flow_mode = is_single_pass ?
-				AES_and_HASH : DIN_AES_DOUT;
-		else
-			data_flow_mode = is_single_pass ?
-				DES_and_HASH : DIN_DES_DOUT;
-	}
-
-	return data_flow_mode;
-}
-
-static void cc_hmac_authenc(struct aead_request *req, struct cc_hw_desc desc[],
-			    unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode =
-		cc_get_data_flow(direct, ctx->flow_mode,
-				 req_ctx->is_single_pass);
-
-	if (req_ctx->is_single_pass) {
-		/**
-		 * Single-pass flow
-		 */
-		cc_set_hmac_desc(req, desc, seq_size);
-		cc_set_cipher_desc(req, desc, seq_size);
-		cc_proc_header_desc(req, desc, seq_size);
-		cc_proc_cipher_desc(req, data_flow_mode, desc, seq_size);
-		cc_proc_scheme_desc(req, desc, seq_size);
-		cc_proc_digest_desc(req, desc, seq_size);
-		return;
-	}
-
-	/**
-	 * Double-pass flow
-	 * Fallback for unsupported single-pass modes,
-	 * i.e. using assoc. data of non-word-multiple
-	 */
-	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-		/* encrypt first.. */
-		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
-		/* authenc after..*/
-		cc_set_hmac_desc(req, desc, seq_size);
-		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
-		cc_proc_scheme_desc(req, desc, seq_size);
-		cc_proc_digest_desc(req, desc, seq_size);
-
-	} else { /*DECRYPT*/
-		/* authenc first..*/
-		cc_set_hmac_desc(req, desc, seq_size);
-		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
-		cc_proc_scheme_desc(req, desc, seq_size);
-		/* decrypt after.. */
-		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
-		/* read the digest result with setting the completion bit
-		 * must be after the cipher operation
-		 */
-		cc_proc_digest_desc(req, desc, seq_size);
-	}
-}
-
-static void
-cc_xcbc_authenc(struct aead_request *req, struct cc_hw_desc desc[],
-		unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode =
-		cc_get_data_flow(direct, ctx->flow_mode,
-				 req_ctx->is_single_pass);
-
-	if (req_ctx->is_single_pass) {
-		/**
-		 * Single-pass flow
-		 */
-		cc_set_xcbc_desc(req, desc, seq_size);
-		cc_set_cipher_desc(req, desc, seq_size);
-		cc_proc_header_desc(req, desc, seq_size);
-		cc_proc_cipher_desc(req, data_flow_mode, desc, seq_size);
-		cc_proc_digest_desc(req, desc, seq_size);
-		return;
-	}
-
-	/**
-	 * Double-pass flow
-	 * Fallback for unsupported single-pass modes,
-	 * i.e. using assoc. data of non-word-multiple
-	 */
-	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-		/* encrypt first.. */
-		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
-		/* authenc after.. */
-		cc_set_xcbc_desc(req, desc, seq_size);
-		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
-		cc_proc_digest_desc(req, desc, seq_size);
-	} else { /*DECRYPT*/
-		/* authenc first.. */
-		cc_set_xcbc_desc(req, desc, seq_size);
-		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
-		/* decrypt after..*/
-		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
-		/* read the digest result with setting the completion bit
-		 * must be after the cipher operation
-		 */
-		cc_proc_digest_desc(req, desc, seq_size);
-	}
-}
-
-static int validate_data_size(struct cc_aead_ctx *ctx,
-			      enum drv_crypto_direction direct,
-			      struct aead_request *req)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	unsigned int assoclen = req->assoclen;
-	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
-			(req->cryptlen - ctx->authsize) : req->cryptlen;
-
-	if (direct == DRV_CRYPTO_DIRECTION_DECRYPT &&
-	    req->cryptlen < ctx->authsize)
-		goto data_size_err;
-
-	areq_ctx->is_single_pass = true; /*defaulted to fast flow*/
-
-	switch (ctx->flow_mode) {
-	case S_DIN_to_AES:
-		if (ctx->cipher_mode == DRV_CIPHER_CBC &&
-		    !IS_ALIGNED(cipherlen, AES_BLOCK_SIZE))
-			goto data_size_err;
-		if (ctx->cipher_mode == DRV_CIPHER_CCM)
-			break;
-		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
-			if (areq_ctx->plaintext_authenticate_only)
-				areq_ctx->is_single_pass = false;
-			break;
-		}
-
-		if (!IS_ALIGNED(assoclen, sizeof(u32)))
-			areq_ctx->is_single_pass = false;
-
-		if (ctx->cipher_mode == DRV_CIPHER_CTR &&
-		    !IS_ALIGNED(cipherlen, sizeof(u32)))
-			areq_ctx->is_single_pass = false;
-
-		break;
-	case S_DIN_to_DES:
-		if (!IS_ALIGNED(cipherlen, DES_BLOCK_SIZE))
-			goto data_size_err;
-		if (!IS_ALIGNED(assoclen, DES_BLOCK_SIZE))
-			areq_ctx->is_single_pass = false;
-		break;
-	default:
-		dev_err(dev, "Unexpected flow mode (%d)\n", ctx->flow_mode);
-		goto data_size_err;
-	}
-
-	return 0;
-
-data_size_err:
-	return -EINVAL;
-}
-
-static unsigned int format_ccm_a0(u8 *pa0_buff, u32 header_size)
-{
-	unsigned int len = 0;
-
-	if (header_size == 0)
-		return 0;
-
-	if (header_size < ((1UL << 16) - (1UL << 8))) {
-		len = 2;
-
-		pa0_buff[0] = (header_size >> 8) & 0xFF;
-		pa0_buff[1] = header_size & 0xFF;
-	} else {
-		len = 6;
-
-		pa0_buff[0] = 0xFF;
-		pa0_buff[1] = 0xFE;
-		pa0_buff[2] = (header_size >> 24) & 0xFF;
-		pa0_buff[3] = (header_size >> 16) & 0xFF;
-		pa0_buff[4] = (header_size >> 8) & 0xFF;
-		pa0_buff[5] = header_size & 0xFF;
-	}
-
-	return len;
-}
-
-static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
-{
-	__be32 data;
-
-	memset(block, 0, csize);
-	block += csize;
-
-	if (csize >= 4)
-		csize = 4;
-	else if (msglen > (1 << (8 * csize)))
-		return -EOVERFLOW;
-
-	data = cpu_to_be32(msglen);
-	memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
-
-	return 0;
-}
-
-static int cc_ccm(struct aead_request *req, struct cc_hw_desc desc[],
-		  unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int idx = *seq_size;
-	unsigned int cipher_flow_mode;
-	dma_addr_t mac_result;
-
-	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		cipher_flow_mode = AES_to_HASH_and_DOUT;
-		mac_result = req_ctx->mac_buf_dma_addr;
-	} else { /* Encrypt */
-		cipher_flow_mode = AES_and_HASH;
-		mac_result = req_ctx->icv_dma_addr;
-	}
-
-	/* load key */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
-	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-		     ((ctx->enc_keylen == 24) ?  CC_AES_KEY_SIZE_MAX :
-		      ctx->enc_keylen), NS_BIT);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* load ctr state */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     req_ctx->gen_ctx.iv_dma_addr, AES_BLOCK_SIZE, NS_BIT);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* load MAC key */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
-	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-		     ((ctx->enc_keylen == 24) ?  CC_AES_KEY_SIZE_MAX :
-		      ctx->enc_keylen), NS_BIT);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	/* load MAC state */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
-		     AES_BLOCK_SIZE, NS_BIT);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	/* process assoc data */
-	if (req->assoclen > 0) {
-		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
-	} else {
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     sg_dma_address(&req_ctx->ccm_adata_sg),
-			     AES_BLOCK_SIZE + req_ctx->ccm_hdr_size, NS_BIT);
-		set_flow_mode(&desc[idx], DIN_HASH);
-		idx++;
-	}
-
-	/* process the cipher */
-	if (req_ctx->cryptlen)
-		cc_proc_cipher_desc(req, cipher_flow_mode, desc, &idx);
-
-	/* Read temporal MAC */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
-	set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr, ctx->authsize,
-		      NS_BIT, 0);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_aes_not_hash_mode(&desc[idx]);
-	idx++;
-
-	/* load AES-CTR state (for last MAC calculation)*/
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
-	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->ccm_iv0_dma_addr,
-		     AES_BLOCK_SIZE, NS_BIT);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	hw_desc_init(&desc[idx]);
-	set_din_no_dma(&desc[idx], 0, 0xfffff0);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	idx++;
-
-	/* encrypt the "T" value and store MAC in mac_state */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
-		     ctx->authsize, NS_BIT);
-	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	idx++;
-
-	*seq_size = idx;
-	return 0;
-}
-
-static int config_ccm_adata(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	//unsigned int size_of_a = 0, rem_a_size = 0;
-	unsigned int lp = req->iv[0];
-	/* Note: The code assume that req->iv[0] already contains the value
-	 * of L' of RFC3610
-	 */
-	unsigned int l = lp + 1;  /* This is L' of RFC 3610. */
-	unsigned int m = ctx->authsize;  /* This is M' of RFC 3610. */
-	u8 *b0 = req_ctx->ccm_config + CCM_B0_OFFSET;
-	u8 *a0 = req_ctx->ccm_config + CCM_A0_OFFSET;
-	u8 *ctr_count_0 = req_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
-	unsigned int cryptlen = (req_ctx->gen_ctx.op_type ==
-				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				req->cryptlen :
-				(req->cryptlen - ctx->authsize);
-	int rc;
-
-	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
-	memset(req_ctx->ccm_config, 0, AES_BLOCK_SIZE * 3);
-
-	/* taken from crypto/ccm.c */
-	/* 2 <= L <= 8, so 1 <= L' <= 7. */
-	if (l < 2 || l > 8) {
-		dev_err(dev, "illegal iv value %X\n", req->iv[0]);
-		return -EINVAL;
-	}
-	memcpy(b0, req->iv, AES_BLOCK_SIZE);
-
-	/* format control info per RFC 3610 and
-	 * NIST Special Publication 800-38C
-	 */
-	*b0 |= (8 * ((m - 2) / 2));
-	if (req->assoclen > 0)
-		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
-
-	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
-	if (rc) {
-		dev_err(dev, "message len overflow detected");
-		return rc;
-	}
-	 /* END of "taken from crypto/ccm.c" */
-
-	/* l(a) - size of associated data. */
-	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req->assoclen);
-
-	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
-	req->iv[15] = 1;
-
-	memcpy(ctr_count_0, req->iv, AES_BLOCK_SIZE);
-	ctr_count_0[15] = 0;
-
-	return 0;
-}
-
-static void cc_proc_rfc4309_ccm(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-
-	/* L' */
-	memset(areq_ctx->ctr_iv, 0, AES_BLOCK_SIZE);
-	/* For RFC 4309, always use 4 bytes for message length
-	 * (at most 2^32-1 bytes).
-	 */
-	areq_ctx->ctr_iv[0] = 3;
-
-	/* In RFC 4309 there is an 11-bytes nonce+IV part,
-	 * that we build here.
-	 */
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce,
-	       CCM_BLOCK_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
-	       CCM_BLOCK_IV_SIZE);
-	req->iv = areq_ctx->ctr_iv;
-	req->assoclen -= CCM_BLOCK_IV_SIZE;
-}
-
-static void cc_set_ghash_desc(struct aead_request *req,
-			      struct cc_hw_desc desc[], unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int idx = *seq_size;
-
-	/* load key to AES*/
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
-	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-		     ctx->enc_keylen, NS_BIT);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* process one zero block to generate hkey */
-	hw_desc_init(&desc[idx]);
-	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
-	set_dout_dlli(&desc[idx], req_ctx->hkey_dma_addr, AES_BLOCK_SIZE,
-		      NS_BIT, 0);
-	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	idx++;
-
-	/* Memory Barrier */
-	hw_desc_init(&desc[idx]);
-	set_din_no_dma(&desc[idx], 0, 0xfffff0);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	idx++;
-
-	/* Load GHASH subkey */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->hkey_dma_addr,
-		     AES_BLOCK_SIZE, NS_BIT);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
-	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	/* Configure Hash Engine to work with GHASH.
-	 * Since it was not possible to extend HASH submodes to add GHASH,
-	 * The following command is necessary in order to
-	 * select GHASH (according to HW designers)
-	 */
-	hw_desc_init(&desc[idx]);
-	set_din_no_dma(&desc[idx], 0, 0xfffff0);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
-	set_cipher_do(&desc[idx], 1); //1=AES_SK RKEK
-	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	/* Load GHASH initial STATE (which is 0). (for any hash there is an
-	 * initial state)
-	 */
-	hw_desc_init(&desc[idx]);
-	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_aes_not_hash_mode(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
-	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	*seq_size = idx;
-}
-
-static void cc_set_gctr_desc(struct aead_request *req, struct cc_hw_desc desc[],
-			     unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int idx = *seq_size;
-
-	/* load key to AES*/
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
-	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-		     ctx->enc_keylen, NS_BIT);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	if (req_ctx->cryptlen && !req_ctx->plaintext_authenticate_only) {
-		/* load AES/CTR initial CTR value inc by 2*/
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
-		set_key_size_aes(&desc[idx], ctx->enc_keylen);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     req_ctx->gcm_iv_inc2_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-		set_flow_mode(&desc[idx], S_DIN_to_AES);
-		idx++;
-	}
-
-	*seq_size = idx;
-}
-
-static void cc_proc_gcm_result(struct aead_request *req,
-			       struct cc_hw_desc desc[],
-			       unsigned int *seq_size)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	dma_addr_t mac_result;
-	unsigned int idx = *seq_size;
-
-	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		mac_result = req_ctx->mac_buf_dma_addr;
-	} else { /* Encrypt */
-		mac_result = req_ctx->icv_dma_addr;
-	}
-
-	/* process(ghash) gcm_block_len */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gcm_block_len_dma_addr,
-		     AES_BLOCK_SIZE, NS_BIT);
-	set_flow_mode(&desc[idx], DIN_HASH);
-	idx++;
-
-	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
-	set_din_no_dma(&desc[idx], 0, 0xfffff0);
-	set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr, AES_BLOCK_SIZE,
-		      NS_BIT, 0);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_aes_not_hash_mode(&desc[idx]);
-
-	idx++;
-
-	/* load AES/CTR initial CTR value inc by 1*/
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
-	set_key_size_aes(&desc[idx], ctx->enc_keylen);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gcm_iv_inc1_dma_addr,
-		     AES_BLOCK_SIZE, NS_BIT);
-	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* Memory Barrier */
-	hw_desc_init(&desc[idx]);
-	set_din_no_dma(&desc[idx], 0, 0xfffff0);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	idx++;
-
-	/* process GCTR on stored GHASH and store MAC in mac_state*/
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
-	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
-		     AES_BLOCK_SIZE, NS_BIT);
-	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	idx++;
-
-	*seq_size = idx;
-}
-
-static int cc_gcm(struct aead_request *req, struct cc_hw_desc desc[],
-		  unsigned int *seq_size)
-{
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int cipher_flow_mode;
-
-	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		cipher_flow_mode = AES_and_HASH;
-	} else { /* Encrypt */
-		cipher_flow_mode = AES_to_HASH_and_DOUT;
-	}
-
-	//in RFC4543 no data to encrypt. just copy data from src to dest.
-	if (req_ctx->plaintext_authenticate_only) {
-		cc_proc_cipher_desc(req, BYPASS, desc, seq_size);
-		cc_set_ghash_desc(req, desc, seq_size);
-		/* process(ghash) assoc data */
-		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
-		cc_set_gctr_desc(req, desc, seq_size);
-		cc_proc_gcm_result(req, desc, seq_size);
-		return 0;
-	}
-
-	// for gcm and rfc4106.
-	cc_set_ghash_desc(req, desc, seq_size);
-	/* process(ghash) assoc data */
-	if (req->assoclen > 0)
-		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
-	cc_set_gctr_desc(req, desc, seq_size);
-	/* process(gctr+ghash) */
-	if (req_ctx->cryptlen)
-		cc_proc_cipher_desc(req, cipher_flow_mode, desc, seq_size);
-	cc_proc_gcm_result(req, desc, seq_size);
-
-	return 0;
-}
-
-static int config_gcm_context(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	unsigned int cryptlen = (req_ctx->gen_ctx.op_type ==
-				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				req->cryptlen :
-				(req->cryptlen - ctx->authsize);
-	__be32 counter = cpu_to_be32(2);
-
-	dev_dbg(dev, "%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n",
-		__func__, cryptlen, req->assoclen, ctx->authsize);
-
-	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
-
-	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
-
-	memcpy(req->iv + 12, &counter, 4);
-	memcpy(req_ctx->gcm_iv_inc2, req->iv, 16);
-
-	counter = cpu_to_be32(1);
-	memcpy(req->iv + 12, &counter, 4);
-	memcpy(req_ctx->gcm_iv_inc1, req->iv, 16);
-
-	if (!req_ctx->plaintext_authenticate_only) {
-		__be64 temp64;
-
-		temp64 = cpu_to_be64(req->assoclen * 8);
-		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
-		temp64 = cpu_to_be64(cryptlen * 8);
-		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
-	} else {
-		/* rfc4543=>  all data(AAD,IV,Plain) are considered additional
-		 * data that is nothing is encrypted.
-		 */
-		__be64 temp64;
-
-		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE +
-				      cryptlen) * 8);
-		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
-		temp64 = 0;
-		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
-	}
-
-	return 0;
-}
-
-static void cc_proc_rfc4_gcm(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET,
-	       ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
-	       GCM_BLOCK_RFC4_IV_SIZE);
-	req->iv = areq_ctx->ctr_iv;
-	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
-}
-
-static int cc_proc_aead(struct aead_request *req,
-			enum drv_crypto_direction direct)
-{
-	int rc = 0;
-	int seq_len = 0;
-	struct cc_hw_desc desc[MAX_AEAD_PROCESS_SEQ];
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct cc_crypto_req cc_req = {};
-
-	dev_dbg(dev, "%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
-		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Enc" : "Dec"),
-		ctx, req, req->iv, sg_virt(req->src), req->src->offset,
-		sg_virt(req->dst), req->dst->offset, req->cryptlen);
-
-	/* STAT_PHASE_0: Init and sanity checks */
-
-	/* Check data length according to mode */
-	if (validate_data_size(ctx, direct, req)) {
-		dev_err(dev, "Unsupported crypt/assoc len %d/%d.\n",
-			req->cryptlen, req->assoclen);
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
-		return -EINVAL;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = (void *)cc_aead_complete;
-	cc_req.user_arg = (void *)req;
-
-	/* Setup request context */
-	areq_ctx->gen_ctx.op_type = direct;
-	areq_ctx->req_authsize = ctx->authsize;
-	areq_ctx->cipher_mode = ctx->cipher_mode;
-
-	/* STAT_PHASE_1: Map buffers */
-
-	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-		/* Build CTR IV - Copy nonce from last 4 bytes in
-		 * CTR key to first 4 bytes in CTR IV
-		 */
-		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce,
-		       CTR_RFC3686_NONCE_SIZE);
-		if (!areq_ctx->backup_giv) /*User none-generated IV*/
-			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
-			       req->iv, CTR_RFC3686_IV_SIZE);
-		/* Initialize counter portion of counter block */
-		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
-			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
-
-		/* Replace with counter iv */
-		req->iv = areq_ctx->ctr_iv;
-		areq_ctx->hw_iv_size = CTR_RFC3686_BLOCK_SIZE;
-	} else if ((ctx->cipher_mode == DRV_CIPHER_CCM) ||
-		   (ctx->cipher_mode == DRV_CIPHER_GCTR)) {
-		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
-		if (areq_ctx->ctr_iv != req->iv) {
-			memcpy(areq_ctx->ctr_iv, req->iv,
-			       crypto_aead_ivsize(tfm));
-			req->iv = areq_ctx->ctr_iv;
-		}
-	}  else {
-		areq_ctx->hw_iv_size = crypto_aead_ivsize(tfm);
-	}
-
-	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
-		rc = config_ccm_adata(req);
-		if (rc) {
-			dev_dbg(dev, "config_ccm_adata() returned with a failure %d!",
-				rc);
-			goto exit;
-		}
-	} else {
-		areq_ctx->ccm_hdr_size = ccm_header_size_null;
-	}
-
-	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
-		rc = config_gcm_context(req);
-		if (rc) {
-			dev_dbg(dev, "config_gcm_context() returned with a failure %d!",
-				rc);
-			goto exit;
-		}
-	}
-
-	rc = cc_map_aead_request(ctx->drvdata, req);
-	if (rc) {
-		dev_err(dev, "map_request() failed\n");
-		goto exit;
-	}
-
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
-	/* STAT_PHASE_2: Create sequence */
-
-	/* Load MLLI tables to SRAM if necessary */
-	cc_mlli_to_sram(req, desc, &seq_len);
-
-	/*TODO: move seq len by reference */
-	switch (ctx->auth_mode) {
-	case DRV_HASH_SHA1:
-	case DRV_HASH_SHA256:
-		cc_hmac_authenc(req, desc, &seq_len);
-		break;
-	case DRV_HASH_XCBC_MAC:
-		cc_xcbc_authenc(req, desc, &seq_len);
-		break;
-	case DRV_HASH_NULL:
-		if (ctx->cipher_mode == DRV_CIPHER_CCM)
-			cc_ccm(req, desc, &seq_len);
-		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
-			cc_gcm(req, desc, &seq_len);
-		break;
-	default:
-		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
-		cc_unmap_aead_request(dev, req);
-		rc = -ENOTSUPP;
-		goto exit;
-	}
-
-	/* STAT_PHASE_3: Lock HW and push sequence */
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, seq_len, &req->base);
-
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_aead_request(dev, req);
-	}
-
-exit:
-	return rc;
-}
-
-static int cc_aead_encrypt(struct aead_request *req)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc;
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-	areq_ctx->is_gcm4543 = false;
-
-	areq_ctx->plaintext_authenticate_only = false;
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-
-	return rc;
-}
-
-static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
-{
-	/* Very similar to cc_aead_encrypt() above. */
-
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	int rc = -EINVAL;
-
-	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
-		goto out;
-	}
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-	areq_ctx->is_gcm4543 = true;
-
-	cc_proc_rfc4309_ccm(req);
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-out:
-	return rc;
-}
-
-static int cc_aead_decrypt(struct aead_request *req)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc;
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-	areq_ctx->is_gcm4543 = false;
-
-	areq_ctx->plaintext_authenticate_only = false;
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-
-	return rc;
-}
-
-static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc = -EINVAL;
-
-	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
-		goto out;
-	}
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-
-	areq_ctx->is_gcm4543 = true;
-	cc_proc_rfc4309_ccm(req);
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-
-out:
-	return rc;
-}
-
-static int cc_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
-				 unsigned int keylen)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "%s()  keylen %d, key %p\n", __func__, keylen, key);
-
-	if (keylen < 4)
-		return -EINVAL;
-
-	keylen -= 4;
-	memcpy(ctx->ctr_nonce, key + keylen, 4);
-
-	return cc_aead_setkey(tfm, key, keylen);
-}
-
-static int cc_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
-				 unsigned int keylen)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "%s()  keylen %d, key %p\n", __func__, keylen, key);
-
-	if (keylen < 4)
-		return -EINVAL;
-
-	keylen -= 4;
-	memcpy(ctx->ctr_nonce, key + keylen, 4);
-
-	return cc_aead_setkey(tfm, key, keylen);
-}
-
-static int cc_gcm_setauthsize(struct crypto_aead *authenc,
-			      unsigned int authsize)
-{
-	switch (authsize) {
-	case 4:
-	case 8:
-	case 12:
-	case 13:
-	case 14:
-	case 15:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return cc_aead_setauthsize(authenc, authsize);
-}
-
-static int cc_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "authsize %d\n", authsize);
-
-	switch (authsize) {
-	case 8:
-	case 12:
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return cc_aead_setauthsize(authenc, authsize);
-}
-
-static int cc_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
-{
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "authsize %d\n", authsize);
-
-	if (authsize != 16)
-		return -EINVAL;
-
-	return cc_aead_setauthsize(authenc, authsize);
-}
-
-static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
-{
-	/* Very similar to cc_aead_encrypt() above. */
-
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc = -EINVAL;
-
-	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
-		goto out;
-	}
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-
-	areq_ctx->plaintext_authenticate_only = false;
-
-	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-out:
-	return rc;
-}
-
-static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
-{
-	/* Very similar to cc_aead_encrypt() above. */
-
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc;
-
-	//plaintext is not encryped with rfc4543
-	areq_ctx->plaintext_authenticate_only = true;
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-
-	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-
-	return rc;
-}
-
-static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
-{
-	/* Very similar to cc_aead_decrypt() above. */
-
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc = -EINVAL;
-
-	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
-		goto out;
-	}
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-
-	areq_ctx->plaintext_authenticate_only = false;
-
-	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-out:
-	return rc;
-}
-
-static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
-{
-	/* Very similar to cc_aead_decrypt() above. */
-
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc;
-
-	//plaintext is not decryped with rfc4543
-	areq_ctx->plaintext_authenticate_only = true;
-
-	/* No generated IV required */
-	areq_ctx->backup_iv = req->iv;
-	areq_ctx->backup_giv = NULL;
-
-	cc_proc_rfc4_gcm(req);
-	areq_ctx->is_gcm4543 = true;
-
-	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS && rc != -EBUSY)
-		req->iv = areq_ctx->backup_iv;
-
-	return rc;
-}
-
-/* DX Block aead alg */
-static struct cc_alg_template aead_algs[] = {
-	{
-		.name = "authenc(hmac(sha1),cbc(aes))",
-		.driver_name = "authenc-hmac-sha1-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA1,
-	},
-	{
-		.name = "authenc(hmac(sha1),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha1-cbc-des3-dx",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_DES,
-		.auth_mode = DRV_HASH_SHA1,
-	},
-	{
-		.name = "authenc(hmac(sha256),cbc(aes))",
-		.driver_name = "authenc-hmac-sha256-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA256,
-	},
-	{
-		.name = "authenc(hmac(sha256),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha256-cbc-des3-dx",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_DES,
-		.auth_mode = DRV_HASH_SHA256,
-	},
-	{
-		.name = "authenc(xcbc(aes),cbc(aes))",
-		.driver_name = "authenc-xcbc-aes-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_XCBC_MAC,
-	},
-	{
-		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA1,
-	},
-	{
-		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA256,
-	},
-	{
-		.name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-xcbc-aes-rfc3686-ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_aead_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_XCBC_MAC,
-	},
-	{
-		.name = "ccm(aes)",
-		.driver_name = "ccm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_ccm_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CCM,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-	{
-		.name = "rfc4309(ccm(aes))",
-		.driver_name = "rfc4309-ccm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_rfc4309_ccm_setkey,
-			.setauthsize = cc_rfc4309_ccm_setauthsize,
-			.encrypt = cc_rfc4309_ccm_encrypt,
-			.decrypt = cc_rfc4309_ccm_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = CCM_BLOCK_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CCM,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-	{
-		.name = "gcm(aes)",
-		.driver_name = "gcm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_aead_setkey,
-			.setauthsize = cc_gcm_setauthsize,
-			.encrypt = cc_aead_encrypt,
-			.decrypt = cc_aead_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = 12,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_GCTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-	{
-		.name = "rfc4106(gcm(aes))",
-		.driver_name = "rfc4106-gcm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_rfc4106_gcm_setkey,
-			.setauthsize = cc_rfc4106_gcm_setauthsize,
-			.encrypt = cc_rfc4106_gcm_encrypt,
-			.decrypt = cc_rfc4106_gcm_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_GCTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-	{
-		.name = "rfc4543(gcm(aes))",
-		.driver_name = "rfc4543-gcm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = cc_rfc4543_gcm_setkey,
-			.setauthsize = cc_rfc4543_gcm_setauthsize,
-			.encrypt = cc_rfc4543_gcm_encrypt,
-			.decrypt = cc_rfc4543_gcm_decrypt,
-			.init = cc_aead_init,
-			.exit = cc_aead_exit,
-			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_GCTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-};
-
-static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
-						struct device *dev)
-{
-	struct cc_crypto_alg *t_alg;
-	struct aead_alg *alg;
-
-	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
-	if (!t_alg)
-		return ERR_PTR(-ENOMEM);
-
-	alg = &tmpl->template_aead;
-
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 tmpl->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 tmpl->driver_name);
-	alg->base.cra_module = THIS_MODULE;
-	alg->base.cra_priority = CC_CRA_PRIO;
-
-	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			 tmpl->type;
-	alg->init = cc_aead_init;
-	alg->exit = cc_aead_exit;
-
-	t_alg->aead_alg = *alg;
-
-	t_alg->cipher_mode = tmpl->cipher_mode;
-	t_alg->flow_mode = tmpl->flow_mode;
-	t_alg->auth_mode = tmpl->auth_mode;
-
-	return t_alg;
-}
-
-int cc_aead_free(struct cc_drvdata *drvdata)
-{
-	struct cc_crypto_alg *t_alg, *n;
-	struct cc_aead_handle *aead_handle =
-		(struct cc_aead_handle *)drvdata->aead_handle;
-
-	if (aead_handle) {
-		/* Remove registered algs */
-		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list,
-					 entry) {
-			crypto_unregister_aead(&t_alg->aead_alg);
-			list_del(&t_alg->entry);
-			kfree(t_alg);
-		}
-		kfree(aead_handle);
-		drvdata->aead_handle = NULL;
-	}
-
-	return 0;
-}
-
-int cc_aead_alloc(struct cc_drvdata *drvdata)
-{
-	struct cc_aead_handle *aead_handle;
-	struct cc_crypto_alg *t_alg;
-	int rc = -ENOMEM;
-	int alg;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	aead_handle = kmalloc(sizeof(*aead_handle), GFP_KERNEL);
-	if (!aead_handle) {
-		rc = -ENOMEM;
-		goto fail0;
-	}
-
-	INIT_LIST_HEAD(&aead_handle->aead_list);
-	drvdata->aead_handle = aead_handle;
-
-	aead_handle->sram_workspace_addr = cc_sram_alloc(drvdata,
-							 MAX_HMAC_DIGEST_SIZE);
-
-	if (aead_handle->sram_workspace_addr == NULL_SRAM_ADDR) {
-		dev_err(dev, "SRAM pool exhausted\n");
-		rc = -ENOMEM;
-		goto fail1;
-	}
-
-	/* Linux crypto */
-	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
-		t_alg = cc_create_aead_alg(&aead_algs[alg], dev);
-		if (IS_ERR(t_alg)) {
-			rc = PTR_ERR(t_alg);
-			dev_err(dev, "%s alg allocation failed\n",
-				aead_algs[alg].driver_name);
-			goto fail1;
-		}
-		t_alg->drvdata = drvdata;
-		rc = crypto_register_aead(&t_alg->aead_alg);
-		if (rc) {
-			dev_err(dev, "%s alg registration failed\n",
-				t_alg->aead_alg.base.cra_driver_name);
-			goto fail2;
-		} else {
-			list_add_tail(&t_alg->entry, &aead_handle->aead_list);
-			dev_dbg(dev, "Registered %s\n",
-				t_alg->aead_alg.base.cra_driver_name);
-		}
-	}
-
-	return 0;
-
-fail2:
-	kfree(t_alg);
-fail1:
-	cc_aead_free(drvdata);
-fail0:
-	return rc;
-}
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
deleted file mode 100644
index 9567b8f..0000000
--- a/drivers/staging/ccree/ssi_aead.h
+++ /dev/null
@@ -1,109 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file ssi_aead.h
- * ARM CryptoCell AEAD Crypto API
- */
-
-#ifndef __CC_AEAD_H__
-#define __CC_AEAD_H__
-
-#include <linux/kernel.h>
-#include <crypto/algapi.h>
-#include <crypto/ctr.h>
-
-/* mac_cmp - HW writes 8 B but all bytes hold the same value */
-#define ICV_CMP_SIZE 8
-#define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE * 3)
-#define MAX_MAC_SIZE SHA256_DIGEST_SIZE
-
-/* defines for AES GCM configuration buffer */
-#define GCM_BLOCK_LEN_SIZE 8
-
-#define GCM_BLOCK_RFC4_IV_OFFSET	4
-#define GCM_BLOCK_RFC4_IV_SIZE		8  /* IV size for rfc's */
-#define GCM_BLOCK_RFC4_NONCE_OFFSET	0
-#define GCM_BLOCK_RFC4_NONCE_SIZE	4
-
-/* Offsets into AES CCM configuration buffer */
-#define CCM_B0_OFFSET 0
-#define CCM_A0_OFFSET 16
-#define CCM_CTR_COUNT_0_OFFSET 32
-/* CCM B0 and CTR_COUNT constants. */
-#define CCM_BLOCK_NONCE_OFFSET 1  /* Nonce offset inside B0 and CTR_COUNT */
-#define CCM_BLOCK_NONCE_SIZE   3  /* Nonce size inside B0 and CTR_COUNT */
-#define CCM_BLOCK_IV_OFFSET    4  /* IV offset inside B0 and CTR_COUNT */
-#define CCM_BLOCK_IV_SIZE      8  /* IV size inside B0 and CTR_COUNT */
-
-enum aead_ccm_header_size {
-	ccm_header_size_null = -1,
-	ccm_header_size_zero = 0,
-	ccm_header_size_2 = 2,
-	ccm_header_size_6 = 6,
-	ccm_header_size_max = S32_MAX
-};
-
-struct aead_req_ctx {
-	/* Allocate cache line although only 4 bytes are needed to
-	 *  assure next field falls @ cache line
-	 *  Used for both: digest HW compare and CCM/GCM MAC value
-	 */
-	u8 mac_buf[MAX_MAC_SIZE] ____cacheline_aligned;
-	u8 ctr_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
-
-	//used in gcm
-	u8 gcm_iv_inc1[AES_BLOCK_SIZE] ____cacheline_aligned;
-	u8 gcm_iv_inc2[AES_BLOCK_SIZE] ____cacheline_aligned;
-	u8 hkey[AES_BLOCK_SIZE] ____cacheline_aligned;
-	struct {
-		u8 len_a[GCM_BLOCK_LEN_SIZE] ____cacheline_aligned;
-		u8 len_c[GCM_BLOCK_LEN_SIZE];
-	} gcm_len_block;
-
-	u8 ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
-	/* HW actual size input */
-	unsigned int hw_iv_size ____cacheline_aligned;
-	/* used to prevent cache coherence problem */
-	u8 backup_mac[MAX_MAC_SIZE];
-	u8 *backup_iv; /*store iv for generated IV flow*/
-	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
-	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
-	/* buffer for internal ccm configurations */
-	dma_addr_t ccm_iv0_dma_addr;
-	dma_addr_t icv_dma_addr; /* Phys. address of ICV */
-
-	//used in gcm
-	/* buffer for internal gcm configurations */
-	dma_addr_t gcm_iv_inc1_dma_addr;
-	/* buffer for internal gcm configurations */
-	dma_addr_t gcm_iv_inc2_dma_addr;
-	dma_addr_t hkey_dma_addr; /* Phys. address of hkey */
-	dma_addr_t gcm_block_len_dma_addr; /* Phys. address of gcm block len */
-	bool is_gcm4543;
-
-	u8 *icv_virt_addr; /* Virt. address of ICV */
-	struct async_gen_req_ctx gen_ctx;
-	struct cc_mlli assoc;
-	struct cc_mlli src;
-	struct cc_mlli dst;
-	struct scatterlist *src_sgl;
-	struct scatterlist *dst_sgl;
-	unsigned int src_offset;
-	unsigned int dst_offset;
-	enum cc_req_dma_buf_type assoc_buff_type;
-	enum cc_req_dma_buf_type data_buff_type;
-	struct mlli_params mlli_params;
-	unsigned int cryptlen;
-	struct scatterlist ccm_adata_sg;
-	enum aead_ccm_header_size ccm_hdr_size;
-	unsigned int req_authsize;
-	enum drv_cipher_mode cipher_mode;
-	bool is_icv_fragmented;
-	bool is_single_pass;
-	bool plaintext_authenticate_only; //for gcm_rfc4543
-};
-
-int cc_aead_alloc(struct cc_drvdata *drvdata);
-int cc_aead_free(struct cc_drvdata *drvdata);
-
-#endif /*__CC_AEAD_H__*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
deleted file mode 100644
index 684070d..0000000
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ /dev/null
@@ -1,1657 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/crypto.h>
-#include <linux/version.h>
-#include <crypto/algapi.h>
-#include <crypto/internal/aead.h>
-#include <crypto/hash.h>
-#include <crypto/authenc.h>
-#include <crypto/scatterwalk.h>
-#include <linux/dmapool.h>
-#include <linux/dma-mapping.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-
-#include "ssi_buffer_mgr.h"
-#include "cc_lli_defs.h"
-#include "ssi_cipher.h"
-#include "ssi_hash.h"
-#include "ssi_aead.h"
-
-enum dma_buffer_type {
-	DMA_NULL_TYPE = -1,
-	DMA_SGL_TYPE = 1,
-	DMA_BUFF_TYPE = 2,
-};
-
-struct buff_mgr_handle {
-	struct dma_pool *mlli_buffs_pool;
-};
-
-union buffer_array_entry {
-	struct scatterlist *sgl;
-	dma_addr_t buffer_dma;
-};
-
-struct buffer_array {
-	unsigned int num_of_buffers;
-	union buffer_array_entry entry[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	unsigned int offset[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	int nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	int total_data_len[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	enum dma_buffer_type type[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	bool is_last[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
-};
-
-static inline char *cc_dma_buf_type(enum cc_req_dma_buf_type type)
-{
-	switch (type) {
-	case CC_DMA_BUF_NULL:
-		return "BUF_NULL";
-	case CC_DMA_BUF_DLLI:
-		return "BUF_DLLI";
-	case CC_DMA_BUF_MLLI:
-		return "BUF_MLLI";
-	default:
-		return "BUF_INVALID";
-	}
-}
-
-/**
- * cc_copy_mac() - Copy MAC to temporary location
- *
- * @dev: device object
- * @req: aead request object
- * @dir: [IN] copy from/to sgl
- */
-static void cc_copy_mac(struct device *dev, struct aead_request *req,
-			enum cc_sg_cpy_direct dir)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	u32 skip = req->assoclen + req->cryptlen;
-
-	if (areq_ctx->is_gcm4543)
-		skip += crypto_aead_ivsize(tfm);
-
-	cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
-			   (skip - areq_ctx->req_authsize), skip, dir);
-}
-
-/**
- * cc_get_sgl_nents() - Get scatterlist number of entries.
- *
- * @sg_list: SG list
- * @nbytes: [IN] Total SGL data bytes.
- * @lbytes: [OUT] Returns the amount of bytes at the last entry
- */
-static unsigned int cc_get_sgl_nents(struct device *dev,
-				     struct scatterlist *sg_list,
-				     unsigned int nbytes, u32 *lbytes,
-				     bool *is_chained)
-{
-	unsigned int nents = 0;
-
-	while (nbytes && sg_list) {
-		if (sg_list->length) {
-			nents++;
-			/* get the number of bytes in the last entry */
-			*lbytes = nbytes;
-			nbytes -= (sg_list->length > nbytes) ?
-					nbytes : sg_list->length;
-			sg_list = sg_next(sg_list);
-		} else {
-			sg_list = (struct scatterlist *)sg_page(sg_list);
-			if (is_chained)
-				*is_chained = true;
-		}
-	}
-	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
-	return nents;
-}
-
-/**
- * cc_zero_sgl() - Zero scatter scatter list data.
- *
- * @sgl:
- */
-void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
-{
-	struct scatterlist *current_sg = sgl;
-	int sg_index = 0;
-
-	while (sg_index <= data_len) {
-		if (!current_sg) {
-			/* reached the end of the sgl --> just return back */
-			return;
-		}
-		memset(sg_virt(current_sg), 0, current_sg->length);
-		sg_index += current_sg->length;
-		current_sg = sg_next(current_sg);
-	}
-}
-
-/**
- * cc_copy_sg_portion() - Copy scatter list data,
- * from to_skip to end, to dest and vice versa
- *
- * @dest:
- * @sg:
- * @to_skip:
- * @end:
- * @direct:
- */
-void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
-			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct)
-{
-	u32 nents, lbytes;
-
-	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
-	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
-		       (direct == CC_SG_TO_BUF));
-}
-
-static int cc_render_buff_to_mlli(struct device *dev, dma_addr_t buff_dma,
-				  u32 buff_size, u32 *curr_nents,
-				  u32 **mlli_entry_pp)
-{
-	u32 *mlli_entry_p = *mlli_entry_pp;
-	u32 new_nents;
-
-	/* Verify there is no memory overflow*/
-	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
-	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES)
-		return -ENOMEM;
-
-	/*handle buffer longer than 64 kbytes */
-	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE) {
-		cc_lli_set_addr(mlli_entry_p, buff_dma);
-		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
-		dev_dbg(dev, "entry[%d]: single_buff=0x%08X size=%08X\n",
-			*curr_nents, mlli_entry_p[LLI_WORD0_OFFSET],
-			mlli_entry_p[LLI_WORD1_OFFSET]);
-		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
-		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
-		mlli_entry_p = mlli_entry_p + 2;
-		(*curr_nents)++;
-	}
-	/*Last entry */
-	cc_lli_set_addr(mlli_entry_p, buff_dma);
-	cc_lli_set_size(mlli_entry_p, buff_size);
-	dev_dbg(dev, "entry[%d]: single_buff=0x%08X size=%08X\n",
-		*curr_nents, mlli_entry_p[LLI_WORD0_OFFSET],
-		mlli_entry_p[LLI_WORD1_OFFSET]);
-	mlli_entry_p = mlli_entry_p + 2;
-	*mlli_entry_pp = mlli_entry_p;
-	(*curr_nents)++;
-	return 0;
-}
-
-static int cc_render_sg_to_mlli(struct device *dev, struct scatterlist *sgl,
-				u32 sgl_data_len, u32 sgl_offset,
-				u32 *curr_nents, u32 **mlli_entry_pp)
-{
-	struct scatterlist *curr_sgl = sgl;
-	u32 *mlli_entry_p = *mlli_entry_pp;
-	s32 rc = 0;
-
-	for ( ; (curr_sgl && sgl_data_len);
-	      curr_sgl = sg_next(curr_sgl)) {
-		u32 entry_data_len =
-			(sgl_data_len > sg_dma_len(curr_sgl) - sgl_offset) ?
-				sg_dma_len(curr_sgl) - sgl_offset :
-				sgl_data_len;
-		sgl_data_len -= entry_data_len;
-		rc = cc_render_buff_to_mlli(dev, sg_dma_address(curr_sgl) +
-					    sgl_offset, entry_data_len,
-					    curr_nents, &mlli_entry_p);
-		if (rc)
-			return rc;
-
-		sgl_offset = 0;
-	}
-	*mlli_entry_pp = mlli_entry_p;
-	return 0;
-}
-
-static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
-			    struct mlli_params *mlli_params, gfp_t flags)
-{
-	u32 *mlli_p;
-	u32 total_nents = 0, prev_total_nents = 0;
-	int rc = 0, i;
-
-	dev_dbg(dev, "NUM of SG's = %d\n", sg_data->num_of_buffers);
-
-	/* Allocate memory from the pointed pool */
-	mlli_params->mlli_virt_addr =
-		dma_pool_alloc(mlli_params->curr_pool, flags,
-			       &mlli_params->mlli_dma_addr);
-	if (!mlli_params->mlli_virt_addr) {
-		dev_err(dev, "dma_pool_alloc() failed\n");
-		rc = -ENOMEM;
-		goto build_mlli_exit;
-	}
-	/* Point to start of MLLI */
-	mlli_p = (u32 *)mlli_params->mlli_virt_addr;
-	/* go over all SG's and link it to one MLLI table */
-	for (i = 0; i < sg_data->num_of_buffers; i++) {
-		union buffer_array_entry *entry = &sg_data->entry[i];
-		u32 tot_len = sg_data->total_data_len[i];
-		u32 offset = sg_data->offset[i];
-
-		if (sg_data->type[i] == DMA_SGL_TYPE)
-			rc = cc_render_sg_to_mlli(dev, entry->sgl, tot_len,
-						  offset, &total_nents,
-						  &mlli_p);
-		else /*DMA_BUFF_TYPE*/
-			rc = cc_render_buff_to_mlli(dev, entry->buffer_dma,
-						    tot_len, &total_nents,
-						    &mlli_p);
-		if (rc)
-			return rc;
-
-		/* set last bit in the current table */
-		if (sg_data->mlli_nents[i]) {
-			/*Calculate the current MLLI table length for the
-			 *length field in the descriptor
-			 */
-			*sg_data->mlli_nents[i] +=
-				(total_nents - prev_total_nents);
-			prev_total_nents = total_nents;
-		}
-	}
-
-	/* Set MLLI size for the bypass operation */
-	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
-
-	dev_dbg(dev, "MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
-		mlli_params->mlli_virt_addr, &mlli_params->mlli_dma_addr,
-		mlli_params->mlli_len);
-
-build_mlli_exit:
-	return rc;
-}
-
-static void cc_add_buffer_entry(struct device *dev,
-				struct buffer_array *sgl_data,
-				dma_addr_t buffer_dma, unsigned int buffer_len,
-				bool is_last_entry, u32 *mlli_nents)
-{
-	unsigned int index = sgl_data->num_of_buffers;
-
-	dev_dbg(dev, "index=%u single_buff=%pad buffer_len=0x%08X is_last=%d\n",
-		index, &buffer_dma, buffer_len, is_last_entry);
-	sgl_data->nents[index] = 1;
-	sgl_data->entry[index].buffer_dma = buffer_dma;
-	sgl_data->offset[index] = 0;
-	sgl_data->total_data_len[index] = buffer_len;
-	sgl_data->type[index] = DMA_BUFF_TYPE;
-	sgl_data->is_last[index] = is_last_entry;
-	sgl_data->mlli_nents[index] = mlli_nents;
-	if (sgl_data->mlli_nents[index])
-		*sgl_data->mlli_nents[index] = 0;
-	sgl_data->num_of_buffers++;
-}
-
-static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
-			    unsigned int nents, struct scatterlist *sgl,
-			    unsigned int data_len, unsigned int data_offset,
-			    bool is_last_table, u32 *mlli_nents)
-{
-	unsigned int index = sgl_data->num_of_buffers;
-
-	dev_dbg(dev, "index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
-		index, nents, sgl, data_len, is_last_table);
-	sgl_data->nents[index] = nents;
-	sgl_data->entry[index].sgl = sgl;
-	sgl_data->offset[index] = data_offset;
-	sgl_data->total_data_len[index] = data_len;
-	sgl_data->type[index] = DMA_SGL_TYPE;
-	sgl_data->is_last[index] = is_last_table;
-	sgl_data->mlli_nents[index] = mlli_nents;
-	if (sgl_data->mlli_nents[index])
-		*sgl_data->mlli_nents[index] = 0;
-	sgl_data->num_of_buffers++;
-}
-
-static int cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
-			 enum dma_data_direction direction)
-{
-	u32 i, j;
-	struct scatterlist *l_sg = sg;
-
-	for (i = 0; i < nents; i++) {
-		if (!l_sg)
-			break;
-		if (dma_map_sg(dev, l_sg, 1, direction) != 1) {
-			dev_err(dev, "dma_map_page() sg buffer failed\n");
-			goto err;
-		}
-		l_sg = sg_next(l_sg);
-	}
-	return nents;
-
-err:
-	/* Restore mapped parts */
-	for (j = 0; j < i; j++) {
-		if (!sg)
-			break;
-		dma_unmap_sg(dev, sg, 1, direction);
-		sg = sg_next(sg);
-	}
-	return 0;
-}
-
-static int cc_map_sg(struct device *dev, struct scatterlist *sg,
-		     unsigned int nbytes, int direction, u32 *nents,
-		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
-{
-	bool is_chained = false;
-
-	if (sg_is_last(sg)) {
-		/* One entry only case -set to DLLI */
-		if (dma_map_sg(dev, sg, 1, direction) != 1) {
-			dev_err(dev, "dma_map_sg() single buffer failed\n");
-			return -ENOMEM;
-		}
-		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
-			&sg_dma_address(sg), sg_page(sg), sg_virt(sg),
-			sg->offset, sg->length);
-		*lbytes = nbytes;
-		*nents = 1;
-		*mapped_nents = 1;
-	} else {  /*sg_is_last*/
-		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes,
-					  &is_chained);
-		if (*nents > max_sg_nents) {
-			*nents = 0;
-			dev_err(dev, "Too many fragments. current %d max %d\n",
-				*nents, max_sg_nents);
-			return -ENOMEM;
-		}
-		if (!is_chained) {
-			/* In case of mmu the number of mapped nents might
-			 * be changed from the original sgl nents
-			 */
-			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-			if (*mapped_nents == 0) {
-				*nents = 0;
-				dev_err(dev, "dma_map_sg() sg buffer failed\n");
-				return -ENOMEM;
-			}
-		} else {
-			/*In this case the driver maps entry by entry so it
-			 * must have the same nents before and after map
-			 */
-			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
-						      direction);
-			if (*mapped_nents != *nents) {
-				*nents = *mapped_nents;
-				dev_err(dev, "dma_map_sg() sg buffer failed\n");
-				return -ENOMEM;
-			}
-		}
-	}
-
-	return 0;
-}
-
-static int
-cc_set_aead_conf_buf(struct device *dev, struct aead_req_ctx *areq_ctx,
-		     u8 *config_data, struct buffer_array *sg_data,
-		     unsigned int assoclen)
-{
-	dev_dbg(dev, " handle additional data config set to DLLI\n");
-	/* create sg for the current buffer */
-	sg_init_one(&areq_ctx->ccm_adata_sg, config_data,
-		    AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
-	if (dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE) != 1) {
-		dev_err(dev, "dma_map_sg() config buffer failed\n");
-		return -ENOMEM;
-	}
-	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
-		&sg_dma_address(&areq_ctx->ccm_adata_sg),
-		sg_page(&areq_ctx->ccm_adata_sg),
-		sg_virt(&areq_ctx->ccm_adata_sg),
-		areq_ctx->ccm_adata_sg.offset, areq_ctx->ccm_adata_sg.length);
-	/* prepare for case of MLLI */
-	if (assoclen > 0) {
-		cc_add_sg_entry(dev, sg_data, 1, &areq_ctx->ccm_adata_sg,
-				(AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
-				0, false, NULL);
-	}
-	return 0;
-}
-
-static int cc_set_hash_buf(struct device *dev, struct ahash_req_ctx *areq_ctx,
-			   u8 *curr_buff, u32 curr_buff_cnt,
-			   struct buffer_array *sg_data)
-{
-	dev_dbg(dev, " handle curr buff %x set to   DLLI\n", curr_buff_cnt);
-	/* create sg for the current buffer */
-	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
-	if (dma_map_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE) != 1) {
-		dev_err(dev, "dma_map_sg() src buffer failed\n");
-		return -ENOMEM;
-	}
-	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
-		&sg_dma_address(areq_ctx->buff_sg), sg_page(areq_ctx->buff_sg),
-		sg_virt(areq_ctx->buff_sg), areq_ctx->buff_sg->offset,
-		areq_ctx->buff_sg->length);
-	areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
-	areq_ctx->curr_sg = areq_ctx->buff_sg;
-	areq_ctx->in_nents = 0;
-	/* prepare for case of MLLI */
-	cc_add_sg_entry(dev, sg_data, 1, areq_ctx->buff_sg, curr_buff_cnt, 0,
-			false, NULL);
-	return 0;
-}
-
-void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
-				unsigned int ivsize, struct scatterlist *src,
-				struct scatterlist *dst)
-{
-	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
-
-	if (req_ctx->gen_ctx.iv_dma_addr) {
-		dev_dbg(dev, "Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
-			&req_ctx->gen_ctx.iv_dma_addr, ivsize);
-		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
-				 ivsize,
-				 req_ctx->is_giv ? DMA_BIDIRECTIONAL :
-				 DMA_TO_DEVICE);
-	}
-	/* Release pool */
-	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI &&
-	    req_ctx->mlli_params.mlli_virt_addr) {
-		dma_pool_free(req_ctx->mlli_params.curr_pool,
-			      req_ctx->mlli_params.mlli_virt_addr,
-			      req_ctx->mlli_params.mlli_dma_addr);
-	}
-
-	dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
-	dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
-
-	if (src != dst) {
-		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped req->dst=%pK\n", sg_virt(dst));
-	}
-}
-
-int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
-			     unsigned int ivsize, unsigned int nbytes,
-			     void *info, struct scatterlist *src,
-			     struct scatterlist *dst, gfp_t flags)
-{
-	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
-	struct mlli_params *mlli_params = &req_ctx->mlli_params;
-	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
-	struct device *dev = drvdata_to_dev(drvdata);
-	struct buffer_array sg_data;
-	u32 dummy = 0;
-	int rc = 0;
-	u32 mapped_nents = 0;
-
-	req_ctx->dma_buf_type = CC_DMA_BUF_DLLI;
-	mlli_params->curr_pool = NULL;
-	sg_data.num_of_buffers = 0;
-
-	/* Map IV buffer */
-	if (ivsize) {
-		dump_byte_array("iv", (u8 *)info, ivsize);
-		req_ctx->gen_ctx.iv_dma_addr =
-			dma_map_single(dev, (void *)info,
-				       ivsize,
-				       req_ctx->is_giv ? DMA_BIDIRECTIONAL :
-				       DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, req_ctx->gen_ctx.iv_dma_addr)) {
-			dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
-				ivsize, info);
-			return -ENOMEM;
-		}
-		dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
-			ivsize, info, &req_ctx->gen_ctx.iv_dma_addr);
-	} else {
-		req_ctx->gen_ctx.iv_dma_addr = 0;
-	}
-
-	/* Map the src SGL */
-	rc = cc_map_sg(dev, src, nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
-		       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
-	if (rc) {
-		rc = -ENOMEM;
-		goto ablkcipher_exit;
-	}
-	if (mapped_nents > 1)
-		req_ctx->dma_buf_type = CC_DMA_BUF_MLLI;
-
-	if (src == dst) {
-		/* Handle inplace operation */
-		if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
-			req_ctx->out_nents = 0;
-			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
-					nbytes, 0, true,
-					&req_ctx->in_mlli_nents);
-		}
-	} else {
-		/* Map the dst sg */
-		if (cc_map_sg(dev, dst, nbytes, DMA_BIDIRECTIONAL,
-			      &req_ctx->out_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
-			      &dummy, &mapped_nents)) {
-			rc = -ENOMEM;
-			goto ablkcipher_exit;
-		}
-		if (mapped_nents > 1)
-			req_ctx->dma_buf_type = CC_DMA_BUF_MLLI;
-
-		if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
-			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
-					nbytes, 0, true,
-					&req_ctx->in_mlli_nents);
-			cc_add_sg_entry(dev, &sg_data, req_ctx->out_nents, dst,
-					nbytes, 0, true,
-					&req_ctx->out_mlli_nents);
-		}
-	}
-
-	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
-		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		rc = cc_generate_mlli(dev, &sg_data, mlli_params, flags);
-		if (rc)
-			goto ablkcipher_exit;
-	}
-
-	dev_dbg(dev, "areq_ctx->dma_buf_type = %s\n",
-		cc_dma_buf_type(req_ctx->dma_buf_type));
-
-	return 0;
-
-ablkcipher_exit:
-	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
-	return rc;
-}
-
-void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	u32 dummy;
-	bool chained;
-	u32 size_to_unmap = 0;
-
-	if (areq_ctx->mac_buf_dma_addr) {
-		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
-				 MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
-	}
-
-	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
-		if (areq_ctx->hkey_dma_addr) {
-			dma_unmap_single(dev, areq_ctx->hkey_dma_addr,
-					 AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
-		}
-
-		if (areq_ctx->gcm_block_len_dma_addr) {
-			dma_unmap_single(dev, areq_ctx->gcm_block_len_dma_addr,
-					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		}
-
-		if (areq_ctx->gcm_iv_inc1_dma_addr) {
-			dma_unmap_single(dev, areq_ctx->gcm_iv_inc1_dma_addr,
-					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		}
-
-		if (areq_ctx->gcm_iv_inc2_dma_addr) {
-			dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr,
-					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		}
-	}
-
-	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		if (areq_ctx->ccm_iv0_dma_addr) {
-			dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr,
-					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		}
-
-		dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE);
-	}
-	if (areq_ctx->gen_ctx.iv_dma_addr) {
-		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
-				 hw_iv_size, DMA_BIDIRECTIONAL);
-	}
-
-	/*In case a pool was set, a table was
-	 *allocated and should be released
-	 */
-	if (areq_ctx->mlli_params.curr_pool) {
-		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
-			&areq_ctx->mlli_params.mlli_dma_addr,
-			areq_ctx->mlli_params.mlli_virt_addr);
-		dma_pool_free(areq_ctx->mlli_params.curr_pool,
-			      areq_ctx->mlli_params.mlli_virt_addr,
-			      areq_ctx->mlli_params.mlli_dma_addr);
-	}
-
-	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
-		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
-		req->assoclen, req->cryptlen);
-	size_to_unmap = req->assoclen + req->cryptlen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
-		size_to_unmap += areq_ctx->req_authsize;
-	if (areq_ctx->is_gcm4543)
-		size_to_unmap += crypto_aead_ivsize(tfm);
-
-	dma_unmap_sg(dev, req->src,
-		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
-				      &dummy, &chained),
-		     DMA_BIDIRECTIONAL);
-	if (req->src != req->dst) {
-		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
-			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst,
-			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
-					      &dummy, &chained),
-			     DMA_BIDIRECTIONAL);
-	}
-	if (drvdata->coherent &&
-	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
-	    req->src == req->dst) {
-		/* copy back mac from temporary location to deal with possible
-		 * data memory overriding that caused by cache coherence
-		 * problem.
-		 */
-		cc_copy_mac(dev, req, CC_SG_FROM_BUF);
-	}
-}
-
-static int cc_get_aead_icv_nents(struct device *dev, struct scatterlist *sgl,
-				 unsigned int sgl_nents, unsigned int authsize,
-				 u32 last_entry_data_size,
-				 bool *is_icv_fragmented)
-{
-	unsigned int icv_max_size = 0;
-	unsigned int icv_required_size = authsize > last_entry_data_size ?
-					(authsize - last_entry_data_size) :
-					authsize;
-	unsigned int nents;
-	unsigned int i;
-
-	if (sgl_nents < MAX_ICV_NENTS_SUPPORTED) {
-		*is_icv_fragmented = false;
-		return 0;
-	}
-
-	for (i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
-		if (!sgl)
-			break;
-		sgl = sg_next(sgl);
-	}
-
-	if (sgl)
-		icv_max_size = sgl->length;
-
-	if (last_entry_data_size > authsize) {
-		/* ICV attached to data in last entry (not fragmented!) */
-		nents = 0;
-		*is_icv_fragmented = false;
-	} else if (last_entry_data_size == authsize) {
-		/* ICV placed in whole last entry (not fragmented!) */
-		nents = 1;
-		*is_icv_fragmented = false;
-	} else if (icv_max_size > icv_required_size) {
-		nents = 1;
-		*is_icv_fragmented = true;
-	} else if (icv_max_size == icv_required_size) {
-		nents = 2;
-		*is_icv_fragmented = true;
-	} else {
-		dev_err(dev, "Unsupported num. of ICV fragments (> %d)\n",
-			MAX_ICV_NENTS_SUPPORTED);
-		nents = -1; /*unsupported*/
-	}
-	dev_dbg(dev, "is_frag=%s icv_nents=%u\n",
-		(*is_icv_fragmented ? "true" : "false"), nents);
-
-	return nents;
-}
-
-static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
-			    struct aead_request *req,
-			    struct buffer_array *sg_data,
-			    bool is_last, bool do_chain)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
-	struct device *dev = drvdata_to_dev(drvdata);
-	int rc = 0;
-
-	if (!req->iv) {
-		areq_ctx->gen_ctx.iv_dma_addr = 0;
-		goto chain_iv_exit;
-	}
-
-	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
-						       hw_iv_size,
-						       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
-		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
-			hw_iv_size, req->iv);
-		rc = -ENOMEM;
-		goto chain_iv_exit;
-	}
-
-	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
-		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
-	// TODO: what about CTR?? ask Ron
-	if (do_chain && areq_ctx->plaintext_authenticate_only) {
-		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
-		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
-		/* Chain to given list */
-		cc_add_buffer_entry(dev, sg_data,
-				    (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
-				    iv_size_to_authenc, is_last,
-				    &areq_ctx->assoc.mlli_nents);
-		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
-	}
-
-chain_iv_exit:
-	return rc;
-}
-
-static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
-			       struct aead_request *req,
-			       struct buffer_array *sg_data,
-			       bool is_last, bool do_chain)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc = 0;
-	u32 mapped_nents = 0;
-	struct scatterlist *current_sg = req->src;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	unsigned int sg_index = 0;
-	u32 size_of_assoc = req->assoclen;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	if (areq_ctx->is_gcm4543)
-		size_of_assoc += crypto_aead_ivsize(tfm);
-
-	if (!sg_data) {
-		rc = -EINVAL;
-		goto chain_assoc_exit;
-	}
-
-	if (req->assoclen == 0) {
-		areq_ctx->assoc_buff_type = CC_DMA_BUF_NULL;
-		areq_ctx->assoc.nents = 0;
-		areq_ctx->assoc.mlli_nents = 0;
-		dev_dbg(dev, "Chain assoc of length 0: buff_type=%s nents=%u\n",
-			cc_dma_buf_type(areq_ctx->assoc_buff_type),
-			areq_ctx->assoc.nents);
-		goto chain_assoc_exit;
-	}
-
-	//iterate over the sgl to see how many entries are for associated data
-	//it is assumed that if we reach here , the sgl is already mapped
-	sg_index = current_sg->length;
-	//the first entry in the scatter list contains all the associated data
-	if (sg_index > size_of_assoc) {
-		mapped_nents++;
-	} else {
-		while (sg_index <= size_of_assoc) {
-			current_sg = sg_next(current_sg);
-			/* if have reached the end of the sgl, then this is
-			 * unexpected
-			 */
-			if (!current_sg) {
-				dev_err(dev, "reached end of sg list. unexpected\n");
-				return -EINVAL;
-			}
-			sg_index += current_sg->length;
-			mapped_nents++;
-		}
-	}
-	if (mapped_nents > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
-		dev_err(dev, "Too many fragments. current %d max %d\n",
-			mapped_nents, LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
-		return -ENOMEM;
-	}
-	areq_ctx->assoc.nents = mapped_nents;
-
-	/* in CCM case we have additional entry for
-	 * ccm header configurations
-	 */
-	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		if ((mapped_nents + 1) > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
-			dev_err(dev, "CCM case.Too many fragments. Current %d max %d\n",
-				(areq_ctx->assoc.nents + 1),
-				LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
-			rc = -ENOMEM;
-			goto chain_assoc_exit;
-		}
-	}
-
-	if (mapped_nents == 1 && areq_ctx->ccm_hdr_size == ccm_header_size_null)
-		areq_ctx->assoc_buff_type = CC_DMA_BUF_DLLI;
-	else
-		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
-
-	if (do_chain || areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI) {
-		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
-			cc_dma_buf_type(areq_ctx->assoc_buff_type),
-			areq_ctx->assoc.nents);
-		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
-				req->assoclen, 0, is_last,
-				&areq_ctx->assoc.mlli_nents);
-		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
-	}
-
-chain_assoc_exit:
-	return rc;
-}
-
-static void cc_prepare_aead_data_dlli(struct aead_request *req,
-				      u32 *src_last_bytes, u32 *dst_last_bytes)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
-	unsigned int authsize = areq_ctx->req_authsize;
-
-	areq_ctx->is_icv_fragmented = false;
-	if (req->src == req->dst) {
-		/*INPLACE*/
-		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		/*NON-INPLACE and DECRYPT*/
-		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-	} else {
-		/*NON-INPLACE and ENCRYPT*/
-		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->dst_sgl) +
-			(*dst_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->dst_sgl) +
-			(*dst_last_bytes - authsize);
-	}
-}
-
-static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
-				     struct aead_request *req,
-				     struct buffer_array *sg_data,
-				     u32 *src_last_bytes, u32 *dst_last_bytes,
-				     bool is_last_table)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
-	unsigned int authsize = areq_ctx->req_authsize;
-	int rc = 0, icv_nents;
-	struct device *dev = drvdata_to_dev(drvdata);
-	struct scatterlist *sg;
-
-	if (req->src == req->dst) {
-		/*INPLACE*/
-		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
-				areq_ctx->src_sgl, areq_ctx->cryptlen,
-				areq_ctx->src_offset, is_last_table,
-				&areq_ctx->src.mlli_nents);
-
-		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
-						  areq_ctx->src.nents,
-						  authsize, *src_last_bytes,
-						  &areq_ctx->is_icv_fragmented);
-		if (icv_nents < 0) {
-			rc = -ENOTSUPP;
-			goto prepare_data_mlli_exit;
-		}
-
-		if (areq_ctx->is_icv_fragmented) {
-			/* Backup happens only when ICV is fragmented, ICV
-			 * verification is made by CPU compare in order to
-			 * simplify MAC verification upon request completion
-			 */
-			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
-				/* In coherent platforms (e.g. ACP)
-				 * already copying ICV for any
-				 * INPLACE-DECRYPT operation, hence
-				 * we must neglect this code.
-				 */
-				if (!drvdata->coherent)
-					cc_copy_mac(dev, req, CC_SG_TO_BUF);
-
-				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
-			} else {
-				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
-				areq_ctx->icv_dma_addr =
-					areq_ctx->mac_buf_dma_addr;
-			}
-		} else { /* Contig. ICV */
-			sg = &areq_ctx->src_sgl[areq_ctx->src.nents - 1];
-			/*Should hanlde if the sg is not contig.*/
-			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
-				(*src_last_bytes - authsize);
-			areq_ctx->icv_virt_addr = sg_virt(sg) +
-				(*src_last_bytes - authsize);
-		}
-
-	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		/*NON-INPLACE and DECRYPT*/
-		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
-				areq_ctx->src_sgl, areq_ctx->cryptlen,
-				areq_ctx->src_offset, is_last_table,
-				&areq_ctx->src.mlli_nents);
-		cc_add_sg_entry(dev, sg_data, areq_ctx->dst.nents,
-				areq_ctx->dst_sgl, areq_ctx->cryptlen,
-				areq_ctx->dst_offset, is_last_table,
-				&areq_ctx->dst.mlli_nents);
-
-		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
-						  areq_ctx->src.nents,
-						  authsize, *src_last_bytes,
-						  &areq_ctx->is_icv_fragmented);
-		if (icv_nents < 0) {
-			rc = -ENOTSUPP;
-			goto prepare_data_mlli_exit;
-		}
-
-		/* Backup happens only when ICV is fragmented, ICV
-		 * verification is made by CPU compare in order to simplify
-		 * MAC verification upon request completion
-		 */
-		if (areq_ctx->is_icv_fragmented) {
-			cc_copy_mac(dev, req, CC_SG_TO_BUF);
-			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
-
-		} else { /* Contig. ICV */
-			sg = &areq_ctx->src_sgl[areq_ctx->src.nents - 1];
-			/*Should hanlde if the sg is not contig.*/
-			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
-				(*src_last_bytes - authsize);
-			areq_ctx->icv_virt_addr = sg_virt(sg) +
-				(*src_last_bytes - authsize);
-		}
-
-	} else {
-		/*NON-INPLACE and ENCRYPT*/
-		cc_add_sg_entry(dev, sg_data, areq_ctx->dst.nents,
-				areq_ctx->dst_sgl, areq_ctx->cryptlen,
-				areq_ctx->dst_offset, is_last_table,
-				&areq_ctx->dst.mlli_nents);
-		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
-				areq_ctx->src_sgl, areq_ctx->cryptlen,
-				areq_ctx->src_offset, is_last_table,
-				&areq_ctx->src.mlli_nents);
-
-		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->dst_sgl,
-						  areq_ctx->dst.nents,
-						  authsize, *dst_last_bytes,
-						  &areq_ctx->is_icv_fragmented);
-		if (icv_nents < 0) {
-			rc = -ENOTSUPP;
-			goto prepare_data_mlli_exit;
-		}
-
-		if (!areq_ctx->is_icv_fragmented) {
-			sg = &areq_ctx->dst_sgl[areq_ctx->dst.nents - 1];
-			/* Contig. ICV */
-			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
-				(*dst_last_bytes - authsize);
-			areq_ctx->icv_virt_addr = sg_virt(sg) +
-				(*dst_last_bytes - authsize);
-		} else {
-			areq_ctx->icv_dma_addr = areq_ctx->mac_buf_dma_addr;
-			areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
-		}
-	}
-
-prepare_data_mlli_exit:
-	return rc;
-}
-
-static int cc_aead_chain_data(struct cc_drvdata *drvdata,
-			      struct aead_request *req,
-			      struct buffer_array *sg_data,
-			      bool is_last_table, bool do_chain)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct device *dev = drvdata_to_dev(drvdata);
-	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
-	unsigned int authsize = areq_ctx->req_authsize;
-	int src_last_bytes = 0, dst_last_bytes = 0;
-	int rc = 0;
-	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
-	u32 offset = 0;
-	/* non-inplace mode */
-	unsigned int size_for_map = req->assoclen + req->cryptlen;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	u32 sg_index = 0;
-	bool chained = false;
-	bool is_gcm4543 = areq_ctx->is_gcm4543;
-	u32 size_to_skip = req->assoclen;
-
-	if (is_gcm4543)
-		size_to_skip += crypto_aead_ivsize(tfm);
-
-	offset = size_to_skip;
-
-	if (!sg_data)
-		return -EINVAL;
-
-	areq_ctx->src_sgl = req->src;
-	areq_ctx->dst_sgl = req->dst;
-
-	if (is_gcm4543)
-		size_for_map += crypto_aead_ivsize(tfm);
-
-	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			authsize : 0;
-	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
-					    &src_last_bytes, &chained);
-	sg_index = areq_ctx->src_sgl->length;
-	//check where the data starts
-	while (sg_index <= size_to_skip) {
-		offset -= areq_ctx->src_sgl->length;
-		areq_ctx->src_sgl = sg_next(areq_ctx->src_sgl);
-		//if have reached the end of the sgl, then this is unexpected
-		if (!areq_ctx->src_sgl) {
-			dev_err(dev, "reached end of sg list. unexpected\n");
-			return -EINVAL;
-		}
-		sg_index += areq_ctx->src_sgl->length;
-		src_mapped_nents--;
-	}
-	if (src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
-		dev_err(dev, "Too many fragments. current %d max %d\n",
-			src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
-			return -ENOMEM;
-	}
-
-	areq_ctx->src.nents = src_mapped_nents;
-
-	areq_ctx->src_offset = offset;
-
-	if (req->src != req->dst) {
-		size_for_map = req->assoclen + req->cryptlen;
-		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				authsize : 0;
-		if (is_gcm4543)
-			size_for_map += crypto_aead_ivsize(tfm);
-
-		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
-			       &areq_ctx->dst.nents,
-			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
-			       &dst_mapped_nents);
-		if (rc) {
-			rc = -ENOMEM;
-			goto chain_data_exit;
-		}
-	}
-
-	dst_mapped_nents = cc_get_sgl_nents(dev, req->dst, size_for_map,
-					    &dst_last_bytes, &chained);
-	sg_index = areq_ctx->dst_sgl->length;
-	offset = size_to_skip;
-
-	//check where the data starts
-	while (sg_index <= size_to_skip) {
-		offset -= areq_ctx->dst_sgl->length;
-		areq_ctx->dst_sgl = sg_next(areq_ctx->dst_sgl);
-		//if have reached the end of the sgl, then this is unexpected
-		if (!areq_ctx->dst_sgl) {
-			dev_err(dev, "reached end of sg list. unexpected\n");
-			return -EINVAL;
-		}
-		sg_index += areq_ctx->dst_sgl->length;
-		dst_mapped_nents--;
-	}
-	if (dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
-		dev_err(dev, "Too many fragments. current %d max %d\n",
-			dst_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
-		return -ENOMEM;
-	}
-	areq_ctx->dst.nents = dst_mapped_nents;
-	areq_ctx->dst_offset = offset;
-	if (src_mapped_nents > 1 ||
-	    dst_mapped_nents  > 1 ||
-	    do_chain) {
-		areq_ctx->data_buff_type = CC_DMA_BUF_MLLI;
-		rc = cc_prepare_aead_data_mlli(drvdata, req, sg_data,
-					       &src_last_bytes,
-					       &dst_last_bytes, is_last_table);
-	} else {
-		areq_ctx->data_buff_type = CC_DMA_BUF_DLLI;
-		cc_prepare_aead_data_dlli(req, &src_last_bytes,
-					  &dst_last_bytes);
-	}
-
-chain_data_exit:
-	return rc;
-}
-
-static void cc_update_aead_mlli_nents(struct cc_drvdata *drvdata,
-				      struct aead_request *req)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	u32 curr_mlli_size = 0;
-
-	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI) {
-		areq_ctx->assoc.sram_addr = drvdata->mlli_sram_addr;
-		curr_mlli_size = areq_ctx->assoc.mlli_nents *
-						LLI_ENTRY_BYTE_SIZE;
-	}
-
-	if (areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
-		/*Inplace case dst nents equal to src nents*/
-		if (req->src == req->dst) {
-			areq_ctx->dst.mlli_nents = areq_ctx->src.mlli_nents;
-			areq_ctx->src.sram_addr = drvdata->mlli_sram_addr +
-								curr_mlli_size;
-			areq_ctx->dst.sram_addr = areq_ctx->src.sram_addr;
-			if (!areq_ctx->is_single_pass)
-				areq_ctx->assoc.mlli_nents +=
-					areq_ctx->src.mlli_nents;
-		} else {
-			if (areq_ctx->gen_ctx.op_type ==
-					DRV_CRYPTO_DIRECTION_DECRYPT) {
-				areq_ctx->src.sram_addr =
-						drvdata->mlli_sram_addr +
-								curr_mlli_size;
-				areq_ctx->dst.sram_addr =
-						areq_ctx->src.sram_addr +
-						areq_ctx->src.mlli_nents *
-						LLI_ENTRY_BYTE_SIZE;
-				if (!areq_ctx->is_single_pass)
-					areq_ctx->assoc.mlli_nents +=
-						areq_ctx->src.mlli_nents;
-			} else {
-				areq_ctx->dst.sram_addr =
-						drvdata->mlli_sram_addr +
-								curr_mlli_size;
-				areq_ctx->src.sram_addr =
-						areq_ctx->dst.sram_addr +
-						areq_ctx->dst.mlli_nents *
-						LLI_ENTRY_BYTE_SIZE;
-				if (!areq_ctx->is_single_pass)
-					areq_ctx->assoc.mlli_nents +=
-						areq_ctx->dst.mlli_nents;
-			}
-		}
-	}
-}
-
-int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
-{
-	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
-	struct device *dev = drvdata_to_dev(drvdata);
-	struct buffer_array sg_data;
-	unsigned int authsize = areq_ctx->req_authsize;
-	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
-	int rc = 0;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	bool is_gcm4543 = areq_ctx->is_gcm4543;
-	dma_addr_t dma_addr;
-	u32 mapped_nents = 0;
-	u32 dummy = 0; /*used for the assoc data fragments */
-	u32 size_to_map = 0;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	mlli_params->curr_pool = NULL;
-	sg_data.num_of_buffers = 0;
-
-	/* copy mac to a temporary location to deal with possible
-	 * data memory overriding that caused by cache coherence problem.
-	 */
-	if (drvdata->coherent &&
-	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
-	    req->src == req->dst)
-		cc_copy_mac(dev, req, CC_SG_TO_BUF);
-
-	/* cacluate the size for cipher remove ICV in decrypt*/
-	areq_ctx->cryptlen = (areq_ctx->gen_ctx.op_type ==
-				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				req->cryptlen :
-				(req->cryptlen - authsize);
-
-	dma_addr = dma_map_single(dev, areq_ctx->mac_buf, MAX_MAC_SIZE,
-				  DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, dma_addr)) {
-		dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
-			MAX_MAC_SIZE, areq_ctx->mac_buf);
-		rc = -ENOMEM;
-		goto aead_map_failure;
-	}
-	areq_ctx->mac_buf_dma_addr = dma_addr;
-
-	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		void *addr = areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
-
-		dma_addr = dma_map_single(dev, addr, AES_BLOCK_SIZE,
-					  DMA_TO_DEVICE);
-
-		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, addr);
-			areq_ctx->ccm_iv0_dma_addr = 0;
-			rc = -ENOMEM;
-			goto aead_map_failure;
-		}
-		areq_ctx->ccm_iv0_dma_addr = dma_addr;
-
-		if (cc_set_aead_conf_buf(dev, areq_ctx, areq_ctx->ccm_config,
-					 &sg_data, req->assoclen)) {
-			rc = -ENOMEM;
-			goto aead_map_failure;
-		}
-	}
-
-	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
-		dma_addr = dma_map_single(dev, areq_ctx->hkey, AES_BLOCK_SIZE,
-					  DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, areq_ctx->hkey);
-			rc = -ENOMEM;
-			goto aead_map_failure;
-		}
-		areq_ctx->hkey_dma_addr = dma_addr;
-
-		dma_addr = dma_map_single(dev, &areq_ctx->gcm_len_block,
-					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
-			rc = -ENOMEM;
-			goto aead_map_failure;
-		}
-		areq_ctx->gcm_block_len_dma_addr = dma_addr;
-
-		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc1,
-					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
-
-		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
-			areq_ctx->gcm_iv_inc1_dma_addr = 0;
-			rc = -ENOMEM;
-			goto aead_map_failure;
-		}
-		areq_ctx->gcm_iv_inc1_dma_addr = dma_addr;
-
-		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc2,
-					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
-
-		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
-			areq_ctx->gcm_iv_inc2_dma_addr = 0;
-			rc = -ENOMEM;
-			goto aead_map_failure;
-		}
-		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
-	}
-
-	size_to_map = req->cryptlen + req->assoclen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
-		size_to_map += authsize;
-
-	if (is_gcm4543)
-		size_to_map += crypto_aead_ivsize(tfm);
-	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
-		       &areq_ctx->src.nents,
-		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
-			LLI_MAX_NUM_OF_DATA_ENTRIES),
-		       &dummy, &mapped_nents);
-	if (rc) {
-		rc = -ENOMEM;
-		goto aead_map_failure;
-	}
-
-	if (areq_ctx->is_single_pass) {
-		/*
-		 * Create MLLI table for:
-		 *   (1) Assoc. data
-		 *   (2) Src/Dst SGLs
-		 *   Note: IV is contg. buffer (not an SGL)
-		 */
-		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, true, false);
-		if (rc)
-			goto aead_map_failure;
-		rc = cc_aead_chain_iv(drvdata, req, &sg_data, true, false);
-		if (rc)
-			goto aead_map_failure;
-		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, false);
-		if (rc)
-			goto aead_map_failure;
-	} else { /* DOUBLE-PASS flow */
-		/*
-		 * Prepare MLLI table(s) in this order:
-		 *
-		 * If ENCRYPT/DECRYPT (inplace):
-		 *   (1) MLLI table for assoc
-		 *   (2) IV entry (chained right after end of assoc)
-		 *   (3) MLLI for src/dst (inplace operation)
-		 *
-		 * If ENCRYPT (non-inplace)
-		 *   (1) MLLI table for assoc
-		 *   (2) IV entry (chained right after end of assoc)
-		 *   (3) MLLI for dst
-		 *   (4) MLLI for src
-		 *
-		 * If DECRYPT (non-inplace)
-		 *   (1) MLLI table for assoc
-		 *   (2) IV entry (chained right after end of assoc)
-		 *   (3) MLLI for src
-		 *   (4) MLLI for dst
-		 */
-		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, false, true);
-		if (rc)
-			goto aead_map_failure;
-		rc = cc_aead_chain_iv(drvdata, req, &sg_data, false, true);
-		if (rc)
-			goto aead_map_failure;
-		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, true);
-		if (rc)
-			goto aead_map_failure;
-	}
-
-	/* Mlli support -start building the MLLI according to the above
-	 * results
-	 */
-	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
-	    areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
-		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		rc = cc_generate_mlli(dev, &sg_data, mlli_params, flags);
-		if (rc)
-			goto aead_map_failure;
-
-		cc_update_aead_mlli_nents(drvdata, req);
-		dev_dbg(dev, "assoc params mn %d\n",
-			areq_ctx->assoc.mlli_nents);
-		dev_dbg(dev, "src params mn %d\n", areq_ctx->src.mlli_nents);
-		dev_dbg(dev, "dst params mn %d\n", areq_ctx->dst.mlli_nents);
-	}
-	return 0;
-
-aead_map_failure:
-	cc_unmap_aead_request(dev, req);
-	return rc;
-}
-
-int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
-			      struct scatterlist *src, unsigned int nbytes,
-			      bool do_update, gfp_t flags)
-{
-	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
-	struct device *dev = drvdata_to_dev(drvdata);
-	u8 *curr_buff = cc_hash_buf(areq_ctx);
-	u32 *curr_buff_cnt = cc_hash_buf_cnt(areq_ctx);
-	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
-	struct buffer_array sg_data;
-	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
-	u32 dummy = 0;
-	u32 mapped_nents = 0;
-
-	dev_dbg(dev, "final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X src=%pK curr_index=%u\n",
-		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
-	/* Init the type of the dma buffer */
-	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
-	mlli_params->curr_pool = NULL;
-	sg_data.num_of_buffers = 0;
-	areq_ctx->in_nents = 0;
-
-	if (nbytes == 0 && *curr_buff_cnt == 0) {
-		/* nothing to do */
-		return 0;
-	}
-
-	/*TODO: copy data in case that buffer is enough for operation */
-	/* map the previous buffer */
-	if (*curr_buff_cnt) {
-		if (cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
-				    &sg_data)) {
-			return -ENOMEM;
-		}
-	}
-
-	if (src && nbytes > 0 && do_update) {
-		if (cc_map_sg(dev, src, nbytes, DMA_TO_DEVICE,
-			      &areq_ctx->in_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
-			      &dummy, &mapped_nents)) {
-			goto unmap_curr_buff;
-		}
-		if (src && mapped_nents == 1 &&
-		    areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
-			memcpy(areq_ctx->buff_sg, src,
-			       sizeof(struct scatterlist));
-			areq_ctx->buff_sg->length = nbytes;
-			areq_ctx->curr_sg = areq_ctx->buff_sg;
-			areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
-		} else {
-			areq_ctx->data_dma_buf_type = CC_DMA_BUF_MLLI;
-		}
-	}
-
-	/*build mlli */
-	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_MLLI) {
-		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		/* add the src data to the sg_data */
-		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
-				0, true, &areq_ctx->mlli_nents);
-		if (cc_generate_mlli(dev, &sg_data, mlli_params, flags))
-			goto fail_unmap_din;
-	}
-	/* change the buffer index for the unmap function */
-	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
-	dev_dbg(dev, "areq_ctx->data_dma_buf_type = %s\n",
-		cc_dma_buf_type(areq_ctx->data_dma_buf_type));
-	return 0;
-
-fail_unmap_din:
-	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
-
-unmap_curr_buff:
-	if (*curr_buff_cnt)
-		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
-
-	return -ENOMEM;
-}
-
-int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
-			       struct scatterlist *src, unsigned int nbytes,
-			       unsigned int block_size, gfp_t flags)
-{
-	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
-	struct device *dev = drvdata_to_dev(drvdata);
-	u8 *curr_buff = cc_hash_buf(areq_ctx);
-	u32 *curr_buff_cnt = cc_hash_buf_cnt(areq_ctx);
-	u8 *next_buff = cc_next_buf(areq_ctx);
-	u32 *next_buff_cnt = cc_next_buf_cnt(areq_ctx);
-	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
-	unsigned int update_data_len;
-	u32 total_in_len = nbytes + *curr_buff_cnt;
-	struct buffer_array sg_data;
-	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
-	unsigned int swap_index = 0;
-	u32 dummy = 0;
-	u32 mapped_nents = 0;
-
-	dev_dbg(dev, " update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
-		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
-	/* Init the type of the dma buffer */
-	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
-	mlli_params->curr_pool = NULL;
-	areq_ctx->curr_sg = NULL;
-	sg_data.num_of_buffers = 0;
-	areq_ctx->in_nents = 0;
-
-	if (total_in_len < block_size) {
-		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
-			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
-		areq_ctx->in_nents =
-			cc_get_sgl_nents(dev, src, nbytes, &dummy, NULL);
-		sg_copy_to_buffer(src, areq_ctx->in_nents,
-				  &curr_buff[*curr_buff_cnt], nbytes);
-		*curr_buff_cnt += nbytes;
-		return 1;
-	}
-
-	/* Calculate the residue size*/
-	*next_buff_cnt = total_in_len & (block_size - 1);
-	/* update data len */
-	update_data_len = total_in_len - *next_buff_cnt;
-
-	dev_dbg(dev, " temp length : *next_buff_cnt=0x%X update_data_len=0x%X\n",
-		*next_buff_cnt, update_data_len);
-
-	/* Copy the new residue to next buffer */
-	if (*next_buff_cnt) {
-		dev_dbg(dev, " handle residue: next buff %pK skip data %u residue %u\n",
-			next_buff, (update_data_len - *curr_buff_cnt),
-			*next_buff_cnt);
-		cc_copy_sg_portion(dev, next_buff, src,
-				   (update_data_len - *curr_buff_cnt),
-				   nbytes, CC_SG_TO_BUF);
-		/* change the buffer index for next operation */
-		swap_index = 1;
-	}
-
-	if (*curr_buff_cnt) {
-		if (cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
-				    &sg_data)) {
-			return -ENOMEM;
-		}
-		/* change the buffer index for next operation */
-		swap_index = 1;
-	}
-
-	if (update_data_len > *curr_buff_cnt) {
-		if (cc_map_sg(dev, src, (update_data_len - *curr_buff_cnt),
-			      DMA_TO_DEVICE, &areq_ctx->in_nents,
-			      LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
-			      &mapped_nents)) {
-			goto unmap_curr_buff;
-		}
-		if (mapped_nents == 1 &&
-		    areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
-			/* only one entry in the SG and no previous data */
-			memcpy(areq_ctx->buff_sg, src,
-			       sizeof(struct scatterlist));
-			areq_ctx->buff_sg->length = update_data_len;
-			areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
-			areq_ctx->curr_sg = areq_ctx->buff_sg;
-		} else {
-			areq_ctx->data_dma_buf_type = CC_DMA_BUF_MLLI;
-		}
-	}
-
-	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_MLLI) {
-		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		/* add the src data to the sg_data */
-		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
-				(update_data_len - *curr_buff_cnt), 0, true,
-				&areq_ctx->mlli_nents);
-		if (cc_generate_mlli(dev, &sg_data, mlli_params, flags))
-			goto fail_unmap_din;
-	}
-	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
-
-	return 0;
-
-fail_unmap_din:
-	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
-
-unmap_curr_buff:
-	if (*curr_buff_cnt)
-		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
-
-	return -ENOMEM;
-}
-
-void cc_unmap_hash_request(struct device *dev, void *ctx,
-			   struct scatterlist *src, bool do_revert)
-{
-	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
-	u32 *prev_len = cc_next_buf_cnt(areq_ctx);
-
-	/*In case a pool was set, a table was
-	 *allocated and should be released
-	 */
-	if (areq_ctx->mlli_params.curr_pool) {
-		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
-			&areq_ctx->mlli_params.mlli_dma_addr,
-			areq_ctx->mlli_params.mlli_virt_addr);
-		dma_pool_free(areq_ctx->mlli_params.curr_pool,
-			      areq_ctx->mlli_params.mlli_virt_addr,
-			      areq_ctx->mlli_params.mlli_dma_addr);
-	}
-
-	if (src && areq_ctx->in_nents) {
-		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
-			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
-		dma_unmap_sg(dev, src,
-			     areq_ctx->in_nents, DMA_TO_DEVICE);
-	}
-
-	if (*prev_len) {
-		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
-			sg_virt(areq_ctx->buff_sg),
-			&sg_dma_address(areq_ctx->buff_sg),
-			sg_dma_len(areq_ctx->buff_sg));
-		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
-		if (!do_revert) {
-			/* clean the previous data length for update
-			 * operation
-			 */
-			*prev_len = 0;
-		} else {
-			areq_ctx->buff_index ^= 1;
-		}
-	}
-}
-
-int cc_buffer_mgr_init(struct cc_drvdata *drvdata)
-{
-	struct buff_mgr_handle *buff_mgr_handle;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	buff_mgr_handle = kmalloc(sizeof(*buff_mgr_handle), GFP_KERNEL);
-	if (!buff_mgr_handle)
-		return -ENOMEM;
-
-	drvdata->buff_mgr_handle = buff_mgr_handle;
-
-	buff_mgr_handle->mlli_buffs_pool =
-		dma_pool_create("dx_single_mlli_tables", dev,
-				MAX_NUM_OF_TOTAL_MLLI_ENTRIES *
-				LLI_ENTRY_BYTE_SIZE,
-				MLLI_TABLE_MIN_ALIGNMENT, 0);
-
-	if (!buff_mgr_handle->mlli_buffs_pool)
-		goto error;
-
-	return 0;
-
-error:
-	cc_buffer_mgr_fini(drvdata);
-	return -ENOMEM;
-}
-
-int cc_buffer_mgr_fini(struct cc_drvdata *drvdata)
-{
-	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
-
-	if (buff_mgr_handle) {
-		dma_pool_destroy(buff_mgr_handle->mlli_buffs_pool);
-		kfree(drvdata->buff_mgr_handle);
-		drvdata->buff_mgr_handle = NULL;
-	}
-	return 0;
-}
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
deleted file mode 100644
index 0ddadd7..0000000
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file buffer_mgr.h
- * Buffer Manager
- */
-
-#ifndef __CC_BUFFER_MGR_H__
-#define __CC_BUFFER_MGR_H__
-
-#include <crypto/algapi.h>
-
-#include "ssi_driver.h"
-
-enum cc_req_dma_buf_type {
-	CC_DMA_BUF_NULL = 0,
-	CC_DMA_BUF_DLLI,
-	CC_DMA_BUF_MLLI
-};
-
-enum cc_sg_cpy_direct {
-	CC_SG_TO_BUF = 0,
-	CC_SG_FROM_BUF = 1
-};
-
-struct cc_mlli {
-	cc_sram_addr_t sram_addr;
-	unsigned int nents; //sg nents
-	unsigned int mlli_nents; //mlli nents might be different than the above
-};
-
-struct mlli_params {
-	struct dma_pool *curr_pool;
-	u8 *mlli_virt_addr;
-	dma_addr_t mlli_dma_addr;
-	u32 mlli_len;
-};
-
-int cc_buffer_mgr_init(struct cc_drvdata *drvdata);
-
-int cc_buffer_mgr_fini(struct cc_drvdata *drvdata);
-
-int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
-			     unsigned int ivsize, unsigned int nbytes,
-			     void *info, struct scatterlist *src,
-			     struct scatterlist *dst, gfp_t flags);
-
-void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
-				unsigned int ivsize,
-				struct scatterlist *src,
-				struct scatterlist *dst);
-
-int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req);
-
-void cc_unmap_aead_request(struct device *dev, struct aead_request *req);
-
-int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
-			      struct scatterlist *src, unsigned int nbytes,
-			      bool do_update, gfp_t flags);
-
-int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
-			       struct scatterlist *src, unsigned int nbytes,
-			       unsigned int block_size, gfp_t flags);
-
-void cc_unmap_hash_request(struct device *dev, void *ctx,
-			   struct scatterlist *src, bool do_revert);
-
-void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
-			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct);
-
-void cc_zero_sgl(struct scatterlist *sgl, u32 data_len);
-
-#endif /*__BUFFER_MGR_H__*/
-
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
deleted file mode 100644
index a0e7d00..0000000
--- a/drivers/staging/ccree/ssi_cipher.c
+++ /dev/null
@@ -1,1171 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/semaphore.h>
-#include <crypto/algapi.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/aes.h>
-#include <crypto/ctr.h>
-#include <crypto/des.h>
-#include <crypto/xts.h>
-#include <crypto/scatterwalk.h>
-
-#include "ssi_driver.h"
-#include "cc_lli_defs.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_cipher.h"
-#include "ssi_request_mgr.h"
-
-#define MAX_ABLKCIPHER_SEQ_LEN 6
-
-#define template_ablkcipher	template_u.ablkcipher
-
-#define CC_MIN_AES_XTS_SIZE 0x10
-#define CC_MAX_AES_XTS_SIZE 0x2000
-struct cc_cipher_handle {
-	struct list_head blkcipher_alg_list;
-};
-
-struct cc_user_key_info {
-	u8 *key;
-	dma_addr_t key_dma_addr;
-};
-
-struct cc_hw_key_info {
-	enum cc_hw_crypto_key key1_slot;
-	enum cc_hw_crypto_key key2_slot;
-};
-
-struct cc_cipher_ctx {
-	struct cc_drvdata *drvdata;
-	int keylen;
-	int key_round_number;
-	int cipher_mode;
-	int flow_mode;
-	unsigned int flags;
-	struct blkcipher_req_ctx *sync_ctx;
-	struct cc_user_key_info user;
-	struct cc_hw_key_info hw;
-	struct crypto_shash *shash_tfm;
-};
-
-static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
-
-static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
-{
-	switch (ctx_p->flow_mode) {
-	case S_DIN_to_AES:
-		switch (size) {
-		case CC_AES_128_BIT_KEY_SIZE:
-		case CC_AES_192_BIT_KEY_SIZE:
-			if (ctx_p->cipher_mode != DRV_CIPHER_XTS &&
-			    ctx_p->cipher_mode != DRV_CIPHER_ESSIV &&
-			    ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)
-				return 0;
-			break;
-		case CC_AES_256_BIT_KEY_SIZE:
-			return 0;
-		case (CC_AES_192_BIT_KEY_SIZE * 2):
-		case (CC_AES_256_BIT_KEY_SIZE * 2):
-			if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-			    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-			    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)
-				return 0;
-			break;
-		default:
-			break;
-		}
-	case S_DIN_to_DES:
-		if (size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE)
-			return 0;
-		break;
-	default:
-		break;
-	}
-	return -EINVAL;
-}
-
-static int validate_data_size(struct cc_cipher_ctx *ctx_p,
-			      unsigned int size)
-{
-	switch (ctx_p->flow_mode) {
-	case S_DIN_to_AES:
-		switch (ctx_p->cipher_mode) {
-		case DRV_CIPHER_XTS:
-			if (size >= CC_MIN_AES_XTS_SIZE &&
-			    size <= CC_MAX_AES_XTS_SIZE &&
-			    IS_ALIGNED(size, AES_BLOCK_SIZE))
-				return 0;
-			break;
-		case DRV_CIPHER_CBC_CTS:
-			if (size >= AES_BLOCK_SIZE)
-				return 0;
-			break;
-		case DRV_CIPHER_OFB:
-		case DRV_CIPHER_CTR:
-				return 0;
-		case DRV_CIPHER_ECB:
-		case DRV_CIPHER_CBC:
-		case DRV_CIPHER_ESSIV:
-		case DRV_CIPHER_BITLOCKER:
-			if (IS_ALIGNED(size, AES_BLOCK_SIZE))
-				return 0;
-			break;
-		default:
-			break;
-		}
-		break;
-	case S_DIN_to_DES:
-		if (IS_ALIGNED(size, DES_BLOCK_SIZE))
-			return 0;
-		break;
-	default:
-		break;
-	}
-	return -EINVAL;
-}
-
-static unsigned int get_max_keysize(struct crypto_tfm *tfm)
-{
-	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     crypto_alg);
-
-	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_ABLKCIPHER)
-		return cc_alg->crypto_alg.cra_ablkcipher.max_keysize;
-
-	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return cc_alg->crypto_alg.cra_blkcipher.max_keysize;
-
-	return 0;
-}
-
-static int cc_cipher_init(struct crypto_tfm *tfm)
-{
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct cc_crypto_alg *cc_alg =
-			container_of(alg, struct cc_crypto_alg, crypto_alg);
-	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
-	int rc = 0;
-	unsigned int max_key_buf_size = get_max_keysize(tfm);
-	struct ablkcipher_tfm *ablktfm = &tfm->crt_ablkcipher;
-
-	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
-		crypto_tfm_alg_name(tfm));
-
-	ablktfm->reqsize = sizeof(struct blkcipher_req_ctx);
-
-	ctx_p->cipher_mode = cc_alg->cipher_mode;
-	ctx_p->flow_mode = cc_alg->flow_mode;
-	ctx_p->drvdata = cc_alg->drvdata;
-
-	/* Allocate key buffer, cache line aligned */
-	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
-	if (!ctx_p->user.key)
-		return -ENOMEM;
-
-	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
-		ctx_p->user.key);
-
-	/* Map key buffer */
-	ctx_p->user.key_dma_addr = dma_map_single(dev, (void *)ctx_p->user.key,
-						  max_key_buf_size,
-						  DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
-		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
-			max_key_buf_size, ctx_p->user.key);
-		return -ENOMEM;
-	}
-	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
-		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
-
-	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-		/* Alloc hash tfm for essiv */
-		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
-		if (IS_ERR(ctx_p->shash_tfm)) {
-			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
-			return PTR_ERR(ctx_p->shash_tfm);
-		}
-	}
-
-	return rc;
-}
-
-static void cc_cipher_exit(struct crypto_tfm *tfm)
-{
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	unsigned int max_key_buf_size = get_max_keysize(tfm);
-
-	dev_dbg(dev, "Clearing context @%p for %s\n",
-		crypto_tfm_ctx(tfm), crypto_tfm_alg_name(tfm));
-
-	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-		/* Free hash tfm for essiv */
-		crypto_free_shash(ctx_p->shash_tfm);
-		ctx_p->shash_tfm = NULL;
-	}
-
-	/* Unmap key buffer */
-	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
-			 DMA_TO_DEVICE);
-	dev_dbg(dev, "Unmapped key buffer key_dma_addr=%pad\n",
-		&ctx_p->user.key_dma_addr);
-
-	/* Free key buffer in context */
-	kfree(ctx_p->user.key);
-	dev_dbg(dev, "Free key buffer in context. key=@%p\n", ctx_p->user.key);
-}
-
-struct tdes_keys {
-	u8	key1[DES_KEY_SIZE];
-	u8	key2[DES_KEY_SIZE];
-	u8	key3[DES_KEY_SIZE];
-};
-
-static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
-
-/* The function verifies that tdes keys are not weak.*/
-static int cc_verify_3des_keys(const u8 *key, unsigned int keylen)
-{
-	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
-
-	/* verify key1 != key2 and key3 != key2*/
-	if ((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
-		    sizeof(tdes_key->key1)) == 0) ||
-	    (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
-		    sizeof(tdes_key->key3)) == 0)) {
-		return -ENOEXEC;
-	}
-
-	return 0;
-}
-
-static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
-{
-	switch (slot_num) {
-	case 0:
-		return KFDE0_KEY;
-	case 1:
-		return KFDE1_KEY;
-	case 2:
-		return KFDE2_KEY;
-	case 3:
-		return KFDE3_KEY;
-	}
-	return END_OF_KEYS;
-}
-
-static int cc_cipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(atfm);
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	u32 tmp[DES_EXPKEY_WORDS];
-	unsigned int max_key_buf_size = get_max_keysize(tfm);
-
-	dev_dbg(dev, "Setting key in context @%p for %s. keylen=%u\n",
-		ctx_p, crypto_tfm_alg_name(tfm), keylen);
-	dump_byte_array("key", (u8 *)key, keylen);
-
-	/* STAT_PHASE_0: Init and sanity checks */
-
-	if (validate_keys_sizes(ctx_p, keylen)) {
-		dev_err(dev, "Unsupported key size %d.\n", keylen);
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	if (cc_is_hw_key(tfm)) {
-		/* setting HW key slots */
-		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
-
-		if (ctx_p->flow_mode != S_DIN_to_AES) {
-			dev_err(dev, "HW key not supported for non-AES flows\n");
-			return -EINVAL;
-		}
-
-		ctx_p->hw.key1_slot = hw_key_to_cc_hw_key(hki->hw_key1);
-		if (ctx_p->hw.key1_slot == END_OF_KEYS) {
-			dev_err(dev, "Unsupported hw key1 number (%d)\n",
-				hki->hw_key1);
-			return -EINVAL;
-		}
-
-		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
-			if (hki->hw_key1 == hki->hw_key2) {
-				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
-					hki->hw_key1, hki->hw_key2);
-				return -EINVAL;
-			}
-			ctx_p->hw.key2_slot =
-				hw_key_to_cc_hw_key(hki->hw_key2);
-			if (ctx_p->hw.key2_slot == END_OF_KEYS) {
-				dev_err(dev, "Unsupported hw key2 number (%d)\n",
-					hki->hw_key2);
-				return -EINVAL;
-			}
-		}
-
-		ctx_p->keylen = keylen;
-		dev_dbg(dev, "cc_is_hw_key ret 0");
-
-		return 0;
-	}
-
-	// verify weak keys
-	if (ctx_p->flow_mode == S_DIN_to_DES) {
-		if (!des_ekey(tmp, key) &&
-		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			dev_dbg(dev, "weak DES key");
-			return -EINVAL;
-		}
-	}
-	if (ctx_p->cipher_mode == DRV_CIPHER_XTS &&
-	    xts_check_key(tfm, key, keylen)) {
-		dev_dbg(dev, "weak XTS key");
-		return -EINVAL;
-	}
-	if (ctx_p->flow_mode == S_DIN_to_DES &&
-	    keylen == DES3_EDE_KEY_SIZE &&
-	    cc_verify_3des_keys(key, keylen)) {
-		dev_dbg(dev, "weak 3DES key");
-		return -EINVAL;
-	}
-
-	/* STAT_PHASE_1: Copy key to ctx */
-	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
-				max_key_buf_size, DMA_TO_DEVICE);
-
-	memcpy(ctx_p->user.key, key, keylen);
-	if (keylen == 24)
-		memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
-
-	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-		/* sha256 for key2 - use sw implementation */
-		int key_len = keylen >> 1;
-		int err;
-
-		SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
-
-		desc->tfm = ctx_p->shash_tfm;
-
-		err = crypto_shash_digest(desc, ctx_p->user.key, key_len,
-					  ctx_p->user.key + key_len);
-		if (err) {
-			dev_err(dev, "Failed to hash ESSIV key.\n");
-			return err;
-		}
-	}
-	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
-				   max_key_buf_size, DMA_TO_DEVICE);
-	ctx_p->keylen = keylen;
-
-	 dev_dbg(dev, "return safely");
-	return 0;
-}
-
-static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
-				 struct blkcipher_req_ctx *req_ctx,
-				 unsigned int ivsize, unsigned int nbytes,
-				 struct cc_hw_desc desc[],
-				 unsigned int *seq_size)
-{
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	int cipher_mode = ctx_p->cipher_mode;
-	int flow_mode = ctx_p->flow_mode;
-	int direction = req_ctx->gen_ctx.op_type;
-	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
-	unsigned int key_len = ctx_p->keylen;
-	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
-	unsigned int du_size = nbytes;
-
-	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     crypto_alg);
-
-	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
-	    CRYPTO_ALG_BULK_DU_512)
-		du_size = 512;
-	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
-	    CRYPTO_ALG_BULK_DU_4096)
-		du_size = 4096;
-
-	switch (cipher_mode) {
-	case DRV_CIPHER_CBC:
-	case DRV_CIPHER_CBC_CTS:
-	case DRV_CIPHER_CTR:
-	case DRV_CIPHER_OFB:
-		/* Load cipher state */
-		hw_desc_init(&desc[*seq_size]);
-		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr, ivsize,
-			     NS_BIT);
-		set_cipher_config0(&desc[*seq_size], direction);
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		if (cipher_mode == DRV_CIPHER_CTR ||
-		    cipher_mode == DRV_CIPHER_OFB) {
-			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
-		} else {
-			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
-		}
-		(*seq_size)++;
-		/*FALLTHROUGH*/
-	case DRV_CIPHER_ECB:
-		/* Load key */
-		hw_desc_init(&desc[*seq_size]);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		if (flow_mode == S_DIN_to_AES) {
-			if (cc_is_hw_key(tfm)) {
-				set_hw_crypto_key(&desc[*seq_size],
-						  ctx_p->hw.key1_slot);
-			} else {
-				set_din_type(&desc[*seq_size], DMA_DLLI,
-					     key_dma_addr, ((key_len == 24) ?
-							    AES_MAX_KEY_SIZE :
-							    key_len), NS_BIT);
-			}
-			set_key_size_aes(&desc[*seq_size], key_len);
-		} else {
-			/*des*/
-			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
-				     key_len, NS_BIT);
-			set_key_size_des(&desc[*seq_size], key_len);
-		}
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
-		(*seq_size)++;
-		break;
-	case DRV_CIPHER_XTS:
-	case DRV_CIPHER_ESSIV:
-	case DRV_CIPHER_BITLOCKER:
-		/* Load AES key */
-		hw_desc_init(&desc[*seq_size]);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		if (cc_is_hw_key(tfm)) {
-			set_hw_crypto_key(&desc[*seq_size],
-					  ctx_p->hw.key1_slot);
-		} else {
-			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
-				     (key_len / 2), NS_BIT);
-		}
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
-		(*seq_size)++;
-
-		/* load XEX key */
-		hw_desc_init(&desc[*seq_size]);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		if (cc_is_hw_key(tfm)) {
-			set_hw_crypto_key(&desc[*seq_size],
-					  ctx_p->hw.key2_slot);
-		} else {
-			set_din_type(&desc[*seq_size], DMA_DLLI,
-				     (key_dma_addr + (key_len / 2)),
-				     (key_len / 2), NS_BIT);
-		}
-		set_xex_data_unit_size(&desc[*seq_size], du_size);
-		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
-		(*seq_size)++;
-
-		/* Set state */
-		hw_desc_init(&desc[*seq_size]);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
-			     CC_AES_BLOCK_SIZE, NS_BIT);
-		(*seq_size)++;
-		break;
-	default:
-		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
-	}
-}
-
-static void cc_setup_cipher_data(struct crypto_tfm *tfm,
-				 struct blkcipher_req_ctx *req_ctx,
-				 struct scatterlist *dst,
-				 struct scatterlist *src, unsigned int nbytes,
-				 void *areq, struct cc_hw_desc desc[],
-				 unsigned int *seq_size)
-{
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	unsigned int flow_mode = ctx_p->flow_mode;
-
-	switch (ctx_p->flow_mode) {
-	case S_DIN_to_AES:
-		flow_mode = DIN_AES_DOUT;
-		break;
-	case S_DIN_to_DES:
-		flow_mode = DIN_DES_DOUT;
-		break;
-	default:
-		dev_err(dev, "invalid flow mode, flow_mode = %d\n", flow_mode);
-		return;
-	}
-	/* Process */
-	if (req_ctx->dma_buf_type == CC_DMA_BUF_DLLI) {
-		dev_dbg(dev, " data params addr %pad length 0x%X\n",
-			&sg_dma_address(src), nbytes);
-		dev_dbg(dev, " data params addr %pad length 0x%X\n",
-			&sg_dma_address(dst), nbytes);
-		hw_desc_init(&desc[*seq_size]);
-		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
-			     nbytes, NS_BIT);
-		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
-			      nbytes, NS_BIT, (!areq ? 0 : 1));
-		if (areq)
-			set_queue_last_ind(&desc[*seq_size]);
-
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		(*seq_size)++;
-	} else {
-		/* bypass */
-		dev_dbg(dev, " bypass params addr %pad length 0x%X addr 0x%08X\n",
-			&req_ctx->mlli_params.mlli_dma_addr,
-			req_ctx->mlli_params.mlli_len,
-			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
-		hw_desc_init(&desc[*seq_size]);
-		set_din_type(&desc[*seq_size], DMA_DLLI,
-			     req_ctx->mlli_params.mlli_dma_addr,
-			     req_ctx->mlli_params.mlli_len, NS_BIT);
-		set_dout_sram(&desc[*seq_size],
-			      ctx_p->drvdata->mlli_sram_addr,
-			      req_ctx->mlli_params.mlli_len);
-		set_flow_mode(&desc[*seq_size], BYPASS);
-		(*seq_size)++;
-
-		hw_desc_init(&desc[*seq_size]);
-		set_din_type(&desc[*seq_size], DMA_MLLI,
-			     ctx_p->drvdata->mlli_sram_addr,
-			     req_ctx->in_mlli_nents, NS_BIT);
-		if (req_ctx->out_nents == 0) {
-			dev_dbg(dev, " din/dout params addr 0x%08X addr 0x%08X\n",
-				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
-				(unsigned int)ctx_p->drvdata->mlli_sram_addr);
-			set_dout_mlli(&desc[*seq_size],
-				      ctx_p->drvdata->mlli_sram_addr,
-				      req_ctx->in_mlli_nents, NS_BIT,
-				      (!areq ? 0 : 1));
-		} else {
-			dev_dbg(dev, " din/dout params addr 0x%08X addr 0x%08X\n",
-				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
-				(unsigned int)ctx_p->drvdata->mlli_sram_addr +
-				(u32)LLI_ENTRY_BYTE_SIZE * req_ctx->in_nents);
-			set_dout_mlli(&desc[*seq_size],
-				      (ctx_p->drvdata->mlli_sram_addr +
-				       (LLI_ENTRY_BYTE_SIZE *
-					req_ctx->in_mlli_nents)),
-				      req_ctx->out_mlli_nents, NS_BIT,
-				      (!areq ? 0 : 1));
-		}
-		if (areq)
-			set_queue_last_ind(&desc[*seq_size]);
-
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		(*seq_size)++;
-	}
-}
-
-static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
-{
-	struct ablkcipher_request *areq = (struct ablkcipher_request *)cc_req;
-	struct scatterlist *dst = areq->dst;
-	struct scatterlist *src = areq->src;
-	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
-	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
-
-	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
-	kfree(req_ctx->iv);
-
-	/*
-	 * The crypto API expects us to set the req->info to the last
-	 * ciphertext block. For encrypt, simply copy from the result.
-	 * For decrypt, we must copy from a saved buffer since this
-	 * could be an in-place decryption operation and the src is
-	 * lost by this point.
-	 */
-	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
-		memcpy(req->info, req_ctx->backup_info, ivsize);
-		kfree(req_ctx->backup_info);
-	} else if (!err) {
-		scatterwalk_map_and_copy(req->info, req->dst,
-					 (req->nbytes - ivsize),
-					 ivsize, 0);
-	}
-
-	ablkcipher_request_complete(areq, err);
-}
-
-static int cc_cipher_process(struct ablkcipher_request *req,
-			     enum drv_crypto_direction direction)
-{
-	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk_tfm);
-	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
-	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
-	struct scatterlist *dst = req->dst;
-	struct scatterlist *src = req->src;
-	unsigned int nbytes = req->nbytes;
-	void *info = req->info;
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
-	struct cc_crypto_req cc_req = {};
-	int rc, seq_len = 0, cts_restore_flag = 0;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "%s req=%p info=%p nbytes=%d\n",
-		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-		"Encrypt" : "Decrypt"), req, info, nbytes);
-
-	/* STAT_PHASE_0: Init and sanity checks */
-
-	/* TODO: check data length according to mode */
-	if (validate_data_size(ctx_p, nbytes)) {
-		dev_err(dev, "Unsupported data size %d.\n", nbytes);
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
-		rc = -EINVAL;
-		goto exit_process;
-	}
-	if (nbytes == 0) {
-		/* No data to process is valid */
-		rc = 0;
-		goto exit_process;
-	}
-
-	/* The IV we are handed may be allocted from the stack so
-	 * we must copy it to a DMAable buffer before use.
-	 */
-	req_ctx->iv = kmalloc(ivsize, flags);
-	if (!req_ctx->iv) {
-		rc = -ENOMEM;
-		goto exit_process;
-	}
-	memcpy(req_ctx->iv, info, ivsize);
-
-	/*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) &&
-	    ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
-		ctx_p->cipher_mode = DRV_CIPHER_CBC;
-		cts_restore_flag = 1;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = (void *)cc_cipher_complete;
-	cc_req.user_arg = (void *)req;
-
-#ifdef ENABLE_CYCLE_COUNT
-	cc_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
-		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
-
-#endif
-
-	/* Setup request context */
-	req_ctx->gen_ctx.op_type = direction;
-
-	/* STAT_PHASE_1: Map buffers */
-
-	rc = cc_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes,
-				      req_ctx->iv, src, dst, flags);
-	if (rc) {
-		dev_err(dev, "map_request() failed\n");
-		goto exit_process;
-	}
-
-	/* STAT_PHASE_2: Create sequence */
-
-	/* Setup processing */
-	cc_setup_cipher_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
-	/* Data processing */
-	cc_setup_cipher_data(tfm, req_ctx, dst, src, nbytes, req, desc,
-			     &seq_len);
-
-	/* do we need to generate IV? */
-	if (req_ctx->is_giv) {
-		cc_req.ivgen_dma_addr[0] = req_ctx->gen_ctx.iv_dma_addr;
-		cc_req.ivgen_dma_addr_len = 1;
-		/* set the IV size (8/16 B long)*/
-		cc_req.ivgen_size = ivsize;
-	}
-
-	/* STAT_PHASE_3: Lock HW and push sequence */
-
-	rc = cc_send_request(ctx_p->drvdata, &cc_req, desc, seq_len,
-			     &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		/* Failed to send the request or request completed
-		 * synchronously
-		 */
-		cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
-	}
-
-exit_process:
-	if (cts_restore_flag)
-		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
-
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		kfree(req_ctx->backup_info);
-		kfree(req_ctx->iv);
-	}
-
-	return rc;
-}
-
-static int cc_cipher_encrypt(struct ablkcipher_request *req)
-{
-	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
-
-	req_ctx->is_giv = false;
-	req_ctx->backup_info = NULL;
-
-	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-}
-
-static int cc_cipher_decrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
-	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
-	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	/*
-	 * Allocate and save the last IV sized bytes of the source, which will
-	 * be lost in case of in-place decryption and might be needed for CTS.
-	 */
-	req_ctx->backup_info = kmalloc(ivsize, flags);
-	if (!req_ctx->backup_info)
-		return -ENOMEM;
-
-	scatterwalk_map_and_copy(req_ctx->backup_info, req->src,
-				 (req->nbytes - ivsize), ivsize, 0);
-	req_ctx->is_giv = false;
-
-	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-}
-
-/* DX Block cipher alg */
-static struct cc_alg_template blkcipher_algs[] = {
-	{
-		.name = "xts(aes)",
-		.driver_name = "xts-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			.geniv = "eseqiv",
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "xts(aes)",
-		.driver_name = "xts-aes-du512-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "xts(aes)",
-		.driver_name = "xts-aes-du4096-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "essiv(aes)",
-		.driver_name = "essiv-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "essiv(aes)",
-		.driver_name = "essiv-aes-du512-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "essiv(aes)",
-		.driver_name = "essiv-aes-du4096-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "bitlocker(aes)",
-		.driver_name = "bitlocker-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_BITLOCKER,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "bitlocker(aes)",
-		.driver_name = "bitlocker-aes-du512-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_512,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_BITLOCKER,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "bitlocker(aes)",
-		.driver_name = "bitlocker-aes-du4096-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_BULK_DU_4096,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_BITLOCKER,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "ecb(aes)",
-		.driver_name = "ecb-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = 0,
-			},
-		.cipher_mode = DRV_CIPHER_ECB,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "cbc(aes)",
-		.driver_name = "cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "ofb(aes)",
-		.driver_name = "ofb-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_OFB,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "cts1(cbc(aes))",
-		.driver_name = "cts1-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_CBC_CTS,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "ctr(aes)",
-		.driver_name = "ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-	},
-	{
-		.name = "cbc(des3_ede)",
-		.driver_name = "cbc-3des-dx",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_DES,
-	},
-	{
-		.name = "ecb(des3_ede)",
-		.driver_name = "ecb-3des-dx",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = 0,
-			},
-		.cipher_mode = DRV_CIPHER_ECB,
-		.flow_mode = S_DIN_to_DES,
-	},
-	{
-		.name = "cbc(des)",
-		.driver_name = "cbc-des-dx",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.ivsize = DES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_DES,
-	},
-	{
-		.name = "ecb(des)",
-		.driver_name = "ecb-des-dx",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.ivsize = 0,
-			},
-		.cipher_mode = DRV_CIPHER_ECB,
-		.flow_mode = S_DIN_to_DES,
-	},
-};
-
-static
-struct cc_crypto_alg *cc_cipher_create_alg(struct cc_alg_template *template,
-					   struct device *dev)
-{
-	struct cc_crypto_alg *t_alg;
-	struct crypto_alg *alg;
-
-	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
-	if (!t_alg)
-		return ERR_PTR(-ENOMEM);
-
-	alg = &t_alg->crypto_alg;
-
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 template->driver_name);
-	alg->cra_module = THIS_MODULE;
-	alg->cra_priority = CC_CRA_PRIO;
-	alg->cra_blocksize = template->blocksize;
-	alg->cra_alignmask = 0;
-	alg->cra_ctxsize = sizeof(struct cc_cipher_ctx);
-
-	alg->cra_init = cc_cipher_init;
-	alg->cra_exit = cc_cipher_exit;
-	alg->cra_type = &crypto_ablkcipher_type;
-	alg->cra_ablkcipher = template->template_ablkcipher;
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-				template->type;
-
-	t_alg->cipher_mode = template->cipher_mode;
-	t_alg->flow_mode = template->flow_mode;
-
-	return t_alg;
-}
-
-int cc_cipher_free(struct cc_drvdata *drvdata)
-{
-	struct cc_crypto_alg *t_alg, *n;
-	struct cc_cipher_handle *blkcipher_handle =
-						drvdata->blkcipher_handle;
-	if (blkcipher_handle) {
-		/* Remove registered algs */
-		list_for_each_entry_safe(t_alg, n,
-					 &blkcipher_handle->blkcipher_alg_list,
-					 entry) {
-			crypto_unregister_alg(&t_alg->crypto_alg);
-			list_del(&t_alg->entry);
-			kfree(t_alg);
-		}
-		kfree(blkcipher_handle);
-		drvdata->blkcipher_handle = NULL;
-	}
-	return 0;
-}
-
-int cc_cipher_alloc(struct cc_drvdata *drvdata)
-{
-	struct cc_cipher_handle *ablkcipher_handle;
-	struct cc_crypto_alg *t_alg;
-	struct device *dev = drvdata_to_dev(drvdata);
-	int rc = -ENOMEM;
-	int alg;
-
-	ablkcipher_handle = kmalloc(sizeof(*ablkcipher_handle), GFP_KERNEL);
-	if (!ablkcipher_handle)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&ablkcipher_handle->blkcipher_alg_list);
-	drvdata->blkcipher_handle = ablkcipher_handle;
-
-	/* Linux crypto */
-	dev_dbg(dev, "Number of algorithms = %zu\n",
-		ARRAY_SIZE(blkcipher_algs));
-	for (alg = 0; alg < ARRAY_SIZE(blkcipher_algs); alg++) {
-		dev_dbg(dev, "creating %s\n", blkcipher_algs[alg].driver_name);
-		t_alg = cc_cipher_create_alg(&blkcipher_algs[alg], dev);
-		if (IS_ERR(t_alg)) {
-			rc = PTR_ERR(t_alg);
-			dev_err(dev, "%s alg allocation failed\n",
-				blkcipher_algs[alg].driver_name);
-			goto fail0;
-		}
-		t_alg->drvdata = drvdata;
-
-		dev_dbg(dev, "registering %s\n",
-			blkcipher_algs[alg].driver_name);
-		rc = crypto_register_alg(&t_alg->crypto_alg);
-		dev_dbg(dev, "%s alg registration rc = %x\n",
-			t_alg->crypto_alg.cra_driver_name, rc);
-		if (rc) {
-			dev_err(dev, "%s alg registration failed\n",
-				t_alg->crypto_alg.cra_driver_name);
-			kfree(t_alg);
-			goto fail0;
-		} else {
-			list_add_tail(&t_alg->entry,
-				      &ablkcipher_handle->blkcipher_alg_list);
-			dev_dbg(dev, "Registered %s\n",
-				t_alg->crypto_alg.cra_driver_name);
-		}
-	}
-	return 0;
-
-fail0:
-	cc_cipher_free(drvdata);
-	return rc;
-}
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
deleted file mode 100644
index 97b266b..0000000
--- a/drivers/staging/ccree/ssi_cipher.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file ssi_cipher.h
- * ARM CryptoCell Cipher Crypto API
- */
-
-#ifndef __CC_CIPHER_H__
-#define __CC_CIPHER_H__
-
-#include <linux/kernel.h>
-#include <crypto/algapi.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-
-/* Crypto cipher flags */
-#define CC_CRYPTO_CIPHER_KEY_KFDE0	BIT(0)
-#define CC_CRYPTO_CIPHER_KEY_KFDE1	BIT(1)
-#define CC_CRYPTO_CIPHER_KEY_KFDE2	BIT(2)
-#define CC_CRYPTO_CIPHER_KEY_KFDE3	BIT(3)
-#define CC_CRYPTO_CIPHER_DU_SIZE_512B	BIT(4)
-
-#define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | \
-					CC_CRYPTO_CIPHER_KEY_KFDE1 | \
-					CC_CRYPTO_CIPHER_KEY_KFDE2 | \
-					CC_CRYPTO_CIPHER_KEY_KFDE3)
-
-struct blkcipher_req_ctx {
-	struct async_gen_req_ctx gen_ctx;
-	enum cc_req_dma_buf_type dma_buf_type;
-	u32 in_nents;
-	u32 in_mlli_nents;
-	u32 out_nents;
-	u32 out_mlli_nents;
-	u8 *backup_info; /*store iv for generated IV flow*/
-	u8 *iv;
-	bool is_giv;
-	struct mlli_params mlli_params;
-};
-
-int cc_cipher_alloc(struct cc_drvdata *drvdata);
-
-int cc_cipher_free(struct cc_drvdata *drvdata);
-
-#ifndef CRYPTO_ALG_BULK_MASK
-
-#define CRYPTO_ALG_BULK_DU_512	0x00002000
-#define CRYPTO_ALG_BULK_DU_4096	0x00004000
-#define CRYPTO_ALG_BULK_MASK	(CRYPTO_ALG_BULK_DU_512 |\
-				CRYPTO_ALG_BULK_DU_4096)
-#endif /* CRYPTO_ALG_BULK_MASK */
-
-#ifdef CRYPTO_TFM_REQ_HW_KEY
-
-static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
-{
-	return (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_HW_KEY);
-}
-
-#else
-
-struct arm_hw_key_info {
-	int hw_key1;
-	int hw_key2;
-};
-
-static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
-{
-	return false;
-}
-
-#endif /* CRYPTO_TFM_REQ_HW_KEY */
-
-#endif /*__CC_CIPHER_H__*/
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
deleted file mode 100644
index b5df9b4..0000000
--- a/drivers/staging/ccree/ssi_driver.c
+++ /dev/null
@@ -1,508 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
-#include <crypto/aes.h>
-#include <crypto/sha.h>
-#include <crypto/aead.h>
-#include <crypto/authenc.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/skcipher.h>
-
-#include <linux/init.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/random.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/fcntl.h>
-#include <linux/poll.h>
-#include <linux/proc_fs.h>
-#include <linux/mutex.h>
-#include <linux/sysctl.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/platform_device.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/dma-mapping.h>
-#include <linux/dmapool.h>
-#include <linux/list.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/pm.h>
-
-/* cache.h required for L1_CACHE_ALIGN() and cache_line_size() */
-#include <linux/cache.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-#include <linux/pagemap.h>
-#include <linux/sched.h>
-#include <linux/of.h>
-#include <linux/clk.h>
-#include <linux/of_address.h>
-
-#include "ssi_driver.h"
-#include "ssi_request_mgr.h"
-#include "ssi_buffer_mgr.h"
-#include "cc_debugfs.h"
-#include "ssi_cipher.h"
-#include "ssi_aead.h"
-#include "ssi_hash.h"
-#include "ssi_ivgen.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_pm.h"
-#include "ssi_fips.h"
-
-bool cc_dump_desc;
-module_param_named(dump_desc, cc_dump_desc, bool, 0600);
-MODULE_PARM_DESC(cc_dump_desc, "Dump descriptors to kernel log as debugging aid");
-
-bool cc_dump_bytes;
-module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
-MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
-
-void __dump_byte_array(const char *name, const u8 *buf, size_t len)
-{
-	char prefix[64];
-
-	if (!buf)
-		return;
-
-	snprintf(prefix, sizeof(prefix), "%s[%zu]: ", name, len);
-
-	print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_ADDRESS, 16, 1, buf,
-		       len, false);
-}
-
-static irqreturn_t cc_isr(int irq, void *dev_id)
-{
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)dev_id;
-	struct device *dev = drvdata_to_dev(drvdata);
-	u32 irr;
-	u32 imr;
-
-	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
-
-	/* read the interrupt status */
-	irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
-	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
-	if (irr == 0) { /* Probably shared interrupt line */
-		dev_err(dev, "Got interrupt with empty IRR\n");
-		return IRQ_NONE;
-	}
-	imr = cc_ioread(drvdata, CC_REG(HOST_IMR));
-
-	/* clear interrupt - must be before processing events */
-	cc_iowrite(drvdata, CC_REG(HOST_ICR), irr);
-
-	drvdata->irq = irr;
-	/* Completion interrupt - most probable */
-	if (irr & CC_COMP_IRQ_MASK) {
-		/* Mask AXI completion interrupt - will be unmasked in
-		 * Deferred service handler
-		 */
-		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_COMP_IRQ_MASK);
-		irr &= ~CC_COMP_IRQ_MASK;
-		complete_request(drvdata);
-	}
-#ifdef CONFIG_CRYPTO_FIPS
-	/* TEE FIPS interrupt */
-	if (irr & CC_GPR0_IRQ_MASK) {
-		/* Mask interrupt - will be unmasked in Deferred service
-		 * handler
-		 */
-		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_GPR0_IRQ_MASK);
-		irr &= ~CC_GPR0_IRQ_MASK;
-		fips_handler(drvdata);
-	}
-#endif
-	/* AXI error interrupt */
-	if (irr & CC_AXI_ERR_IRQ_MASK) {
-		u32 axi_err;
-
-		/* Read the AXI error ID */
-		axi_err = cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
-		dev_dbg(dev, "AXI completion error: axim_mon_err=0x%08X\n",
-			axi_err);
-
-		irr &= ~CC_AXI_ERR_IRQ_MASK;
-	}
-
-	if (irr) {
-		dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
-			irr);
-		/* Just warning */
-	}
-
-	return IRQ_HANDLED;
-}
-
-int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
-{
-	unsigned int val, cache_params;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	/* Unmask all AXI interrupt sources AXI_CFG1 register */
-	val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
-	cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~CC_AXI_IRQ_MASK);
-	dev_dbg(dev, "AXIM_CFG=0x%08X\n",
-		cc_ioread(drvdata, CC_REG(AXIM_CFG)));
-
-	/* Clear all pending interrupts */
-	val = cc_ioread(drvdata, CC_REG(HOST_IRR));
-	dev_dbg(dev, "IRR=0x%08X\n", val);
-	cc_iowrite(drvdata, CC_REG(HOST_ICR), val);
-
-	/* Unmask relevant interrupt cause */
-	val = (unsigned int)(~(CC_COMP_IRQ_MASK | CC_AXI_ERR_IRQ_MASK |
-			       CC_GPR0_IRQ_MASK));
-	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
-
-	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
-
-	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-
-	if (is_probe)
-		dev_info(dev, "Cache params previous: 0x%08X\n", val);
-
-	cc_iowrite(drvdata, CC_REG(AXIM_CACHE_PARAMS), cache_params);
-	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-
-	if (is_probe)
-		dev_info(dev, "Cache params current: 0x%08X (expect: 0x%08X)\n",
-			 val, cache_params);
-
-	return 0;
-}
-
-static int init_cc_resources(struct platform_device *plat_dev)
-{
-	struct resource *req_mem_cc_regs = NULL;
-	struct cc_drvdata *new_drvdata;
-	struct device *dev = &plat_dev->dev;
-	struct device_node *np = dev->of_node;
-	u32 signature_val;
-	dma_addr_t dma_mask;
-	int rc = 0;
-
-	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
-	if (!new_drvdata)
-		return -ENOMEM;
-
-	platform_set_drvdata(plat_dev, new_drvdata);
-	new_drvdata->plat_dev = plat_dev;
-
-	new_drvdata->clk = of_clk_get(np, 0);
-	new_drvdata->coherent = of_dma_is_coherent(np);
-
-	/* Get device resources */
-	/* First CC registers space */
-	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
-	/* Map registers space */
-	new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
-	if (IS_ERR(new_drvdata->cc_base)) {
-		dev_err(dev, "Failed to ioremap registers");
-		return PTR_ERR(new_drvdata->cc_base);
-	}
-
-	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
-		req_mem_cc_regs);
-	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
-		&req_mem_cc_regs->start, new_drvdata->cc_base);
-
-	/* Then IRQ */
-	new_drvdata->irq = platform_get_irq(plat_dev, 0);
-	if (new_drvdata->irq < 0) {
-		dev_err(dev, "Failed getting IRQ resource\n");
-		return new_drvdata->irq;
-	}
-
-	rc = devm_request_irq(dev, new_drvdata->irq, cc_isr,
-			      IRQF_SHARED, "arm_cc7x", new_drvdata);
-	if (rc) {
-		dev_err(dev, "Could not register to interrupt %d\n",
-			new_drvdata->irq);
-		return rc;
-	}
-	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
-
-	init_completion(&new_drvdata->hw_queue_avail);
-
-	if (!plat_dev->dev.dma_mask)
-		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
-
-	dma_mask = (dma_addr_t)(DMA_BIT_MASK(DMA_BIT_MASK_LEN));
-	while (dma_mask > 0x7fffffffUL) {
-		if (dma_supported(&plat_dev->dev, dma_mask)) {
-			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
-			if (!rc)
-				break;
-		}
-		dma_mask >>= 1;
-	}
-
-	if (rc) {
-		dev_err(dev, "Failed in dma_set_mask, mask=%par\n",
-			&dma_mask);
-		return rc;
-	}
-
-	rc = cc_clk_on(new_drvdata);
-	if (rc) {
-		dev_err(dev, "Failed to enable clock");
-		return rc;
-	}
-
-	/* Verify correct mapping */
-	signature_val = cc_ioread(new_drvdata, CC_REG(HOST_SIGNATURE));
-	if (signature_val != CC_DEV_SIGNATURE) {
-		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
-			signature_val, (u32)CC_DEV_SIGNATURE);
-		rc = -EINVAL;
-		goto post_clk_err;
-	}
-	dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
-
-	/* Display HW versions */
-	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
-		 CC_DEV_NAME_STR,
-		 cc_ioread(new_drvdata, CC_REG(HOST_VERSION)),
-		 DRV_MODULE_VERSION);
-
-	rc = init_cc_regs(new_drvdata, true);
-	if (rc) {
-		dev_err(dev, "init_cc_regs failed\n");
-		goto post_clk_err;
-	}
-
-	rc = cc_debugfs_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "Failed registering debugfs interface\n");
-		goto post_regs_err;
-	}
-
-	rc = cc_fips_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
-		goto post_debugfs_err;
-	}
-	rc = cc_sram_mgr_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_sram_mgr_init failed\n");
-		goto post_fips_init_err;
-	}
-
-	new_drvdata->mlli_sram_addr =
-		cc_sram_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
-	if (new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR) {
-		dev_err(dev, "Failed to alloc MLLI Sram buffer\n");
-		rc = -ENOMEM;
-		goto post_sram_mgr_err;
-	}
-
-	rc = cc_req_mgr_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_req_mgr_init failed\n");
-		goto post_sram_mgr_err;
-	}
-
-	rc = cc_buffer_mgr_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "buffer_mgr_init failed\n");
-		goto post_req_mgr_err;
-	}
-
-	rc = cc_pm_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "ssi_power_mgr_init failed\n");
-		goto post_buf_mgr_err;
-	}
-
-	rc = cc_ivgen_init(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_ivgen_init failed\n");
-		goto post_power_mgr_err;
-	}
-
-	/* Allocate crypto algs */
-	rc = cc_cipher_alloc(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_cipher_alloc failed\n");
-		goto post_ivgen_err;
-	}
-
-	/* hash must be allocated before aead since hash exports APIs */
-	rc = cc_hash_alloc(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_hash_alloc failed\n");
-		goto post_cipher_err;
-	}
-
-	rc = cc_aead_alloc(new_drvdata);
-	if (rc) {
-		dev_err(dev, "cc_aead_alloc failed\n");
-		goto post_hash_err;
-	}
-
-	/* If we got here and FIPS mode is enabled
-	 * it means all FIPS test passed, so let TEE
-	 * know we're good.
-	 */
-	cc_set_ree_fips_status(new_drvdata, true);
-
-	return 0;
-
-post_hash_err:
-	cc_hash_free(new_drvdata);
-post_cipher_err:
-	cc_cipher_free(new_drvdata);
-post_ivgen_err:
-	cc_ivgen_fini(new_drvdata);
-post_power_mgr_err:
-	cc_pm_fini(new_drvdata);
-post_buf_mgr_err:
-	 cc_buffer_mgr_fini(new_drvdata);
-post_req_mgr_err:
-	cc_req_mgr_fini(new_drvdata);
-post_sram_mgr_err:
-	cc_sram_mgr_fini(new_drvdata);
-post_fips_init_err:
-	cc_fips_fini(new_drvdata);
-post_debugfs_err:
-	cc_debugfs_fini(new_drvdata);
-post_regs_err:
-	fini_cc_regs(new_drvdata);
-post_clk_err:
-	cc_clk_off(new_drvdata);
-	return rc;
-}
-
-void fini_cc_regs(struct cc_drvdata *drvdata)
-{
-	/* Mask all interrupts */
-	cc_iowrite(drvdata, CC_REG(HOST_IMR), 0xFFFFFFFF);
-}
-
-static void cleanup_cc_resources(struct platform_device *plat_dev)
-{
-	struct cc_drvdata *drvdata =
-		(struct cc_drvdata *)platform_get_drvdata(plat_dev);
-
-	cc_aead_free(drvdata);
-	cc_hash_free(drvdata);
-	cc_cipher_free(drvdata);
-	cc_ivgen_fini(drvdata);
-	cc_pm_fini(drvdata);
-	cc_buffer_mgr_fini(drvdata);
-	cc_req_mgr_fini(drvdata);
-	cc_sram_mgr_fini(drvdata);
-	cc_fips_fini(drvdata);
-	cc_debugfs_fini(drvdata);
-	fini_cc_regs(drvdata);
-	cc_clk_off(drvdata);
-}
-
-int cc_clk_on(struct cc_drvdata *drvdata)
-{
-	struct clk *clk = drvdata->clk;
-	int rc;
-
-	if (IS_ERR(clk))
-		/* Not all devices have a clock associated with CCREE  */
-		return 0;
-
-	rc = clk_prepare_enable(clk);
-	if (rc)
-		return rc;
-
-	return 0;
-}
-
-void cc_clk_off(struct cc_drvdata *drvdata)
-{
-	struct clk *clk = drvdata->clk;
-
-	if (IS_ERR(clk))
-		/* Not all devices have a clock associated with CCREE */
-		return;
-
-	clk_disable_unprepare(clk);
-}
-
-static int cc7x_probe(struct platform_device *plat_dev)
-{
-	int rc;
-	struct device *dev = &plat_dev->dev;
-
-	/* Map registers space */
-	rc = init_cc_resources(plat_dev);
-	if (rc)
-		return rc;
-
-	dev_info(dev, "ARM ccree device initialized\n");
-
-	return 0;
-}
-
-static int cc7x_remove(struct platform_device *plat_dev)
-{
-	struct device *dev = &plat_dev->dev;
-
-	dev_dbg(dev, "Releasing cc7x resources...\n");
-
-	cleanup_cc_resources(plat_dev);
-
-	dev_info(dev, "ARM ccree device terminated\n");
-
-	return 0;
-}
-
-static const struct of_device_id arm_cc7x_dev_of_match[] = {
-	{.compatible = "arm,cryptocell-712-ree"},
-	{}
-};
-MODULE_DEVICE_TABLE(of, arm_cc7x_dev_of_match);
-
-static struct platform_driver cc7x_driver = {
-	.driver = {
-		   .name = "cc7xree",
-		   .of_match_table = arm_cc7x_dev_of_match,
-#ifdef CONFIG_PM
-		   .pm = &ccree_pm,
-#endif
-	},
-	.probe = cc7x_probe,
-	.remove = cc7x_remove,
-};
-
-static int __init ccree_init(void)
-{
-	int ret;
-
-	cc_hash_global_init();
-
-	ret = cc_debugfs_global_init();
-	if (ret)
-		return ret;
-
-	return platform_driver_register(&cc7x_driver);
-}
-module_init(ccree_init);
-
-static void __exit ccree_exit(void)
-{
-	platform_driver_unregister(&cc7x_driver);
-	cc_debugfs_global_fini();
-}
-module_exit(ccree_exit);
-
-/* Module description */
-MODULE_DESCRIPTION("ARM TrustZone CryptoCell REE Driver");
-MODULE_VERSION(DRV_MODULE_VERSION);
-MODULE_AUTHOR("ARM");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
deleted file mode 100644
index c2b978b..0000000
--- a/drivers/staging/ccree/ssi_driver.h
+++ /dev/null
@@ -1,194 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file ssi_driver.h
- * ARM CryptoCell Linux Crypto Driver
- */
-
-#ifndef __CC_DRIVER_H__
-#define __CC_DRIVER_H__
-
-#ifdef COMP_IN_WQ
-#include <linux/workqueue.h>
-#else
-#include <linux/interrupt.h>
-#endif
-#include <linux/dma-mapping.h>
-#include <crypto/algapi.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/aes.h>
-#include <crypto/sha.h>
-#include <crypto/aead.h>
-#include <crypto/authenc.h>
-#include <crypto/hash.h>
-#include <linux/version.h>
-#include <linux/clk.h>
-#include <linux/platform_device.h>
-
-/* Registers definitions from shared/hw/ree_include */
-#include "dx_host.h"
-#define CC_DEV_SHA_MAX 512
-#include "cc_crypto_ctx.h"
-#include "cc_hw_queue_defs.h"
-#include "ssi_sram_mgr.h"
-
-extern bool cc_dump_desc;
-extern bool cc_dump_bytes;
-
-#define DRV_MODULE_VERSION "3.0"
-
-#define CC_DEV_NAME_STR "cc715ree"
-#define CC_COHERENT_CACHE_PARAMS 0xEEE
-
-/* Maximum DMA mask supported by IP */
-#define DMA_BIT_MASK_LEN 48
-
-#define CC_DEV_SIGNATURE 0xDCC71200UL
-
-#define CC_AXI_IRQ_MASK ((1 << CC_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
-			  (1 << CC_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
-			  (1 << CC_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
-			  (1 << CC_AXIM_CFG_COMPMASK_BIT_SHIFT))
-
-#define CC_AXI_ERR_IRQ_MASK BIT(CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
-
-#define CC_COMP_IRQ_MASK BIT(CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
-
-#define AXIM_MON_COMP_VALUE GENMASK(CC_AXIM_MON_COMP_VALUE_BIT_SIZE + \
-				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
-				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
-
-/* Register name mangling macro */
-#define CC_REG(reg_name) CC_ ## reg_name ## _REG_OFFSET
-
-/* TEE FIPS status interrupt */
-#define CC_GPR0_IRQ_MASK BIT(CC_HOST_IRR_GPR0_BIT_SHIFT)
-
-#define CC_CRA_PRIO 3000
-
-#define MIN_HW_QUEUE_SIZE 50 /* Minimum size required for proper function */
-
-#define MAX_REQUEST_QUEUE_SIZE 4096
-#define MAX_MLLI_BUFF_SIZE 2080
-#define MAX_ICV_NENTS_SUPPORTED 2
-
-/* Definitions for HW descriptors DIN/DOUT fields */
-#define NS_BIT 1
-#define AXI_ID 0
-/* AXI_ID is not actually the AXI ID of the transaction but the value of AXI_ID
- * field in the HW descriptor. The DMA engine +8 that value.
- */
-
-#define CC_MAX_IVGEN_DMA_ADDRESSES	3
-struct cc_crypto_req {
-	void (*user_cb)(struct device *dev, void *req, int err);
-	void *user_arg;
-	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
-	/* For the first 'ivgen_dma_addr_len' addresses of this array,
-	 * generated IV would be placed in it by send_request().
-	 * Same generated IV for all addresses!
-	 */
-	/* Amount of 'ivgen_dma_addr' elements to be filled. */
-	unsigned int ivgen_dma_addr_len;
-	/* The generated IV size required, 8/16 B allowed. */
-	unsigned int ivgen_size;
-	struct completion seq_compl; /* request completion */
-};
-
-/**
- * struct cc_drvdata - driver private data context
- * @cc_base:	virt address of the CC registers
- * @irq:	device IRQ number
- * @irq_mask:	Interrupt mask shadow (1 for masked interrupts)
- * @fw_ver:	SeP loaded firmware version
- */
-struct cc_drvdata {
-	void __iomem *cc_base;
-	int irq;
-	u32 irq_mask;
-	u32 fw_ver;
-	struct completion hw_queue_avail; /* wait for HW queue availability */
-	struct platform_device *plat_dev;
-	cc_sram_addr_t mlli_sram_addr;
-	void *buff_mgr_handle;
-	void *hash_handle;
-	void *aead_handle;
-	void *blkcipher_handle;
-	void *request_mgr_handle;
-	void *fips_handle;
-	void *ivgen_handle;
-	void *sram_mgr_handle;
-	void *debugfs;
-	struct clk *clk;
-	bool coherent;
-};
-
-struct cc_crypto_alg {
-	struct list_head entry;
-	int cipher_mode;
-	int flow_mode; /* Note: currently, refers to the cipher mode only. */
-	int auth_mode;
-	struct cc_drvdata *drvdata;
-	struct crypto_alg crypto_alg;
-	struct aead_alg aead_alg;
-};
-
-struct cc_alg_template {
-	char name[CRYPTO_MAX_ALG_NAME];
-	char driver_name[CRYPTO_MAX_ALG_NAME];
-	unsigned int blocksize;
-	u32 type;
-	union {
-		struct ablkcipher_alg ablkcipher;
-		struct aead_alg aead;
-		struct blkcipher_alg blkcipher;
-		struct cipher_alg cipher;
-		struct compress_alg compress;
-	} template_u;
-	int cipher_mode;
-	int flow_mode; /* Note: currently, refers to the cipher mode only. */
-	int auth_mode;
-	struct cc_drvdata *drvdata;
-};
-
-struct async_gen_req_ctx {
-	dma_addr_t iv_dma_addr;
-	enum drv_crypto_direction op_type;
-};
-
-static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
-{
-	return &drvdata->plat_dev->dev;
-}
-
-void __dump_byte_array(const char *name, const u8 *buf, size_t len);
-static inline void dump_byte_array(const char *name, const u8 *the_array,
-				   size_t size)
-{
-	if (cc_dump_bytes)
-		__dump_byte_array(name, the_array, size);
-}
-
-int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
-void fini_cc_regs(struct cc_drvdata *drvdata);
-int cc_clk_on(struct cc_drvdata *drvdata);
-void cc_clk_off(struct cc_drvdata *drvdata);
-
-static inline void cc_iowrite(struct cc_drvdata *drvdata, u32 reg, u32 val)
-{
-	iowrite32(val, (drvdata->cc_base + reg));
-}
-
-static inline u32 cc_ioread(struct cc_drvdata *drvdata, u32 reg)
-{
-	return ioread32(drvdata->cc_base + reg);
-}
-
-static inline gfp_t cc_gfp_flags(struct crypto_async_request *req)
-{
-	return (req->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC;
-}
-
-#endif /*__CC_DRIVER_H__*/
-
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
deleted file mode 100644
index 2c58f90..0000000
--- a/drivers/staging/ccree/ssi_fips.c
+++ /dev/null
@@ -1,112 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/fips.h>
-
-#include "ssi_driver.h"
-#include "ssi_fips.h"
-
-static void fips_dsr(unsigned long devarg);
-
-struct cc_fips_handle {
-	struct tasklet_struct tasklet;
-};
-
-/* The function called once at driver entry point to check
- * whether TEE FIPS error occurred.
- */
-static bool cc_get_tee_fips_status(struct cc_drvdata *drvdata)
-{
-	u32 reg;
-
-	reg = cc_ioread(drvdata, CC_REG(GPR_HOST));
-	return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
-}
-
-/*
- * This function should push the FIPS REE library status towards the TEE library
- * by writing the error state to HOST_GPR0 register.
- */
-void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool status)
-{
-	int val = CC_FIPS_SYNC_REE_STATUS;
-
-	val |= (status ? CC_FIPS_SYNC_MODULE_OK : CC_FIPS_SYNC_MODULE_ERROR);
-
-	cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
-}
-
-void cc_fips_fini(struct cc_drvdata *drvdata)
-{
-	struct cc_fips_handle *fips_h = drvdata->fips_handle;
-
-	if (!fips_h)
-		return; /* Not allocated */
-
-	/* Kill tasklet */
-	tasklet_kill(&fips_h->tasklet);
-
-	kfree(fips_h);
-	drvdata->fips_handle = NULL;
-}
-
-void fips_handler(struct cc_drvdata *drvdata)
-{
-	struct cc_fips_handle *fips_handle_ptr =
-		drvdata->fips_handle;
-
-	tasklet_schedule(&fips_handle_ptr->tasklet);
-}
-
-static inline void tee_fips_error(struct device *dev)
-{
-	if (fips_enabled)
-		panic("ccree: TEE reported cryptographic error in fips mode!\n");
-	else
-		dev_err(dev, "TEE reported error!\n");
-}
-
-/* Deferred service handler, run as interrupt-fired tasklet */
-static void fips_dsr(unsigned long devarg)
-{
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
-	struct device *dev = drvdata_to_dev(drvdata);
-	u32 irq, state, val;
-
-	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
-
-	if (irq) {
-		state = cc_ioread(drvdata, CC_REG(GPR_HOST));
-
-		if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
-			tee_fips_error(dev);
-	}
-
-	/* after verifing that there is nothing to do,
-	 * unmask AXI completion interrupt.
-	 */
-	val = (CC_REG(HOST_IMR) & ~irq);
-	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
-}
-
-/* The function called once at driver entry point .*/
-int cc_fips_init(struct cc_drvdata *p_drvdata)
-{
-	struct cc_fips_handle *fips_h;
-	struct device *dev = drvdata_to_dev(p_drvdata);
-
-	fips_h = kzalloc(sizeof(*fips_h), GFP_KERNEL);
-	if (!fips_h)
-		return -ENOMEM;
-
-	p_drvdata->fips_handle = fips_h;
-
-	dev_dbg(dev, "Initializing fips tasklet\n");
-	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
-
-	if (!cc_get_tee_fips_status(p_drvdata))
-		tee_fips_error(dev);
-
-	return 0;
-}
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
deleted file mode 100644
index 0d52003..0000000
--- a/drivers/staging/ccree/ssi_fips.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#ifndef __CC_FIPS_H__
-#define __CC_FIPS_H__
-
-#ifdef CONFIG_CRYPTO_FIPS
-
-enum cc_fips_status {
-	CC_FIPS_SYNC_MODULE_OK = 0x0,
-	CC_FIPS_SYNC_MODULE_ERROR = 0x1,
-	CC_FIPS_SYNC_REE_STATUS = 0x4,
-	CC_FIPS_SYNC_TEE_STATUS = 0x8,
-	CC_FIPS_SYNC_STATUS_RESERVE32B = S32_MAX
-};
-
-int cc_fips_init(struct cc_drvdata *p_drvdata);
-void cc_fips_fini(struct cc_drvdata *drvdata);
-void fips_handler(struct cc_drvdata *drvdata);
-void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
-
-#else  /* CONFIG_CRYPTO_FIPS */
-
-static inline int cc_fips_init(struct cc_drvdata *p_drvdata)
-{
-	return 0;
-}
-
-static inline void cc_fips_fini(struct cc_drvdata *drvdata) {}
-static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
-					  bool ok) {}
-static inline void fips_handler(struct cc_drvdata *drvdata) {}
-
-#endif /* CONFIG_CRYPTO_FIPS */
-
-#endif  /*__CC_FIPS_H__*/
-
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
deleted file mode 100644
index 57031c7..0000000
--- a/drivers/staging/ccree/ssi_hash.c
+++ /dev/null
@@ -1,2299 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <crypto/algapi.h>
-#include <crypto/hash.h>
-#include <crypto/sha.h>
-#include <crypto/md5.h>
-#include <crypto/internal/hash.h>
-
-#include "ssi_driver.h"
-#include "ssi_request_mgr.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_hash.h"
-#include "ssi_sram_mgr.h"
-
-#define CC_MAX_HASH_SEQ_LEN 12
-#define CC_MAX_OPAD_KEYS_SIZE CC_MAX_HASH_BLCK_SIZE
-
-struct cc_hash_handle {
-	cc_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
-	cc_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
-	struct list_head hash_list;
-};
-
-static const u32 digest_len_init[] = {
-	0x00000040, 0x00000000, 0x00000000, 0x00000000 };
-static const u32 md5_init[] = {
-	SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
-static const u32 sha1_init[] = {
-	SHA1_H4, SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
-static const u32 sha224_init[] = {
-	SHA224_H7, SHA224_H6, SHA224_H5, SHA224_H4,
-	SHA224_H3, SHA224_H2, SHA224_H1, SHA224_H0 };
-static const u32 sha256_init[] = {
-	SHA256_H7, SHA256_H6, SHA256_H5, SHA256_H4,
-	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
-#if (CC_DEV_SHA_MAX > 256)
-static const u32 digest_len_sha512_init[] = {
-	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
-static u64 sha384_init[] = {
-	SHA384_H7, SHA384_H6, SHA384_H5, SHA384_H4,
-	SHA384_H3, SHA384_H2, SHA384_H1, SHA384_H0 };
-static u64 sha512_init[] = {
-	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
-	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
-#endif
-
-static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
-			  unsigned int *seq_size);
-
-static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
-			  unsigned int *seq_size);
-
-static const void *cc_larval_digest(struct device *dev, u32 mode);
-
-struct cc_hash_alg {
-	struct list_head entry;
-	int hash_mode;
-	int hw_mode;
-	int inter_digestsize;
-	struct cc_drvdata *drvdata;
-	struct ahash_alg ahash_alg;
-};
-
-struct hash_key_req_ctx {
-	u32 keylen;
-	dma_addr_t key_dma_addr;
-};
-
-/* hash per-session context */
-struct cc_hash_ctx {
-	struct cc_drvdata *drvdata;
-	/* holds the origin digest; the digest after "setkey" if HMAC,*
-	 * the initial digest if HASH.
-	 */
-	u8 digest_buff[CC_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
-	u8 opad_tmp_keys_buff[CC_MAX_OPAD_KEYS_SIZE]  ____cacheline_aligned;
-
-	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
-	dma_addr_t digest_buff_dma_addr;
-	/* use for hmac with key large then mode block size */
-	struct hash_key_req_ctx key_params;
-	int hash_mode;
-	int hw_mode;
-	int inter_digestsize;
-	struct completion setkey_comp;
-	bool is_hmac;
-};
-
-static void cc_set_desc(struct ahash_req_ctx *areq_ctx, struct cc_hash_ctx *ctx,
-			unsigned int flow_mode, struct cc_hw_desc desc[],
-			bool is_not_last_data, unsigned int *seq_size);
-
-static void cc_set_endianity(u32 mode, struct cc_hw_desc *desc)
-{
-	if (mode == DRV_HASH_MD5 || mode == DRV_HASH_SHA384 ||
-	    mode == DRV_HASH_SHA512) {
-		set_bytes_swap(desc, 1);
-	} else {
-		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-	}
-}
-
-static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
-			 unsigned int digestsize)
-{
-	state->digest_result_dma_addr =
-		dma_map_single(dev, state->digest_result_buff,
-			       digestsize, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, state->digest_result_dma_addr)) {
-		dev_err(dev, "Mapping digest result buffer %u B for DMA failed\n",
-			digestsize);
-		return -ENOMEM;
-	}
-	dev_dbg(dev, "Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
-		digestsize, state->digest_result_buff,
-		&state->digest_result_dma_addr);
-
-	return 0;
-}
-
-static void cc_init_req(struct device *dev, struct ahash_req_ctx *state,
-			struct cc_hash_ctx *ctx)
-{
-	bool is_hmac = ctx->is_hmac;
-
-	memset(state, 0, sizeof(*state));
-
-	if (is_hmac) {
-		if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC &&
-		    ctx->hw_mode != DRV_CIPHER_CMAC) {
-			dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr,
-						ctx->inter_digestsize,
-						DMA_BIDIRECTIONAL);
-
-			memcpy(state->digest_buff, ctx->digest_buff,
-			       ctx->inter_digestsize);
-#if (CC_DEV_SHA_MAX > 256)
-			if (ctx->hash_mode == DRV_HASH_SHA512 ||
-			    ctx->hash_mode == DRV_HASH_SHA384)
-				memcpy(state->digest_bytes_len,
-				       digest_len_sha512_init, HASH_LEN_SIZE);
-			else
-				memcpy(state->digest_bytes_len,
-				       digest_len_init, HASH_LEN_SIZE);
-#else
-			memcpy(state->digest_bytes_len, digest_len_init,
-			       HASH_LEN_SIZE);
-#endif
-		}
-
-		if (ctx->hash_mode != DRV_HASH_NULL) {
-			dma_sync_single_for_cpu(dev,
-						ctx->opad_tmp_keys_dma_addr,
-						ctx->inter_digestsize,
-						DMA_BIDIRECTIONAL);
-			memcpy(state->opad_digest_buff,
-			       ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
-		}
-	} else { /*hash*/
-		/* Copy the initial digests if hash flow. */
-		const void *larval = cc_larval_digest(dev, ctx->hash_mode);
-
-		memcpy(state->digest_buff, larval, ctx->inter_digestsize);
-	}
-}
-
-static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
-		      struct cc_hash_ctx *ctx)
-{
-	bool is_hmac = ctx->is_hmac;
-
-	state->digest_buff_dma_addr =
-		dma_map_single(dev, state->digest_buff,
-			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
-			ctx->inter_digestsize, state->digest_buff);
-		return -EINVAL;
-	}
-	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
-		ctx->inter_digestsize, state->digest_buff,
-		&state->digest_buff_dma_addr);
-
-	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len_dma_addr =
-			dma_map_single(dev, state->digest_bytes_len,
-				       HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
-			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
-				HASH_LEN_SIZE, state->digest_bytes_len);
-			goto unmap_digest_buf;
-		}
-		dev_dbg(dev, "Mapped digest len %u B at va=%pK to dma=%pad\n",
-			HASH_LEN_SIZE, state->digest_bytes_len,
-			&state->digest_bytes_len_dma_addr);
-	}
-
-	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
-		state->opad_digest_dma_addr =
-			dma_map_single(dev, state->opad_digest_buff,
-				       ctx->inter_digestsize,
-				       DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
-			dev_err(dev, "Mapping opad digest %d B at va=%pK for DMA failed\n",
-				ctx->inter_digestsize,
-				state->opad_digest_buff);
-			goto unmap_digest_len;
-		}
-		dev_dbg(dev, "Mapped opad digest %d B at va=%pK to dma=%pad\n",
-			ctx->inter_digestsize, state->opad_digest_buff,
-			&state->opad_digest_dma_addr);
-	}
-
-	return 0;
-
-unmap_digest_len:
-	if (state->digest_bytes_len_dma_addr) {
-		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
-				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		state->digest_bytes_len_dma_addr = 0;
-	}
-unmap_digest_buf:
-	if (state->digest_buff_dma_addr) {
-		dma_unmap_single(dev, state->digest_buff_dma_addr,
-				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		state->digest_buff_dma_addr = 0;
-	}
-
-	return -EINVAL;
-}
-
-static void cc_unmap_req(struct device *dev, struct ahash_req_ctx *state,
-			 struct cc_hash_ctx *ctx)
-{
-	if (state->digest_buff_dma_addr) {
-		dma_unmap_single(dev, state->digest_buff_dma_addr,
-				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
-			&state->digest_buff_dma_addr);
-		state->digest_buff_dma_addr = 0;
-	}
-	if (state->digest_bytes_len_dma_addr) {
-		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
-				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
-			&state->digest_bytes_len_dma_addr);
-		state->digest_bytes_len_dma_addr = 0;
-	}
-	if (state->opad_digest_dma_addr) {
-		dma_unmap_single(dev, state->opad_digest_dma_addr,
-				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
-			&state->opad_digest_dma_addr);
-		state->opad_digest_dma_addr = 0;
-	}
-}
-
-static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
-			    unsigned int digestsize, u8 *result)
-{
-	if (state->digest_result_dma_addr) {
-		dma_unmap_single(dev, state->digest_result_dma_addr, digestsize,
-				 DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
-			state->digest_result_buff,
-			&state->digest_result_dma_addr, digestsize);
-		memcpy(result, state->digest_result_buff, digestsize);
-	}
-	state->digest_result_dma_addr = 0;
-}
-
-static void cc_update_complete(struct device *dev, void *cc_req, int err)
-{
-	struct ahash_request *req = (struct ahash_request *)cc_req;
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-
-	dev_dbg(dev, "req=%pK\n", req);
-
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_req(dev, state, ctx);
-	req->base.complete(&req->base, err);
-}
-
-static void cc_digest_complete(struct device *dev, void *cc_req, int err)
-{
-	struct ahash_request *req = (struct ahash_request *)cc_req;
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	dev_dbg(dev, "req=%pK\n", req);
-
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_result(dev, state, digestsize, req->result);
-	cc_unmap_req(dev, state, ctx);
-	req->base.complete(&req->base, err);
-}
-
-static void cc_hash_complete(struct device *dev, void *cc_req, int err)
-{
-	struct ahash_request *req = (struct ahash_request *)cc_req;
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	dev_dbg(dev, "req=%pK\n", req);
-
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_result(dev, state, digestsize, req->result);
-	cc_unmap_req(dev, state, ctx);
-	req->base.complete(&req->base, err);
-}
-
-static int cc_fin_result(struct cc_hw_desc *desc, struct ahash_request *req,
-			 int idx)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	/* TODO */
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	cc_set_endianity(ctx->hash_mode, &desc[idx]);
-	idx++;
-
-	return idx;
-}
-
-static int cc_fin_hmac(struct cc_hw_desc *desc, struct ahash_request *req,
-		       int idx)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	/* store the hash digest result in the context */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr, digestsize,
-		      NS_BIT, 0);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	cc_set_endianity(ctx->hash_mode, &desc[idx]);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	idx++;
-
-	/* Loading hash opad xor key state */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
-		     ctx->inter_digestsize, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Load the hash current length */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_sram(&desc[idx],
-		     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
-		     HASH_LEN_SIZE);
-	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-	hw_desc_init(&desc[idx]);
-	set_din_no_dma(&desc[idx], 0, 0xfffff0);
-	set_dout_no_dma(&desc[idx], 0, 0, 1);
-	idx++;
-
-	/* Perform HASH update */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     digestsize, NS_BIT);
-	set_flow_mode(&desc[idx], DIN_HASH);
-	idx++;
-
-	return idx;
-}
-
-static int cc_hash_digest(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	struct scatterlist *src = req->src;
-	unsigned int nbytes = req->nbytes;
-	u8 *result = req->result;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	bool is_hmac = ctx->is_hmac;
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	cc_sram_addr_t larval_digest_addr =
-		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
-	int idx = 0;
-	int rc = 0;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
-		nbytes);
-
-	cc_init_req(dev, state, ctx);
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -ENOMEM;
-	}
-
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
-				      flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_result(dev, state, digestsize, result);
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = cc_digest_complete;
-	cc_req.user_arg = req;
-
-	/* If HMAC then load hash IPAD xor key, if HASH then load initial
-	 * digest
-	 */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	if (is_hmac) {
-		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-			     ctx->inter_digestsize, NS_BIT);
-	} else {
-		set_din_sram(&desc[idx], larval_digest_addr,
-			     ctx->inter_digestsize);
-	}
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Load the hash current length */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-
-	if (is_hmac) {
-		set_din_type(&desc[idx], DMA_DLLI,
-			     state->digest_bytes_len_dma_addr, HASH_LEN_SIZE,
-			     NS_BIT);
-	} else {
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-		if (nbytes)
-			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-		else
-			set_cipher_do(&desc[idx], DO_PAD);
-	}
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
-
-	if (is_hmac) {
-		/* HW last hash block padding (aka. "DO_PAD") */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      HASH_LEN_SIZE, NS_BIT, 0);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
-		set_cipher_do(&desc[idx], DO_PAD);
-		idx++;
-
-		idx = cc_fin_hmac(desc, req, idx);
-	}
-
-	idx = cc_fin_result(desc, req, idx);
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_result(dev, state, digestsize, result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
-			   struct ahash_req_ctx *state, int idx)
-{
-	/* Restore hash digest */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     ctx->inter_digestsize, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Restore hash current length */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
-
-	return idx;
-}
-
-static int cc_hash_update(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
-	struct scatterlist *src = req->src;
-	unsigned int nbytes = req->nbytes;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	u32 idx = 0;
-	int rc;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== %s-update (%d) ====\n", ctx->is_hmac ?
-		"hmac" : "hash", nbytes);
-
-	if (nbytes == 0) {
-		/* no real updates required */
-		return 0;
-	}
-
-	rc = cc_map_hash_request_update(ctx->drvdata, state, src, nbytes,
-					block_size, flags);
-	if (rc) {
-		if (rc == 1) {
-			dev_dbg(dev, " data size not require HW update %x\n",
-				nbytes);
-			/* No hardware updates are required */
-			return 0;
-		}
-		dev_err(dev, "map_ahash_request_update() failed\n");
-		return -ENOMEM;
-	}
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		cc_unmap_hash_request(dev, state, src, true);
-		return -EINVAL;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = cc_update_complete;
-	cc_req.user_arg = req;
-
-	idx = cc_restore_hash(desc, ctx, state, idx);
-
-	/* store the hash digest result in context */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-		      ctx->inter_digestsize, NS_BIT, 0);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	idx++;
-
-	/* store current hash length in context */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      HASH_LEN_SIZE, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
-	idx++;
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_hash_finup(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	struct scatterlist *src = req->src;
-	unsigned int nbytes = req->nbytes;
-	u8 *result = req->result;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	bool is_hmac = ctx->is_hmac;
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	int idx = 0;
-	int rc;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
-		nbytes);
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -EINVAL;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
-				      flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = cc_hash_complete;
-	cc_req.user_arg = req;
-
-	idx = cc_restore_hash(desc, ctx, state, idx);
-
-	if (is_hmac)
-		idx = cc_fin_hmac(desc, req, idx);
-
-	idx = cc_fin_result(desc, req, idx);
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_result(dev, state, digestsize, result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_hash_final(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	struct scatterlist *src = req->src;
-	unsigned int nbytes = req->nbytes;
-	u8 *result = req->result;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	bool is_hmac = ctx->is_hmac;
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	int idx = 0;
-	int rc;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
-		nbytes);
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -EINVAL;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0,
-				      flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = cc_hash_complete;
-	cc_req.user_arg = req;
-
-	idx = cc_restore_hash(desc, ctx, state, idx);
-
-	/* "DO-PAD" must be enabled only when writing current length to HW */
-	hw_desc_init(&desc[idx]);
-	set_cipher_do(&desc[idx], DO_PAD);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      HASH_LEN_SIZE, NS_BIT, 0);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	idx++;
-
-	if (is_hmac)
-		idx = cc_fin_hmac(desc, req, idx);
-
-	idx = cc_fin_result(desc, req, idx);
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_result(dev, state, digestsize, result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_hash_init(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
-
-	cc_init_req(dev, state, ctx);
-
-	return 0;
-}
-
-static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
-			  unsigned int keylen)
-{
-	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
-	struct cc_crypto_req cc_req = {};
-	struct cc_hash_ctx *ctx = NULL;
-	int blocksize = 0;
-	int digestsize = 0;
-	int i, idx = 0, rc = 0;
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	cc_sram_addr_t larval_addr;
-	struct device *dev;
-
-	ctx = crypto_ahash_ctx(ahash);
-	dev = drvdata_to_dev(ctx->drvdata);
-	dev_dbg(dev, "start keylen: %d", keylen);
-
-	blocksize = crypto_tfm_alg_blocksize(&ahash->base);
-	digestsize = crypto_ahash_digestsize(ahash);
-
-	larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
-
-	/* The keylen value distinguishes HASH in case keylen is ZERO bytes,
-	 * any NON-ZERO value utilizes HMAC flow
-	 */
-	ctx->key_params.keylen = keylen;
-	ctx->key_params.key_dma_addr = 0;
-	ctx->is_hmac = true;
-
-	if (keylen) {
-		ctx->key_params.key_dma_addr =
-			dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
-			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
-				key, keylen);
-			return -ENOMEM;
-		}
-		dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
-			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
-
-		if (keylen > blocksize) {
-			/* Load hash initial state */
-			hw_desc_init(&desc[idx]);
-			set_cipher_mode(&desc[idx], ctx->hw_mode);
-			set_din_sram(&desc[idx], larval_addr,
-				     ctx->inter_digestsize);
-			set_flow_mode(&desc[idx], S_DIN_to_HASH);
-			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-			idx++;
-
-			/* Load the hash current length*/
-			hw_desc_init(&desc[idx]);
-			set_cipher_mode(&desc[idx], ctx->hw_mode);
-			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-			set_flow_mode(&desc[idx], S_DIN_to_HASH);
-			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-			idx++;
-
-			hw_desc_init(&desc[idx]);
-			set_din_type(&desc[idx], DMA_DLLI,
-				     ctx->key_params.key_dma_addr, keylen,
-				     NS_BIT);
-			set_flow_mode(&desc[idx], DIN_HASH);
-			idx++;
-
-			/* Get hashed key */
-			hw_desc_init(&desc[idx]);
-			set_cipher_mode(&desc[idx], ctx->hw_mode);
-			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
-				      digestsize, NS_BIT, 0);
-			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-			cc_set_endianity(ctx->hash_mode, &desc[idx]);
-			idx++;
-
-			hw_desc_init(&desc[idx]);
-			set_din_const(&desc[idx], 0, (blocksize - digestsize));
-			set_flow_mode(&desc[idx], BYPASS);
-			set_dout_dlli(&desc[idx],
-				      (ctx->opad_tmp_keys_dma_addr +
-				       digestsize),
-				      (blocksize - digestsize), NS_BIT, 0);
-			idx++;
-		} else {
-			hw_desc_init(&desc[idx]);
-			set_din_type(&desc[idx], DMA_DLLI,
-				     ctx->key_params.key_dma_addr, keylen,
-				     NS_BIT);
-			set_flow_mode(&desc[idx], BYPASS);
-			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
-				      keylen, NS_BIT, 0);
-			idx++;
-
-			if ((blocksize - keylen)) {
-				hw_desc_init(&desc[idx]);
-				set_din_const(&desc[idx], 0,
-					      (blocksize - keylen));
-				set_flow_mode(&desc[idx], BYPASS);
-				set_dout_dlli(&desc[idx],
-					      (ctx->opad_tmp_keys_dma_addr +
-					       keylen), (blocksize - keylen),
-					      NS_BIT, 0);
-				idx++;
-			}
-		}
-	} else {
-		hw_desc_init(&desc[idx]);
-		set_din_const(&desc[idx], 0, blocksize);
-		set_flow_mode(&desc[idx], BYPASS);
-		set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr),
-			      blocksize, NS_BIT, 0);
-		idx++;
-	}
-
-	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
-	if (rc) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		goto out;
-	}
-
-	/* calc derived HMAC key */
-	for (idx = 0, i = 0; i < 2; i++) {
-		/* Load hash initial state */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_sram(&desc[idx], larval_addr, ctx->inter_digestsize);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-		idx++;
-
-		/* Load the hash current length*/
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-		idx++;
-
-		/* Prepare ipad key */
-		hw_desc_init(&desc[idx]);
-		set_xor_val(&desc[idx], hmac_pad_const[i]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-		idx++;
-
-		/* Perform HASH update */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
-			     blocksize, NS_BIT);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_xor_active(&desc[idx]);
-		set_flow_mode(&desc[idx], DIN_HASH);
-		idx++;
-
-		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial digest
-		 * of the first HASH "update" state)
-		 */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		if (i > 0) /* Not first iteration */
-			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
-				      ctx->inter_digestsize, NS_BIT, 0);
-		else /* First iteration */
-			set_dout_dlli(&desc[idx], ctx->digest_buff_dma_addr,
-				      ctx->inter_digestsize, NS_BIT, 0);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		idx++;
-	}
-
-	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
-
-out:
-	if (rc)
-		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
-	if (ctx->key_params.key_dma_addr) {
-		dma_unmap_single(dev, ctx->key_params.key_dma_addr,
-				 ctx->key_params.keylen, DMA_TO_DEVICE);
-		dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
-	}
-	return rc;
-}
-
-static int cc_xcbc_setkey(struct crypto_ahash *ahash,
-			  const u8 *key, unsigned int keylen)
-{
-	struct cc_crypto_req cc_req = {};
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	int idx = 0, rc = 0;
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-
-	dev_dbg(dev, "===== setkey (%d) ====\n", keylen);
-
-	switch (keylen) {
-	case AES_KEYSIZE_128:
-	case AES_KEYSIZE_192:
-	case AES_KEYSIZE_256:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	ctx->key_params.keylen = keylen;
-
-	ctx->key_params.key_dma_addr =
-		dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
-		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
-			key, keylen);
-		return -ENOMEM;
-	}
-	dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
-		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
-
-	ctx->is_hmac = true;
-	/* 1. Load the AES key */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, ctx->key_params.key_dma_addr,
-		     keylen, NS_BIT);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
-	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	set_key_size_aes(&desc[idx], keylen);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	hw_desc_init(&desc[idx]);
-	set_din_const(&desc[idx], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	set_dout_dlli(&desc[idx],
-		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K1_OFFSET),
-		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
-	idx++;
-
-	hw_desc_init(&desc[idx]);
-	set_din_const(&desc[idx], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	set_dout_dlli(&desc[idx],
-		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K2_OFFSET),
-		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
-	idx++;
-
-	hw_desc_init(&desc[idx]);
-	set_din_const(&desc[idx], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	set_dout_dlli(&desc[idx],
-		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K3_OFFSET),
-		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
-	idx++;
-
-	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
-
-	if (rc)
-		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
-	dma_unmap_single(dev, ctx->key_params.key_dma_addr,
-			 ctx->key_params.keylen, DMA_TO_DEVICE);
-	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
-
-	return rc;
-}
-
-static int cc_cmac_setkey(struct crypto_ahash *ahash,
-			  const u8 *key, unsigned int keylen)
-{
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "===== setkey (%d) ====\n", keylen);
-
-	ctx->is_hmac = true;
-
-	switch (keylen) {
-	case AES_KEYSIZE_128:
-	case AES_KEYSIZE_192:
-	case AES_KEYSIZE_256:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	ctx->key_params.keylen = keylen;
-
-	/* STAT_PHASE_1: Copy key to ctx */
-
-	dma_sync_single_for_cpu(dev, ctx->opad_tmp_keys_dma_addr,
-				keylen, DMA_TO_DEVICE);
-
-	memcpy(ctx->opad_tmp_keys_buff, key, keylen);
-	if (keylen == 24) {
-		memset(ctx->opad_tmp_keys_buff + 24, 0,
-		       CC_AES_KEY_SIZE_MAX - 24);
-	}
-
-	dma_sync_single_for_device(dev, ctx->opad_tmp_keys_dma_addr,
-				   keylen, DMA_TO_DEVICE);
-
-	ctx->key_params.keylen = keylen;
-
-	return 0;
-}
-
-static void cc_free_ctx(struct cc_hash_ctx *ctx)
-{
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	if (ctx->digest_buff_dma_addr) {
-		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
-				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
-			&ctx->digest_buff_dma_addr);
-		ctx->digest_buff_dma_addr = 0;
-	}
-	if (ctx->opad_tmp_keys_dma_addr) {
-		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
-				 sizeof(ctx->opad_tmp_keys_buff),
-				 DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
-			&ctx->opad_tmp_keys_dma_addr);
-		ctx->opad_tmp_keys_dma_addr = 0;
-	}
-
-	ctx->key_params.keylen = 0;
-}
-
-static int cc_alloc_ctx(struct cc_hash_ctx *ctx)
-{
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	ctx->key_params.keylen = 0;
-
-	ctx->digest_buff_dma_addr =
-		dma_map_single(dev, (void *)ctx->digest_buff,
-			       sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %zu B at va=%pK for DMA failed\n",
-			sizeof(ctx->digest_buff), ctx->digest_buff);
-		goto fail;
-	}
-	dev_dbg(dev, "Mapped digest %zu B at va=%pK to dma=%pad\n",
-		sizeof(ctx->digest_buff), ctx->digest_buff,
-		&ctx->digest_buff_dma_addr);
-
-	ctx->opad_tmp_keys_dma_addr =
-		dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff,
-			       sizeof(ctx->opad_tmp_keys_buff),
-			       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
-		dev_err(dev, "Mapping opad digest %zu B at va=%pK for DMA failed\n",
-			sizeof(ctx->opad_tmp_keys_buff),
-			ctx->opad_tmp_keys_buff);
-		goto fail;
-	}
-	dev_dbg(dev, "Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
-		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
-		&ctx->opad_tmp_keys_dma_addr);
-
-	ctx->is_hmac = false;
-	return 0;
-
-fail:
-	cc_free_ctx(ctx);
-	return -ENOMEM;
-}
-
-static int cc_cra_init(struct crypto_tfm *tfm)
-{
-	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct hash_alg_common *hash_alg_common =
-		container_of(tfm->__crt_alg, struct hash_alg_common, base);
-	struct ahash_alg *ahash_alg =
-		container_of(hash_alg_common, struct ahash_alg, halg);
-	struct cc_hash_alg *cc_alg =
-			container_of(ahash_alg, struct cc_hash_alg, ahash_alg);
-
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct ahash_req_ctx));
-
-	ctx->hash_mode = cc_alg->hash_mode;
-	ctx->hw_mode = cc_alg->hw_mode;
-	ctx->inter_digestsize = cc_alg->inter_digestsize;
-	ctx->drvdata = cc_alg->drvdata;
-
-	return cc_alloc_ctx(ctx);
-}
-
-static void cc_cra_exit(struct crypto_tfm *tfm)
-{
-	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "cc_cra_exit");
-	cc_free_ctx(ctx);
-}
-
-static int cc_mac_update(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	int rc;
-	u32 idx = 0;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	if (req->nbytes == 0) {
-		/* no real updates required */
-		return 0;
-	}
-
-	state->xcbc_count++;
-
-	rc = cc_map_hash_request_update(ctx->drvdata, state, req->src,
-					req->nbytes, block_size, flags);
-	if (rc) {
-		if (rc == 1) {
-			dev_dbg(dev, " data size not require HW update %x\n",
-				req->nbytes);
-			/* No hardware updates are required */
-			return 0;
-		}
-		dev_err(dev, "map_ahash_request_update() failed\n");
-		return -ENOMEM;
-	}
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -EINVAL;
-	}
-
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
-		cc_setup_xcbc(req, desc, &idx);
-	else
-		cc_setup_cmac(req, desc, &idx);
-
-	cc_set_desc(state, ctx, DIN_AES_DOUT, desc, true, &idx);
-
-	/* store the hash digest result in context */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-		      ctx->inter_digestsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_AES_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	idx++;
-
-	/* Setup DX request structure */
-	cc_req.user_cb = (void *)cc_update_complete;
-	cc_req.user_arg = (void *)req;
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, req->src, true);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_mac_final(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	int idx = 0;
-	int rc = 0;
-	u32 key_size, key_len;
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	gfp_t flags = cc_gfp_flags(&req->base);
-	u32 rem_cnt = *cc_hash_buf_cnt(state);
-
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
-		key_size = CC_AES_128_BIT_KEY_SIZE;
-		key_len  = CC_AES_128_BIT_KEY_SIZE;
-	} else {
-		key_size = (ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
-			ctx->key_params.keylen;
-		key_len =  ctx->key_params.keylen;
-	}
-
-	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -EINVAL;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
-				      req->nbytes, 0, flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_hash_request(dev, state, req->src, true);
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = (void *)cc_hash_complete;
-	cc_req.user_arg = (void *)req;
-
-	if (state->xcbc_count && rem_cnt == 0) {
-		/* Load key for ECB decryption */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
-		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_DECRYPT);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K1_OFFSET),
-			     key_size, NS_BIT);
-		set_key_size_aes(&desc[idx], key_len);
-		set_flow_mode(&desc[idx], S_DIN_to_AES);
-		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-		idx++;
-
-		/* Initiate decryption of block state to previous
-		 * block_state-XOR-M[n]
-		 */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-			     CC_AES_BLOCK_SIZE, NS_BIT);
-		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      CC_AES_BLOCK_SIZE, NS_BIT, 0);
-		set_flow_mode(&desc[idx], DIN_AES_DOUT);
-		idx++;
-
-		/* Memory Barrier: wait for axi write to complete */
-		hw_desc_init(&desc[idx]);
-		set_din_no_dma(&desc[idx], 0, 0xfffff0);
-		set_dout_no_dma(&desc[idx], 0, 0, 1);
-		idx++;
-	}
-
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
-		cc_setup_xcbc(req, desc, &idx);
-	else
-		cc_setup_cmac(req, desc, &idx);
-
-	if (state->xcbc_count == 0) {
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_key_size_aes(&desc[idx], key_len);
-		set_cmac_size0_mode(&desc[idx]);
-		set_flow_mode(&desc[idx], S_DIN_to_AES);
-		idx++;
-	} else if (rem_cnt > 0) {
-		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
-	} else {
-		hw_desc_init(&desc[idx]);
-		set_din_const(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
-		set_flow_mode(&desc[idx], DIN_AES_DOUT);
-		idx++;
-	}
-
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	/* TODO */
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
-		      digestsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_AES_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	idx++;
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, req->src, true);
-		cc_unmap_result(dev, state, digestsize, req->result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_mac_finup(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	int idx = 0;
-	int rc = 0;
-	u32 key_len = 0;
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== finup xcbc(%d) ====\n", req->nbytes);
-	if (state->xcbc_count > 0 && req->nbytes == 0) {
-		dev_dbg(dev, "No data to update. Call to fdx_mac_final\n");
-		return cc_mac_final(req);
-	}
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -EINVAL;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
-				      req->nbytes, 1, flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_hash_request(dev, state, req->src, true);
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = (void *)cc_hash_complete;
-	cc_req.user_arg = (void *)req;
-
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
-		key_len = CC_AES_128_BIT_KEY_SIZE;
-		cc_setup_xcbc(req, desc, &idx);
-	} else {
-		key_len = ctx->key_params.keylen;
-		cc_setup_cmac(req, desc, &idx);
-	}
-
-	if (req->nbytes == 0) {
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_key_size_aes(&desc[idx], key_len);
-		set_cmac_size0_mode(&desc[idx]);
-		set_flow_mode(&desc[idx], S_DIN_to_AES);
-		idx++;
-	} else {
-		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
-	}
-
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	/* TODO */
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
-		      digestsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_AES_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	idx++;
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, req->src, true);
-		cc_unmap_result(dev, state, digestsize, req->result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_mac_digest(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	u32 key_len;
-	int idx = 0;
-	int rc;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
-
-	cc_init_req(dev, state, ctx);
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -ENOMEM;
-	}
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
-				      req->nbytes, 1, flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup DX request structure */
-	cc_req.user_cb = (void *)cc_digest_complete;
-	cc_req.user_arg = (void *)req;
-
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
-		key_len = CC_AES_128_BIT_KEY_SIZE;
-		cc_setup_xcbc(req, desc, &idx);
-	} else {
-		key_len = ctx->key_params.keylen;
-		cc_setup_cmac(req, desc, &idx);
-	}
-
-	if (req->nbytes == 0) {
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_key_size_aes(&desc[idx], key_len);
-		set_cmac_size0_mode(&desc[idx]);
-		set_flow_mode(&desc[idx], S_DIN_to_AES);
-		idx++;
-	} else {
-		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
-	}
-
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
-		      CC_AES_BLOCK_SIZE, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_AES_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	idx++;
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, req->src, true);
-		cc_unmap_result(dev, state, digestsize, req->result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_hash_export(struct ahash_request *req, void *out)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	u8 *curr_buff = cc_hash_buf(state);
-	u32 curr_buff_cnt = *cc_hash_buf_cnt(state);
-	const u32 tmp = CC_EXPORT_MAGIC;
-
-	memcpy(out, &tmp, sizeof(u32));
-	out += sizeof(u32);
-
-	memcpy(out, state->digest_buff, ctx->inter_digestsize);
-	out += ctx->inter_digestsize;
-
-	memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
-	out += HASH_LEN_SIZE;
-
-	memcpy(out, &curr_buff_cnt, sizeof(u32));
-	out += sizeof(u32);
-
-	memcpy(out, curr_buff, curr_buff_cnt);
-
-	return 0;
-}
-
-static int cc_hash_import(struct ahash_request *req, const void *in)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	u32 tmp;
-
-	memcpy(&tmp, in, sizeof(u32));
-	if (tmp != CC_EXPORT_MAGIC)
-		return -EINVAL;
-	in += sizeof(u32);
-
-	cc_init_req(dev, state, ctx);
-
-	memcpy(state->digest_buff, in, ctx->inter_digestsize);
-	in += ctx->inter_digestsize;
-
-	memcpy(state->digest_bytes_len, in, HASH_LEN_SIZE);
-	in += HASH_LEN_SIZE;
-
-	/* Sanity check the data as much as possible */
-	memcpy(&tmp, in, sizeof(u32));
-	if (tmp > CC_MAX_HASH_BLCK_SIZE)
-		return -EINVAL;
-	in += sizeof(u32);
-
-	state->buf_cnt[0] = tmp;
-	memcpy(state->buffers[0], in, tmp);
-
-	return 0;
-}
-
-struct cc_hash_template {
-	char name[CRYPTO_MAX_ALG_NAME];
-	char driver_name[CRYPTO_MAX_ALG_NAME];
-	char mac_name[CRYPTO_MAX_ALG_NAME];
-	char mac_driver_name[CRYPTO_MAX_ALG_NAME];
-	unsigned int blocksize;
-	bool synchronize;
-	struct ahash_alg template_ahash;
-	int hash_mode;
-	int hw_mode;
-	int inter_digestsize;
-	struct cc_drvdata *drvdata;
-};
-
-#define CC_STATE_SIZE(_x) \
-	((_x) + HASH_LEN_SIZE + CC_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
-
-/* hash descriptors */
-static struct cc_hash_template driver_hash[] = {
-	//Asynchronize hash template
-	{
-		.name = "sha1",
-		.driver_name = "sha1-dx",
-		.mac_name = "hmac(sha1)",
-		.mac_driver_name = "hmac-sha1-dx",
-		.blocksize = SHA1_BLOCK_SIZE,
-		.synchronize = false,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_hash_update,
-			.final = cc_hash_final,
-			.finup = cc_hash_finup,
-			.digest = cc_hash_digest,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.setkey = cc_hash_setkey,
-			.halg = {
-				.digestsize = SHA1_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA1_DIGEST_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_SHA1,
-		.hw_mode = DRV_HASH_HW_SHA1,
-		.inter_digestsize = SHA1_DIGEST_SIZE,
-	},
-	{
-		.name = "sha256",
-		.driver_name = "sha256-dx",
-		.mac_name = "hmac(sha256)",
-		.mac_driver_name = "hmac-sha256-dx",
-		.blocksize = SHA256_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_hash_update,
-			.final = cc_hash_final,
-			.finup = cc_hash_finup,
-			.digest = cc_hash_digest,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.setkey = cc_hash_setkey,
-			.halg = {
-				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA256_DIGEST_SIZE)
-			},
-		},
-		.hash_mode = DRV_HASH_SHA256,
-		.hw_mode = DRV_HASH_HW_SHA256,
-		.inter_digestsize = SHA256_DIGEST_SIZE,
-	},
-	{
-		.name = "sha224",
-		.driver_name = "sha224-dx",
-		.mac_name = "hmac(sha224)",
-		.mac_driver_name = "hmac-sha224-dx",
-		.blocksize = SHA224_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_hash_update,
-			.final = cc_hash_final,
-			.finup = cc_hash_finup,
-			.digest = cc_hash_digest,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.setkey = cc_hash_setkey,
-			.halg = {
-				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA224_DIGEST_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_SHA224,
-		.hw_mode = DRV_HASH_HW_SHA256,
-		.inter_digestsize = SHA256_DIGEST_SIZE,
-	},
-#if (CC_DEV_SHA_MAX > 256)
-	{
-		.name = "sha384",
-		.driver_name = "sha384-dx",
-		.mac_name = "hmac(sha384)",
-		.mac_driver_name = "hmac-sha384-dx",
-		.blocksize = SHA384_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_hash_update,
-			.final = cc_hash_final,
-			.finup = cc_hash_finup,
-			.digest = cc_hash_digest,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.setkey = cc_hash_setkey,
-			.halg = {
-				.digestsize = SHA384_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA384_DIGEST_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_SHA384,
-		.hw_mode = DRV_HASH_HW_SHA512,
-		.inter_digestsize = SHA512_DIGEST_SIZE,
-	},
-	{
-		.name = "sha512",
-		.driver_name = "sha512-dx",
-		.mac_name = "hmac(sha512)",
-		.mac_driver_name = "hmac-sha512-dx",
-		.blocksize = SHA512_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_hash_update,
-			.final = cc_hash_final,
-			.finup = cc_hash_finup,
-			.digest = cc_hash_digest,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.setkey = cc_hash_setkey,
-			.halg = {
-				.digestsize = SHA512_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA512_DIGEST_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_SHA512,
-		.hw_mode = DRV_HASH_HW_SHA512,
-		.inter_digestsize = SHA512_DIGEST_SIZE,
-	},
-#endif
-	{
-		.name = "md5",
-		.driver_name = "md5-dx",
-		.mac_name = "hmac(md5)",
-		.mac_driver_name = "hmac-md5-dx",
-		.blocksize = MD5_HMAC_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_hash_update,
-			.final = cc_hash_final,
-			.finup = cc_hash_finup,
-			.digest = cc_hash_digest,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.setkey = cc_hash_setkey,
-			.halg = {
-				.digestsize = MD5_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(MD5_DIGEST_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_MD5,
-		.hw_mode = DRV_HASH_HW_MD5,
-		.inter_digestsize = MD5_DIGEST_SIZE,
-	},
-	{
-		.mac_name = "xcbc(aes)",
-		.mac_driver_name = "xcbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_mac_update,
-			.final = cc_mac_final,
-			.finup = cc_mac_finup,
-			.digest = cc_mac_digest,
-			.setkey = cc_xcbc_setkey,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.halg = {
-				.digestsize = AES_BLOCK_SIZE,
-				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_NULL,
-		.hw_mode = DRV_CIPHER_XCBC_MAC,
-		.inter_digestsize = AES_BLOCK_SIZE,
-	},
-	{
-		.mac_name = "cmac(aes)",
-		.mac_driver_name = "cmac-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_ahash = {
-			.init = cc_hash_init,
-			.update = cc_mac_update,
-			.final = cc_mac_final,
-			.finup = cc_mac_finup,
-			.digest = cc_mac_digest,
-			.setkey = cc_cmac_setkey,
-			.export = cc_hash_export,
-			.import = cc_hash_import,
-			.halg = {
-				.digestsize = AES_BLOCK_SIZE,
-				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
-			},
-		},
-		.hash_mode = DRV_HASH_NULL,
-		.hw_mode = DRV_CIPHER_CMAC,
-		.inter_digestsize = AES_BLOCK_SIZE,
-	},
-};
-
-static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template *template,
-					     struct device *dev, bool keyed)
-{
-	struct cc_hash_alg *t_crypto_alg;
-	struct crypto_alg *alg;
-	struct ahash_alg *halg;
-
-	t_crypto_alg = kzalloc(sizeof(*t_crypto_alg), GFP_KERNEL);
-	if (!t_crypto_alg)
-		return ERR_PTR(-ENOMEM);
-
-	t_crypto_alg->ahash_alg = template->template_ahash;
-	halg = &t_crypto_alg->ahash_alg;
-	alg = &halg->halg.base;
-
-	if (keyed) {
-		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
-			 template->mac_name);
-		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-			 template->mac_driver_name);
-	} else {
-		halg->setkey = NULL;
-		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
-			 template->name);
-		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-			 template->driver_name);
-	}
-	alg->cra_module = THIS_MODULE;
-	alg->cra_ctxsize = sizeof(struct cc_hash_ctx);
-	alg->cra_priority = CC_CRA_PRIO;
-	alg->cra_blocksize = template->blocksize;
-	alg->cra_alignmask = 0;
-	alg->cra_exit = cc_cra_exit;
-
-	alg->cra_init = cc_cra_init;
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_TYPE_AHASH |
-			CRYPTO_ALG_KERN_DRIVER_ONLY;
-	alg->cra_type = &crypto_ahash_type;
-
-	t_crypto_alg->hash_mode = template->hash_mode;
-	t_crypto_alg->hw_mode = template->hw_mode;
-	t_crypto_alg->inter_digestsize = template->inter_digestsize;
-
-	return t_crypto_alg;
-}
-
-int cc_init_hash_sram(struct cc_drvdata *drvdata)
-{
-	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
-	cc_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
-	unsigned int larval_seq_len = 0;
-	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
-	int rc = 0;
-
-	/* Copy-to-sram digest-len */
-	cc_set_sram_desc(digest_len_init, sram_buff_ofs,
-			 ARRAY_SIZE(digest_len_init), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-
-	sram_buff_ofs += sizeof(digest_len_init);
-	larval_seq_len = 0;
-
-#if (CC_DEV_SHA_MAX > 256)
-	/* Copy-to-sram digest-len for sha384/512 */
-	cc_set_sram_desc(digest_len_sha512_init, sram_buff_ofs,
-			 ARRAY_SIZE(digest_len_sha512_init),
-			 larval_seq, &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-
-	sram_buff_ofs += sizeof(digest_len_sha512_init);
-	larval_seq_len = 0;
-#endif
-
-	/* The initial digests offset */
-	hash_handle->larval_digest_sram_addr = sram_buff_ofs;
-
-	/* Copy-to-sram initial SHA* digests */
-	cc_set_sram_desc(md5_init, sram_buff_ofs,
-			 ARRAY_SIZE(md5_init), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-	sram_buff_ofs += sizeof(md5_init);
-	larval_seq_len = 0;
-
-	cc_set_sram_desc(sha1_init, sram_buff_ofs,
-			 ARRAY_SIZE(sha1_init), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-	sram_buff_ofs += sizeof(sha1_init);
-	larval_seq_len = 0;
-
-	cc_set_sram_desc(sha224_init, sram_buff_ofs,
-			 ARRAY_SIZE(sha224_init), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-	sram_buff_ofs += sizeof(sha224_init);
-	larval_seq_len = 0;
-
-	cc_set_sram_desc(sha256_init, sram_buff_ofs,
-			 ARRAY_SIZE(sha256_init), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-	sram_buff_ofs += sizeof(sha256_init);
-	larval_seq_len = 0;
-
-#if (CC_DEV_SHA_MAX > 256)
-	cc_set_sram_desc((u32 *)sha384_init, sram_buff_ofs,
-			 (ARRAY_SIZE(sha384_init) * 2), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-	sram_buff_ofs += sizeof(sha384_init);
-	larval_seq_len = 0;
-
-	cc_set_sram_desc((u32 *)sha512_init, sram_buff_ofs,
-			 (ARRAY_SIZE(sha512_init) * 2), larval_seq,
-			 &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc)
-		goto init_digest_const_err;
-#endif
-
-init_digest_const_err:
-	return rc;
-}
-
-static void __init cc_swap_dwords(u32 *buf, unsigned long size)
-{
-	int i;
-	u32 tmp;
-
-	for (i = 0; i < size; i += 2) {
-		tmp = buf[i];
-		buf[i] = buf[i + 1];
-		buf[i + 1] = tmp;
-	}
-}
-
-/*
- * Due to the way the HW works we need to swap every
- * double word in the SHA384 and SHA512 larval hashes
- */
-void __init cc_hash_global_init(void)
-{
-	cc_swap_dwords((u32 *)&sha384_init, (ARRAY_SIZE(sha384_init) * 2));
-	cc_swap_dwords((u32 *)&sha512_init, (ARRAY_SIZE(sha512_init) * 2));
-}
-
-int cc_hash_alloc(struct cc_drvdata *drvdata)
-{
-	struct cc_hash_handle *hash_handle;
-	cc_sram_addr_t sram_buff;
-	u32 sram_size_to_alloc;
-	struct device *dev = drvdata_to_dev(drvdata);
-	int rc = 0;
-	int alg;
-
-	hash_handle = kzalloc(sizeof(*hash_handle), GFP_KERNEL);
-	if (!hash_handle)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&hash_handle->hash_list);
-	drvdata->hash_handle = hash_handle;
-
-	sram_size_to_alloc = sizeof(digest_len_init) +
-#if (CC_DEV_SHA_MAX > 256)
-			sizeof(digest_len_sha512_init) +
-			sizeof(sha384_init) +
-			sizeof(sha512_init) +
-#endif
-			sizeof(md5_init) +
-			sizeof(sha1_init) +
-			sizeof(sha224_init) +
-			sizeof(sha256_init);
-
-	sram_buff = cc_sram_alloc(drvdata, sram_size_to_alloc);
-	if (sram_buff == NULL_SRAM_ADDR) {
-		dev_err(dev, "SRAM pool exhausted\n");
-		rc = -ENOMEM;
-		goto fail;
-	}
-
-	/* The initial digest-len offset */
-	hash_handle->digest_len_sram_addr = sram_buff;
-
-	/*must be set before the alg registration as it is being used there*/
-	rc = cc_init_hash_sram(drvdata);
-	if (rc) {
-		dev_err(dev, "Init digest CONST failed (rc=%d)\n", rc);
-		goto fail;
-	}
-
-	/* ahash registration */
-	for (alg = 0; alg < ARRAY_SIZE(driver_hash); alg++) {
-		struct cc_hash_alg *t_alg;
-		int hw_mode = driver_hash[alg].hw_mode;
-
-		/* register hmac version */
-		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
-		if (IS_ERR(t_alg)) {
-			rc = PTR_ERR(t_alg);
-			dev_err(dev, "%s alg allocation failed\n",
-				driver_hash[alg].driver_name);
-			goto fail;
-		}
-		t_alg->drvdata = drvdata;
-
-		rc = crypto_register_ahash(&t_alg->ahash_alg);
-		if (rc) {
-			dev_err(dev, "%s alg registration failed\n",
-				driver_hash[alg].driver_name);
-			kfree(t_alg);
-			goto fail;
-		} else {
-			list_add_tail(&t_alg->entry,
-				      &hash_handle->hash_list);
-		}
-
-		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
-		    hw_mode == DRV_CIPHER_CMAC)
-			continue;
-
-		/* register hash version */
-		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, false);
-		if (IS_ERR(t_alg)) {
-			rc = PTR_ERR(t_alg);
-			dev_err(dev, "%s alg allocation failed\n",
-				driver_hash[alg].driver_name);
-			goto fail;
-		}
-		t_alg->drvdata = drvdata;
-
-		rc = crypto_register_ahash(&t_alg->ahash_alg);
-		if (rc) {
-			dev_err(dev, "%s alg registration failed\n",
-				driver_hash[alg].driver_name);
-			kfree(t_alg);
-			goto fail;
-		} else {
-			list_add_tail(&t_alg->entry, &hash_handle->hash_list);
-		}
-	}
-
-	return 0;
-
-fail:
-	kfree(drvdata->hash_handle);
-	drvdata->hash_handle = NULL;
-	return rc;
-}
-
-int cc_hash_free(struct cc_drvdata *drvdata)
-{
-	struct cc_hash_alg *t_hash_alg, *hash_n;
-	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
-
-	if (hash_handle) {
-		list_for_each_entry_safe(t_hash_alg, hash_n,
-					 &hash_handle->hash_list, entry) {
-			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
-			list_del(&t_hash_alg->entry);
-			kfree(t_hash_alg);
-		}
-
-		kfree(hash_handle);
-		drvdata->hash_handle = NULL;
-	}
-	return 0;
-}
-
-static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
-			  unsigned int *seq_size)
-{
-	unsigned int idx = *seq_size;
-	struct ahash_req_ctx *state = ahash_request_ctx(areq);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-
-	/* Setup XCBC MAC K1 */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
-					    XCBC_MAC_K1_OFFSET),
-		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* Setup XCBC MAC K2 */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K2_OFFSET),
-		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* Setup XCBC MAC K3 */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI,
-		     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K3_OFFSET),
-		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* Loading MAC state */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     CC_AES_BLOCK_SIZE, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-	*seq_size = idx;
-}
-
-static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
-			  unsigned int *seq_size)
-{
-	unsigned int idx = *seq_size;
-	struct ahash_req_ctx *state = ahash_request_ctx(areq);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-
-	/* Setup CMAC Key */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
-		     ((ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
-		      ctx->key_params.keylen), NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], ctx->key_params.keylen);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-
-	/* Load MAC state */
-	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     CC_AES_BLOCK_SIZE, NS_BIT);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
-	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	set_key_size_aes(&desc[idx], ctx->key_params.keylen);
-	set_flow_mode(&desc[idx], S_DIN_to_AES);
-	idx++;
-	*seq_size = idx;
-}
-
-static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
-			struct cc_hash_ctx *ctx, unsigned int flow_mode,
-			struct cc_hw_desc desc[], bool is_not_last_data,
-			unsigned int *seq_size)
-{
-	unsigned int idx = *seq_size;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_DLLI) {
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     sg_dma_address(areq_ctx->curr_sg),
-			     areq_ctx->curr_sg->length, NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		idx++;
-	} else {
-		if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
-			dev_dbg(dev, " NULL mode\n");
-			/* nothing to build */
-			return;
-		}
-		/* bypass */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     areq_ctx->mlli_params.mlli_dma_addr,
-			     areq_ctx->mlli_params.mlli_len, NS_BIT);
-		set_dout_sram(&desc[idx], ctx->drvdata->mlli_sram_addr,
-			      areq_ctx->mlli_params.mlli_len);
-		set_flow_mode(&desc[idx], BYPASS);
-		idx++;
-		/* process */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_MLLI,
-			     ctx->drvdata->mlli_sram_addr,
-			     areq_ctx->mlli_nents, NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		idx++;
-	}
-	if (is_not_last_data)
-		set_din_not_last_indication(&desc[(idx - 1)]);
-	/* return updated desc sequence size */
-	*seq_size = idx;
-}
-
-static const void *cc_larval_digest(struct device *dev, u32 mode)
-{
-	switch (mode) {
-	case DRV_HASH_MD5:
-		return md5_init;
-	case DRV_HASH_SHA1:
-		return sha1_init;
-	case DRV_HASH_SHA224:
-		return sha224_init;
-	case DRV_HASH_SHA256:
-		return sha256_init;
-#if (CC_DEV_SHA_MAX > 256)
-	case DRV_HASH_SHA384:
-		return sha384_init;
-	case DRV_HASH_SHA512:
-		return sha512_init;
-#endif
-	default:
-		dev_err(dev, "Invalid hash mode (%d)\n", mode);
-		return md5_init;
-	}
-}
-
-/*!
- * Gets the address of the initial digest in SRAM
- * according to the given hash mode
- *
- * \param drvdata
- * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256
- *
- * \return u32 The address of the initial digest in SRAM
- */
-cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
-{
-	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
-	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
-	struct device *dev = drvdata_to_dev(_drvdata);
-
-	switch (mode) {
-	case DRV_HASH_NULL:
-		break; /*Ignore*/
-	case DRV_HASH_MD5:
-		return (hash_handle->larval_digest_sram_addr);
-	case DRV_HASH_SHA1:
-		return (hash_handle->larval_digest_sram_addr +
-			sizeof(md5_init));
-	case DRV_HASH_SHA224:
-		return (hash_handle->larval_digest_sram_addr +
-			sizeof(md5_init) +
-			sizeof(sha1_init));
-	case DRV_HASH_SHA256:
-		return (hash_handle->larval_digest_sram_addr +
-			sizeof(md5_init) +
-			sizeof(sha1_init) +
-			sizeof(sha224_init));
-#if (CC_DEV_SHA_MAX > 256)
-	case DRV_HASH_SHA384:
-		return (hash_handle->larval_digest_sram_addr +
-			sizeof(md5_init) +
-			sizeof(sha1_init) +
-			sizeof(sha224_init) +
-			sizeof(sha256_init));
-	case DRV_HASH_SHA512:
-		return (hash_handle->larval_digest_sram_addr +
-			sizeof(md5_init) +
-			sizeof(sha1_init) +
-			sizeof(sha224_init) +
-			sizeof(sha256_init) +
-			sizeof(sha384_init));
-#endif
-	default:
-		dev_err(dev, "Invalid hash mode (%d)\n", mode);
-	}
-
-	/*This is valid wrong value to avoid kernel crash*/
-	return hash_handle->larval_digest_sram_addr;
-}
-
-cc_sram_addr_t
-cc_digest_len_addr(void *drvdata, u32 mode)
-{
-	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
-	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
-	cc_sram_addr_t digest_len_addr = hash_handle->digest_len_sram_addr;
-
-	switch (mode) {
-	case DRV_HASH_SHA1:
-	case DRV_HASH_SHA224:
-	case DRV_HASH_SHA256:
-	case DRV_HASH_MD5:
-		return digest_len_addr;
-#if (CC_DEV_SHA_MAX > 256)
-	case DRV_HASH_SHA384:
-	case DRV_HASH_SHA512:
-		return  digest_len_addr + sizeof(digest_len_init);
-#endif
-	default:
-		return digest_len_addr; /*to avoid kernel crash*/
-	}
-}
-
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
deleted file mode 100644
index e45bb69..0000000
--- a/drivers/staging/ccree/ssi_hash.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file ssi_hash.h
- * ARM CryptoCell Hash Crypto API
- */
-
-#ifndef __CC_HASH_H__
-#define __CC_HASH_H__
-
-#include "ssi_buffer_mgr.h"
-
-#define HMAC_IPAD_CONST	0x36363636
-#define HMAC_OPAD_CONST	0x5C5C5C5C
-#if (CC_DEV_SHA_MAX > 256)
-#define HASH_LEN_SIZE 16
-#define CC_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
-#define CC_MAX_HASH_BLCK_SIZE SHA512_BLOCK_SIZE
-#else
-#define HASH_LEN_SIZE 8
-#define CC_MAX_HASH_DIGEST_SIZE	SHA256_DIGEST_SIZE
-#define CC_MAX_HASH_BLCK_SIZE SHA256_BLOCK_SIZE
-#endif
-
-#define XCBC_MAC_K1_OFFSET 0
-#define XCBC_MAC_K2_OFFSET 16
-#define XCBC_MAC_K3_OFFSET 32
-
-#define CC_EXPORT_MAGIC 0xC2EE1070U
-
-/* this struct was taken from drivers/crypto/nx/nx-aes-xcbc.c and it is used
- * for xcbc/cmac statesize
- */
-struct aeshash_state {
-	u8 state[AES_BLOCK_SIZE];
-	unsigned int count;
-	u8 buffer[AES_BLOCK_SIZE];
-};
-
-/* ahash state */
-struct ahash_req_ctx {
-	u8 buffers[2][CC_MAX_HASH_BLCK_SIZE] ____cacheline_aligned;
-	u8 digest_result_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
-	u8 digest_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
-	u8 opad_digest_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
-	u8 digest_bytes_len[HASH_LEN_SIZE] ____cacheline_aligned;
-	struct async_gen_req_ctx gen_ctx ____cacheline_aligned;
-	enum cc_req_dma_buf_type data_dma_buf_type;
-	dma_addr_t opad_digest_dma_addr;
-	dma_addr_t digest_buff_dma_addr;
-	dma_addr_t digest_bytes_len_dma_addr;
-	dma_addr_t digest_result_dma_addr;
-	u32 buf_cnt[2];
-	u32 buff_index;
-	u32 xcbc_count; /* count xcbc update operatations */
-	struct scatterlist buff_sg[2];
-	struct scatterlist *curr_sg;
-	u32 in_nents;
-	u32 mlli_nents;
-	struct mlli_params mlli_params;
-};
-
-static inline u32 *cc_hash_buf_cnt(struct ahash_req_ctx *state)
-{
-	return &state->buf_cnt[state->buff_index];
-}
-
-static inline u8 *cc_hash_buf(struct ahash_req_ctx *state)
-{
-	return state->buffers[state->buff_index];
-}
-
-static inline u32 *cc_next_buf_cnt(struct ahash_req_ctx *state)
-{
-	return &state->buf_cnt[state->buff_index ^ 1];
-}
-
-static inline u8 *cc_next_buf(struct ahash_req_ctx *state)
-{
-	return state->buffers[state->buff_index ^ 1];
-}
-
-int cc_hash_alloc(struct cc_drvdata *drvdata);
-int cc_init_hash_sram(struct cc_drvdata *drvdata);
-int cc_hash_free(struct cc_drvdata *drvdata);
-
-/*!
- * Gets the initial digest length
- *
- * \param drvdata
- * \param mode The Hash mode. Supported modes:
- *             MD5/SHA1/SHA224/SHA256/SHA384/SHA512
- *
- * \return u32 returns the address of the initial digest length in SRAM
- */
-cc_sram_addr_t
-cc_digest_len_addr(void *drvdata, u32 mode);
-
-/*!
- * Gets the address of the initial digest in SRAM
- * according to the given hash mode
- *
- * \param drvdata
- * \param mode The Hash mode. Supported modes:
- *             MD5/SHA1/SHA224/SHA256/SHA384/SHA512
- *
- * \return u32 The address of the initial digest in SRAM
- */
-cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
-
-void cc_hash_global_init(void);
-
-#endif /*__CC_HASH_H__*/
-
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
deleted file mode 100644
index 2ba15a5..0000000
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ /dev/null
@@ -1,281 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/platform_device.h>
-#include <crypto/ctr.h>
-#include "ssi_driver.h"
-#include "ssi_ivgen.h"
-#include "ssi_request_mgr.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_buffer_mgr.h"
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
- * This function should be invoked when resuming DX driver.
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
-
-	/* release "this" context */
-	kfree(ivgen_ctx);
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
-	ivgen_ctx = kzalloc(sizeof(*ivgen_ctx), GFP_KERNEL);
-	if (!ivgen_ctx)
-		return -ENOMEM;
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
-	drvdata->ivgen_handle = ivgen_ctx;
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
-
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
deleted file mode 100644
index b6ac169..0000000
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
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
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
deleted file mode 100644
index 3a8d91c..0000000
--- a/drivers/staging/ccree/ssi_pm.c
+++ /dev/null
@@ -1,125 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <crypto/ctr.h>
-#include <linux/pm_runtime.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_request_mgr.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_ivgen.h"
-#include "ssi_hash.h"
-#include "ssi_pm.h"
-
-#define POWER_DOWN_ENABLE 0x01
-#define POWER_DOWN_DISABLE 0x00
-
-const struct dev_pm_ops ccree_pm = {
-	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
-};
-
-int cc_pm_suspend(struct device *dev)
-{
-	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	int rc;
-
-	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
-	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
-	rc = cc_suspend_req_queue(drvdata);
-	if (rc) {
-		dev_err(dev, "cc_suspend_req_queue (%x)\n",
-			rc);
-		return rc;
-	}
-	fini_cc_regs(drvdata);
-	cc_clk_off(drvdata);
-	return 0;
-}
-
-int cc_pm_resume(struct device *dev)
-{
-	int rc;
-	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-
-	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
-	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
-
-	rc = cc_clk_on(drvdata);
-	if (rc) {
-		dev_err(dev, "failed getting clock back on. We're toast.\n");
-		return rc;
-	}
-
-	rc = init_cc_regs(drvdata, false);
-	if (rc) {
-		dev_err(dev, "init_cc_regs (%x)\n", rc);
-		return rc;
-	}
-
-	rc = cc_resume_req_queue(drvdata);
-	if (rc) {
-		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
-		return rc;
-	}
-
-	/* must be after the queue resuming as it uses the HW queue*/
-	cc_init_hash_sram(drvdata);
-
-	cc_init_iv_sram(drvdata);
-	return 0;
-}
-
-int cc_pm_get(struct device *dev)
-{
-	int rc = 0;
-	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-
-	if (cc_req_queue_suspended(drvdata))
-		rc = pm_runtime_get_sync(dev);
-	else
-		pm_runtime_get_noresume(dev);
-
-	return rc;
-}
-
-int cc_pm_put_suspend(struct device *dev)
-{
-	int rc = 0;
-	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-
-	if (!cc_req_queue_suspended(drvdata)) {
-		pm_runtime_mark_last_busy(dev);
-		rc = pm_runtime_put_autosuspend(dev);
-	} else {
-		/* Something wrong happens*/
-		dev_err(dev, "request to suspend already suspended queue");
-		rc = -EBUSY;
-	}
-	return rc;
-}
-
-int cc_pm_init(struct cc_drvdata *drvdata)
-{
-	int rc = 0;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	/* must be before the enabling to avoid resdundent suspending */
-	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
-	pm_runtime_use_autosuspend(dev);
-	/* activate the PM module */
-	rc = pm_runtime_set_active(dev);
-	if (rc)
-		return rc;
-	/* enable the PM module*/
-	pm_runtime_enable(dev);
-
-	return rc;
-}
-
-void cc_pm_fini(struct cc_drvdata *drvdata)
-{
-	pm_runtime_disable(drvdata_to_dev(drvdata));
-}
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
deleted file mode 100644
index f603255..0000000
--- a/drivers/staging/ccree/ssi_pm.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file ssi_pm.h
- */
-
-#ifndef __CC_POWER_MGR_H__
-#define __CC_POWER_MGR_H__
-
-#include "ssi_driver.h"
-
-#define CC_SUSPEND_TIMEOUT 3000
-
-#if defined(CONFIG_PM)
-
-extern const struct dev_pm_ops ccree_pm;
-
-int cc_pm_init(struct cc_drvdata *drvdata);
-void cc_pm_fini(struct cc_drvdata *drvdata);
-int cc_pm_suspend(struct device *dev);
-int cc_pm_resume(struct device *dev);
-int cc_pm_get(struct device *dev);
-int cc_pm_put_suspend(struct device *dev);
-
-#else
-
-static inline int cc_pm_init(struct cc_drvdata *drvdata)
-{
-	return 0;
-}
-
-static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
-
-static inline int cc_pm_suspend(struct device *dev)
-{
-	return 0;
-}
-
-static inline int cc_pm_resume(struct device *dev)
-{
-	return 0;
-}
-
-static inline int cc_pm_get(struct device *dev)
-{
-	return 0;
-}
-
-static inline int cc_pm_put_suspend(struct device *dev)
-{
-	return 0;
-}
-
-#endif
-
-#endif /*__POWER_MGR_H__*/
-
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
deleted file mode 100644
index dc3be29..0000000
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ /dev/null
@@ -1,719 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <crypto/ctr.h>
-#include <linux/pm_runtime.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_request_mgr.h"
-#include "ssi_ivgen.h"
-#include "ssi_pm.h"
-
-#define CC_MAX_POLL_ITER	10
-/* The highest descriptor count in used */
-#define CC_MAX_DESC_SEQ_LEN	23
-
-struct cc_req_mgr_handle {
-	/* Request manager resources */
-	unsigned int hw_queue_size; /* HW capability */
-	unsigned int min_free_hw_slots;
-	unsigned int max_used_sw_slots;
-	struct cc_crypto_req req_queue[MAX_REQUEST_QUEUE_SIZE];
-	u32 req_queue_head;
-	u32 req_queue_tail;
-	u32 axi_completed;
-	u32 q_free_slots;
-	/* This lock protects access to HW register
-	 * that must be single request at a time
-	 */
-	spinlock_t hw_lock;
-	struct cc_hw_desc compl_desc;
-	u8 *dummy_comp_buff;
-	dma_addr_t dummy_comp_buff_dma;
-
-	/* backlog queue */
-	struct list_head backlog;
-	unsigned int bl_len;
-	spinlock_t bl_lock; /* protect backlog queue */
-
-#ifdef COMP_IN_WQ
-	struct workqueue_struct *workq;
-	struct delayed_work compwork;
-#else
-	struct tasklet_struct comptask;
-#endif
-	bool is_runtime_suspended;
-};
-
-struct cc_bl_item {
-	struct cc_crypto_req creq;
-	struct cc_hw_desc desc[CC_MAX_DESC_SEQ_LEN];
-	unsigned int len;
-	struct list_head list;
-	bool notif;
-};
-
-static void comp_handler(unsigned long devarg);
-#ifdef COMP_IN_WQ
-static void comp_work_handler(struct work_struct *work);
-#endif
-
-void cc_req_mgr_fini(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	if (!req_mgr_h)
-		return; /* Not allocated */
-
-	if (req_mgr_h->dummy_comp_buff_dma) {
-		dma_free_coherent(dev, sizeof(u32), req_mgr_h->dummy_comp_buff,
-				  req_mgr_h->dummy_comp_buff_dma);
-	}
-
-	dev_dbg(dev, "max_used_hw_slots=%d\n", (req_mgr_h->hw_queue_size -
-						req_mgr_h->min_free_hw_slots));
-	dev_dbg(dev, "max_used_sw_slots=%d\n", req_mgr_h->max_used_sw_slots);
-
-#ifdef COMP_IN_WQ
-	flush_workqueue(req_mgr_h->workq);
-	destroy_workqueue(req_mgr_h->workq);
-#else
-	/* Kill tasklet */
-	tasklet_kill(&req_mgr_h->comptask);
-#endif
-	memset(req_mgr_h, 0, sizeof(struct cc_req_mgr_handle));
-	kfree(req_mgr_h);
-	drvdata->request_mgr_handle = NULL;
-}
-
-int cc_req_mgr_init(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *req_mgr_h;
-	struct device *dev = drvdata_to_dev(drvdata);
-	int rc = 0;
-
-	req_mgr_h = kzalloc(sizeof(*req_mgr_h), GFP_KERNEL);
-	if (!req_mgr_h) {
-		rc = -ENOMEM;
-		goto req_mgr_init_err;
-	}
-
-	drvdata->request_mgr_handle = req_mgr_h;
-
-	spin_lock_init(&req_mgr_h->hw_lock);
-	spin_lock_init(&req_mgr_h->bl_lock);
-	INIT_LIST_HEAD(&req_mgr_h->backlog);
-
-#ifdef COMP_IN_WQ
-	dev_dbg(dev, "Initializing completion workqueue\n");
-	req_mgr_h->workq = create_singlethread_workqueue("arm_cc7x_wq");
-	if (!req_mgr_h->workq) {
-		dev_err(dev, "Failed creating work queue\n");
-		rc = -ENOMEM;
-		goto req_mgr_init_err;
-	}
-	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
-#else
-	dev_dbg(dev, "Initializing completion tasklet\n");
-	tasklet_init(&req_mgr_h->comptask, comp_handler,
-		     (unsigned long)drvdata);
-#endif
-	req_mgr_h->hw_queue_size = cc_ioread(drvdata,
-					     CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
-	dev_dbg(dev, "hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
-	if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
-		dev_err(dev, "Invalid HW queue size = %u (Min. required is %u)\n",
-			req_mgr_h->hw_queue_size, MIN_HW_QUEUE_SIZE);
-		rc = -ENOMEM;
-		goto req_mgr_init_err;
-	}
-	req_mgr_h->min_free_hw_slots = req_mgr_h->hw_queue_size;
-	req_mgr_h->max_used_sw_slots = 0;
-
-	/* Allocate DMA word for "dummy" completion descriptor use */
-	req_mgr_h->dummy_comp_buff =
-		dma_alloc_coherent(dev, sizeof(u32),
-				   &req_mgr_h->dummy_comp_buff_dma,
-				   GFP_KERNEL);
-	if (!req_mgr_h->dummy_comp_buff) {
-		dev_err(dev, "Not enough memory to allocate DMA (%zu) dropped buffer\n",
-			sizeof(u32));
-		rc = -ENOMEM;
-		goto req_mgr_init_err;
-	}
-
-	/* Init. "dummy" completion descriptor */
-	hw_desc_init(&req_mgr_h->compl_desc);
-	set_din_const(&req_mgr_h->compl_desc, 0, sizeof(u32));
-	set_dout_dlli(&req_mgr_h->compl_desc, req_mgr_h->dummy_comp_buff_dma,
-		      sizeof(u32), NS_BIT, 1);
-	set_flow_mode(&req_mgr_h->compl_desc, BYPASS);
-	set_queue_last_ind(&req_mgr_h->compl_desc);
-
-	return 0;
-
-req_mgr_init_err:
-	cc_req_mgr_fini(drvdata);
-	return rc;
-}
-
-static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
-			unsigned int seq_len)
-{
-	int i, w;
-	void __iomem *reg = drvdata->cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	/*
-	 * We do indeed write all 6 command words to the same
-	 * register. The HW supports this.
-	 */
-
-	for (i = 0; i < seq_len; i++) {
-		for (w = 0; w <= 5; w++)
-			writel_relaxed(seq[i].word[w], reg);
-
-		if (cc_dump_desc)
-			dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
-				i, seq[i].word[0], seq[i].word[1],
-				seq[i].word[2], seq[i].word[3],
-				seq[i].word[4], seq[i].word[5]);
-	}
-}
-
-/*!
- * Completion will take place if and only if user requested completion
- * by cc_send_sync_request().
- *
- * \param dev
- * \param dx_compl_h The completion event to signal
- */
-static void request_mgr_complete(struct device *dev, void *dx_compl_h,
-				 int dummy)
-{
-	struct completion *this_compl = dx_compl_h;
-
-	complete(this_compl);
-}
-
-static int cc_queues_status(struct cc_drvdata *drvdata,
-			    struct cc_req_mgr_handle *req_mgr_h,
-			    unsigned int total_seq_len)
-{
-	unsigned long poll_queue;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	/* SW queue is checked only once as it will not
-	 * be chaned during the poll because the spinlock_bh
-	 * is held by the thread
-	 */
-	if (((req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1)) ==
-	    req_mgr_h->req_queue_tail) {
-		dev_err(dev, "SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n",
-			req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
-		return -ENOSPC;
-	}
-
-	if (req_mgr_h->q_free_slots >= total_seq_len)
-		return 0;
-
-	/* Wait for space in HW queue. Poll constant num of iterations. */
-	for (poll_queue = 0; poll_queue < CC_MAX_POLL_ITER ; poll_queue++) {
-		req_mgr_h->q_free_slots =
-			cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots)
-			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
-
-		if (req_mgr_h->q_free_slots >= total_seq_len) {
-			/* If there is enough place return */
-			return 0;
-		}
-
-		dev_dbg(dev, "HW FIFO is full. q_free_slots=%d total_seq_len=%d\n",
-			req_mgr_h->q_free_slots, total_seq_len);
-	}
-	/* No room in the HW queue try again later */
-	dev_dbg(dev, "HW FIFO full, timeout. req_queue_head=%d sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n",
-		req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE,
-		req_mgr_h->q_free_slots, total_seq_len);
-	return -ENOSPC;
-}
-
-/*!
- * Enqueue caller request to crypto hardware.
- * Need to be called with HW lock held and PM running
- *
- * \param drvdata
- * \param cc_req The request to enqueue
- * \param desc The crypto sequence
- * \param len The crypto sequence length
- * \param add_comp If "true": add an artificial dout DMA to mark completion
- *
- * \return int Returns -EINPROGRESS or error code
- */
-static int cc_do_send_request(struct cc_drvdata *drvdata,
-			      struct cc_crypto_req *cc_req,
-			      struct cc_hw_desc *desc, unsigned int len,
-				bool add_comp, bool ivgen)
-{
-	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
-	unsigned int used_sw_slots;
-	unsigned int iv_seq_len = 0;
-	unsigned int total_seq_len = len; /*initial sequence length*/
-	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
-	struct device *dev = drvdata_to_dev(drvdata);
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
-			       cc_req->ivgen_size,
-			       iv_seq, &iv_seq_len);
-
-		if (rc) {
-			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
-			return rc;
-		}
-
-		total_seq_len += iv_seq_len;
-	}
-
-	used_sw_slots = ((req_mgr_h->req_queue_head -
-			  req_mgr_h->req_queue_tail) &
-			 (MAX_REQUEST_QUEUE_SIZE - 1));
-	if (used_sw_slots > req_mgr_h->max_used_sw_slots)
-		req_mgr_h->max_used_sw_slots = used_sw_slots;
-
-	/* Enqueue request - must be locked with HW lock*/
-	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *cc_req;
-	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) &
-				    (MAX_REQUEST_QUEUE_SIZE - 1);
-	/* TODO: Use circ_buf.h ? */
-
-	dev_dbg(dev, "Enqueue request head=%u\n", req_mgr_h->req_queue_head);
-
-	/*
-	 * We are about to push command to the HW via the command registers
-	 * that may refernece hsot memory. We need to issue a memory barrier
-	 * to make sure there are no outstnading memory writes
-	 */
-	wmb();
-
-	/* STAT_PHASE_4: Push sequence */
-	if (ivgen)
-		enqueue_seq(drvdata, iv_seq, iv_seq_len);
-
-	enqueue_seq(drvdata, desc, len);
-
-	if (add_comp) {
-		enqueue_seq(drvdata, &req_mgr_h->compl_desc, 1);
-		total_seq_len++;
-	}
-
-	if (req_mgr_h->q_free_slots < total_seq_len) {
-		/* This situation should never occur. Maybe indicating problem
-		 * with resuming power. Set the free slot count to 0 and hope
-		 * for the best.
-		 */
-		dev_err(dev, "HW free slot count mismatch.");
-		req_mgr_h->q_free_slots = 0;
-	} else {
-		/* Update the free slots in HW queue */
-		req_mgr_h->q_free_slots -= total_seq_len;
-	}
-
-	/* Operation still in process */
-	return -EINPROGRESS;
-}
-
-static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
-			       struct cc_bl_item *bli)
-{
-	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
-
-	spin_lock_bh(&mgr->bl_lock);
-	list_add_tail(&bli->list, &mgr->backlog);
-	++mgr->bl_len;
-	spin_unlock_bh(&mgr->bl_lock);
-	tasklet_schedule(&mgr->comptask);
-}
-
-static void cc_proc_backlog(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
-	struct cc_bl_item *bli;
-	struct cc_crypto_req *creq;
-	struct crypto_async_request *req;
-	bool ivgen;
-	unsigned int total_len;
-	struct device *dev = drvdata_to_dev(drvdata);
-	int rc;
-
-	spin_lock(&mgr->bl_lock);
-
-	while (mgr->bl_len) {
-		bli = list_first_entry(&mgr->backlog, struct cc_bl_item, list);
-		spin_unlock(&mgr->bl_lock);
-
-		creq = &bli->creq;
-		req = (struct crypto_async_request *)creq->user_arg;
-
-		/*
-		 * Notify the request we're moving out of the backlog
-		 * but only if we haven't done so already.
-		 */
-		if (!bli->notif) {
-			req->complete(req, -EINPROGRESS);
-			bli->notif = true;
-		}
-
-		ivgen = !!creq->ivgen_dma_addr_len;
-		total_len = bli->len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
-
-		spin_lock(&mgr->hw_lock);
-
-		rc = cc_queues_status(drvdata, mgr, total_len);
-		if (rc) {
-			/*
-			 * There is still not room in the FIFO for
-			 * this request. Bail out. We'll return here
-			 * on the next completion irq.
-			 */
-			spin_unlock(&mgr->hw_lock);
-			return;
-		}
-
-		rc = cc_do_send_request(drvdata, &bli->creq, bli->desc,
-					bli->len, false, ivgen);
-
-		spin_unlock(&mgr->hw_lock);
-
-		if (rc != -EINPROGRESS) {
-			cc_pm_put_suspend(dev);
-			creq->user_cb(dev, req, rc);
-		}
-
-		/* Remove ourselves from the backlog list */
-		spin_lock(&mgr->bl_lock);
-		list_del(&bli->list);
-		--mgr->bl_len;
-	}
-
-	spin_unlock(&mgr->bl_lock);
-}
-
-int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
-		    struct cc_hw_desc *desc, unsigned int len,
-		    struct crypto_async_request *req)
-{
-	int rc;
-	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
-	bool ivgen = !!cc_req->ivgen_dma_addr_len;
-	unsigned int total_len = len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
-	struct device *dev = drvdata_to_dev(drvdata);
-	bool backlog_ok = req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG;
-	gfp_t flags = cc_gfp_flags(req);
-	struct cc_bl_item *bli;
-
-	rc = cc_pm_get(dev);
-	if (rc) {
-		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
-		return rc;
-	}
-
-	spin_lock_bh(&mgr->hw_lock);
-	rc = cc_queues_status(drvdata, mgr, total_len);
-
-#ifdef CC_DEBUG_FORCE_BACKLOG
-	if (backlog_ok)
-		rc = -ENOSPC;
-#endif /* CC_DEBUG_FORCE_BACKLOG */
-
-	if (rc == -ENOSPC && backlog_ok) {
-		spin_unlock_bh(&mgr->hw_lock);
-
-		bli = kmalloc(sizeof(*bli), flags);
-		if (!bli) {
-			cc_pm_put_suspend(dev);
-			return -ENOMEM;
-		}
-
-		memcpy(&bli->creq, cc_req, sizeof(*cc_req));
-		memcpy(&bli->desc, desc, len * sizeof(*desc));
-		bli->len = len;
-		bli->notif = false;
-		cc_enqueue_backlog(drvdata, bli);
-		return -EBUSY;
-	}
-
-	if (!rc)
-		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
-					ivgen);
-
-	spin_unlock_bh(&mgr->hw_lock);
-	return rc;
-}
-
-int cc_send_sync_request(struct cc_drvdata *drvdata,
-			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
-			 unsigned int len)
-{
-	int rc;
-	struct device *dev = drvdata_to_dev(drvdata);
-	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
-
-	init_completion(&cc_req->seq_compl);
-	cc_req->user_cb = request_mgr_complete;
-	cc_req->user_arg = &cc_req->seq_compl;
-
-	rc = cc_pm_get(dev);
-	if (rc) {
-		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
-		return rc;
-	}
-
-	while (true) {
-		spin_lock_bh(&mgr->hw_lock);
-		rc = cc_queues_status(drvdata, mgr, len + 1);
-
-		if (!rc)
-			break;
-
-		spin_unlock_bh(&mgr->hw_lock);
-		if (rc != -EAGAIN) {
-			cc_pm_put_suspend(dev);
-			return rc;
-		}
-		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
-		reinit_completion(&drvdata->hw_queue_avail);
-	}
-
-	rc = cc_do_send_request(drvdata, cc_req, desc, len, true, false);
-	spin_unlock_bh(&mgr->hw_lock);
-
-	if (rc != -EINPROGRESS) {
-		cc_pm_put_suspend(dev);
-		return rc;
-	}
-
-	wait_for_completion(&cc_req->seq_compl);
-	return 0;
-}
-
-/*!
- * Enqueue caller request to crypto hardware during init process.
- * assume this function is not called in middle of a flow,
- * since we set QUEUE_LAST_IND flag in the last descriptor.
- *
- * \param drvdata
- * \param desc The crypto sequence
- * \param len The crypto sequence length
- *
- * \return int Returns "0" upon success
- */
-int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
-		      unsigned int len)
-{
-	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
-	unsigned int total_seq_len = len; /*initial sequence length*/
-	int rc = 0;
-
-	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT.
-	 */
-	rc = cc_queues_status(drvdata, req_mgr_h, total_seq_len);
-	if (rc)
-		return rc;
-
-	set_queue_last_ind(&desc[(len - 1)]);
-
-	/*
-	 * We are about to push command to the HW via the command registers
-	 * that may refernece hsot memory. We need to issue a memory barrier
-	 * to make sure there are no outstnading memory writes
-	 */
-	wmb();
-	enqueue_seq(drvdata, desc, len);
-
-	/* Update the free slots in HW queue */
-	req_mgr_h->q_free_slots =
-		cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-
-	return 0;
-}
-
-void complete_request(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	complete(&drvdata->hw_queue_avail);
-#ifdef COMP_IN_WQ
-	queue_delayed_work(request_mgr_handle->workq,
-			   &request_mgr_handle->compwork, 0);
-#else
-	tasklet_schedule(&request_mgr_handle->comptask);
-#endif
-}
-
-#ifdef COMP_IN_WQ
-static void comp_work_handler(struct work_struct *work)
-{
-	struct cc_drvdata *drvdata =
-		container_of(work, struct cc_drvdata, compwork.work);
-
-	comp_handler((unsigned long)drvdata);
-}
-#endif
-
-static void proc_completions(struct cc_drvdata *drvdata)
-{
-	struct cc_crypto_req *cc_req;
-	struct device *dev = drvdata_to_dev(drvdata);
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-	unsigned int *tail = &request_mgr_handle->req_queue_tail;
-	unsigned int *head = &request_mgr_handle->req_queue_head;
-
-	while (request_mgr_handle->axi_completed) {
-		request_mgr_handle->axi_completed--;
-
-		/* Dequeue request */
-		if (*head == *tail) {
-			/* We are supposed to handle a completion but our
-			 * queue is empty. This is not normal. Return and
-			 * hope for the best.
-			 */
-			dev_err(dev, "Request queue is empty head == tail %u\n",
-				*head);
-			break;
-		}
-
-		cc_req = &request_mgr_handle->req_queue[*tail];
-
-		if (cc_req->user_cb)
-			cc_req->user_cb(dev, cc_req->user_arg, 0);
-		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
-		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
-		dev_dbg(dev, "Request completed. axi_completed=%d\n",
-			request_mgr_handle->axi_completed);
-		cc_pm_put_suspend(dev);
-	}
-}
-
-static inline u32 cc_axi_comp_count(struct cc_drvdata *drvdata)
-{
-	return FIELD_GET(AXIM_MON_COMP_VALUE,
-			 cc_ioread(drvdata, CC_REG(AXIM_MON_COMP)));
-}
-
-/* Deferred service handler, run as interrupt-fired tasklet */
-static void comp_handler(unsigned long devarg)
-{
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	u32 irq;
-
-	irq = (drvdata->irq & CC_COMP_IRQ_MASK);
-
-	if (irq & CC_COMP_IRQ_MASK) {
-		/* To avoid the interrupt from firing as we unmask it,
-		 * we clear it now
-		 */
-		cc_iowrite(drvdata, CC_REG(HOST_ICR), CC_COMP_IRQ_MASK);
-
-		/* Avoid race with above clear: Test completion counter
-		 * once more
-		 */
-		request_mgr_handle->axi_completed +=
-				cc_axi_comp_count(drvdata);
-
-		while (request_mgr_handle->axi_completed) {
-			do {
-				proc_completions(drvdata);
-				/* At this point (after proc_completions()),
-				 * request_mgr_handle->axi_completed is 0.
-				 */
-				request_mgr_handle->axi_completed =
-						cc_axi_comp_count(drvdata);
-			} while (request_mgr_handle->axi_completed > 0);
-
-			cc_iowrite(drvdata, CC_REG(HOST_ICR),
-				   CC_COMP_IRQ_MASK);
-
-			request_mgr_handle->axi_completed +=
-					cc_axi_comp_count(drvdata);
-		}
-	}
-	/* after verifing that there is nothing to do,
-	 * unmask AXI completion interrupt
-	 */
-	cc_iowrite(drvdata, CC_REG(HOST_IMR),
-		   cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~irq);
-
-	cc_proc_backlog(drvdata);
-}
-
-/*
- * resume the queue configuration - no need to take the lock as this happens
- * inside the spin lock protection
- */
-#if defined(CONFIG_PM)
-int cc_resume_req_queue(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-		drvdata->request_mgr_handle;
-
-	spin_lock_bh(&request_mgr_handle->hw_lock);
-	request_mgr_handle->is_runtime_suspended = false;
-	spin_unlock_bh(&request_mgr_handle->hw_lock);
-
-	return 0;
-}
-
-/*
- * suspend the queue configuration. Since it is used for the runtime suspend
- * only verify that the queue can be suspended.
- */
-int cc_suspend_req_queue(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	/* lock the send_request */
-	spin_lock_bh(&request_mgr_handle->hw_lock);
-	if (request_mgr_handle->req_queue_head !=
-	    request_mgr_handle->req_queue_tail) {
-		spin_unlock_bh(&request_mgr_handle->hw_lock);
-		return -EBUSY;
-	}
-	request_mgr_handle->is_runtime_suspended = true;
-	spin_unlock_bh(&request_mgr_handle->hw_lock);
-
-	return 0;
-}
-
-bool cc_req_queue_suspended(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	return	request_mgr_handle->is_runtime_suspended;
-}
-
-#endif
-
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
deleted file mode 100644
index f11a26a..0000000
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-/* \file request_mgr.h
- * Request Manager
- */
-
-#ifndef __REQUEST_MGR_H__
-#define __REQUEST_MGR_H__
-
-#include "cc_hw_queue_defs.h"
-
-int cc_req_mgr_init(struct cc_drvdata *drvdata);
-
-/*!
- * Enqueue caller request to crypto hardware.
- *
- * \param drvdata
- * \param cc_req The request to enqueue
- * \param desc The crypto sequence
- * \param len The crypto sequence length
- * \param is_dout If "true": completion is handled by the caller
- *	  If "false": this function adds a dummy descriptor completion
- *	  and waits upon completion signal.
- *
- * \return int Returns -EINPROGRESS or error
- */
-int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
-		    struct cc_hw_desc *desc, unsigned int len,
-		    struct crypto_async_request *req);
-
-int cc_send_sync_request(struct cc_drvdata *drvdata,
-			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
-			 unsigned int len);
-
-int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
-		      unsigned int len);
-
-void complete_request(struct cc_drvdata *drvdata);
-
-void cc_req_mgr_fini(struct cc_drvdata *drvdata);
-
-#if defined(CONFIG_PM)
-int cc_resume_req_queue(struct cc_drvdata *drvdata);
-
-int cc_suspend_req_queue(struct cc_drvdata *drvdata);
-
-bool cc_req_queue_suspended(struct cc_drvdata *drvdata);
-#endif
-
-#endif /*__REQUEST_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
deleted file mode 100644
index c5497aa..0000000
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ /dev/null
@@ -1,107 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#include "ssi_driver.h"
-#include "ssi_sram_mgr.h"
-
-/**
- * struct cc_sram_ctx -Internal RAM context manager
- * @sram_free_offset:   the offset to the non-allocated area
- */
-struct cc_sram_ctx {
-	cc_sram_addr_t sram_free_offset;
-};
-
-/**
- * cc_sram_mgr_fini() - Cleanup SRAM pool.
- *
- * @drvdata: Associated device driver context
- */
-void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
-{
-	/* Free "this" context */
-	kfree(drvdata->sram_mgr_handle);
-}
-
-/**
- * cc_sram_mgr_init() - Initializes SRAM pool.
- *      The pool starts right at the beginning of SRAM.
- *      Returns zero for success, negative value otherwise.
- *
- * @drvdata: Associated device driver context
- */
-int cc_sram_mgr_init(struct cc_drvdata *drvdata)
-{
-	struct cc_sram_ctx *ctx;
-
-	/* Allocate "this" context */
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-
-	if (!ctx)
-		return -ENOMEM;
-
-	drvdata->sram_mgr_handle = ctx;
-
-	return 0;
-}
-
-/*!
- * Allocated buffer from SRAM pool.
- * Note: Caller is responsible to free the LAST allocated buffer.
- * This function does not taking care of any fragmentation may occur
- * by the order of calls to alloc/free.
- *
- * \param drvdata
- * \param size The requested bytes to allocate
- */
-cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size)
-{
-	struct cc_sram_ctx *smgr_ctx = drvdata->sram_mgr_handle;
-	struct device *dev = drvdata_to_dev(drvdata);
-	cc_sram_addr_t p;
-
-	if ((size & 0x3)) {
-		dev_err(dev, "Requested buffer size (%u) is not multiple of 4",
-			size);
-		return NULL_SRAM_ADDR;
-	}
-	if (size > (CC_CC_SRAM_SIZE - smgr_ctx->sram_free_offset)) {
-		dev_err(dev, "Not enough space to allocate %u B (at offset %llu)\n",
-			size, smgr_ctx->sram_free_offset);
-		return NULL_SRAM_ADDR;
-	}
-
-	p = smgr_ctx->sram_free_offset;
-	smgr_ctx->sram_free_offset += size;
-	dev_dbg(dev, "Allocated %u B @ %u\n", size, (unsigned int)p);
-	return p;
-}
-
-/**
- * cc_set_sram_desc() - Create const descriptors sequence to
- *	set values in given array into SRAM.
- * Note: each const value can't exceed word size.
- *
- * @src:	  A pointer to array of words to set as consts.
- * @dst:	  The target SRAM buffer to set into
- * @nelements:	  The number of words in "src" array
- * @seq:	  A pointer to the given IN/OUT descriptor sequence
- * @seq_len:	  A pointer to the given IN/OUT sequence length
- */
-void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
-		      unsigned int nelement, struct cc_hw_desc *seq,
-		      unsigned int *seq_len)
-{
-	u32 i;
-	unsigned int idx = *seq_len;
-
-	for (i = 0; i < nelement; i++, idx++) {
-		hw_desc_init(&seq[idx]);
-		set_din_const(&seq[idx], src[i], sizeof(u32));
-		set_dout_sram(&seq[idx], dst + (i * sizeof(u32)), sizeof(u32));
-		set_flow_mode(&seq[idx], BYPASS);
-	}
-
-	*seq_len = idx;
-}
-
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
deleted file mode 100644
index d48649f..0000000
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ /dev/null
@@ -1,65 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#ifndef __CC_SRAM_MGR_H__
-#define __CC_SRAM_MGR_H__
-
-#ifndef CC_CC_SRAM_SIZE
-#define CC_CC_SRAM_SIZE 4096
-#endif
-
-struct cc_drvdata;
-
-/**
- * Address (offset) within CC internal SRAM
- */
-
-typedef u64 cc_sram_addr_t;
-
-#define NULL_SRAM_ADDR ((cc_sram_addr_t)-1)
-
-/*!
- * Initializes SRAM pool.
- * The first X bytes of SRAM are reserved for ROM usage, hence, pool
- * starts right after X bytes.
- *
- * \param drvdata
- *
- * \return int Zero for success, negative value otherwise.
- */
-int cc_sram_mgr_init(struct cc_drvdata *drvdata);
-
-/*!
- * Uninits SRAM pool.
- *
- * \param drvdata
- */
-void cc_sram_mgr_fini(struct cc_drvdata *drvdata);
-
-/*!
- * Allocated buffer from SRAM pool.
- * Note: Caller is responsible to free the LAST allocated buffer.
- * This function does not taking care of any fragmentation may occur
- * by the order of calls to alloc/free.
- *
- * \param drvdata
- * \param size The requested bytes to allocate
- */
-cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size);
-
-/**
- * cc_set_sram_desc() - Create const descriptors sequence to
- *	set values in given array into SRAM.
- * Note: each const value can't exceed word size.
- *
- * @src:	  A pointer to array of words to set as consts.
- * @dst:	  The target SRAM buffer to set into
- * @nelements:	  The number of words in "src" array
- * @seq:	  A pointer to the given IN/OUT descriptor sequence
- * @seq_len:	  A pointer to the given IN/OUT sequence length
- */
-void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
-		      unsigned int nelement, struct cc_hw_desc *seq,
-		      unsigned int *seq_len);
-
-#endif /*__CC_SRAM_MGR_H__*/
-- 
2.7.4
