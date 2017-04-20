From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v2 1/9] staging: ccree: introduce CryptoCell HW driver
Date: Thu, 20 Apr 2017 16:12:55 +0300
Message-ID: <1492693983-8175-2-git-send-email-gilad@benyossef.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gilad.benyossef-5wv7dgnIgG8@public.gmane.org,
        Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>,
        Stuart Yoder <stuart.yoder-5wv7dgnIgG8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492693983-8175-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Introduce basic low level Arm TrustZone CryptoCell HW support.
This first patch doesn't actually register any Crypto API
transformations, these will follow up in the next patch.

This first revision supports the CC 712 REE component.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 drivers/staging/Kconfig                    |   2 +
 drivers/staging/Makefile                   |   2 +-
 drivers/staging/ccree/Kconfig              |  19 +
 drivers/staging/ccree/Makefile             |   2 +
 drivers/staging/ccree/bsp.h                |  21 +
 drivers/staging/ccree/cc_bitops.h          |  62 +++
 drivers/staging/ccree/cc_crypto_ctx.h      | 235 ++++++++++
 drivers/staging/ccree/cc_hal.h             |  35 ++
 drivers/staging/ccree/cc_hw_queue_defs.h   | 603 +++++++++++++++++++++++++
 drivers/staging/ccree/cc_lli_defs.h        |  57 +++
 drivers/staging/ccree/cc_pal_log.h         | 188 ++++++++
 drivers/staging/ccree/cc_pal_log_plat.h    |  33 ++
 drivers/staging/ccree/cc_pal_types.h       |  97 ++++
 drivers/staging/ccree/cc_pal_types_plat.h  |  29 ++
 drivers/staging/ccree/cc_regs.h            | 106 +++++
 drivers/staging/ccree/dx_crys_kernel.h     | 180 ++++++++
 drivers/staging/ccree/dx_env.h             | 224 ++++++++++
 drivers/staging/ccree/dx_host.h            | 155 +++++++
 drivers/staging/ccree/dx_reg_base_host.h   |  34 ++
 drivers/staging/ccree/dx_reg_common.h      |  26 ++
 drivers/staging/ccree/hw_queue_defs_plat.h |  43 ++
 drivers/staging/ccree/ssi_buffer_mgr.c     | 537 +++++++++++++++++++++++
 drivers/staging/ccree/ssi_buffer_mgr.h     |  79 ++++
 drivers/staging/ccree/ssi_config.h         |  61 +++
 drivers/staging/ccree/ssi_driver.c         | 499 +++++++++++++++++++++
 drivers/staging/ccree/ssi_driver.h         | 183 ++++++++
 drivers/staging/ccree/ssi_pm.c             | 144 ++++++
 drivers/staging/ccree/ssi_pm.h             |  46 ++
 drivers/staging/ccree/ssi_pm_ext.c         |  60 +++
 drivers/staging/ccree/ssi_pm_ext.h         |  33 ++
 drivers/staging/ccree/ssi_request_mgr.c    | 680 +++++++++++++++++++++++++++++
 drivers/staging/ccree/ssi_request_mgr.h    |  60 +++
 drivers/staging/ccree/ssi_sram_mgr.c       | 138 ++++++
 drivers/staging/ccree/ssi_sram_mgr.h       |  80 ++++
 drivers/staging/ccree/ssi_sysfs.c          | 440 +++++++++++++++++++
 drivers/staging/ccree/ssi_sysfs.h          |  54 +++
 36 files changed, 5246 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/ccree/Kconfig
 create mode 100644 drivers/staging/ccree/Makefile
 create mode 100644 drivers/staging/ccree/bsp.h
 create mode 100644 drivers/staging/ccree/cc_bitops.h
 create mode 100644 drivers/staging/ccree/cc_crypto_ctx.h
 create mode 100644 drivers/staging/ccree/cc_hal.h
 create mode 100644 drivers/staging/ccree/cc_hw_queue_defs.h
 create mode 100644 drivers/staging/ccree/cc_lli_defs.h
 create mode 100644 drivers/staging/ccree/cc_pal_log.h
 create mode 100644 drivers/staging/ccree/cc_pal_log_plat.h
 create mode 100644 drivers/staging/ccree/cc_pal_types.h
 create mode 100644 drivers/staging/ccree/cc_pal_types_plat.h
 create mode 100644 drivers/staging/ccree/cc_regs.h
 create mode 100644 drivers/staging/ccree/dx_crys_kernel.h
 create mode 100644 drivers/staging/ccree/dx_env.h
 create mode 100644 drivers/staging/ccree/dx_host.h
 create mode 100644 drivers/staging/ccree/dx_reg_base_host.h
 create mode 100644 drivers/staging/ccree/dx_reg_common.h
 create mode 100644 drivers/staging/ccree/hw_queue_defs_plat.h
 create mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
 create mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
 create mode 100644 drivers/staging/ccree/ssi_config.h
 create mode 100644 drivers/staging/ccree/ssi_driver.c
 create mode 100644 drivers/staging/ccree/ssi_driver.h
 create mode 100644 drivers/staging/ccree/ssi_pm.c
 create mode 100644 drivers/staging/ccree/ssi_pm.h
 create mode 100644 drivers/staging/ccree/ssi_pm_ext.c
 create mode 100644 drivers/staging/ccree/ssi_pm_ext.h
 create mode 100644 drivers/staging/ccree/ssi_request_mgr.c
 create mode 100644 drivers/staging/ccree/ssi_request_mgr.h
 create mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
 create mode 100644 drivers/staging/ccree/ssi_sram_mgr.h
 create mode 100644 drivers/staging/ccree/ssi_sysfs.c
 create mode 100644 drivers/staging/ccree/ssi_sysfs.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 4c360f8..79587f5 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -104,4 +104,6 @@ source "drivers/staging/vc04_services/Kconfig"
 
 source "drivers/staging/bcm2835-audio/Kconfig"
 
+source "drivers/staging/ccree/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 29cec5a..a3dcb3e 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -41,4 +41,4 @@ obj-$(CONFIG_KS7010)		+= ks7010/
 obj-$(CONFIG_GREYBUS)		+= greybus/
 obj-$(CONFIG_BCM2835_VCHIQ)	+= vc04_services/
 obj-$(CONFIG_SND_BCM2835)	+= bcm2835-audio/
-
+obj-$(CONFIG_CRYPTO_DEV_CCREE)	+= ccree/
diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
new file mode 100644
index 0000000..0f723d7
--- /dev/null
+++ b/drivers/staging/ccree/Kconfig
@@ -0,0 +1,19 @@
+config CRYPTO_DEV_CCREE
+	tristate "Support for ARM TrustZone CryptoCell C7XX family of Crypto accelerators"
+	depends on CRYPTO_HW && OF && HAS_DMA
+	default n
+	help
+	  Say 'Y' to enable a driver for the Arm TrustZone CryptoCell 
+	  C7xx. Currently only the CryptoCell 712 REE is supported.
+	  Choose this if you wish to use hardware acceleration of
+	  cryptographic operations on the system REE.
+	  If unsure say Y.
+
+config CCREE_DISABLE_COHERENT_DMA_OPS
+	bool "Disable Coherent DMA operations for the CCREE driver"
+	depends on CRYPTO_DEV_CCREE
+	default n
+	help
+	  Say 'Y' to disable the use of coherent DMA operations by the
+	  CCREE driver for debugging purposes.  
+	  If unsure say N.
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
new file mode 100644
index 0000000..972af69
--- /dev/null
+++ b/drivers/staging/ccree/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
+ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
diff --git a/drivers/staging/ccree/bsp.h b/drivers/staging/ccree/bsp.h
new file mode 100644
index 0000000..3dc3ede
--- /dev/null
+++ b/drivers/staging/ccree/bsp.h
@@ -0,0 +1,21 @@
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
+/* Empty file on purpose (required for #include of cc_hw_queue_defs.h) */
+#ifndef __BSP_H__
+#define __BSP_H__
+
+#endif /*__BSP_H__*/
+
diff --git a/drivers/staging/ccree/cc_bitops.h b/drivers/staging/ccree/cc_bitops.h
new file mode 100644
index 0000000..6677f56
--- /dev/null
+++ b/drivers/staging/ccree/cc_bitops.h
@@ -0,0 +1,62 @@
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
+/*!
+ * \file cc_bitops.h
+ * Bit fields operations macros.
+ */
+#ifndef _CC_BITOPS_H_
+#define _CC_BITOPS_H_
+
+#define BITMASK(mask_size) (((mask_size) < 32) ?	\
+	((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
+#define BITMASK_AT(mask_size, mask_offset) (BITMASK(mask_size) << (mask_offset))
+
+#define BITFIELD_GET(word, bit_offset, bit_size) \
+	(((word) >> (bit_offset)) & BITMASK(bit_size))
+#define BITFIELD_SET(word, bit_offset, bit_size, new_val)   do {    \
+	word = ((word) & ~BITMASK_AT(bit_size, bit_offset)) |	    \
+		(((new_val) & BITMASK(bit_size)) << (bit_offset));  \
+} while (0)
+
+/* Is val aligned to "align" ("align" must be power of 2) */
+#ifndef IS_ALIGNED
+#define IS_ALIGNED(val, align)		\
+	(((uintptr_t)(val) & ((align) - 1)) == 0)
+#endif
+
+#define SWAP_ENDIAN(word)		\
+	(((word) >> 24) | (((word) & 0x00FF0000) >> 8) | \
+	(((word) & 0x0000FF00) << 8) | (((word) & 0x000000FF) << 24))
+
+#ifdef BIG__ENDIAN
+#define SWAP_TO_LE(word) SWAP_ENDIAN(word)
+#define SWAP_TO_BE(word) word
+#else
+#define SWAP_TO_LE(word) word
+#define SWAP_TO_BE(word) SWAP_ENDIAN(word)
+#endif
+
+
+
+/* Is val a multiple of "mult" ("mult" must be power of 2) */
+#define IS_MULT(val, mult)              \
+	(((val) & ((mult) - 1)) == 0)
+
+#define IS_NULL_ADDR(adr)		\
+	(!(adr))
+
+#endif /*_CC_BITOPS_H_*/
diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
new file mode 100644
index 0000000..8b8aea2
--- /dev/null
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -0,0 +1,235 @@
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
+#ifndef _CC_CRYPTO_CTX_H_
+#define _CC_CRYPTO_CTX_H_
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#define INT32_MAX 0x7FFFFFFFL
+#else
+#include <stdint.h>
+#endif
+
+
+#ifndef max
+#define max(a, b) ((a) > (b) ? (a) : (b))
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#endif
+
+/* context size */
+#ifndef CC_CTX_SIZE_LOG2
+#if (CC_SUPPORT_SHA > 256)
+#define CC_CTX_SIZE_LOG2 8
+#else
+#define CC_CTX_SIZE_LOG2 7
+#endif
+#endif
+#define CC_CTX_SIZE (1<<CC_CTX_SIZE_LOG2)
+#define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
+
+#define CC_DRV_DES_IV_SIZE 8
+#define CC_DRV_DES_BLOCK_SIZE 8
+
+#define CC_DRV_DES_ONE_KEY_SIZE 8
+#define CC_DRV_DES_DOUBLE_KEY_SIZE 16
+#define CC_DRV_DES_TRIPLE_KEY_SIZE 24
+#define CC_DRV_DES_KEY_SIZE_MAX CC_DRV_DES_TRIPLE_KEY_SIZE
+
+#define CC_AES_IV_SIZE 16
+#define CC_AES_IV_SIZE_WORDS (CC_AES_IV_SIZE >> 2)
+
+#define CC_AES_BLOCK_SIZE 16
+#define CC_AES_BLOCK_SIZE_WORDS 4
+
+#define CC_AES_128_BIT_KEY_SIZE 16
+#define CC_AES_128_BIT_KEY_SIZE_WORDS	(CC_AES_128_BIT_KEY_SIZE >> 2)
+#define CC_AES_192_BIT_KEY_SIZE 24
+#define CC_AES_192_BIT_KEY_SIZE_WORDS	(CC_AES_192_BIT_KEY_SIZE >> 2)
+#define CC_AES_256_BIT_KEY_SIZE 32
+#define CC_AES_256_BIT_KEY_SIZE_WORDS	(CC_AES_256_BIT_KEY_SIZE >> 2)
+#define CC_AES_KEY_SIZE_MAX			CC_AES_256_BIT_KEY_SIZE
+#define CC_AES_KEY_SIZE_WORDS_MAX		(CC_AES_KEY_SIZE_MAX >> 2)
+
+#define CC_MD5_DIGEST_SIZE 	16
+#define CC_SHA1_DIGEST_SIZE 	20
+#define CC_SHA224_DIGEST_SIZE 	28
+#define CC_SHA256_DIGEST_SIZE 	32
+#define CC_SHA256_DIGEST_SIZE_IN_WORDS 8
+#define CC_SHA384_DIGEST_SIZE 	48
+#define CC_SHA512_DIGEST_SIZE 	64
+
+#define CC_SHA1_BLOCK_SIZE 64
+#define CC_SHA1_BLOCK_SIZE_IN_WORDS 16
+#define CC_MD5_BLOCK_SIZE 64
+#define CC_MD5_BLOCK_SIZE_IN_WORDS 16
+#define CC_SHA224_BLOCK_SIZE 64
+#define CC_SHA256_BLOCK_SIZE 64
+#define CC_SHA256_BLOCK_SIZE_IN_WORDS 16
+#define CC_SHA1_224_256_BLOCK_SIZE 64
+#define CC_SHA384_BLOCK_SIZE 128
+#define CC_SHA512_BLOCK_SIZE 128
+
+#if (CC_SUPPORT_SHA > 256)
+#define CC_DIGEST_SIZE_MAX CC_SHA512_DIGEST_SIZE
+#define CC_HASH_BLOCK_SIZE_MAX CC_SHA512_BLOCK_SIZE /*1024b*/
+#else /* Only up to SHA256 */
+#define CC_DIGEST_SIZE_MAX CC_SHA256_DIGEST_SIZE
+#define CC_HASH_BLOCK_SIZE_MAX CC_SHA256_BLOCK_SIZE /*512b*/
+#endif
+
+#define CC_HMAC_BLOCK_SIZE_MAX CC_HASH_BLOCK_SIZE_MAX
+
+#define CC_MULTI2_SYSTEM_KEY_SIZE 		32
+#define CC_MULTI2_DATA_KEY_SIZE 		8
+#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE 	(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
+#define	CC_MULTI2_BLOCK_SIZE					8
+#define	CC_MULTI2_IV_SIZE					8
+#define	CC_MULTI2_MIN_NUM_ROUNDS				8
+#define	CC_MULTI2_MAX_NUM_ROUNDS				128
+
+
+#define CC_DRV_ALG_MAX_BLOCK_SIZE CC_HASH_BLOCK_SIZE_MAX
+
+
+enum drv_engine_type {
+	DRV_ENGINE_NULL = 0,
+	DRV_ENGINE_AES = 1,
+	DRV_ENGINE_DES = 2,
+	DRV_ENGINE_HASH = 3,
+	DRV_ENGINE_RC4 = 4,
+	DRV_ENGINE_DOUT = 5,
+	DRV_ENGINE_RESERVE32B = INT32_MAX,
+};
+
+enum drv_crypto_alg {
+	DRV_CRYPTO_ALG_NULL = -1,
+	DRV_CRYPTO_ALG_AES  = 0,
+	DRV_CRYPTO_ALG_DES  = 1,
+	DRV_CRYPTO_ALG_HASH = 2,
+	DRV_CRYPTO_ALG_C2   = 3,
+	DRV_CRYPTO_ALG_HMAC = 4,
+	DRV_CRYPTO_ALG_AEAD = 5,
+	DRV_CRYPTO_ALG_BYPASS = 6,
+	DRV_CRYPTO_ALG_NUM = 7,
+	DRV_CRYPTO_ALG_RESERVE32B = INT32_MAX
+};
+
+enum drv_crypto_direction {
+	DRV_CRYPTO_DIRECTION_NULL = -1,
+	DRV_CRYPTO_DIRECTION_ENCRYPT = 0,
+	DRV_CRYPTO_DIRECTION_DECRYPT = 1,
+	DRV_CRYPTO_DIRECTION_DECRYPT_ENCRYPT = 3,
+	DRV_CRYPTO_DIRECTION_RESERVE32B = INT32_MAX
+};
+
+enum drv_cipher_mode {
+	DRV_CIPHER_NULL_MODE = -1,
+	DRV_CIPHER_ECB = 0,
+	DRV_CIPHER_CBC = 1,
+	DRV_CIPHER_CTR = 2,
+	DRV_CIPHER_CBC_MAC = 3,
+	DRV_CIPHER_XTS = 4,
+	DRV_CIPHER_XCBC_MAC = 5,
+	DRV_CIPHER_OFB = 6,
+	DRV_CIPHER_CMAC = 7,
+	DRV_CIPHER_CCM = 8,
+	DRV_CIPHER_CBC_CTS = 11,
+	DRV_CIPHER_GCTR = 12,
+	DRV_CIPHER_ESSIV = 13,
+	DRV_CIPHER_BITLOCKER = 14,
+	DRV_CIPHER_RESERVE32B = INT32_MAX
+};
+
+enum drv_hash_mode {
+	DRV_HASH_NULL = -1,
+	DRV_HASH_SHA1 = 0,
+	DRV_HASH_SHA256 = 1,
+	DRV_HASH_SHA224 = 2,
+	DRV_HASH_SHA512 = 3,
+	DRV_HASH_SHA384 = 4,
+	DRV_HASH_MD5 = 5,
+	DRV_HASH_CBC_MAC = 6, 
+	DRV_HASH_XCBC_MAC = 7,
+	DRV_HASH_CMAC = 8,
+	DRV_HASH_MODE_NUM = 9,
+	DRV_HASH_RESERVE32B = INT32_MAX
+};
+
+enum drv_hash_hw_mode {
+	DRV_HASH_HW_MD5 = 0,
+	DRV_HASH_HW_SHA1 = 1,
+	DRV_HASH_HW_SHA256 = 2,
+	DRV_HASH_HW_SHA224 = 10,
+	DRV_HASH_HW_SHA512 = 4,
+	DRV_HASH_HW_SHA384 = 12,
+	DRV_HASH_HW_GHASH = 6,
+	DRV_HASH_HW_RESERVE32B = INT32_MAX
+};
+
+enum drv_multi2_mode {
+	DRV_MULTI2_NULL = -1,
+	DRV_MULTI2_ECB = 0,
+	DRV_MULTI2_CBC = 1,
+	DRV_MULTI2_OFB = 2,
+	DRV_MULTI2_RESERVE32B = INT32_MAX
+};
+
+
+/* drv_crypto_key_type[1:0] is mapped to cipher_do[1:0] */
+/* drv_crypto_key_type[2] is mapped to cipher_config2 */
+enum drv_crypto_key_type {
+	DRV_NULL_KEY = -1,
+	DRV_USER_KEY = 0,		/* 0x000 */
+	DRV_ROOT_KEY = 1,		/* 0x001 */
+	DRV_PROVISIONING_KEY = 2,	/* 0x010 */
+	DRV_SESSION_KEY = 3,		/* 0x011 */
+	DRV_APPLET_KEY = 4,		/* NA */
+	DRV_PLATFORM_KEY = 5,		/* 0x101 */
+	DRV_CUSTOMER_KEY = 6,		/* 0x110 */
+	DRV_END_OF_KEYS = INT32_MAX,
+};
+
+enum drv_crypto_padding_type {
+	DRV_PADDING_NONE = 0,
+	DRV_PADDING_PKCS7 = 1,
+	DRV_PADDING_RESERVE32B = INT32_MAX
+};
+
+/*******************************************************************/
+/***************** DESCRIPTOR BASED CONTEXTS ***********************/
+/*******************************************************************/
+
+ /* Generic context ("super-class") */
+struct drv_ctx_generic {
+	enum drv_crypto_alg alg;
+} __attribute__((__may_alias__));
+
+
+/*******************************************************************/
+/***************** MESSAGE BASED CONTEXTS **************************/
+/*******************************************************************/
+
+
+/* Get the address of a @member within a given @ctx address
+   @ctx: The context address
+   @type: Type of context structure
+   @member: Associated context field */
+#define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))
+
+#endif /* _CC_CRYPTO_CTX_H_ */
+
diff --git a/drivers/staging/ccree/cc_hal.h b/drivers/staging/ccree/cc_hal.h
new file mode 100644
index 0000000..48e122b
--- /dev/null
+++ b/drivers/staging/ccree/cc_hal.h
@@ -0,0 +1,35 @@
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
+/* pseudo cc_hal.h for cc7x_perf_test_driver (to be able to include code from CC drivers) */
+
+#ifndef __CC_HAL_H__
+#define __CC_HAL_H__
+
+#include <linux/io.h>
+
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+/* CC registers are always 32 bit wide (even on 64 bit platforms) */
+#define READ_REGISTER(_addr) ioread32((_addr))
+#define WRITE_REGISTER(_addr, _data)  iowrite32((_data), (_addr))
+#else
+#error Unsupported platform
+#endif
+
+#define CC_HAL_WRITE_REGISTER(offset, val) WRITE_REGISTER(cc_base + offset, val)
+#define CC_HAL_READ_REGISTER(offset) READ_REGISTER(cc_base + offset)
+
+#endif
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
new file mode 100644
index 0000000..201dbb7
--- /dev/null
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -0,0 +1,603 @@
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
+#ifndef __CC_HW_QUEUE_DEFS_H__
+#define __CC_HW_QUEUE_DEFS_H__
+
+#include "cc_pal_log.h"
+#include "cc_regs.h"
+#include "dx_crys_kernel.h"
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#define UINT32_MAX 0xFFFFFFFFL
+#define INT32_MAX  0x7FFFFFFFL
+#define UINT16_MAX 0xFFFFL
+#else
+#include <stdint.h>
+#endif
+
+/******************************************************************************
+*                        	DEFINITIONS
+******************************************************************************/
+
+
+/* Dma AXI Secure bit */
+#define	AXI_SECURE	0
+#define AXI_NOT_SECURE	1
+
+#define HW_DESC_SIZE_WORDS		6
+#define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
+
+#define _HW_DESC_MONITOR_KICK 0x7FFFC00
+
+/******************************************************************************
+*				TYPE DEFINITIONS
+******************************************************************************/
+
+typedef struct HwDesc {
+	uint32_t word[HW_DESC_SIZE_WORDS];
+} HwDesc_s;
+
+typedef enum DescDirection {
+	DESC_DIRECTION_ILLEGAL = -1,
+	DESC_DIRECTION_ENCRYPT_ENCRYPT = 0,
+	DESC_DIRECTION_DECRYPT_DECRYPT = 1,
+	DESC_DIRECTION_DECRYPT_ENCRYPT = 3,
+	DESC_DIRECTION_END = INT32_MAX,
+}DescDirection_t;
+
+typedef enum DmaMode {
+	DMA_MODE_NULL		= -1,
+	NO_DMA 			= 0,
+	DMA_SRAM		= 1,
+	DMA_DLLI		= 2,
+	DMA_MLLI		= 3,
+	DmaMode_OPTIONTS,
+	DmaMode_END 		= INT32_MAX,
+}DmaMode_t;
+
+typedef enum FlowMode {
+	FLOW_MODE_NULL		= -1,
+	/* data flows */
+ 	BYPASS			= 0,
+	DIN_AES_DOUT		= 1,
+	AES_to_HASH		= 2,
+	AES_and_HASH		= 3,
+	DIN_DES_DOUT		= 4,
+	DES_to_HASH		= 5,
+	DES_and_HASH		= 6,
+	DIN_HASH		= 7,
+	DIN_HASH_and_BYPASS	= 8,
+	AESMAC_and_BYPASS	= 9,
+	AES_to_HASH_and_DOUT	= 10,
+	DIN_RC4_DOUT		= 11,
+	DES_to_HASH_and_DOUT	= 12,
+	AES_to_AES_to_HASH_and_DOUT	= 13,
+	AES_to_AES_to_HASH	= 14,
+	AES_to_HASH_and_AES	= 15,
+	DIN_MULTI2_DOUT		= 16,
+	DIN_AES_AESMAC		= 17,
+	HASH_to_DOUT		= 18,
+	/* setup flows */
+ 	S_DIN_to_AES 		= 32,
+	S_DIN_to_AES2		= 33,
+	S_DIN_to_DES		= 34,
+	S_DIN_to_RC4		= 35,
+ 	S_DIN_to_MULTI2		= 36,
+	S_DIN_to_HASH		= 37,
+	S_AES_to_DOUT		= 38,
+	S_AES2_to_DOUT		= 39,
+	S_RC4_to_DOUT		= 41,
+	S_DES_to_DOUT		= 42,
+	S_HASH_to_DOUT		= 43,
+	SET_FLOW_ID		= 44,
+	FlowMode_OPTIONTS,
+	FlowMode_END = INT32_MAX,
+}FlowMode_t;
+
+typedef enum TunnelOp {
+	TUNNEL_OP_INVALID = -1,
+	TUNNEL_OFF = 0,
+	TUNNEL_ON = 1,
+	TunnelOp_OPTIONS,
+	TunnelOp_END = INT32_MAX,
+} TunnelOp_t;
+
+typedef enum SetupOp {
+	SETUP_LOAD_NOP		= 0,
+	SETUP_LOAD_STATE0	= 1,
+	SETUP_LOAD_STATE1	= 2,
+	SETUP_LOAD_STATE2	= 3,
+	SETUP_LOAD_KEY0		= 4,
+	SETUP_LOAD_XEX_KEY	= 5,
+	SETUP_WRITE_STATE0	= 8, 
+	SETUP_WRITE_STATE1	= 9,
+	SETUP_WRITE_STATE2	= 10,
+	SETUP_WRITE_STATE3	= 11,
+	setupOp_OPTIONTS,
+	setupOp_END = INT32_MAX,	
+}SetupOp_t;
+
+enum AesMacSelector {
+	AES_SK = 1,
+	AES_CMAC_INIT = 2,
+	AES_CMAC_SIZE0 = 3,
+	AesMacEnd = INT32_MAX,
+};
+
+#define HW_KEY_MASK_CIPHER_DO 	  0x3
+#define HW_KEY_SHIFT_CIPHER_CFG2  2
+
+
+/* HwCryptoKey[1:0] is mapped to cipher_do[1:0] */
+/* HwCryptoKey[2:3] is mapped to cipher_config2[1:0] */
+typedef enum HwCryptoKey {
+	USER_KEY = 0,			/* 0x0000 */
+	ROOT_KEY = 1,			/* 0x0001 */
+	PROVISIONING_KEY = 2,		/* 0x0010 */ /* ==KCP */
+	SESSION_KEY = 3,		/* 0x0011 */
+	RESERVED_KEY = 4,		/* NA */
+	PLATFORM_KEY = 5,		/* 0x0101 */
+	CUSTOMER_KEY = 6,		/* 0x0110 */
+	KFDE0_KEY = 7,			/* 0x0111 */
+	KFDE1_KEY = 9,			/* 0x1001 */
+	KFDE2_KEY = 10,			/* 0x1010 */
+	KFDE3_KEY = 11,			/* 0x1011 */
+	END_OF_KEYS = INT32_MAX,
+}HwCryptoKey_t;
+
+typedef enum HwAesKeySize {
+	AES_128_KEY = 0,
+	AES_192_KEY = 1,
+	AES_256_KEY = 2,
+	END_OF_AES_KEYS = INT32_MAX,
+}HwAesKeySize_t;
+
+typedef enum HwDesKeySize {
+	DES_ONE_KEY = 0,
+	DES_TWO_KEYS = 1,
+	DES_THREE_KEYS = 2,
+	END_OF_DES_KEYS = INT32_MAX,
+}HwDesKeySize_t;
+
+/*****************************/
+/* Descriptor packing macros */
+/*****************************/
+
+#define GET_HW_Q_DESC_WORD_IDX(descWordIdx) (CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD ## descWordIdx) )
+
+#define HW_DESC_INIT(pDesc)  do { \
+	(pDesc)->word[0] = 0;     \
+	(pDesc)->word[1] = 0;     \
+	(pDesc)->word[2] = 0;     \
+	(pDesc)->word[3] = 0;     \
+	(pDesc)->word[4] = 0;     \
+	(pDesc)->word[5] = 0;     \
+} while (0)
+
+/* HW descriptor debug functions */
+int createDetailedDump(HwDesc_s *pDesc);
+void descriptor_log(HwDesc_s *desc);
+
+#if defined(HW_DESCRIPTOR_LOG) || defined(HW_DESC_DUMP_HOST_BUF)
+#define LOG_HW_DESC(pDesc) descriptor_log(pDesc)
+#else
+#define LOG_HW_DESC(pDesc) 
+#endif
+
+#if (CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_TRACE) || defined(OEMFW_LOG)
+
+#ifdef UART_PRINTF
+#define CREATE_DETAILED_DUMP(pDesc) createDetailedDump(pDesc)
+#else
+#define CREATE_DETAILED_DUMP(pDesc) 
+#endif 
+
+#define HW_DESC_DUMP(pDesc) do {            			\
+	CC_PAL_LOG_TRACE("\n---------------------------------------------------\n");	\
+	CREATE_DETAILED_DUMP(pDesc); 				\
+	CC_PAL_LOG_TRACE("0x%08X, ", (unsigned int)(pDesc)->word[0]);  	\
+	CC_PAL_LOG_TRACE("0x%08X, ", (unsigned int)(pDesc)->word[1]);  	\
+	CC_PAL_LOG_TRACE("0x%08X, ", (unsigned int)(pDesc)->word[2]);  	\
+	CC_PAL_LOG_TRACE("0x%08X, ", (unsigned int)(pDesc)->word[3]);  	\
+	CC_PAL_LOG_TRACE("0x%08X, ", (unsigned int)(pDesc)->word[4]);  	\
+	CC_PAL_LOG_TRACE("0x%08X\n", (unsigned int)(pDesc)->word[5]);  	\
+	CC_PAL_LOG_TRACE("---------------------------------------------------\n\n");    \
+} while (0)
+
+#else
+#define HW_DESC_DUMP(pDesc) do {} while (0)
+#endif
+
+
+/*!
+ * This macro indicates the end of current HW descriptors flow and release the HW engines.
+ * 
+ * \param pDesc pointer HW descriptor struct
+ */
+#define HW_DESC_SET_QUEUE_LAST_IND(pDesc) 								\
+	do {												\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, QUEUE_LAST_IND, (pDesc)->word[3], 1);	\
+	} while (0)
+
+/*!
+ * This macro signs the end of HW descriptors flow by asking for completion ack, and release the HW engines
+ * 
+ * \param pDesc pointer HW descriptor struct 
+ */
+#define HW_DESC_SET_ACK_LAST(pDesc) 									\
+	do {												\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, QUEUE_LAST_IND, (pDesc)->word[3], 1);	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, ACK_NEEDED, (pDesc)->word[4], 1);	\
+	} while (0)
+
+
+#define MSB64(_addr) (sizeof(_addr) == 4 ? 0 : ((_addr) >> 32)&UINT16_MAX)
+
+/*!
+ * This macro sets the DIN field of a HW descriptors
+ * 
+ * \param pDesc pointer HW descriptor struct 
+ * \param dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
+ * \param dinAdr DIN address
+ * \param dinSize Data size in bytes 
+ * \param axiNs AXI secure bit
+ */
+#define HW_DESC_SET_DIN_TYPE(pDesc, dmaMode, dinAdr, dinSize, axiNs)								\
+	do {		                                                                                        		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (dinAdr)&UINT32_MAX );			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DIN_ADDR_HIGH, (pDesc)->word[5], MSB64(dinAdr) );		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_DMA_MODE, (pDesc)->word[1], (dmaMode));			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));				\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, NS_BIT, (pDesc)->word[1], (axiNs));				\
+	} while (0)
+
+
+/*!
+ * This macro sets the DIN field of a HW descriptors to NO DMA mode. Used for NOP descriptor, register patches and 
+ * other special modes 
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param dinAdr DIN address
+ * \param dinSize Data size in bytes 
+ */
+#define HW_DESC_SET_DIN_NO_DMA(pDesc, dinAdr, dinSize)									\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (uint32_t)(dinAdr));		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));			\
+	} while (0)
+
+/*!
+ * This macro sets the DIN field of a HW descriptors to SRAM mode. 
+ * Note: No need to check SRAM alignment since host requests do not use SRAM and 
+ * adaptor will enforce alignment check. 
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param dinAdr DIN address
+ * \param dinSize Data size in bytes 
+ */
+#define HW_DESC_SET_DIN_SRAM(pDesc, dinAdr, dinSize)									\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (uint32_t)(dinAdr));		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_DMA_MODE, (pDesc)->word[1], DMA_SRAM);		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));			\
+	} while (0)
+
+/*! This macro sets the DIN field of a HW descriptors to CONST mode 
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param val DIN const value
+ * \param dinSize Data size in bytes 
+ */
+#define HW_DESC_SET_DIN_CONST(pDesc, val, dinSize)									\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (uint32_t)(val));		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_CONST_VALUE, (pDesc)->word[1], 1);			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_DMA_MODE, (pDesc)->word[1], DMA_SRAM);		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));			\
+	} while (0)
+
+/*!
+ * This macro sets the DIN not last input data indicator
+ * 
+ * \param pDesc pointer HW descriptor struct
+ */
+#define HW_DESC_SET_DIN_NOT_LAST_INDICATION(pDesc)									\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, NOT_LAST, (pDesc)->word[1], 1);				\
+	} while (0)
+
+/*!
+ * This macro sets the DOUT field of a HW descriptors 
+ * 
+ * \param pDesc pointer HW descriptor struct 
+ * \param dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
+ * \param doutAdr DOUT address
+ * \param doutSize Data size in bytes 
+ * \param axiNs AXI secure bit
+ */
+#define HW_DESC_SET_DOUT_TYPE(pDesc, dmaMode, doutAdr, doutSize, axiNs)							\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (doutAdr)&UINT32_MAX );		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DOUT_ADDR_HIGH, (pDesc)->word[5], MSB64(doutAdr) );	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], (dmaMode));		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, NS_BIT, (pDesc)->word[3], (axiNs));			\
+	} while (0)
+
+/*!
+ * This macro sets the DOUT field of a HW descriptors to DLLI type 
+ * The LAST INDICATION is provided by the user 
+ * 
+ * \param pDesc pointer HW descriptor struct 
+ * \param doutAdr DOUT address
+ * \param doutSize Data size in bytes 
+ * \param lastInd The last indication bit
+ * \param axiNs AXI secure bit 
+ */
+#define HW_DESC_SET_DOUT_DLLI(pDesc, doutAdr, doutSize, axiNs ,lastInd)								\
+	do {		                                                                                        		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (doutAdr)&UINT32_MAX );		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DOUT_ADDR_HIGH, (pDesc)->word[5], MSB64(doutAdr) );	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], DMA_DLLI);			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_LAST_IND, (pDesc)->word[3], lastInd);			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, NS_BIT, (pDesc)->word[3], (axiNs));				\
+	} while (0)
+
+/*!
+ * This macro sets the DOUT field of a HW descriptors to DLLI type 
+ * The LAST INDICATION is provided by the user 
+ * 
+ * \param pDesc pointer HW descriptor struct 
+ * \param doutAdr DOUT address
+ * \param doutSize Data size in bytes 
+ * \param lastInd The last indication bit
+ * \param axiNs AXI secure bit 
+ */
+#define HW_DESC_SET_DOUT_MLLI(pDesc, doutAdr, doutSize, axiNs ,lastInd)								\
+	do {		                                                                                        		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (doutAdr)&UINT32_MAX );		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DOUT_ADDR_HIGH, (pDesc)->word[5], MSB64(doutAdr) );	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], DMA_MLLI);			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_LAST_IND, (pDesc)->word[3], lastInd);			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, NS_BIT, (pDesc)->word[3], (axiNs));				\
+	} while (0)
+
+/*!
+ * This macro sets the DOUT field of a HW descriptors to NO DMA mode. Used for NOP descriptor, register patches and 
+ * other special modes 
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param doutAdr DOUT address
+ * \param doutSize Data size in bytes  
+ * \param registerWriteEnable Enables a write operation to a register
+ */
+#define HW_DESC_SET_DOUT_NO_DMA(pDesc, doutAdr, doutSize, registerWriteEnable)							\
+	do {		                                                                                        		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (uint32_t)(doutAdr));			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));			\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_LAST_IND, (pDesc)->word[3], (registerWriteEnable));	\
+	} while (0)
+
+/*!
+ * This macro sets the word for the XOR operation. 
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param xorVal xor data value
+ */
+#define HW_DESC_SET_XOR_VAL(pDesc, xorVal)										\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (uint32_t)(xorVal));		\
+	} while (0)
+
+/*!
+ * This macro sets the XOR indicator bit in the descriptor
+ * 
+ * \param pDesc pointer HW descriptor struct
+ */
+#define HW_DESC_SET_XOR_ACTIVE(pDesc)											\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, HASH_XOR_BIT, (pDesc)->word[3], 1);			\
+	} while (0)
+
+/*!
+ * This macro selects the AES engine instead of HASH engine when setting up combined mode with AES XCBC MAC
+ * 
+ * \param pDesc pointer HW descriptor struct
+ */
+#define HW_DESC_SET_AES_NOT_HASH_MODE(pDesc)										\
+	do {		                                                                                       	 	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, AES_SEL_N_HASH, (pDesc)->word[4], 1);			\
+	} while (0)
+
+/*!
+ * This macro sets the DOUT field of a HW descriptors to SRAM mode
+ * Note: No need to check SRAM alignment since host requests do not use SRAM and 
+ * adaptor will enforce alignment check. 
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param doutAdr DOUT address
+ * \param doutSize Data size in bytes 
+ */
+#define HW_DESC_SET_DOUT_SRAM(pDesc, doutAdr, doutSize)									\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (uint32_t)(doutAdr));		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], DMA_SRAM);		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));		\
+	} while (0)
+
+
+/*!
+ * This macro sets the data unit size for XEX mode in data_out_addr[15:0]
+ * 
+ * \param pDesc pointer HW descriptor struct
+ * \param dataUnitSize data unit size for XEX mode
+ */
+#define HW_DESC_SET_XEX_DATA_UNIT_SIZE(pDesc, dataUnitSize)								\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (uint32_t)(dataUnitSize));	\
+	} while (0)
+
+/*!
+ * This macro sets the number of rounds for Multi2 in data_out_addr[15:0]
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param numRounds number of rounds for Multi2
+*/
+#define HW_DESC_SET_MULTI2_NUM_ROUNDS(pDesc, numRounds)									\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (uint32_t)(numRounds));	\
+	} while (0)
+
+/*!
+ * This macro sets the flow mode.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param flowMode Any one of the modes defined in [CC7x-DESC]
+*/
+
+#define HW_DESC_SET_FLOW_MODE(pDesc, flowMode)										\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, DATA_FLOW_MODE, (pDesc)->word[4], (flowMode));		\
+	} while (0)
+
+/*!
+ * This macro sets the cipher mode.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param cipherMode Any one of the modes defined in [CC7x-DESC]
+*/
+#define HW_DESC_SET_CIPHER_MODE(pDesc, cipherMode)									\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_MODE, (pDesc)->word[4], (cipherMode));		\
+	} while (0)
+
+/*!
+ * This macro sets the cipher configuration fields.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param cipherConfig Any one of the modes defined in [CC7x-DESC]
+*/
+#define HW_DESC_SET_CIPHER_CONFIG0(pDesc, cipherConfig)									\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF0, (pDesc)->word[4], (cipherConfig));	\
+	} while (0)
+
+/*!
+ * This macro sets the cipher configuration fields.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param cipherConfig Any one of the modes defined in [CC7x-DESC]
+*/
+#define HW_DESC_SET_CIPHER_CONFIG1(pDesc, cipherConfig)									\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF1, (pDesc)->word[4], (cipherConfig));	\
+	} while (0)
+
+/*!
+ * This macro sets HW key configuration fields.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param hwKey The hw key number as in enun HwCryptoKey
+*/
+#define HW_DESC_SET_HW_CRYPTO_KEY(pDesc, hwKey)										\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_DO, (pDesc)->word[4], (hwKey)&HW_KEY_MASK_CIPHER_DO);		\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF2, (pDesc)->word[4], (hwKey>>HW_KEY_SHIFT_CIPHER_CFG2));	\
+	} while (0)
+
+/*!
+ * This macro changes the bytes order of all setup-finalize descriptosets.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param swapConfig Any one of the modes defined in [CC7x-DESC]
+*/
+#define HW_DESC_SET_BYTES_SWAP(pDesc, swapConfig)									\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, BYTES_SWAP, (pDesc)->word[4], (swapConfig));		\
+	} while (0)
+
+/*!
+ * This macro sets the CMAC_SIZE0 mode.
+ *
+ * \param pDesc pointer HW descriptor struct
+*/
+#define HW_DESC_SET_CMAC_SIZE0_MODE(pDesc)										\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CMAC_SIZE0, (pDesc)->word[4], 0x1);			\
+	} while (0)
+
+/*!
+ * This macro sets the key size for AES engine.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param keySize key size in bytes (NOT size code)
+*/
+#define HW_DESC_SET_KEY_SIZE_AES(pDesc, keySize)									\
+	do {													        \
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, KEY_SIZE, (pDesc)->word[4], ((keySize) >> 3) - 2);	\
+	} while (0)
+
+/*!
+ * This macro sets the key size for DES engine.
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param keySize key size in bytes (NOT size code)
+*/
+#define HW_DESC_SET_KEY_SIZE_DES(pDesc, keySize)									\
+	do {													        \
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, KEY_SIZE, (pDesc)->word[4], ((keySize) >> 3) - 1);	\
+	} while (0)
+
+/*!
+ * This macro sets the descriptor's setup mode
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param setupMode Any one of the setup modes defined in [CC7x-DESC]
+*/
+#define HW_DESC_SET_SETUP_MODE(pDesc, setupMode)									\
+	do {														\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, SETUP_OPERATION, (pDesc)->word[4], (setupMode));	\
+	} while (0)
+
+/*!
+ * This macro sets the descriptor's cipher do
+ *
+ * \param pDesc pointer HW descriptor struct
+ * \param cipherDo Any one of the cipher do defined in [CC7x-DESC]
+*/
+#define HW_DESC_SET_CIPHER_DO(pDesc, cipherDo)											\
+	do {															\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_DO, (pDesc)->word[4], (cipherDo)&HW_KEY_MASK_CIPHER_DO);	\
+	} while (0)
+
+/*!
+ * This macro sets the DIN field of a HW descriptors to star/stop monitor descriptor. 
+ * Used for performance measurements and debug purposes.
+ * 
+ * \param pDesc pointer HW descriptor struct
+ */
+#define HW_DESC_SET_DIN_MONITOR_CNTR(pDesc)										\
+	do {		                                                                                        	\
+		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_MEASURE_CNTR, VALUE, (pDesc)->word[1], _HW_DESC_MONITOR_KICK);	\
+	} while (0)
+
+
+
+#endif /*__CC_HW_QUEUE_DEFS_H__*/
diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
new file mode 100644
index 0000000..a12cb6d
--- /dev/null
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -0,0 +1,57 @@
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
+#ifndef _CC_LLI_DEFS_H_
+#define _CC_LLI_DEFS_H_
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+#include "cc_bitops.h"
+
+/* Max DLLI size */
+#define DLLI_SIZE_BIT_SIZE	0x18	// DX_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE
+
+#define CC_MAX_MLLI_ENTRY_SIZE 0x10000
+
+#define MSB64(_addr) (sizeof(_addr) == 4 ? 0 : ((_addr) >> 32)&UINT16_MAX)
+
+#define LLI_SET_ADDR(lli_p, addr) \
+		BITFIELD_SET(((uint32_t *)(lli_p))[LLI_WORD0_OFFSET], LLI_LADDR_BIT_OFFSET, LLI_LADDR_BIT_SIZE, (addr & UINT32_MAX)); \
+		BITFIELD_SET(((uint32_t *)(lli_p))[LLI_WORD1_OFFSET], LLI_HADDR_BIT_OFFSET, LLI_HADDR_BIT_SIZE, MSB64(addr));
+
+#define LLI_SET_SIZE(lli_p, size) \
+		BITFIELD_SET(((uint32_t *)(lli_p))[LLI_WORD1_OFFSET], LLI_SIZE_BIT_OFFSET, LLI_SIZE_BIT_SIZE, size)
+
+/* Size of entry */
+#define LLI_ENTRY_WORD_SIZE 2
+#define LLI_ENTRY_BYTE_SIZE (LLI_ENTRY_WORD_SIZE * sizeof(uint32_t))
+
+/* Word0[31:0] = ADDR[31:0] */
+#define LLI_WORD0_OFFSET 0
+#define LLI_LADDR_BIT_OFFSET 0
+#define LLI_LADDR_BIT_SIZE 32
+/* Word1[31:16] = ADDR[47:32]; Word1[15:0] = SIZE */
+#define LLI_WORD1_OFFSET 1
+#define LLI_SIZE_BIT_OFFSET 0
+#define LLI_SIZE_BIT_SIZE 16
+#define LLI_HADDR_BIT_OFFSET 16
+#define LLI_HADDR_BIT_SIZE 16
+
+
+#endif /*_CC_LLI_DEFS_H_*/
diff --git a/drivers/staging/ccree/cc_pal_log.h b/drivers/staging/ccree/cc_pal_log.h
new file mode 100644
index 0000000..21b7f2e
--- /dev/null
+++ b/drivers/staging/ccree/cc_pal_log.h
@@ -0,0 +1,188 @@
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
+#ifndef _CC_PAL_LOG_H_
+#define _CC_PAL_LOG_H_
+
+#include "cc_pal_types.h"
+#include "cc_pal_log_plat.h"
+
+/*!
+@file 
+@brief This file contains the PAL layer log definitions, by default the log is disabled. 
+@defgroup cc_pal_log CryptoCell PAL logging APIs and definitions
+@{
+@ingroup cc_pal
+*/
+
+/* PAL log levels (to be used in CC_PAL_logLevel) */
+/*! PAL log level - disabled. */
+#define CC_PAL_LOG_LEVEL_NULL      (-1) /*!< \internal Disable logging */
+/*! PAL log level - error. */
+#define CC_PAL_LOG_LEVEL_ERR       0
+/*! PAL log level - warning. */
+#define CC_PAL_LOG_LEVEL_WARN      1
+/*! PAL log level - info. */
+#define CC_PAL_LOG_LEVEL_INFO      2
+/*! PAL log level - debug. */
+#define CC_PAL_LOG_LEVEL_DEBUG     3
+/*! PAL log level - trace. */
+#define CC_PAL_LOG_LEVEL_TRACE     4
+/*! PAL log level - data. */
+#define CC_PAL_LOG_LEVEL_DATA      5
+
+#ifndef CC_PAL_LOG_CUR_COMPONENT
+/* Setting default component mask in case caller did not define */
+/* (a mask that is always on for every log mask value but full masking) */
+/*! Default log debugged component.*/
+#define CC_PAL_LOG_CUR_COMPONENT 0xFFFFFFFF
+#endif
+#ifndef CC_PAL_LOG_CUR_COMPONENT_NAME
+/*! Default log debugged component.*/
+#define CC_PAL_LOG_CUR_COMPONENT_NAME "CC"
+#endif
+
+/* Select compile time log level (default if not explicitly specified by caller) */
+#ifndef CC_PAL_MAX_LOG_LEVEL /* Can be overriden by external definition of this constant */
+#ifdef DEBUG
+/*! Default debug log level (when debug is set to on).*/
+#define CC_PAL_MAX_LOG_LEVEL  CC_PAL_LOG_LEVEL_ERR /*CC_PAL_LOG_LEVEL_DEBUG*/
+#else /* Disable logging */
+/*! Default debug log level (when debug is set to on).*/
+#define CC_PAL_MAX_LOG_LEVEL CC_PAL_LOG_LEVEL_NULL
+#endif
+#endif /*CC_PAL_MAX_LOG_LEVEL*/
+/*! Evaluate CC_PAL_MAX_LOG_LEVEL in case provided by caller */
+#define __CC_PAL_LOG_LEVEL_EVAL(level) level
+/*! Maximal log level defintion.*/
+#define _CC_PAL_MAX_LOG_LEVEL __CC_PAL_LOG_LEVEL_EVAL(CC_PAL_MAX_LOG_LEVEL)
+
+
+#ifdef ARM_DSM
+/*! Log init function. */
+#define CC_PalLogInit() do {} while (0)
+/*! Log set level function - sets the level of logging in case of debug. */
+#define CC_PalLogLevelSet(setLevel) do {} while (0)
+/*! Log set mask function - sets the component masking in case of debug. */
+#define CC_PalLogMaskSet(setMask) do {} while (0)
+#else
+#if _CC_PAL_MAX_LOG_LEVEL > CC_PAL_LOG_LEVEL_NULL
+/*! Log init function. */
+void CC_PalLogInit(void);
+/*! Log set level function - sets the level of logging in case of debug. */
+void CC_PalLogLevelSet(int setLevel);
+/*! Log set mask function - sets the component masking in case of debug. */
+void CC_PalLogMaskSet(uint32_t setMask);
+/*! Global variable for log level */
+extern int CC_PAL_logLevel;
+/*! Global variable for log mask */
+extern uint32_t CC_PAL_logMask;
+#else /* No log */
+/*! Log init function. */
+static inline void CC_PalLogInit(void) {}
+/*! Log set level function - sets the level of logging in case of debug. */
+static inline void CC_PalLogLevelSet(int setLevel) {CC_UNUSED_PARAM(setLevel);}
+/*! Log set mask function - sets the component masking in case of debug. */
+static inline void CC_PalLogMaskSet(uint32_t setMask) {CC_UNUSED_PARAM(setMask);}
+#endif
+#endif
+
+/*! Filter logging based on logMask and dispatch to platform specific logging mechanism. */
+#define _CC_PAL_LOG(level, format, ...)  \
+	if (CC_PAL_logMask & CC_PAL_LOG_CUR_COMPONENT) \
+		__CC_PAL_LOG_PLAT(CC_PAL_LOG_LEVEL_ ## level, "%s:%s: " format, CC_PAL_LOG_CUR_COMPONENT_NAME, __func__, ##__VA_ARGS__)
+
+#if (_CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_ERR)
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_ERR(format, ... ) \
+	_CC_PAL_LOG(ERR, format, ##__VA_ARGS__)
+#else
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_ERR( ... ) do {} while (0)
+#endif
+
+#if (_CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_WARN)
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_WARN(format, ... ) \
+	if (CC_PAL_logLevel >= CC_PAL_LOG_LEVEL_WARN) \
+		_CC_PAL_LOG(WARN, format, ##__VA_ARGS__)
+#else
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_WARN( ... ) do {} while (0)
+#endif
+
+#if (_CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_INFO)
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_INFO(format, ... ) \
+	if (CC_PAL_logLevel >= CC_PAL_LOG_LEVEL_INFO) \
+		_CC_PAL_LOG(INFO, format, ##__VA_ARGS__)
+#else
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_INFO( ... ) do {} while (0)
+#endif
+
+#if (_CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_DEBUG)
+/*! Log messages according to log level.*/
+#define CC_PAL_LOG_DEBUG(format, ... ) \
+	if (CC_PAL_logLevel >= CC_PAL_LOG_LEVEL_DEBUG) \
+		_CC_PAL_LOG(DEBUG, format, ##__VA_ARGS__)
+
+/*! Log message buffer.*/
+#define CC_PAL_LOG_DUMP_BUF(msg, buf, size)		\
+	do {						\
+	int i;						\
+	uint8_t	*pData = (uint8_t*)buf;			\
+							\
+	PRINTF("%s (%d):\n", msg, size);		\
+	for (i = 0; i < size; i++) {			\
+		PRINTF("0x%02X ", pData[i]);		\
+		if ((i & 0xF) == 0xF) {			\
+			PRINTF("\n");			\
+		}					\
+	}						\
+	PRINTF("\n");					\
+	} while (0)
+#else
+/*! Log debug messages.*/
+#define CC_PAL_LOG_DEBUG( ... ) do {} while (0)
+/*! Log debug buffer.*/
+#define CC_PAL_LOG_DUMP_BUF(msg, buf, size)	do {} while (0)
+#endif
+
+#if (_CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_TRACE)
+/*! Log debug trace.*/
+#define CC_PAL_LOG_TRACE(format, ... ) \
+	if (CC_PAL_logLevel >= CC_PAL_LOG_LEVEL_TRACE) \
+		_CC_PAL_LOG(TRACE, format, ##__VA_ARGS__)
+#else
+/*! Log debug trace.*/
+#define CC_PAL_LOG_TRACE(...) do {} while (0)
+#endif
+
+#if (_CC_PAL_MAX_LOG_LEVEL >= CC_PAL_LOG_LEVEL_TRACE)
+/*! Log debug data.*/
+#define CC_PAL_LOG_DATA(format, ...) \
+	if (CC_PAL_logLevel >= CC_PAL_LOG_LEVEL_TRACE) \
+		_CC_PAL_LOG(DATA, format, ##__VA_ARGS__)
+#else
+/*! Log debug data.*/
+#define CC_PAL_LOG_DATA( ...) do {} while (0)
+#endif
+/** 
+@}
+ */
+
+#endif /*_CC_PAL_LOG_H_*/
diff --git a/drivers/staging/ccree/cc_pal_log_plat.h b/drivers/staging/ccree/cc_pal_log_plat.h
new file mode 100644
index 0000000..01cc3b0
--- /dev/null
+++ b/drivers/staging/ccree/cc_pal_log_plat.h
@@ -0,0 +1,33 @@
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
+/* Dummy pal_log_plat for test driver in kernel */
+
+#ifndef _SSI_PAL_LOG_PLAT_H_
+#define _SSI_PAL_LOG_PLAT_H_
+
+#if defined(DEBUG)
+
+#define __CC_PAL_LOG_PLAT(level, format, ...) printk(level "cc7x_test::" format , ##__VA_ARGS__)
+
+#else /* Disable all prints */
+
+#define __CC_PAL_LOG_PLAT(...)  do {} while (0)
+
+#endif
+
+#endif /*_SASI_PAL_LOG_PLAT_H_*/
+
diff --git a/drivers/staging/ccree/cc_pal_types.h b/drivers/staging/ccree/cc_pal_types.h
new file mode 100644
index 0000000..25c89b7
--- /dev/null
+++ b/drivers/staging/ccree/cc_pal_types.h
@@ -0,0 +1,97 @@
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
+#ifndef CC_PAL_TYPES_H
+#define CC_PAL_TYPES_H
+
+/*! 
+@file 
+@brief This file contains platform-dependent definitions and types. 
+@defgroup cc_pal_types CryptoCell PAL platform dependant types
+@{
+@ingroup cc_pal
+
+*/
+ 
+#include "cc_pal_types_plat.h"
+
+/*! Boolean definition.*/
+typedef enum {
+	/*! Boolean false definition.*/
+	CC_FALSE = 0,
+	/*! Boolean true definition.*/
+	CC_TRUE = 1
+} CCBool;
+
+/*! Success definition. */
+#define CC_SUCCESS              0UL
+/*! Failure definition. */
+#define CC_FAIL		  	1UL
+
+/*! Defintion of 1KB in bytes. */
+#define CC_1K_SIZE_IN_BYTES	1024
+/*! Defintion of number of bits in a byte. */
+#define CC_BITS_IN_BYTE		8
+/*! Defintion of number of bits in a 32bits word. */
+#define CC_BITS_IN_32BIT_WORD	32
+/*! Defintion of number of bytes in a 32bits word. */
+#define CC_32BIT_WORD_SIZE	(sizeof(uint32_t))
+
+/*! Success (OK) defintion. */
+#define CC_OK   0
+
+/*! Macro that handles unused parameters in the code (to avoid compilation warnings).  */
+#define CC_UNUSED_PARAM(prm)  ((void)prm)
+
+/*! Maximal uint32 value.*/
+#define CC_MAX_UINT32_VAL 	(0xFFFFFFFF)
+
+
+/* Minimum and Maximum macros */
+#ifdef  min
+/*! Definition for minimum. */
+#define CC_MIN(a,b) min( a , b )
+#else
+/*! Definition for minimum. */
+#define CC_MIN( a , b ) ( ( (a) < (b) ) ? (a) : (b) )
+#endif
+
+#ifdef max    
+/*! Definition for maximum. */    
+#define CC_MAX(a,b) max( a , b )
+#else
+/*! Definition for maximum. */    
+#define CC_MAX( a , b ) ( ( (a) > (b) ) ? (a) : (b) )
+#endif
+
+/*! Macro that calculates number of full bytes from bits (i.e. 7 bits are 1 byte). */    
+#define CALC_FULL_BYTES(numBits) 		((numBits)/CC_BITS_IN_BYTE + (((numBits) & (CC_BITS_IN_BYTE-1)) > 0)) 
+/*! Macro that calculates number of full 32bits words from bits (i.e. 31 bits are 1 word). */    
+#define CALC_FULL_32BIT_WORDS(numBits) 		((numBits)/CC_BITS_IN_32BIT_WORD +  (((numBits) & (CC_BITS_IN_32BIT_WORD-1)) > 0))   
+/*! Macro that calculates number of full 32bits words from bytes (i.e. 3 bytes are 1 word). */    
+#define CALC_32BIT_WORDS_FROM_BYTES(sizeBytes)  ((sizeBytes)/CC_32BIT_WORD_SIZE + (((sizeBytes) & (CC_32BIT_WORD_SIZE-1)) > 0)) 
+/*! Macro that round up bits to 32bits words. */     
+#define ROUNDUP_BITS_TO_32BIT_WORD(numBits) 	(CALC_FULL_32BIT_WORDS(numBits) * CC_BITS_IN_32BIT_WORD)
+/*! Macro that round up bits to bytes. */    
+#define ROUNDUP_BITS_TO_BYTES(numBits) 		(CALC_FULL_BYTES(numBits) * CC_BITS_IN_BYTE)
+/*! Macro that round up bytes to 32bits words. */    
+#define ROUNDUP_BYTES_TO_32BIT_WORD(sizeBytes) 	(CALC_32BIT_WORDS_FROM_BYTES(sizeBytes) * CC_32BIT_WORD_SIZE)     
+
+
+/** 
+@}
+ */
+#endif
diff --git a/drivers/staging/ccree/cc_pal_types_plat.h b/drivers/staging/ccree/cc_pal_types_plat.h
new file mode 100644
index 0000000..9016101
--- /dev/null
+++ b/drivers/staging/ccree/cc_pal_types_plat.h
@@ -0,0 +1,29 @@
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
+#ifndef SSI_PAL_TYPES_PLAT_H
+#define SSI_PAL_TYPES_PLAT_H
+/* Linux kernel types */
+
+#include <linux/types.h>
+
+#ifndef NULL /* Missing in Linux kernel */
+#define NULL (0x0L)
+#endif
+
+
+#endif /*SSI_PAL_TYPES_PLAT_H*/
diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
new file mode 100644
index 0000000..fa5486b
--- /dev/null
+++ b/drivers/staging/ccree/cc_regs.h
@@ -0,0 +1,106 @@
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
+/*!
+ * @file 
+ * @brief This file contains macro definitions for accessing ARM TrustZone CryptoCell register space.
+ */
+
+#ifndef _CC_REGS_H_
+#define _CC_REGS_H_
+
+#include "cc_bitops.h"
+
+/* Register Offset macro */
+#define CC_REG_OFFSET(unit_name, reg_name)               \
+	(DX_BASE_ ## unit_name + DX_ ## reg_name ## _REG_OFFSET)
+
+#define CC_REG_BIT_SHIFT(reg_name, field_name)               \
+	(DX_ ## reg_name ## _ ## field_name ## _BIT_SHIFT)
+
+/* Register Offset macros (from registers base address in host) */
+#include "dx_reg_base_host.h"
+
+/* Read-Modify-Write a field of a register */
+#define MODIFY_REGISTER_FLD(unitName, regName, fldName, fldVal)         \
+do {								            \
+	uint32_t regVal;						    \
+	regVal = READ_REGISTER(CC_REG_ADDR(unitName, regName));       \
+	CC_REG_FLD_SET(unitName, regName, fldName, regVal, fldVal); \
+	WRITE_REGISTER(CC_REG_ADDR(unitName, regName), regVal);       \
+} while (0)
+
+/* Registers address macros for ENV registers (development FPGA only) */
+#ifdef DX_BASE_ENV_REGS
+
+/* This offset should be added to mapping address of DX_BASE_ENV_REGS */
+#define CC_ENV_REG_OFFSET(reg_name) (DX_ENV_ ## reg_name ## _REG_OFFSET)
+
+#endif /*DX_BASE_ENV_REGS*/
+
+/*! Bit fields get */
+#define CC_REG_FLD_GET(unit_name, reg_name, fld_name, reg_val)	      \
+	(DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20 ?	      \
+	reg_val /*!< \internal Optimization for 32b fields */ :			      \
+	BITFIELD_GET(reg_val, DX_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT, \
+		     DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE))
+
+/*! Bit fields access */
+#define CC_REG_FLD_GET2(unit_name, reg_name, fld_name, reg_val)	      \
+	(CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20 ?	      \
+	reg_val /*!< \internal Optimization for 32b fields */ :			      \
+	BITFIELD_GET(reg_val, CC_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT, \
+		     CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE))
+
+/* yael TBD !!! -       				      * 
+* all HW includes should start with CC_ and not DX_ !!	      */
+
+
+/*! Bit fields set */
+#define CC_REG_FLD_SET(                                               \
+	unit_name, reg_name, fld_name, reg_shadow_var, new_fld_val)      \
+do {                                                                     \
+	if (DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20)       \
+		reg_shadow_var = new_fld_val; /*!< \internal Optimization for 32b fields */\
+	else                                                             \
+		BITFIELD_SET(reg_shadow_var,                             \
+			DX_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT,  \
+			DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE,   \
+			new_fld_val);                                    \
+} while (0)
+
+/*! Bit fields set */
+#define CC_REG_FLD_SET2(                                               \
+	unit_name, reg_name, fld_name, reg_shadow_var, new_fld_val)      \
+do {                                                                     \
+	if (CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20)       \
+		reg_shadow_var = new_fld_val; /*!< \internal Optimization for 32b fields */\
+	else                                                             \
+		BITFIELD_SET(reg_shadow_var,                             \
+			CC_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT,  \
+			CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE,   \
+			new_fld_val);                                    \
+} while (0)
+
+/* Usage example:
+   uint32_t reg_shadow = READ_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL));
+   CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY0,reg_shadow, 3);
+   CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY1,reg_shadow, 1);
+   WRITE_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL), reg_shadow);
+ */
+
+#endif /*_CC_REGS_H_*/
diff --git a/drivers/staging/ccree/dx_crys_kernel.h b/drivers/staging/ccree/dx_crys_kernel.h
new file mode 100644
index 0000000..ba80a9e
--- /dev/null
+++ b/drivers/staging/ccree/dx_crys_kernel.h
@@ -0,0 +1,180 @@
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
+#ifndef __DX_CRYS_KERNEL_H__
+#define __DX_CRYS_KERNEL_H__
+
+// --------------------------------------
+// BLOCK: DSCRPTR
+// --------------------------------------
+#define DX_DSCRPTR_COMPLETION_COUNTER_REG_OFFSET 	0xE00UL 
+#define DX_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SIZE 	0x6UL
+#define DX_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SHIFT 	0x6UL
+#define DX_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_SW_RESET_REG_OFFSET 	0xE40UL 
+#define DX_DSCRPTR_SW_RESET_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_SW_RESET_VALUE_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_REG_OFFSET 	0xE60UL 
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SIZE 	0xAUL
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SHIFT 	0xAUL
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SIZE 	0xCUL
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SHIFT 	0x16UL
+#define DX_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SIZE 	0x3UL
+#define DX_DSCRPTR_SINGLE_ADDR_EN_REG_OFFSET 	0xE64UL 
+#define DX_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_MEASURE_CNTR_REG_OFFSET 	0xE68UL 
+#define DX_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SIZE 	0x20UL
+#define DX_DSCRPTR_QUEUE_WORD0_REG_OFFSET 	0xE80UL 
+#define DX_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SIZE 	0x20UL
+#define DX_DSCRPTR_QUEUE_WORD1_REG_OFFSET 	0xE84UL 
+#define DX_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SHIFT 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE 	0x18UL
+#define DX_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SHIFT 	0x1AUL
+#define DX_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SHIFT 	0x1BUL
+#define DX_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SHIFT 	0x1CUL
+#define DX_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SHIFT 	0x1DUL
+#define DX_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SHIFT 	0x1EUL
+#define DX_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD2_REG_OFFSET 	0xE88UL 
+#define DX_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SIZE 	0x20UL
+#define DX_DSCRPTR_QUEUE_WORD3_REG_OFFSET 	0xE8CUL 
+#define DX_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SHIFT 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SIZE 	0x18UL
+#define DX_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SHIFT 	0x1AUL
+#define DX_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SHIFT 	0x1BUL
+#define DX_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SHIFT 	0x1DUL
+#define DX_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SHIFT 	0x1EUL
+#define DX_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SHIFT 	0x1FUL
+#define DX_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_REG_OFFSET 	0xE90UL 
+#define DX_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SIZE 	0x6UL
+#define DX_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SHIFT 	0x6UL
+#define DX_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SHIFT 	0x7UL
+#define DX_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SHIFT 	0x8UL
+#define DX_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SHIFT 	0xAUL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SIZE 	0x4UL
+#define DX_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SHIFT 	0xEUL
+#define DX_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SHIFT 	0xFUL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SHIFT 	0x11UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SHIFT 	0x13UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SHIFT 	0x14UL
+#define DX_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SHIFT 	0x16UL
+#define DX_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SIZE 	0x2UL
+#define DX_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SHIFT 	0x18UL
+#define DX_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SIZE 	0x4UL
+#define DX_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SHIFT 	0x1CUL
+#define DX_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SHIFT 	0x1DUL
+#define DX_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SHIFT 	0x1EUL
+#define DX_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SHIFT 	0x1FUL
+#define DX_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SIZE 	0x1UL
+#define DX_DSCRPTR_QUEUE_WORD5_REG_OFFSET 	0xE94UL 
+#define DX_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SIZE 	0x10UL
+#define DX_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SHIFT 	0x10UL
+#define DX_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SIZE 	0x10UL
+#define DX_DSCRPTR_QUEUE_WATERMARK_REG_OFFSET 	0xE98UL 
+#define DX_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SIZE 	0xAUL
+#define DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET 	0xE9CUL 
+#define DX_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SHIFT 	0x0UL
+#define DX_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SIZE 	0xAUL
+// --------------------------------------
+// BLOCK: AXI_P
+// --------------------------------------
+#define DX_AXIM_MON_INFLIGHT_REG_OFFSET 	0xB00UL 
+#define DX_AXIM_MON_INFLIGHT_VALUE_BIT_SHIFT 	0x0UL
+#define DX_AXIM_MON_INFLIGHT_VALUE_BIT_SIZE 	0x8UL
+#define DX_AXIM_MON_INFLIGHTLAST_REG_OFFSET 	0xB40UL 
+#define DX_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SHIFT 	0x0UL
+#define DX_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SIZE 	0x8UL
+#define DX_AXIM_MON_COMP_REG_OFFSET 	0xB80UL 
+#define DX_AXIM_MON_COMP_VALUE_BIT_SHIFT 	0x0UL
+#define DX_AXIM_MON_COMP_VALUE_BIT_SIZE 	0x10UL
+#define DX_AXIM_MON_ERR_REG_OFFSET 	0xBC4UL 
+#define DX_AXIM_MON_ERR_BRESP_BIT_SHIFT 	0x0UL
+#define DX_AXIM_MON_ERR_BRESP_BIT_SIZE 	0x2UL
+#define DX_AXIM_MON_ERR_BID_BIT_SHIFT 	0x2UL
+#define DX_AXIM_MON_ERR_BID_BIT_SIZE 	0x4UL
+#define DX_AXIM_MON_ERR_RRESP_BIT_SHIFT 	0x10UL
+#define DX_AXIM_MON_ERR_RRESP_BIT_SIZE 	0x2UL
+#define DX_AXIM_MON_ERR_RID_BIT_SHIFT 	0x12UL
+#define DX_AXIM_MON_ERR_RID_BIT_SIZE 	0x4UL
+#define DX_AXIM_CFG_REG_OFFSET 	0xBE8UL 
+#define DX_AXIM_CFG_BRESPMASK_BIT_SHIFT 	0x4UL
+#define DX_AXIM_CFG_BRESPMASK_BIT_SIZE 	0x1UL
+#define DX_AXIM_CFG_RRESPMASK_BIT_SHIFT 	0x5UL
+#define DX_AXIM_CFG_RRESPMASK_BIT_SIZE 	0x1UL
+#define DX_AXIM_CFG_INFLTMASK_BIT_SHIFT 	0x6UL
+#define DX_AXIM_CFG_INFLTMASK_BIT_SIZE 	0x1UL
+#define DX_AXIM_CFG_COMPMASK_BIT_SHIFT 	0x7UL
+#define DX_AXIM_CFG_COMPMASK_BIT_SIZE 	0x1UL
+#define DX_AXIM_ACE_CONST_REG_OFFSET 	0xBECUL 
+#define DX_AXIM_ACE_CONST_ARDOMAIN_BIT_SHIFT 	0x0UL
+#define DX_AXIM_ACE_CONST_ARDOMAIN_BIT_SIZE 	0x2UL
+#define DX_AXIM_ACE_CONST_AWDOMAIN_BIT_SHIFT 	0x2UL
+#define DX_AXIM_ACE_CONST_AWDOMAIN_BIT_SIZE 	0x2UL
+#define DX_AXIM_ACE_CONST_ARBAR_BIT_SHIFT 	0x4UL
+#define DX_AXIM_ACE_CONST_ARBAR_BIT_SIZE 	0x2UL
+#define DX_AXIM_ACE_CONST_AWBAR_BIT_SHIFT 	0x6UL
+#define DX_AXIM_ACE_CONST_AWBAR_BIT_SIZE 	0x2UL
+#define DX_AXIM_ACE_CONST_ARSNOOP_BIT_SHIFT 	0x8UL
+#define DX_AXIM_ACE_CONST_ARSNOOP_BIT_SIZE 	0x4UL
+#define DX_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SHIFT 	0xCUL
+#define DX_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SIZE 	0x3UL
+#define DX_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SHIFT 	0xFUL
+#define DX_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SIZE 	0x3UL
+#define DX_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SHIFT 	0x12UL
+#define DX_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SIZE 	0x7UL
+#define DX_AXIM_ACE_CONST_AWLEN_VAL_BIT_SHIFT 	0x19UL
+#define DX_AXIM_ACE_CONST_AWLEN_VAL_BIT_SIZE 	0x4UL
+#define DX_AXIM_CACHE_PARAMS_REG_OFFSET 	0xBF0UL 
+#define DX_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SHIFT 	0x0UL
+#define DX_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SIZE 	0x4UL
+#define DX_AXIM_CACHE_PARAMS_AWCACHE_BIT_SHIFT 	0x4UL
+#define DX_AXIM_CACHE_PARAMS_AWCACHE_BIT_SIZE 	0x4UL
+#define DX_AXIM_CACHE_PARAMS_ARCACHE_BIT_SHIFT 	0x8UL
+#define DX_AXIM_CACHE_PARAMS_ARCACHE_BIT_SIZE 	0x4UL
+#endif	// __DX_CRYS_KERNEL_H__
diff --git a/drivers/staging/ccree/dx_env.h b/drivers/staging/ccree/dx_env.h
new file mode 100644
index 0000000..199ce2d
--- /dev/null
+++ b/drivers/staging/ccree/dx_env.h
@@ -0,0 +1,224 @@
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
+#ifndef __DX_ENV_H__
+#define __DX_ENV_H__
+
+// --------------------------------------
+// BLOCK: FPGA_ENV_REGS
+// --------------------------------------
+#define DX_ENV_PKA_DEBUG_MODE_REG_OFFSET 	0x024UL 
+#define DX_ENV_PKA_DEBUG_MODE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_PKA_DEBUG_MODE_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_SCAN_MODE_REG_OFFSET 	0x030UL 
+#define DX_ENV_SCAN_MODE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SCAN_MODE_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_ALLOW_SCAN_REG_OFFSET 	0x034UL 
+#define DX_ENV_CC_ALLOW_SCAN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_ALLOW_SCAN_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_HOST_INT_REG_OFFSET 	0x0A0UL 
+#define DX_ENV_CC_HOST_INT_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_HOST_INT_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_PUB_HOST_INT_REG_OFFSET 	0x0A4UL 
+#define DX_ENV_CC_PUB_HOST_INT_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_PUB_HOST_INT_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_RST_N_REG_OFFSET 	0x0A8UL 
+#define DX_ENV_CC_RST_N_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_RST_N_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_RST_OVERRIDE_REG_OFFSET 	0x0ACUL 
+#define DX_ENV_RST_OVERRIDE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_RST_OVERRIDE_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_POR_N_ADDR_REG_OFFSET 	0x0E0UL 
+#define DX_ENV_CC_POR_N_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_POR_N_ADDR_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_COLD_RST_REG_OFFSET 	0x0FCUL 
+#define DX_ENV_CC_COLD_RST_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_COLD_RST_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_DUMMY_ADDR_REG_OFFSET 	0x108UL 
+#define DX_ENV_DUMMY_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_DUMMY_ADDR_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_COUNTER_CLR_REG_OFFSET 	0x118UL 
+#define DX_ENV_COUNTER_CLR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_COUNTER_CLR_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_COUNTER_RD_REG_OFFSET 	0x11CUL 
+#define DX_ENV_COUNTER_RD_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_COUNTER_RD_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_RNG_DEBUG_ENABLE_REG_OFFSET 	0x430UL 
+#define DX_ENV_RNG_DEBUG_ENABLE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_RNG_DEBUG_ENABLE_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_LCS_REG_OFFSET 	0x43CUL 
+#define DX_ENV_CC_LCS_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_LCS_VALUE_BIT_SIZE 	0x8UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_REG_OFFSET 	0x440UL 
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_CM_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_CM_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_DM_BIT_SHIFT 	0x1UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_DM_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_SECURE_BIT_SHIFT 	0x2UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_SECURE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_RMA_BIT_SHIFT 	0x3UL
+#define DX_ENV_CC_IS_CM_DM_SECURE_RMA_IS_RMA_BIT_SIZE 	0x1UL
+#define DX_ENV_DCU_EN_REG_OFFSET 	0x444UL 
+#define DX_ENV_DCU_EN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_DCU_EN_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_CC_LCS_IS_VALID_REG_OFFSET 	0x448UL 
+#define DX_ENV_CC_LCS_IS_VALID_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_LCS_IS_VALID_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_POWER_DOWN_REG_OFFSET 	0x478UL 
+#define DX_ENV_POWER_DOWN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_POWER_DOWN_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_DCU_H_EN_REG_OFFSET 	0x484UL 
+#define DX_ENV_DCU_H_EN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_DCU_H_EN_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_VERSION_REG_OFFSET 	0x488UL 
+#define DX_ENV_VERSION_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_VERSION_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_ROSC_WRITE_REG_OFFSET 	0x48CUL 
+#define DX_ENV_ROSC_WRITE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_ROSC_WRITE_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_ROSC_ADDR_REG_OFFSET 	0x490UL 
+#define DX_ENV_ROSC_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_ROSC_ADDR_VALUE_BIT_SIZE 	0x8UL
+#define DX_ENV_RESET_SESSION_KEY_REG_OFFSET 	0x494UL 
+#define DX_ENV_RESET_SESSION_KEY_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_RESET_SESSION_KEY_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_SESSION_KEY_0_REG_OFFSET 	0x4A0UL 
+#define DX_ENV_SESSION_KEY_0_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SESSION_KEY_0_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_SESSION_KEY_1_REG_OFFSET 	0x4A4UL 
+#define DX_ENV_SESSION_KEY_1_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SESSION_KEY_1_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_SESSION_KEY_2_REG_OFFSET 	0x4A8UL 
+#define DX_ENV_SESSION_KEY_2_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SESSION_KEY_2_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_SESSION_KEY_3_REG_OFFSET 	0x4ACUL 
+#define DX_ENV_SESSION_KEY_3_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SESSION_KEY_3_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_SESSION_KEY_VALID_REG_OFFSET 	0x4B0UL 
+#define DX_ENV_SESSION_KEY_VALID_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SESSION_KEY_VALID_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_SPIDEN_REG_OFFSET 	0x4D0UL 
+#define DX_ENV_SPIDEN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_SPIDEN_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_AXIM_USER_PARAMS_REG_OFFSET 	0x600UL 
+#define DX_ENV_AXIM_USER_PARAMS_ARUSER_BIT_SHIFT 	0x0UL
+#define DX_ENV_AXIM_USER_PARAMS_ARUSER_BIT_SIZE 	0x5UL
+#define DX_ENV_AXIM_USER_PARAMS_AWUSER_BIT_SHIFT 	0x5UL
+#define DX_ENV_AXIM_USER_PARAMS_AWUSER_BIT_SIZE 	0x5UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_REG_OFFSET 	0x604UL 
+#define DX_ENV_SECURITY_MODE_OVERRIDE_AWPROT_NS_BIT_BIT_SHIFT 	0x0UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_AWPROT_NS_BIT_BIT_SIZE 	0x1UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_AWPROT_NS_OVERRIDE_BIT_SHIFT 	0x1UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_AWPROT_NS_OVERRIDE_BIT_SIZE 	0x1UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_ARPROT_NS_BIT_BIT_SHIFT 	0x2UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_ARPROT_NS_BIT_BIT_SIZE 	0x1UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_ARPROT_NS_OVERRIDE_BIT_SHIFT 	0x3UL
+#define DX_ENV_SECURITY_MODE_OVERRIDE_ARPROT_NS_OVERRIDE_BIT_SIZE 	0x1UL
+#define DX_ENV_AO_CC_KPLT_0_REG_OFFSET 	0x620UL 
+#define DX_ENV_AO_CC_KPLT_0_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KPLT_0_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KPLT_1_REG_OFFSET 	0x624UL 
+#define DX_ENV_AO_CC_KPLT_1_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KPLT_1_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KPLT_2_REG_OFFSET 	0x628UL 
+#define DX_ENV_AO_CC_KPLT_2_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KPLT_2_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KPLT_3_REG_OFFSET 	0x62CUL 
+#define DX_ENV_AO_CC_KPLT_3_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KPLT_3_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KCST_0_REG_OFFSET 	0x630UL 
+#define DX_ENV_AO_CC_KCST_0_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KCST_0_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KCST_1_REG_OFFSET 	0x634UL 
+#define DX_ENV_AO_CC_KCST_1_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KCST_1_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KCST_2_REG_OFFSET 	0x638UL 
+#define DX_ENV_AO_CC_KCST_2_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KCST_2_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_AO_CC_KCST_3_REG_OFFSET 	0x63CUL 
+#define DX_ENV_AO_CC_KCST_3_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_AO_CC_KCST_3_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APB_FIPS_ADDR_REG_OFFSET 	0x650UL 
+#define DX_ENV_APB_FIPS_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APB_FIPS_ADDR_VALUE_BIT_SIZE 	0xCUL
+#define DX_ENV_APB_FIPS_VAL_REG_OFFSET 	0x654UL 
+#define DX_ENV_APB_FIPS_VAL_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APB_FIPS_VAL_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APB_FIPS_MASK_REG_OFFSET 	0x658UL 
+#define DX_ENV_APB_FIPS_MASK_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APB_FIPS_MASK_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APB_FIPS_CNT_REG_OFFSET 	0x65CUL 
+#define DX_ENV_APB_FIPS_CNT_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APB_FIPS_CNT_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APB_FIPS_NEW_ADDR_REG_OFFSET 	0x660UL 
+#define DX_ENV_APB_FIPS_NEW_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APB_FIPS_NEW_ADDR_VALUE_BIT_SIZE 	0xCUL
+#define DX_ENV_APB_FIPS_NEW_VAL_REG_OFFSET 	0x664UL 
+#define DX_ENV_APB_FIPS_NEW_VAL_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APB_FIPS_NEW_VAL_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APBP_FIPS_ADDR_REG_OFFSET 	0x670UL 
+#define DX_ENV_APBP_FIPS_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APBP_FIPS_ADDR_VALUE_BIT_SIZE 	0xCUL
+#define DX_ENV_APBP_FIPS_VAL_REG_OFFSET 	0x674UL 
+#define DX_ENV_APBP_FIPS_VAL_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APBP_FIPS_VAL_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APBP_FIPS_MASK_REG_OFFSET 	0x678UL 
+#define DX_ENV_APBP_FIPS_MASK_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APBP_FIPS_MASK_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APBP_FIPS_CNT_REG_OFFSET 	0x67CUL 
+#define DX_ENV_APBP_FIPS_CNT_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APBP_FIPS_CNT_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_APBP_FIPS_NEW_ADDR_REG_OFFSET 	0x680UL 
+#define DX_ENV_APBP_FIPS_NEW_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APBP_FIPS_NEW_ADDR_VALUE_BIT_SIZE 	0xCUL
+#define DX_ENV_APBP_FIPS_NEW_VAL_REG_OFFSET 	0x684UL 
+#define DX_ENV_APBP_FIPS_NEW_VAL_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_APBP_FIPS_NEW_VAL_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_CC_POWERDOWN_EN_REG_OFFSET 	0x690UL 
+#define DX_ENV_CC_POWERDOWN_EN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_POWERDOWN_EN_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_CC_POWERDOWN_RST_EN_REG_OFFSET 	0x694UL 
+#define DX_ENV_CC_POWERDOWN_RST_EN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_CC_POWERDOWN_RST_EN_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_POWERDOWN_RST_CNTR_REG_OFFSET 	0x698UL 
+#define DX_ENV_POWERDOWN_RST_CNTR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_POWERDOWN_RST_CNTR_VALUE_BIT_SIZE 	0x20UL
+#define DX_ENV_POWERDOWN_EN_DEBUG_REG_OFFSET 	0x69CUL 
+#define DX_ENV_POWERDOWN_EN_DEBUG_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_POWERDOWN_EN_DEBUG_VALUE_BIT_SIZE 	0x1UL
+// --------------------------------------
+// BLOCK: ENV_CC_MEMORIES
+// --------------------------------------
+#define DX_ENV_FUSE_READY_REG_OFFSET 	0x000UL 
+#define DX_ENV_FUSE_READY_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_FUSE_READY_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_PERF_RAM_MASTER_REG_OFFSET 	0x0ECUL 
+#define DX_ENV_PERF_RAM_MASTER_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_PERF_RAM_MASTER_VALUE_BIT_SIZE 	0x1UL
+#define DX_ENV_PERF_RAM_ADDR_HIGH4_REG_OFFSET 	0x0F0UL 
+#define DX_ENV_PERF_RAM_ADDR_HIGH4_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_PERF_RAM_ADDR_HIGH4_VALUE_BIT_SIZE 	0x2UL
+#define DX_ENV_FUSES_RAM_REG_OFFSET 	0x3ECUL 
+#define DX_ENV_FUSES_RAM_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_FUSES_RAM_VALUE_BIT_SIZE 	0x20UL
+// --------------------------------------
+// BLOCK: ENV_PERF_RAM_BASE
+// --------------------------------------
+#define DX_ENV_PERF_RAM_BASE_REG_OFFSET 	0x000UL 
+#define DX_ENV_PERF_RAM_BASE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_ENV_PERF_RAM_BASE_VALUE_BIT_SIZE 	0x20UL
+
+#endif /*__DX_ENV_H__*/
diff --git a/drivers/staging/ccree/dx_host.h b/drivers/staging/ccree/dx_host.h
new file mode 100644
index 0000000..edee5e3
--- /dev/null
+++ b/drivers/staging/ccree/dx_host.h
@@ -0,0 +1,155 @@
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
+#ifndef __DX_HOST_H__
+#define __DX_HOST_H__
+
+// --------------------------------------
+// BLOCK: HOST_P
+// --------------------------------------
+#define DX_HOST_IRR_REG_OFFSET 	0xA00UL 
+#define DX_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SHIFT 	0x2UL
+#define DX_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SIZE 	0x1UL
+#define DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT 	0x8UL
+#define DX_HOST_IRR_AXI_ERR_INT_BIT_SIZE 	0x1UL
+#define DX_HOST_IRR_GPR0_BIT_SHIFT 	0xBUL
+#define DX_HOST_IRR_GPR0_BIT_SIZE 	0x1UL
+#define DX_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SHIFT 	0x13UL
+#define DX_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SIZE 	0x1UL
+#define DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT 	0x17UL
+#define DX_HOST_IRR_AXIM_COMP_INT_BIT_SIZE 	0x1UL
+#define DX_HOST_IMR_REG_OFFSET 	0xA04UL 
+#define DX_HOST_IMR_NOT_USED_MASK_BIT_SHIFT 	0x1UL
+#define DX_HOST_IMR_NOT_USED_MASK_BIT_SIZE 	0x1UL
+#define DX_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SHIFT 	0x2UL
+#define DX_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SIZE 	0x1UL
+#define DX_HOST_IMR_AXI_ERR_MASK_BIT_SHIFT 	0x8UL
+#define DX_HOST_IMR_AXI_ERR_MASK_BIT_SIZE 	0x1UL
+#define DX_HOST_IMR_GPR0_BIT_SHIFT 	0xBUL
+#define DX_HOST_IMR_GPR0_BIT_SIZE 	0x1UL
+#define DX_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SHIFT 	0x13UL
+#define DX_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SIZE 	0x1UL
+#define DX_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SHIFT 	0x17UL
+#define DX_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SIZE 	0x1UL
+#define DX_HOST_ICR_REG_OFFSET 	0xA08UL 
+#define DX_HOST_ICR_DSCRPTR_COMPLETION_BIT_SHIFT 	0x2UL
+#define DX_HOST_ICR_DSCRPTR_COMPLETION_BIT_SIZE 	0x1UL
+#define DX_HOST_ICR_AXI_ERR_CLEAR_BIT_SHIFT 	0x8UL
+#define DX_HOST_ICR_AXI_ERR_CLEAR_BIT_SIZE 	0x1UL
+#define DX_HOST_ICR_GPR_INT_CLEAR_BIT_SHIFT 	0xBUL
+#define DX_HOST_ICR_GPR_INT_CLEAR_BIT_SIZE 	0x1UL
+#define DX_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SHIFT 	0x13UL
+#define DX_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE 	0x1UL
+#define DX_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT 	0x17UL
+#define DX_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE 	0x1UL
+#define DX_HOST_SIGNATURE_REG_OFFSET 	0xA24UL 
+#define DX_HOST_SIGNATURE_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_SIGNATURE_VALUE_BIT_SIZE 	0x20UL
+#define DX_HOST_BOOT_REG_OFFSET 	0xA28UL 
+#define DX_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SHIFT 	0x0UL
+#define DX_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SHIFT 	0x1UL
+#define DX_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SHIFT 	0x2UL
+#define DX_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SHIFT 	0x3UL
+#define DX_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SHIFT 	0x5UL
+#define DX_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SHIFT 	0x6UL
+#define DX_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SIZE 	0x3UL
+#define DX_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SHIFT 	0x9UL
+#define DX_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SHIFT 	0xAUL
+#define DX_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SHIFT 	0xBUL
+#define DX_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SHIFT 	0xCUL
+#define DX_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SHIFT 	0xDUL
+#define DX_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SHIFT 	0xEUL
+#define DX_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SHIFT 	0xFUL
+#define DX_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SHIFT 	0x10UL
+#define DX_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SHIFT 	0x11UL
+#define DX_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SHIFT 	0x12UL
+#define DX_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SHIFT 	0x13UL
+#define DX_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SHIFT 	0x14UL
+#define DX_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SHIFT 	0x15UL
+#define DX_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SHIFT 	0x16UL
+#define DX_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SHIFT 	0x17UL
+#define DX_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SHIFT 	0x18UL
+#define DX_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SHIFT 	0x19UL
+#define DX_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SHIFT 	0x1AUL
+#define DX_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SHIFT 	0x1BUL
+#define DX_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SHIFT 	0x1CUL
+#define DX_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SHIFT 	0x1DUL
+#define DX_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SHIFT 	0x1EUL
+#define DX_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SIZE 	0x1UL
+#define DX_HOST_VERSION_REG_OFFSET 	0xA40UL 
+#define DX_HOST_VERSION_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_VERSION_VALUE_BIT_SIZE 	0x20UL
+#define DX_HOST_KFDE0_VALID_REG_OFFSET 	0xA60UL 
+#define DX_HOST_KFDE0_VALID_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_KFDE0_VALID_VALUE_BIT_SIZE 	0x1UL
+#define DX_HOST_KFDE1_VALID_REG_OFFSET 	0xA64UL 
+#define DX_HOST_KFDE1_VALID_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_KFDE1_VALID_VALUE_BIT_SIZE 	0x1UL
+#define DX_HOST_KFDE2_VALID_REG_OFFSET 	0xA68UL 
+#define DX_HOST_KFDE2_VALID_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_KFDE2_VALID_VALUE_BIT_SIZE 	0x1UL
+#define DX_HOST_KFDE3_VALID_REG_OFFSET 	0xA6CUL 
+#define DX_HOST_KFDE3_VALID_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_KFDE3_VALID_VALUE_BIT_SIZE 	0x1UL
+#define DX_HOST_GPR0_REG_OFFSET 	0xA70UL 
+#define DX_HOST_GPR0_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_GPR0_VALUE_BIT_SIZE 	0x20UL
+#define DX_GPR_HOST_REG_OFFSET 	0xA74UL 
+#define DX_GPR_HOST_VALUE_BIT_SHIFT 	0x0UL
+#define DX_GPR_HOST_VALUE_BIT_SIZE 	0x20UL
+#define DX_HOST_POWER_DOWN_EN_REG_OFFSET 	0xA78UL 
+#define DX_HOST_POWER_DOWN_EN_VALUE_BIT_SHIFT 	0x0UL
+#define DX_HOST_POWER_DOWN_EN_VALUE_BIT_SIZE 	0x1UL
+// --------------------------------------
+// BLOCK: HOST_SRAM
+// --------------------------------------
+#define DX_SRAM_DATA_REG_OFFSET 	0xF00UL 
+#define DX_SRAM_DATA_VALUE_BIT_SHIFT 	0x0UL
+#define DX_SRAM_DATA_VALUE_BIT_SIZE 	0x20UL
+#define DX_SRAM_ADDR_REG_OFFSET 	0xF04UL 
+#define DX_SRAM_ADDR_VALUE_BIT_SHIFT 	0x0UL
+#define DX_SRAM_ADDR_VALUE_BIT_SIZE 	0xFUL
+#define DX_SRAM_DATA_READY_REG_OFFSET 	0xF08UL 
+#define DX_SRAM_DATA_READY_VALUE_BIT_SHIFT 	0x0UL
+#define DX_SRAM_DATA_READY_VALUE_BIT_SIZE 	0x1UL
+
+#endif //__DX_HOST_H__
diff --git a/drivers/staging/ccree/dx_reg_base_host.h b/drivers/staging/ccree/dx_reg_base_host.h
new file mode 100644
index 0000000..113c252
--- /dev/null
+++ b/drivers/staging/ccree/dx_reg_base_host.h
@@ -0,0 +1,34 @@
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
+#ifndef __DX_REG_BASE_HOST_H__
+#define __DX_REG_BASE_HOST_H__
+
+/* Identify platform: Xilinx Zynq7000 ZC706 */
+#define DX_PLAT_ZYNQ7000 1
+#define DX_PLAT_ZYNQ7000_ZC706 1
+
+#define DX_BASE_CC 0x80000000
+
+#define DX_BASE_ENV_REGS 0x40008000
+#define DX_BASE_ENV_CC_MEMORIES 0x40008000
+#define DX_BASE_ENV_PERF_RAM 0x40009000
+
+#define DX_BASE_HOST_RGF 0x0UL
+#define DX_BASE_CRY_KERNEL     0x0UL
+#define DX_BASE_ROM     0x40000000
+
+#endif /*__DX_REG_BASE_HOST_H__*/
diff --git a/drivers/staging/ccree/dx_reg_common.h b/drivers/staging/ccree/dx_reg_common.h
new file mode 100644
index 0000000..4036d4f
--- /dev/null
+++ b/drivers/staging/ccree/dx_reg_common.h
@@ -0,0 +1,26 @@
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
+#ifndef __DX_REG_COMMON_H__
+#define __DX_REG_COMMON_H__
+
+#define DX_DEV_SIGNATURE 0xDCC71200UL
+
+#define CC_HW_VERSION 0xef840015UL 
+
+#define DX_DEV_SHA_MAX 512
+
+#endif /*__DX_REG_COMMON_H__*/
diff --git a/drivers/staging/ccree/hw_queue_defs_plat.h b/drivers/staging/ccree/hw_queue_defs_plat.h
new file mode 100644
index 0000000..b7b7efa
--- /dev/null
+++ b/drivers/staging/ccree/hw_queue_defs_plat.h
@@ -0,0 +1,43 @@
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
+#ifndef __HW_QUEUE_DEFS_PLAT_H__
+#define __HW_QUEUE_DEFS_PLAT_H__
+
+
+/*****************************/
+/* Descriptor packing macros */
+/*****************************/
+
+#define HW_QUEUE_FREE_SLOTS_GET() (CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_CONTENT)) & HW_QUEUE_SLOTS_MAX)
+
+#define HW_QUEUE_POLL_QUEUE_UNTIL_FREE_SLOTS(seqLen)						\
+	do {											\
+	} while (HW_QUEUE_FREE_SLOTS_GET() < (seqLen))
+
+#define HW_DESC_PUSH_TO_QUEUE(pDesc) do {        				  \
+	LOG_HW_DESC(pDesc);							  \
+	HW_DESC_DUMP(pDesc);							  \
+	CC_HAL_WRITE_REGISTER(GET_HW_Q_DESC_WORD_IDX(0), (pDesc)->word[0]); \
+	CC_HAL_WRITE_REGISTER(GET_HW_Q_DESC_WORD_IDX(1), (pDesc)->word[1]); \
+	CC_HAL_WRITE_REGISTER(GET_HW_Q_DESC_WORD_IDX(2), (pDesc)->word[2]); \
+	CC_HAL_WRITE_REGISTER(GET_HW_Q_DESC_WORD_IDX(3), (pDesc)->word[3]); \
+	CC_HAL_WRITE_REGISTER(GET_HW_Q_DESC_WORD_IDX(4), (pDesc)->word[4]); \
+	wmb();									   \
+	CC_HAL_WRITE_REGISTER(GET_HW_Q_DESC_WORD_IDX(5), (pDesc)->word[5]); \
+} while (0)
+
+#endif /*__HW_QUEUE_DEFS_PLAT_H__*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
new file mode 100644
index 0000000..aca837d
--- /dev/null
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -0,0 +1,537 @@
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
+#include <linux/crypto.h>
+#include <linux/version.h>
+#include <crypto/algapi.h>
+#include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "ssi_buffer_mgr.h"
+#include "cc_lli_defs.h"
+
+#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
+#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
+#define MLLI_TABLE_MIN_ALIGNMENT 4 /*Force the MLLI table to be align to uint32 */
+#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
+#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES (2*LLI_MAX_NUM_OF_DATA_ENTRIES + \
+					LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES )
+
+#ifdef CC_DEBUG
+#define DUMP_SGL(sg) \
+	while (sg) { \
+		SSI_LOG_DEBUG("page=%lu offset=%u length=%u (dma_len=%u) " \
+			     "dma_addr=%08x\n", (sg)->page_link, (sg)->offset, \
+			(sg)->length, sg_dma_len(sg), (sg)->dma_address); \
+		(sg) = sg_next(sg); \
+	}
+#define DUMP_MLLI_TABLE(mlli_p, nents) \
+	do { \
+		SSI_LOG_DEBUG("mlli=%pK nents=%u\n", (mlli_p), (nents)); \
+		while((nents)--) { \
+			SSI_LOG_DEBUG("addr=0x%08X size=0x%08X\n", \
+			     (mlli_p)[LLI_WORD0_OFFSET], \
+			     (mlli_p)[LLI_WORD1_OFFSET]); \
+			(mlli_p) += LLI_ENTRY_WORD_SIZE; \
+		} \
+	} while (0)
+#define GET_DMA_BUFFER_TYPE(buff_type) ( \
+	((buff_type) == SSI_DMA_BUF_NULL) ? "BUF_NULL" : \
+	((buff_type) == SSI_DMA_BUF_DLLI) ? "BUF_DLLI" : \
+	((buff_type) == SSI_DMA_BUF_MLLI) ? "BUF_MLLI" : "BUF_INVALID")
+#else
+#define DX_BUFFER_MGR_DUMP_SGL(sg)
+#define DX_BUFFER_MGR_DUMP_MLLI_TABLE(mlli_p, nents)
+#define GET_DMA_BUFFER_TYPE(buff_type)
+#endif
+
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
+	uint32_t * mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
+};
+
+#ifdef CC_DMA_48BIT_SIM
+dma_addr_t ssi_buff_mgr_update_dma_addr(dma_addr_t orig_addr, uint32_t data_len)
+{
+	dma_addr_t tmp_dma_addr;
+#ifdef CC_DMA_48BIT_SIM_FULL
+	/* With this code all addresses will be switched to 48 bits. */
+	/* The if condition protects from double expention */
+	if((((orig_addr >> 16) & 0xFFFF) != 0xFFFF) && 
+		(data_len <= CC_MAX_MLLI_ENTRY_SIZE)) {
+#else
+	if((!(((orig_addr >> 16) & 0xFF) % 2)) && 
+		(data_len <= CC_MAX_MLLI_ENTRY_SIZE)) {
+#endif
+		tmp_dma_addr = ((orig_addr<<16) | 0xFFFF0000 | 
+				(orig_addr & UINT16_MAX));
+			SSI_LOG_DEBUG("MAP DMA: orig address=0x%llX "
+				    "dma_address=0x%llX\n",
+				     orig_addr, tmp_dma_addr);
+			return tmp_dma_addr;	
+	}
+	return orig_addr;
+}
+
+dma_addr_t ssi_buff_mgr_restore_dma_addr(dma_addr_t orig_addr)
+{
+	dma_addr_t tmp_dma_addr;
+#ifdef CC_DMA_48BIT_SIM_FULL
+	/* With this code all addresses will be restored from 48 bits. */
+	/* The if condition protects from double restoring */
+	if((orig_addr >> 32) & 0xFFFF ) {
+#else
+	if(((orig_addr >> 32) & 0xFFFF) && 
+		!(((orig_addr >> 32) & 0xFF) % 2) ) {
+#endif
+		/*return high 16 bits*/
+		tmp_dma_addr = ((orig_addr >> 16));
+		/*clean the 0xFFFF in the lower bits (set in the add expansion)*/
+		tmp_dma_addr &= 0xFFFF0000; 
+		/* Set the original 16 bits */
+		tmp_dma_addr |= (orig_addr & UINT16_MAX); 
+		SSI_LOG_DEBUG("Release DMA: orig address=0x%llX "
+			     "dma_address=0x%llX\n",
+			     orig_addr, tmp_dma_addr);
+			return tmp_dma_addr;	
+	}
+	return orig_addr;
+}
+#endif
+/**
+ * ssi_buffer_mgr_get_sgl_nents() - Get scatterlist number of entries.
+ * 
+ * @sg_list: SG list
+ * @nbytes: [IN] Total SGL data bytes.
+ * @lbytes: [OUT] Returns the amount of bytes at the last entry 
+ */
+static unsigned int ssi_buffer_mgr_get_sgl_nents(
+	struct scatterlist *sg_list, unsigned int nbytes, uint32_t *lbytes, bool *is_chained)
+{
+	unsigned int nents = 0;
+	while (nbytes != 0) {
+		if (sg_is_chain(sg_list)) {
+			SSI_LOG_ERR("Unexpected chanined entry "
+				   "in sg (entry =0x%X) \n", nents);
+			BUG();
+		}
+		if (sg_list->length != 0) {
+			nents++;
+			/* get the number of bytes in the last entry */
+			*lbytes = nbytes;
+			nbytes -= ( sg_list->length > nbytes ) ? nbytes : sg_list->length;
+			sg_list = sg_next(sg_list);
+		} else {
+			sg_list = (struct scatterlist *)sg_page(sg_list);
+			if (is_chained != NULL) {
+				*is_chained = true;
+			}
+		}
+	}
+	SSI_LOG_DEBUG("nents %d last bytes %d\n",nents, *lbytes);
+	return nents;
+}
+
+/**
+ * ssi_buffer_mgr_zero_sgl() - Zero scatter scatter list data.
+ * 
+ * @sgl:
+ */
+void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, uint32_t data_len)
+{
+	struct scatterlist *current_sg = sgl;
+	int sg_index = 0;
+
+	while (sg_index <= data_len) {
+		if (current_sg == NULL) {
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
+ * ssi_buffer_mgr_copy_scatterlist_portion() - Copy scatter list data,
+ * from to_skip to end, to dest and vice versa
+ * 
+ * @dest:
+ * @sg:
+ * @to_skip:
+ * @end:
+ * @direct:
+ */
+void ssi_buffer_mgr_copy_scatterlist_portion(
+	u8 *dest, struct scatterlist *sg,
+	uint32_t to_skip,  uint32_t end,
+	enum ssi_sg_cpy_direct direct)
+{
+	uint32_t nents, lbytes;
+
+	nents = ssi_buffer_mgr_get_sgl_nents(sg, end, &lbytes, NULL);
+	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip), 0, (direct == SSI_SG_TO_BUF));
+}
+
+static inline int ssi_buffer_mgr_render_buff_to_mlli(
+	dma_addr_t buff_dma, uint32_t buff_size, uint32_t *curr_nents,
+	uint32_t **mlli_entry_pp)
+{
+	uint32_t *mlli_entry_p = *mlli_entry_pp;
+	uint32_t new_nents;;
+
+	/* Verify there is no memory overflow*/
+	new_nents = (*curr_nents + buff_size/CC_MAX_MLLI_ENTRY_SIZE + 1);
+	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES ) {
+		return -ENOMEM;
+	}
+
+	/*handle buffer longer than 64 kbytes */
+	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE ) {
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(buff_dma, CC_MAX_MLLI_ENTRY_SIZE);
+		LLI_SET_ADDR(mlli_entry_p,buff_dma);
+		LLI_SET_SIZE(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
+		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
+			   mlli_entry_p[LLI_WORD0_OFFSET],
+			   mlli_entry_p[LLI_WORD1_OFFSET]);
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(buff_dma);
+		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
+		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
+		mlli_entry_p = mlli_entry_p + 2;
+		(*curr_nents)++;
+	}
+	/*Last entry */
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(buff_dma, buff_size);
+	LLI_SET_ADDR(mlli_entry_p,buff_dma);
+	LLI_SET_SIZE(mlli_entry_p, buff_size);
+	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
+		   mlli_entry_p[LLI_WORD0_OFFSET],
+		   mlli_entry_p[LLI_WORD1_OFFSET]);
+	mlli_entry_p = mlli_entry_p + 2;
+	*mlli_entry_pp = mlli_entry_p;
+	(*curr_nents)++;
+	return 0;
+}
+
+
+static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
+	struct scatterlist *sgl, uint32_t sgl_data_len, uint32_t sglOffset, uint32_t *curr_nents,
+	uint32_t **mlli_entry_pp)
+{
+	struct scatterlist *curr_sgl = sgl;
+	uint32_t *mlli_entry_p = *mlli_entry_pp;
+	int32_t rc = 0;
+
+	for ( ; (curr_sgl != NULL) && (sgl_data_len != 0);
+	      curr_sgl = sg_next(curr_sgl)) {
+		uint32_t entry_data_len =
+			(sgl_data_len > sg_dma_len(curr_sgl) - sglOffset) ?
+				sg_dma_len(curr_sgl) - sglOffset : sgl_data_len ;
+		sgl_data_len -= entry_data_len;
+		rc = ssi_buffer_mgr_render_buff_to_mlli(
+			sg_dma_address(curr_sgl) + sglOffset, entry_data_len, curr_nents,
+			&mlli_entry_p);
+		if(rc != 0) {
+			return rc;
+		}
+		sglOffset=0;
+	}
+	*mlli_entry_pp = mlli_entry_p;
+	return 0;
+}
+
+static int ssi_buffer_mgr_generate_mlli (
+	struct device *dev,
+	struct buffer_array *sg_data,
+	struct mlli_params *mlli_params) __maybe_unused;
+
+static int ssi_buffer_mgr_generate_mlli(
+	struct device *dev,
+	struct buffer_array *sg_data,
+	struct mlli_params *mlli_params)
+{
+	uint32_t *mlli_p;
+	uint32_t total_nents = 0,prev_total_nents = 0;
+	int rc = 0, i;
+
+	SSI_LOG_DEBUG("NUM of SG's = %d\n", sg_data->num_of_buffers);
+
+	/* Allocate memory from the pointed pool */
+	mlli_params->mlli_virt_addr = dma_pool_alloc(
+			mlli_params->curr_pool, GFP_KERNEL,
+			&(mlli_params->mlli_dma_addr));
+	if (unlikely(mlli_params->mlli_virt_addr == NULL)) {
+		SSI_LOG_ERR("dma_pool_alloc() failed\n");
+		rc =-ENOMEM;
+		goto build_mlli_exit;
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(mlli_params->mlli_dma_addr, 
+						(MAX_NUM_OF_TOTAL_MLLI_ENTRIES*
+						LLI_ENTRY_BYTE_SIZE));
+	/* Point to start of MLLI */
+	mlli_p = (uint32_t *)mlli_params->mlli_virt_addr;
+	/* go over all SG's and link it to one MLLI table */
+	for (i = 0; i < sg_data->num_of_buffers; i++) {
+		if (sg_data->type[i] == DMA_SGL_TYPE)
+			rc = ssi_buffer_mgr_render_scatterlist_to_mlli(
+				sg_data->entry[i].sgl, 
+				sg_data->total_data_len[i], sg_data->offset[i], &total_nents,
+				&mlli_p);
+		else /*DMA_BUFF_TYPE*/
+			rc = ssi_buffer_mgr_render_buff_to_mlli(
+				sg_data->entry[i].buffer_dma,
+				sg_data->total_data_len[i], &total_nents,
+				&mlli_p);
+		if(rc != 0) {
+			return rc;
+		}
+
+		/* set last bit in the current table */
+		if (sg_data->mlli_nents[i] != NULL) {
+			/*Calculate the current MLLI table length for the 
+			length field in the descriptor*/
+			*(sg_data->mlli_nents[i]) += 
+				(total_nents - prev_total_nents);
+			prev_total_nents = total_nents;
+		}
+	}
+
+	/* Set MLLI size for the bypass operation */
+	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
+
+	SSI_LOG_DEBUG("MLLI params: "
+		     "virt_addr=%pK dma_addr=0x%llX mlli_len=0x%X\n",
+		   mlli_params->mlli_virt_addr,
+		   (unsigned long long)mlli_params->mlli_dma_addr,
+		   mlli_params->mlli_len);
+
+build_mlli_exit:
+	return rc;
+}
+
+static inline void ssi_buffer_mgr_add_buffer_entry(
+	struct buffer_array *sgl_data,
+	dma_addr_t buffer_dma, unsigned int buffer_len,
+	bool is_last_entry, uint32_t *mlli_nents)
+{
+	unsigned int index = sgl_data->num_of_buffers;
+
+	SSI_LOG_DEBUG("index=%u single_buff=0x%llX "
+		     "buffer_len=0x%08X is_last=%d\n",
+		     index, (unsigned long long)buffer_dma, buffer_len, is_last_entry);
+	sgl_data->nents[index] = 1;
+	sgl_data->entry[index].buffer_dma = buffer_dma;
+	sgl_data->offset[index] = 0;
+	sgl_data->total_data_len[index] = buffer_len;
+	sgl_data->type[index] = DMA_BUFF_TYPE;
+	sgl_data->is_last[index] = is_last_entry;
+	sgl_data->mlli_nents[index] = mlli_nents;
+	if (sgl_data->mlli_nents[index] != NULL)
+		*sgl_data->mlli_nents[index] = 0;
+	sgl_data->num_of_buffers++;
+}
+
+static inline void ssi_buffer_mgr_add_scatterlist_entry(
+	struct buffer_array *sgl_data,
+	unsigned int nents,
+	struct scatterlist *sgl,
+	unsigned int data_len,
+	unsigned int data_offset,
+	bool is_last_table,
+	uint32_t *mlli_nents)
+{
+	unsigned int index = sgl_data->num_of_buffers;
+
+	SSI_LOG_DEBUG("index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
+		     index, nents, sgl, data_len, is_last_table);
+	sgl_data->nents[index] = nents;
+	sgl_data->entry[index].sgl = sgl;
+	sgl_data->offset[index] = data_offset;
+	sgl_data->total_data_len[index] = data_len;
+	sgl_data->type[index] = DMA_SGL_TYPE;
+	sgl_data->is_last[index] = is_last_table;
+	sgl_data->mlli_nents[index] = mlli_nents;
+	if (sgl_data->mlli_nents[index] != NULL)
+		*sgl_data->mlli_nents[index] = 0;
+	sgl_data->num_of_buffers++;
+}
+
+static int
+ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, uint32_t nents,
+			 enum dma_data_direction direction)
+{
+	uint32_t i , j;
+	struct scatterlist *l_sg = sg;
+	for (i = 0; i < nents; i++) {
+		if (l_sg == NULL) {
+			break;
+		}
+		if (unlikely(dma_map_sg(dev, l_sg, 1, direction) != 1)){
+			SSI_LOG_ERR("dma_map_page() sg buffer failed\n");
+			goto err;
+		}
+		l_sg = sg_next(l_sg);
+	}
+	return nents;
+
+err:
+	/* Restore mapped parts */
+	for (j = 0; j < i; j++) {
+		if (sg == NULL) {
+			break;
+		}
+		dma_unmap_sg(dev,sg,1,direction);
+		sg = sg_next(sg);
+	}
+	return 0;
+}
+
+static int ssi_buffer_mgr_map_scatterlist (struct device *dev,
+	struct scatterlist *sg, unsigned int nbytes, int direction,
+	uint32_t *nents, uint32_t max_sg_nents, uint32_t *lbytes,
+	uint32_t *mapped_nents) __maybe_unused;
+
+static int ssi_buffer_mgr_map_scatterlist(
+	struct device *dev, struct scatterlist *sg,
+	unsigned int nbytes, int direction,
+	uint32_t *nents, uint32_t max_sg_nents,
+	uint32_t *lbytes, uint32_t *mapped_nents)
+{
+	bool is_chained = false;
+
+	if (sg_is_last(sg)) {
+		/* One entry only case -set to DLLI */
+		if (unlikely(dma_map_sg(dev, sg, 1, direction) != 1)) {
+			SSI_LOG_ERR("dma_map_sg() single buffer failed\n");
+			return -ENOMEM;
+		} 
+		SSI_LOG_DEBUG("Mapped sg: dma_address=0x%llX "
+			     "page_link=0x%08lX addr=%pK offset=%u "
+			     "length=%u\n",
+			     (unsigned long long)sg_dma_address(sg), 
+			     sg->page_link, 
+			     sg_virt(sg), 
+			     sg->offset, sg->length);
+		*lbytes = nbytes;
+		*nents = 1;
+		*mapped_nents = 1;
+		SSI_UPDATE_DMA_ADDR_TO_48BIT(sg_dma_address(sg), sg_dma_len(sg));
+	} else {  /*sg_is_last*/
+		*nents = ssi_buffer_mgr_get_sgl_nents(sg, nbytes, lbytes, 
+						     &is_chained);
+		if (*nents > max_sg_nents) {
+			*nents = 0;
+			SSI_LOG_ERR("Too many fragments. current %d max %d\n",
+				   *nents, max_sg_nents);
+			return -ENOMEM;
+		}
+		if (!is_chained) {
+			/* In case of mmu the number of mapped nents might
+			be changed from the original sgl nents */
+			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
+			if (unlikely(*mapped_nents == 0)){
+				*nents = 0;
+				SSI_LOG_ERR("dma_map_sg() sg buffer failed\n");
+				return -ENOMEM;
+			}
+		} else {
+			/*In this case the driver maps entry by entry so it
+			must have the same nents before and after map */
+			*mapped_nents = ssi_buffer_mgr_dma_map_sg(dev,
+								 sg,
+								 *nents,
+								 direction);
+			if (unlikely(*mapped_nents != *nents)){
+				*nents = *mapped_nents;
+				SSI_LOG_ERR("dma_map_sg() sg buffer failed\n");
+				return -ENOMEM;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
+{
+	struct buff_mgr_handle *buff_mgr_handle;
+	struct device *dev = &drvdata->plat_dev->dev;
+
+	buff_mgr_handle = (struct buff_mgr_handle *)
+		kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
+	if (buff_mgr_handle == NULL)
+		return -ENOMEM;
+
+	drvdata->buff_mgr_handle = buff_mgr_handle;
+
+	buff_mgr_handle->mlli_buffs_pool = dma_pool_create(
+				"dx_single_mlli_tables", dev,
+				MAX_NUM_OF_TOTAL_MLLI_ENTRIES * 
+				LLI_ENTRY_BYTE_SIZE,
+				MLLI_TABLE_MIN_ALIGNMENT, 0);
+
+	if (unlikely(buff_mgr_handle->mlli_buffs_pool == NULL))
+		goto error;
+
+	return 0;
+
+error:
+	ssi_buffer_mgr_fini(drvdata);
+	return -ENOMEM;
+}
+
+int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata)
+{
+	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
+
+	if (buff_mgr_handle  != NULL) {
+		if (buff_mgr_handle->mlli_buffs_pool != NULL)
+			dma_pool_destroy(buff_mgr_handle->mlli_buffs_pool);
+		kfree(drvdata->buff_mgr_handle);
+		drvdata->buff_mgr_handle = NULL;
+
+	}
+	return 0;
+}
+
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
new file mode 100644
index 0000000..9b74d81
--- /dev/null
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -0,0 +1,79 @@
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
+/* \file buffer_mgr.h
+   Buffer Manager
+ */
+
+#ifndef __SSI_BUFFER_MGR_H__
+#define __SSI_BUFFER_MGR_H__
+
+#include <crypto/algapi.h>
+
+#include "ssi_config.h"
+#include "ssi_driver.h"
+
+
+enum ssi_req_dma_buf_type {
+	SSI_DMA_BUF_NULL = 0,
+	SSI_DMA_BUF_DLLI,
+	SSI_DMA_BUF_MLLI
+};
+
+enum ssi_sg_cpy_direct {
+	SSI_SG_TO_BUF = 0,
+	SSI_SG_FROM_BUF = 1
+};
+
+struct ssi_mlli {
+	ssi_sram_addr_t sram_addr;
+	unsigned int nents; //sg nents
+	unsigned int mlli_nents; //mlli nents might be different than the above
+};
+
+struct mlli_params {
+	struct dma_pool *curr_pool;
+	uint8_t *mlli_virt_addr;
+	dma_addr_t mlli_dma_addr;
+	uint32_t mlli_len;  
+};
+
+int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata);
+
+int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata);
+
+void ssi_buffer_mgr_copy_scatterlist_portion(u8 *dest, struct scatterlist *sg, uint32_t to_skip, uint32_t end, enum ssi_sg_cpy_direct direct);
+
+void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, uint32_t data_len);
+
+
+#ifdef CC_DMA_48BIT_SIM
+dma_addr_t ssi_buff_mgr_update_dma_addr(dma_addr_t orig_addr, uint32_t data_len);
+dma_addr_t ssi_buff_mgr_restore_dma_addr(dma_addr_t orig_addr);
+
+#define SSI_UPDATE_DMA_ADDR_TO_48BIT(addr,size) addr = \
+					ssi_buff_mgr_update_dma_addr(addr,size)
+#define SSI_RESTORE_DMA_ADDR_TO_48BIT(addr) addr = \
+					ssi_buff_mgr_restore_dma_addr(addr)
+#else
+
+#define SSI_UPDATE_DMA_ADDR_TO_48BIT(addr,size) addr = addr
+#define SSI_RESTORE_DMA_ADDR_TO_48BIT(addr) addr = addr
+
+#endif
+
+#endif /*__BUFFER_MGR_H__*/
+
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
new file mode 100644
index 0000000..a775ea4
--- /dev/null
+++ b/drivers/staging/ccree/ssi_config.h
@@ -0,0 +1,61 @@
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
+/* \file ssi_config.h
+   Definitions for ARM CryptoCell Linux Crypto Driver
+ */
+
+#ifndef __SSI_CONFIG_H__
+#define __SSI_CONFIG_H__
+
+#include <linux/version.h>
+
+#define DISABLE_COHERENT_DMA_OPS
+//#define FLUSH_CACHE_ALL
+//#define COMPLETION_DELAY
+//#define DX_DUMP_DESCS
+// #define DX_DUMP_BYTES
+// #define CC_DEBUG
+#define ENABLE_CC_SYSFS		/* Enable sysfs interface for debugging REE driver */
+//#define ENABLE_CC_CYCLE_COUNT
+//#define DX_IRQ_DELAY 100000
+#define DMA_BIT_MASK_LEN	48	/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
+
+#if defined ENABLE_CC_CYCLE_COUNT && defined ENABLE_CC_SYSFS
+#define CC_CYCLE_COUNT
+#endif
+
+
+#if defined (CONFIG_ARM64)	// TODO currently only this mode was test on Juno (which is ARM64), need to enable coherent also.
+#define DISABLE_COHERENT_DMA_OPS
+#endif
+
+/* Define the CryptoCell DMA cache coherency signals configuration */
+#if defined (DISABLE_COHERENT_DMA_OPS)
+	/* Software Controlled Cache Coherency (SCCC) */ 
+	#define SSI_CACHE_PARAMS (0x000)
+	/* CC attached to NONE-ACP such as HPP/ACE/AMBA4.
+	 * The customer is responsible to enable/disable this feature
+	 * according to his platform type. */
+	#define DX_HAS_ACP 0
+#else
+	#define SSI_CACHE_PARAMS (0xEEE)
+	/* CC attached to ACP */
+	#define DX_HAS_ACP 1
+#endif
+
+#endif /*__DX_CONFIG_H__*/
+
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
new file mode 100644
index 0000000..e70ad07
--- /dev/null
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -0,0 +1,499 @@
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
+
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+#include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
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
+#include <linux/random.h>
+#include <linux/of.h>
+
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "ssi_request_mgr.h"
+#include "ssi_buffer_mgr.h"
+#include "ssi_sysfs.h"
+#include "ssi_sram_mgr.h"
+#include "ssi_pm.h"
+
+
+#ifdef DX_DUMP_BYTES
+void dump_byte_array(const char *name, const uint8_t *the_array, unsigned long size)
+{
+	int i , line_offset = 0, ret = 0;
+	const uint8_t *cur_byte;
+	char line_buf[80];
+
+	if (the_array == NULL) {
+		SSI_LOG_ERR("cannot dump_byte_array - NULL pointer\n");
+		return;
+	}
+
+	ret = snprintf(line_buf, sizeof(line_buf), "%s[%lu]: ",
+		name, size);
+	if (ret < 0) {
+		SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n",ret);
+		return;
+	}
+	line_offset = ret;
+	for (i = 0 , cur_byte = the_array;
+	     (i < size) && (line_offset < sizeof(line_buf)); i++, cur_byte++) {
+			ret = snprintf(line_buf + line_offset,
+					sizeof(line_buf) - line_offset,
+					"0x%02X ", *cur_byte);
+		if (ret < 0) {
+			SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n",ret);
+			return;
+		}
+		line_offset += ret;
+		if (line_offset > 75) { /* Cut before line end */
+			SSI_LOG_DEBUG("%s\n", line_buf);
+			line_offset = 0;
+		}
+	}
+
+	if (line_offset > 0) /* Dump remaining line */
+		SSI_LOG_DEBUG("%s\n", line_buf);
+}
+#endif
+
+static irqreturn_t cc_isr(int irq, void *dev_id)
+{
+	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)dev_id;
+	void __iomem *cc_base = drvdata->cc_base;
+	uint32_t irr;
+	uint32_t imr;
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
+	START_CYCLE_COUNT();
+
+	/* read the interrupt status */
+	irr = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
+	SSI_LOG_DEBUG("Got IRR=0x%08X\n", irr);
+	if (unlikely(irr == 0)) { /* Probably shared interrupt line */
+		SSI_LOG_ERR("Got interrupt with empty IRR\n");
+		return IRQ_NONE;
+	}
+	imr = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR));
+
+	/* clear interrupt - must be before processing events */
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), irr);
+
+	drvdata->irq = irr;
+	/* Completion interrupt - most probable */
+	if (likely((irr & SSI_COMP_IRQ_MASK) != 0)) {
+		/* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), imr | SSI_COMP_IRQ_MASK);
+		irr &= ~SSI_COMP_IRQ_MASK;
+		complete_request(drvdata);
+	}
+
+	/* AXI error interrupt */
+	if (unlikely((irr & SSI_AXI_ERR_IRQ_MASK) != 0)) {
+		uint32_t axi_err;
+		
+		/* Read the AXI error ID */
+		axi_err = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
+		SSI_LOG_DEBUG("AXI completion error: axim_mon_err=0x%08X\n", axi_err);
+		
+		irr &= ~SSI_AXI_ERR_IRQ_MASK;
+	}
+
+	if (unlikely(irr != 0)) {
+		SSI_LOG_DEBUG("IRR includes unknown cause bits (0x%08X)\n", irr);
+		/* Just warning */
+	}
+
+	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_0);
+	START_CYCLE_COUNT_AT(drvdata->isr_exit_cycles);
+
+	return IRQ_HANDLED;
+}
+
+int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
+{
+	unsigned int val;
+	void __iomem *cc_base = drvdata->cc_base;
+
+	/* Unmask all AXI interrupt sources AXI_CFG1 register */
+	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG));
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
+	SSI_LOG_DEBUG("AXIM_CFG=0x%08X\n", CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG)));
+
+	/* Clear all pending interrupts */
+	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
+	SSI_LOG_DEBUG("IRR=0x%08X\n", val);
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), val);
+
+	/* Unmask relevant interrupt cause */
+	val = (~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK | SSI_GPR0_IRQ_MASK));
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), val);
+		
+#ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
+#ifdef DX_IRQ_DELAY
+	/* Set CC IRQ delay */
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL),
+		DX_IRQ_DELAY);
+#endif
+	if (CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)) > 0) {
+		SSI_LOG_DEBUG("irq_delay=%d CC cycles\n",
+			CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)));
+	}
+#endif
+
+	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
+	if (is_probe == true) {
+		SSI_LOG_INFO("Cache params previous: 0x%08X\n", val);
+	}
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS), SSI_CACHE_PARAMS);
+	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
+	if (is_probe == true) {
+		SSI_LOG_INFO("Cache params current: 0x%08X  (expected: 0x%08X)\n", val, SSI_CACHE_PARAMS);
+	}
+
+	return 0;
+}
+
+static int init_cc_resources(struct platform_device *plat_dev)
+{
+	struct resource *req_mem_cc_regs = NULL;
+	void __iomem *cc_base = NULL;
+	bool irq_registered = false;
+	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
+	uint32_t signature_val;
+	int rc = 0;
+
+	if (unlikely(new_drvdata == NULL)) {
+		SSI_LOG_ERR("Failed to allocate drvdata");
+		rc = -ENOMEM;
+		goto init_cc_res_err;
+	}
+
+	new_drvdata->inflight_counter = 0;
+
+	dev_set_drvdata(&plat_dev->dev, new_drvdata);
+	/* Get device resources */
+	/* First CC registers space */
+	new_drvdata->res_mem = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (unlikely(new_drvdata->res_mem == NULL)) {
+		SSI_LOG_ERR("Failed getting IO memory resource\n");
+		rc = -ENODEV;
+		goto init_cc_res_err;
+	}
+	SSI_LOG_DEBUG("Got MEM resource (%s): start=0x%llX end=0x%llX\n",
+		new_drvdata->res_mem->name,
+		(unsigned long long)new_drvdata->res_mem->start,
+		(unsigned long long)new_drvdata->res_mem->end);
+	/* Map registers space */
+	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
+	if (unlikely(req_mem_cc_regs == NULL)) {
+		SSI_LOG_ERR("Couldn't allocate registers memory region at "
+			     "0x%08X\n", (unsigned int)new_drvdata->res_mem->start);
+		rc = -EBUSY;
+		goto init_cc_res_err;
+	}
+	cc_base = ioremap(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem));
+	if (unlikely(cc_base == NULL)) {
+		SSI_LOG_ERR("ioremap[CC](0x%08X,0x%08X) failed\n",
+			(unsigned int)new_drvdata->res_mem->start, (unsigned int)resource_size(new_drvdata->res_mem));
+		rc = -ENOMEM;
+		goto init_cc_res_err;
+	}
+	SSI_LOG_DEBUG("CC registers mapped from %pa to 0x%p\n", &new_drvdata->res_mem->start, cc_base);
+	new_drvdata->cc_base = cc_base;
+	
+
+	/* Then IRQ */
+	new_drvdata->res_irq = platform_get_resource(plat_dev, IORESOURCE_IRQ, 0);
+	if (unlikely(new_drvdata->res_irq == NULL)) {
+		SSI_LOG_ERR("Failed getting IRQ resource\n");
+		rc = -ENODEV;
+		goto init_cc_res_err;
+	}
+	rc = request_irq(new_drvdata->res_irq->start, cc_isr,
+			 IRQF_SHARED, "arm_cc7x", new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("Could not register to interrupt %llu\n",
+			(unsigned long long)new_drvdata->res_irq->start);
+		goto init_cc_res_err;
+	}
+	init_completion(&new_drvdata->icache_setup_completion);
+
+	irq_registered = true;
+	SSI_LOG_DEBUG("Registered to IRQ (%s) %llu\n",
+		new_drvdata->res_irq->name,
+		(unsigned long long)new_drvdata->res_irq->start);
+
+	new_drvdata->plat_dev = plat_dev;
+
+	if(new_drvdata->plat_dev->dev.dma_mask == NULL)
+	{
+		new_drvdata->plat_dev->dev.dma_mask = & new_drvdata->plat_dev->dev.coherent_dma_mask;
+	}
+	if (!new_drvdata->plat_dev->dev.coherent_dma_mask)
+	{
+		new_drvdata->plat_dev->dev.coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
+	}
+
+	/* Verify correct mapping */
+	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
+	if (signature_val != DX_DEV_SIGNATURE) {
+		SSI_LOG_ERR("Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
+			signature_val, (uint32_t)DX_DEV_SIGNATURE);
+		rc = -EINVAL;
+		goto init_cc_res_err;
+	}
+	SSI_LOG_DEBUG("CC SIGNATURE=0x%08X\n", signature_val);
+
+	/* Display HW versions */
+	SSI_LOG(KERN_INFO, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n", SSI_DEV_NAME_STR,
+		CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)), DRV_MODULE_VERSION);
+
+	rc = init_cc_regs(new_drvdata, true);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("init_cc_regs failed\n");
+		goto init_cc_res_err;
+	}
+
+#ifdef ENABLE_CC_SYSFS
+	rc = ssi_sysfs_init(&(plat_dev->dev.kobj), new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("init_stat_db failed\n");
+		goto init_cc_res_err;
+	}
+#endif
+
+	rc = ssi_sram_mgr_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("ssi_sram_mgr_init failed\n");
+		goto init_cc_res_err;
+	}
+
+	new_drvdata->mlli_sram_addr =
+		ssi_sram_mgr_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
+	if (unlikely(new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR)) {
+		SSI_LOG_ERR("Failed to alloc MLLI Sram buffer\n");
+		rc = -ENOMEM;
+		goto init_cc_res_err;
+	}
+
+	rc = request_mgr_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("request_mgr_init failed\n");
+		goto init_cc_res_err;
+	}
+
+	rc = ssi_buffer_mgr_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("buffer_mgr_init failed\n");
+		goto init_cc_res_err;
+	}
+
+	rc = ssi_power_mgr_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("ssi_power_mgr_init failed\n");
+		goto init_cc_res_err;
+	}
+
+	return 0;
+
+init_cc_res_err:
+	SSI_LOG_ERR("Freeing CC HW resources!\n");
+	
+	if (new_drvdata != NULL) {
+		ssi_power_mgr_fini(new_drvdata);
+		ssi_buffer_mgr_fini(new_drvdata);
+		request_mgr_fini(new_drvdata);
+		ssi_sram_mgr_fini(new_drvdata);
+#ifdef ENABLE_CC_SYSFS
+		ssi_sysfs_fini();
+#endif
+	
+		if (req_mem_cc_regs != NULL) {
+			if (irq_registered) {
+				free_irq(new_drvdata->res_irq->start, new_drvdata);
+				new_drvdata->res_irq = NULL;
+				iounmap(cc_base);
+				new_drvdata->cc_base = NULL;
+			}
+			release_mem_region(new_drvdata->res_mem->start,
+				resource_size(new_drvdata->res_mem));
+			new_drvdata->res_mem = NULL;
+		}
+		kfree(new_drvdata);
+		dev_set_drvdata(&plat_dev->dev, NULL);
+	}
+
+	return rc;
+}
+
+void fini_cc_regs(struct ssi_drvdata *drvdata)
+{
+	/* Mask all interrupts */
+	WRITE_REGISTER(drvdata->cc_base + 
+		       CC_REG_OFFSET(HOST_RGF, HOST_IMR), 0xFFFFFFFF);
+
+}
+
+static void cleanup_cc_resources(struct platform_device *plat_dev)
+{
+	struct ssi_drvdata *drvdata =
+		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
+
+	ssi_power_mgr_fini(drvdata);
+	ssi_buffer_mgr_fini(drvdata);
+	request_mgr_fini(drvdata);
+	ssi_sram_mgr_fini(drvdata);
+#ifdef ENABLE_CC_SYSFS
+	ssi_sysfs_fini();
+#endif
+
+	/* Mask all interrupts */
+	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_IMR),
+		0xFFFFFFFF);
+	free_irq(drvdata->res_irq->start, drvdata);
+	drvdata->res_irq = NULL;
+
+	fini_cc_regs(drvdata);
+
+	if (drvdata->cc_base != NULL) {
+		iounmap(drvdata->cc_base);
+		release_mem_region(drvdata->res_mem->start,
+			resource_size(drvdata->res_mem));
+		drvdata->cc_base = NULL;
+		drvdata->res_mem = NULL;
+	}
+
+	kfree(drvdata);
+	dev_set_drvdata(&plat_dev->dev, NULL);
+}
+
+static int cc7x_probe(struct platform_device *plat_dev)
+{
+	int rc;
+#if defined(CONFIG_ARM) && defined(CC_DEBUG)
+	uint32_t ctr, cacheline_size;
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	cacheline_size =  4 << ((ctr >> 16) & 0xf);
+	SSI_LOG_DEBUG("CP15(L1_CACHE_BYTES) = %u , Kconfig(L1_CACHE_BYTES) = %u\n",
+		cacheline_size, L1_CACHE_BYTES);
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 0" : "=r" (ctr));
+	SSI_LOG_DEBUG("Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X,"
+		     " Part 0x%03X, Rev r%dp%d\n",
+		(ctr>>24), (ctr>>16)&0xF, (ctr>>4)&0xFFF, (ctr>>20)&0xF, ctr&0xF);
+#endif
+
+	/* Map registers space */
+	rc = init_cc_resources(plat_dev);
+	if (rc != 0)
+		return rc;
+
+	SSI_LOG(KERN_INFO, "ARM cc7x_ree device initialized\n");
+
+	return 0;
+}
+
+static int cc7x_remove(struct platform_device *plat_dev)
+{
+	SSI_LOG_DEBUG("Releasing cc7x resources...\n");
+	
+	cleanup_cc_resources(plat_dev);
+
+	SSI_LOG(KERN_INFO, "ARM cc7x_ree device terminated\n");
+#ifdef ENABLE_CYCLE_COUNT
+	display_all_stat_db();
+#endif
+	
+	return 0;
+}
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+static struct dev_pm_ops arm_cc7x_driver_pm = {
+	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
+};
+#endif
+
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#define	DX_DRIVER_RUNTIME_PM	(&arm_cc7x_driver_pm)
+#else
+#define	DX_DRIVER_RUNTIME_PM	NULL
+#endif
+
+
+#ifdef CONFIG_OF
+static const struct of_device_id arm_cc7x_dev_of_match[] = {
+	{.compatible = "arm,cryptocell-712-ree"},
+	{}
+};
+MODULE_DEVICE_TABLE(of, arm_cc7x_dev_of_match);
+#endif
+
+static struct platform_driver cc7x_driver = {
+	.driver = {
+		   .name = "cc7xree",
+		   .owner = THIS_MODULE,
+#ifdef CONFIG_OF
+		   .of_match_table = arm_cc7x_dev_of_match,
+#endif
+		   .pm = DX_DRIVER_RUNTIME_PM,
+	},
+	.probe = cc7x_probe,
+	.remove = cc7x_remove,
+};
+module_platform_driver(cc7x_driver);
+
+/* Module description */
+MODULE_DESCRIPTION("ARM TrustZone CryptoCell REE Driver");
+MODULE_VERSION(DRV_MODULE_VERSION);
+MODULE_AUTHOR("ARM");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
new file mode 100644
index 0000000..c4ccbfa
--- /dev/null
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -0,0 +1,183 @@
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
+/* \file ssi_driver.h
+   ARM CryptoCell Linux Crypto Driver
+ */
+
+#ifndef __SSI_DRIVER_H__
+#define __SSI_DRIVER_H__
+
+#include "ssi_config.h"
+#ifdef COMP_IN_WQ
+#include <linux/workqueue.h>
+#else
+#include <linux/interrupt.h>
+#endif
+#include <linux/dma-mapping.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+#include <crypto/authenc.h>
+#include <linux/version.h>
+
+#ifndef INT32_MAX /* Missing in Linux kernel */
+#define INT32_MAX 0x7FFFFFFFL
+#endif
+
+/* Registers definitions from shared/hw/ree_include */
+#include "dx_reg_base_host.h"
+#include "dx_host.h"
+#define DX_CC_HOST_VIRT /* must be defined before including dx_cc_regs.h */
+#include "cc_hw_queue_defs.h"
+#include "cc_regs.h"
+#include "dx_reg_common.h"
+#include "cc_hal.h"
+#include "ssi_sram_mgr.h"
+#define CC_SUPPORT_SHA DX_DEV_SHA_MAX
+#include "cc_crypto_ctx.h"
+#include "ssi_sysfs.h"
+
+#define DRV_MODULE_VERSION "3.0"
+
+#define SSI_DEV_NAME_STR "cc715ree"
+#define SSI_CC_HAS_AES_CCM 1
+#define SSI_CC_HAS_AES_GCM 1
+#define SSI_CC_HAS_AES_XTS 1
+#define SSI_CC_HAS_AES_ESSIV 1
+#define SSI_CC_HAS_AES_BITLOCKER 1
+#define SSI_CC_HAS_AES_CTS 1
+#define SSI_CC_HAS_MULTI2 0
+#define SSI_CC_HAS_CMAC 1
+
+#define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | (1 << DX_AXIM_CFG_RRESPMASK_BIT_SHIFT) |	\
+			(1 << DX_AXIM_CFG_INFLTMASK_BIT_SHIFT) | (1 << DX_AXIM_CFG_COMPMASK_BIT_SHIFT))
+
+#define SSI_AXI_ERR_IRQ_MASK (1 << DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
+
+#define SSI_COMP_IRQ_MASK (1 << DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
+
+/* TEE FIPS status interrupt */
+#define SSI_GPR0_IRQ_MASK (1 << DX_HOST_IRR_GPR0_BIT_SHIFT)
+
+#define SSI_CRA_PRIO 3000
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
+   field in the HW descriptor. The DMA engine +8 that value. */
+
+/* Logging macros */
+#define SSI_LOG(level, format, ...) \
+	printk(level "cc715ree::%s: " format , __func__, ##__VA_ARGS__)
+#define SSI_LOG_ERR(format, ...) SSI_LOG(KERN_ERR, format, ##__VA_ARGS__)
+#define SSI_LOG_WARNING(format, ...) SSI_LOG(KERN_WARNING, format, ##__VA_ARGS__)
+#define SSI_LOG_NOTICE(format, ...) SSI_LOG(KERN_NOTICE, format, ##__VA_ARGS__)
+#define SSI_LOG_INFO(format, ...) SSI_LOG(KERN_INFO, format, ##__VA_ARGS__)
+#ifdef CC_DEBUG
+#define SSI_LOG_DEBUG(format, ...) SSI_LOG(KERN_DEBUG, format, ##__VA_ARGS__)
+#else /* Debug log messages are removed at compile time for non-DEBUG config. */
+#define SSI_LOG_DEBUG(format, ...) do {} while (0)
+#endif
+
+#define MIN(a, b) (((a) < (b)) ? (a) : (b))
+#define MAX(a, b) (((a) > (b)) ? (a) : (b))
+
+struct ssi_crypto_req {
+	void (*user_cb)(struct device *dev, void *req, void __iomem *cc_base);
+	void *user_arg;
+	struct completion seq_compl; /* request completion */
+#ifdef ENABLE_CYCLE_COUNT
+	enum stat_op op_type;
+	cycles_t submit_cycle;
+	bool is_monitored_p;
+#endif
+};
+
+/**
+ * struct ssi_drvdata - driver private data context
+ * @cc_base:	virt address of the CC registers
+ * @irq:	device IRQ number
+ * @irq_mask:	Interrupt mask shadow (1 for masked interrupts)
+ * @fw_ver:	SeP loaded firmware version
+ */
+struct ssi_drvdata {
+	struct resource *res_mem;
+	struct resource *res_irq;
+	void __iomem *cc_base;
+#ifdef DX_BASE_ENV_REGS
+	void __iomem *env_base; /* ARM CryptoCell development FPGAs only */
+#endif
+	unsigned int irq;
+	uint32_t irq_mask;
+	uint32_t fw_ver;
+	/* Calibration time of start/stop
+	*  monitor descriptors */
+	uint32_t monitor_null_cycles;
+	struct platform_device *plat_dev;
+	ssi_sram_addr_t mlli_sram_addr;
+	struct completion icache_setup_completion;
+	void *buff_mgr_handle;
+	void *request_mgr_handle;
+	void *sram_mgr_handle;
+
+#ifdef ENABLE_CYCLE_COUNT
+	cycles_t isr_exit_cycles; /* Save for isr-to-tasklet latency */
+#endif
+	uint32_t inflight_counter;
+
+};
+
+struct async_gen_req_ctx {
+	dma_addr_t iv_dma_addr;
+	enum drv_crypto_direction op_type;
+};
+
+#ifdef DX_DUMP_BYTES
+void dump_byte_array(const char *name, const uint8_t *the_array, unsigned long size);
+#else
+#define dump_byte_array(name, array, size) do {	\
+} while (0);
+#endif
+
+#ifdef ENABLE_CYCLE_COUNT
+#define DECL_CYCLE_COUNT_RESOURCES cycles_t _last_cycles_read
+#define START_CYCLE_COUNT() do { _last_cycles_read = get_cycles(); } while (0)
+#define END_CYCLE_COUNT(_stat_op_type, _stat_phase) update_host_stat(_stat_op_type, _stat_phase, get_cycles() - _last_cycles_read)
+#define GET_START_CYCLE_COUNT() _last_cycles_read
+#define START_CYCLE_COUNT_AT(_var) do { _var = get_cycles(); } while(0)
+#define END_CYCLE_COUNT_AT(_var, _stat_op_type, _stat_phase) update_host_stat(_stat_op_type, _stat_phase, get_cycles() - _var)
+#else
+#define DECL_CYCLE_COUNT_RESOURCES 
+#define START_CYCLE_COUNT() do { } while (0)
+#define END_CYCLE_COUNT(_stat_op_type, _stat_phase) do { } while (0)
+#define GET_START_CYCLE_COUNT() 0
+#define START_CYCLE_COUNT_AT(_var) do { } while (0)
+#define END_CYCLE_COUNT_AT(_var, _stat_op_type, _stat_phase) do { } while (0)
+#endif /*ENABLE_CYCLE_COUNT*/
+
+int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe);
+void fini_cc_regs(struct ssi_drvdata *drvdata);
+
+#endif /*__SSI_DRIVER_H__*/
+
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
new file mode 100644
index 0000000..8ee481b
--- /dev/null
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -0,0 +1,144 @@
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
+#include "ssi_config.h"
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <crypto/ctr.h>
+#include <linux/pm_runtime.h>
+#include "ssi_driver.h"
+#include "ssi_buffer_mgr.h"
+#include "ssi_request_mgr.h"
+#include "ssi_sram_mgr.h"
+#include "ssi_sysfs.h"
+#include "ssi_pm.h"
+#include "ssi_pm_ext.h"
+
+
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+
+#define POWER_DOWN_ENABLE 0x01
+#define POWER_DOWN_DISABLE 0x00
+
+
+int ssi_power_mgr_runtime_suspend(struct device *dev)
+{
+	struct ssi_drvdata *drvdata =
+		(struct ssi_drvdata *)dev_get_drvdata(dev);
+	int rc;
+
+	SSI_LOG_DEBUG("ssi_power_mgr_runtime_suspend: set HOST_POWER_DOWN_EN\n");
+	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
+	rc = ssi_request_mgr_runtime_suspend_queue(drvdata);
+	if (rc != 0) {
+		SSI_LOG_ERR("ssi_request_mgr_runtime_suspend_queue (%x)\n", rc);
+		return rc;
+	}
+	fini_cc_regs(drvdata);
+
+	/* Specific HW suspend code */
+	ssi_pm_ext_hw_suspend(dev);
+	return 0;
+}
+
+int ssi_power_mgr_runtime_resume(struct device *dev)
+{
+	int rc;
+	struct ssi_drvdata *drvdata =
+		(struct ssi_drvdata *)dev_get_drvdata(dev);
+
+	SSI_LOG_DEBUG("ssi_power_mgr_runtime_resume , unset HOST_POWER_DOWN_EN\n");
+	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
+	/* Specific HW resume code */
+	ssi_pm_ext_hw_resume(dev);
+
+	rc = init_cc_regs(drvdata, false);
+	if (rc !=0) {
+		SSI_LOG_ERR("init_cc_regs (%x)\n",rc);
+		return rc;
+	}
+
+	rc = ssi_request_mgr_runtime_resume_queue(drvdata);
+	if (rc !=0) {
+		SSI_LOG_ERR("ssi_request_mgr_runtime_resume_queue (%x)\n",rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+int ssi_power_mgr_runtime_get(struct device *dev)
+{
+	int rc = 0;
+
+	if (ssi_request_mgr_is_queue_runtime_suspend(
+				(struct ssi_drvdata *)dev_get_drvdata(dev))) {
+		rc = pm_runtime_get_sync(dev);
+	} else {
+		pm_runtime_get_noresume(dev);
+	}
+	return rc;
+}
+
+int ssi_power_mgr_runtime_put_suspend(struct device *dev)
+{
+	int rc = 0;
+
+	if (!ssi_request_mgr_is_queue_runtime_suspend(
+				(struct ssi_drvdata *)dev_get_drvdata(dev))) {
+		pm_runtime_mark_last_busy(dev);
+		rc = pm_runtime_put_autosuspend(dev);
+	}
+	else {
+		/* Something wrong happens*/
+		BUG();
+	}
+	return rc;
+
+}
+
+#endif
+
+
+
+int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
+{
+	int rc = 0;
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+	struct platform_device *plat_dev = drvdata->plat_dev;
+	/* must be before the enabling to avoid resdundent suspending */
+	pm_runtime_set_autosuspend_delay(&plat_dev->dev,SSI_SUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(&plat_dev->dev);
+	/* activate the PM module */
+	rc = pm_runtime_set_active(&plat_dev->dev);
+	if (rc != 0)
+		return rc;
+	/* enable the PM module*/
+	pm_runtime_enable(&plat_dev->dev);
+#endif
+	return rc;
+}
+
+void ssi_power_mgr_fini(struct ssi_drvdata *drvdata)
+{
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+	struct platform_device *plat_dev = drvdata->plat_dev;
+
+	pm_runtime_disable(&plat_dev->dev);
+#endif
+}
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
new file mode 100644
index 0000000..6998871
--- /dev/null
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -0,0 +1,46 @@
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
+/* \file ssi_pm.h
+    */
+
+#ifndef __SSI_POWER_MGR_H__
+#define __SSI_POWER_MGR_H__
+
+
+#include "ssi_config.h"
+#include "ssi_driver.h"
+
+
+#define SSI_SUSPEND_TIMEOUT 3000
+
+
+int ssi_power_mgr_init(struct ssi_drvdata *drvdata);
+
+void ssi_power_mgr_fini(struct ssi_drvdata *drvdata);
+
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+int ssi_power_mgr_runtime_suspend(struct device *dev);
+
+int ssi_power_mgr_runtime_resume(struct device *dev);
+
+int ssi_power_mgr_runtime_get(struct device *dev);
+
+int ssi_power_mgr_runtime_put_suspend(struct device *dev);
+#endif
+
+#endif /*__POWER_MGR_H__*/
+
diff --git a/drivers/staging/ccree/ssi_pm_ext.c b/drivers/staging/ccree/ssi_pm_ext.c
new file mode 100644
index 0000000..2450e07
--- /dev/null
+++ b/drivers/staging/ccree/ssi_pm_ext.c
@@ -0,0 +1,60 @@
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
+#include "ssi_config.h"
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <crypto/ctr.h>
+#include <linux/pm_runtime.h>
+#include "ssi_driver.h"
+#include "ssi_sram_mgr.h"
+#include "ssi_pm_ext.h"
+
+/*
+This function should suspend the HW (if possiable), It should be implemented by 
+the driver user. 
+The reference code clears the internal SRAM to imitate lose of state. 
+*/
+void ssi_pm_ext_hw_suspend(struct device *dev)
+{
+	struct ssi_drvdata *drvdata =
+		(struct ssi_drvdata *)dev_get_drvdata(dev);
+	unsigned int val;
+	void __iomem *cc_base = drvdata->cc_base;
+	unsigned int  sram_addr = 0;
+
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, SRAM_ADDR), sram_addr);
+
+	for (;sram_addr < SSI_CC_SRAM_SIZE ; sram_addr+=4) {
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, SRAM_DATA), 0x0);
+
+		do {
+			val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, SRAM_DATA_READY));
+		} while (!(val &0x1));
+	}
+}
+
+/*
+This function should resume the HW (if possiable).It should be implemented by 
+the driver user. 
+*/
+void ssi_pm_ext_hw_resume(struct device *dev)
+{
+	return;
+}
+
diff --git a/drivers/staging/ccree/ssi_pm_ext.h b/drivers/staging/ccree/ssi_pm_ext.h
new file mode 100644
index 0000000..52e8fc1
--- /dev/null
+++ b/drivers/staging/ccree/ssi_pm_ext.h
@@ -0,0 +1,33 @@
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
+/* \file ssi_pm_ext.h
+    */
+
+#ifndef __PM_EXT_H__
+#define __PM_EXT_H__
+
+
+#include "ssi_config.h"
+#include "ssi_driver.h"
+
+void ssi_pm_ext_hw_suspend(struct device *dev);
+
+void ssi_pm_ext_hw_resume(struct device *dev);
+
+
+#endif /*__POWER_MGR_H__*/
+
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
new file mode 100644
index 0000000..976a54c
--- /dev/null
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -0,0 +1,680 @@
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
+#include "ssi_config.h"
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <crypto/ctr.h>
+#ifdef FLUSH_CACHE_ALL
+#include <asm/cacheflush.h>
+#endif
+#include <linux/pm_runtime.h>
+#include "ssi_driver.h"
+#include "ssi_buffer_mgr.h"
+#include "ssi_request_mgr.h"
+#include "ssi_sysfs.h"
+#include "ssi_pm.h"
+
+#define SSI_MAX_POLL_ITER	10
+
+#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
+
+#ifdef CC_CYCLE_COUNT
+
+#define MONITOR_CNTR_BIT 0
+
+/**
+ * Monitor descriptor. 
+ * Used to measure CC performance. 
+ */
+#define INIT_CC_MONITOR_DESC(desc_p) \
+do { \
+	HW_DESC_INIT(desc_p); \
+	HW_DESC_SET_DIN_MONITOR_CNTR(desc_p); \
+} while (0)
+
+/** 
+ * Try adding monitor descriptor BEFORE enqueuing sequence.
+ */
+#define CC_CYCLE_DESC_HEAD(cc_base_addr, desc_p, lock_p, is_monitored_p) \
+do { \
+	if (!test_and_set_bit(MONITOR_CNTR_BIT, (lock_p))) { \
+		enqueue_seq((cc_base_addr), (desc_p), 1); \
+		*(is_monitored_p) = true; \
+	} else { \
+		*(is_monitored_p) = false; \
+	} \
+} while (0)
+
+/**
+ * If CC_CYCLE_DESC_HEAD was successfully added: 
+ * 1. Add memory barrier descriptor to ensure last AXI transaction.  
+ * 2. Add monitor descriptor to sequence tail AFTER enqueuing sequence.
+ */
+#define CC_CYCLE_DESC_TAIL(cc_base_addr, desc_p, is_monitored) \
+do { \
+	if ((is_monitored) == true) { \
+		HwDesc_s barrier_desc; \
+		HW_DESC_INIT(&barrier_desc); \
+		HW_DESC_SET_DIN_NO_DMA(&barrier_desc, 0, 0xfffff0); \
+		HW_DESC_SET_DOUT_NO_DMA(&barrier_desc, 0, 0, 1); \
+		enqueue_seq((cc_base_addr), &barrier_desc, 1); \
+		enqueue_seq((cc_base_addr), (desc_p), 1); \
+	} \
+} while (0)
+
+/**
+ * Try reading CC monitor counter value upon sequence complete. 
+ * Can only succeed if the lock_p is taken by the owner of the given request.
+ */
+#define END_CC_MONITOR_COUNT(cc_base_addr, stat_op_type, stat_phase, monitor_null_cycles, lock_p, is_monitored) \
+do { \
+	uint32_t elapsed_cycles; \
+	if ((is_monitored) == true) { \
+		elapsed_cycles = READ_REGISTER((cc_base_addr) + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_MEASURE_CNTR)); \
+		clear_bit(MONITOR_CNTR_BIT, (lock_p)); \
+		if (elapsed_cycles > 0) \
+			update_cc_stat(stat_op_type, stat_phase, (elapsed_cycles - monitor_null_cycles)); \
+	} \
+} while (0)
+
+#else /*CC_CYCLE_COUNT*/
+
+#define INIT_CC_MONITOR_DESC(desc_p) do { } while (0)
+#define CC_CYCLE_DESC_HEAD(cc_base_addr, desc_p, lock_p, is_monitored_p) do { } while (0)
+#define CC_CYCLE_DESC_TAIL(cc_base_addr, desc_p, is_monitored) do { } while (0)
+#define END_CC_MONITOR_COUNT(cc_base_addr, stat_op_type, stat_phase, monitor_null_cycles, lock_p, is_monitored) do { } while (0)
+#endif /*CC_CYCLE_COUNT*/
+
+
+struct ssi_request_mgr_handle {
+	/* Request manager resources */
+	unsigned int hw_queue_size; /* HW capability */
+	unsigned int min_free_hw_slots;
+	unsigned int max_used_sw_slots;
+	struct ssi_crypto_req req_queue[MAX_REQUEST_QUEUE_SIZE];
+	uint32_t req_queue_head;
+	uint32_t req_queue_tail;
+	uint32_t axi_completed;
+	uint32_t q_free_slots;
+	spinlock_t hw_lock;
+	HwDesc_s compl_desc;
+	uint8_t *dummy_comp_buff;
+	dma_addr_t dummy_comp_buff_dma;
+	HwDesc_s monitor_desc;
+	volatile unsigned long monitor_lock;
+#ifdef COMP_IN_WQ
+	struct workqueue_struct *workq;
+	struct delayed_work compwork;
+#else
+	struct tasklet_struct comptask;
+#endif
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+	bool is_runtime_suspended;
+#endif
+};
+
+static void comp_handler(unsigned long devarg);
+#ifdef COMP_IN_WQ
+static void comp_work_handler(struct work_struct *work);
+#endif
+
+void request_mgr_fini(struct ssi_drvdata *drvdata)
+{
+	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+
+	if (req_mgr_h == NULL)
+		return; /* Not allocated */
+
+	if (req_mgr_h->dummy_comp_buff_dma != 0) {
+		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_mgr_h->dummy_comp_buff_dma);
+		dma_free_coherent(&drvdata->plat_dev->dev,
+				  sizeof(uint32_t), req_mgr_h->dummy_comp_buff,
+				  req_mgr_h->dummy_comp_buff_dma);
+	}
+
+	SSI_LOG_DEBUG("max_used_hw_slots=%d\n", (req_mgr_h->hw_queue_size -
+						req_mgr_h->min_free_hw_slots) );
+	SSI_LOG_DEBUG("max_used_sw_slots=%d\n", req_mgr_h->max_used_sw_slots);
+
+#ifdef COMP_IN_WQ
+	flush_workqueue(req_mgr_h->workq);
+	destroy_workqueue(req_mgr_h->workq);
+#else
+	/* Kill tasklet */
+	tasklet_kill(&req_mgr_h->comptask);
+#endif
+	memset(req_mgr_h, 0, sizeof(struct ssi_request_mgr_handle));
+	kfree(req_mgr_h);
+	drvdata->request_mgr_handle = NULL;
+}
+
+int request_mgr_init(struct ssi_drvdata *drvdata)
+{
+#ifdef CC_CYCLE_COUNT
+	HwDesc_s monitor_desc[2];
+	struct ssi_crypto_req monitor_req = {0};
+#endif
+	struct ssi_request_mgr_handle *req_mgr_h;
+	int rc = 0;
+
+	req_mgr_h = kzalloc(sizeof(struct ssi_request_mgr_handle),GFP_KERNEL);
+	if (req_mgr_h == NULL) {
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+
+	drvdata->request_mgr_handle = req_mgr_h;
+
+	spin_lock_init(&req_mgr_h->hw_lock);
+#ifdef COMP_IN_WQ
+	SSI_LOG_DEBUG("Initializing completion workqueue\n");
+	req_mgr_h->workq = create_singlethread_workqueue("arm_cc7x_wq");
+	if (unlikely(req_mgr_h->workq == NULL)) {
+		SSI_LOG_ERR("Failed creating work queue\n");
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
+#else
+	SSI_LOG_DEBUG("Initializing completion tasklet\n");
+	tasklet_init(&req_mgr_h->comptask, comp_handler, (unsigned long)drvdata);
+#endif
+	req_mgr_h->hw_queue_size = READ_REGISTER(drvdata->cc_base +
+		CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_SRAM_SIZE));
+	SSI_LOG_DEBUG("hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
+	if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
+		SSI_LOG_ERR("Invalid HW queue size = %u (Min. required is %u)\n",
+			req_mgr_h->hw_queue_size, MIN_HW_QUEUE_SIZE);
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	req_mgr_h->min_free_hw_slots = req_mgr_h->hw_queue_size;
+	req_mgr_h->max_used_sw_slots = 0;
+
+
+	/* Allocate DMA word for "dummy" completion descriptor use */
+	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(&drvdata->plat_dev->dev,
+		sizeof(uint32_t), &req_mgr_h->dummy_comp_buff_dma, GFP_KERNEL);
+	if (!req_mgr_h->dummy_comp_buff) {
+		SSI_LOG_ERR("Not enough memory to allocate DMA (%zu) dropped "
+			   "buffer\n", sizeof(uint32_t));
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(req_mgr_h->dummy_comp_buff_dma,
+							     sizeof(uint32_t));
+
+	/* Init. "dummy" completion descriptor */
+	HW_DESC_INIT(&req_mgr_h->compl_desc);
+	HW_DESC_SET_DIN_CONST(&req_mgr_h->compl_desc, 0, sizeof(uint32_t));
+	HW_DESC_SET_DOUT_DLLI(&req_mgr_h->compl_desc,
+		req_mgr_h->dummy_comp_buff_dma,
+		sizeof(uint32_t), NS_BIT, 1);
+	HW_DESC_SET_FLOW_MODE(&req_mgr_h->compl_desc, BYPASS);
+	HW_DESC_SET_QUEUE_LAST_IND(&req_mgr_h->compl_desc);
+
+#ifdef CC_CYCLE_COUNT
+	/* For CC-HW cycle performance trace */
+	INIT_CC_MONITOR_DESC(&req_mgr_h->monitor_desc);
+	set_bit(MONITOR_CNTR_BIT, &req_mgr_h->monitor_lock);
+	monitor_desc[0] = req_mgr_h->monitor_desc;
+	monitor_desc[1] = req_mgr_h->monitor_desc;
+
+	rc = send_request(drvdata, &monitor_req, monitor_desc, 2, 0);
+	if (unlikely(rc != 0))
+		goto req_mgr_init_err;
+
+	drvdata->monitor_null_cycles = READ_REGISTER(drvdata->cc_base +
+		CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_MEASURE_CNTR));
+	SSI_LOG_ERR("Calibration time=0x%08x\n", drvdata->monitor_null_cycles);
+
+	clear_bit(MONITOR_CNTR_BIT, &req_mgr_h->monitor_lock);
+#endif
+
+	return 0;
+
+req_mgr_init_err:
+	request_mgr_fini(drvdata);
+	return rc;
+}
+
+static inline void enqueue_seq(
+	void __iomem *cc_base,
+	HwDesc_s seq[], unsigned int seq_len)
+{
+	int i;
+
+	for (i = 0; i < seq_len; i++) {
+		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		wmb();
+		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+#ifdef DX_DUMP_DESCS
+		SSI_LOG_DEBUG("desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n", i,
+			seq[i].word[0], seq[i].word[1], seq[i].word[2], seq[i].word[3], seq[i].word[4], seq[i].word[5]);
+#endif
+	}
+}
+
+/*!
+ * Completion will take place if and only if user requested completion 
+ * by setting "is_dout = 0" in send_request().  
+ * 
+ * \param dev 
+ * \param dx_compl_h The completion event to signal
+ */
+static void request_mgr_complete(struct device *dev, void *dx_compl_h, void __iomem *cc_base)
+{
+	struct completion *this_compl = dx_compl_h;
+	complete(this_compl);
+}
+
+
+static inline int request_mgr_queues_status_check(
+		struct ssi_request_mgr_handle *req_mgr_h,
+		void __iomem *cc_base,
+		unsigned int total_seq_len)
+{
+	unsigned long poll_queue;
+	
+	/* SW queue is checked only once as it will not 
+	   be chaned during the poll becasue the spinlock_bh 
+	   is held by the thread */
+	if (unlikely(((req_mgr_h->req_queue_head + 1) &
+		      (MAX_REQUEST_QUEUE_SIZE - 1)) == 
+		     req_mgr_h->req_queue_tail)) {
+		SSI_LOG_ERR("SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n", 
+			   req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
+		return -EBUSY;
+	}
+
+	if ((likely(req_mgr_h->q_free_slots >= total_seq_len)) ) {
+		return 0;
+	}
+	/* Wait for space in HW queue. Poll constant num of iterations. */
+	for (poll_queue =0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue ++) {
+		req_mgr_h->q_free_slots = 
+			CC_HAL_READ_REGISTER(
+				CC_REG_OFFSET(CRY_KERNEL,
+						 DSCRPTR_QUEUE_CONTENT));
+		if (unlikely(req_mgr_h->q_free_slots < 
+						req_mgr_h->min_free_hw_slots)) {
+			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
+		}
+
+		if (likely (req_mgr_h->q_free_slots >= total_seq_len)) {
+			/* If there is enough place return */
+			return 0;
+		}
+
+		SSI_LOG_DEBUG("HW FIFO is full. q_free_slots=%d total_seq_len=%d\n", 
+			req_mgr_h->q_free_slots, total_seq_len);
+	}
+	/* No room in the HW queue try again later */
+	SSI_LOG_DEBUG("HW FIFO full, timeout. req_queue_head=%d "
+		   "sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n", 
+		     req_mgr_h->req_queue_head,
+		   MAX_REQUEST_QUEUE_SIZE,
+		   req_mgr_h->q_free_slots,
+		   total_seq_len);
+	return -EAGAIN;
+}
+
+/*!
+ * Enqueue caller request to crypto hardware.
+ * 
+ * \param drvdata 
+ * \param ssi_req The request to enqueue
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ * \param is_dout If "true": completion is handled by the caller 
+ *      	  If "false": this function adds a dummy descriptor completion
+ *      	  and waits upon completion signal.
+ * 
+ * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
+ */
+int send_request(
+	struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
+	HwDesc_s *desc, unsigned int len, bool is_dout)
+{
+	void __iomem *cc_base = drvdata->cc_base;
+	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	unsigned int used_sw_slots;
+	unsigned int total_seq_len = len; /*initial sequence length*/
+	int rc;
+	unsigned int max_required_seq_len = total_seq_len + ((is_dout == 0) ? 1 : 0);
+	DECL_CYCLE_COUNT_RESOURCES;
+
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+	rc = ssi_power_mgr_runtime_get(&drvdata->plat_dev->dev);
+	if (rc != 0) {
+		SSI_LOG_ERR("ssi_power_mgr_runtime_get returned %x\n",rc);
+		spin_unlock_bh(&req_mgr_h->hw_lock);
+		return rc;
+	}
+#endif
+
+	do {
+		spin_lock_bh(&req_mgr_h->hw_lock);
+
+		/* Check if there is enough place in the SW/HW queues
+		in case iv gen add the max size and in case of no dout add 1 
+		for the internal completion descriptor */
+		rc = request_mgr_queues_status_check(req_mgr_h,
+					       cc_base,
+					       max_required_seq_len);
+		if (likely(rc == 0 ))
+			/* There is enough place in the queue */
+			break;
+		/* something wrong release the spinlock*/
+		spin_unlock_bh(&req_mgr_h->hw_lock);
+
+		if (rc != -EAGAIN) {
+			/* Any error other than HW queue full 
+			   (SW queue is full) */
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
+#endif
+			return rc;
+		}
+
+		/* HW queue is full - short sleep */
+		msleep(1);
+	} while (1);
+
+	/* Additional completion descriptor is needed incase caller did not
+	   enabled any DLLI/MLLI DOUT bit in the given sequence */
+	if (!is_dout) {
+		init_completion(&ssi_req->seq_compl);
+		ssi_req->user_cb = request_mgr_complete;
+		ssi_req->user_arg = &(ssi_req->seq_compl);
+		total_seq_len++;
+	}
+
+	used_sw_slots = ((req_mgr_h->req_queue_head - req_mgr_h->req_queue_tail) & (MAX_REQUEST_QUEUE_SIZE-1));
+	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots)) {
+		req_mgr_h->max_used_sw_slots = used_sw_slots;
+	}
+	
+	CC_CYCLE_DESC_HEAD(cc_base, &req_mgr_h->monitor_desc,
+			&req_mgr_h->monitor_lock, &ssi_req->is_monitored_p);
+
+	/* Enqueue request - must be locked with HW lock*/
+	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *ssi_req;
+	START_CYCLE_COUNT_AT(req_mgr_h->req_queue[req_mgr_h->req_queue_head].submit_cycle);
+	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+	/* TODO: Use circ_buf.h ? */
+
+	SSI_LOG_DEBUG("Enqueue request head=%u\n", req_mgr_h->req_queue_head);
+
+#ifdef FLUSH_CACHE_ALL
+	flush_cache_all();
+#endif
+
+	/* STAT_PHASE_4: Push sequence */
+	START_CYCLE_COUNT();
+	enqueue_seq(cc_base, desc, len);
+	enqueue_seq(cc_base, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
+	END_CYCLE_COUNT(ssi_req->op_type, STAT_PHASE_4);
+
+	CC_CYCLE_DESC_TAIL(cc_base, &req_mgr_h->monitor_desc, ssi_req->is_monitored_p);
+
+	if (unlikely(req_mgr_h->q_free_slots < total_seq_len)) {
+		/*This means that there was a problem with the resume*/
+		BUG();
+	}
+	/* Update the free slots in HW queue */
+	req_mgr_h->q_free_slots -= total_seq_len;
+
+	spin_unlock_bh(&req_mgr_h->hw_lock);
+
+	if (!is_dout) {
+		/* Wait upon sequence completion.
+		*  Return "0" -Operation done successfully. */
+		return wait_for_completion_interruptible(&ssi_req->seq_compl);
+	} else {
+		/* Operation still in process */
+		return -EINPROGRESS;
+	}
+}
+
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
+int send_request_init(
+	struct ssi_drvdata *drvdata, HwDesc_s *desc, unsigned int len)
+{
+	void __iomem *cc_base = drvdata->cc_base;
+	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	unsigned int total_seq_len = len; /*initial sequence length*/
+	int rc = 0;
+
+	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
+	rc = request_mgr_queues_status_check(req_mgr_h, cc_base, total_seq_len);
+	if (unlikely(rc != 0 )) {
+		return rc;
+	}
+	HW_DESC_SET_QUEUE_LAST_IND(&desc[len-1]);
+
+	enqueue_seq(cc_base, desc, len);
+
+	/* Update the free slots in HW queue */
+	req_mgr_h->q_free_slots = CC_HAL_READ_REGISTER(
+					CC_REG_OFFSET(CRY_KERNEL,
+					 DSCRPTR_QUEUE_CONTENT));
+
+	return 0;
+}
+
+
+void complete_request(struct ssi_drvdata *drvdata)
+{
+	struct ssi_request_mgr_handle *request_mgr_handle = 
+						drvdata->request_mgr_handle;
+#ifdef COMP_IN_WQ
+	queue_delayed_work(request_mgr_handle->workq, &request_mgr_handle->compwork, 0);
+#else
+	tasklet_schedule(&request_mgr_handle->comptask);
+#endif
+}
+
+#ifdef COMP_IN_WQ
+static void comp_work_handler(struct work_struct *work)
+{
+	struct ssi_drvdata *drvdata =
+		container_of(work, struct ssi_drvdata, compwork.work);
+
+	comp_handler((unsigned long)drvdata);
+}
+#endif
+
+static void proc_completions(struct ssi_drvdata *drvdata)
+{
+	struct ssi_crypto_req *ssi_req;
+	struct platform_device *plat_dev = drvdata->plat_dev;
+	struct ssi_request_mgr_handle * request_mgr_handle = 
+						drvdata->request_mgr_handle;
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+	int rc = 0;
+#endif
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	while(request_mgr_handle->axi_completed) {
+		request_mgr_handle->axi_completed--;
+
+		/* Dequeue request */
+		if (unlikely(request_mgr_handle->req_queue_head == request_mgr_handle->req_queue_tail)) {
+			SSI_LOG_ERR("Request queue is empty req_queue_head==req_queue_tail==%u\n", request_mgr_handle->req_queue_head);
+			BUG();
+		}
+
+		ssi_req = &request_mgr_handle->req_queue[request_mgr_handle->req_queue_tail];
+		END_CYCLE_COUNT_AT(ssi_req->submit_cycle, ssi_req->op_type, STAT_PHASE_5); /* Seq. Comp. */
+		END_CC_MONITOR_COUNT(drvdata->cc_base, ssi_req->op_type, STAT_PHASE_6,
+			drvdata->monitor_null_cycles, &request_mgr_handle->monitor_lock, ssi_req->is_monitored_p);
+
+#ifdef FLUSH_CACHE_ALL
+		flush_cache_all();
+#endif
+
+#ifdef COMPLETION_DELAY
+		/* Delay */
+		{
+			uint32_t axi_err;
+			int i;
+			SSI_LOG_INFO("Delay\n");
+			for (i=0;i<1000000;i++) {
+				axi_err = READ_REGISTER(drvdata->cc_base + CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
+			}
+		}
+#endif /* COMPLETION_DELAY */
+
+		if (likely(ssi_req->user_cb != NULL)) {
+			START_CYCLE_COUNT();
+			ssi_req->user_cb(&plat_dev->dev, ssi_req->user_arg, drvdata->cc_base);
+			END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_3);
+		}
+		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
+		SSI_LOG_DEBUG("Request completed. axi_completed=%d\n", request_mgr_handle->axi_completed);
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+		rc = ssi_power_mgr_runtime_put_suspend(&plat_dev->dev);
+		if (rc != 0) {
+			SSI_LOG_ERR("Failed to set runtime suspension %d\n",rc);
+		}
+#endif
+	}
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void comp_handler(unsigned long devarg)
+{
+	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
+	void __iomem *cc_base = drvdata->cc_base;
+	struct ssi_request_mgr_handle * request_mgr_handle = 
+						drvdata->request_mgr_handle;
+
+	uint32_t irq;
+
+	DECL_CYCLE_COUNT_RESOURCES;
+
+	START_CYCLE_COUNT();
+
+	irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
+
+	if (irq & SSI_COMP_IRQ_MASK) {
+		/* To avoid the interrupt from firing as we unmask it, we clear it now */
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
+	
+		/* Avoid race with above clear: Test completion counter once more */
+		request_mgr_handle->axi_completed += CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE, 
+			CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+	
+		/* ISR-to-Tasklet latency */
+		if (request_mgr_handle->axi_completed) {
+			/* Only if actually reflects ISR-to-completion-handling latency, i.e.,
+			   not duplicate as a result of interrupt after AXIM_MON_ERR clear, before end of loop */
+			END_CYCLE_COUNT_AT(drvdata->isr_exit_cycles, STAT_OP_TYPE_GENERIC, STAT_PHASE_1);
+		}
+	
+		while (request_mgr_handle->axi_completed) {
+			do {
+				proc_completions(drvdata);
+				/* At this point (after proc_completions()), request_mgr_handle->axi_completed is always 0.
+				   The following assignment was changed to = (previously was +=) to conform KW restrictions. */
+				request_mgr_handle->axi_completed = CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE, 
+					CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+			} while (request_mgr_handle->axi_completed > 0);
+	
+			/* To avoid the interrupt from firing as we unmask it, we clear it now */
+			CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
+			
+			/* Avoid race with above clear: Test completion counter once more */
+			request_mgr_handle->axi_completed += CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE, 
+				CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+		};
+	
+	}
+	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), 
+		CC_HAL_READ_REGISTER(
+		CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
+	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_2);
+}
+
+/*
+resume the queue configuration - no need to take the lock as this happens inside
+the spin lock protection
+*/
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
+{
+	struct ssi_request_mgr_handle * request_mgr_handle = drvdata->request_mgr_handle;
+
+	spin_lock_bh(&request_mgr_handle->hw_lock);
+	request_mgr_handle->is_runtime_suspended = false;
+	spin_unlock_bh(&request_mgr_handle->hw_lock);
+
+	return 0 ;
+}
+
+/*
+suspend the queue configuration. Since it is used for the runtime suspend
+only verify that the queue can be suspended.
+*/
+int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata)
+{
+	struct ssi_request_mgr_handle * request_mgr_handle = 
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
+bool ssi_request_mgr_is_queue_runtime_suspend(struct ssi_drvdata *drvdata)
+{
+	struct ssi_request_mgr_handle * request_mgr_handle = 
+						drvdata->request_mgr_handle;
+
+	return 	request_mgr_handle->is_runtime_suspended;
+}
+
+#endif
+
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
new file mode 100644
index 0000000..f4bfeca
--- /dev/null
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -0,0 +1,60 @@
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
+/* \file request_mgr.h
+   Request Manager
+ */
+
+#ifndef __REQUEST_MGR_H__
+#define __REQUEST_MGR_H__
+
+#include "cc_hw_queue_defs.h"
+
+int request_mgr_init(struct ssi_drvdata *drvdata);
+
+/*!
+ * Enqueue caller request to crypto hardware.
+ * 
+ * \param drvdata 
+ * \param ssi_req The request to enqueue
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ * \param is_dout If "true": completion is handled by the caller 
+ *      	  If "false": this function adds a dummy descriptor completion
+ *      	  and waits upon completion signal.
+ * 
+ * \return int Returns -EINPROGRESS if "is_dout=ture"; "0" if "is_dout=false"
+ */
+int send_request(
+	struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
+	HwDesc_s *desc, unsigned int len, bool is_dout);
+
+int send_request_init(
+	struct ssi_drvdata *drvdata, HwDesc_s *desc, unsigned int len);
+
+void complete_request(struct ssi_drvdata *drvdata);
+
+void request_mgr_fini(struct ssi_drvdata *drvdata);
+
+#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata);
+
+int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata);
+
+bool ssi_request_mgr_is_queue_runtime_suspend(struct ssi_drvdata *drvdata);
+#endif
+
+#endif /*__REQUEST_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
new file mode 100644
index 0000000..36be53e
--- /dev/null
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -0,0 +1,138 @@
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
+#include "ssi_driver.h"
+#include "ssi_sram_mgr.h"
+
+
+/**
+ * struct ssi_sram_mgr_ctx -Internal RAM context manager
+ * @sram_free_offset:   the offset to the non-allocated area
+ */
+struct ssi_sram_mgr_ctx {
+	ssi_sram_addr_t sram_free_offset;
+};
+
+
+/**
+ * ssi_sram_mgr_fini() - Cleanup SRAM pool.
+ * 
+ * @drvdata: Associated device driver context
+ */
+void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata)
+{
+	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
+
+	/* Free "this" context */
+	if (smgr_ctx != NULL) {
+		memset(smgr_ctx, 0, sizeof(struct ssi_sram_mgr_ctx));
+		kfree(smgr_ctx);
+	}
+}
+
+/**
+ * ssi_sram_mgr_init() - Initializes SRAM pool. 
+ *      The pool starts right at the beginning of SRAM.
+ *      Returns zero for success, negative value otherwise.
+ * 
+ * @drvdata: Associated device driver context
+ */
+int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
+{
+	struct ssi_sram_mgr_ctx *smgr_ctx;
+	int rc;
+
+	/* Allocate "this" context */
+	drvdata->sram_mgr_handle = kzalloc(
+			sizeof(struct ssi_sram_mgr_ctx), GFP_KERNEL);
+	if (!drvdata->sram_mgr_handle) {
+		SSI_LOG_ERR("Not enough memory to allocate SRAM_MGR ctx (%zu)\n",
+			sizeof(struct ssi_sram_mgr_ctx));
+		rc = -ENOMEM;
+		goto out;
+	}
+	smgr_ctx = drvdata->sram_mgr_handle;
+
+	/* Pool starts at start of SRAM */
+	smgr_ctx->sram_free_offset = 0;
+
+	return 0;
+
+out:
+	ssi_sram_mgr_fini(drvdata);
+	return rc;
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
+ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, uint32_t size)
+{
+	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
+	ssi_sram_addr_t p;
+
+	if (unlikely((size & 0x3) != 0)) {
+		SSI_LOG_ERR("Requested buffer size (%u) is not multiple of 4",
+			size);
+		return NULL_SRAM_ADDR;
+	}
+	if (unlikely(size > (SSI_CC_SRAM_SIZE - smgr_ctx->sram_free_offset))) {
+		SSI_LOG_ERR("Not enough space to allocate %u B (at offset %llu)\n",
+			size, smgr_ctx->sram_free_offset);
+		return NULL_SRAM_ADDR;
+	}
+	
+	p = smgr_ctx->sram_free_offset;
+	smgr_ctx->sram_free_offset += size;
+	SSI_LOG_DEBUG("Allocated %u B @ %u\n", size, (unsigned int)p);
+	return p;
+}
+
+/**
+ * ssi_sram_mgr_const2sram_desc() - Create const descriptors sequence to
+ *	set values in given array into SRAM. 
+ * Note: each const value can't exceed word size.
+ * 
+ * @src:	  A pointer to array of words to set as consts.
+ * @dst:	  The target SRAM buffer to set into
+ * @nelements:	  The number of words in "src" array
+ * @seq:	  A pointer to the given IN/OUT descriptor sequence
+ * @seq_len:	  A pointer to the given IN/OUT sequence length
+ */
+void ssi_sram_mgr_const2sram_desc(
+	const uint32_t *src, ssi_sram_addr_t dst,
+	unsigned int nelement,
+	HwDesc_s *seq, unsigned int *seq_len)
+{
+	uint32_t i;
+	unsigned int idx = *seq_len;
+
+	for (i = 0; i < nelement; i++, idx++) {
+		HW_DESC_INIT(&seq[idx]);
+		HW_DESC_SET_DIN_CONST(&seq[idx], src[i], sizeof(uint32_t));
+		HW_DESC_SET_DOUT_SRAM(&seq[idx], dst + (i * sizeof(uint32_t)), sizeof(uint32_t));
+		HW_DESC_SET_FLOW_MODE(&seq[idx], BYPASS);
+	}
+
+	*seq_len = idx;
+}
+
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
new file mode 100644
index 0000000..90324d9
--- /dev/null
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -0,0 +1,80 @@
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
+#ifndef __SSI_SRAM_MGR_H__
+#define __SSI_SRAM_MGR_H__
+
+
+#ifndef SSI_CC_SRAM_SIZE
+#define SSI_CC_SRAM_SIZE 4096
+#endif
+
+struct ssi_drvdata;
+
+/**
+ * Address (offset) within CC internal SRAM
+ */
+
+typedef uint64_t ssi_sram_addr_t;
+
+#define NULL_SRAM_ADDR ((ssi_sram_addr_t)-1)
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
+int ssi_sram_mgr_init(struct ssi_drvdata *drvdata);
+
+/*!
+ * Uninits SRAM pool.
+ * 
+ * \param drvdata 
+ */
+void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata);
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
+ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, uint32_t size);
+
+/**
+ * ssi_sram_mgr_const2sram_desc() - Create const descriptors sequence to
+ *	set values in given array into SRAM. 
+ * Note: each const value can't exceed word size.
+ * 
+ * @src:	  A pointer to array of words to set as consts.
+ * @dst:	  The target SRAM buffer to set into
+ * @nelements:	  The number of words in "src" array
+ * @seq:	  A pointer to the given IN/OUT descriptor sequence
+ * @seq_len:	  A pointer to the given IN/OUT sequence length
+ */
+void ssi_sram_mgr_const2sram_desc(
+	const uint32_t *src, ssi_sram_addr_t dst,
+	unsigned int nelement,
+	HwDesc_s *seq, unsigned int *seq_len);
+
+#endif /*__SSI_SRAM_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
new file mode 100644
index 0000000..fdcbfa8
--- /dev/null
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -0,0 +1,440 @@
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
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "cc_crypto_ctx.h"
+#include "ssi_sysfs.h"
+
+#ifdef ENABLE_CC_SYSFS
+
+static struct ssi_drvdata *sys_get_drvdata(void);
+
+#ifdef CC_CYCLE_COUNT
+
+#include <asm/timex.h>
+
+struct stat_item {
+	unsigned int min;
+	unsigned int max;
+	cycles_t sum;
+	unsigned int count;
+};
+
+struct stat_name {
+	const char *op_type_name;
+	const char *stat_phase_name[MAX_STAT_PHASES];
+};
+
+static struct stat_name stat_name_db[MAX_STAT_OP_TYPES] = 
+{
+	{
+		/* STAT_OP_TYPE_NULL */
+		.op_type_name = "NULL",
+		.stat_phase_name = {NULL},
+	},
+	{
+		.op_type_name = "Encode",
+		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
+		.stat_phase_name[STAT_PHASE_1] = "Map buffers", 
+		.stat_phase_name[STAT_PHASE_2] = "Create sequence", 
+		.stat_phase_name[STAT_PHASE_3] = "Send Request",
+		.stat_phase_name[STAT_PHASE_4] = "HW-Q push",
+		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
+		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
+	},
+	{	.op_type_name = "Decode",
+		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
+		.stat_phase_name[STAT_PHASE_1] = "Map buffers", 
+		.stat_phase_name[STAT_PHASE_2] = "Create sequence", 
+		.stat_phase_name[STAT_PHASE_3] = "Send Request",
+		.stat_phase_name[STAT_PHASE_4] = "HW-Q push",
+		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
+		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
+	},
+	{ 	.op_type_name = "Setkey",
+		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
+		.stat_phase_name[STAT_PHASE_1] = "Copy key to ctx",
+		.stat_phase_name[STAT_PHASE_2] = "Create sequence",
+		.stat_phase_name[STAT_PHASE_3] = "Send Request",
+		.stat_phase_name[STAT_PHASE_4] = "HW-Q push",
+		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
+		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
+	},
+	{
+		.op_type_name = "Generic",
+		.stat_phase_name[STAT_PHASE_0] = "Interrupt",
+		.stat_phase_name[STAT_PHASE_1] = "ISR-to-Tasklet",
+		.stat_phase_name[STAT_PHASE_2] = "Tasklet start-to-end",
+		.stat_phase_name[STAT_PHASE_3] = "Tasklet:user_cb()",
+		.stat_phase_name[STAT_PHASE_4] = "Tasklet:dx_X_complete() - w/o X_complete()",
+		.stat_phase_name[STAT_PHASE_5] = "",
+		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
+	}
+};
+
+/*
+ * Structure used to create a directory 
+ * and its attributes in sysfs.
+ */
+struct sys_dir {
+	struct kobject *sys_dir_kobj;
+	struct attribute_group sys_dir_attr_group;
+	struct attribute **sys_dir_attr_list;
+	uint32_t num_of_attrs;
+	struct ssi_drvdata *drvdata; /* Associated driver context */
+};
+
+/* top level directory structures */
+struct sys_dir sys_top_dir;
+
+static DEFINE_SPINLOCK(stat_lock);
+
+/* List of DBs */
+static struct stat_item stat_host_db[MAX_STAT_OP_TYPES][MAX_STAT_PHASES];
+static struct stat_item stat_cc_db[MAX_STAT_OP_TYPES][MAX_STAT_PHASES];
+
+
+static void init_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES])
+{
+	unsigned int i, j;
+
+	/* Clear db */
+	for (i=0; i<MAX_STAT_OP_TYPES; i++) {
+		for (j=0; j<MAX_STAT_PHASES; j++) {
+			item[i][j].min = 0xFFFFFFFF;
+			item[i][j].max = 0;
+			item[i][j].sum = 0;
+			item[i][j].count = 0;
+		}
+	}
+}
+
+static void update_db(struct stat_item *item, unsigned int result)
+{
+	item->count++;
+	item->sum += result;
+	if (result < item->min)
+		item->min = result;
+	if (result > item->max )
+		item->max = result;
+}
+
+static void display_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES])
+{
+	unsigned int i, j;
+	uint64_t avg;
+
+	for (i=STAT_OP_TYPE_ENCODE; i<MAX_STAT_OP_TYPES; i++) {
+		for (j=0; j<MAX_STAT_PHASES; j++) {	
+			if (item[i][j].count > 0) {
+				avg = (uint64_t)item[i][j].sum;
+				do_div(avg, item[i][j].count);
+				SSI_LOG_ERR("%s, %s: min=%d avg=%d max=%d sum=%lld count=%d\n", 
+					stat_name_db[i].op_type_name, stat_name_db[i].stat_phase_name[j], 
+					item[i][j].min, (int)avg, item[i][j].max, (long long)item[i][j].sum, item[i][j].count);
+			}
+		}
+	}
+}
+
+
+/**************************************
+ * Attributes show functions section  *
+ **************************************/
+
+static ssize_t ssi_sys_stats_host_db_clear(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	init_db(stat_host_db);
+	return count;
+}
+
+static ssize_t ssi_sys_stats_cc_db_clear(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	init_db(stat_cc_db);
+	return count;
+}
+
+static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	int i, j ;
+	char line[512];
+	uint32_t min_cyc, max_cyc;
+	uint64_t avg;
+	ssize_t buf_len, tmp_len=0;
+
+	buf_len = scnprintf(buf,PAGE_SIZE,
+		"phase\t\t\t\t\t\t\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
+	if ( buf_len <0 )/* scnprintf shouldn't return negative value according to its implementation*/
+		return buf_len;
+	for (i=STAT_OP_TYPE_ENCODE; i<MAX_STAT_OP_TYPES; i++) {
+		for (j=0; j<MAX_STAT_PHASES-1; j++) {
+			if (stat_host_db[i][j].count > 0) {
+				avg = (uint64_t)stat_host_db[i][j].sum;
+				do_div(avg, stat_host_db[i][j].count);
+				min_cyc = stat_host_db[i][j].min;
+				max_cyc = stat_host_db[i][j].max;
+			} else {
+				avg = min_cyc = max_cyc = 0;
+			}
+			tmp_len = scnprintf(line,512,
+				"%s::%s\t\t\t\t\t%6u\t%6u\t%6u\t%7u\n",
+				stat_name_db[i].op_type_name,
+				stat_name_db[i].stat_phase_name[j],
+				min_cyc, (unsigned int)avg, max_cyc,
+				stat_host_db[i][j].count);
+			if ( tmp_len <0 )/* scnprintf shouldn't return negative value according to its implementation*/
+				return buf_len;
+			if ( buf_len + tmp_len >= PAGE_SIZE)
+				return buf_len;
+			buf_len += tmp_len;
+			strncat(buf, line,512);
+		}
+	}
+	return buf_len;
+}
+
+static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	int i;
+	char line[256];
+	uint32_t min_cyc, max_cyc;
+	uint64_t avg;
+	ssize_t buf_len,tmp_len=0;
+
+	buf_len = scnprintf(buf,PAGE_SIZE,
+		"phase\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
+	if ( buf_len <0 )/* scnprintf shouldn't return negative value according to its implementation*/
+		return buf_len;
+	for (i=STAT_OP_TYPE_ENCODE; i<MAX_STAT_OP_TYPES; i++) {
+		if (stat_cc_db[i][STAT_PHASE_6].count > 0) {
+			avg = (uint64_t)stat_cc_db[i][STAT_PHASE_6].sum;
+			do_div(avg, stat_cc_db[i][STAT_PHASE_6].count);
+			min_cyc = stat_cc_db[i][STAT_PHASE_6].min;
+			max_cyc = stat_cc_db[i][STAT_PHASE_6].max;
+		} else {
+			avg = min_cyc = max_cyc = 0;
+		}
+		tmp_len = scnprintf(line,256,
+			"%s\t%6u\t%6u\t%6u\t%7u\n",
+			stat_name_db[i].op_type_name,
+			min_cyc,
+			(unsigned int)avg,
+			max_cyc,
+			stat_cc_db[i][STAT_PHASE_6].count);
+
+		if ( tmp_len < 0 )/* scnprintf shouldn't return negative value according to its implementation*/
+			return buf_len;
+
+		if ( buf_len + tmp_len >= PAGE_SIZE)
+			return buf_len;
+		buf_len += tmp_len;
+		strncat(buf, line,256);
+	}
+	return buf_len;
+}
+
+void update_host_stat(unsigned int op_type, unsigned int phase, cycles_t result)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&stat_lock, flags);
+	update_db(&(stat_host_db[op_type][phase]), (unsigned int)result);
+	spin_unlock_irqrestore(&stat_lock, flags);
+}
+
+void update_cc_stat(
+	unsigned int op_type,
+	unsigned int phase,
+	unsigned int elapsed_cycles)
+{
+	update_db(&(stat_cc_db[op_type][phase]), elapsed_cycles);
+}
+
+void display_all_stat_db(void)
+{
+	SSI_LOG_ERR("\n=======    CYCLE COUNT STATS    =======\n"); 
+	display_db(stat_host_db);
+	SSI_LOG_ERR("\n======= CC HW CYCLE COUNT STATS =======\n"); 
+	display_db(stat_cc_db);
+}
+#endif /*CC_CYCLE_COUNT*/
+
+
+
+static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct ssi_drvdata *drvdata = sys_get_drvdata();
+	uint32_t register_value;
+	void __iomem* cc_base = drvdata->cc_base;
+	int offset = 0;
+
+	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
+	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
+	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN));
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
+	register_value =  CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
+	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_CONTENT));
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
+	return offset;
+}
+
+static ssize_t ssi_sys_help_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	char* help_str[]={
+				"cat reg_dump              ", "Print several of CC register values",
+		#if defined CC_CYCLE_COUNT
+				"cat stats_host            ", "Print host statistics",
+				"echo <number> > stats_host", "Clear host statistics database",
+				"cat stats_cc              ", "Print CC statistics",
+				"echo <number> > stats_cc  ", "Clear CC statistics database",
+		#endif
+				};
+	int i=0, offset = 0;
+
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
+	for ( i = 0; i < (sizeof(help_str)/sizeof(help_str[0])); i+=2) {
+	   offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s\t\t%s\n", help_str[i], help_str[i+1]);
+	}
+	return offset;
+}
+
+/********************************************************
+ *		SYSFS objects				*
+ ********************************************************/
+/*
+ * Structure used to create a directory
+ * and its attributes in sysfs.
+ */
+struct sys_dir {
+	struct kobject *sys_dir_kobj;
+	struct attribute_group sys_dir_attr_group;
+	struct attribute **sys_dir_attr_list;
+	uint32_t num_of_attrs;
+	struct ssi_drvdata *drvdata; /* Associated driver context */
+};
+
+/* top level directory structures */
+static struct sys_dir sys_top_dir;
+
+/* TOP LEVEL ATTRIBUTES */
+static struct kobj_attribute ssi_sys_top_level_attrs[] = {
+	__ATTR(dump_regs, 0444, ssi_sys_regdump_show, NULL),
+	__ATTR(help, 0444, ssi_sys_help_show, NULL),
+#if defined CC_CYCLE_COUNT
+	__ATTR(stats_host, 0664, ssi_sys_stat_host_db_show, ssi_sys_stats_host_db_clear),
+	__ATTR(stats_cc, 0664, ssi_sys_stat_cc_db_show, ssi_sys_stats_cc_db_clear),
+#endif
+
+};
+
+static struct ssi_drvdata *sys_get_drvdata(void)
+{
+	/* TODO: supporting multiple SeP devices would require avoiding
+	 * global "top_dir" and finding associated "top_dir" by traversing
+	 * up the tree to the kobject which matches one of the top_dir's */
+	return sys_top_dir.drvdata;
+}
+
+static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
+		 struct kobject *parent_dir_kobj, const char *dir_name,
+		 struct kobj_attribute *attrs, uint32_t num_of_attrs)
+{
+	int i;
+
+	memset(sys_dir, 0, sizeof(struct sys_dir));
+
+	sys_dir->drvdata = drvdata;
+
+	/* initialize directory kobject */
+	sys_dir->sys_dir_kobj =
+		kobject_create_and_add(dir_name, parent_dir_kobj);
+
+	if (!(sys_dir->sys_dir_kobj))
+		return -ENOMEM;
+	/* allocate memory for directory's attributes list */
+	sys_dir->sys_dir_attr_list =
+		kzalloc(sizeof(struct attribute *) * (num_of_attrs + 1),
+				GFP_KERNEL);
+
+	if (!(sys_dir->sys_dir_attr_list)) {
+		kobject_put(sys_dir->sys_dir_kobj);
+		return -ENOMEM;
+	}
+
+	sys_dir->num_of_attrs = num_of_attrs;
+
+	/* initialize attributes list */
+	for (i = 0; i < num_of_attrs; ++i)
+		sys_dir->sys_dir_attr_list[i] = &(attrs[i].attr);
+
+	/* last list entry should be NULL */
+	sys_dir->sys_dir_attr_list[num_of_attrs] = NULL;
+
+	sys_dir->sys_dir_attr_group.attrs = sys_dir->sys_dir_attr_list;
+
+	return sysfs_create_group(sys_dir->sys_dir_kobj,
+			&(sys_dir->sys_dir_attr_group));
+}
+
+static void sys_free_dir(struct sys_dir *sys_dir)
+{
+	if (!sys_dir)
+		return;
+
+	kfree(sys_dir->sys_dir_attr_list);
+
+	if (sys_dir->sys_dir_kobj != NULL)
+		kobject_put(sys_dir->sys_dir_kobj);
+}
+
+int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
+{
+	int retval;
+
+#if defined CC_CYCLE_COUNT
+	/* Init. statistics */
+	init_db(stat_host_db);
+	init_db(stat_cc_db);
+#endif
+
+	SSI_LOG_ERR("setup sysfs under %s\n", sys_dev_obj->name);
+
+	/* Initialize top directory */
+	retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj,
+				"cc_info", ssi_sys_top_level_attrs,
+				sizeof(ssi_sys_top_level_attrs) /
+				sizeof(struct kobj_attribute));
+	return retval;
+}
+
+void ssi_sysfs_fini(void)
+{
+	sys_free_dir(&sys_top_dir);
+}
+
+#endif /*ENABLE_CC_SYSFS*/
+
diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
new file mode 100644
index 0000000..087815e
--- /dev/null
+++ b/drivers/staging/ccree/ssi_sysfs.h
@@ -0,0 +1,54 @@
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
+/* \file ssi_sysfs.h
+   ARM CryptoCell sysfs APIs
+ */
+
+#ifndef __SSI_SYSFS_H__
+#define __SSI_SYSFS_H__
+
+#include <asm/timex.h>
+
+/* forward declaration */
+struct ssi_drvdata;
+
+enum stat_phase {
+	STAT_PHASE_0 = 0,
+	STAT_PHASE_1,
+	STAT_PHASE_2,
+	STAT_PHASE_3,
+	STAT_PHASE_4,
+	STAT_PHASE_5,
+	STAT_PHASE_6,
+	MAX_STAT_PHASES,
+};
+enum stat_op {
+	STAT_OP_TYPE_NULL = 0,
+	STAT_OP_TYPE_ENCODE,
+	STAT_OP_TYPE_DECODE,
+	STAT_OP_TYPE_SETKEY,
+	STAT_OP_TYPE_GENERIC,
+	MAX_STAT_OP_TYPES,
+};
+
+int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata);
+void ssi_sysfs_fini(void);
+void update_host_stat(unsigned int op_type, unsigned int phase, cycles_t result);
+void update_cc_stat(unsigned int op_type, unsigned int phase, unsigned int elapsed_cycles);
+void display_all_stat_db(void);
+
+#endif /*__SSI_SYSFS_H__*/
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
