From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 1/3 v4] crypto: ux500: Add driver for CRYP hardware.
Date: Fri, 30 Mar 2012 11:02:46 +0200
Message-ID: <1333098168-30706-2-git-send-email-andreas.westin@stericsson.com>
References: <1333098168-30706-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <kim.phillips@freescale.com>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:43206 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759552Ab2C3JD1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Mar 2012 05:03:27 -0400
In-Reply-To: <1333098168-30706-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds a driver for the ST-Ericsson ux500 crypto hardware
module. It supports AES, DES and 3DES, the driver implements
support for AES-ECB,CBC and CTR.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>
---
 arch/arm/mach-ux500/include/mach/crypto-ux500.h |   16 +
 drivers/crypto/Kconfig                          |   11 +
 drivers/crypto/Makefile                         |    1 +
 drivers/crypto/ux500/Kconfig                    |   21 +
 drivers/crypto/ux500/Makefile                   |    7 +
 drivers/crypto/ux500/cryp/Makefile              |   13 +
 drivers/crypto/ux500/cryp/cryp.c                |  391 +++++
 drivers/crypto/ux500/cryp/cryp.h                |  308 ++++
 drivers/crypto/ux500/cryp/cryp_core.c           | 1785 +++++++++++++++++++++++
 drivers/crypto/ux500/cryp/cryp_irq.c            |   45 +
 drivers/crypto/ux500/cryp/cryp_irq.h            |   31 +
 drivers/crypto/ux500/cryp/cryp_irqp.h           |  125 ++
 drivers/crypto/ux500/cryp/cryp_p.h              |  124 ++
 13 files changed, 2878 insertions(+)
 create mode 100644 arch/arm/mach-ux500/include/mach/crypto-ux500.h
 create mode 100644 drivers/crypto/ux500/Kconfig
 create mode 100644 drivers/crypto/ux500/Makefile
 create mode 100644 drivers/crypto/ux500/cryp/Makefile
 create mode 100644 drivers/crypto/ux500/cryp/cryp.c
 create mode 100644 drivers/crypto/ux500/cryp/cryp.h
 create mode 100644 drivers/crypto/ux500/cryp/cryp_core.c
 create mode 100644 drivers/crypto/ux500/cryp/cryp_irq.c
 create mode 100644 drivers/crypto/ux500/cryp/cryp_irq.h
 create mode 100644 drivers/crypto/ux500/cryp/cryp_irqp.h
 create mode 100644 drivers/crypto/ux500/cryp/cryp_p.h

diff --git a/arch/arm/mach-ux500/include/mach/crypto-ux500.h b/arch/arm/mach-ux500/include/mach/crypto-ux500.h
new file mode 100644
index 0000000..c470567
--- /dev/null
+++ b/arch/arm/mach-ux500/include/mach/crypto-ux500.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef _CRYPTO_UX500_H
+#include <linux/dmaengine.h>
+#include <plat/ste_dma40.h>
+
+struct cryp_platform_data {
+	struct stedma40_chan_cfg mem_to_engine;
+	struct stedma40_chan_cfg engine_to_mem;
+};
+
+#endif
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab9abb4..aa72acd 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -295,4 +295,15 @@ config CRYPTO_DEV_TEGRA_AES
 	  To compile this driver as a module, choose M here: the module
 	  will be called tegra-aes.
 
+config CRYPTO_DEV_UX500
+	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"
+	#depends on ARCH_UX500
+	select CRYPTO_ALGAPI
+	help
+	  Driver for ST-Ericsson UX500 crypto engine.
+
+if CRYPTO_DEV_UX500
+	source "drivers/crypto/ux500/Kconfig"
+endif # if CRYPTO_DEV_UX500
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index f3e64ea..0139032 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
+obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
\ No newline at end of file
diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
new file mode 100644
index 0000000..b893fa0
--- /dev/null
+++ b/drivers/crypto/ux500/Kconfig
@@ -0,0 +1,21 @@
+#
+# Copyright (C) ST-Ericsson SA 2010
+# Author: Shujuan Chen (shujuan.chen@stericsson.com)
+# License terms: GNU General Public License (GPL) version 2
+#
+
+config CRYPTO_DEV_UX500_CRYP
+	tristate "UX500 crypto driver for CRYP block"
+	depends on CRYPTO_DEV_UX500
+	select CRYPTO_DES
+	help
+        This selects the crypto driver for the UX500_CRYP hardware. It supports
+        AES-ECB, CBC and CTR with keys sizes of 128, 192 and 256 bit sizes.
+
+config CRYPTO_DEV_UX500_DEBUG
+	bool "Activate ux500 platform debug-mode for crypto and hash block"
+	depends on CRYPTO_DEV_UX500_CRYP || CRYPTO_DEV_UX500_HASH
+	default n
+	help
+	  Say Y if you want to add debug prints to ux500_hash and
+	  ux500_cryp devices.
diff --git a/drivers/crypto/ux500/Makefile b/drivers/crypto/ux500/Makefile
new file mode 100644
index 0000000..beb4d37
--- /dev/null
+++ b/drivers/crypto/ux500/Makefile
@@ -0,0 +1,7 @@
+#
+# Copyright (C) ST-Ericsson SA 2010
+# Author: Shujuan Chen (shujuan.chen@stericsson.com)
+# License terms: GNU General Public License (GPL) version 2
+#
+
+obj-$(CONFIG_CRYPTO_DEV_UX500_CRYP) += cryp/
diff --git a/drivers/crypto/ux500/cryp/Makefile b/drivers/crypto/ux500/cryp/Makefile
new file mode 100644
index 0000000..e5d362a
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/Makefile
@@ -0,0 +1,13 @@
+#/*
+# * Copyright (C) ST-Ericsson SA 2010
+# * Author: shujuan.chen@stericsson.com for ST-Ericsson.
+# * License terms: GNU General Public License (GPL) version 2  */
+
+ifdef CONFIG_CRYPTO_DEV_UX500_DEBUG
+CFLAGS_cryp_core.o := -DDEBUG -O0
+CFLAGS_cryp.o := -DDEBUG -O0
+CFLAGS_cryp_irq.o := -DDEBUG -O0
+endif
+
+obj-$(CONFIG_CRYPTO_DEV_UX500_CRYP) += ux500_cryp.o
+ux500_cryp-objs :=  cryp.o cryp_irq.o cryp_core.o
diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
new file mode 100644
index 0000000..bd206ff
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp.c
@@ -0,0 +1,391 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#include <mach/hardware.h>
+
+#include "cryp_p.h"
+#include "cryp.h"
+
+/**
+ * cryp_wait_until_done - wait until the device logic is not busy
+ */
+void cryp_wait_until_done(struct cryp_device_data *device_data)
+{
+	while (cryp_is_logic_busy(device_data))
+		cpu_relax();
+}
+
+/**
+ * cryp_check - This routine checks Peripheral and PCell Id
+ * @device_data: Pointer to the device data struct for base address.
+ */
+int cryp_check(struct cryp_device_data *device_data)
+{
+	int peripheralid2 = 0;
+
+	if (NULL == device_data)
+		return -EINVAL;
+
+	if (cpu_is_u8500())
+		peripheralid2 = CRYP_PERIPHERAL_ID2_DB8500;
+	else if (cpu_is_u5500())
+		peripheralid2 = CRYP_PERIPHERAL_ID2_DB5500;
+
+	/* Check Peripheral and Pcell Id Register for CRYP */
+	if ((CRYP_PERIPHERAL_ID0 ==
+		readl_relaxed(&device_data->base->periphId0))
+	    && (CRYP_PERIPHERAL_ID1 ==
+		    readl_relaxed(&device_data->base->periphId1))
+	    && (peripheralid2 ==
+		    readl_relaxed(&device_data->base->periphId2))
+	    && (CRYP_PERIPHERAL_ID3 ==
+		    readl_relaxed(&device_data->base->periphId3))
+	    && (CRYP_PCELL_ID0 ==
+		    readl_relaxed(&device_data->base->pcellId0))
+	    && (CRYP_PCELL_ID1 ==
+		    readl_relaxed(&device_data->base->pcellId1))
+	    && (CRYP_PCELL_ID2 ==
+		    readl_relaxed(&device_data->base->pcellId2))
+	    && (CRYP_PCELL_ID3 ==
+		    readl_relaxed(&device_data->base->pcellId3))) {
+		return 0;
+	}
+
+	return -EPERM;
+}
+
+/**
+ * cryp_activity - This routine enables/disable the cryptography function.
+ * @device_data: Pointer to the device data struct for base address.
+ * @cryp_crypen: Enable/Disable functionality
+ */
+void cryp_activity(struct cryp_device_data *device_data,
+		   enum cryp_crypen cryp_crypen)
+{
+	CRYP_PUT_BITS(&device_data->base->cr,
+		      cryp_crypen,
+		      CRYP_CR_CRYPEN_POS,
+		      CRYP_CR_CRYPEN_MASK);
+}
+
+/**
+ * cryp_flush_inoutfifo - Resets both the input and the output FIFOs
+ * @device_data: Pointer to the device data struct for base address.
+ */
+void cryp_flush_inoutfifo(struct cryp_device_data *device_data)
+{
+	/*
+	 * We always need to disble the hardware before trying to flush the
+	 * FIFO. This is something that isn't written in the design
+	 * specification, but we have been informed by the hardware designers
+	 * that this must be done.
+	 */
+	cryp_activity(device_data, CRYP_CRYPEN_DISABLE);
+	cryp_wait_until_done(device_data);
+
+	CRYP_SET_BITS(&device_data->base->cr, CRYP_CR_FFLUSH_MASK);
+	/*
+	 * CRYP_SR_INFIFO_READY_MASK is the expected value on the status
+	 * register when starting a new calculation, which means Input FIFO is
+	 * not full and input FIFO is empty.
+	 */
+	while (readl_relaxed(&device_data->base->sr) !=
+	       CRYP_SR_INFIFO_READY_MASK)
+		cpu_relax();
+}
+
+/**
+ * cryp_set_configuration - This routine set the cr CRYP IP
+ * @device_data: Pointer to the device data struct for base address.
+ * @cryp_config: Pointer to the configuration parameter
+ * @control_register: The control register to be written later on.
+ */
+int cryp_set_configuration(struct cryp_device_data *device_data,
+			   struct cryp_config *cryp_config,
+			   u32 *control_register)
+{
+	u32 cr_for_kse;
+
+	if (NULL == device_data || NULL == cryp_config)
+		return -EINVAL;
+
+	*control_register |= (cryp_config->keysize << CRYP_CR_KEYSIZE_POS);
+
+	/* Prepare key for decryption in AES_ECB and AES_CBC mode. */
+	if ((CRYP_ALGORITHM_DECRYPT == cryp_config->algodir) &&
+	    ((CRYP_ALGO_AES_ECB == cryp_config->algomode) ||
+	     (CRYP_ALGO_AES_CBC == cryp_config->algomode))) {
+		cr_for_kse = *control_register;
+		/*
+		 * This seems a bit odd, but it is indeed needed to set this to
+		 * encrypt even though it is a decryption that we are doing. It
+		 * also mentioned in the design spec that you need to do this.
+		 * After the keyprepartion for decrypting is done you should set
+		 * algodir back to decryption, which is done outside this if
+		 * statement.
+		 *
+		 * According to design specification we should set mode ECB
+		 * during key preparation even though we might be running CBC
+		 * when enter this function.
+		 *
+		 * Writing to KSE_ENABLED will drop CRYPEN when key preparation
+		 * is done. Therefore we need to set CRYPEN again outside this
+		 * if statement when running decryption.
+		 */
+		cr_for_kse |= ((CRYP_ALGORITHM_ENCRYPT << CRYP_CR_ALGODIR_POS) |
+			       (CRYP_ALGO_AES_ECB << CRYP_CR_ALGOMODE_POS) |
+			       (CRYP_CRYPEN_ENABLE << CRYP_CR_CRYPEN_POS) |
+			       (KSE_ENABLED << CRYP_CR_KSE_POS));
+
+		writel_relaxed(cr_for_kse, &device_data->base->cr);
+		cryp_wait_until_done(device_data);
+	}
+
+	*control_register |=
+		((cryp_config->algomode << CRYP_CR_ALGOMODE_POS) |
+		 (cryp_config->algodir << CRYP_CR_ALGODIR_POS));
+
+	return 0;
+}
+
+/**
+ * cryp_configure_protection - set the protection bits in the CRYP logic.
+ * @device_data: Pointer to the device data struct for base address.
+ * @p_protect_config:	Pointer to the protection mode and
+ *			secure mode configuration
+ */
+int cryp_configure_protection(struct cryp_device_data *device_data,
+			      struct cryp_protection_config *p_protect_config)
+{
+	if (NULL == p_protect_config)
+		return -EINVAL;
+
+	CRYP_WRITE_BIT(&device_data->base->cr,
+		       (u32) p_protect_config->secure_access,
+		       CRYP_CR_SECURE_MASK);
+	CRYP_PUT_BITS(&device_data->base->cr,
+		      p_protect_config->privilege_access,
+		      CRYP_CR_PRLG_POS,
+		      CRYP_CR_PRLG_MASK);
+
+	return 0;
+}
+
+/**
+ * cryp_is_logic_busy - returns the busy status of the CRYP logic
+ * @device_data: Pointer to the device data struct for base address.
+ */
+int cryp_is_logic_busy(struct cryp_device_data *device_data)
+{
+	return CRYP_TEST_BITS(&device_data->base->sr,
+			      CRYP_SR_BUSY_MASK);
+}
+
+/**
+ * cryp_configure_for_dma - configures the CRYP IP for DMA operation
+ * @device_data: Pointer to the device data struct for base address.
+ * @dma_req: Specifies the DMA request type value.
+ */
+void cryp_configure_for_dma(struct cryp_device_data *device_data,
+			    enum cryp_dma_req_type dma_req)
+{
+	CRYP_SET_BITS(&device_data->base->dmacr,
+		      (u32) dma_req);
+}
+
+/**
+ * cryp_configure_key_values - configures the key values for CRYP operations
+ * @device_data: Pointer to the device data struct for base address.
+ * @key_reg_index: Key value index register
+ * @key_value: The key value struct
+ */
+int cryp_configure_key_values(struct cryp_device_data *device_data,
+			      enum cryp_key_reg_index key_reg_index,
+			      struct cryp_key_value key_value)
+{
+	while (cryp_is_logic_busy(device_data))
+		cpu_relax();
+
+	switch (key_reg_index) {
+	case CRYP_KEY_REG_1:
+		writel_relaxed(key_value.key_value_left,
+				&device_data->base->key_1_l);
+		writel_relaxed(key_value.key_value_right,
+				&device_data->base->key_1_r);
+		break;
+	case CRYP_KEY_REG_2:
+		writel_relaxed(key_value.key_value_left,
+				&device_data->base->key_2_l);
+		writel_relaxed(key_value.key_value_right,
+				&device_data->base->key_2_r);
+		break;
+	case CRYP_KEY_REG_3:
+		writel_relaxed(key_value.key_value_left,
+				&device_data->base->key_3_l);
+		writel_relaxed(key_value.key_value_right,
+				&device_data->base->key_3_r);
+		break;
+	case CRYP_KEY_REG_4:
+		writel_relaxed(key_value.key_value_left,
+				&device_data->base->key_4_l);
+		writel_relaxed(key_value.key_value_right,
+				&device_data->base->key_4_r);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * cryp_configure_init_vector - configures the initialization vector register
+ * @device_data: Pointer to the device data struct for base address.
+ * @init_vector_index: Specifies the index of the init vector.
+ * @init_vector_value: Specifies the value for the init vector.
+ */
+int cryp_configure_init_vector(struct cryp_device_data *device_data,
+			       enum cryp_init_vector_index
+			       init_vector_index,
+			       struct cryp_init_vector_value
+			       init_vector_value)
+{
+	while (cryp_is_logic_busy(device_data))
+		cpu_relax();
+
+	switch (init_vector_index) {
+	case CRYP_INIT_VECTOR_INDEX_0:
+		writel_relaxed(init_vector_value.init_value_left,
+		       &device_data->base->init_vect_0_l);
+		writel_relaxed(init_vector_value.init_value_right,
+		       &device_data->base->init_vect_0_r);
+		break;
+	case CRYP_INIT_VECTOR_INDEX_1:
+		writel_relaxed(init_vector_value.init_value_left,
+		       &device_data->base->init_vect_1_l);
+		writel_relaxed(init_vector_value.init_value_right,
+		       &device_data->base->init_vect_1_r);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * cryp_save_device_context -	Store hardware registers and
+ *				other device context parameter
+ * @device_data: Pointer to the device data struct for base address.
+ * @ctx: Crypto device context
+ */
+void cryp_save_device_context(struct cryp_device_data *device_data,
+			      struct cryp_device_context *ctx,
+			      int cryp_mode)
+{
+	enum cryp_algo_mode algomode;
+	struct cryp_register *src_reg = device_data->base;
+	struct cryp_config *config =
+		(struct cryp_config *)device_data->current_ctx;
+
+	/*
+	 * Always start by disable the hardware and wait for it to finish the
+	 * ongoing calculations before trying to reprogram it.
+	 */
+	cryp_activity(device_data, CRYP_CRYPEN_DISABLE);
+	cryp_wait_until_done(device_data);
+
+	if (cryp_mode == CRYP_MODE_DMA)
+		cryp_configure_for_dma(device_data, CRYP_DMA_DISABLE_BOTH);
+
+	if (CRYP_TEST_BITS(&src_reg->sr, CRYP_SR_IFEM_MASK) == 0)
+		ctx->din = readl_relaxed(&src_reg->din);
+
+	ctx->cr = readl_relaxed(&src_reg->cr) & CRYP_CR_CONTEXT_SAVE_MASK;
+
+	switch (config->keysize) {
+	case CRYP_KEY_SIZE_256:
+		ctx->key_4_l = readl_relaxed(&src_reg->key_4_l);
+		ctx->key_4_r = readl_relaxed(&src_reg->key_4_r);
+
+	case CRYP_KEY_SIZE_192:
+		ctx->key_3_l = readl_relaxed(&src_reg->key_3_l);
+		ctx->key_3_r = readl_relaxed(&src_reg->key_3_r);
+
+	case CRYP_KEY_SIZE_128:
+		ctx->key_2_l = readl_relaxed(&src_reg->key_2_l);
+		ctx->key_2_r = readl_relaxed(&src_reg->key_2_r);
+
+	default:
+		ctx->key_1_l = readl_relaxed(&src_reg->key_1_l);
+		ctx->key_1_r = readl_relaxed(&src_reg->key_1_r);
+	}
+
+	/* Save IV for CBC mode for both AES and DES. */
+	algomode = ((ctx->cr & CRYP_CR_ALGOMODE_MASK) >> CRYP_CR_ALGOMODE_POS);
+	if (algomode == CRYP_ALGO_TDES_CBC ||
+	    algomode == CRYP_ALGO_DES_CBC ||
+	    algomode == CRYP_ALGO_AES_CBC) {
+		ctx->init_vect_0_l = readl_relaxed(&src_reg->init_vect_0_l);
+		ctx->init_vect_0_r = readl_relaxed(&src_reg->init_vect_0_r);
+		ctx->init_vect_1_l = readl_relaxed(&src_reg->init_vect_1_l);
+		ctx->init_vect_1_r = readl_relaxed(&src_reg->init_vect_1_r);
+	}
+}
+
+/**
+ * cryp_restore_device_context -	Restore hardware registers and
+ *					other device context parameter
+ * @device_data: Pointer to the device data struct for base address.
+ * @ctx: Crypto device context
+ */
+void cryp_restore_device_context(struct cryp_device_data *device_data,
+				 struct cryp_device_context *ctx)
+{
+	struct cryp_register *reg = device_data->base;
+	struct cryp_config *config =
+		(struct cryp_config *)device_data->current_ctx;
+
+	/*
+	 * Fall through for all items in switch statement. DES is captured in
+	 * the default.
+	 */
+	switch (config->keysize) {
+	case CRYP_KEY_SIZE_256:
+		writel_relaxed(ctx->key_4_l, &reg->key_4_l);
+		writel_relaxed(ctx->key_4_r, &reg->key_4_r);
+
+	case CRYP_KEY_SIZE_192:
+		writel_relaxed(ctx->key_3_l, &reg->key_3_l);
+		writel_relaxed(ctx->key_3_r, &reg->key_3_r);
+
+	case CRYP_KEY_SIZE_128:
+		writel_relaxed(ctx->key_2_l, &reg->key_2_l);
+		writel_relaxed(ctx->key_2_r, &reg->key_2_r);
+
+	default:
+		writel_relaxed(ctx->key_1_l, &reg->key_1_l);
+		writel_relaxed(ctx->key_1_r, &reg->key_1_r);
+	}
+
+	/* Restore IV for CBC mode for AES and DES. */
+	if (config->algomode == CRYP_ALGO_TDES_CBC ||
+	    config->algomode == CRYP_ALGO_DES_CBC ||
+	    config->algomode == CRYP_ALGO_AES_CBC) {
+		writel_relaxed(ctx->init_vect_0_l, &reg->init_vect_0_l);
+		writel_relaxed(ctx->init_vect_0_r, &reg->init_vect_0_r);
+		writel_relaxed(ctx->init_vect_1_l, &reg->init_vect_1_l);
+		writel_relaxed(ctx->init_vect_1_r, &reg->init_vect_1_r);
+	}
+}
diff --git a/drivers/crypto/ux500/cryp/cryp.h b/drivers/crypto/ux500/cryp/cryp.h
new file mode 100644
index 0000000..14cfd05
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp.h
@@ -0,0 +1,308 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef _CRYP_H_
+#define _CRYP_H_
+
+#include <linux/completion.h>
+#include <linux/dmaengine.h>
+#include <linux/klist.h>
+#include <linux/mutex.h>
+
+#define DEV_DBG_NAME "crypX crypX:"
+
+/* CRYP enable/disable */
+enum cryp_crypen {
+	CRYP_CRYPEN_DISABLE = 0,
+	CRYP_CRYPEN_ENABLE = 1
+};
+
+/* CRYP Start Computation enable/disable */
+enum cryp_start {
+	CRYP_START_DISABLE = 0,
+	CRYP_START_ENABLE = 1
+};
+
+/* CRYP Init Signal enable/disable */
+enum cryp_init {
+	CRYP_INIT_DISABLE = 0,
+	CRYP_INIT_ENABLE = 1
+};
+
+/* Cryp State enable/disable */
+enum cryp_state {
+	CRYP_STATE_DISABLE = 0,
+	CRYP_STATE_ENABLE = 1
+};
+
+/* Key preparation bit enable */
+enum cryp_key_prep {
+	KSE_DISABLED = 0,
+	KSE_ENABLED = 1
+};
+
+/* Key size for AES */
+#define	CRYP_KEY_SIZE_128 (0)
+#define	CRYP_KEY_SIZE_192 (1)
+#define	CRYP_KEY_SIZE_256 (2)
+
+/* AES modes */
+enum cryp_algo_mode {
+	CRYP_ALGO_TDES_ECB,
+	CRYP_ALGO_TDES_CBC,
+	CRYP_ALGO_DES_ECB,
+	CRYP_ALGO_DES_CBC,
+	CRYP_ALGO_AES_ECB,
+	CRYP_ALGO_AES_CBC,
+	CRYP_ALGO_AES_CTR,
+	CRYP_ALGO_AES_XTS
+};
+
+/* Cryp Encryption or Decryption */
+enum cryp_algorithm_dir {
+	CRYP_ALGORITHM_ENCRYPT,
+	CRYP_ALGORITHM_DECRYPT
+};
+
+/* Hardware access method */
+enum cryp_mode {
+	CRYP_MODE_POLLING,
+	CRYP_MODE_INTERRUPT,
+	CRYP_MODE_DMA
+};
+
+/**
+ * struct cryp_config -
+ * @keysize: Key size for AES
+ * @algomode: AES modes
+ * @algodir: Cryp Encryption or Decryption
+ *
+ * CRYP configuration structure to be passed to set configuration
+ */
+struct cryp_config {
+	int keysize;
+	enum cryp_algo_mode algomode;
+	enum cryp_algorithm_dir algodir;
+};
+
+/**
+ * struct cryp_protection_config -
+ * @privilege_access: Privileged cryp state enable/disable
+ * @secure_access: Secure cryp state enable/disable
+ *
+ * Protection configuration structure for setting privilage access
+ */
+struct cryp_protection_config {
+	enum cryp_state privilege_access;
+	enum cryp_state secure_access;
+};
+
+/* Cryp status */
+enum cryp_status_id {
+	CRYP_STATUS_BUSY = 0x10,
+	CRYP_STATUS_OUTPUT_FIFO_FULL = 0x08,
+	CRYP_STATUS_OUTPUT_FIFO_NOT_EMPTY = 0x04,
+	CRYP_STATUS_INPUT_FIFO_NOT_FULL = 0x02,
+	CRYP_STATUS_INPUT_FIFO_EMPTY = 0x01
+};
+
+/* Cryp DMA interface */
+enum cryp_dma_req_type {
+	CRYP_DMA_DISABLE_BOTH,
+	CRYP_DMA_ENABLE_IN_DATA,
+	CRYP_DMA_ENABLE_OUT_DATA,
+	CRYP_DMA_ENABLE_BOTH_DIRECTIONS
+};
+
+enum cryp_dma_channel {
+	CRYP_DMA_RX = 0,
+	CRYP_DMA_TX
+};
+
+/* Key registers */
+enum cryp_key_reg_index {
+	CRYP_KEY_REG_1,
+	CRYP_KEY_REG_2,
+	CRYP_KEY_REG_3,
+	CRYP_KEY_REG_4
+};
+
+/* Key register left and right */
+struct cryp_key_value {
+	u32 key_value_left;
+	u32 key_value_right;
+};
+
+/* Cryp Initialization structure */
+enum cryp_init_vector_index {
+	CRYP_INIT_VECTOR_INDEX_0,
+	CRYP_INIT_VECTOR_INDEX_1
+};
+
+/* struct cryp_init_vector_value -
+ * @init_value_left
+ * @init_value_right
+ * */
+struct cryp_init_vector_value {
+	u32 init_value_left;
+	u32 init_value_right;
+};
+
+/**
+ * struct cryp_device_context - structure for a cryp context.
+ * @cr: control register
+ * @dmacr: DMA control register
+ * @imsc: Interrupt mask set/clear register
+ * @key_1_l: Key 1l register
+ * @key_1_r: Key 1r register
+ * @key_2_l: Key 2l register
+ * @key_2_r: Key 2r register
+ * @key_3_l: Key 3l register
+ * @key_3_r: Key 3r register
+ * @key_4_l: Key 4l register
+ * @key_4_r: Key 4r register
+ * @init_vect_0_l: Initialization vector 0l register
+ * @init_vect_0_r: Initialization vector 0r register
+ * @init_vect_1_l: Initialization vector 1l register
+ * @init_vect_1_r: Initialization vector 0r register
+ * @din: Data in register
+ * @dout: Data out register
+ *
+ * CRYP power management specifc structure.
+ */
+struct cryp_device_context {
+	u32 cr;
+	u32 dmacr;
+	u32 imsc;
+
+	u32 key_1_l;
+	u32 key_1_r;
+	u32 key_2_l;
+	u32 key_2_r;
+	u32 key_3_l;
+	u32 key_3_r;
+	u32 key_4_l;
+	u32 key_4_r;
+
+	u32 init_vect_0_l;
+	u32 init_vect_0_r;
+	u32 init_vect_1_l;
+	u32 init_vect_1_r;
+
+	u32 din;
+	u32 dout;
+};
+
+struct cryp_dma {
+	dma_cap_mask_t mask;
+	struct completion cryp_dma_complete;
+	struct dma_chan *chan_cryp2mem;
+	struct dma_chan *chan_mem2cryp;
+	struct stedma40_chan_cfg *cfg_cryp2mem;
+	struct stedma40_chan_cfg *cfg_mem2cryp;
+	int sg_src_len;
+	int sg_dst_len;
+	struct scatterlist *sg_src;
+	struct scatterlist *sg_dst;
+	int nents_src;
+	int nents_dst;
+};
+
+/**
+ * struct cryp_device_data - structure for a cryp device.
+ * @base: Pointer to the hardware base address.
+ * @dev: Pointer to the devices dev structure.
+ * @clk: Pointer to the device's clock control.
+ * @pwr_regulator: Pointer to the device's power control.
+ * @power_status: Current status of the power.
+ * @ctx_lock: Lock for current_ctx.
+ * @current_ctx: Pointer to the currently allocated context.
+ * @list_node: For inclusion into a klist.
+ * @dma: The dma structure holding channel configuration.
+ * @power_state: TRUE = power state on, FALSE = power state off.
+ * @power_state_spinlock: Spinlock for power_state.
+ * @restore_dev_ctx: TRUE = saved ctx, FALSE = no saved ctx.
+ */
+struct cryp_device_data {
+	struct cryp_register __iomem *base;
+	struct device *dev;
+	struct clk *clk;
+	struct regulator *pwr_regulator;
+	int power_status;
+	struct spinlock ctx_lock;
+	struct cryp_ctx *current_ctx;
+	struct klist_node list_node;
+	struct cryp_dma dma;
+	bool power_state;
+	struct spinlock power_state_spinlock;
+	bool restore_dev_ctx;
+};
+
+void cryp_wait_until_done(struct cryp_device_data *device_data);
+
+/* Initialization functions */
+
+int cryp_check(struct cryp_device_data *device_data);
+
+void cryp_activity(struct cryp_device_data *device_data,
+		   enum cryp_crypen cryp_crypen);
+
+void cryp_flush_inoutfifo(struct cryp_device_data *device_data);
+
+int cryp_set_configuration(struct cryp_device_data *device_data,
+			   struct cryp_config *cryp_config,
+			   u32 *control_register);
+
+void cryp_configure_for_dma(struct cryp_device_data *device_data,
+			    enum cryp_dma_req_type dma_req);
+
+int cryp_configure_key_values(struct cryp_device_data *device_data,
+			      enum cryp_key_reg_index key_reg_index,
+			      struct cryp_key_value key_value);
+
+int cryp_configure_init_vector(struct cryp_device_data *device_data,
+			       enum cryp_init_vector_index
+			       init_vector_index,
+			       struct cryp_init_vector_value
+			       init_vector_value);
+
+int cryp_configure_protection(struct cryp_device_data *device_data,
+			      struct cryp_protection_config *p_protect_config);
+
+/* Power management funtions */
+void cryp_save_device_context(struct cryp_device_data *device_data,
+			      struct cryp_device_context *ctx,
+			      int cryp_mode);
+
+void cryp_restore_device_context(struct cryp_device_data *device_data,
+				 struct cryp_device_context *ctx);
+
+/* Data transfer and status bits. */
+int cryp_is_logic_busy(struct cryp_device_data *device_data);
+
+int cryp_get_status(struct cryp_device_data *device_data);
+
+/**
+ * cryp_write_indata - This routine writes 32 bit data into the data input
+ *		       register of the cryptography IP.
+ * @device_data: Pointer to the device data struct for base address.
+ * @write_data: Data to write.
+ */
+int cryp_write_indata(struct cryp_device_data *device_data, u32 write_data);
+
+/**
+ * cryp_read_outdata - This routine reads the data from the data output
+ *		       register of the CRYP logic
+ * @device_data: Pointer to the device data struct for base address.
+ * @read_data: Read the data from the output FIFO.
+ */
+int cryp_read_outdata(struct cryp_device_data *device_data, u32 *read_data);
+
+#endif /* _CRYP_H_ */
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
new file mode 100644
index 0000000..7051e00
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -0,0 +1,1785 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Andreas Westin <andreas.westin@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/crypto.h>
+#include <linux/dmaengine.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/klist.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/semaphore.h>
+
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/ctr.h>
+#include <crypto/des.h>
+#include <crypto/scatterwalk.h>
+
+#include <plat/ste_dma40.h>
+
+#include <mach/crypto-ux500.h>
+#include <mach/hardware.h>
+
+#include "cryp_p.h"
+#include "cryp.h"
+
+#define CRYP_MAX_KEY_SIZE	32
+#define BYTES_PER_WORD		4
+
+static int cryp_mode;
+static atomic_t session_id;
+
+static struct stedma40_chan_cfg *mem_to_engine;
+static struct stedma40_chan_cfg *engine_to_mem;
+
+/**
+ * struct cryp_driver_data - data specific to the driver.
+ *
+ * @device_list: A list of registered devices to choose from.
+ * @device_allocation: A semaphore initialized with number of devices.
+ */
+struct cryp_driver_data {
+	struct klist device_list;
+	struct semaphore device_allocation;
+};
+
+/**
+ * struct cryp_ctx - Crypto context
+ * @config: Crypto mode.
+ * @key[CRYP_MAX_KEY_SIZE]: Key.
+ * @keylen: Length of key.
+ * @iv: Pointer to initialization vector.
+ * @indata: Pointer to indata.
+ * @outdata: Pointer to outdata.
+ * @datalen: Length of indata.
+ * @outlen: Length of outdata.
+ * @blocksize: Size of blocks.
+ * @updated: Updated flag.
+ * @dev_ctx: Device dependent context.
+ * @device: Pointer to the device.
+ */
+struct cryp_ctx {
+	struct cryp_config config;
+	u8 key[CRYP_MAX_KEY_SIZE];
+	u32 keylen;
+	u8 *iv;
+	const u8 *indata;
+	u8 *outdata;
+	u32 datalen;
+	u32 outlen;
+	u32 blocksize;
+	u8 updated;
+	struct cryp_device_context dev_ctx;
+	struct cryp_device_data *device;
+	u32 session_id;
+};
+
+static struct cryp_driver_data driver_data;
+
+/**
+ * uint8p_to_uint32_be - 4*uint8 to uint32 big endian
+ * @in: Data to convert.
+ */
+static inline u32 uint8p_to_uint32_be(u8 *in)
+{
+	u32 *data = (u32 *)in;
+
+	return cpu_to_be32p(data);
+}
+
+/**
+ * swap_bits_in_byte - mirror the bits in a byte
+ * @b: the byte to be mirrored
+ *
+ * The bits are swapped the following way:
+ *  Byte b include bits 0-7, nibble 1 (n1) include bits 0-3 and
+ *  nibble 2 (n2) bits 4-7.
+ *
+ *  Nibble 1 (n1):
+ *  (The "old" (moved) bit is replaced with a zero)
+ *  1. Move bit 6 and 7, 4 positions to the left.
+ *  2. Move bit 3 and 5, 2 positions to the left.
+ *  3. Move bit 1-4, 1 position to the left.
+ *
+ *  Nibble 2 (n2):
+ *  1. Move bit 0 and 1, 4 positions to the right.
+ *  2. Move bit 2 and 4, 2 positions to the right.
+ *  3. Move bit 3-6, 1 position to the right.
+ *
+ *  Combine the two nibbles to a complete and swapped byte.
+ */
+
+static inline u8 swap_bits_in_byte(u8 b)
+{
+#define R_SHIFT_4_MASK  0xc0 /* Bits 6 and 7, right shift 4 */
+#define R_SHIFT_2_MASK  0x28 /* (After right shift 4) Bits 3 and 5,
+				  right shift 2 */
+#define R_SHIFT_1_MASK  0x1e /* (After right shift 2) Bits 1-4,
+				  right shift 1 */
+#define L_SHIFT_4_MASK  0x03 /* Bits 0 and 1, left shift 4 */
+#define L_SHIFT_2_MASK  0x14 /* (After left shift 4) Bits 2 and 4,
+				  left shift 2 */
+#define L_SHIFT_1_MASK  0x78 /* (After left shift 1) Bits 3-6,
+				  left shift 1 */
+
+	u8 n1;
+	u8 n2;
+
+	/* Swap most significant nibble */
+	/* Right shift 4, bits 6 and 7 */
+	n1 = ((b  & R_SHIFT_4_MASK) >> 4) | (b  & ~(R_SHIFT_4_MASK >> 4));
+	/* Right shift 2, bits 3 and 5 */
+	n1 = ((n1 & R_SHIFT_2_MASK) >> 2) | (n1 & ~(R_SHIFT_2_MASK >> 2));
+	/* Right shift 1, bits 1-4 */
+	n1 = (n1  & R_SHIFT_1_MASK) >> 1;
+
+	/* Swap least significant nibble */
+	/* Left shift 4, bits 0 and 1 */
+	n2 = ((b  & L_SHIFT_4_MASK) << 4) | (b  & ~(L_SHIFT_4_MASK << 4));
+	/* Left shift 2, bits 2 and 4 */
+	n2 = ((n2 & L_SHIFT_2_MASK) << 2) | (n2 & ~(L_SHIFT_2_MASK << 2));
+	/* Left shift 1, bits 3-6 */
+	n2 = (n2  & L_SHIFT_1_MASK) << 1;
+
+	return n1 | n2;
+}
+
+static inline void swap_words_in_key_and_bits_in_byte(const u8 *in,
+						      u8 *out, u32 len)
+{
+	unsigned int i = 0;
+	int j;
+	int index = 0;
+
+	j = len - BYTES_PER_WORD;
+	while (j >= 0) {
+		for (i = 0; i < BYTES_PER_WORD; i++) {
+			index = len - j - BYTES_PER_WORD + i;
+			out[j + i] =
+				swap_bits_in_byte(in[index]);
+		}
+		j -= BYTES_PER_WORD;
+	}
+}
+
+static void add_session_id(struct cryp_ctx *ctx)
+{
+	/*
+	 * We never want 0 to be a valid value, since this is the default value
+	 * for the software context.
+	 */
+	if (unlikely(atomic_inc_and_test(&session_id)))
+		atomic_inc(&session_id);
+
+	ctx->session_id = atomic_read(&session_id);
+}
+
+static irqreturn_t cryp_interrupt_handler(int irq, void *param)
+{
+	struct cryp_ctx *ctx;
+	int i;
+	struct cryp_device_data *device_data;
+
+	if (param == NULL) {
+		BUG_ON(!param);
+		return IRQ_HANDLED;
+	}
+
+	/* The device is coming from the one found in hw_crypt_noxts. */
+	device_data = (struct cryp_device_data *)param;
+
+	ctx = device_data->current_ctx;
+
+	if (ctx == NULL) {
+		BUG_ON(!ctx);
+		return IRQ_HANDLED;
+	}
+
+	dev_dbg(ctx->device->dev, "[%s] (len: %d) %s, ", __func__, ctx->outlen,
+		cryp_pending_irq_src(device_data, CRYP_IRQ_SRC_OUTPUT_FIFO) ?
+		"out" : "in");
+
+	if (cryp_pending_irq_src(device_data,
+				 CRYP_IRQ_SRC_OUTPUT_FIFO)) {
+		if (ctx->outlen / ctx->blocksize > 0) {
+			for (i = 0; i < ctx->blocksize / 4; i++) {
+				*(ctx->outdata) = readl_relaxed(
+						&device_data->base->dout);
+				ctx->outdata += 4;
+				ctx->outlen -= 4;
+			}
+
+			if (ctx->outlen == 0) {
+				cryp_disable_irq_src(device_data,
+						     CRYP_IRQ_SRC_OUTPUT_FIFO);
+			}
+		}
+	} else if (cryp_pending_irq_src(device_data,
+					CRYP_IRQ_SRC_INPUT_FIFO)) {
+		if (ctx->datalen / ctx->blocksize > 0) {
+			for (i = 0 ; i < ctx->blocksize / 4; i++) {
+				writel_relaxed(ctx->indata,
+						&device_data->base->din);
+				ctx->indata += 4;
+				ctx->datalen -= 4;
+			}
+
+			if (ctx->datalen == 0)
+				cryp_disable_irq_src(device_data,
+						   CRYP_IRQ_SRC_INPUT_FIFO);
+
+			if (ctx->config.algomode == CRYP_ALGO_AES_XTS) {
+				CRYP_PUT_BITS(&device_data->base->cr,
+					      CRYP_START_ENABLE,
+					      CRYP_CR_START_POS,
+					      CRYP_CR_START_MASK);
+
+				cryp_wait_until_done(device_data);
+			}
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mode_is_aes(enum cryp_algo_mode mode)
+{
+	return	CRYP_ALGO_AES_ECB == mode ||
+		CRYP_ALGO_AES_CBC == mode ||
+		CRYP_ALGO_AES_CTR == mode ||
+		CRYP_ALGO_AES_XTS == mode;
+}
+
+static int cfg_iv(struct cryp_device_data *device_data, u32 left, u32 right,
+		  enum cryp_init_vector_index index)
+{
+	struct cryp_init_vector_value vector_value;
+
+	dev_dbg(device_data->dev, "[%s]", __func__);
+
+	vector_value.init_value_left = left;
+	vector_value.init_value_right = right;
+
+	return cryp_configure_init_vector(device_data,
+					  index,
+					  vector_value);
+}
+
+static int cfg_ivs(struct cryp_device_data *device_data, struct cryp_ctx *ctx)
+{
+	int i;
+	int status = 0;
+	int num_of_regs = ctx->blocksize / 8;
+	u32 iv[AES_BLOCK_SIZE / 4];
+
+	dev_dbg(device_data->dev, "[%s]", __func__);
+
+	/*
+	 * Since we loop on num_of_regs we need to have a check in case
+	 * someone provides an incorrect blocksize which would force calling
+	 * cfg_iv with i greater than 2 which is an error.
+	 */
+	if (num_of_regs > 2) {
+		dev_err(device_data->dev, "[%s] Incorrect blocksize %d",
+			__func__, ctx->blocksize);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ctx->blocksize / 4; i++)
+		iv[i] = uint8p_to_uint32_be(ctx->iv + i*4);
+
+	for (i = 0; i < num_of_regs; i++) {
+		status = cfg_iv(device_data, iv[i*2], iv[i*2+1],
+				(enum cryp_init_vector_index) i);
+		if (status != 0)
+			return status;
+	}
+	return status;
+}
+
+static int set_key(struct cryp_device_data *device_data,
+		   u32 left_key,
+		   u32 right_key,
+		   enum cryp_key_reg_index index)
+{
+	struct cryp_key_value key_value;
+	int cryp_error;
+
+	dev_dbg(device_data->dev, "[%s]", __func__);
+
+	key_value.key_value_left = left_key;
+	key_value.key_value_right = right_key;
+
+	cryp_error = cryp_configure_key_values(device_data,
+					       index,
+					       key_value);
+	if (cryp_error != 0)
+		dev_err(device_data->dev, "[%s]: "
+			"cryp_configure_key_values() failed!", __func__);
+
+	return cryp_error;
+}
+
+static int cfg_keys(struct cryp_ctx *ctx)
+{
+	int i;
+	int num_of_regs = ctx->keylen / 8;
+	u32 swapped_key[CRYP_MAX_KEY_SIZE / 4];
+	int cryp_error = 0;
+
+	dev_dbg(ctx->device->dev, "[%s]", __func__);
+
+	if (mode_is_aes(ctx->config.algomode)) {
+		swap_words_in_key_and_bits_in_byte((u8 *)ctx->key,
+						   (u8 *)swapped_key,
+						   ctx->keylen);
+	} else {
+		for (i = 0; i < ctx->keylen / 4; i++)
+			swapped_key[i] = uint8p_to_uint32_be(ctx->key + i*4);
+	}
+
+	for (i = 0; i < num_of_regs; i++) {
+		cryp_error = set_key(ctx->device,
+				     *(((u32 *)swapped_key)+i*2),
+				     *(((u32 *)swapped_key)+i*2+1),
+				     (enum cryp_key_reg_index) i);
+
+		if (cryp_error != 0) {
+			dev_err(ctx->device->dev, "[%s]: set_key() failed!",
+					__func__);
+			return cryp_error;
+		}
+	}
+	return cryp_error;
+}
+
+static int cryp_setup_context(struct cryp_ctx *ctx,
+			      struct cryp_device_data *device_data)
+{
+	u32 control_register = CRYP_CR_DEFAULT;
+
+	switch (cryp_mode) {
+	case CRYP_MODE_INTERRUPT:
+		writel_relaxed(CRYP_IMSC_DEFAULT, &device_data->base->imsc);
+		break;
+
+	case CRYP_MODE_DMA:
+		writel_relaxed(CRYP_DMACR_DEFAULT, &device_data->base->dmacr);
+		break;
+
+	default:
+		break;
+	}
+
+	if (ctx->updated == 0) {
+		cryp_flush_inoutfifo(device_data);
+		if (cfg_keys(ctx) != 0) {
+			dev_err(ctx->device->dev, "[%s]: cfg_keys failed!",
+				__func__);
+			return -EINVAL;
+		}
+
+		if (ctx->iv &&
+		    CRYP_ALGO_AES_ECB != ctx->config.algomode &&
+		    CRYP_ALGO_DES_ECB != ctx->config.algomode &&
+		    CRYP_ALGO_TDES_ECB != ctx->config.algomode) {
+			if (cfg_ivs(device_data, ctx) != 0)
+				return -EPERM;
+		}
+
+		cryp_set_configuration(device_data, &ctx->config,
+				       &control_register);
+		add_session_id(ctx);
+	} else if (ctx->updated == 1 &&
+		   ctx->session_id != atomic_read(&session_id)) {
+		cryp_flush_inoutfifo(device_data);
+		cryp_restore_device_context(device_data, &ctx->dev_ctx);
+
+		add_session_id(ctx);
+		control_register = ctx->dev_ctx.cr;
+	} else
+		control_register = ctx->dev_ctx.cr;
+
+	writel(control_register |
+	       (CRYP_CRYPEN_ENABLE << CRYP_CR_CRYPEN_POS),
+	       &device_data->base->cr);
+
+	return 0;
+}
+
+static int cryp_get_device_data(struct cryp_ctx *ctx,
+				struct cryp_device_data **device_data)
+{
+	int ret;
+	struct klist_iter device_iterator;
+	struct klist_node *device_node;
+	struct cryp_device_data *local_device_data = NULL;
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	/* Wait until a device is available */
+	ret = down_interruptible(&driver_data.device_allocation);
+	if (ret)
+		return ret;  /* Interrupted */
+
+	/* Select a device */
+	klist_iter_init(&driver_data.device_list, &device_iterator);
+
+	device_node = klist_next(&device_iterator);
+	while (device_node) {
+		local_device_data = container_of(device_node,
+					   struct cryp_device_data, list_node);
+		spin_lock(&local_device_data->ctx_lock);
+		/* current_ctx allocates a device, NULL = unallocated */
+		if (local_device_data->current_ctx) {
+			device_node = klist_next(&device_iterator);
+		} else {
+			local_device_data->current_ctx = ctx;
+			ctx->device = local_device_data;
+			spin_unlock(&local_device_data->ctx_lock);
+			break;
+		}
+		spin_unlock(&local_device_data->ctx_lock);
+	}
+	klist_iter_exit(&device_iterator);
+
+	if (!device_node) {
+		/**
+		 * No free device found.
+		 * Since we allocated a device with down_interruptible, this
+		 * should not be able to happen.
+		 * Number of available devices, which are contained in
+		 * device_allocation, is therefore decremented by not doing
+		 * an up(device_allocation).
+		 */
+		return -EBUSY;
+	}
+
+	*device_data = local_device_data;
+
+	return 0;
+}
+
+static void cryp_dma_setup_channel(struct cryp_device_data *device_data,
+				   struct device *dev)
+{
+	dma_cap_zero(device_data->dma.mask);
+	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
+
+	device_data->dma.cfg_mem2cryp = mem_to_engine;
+	device_data->dma.chan_mem2cryp =
+		dma_request_channel(device_data->dma.mask,
+				    stedma40_filter,
+				    device_data->dma.cfg_mem2cryp);
+
+	device_data->dma.cfg_cryp2mem = engine_to_mem;
+	device_data->dma.chan_cryp2mem =
+		dma_request_channel(device_data->dma.mask,
+				    stedma40_filter,
+				    device_data->dma.cfg_cryp2mem);
+
+	init_completion(&device_data->dma.cryp_dma_complete);
+}
+
+static void cryp_dma_out_callback(void *data)
+{
+	struct cryp_ctx *ctx = (struct cryp_ctx *) data;
+	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
+
+	complete(&ctx->device->dma.cryp_dma_complete);
+}
+
+static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
+				 struct scatterlist *sg,
+				 int len,
+				 enum dma_data_direction direction)
+{
+	struct dma_async_tx_descriptor *desc;
+	struct dma_chan *channel = NULL;
+	dma_cookie_t cookie;
+
+	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
+
+	if (unlikely(!IS_ALIGNED((u32)sg, 4))) {
+		dev_err(ctx->device->dev, "[%s]: Data in sg list isn't "
+			"aligned! Addr: 0x%08x", __func__, (u32)sg);
+		return -EFAULT;
+	}
+
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		channel = ctx->device->dma.chan_mem2cryp;
+		ctx->device->dma.sg_src = sg;
+		ctx->device->dma.sg_src_len = dma_map_sg(channel->device->dev,
+						 ctx->device->dma.sg_src,
+						 ctx->device->dma.nents_src,
+						 direction);
+
+		if (!ctx->device->dma.sg_src_len) {
+			dev_dbg(ctx->device->dev,
+				"[%s]: Could not map the sg list (TO_DEVICE)",
+				__func__);
+			return -EFAULT;
+		}
+
+		dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
+			"(TO_DEVICE)", __func__);
+
+		desc = channel->device->device_prep_slave_sg(channel,
+					     ctx->device->dma.sg_src,
+					     ctx->device->dma.sg_src_len,
+					     direction,
+					     DMA_CTRL_ACK);
+		break;
+
+	case DMA_FROM_DEVICE:
+		channel = ctx->device->dma.chan_cryp2mem;
+		ctx->device->dma.sg_dst = sg;
+		ctx->device->dma.sg_dst_len = dma_map_sg(channel->device->dev,
+						 ctx->device->dma.sg_dst,
+						 ctx->device->dma.nents_dst,
+						 direction);
+
+		if (!ctx->device->dma.sg_dst_len) {
+			dev_dbg(ctx->device->dev,
+				"[%s]: Could not map the sg list (FROM_DEVICE)",
+				__func__);
+			return -EFAULT;
+		}
+
+		dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
+			"(FROM_DEVICE)", __func__);
+
+		desc = channel->device->device_prep_slave_sg(channel,
+					     ctx->device->dma.sg_dst,
+					     ctx->device->dma.sg_dst_len,
+					     direction,
+					     DMA_CTRL_ACK |
+					     DMA_PREP_INTERRUPT);
+
+		desc->callback = cryp_dma_out_callback;
+		desc->callback_param = ctx;
+		break;
+
+	default:
+		dev_dbg(ctx->device->dev, "[%s]: Invalid DMA direction",
+			__func__);
+		return -EFAULT;
+	}
+
+	cookie = desc->tx_submit(desc);
+	dma_async_issue_pending(channel);
+
+	return 0;
+}
+
+static void cryp_dma_done(struct cryp_ctx *ctx)
+{
+	struct dma_chan *chan;
+
+	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
+
+	chan = ctx->device->dma.chan_mem2cryp;
+	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_src,
+		     ctx->device->dma.sg_src_len, DMA_TO_DEVICE);
+
+	chan = ctx->device->dma.chan_cryp2mem;
+	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_dst,
+		     ctx->device->dma.sg_dst_len, DMA_FROM_DEVICE);
+}
+
+static int cryp_dma_write(struct cryp_ctx *ctx, struct scatterlist *sg,
+			  int len)
+{
+	int error = cryp_set_dma_transfer(ctx, sg, len, DMA_TO_DEVICE);
+	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
+
+	if (error) {
+		dev_dbg(ctx->device->dev, "[%s]: cryp_set_dma_transfer() "
+			"failed", __func__);
+		return error;
+	}
+
+	return len;
+}
+
+static int cryp_dma_read(struct cryp_ctx *ctx, struct scatterlist *sg, int len)
+{
+	int error = cryp_set_dma_transfer(ctx, sg, len, DMA_FROM_DEVICE);
+	if (error) {
+		dev_dbg(ctx->device->dev, "[%s]: cryp_set_dma_transfer() "
+			"failed", __func__);
+		return error;
+	}
+
+	return len;
+}
+
+static void cryp_polling_mode(struct cryp_ctx *ctx,
+			      struct cryp_device_data *device_data)
+{
+	int len = ctx->blocksize / BYTES_PER_WORD;
+	int remaining_length = ctx->datalen;
+	u32 *indata = (u32 *)ctx->indata;
+	u32 *outdata = (u32 *)ctx->outdata;
+
+	while (remaining_length > 0) {
+		writesl(&device_data->base->din, indata, len);
+		indata += len;
+		remaining_length -= (len * BYTES_PER_WORD);
+		cryp_wait_until_done(device_data);
+
+		readsl(&device_data->base->dout, outdata, len);
+		outdata += len;
+		cryp_wait_until_done(device_data);
+	}
+}
+
+static int cryp_disable_power(struct device *dev,
+			      struct cryp_device_data *device_data,
+			      bool save_device_context)
+{
+	int ret = 0;
+
+	dev_dbg(dev, "[%s]", __func__);
+
+	spin_lock(&device_data->power_state_spinlock);
+	if (!device_data->power_state)
+		goto out;
+
+	spin_lock(&device_data->ctx_lock);
+	if (save_device_context && device_data->current_ctx) {
+		cryp_save_device_context(device_data,
+				&device_data->current_ctx->dev_ctx,
+				cryp_mode);
+		device_data->restore_dev_ctx = true;
+	}
+	spin_unlock(&device_data->ctx_lock);
+
+	clk_disable(device_data->clk);
+	ret = regulator_disable(device_data->pwr_regulator);
+	if (ret)
+		dev_err(dev, "[%s]: "
+				"regulator_disable() failed!",
+				__func__);
+
+	device_data->power_state = false;
+
+out:
+	spin_unlock(&device_data->power_state_spinlock);
+
+	return ret;
+}
+
+static int cryp_enable_power(
+		struct device *dev,
+		struct cryp_device_data *device_data,
+		bool restore_device_context)
+{
+	int ret = 0;
+
+	dev_dbg(dev, "[%s]", __func__);
+
+	spin_lock(&device_data->power_state_spinlock);
+	if (!device_data->power_state) {
+		ret = regulator_enable(device_data->pwr_regulator);
+		if (ret) {
+			dev_err(dev, "[%s]: regulator_enable() failed!",
+					__func__);
+			goto out;
+		}
+
+		ret = clk_enable(device_data->clk);
+		if (ret) {
+			dev_err(dev, "[%s]: clk_enable() failed!",
+					__func__);
+			regulator_disable(device_data->pwr_regulator);
+			goto out;
+		}
+		device_data->power_state = true;
+	}
+
+	if (device_data->restore_dev_ctx) {
+		spin_lock(&device_data->ctx_lock);
+		if (restore_device_context && device_data->current_ctx) {
+			device_data->restore_dev_ctx = false;
+			cryp_restore_device_context(device_data,
+					&device_data->current_ctx->dev_ctx);
+		}
+		spin_unlock(&device_data->ctx_lock);
+	}
+out:
+	spin_unlock(&device_data->power_state_spinlock);
+
+	return ret;
+}
+
+static int hw_crypt_noxts(struct cryp_ctx *ctx,
+			  struct cryp_device_data *device_data)
+{
+	int ret = 0;
+
+	const u8 *indata = ctx->indata;
+	u8 *outdata = ctx->outdata;
+	u32 datalen = ctx->datalen;
+	u32 outlen = datalen;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	ctx->outlen = ctx->datalen;
+
+	if (unlikely(!IS_ALIGNED((u32)indata, 4))) {
+		pr_debug(DEV_DBG_NAME " [%s]: Data isn't aligned! Addr: "
+			 "0x%08x", __func__, (u32)indata);
+		return -EINVAL;
+	}
+
+	ret = cryp_setup_context(ctx, device_data);
+
+	if (ret)
+		goto out;
+
+	if (cryp_mode == CRYP_MODE_INTERRUPT) {
+		cryp_enable_irq_src(device_data, CRYP_IRQ_SRC_INPUT_FIFO |
+				    CRYP_IRQ_SRC_OUTPUT_FIFO);
+
+		/*
+		 * ctx->outlen is decremented in the cryp_interrupt_handler
+		 * function. We had to add cpu_relax() (barrier) to make sure
+		 * that gcc didn't optimze away this variable.
+		 */
+		while (ctx->outlen > 0)
+			cpu_relax();
+	} else if (cryp_mode == CRYP_MODE_POLLING ||
+		   cryp_mode == CRYP_MODE_DMA) {
+		/*
+		 * The reason for having DMA in this if case is that if we are
+		 * running cryp_mode = 2, then we separate DMA routines for
+		 * handling cipher/plaintext > blocksize, except when
+		 * running the normal CRYPTO_ALG_TYPE_CIPHER, then we still use
+		 * the polling mode. Overhead of doing DMA setup eats up the
+		 * benefits using it.
+		 */
+		cryp_polling_mode(ctx, device_data);
+	} else {
+		dev_err(ctx->device->dev, "[%s]: Invalid operation mode!",
+			__func__);
+		ret = -EPERM;
+		goto out;
+	}
+
+	cryp_save_device_context(device_data, &ctx->dev_ctx, cryp_mode);
+	ctx->updated = 1;
+
+out:
+	ctx->indata = indata;
+	ctx->outdata = outdata;
+	ctx->datalen = datalen;
+	ctx->outlen = outlen;
+
+	return ret;
+}
+
+static int get_nents(struct scatterlist *sg, int nbytes)
+{
+	int nents = 0;
+
+	while (nbytes > 0) {
+		nbytes -= sg->length;
+		sg = scatterwalk_sg_next(sg);
+		nents++;
+	}
+
+	return nents;
+}
+
+static int ablk_dma_crypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct cryp_device_data *device_data;
+
+	int bytes_written = 0;
+	int bytes_read = 0;
+	int ret;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	ctx->datalen = areq->nbytes;
+	ctx->outlen = areq->nbytes;
+
+	ret = cryp_get_device_data(ctx, &device_data);
+	if (ret)
+		return ret;
+
+	ret = cryp_setup_context(ctx, device_data);
+	if (ret)
+		goto out;
+
+	/* We have the device now, so store the nents in the dma struct. */
+	ctx->device->dma.nents_src = get_nents(areq->src, ctx->datalen);
+	ctx->device->dma.nents_dst = get_nents(areq->dst, ctx->outlen);
+
+	/* Enable DMA in- and output. */
+	cryp_configure_for_dma(device_data, CRYP_DMA_ENABLE_BOTH_DIRECTIONS);
+
+	bytes_written = cryp_dma_write(ctx, areq->src, ctx->datalen);
+	bytes_read = cryp_dma_read(ctx, areq->dst, bytes_written);
+
+	wait_for_completion(&ctx->device->dma.cryp_dma_complete);
+	cryp_dma_done(ctx);
+
+	cryp_save_device_context(device_data, &ctx->dev_ctx, cryp_mode);
+	ctx->updated = 1;
+
+out:
+	spin_lock(&device_data->ctx_lock);
+	device_data->current_ctx = NULL;
+	ctx->device = NULL;
+	spin_unlock(&device_data->ctx_lock);
+
+	/*
+	 * The down_interruptible part for this semaphore is called in
+	 * cryp_get_device_data.
+	 */
+	up(&driver_data.device_allocation);
+
+	if (unlikely(bytes_written != bytes_read))
+		return -EPERM;
+
+	return 0;
+}
+
+static int ablk_crypt(struct ablkcipher_request *areq)
+{
+	struct ablkcipher_walk walk;
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct cryp_device_data *device_data;
+	unsigned long src_paddr;
+	unsigned long dst_paddr;
+	int ret;
+	int nbytes;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	ret = cryp_get_device_data(ctx, &device_data);
+	if (ret)
+		goto out;
+
+	ablkcipher_walk_init(&walk, areq->dst, areq->src, areq->nbytes);
+	ret = ablkcipher_walk_phys(areq, &walk);
+
+	if (ret) {
+		pr_err(DEV_DBG_NAME "[%s]: ablkcipher_walk_phys() failed!",
+			__func__);
+		goto out;
+	}
+
+	while ((nbytes = walk.nbytes) > 0) {
+		ctx->iv = walk.iv;
+		src_paddr = (page_to_phys(walk.src.page) + walk.src.offset);
+		ctx->indata = phys_to_virt(src_paddr);
+
+		dst_paddr = (page_to_phys(walk.dst.page) + walk.dst.offset);
+		ctx->outdata = phys_to_virt(dst_paddr);
+
+		ctx->datalen = nbytes - (nbytes % ctx->blocksize);
+
+		ret = hw_crypt_noxts(ctx, device_data);
+		if (ret)
+			goto out;
+
+		nbytes -= ctx->datalen;
+		ret = ablkcipher_walk_done(areq, &walk, nbytes);
+		if (ret)
+			goto out;
+	}
+	ablkcipher_walk_complete(&walk);
+
+out:
+	/* Release the device */
+	spin_lock(&device_data->ctx_lock);
+	device_data->current_ctx = NULL;
+	ctx->device = NULL;
+	spin_unlock(&device_data->ctx_lock);
+
+	/*
+	 * The down_interruptible part for this semaphore is called in
+	 * cryp_get_device_data.
+	 */
+	up(&driver_data.device_allocation);
+
+	return ret;
+}
+
+static int aes_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+				 const u8 *key, unsigned int keylen)
+{
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 *flags = &cipher->base.crt_flags;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		ctx->config.keysize = CRYP_KEY_SIZE_128;
+		break;
+
+	case AES_KEYSIZE_192:
+		ctx->config.keysize = CRYP_KEY_SIZE_192;
+		break;
+
+	case AES_KEYSIZE_256:
+		ctx->config.keysize = CRYP_KEY_SIZE_256;
+		break;
+
+	default:
+		pr_err(DEV_DBG_NAME "[%s]: Unknown keylen!", __func__);
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	ctx->updated = 0;
+
+	return 0;
+}
+
+static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+				 const u8 *key, unsigned int keylen)
+{
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 *flags = &cipher->base.crt_flags;
+	u32 tmp[DES_EXPKEY_WORDS];
+	int ret;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+	if (keylen != DES_KEY_SIZE) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_BAD_KEY_LEN",
+				__func__);
+		return -EINVAL;
+	}
+
+	ret = des_ekey(tmp, key);
+	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_REQ_WEAK_KEY",
+				__func__);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	ctx->updated = 0;
+	return 0;
+}
+
+static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 *flags = &cipher->base.crt_flags;
+	const u32 *K = (const u32 *)key;
+	u32 tmp[DES3_EDE_EXPKEY_WORDS];
+	int i, ret;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+	if (keylen != DES3_EDE_KEY_SIZE) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_BAD_KEY_LEN",
+				__func__);
+		return -EINVAL;
+	}
+
+	/* Checking key interdependency for weak key detection. */
+	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
+				!((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+			(*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_REQ_WEAK_KEY",
+				__func__);
+		return -EINVAL;
+	}
+	for (i = 0; i < 3; i++) {
+		ret = des_ekey(tmp, key + i*DES_KEY_SIZE);
+		if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+			pr_debug(DEV_DBG_NAME " [%s]: "
+					"CRYPTO_TFM_REQ_WEAK_KEY", __func__);
+			return -EINVAL;
+		}
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	ctx->updated = 0;
+	return 0;
+}
+
+static int cryp_blk_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	ctx->config.algodir = CRYP_ALGORITHM_ENCRYPT;
+
+	/*
+	 * DMA does not work for DES due to a hw bug */
+	if (cryp_mode == CRYP_MODE_DMA && mode_is_aes(ctx->config.algomode))
+		return ablk_dma_crypt(areq);
+
+	/* For everything except DMA, we run the non DMA version. */
+	return ablk_crypt(areq);
+}
+
+static int cryp_blk_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	ctx->config.algodir = CRYP_ALGORITHM_DECRYPT;
+
+	/* DMA does not work for DES due to a hw bug */
+	if (cryp_mode == CRYP_MODE_DMA && mode_is_aes(ctx->config.algomode))
+		return ablk_dma_crypt(areq);
+
+	/* For everything except DMA, we run the non DMA version. */
+	return ablk_crypt(areq);
+}
+
+struct cryp_algo_template {
+	enum cryp_algo_mode algomode;
+	struct crypto_alg crypto;
+};
+
+static int cryp_cra_init(struct crypto_tfm *tfm)
+{
+	struct cryp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct cryp_algo_template *cryp_alg = container_of(alg,
+			struct cryp_algo_template,
+			crypto);
+
+	ctx->config.algomode = cryp_alg->algomode;
+	ctx->blocksize = crypto_tfm_alg_blocksize(tfm);
+
+	return 0;
+}
+
+static struct cryp_algo_template cryp_algs[] = {
+	{
+		.algomode = CRYP_ALGO_AES_ECB,
+		.crypto = {
+			.cra_name = "aes",
+			.cra_driver_name = "aes-ux500",
+			.cra_priority =	300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = AES_MIN_KEY_SIZE,
+					.max_keysize = AES_MAX_KEY_SIZE,
+					.setkey = aes_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_AES_ECB,
+		.crypto = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = AES_MIN_KEY_SIZE,
+					.max_keysize = AES_MAX_KEY_SIZE,
+					.setkey = aes_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_AES_CBC,
+		.crypto = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "cbc-aes-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = AES_MIN_KEY_SIZE,
+					.max_keysize = AES_MAX_KEY_SIZE,
+					.setkey = aes_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+					.ivsize = AES_BLOCK_SIZE,
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_AES_CTR,
+		.crypto = {
+			.cra_name = "ctr(aes)",
+			.cra_driver_name = "ctr-aes-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+						CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = AES_MIN_KEY_SIZE,
+					.max_keysize = AES_MAX_KEY_SIZE,
+					.setkey = aes_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+					.ivsize = AES_BLOCK_SIZE,
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_DES_ECB,
+		.crypto = {
+			.cra_name = "des",
+			.cra_driver_name = "des-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+						CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = DES_KEY_SIZE,
+					.max_keysize = DES_KEY_SIZE,
+					.setkey = des_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt
+				}
+			}
+		}
+
+	},
+	{
+		.algomode = CRYP_ALGO_TDES_ECB,
+		.crypto = {
+			.cra_name = "des3_ede",
+			.cra_driver_name = "des3_ede-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+						CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = DES3_EDE_KEY_SIZE,
+					.max_keysize = DES3_EDE_KEY_SIZE,
+					.setkey = des_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_DES_ECB,
+		.crypto = {
+			.cra_name = "ecb(des)",
+			.cra_driver_name = "ecb-des-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = DES_KEY_SIZE,
+					.max_keysize = DES_KEY_SIZE,
+					.setkey = des_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_TDES_ECB,
+		.crypto = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "ecb-des3_ede-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = DES3_EDE_KEY_SIZE,
+					.max_keysize = DES3_EDE_KEY_SIZE,
+					.setkey = des3_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_DES_CBC,
+		.crypto = {
+			.cra_name = "cbc(des)",
+			.cra_driver_name = "cbc-des-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = DES_KEY_SIZE,
+					.max_keysize = DES_KEY_SIZE,
+					.setkey = des_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+				}
+			}
+		}
+	},
+	{
+		.algomode = CRYP_ALGO_TDES_CBC,
+		.crypto = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "cbc-des3_ede-ux500",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct cryp_ctx),
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = cryp_cra_init,
+			.cra_module = THIS_MODULE,
+			.cra_u = {
+				.ablkcipher = {
+					.min_keysize = DES3_EDE_KEY_SIZE,
+					.max_keysize = DES3_EDE_KEY_SIZE,
+					.setkey = des3_ablkcipher_setkey,
+					.encrypt = cryp_blk_encrypt,
+					.decrypt = cryp_blk_decrypt,
+					.ivsize = DES3_EDE_BLOCK_SIZE,
+				}
+			}
+		}
+	}
+};
+
+/**
+ * cryp_algs_register_all -
+ */
+static int cryp_algs_register_all(void)
+{
+	int ret;
+	int i;
+	int count;
+
+	pr_debug("[%s]", __func__);
+
+	for (i = 0; i < ARRAY_SIZE(cryp_algs); i++) {
+		ret = crypto_register_alg(&cryp_algs[i].crypto);
+		if (ret) {
+			count = i;
+			pr_err("[%s] alg registration failed",
+					cryp_algs[i].crypto.cra_driver_name);
+			goto unreg;
+		}
+	}
+	return 0;
+unreg:
+	for (i = 0; i < count; i++)
+		crypto_unregister_alg(&cryp_algs[i].crypto);
+	return ret;
+}
+
+/**
+ * cryp_algs_unregister_all -
+ */
+static void cryp_algs_unregister_all(void)
+{
+	int i;
+
+	pr_debug(DEV_DBG_NAME " [%s]", __func__);
+
+	for (i = 0; i < ARRAY_SIZE(cryp_algs); i++)
+		crypto_unregister_alg(&cryp_algs[i].crypto);
+}
+
+static int ux500_cryp_probe(struct platform_device *pdev)
+{
+	int ret;
+	int cryp_error = 0;
+	struct resource *res = NULL;
+	struct resource *res_irq = NULL;
+	struct cryp_device_data *device_data;
+	struct cryp_protection_config prot = {
+		.privilege_access = CRYP_STATE_ENABLE
+	};
+	struct device *dev = &pdev->dev;
+
+	dev_dbg(dev, "[%s]", __func__);
+	device_data = kzalloc(sizeof(struct cryp_device_data), GFP_ATOMIC);
+	if (!device_data) {
+		dev_err(dev, "[%s]: kzalloc() failed!", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	device_data->dev = dev;
+	device_data->current_ctx = NULL;
+
+	/* Grab the DMA configuration from platform data. */
+	mem_to_engine = &((struct cryp_platform_data *)
+			 dev->platform_data)->mem_to_engine;
+	engine_to_mem = &((struct cryp_platform_data *)
+			 dev->platform_data)->engine_to_mem;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "[%s]: platform_get_resource() failed",
+				__func__);
+		ret = -ENODEV;
+		goto out_kfree;
+	}
+
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	if (res == NULL) {
+		dev_err(dev, "[%s]: request_mem_region() failed",
+				__func__);
+		ret = -EBUSY;
+		goto out_kfree;
+	}
+
+	device_data->base = ioremap(res->start, resource_size(res));
+	if (!device_data->base) {
+		dev_err(dev, "[%s]: ioremap failed!", __func__);
+		ret = -ENOMEM;
+		goto out_free_mem;
+	}
+
+	spin_lock_init(&device_data->ctx_lock);
+	spin_lock_init(&device_data->power_state_spinlock);
+
+	/* Enable power for CRYP hardware block */
+	device_data->pwr_regulator = regulator_get(&pdev->dev, "v-ape");
+	if (IS_ERR(device_data->pwr_regulator)) {
+		dev_err(dev, "[%s]: could not get cryp regulator", __func__);
+		ret = PTR_ERR(device_data->pwr_regulator);
+		device_data->pwr_regulator = NULL;
+		goto out_unmap;
+	}
+
+	/* Enable the clk for CRYP hardware block */
+	device_data->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(device_data->clk)) {
+		dev_err(dev, "[%s]: clk_get() failed!", __func__);
+		ret = PTR_ERR(device_data->clk);
+		goto out_regulator;
+	}
+
+	/* Enable device power (and clock) */
+	ret = cryp_enable_power(device_data->dev, device_data, false);
+	if (ret) {
+		dev_err(dev, "[%s]: cryp_enable_power() failed!", __func__);
+		goto out_clk;
+	}
+
+	cryp_error = cryp_check(device_data);
+	if (cryp_error != 0) {
+		dev_err(dev, "[%s]: cryp_init() failed!", __func__);
+		ret = -EINVAL;
+		goto out_power;
+	}
+
+	cryp_error = cryp_configure_protection(device_data, &prot);
+	if (cryp_error != 0) {
+		dev_err(dev, "[%s]: cryp_configure_protection() failed!",
+			__func__);
+		ret = -EINVAL;
+		goto out_power;
+	}
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq) {
+		dev_err(dev, "[%s]: IORESOURCE_IRQ unavailable",
+			__func__);
+		goto out_power;
+	}
+
+	ret = request_irq(res_irq->start,
+			  cryp_interrupt_handler,
+			  0,
+			  "cryp1",
+			  device_data);
+	if (ret) {
+		dev_err(dev, "[%s]: Unable to request IRQ", __func__);
+		goto out_power;
+	}
+
+	if (cryp_mode == CRYP_MODE_DMA)
+		cryp_dma_setup_channel(device_data, dev);
+
+	platform_set_drvdata(pdev, device_data);
+
+	/* Put the new device into the device list... */
+	klist_add_tail(&device_data->list_node, &driver_data.device_list);
+
+	/* ... and signal that a new device is available. */
+	up(&driver_data.device_allocation);
+
+	atomic_set(&session_id, 1);
+
+	ret = cryp_algs_register_all();
+	if (ret) {
+		dev_err(dev, "[%s]: cryp_algs_register_all() failed!",
+			__func__);
+		goto out_power;
+	}
+
+	return 0;
+
+out_power:
+	cryp_disable_power(device_data->dev, device_data, false);
+
+out_clk:
+	clk_put(device_data->clk);
+
+out_regulator:
+	regulator_put(device_data->pwr_regulator);
+
+out_unmap:
+	iounmap(device_data->base);
+
+out_free_mem:
+	release_mem_region(res->start, resource_size(res));
+
+out_kfree:
+	kfree(device_data);
+out:
+	return ret;
+}
+
+static int ux500_cryp_remove(struct platform_device *pdev)
+{
+	struct resource *res = NULL;
+	struct resource *res_irq = NULL;
+	struct cryp_device_data *device_data;
+
+	dev_dbg(&pdev->dev, "[%s]", __func__);
+	device_data = platform_get_drvdata(pdev);
+	if (!device_data) {
+		dev_err(&pdev->dev, "[%s]: platform_get_drvdata() failed!",
+			__func__);
+		return -ENOMEM;
+	}
+
+	/* Try to decrease the number of available devices. */
+	if (down_trylock(&driver_data.device_allocation))
+		return -EBUSY;
+
+	/* Check that the device is free */
+	spin_lock(&device_data->ctx_lock);
+	/* current_ctx allocates a device, NULL = unallocated */
+	if (device_data->current_ctx) {
+		/* The device is busy */
+		spin_unlock(&device_data->ctx_lock);
+		/* Return the device to the pool. */
+		up(&driver_data.device_allocation);
+		return -EBUSY;
+	}
+
+	spin_unlock(&device_data->ctx_lock);
+
+	/* Remove the device from the list */
+	if (klist_node_attached(&device_data->list_node))
+		klist_remove(&device_data->list_node);
+
+	/* If this was the last device, remove the services */
+	if (list_empty(&driver_data.device_list.k_list))
+		cryp_algs_unregister_all();
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq)
+		dev_err(&pdev->dev, "[%s]: IORESOURCE_IRQ, unavailable",
+			__func__);
+	else {
+		disable_irq(res_irq->start);
+		free_irq(res_irq->start, device_data);
+	}
+
+	if (cryp_disable_power(&pdev->dev, device_data, false))
+		dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
+			__func__);
+
+	clk_put(device_data->clk);
+	regulator_put(device_data->pwr_regulator);
+
+	iounmap(device_data->base);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		release_mem_region(res->start, res->end - res->start + 1);
+
+	kfree(device_data);
+
+	return 0;
+}
+
+static void ux500_cryp_shutdown(struct platform_device *pdev)
+{
+	struct resource *res_irq = NULL;
+	struct cryp_device_data *device_data;
+
+	dev_dbg(&pdev->dev, "[%s]", __func__);
+
+	device_data = platform_get_drvdata(pdev);
+	if (!device_data) {
+		dev_err(&pdev->dev, "[%s]: platform_get_drvdata() failed!",
+			__func__);
+		return;
+	}
+
+	/* Check that the device is free */
+	spin_lock(&device_data->ctx_lock);
+	/* current_ctx allocates a device, NULL = unallocated */
+	if (!device_data->current_ctx) {
+		if (down_trylock(&driver_data.device_allocation))
+			dev_dbg(&pdev->dev, "[%s]: Cryp still in use!"
+				"Shutting down anyway...", __func__);
+		/**
+		 * (Allocate the device)
+		 * Need to set this to non-null (dummy) value,
+		 * to avoid usage if context switching.
+		 */
+		device_data->current_ctx++;
+	}
+	spin_unlock(&device_data->ctx_lock);
+
+	/* Remove the device from the list */
+	if (klist_node_attached(&device_data->list_node))
+		klist_remove(&device_data->list_node);
+
+	/* If this was the last device, remove the services */
+	if (list_empty(&driver_data.device_list.k_list))
+		cryp_algs_unregister_all();
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq)
+		dev_err(&pdev->dev, "[%s]: IORESOURCE_IRQ, unavailable",
+			__func__);
+	else {
+		disable_irq(res_irq->start);
+		free_irq(res_irq->start, device_data);
+	}
+
+	if (cryp_disable_power(&pdev->dev, device_data, false))
+		dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
+			__func__);
+
+}
+
+static int ux500_cryp_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	int ret;
+	struct cryp_device_data *device_data;
+	struct resource *res_irq;
+	struct cryp_ctx *temp_ctx = NULL;
+
+	dev_dbg(&pdev->dev, "[%s]", __func__);
+
+	/* Handle state? */
+	device_data = platform_get_drvdata(pdev);
+	if (!device_data) {
+		dev_err(&pdev->dev, "[%s]: platform_get_drvdata() failed!",
+			__func__);
+		return -ENOMEM;
+	}
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq)
+		dev_err(&pdev->dev, "[%s]: IORESOURCE_IRQ, unavailable",
+			__func__);
+	else
+		disable_irq(res_irq->start);
+
+	spin_lock(&device_data->ctx_lock);
+	if (!device_data->current_ctx)
+		device_data->current_ctx++;
+	spin_unlock(&device_data->ctx_lock);
+
+	if (device_data->current_ctx == ++temp_ctx) {
+		if (down_interruptible(&driver_data.device_allocation))
+			dev_dbg(&pdev->dev, "[%s]: down_interruptible() "
+					"failed", __func__);
+		ret = cryp_disable_power(&pdev->dev, device_data, false);
+
+	} else
+		ret = cryp_disable_power(&pdev->dev, device_data, true);
+
+	if (ret)
+		dev_err(&pdev->dev, "[%s]: cryp_disable_power()", __func__);
+
+	return ret;
+}
+
+static int ux500_cryp_resume(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct cryp_device_data *device_data;
+	struct resource *res_irq;
+	struct cryp_ctx *temp_ctx = NULL;
+
+	dev_dbg(&pdev->dev, "[%s]", __func__);
+
+	device_data = platform_get_drvdata(pdev);
+	if (!device_data) {
+		dev_err(&pdev->dev, "[%s]: platform_get_drvdata() failed!",
+			__func__);
+		return -ENOMEM;
+	}
+
+	spin_lock(&device_data->ctx_lock);
+	if (device_data->current_ctx == ++temp_ctx)
+		device_data->current_ctx = NULL;
+	spin_unlock(&device_data->ctx_lock);
+
+
+	if (!device_data->current_ctx)
+		up(&driver_data.device_allocation);
+	else
+		ret = cryp_enable_power(&pdev->dev, device_data, true);
+
+	if (ret)
+		dev_err(&pdev->dev, "[%s]: cryp_enable_power() failed!",
+			__func__);
+	else {
+		res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+		if (res_irq)
+			enable_irq(res_irq->start);
+	}
+
+	return ret;
+}
+
+static struct platform_driver cryp_driver = {
+	.probe  = ux500_cryp_probe,
+	.remove = ux500_cryp_remove,
+	.shutdown = ux500_cryp_shutdown,
+	.suspend  = ux500_cryp_suspend,
+	.resume   = ux500_cryp_resume,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = "cryp1"
+	}
+};
+
+static int __init ux500_cryp_mod_init(void)
+{
+	pr_debug("[%s] is called!", __func__);
+	klist_init(&driver_data.device_list, NULL, NULL);
+	/* Initialize the semaphore to 0 devices (locked state) */
+	sema_init(&driver_data.device_allocation, 0);
+	return platform_driver_register(&cryp_driver);
+}
+
+static void __exit ux500_cryp_mod_fini(void)
+{
+	pr_debug("[%s] is called!", __func__);
+	platform_driver_unregister(&cryp_driver);
+	return;
+}
+
+module_init(ux500_cryp_mod_init);
+module_exit(ux500_cryp_mod_fini);
+
+module_param(cryp_mode, int, 0);
+
+MODULE_DESCRIPTION("Driver for ST-Ericsson UX500 CRYP crypto engine.");
+MODULE_ALIAS("aes-all");
+MODULE_ALIAS("des-all");
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/ux500/cryp/cryp_irq.c b/drivers/crypto/ux500/cryp/cryp_irq.c
new file mode 100644
index 0000000..08d291c
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp_irq.c
@@ -0,0 +1,45 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/device.h>
+
+#include "cryp.h"
+#include "cryp_p.h"
+#include "cryp_irq.h"
+#include "cryp_irqp.h"
+
+void cryp_enable_irq_src(struct cryp_device_data *device_data, u32 irq_src)
+{
+	u32 i;
+
+	dev_dbg(device_data->dev, "[%s]", __func__);
+
+	i = readl_relaxed(&device_data->base->imsc);
+	i = i | irq_src;
+	writel_relaxed(i, &device_data->base->imsc);
+}
+
+void cryp_disable_irq_src(struct cryp_device_data *device_data, u32 irq_src)
+{
+	u32 i;
+
+	dev_dbg(device_data->dev, "[%s]", __func__);
+
+	i = readl_relaxed(&device_data->base->imsc);
+	i = i & ~irq_src;
+	writel_relaxed(i, &device_data->base->imsc);
+}
+
+bool cryp_pending_irq_src(struct cryp_device_data *device_data, u32 irq_src)
+{
+	return (readl_relaxed(&device_data->base->mis) & irq_src) > 0;
+}
diff --git a/drivers/crypto/ux500/cryp/cryp_irq.h b/drivers/crypto/ux500/cryp/cryp_irq.h
new file mode 100644
index 0000000..5a7837f
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp_irq.h
@@ -0,0 +1,31 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef _CRYP_IRQ_H_
+#define _CRYP_IRQ_H_
+
+#include "cryp.h"
+
+enum cryp_irq_src_id {
+	CRYP_IRQ_SRC_INPUT_FIFO = 0x1,
+	CRYP_IRQ_SRC_OUTPUT_FIFO = 0x2,
+	CRYP_IRQ_SRC_ALL = 0x3
+};
+
+/**
+ * M0 Funtions
+ */
+void cryp_enable_irq_src(struct cryp_device_data *device_data, u32 irq_src);
+
+void cryp_disable_irq_src(struct cryp_device_data *device_data, u32 irq_src);
+
+bool cryp_pending_irq_src(struct cryp_device_data *device_data, u32 irq_src);
+
+#endif				/* _CRYP_IRQ_H_ */
diff --git a/drivers/crypto/ux500/cryp/cryp_irqp.h b/drivers/crypto/ux500/cryp/cryp_irqp.h
new file mode 100644
index 0000000..8b339cc
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp_irqp.h
@@ -0,0 +1,125 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __CRYP_IRQP_H_
+#define __CRYP_IRQP_H_
+
+#include "cryp_irq.h"
+
+/**
+ *
+ * CRYP Registers - Offset mapping
+ *     +-----------------+
+ * 00h | CRYP_CR         |  Configuration register
+ *     +-----------------+
+ * 04h | CRYP_SR         |  Status register
+ *     +-----------------+
+ * 08h | CRYP_DIN        |  Data In register
+ *     +-----------------+
+ * 0ch | CRYP_DOUT       |  Data out register
+ *     +-----------------+
+ * 10h | CRYP_DMACR      |  DMA control register
+ *     +-----------------+
+ * 14h | CRYP_IMSC       |  IMSC
+ *     +-----------------+
+ * 18h | CRYP_RIS        |  Raw interrupt status
+ *     +-----------------+
+ * 1ch | CRYP_MIS        |  Masked interrupt status.
+ *     +-----------------+
+ *       Key registers
+ *       IVR registers
+ *       Peripheral
+ *       Cell IDs
+ *
+ *       Refer data structure for other register map
+ */
+
+/**
+ * struct cryp_register
+ * @cr			- Configuration register
+ * @status		- Status register
+ * @din			- Data input register
+ * @din_size		- Data input size register
+ * @dout		- Data output register
+ * @dout_size		- Data output size register
+ * @dmacr		- Dma control register
+ * @imsc		- Interrupt mask set/clear register
+ * @ris			- Raw interrupt status
+ * @mis			- Masked interrupt statu register
+ * @key_1_l		- Key register 1 L
+ * @key_1_r		- Key register 1 R
+ * @key_2_l		- Key register 2 L
+ * @key_2_r		- Key register 2 R
+ * @key_3_l		- Key register 3 L
+ * @key_3_r		- Key register 3 R
+ * @key_4_l		- Key register 4 L
+ * @key_4_r		- Key register 4 R
+ * @init_vect_0_l	- init vector 0 L
+ * @init_vect_0_r	- init vector 0 R
+ * @init_vect_1_l	- init vector 1 L
+ * @init_vect_1_r	- init vector 1 R
+ * @cryp_unused1	- unused registers
+ * @itcr		- Integration test control register
+ * @itip		- Integration test input register
+ * @itop		- Integration test output register
+ * @cryp_unused2	- unused registers
+ * @periphId0		- FE0 CRYP Peripheral Identication Register
+ * @periphId1		- FE4
+ * @periphId2		- FE8
+ * @periphId3		- FEC
+ * @pcellId0		- FF0  CRYP PCell Identication Register
+ * @pcellId1		- FF4
+ * @pcellId2		- FF8
+ * @pcellId3		- FFC
+ */
+struct cryp_register {
+	u32 cr;			/* Configuration register   */
+	u32 sr;			/* Status register          */
+	u32 din;		/* Data input register      */
+	u32 din_size;		/* Data input size register */
+	u32 dout;		/* Data output register     */
+	u32 dout_size;		/* Data output size register */
+	u32 dmacr;		/* Dma control register     */
+	u32 imsc;		/* Interrupt mask set/clear register */
+	u32 ris;		/* Raw interrupt status             */
+	u32 mis;		/* Masked interrupt statu register  */
+
+	u32 key_1_l;		/*Key register 1 L */
+	u32 key_1_r;		/*Key register 1 R */
+	u32 key_2_l;		/*Key register 2 L */
+	u32 key_2_r;		/*Key register 2 R */
+	u32 key_3_l;		/*Key register 3 L */
+	u32 key_3_r;		/*Key register 3 R */
+	u32 key_4_l;		/*Key register 4 L */
+	u32 key_4_r;		/*Key register 4 R */
+
+	u32 init_vect_0_l;	/*init vector 0 L */
+	u32 init_vect_0_r;	/*init vector 0 R */
+	u32 init_vect_1_l;	/*init vector 1 L */
+	u32 init_vect_1_r;	/*init vector 1 R */
+
+	u32 cryp_unused1[(0x80 - 0x58) / sizeof(u32)];	/* unused registers */
+	u32 itcr;		/*Integration test control register */
+	u32 itip;		/*Integration test input register */
+	u32 itop;		/*Integration test output register */
+	u32 cryp_unused2[(0xFE0 - 0x8C) / sizeof(u32)];	/* unused registers */
+
+	u32 periphId0;		/* FE0  CRYP Peripheral Identication Register */
+	u32 periphId1;		/* FE4 */
+	u32 periphId2;		/* FE8 */
+	u32 periphId3;		/* FEC */
+
+	u32 pcellId0;		/* FF0  CRYP PCell Identication Register */
+	u32 pcellId1;		/* FF4 */
+	u32 pcellId2;		/* FF8 */
+	u32 pcellId3;		/* FFC */
+};
+
+#endif
diff --git a/drivers/crypto/ux500/cryp/cryp_p.h b/drivers/crypto/ux500/cryp/cryp_p.h
new file mode 100644
index 0000000..0e07082
--- /dev/null
+++ b/drivers/crypto/ux500/cryp/cryp_p.h
@@ -0,0 +1,124 @@
+/**
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
+ * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
+ * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
+ * Author: Berne Hebark <berne.herbark@stericsson.com> for ST-Ericsson.
+ * Author: Niklas Hernaeus <niklas.hernaeus@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef _CRYP_P_H_
+#define _CRYP_P_H_
+
+#include <linux/io.h>
+#include <linux/bitops.h>
+
+#include "cryp.h"
+#include "cryp_irqp.h"
+
+/**
+ * Generic Macros
+ */
+#define CRYP_SET_BITS(reg_name, mask) \
+	writel_relaxed((readl_relaxed(reg_name) | mask), reg_name)
+
+#define CRYP_WRITE_BIT(reg_name, val, mask) \
+	writel_relaxed(((readl_relaxed(reg_name) & ~(mask)) |\
+			((val) & (mask))), reg_name)
+
+#define CRYP_TEST_BITS(reg_name, val) \
+	(readl_relaxed(reg_name) & (val))
+
+#define CRYP_PUT_BITS(reg, val, shift, mask) \
+	writel_relaxed(((readl_relaxed(reg) & ~(mask)) | \
+		(((u32)val << shift) & (mask))), reg)
+
+/**
+ * CRYP specific Macros
+ */
+#define CRYP_PERIPHERAL_ID0		0xE3
+#define CRYP_PERIPHERAL_ID1		0x05
+
+#define CRYP_PERIPHERAL_ID2_DB8500	0x28
+#define CRYP_PERIPHERAL_ID2_DB5500	0x29
+#define CRYP_PERIPHERAL_ID3		0x00
+
+#define CRYP_PCELL_ID0			0x0D
+#define CRYP_PCELL_ID1			0xF0
+#define CRYP_PCELL_ID2			0x05
+#define CRYP_PCELL_ID3			0xB1
+
+/**
+ * CRYP register default values
+ */
+#define MAX_DEVICE_SUPPORT		2
+
+/* Priv set, keyrden set and datatype 8bits swapped set as default. */
+#define CRYP_CR_DEFAULT			0x0482
+#define CRYP_DMACR_DEFAULT		0x0
+#define CRYP_IMSC_DEFAULT		0x0
+#define CRYP_DIN_DEFAULT		0x0
+#define CRYP_DOUT_DEFAULT		0x0
+#define CRYP_KEY_DEFAULT		0x0
+#define CRYP_INIT_VECT_DEFAULT		0x0
+
+/**
+ * CRYP Control register specific mask
+ */
+#define CRYP_CR_SECURE_MASK		BIT(0)
+#define CRYP_CR_PRLG_MASK		BIT(1)
+#define CRYP_CR_ALGODIR_MASK		BIT(2)
+#define CRYP_CR_ALGOMODE_MASK		(BIT(5) | BIT(4) | BIT(3))
+#define CRYP_CR_DATATYPE_MASK		(BIT(7) | BIT(6))
+#define CRYP_CR_KEYSIZE_MASK		(BIT(9) | BIT(8))
+#define CRYP_CR_KEYRDEN_MASK		BIT(10)
+#define CRYP_CR_KSE_MASK		BIT(11)
+#define CRYP_CR_START_MASK		BIT(12)
+#define CRYP_CR_INIT_MASK		BIT(13)
+#define CRYP_CR_FFLUSH_MASK		BIT(14)
+#define CRYP_CR_CRYPEN_MASK		BIT(15)
+#define CRYP_CR_CONTEXT_SAVE_MASK	(CRYP_CR_SECURE_MASK |\
+					 CRYP_CR_PRLG_MASK |\
+					 CRYP_CR_ALGODIR_MASK |\
+					 CRYP_CR_ALGOMODE_MASK |\
+					 CRYP_CR_DATATYPE_MASK |\
+					 CRYP_CR_KEYSIZE_MASK |\
+					 CRYP_CR_KEYRDEN_MASK |\
+					 CRYP_CR_DATATYPE_MASK)
+
+
+#define CRYP_SR_INFIFO_READY_MASK	(BIT(0) | BIT(1))
+#define CRYP_SR_IFEM_MASK		BIT(0)
+#define CRYP_SR_BUSY_MASK		BIT(4)
+
+/**
+ * Bit position used while setting bits in register
+ */
+#define CRYP_CR_PRLG_POS		1
+#define CRYP_CR_ALGODIR_POS		2
+#define CRYP_CR_ALGOMODE_POS		3
+#define CRYP_CR_DATATYPE_POS		6
+#define CRYP_CR_KEYSIZE_POS		8
+#define CRYP_CR_KEYRDEN_POS		10
+#define CRYP_CR_KSE_POS			11
+#define CRYP_CR_START_POS		12
+#define CRYP_CR_INIT_POS		13
+#define CRYP_CR_CRYPEN_POS		15
+
+#define CRYP_SR_BUSY_POS		4
+
+/**
+ * CRYP PCRs------PC_NAND control register
+ * BIT_MASK
+ */
+#define CRYP_DMA_REQ_MASK		(BIT(1) | BIT(0))
+#define CRYP_DMA_REQ_MASK_POS		0
+
+
+struct cryp_system_context {
+	/* CRYP Register structure */
+	struct cryp_register *p_cryp_reg[MAX_DEVICE_SUPPORT];
+};
+
+#endif
-- 
1.7.9.4
