Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BC2225A5A;
	Thu,  6 Feb 2025 09:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738833705; cv=none; b=YlJMPvzsRlTVh/GNx4RCOaL+mL99g4mqqTCFJQPYxrNUcaykcvhWhM8KXlnXl/D2HYLGY6frTWIPXX68QTzMf1k/1wZI3l1LaVsMiHmCXm7lKxH+z0Z4pjElqK2jrGrP/lVH5DdEJLAN7bktzsTxtyYjZH7Qcp0QmwLHFeEALEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738833705; c=relaxed/simple;
	bh=nYDda5FW4+m+g6/rsnP84jir2XzzwghcjJbdKSiliLk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bONQvCh10Ga2sofx1SRrInfHE58x54Ok+fXaRCYaj8/S9AmiThdccMfMvZb7nEE5x0jvvUy7gYQgR2YtaSPPVdQ2WQ5UjR7KWao3gRlkocZCPo+TN48w/qqD9+vc/2RADV5SDpPUjHrQhi6xTRu9ATip4voPwF/dHViId9AW7f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KdnV7iLH; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KdnV7iLH"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 5169LUCI3525923
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 03:21:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1738833690;
	bh=asLVigdKsj1iUv23/fqk7Z+Mk0fYdr+SykqEytlDSw4=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=KdnV7iLHiR5mXbiTbnP/nkGuAP8JMA9cVvF3AswfJBZS3F7XIfXeKSSgOd5imN/zU
	 3kHoi2/tuCixSD9dIbPirAfuFAcGieoIDIYhoGX56Orgb1Tmo2B5vtFN/00jA4l3/W
	 qWzcZJlnKlUHKYW9eGBs4XLyjyvsb3t5APBF4CzQ=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 5169LUaH007674
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 6 Feb 2025 03:21:30 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 6
 Feb 2025 03:21:29 -0600
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 6 Feb 2025 03:21:30 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 5169LStC009825;
	Thu, 6 Feb 2025 03:21:29 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani
	<kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH RFC 2/3] crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)
Date: Thu, 6 Feb 2025 14:44:31 +0530
Message-ID: <20250206-dthe-v2-aes-v1-2-1e86cf683928@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
References: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add support for ECB and CBC modes in the AES Engine of DTHE V2
hardware crypto accelerator.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
PS: The hardware specs for DTHE V2 is currently under process to be
updated in the public TRM. Hence there is no public HW doc available to
share at the moment. It will be sent later as soon as it is available.

 MAINTAINERS                |   1 +
 drivers/crypto/Kconfig     |   1 +
 drivers/crypto/Makefile    |   1 +
 drivers/crypto/ti/Kconfig  |  11 +
 drivers/crypto/ti/Makefile |   1 +
 drivers/crypto/ti/dthev2.c | 749 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 764 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e3a32533cf3922d799439b14453248d23350bb18..750713cdeb97020a477f587b1006378e380e236f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23438,6 +23438,7 @@ M:	T Pratham <t-pratham@ti.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/crypto/ti,dthe-v2.yaml
+F:	drivers/crypto/ti/
 
 TI DAVINCI MACHINE SUPPORT
 M:	Bartosz Golaszewski <brgl@bgdev.pl>
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 19ab145f912ed372fac79c01ea15def033dfa2f5..c80345f8babd4057da8ca9bad4aaf96692a70857 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -855,5 +855,6 @@ config CRYPTO_DEV_SA2UL
 
 source "drivers/crypto/aspeed/Kconfig"
 source "drivers/crypto/starfive/Kconfig"
+source "drivers/crypto/ti/Kconfig"
 
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index fef18ffdb128420ea577f2c6e3afd9184d628f94..ef1cd4781b808069355196fd8e90b69ab2e099a0 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -50,3 +50,4 @@ obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
+obj-$(CONFIG_ARCH_K3) += ti/
diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
new file mode 100644
index 0000000000000000000000000000000000000000..c0f0133364251dde9f9eb60735840a1768453403
--- /dev/null
+++ b/drivers/crypto/ti/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CRYPTO_DEV_TI_DTHE_V2
+	tristate "Support for TI DTHE V2 crypto accelerators"
+	depends on CRYPTO && CRYPTO_HW && ARCH_K3
+	select CRYPTO_SKCIPHER
+	help
+	  This enables support for the TI DTHE V2 hw crypto accelerator
+	  which can be found on TI K3 SOCs. Selecting this enables use
+	  of hardware acceleration for cryptographic algorithms on
+	  these devices.
diff --git a/drivers/crypto/ti/Makefile b/drivers/crypto/ti/Makefile
new file mode 100644
index 0000000000000000000000000000000000000000..cf5fb48e70102656c7962afa6a12819e458e032c
--- /dev/null
+++ b/drivers/crypto/ti/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CRYPTO_DEV_TI_DTHE_V2) += dthev2.o
diff --git a/drivers/crypto/ti/dthev2.c b/drivers/crypto/ti/dthev2.c
new file mode 100644
index 0000000000000000000000000000000000000000..b19371a4b50c4827bc49ccd0953aa790c7f1b17f
--- /dev/null
+++ b/drivers/crypto/ti/dthev2.c
@@ -0,0 +1,749 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * K3 DTHE V2 crypto accelerator driver
+ *
+ * Copyright (C) Texas Instruments 2025 - https://www.ti.com
+ * Author: T Pratham <t-pratham@ti.com>
+ */
+
+#include <linux/dmaengine.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+#include <linux/scatterlist.h>
+
+#include <crypto/aead.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/sha2.h>
+
+#include <linux/delay.h>
+
+#define DRIVER_NAME	"dthev2"
+
+/* Registers */
+
+// AES Engine
+#define DTHE_P_AES_BASE		0x7000
+#define DTHE_P_AES_KEY1_0	0x0038
+#define DTHE_P_AES_KEY1_1	0x003C
+#define DTHE_P_AES_KEY1_2	0x0030
+#define DTHE_P_AES_KEY1_3	0x0034
+#define DTHE_P_AES_KEY1_4	0x0028
+#define DTHE_P_AES_KEY1_5	0x002C
+#define DTHE_P_AES_KEY1_6	0x0020
+#define DTHE_P_AES_KEY1_7	0x0024
+#define DTHE_P_AES_IV_IN_0	0x0040
+#define DTHE_P_AES_IV_IN_1	0x0044
+#define DTHE_P_AES_IV_IN_2	0x0048
+#define DTHE_P_AES_IV_IN_3	0x004C
+#define DTHE_P_AES_CTRL		0x0050
+#define DTHE_P_AES_C_LENGTH_0	0x0054
+#define DTHE_P_AES_C_LENGTH_1	0x0058
+#define DTHE_P_AES_AUTH_LENGTH	0x005C
+#define DTHE_P_AES_DATA_IN_OUT	0x0060
+
+#define DTHE_P_AES_SYSCONFIG	0x0084
+#define DTHE_P_AES_IRQSTATUS	0x008C
+#define DTHE_P_AES_IRQENABLE	0x0090
+
+/* Register write values and macros */
+enum dthe_aes_mode {
+	DTHE_AES_ECB = 0,
+	DTHE_AES_CBC,
+};
+
+enum aes_ctrl_mode_masks {
+	AES_CTRL_ECB_MASK = 0x00,
+	AES_CTRL_CBC_MASK = BIT(5),
+};
+
+#define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
+
+#define DTHE_AES_CTRL_DIR_ENC			BIT(2)
+
+#define DTHE_AES_CTRL_KEYSIZE_16B		BIT(3)
+#define DTHE_AES_CTRL_KEYSIZE_24B		BIT(4)
+#define DTHE_AES_CTRL_KEYSIZE_32B		(BIT(3) | BIT(4))
+
+#define DTHE_AES_CTRL_SAVE_CTX_SET		BIT(29)
+
+#define DTHE_AES_CTRL_OUTPUT_READY		BIT_MASK(0)
+#define DTHE_AES_CTRL_INPUT_READY		BIT_MASK(1)
+#define DTHE_AES_CTRL_SAVED_CTX_READY		BIT_MASK(30)
+#define DTHE_AES_CTRL_CTX_READY			BIT_MASK(31)
+
+#define DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN	GENMASK(6, 5)
+#define DTHE_AES_IRQENABLE_EN_ALL		GENMASK(3, 0)
+
+/* Driver specific struct definitions */
+
+struct dthe_tfm_ctx;
+
+/**
+ * struct dthe_data - DTHE_V2 driver instance data
+ * @dev: Device pointer
+ * @regs: Base address of the register space
+ * @list: list node for dev
+ * @dma_aes_rx: AES Rx DMA Channel
+ * @dma_aes_tx: AES Tx DMA Channel
+ * @dma_sha_tx: SHA Tx DMA Channel
+ * @aes_mutex: Mutex protecting access to AES engine
+ * @ctx: Transform context struct
+ */
+struct dthe_data {
+	struct device *dev;
+	void __iomem *regs;
+	struct list_head list;
+
+	struct dma_chan *dma_aes_rx;
+	struct dma_chan *dma_aes_tx;
+
+	struct dma_chan *dma_sha_tx;
+
+	struct mutex aes_mutex;
+
+	struct dthe_tfm_ctx *ctx;
+};
+
+/**
+ * struct dthe_list - device data list head
+ * @dev_list: linked list head
+ * @lock: Spinlock protecting accesses to the list
+ */
+struct dthe_list {
+	struct list_head dev_list;
+	spinlock_t lock;
+};
+
+/**
+ * struct dthe_aes_ctx - AES engine ctx struct
+ * @mode: AES mode
+ * @keylen: AES key length
+ * @key: AES key
+ * @enc: flag indicating encryption or decryption operation
+ * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ */
+struct dthe_aes_ctx {
+	enum dthe_aes_mode mode;
+	unsigned int keylen;
+	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
+	int enc;
+	struct completion aes_compl;
+};
+
+/**
+ * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
+ * @dev_data: Device data struct pointer
+ * @ctx_info: Union of ctx structs of various sub-components of DTHE_V2
+ */
+struct dthe_tfm_ctx {
+	struct dthe_data *dev_data;
+	union {
+		struct dthe_aes_ctx *aes_ctx;
+	} ctx_info;
+};
+
+/**
+ * struct dthe_mapped_sg - struct storing info of DMA mapped scatterlists
+ * @sg: Scatterlist mapped
+ * @nents: nents of sg mapped
+ * @dir: DMA data direction
+ * @dev: DMA device struct to which sg is mapped
+ */
+struct dthe_mapped_sg {
+	struct scatterlist *sg;
+	int nents;
+	enum dma_data_direction dir;
+	struct device *dev;
+};
+
+/**
+ * struct dthe_dma_data - struct for passing necessary data into DMA callback function
+ * @req: pointer to store crypto request object
+ * @mapped_sg: Array to store data of mapped scatterlists in this DMA transfer
+ */
+struct dthe_dma_data {
+	void *req;
+	struct dthe_mapped_sg mapped_sg[2];
+};
+
+/* Struct definitions end */
+
+static struct dthe_list dthe_dev_list = {
+	.dev_list = LIST_HEAD_INIT(dthe_dev_list.dev_list),
+	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
+};
+
+static struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+{
+	struct dthe_data *dev_data;
+
+	if (ctx->dev_data)
+		return ctx->dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	if (dev_data)
+		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+	spin_unlock_bh(&dthe_dev_list.lock);
+
+	return dev_data;
+}
+
+/**********************************************************************
+ *				AES
+ **********************************************************************/
+
+static int dthe_cipher_cra_init(struct crypto_skcipher *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
+	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
+
+	memzero_explicit(ctx, sizeof(*ctx));
+	ctx->dev_data = dev_data;
+	ctx->ctx_info.aes_ctx = kzalloc(sizeof(*ctx->ctx_info.aes_ctx), GFP_KERNEL);
+	if (!ctx->ctx_info.aes_ctx)
+		return -ENOMEM;
+
+	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
+	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
+
+	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
+	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
+
+	return 0;
+}
+
+static void dthe_cipher_cra_exit(struct crypto_skcipher *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+
+	kfree(ctx->ctx_info.aes_ctx);
+	writel_relaxed(0, aes_base_reg + DTHE_P_AES_IRQENABLE);
+}
+
+static int dthe_ecb_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->ctx_info.aes_ctx->mode = DTHE_AES_ECB;
+	ctx->ctx_info.aes_ctx->keylen = keylen;
+	memcpy(ctx->ctx_info.aes_ctx->key, key, keylen);
+
+	return 0;
+}
+
+static int dthe_cbc_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->ctx_info.aes_ctx->mode = DTHE_AES_CBC;
+	ctx->ctx_info.aes_ctx->keylen = keylen;
+	memcpy(ctx->ctx_info.aes_ctx->key, key, keylen);
+
+	return 0;
+}
+
+static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx, u32 *iv_in)
+{
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_ctx *actx = ctx->ctx_info.aes_ctx;
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+	u32 ctrl_val = 0;
+
+	writel_relaxed(actx->key[0], aes_base_reg + DTHE_P_AES_KEY1_0);
+	writel_relaxed(actx->key[1], aes_base_reg + DTHE_P_AES_KEY1_1);
+	writel_relaxed(actx->key[2], aes_base_reg + DTHE_P_AES_KEY1_2);
+	writel_relaxed(actx->key[3], aes_base_reg + DTHE_P_AES_KEY1_3);
+
+	if (actx->keylen > 16) {
+		writel_relaxed(actx->key[4], aes_base_reg + DTHE_P_AES_KEY1_4);
+		writel_relaxed(actx->key[5], aes_base_reg + DTHE_P_AES_KEY1_5);
+	}
+	if (actx->keylen == 32) {
+		writel_relaxed(actx->key[6], aes_base_reg + DTHE_P_AES_KEY1_6);
+		writel_relaxed(actx->key[7], aes_base_reg + DTHE_P_AES_KEY1_7);
+	}
+
+	if (actx->enc)
+		ctrl_val |= DTHE_AES_CTRL_DIR_ENC;
+
+	if (actx->keylen == AES_KEYSIZE_128)
+		ctrl_val |= DTHE_AES_CTRL_KEYSIZE_16B;
+	else if (actx->keylen == AES_KEYSIZE_192)
+		ctrl_val |= DTHE_AES_CTRL_KEYSIZE_24B;
+	else
+		ctrl_val |= DTHE_AES_CTRL_KEYSIZE_32B;
+
+	// Write AES mode
+	ctrl_val &= DTHE_AES_CTRL_MODE_CLEAR_MASK;
+	switch (ctx->ctx_info.aes_ctx->mode) {
+	case DTHE_AES_ECB:
+		ctrl_val |= AES_CTRL_ECB_MASK;
+		break;
+	case DTHE_AES_CBC:
+		ctrl_val |= AES_CTRL_CBC_MASK;
+		break;
+	}
+
+	if (iv_in) {
+		ctrl_val |= DTHE_AES_CTRL_SAVE_CTX_SET;
+		for (int i = 0; i < AES_BLOCK_SIZE / sizeof(int); ++i)
+			writel_relaxed(iv_in[i], aes_base_reg + DTHE_P_AES_IV_IN_0 + (4 * i));
+	}
+
+	writel_relaxed(ctrl_val, aes_base_reg + DTHE_P_AES_CTRL);
+}
+
+static void dthe_aes_dma_in_callback(void *data)
+{
+	struct dthe_dma_data *rxd = (struct dthe_dma_data *)data;
+	struct skcipher_request *req = (struct skcipher_request *)rxd->req;
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	dma_unmap_sg(rxd->mapped_sg[0].dev, rxd->mapped_sg[0].sg,
+		     rxd->mapped_sg[0].nents, rxd->mapped_sg[0].dir);
+	if (rxd->mapped_sg[0].dir != DMA_BIDIRECTIONAL)
+		dma_unmap_sg(rxd->mapped_sg[1].dev, rxd->mapped_sg[1].sg,
+			     rxd->mapped_sg[1].nents, rxd->mapped_sg[1].dir);
+
+	// For modes other than ECB, read IV_OUT
+	if (ctx->ctx_info.aes_ctx->mode != DTHE_AES_ECB) {
+		void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+		u32 *iv_out = (u32 *)req->iv;
+
+		for (int i = 0; i < AES_BLOCK_SIZE / sizeof(int); ++i)
+			iv_out[i] = readl_relaxed(aes_base_reg + DTHE_P_AES_IV_IN_0 + (4 * i));
+	}
+
+	skcipher_request_complete(req, 0);
+
+	mutex_unlock(&dev_data->aes_mutex);
+	kfree(rxd);
+	complete(&ctx->ctx_info.aes_ctx->aes_compl);
+}
+
+static int dthe_aes_run(struct skcipher_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_ctx *actx = ctx->ctx_info.aes_ctx;
+
+	unsigned int len = req->cryptlen;
+	struct scatterlist *src = req->src;
+	struct scatterlist *dst = req->dst;
+
+	int src_nents = sg_nents_for_len(src, len);
+	int dst_nents;
+
+	int src_mapped_nents;
+	int dst_mapped_nents;
+
+	bool diff_dst;
+	enum dma_data_direction src_dir, dst_dir;
+
+	struct device *tx_dev, *rx_dev;
+	struct dma_async_tx_descriptor *desc_in, *desc_out;
+
+	struct dthe_dma_data *rx_data;
+
+	int ret;
+
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+
+	if (src == dst) {
+		diff_dst = false;
+		src_dir = DMA_BIDIRECTIONAL;
+		dst_dir = DMA_BIDIRECTIONAL;
+	} else {
+		diff_dst = true;
+		src_dir = DMA_TO_DEVICE;
+		dst_dir  = DMA_FROM_DEVICE;
+	}
+
+	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
+	rx_dev = dmaengine_get_dma_device(dev_data->dma_aes_rx);
+
+	src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
+	if (src_mapped_nents == 0) {
+		ret = -EINVAL;
+		goto aes_err;
+	}
+
+	if (!diff_dst) {
+		dst_nents = src_nents;
+		dst_mapped_nents = src_mapped_nents;
+	} else {
+		dst_nents = sg_nents_for_len(dst, len);
+		dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
+		if (dst_mapped_nents == 0) {
+			dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+			ret = -EINVAL;
+			goto aes_err;
+		}
+	}
+
+	desc_in = dmaengine_prep_slave_sg(dev_data->dma_aes_rx, dst, dst_mapped_nents,
+					  DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_in) {
+		dev_err(dev_data->dev, "IN prep_slave_sg() failed\n");
+		ret = -EINVAL;
+		goto aes_err;
+	}
+
+	desc_out = dmaengine_prep_slave_sg(dev_data->dma_aes_tx, src, src_mapped_nents,
+					   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_out) {
+		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
+		ret = -EINVAL;
+		goto aes_err;
+	}
+
+	rx_data = kzalloc(sizeof(*rx_data), GFP_KERNEL);
+	if (!rx_data) {
+		ret = -ENOMEM;
+		goto aes_err;
+	}
+
+	rx_data->mapped_sg[0] = (struct dthe_mapped_sg) {
+		.sg = src,
+		.nents = src_nents,
+		.dir = src_dir,
+		.dev = tx_dev
+	};
+	rx_data->mapped_sg[1] = (struct dthe_mapped_sg) {
+		.sg = dst,
+		.nents = dst_nents,
+		.dir = dst_dir,
+		.dev = rx_dev
+	};
+	rx_data->req = req;
+
+	desc_in->callback = dthe_aes_dma_in_callback;
+	desc_in->callback_param = rx_data;
+
+	init_completion(&actx->aes_compl);
+
+	mutex_lock(&dev_data->aes_mutex);
+
+	if (actx->mode == DTHE_AES_ECB)
+		dthe_aes_set_ctrl_key(ctx, NULL);
+	else
+		dthe_aes_set_ctrl_key(ctx, (u32 *)req->iv);
+
+	writel_relaxed(req->cryptlen, aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+
+	dmaengine_submit(desc_in);
+	dmaengine_submit(desc_out);
+
+	dma_async_issue_pending(dev_data->dma_aes_rx);
+	dma_async_issue_pending(dev_data->dma_aes_tx);
+
+	// Need to do a timeout to ensure mutex gets unlocked if DMA callback fails for any reason
+	ret = wait_for_completion_timeout(&actx->aes_compl, msecs_to_jiffies(2000));
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+		if (dst_dir != DMA_BIDIRECTIONAL)
+			dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+
+		for (int i = 0; i < AES_BLOCK_SIZE / sizeof(int); ++i)
+			readl_relaxed(aes_base_reg + DTHE_P_AES_DATA_IN_OUT + (4 * i));
+		for (int i = 0; i < AES_BLOCK_SIZE / sizeof(int); ++i)
+			readl_relaxed(aes_base_reg + DTHE_P_AES_IV_IN_0 + (4 * i));
+		skcipher_request_complete(req, ret);
+		kfree(rx_data);
+		mutex_unlock(&dev_data->aes_mutex);
+		goto aes_err;
+	}
+
+	return 0;
+
+aes_err:
+	mutex_unlock(&dev_data->aes_mutex);
+	return ret;
+}
+
+static int dthe_aes_crypt(struct skcipher_request *req, int enc)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	/*
+	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
+	 * If data length input is zero, no need to do any operation.
+	 */
+	if (req->cryptlen % AES_BLOCK_SIZE) {
+		skcipher_request_complete(req, -EINVAL);
+		return -EINVAL;
+	}
+	if (req->cryptlen == 0) {
+		skcipher_request_complete(req, 0);
+		return 0;
+	}
+
+	ctx->ctx_info.aes_ctx->enc = enc;
+	return dthe_aes_run(req);
+}
+
+static int dthe_aes_encrypt(struct skcipher_request *req)
+{
+	return dthe_aes_crypt(req, 1);
+}
+
+static int dthe_aes_decrypt(struct skcipher_request *req)
+{
+	return dthe_aes_crypt(req, 0);
+}
+
+static unsigned int refcnt;
+static DEFINE_MUTEX(refcnt_lock);
+
+static struct skcipher_alg cipher_algs[] = {
+	{
+		.setkey	= dthe_ecb_aes_setkey,
+		.encrypt	= dthe_aes_encrypt,
+		.decrypt	= dthe_aes_decrypt,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.base	= {
+			.cra_name	= "ecb(aes)",
+			.cra_driver_name	= "ecb-aes-dthe_v2",
+			.cra_priority	= 30000,
+			.cra_flags	= CRYPTO_ALG_TYPE_SKCIPHER |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_alignmask	= AES_BLOCK_SIZE - 1,
+			.cra_blocksize	= AES_BLOCK_SIZE,
+			.cra_ctxsize	= sizeof(struct dthe_tfm_ctx),
+			.cra_module	= THIS_MODULE,
+		},
+		.init	= dthe_cipher_cra_init,
+		.exit	= dthe_cipher_cra_exit
+	}, /* ECB AES*/
+	{
+		.setkey = dthe_cbc_aes_setkey,
+		.encrypt	= dthe_aes_encrypt,
+		.decrypt	= dthe_aes_decrypt,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.base	= {
+			.cra_name	= "cbc(aes)",
+			.cra_driver_name	 = "cbc-aes-dthe_v2",
+			.cra_priority	= 30000,
+			.cra_flags	= CRYPTO_ALG_TYPE_SKCIPHER |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_alignmask	= AES_BLOCK_SIZE - 1,
+			.cra_blocksize	= AES_BLOCK_SIZE,
+			.cra_ctxsize	= sizeof(struct dthe_tfm_ctx),
+			.cra_module	= THIS_MODULE,
+		},
+		.init	= dthe_cipher_cra_init,
+		.exit	= dthe_cipher_cra_exit
+	}, /* CBC AES */
+};
+
+static int dthe_dma_init(struct dthe_data *dev_data)
+{
+	int ret;
+	struct dma_slave_config cfg;
+
+	dev_data->dma_aes_rx = NULL;
+	dev_data->dma_aes_tx = NULL;
+	dev_data->dma_sha_tx = NULL;
+
+	dev_data->dma_aes_rx = dma_request_chan(dev_data->dev, "rx");
+	if (IS_ERR(dev_data->dma_aes_rx)) {
+		return dev_err_probe(dev_data->dev, PTR_ERR(dev_data->dma_aes_rx),
+				     "Unable to request rx DMA channel\n");
+	}
+
+	dev_data->dma_aes_tx = dma_request_chan(dev_data->dev, "tx1");
+	if (IS_ERR(dev_data->dma_aes_tx)) {
+		ret = dev_err_probe(dev_data->dev, PTR_ERR(dev_data->dma_aes_tx),
+				    "Unable to request tx1 DMA channel\n");
+		goto err_dma_aes_tx;
+	}
+
+	dev_data->dma_sha_tx = dma_request_chan(dev_data->dev, "tx2");
+	if (IS_ERR(dev_data->dma_sha_tx)) {
+		ret = dev_err_probe(dev_data->dev, PTR_ERR(dev_data->dma_sha_tx),
+				    "Unable to request tx2 DMA channel\n");
+		goto err_dma_sha_tx;
+	}
+
+	memzero_explicit(&cfg, sizeof(cfg));
+
+	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.src_maxburst = 4;
+
+	ret = dmaengine_slave_config(dev_data->dma_aes_rx, &cfg);
+	if (ret) {
+		dev_err(dev_data->dev, "Can't configure IN dmaengine slave: %d\n", ret);
+		goto err_dma_config;
+	}
+
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_maxburst = 4;
+
+	ret = dmaengine_slave_config(dev_data->dma_aes_tx, &cfg);
+	if (ret) {
+		dev_err(dev_data->dev, "Can't configure OUT dmaengine slave: %d\n", ret);
+		goto err_dma_config;
+	}
+
+	memzero_explicit(&cfg, sizeof(cfg));
+
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_maxburst = 32;
+
+	ret = dmaengine_slave_config(dev_data->dma_sha_tx, &cfg);
+	if (ret) {
+		dev_err(dev_data->dev, "Can't configure OUT2 dmaengine slave: %d\n", ret);
+		goto err_dma_config;
+	}
+
+	return 0;
+
+err_dma_config:
+	dma_release_channel(dev_data->dma_sha_tx);
+err_dma_sha_tx:
+	dma_release_channel(dev_data->dma_aes_tx);
+err_dma_aes_tx:
+	dma_release_channel(dev_data->dma_aes_rx);
+
+	return ret;
+}
+
+static int dthe_register_algs(void)
+{
+	int ret = 0;
+
+	ret |= crypto_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+
+	return ret;
+}
+
+static void dthe_unregister_algs(void)
+{
+	crypto_unregister_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+}
+
+static int dthe_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct dthe_data *dev_data;
+	int ret;
+
+	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	dev_data->dev = dev;
+	dev_data->regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(dev_data->regs))
+		return PTR_ERR(dev_data->regs);
+
+	platform_set_drvdata(pdev, dev_data);
+
+	ret = dthe_dma_init(dev_data);
+	if (ret)
+		return ret;
+
+	spin_lock(&dthe_dev_list.lock);
+	list_add(&dev_data->list, &dthe_dev_list.dev_list);
+	spin_unlock(&dthe_dev_list.lock);
+
+	mutex_init(&dev_data->aes_mutex);
+
+	mutex_lock(&refcnt_lock);
+	if (!refcnt) {
+		ret = dthe_register_algs();
+		if (ret) {
+			mutex_unlock(&refcnt_lock);
+			dev_err(dev, "Failed to register algs\n");
+
+			spin_lock(&dthe_dev_list.lock);
+			list_del(&dev_data->list);
+			spin_unlock(&dthe_dev_list.lock);
+
+			mutex_destroy(&dev_data->aes_mutex);
+
+			dma_release_channel(dev_data->dma_aes_rx);
+			dma_release_channel(dev_data->dma_aes_tx);
+			dma_release_channel(dev_data->dma_sha_tx);
+
+			return ret;
+		}
+	}
+	refcnt++;
+	mutex_unlock(&refcnt_lock);
+
+	return 0;
+}
+
+static void dthe_remove(struct platform_device *pdev)
+{
+	struct dthe_data *dev_data = platform_get_drvdata(pdev);
+
+	spin_lock(&dthe_dev_list.lock);
+	list_del(&dev_data->list);
+	spin_unlock(&dthe_dev_list.lock);
+
+	mutex_destroy(&dev_data->aes_mutex);
+
+	mutex_lock(&refcnt_lock);
+	if (!--refcnt)
+		dthe_unregister_algs();
+
+	mutex_unlock(&refcnt_lock);
+
+	dma_release_channel(dev_data->dma_aes_rx);
+	dma_release_channel(dev_data->dma_aes_tx);
+	dma_release_channel(dev_data->dma_sha_tx);
+}
+
+static const struct of_device_id dthe_of_match[] = {
+	{ .compatible = "ti,dthe-v2", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, dthe_of_match);
+
+static struct platform_driver dthe_driver = {
+	.probe	= dthe_probe,
+	.remove	= dthe_remove,
+	.driver = {
+		.name		= DRIVER_NAME,
+		.of_match_table	= dthe_of_match,
+	},
+};
+
+module_platform_driver(dthe_driver);
+
+MODULE_AUTHOR("T Pratham <t-pratham@ti.com>");
+MODULE_DESCRIPTION("Texas Instruments DTHE V2 driver");
+MODULE_LICENSE("GPL");

-- 
2.34.1

