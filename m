From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Thu, 20 Apr 2017 16:13:00 +0300
Message-ID: <1492693983-8175-7-git-send-email-gilad@benyossef.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, gilad.benyossef@arm.com,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add FIPS mode support to CryptoCell driver

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig           |    9 +
 drivers/staging/ccree/Makefile          |    1 +
 drivers/staging/ccree/ssi_aead.c        |    6 +
 drivers/staging/ccree/ssi_cipher.c      |   52 +
 drivers/staging/ccree/ssi_driver.c      |   19 +-
 drivers/staging/ccree/ssi_driver.h      |    2 +
 drivers/staging/ccree/ssi_fips.c        |   65 ++
 drivers/staging/ccree/ssi_fips.h        |   70 ++
 drivers/staging/ccree/ssi_fips_data.h   |  315 ++++++
 drivers/staging/ccree/ssi_fips_ext.c    |   96 ++
 drivers/staging/ccree/ssi_fips_ll.c     | 1681 +++++++++++++++++++++++++++++++
 drivers/staging/ccree/ssi_fips_local.c  |  369 +++++++
 drivers/staging/ccree/ssi_fips_local.h  |   77 ++
 drivers/staging/ccree/ssi_hash.c        |   21 +-
 drivers/staging/ccree/ssi_request_mgr.c |    2 +
 15 files changed, 2783 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/ccree/ssi_fips.c
 create mode 100644 drivers/staging/ccree/ssi_fips.h
 create mode 100644 drivers/staging/ccree/ssi_fips_data.h
 create mode 100644 drivers/staging/ccree/ssi_fips_ext.c
 create mode 100644 drivers/staging/ccree/ssi_fips_ll.c
 create mode 100644 drivers/staging/ccree/ssi_fips_local.c
 create mode 100644 drivers/staging/ccree/ssi_fips_local.h

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 2d11223..ae62704 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -24,6 +24,15 @@ config CRYPTO_DEV_CCREE
 	  cryptographic operations on the system REE.
 	  If unsure say Y.
 
+config CCREE_FIPS_SUPPORT
+	bool "Turn on CryptoCell 7XX REE FIPS mode support"
+	depends on CRYPTO_DEV_CCREE
+	default n
+	help
+	  Say 'Y' to enable support for FIPS compliant mode by the
+	  CCREE driver.
+	  If unsure say N.
+
 config CCREE_DISABLE_COHERENT_DMA_OPS
 	bool "Disable Coherent DMA operations for the CCREE driver"
 	depends on CRYPTO_DEV_CCREE
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index b9285c0..44f3e3e 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
 ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
+ccree-$(CCREE_FIPS_SUPPORT) += ssi_fips.o ssi_fips_ll.o ssi_fips_ext.o ssi_fips_local.o
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 1d2890e..3ab958b 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -36,6 +36,7 @@
 #include "ssi_hash.h"
 #include "ssi_sysfs.h"
 #include "ssi_sram_mgr.h"
+#include "ssi_fips_local.h"
 
 #define template_aead	template_u.aead
 
@@ -153,6 +154,8 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 			container_of(alg, struct ssi_crypto_alg, aead_alg);
 	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx, crypto_tfm_alg_name(&(tfm->base)));
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
+
 	/* Initialize modes in instance */
 	ctx->cipher_mode = ssi_alg->cipher_mode;
 	ctx->flow_mode = ssi_alg->flow_mode;
@@ -572,6 +575,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	SSI_LOG_DEBUG("Setting key in context @%p for %s. key=%p keylen=%u\n",
 		ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key, keylen);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* STAT_PHASE_0: Init and sanity checks */
 	START_CYCLE_COUNT();
 
@@ -699,6 +703,7 @@ static int ssi_aead_setauthsize(
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(authenc);
 	
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* Unsupported auth. sizes */
 	if ((authsize == 0) ||
 	    (authsize >crypto_aead_maxauthsize(authenc))) {
@@ -2006,6 +2011,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
 		((direct==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"), ctx, req, req->iv,
 		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
 	/* STAT_PHASE_0: Init and sanity checks */
 	START_CYCLE_COUNT();
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 2e4ce90..e8a4071 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -31,6 +31,7 @@
 #include "ssi_cipher.h"
 #include "ssi_request_mgr.h"
 #include "ssi_sysfs.h"
+#include "ssi_fips_local.h"
 
 #define MAX_ABLKCIPHER_SEQ_LEN 6
 
@@ -191,6 +192,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx_p, 
 						crypto_tfm_alg_name(tfm));
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	ctx_p->cipher_mode = ssi_alg->cipher_mode;
 	ctx_p->flow_mode = ssi_alg->flow_mode;
 	ctx_p->drvdata = ssi_alg->drvdata;
@@ -269,6 +271,37 @@ static const u8 zero_buff[] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
                                0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
                                0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
 
+/* The function verifies that tdes keys are not weak.*/
+static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
+{
+#ifdef CCREE_FIPS_SUPPORT
+        tdes_keys_t *tdes_key = (tdes_keys_t*)key;
+
+	/* verify key1 != key2 and key3 != key2*/
+        if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) || 
+		      (memcmp((u8*)tdes_key->key3, (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0) )) {
+                return -ENOEXEC;
+        }
+#endif /* CCREE_FIPS_SUPPORT */
+
+        return 0;
+}
+
+/* The function verifies that xts keys are not weak.*/
+static int ssi_fips_verify_xts_keys(const u8 *key, unsigned int keylen)
+{
+#ifdef CCREE_FIPS_SUPPORT
+        /* Weak key is define as key that its first half (128/256 lsb) equals its second half (128/256 msb) */
+        int singleKeySize = keylen >> 1;
+
+	if (unlikely(memcmp(key, &key[singleKeySize], singleKeySize) == 0)) {
+		return -ENOEXEC;
+	}
+#endif /* CCREE_FIPS_SUPPORT */
+
+        return 0;
+}
+
 static enum HwCryptoKey hw_key_to_cc_hw_key(int slot_num)
 {
 	switch (slot_num) {
@@ -298,6 +331,10 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		ctx_p, crypto_tfm_alg_name(tfm), keylen);
 	dump_byte_array("key", (uint8_t *)key, keylen);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
+
+	SSI_LOG_DEBUG("ssi_blkcipher_setkey: after FIPS check");
+	
 	/* STAT_PHASE_0: Init and sanity checks */
 	START_CYCLE_COUNT();
 
@@ -359,6 +396,18 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			return -EINVAL;
 		}
 	}
+	if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) && 
+	    ssi_fips_verify_xts_keys(key, keylen) != 0) {
+		SSI_LOG_DEBUG("ssi_blkcipher_setkey: weak XTS key");
+		return -EINVAL;
+	}
+	if ((ctx_p->flow_mode == S_DIN_to_DES) && 
+	    (keylen == DES3_EDE_KEY_SIZE) && 
+	    ssi_fips_verify_3des_keys(key, keylen) != 0) {
+		SSI_LOG_DEBUG("ssi_blkcipher_setkey: weak 3DES key");
+		return -EINVAL;
+	}
+
 
 	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
 
@@ -744,6 +793,7 @@ static int ssi_blkcipher_process(
 		((direction==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"),
 		     areq, info, nbytes);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* STAT_PHASE_0: Init and sanity checks */
 	START_CYCLE_COUNT();
 	
@@ -864,6 +914,8 @@ static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __io
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_ablkcipher_ctx(tfm);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
 
+	CHECK_AND_RETURN_VOID_UPON_FIPS_ERROR();
+
 	ssi_blkcipher_complete(dev, ctx_p, req_ctx, areq->dst, areq->src, areq->info, ivsize, areq, cc_base);
 }
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 42a00fc..1615f76 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -69,6 +69,7 @@
 #include "ssi_ivgen.h"
 #include "ssi_sram_mgr.h"
 #include "ssi_pm.h"
+#include "ssi_fips_local.h"
 
 
 #ifdef DX_DUMP_BYTES
@@ -142,7 +143,15 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		irr &= ~SSI_COMP_IRQ_MASK;
 		complete_request(drvdata);
 	}
-
+#ifdef CC_SUPPORT_FIPS
+	/* TEE FIPS interrupt */
+	if (likely((irr & SSI_GPR0_IRQ_MASK) != 0)) {
+		/* Mask interrupt - will be unmasked in Deferred service handler */
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
+		irr &= ~SSI_GPR0_IRQ_MASK;
+		fips_handler(drvdata);
+	}
+#endif
 	/* AXI error interrupt */
 	if (unlikely((irr & SSI_AXI_ERR_IRQ_MASK) != 0)) {
 		uint32_t axi_err;
@@ -351,6 +360,12 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 
+	rc = ssi_fips_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("SSI_FIPS_INIT failed 0x%x\n", rc);
+		goto init_cc_res_err;
+	}
+
 	rc = ssi_ivgen_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_ivgen_init failed\n");
@@ -391,6 +406,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		ssi_buffer_mgr_fini(new_drvdata);
 		request_mgr_fini(new_drvdata);
 		ssi_sram_mgr_fini(new_drvdata);
+		ssi_fips_fini(new_drvdata);
 #ifdef ENABLE_CC_SYSFS
 		ssi_sysfs_fini();
 #endif
@@ -434,6 +450,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	ssi_buffer_mgr_fini(drvdata);
 	request_mgr_fini(drvdata);
 	ssi_sram_mgr_fini(drvdata);
+	ssi_fips_fini(drvdata);
 #ifdef ENABLE_CC_SYSFS
 	ssi_sysfs_fini();
 #endif
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 1576a18..60aa8a8 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -54,6 +54,7 @@
 #include "cc_crypto_ctx.h"
 #include "ssi_sysfs.h"
 #include "hash_defs.h"
+#include "ssi_fips_local.h"
 
 #define DRV_MODULE_VERSION "3.0"
 
@@ -152,6 +153,7 @@ struct ssi_drvdata {
 	void *aead_handle;
 	void *blkcipher_handle;
 	void *request_mgr_handle;
+	void *fips_handle;
 	void *ivgen_handle;
 	void *sram_mgr_handle;
 
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
new file mode 100644
index 0000000..d4e65e9
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -0,0 +1,65 @@
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
+
+/**************************************************************
+This file defines the driver FIPS APIs                                                             *
+***************************************************************/
+
+#include <linux/module.h>
+#include "ssi_fips.h"
+
+
+extern int ssi_fips_ext_get_state(ssi_fips_state_t *p_state);
+extern int ssi_fips_ext_get_error(ssi_fips_error_t *p_err);
+
+/*
+This function returns the REE FIPS state.  
+It should be called by kernel module. 
+*/
+int ssi_fips_get_state(ssi_fips_state_t *p_state)
+{
+        int rc = 0;
+
+	if (p_state == NULL) {
+		return -EINVAL;
+	}
+
+	rc = ssi_fips_ext_get_state(p_state);
+
+	return rc;
+}
+
+EXPORT_SYMBOL(ssi_fips_get_state);
+
+/*
+This function returns the REE FIPS error.  
+It should be called by kernel module. 
+*/
+int ssi_fips_get_error(ssi_fips_error_t *p_err)
+{
+        int rc = 0;
+
+	if (p_err == NULL) {
+		return -EINVAL;
+	}
+
+	rc = ssi_fips_ext_get_error(p_err);
+
+	return rc;
+}
+
+EXPORT_SYMBOL(ssi_fips_get_error);
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
new file mode 100644
index 0000000..9c1fbf9
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -0,0 +1,70 @@
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
+#ifndef __SSI_FIPS_H__
+#define __SSI_FIPS_H__
+
+
+#ifndef INT32_MAX /* Missing in Linux kernel */
+#define INT32_MAX 0x7FFFFFFFL
+#endif
+
+
+/*! 
+@file
+@brief This file contains FIPS related defintions and APIs.
+*/
+
+typedef enum ssi_fips_state {
+        CC_FIPS_STATE_NOT_SUPPORTED = 0,
+        CC_FIPS_STATE_SUPPORTED,
+        CC_FIPS_STATE_ERROR,
+        CC_FIPS_STATE_RESERVE32B = INT32_MAX
+} ssi_fips_state_t;
+
+
+typedef enum ssi_fips_error {
+	CC_REE_FIPS_ERROR_OK = 0,
+	CC_REE_FIPS_ERROR_GENERAL,
+	CC_REE_FIPS_ERROR_FROM_TEE,
+	CC_REE_FIPS_ERROR_AES_ECB_PUT,
+	CC_REE_FIPS_ERROR_AES_CBC_PUT,
+	CC_REE_FIPS_ERROR_AES_OFB_PUT,
+	CC_REE_FIPS_ERROR_AES_CTR_PUT,
+	CC_REE_FIPS_ERROR_AES_CBC_CTS_PUT,
+	CC_REE_FIPS_ERROR_AES_XTS_PUT,
+	CC_REE_FIPS_ERROR_AES_CMAC_PUT,
+	CC_REE_FIPS_ERROR_AESCCM_PUT,
+	CC_REE_FIPS_ERROR_AESGCM_PUT,
+	CC_REE_FIPS_ERROR_DES_ECB_PUT,
+	CC_REE_FIPS_ERROR_DES_CBC_PUT,
+	CC_REE_FIPS_ERROR_SHA1_PUT,
+	CC_REE_FIPS_ERROR_SHA256_PUT,
+	CC_REE_FIPS_ERROR_SHA512_PUT,
+	CC_REE_FIPS_ERROR_HMAC_SHA1_PUT,
+	CC_REE_FIPS_ERROR_HMAC_SHA256_PUT,
+	CC_REE_FIPS_ERROR_HMAC_SHA512_PUT,
+	CC_REE_FIPS_ERROR_ROM_CHECKSUM,
+	CC_REE_FIPS_ERROR_RESERVE32B = INT32_MAX
+} ssi_fips_error_t;
+
+
+
+int ssi_fips_get_state(ssi_fips_state_t *p_state);
+int ssi_fips_get_error(ssi_fips_error_t *p_err);
+
+#endif  /*__SSI_FIPS_H__*/
+
diff --git a/drivers/staging/ccree/ssi_fips_data.h b/drivers/staging/ccree/ssi_fips_data.h
new file mode 100644
index 0000000..3590073
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips_data.h
@@ -0,0 +1,315 @@
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
+/*
+The test vectors were taken from:
+
+* AES
+NIST Special Publication 800-38A 2001 Edition
+Recommendation for Block Cipher Modes of Operation
+http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
+Appendix F: Example Vectors for Modes of Operation of the AES
+
+* AES CTS
+Advanced Encryption Standard (AES) Encryption for Kerberos 5
+February 2005
+https://tools.ietf.org/html/rfc3962#appendix-B
+B.  Sample Test Vectors
+
+* AES XTS
+http://csrc.nist.gov/groups/STM/cavp/#08
+http://csrc.nist.gov/groups/STM/cavp/documents/aes/XTSTestVectors.zip
+
+* AES CMAC
+http://csrc.nist.gov/groups/STM/cavp/index.html#07
+http://csrc.nist.gov/groups/STM/cavp/documents/mac/cmactestvectors.zip
+ 
+* AES-CCM
+http://csrc.nist.gov/groups/STM/cavp/#07
+http://csrc.nist.gov/groups/STM/cavp/documents/mac/ccmtestvectors.zip
+
+* AES-GCM
+http://csrc.nist.gov/groups/STM/cavp/documents/mac/gcmtestvectors.zip
+
+* Triple-DES
+NIST Special Publication 800-67 January 2012
+Recommendation for the Triple Data Encryption Algorithm (TDEA) Block Cipher
+http://csrc.nist.gov/publications/nistpubs/800-67-Rev1/SP-800-67-Rev1.pdf
+APPENDIX B: EXAMPLE OF TDEA FORWARD AND INVERSE CIPHER OPERATIONS
+and
+http://csrc.nist.gov/groups/STM/cavp/#01
+http://csrc.nist.gov/groups/STM/cavp/documents/des/tdesmct_intermediate.zip
+
+* HASH
+http://csrc.nist.gov/groups/STM/cavp/#03
+http://csrc.nist.gov/groups/STM/cavp/documents/shs/shabytetestvectors.zip 
+ 
+* HMAC 
+http://csrc.nist.gov/groups/STM/cavp/#07
+http://csrc.nist.gov/groups/STM/cavp/documents/mac/hmactestvectors.zip 
+ 
+*/
+
+/* NIST AES */
+#define AES_128_BIT_KEY_SIZE    16
+#define AES_192_BIT_KEY_SIZE    24
+#define AES_256_BIT_KEY_SIZE    32
+#define AES_512_BIT_KEY_SIZE    64
+
+#define NIST_AES_IV_SIZE        16
+
+#define NIST_AES_128_KEY        { 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c }
+#define NIST_AES_192_KEY        { 0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52, 0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5, \
+				  0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b }
+#define NIST_AES_256_KEY        { 0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81, \
+				  0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4 }
+#define NIST_AES_VECTOR_SIZE    16
+#define NIST_AES_PLAIN_DATA     { 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a }
+
+#define NIST_AES_ECB_IV         { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
+#define NIST_AES_128_ECB_CIPHER { 0x3a, 0xd7, 0x7b, 0xb4, 0x0d, 0x7a, 0x36, 0x60, 0xa8, 0x9e, 0xca, 0xf3, 0x24, 0x66, 0xef, 0x97 }
+#define NIST_AES_192_ECB_CIPHER { 0xbd, 0x33, 0x4f, 0x1d, 0x6e, 0x45, 0xf2, 0x5f, 0xf7, 0x12, 0xa2, 0x14, 0x57, 0x1f, 0xa5, 0xcc }
+#define NIST_AES_256_ECB_CIPHER { 0xf3, 0xee, 0xd1, 0xbd, 0xb5, 0xd2, 0xa0, 0x3c, 0x06, 0x4b, 0x5a, 0x7e, 0x3d, 0xb1, 0x81, 0xf8 }
+
+#define NIST_AES_CBC_IV         { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f }
+#define NIST_AES_128_CBC_CIPHER { 0x76, 0x49, 0xab, 0xac, 0x81, 0x19, 0xb2, 0x46, 0xce, 0xe9, 0x8e, 0x9b, 0x12, 0xe9, 0x19, 0x7d }
+#define NIST_AES_192_CBC_CIPHER { 0x4f, 0x02, 0x1d, 0xb2, 0x43, 0xbc, 0x63, 0x3d, 0x71, 0x78, 0x18, 0x3a, 0x9f, 0xa0, 0x71, 0xe8 } 
+#define NIST_AES_256_CBC_CIPHER { 0xf5, 0x8c, 0x4c, 0x04, 0xd6, 0xe5, 0xf1, 0xba, 0x77, 0x9e, 0xab, 0xfb, 0x5f, 0x7b, 0xfb, 0xd6 } 
+
+#define NIST_AES_OFB_IV         { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f }
+#define NIST_AES_128_OFB_CIPHER { 0x3b, 0x3f, 0xd9, 0x2e, 0xb7, 0x2d, 0xad, 0x20, 0x33, 0x34, 0x49, 0xf8, 0xe8, 0x3c, 0xfb, 0x4a }
+#define NIST_AES_192_OFB_CIPHER { 0xcd, 0xc8, 0x0d, 0x6f, 0xdd, 0xf1, 0x8c, 0xab, 0x34, 0xc2, 0x59, 0x09, 0xc9, 0x9a, 0x41, 0x74 } 
+#define NIST_AES_256_OFB_CIPHER { 0xdc, 0x7e, 0x84, 0xbf, 0xda, 0x79, 0x16, 0x4b, 0x7e, 0xcd, 0x84, 0x86, 0x98, 0x5d, 0x38, 0x60 }
+
+#define NIST_AES_CTR_IV         { 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff }
+#define NIST_AES_128_CTR_CIPHER { 0x87, 0x4d, 0x61, 0x91, 0xb6, 0x20, 0xe3, 0x26, 0x1b, 0xef, 0x68, 0x64, 0x99, 0x0d, 0xb6, 0xce }
+#define NIST_AES_192_CTR_CIPHER { 0x1a, 0xbc, 0x93, 0x24, 0x17, 0x52, 0x1c, 0xa2, 0x4f, 0x2b, 0x04, 0x59, 0xfe, 0x7e, 0x6e, 0x0b } 
+#define NIST_AES_256_CTR_CIPHER { 0x60, 0x1e, 0xc3, 0x13, 0x77, 0x57, 0x89, 0xa5, 0xb7, 0xa7, 0xf5, 0x04, 0xbb, 0xf3, 0xd2, 0x28 } 
+
+
+#define RFC3962_AES_128_KEY            { 0x63, 0x68, 0x69, 0x63, 0x6b, 0x65, 0x6e, 0x20, 0x74, 0x65, 0x72, 0x69, 0x79, 0x61, 0x6b, 0x69 }
+#define RFC3962_AES_VECTOR_SIZE        17
+#define RFC3962_AES_PLAIN_DATA         { 0x49, 0x20, 0x77, 0x6f, 0x75, 0x6c, 0x64, 0x20, 0x6c, 0x69, 0x6b, 0x65, 0x20, 0x74, 0x68, 0x65, 0x20 }
+#define RFC3962_AES_CBC_CTS_IV         { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
+#define RFC3962_AES_128_CBC_CTS_CIPHER { 0xc6, 0x35, 0x35, 0x68, 0xf2, 0xbf, 0x8c, 0xb4, 0xd8, 0xa5, 0x80, 0x36, 0x2d, 0xa7, 0xff, 0x7f, 0x97 }
+
+
+#define NIST_AES_256_XTS_KEY            { 0xa1, 0xb9, 0x0c, 0xba, 0x3f, 0x06, 0xac, 0x35, 0x3b, 0x2c, 0x34, 0x38, 0x76, 0x08, 0x17, 0x62, \
+					  0x09, 0x09, 0x23, 0x02, 0x6e, 0x91, 0x77, 0x18, 0x15, 0xf2, 0x9d, 0xab, 0x01, 0x93, 0x2f, 0x2f }
+#define NIST_AES_256_XTS_IV             { 0x4f, 0xae, 0xf7, 0x11, 0x7c, 0xda, 0x59, 0xc6, 0x6e, 0x4b, 0x92, 0x01, 0x3e, 0x76, 0x8a, 0xd5 }
+#define NIST_AES_256_XTS_VECTOR_SIZE    16
+#define NIST_AES_256_XTS_PLAIN          { 0xeb, 0xab, 0xce, 0x95, 0xb1, 0x4d, 0x3c, 0x8d, 0x6f, 0xb3, 0x50, 0x39, 0x07, 0x90, 0x31, 0x1c } 
+#define NIST_AES_256_XTS_CIPHER         { 0x77, 0x8a, 0xe8, 0xb4, 0x3c, 0xb9, 0x8d, 0x5a, 0x82, 0x50, 0x81, 0xd5, 0xbe, 0x47, 0x1c, 0x63 } 
+
+#define NIST_AES_512_XTS_KEY            { 0x1e, 0xa6, 0x61, 0xc5, 0x8d, 0x94, 0x3a, 0x0e, 0x48, 0x01, 0xe4, 0x2f, 0x4b, 0x09, 0x47, 0x14, \
+					  0x9e, 0x7f, 0x9f, 0x8e, 0x3e, 0x68, 0xd0, 0xc7, 0x50, 0x52, 0x10, 0xbd, 0x31, 0x1a, 0x0e, 0x7c, \
+					  0xd6, 0xe1, 0x3f, 0xfd, 0xf2, 0x41, 0x8d, 0x8d, 0x19, 0x11, 0xc0, 0x04, 0xcd, 0xa5, 0x8d, 0xa3, \
+					  0xd6, 0x19, 0xb7, 0xe2, 0xb9, 0x14, 0x1e, 0x58, 0x31, 0x8e, 0xea, 0x39, 0x2c, 0xf4, 0x1b, 0x08 }
+#define NIST_AES_512_XTS_IV             { 0xad, 0xf8, 0xd9, 0x26, 0x27, 0x46, 0x4a, 0xd2, 0xf0, 0x42, 0x8e, 0x84, 0xa9, 0xf8, 0x75, 0x64,  }
+#define NIST_AES_512_XTS_VECTOR_SIZE    32
+#define NIST_AES_512_XTS_PLAIN          { 0x2e, 0xed, 0xea, 0x52, 0xcd, 0x82, 0x15, 0xe1, 0xac, 0xc6, 0x47, 0xe8, 0x10, 0xbb, 0xc3, 0x64, \
+					  0x2e, 0x87, 0x28, 0x7f, 0x8d, 0x2e, 0x57, 0xe3, 0x6c, 0x0a, 0x24, 0xfb, 0xc1, 0x2a, 0x20, 0x2e } 
+#define NIST_AES_512_XTS_CIPHER         { 0xcb, 0xaa, 0xd0, 0xe2, 0xf6, 0xce, 0xa3, 0xf5, 0x0b, 0x37, 0xf9, 0x34, 0xd4, 0x6a, 0x9b, 0x13, \
+					  0x0b, 0x9d, 0x54, 0xf0, 0x7e, 0x34, 0xf3, 0x6a, 0xf7, 0x93, 0xe8, 0x6f, 0x73, 0xc6, 0xd7, 0xdb } 
+
+
+/* NIST AES-CMAC */
+#define NIST_AES_128_CMAC_KEY           { 0x67, 0x08, 0xc9, 0x88, 0x7b, 0x84, 0x70, 0x84, 0xf1, 0x23, 0xd3, 0xdd, 0x9c, 0x3a, 0x81, 0x36 }
+#define NIST_AES_128_CMAC_PLAIN_DATA    { 0xa8, 0xde, 0x55, 0x17, 0x0c, 0x6d, 0xc0, 0xd8, 0x0d, 0xe3, 0x2f, 0x50, 0x8b, 0xf4, 0x9b, 0x70 }
+#define NIST_AES_128_CMAC_MAC           { 0xcf, 0xef, 0x9b, 0x78, 0x39, 0x84, 0x1f, 0xdb, 0xcc, 0xbb, 0x6c, 0x2c, 0xf2, 0x38, 0xf7 }
+#define NIST_AES_128_CMAC_VECTOR_SIZE   16
+#define NIST_AES_128_CMAC_OUTPUT_SIZE   15
+
+#define NIST_AES_192_CMAC_KEY           { 0x20, 0x51, 0xaf, 0x34, 0x76, 0x2e, 0xbe, 0x55, 0x6f, 0x72, 0xa5, 0xc6, 0xed, 0xc7, 0x77, 0x1e, \
+					  0xb9, 0x24, 0x5f, 0xad, 0x76, 0xf0, 0x34, 0xbe }
+#define NIST_AES_192_CMAC_PLAIN_DATA    { 0xae, 0x8e, 0x93, 0xc9, 0xc9, 0x91, 0xcf, 0x89, 0x6a, 0x49, 0x1a, 0x89, 0x07, 0xdf, 0x4e, 0x4b, \
+					  0xe5, 0x18, 0x6a, 0xe4, 0x96, 0xcd, 0x34, 0x0d, 0xc1, 0x9b, 0x23, 0x78, 0x21, 0xdb, 0x7b, 0x60 }
+#define NIST_AES_192_CMAC_MAC           { 0x74, 0xf7, 0x46, 0x08, 0xc0, 0x4f, 0x0f, 0x4e, 0x47, 0xfa, 0x64, 0x04, 0x33, 0xb6, 0xe6, 0xfb }
+#define NIST_AES_192_CMAC_VECTOR_SIZE   32
+#define NIST_AES_192_CMAC_OUTPUT_SIZE   16
+
+#define NIST_AES_256_CMAC_KEY           { 0x3a, 0x75, 0xa9, 0xd2, 0xbd, 0xb8, 0xc8, 0x04, 0xba, 0x4a, 0xb4, 0x98, 0x35, 0x73, 0xa6, 0xb2, \
+					  0x53, 0x16, 0x0d, 0xd9, 0x0f, 0x8e, 0xdd, 0xfb, 0x2f, 0xdc, 0x2a, 0xb1, 0x76, 0x04, 0xf5, 0xc5 }
+#define NIST_AES_256_CMAC_PLAIN_DATA    { 0x42, 0xf3, 0x5d, 0x5a, 0xa5, 0x33, 0xa7, 0xa0, 0xa5, 0xf7, 0x4e, 0x14, 0x4f, 0x2a, 0x5f, 0x20 }
+#define NIST_AES_256_CMAC_MAC           { 0xf1, 0x53, 0x2f, 0x87, 0x32, 0xd9, 0xf5, 0x90, 0x30, 0x07 }
+#define NIST_AES_256_CMAC_VECTOR_SIZE   16
+#define NIST_AES_256_CMAC_OUTPUT_SIZE   10
+
+
+/* NIST TDES */
+#define TDES_NUM_OF_KEYS                3
+#define NIST_TDES_VECTOR_SIZE           8
+#define NIST_TDES_IV_SIZE               8
+
+#define NIST_TDES_ECB_IV             	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
+
+#define NIST_TDES_ECB3_KEY		{ 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, \
+					  0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x01, \
+					  0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x01, 0x23 }
+#define NIST_TDES_ECB3_PLAIN_DATA    	{ 0x54, 0x68, 0x65, 0x20, 0x71, 0x75, 0x66, 0x63 }
+#define NIST_TDES_ECB3_CIPHER        	{ 0xa8, 0x26, 0xfd, 0x8c, 0xe5, 0x3b, 0x85, 0x5f }
+
+#define NIST_TDES_CBC3_IV            	{ 0xf8, 0xee, 0xe1, 0x35, 0x9c, 0x6e, 0x54, 0x40 }
+#define NIST_TDES_CBC3_KEY		{ 0xe9, 0xda, 0x37, 0xf8, 0xdc, 0x97, 0x6d, 0x5b, \
+					  0xb6, 0x8c, 0x04, 0xe3, 0xec, 0x98, 0x20, 0x15, \
+					  0xf4, 0x0e, 0x08, 0xb5, 0x97, 0x29, 0xf2, 0x8f }
+#define NIST_TDES_CBC3_PLAIN_DATA    	{ 0x3b, 0xb7, 0xa7, 0xdb, 0xa3, 0xd5, 0x92, 0x91 }
+#define NIST_TDES_CBC3_CIPHER        	{ 0x5b, 0x84, 0x24, 0xd2, 0x39, 0x3e, 0x55, 0xa2 }
+
+
+/* NIST AES-CCM */
+#define NIST_AESCCM_128_BIT_KEY_SIZE    16
+#define NIST_AESCCM_192_BIT_KEY_SIZE    24
+#define NIST_AESCCM_256_BIT_KEY_SIZE    32
+
+#define NIST_AESCCM_B0_VAL              0x79  /* L'[0:2]=1 , M'[3-5]=7 , Adata[6]=1, reserved[7]=0 */
+#define NIST_AESCCM_NONCE_SIZE          13
+#define NIST_AESCCM_IV_SIZE             16
+#define NIST_AESCCM_ADATA_SIZE          32
+#define NIST_AESCCM_TEXT_SIZE           16
+#define NIST_AESCCM_TAG_SIZE            16
+
+#define NIST_AESCCM_128_KEY             { 0x70, 0x01, 0x0e, 0xd9, 0x0e, 0x61, 0x86, 0xec, 0xad, 0x41, 0xf0, 0xd3, 0xc7, 0xc4, 0x2f, 0xf8 }
+#define NIST_AESCCM_128_NONCE           { 0xa5, 0xf4, 0xf4, 0x98, 0x6e, 0x98, 0x47, 0x29, 0x65, 0xf5, 0xab, 0xcc, 0x4b }
+#define NIST_AESCCM_128_ADATA           { 0x3f, 0xec, 0x0e, 0x5c, 0xc2, 0x4d, 0x67, 0x13, 0x94, 0x37, 0xcb, 0xc8, 0x11, 0x24, 0x14, 0xfc, \
+					  0x8d, 0xac, 0xcd, 0x1a, 0x94, 0xb4, 0x9a, 0x4c, 0x76, 0xe2, 0xd3, 0x93, 0x03, 0x54, 0x73, 0x17 }
+#define NIST_AESCCM_128_PLAIN_TEXT      { 0xbe, 0x32, 0x2f, 0x58, 0xef, 0xa7, 0xf8, 0xc6, 0x8a, 0x63, 0x5e, 0x0b, 0x9c, 0xce, 0x77, 0xf2 }
+#define NIST_AESCCM_128_CIPHER          { 0x8e, 0x44, 0x25, 0xae, 0x57, 0x39, 0x74, 0xf0, 0xf0, 0x69, 0x3a, 0x18, 0x8b, 0x52, 0x58, 0x12 }
+#define NIST_AESCCM_128_MAC             { 0xee, 0xf0, 0x8e, 0x3f, 0xb1, 0x5f, 0x42, 0x27, 0xe0, 0xd9, 0x89, 0xa4, 0xd5, 0x87, 0xa8, 0xcf }
+
+#define NIST_AESCCM_192_KEY             { 0x68, 0x73, 0xf1, 0xc6, 0xc3, 0x09, 0x75, 0xaf, 0xf6, 0xf0, 0x84, 0x70, 0x26, 0x43, 0x21, 0x13, \
+					  0x0a, 0x6e, 0x59, 0x84, 0xad, 0xe3, 0x24, 0xe9 }
+#define NIST_AESCCM_192_NONCE           { 0x7c, 0x4d, 0x2f, 0x7c, 0xec, 0x04, 0x36, 0x1f, 0x18, 0x7f, 0x07, 0x26, 0xd5 }
+#define NIST_AESCCM_192_ADATA           { 0x77, 0x74, 0x3b, 0x5d, 0x83, 0xa0, 0x0d, 0x2c, 0x8d, 0x5f, 0x7e, 0x10, 0x78, 0x15, 0x31, 0xb4, \
+					  0x96, 0xe0, 0x9f, 0x3b, 0xc9, 0x29, 0x5d, 0x7a, 0xe9, 0x79, 0x9e, 0x64, 0x66, 0x8e, 0xf8, 0xc5 }
+#define NIST_AESCCM_192_PLAIN_TEXT      { 0x50, 0x51, 0xa0, 0xb0, 0xb6, 0x76, 0x6c, 0xd6, 0xea, 0x29, 0xa6, 0x72, 0x76, 0x9d, 0x40, 0xfe }
+#define NIST_AESCCM_192_CIPHER          { 0x0c, 0xe5, 0xac, 0x8d, 0x6b, 0x25, 0x6f, 0xb7, 0x58, 0x0b, 0xf6, 0xac, 0xc7, 0x64, 0x26, 0xaf }
+#define NIST_AESCCM_192_MAC             { 0x40, 0xbc, 0xe5, 0x8f, 0xd4, 0xcd, 0x65, 0x48, 0xdf, 0x90, 0xa0, 0x33, 0x7c, 0x84, 0x20, 0x04 }
+
+#define NIST_AESCCM_256_KEY             { 0xee, 0x8c, 0xe1, 0x87, 0x16, 0x97, 0x79, 0xd1, 0x3e, 0x44, 0x3d, 0x64, 0x28, 0xe3, 0x8b, 0x38, \
+					  0xb5, 0x5d, 0xfb, 0x90, 0xf0, 0x22, 0x8a, 0x8a, 0x4e, 0x62, 0xf8, 0xf5, 0x35, 0x80, 0x6e, 0x62 }
+#define NIST_AESCCM_256_NONCE           { 0x12, 0x16, 0x42, 0xc4, 0x21, 0x8b, 0x39, 0x1c, 0x98, 0xe6, 0x26, 0x9c, 0x8a }
+#define NIST_AESCCM_256_ADATA           { 0x71, 0x8d, 0x13, 0xe4, 0x75, 0x22, 0xac, 0x4c, 0xdf, 0x3f, 0x82, 0x80, 0x63, 0x98, 0x0b, 0x6d, \
+					  0x45, 0x2f, 0xcd, 0xcd, 0x6e, 0x1a, 0x19, 0x04, 0xbf, 0x87, 0xf5, 0x48, 0xa5, 0xfd, 0x5a, 0x05 }
+#define NIST_AESCCM_256_PLAIN_TEXT      { 0xd1, 0x5f, 0x98, 0xf2, 0xc6, 0xd6, 0x70, 0xf5, 0x5c, 0x78, 0xa0, 0x66, 0x48, 0x33, 0x2b, 0xc9 }
+#define NIST_AESCCM_256_CIPHER          { 0xcc, 0x17, 0xbf, 0x87, 0x94, 0xc8, 0x43, 0x45, 0x7d, 0x89, 0x93, 0x91, 0x89, 0x8e, 0xd2, 0x2a }
+#define NIST_AESCCM_256_MAC             { 0x6f, 0x9d, 0x28, 0xfc, 0xb6, 0x42, 0x34, 0xe1, 0xcd, 0x79, 0x3c, 0x41, 0x44, 0xf1, 0xda, 0x50 }
+
+
+/* NIST AES-GCM */
+#define NIST_AESGCM_128_BIT_KEY_SIZE    16
+#define NIST_AESGCM_192_BIT_KEY_SIZE    24
+#define NIST_AESGCM_256_BIT_KEY_SIZE    32
+
+#define NIST_AESGCM_IV_SIZE             12
+#define NIST_AESGCM_ADATA_SIZE          16
+#define NIST_AESGCM_TEXT_SIZE           16
+#define NIST_AESGCM_TAG_SIZE            16
+
+#define NIST_AESGCM_128_KEY             { 0x81, 0x6e, 0x39, 0x07, 0x04, 0x10, 0xcf, 0x21, 0x84, 0x90, 0x4d, 0xa0, 0x3e, 0xa5, 0x07, 0x5a }
+#define NIST_AESGCM_128_IV              { 0x32, 0xc3, 0x67, 0xa3, 0x36, 0x26, 0x13, 0xb2, 0x7f, 0xc3, 0xe6, 0x7e }
+#define NIST_AESGCM_128_ADATA           { 0xf2, 0xa3, 0x07, 0x28, 0xed, 0x87, 0x4e, 0xe0, 0x29, 0x83, 0xc2, 0x94, 0x43, 0x5d, 0x3c, 0x16 }
+#define NIST_AESGCM_128_PLAIN_TEXT      { 0xec, 0xaf, 0xe9, 0x6c, 0x67, 0xa1, 0x64, 0x67, 0x44, 0xf1, 0xc8, 0x91, 0xf5, 0xe6, 0x94, 0x27 }
+#define NIST_AESGCM_128_CIPHER          { 0x55, 0x2e, 0xbe, 0x01, 0x2e, 0x7b, 0xcf, 0x90, 0xfc, 0xef, 0x71, 0x2f, 0x83, 0x44, 0xe8, 0xf1 }
+#define NIST_AESGCM_128_MAC             { 0xec, 0xaa, 0xe9, 0xfc, 0x68, 0x27, 0x6a, 0x45, 0xab, 0x0c, 0xa3, 0xcb, 0x9d, 0xd9, 0x53, 0x9f }
+
+#define NIST_AESGCM_192_KEY             { 0x0c, 0x44, 0xd6, 0xc9, 0x28, 0xee, 0x11, 0x2c, 0xe6, 0x65, 0xfe, 0x54, 0x7e, 0xbd, 0x38, 0x72, \
+					  0x98, 0xa9, 0x54, 0xb4, 0x62, 0xf6, 0x95, 0xd8 }
+#define NIST_AESGCM_192_IV              { 0x18, 0xb8, 0xf3, 0x20, 0xfe, 0xf4, 0xae, 0x8c, 0xcb, 0xe8, 0xf9, 0x52 }
+#define NIST_AESGCM_192_ADATA           { 0x73, 0x41, 0xd4, 0x3f, 0x98, 0xcf, 0x38, 0x82, 0x21, 0x18, 0x09, 0x41, 0x97, 0x03, 0x76, 0xe8 }
+#define NIST_AESGCM_192_PLAIN_TEXT      { 0x96, 0xad, 0x07, 0xf9, 0xb6, 0x28, 0xb6, 0x52, 0xcf, 0x86, 0xcb, 0x73, 0x17, 0x88, 0x6f, 0x51 }
+#define NIST_AESGCM_192_CIPHER          { 0xa6, 0x64, 0x07, 0x81, 0x33, 0x40, 0x5e, 0xb9, 0x09, 0x4d, 0x36, 0xf7, 0xe0, 0x70, 0x19, 0x1f }
+#define NIST_AESGCM_192_MAC             { 0xe8, 0xf9, 0xc3, 0x17, 0x84, 0x7c, 0xe3, 0xf3, 0xc2, 0x39, 0x94, 0xa4, 0x02, 0xf0, 0x65, 0x81 }
+
+#define NIST_AESGCM_256_KEY             { 0x54, 0xe3, 0x52, 0xea, 0x1d, 0x84, 0xbf, 0xe6, 0x4a, 0x10, 0x11, 0x09, 0x61, 0x11, 0xfb, 0xe7, \
+					  0x66, 0x8a, 0xd2, 0x20, 0x3d, 0x90, 0x2a, 0x01, 0x45, 0x8c, 0x3b, 0xbd, 0x85, 0xbf, 0xce, 0x14 }
+#define NIST_AESGCM_256_IV              { 0xdf, 0x7c, 0x3b, 0xca, 0x00, 0x39, 0x6d, 0x0c, 0x01, 0x84, 0x95, 0xd9 }
+#define NIST_AESGCM_256_ADATA           { 0x7e, 0x96, 0x8d, 0x71, 0xb5, 0x0c, 0x1f, 0x11, 0xfd, 0x00, 0x1f, 0x3f, 0xef, 0x49, 0xd0, 0x45 }
+#define NIST_AESGCM_256_PLAIN_TEXT      { 0x85, 0xfc, 0x3d, 0xfa, 0xd9, 0xb5, 0xa8, 0xd3, 0x25, 0x8e, 0x4f, 0xc4, 0x45, 0x71, 0xbd, 0x3b }
+#define NIST_AESGCM_256_CIPHER          { 0x42, 0x6e, 0x0e, 0xfc, 0x69, 0x3b, 0x7b, 0xe1, 0xf3, 0x01, 0x8d, 0xb7, 0xdd, 0xbb, 0x7e, 0x4d }
+#define NIST_AESGCM_256_MAC             { 0xee, 0x82, 0x57, 0x79, 0x5b, 0xe6, 0xa1, 0x16, 0x4d, 0x7e, 0x1d, 0x2d, 0x6c, 0xac, 0x77, 0xa7 }
+
+
+/* NIST HASH */
+#define NIST_SHA_MSG_SIZE               16
+
+#define NIST_SHA_1_MSG                  { 0x35, 0x52, 0x69, 0x4c, 0xdf, 0x66, 0x3f, 0xd9, 0x4b, 0x22, 0x47, 0x47, 0xac, 0x40, 0x6a, 0xaf }
+#define NIST_SHA_1_MD                   { 0xa1, 0x50, 0xde, 0x92, 0x74, 0x54, 0x20, 0x2d, 0x94, 0xe6, 0x56, 0xde, 0x4c, 0x7c, 0x0c, 0xa6, \
+					  0x91, 0xde, 0x95, 0x5d }
+
+#define NIST_SHA_256_MSG                { 0x0a, 0x27, 0x84, 0x7c, 0xdc, 0x98, 0xbd, 0x6f, 0x62, 0x22, 0x0b, 0x04, 0x6e, 0xdd, 0x76, 0x2b }
+#define NIST_SHA_256_MD                 { 0x80, 0xc2, 0x5e, 0xc1, 0x60, 0x05, 0x87, 0xe7, 0xf2, 0x8b, 0x18, 0xb1, 0xb1, 0x8e, 0x3c, 0xdc, \
+					  0x89, 0x92, 0x8e, 0x39, 0xca, 0xb3, 0xbc, 0x25, 0xe4, 0xd4, 0xa4, 0xc1, 0x39, 0xbc, 0xed, 0xc4 }
+
+#define NIST_SHA_512_MSG                { 0xcd, 0x67, 0xbd, 0x40, 0x54, 0xaa, 0xa3, 0xba, 0xa0, 0xdb, 0x17, 0x8c, 0xe2, 0x32, 0xfd, 0x5a }
+#define NIST_SHA_512_MD                 { 0x0d, 0x85, 0x21, 0xf8, 0xf2, 0xf3, 0x90, 0x03, 0x32, 0xd1, 0xa1, 0xa5, 0x5c, 0x60, 0xba, 0x81, \
+					  0xd0, 0x4d, 0x28, 0xdf, 0xe8, 0xc5, 0x04, 0xb6, 0x32, 0x8a, 0xe7, 0x87, 0x92, 0x5f, 0xe0, 0x18, \
+					  0x8f, 0x2b, 0xa9, 0x1c, 0x3a, 0x9f, 0x0c, 0x16, 0x53, 0xc4, 0xbf, 0x0a, 0xda, 0x35, 0x64, 0x55, \
+					  0xea, 0x36, 0xfd, 0x31, 0xf8, 0xe7, 0x3e, 0x39, 0x51, 0xca, 0xd4, 0xeb, 0xba, 0x8c, 0x6e, 0x04 }
+
+
+/* NIST HMAC */
+#define NIST_HMAC_MSG_SIZE              128
+
+#define NIST_HMAC_SHA1_KEY_SIZE         10
+#define NIST_HMAC_SHA1_KEY		{ 0x59, 0x78, 0x59, 0x28, 0xd7, 0x25, 0x16, 0xe3, 0x12, 0x72 }
+#define NIST_HMAC_SHA1_MSG		{ 0xa3, 0xce, 0x88, 0x99, 0xdf, 0x10, 0x22, 0xe8, 0xd2, 0xd5, 0x39, 0xb4, 0x7b, 0xf0, 0xe3, 0x09, \
+					  0xc6, 0x6f, 0x84, 0x09, 0x5e, 0x21, 0x43, 0x8e, 0xc3, 0x55, 0xbf, 0x11, 0x9c, 0xe5, 0xfd, 0xcb, \
+					  0x4e, 0x73, 0xa6, 0x19, 0xcd, 0xf3, 0x6f, 0x25, 0xb3, 0x69, 0xd8, 0xc3, 0x8f, 0xf4, 0x19, 0x99, \
+					  0x7f, 0x0c, 0x59, 0x83, 0x01, 0x08, 0x22, 0x36, 0x06, 0xe3, 0x12, 0x23, 0x48, 0x3f, 0xd3, 0x9e, \
+					  0xde, 0xaa, 0x4d, 0x3f, 0x0d, 0x21, 0x19, 0x88, 0x62, 0xd2, 0x39, 0xc9, 0xfd, 0x26, 0x07, 0x41, \
+					  0x30, 0xff, 0x6c, 0x86, 0x49, 0x3f, 0x52, 0x27, 0xab, 0x89, 0x5c, 0x8f, 0x24, 0x4b, 0xd4, 0x2c, \
+					  0x7a, 0xfc, 0xe5, 0xd1, 0x47, 0xa2, 0x0a, 0x59, 0x07, 0x98, 0xc6, 0x8e, 0x70, 0x8e, 0x96, 0x49, \
+					  0x02, 0xd1, 0x24, 0xda, 0xde, 0xcd, 0xbd, 0xa9, 0xdb, 0xd0, 0x05, 0x1e, 0xd7, 0x10, 0xe9, 0xbf }
+#define NIST_HMAC_SHA1_MD               { 0x3c, 0x81, 0x62, 0x58, 0x9a, 0xaf, 0xae, 0xe0, 0x24, 0xfc, 0x9a, 0x5c, 0xa5, 0x0d, 0xd2, 0x33, \
+					  0x6f, 0xe3, 0xeb, 0x28 }
+
+#define NIST_HMAC_SHA256_KEY_SIZE       40
+#define NIST_HMAC_SHA256_KEY		{ 0x97, 0x79, 0xd9, 0x12, 0x06, 0x42, 0x79, 0x7f, 0x17, 0x47, 0x02, 0x5d, 0x5b, 0x22, 0xb7, 0xac, \
+					  0x60, 0x7c, 0xab, 0x08, 0xe1, 0x75, 0x8f, 0x2f, 0x3a, 0x46, 0xc8, 0xbe, 0x1e, 0x25, 0xc5, 0x3b, \
+					  0x8c, 0x6a, 0x8f, 0x58, 0xff, 0xef, 0xa1, 0x76 }
+#define NIST_HMAC_SHA256_MSG		{ 0xb1, 0x68, 0x9c, 0x25, 0x91, 0xea, 0xf3, 0xc9, 0xe6, 0x60, 0x70, 0xf8, 0xa7, 0x79, 0x54, 0xff, \
+					  0xb8, 0x17, 0x49, 0xf1, 0xb0, 0x03, 0x46, 0xf9, 0xdf, 0xe0, 0xb2, 0xee, 0x90, 0x5d, 0xcc, 0x28, \
+					  0x8b, 0xaf, 0x4a, 0x92, 0xde, 0x3f, 0x40, 0x01, 0xdd, 0x9f, 0x44, 0xc4, 0x68, 0xc3, 0xd0, 0x7d, \
+					  0x6c, 0x6e, 0xe8, 0x2f, 0xac, 0xea, 0xfc, 0x97, 0xc2, 0xfc, 0x0f, 0xc0, 0x60, 0x17, 0x19, 0xd2, \
+					  0xdc, 0xd0, 0xaa, 0x2a, 0xec, 0x92, 0xd1, 0xb0, 0xae, 0x93, 0x3c, 0x65, 0xeb, 0x06, 0xa0, 0x3c, \
+					  0x9c, 0x93, 0x5c, 0x2b, 0xad, 0x04, 0x59, 0x81, 0x02, 0x41, 0x34, 0x7a, 0xb8, 0x7e, 0x9f, 0x11, \
+					  0xad, 0xb3, 0x04, 0x15, 0x42, 0x4c, 0x6c, 0x7f, 0x5f, 0x22, 0xa0, 0x03, 0xb8, 0xab, 0x8d, 0xe5, \
+					  0x4f, 0x6d, 0xed, 0x0e, 0x3a, 0xb9, 0x24, 0x5f, 0xa7, 0x95, 0x68, 0x45, 0x1d, 0xfa, 0x25, 0x8e }
+#define NIST_HMAC_SHA256_MD             { 0x76, 0x9f, 0x00, 0xd3, 0xe6, 0xa6, 0xcc, 0x1f, 0xb4, 0x26, 0xa1, 0x4a, 0x4f, 0x76, 0xc6, 0x46, \
+					  0x2e, 0x61, 0x49, 0x72, 0x6e, 0x0d, 0xee, 0x0e, 0xc0, 0xcf, 0x97, 0xa1, 0x66, 0x05, 0xac, 0x8b }
+
+#define NIST_HMAC_SHA512_KEY_SIZE       100
+#define NIST_HMAC_SHA512_KEY		{ 0x57, 0xc2, 0xeb, 0x67, 0x7b, 0x50, 0x93, 0xb9, 0xe8, 0x29, 0xea, 0x4b, 0xab, 0xb5, 0x0b, 0xde, \
+					  0x55, 0xd0, 0xad, 0x59, 0xfe, 0xc3, 0x4a, 0x61, 0x89, 0x73, 0x80, 0x2b, 0x2a, 0xd9, 0xb7, 0x8e, \
+					  0x26, 0xb2, 0x04, 0x5d, 0xda, 0x78, 0x4d, 0xf3, 0xff, 0x90, 0xae, 0x0f, 0x2c, 0xc5, 0x1c, 0xe3, \
+					  0x9c, 0xf5, 0x48, 0x67, 0x32, 0x0a, 0xc6, 0xf3, 0xba, 0x2c, 0x6f, 0x0d, 0x72, 0x36, 0x04, 0x80, \
+					  0xc9, 0x66, 0x14, 0xae, 0x66, 0x58, 0x1f, 0x26, 0x6c, 0x35, 0xfb, 0x79, 0xfd, 0x28, 0x77, 0x4a, \
+					  0xfd, 0x11, 0x3f, 0xa5, 0x18, 0x7e, 0xff, 0x92, 0x06, 0xd7, 0xcb, 0xe9, 0x0d, 0xd8, 0xbf, 0x67, \
+					  0xc8, 0x44, 0xe2, 0x02 }
+#define NIST_HMAC_SHA512_MSG		{ 0x24, 0x23, 0xdf, 0xf4, 0x8b, 0x31, 0x2b, 0xe8, 0x64, 0xcb, 0x34, 0x90, 0x64, 0x1f, 0x79, 0x3d, \
+					  0x2b, 0x9f, 0xb6, 0x8a, 0x77, 0x63, 0xb8, 0xe2, 0x98, 0xc8, 0x6f, 0x42, 0x24, 0x5e, 0x45, 0x40, \
+					  0xeb, 0x01, 0xae, 0x4d, 0x2d, 0x45, 0x00, 0x37, 0x0b, 0x18, 0x86, 0xf2, 0x3c, 0xa2, 0xcf, 0x97, \
+					  0x01, 0x70, 0x4c, 0xad, 0x5b, 0xd2, 0x1b, 0xa8, 0x7b, 0x81, 0x1d, 0xaf, 0x7a, 0x85, 0x4e, 0xa2, \
+					  0x4a, 0x56, 0x56, 0x5c, 0xed, 0x42, 0x5b, 0x35, 0xe4, 0x0e, 0x1a, 0xcb, 0xeb, 0xe0, 0x36, 0x03, \
+					  0xe3, 0x5d, 0xcf, 0x4a, 0x10, 0x0e, 0x57, 0x21, 0x84, 0x08, 0xa1, 0xd8, 0xdb, 0xcc, 0x3b, 0x99, \
+					  0x29, 0x6c, 0xfe, 0xa9, 0x31, 0xef, 0xe3, 0xeb, 0xd8, 0xf7, 0x19, 0xa6, 0xd9, 0xa1, 0x54, 0x87, \
+					  0xb9, 0xad, 0x67, 0xea, 0xfe, 0xdf, 0x15, 0x55, 0x9c, 0xa4, 0x24, 0x45, 0xb0, 0xf9, 0xb4, 0x2e }
+#define NIST_HMAC_SHA512_MD             { 0x33, 0xc5, 0x11, 0xe9, 0xbc, 0x23, 0x07, 0xc6, 0x27, 0x58, 0xdf, 0x61, 0x12, 0x5a, 0x98, 0x0e, \
+					  0xe6, 0x4c, 0xef, 0xeb, 0xd9, 0x09, 0x31, 0xcb, 0x91, 0xc1, 0x37, 0x42, 0xd4, 0x71, 0x4c, 0x06, \
+					  0xde, 0x40, 0x03, 0xfa, 0xf3, 0xc4, 0x1c, 0x06, 0xae, 0xfc, 0x63, 0x8a, 0xd4, 0x7b, 0x21, 0x90, \
+					  0x6e, 0x6b, 0x10, 0x48, 0x16, 0xb7, 0x2d, 0xe6, 0x26, 0x9e, 0x04, 0x5a, 0x1f, 0x44, 0x29, 0xd4 }
+
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
new file mode 100644
index 0000000..369ab86
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -0,0 +1,96 @@
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
+/**************************************************************
+This file defines the driver FIPS functions that should be 
+implemented by the driver user. Current implementation is sample code only.
+***************************************************************/
+
+#include <linux/module.h>
+#include "ssi_fips_local.h"
+#include "ssi_driver.h"
+
+
+static bool tee_error;
+module_param(tee_error, bool, 0644);
+MODULE_PARM_DESC(tee_error, "Simulate TEE library failure flag: 0 - no error (default), 1 - TEE error occured ");
+
+static ssi_fips_state_t fips_state = CC_FIPS_STATE_NOT_SUPPORTED;
+static ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
+
+/*
+This function returns the FIPS REE state. 
+The function should be implemented by the driver user, depends on where                          .
+the state value is stored. 
+The reference code uses global variable. 
+*/
+int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
+{
+        int rc = 0;
+
+	if (p_state == NULL) {
+		return -EINVAL;
+	}
+
+	*p_state = fips_state;
+
+	return rc;
+}
+
+/*
+This function returns the FIPS REE error. 
+The function should be implemented by the driver user, depends on where                          .
+the error value is stored. 
+The reference code uses global variable. 
+*/
+int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
+{
+        int rc = 0;
+
+	if (p_err == NULL) {
+		return -EINVAL;
+	}
+
+	*p_err = fips_error;
+
+	return rc;
+}
+
+/*
+This function sets the FIPS REE state. 
+The function should be implemented by the driver user, depends on where                          .
+the state value is stored. 
+The reference code uses global variable. 
+*/
+int ssi_fips_ext_set_state(ssi_fips_state_t state)
+{
+	fips_state = state;
+	return 0;
+}
+
+/*
+This function sets the FIPS REE error. 
+The function should be implemented by the driver user, depends on where                          .
+the error value is stored. 
+The reference code uses global variable. 
+*/
+int ssi_fips_ext_set_error(ssi_fips_error_t err)
+{
+	fips_error = err;
+	return 0;
+}
+
+
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
new file mode 100644
index 0000000..32daf35
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -0,0 +1,1681 @@
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
+/**************************************************************
+This file defines the driver FIPS Low Level implmentaion functions,
+that executes the KAT.
+***************************************************************/
+#include <linux/kernel.h>
+
+#include "ssi_driver.h"
+#include "ssi_fips_local.h"
+#include "ssi_fips_data.h"
+#include "cc_crypto_ctx.h"
+#include "ssi_hash.h"
+#include "ssi_request_mgr.h"
+
+
+static const uint32_t digest_len_init[] = {
+	0x00000040, 0x00000000, 0x00000000, 0x00000000 };
+static const uint32_t sha1_init[] = { 
+	SHA1_H4, SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
+static const uint32_t sha256_init[] = {
+	SHA256_H7, SHA256_H6, SHA256_H5, SHA256_H4,
+	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
+#if (CC_SUPPORT_SHA > 256)
+static const uint32_t digest_len_sha512_init[] = { 
+	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
+static const uint64_t sha512_init[] = {
+	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
+	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
+#endif
+
+
+#define NIST_CIPHER_AES_MAX_VECTOR_SIZE      32
+
+struct fips_cipher_ctx {
+	uint8_t iv[CC_AES_IV_SIZE];
+	uint8_t key[AES_512_BIT_KEY_SIZE];
+	uint8_t din[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
+	uint8_t dout[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
+};
+
+typedef struct _FipsCipherData {
+	uint8_t                   isAes;
+	uint8_t                   key[AES_512_BIT_KEY_SIZE];
+	size_t                    keySize;
+	uint8_t                   iv[CC_AES_IV_SIZE];
+	enum drv_crypto_direction direction;
+	enum drv_cipher_mode      oprMode;
+	uint8_t                   dataIn[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
+	uint8_t                   dataOut[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
+	size_t                    dataInSize;
+} FipsCipherData;
+
+
+struct fips_cmac_ctx {
+	uint8_t key[AES_256_BIT_KEY_SIZE];
+	uint8_t din[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
+	uint8_t mac_res[CC_DIGEST_SIZE_MAX];
+};
+
+typedef struct _FipsCmacData {
+	enum drv_crypto_direction direction;
+	uint8_t                   key[AES_256_BIT_KEY_SIZE];
+	size_t                    key_size;
+	uint8_t                   data_in[NIST_CIPHER_AES_MAX_VECTOR_SIZE];
+	size_t                    data_in_size;
+	uint8_t                   mac_res[CC_DIGEST_SIZE_MAX];
+	size_t                    mac_res_size;
+} FipsCmacData;
+
+
+struct fips_hash_ctx {
+	uint8_t initial_digest[CC_DIGEST_SIZE_MAX];
+	uint8_t din[NIST_SHA_MSG_SIZE];
+	uint8_t mac_res[CC_DIGEST_SIZE_MAX];
+};
+
+typedef struct _FipsHashData {
+	enum drv_hash_mode    hash_mode;
+	uint8_t               data_in[NIST_SHA_MSG_SIZE];
+	size_t                data_in_size;
+	uint8_t               mac_res[CC_DIGEST_SIZE_MAX];
+} FipsHashData;
+
+
+/* note that the hmac key length must be equal or less than block size (block size is 64 up to sha256 and 128 for sha384/512) */
+struct fips_hmac_ctx {
+	uint8_t initial_digest[CC_DIGEST_SIZE_MAX];
+	uint8_t key[CC_HMAC_BLOCK_SIZE_MAX];
+	uint8_t k0[CC_HMAC_BLOCK_SIZE_MAX];
+	uint8_t digest_bytes_len[HASH_LEN_SIZE];
+	uint8_t tmp_digest[CC_DIGEST_SIZE_MAX];
+	uint8_t din[NIST_HMAC_MSG_SIZE];
+	uint8_t mac_res[CC_DIGEST_SIZE_MAX];
+};
+
+typedef struct _FipsHmacData {
+	enum drv_hash_mode    hash_mode;
+	uint8_t               key[CC_HMAC_BLOCK_SIZE_MAX];
+	size_t                key_size;
+	uint8_t               data_in[NIST_HMAC_MSG_SIZE];
+	size_t                data_in_size;
+	uint8_t               mac_res[CC_DIGEST_SIZE_MAX];
+} FipsHmacData;
+
+
+#define FIPS_CCM_B0_A0_ADATA_SIZE   (NIST_AESCCM_IV_SIZE + NIST_AESCCM_IV_SIZE + NIST_AESCCM_ADATA_SIZE)
+
+struct fips_ccm_ctx {
+	uint8_t b0_a0_adata[FIPS_CCM_B0_A0_ADATA_SIZE];
+	uint8_t iv[NIST_AESCCM_IV_SIZE];
+	uint8_t ctr_cnt_0[NIST_AESCCM_IV_SIZE];
+	uint8_t key[CC_AES_KEY_SIZE_MAX];
+	uint8_t din[NIST_AESCCM_TEXT_SIZE];
+	uint8_t dout[NIST_AESCCM_TEXT_SIZE];
+	uint8_t mac_res[NIST_AESCCM_TAG_SIZE];
+};
+
+typedef struct _FipsCcmData {
+	enum drv_crypto_direction direction;
+	uint8_t                   key[CC_AES_KEY_SIZE_MAX];
+	size_t                    keySize;
+	uint8_t                   nonce[NIST_AESCCM_NONCE_SIZE];
+	uint8_t                   adata[NIST_AESCCM_ADATA_SIZE];
+	size_t                    adataSize;
+	uint8_t                   dataIn[NIST_AESCCM_TEXT_SIZE];
+	size_t                    dataInSize;
+	uint8_t                   dataOut[NIST_AESCCM_TEXT_SIZE];
+	uint8_t                   tagSize;
+	uint8_t                   macResOut[NIST_AESCCM_TAG_SIZE];
+} FipsCcmData;
+
+
+struct fips_gcm_ctx {
+	uint8_t adata[NIST_AESGCM_ADATA_SIZE];
+	uint8_t key[CC_AES_KEY_SIZE_MAX];
+	uint8_t hkey[CC_AES_KEY_SIZE_MAX];
+	uint8_t din[NIST_AESGCM_TEXT_SIZE];
+	uint8_t dout[NIST_AESGCM_TEXT_SIZE];
+	uint8_t mac_res[NIST_AESGCM_TAG_SIZE];
+	uint8_t len_block[AES_BLOCK_SIZE];
+	uint8_t iv_inc1[AES_BLOCK_SIZE];
+	uint8_t iv_inc2[AES_BLOCK_SIZE];
+};
+
+typedef struct _FipsGcmData {
+	enum drv_crypto_direction direction;
+	uint8_t                   key[CC_AES_KEY_SIZE_MAX];
+	size_t                    keySize;
+	uint8_t                   iv[NIST_AESGCM_IV_SIZE];
+	uint8_t                   adata[NIST_AESGCM_ADATA_SIZE];
+	size_t                    adataSize;
+	uint8_t                   dataIn[NIST_AESGCM_TEXT_SIZE];
+	size_t                    dataInSize;
+	uint8_t                   dataOut[NIST_AESGCM_TEXT_SIZE];
+	uint8_t                   tagSize;
+	uint8_t                   macResOut[NIST_AESGCM_TAG_SIZE];
+} FipsGcmData;
+
+
+typedef union _fips_ctx {
+	struct fips_cipher_ctx cipher;
+	struct fips_cmac_ctx cmac;
+	struct fips_hash_ctx hash;
+	struct fips_hmac_ctx hmac;
+	struct fips_ccm_ctx ccm;
+	struct fips_gcm_ctx gcm;
+} fips_ctx;
+
+
+/* test data tables */
+static const FipsCipherData FipsCipherDataTable[] = {
+	/* AES */
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_ECB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_ECB, NIST_AES_PLAIN_DATA, NIST_AES_128_ECB_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_ECB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_ECB, NIST_AES_128_ECB_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_ECB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_ECB, NIST_AES_PLAIN_DATA, NIST_AES_192_ECB_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_ECB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_ECB, NIST_AES_192_ECB_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_ECB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_ECB, NIST_AES_PLAIN_DATA, NIST_AES_256_ECB_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_ECB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_ECB, NIST_AES_256_ECB_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_CBC_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CBC, NIST_AES_PLAIN_DATA, NIST_AES_128_CBC_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_CBC_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC, NIST_AES_128_CBC_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_CBC_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CBC, NIST_AES_PLAIN_DATA, NIST_AES_192_CBC_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_CBC_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC, NIST_AES_192_CBC_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_CBC_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CBC, NIST_AES_PLAIN_DATA, NIST_AES_256_CBC_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_CBC_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC, NIST_AES_256_CBC_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_OFB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_OFB, NIST_AES_PLAIN_DATA, NIST_AES_128_OFB_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_OFB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_OFB, NIST_AES_128_OFB_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_OFB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_OFB, NIST_AES_PLAIN_DATA, NIST_AES_192_OFB_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_OFB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_OFB, NIST_AES_192_OFB_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_OFB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_OFB, NIST_AES_PLAIN_DATA, NIST_AES_256_OFB_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_OFB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_OFB, NIST_AES_256_OFB_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_CTR_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CTR, NIST_AES_PLAIN_DATA, NIST_AES_128_CTR_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_128_KEY, CC_AES_128_BIT_KEY_SIZE, NIST_AES_CTR_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CTR, NIST_AES_128_CTR_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_CTR_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CTR, NIST_AES_PLAIN_DATA, NIST_AES_192_CTR_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_192_KEY, CC_AES_192_BIT_KEY_SIZE, NIST_AES_CTR_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CTR, NIST_AES_192_CTR_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_CTR_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CTR, NIST_AES_PLAIN_DATA, NIST_AES_256_CTR_CIPHER, NIST_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_KEY, CC_AES_256_BIT_KEY_SIZE, NIST_AES_CTR_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CTR, NIST_AES_256_CTR_CIPHER, NIST_AES_PLAIN_DATA, NIST_AES_VECTOR_SIZE },
+	{ 1, RFC3962_AES_128_KEY,  CC_AES_128_BIT_KEY_SIZE, RFC3962_AES_CBC_CTS_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CBC_CTS, RFC3962_AES_PLAIN_DATA, RFC3962_AES_128_CBC_CTS_CIPHER, RFC3962_AES_VECTOR_SIZE },
+	{ 1, RFC3962_AES_128_KEY,  CC_AES_128_BIT_KEY_SIZE, RFC3962_AES_CBC_CTS_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC_CTS, RFC3962_AES_128_CBC_CTS_CIPHER, RFC3962_AES_PLAIN_DATA, RFC3962_AES_VECTOR_SIZE },
+	{ 1, NIST_AES_256_XTS_KEY, CC_AES_256_BIT_KEY_SIZE,   NIST_AES_256_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_256_XTS_PLAIN, NIST_AES_256_XTS_CIPHER, NIST_AES_256_XTS_VECTOR_SIZE },
+	{ 1, NIST_AES_256_XTS_KEY, CC_AES_256_BIT_KEY_SIZE,   NIST_AES_256_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_256_XTS_CIPHER, NIST_AES_256_XTS_PLAIN, NIST_AES_256_XTS_VECTOR_SIZE },
+#if (CC_SUPPORT_SHA > 256)
+	{ 1, NIST_AES_512_XTS_KEY, 2*CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_VECTOR_SIZE },
+	{ 1, NIST_AES_512_XTS_KEY, 2*CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_VECTOR_SIZE },
+#endif
+	/* DES */
+	{ 0, NIST_TDES_ECB3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_ECB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_ECB, NIST_TDES_ECB3_PLAIN_DATA, NIST_TDES_ECB3_CIPHER, NIST_TDES_VECTOR_SIZE },
+	{ 0, NIST_TDES_ECB3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_ECB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_ECB, NIST_TDES_ECB3_CIPHER, NIST_TDES_ECB3_PLAIN_DATA, NIST_TDES_VECTOR_SIZE },
+	{ 0, NIST_TDES_CBC3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_CBC3_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_CBC, NIST_TDES_CBC3_PLAIN_DATA, NIST_TDES_CBC3_CIPHER, NIST_TDES_VECTOR_SIZE },
+	{ 0, NIST_TDES_CBC3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_CBC3_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC, NIST_TDES_CBC3_CIPHER, NIST_TDES_CBC3_PLAIN_DATA, NIST_TDES_VECTOR_SIZE },
+};
+#define FIPS_CIPHER_NUM_OF_TESTS        (sizeof(FipsCipherDataTable) / sizeof(FipsCipherData))
+
+static const FipsCmacData FipsCmacDataTable[] = {
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AES_128_CMAC_KEY, AES_128_BIT_KEY_SIZE, NIST_AES_128_CMAC_PLAIN_DATA, NIST_AES_128_CMAC_VECTOR_SIZE, NIST_AES_128_CMAC_MAC, NIST_AES_128_CMAC_OUTPUT_SIZE },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AES_192_CMAC_KEY, AES_192_BIT_KEY_SIZE, NIST_AES_192_CMAC_PLAIN_DATA, NIST_AES_192_CMAC_VECTOR_SIZE, NIST_AES_192_CMAC_MAC, NIST_AES_192_CMAC_OUTPUT_SIZE },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AES_256_CMAC_KEY, AES_256_BIT_KEY_SIZE, NIST_AES_256_CMAC_PLAIN_DATA, NIST_AES_256_CMAC_VECTOR_SIZE, NIST_AES_256_CMAC_MAC, NIST_AES_256_CMAC_OUTPUT_SIZE },
+};
+#define FIPS_CMAC_NUM_OF_TESTS        (sizeof(FipsCmacDataTable) / sizeof(FipsCmacData))
+
+static const FipsHashData FipsHashDataTable[] = {
+        { DRV_HASH_SHA1,   NIST_SHA_1_MSG,   NIST_SHA_MSG_SIZE, NIST_SHA_1_MD },
+        { DRV_HASH_SHA256, NIST_SHA_256_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_256_MD },
+#if (CC_SUPPORT_SHA > 256)
+//        { DRV_HASH_SHA512, NIST_SHA_512_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_512_MD },
+#endif
+};
+#define FIPS_HASH_NUM_OF_TESTS        (sizeof(FipsHashDataTable) / sizeof(FipsHashData))
+
+static const FipsHmacData FipsHmacDataTable[] = {
+        { DRV_HASH_SHA1,   NIST_HMAC_SHA1_KEY,   NIST_HMAC_SHA1_KEY_SIZE,   NIST_HMAC_SHA1_MSG,   NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA1_MD },
+        { DRV_HASH_SHA256, NIST_HMAC_SHA256_KEY, NIST_HMAC_SHA256_KEY_SIZE, NIST_HMAC_SHA256_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA256_MD },
+#if (CC_SUPPORT_SHA > 256)
+//        { DRV_HASH_SHA512, NIST_HMAC_SHA512_KEY, NIST_HMAC_SHA512_KEY_SIZE, NIST_HMAC_SHA512_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA512_MD },
+#endif
+};
+#define FIPS_HMAC_NUM_OF_TESTS        (sizeof(FipsHmacDataTable) / sizeof(FipsHmacData))
+
+static const FipsCcmData FipsCcmDataTable[] = {
+        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_128_KEY, NIST_AESCCM_128_BIT_KEY_SIZE, NIST_AESCCM_128_NONCE, NIST_AESCCM_128_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_128_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_128_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_128_MAC },
+        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_128_KEY, NIST_AESCCM_128_BIT_KEY_SIZE, NIST_AESCCM_128_NONCE, NIST_AESCCM_128_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_128_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_128_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_128_MAC },
+        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_192_KEY, NIST_AESCCM_192_BIT_KEY_SIZE, NIST_AESCCM_192_NONCE, NIST_AESCCM_192_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_192_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_192_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_192_MAC },
+        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_192_KEY, NIST_AESCCM_192_BIT_KEY_SIZE, NIST_AESCCM_192_NONCE, NIST_AESCCM_192_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_192_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_192_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_192_MAC },
+        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
+        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
+};
+#define FIPS_CCM_NUM_OF_TESTS        (sizeof(FipsCcmDataTable) / sizeof(FipsCcmData))
+
+static const FipsGcmData FipsGcmDataTable[] = {
+        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_128_KEY, NIST_AESGCM_128_BIT_KEY_SIZE, NIST_AESGCM_128_IV, NIST_AESGCM_128_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_128_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_128_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_128_MAC },
+        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_128_KEY, NIST_AESGCM_128_BIT_KEY_SIZE, NIST_AESGCM_128_IV, NIST_AESGCM_128_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_128_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_128_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_128_MAC },
+        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_192_KEY, NIST_AESGCM_192_BIT_KEY_SIZE, NIST_AESGCM_192_IV, NIST_AESGCM_192_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_192_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_192_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_192_MAC },
+        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_192_KEY, NIST_AESGCM_192_BIT_KEY_SIZE, NIST_AESGCM_192_IV, NIST_AESGCM_192_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_192_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_192_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_192_MAC },
+        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
+        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
+};
+#define FIPS_GCM_NUM_OF_TESTS        (sizeof(FipsGcmDataTable) / sizeof(FipsGcmData))
+
+
+static inline ssi_fips_error_t 
+FIPS_CipherToFipsError(enum drv_cipher_mode mode, bool is_aes)
+{
+	switch (mode)
+	{
+	case DRV_CIPHER_ECB:
+		return is_aes ? CC_REE_FIPS_ERROR_AES_ECB_PUT : CC_REE_FIPS_ERROR_DES_ECB_PUT ;
+	case DRV_CIPHER_CBC:
+		return is_aes ? CC_REE_FIPS_ERROR_AES_CBC_PUT : CC_REE_FIPS_ERROR_DES_CBC_PUT ;
+	case DRV_CIPHER_OFB:
+		return CC_REE_FIPS_ERROR_AES_OFB_PUT;
+	case DRV_CIPHER_CTR:
+		return CC_REE_FIPS_ERROR_AES_CTR_PUT;
+	case DRV_CIPHER_CBC_CTS:
+		return CC_REE_FIPS_ERROR_AES_CBC_CTS_PUT;
+	case DRV_CIPHER_XTS:
+		return CC_REE_FIPS_ERROR_AES_XTS_PUT;
+	default:
+		return CC_REE_FIPS_ERROR_GENERAL;
+	}
+
+	return CC_REE_FIPS_ERROR_GENERAL;
+}
+
+
+static inline int 
+ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
+			 bool is_aes,
+			 int cipher_mode,
+			 int direction,
+			 dma_addr_t key_dma_addr,
+			 size_t key_len,
+			 dma_addr_t iv_dma_addr,
+			 size_t iv_len,
+			 dma_addr_t din_dma_addr,
+			 dma_addr_t dout_dma_addr,
+			 size_t data_size)
+{
+	/* max number of descriptors used for the flow */
+	#define FIPS_CIPHER_MAX_SEQ_LEN 6
+
+	int rc;
+	struct ssi_crypto_req ssi_req = {0};
+	HwDesc_s desc[FIPS_CIPHER_MAX_SEQ_LEN];
+	int idx = 0;
+	int s_flow_mode = is_aes ? S_DIN_to_AES : S_DIN_to_DES;
+
+	/* create setup descriptors */
+	switch (cipher_mode) {
+	case DRV_CIPHER_CBC:
+	case DRV_CIPHER_CBC_CTS:
+	case DRV_CIPHER_CTR:
+	case DRV_CIPHER_OFB:
+		/* Load cipher state */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				     iv_dma_addr, iv_len, NS_BIT);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
+		if ((cipher_mode == DRV_CIPHER_CTR) || 
+		    (cipher_mode == DRV_CIPHER_OFB) ) {
+			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		} else {
+			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		}
+		idx++;
+		/*FALLTHROUGH*/
+	case DRV_CIPHER_ECB:
+		/* Load key */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
+		if (is_aes) {
+			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+					     key_dma_addr, 
+					     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len),
+					     NS_BIT);
+			HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
+		} else {/*des*/
+			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+					     key_dma_addr, key_len,
+					     NS_BIT);
+			HW_DESC_SET_KEY_SIZE_DES(&desc[idx], key_len);
+		}
+		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+		break;
+	case DRV_CIPHER_XTS:
+		/* Load AES key */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				     key_dma_addr, key_len/2, NS_BIT);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len/2);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+
+		/* load XEX key */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+				     (key_dma_addr+key_len/2), key_len/2, NS_BIT);
+		HW_DESC_SET_XEX_DATA_UNIT_SIZE(&desc[idx], data_size);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len/2);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_XEX_KEY);
+		idx++;
+
+		/* Set state */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
+		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len/2);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				     iv_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
+		idx++;
+		break;
+	default:
+		FIPS_LOG("Unsupported cipher mode (%d)\n", cipher_mode);
+		BUG();
+	}
+
+	/* create data descriptor */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, din_dma_addr, data_size, NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], dout_dma_addr, data_size, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], is_aes ? DIN_AES_DOUT : DIN_DES_DOUT);
+	idx++;
+
+	/* perform the operation - Lock HW and push sequence */
+	BUG_ON(idx > FIPS_CIPHER_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, false);
+
+	// send_request returns error just in some corner cases which should not appear in this flow.
+	return rc;
+}
+
+
+ssi_fips_error_t
+ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
+{
+	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	size_t i;
+	struct fips_cipher_ctx *virt_ctx = (struct fips_cipher_ctx *)cpu_addr_buffer;
+
+	/* set the phisical pointers for iv, key, din, dout */
+	dma_addr_t iv_dma_addr = dma_coherent_buffer + offsetof(struct fips_cipher_ctx, iv);
+	dma_addr_t key_dma_addr = dma_coherent_buffer + offsetof(struct fips_cipher_ctx, key);
+	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_cipher_ctx, din);
+	dma_addr_t dout_dma_addr = dma_coherent_buffer + offsetof(struct fips_cipher_ctx, dout);
+
+	for (i = 0; i < FIPS_CIPHER_NUM_OF_TESTS; ++i)
+	{
+		FipsCipherData *cipherData = (FipsCipherData*)&FipsCipherDataTable[i];
+		int rc = 0;
+		size_t iv_size = cipherData->isAes ? NIST_AES_IV_SIZE : NIST_TDES_IV_SIZE ;
+
+		memset(cpu_addr_buffer, 0, sizeof(struct fips_cipher_ctx));
+
+		/* copy into the allocated buffer */
+		memcpy(virt_ctx->iv, cipherData->iv, iv_size);
+		memcpy(virt_ctx->key, cipherData->key, cipherData->keySize);
+		memcpy(virt_ctx->din, cipherData->dataIn, cipherData->dataInSize);
+
+		FIPS_DBG("ssi_cipher_fips_run_test -  (i = %d) \n", i);
+		rc = ssi_cipher_fips_run_test(drvdata,
+					      cipherData->isAes,
+					      cipherData->oprMode,
+					      cipherData->direction,
+					      key_dma_addr,
+					      cipherData->keySize,
+					      iv_dma_addr,
+					      iv_size,
+					      din_dma_addr,
+					      dout_dma_addr,
+					      cipherData->dataInSize);
+		if (rc != 0)
+		{
+			FIPS_LOG("ssi_cipher_fips_run_test %d returned error - rc = %d \n", i, rc);
+			error = FIPS_CipherToFipsError(cipherData->oprMode, cipherData->isAes);
+			break;
+		}
+
+		/* compare actual dout to expected */
+		if (memcmp(virt_ctx->dout, cipherData->dataOut, cipherData->dataInSize) != 0)
+		{
+			FIPS_LOG("dout comparison error %d - oprMode=%d, isAes=%d\n", i, cipherData->oprMode, cipherData->isAes);
+			FIPS_LOG("  i  expected   received \n");
+			FIPS_LOG("  i  0x%08x 0x%08x  (size=%d) \n", (size_t)cipherData->dataOut, (size_t)virt_ctx->dout, cipherData->dataInSize);
+			for (i = 0; i < cipherData->dataInSize; ++i)
+			{
+				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, cipherData->dataOut[i], virt_ctx->dout[i]);
+			}
+
+			error = FIPS_CipherToFipsError(cipherData->oprMode, cipherData->isAes);
+			break;
+		}
+	}
+
+	return error;
+}
+
+
+static inline int 
+ssi_cmac_fips_run_test(struct ssi_drvdata *drvdata,
+		       dma_addr_t key_dma_addr,
+		       size_t key_len,
+		       dma_addr_t din_dma_addr,
+		       size_t din_len,
+		       dma_addr_t digest_dma_addr,
+		       size_t digest_len)
+{
+	/* max number of descriptors used for the flow */
+	#define FIPS_CMAC_MAX_SEQ_LEN 4
+
+	int rc;
+	struct ssi_crypto_req ssi_req = {0};
+	HwDesc_s desc[FIPS_CMAC_MAX_SEQ_LEN];
+	int idx = 0;
+
+	/* Setup CMAC Key */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr,
+			     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len), NS_BIT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* Load MAC state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, digest_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+
+	//ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+			     din_dma_addr, 
+			     din_len, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	idx++;
+	
+	/* Get final MAC result */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], digest_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_AES_to_DOUT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC); 
+	idx++;
+
+	/* perform the operation - Lock HW and push sequence */
+	BUG_ON(idx > FIPS_CMAC_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, false);
+
+	// send_request returns error just in some corner cases which should not appear in this flow.
+	return rc;
+}
+
+ssi_fips_error_t
+ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
+{
+	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	size_t i;
+	struct fips_cmac_ctx *virt_ctx = (struct fips_cmac_ctx *)cpu_addr_buffer;
+
+	/* set the phisical pointers for key, din, dout */
+	dma_addr_t key_dma_addr = dma_coherent_buffer + offsetof(struct fips_cmac_ctx, key);
+	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_cmac_ctx, din);
+	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_cmac_ctx, mac_res);
+
+	for (i = 0; i < FIPS_CMAC_NUM_OF_TESTS; ++i)
+	{
+		FipsCmacData *cmac_data = (FipsCmacData*)&FipsCmacDataTable[i];
+		int rc = 0;
+
+		memset(cpu_addr_buffer, 0, sizeof(struct fips_cmac_ctx));
+
+		/* copy into the allocated buffer */
+		memcpy(virt_ctx->key, cmac_data->key, cmac_data->key_size);
+		memcpy(virt_ctx->din, cmac_data->data_in, cmac_data->data_in_size);
+
+		BUG_ON(cmac_data->direction != DRV_CRYPTO_DIRECTION_ENCRYPT);
+
+		FIPS_DBG("ssi_cmac_fips_run_test -  (i = %d) \n", i);
+		rc = ssi_cmac_fips_run_test(drvdata,
+					    key_dma_addr,
+					    cmac_data->key_size,
+					    din_dma_addr,
+					    cmac_data->data_in_size,
+					    mac_res_dma_addr,
+					    cmac_data->mac_res_size);
+		if (rc != 0)
+		{
+			FIPS_LOG("ssi_cmac_fips_run_test %d returned error - rc = %d \n", i, rc);
+			error = CC_REE_FIPS_ERROR_AES_CMAC_PUT;
+			break;
+		}
+
+		/* compare actual mac result to expected */
+		if (memcmp(virt_ctx->mac_res, cmac_data->mac_res, cmac_data->mac_res_size) != 0)
+		{
+			FIPS_LOG("comparison error %d - digest_size=%d \n", i, cmac_data->mac_res_size);
+			FIPS_LOG("  i  expected   received \n");
+			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)cmac_data->mac_res, (size_t)virt_ctx->mac_res);
+			for (i = 0; i < cmac_data->mac_res_size; ++i)
+			{
+				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, cmac_data->mac_res[i], virt_ctx->mac_res[i]);
+			}
+
+			error = CC_REE_FIPS_ERROR_AES_CMAC_PUT;
+			break;
+		}
+	}
+
+	return error;
+}
+
+
+static inline ssi_fips_error_t 
+FIPS_HashToFipsError(enum drv_hash_mode hash_mode)
+{
+	switch (hash_mode) {
+	case DRV_HASH_SHA1:
+		return CC_REE_FIPS_ERROR_SHA1_PUT;
+	case DRV_HASH_SHA256:
+		return CC_REE_FIPS_ERROR_SHA256_PUT;
+#if (CC_SUPPORT_SHA > 256)
+	case DRV_HASH_SHA512:
+		return CC_REE_FIPS_ERROR_SHA512_PUT;
+#endif
+	default:
+		return CC_REE_FIPS_ERROR_GENERAL;
+	}
+
+	return CC_REE_FIPS_ERROR_GENERAL;
+}
+
+static inline int 
+ssi_hash_fips_run_test(struct ssi_drvdata *drvdata,
+		       dma_addr_t initial_digest_dma_addr,
+		       dma_addr_t din_dma_addr,
+		       size_t data_in_size,
+		       dma_addr_t mac_res_dma_addr,
+		       enum drv_hash_mode hash_mode,
+		       enum drv_hash_hw_mode hw_mode,
+		       int digest_size,
+		       int inter_digestsize)
+{
+	/* max number of descriptors used for the flow */
+	#define FIPS_HASH_MAX_SEQ_LEN 4
+
+	int rc;
+	struct ssi_crypto_req ssi_req = {0};
+	HwDesc_s desc[FIPS_HASH_MAX_SEQ_LEN];
+	int idx = 0;
+
+	/* Load initial digest */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, initial_digest_dma_addr, inter_digestsize, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load the hash current length */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* data descriptor */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, din_dma_addr, data_in_size, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+	/* Get final MAC result */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, digest_size, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+	if (unlikely((hash_mode == DRV_HASH_MD5) ||
+		     (hash_mode == DRV_HASH_SHA384) ||
+		     (hash_mode == DRV_HASH_SHA512))) {
+		HW_DESC_SET_BYTES_SWAP(&desc[idx], 1);
+	} else {
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	}
+	idx++;
+
+	/* perform the operation - Lock HW and push sequence */
+	BUG_ON(idx > FIPS_HASH_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, false);
+
+	return rc;
+}
+
+ssi_fips_error_t
+ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
+{
+	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	size_t i;
+	struct fips_hash_ctx *virt_ctx = (struct fips_hash_ctx *)cpu_addr_buffer;
+
+	/* set the phisical pointers for initial_digest, din, mac_res */
+	dma_addr_t initial_digest_dma_addr = dma_coherent_buffer + offsetof(struct fips_hash_ctx, initial_digest);
+	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_hash_ctx, din);
+	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_hash_ctx, mac_res);
+
+	for (i = 0; i < FIPS_HASH_NUM_OF_TESTS; ++i)
+	{
+		FipsHashData *hash_data = (FipsHashData*)&FipsHashDataTable[i];
+		int rc = 0;
+		enum drv_hash_hw_mode hw_mode = 0;
+		int digest_size = 0;
+		int inter_digestsize = 0;
+
+		memset(cpu_addr_buffer, 0, sizeof(struct fips_hash_ctx));
+
+		switch (hash_data->hash_mode) {
+		case DRV_HASH_SHA1:
+			hw_mode = DRV_HASH_HW_SHA1;
+			digest_size = CC_SHA1_DIGEST_SIZE;
+			inter_digestsize = CC_SHA1_DIGEST_SIZE;
+			/* copy the initial digest into the allocated cache coherent buffer */
+			memcpy(virt_ctx->initial_digest, (void*)sha1_init, CC_SHA1_DIGEST_SIZE);
+			break;
+		case DRV_HASH_SHA256:
+			hw_mode = DRV_HASH_HW_SHA256;
+			digest_size = CC_SHA256_DIGEST_SIZE;
+			inter_digestsize = CC_SHA256_DIGEST_SIZE;
+			memcpy(virt_ctx->initial_digest, (void*)sha256_init, CC_SHA256_DIGEST_SIZE);
+			break;
+#if (CC_SUPPORT_SHA > 256)
+		case DRV_HASH_SHA512:
+			hw_mode = DRV_HASH_HW_SHA512;
+			digest_size = CC_SHA512_DIGEST_SIZE;
+			inter_digestsize = CC_SHA512_DIGEST_SIZE;
+			memcpy(virt_ctx->initial_digest, (void*)sha512_init, CC_SHA512_DIGEST_SIZE);
+			break;
+#endif
+		default:
+			error = FIPS_HashToFipsError(hash_data->hash_mode);
+			break;
+		}
+
+		/* copy the din data into the allocated buffer */
+		memcpy(virt_ctx->din, hash_data->data_in, hash_data->data_in_size);
+
+		/* run the test on HW */
+		FIPS_DBG("ssi_hash_fips_run_test -  (i = %d) \n", i);
+		rc = ssi_hash_fips_run_test(drvdata,
+					    initial_digest_dma_addr,
+					    din_dma_addr,
+					    hash_data->data_in_size,
+					    mac_res_dma_addr,
+					    hash_data->hash_mode,
+					    hw_mode,
+					    digest_size,
+					    inter_digestsize);
+		if (rc != 0)
+		{
+			FIPS_LOG("ssi_hash_fips_run_test %d returned error - rc = %d \n", i, rc);
+			error = FIPS_HashToFipsError(hash_data->hash_mode);
+			break;
+                }
+
+		/* compare actual mac result to expected */
+		if (memcmp(virt_ctx->mac_res, hash_data->mac_res, digest_size) != 0)
+		{
+			FIPS_LOG("comparison error %d - hash_mode=%d digest_size=%d \n", i, hash_data->hash_mode, digest_size);
+			FIPS_LOG("  i  expected   received \n");
+			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)hash_data->mac_res, (size_t)virt_ctx->mac_res);
+			for (i = 0; i < digest_size; ++i)
+			{
+				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, hash_data->mac_res[i], virt_ctx->mac_res[i]);
+			}
+
+			error = FIPS_HashToFipsError(hash_data->hash_mode);
+			break;
+                }
+	}
+
+	return error;
+}
+
+
+static inline ssi_fips_error_t 
+FIPS_HmacToFipsError(enum drv_hash_mode hash_mode)
+{
+	switch (hash_mode) {
+	case DRV_HASH_SHA1:
+		return CC_REE_FIPS_ERROR_HMAC_SHA1_PUT;
+	case DRV_HASH_SHA256:
+		return CC_REE_FIPS_ERROR_HMAC_SHA256_PUT;
+#if (CC_SUPPORT_SHA > 256)
+	case DRV_HASH_SHA512:
+		return CC_REE_FIPS_ERROR_HMAC_SHA512_PUT;
+#endif
+	default:
+		return CC_REE_FIPS_ERROR_GENERAL;
+	}
+
+	return CC_REE_FIPS_ERROR_GENERAL;
+}
+
+static inline int 
+ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
+		       dma_addr_t initial_digest_dma_addr,
+		       dma_addr_t key_dma_addr,
+		       size_t key_size,
+		       dma_addr_t din_dma_addr,
+		       size_t data_in_size,
+		       dma_addr_t mac_res_dma_addr,
+		       enum drv_hash_mode hash_mode,
+		       enum drv_hash_hw_mode hw_mode,
+		       size_t digest_size,
+		       size_t inter_digestsize,
+		       size_t block_size,
+		       dma_addr_t k0_dma_addr,
+		       dma_addr_t tmp_digest_dma_addr,
+		       dma_addr_t digest_bytes_len_dma_addr)
+{
+	/* The implemented flow is not the same as the one implemented in ssi_hash.c (setkey + digest flows).
+	   In this flow, there is no need to store and reload some of the intermidiate results. */
+
+	/* max number of descriptors used for the flow */
+	#define FIPS_HMAC_MAX_SEQ_LEN 12
+
+	int rc;
+	struct ssi_crypto_req ssi_req = {0};
+	HwDesc_s desc[FIPS_HMAC_MAX_SEQ_LEN];
+	int idx = 0;
+	int i;
+	/* calc the hash opad first and ipad only afterwards (unlike the flow in ssi_hash.c) */
+	unsigned int hmacPadConst[2] = { HMAC_OPAD_CONST, HMAC_IPAD_CONST };
+
+	// assume (key_size <= block_size)
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr, key_size, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], k0_dma_addr, key_size, NS_BIT, 0);
+	idx++;
+
+	// if needed, append Key with zeros to create K0
+	if ((block_size - key_size) != 0) {
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_CONST(&desc[idx], 0, (block_size - key_size));
+		HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+		HW_DESC_SET_DOUT_DLLI(&desc[idx], 
+				      (k0_dma_addr + key_size), (block_size - key_size),
+				      NS_BIT, 0);
+		idx++;
+	}
+
+	BUG_ON(idx > FIPS_HMAC_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, 0);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
+		return rc;
+	}
+	idx = 0;
+
+	/* calc derived HMAC key */
+	for (i = 0; i < 2; i++) {
+		/* Load hash initial state */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, initial_digest_dma_addr, inter_digestsize, NS_BIT);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		idx++;
+
+
+		/* Load the hash current length*/
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+		HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		idx++;
+
+		/* Prepare opad/ipad key */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_XOR_VAL(&desc[idx], hmacPadConst[i]);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		idx++;
+
+		/* Perform HASH update */
+		HW_DESC_INIT(&desc[idx]);
+		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+				     k0_dma_addr,
+				     block_size, NS_BIT);
+		HW_DESC_SET_CIPHER_MODE(&desc[idx],hw_mode);
+		HW_DESC_SET_XOR_ACTIVE(&desc[idx]);
+		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		idx++;
+
+		if (i == 0) {
+			/* First iteration - calc H(K0^opad) into tmp_digest_dma_addr */
+			HW_DESC_INIT(&desc[idx]);
+			HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+			HW_DESC_SET_DOUT_DLLI(&desc[idx],
+					      tmp_digest_dma_addr,
+					      inter_digestsize,
+					      NS_BIT, 0);
+			HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+			idx++;
+
+			// is this needed?? or continue with current descriptors??
+			BUG_ON(idx > FIPS_HMAC_MAX_SEQ_LEN);
+			rc = send_request(drvdata, &ssi_req, desc, idx, 0);
+			if (unlikely(rc != 0)) {
+				SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
+				return rc;
+			}
+			idx = 0;
+		}
+	}
+
+	/* data descriptor */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+			     din_dma_addr, data_in_size,
+			     NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+	/* HW last hash block padding (aka. "DO_PAD") */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], k0_dma_addr, HASH_LEN_SIZE, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
+	HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
+	idx++;
+
+	/* store the hash digest result in the context */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], k0_dma_addr, digest_size, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	if (unlikely((hash_mode == DRV_HASH_MD5) ||
+		     (hash_mode == DRV_HASH_SHA384) ||
+		     (hash_mode == DRV_HASH_SHA512))) {
+		HW_DESC_SET_BYTES_SWAP(&desc[idx], 1);
+	} else {
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	}
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	idx++;
+
+	/* at this point:
+	   tmp_digest = H(o_key_pad)
+	   k0 = H(i_key_pad || m)
+	   */
+
+	/* Loading hash opad xor key state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, tmp_digest_dma_addr, inter_digestsize, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load the hash current length */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* Perform HASH update */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, k0_dma_addr, digest_size, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+
+	/* Get final MAC result */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, digest_size, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+	if (unlikely((hash_mode == DRV_HASH_MD5) ||
+		     (hash_mode == DRV_HASH_SHA384) ||
+		     (hash_mode == DRV_HASH_SHA512))) {
+		HW_DESC_SET_BYTES_SWAP(&desc[idx], 1);
+	} else {
+		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	}
+	idx++;
+
+	/* perform the operation - Lock HW and push sequence */
+	BUG_ON(idx > FIPS_HMAC_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, false);
+
+	return rc;
+}
+
+ssi_fips_error_t
+ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
+{
+	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	size_t i;
+	struct fips_hmac_ctx *virt_ctx = (struct fips_hmac_ctx *)cpu_addr_buffer;
+
+	/* set the phisical pointers */
+	dma_addr_t initial_digest_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, initial_digest);
+	dma_addr_t key_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, key);
+	dma_addr_t k0_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, k0);
+	dma_addr_t tmp_digest_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, tmp_digest);
+	dma_addr_t digest_bytes_len_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, digest_bytes_len);
+	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, din);
+	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, mac_res);
+
+	for (i = 0; i < FIPS_HMAC_NUM_OF_TESTS; ++i)
+	{
+		FipsHmacData *hmac_data = (FipsHmacData*)&FipsHmacDataTable[i];
+		int rc = 0;
+		enum drv_hash_hw_mode hw_mode = 0;
+		int digest_size = 0;
+		int block_size = 0;
+		int inter_digestsize = 0;
+
+		memset(cpu_addr_buffer, 0, sizeof(struct fips_hmac_ctx));
+
+		switch (hmac_data->hash_mode) {
+		case DRV_HASH_SHA1:
+			hw_mode = DRV_HASH_HW_SHA1;
+			digest_size = CC_SHA1_DIGEST_SIZE;
+			block_size = CC_SHA1_BLOCK_SIZE;
+			inter_digestsize = CC_SHA1_DIGEST_SIZE;
+			memcpy(virt_ctx->initial_digest, (void*)sha1_init, CC_SHA1_DIGEST_SIZE);
+			memcpy(virt_ctx->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+			break;
+		case DRV_HASH_SHA256:
+			hw_mode = DRV_HASH_HW_SHA256;
+			digest_size = CC_SHA256_DIGEST_SIZE;
+			block_size = CC_SHA256_BLOCK_SIZE;
+			inter_digestsize = CC_SHA256_DIGEST_SIZE;
+			memcpy(virt_ctx->initial_digest, (void*)sha256_init, CC_SHA256_DIGEST_SIZE);
+			memcpy(virt_ctx->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+			break;
+#if (CC_SUPPORT_SHA > 256)
+		case DRV_HASH_SHA512:
+			hw_mode = DRV_HASH_HW_SHA512;
+			digest_size = CC_SHA512_DIGEST_SIZE;
+			block_size = CC_SHA512_BLOCK_SIZE;
+			inter_digestsize = CC_SHA512_DIGEST_SIZE;
+			memcpy(virt_ctx->initial_digest, (void*)sha512_init, CC_SHA512_DIGEST_SIZE);
+			memcpy(virt_ctx->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
+			break;
+#endif
+		default:
+			error = FIPS_HmacToFipsError(hmac_data->hash_mode);
+			break;
+		}
+
+		/* copy into the allocated buffer */
+		memcpy(virt_ctx->key, hmac_data->key, hmac_data->key_size);
+		memcpy(virt_ctx->din, hmac_data->data_in, hmac_data->data_in_size);
+
+		/* run the test on HW */
+		FIPS_DBG("ssi_hmac_fips_run_test -  (i = %d) \n", i);
+		rc = ssi_hmac_fips_run_test(drvdata,
+					    initial_digest_dma_addr,
+					    key_dma_addr,
+					    hmac_data->key_size,
+					    din_dma_addr,
+					    hmac_data->data_in_size,
+					    mac_res_dma_addr,
+					    hmac_data->hash_mode,
+					    hw_mode,
+					    digest_size,
+					    inter_digestsize,
+					    block_size,
+					    k0_dma_addr,
+					    tmp_digest_dma_addr,
+					    digest_bytes_len_dma_addr);
+		if (rc != 0)
+		{
+			FIPS_LOG("ssi_hmac_fips_run_test %d returned error - rc = %d \n", i, rc);
+			error = FIPS_HmacToFipsError(hmac_data->hash_mode);
+			break;
+		}
+
+		/* compare actual mac result to expected */
+		if (memcmp(virt_ctx->mac_res, hmac_data->mac_res, digest_size) != 0)
+		{
+			FIPS_LOG("comparison error %d - hash_mode=%d digest_size=%d \n", i, hmac_data->hash_mode, digest_size);
+			FIPS_LOG("  i  expected   received \n");
+			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)hmac_data->mac_res, (size_t)virt_ctx->mac_res);
+			for (i = 0; i < digest_size; ++i)
+			{
+				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, hmac_data->mac_res[i], virt_ctx->mac_res[i]);
+			}
+
+			error = FIPS_HmacToFipsError(hmac_data->hash_mode);
+			break;
+		}
+	}
+
+	return error;
+}
+
+
+static inline int 
+ssi_ccm_fips_run_test(struct ssi_drvdata *drvdata,
+		      enum drv_crypto_direction direction,
+		      dma_addr_t key_dma_addr,
+		      size_t key_size,
+		      dma_addr_t iv_dma_addr,
+		      dma_addr_t ctr_cnt_0_dma_addr,
+		      dma_addr_t b0_a0_adata_dma_addr,
+		      size_t b0_a0_adata_size,
+		      dma_addr_t din_dma_addr,
+		      size_t din_size,
+		      dma_addr_t dout_dma_addr,
+		      dma_addr_t mac_res_dma_addr)
+{
+	/* max number of descriptors used for the flow */
+	#define FIPS_CCM_MAX_SEQ_LEN 10
+
+	int rc;
+	struct ssi_crypto_req ssi_req = {0};
+	HwDesc_s desc[FIPS_CCM_MAX_SEQ_LEN];
+	unsigned int idx = 0;
+	unsigned int cipher_flow_mode;
+
+	if (direction == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		cipher_flow_mode = AES_to_HASH_and_DOUT;
+	} else { /* Encrypt */
+		cipher_flow_mode = AES_and_HASH;
+	}
+
+	/* load key */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr,
+			     ((key_size == NIST_AESCCM_192_BIT_KEY_SIZE) ? CC_AES_KEY_SIZE_MAX : key_size),
+			     NS_BIT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load ctr state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     iv_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load MAC key */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr,
+			     ((key_size == NIST_AESCCM_192_BIT_KEY_SIZE) ? CC_AES_KEY_SIZE_MAX : key_size),
+			     NS_BIT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* load MAC state */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++;
+
+	/* prcess assoc data */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, b0_a0_adata_dma_addr, b0_a0_adata_size, NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+	/* process the cipher */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, din_dma_addr, din_size, NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], dout_dma_addr, din_size, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], cipher_flow_mode);
+	idx++;
+
+	/* Read temporal MAC */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT, 0);
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
+			     ctr_cnt_0_dma_addr,
+			     AES_BLOCK_SIZE, NS_BIT);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
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
+	/* encrypt the "T" value and store MAC inplace */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	idx++;	
+
+	/* perform the operation - Lock HW and push sequence */
+	BUG_ON(idx > FIPS_CCM_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, false);
+
+	return rc;
+}
+
+ssi_fips_error_t
+ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
+{
+	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	size_t i;
+	struct fips_ccm_ctx *virt_ctx = (struct fips_ccm_ctx *)cpu_addr_buffer;
+
+	/* set the phisical pointers */
+	dma_addr_t b0_a0_adata_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, b0_a0_adata);
+	dma_addr_t iv_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, iv);
+	dma_addr_t ctr_cnt_0_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, ctr_cnt_0);
+	dma_addr_t key_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, key);
+	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, din);
+	dma_addr_t dout_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, dout);
+	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, mac_res);
+
+	for (i = 0; i < FIPS_CCM_NUM_OF_TESTS; ++i)
+	{
+		FipsCcmData *ccmData = (FipsCcmData*)&FipsCcmDataTable[i];
+		int rc = 0;
+
+		memset(cpu_addr_buffer, 0, sizeof(struct fips_ccm_ctx));
+
+		/* copy the nonce, key, adata, din data into the allocated buffer */
+		memcpy(virt_ctx->key, ccmData->key, ccmData->keySize);
+		memcpy(virt_ctx->din, ccmData->dataIn, ccmData->dataInSize);
+		{
+			/* build B0 -- B0, nonce, l(m) */
+			__be16 data = cpu_to_be16(NIST_AESCCM_TEXT_SIZE);
+			virt_ctx->b0_a0_adata[0] = NIST_AESCCM_B0_VAL;
+			memcpy(virt_ctx->b0_a0_adata + 1, ccmData->nonce, NIST_AESCCM_NONCE_SIZE);
+			memcpy(virt_ctx->b0_a0_adata + 14, (u8 *)&data, sizeof(__be16));
+			/* build A0+ADATA */
+			virt_ctx->b0_a0_adata[NIST_AESCCM_IV_SIZE + 0] = (ccmData->adataSize >> 8) & 0xFF;
+			virt_ctx->b0_a0_adata[NIST_AESCCM_IV_SIZE + 1] = ccmData->adataSize & 0xFF;
+			memcpy(virt_ctx->b0_a0_adata + NIST_AESCCM_IV_SIZE + 2, ccmData->adata, ccmData->adataSize);
+			/* iv */
+			virt_ctx->iv[0] = 1; /* L' */
+			memcpy(virt_ctx->iv + 1, ccmData->nonce, NIST_AESCCM_NONCE_SIZE);
+			virt_ctx->iv[15] = 1;
+			/* ctr_count_0 */
+			memcpy(virt_ctx->ctr_cnt_0, virt_ctx->iv, NIST_AESCCM_IV_SIZE);
+			virt_ctx->ctr_cnt_0[15] = 0;
+		}
+
+		FIPS_DBG("ssi_ccm_fips_run_test -  (i = %d) \n", i);
+		rc = ssi_ccm_fips_run_test(drvdata,
+					   ccmData->direction,
+					   key_dma_addr,
+					   ccmData->keySize,
+					   iv_dma_addr,
+					   ctr_cnt_0_dma_addr,
+					   b0_a0_adata_dma_addr,
+					   FIPS_CCM_B0_A0_ADATA_SIZE,
+					   din_dma_addr,
+					   ccmData->dataInSize,
+					   dout_dma_addr,
+					   mac_res_dma_addr);
+		if (rc != 0)
+		{
+			FIPS_LOG("ssi_ccm_fips_run_test %d returned error - rc = %d \n", i, rc);
+			error = CC_REE_FIPS_ERROR_AESCCM_PUT;
+			break;
+		}
+
+		/* compare actual dout to expected */
+		if (memcmp(virt_ctx->dout, ccmData->dataOut, ccmData->dataInSize) != 0)
+		{
+			FIPS_LOG("dout comparison error %d - size=%d \n", i, ccmData->dataInSize);
+                        error = CC_REE_FIPS_ERROR_AESCCM_PUT;
+			break;
+                }
+
+		/* compare actual mac result to expected */
+		if (memcmp(virt_ctx->mac_res, ccmData->macResOut, ccmData->tagSize) != 0)
+		{
+			FIPS_LOG("mac_res comparison error %d - mac_size=%d \n", i, ccmData->tagSize);
+			FIPS_LOG("  i  expected   received \n");
+			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)ccmData->macResOut, (size_t)virt_ctx->mac_res);
+			for (i = 0; i < ccmData->tagSize; ++i)
+			{
+				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, ccmData->macResOut[i], virt_ctx->mac_res[i]);
+			}
+
+			error = CC_REE_FIPS_ERROR_AESCCM_PUT;
+			break;
+		}
+	}
+
+	return error;
+}
+
+
+static inline int
+ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
+		      enum drv_crypto_direction direction,
+		      dma_addr_t key_dma_addr,
+		      size_t key_size,
+		      dma_addr_t hkey_dma_addr,
+		      dma_addr_t block_len_dma_addr,
+		      dma_addr_t iv_inc1_dma_addr,
+		      dma_addr_t iv_inc2_dma_addr,
+		      dma_addr_t adata_dma_addr,
+		      size_t adata_size,
+		      dma_addr_t din_dma_addr,
+		      size_t din_size,
+		      dma_addr_t dout_dma_addr,
+		      dma_addr_t mac_res_dma_addr)
+{
+	/* max number of descriptors used for the flow */
+	#define FIPS_GCM_MAX_SEQ_LEN 15
+
+	int rc;
+	struct ssi_crypto_req ssi_req = {0};
+	HwDesc_s desc[FIPS_GCM_MAX_SEQ_LEN];
+	unsigned int idx = 0;
+	unsigned int cipher_flow_mode;
+
+	if (direction == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		cipher_flow_mode = AES_and_HASH;
+	} else { /* Encrypt */
+		cipher_flow_mode = AES_to_HASH_and_DOUT;
+	}
+
+/////////////////////////////////   1   ////////////////////////////////////
+//	ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
+/////////////////////////////////   1   ////////////////////////////////////
+
+	/* load key to AES*/
+	HW_DESC_INIT(&desc[idx]);	
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_ECB);	
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_DIN_TYPE(&desc[idx],
+			     DMA_DLLI, key_dma_addr, key_size,
+			     NS_BIT); 
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* process one zero block to generate hkey */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx],
+			      hkey_dma_addr, AES_BLOCK_SIZE,
+			      NS_BIT, 0); 
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
+			     hkey_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
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
+
+
+/////////////////////////////////   2   ////////////////////////////////////
+	/* prcess(ghash) assoc data */
+//	if (req->assoclen > 0)
+//		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
+/////////////////////////////////   2   ////////////////////////////////////
+
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+			     adata_dma_addr, adata_size,
+			     NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+
+/////////////////////////////////   3   ////////////////////////////////////
+//	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
+/////////////////////////////////   3   ////////////////////////////////////
+
+	/* load key to AES*/
+	HW_DESC_INIT(&desc[idx]);	
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);	
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     key_dma_addr, key_size,
+			     NS_BIT); 
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+	/* load AES/CTR initial CTR value inc by 2*/
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     iv_inc2_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
+	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);	
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	idx++;
+
+
+/////////////////////////////////   4   ////////////////////////////////////
+	/* process(gctr+ghash) */
+//	if (req_ctx->cryptlen != 0)
+//		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size); 
+/////////////////////////////////   4   ////////////////////////////////////
+
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     din_dma_addr, din_size,
+			     NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx],
+			      dout_dma_addr, din_size,
+			      NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], cipher_flow_mode);
+	idx++;
+
+
+/////////////////////////////////   5   ////////////////////////////////////
+//	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
+/////////////////////////////////   5   ////////////////////////////////////
+
+	/* prcess(ghash) gcm_block_len */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, 
+			     block_len_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	idx++;
+
+	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
+	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx],
+			      mac_res_dma_addr, AES_BLOCK_SIZE,
+			      NS_BIT, 0);
+	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	idx++; 
+
+	/* load AES/CTR initial CTR value inc by 1*/
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
+	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     iv_inc1_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
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
+	/* process GCTR on stored GHASH and store MAC inplace */
+	HW_DESC_INIT(&desc[idx]);
+	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
+	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
+			     mac_res_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
+	HW_DESC_SET_DOUT_DLLI(&desc[idx],
+			      mac_res_dma_addr, AES_BLOCK_SIZE,
+			      NS_BIT, 0);
+	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	idx++;
+
+	/* perform the operation - Lock HW and push sequence */
+	BUG_ON(idx > FIPS_GCM_MAX_SEQ_LEN);
+	rc = send_request(drvdata, &ssi_req, desc, idx, false);
+
+	return rc;
+}
+
+ssi_fips_error_t
+ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
+{
+	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	size_t i;
+	struct fips_gcm_ctx *virt_ctx = (struct fips_gcm_ctx *)cpu_addr_buffer;
+
+	/* set the phisical pointers */
+	dma_addr_t adata_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, adata);
+	dma_addr_t key_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, key);
+	dma_addr_t hkey_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, hkey);
+	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, din);
+	dma_addr_t dout_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, dout);
+	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, mac_res);
+	dma_addr_t len_block_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, len_block);
+	dma_addr_t iv_inc1_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, iv_inc1);
+	dma_addr_t iv_inc2_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, iv_inc2);
+
+	for (i = 0; i < FIPS_GCM_NUM_OF_TESTS; ++i)
+	{
+		FipsGcmData *gcmData = (FipsGcmData*)&FipsGcmDataTable[i];
+		int rc = 0;
+
+		memset(cpu_addr_buffer, 0, sizeof(struct fips_gcm_ctx));
+
+		/* copy the key, adata, din data - into the allocated buffer */
+		memcpy(virt_ctx->key, gcmData->key, gcmData->keySize);
+		memcpy(virt_ctx->adata, gcmData->adata, gcmData->adataSize);
+		memcpy(virt_ctx->din, gcmData->dataIn, gcmData->dataInSize);
+
+		/* len_block */
+		{
+			__be64 len_bits;
+			len_bits = cpu_to_be64(gcmData->adataSize * 8);
+			memcpy(virt_ctx->len_block, &len_bits, sizeof(len_bits));
+			len_bits = cpu_to_be64(gcmData->dataInSize * 8);
+			memcpy(virt_ctx->len_block + 8, &len_bits, sizeof(len_bits));
+		}
+		/* iv_inc1, iv_inc2 */
+		{
+			__be32 counter = cpu_to_be32(1);
+			memcpy(virt_ctx->iv_inc1, gcmData->iv, NIST_AESGCM_IV_SIZE);
+			memcpy(virt_ctx->iv_inc1 + NIST_AESGCM_IV_SIZE, &counter, sizeof(counter));
+			counter = cpu_to_be32(2);
+			memcpy(virt_ctx->iv_inc2, gcmData->iv, NIST_AESGCM_IV_SIZE);
+			memcpy(virt_ctx->iv_inc2 + NIST_AESGCM_IV_SIZE, &counter, sizeof(counter));
+		}
+
+		FIPS_DBG("ssi_gcm_fips_run_test -  (i = %d) \n", i);
+		rc = ssi_gcm_fips_run_test(drvdata,
+					   gcmData->direction,
+					   key_dma_addr,
+					   gcmData->keySize,
+					   hkey_dma_addr,
+					   len_block_dma_addr,
+					   iv_inc1_dma_addr,
+					   iv_inc2_dma_addr,
+					   adata_dma_addr,
+					   gcmData->adataSize,
+					   din_dma_addr,
+					   gcmData->dataInSize,
+					   dout_dma_addr,
+					   mac_res_dma_addr);
+		if (rc != 0)
+		{
+			FIPS_LOG("ssi_gcm_fips_run_test %d returned error - rc = %d \n", i, rc);
+			error = CC_REE_FIPS_ERROR_AESGCM_PUT;
+			break;
+		}
+
+		if (gcmData->direction == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+			/* compare actual dout to expected */
+			if (memcmp(virt_ctx->dout, gcmData->dataOut, gcmData->dataInSize) != 0)
+			{
+				FIPS_LOG("dout comparison error %d - size=%d \n", i, gcmData->dataInSize);
+				FIPS_LOG("  i  expected   received \n");
+				FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)gcmData->dataOut, (size_t)virt_ctx->dout);
+				for (i = 0; i < gcmData->dataInSize; ++i)
+				{
+					FIPS_LOG("  %d    0x%02x     0x%02x \n", i, gcmData->dataOut[i], virt_ctx->dout[i]);
+				}
+
+				error = CC_REE_FIPS_ERROR_AESGCM_PUT;
+				break;
+			}
+		}
+
+		/* compare actual mac result to expected */
+		if (memcmp(virt_ctx->mac_res, gcmData->macResOut, gcmData->tagSize) != 0)
+		{
+			FIPS_LOG("mac_res comparison error %d - mac_size=%d \n", i, gcmData->tagSize);
+			FIPS_LOG("  i  expected   received \n");
+			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)gcmData->macResOut, (size_t)virt_ctx->mac_res);
+			for (i = 0; i < gcmData->tagSize; ++i)
+			{
+				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, gcmData->macResOut[i], virt_ctx->mac_res[i]);
+			}
+
+			error = CC_REE_FIPS_ERROR_AESGCM_PUT;
+			break;
+		}
+	}
+	return error;
+}
+
+
+size_t ssi_fips_max_mem_alloc_size(void)
+{
+	FIPS_DBG("sizeof(struct fips_cipher_ctx) %d \n", sizeof(struct fips_cipher_ctx));
+	FIPS_DBG("sizeof(struct fips_cmac_ctx) %d \n", sizeof(struct fips_cmac_ctx));
+	FIPS_DBG("sizeof(struct fips_hash_ctx) %d \n", sizeof(struct fips_hash_ctx));
+	FIPS_DBG("sizeof(struct fips_hmac_ctx) %d \n", sizeof(struct fips_hmac_ctx));
+	FIPS_DBG("sizeof(struct fips_ccm_ctx) %d \n", sizeof(struct fips_ccm_ctx));
+	FIPS_DBG("sizeof(struct fips_gcm_ctx) %d \n", sizeof(struct fips_gcm_ctx));
+
+	return sizeof(fips_ctx);
+}
+
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
new file mode 100644
index 0000000..508031c
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -0,0 +1,369 @@
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
+/**************************************************************
+This file defines the driver FIPS internal function, used by the driver itself.
+***************************************************************/
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <crypto/des.h>
+
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "cc_hal.h"
+
+
+#define FIPS_POWER_UP_TEST_CIPHER	1
+#define FIPS_POWER_UP_TEST_CMAC		1
+#define FIPS_POWER_UP_TEST_HASH		1
+#define FIPS_POWER_UP_TEST_HMAC		1
+#define FIPS_POWER_UP_TEST_CCM		1
+#define FIPS_POWER_UP_TEST_GCM		1
+
+static bool ssi_fips_support = 1;
+module_param(ssi_fips_support, bool, 0644);
+MODULE_PARM_DESC(ssi_fips_support, "FIPS supported flag: 0 - off , 1 - on (default)");
+
+static void fips_dsr(unsigned long devarg);
+
+struct ssi_fips_handle {
+#ifdef COMP_IN_WQ
+	struct workqueue_struct *workq;
+	struct delayed_work fipswork;
+#else
+	struct tasklet_struct fipstask;
+#endif
+};
+
+
+extern int ssi_fips_get_state(ssi_fips_state_t *p_state);
+extern int ssi_fips_get_error(ssi_fips_error_t *p_err);
+extern int ssi_fips_ext_set_state(ssi_fips_state_t state);
+extern int ssi_fips_ext_set_error(ssi_fips_error_t err);
+
+/* FIPS power-up tests */
+extern ssi_fips_error_t ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern ssi_fips_error_t ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern ssi_fips_error_t ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern ssi_fips_error_t ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern ssi_fips_error_t ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern ssi_fips_error_t ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern size_t ssi_fips_max_mem_alloc_size(void);
+
+
+/* The function called once at driver entry point to check whether TEE FIPS error occured.*/
+static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
+{
+	uint32_t regVal;
+	void __iomem *cc_base = drvdata->cc_base;
+
+	regVal = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, GPR_HOST));
+	if (regVal == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK)) {
+		return CC_REE_FIPS_ERROR_OK;
+	} 
+	return CC_REE_FIPS_ERROR_FROM_TEE;
+}
+
+
+/* 
+ This function should push the FIPS REE library status towards the TEE library.
+ By writing the error state to HOST_GPR0 register. The function is called from  						.
+ driver entry point so no need to protect by mutex.
+*/
+static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, ssi_fips_error_t err)
+{
+	void __iomem *cc_base = drvdata->cc_base;
+	if (err == CC_REE_FIPS_ERROR_OK) {
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS|CC_FIPS_SYNC_MODULE_OK));
+	} else {
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS|CC_FIPS_SYNC_MODULE_ERROR));
+	}
+}
+
+
+
+void ssi_fips_fini(struct ssi_drvdata *drvdata)
+{
+	struct ssi_fips_handle *fips_h = drvdata->fips_handle;
+
+	if (fips_h == NULL)
+		return; /* Not allocated */
+
+#ifdef COMP_IN_WQ
+	if (fips_h->workq != NULL) {
+		flush_workqueue(fips_h->workq);
+		destroy_workqueue(fips_h->workq);
+	}
+#else
+	/* Kill tasklet */
+	tasklet_kill(&fips_h->fipstask);
+#endif
+	memset(fips_h, 0, sizeof(struct ssi_fips_handle));
+	kfree(fips_h);
+	drvdata->fips_handle = NULL;
+}
+
+void fips_handler(struct ssi_drvdata *drvdata)
+{
+	struct ssi_fips_handle *fips_handle_ptr = 
+						drvdata->fips_handle;
+#ifdef COMP_IN_WQ
+	queue_delayed_work(fips_handle_ptr->workq, &fips_handle_ptr->fipswork, 0);
+#else
+	tasklet_schedule(&fips_handle_ptr->fipstask);
+#endif
+}
+
+
+
+#ifdef COMP_IN_WQ
+static void fips_wq_handler(struct work_struct *work)
+{
+	struct ssi_drvdata *drvdata =
+		container_of(work, struct ssi_drvdata, fipswork.work);
+
+	fips_dsr((unsigned long)drvdata);
+}
+#endif
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void fips_dsr(unsigned long devarg)
+{
+	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
+	void __iomem *cc_base = drvdata->cc_base;
+	uint32_t irq;
+	uint32_t teeFipsError = 0;
+
+	irq = (drvdata->irq & (SSI_GPR0_IRQ_MASK));
+
+	if (irq & SSI_GPR0_IRQ_MASK) {
+		teeFipsError = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, GPR_HOST));
+		if (teeFipsError != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK)) {
+			ssi_fips_set_error(drvdata, CC_REE_FIPS_ERROR_FROM_TEE);
+		} 
+	}
+
+	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), 
+		CC_HAL_READ_REGISTER(
+		CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
+}
+
+
+ssi_fips_error_t cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
+{
+	ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
+	void * cpu_addr_buffer = NULL;
+	dma_addr_t dma_handle;
+	size_t alloc_buff_size = ssi_fips_max_mem_alloc_size();
+	struct device *dev = &drvdata->plat_dev->dev;
+
+	// allocate memory using dma_alloc_coherent - for phisical, consecutive and cache coherent buffer (memory map is not needed)
+	// the return value is the virtual address - use it to copy data into the buffer
+	// the dma_handle is the returned phy address - use it in the HW descriptor
+	FIPS_DBG("dma_alloc_coherent \n");
+	cpu_addr_buffer = dma_alloc_coherent(dev, alloc_buff_size, &dma_handle, GFP_KERNEL);
+	if (cpu_addr_buffer == NULL) {
+		return CC_REE_FIPS_ERROR_GENERAL;
+	}
+	FIPS_DBG("allocated coherent buffer - addr 0x%08X , size = %d \n", (size_t)cpu_addr_buffer, alloc_buff_size);
+
+#if FIPS_POWER_UP_TEST_CIPHER
+	FIPS_DBG("ssi_cipher_fips_power_up_tests ...\n");
+	fips_error = ssi_cipher_fips_power_up_tests(drvdata, cpu_addr_buffer, dma_handle);
+	FIPS_DBG("ssi_cipher_fips_power_up_tests - done. (fips_error = %d) \n", fips_error);
+#endif
+#if FIPS_POWER_UP_TEST_CMAC
+	if (likely(fips_error == CC_REE_FIPS_ERROR_OK)) {
+		FIPS_DBG("ssi_cmac_fips_power_up_tests ...\n");
+		fips_error = ssi_cmac_fips_power_up_tests(drvdata, cpu_addr_buffer, dma_handle);
+		FIPS_DBG("ssi_cmac_fips_power_up_tests - done. (fips_error = %d) \n", fips_error);
+	}
+#endif
+#if FIPS_POWER_UP_TEST_HASH
+	if (likely(fips_error == CC_REE_FIPS_ERROR_OK)) {
+		FIPS_DBG("ssi_hash_fips_power_up_tests ...\n");
+		fips_error = ssi_hash_fips_power_up_tests(drvdata, cpu_addr_buffer, dma_handle);
+		FIPS_DBG("ssi_hash_fips_power_up_tests - done. (fips_error = %d) \n", fips_error);
+	}
+#endif
+#if FIPS_POWER_UP_TEST_HMAC
+	if (likely(fips_error == CC_REE_FIPS_ERROR_OK)) {
+		FIPS_DBG("ssi_hmac_fips_power_up_tests ...\n");
+		fips_error = ssi_hmac_fips_power_up_tests(drvdata, cpu_addr_buffer, dma_handle);
+		FIPS_DBG("ssi_hmac_fips_power_up_tests - done. (fips_error = %d) \n", fips_error);
+	}
+#endif
+#if FIPS_POWER_UP_TEST_CCM
+	if (likely(fips_error == CC_REE_FIPS_ERROR_OK)) {
+		FIPS_DBG("ssi_ccm_fips_power_up_tests ...\n");
+		fips_error = ssi_ccm_fips_power_up_tests(drvdata, cpu_addr_buffer, dma_handle);
+		FIPS_DBG("ssi_ccm_fips_power_up_tests - done. (fips_error = %d) \n", fips_error);
+	}
+#endif
+#if FIPS_POWER_UP_TEST_GCM
+	if (likely(fips_error == CC_REE_FIPS_ERROR_OK)) {
+		FIPS_DBG("ssi_gcm_fips_power_up_tests ...\n");
+		fips_error = ssi_gcm_fips_power_up_tests(drvdata, cpu_addr_buffer, dma_handle);
+		FIPS_DBG("ssi_gcm_fips_power_up_tests - done. (fips_error = %d) \n", fips_error);
+	}
+#endif
+	/* deallocate the buffer when all tests are done... */
+	FIPS_DBG("dma_free_coherent \n");
+	dma_free_coherent(dev, alloc_buff_size, cpu_addr_buffer, dma_handle);
+
+	return fips_error;
+}
+
+
+
+/* The function checks if FIPS supported and FIPS error exists.* 
+*  It should be used in every driver API.*/
+int ssi_fips_check_fips_error(void)
+{
+	ssi_fips_state_t fips_state; 
+
+	if (ssi_fips_get_state(&fips_state) != 0) {
+		FIPS_LOG("ssi_fips_get_state FAILED, returning.. \n");
+		return -ENOEXEC;
+	}
+	if (fips_state == CC_FIPS_STATE_ERROR) {
+		FIPS_LOG("ssi_fips_get_state: fips_state is %d, returning.. \n", fips_state);
+		return -ENOEXEC;
+	}
+	return 0;
+}
+
+
+/* The function sets the REE FIPS state.* 
+*  It should be used while driver is being loaded .*/
+int ssi_fips_set_state(ssi_fips_state_t state)
+{
+	return ssi_fips_ext_set_state(state);
+}
+
+/* The function sets the REE FIPS error, and pushes the error to TEE library. * 
+*  It should be used when any of the KAT tests fails .*/
+int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err)
+{
+	int rc = 0;
+        ssi_fips_error_t current_err;
+
+        FIPS_LOG("ssi_fips_set_error - fips_error = %d \n", err);
+
+	// setting no error is not allowed
+	if (err == CC_REE_FIPS_ERROR_OK) {
+                return -ENOEXEC;
+	} 
+        // If error exists, do not set new error
+        if (ssi_fips_get_error(&current_err) != 0) {
+                return -ENOEXEC;
+        }
+        if (current_err != CC_REE_FIPS_ERROR_OK) {
+                return -ENOEXEC;
+        }
+        // set REE internal error and state
+	rc = ssi_fips_ext_set_error(err);
+	if (rc != 0) {
+                return -ENOEXEC;
+	}
+	rc = ssi_fips_ext_set_state(CC_FIPS_STATE_ERROR);
+	if (rc != 0) {
+                return -ENOEXEC;
+	}
+
+        // push error towards TEE libraray, if it's not TEE error
+	if (err != CC_REE_FIPS_ERROR_FROM_TEE) {
+		ssi_fips_update_tee_upon_ree_status(p_drvdata, err);
+	}
+	return rc;
+}
+
+
+/* The function called once at driver entry point .*/
+int ssi_fips_init(struct ssi_drvdata *p_drvdata)
+{
+	ssi_fips_error_t rc = CC_REE_FIPS_ERROR_OK;
+	struct ssi_fips_handle *fips_h;
+
+	FIPS_DBG("CC FIPS code ..  (fips=%d) \n", ssi_fips_support);
+
+	fips_h = kzalloc(sizeof(struct ssi_fips_handle),GFP_KERNEL);
+	if (fips_h == NULL) {
+		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
+		return -ENOMEM;
+	}
+
+	p_drvdata->fips_handle = fips_h;
+
+#ifdef COMP_IN_WQ
+	SSI_LOG_DEBUG("Initializing fips workqueue\n");
+	fips_h->workq = create_singlethread_workqueue("arm_cc7x_fips_wq");
+	if (unlikely(fips_h->workq == NULL)) {
+		SSI_LOG_ERR("Failed creating fips work queue\n");
+		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
+		rc = -ENOMEM;
+		goto ssi_fips_init_err;
+	}
+	INIT_DELAYED_WORK(&fips_h->fipswork, fips_wq_handler);
+#else
+	SSI_LOG_DEBUG("Initializing fips tasklet\n");
+	tasklet_init(&fips_h->fipstask, fips_dsr, (unsigned long)p_drvdata);
+#endif
+
+	/* init fips driver data */
+	rc = ssi_fips_set_state((ssi_fips_support == 0)? CC_FIPS_STATE_NOT_SUPPORTED : CC_FIPS_STATE_SUPPORTED);
+	if (unlikely(rc != 0)) {
+		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
+		rc = -EAGAIN;
+		goto ssi_fips_init_err;
+	}
+
+	/* Run power up tests (before registration and operating the HW engines) */
+	FIPS_DBG("ssi_fips_get_tee_error \n");
+	rc = ssi_fips_get_tee_error(p_drvdata);
+	if (unlikely(rc != CC_REE_FIPS_ERROR_OK)) {
+		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_FROM_TEE);
+		rc = -EAGAIN;
+		goto ssi_fips_init_err;
+	}
+
+	FIPS_DBG("cc_fips_run_power_up_tests \n");
+	rc = cc_fips_run_power_up_tests(p_drvdata);
+	if (unlikely(rc != CC_REE_FIPS_ERROR_OK)) {
+		ssi_fips_set_error(p_drvdata, rc);
+		rc = -EAGAIN;
+		goto ssi_fips_init_err;
+	}
+	FIPS_LOG("cc_fips_run_power_up_tests - done  ...  fips_error = %d \n", rc);
+
+	/* when all tests passed, update TEE with fips OK status after power up tests */
+	ssi_fips_update_tee_upon_ree_status(p_drvdata, CC_REE_FIPS_ERROR_OK);
+
+	if (unlikely(rc != 0)) {
+		rc = -EAGAIN;
+		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
+		goto ssi_fips_init_err;
+	}
+
+	return 0;
+
+ssi_fips_init_err:
+	ssi_fips_fini(p_drvdata);
+	return rc;
+}
+
diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
new file mode 100644
index 0000000..d82e6b5
--- /dev/null
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -0,0 +1,77 @@
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
+#ifndef __SSI_FIPS_LOCAL_H__
+#define __SSI_FIPS_LOCAL_H__
+
+
+#ifdef CONFIG_CCX7REE_FIPS_SUPPORT
+
+#include "ssi_fips.h"
+struct ssi_drvdata;
+
+// IG - how to make 1 file for TEE and REE
+typedef enum CC_FipsSyncStatus{
+	CC_FIPS_SYNC_MODULE_OK 		= 0x0,
+	CC_FIPS_SYNC_MODULE_ERROR 	= 0x1,
+	CC_FIPS_SYNC_REE_STATUS 	= 0x4,
+	CC_FIPS_SYNC_TEE_STATUS 	= 0x8,
+	CC_FIPS_SYNC_STATUS_RESERVE32B 	= INT32_MAX
+}CCFipsSyncStatus_t;
+
+
+#define CHECK_AND_RETURN_UPON_FIPS_ERROR() {\
+        if (ssi_fips_check_fips_error() != 0) {\
+                return -ENOEXEC;\
+        }\
+}
+#define CHECK_AND_RETURN_VOID_UPON_FIPS_ERROR() {\
+        if (ssi_fips_check_fips_error() != 0) {\
+                return;\
+        }\
+}
+#define SSI_FIPS_INIT(p_drvData)  (ssi_fips_init(p_drvData))
+#define SSI_FIPS_FINI(p_drvData)  (ssi_fips_fini(p_drvData))
+
+#define FIPS_LOG(...)	SSI_LOG(KERN_INFO, __VA_ARGS__)
+#define FIPS_DBG(...)	//SSI_LOG(KERN_INFO, __VA_ARGS__)
+
+/* FIPS functions */
+int ssi_fips_init(struct ssi_drvdata *p_drvdata);
+void ssi_fips_fini(struct ssi_drvdata *drvdata);
+int ssi_fips_check_fips_error(void);
+int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err);
+void fips_handler(struct ssi_drvdata *drvdata);
+
+#else  /* CONFIG_CC7XXREE_FIPS_SUPPORT */
+
+#define CHECK_AND_RETURN_UPON_FIPS_ERROR()
+#define CHECK_AND_RETURN_VOID_UPON_FIPS_ERROR()
+
+static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
+{
+	return 0;
+}
+
+static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
+
+void fips_handler(struct ssi_drvdata *drvdata);
+
+#endif  /* CONFIG_CC7XXREE_FIPS_SUPPORT */
+
+
+#endif  /*__SSI_FIPS_LOCAL_H__*/
+
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index cb7fde7..dd06f50 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -30,6 +30,7 @@
 #include "ssi_sysfs.h"
 #include "ssi_hash.h"
 #include "ssi_sram_mgr.h"
+#include "ssi_fips_local.h"
 
 #define SSI_MAX_AHASH_SEQ_LEN 12
 #define SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE MAX(SSI_MAX_HASH_BLCK_SIZE, 3 * AES_BLOCK_SIZE)
@@ -467,6 +468,8 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 
 	SSI_LOG_DEBUG("===== %s-digest (%d) ====\n", is_hmac?"hmac":"hash", nbytes);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
+
 	if (unlikely(ssi_hash_map_request(dev, state, ctx) != 0)) {
 		SSI_LOG_ERR("map_ahash_source() failed\n");
 		return -ENOMEM;
@@ -623,6 +626,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	SSI_LOG_DEBUG("===== %s-update (%d) ====\n", ctx->is_hmac ?
 					"hmac":"hash", nbytes);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (nbytes == 0) {
 		/* no real updates required */
 		return 0;
@@ -719,6 +723,8 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 
 	SSI_LOG_DEBUG("===== %s-finup (%d) ====\n", is_hmac?"hmac":"hash", nbytes);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
+
 	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src , nbytes, 1) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
@@ -848,6 +854,8 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 
 	SSI_LOG_DEBUG("===== %s-final (%d) ====\n", is_hmac?"hmac":"hash", nbytes);
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
+
 	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
@@ -975,6 +983,7 @@ static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	state->xcbc_count = 0;	
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	ssi_hash_map_request(dev, state, ctx);
 
 	return 0;
@@ -983,12 +992,14 @@ static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 #ifdef EXPORT_FIXED
 static int ssi_hash_export(struct ssi_hash_ctx *ctx, void *out)
 {
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	memcpy(out, ctx, sizeof(struct ssi_hash_ctx));
 	return 0;
 }
 
 static int ssi_hash_import(struct ssi_hash_ctx *ctx, const void *in)
 {
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	memcpy(ctx, in, sizeof(struct ssi_hash_ctx));
 	return 0;
 }
@@ -1010,6 +1021,7 @@ static int ssi_hash_setkey(void *hash,
 
 	 SSI_LOG_DEBUG("ssi_hash_setkey: start keylen: %d", keylen);
 	
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (synchronize) {
 		ctx = crypto_shash_ctx(((struct crypto_shash *)hash));
 		blocksize = crypto_tfm_alg_blocksize(&((struct crypto_shash *)hash)->base);
@@ -1218,6 +1230,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	HwDesc_s desc[SSI_MAX_AHASH_SEQ_LEN];
 
 	SSI_LOG_DEBUG("===== setkey (%d) ====\n", keylen);
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
 	switch (keylen) {
 		case AES_KEYSIZE_128:
@@ -1303,6 +1316,7 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	DECL_CYCLE_COUNT_RESOURCES;
 	SSI_LOG_DEBUG("===== setkey (%d) ====\n", keylen);
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
 	ctx->is_hmac = true;
 
@@ -1418,6 +1432,7 @@ static int ssi_shash_cra_init(struct crypto_tfm *tfm)
 	struct ssi_hash_alg *ssi_alg =
 			container_of(shash_alg, struct ssi_hash_alg, shash_alg);
         	
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	ctx->hash_mode = ssi_alg->hash_mode;
 	ctx->hw_mode = ssi_alg->hw_mode;
 	ctx->inter_digestsize = ssi_alg->inter_digestsize;
@@ -1437,6 +1452,7 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 			container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
 
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				sizeof(struct ahash_req_ctx));
 
@@ -1468,6 +1484,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	int rc;
 	uint32_t idx = 0;
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (req->nbytes == 0) {
 		/* no real updates required */
 		return 0;
@@ -1535,6 +1552,7 @@ static int ssi_mac_final(struct ahash_request *req)
 			state->buff0_cnt;
 	
 
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		keySize = CC_AES_128_BIT_KEY_SIZE;
 		keyLen  = CC_AES_128_BIT_KEY_SIZE;
@@ -1645,7 +1663,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 	uint32_t digestsize = crypto_ahash_digestsize(tfm);
 
 	SSI_LOG_DEBUG("===== finup xcbc(%d) ====\n", req->nbytes);
-
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (state->xcbc_count > 0 && req->nbytes == 0) {
 		SSI_LOG_DEBUG("No data to update. Call to fdx_mac_final \n");
 		return ssi_mac_final(req);
@@ -1718,6 +1736,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	int rc;
 
 	SSI_LOG_DEBUG("===== -digest mac (%d) ====\n",  req->nbytes);
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	
 	if (unlikely(ssi_hash_map_request(dev, state, ctx) != 0)) {
 		SSI_LOG_ERR("map_ahash_source() failed\n");
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index c19c006..925bc0b 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -30,6 +30,8 @@
 #include "ssi_sysfs.h"
 #include "ssi_ivgen.h"
 #include "ssi_pm.h"
+#include "ssi_fips.h"
+#include "ssi_fips_local.h"
 
 #define SSI_MAX_POLL_ITER	10
 
-- 
2.1.4
