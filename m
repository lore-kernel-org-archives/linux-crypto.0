Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989E9C3F6B0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiHPOEV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbiHPODm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:42 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5F125C63
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id e15so15114828lfs.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=p+6hbJuzTfoCdoe9aWPSXaliBzd4ByI0bHJTkg1Dlbc=;
        b=j1aIS9w3TbsLQHz/OFlElS+7czgnScrpa0xNrSE3iNGIpi31QjfFe/eIdE4u592Sz8
         9y9y0a1uWYRPVLQTYYBlqZ0vj4KpgwV59fP9bFRK2P3p454jdzIFuMBZq5FiKhXniyRW
         BhqgXpiNdNu+aIlmGm8lMUMdIUPcdkLXJojdq72+JXJh04kaJVqr+Llddl5RvQjQewxG
         /SXU2TF/fARCNH9cBZT7Nb0aW0XBkOcVpgEP4ebXY5sUPivmsEczWmyeT2FVDE7FU6O7
         3TQ+XPNmcHlm00IbhAb2MNVCXQZqXMvcWYh02MoGJb6+JkOQabiYL4jKOFtN7O8+ZmOD
         M1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=p+6hbJuzTfoCdoe9aWPSXaliBzd4ByI0bHJTkg1Dlbc=;
        b=jCMErDDU9V3mWNvpuHVdUkldRhf4LWJqQO72FsTPZXVnrQziv3RbB84ce555HNcIc7
         6oO0aUKdFd22p/Y3fNDcAQ07wmRg14XpwPqjBPKAjgHsqzf4Gz5OpYOFV2k8BjiGDLfx
         H6MYPasiCpbw3hLznrQ4bpxsnSbJCZfvwo1aasVH/Go2qKSZ7oQnA3dUuTXHYupRgq/A
         cwW/dDb+XkyquWTjD4kHdmfBPVaDvHHrA61NWHe8L/wPiU8sV2y55tYHlApDWD3nT8se
         vYRFWrVz0yNi6L31/MND0RHpjBPYxY2UMprUBUD5Z/j/ehDBJ4LQwqGxeMU6wUZkkPS6
         aqQg==
X-Gm-Message-State: ACgBeo392Oo/KohYOKcY9Kv6nI3bH694TJdqcpVcyt0LmKokHw51k9bI
        6S1MA2u+jAD6toJ5Y/Mkmb/1cFeP+VSpIw==
X-Google-Smtp-Source: AA6agR4fsuWlu1HE4yCanCZ0n9eoBUow9lKA5urXIzQmKDBeP8h9RdC19QomYbzF6bT5ZFZRNN7klw==
X-Received: by 2002:a05:6512:110d:b0:492:8c61:48f9 with SMTP id l13-20020a056512110d00b004928c6148f9mr2994162lfg.224.1660658608853;
        Tue, 16 Aug 2022 07:03:28 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:28 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 13/16] crypto: ux500/hash: Convert to regmap MMIO
Date:   Tue, 16 Aug 2022 16:00:46 +0200
Message-Id: <20220816140049.102306-14-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver goes to extents to map a struct over all the registers
and access the registers and macros to access certain fields
and bits in a way equivalent but inferior to the existing Linux
regmap.

The driver predates the introduction of regmap MMIO, so this is
understandable.

Convert the driver to use regmap MMIO instead.

Break out two helper functions to wait for an STR flag and to
fill the data in (DIN) FIFO to avoid repetitive code.

Disable the regcache: this drives sends a LOT of data into a
single register (DIN), which is pointless to cache and only takes
extra execution time. Any other accesses are stray and few.

Checkpatch complains about -ENOTSUPP so use -ENODEV instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- Mark PrimeCell ID registers volatile as they have interesting
  power-on defaults.
- Avoid using noinc calls, they don't work with regmap MMIO
  right now. (Working on a solution.)
---
 drivers/crypto/ux500/Kconfig          |   1 +
 drivers/crypto/ux500/hash/hash_alg.h  | 200 +++----------
 drivers/crypto/ux500/hash/hash_core.c | 415 ++++++++++++++++----------
 3 files changed, 302 insertions(+), 314 deletions(-)

diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index f56d65c56ccf..5d70f5965d06 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -20,6 +20,7 @@ config CRYPTO_DEV_UX500_HASH
 	select CRYPTO_HASH
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
+	select REGMAP_MMIO
 	help
 	  This selects the hash driver for the UX500_HASH hardware.
 	  Depends on UX500/STM DMA if running in DMA mode.
diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 6a610c83e63d..cc44d3cb21ac 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -8,6 +8,7 @@
 #ifndef _HASH_ALG_H
 #define _HASH_ALG_H
 
+#include <linux/regmap.h>
 #include <linux/bitops.h>
 
 #define HASH_BLOCK_SIZE			64
@@ -16,70 +17,50 @@
 #define HASH_DMA_PERFORMANCE_MIN_SIZE	1024
 #define HASH_BYTES_PER_WORD		4
 
-/* Power on Reset values HASH registers */
-#define HASH_RESET_CR_VALUE		0x0
-#define HASH_RESET_STR_VALUE		0x0
-
 /* Number of context swap registers */
 #define HASH_CSR_COUNT			52
 
-#define HASH_RESET_CSRX_REG_VALUE	0x0
-#define HASH_RESET_CSFULL_REG_VALUE	0x0
-#define HASH_RESET_CSDATAIN_REG_VALUE	0x0
-
-#define HASH_RESET_INDEX_VAL		0x0
-#define HASH_RESET_BIT_INDEX_VAL	0x0
-#define HASH_RESET_BUFFER_VAL		0x0
-#define HASH_RESET_LEN_HIGH_VAL		0x0
-#define HASH_RESET_LEN_LOW_VAL		0x0
+#define UX500_HASH_CR			0x00
+#define UX500_HASH_DIN			0x04
+#define UX500_HASH_STR			0x08
+#define UX500_HASH_H(x)			(0x0C + ((x) * 0x04))
+#define UX500_HASH_ITCR			0x80
+#define UX500_HASH_ITIP			0x84
+#define UX500_HASH_ITOP			0x88
+#define UX500_HASH_CSFULL		0xF8
+#define UX500_HASH_CSDATAIN		0xFC
+#define UX500_HASH_CSR(x)		(0x100 + ((x) * 0x04))
+#define UX500_HASH_PERIPHID0		0xFE0
+#define UX500_HASH_PERIPHID1		0xFE4
+#define UX500_HASH_PERIPHID2		0xFE8
+#define UX500_HASH_PERIPHID3		0xFEC
+#define UX500_HASH_CELLID0		0xFF0
+#define UX500_HASH_CELLID1		0xFF4
+#define UX500_HASH_CELLID2		0xFF8
+#define UX500_HASH_CELLID3		0xFFC
 
 /* Control register bitfields */
 #define HASH_CR_RESUME_MASK	0x11FCF
-
-#define HASH_CR_SWITCHON_POS	31
-#define HASH_CR_SWITCHON_MASK	BIT(31)
-
-#define HASH_CR_EMPTYMSG_POS	20
-#define HASH_CR_EMPTYMSG_MASK	BIT(20)
-
-#define HASH_CR_DINF_POS	12
-#define HASH_CR_DINF_MASK	BIT(12)
-
-#define HASH_CR_NBW_POS		8
+#define HASH_CR_SWITCHON	BIT(31)
+#define HASH_CR_EMPTYMSG	BIT(20)
+#define HASH_CR_DINF		BIT(12)
 #define HASH_CR_NBW_MASK	0x00000F00UL
-
-#define HASH_CR_LKEY_POS	16
-#define HASH_CR_LKEY_MASK	BIT(16)
-
-#define HASH_CR_ALGO_POS	7
-#define HASH_CR_ALGO_MASK	BIT(7)
-
-#define HASH_CR_MODE_POS	6
-#define HASH_CR_MODE_MASK	BIT(6)
-
-#define HASH_CR_DATAFORM_POS	4
+#define HASH_CR_LKEY		BIT(16)
+#define HASH_CR_ALGO		BIT(7)
+#define HASH_CR_MODE		BIT(6)
 #define HASH_CR_DATAFORM_MASK	(BIT(4) | BIT(5))
-
-#define HASH_CR_DMAE_POS	3
-#define HASH_CR_DMAE_MASK	BIT(3)
-
-#define HASH_CR_INIT_POS	2
-#define HASH_CR_INIT_MASK	BIT(2)
-
-#define HASH_CR_PRIVN_POS	1
-#define HASH_CR_PRIVN_MASK	BIT(1)
-
-#define HASH_CR_SECN_POS	0
-#define HASH_CR_SECN_MASK	BIT(0)
+#define HASH_CR_DATAFORM_32BIT	0
+#define HASH_CR_DATAFORM_16BIT	BIT(4)
+#define HASH_CR_DATAFORM_8BIT	BIT(5)
+#define HASH_CR_DATAFORM_1BIT	(BIT(4) | BIT(5))
+#define HASH_CR_DMAE		BIT(3)
+#define HASH_CR_INIT		BIT(2)
+#define HASH_CR_PRIVN		BIT(1)
+#define HASH_CR_SECN		BIT(0)
 
 /* Start register bitfields */
-#define HASH_STR_DCAL_POS	8
-#define HASH_STR_DCAL_MASK	BIT(8)
-#define HASH_STR_DEFAULT	0x0
-
-#define HASH_STR_NBLW_POS	0
+#define HASH_STR_DCAL		BIT(8)
 #define HASH_STR_NBLW_MASK	0x0000001FUL
-
 #define HASH_NBLW_MAX_VAL	0x1F
 
 /* PrimeCell IDs */
@@ -92,105 +73,12 @@
 #define HASH_CELL_ID2		0x05
 #define HASH_CELL_ID3		0xB1
 
-#define HASH_SET_BITS(reg_name, mask)	\
-	writel_relaxed((readl_relaxed(reg_name) | mask), reg_name)
-
-#define HASH_CLEAR_BITS(reg_name, mask)	\
-	writel_relaxed((readl_relaxed(reg_name) & ~mask), reg_name)
-
-#define HASH_PUT_BITS(reg, val, shift, mask)	\
-	writel_relaxed(((readl(reg) & ~(mask)) |	\
-		(((u32)val << shift) & (mask))), reg)
-
-#define HASH_SET_DIN(val, len)	writesl(&device_data->base->din, (val), (len))
-
-#define HASH_INITIALIZE			\
-	HASH_PUT_BITS(			\
-		&device_data->base->cr,	\
-		0x01, HASH_CR_INIT_POS,	\
-		HASH_CR_INIT_MASK)
-
-#define HASH_SET_DATA_FORMAT(data_format)				\
-		HASH_PUT_BITS(						\
-			&device_data->base->cr,				\
-			(u32) (data_format), HASH_CR_DATAFORM_POS,	\
-			HASH_CR_DATAFORM_MASK)
-#define HASH_SET_NBLW(val)					\
-		HASH_PUT_BITS(					\
-			&device_data->base->str,		\
-			(u32) (val), HASH_STR_NBLW_POS,		\
-			HASH_STR_NBLW_MASK)
-#define HASH_SET_DCAL					\
-		HASH_PUT_BITS(				\
-			&device_data->base->str,	\
-			0x01, HASH_STR_DCAL_POS,	\
-			HASH_STR_DCAL_MASK)
-
 /* Hardware access method */
 enum hash_mode {
 	HASH_MODE_CPU,
 	HASH_MODE_DMA
 };
 
-/**
- * struct hash_register - Contains all registers in ux500 hash hardware.
- * @cr:		HASH control register (0x000).
- * @din:	HASH data input register (0x004).
- * @str:	HASH start register (0x008).
- * @hx:		HASH digest register 0..7 (0x00c-0x01C).
- * @padding0:	Reserved (0x02C).
- * @itcr:	Integration test control register (0x080).
- * @itip:	Integration test input register (0x084).
- * @itop:	Integration test output register (0x088).
- * @padding1:	Reserved (0x08C).
- * @csfull:	HASH context full register (0x0F8).
- * @csdatain:	HASH context swap data input register (0x0FC).
- * @csrx:	HASH context swap register 0..51 (0x100-0x1CC).
- * @padding2:	Reserved (0x1D0).
- * @periphid0:	HASH peripheral identification register 0 (0xFE0).
- * @periphid1:	HASH peripheral identification register 1 (0xFE4).
- * @periphid2:	HASH peripheral identification register 2 (0xFE8).
- * @periphid3:	HASH peripheral identification register 3 (0xFEC).
- * @cellid0:	HASH PCell identification register 0 (0xFF0).
- * @cellid1:	HASH PCell identification register 1 (0xFF4).
- * @cellid2:	HASH PCell identification register 2 (0xFF8).
- * @cellid3:	HASH PCell identification register 3 (0xFFC).
- *
- * The device communicates to the HASH via 32-bit-wide control registers
- * accessible via the 32-bit width AMBA rev. 2.0 AHB Bus. Below is a structure
- * with the registers used.
- */
-struct hash_register {
-	u32 cr;
-	u32 din;
-	u32 str;
-	u32 hx[8];
-
-	u32 padding0[(0x080 - 0x02C) / sizeof(u32)];
-
-	u32 itcr;
-	u32 itip;
-	u32 itop;
-
-	u32 padding1[(0x0F8 - 0x08C) / sizeof(u32)];
-
-	u32 csfull;
-	u32 csdatain;
-	u32 csrx[HASH_CSR_COUNT];
-
-	u32 padding2[(0xFE0 - 0x1D0) / sizeof(u32)];
-
-	u32 periphid0;
-	u32 periphid1;
-	u32 periphid2;
-	u32 periphid3;
-
-	u32 cellid0;
-	u32 cellid1;
-	u32 cellid2;
-	u32 cellid3;
-};
-
 /**
  * struct hash_state - Hash context state.
  * @temp_cr:	Temporary HASH Control Register.
@@ -228,20 +116,6 @@ enum hash_device_id {
 	HASH_DEVICE_ID_1 = 1
 };
 
-/**
- * enum hash_data_format - HASH data format.
- * @HASH_DATA_32_BITS:	32 bits data format
- * @HASH_DATA_16_BITS:	16 bits data format
- * @HASH_DATA_8_BITS:	8 bits data format.
- * @HASH_DATA_1_BITS:	1 bit data format.
- */
-enum hash_data_format {
-	HASH_DATA_32_BITS	= 0x0,
-	HASH_DATA_16_BITS	= 0x1,
-	HASH_DATA_8_BITS	= 0x2,
-	HASH_DATA_1_BIT		= 0x3
-};
-
 /**
  * enum hash_algo - Enumeration for selecting between SHA1 or SHA2 algorithm.
  * @HASH_ALGO_SHA1: Indicates that SHA1 is used.
@@ -269,7 +143,7 @@ enum hash_op {
  * @oper_mode:		Operating mode selection bit.
  */
 struct hash_config {
-	int data_format;
+	unsigned int data_format;
 	int algorithm;
 	int oper_mode;
 };
@@ -335,7 +209,7 @@ struct hash_req_ctx {
 
 /**
  * struct hash_device_data - structure for a hash device.
- * @base:		Pointer to virtual base address of the hash device.
+ * @map:		Regmap for the MMIO for the device
  * @phybase:		Pointer to physical memory location of the hash device.
  * @list_node:		For inclusion in klist.
  * @dev:		Pointer to the device dev structure.
@@ -348,7 +222,7 @@ struct hash_req_ctx {
  * @dma:		Structure used for dma.
  */
 struct hash_device_data {
-	struct hash_register __iomem	*base;
+	struct regmap		*map;
 	phys_addr_t             phybase;
 	struct klist_node	list_node;
 	struct device		*dev;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 21657c9c79a7..ed54e71efbb2 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/crypto.h>
 #include <linux/dmaengine.h>
 #include <linux/bitops.h>
@@ -289,6 +290,45 @@ static int hash_enable_power(struct hash_device_data *device_data)
 	return ret;
 }
 
+static void hash_wait_for_dcal(struct hash_device_data *device_data)
+{
+	unsigned int val;
+
+	regmap_read(device_data->map, UX500_HASH_STR, &val);
+	while (val & HASH_STR_DCAL) {
+		cpu_relax();
+		regmap_read(device_data->map, UX500_HASH_STR, &val);
+	}
+}
+
+static void hash_fill_din(struct hash_device_data *device_data,
+			  const void *data, unsigned int len)
+{
+	const u8 *datap = data;
+	u32 val;
+
+	/*
+	 * We cannot use regmap_write_noinc() because regmap MMIO does
+	 * not support the noinc operations (requires .write() callback).
+	 * TODO: revisit when regmap MMIO supports regmap_write_noinc().
+	 */
+	while (len > 4) {
+		val = *((u32 *)datap);
+		regmap_write(device_data->map, UX500_HASH_DIN, val);
+		datap += 4;
+		len -= 4;
+	}
+
+	if (len) {
+		val = 0;
+		while (len) {
+			val |= (datap[len - 1] << (8 * (len - 1)));
+			len--;
+		}
+		regmap_write(device_data->map, UX500_HASH_DIN, val);
+	}
+}
+
 /**
  * hash_hw_write_key - Writes the key to the hardware registries.
  *
@@ -303,37 +343,17 @@ static int hash_enable_power(struct hash_device_data *device_data)
 static void hash_hw_write_key(struct hash_device_data *device_data,
 			      const u8 *key, unsigned int keylen)
 {
-	u32 word = 0;
-	int nwords = 1;
-
-	HASH_CLEAR_BITS(&device_data->base->str, HASH_STR_NBLW_MASK);
-
-	while (keylen >= 4) {
-		u32 *key_word = (u32 *)key;
-
-		HASH_SET_DIN(key_word, nwords);
-		keylen -= 4;
-		key += 4;
-	}
-
-	/* Take care of the remaining bytes in the last word */
-	if (keylen) {
-		word = 0;
-		while (keylen) {
-			word |= (key[keylen - 1] << (8 * (keylen - 1)));
-			keylen--;
-		}
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_NBLW_MASK, 0);
 
-		HASH_SET_DIN(&word, nwords);
-	}
+	hash_fill_din(device_data, key, keylen);
 
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
+	hash_wait_for_dcal(device_data);
 
-	HASH_SET_DCAL;
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_DCAL, HASH_STR_DCAL);
 
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
+	hash_wait_for_dcal(device_data);
 }
 
 /**
@@ -468,16 +488,16 @@ static int ux500_hash_init(struct ahash_request *req)
 static void hash_processblock(struct hash_device_data *device_data,
 			      const u32 *message, int length)
 {
-	int len = length / HASH_BYTES_PER_WORD;
 	/*
 	 * NBLW bits. Reset the number of bits in last word (NBLW).
 	 */
-	HASH_CLEAR_BITS(&device_data->base->str, HASH_STR_NBLW_MASK);
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_NBLW_MASK, 0);
 
 	/*
 	 * Write message data to the HASH_DIN register.
 	 */
-	HASH_SET_DIN(message, len);
+	hash_fill_din(device_data, message, length);
 }
 
 /**
@@ -493,39 +513,24 @@ static void hash_processblock(struct hash_device_data *device_data,
 static void hash_messagepad(struct hash_device_data *device_data,
 			    const u32 *message, u8 index_bytes)
 {
-	int nwords = 1;
-
 	/*
 	 * Clear hash str register, only clear NBLW
 	 * since DCAL will be reset by hardware.
 	 */
-	HASH_CLEAR_BITS(&device_data->base->str, HASH_STR_NBLW_MASK);
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_NBLW_MASK, 0);
 
-	/* Main loop */
-	while (index_bytes >= 4) {
-		HASH_SET_DIN(message, nwords);
-		index_bytes -= 4;
-		message++;
-	}
-
-	if (index_bytes)
-		HASH_SET_DIN(message, nwords);
+	hash_fill_din(device_data, message, index_bytes);
 
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
+	hash_wait_for_dcal(device_data);
 
 	/* num_of_bytes == 0 => NBLW <- 0 (32 bits valid in DATAIN) */
-	HASH_SET_NBLW(index_bytes * 8);
-	dev_dbg(device_data->dev, "%s: DIN=0x%08x NBLW=%lu\n",
-		__func__, readl_relaxed(&device_data->base->din),
-		readl_relaxed(&device_data->base->str) & HASH_STR_NBLW_MASK);
-	HASH_SET_DCAL;
-	dev_dbg(device_data->dev, "%s: after dcal -> DIN=0x%08x NBLW=%lu\n",
-		__func__, readl_relaxed(&device_data->base->din),
-		readl_relaxed(&device_data->base->str) & HASH_STR_NBLW_MASK);
-
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_NBLW_MASK, index_bytes * 8);
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_DCAL, HASH_STR_DCAL);
+
+	hash_wait_for_dcal(device_data);
 }
 
 /**
@@ -548,18 +553,21 @@ int hash_setconfiguration(struct hash_device_data *device_data,
 	 * DATAFORM bits. Set the DATAFORM bits to 0b11, which means the data
 	 * to be written to HASH_DIN is considered as 32 bits.
 	 */
-	HASH_SET_DATA_FORMAT(config->data_format);
+	regmap_update_bits(device_data->map, UX500_HASH_CR,
+			   HASH_CR_DATAFORM_MASK, config->data_format);
 
 	/*
 	 * ALGO bit. Set to 0b1 for SHA-1 and 0b0 for SHA-256
 	 */
 	switch (config->algorithm) {
 	case HASH_ALGO_SHA1:
-		HASH_SET_BITS(&device_data->base->cr, HASH_CR_ALGO_MASK);
+		regmap_update_bits(device_data->map, UX500_HASH_CR,
+				   HASH_CR_ALGO, HASH_CR_ALGO);
 		break;
 
 	case HASH_ALGO_SHA256:
-		HASH_CLEAR_BITS(&device_data->base->cr, HASH_CR_ALGO_MASK);
+		regmap_update_bits(device_data->map, UX500_HASH_CR,
+				   HASH_CR_ALGO, 0);
 		break;
 
 	default:
@@ -573,20 +581,21 @@ int hash_setconfiguration(struct hash_device_data *device_data,
 	 * selected algorithm. 0b0 = HASH and 0b1 = HMAC.
 	 */
 	if (config->oper_mode == HASH_OPER_MODE_HASH) {
-		HASH_CLEAR_BITS(&device_data->base->cr,
-				HASH_CR_MODE_MASK);
+		regmap_update_bits(device_data->map, UX500_HASH_CR,
+				   HASH_CR_MODE, 0);
 	} else if (config->oper_mode == HASH_OPER_MODE_HMAC) {
-		HASH_SET_BITS(&device_data->base->cr, HASH_CR_MODE_MASK);
+		regmap_update_bits(device_data->map, UX500_HASH_CR,
+				   HASH_CR_MODE, HASH_CR_MODE);
 		if (ctx->keylen > HASH_BLOCK_SIZE) {
 			/* Truncate key to blocksize */
 			dev_dbg(device_data->dev, "%s: LKEY set\n", __func__);
-			HASH_SET_BITS(&device_data->base->cr,
-				      HASH_CR_LKEY_MASK);
+			regmap_update_bits(device_data->map, UX500_HASH_CR,
+					   HASH_CR_LKEY, HASH_CR_LKEY);
 		} else {
 			dev_dbg(device_data->dev, "%s: LKEY cleared\n",
 				__func__);
-			HASH_CLEAR_BITS(&device_data->base->cr,
-					HASH_CR_LKEY_MASK);
+			regmap_update_bits(device_data->map, UX500_HASH_CR,
+					   HASH_CR_LKEY, 0);
 		}
 	} else {	/* Wrong hash mode */
 		ret = -EPERM;
@@ -607,20 +616,21 @@ void hash_begin(struct hash_device_data *device_data, struct hash_ctx *ctx)
 	/* HW and SW initializations */
 	/* Note: there is no need to initialize buffer and digest members */
 
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
+	hash_wait_for_dcal(device_data);
 
 	/*
 	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
 	 * prepare the initialize the HASH accelerator to compute the message
 	 * digest of a new message.
 	 */
-	HASH_INITIALIZE;
+	regmap_update_bits(device_data->map, UX500_HASH_CR,
+			   HASH_CR_INIT, HASH_CR_INIT);
 
 	/*
 	 * NBLW bits. Reset the number of bits in last word (NBLW).
 	 */
-	HASH_CLEAR_BITS(&device_data->base->str, HASH_STR_NBLW_MASK);
+	regmap_update_bits(device_data->map, UX500_HASH_STR,
+			   HASH_STR_NBLW_MASK, 0);
 }
 
 static int hash_process_data(struct hash_device_data *device_data,
@@ -715,22 +725,24 @@ static int hash_dma_final(struct ahash_request *req)
 
 		/* Enable DMA input */
 		if (hash_mode != HASH_MODE_DMA || !req_ctx->dma_mode) {
-			HASH_CLEAR_BITS(&device_data->base->cr,
-					HASH_CR_DMAE_MASK);
+			regmap_update_bits(device_data->map, UX500_HASH_CR,
+					   HASH_CR_DMAE, 0);
 		} else {
-			HASH_SET_BITS(&device_data->base->cr,
-				      HASH_CR_DMAE_MASK);
-			HASH_SET_BITS(&device_data->base->cr,
-				      HASH_CR_PRIVN_MASK);
+			regmap_update_bits(device_data->map, UX500_HASH_CR,
+					   HASH_CR_DMAE | HASH_CR_PRIVN,
+					   HASH_CR_DMAE | HASH_CR_PRIVN);
 		}
 
-		HASH_INITIALIZE;
+		regmap_update_bits(device_data->map, UX500_HASH_CR,
+				   HASH_CR_INIT, HASH_CR_INIT);
 
 		if (ctx->config.oper_mode == HASH_OPER_MODE_HMAC)
 			hash_hw_write_key(device_data, ctx->key, ctx->keylen);
 
 		/* Number of bits in last word = (nbytes * 8) % 32 */
-		HASH_SET_NBLW((req->nbytes * 8) % 32);
+		regmap_update_bits(device_data->map, UX500_HASH_STR,
+				   HASH_STR_NBLW_MASK, (req->nbytes * 8) % 32);
+
 		req_ctx->hw_initialized = true;
 	}
 
@@ -754,8 +766,7 @@ static int hash_dma_final(struct ahash_request *req)
 	wait_for_completion(&ctx->device->dma.complete);
 	hash_dma_done(ctx);
 
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
+	hash_wait_for_dcal(device_data);
 
 	if (ctx->config.oper_mode == HASH_OPER_MODE_HMAC && ctx->key) {
 		unsigned int keylen = ctx->keylen;
@@ -844,9 +855,9 @@ static int hash_hw_final(struct ahash_request *req)
 		hash_messagepad(device_data, req_ctx->buffer,
 				req_ctx->index);
 	} else {
-		HASH_SET_DCAL;
-		while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-			cpu_relax();
+		regmap_update_bits(device_data->map, UX500_HASH_STR,
+				   HASH_STR_DCAL, HASH_STR_DCAL);
+		hash_wait_for_dcal(device_data);
 	}
 
 	if (ctx->config.oper_mode == HASH_OPER_MODE_HMAC && ctx->key) {
@@ -935,20 +946,24 @@ int hash_hw_update(struct ahash_request *req)
  */
 int hash_check_hw(struct hash_device_data *device_data)
 {
-	/* Checking Peripheral Ids  */
-	if (HASH_P_ID0 == readl_relaxed(&device_data->base->periphid0) &&
-	    HASH_P_ID1 == readl_relaxed(&device_data->base->periphid1) &&
-	    HASH_P_ID2 == readl_relaxed(&device_data->base->periphid2) &&
-	    HASH_P_ID3 == readl_relaxed(&device_data->base->periphid3) &&
-	    HASH_CELL_ID0 == readl_relaxed(&device_data->base->cellid0) &&
-	    HASH_CELL_ID1 == readl_relaxed(&device_data->base->cellid1) &&
-	    HASH_CELL_ID2 == readl_relaxed(&device_data->base->cellid2) &&
-	    HASH_CELL_ID3 == readl_relaxed(&device_data->base->cellid3)) {
-		return 0;
+	unsigned int regs[] = { UX500_HASH_PERIPHID0, UX500_HASH_PERIPHID1,
+		UX500_HASH_PERIPHID2, UX500_HASH_PERIPHID3, UX500_HASH_CELLID0,
+		UX500_HASH_CELLID1, UX500_HASH_CELLID2, UX500_HASH_CELLID3 };
+	unsigned int expected[] = { HASH_P_ID0, HASH_P_ID1, HASH_P_ID2, HASH_P_ID3,
+		HASH_CELL_ID0, HASH_CELL_ID1, HASH_CELL_ID2, HASH_CELL_ID3 };
+	unsigned int val;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		regmap_read(device_data->map, regs[i], &val);
+		if (val != expected[i]) {
+			dev_err(device_data->dev, "ID word %d was %08x expected %08x\n",
+				i, val, expected[i]);
+			return -ENODEV;
+		}
 	}
 
-	dev_err(device_data->dev, "%s: HASH_UNSUPPORTED_HW!\n", __func__);
-	return -ENOTSUPP;
+	return 0;
 }
 
 /**
@@ -960,8 +975,9 @@ int hash_check_hw(struct hash_device_data *device_data)
 void hash_get_digest(struct hash_device_data *device_data,
 		     u8 *digest, int algorithm)
 {
-	u32 temp_hx_val, count;
 	int loop_ctr;
+	u32 val;
+	int i;
 
 	if (algorithm != HASH_ALGO_SHA1 && algorithm != HASH_ALGO_SHA256) {
 		dev_err(device_data->dev, "%s: Incorrect algorithm %d\n",
@@ -977,13 +993,13 @@ void hash_get_digest(struct hash_device_data *device_data,
 	dev_dbg(device_data->dev, "%s: digest array:(0x%lx)\n",
 		__func__, (unsigned long)digest);
 
-	/* Copy result into digest array */
-	for (count = 0; count < loop_ctr; count++) {
-		temp_hx_val = readl_relaxed(&device_data->base->hx[count]);
-		digest[count * 4] = (u8) ((temp_hx_val >> 24) & 0xFF);
-		digest[count * 4 + 1] = (u8) ((temp_hx_val >> 16) & 0xFF);
-		digest[count * 4 + 2] = (u8) ((temp_hx_val >> 8) & 0xFF);
-		digest[count * 4 + 3] = (u8) ((temp_hx_val >> 0) & 0xFF);
+	for (i = 0; i < loop_ctr; i++) {
+		regmap_read(device_data->map, UX500_HASH_H(i),
+			    &val);
+		digest[i * 4] = (u8) ((val >> 24) & 0xFF);
+		digest[i * 4 + 1] = (u8) ((val >> 16) & 0xFF);
+		digest[i * 4 + 2] = (u8) ((val >> 8) & 0xFF);
+		digest[i * 4 + 3] = (u8) ((val >> 0) & 0xFF);
 	}
 }
 
@@ -1055,7 +1071,7 @@ static int ahash_sha1_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->config.data_format = HASH_DATA_8_BITS;
+	ctx->config.data_format = HASH_CR_DATAFORM_8BIT;
 	ctx->config.algorithm = HASH_ALGO_SHA1;
 	ctx->config.oper_mode = HASH_OPER_MODE_HASH;
 	ctx->digestsize = SHA1_DIGEST_SIZE;
@@ -1068,7 +1084,7 @@ static int ahash_sha256_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->config.data_format = HASH_DATA_8_BITS;
+	ctx->config.data_format = HASH_CR_DATAFORM_8BIT;
 	ctx->config.algorithm = HASH_ALGO_SHA256;
 	ctx->config.oper_mode = HASH_OPER_MODE_HASH;
 	ctx->digestsize = SHA256_DIGEST_SIZE;
@@ -1113,9 +1129,8 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	struct hash_device_data *device_data = ctx->device;
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
 	const struct hash_state *hstate = in;
-	int hash_mode = HASH_OPER_MODE_HASH;
+	unsigned int val;
 	u32 cr;
-	s32 count;
 
 	/* Restore software state */
 	req_ctx->length = hstate->length;
@@ -1130,27 +1145,24 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	 * prepare the initialize the HASH accelerator to compute the message
 	 * digest of a new message.
 	 */
-	HASH_INITIALIZE;
+	regmap_update_bits(device_data->map, UX500_HASH_CR,
+			   HASH_CR_INIT, HASH_CR_INIT);
 
 	cr = hstate->temp_cr;
-	writel_relaxed(cr & HASH_CR_RESUME_MASK, &device_data->base->cr);
+	regmap_write(device_data->map, UX500_HASH_CR, cr & HASH_CR_RESUME_MASK);
 
-	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
-		hash_mode = HASH_OPER_MODE_HMAC;
+	regmap_read(device_data->map, UX500_HASH_CR, &val);
+	if (val & HASH_CR_MODE)
+		regmap_bulk_write(device_data->map, UX500_HASH_CSR(0),
+				  hstate->csr, HASH_CSR_COUNT);
 	else
-		hash_mode = HASH_OPER_MODE_HASH;
-
-	for (count = 0; count < HASH_CSR_COUNT; count++) {
-		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
-			break;
-		writel_relaxed(hstate->csr[count],
-			       &device_data->base->csrx[count]);
-	}
+		regmap_bulk_write(device_data->map, UX500_HASH_CSR(0),
+				  hstate->csr, 36);
 
-	writel_relaxed(hstate->csfull, &device_data->base->csfull);
-	writel_relaxed(hstate->csdatain, &device_data->base->csdatain);
-	writel_relaxed(hstate->str_reg, &device_data->base->str);
-	writel_relaxed(cr, &device_data->base->cr);
+	regmap_write(device_data->map, UX500_HASH_CSFULL, hstate->csfull);
+	regmap_write(device_data->map, UX500_HASH_CSDATAIN, hstate->csdatain);
+	regmap_write(device_data->map, UX500_HASH_STR, hstate->str_reg);
+	regmap_write(device_data->map, UX500_HASH_CR, cr);
 
 	return 0;
 }
@@ -1162,9 +1174,7 @@ static int ahash_export(struct ahash_request *req, void *out)
 	struct hash_device_data *device_data = ctx->device;
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
 	struct hash_state *hstate = out;
-	int hash_mode = HASH_OPER_MODE_HASH;
 	u32 cr;
-	u32 count;
 
 	/*
 	 * Save hardware state:
@@ -1172,31 +1182,21 @@ static int ahash_export(struct ahash_request *req, void *out)
 	 * actually makes sure that there isn't any ongoing calculation in the
 	 * hardware.
 	 */
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
-
-	cr = readl_relaxed(&device_data->base->cr);
-
-	hstate->str_reg = readl_relaxed(&device_data->base->str);
+	hash_wait_for_dcal(device_data);
 
-	hstate->din_reg = readl_relaxed(&device_data->base->din);
+	regmap_read(device_data->map, UX500_HASH_CR, &cr);
+	regmap_read(device_data->map, UX500_HASH_STR, &hstate->str_reg);
+	regmap_read(device_data->map, UX500_HASH_DIN, &hstate->din_reg);
 
-	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
-		hash_mode = HASH_OPER_MODE_HMAC;
+	if (cr & HASH_CR_MODE)
+		regmap_bulk_read(device_data->map, UX500_HASH_CSR(0),
+				 hstate->csr, HASH_CSR_COUNT);
 	else
-		hash_mode = HASH_OPER_MODE_HASH;
-
-	for (count = 0; count < HASH_CSR_COUNT; count++) {
-		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
-			break;
-
-		hstate->csr[count] =
-			readl_relaxed(&device_data->base->csrx[count]);
-	}
-
-	hstate->csfull = readl_relaxed(&device_data->base->csfull);
-	hstate->csdatain = readl_relaxed(&device_data->base->csdatain);
+		regmap_bulk_read(device_data->map, UX500_HASH_CSR(0),
+				 hstate->csr, 36);
 
+	regmap_read(device_data->map, UX500_HASH_CSFULL, &hstate->csfull);
+	regmap_read(device_data->map, UX500_HASH_CSDATAIN, &hstate->csdatain);
 	hstate->temp_cr = cr;
 
 	/* Save software state */
@@ -1214,7 +1214,7 @@ static int hmac_sha1_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->config.data_format	= HASH_DATA_8_BITS;
+	ctx->config.data_format	= HASH_CR_DATAFORM_8BIT;
 	ctx->config.algorithm	= HASH_ALGO_SHA1;
 	ctx->config.oper_mode	= HASH_OPER_MODE_HMAC;
 	ctx->digestsize		= SHA1_DIGEST_SIZE;
@@ -1227,7 +1227,7 @@ static int hmac_sha256_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->config.data_format	= HASH_DATA_8_BITS;
+	ctx->config.data_format	= HASH_CR_DATAFORM_8BIT;
 	ctx->config.algorithm	= HASH_ALGO_SHA256;
 	ctx->config.oper_mode	= HASH_OPER_MODE_HMAC;
 	ctx->digestsize		= SHA256_DIGEST_SIZE;
@@ -1298,7 +1298,7 @@ static int hash_cra_init(struct crypto_tfm *tfm)
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct hash_req_ctx));
 
-	ctx->config.data_format = HASH_DATA_8_BITS;
+	ctx->config.data_format = HASH_CR_DATAFORM_8BIT;
 	ctx->config.algorithm = hash_alg->conf.algorithm;
 	ctx->config.oper_mode = hash_alg->conf.oper_mode;
 
@@ -1435,6 +1435,107 @@ static void ahash_algs_unregister_all(struct hash_device_data *device_data)
 		crypto_unregister_ahash(&hash_algs[i].hash);
 }
 
+static bool ux500_hash_reg_readable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case UX500_HASH_CR:
+	case UX500_HASH_DIN:
+	case UX500_HASH_STR:
+	case UX500_HASH_H(0) ... UX500_HASH_H(7):
+	case UX500_HASH_ITCR:
+	case UX500_HASH_ITIP:
+	case UX500_HASH_ITOP:
+	case UX500_HASH_CSFULL:
+	case UX500_HASH_CSDATAIN:
+	case UX500_HASH_CSR(0) ... UX500_HASH_CSR(51):
+	case UX500_HASH_PERIPHID0:
+	case UX500_HASH_PERIPHID1:
+	case UX500_HASH_PERIPHID2:
+	case UX500_HASH_PERIPHID3:
+	case UX500_HASH_CELLID0:
+	case UX500_HASH_CELLID1:
+	case UX500_HASH_CELLID2:
+	case UX500_HASH_CELLID3:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool ux500_hash_reg_writeable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case UX500_HASH_CR:
+	case UX500_HASH_DIN:
+	case UX500_HASH_STR:
+	case UX500_HASH_ITCR:
+	case UX500_HASH_ITIP:
+	case UX500_HASH_ITOP:
+	case UX500_HASH_CSFULL:
+	case UX500_HASH_CSDATAIN:
+	case UX500_HASH_CSR(0) ... UX500_HASH_CSR(51):
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool ux500_hash_reg_writeable_noinc(struct device *dev, unsigned int reg)
+{
+	if (reg == UX500_HASH_DIN)
+		return true;
+	return false;
+}
+
+static bool ux500_hash_reg_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case UX500_HASH_CR:
+	case UX500_HASH_STR:
+	case UX500_HASH_H(0) ... UX500_HASH_H(7):
+	case UX500_HASH_ITCR:
+	case UX500_HASH_ITIP:
+	case UX500_HASH_ITOP:
+	case UX500_HASH_CSFULL:
+	case UX500_HASH_CSDATAIN:
+	case UX500_HASH_CSR(0) ... UX500_HASH_CSR(51):
+	/*
+	 * The following IDs are read-only, but to the reg cache they are
+	 * volatile, since they have values there at startup.
+	 */
+	case UX500_HASH_PERIPHID0:
+	case UX500_HASH_PERIPHID1:
+	case UX500_HASH_PERIPHID2:
+	case UX500_HASH_PERIPHID3:
+	case UX500_HASH_CELLID0:
+	case UX500_HASH_CELLID1:
+	case UX500_HASH_CELLID2:
+	case UX500_HASH_CELLID3:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const struct regmap_config ux500_hash_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	/*
+	 * Regcache is not helpful since we shoehorn tons of random data
+	 * into the hash engine, the few register reads outside of that
+	 * are not worth it. Disable the cache.
+	 */
+	.cache_type = REGCACHE_NONE,
+	.fast_io = true,
+	.max_register = 0xFFC,
+	.use_relaxed_mmio = true,
+	.readable_reg = ux500_hash_reg_readable,
+	.writeable_reg = ux500_hash_reg_writeable,
+	.volatile_reg = ux500_hash_reg_volatile,
+	.writeable_noinc_reg = ux500_hash_reg_writeable_noinc,
+};
+
 /**
  * ux500_hash_probe - Function that probes the hash hardware.
  * @pdev: The platform device.
@@ -1445,6 +1546,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	struct resource		*res = NULL;
 	struct hash_device_data *device_data;
 	struct device		*dev = &pdev->dev;
+	void __iomem *base;
 
 	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_KERNEL);
 	if (!device_data) {
@@ -1463,11 +1565,22 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	}
 
 	device_data->phybase = res->start;
-	device_data->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(device_data->base)) {
-		ret = PTR_ERR(device_data->base);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		goto out;
+	}
+	device_data->map = devm_regmap_init_mmio(dev, base,
+						 &ux500_hash_regmap_config);
+	if (IS_ERR(device_data->map)) {
+		ret = PTR_ERR(device_data->map);
 		goto out;
 	}
+	/*
+	 * We use REGCACHE_NONE, so also bypass any calls not stubbed
+	 * by that.
+	 */
+	regcache_cache_bypass(device_data->map, true);
 	spin_lock_init(&device_data->ctx_lock);
 	spin_lock_init(&device_data->power_state_lock);
 
-- 
2.37.2

