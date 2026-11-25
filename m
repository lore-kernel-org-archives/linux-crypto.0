Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=119.15.109.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795640753;
	b=cQuQ2MniZlXhbC3y+mUNquXYSooPbdRt6olrMvGs7bcZes3NvN9hl18eQ0IsVuZV6dMw
	 M3mz9uhOVJEziIS9UL+V9/+JYj3e75FDLl+QNfxMcOkkO2S/xM5OuuwyJRjfNhe4pRZe4
	 4sJtSiAezJCzvfjYRqBSPhqRF8Ea2DjtIH91/zC33a7C8DS8BPQPN0D9JBPh7AE5lqzXV
	 mfl+1yKoBrplhJRAdw/wQ6LGxVKoxN1kdoGlmMCTzVGm8xlwm02i8fTeeh6MPXTlTWv7J
	 tEYWglzcZ1swkwuHPCJm+qSTQKCquWiRYWJD3IffWmUfnxIocdMuRc85Ml9f+lLP6gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795640753;
	h=DMARC-Filter:Received:DKIM-Signature:X-GPT-Reason:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JPPmqpjy/HV2rKVm5MUH30TqlPi5GULmYFV4J3H3KF8=;
	b=ehcnd872aA8oWiLkaeC6jrTJQ1qjyqgxl1cxMjX0EvG09QwSr02NcpEmuaE0M/XKRro1
	 IlzNz+9kzrQ+Mvx7bcnZ4HN/W9Xtzj0F02twYuTxUnwpQx2RMaYi5VVyAHu9F03/gl2E7
	 o0B8WyTKWkP5aLd0FOCnYL9X8Pm/yjo84GDALq2Xh4uI2t31+eEmxTopjYEDtDZptCMwI
	 XTeCfyoDCC04TD8MrPur+2SGH6g73SsbEExeFZYWiVewzWPeGbbjqLXY89KYbUzPNAb0s
	 w8XU139BiOnVHv7Qtf1DxMlWlg+XT+ZcZKCo0nCb1p/jEUsvV2ayZlBU4BDNBr8gjXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=d-silva.org;
	spf=pass smtp.mailfrom=d-silva.org;
	dkim=pass header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=BCCVnob2;
	arc=none smtp.remote-ip=119.15.109.137
Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A84606A329;
	Wed, 25 Nov 2026 21:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97A84606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=BCCVnob2
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id A9F014C962;
	Thu, 26 Nov 2026 08:05:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1795640744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JPPmqpjy/HV2rKVm5MUH30TqlPi5GULmYFV4J3H3KF8=;
	b=BCCVnob2XQ8ZoIsHsKiUYKA6IJnmmvGVJuUnLBo49nYa1rgnARhTXRQQw3vzpDEEvfzVzk
	iVulYSCCNKzS9qORG/y5QlRgjanwFyywoWe+huGvnUW3r63SJPshuwCBPFbEr15kFJAkZs
	m+zMJBtw8YicwRMYnB1sM5AF3QUbQsKFX7AqiLsRNAYrS6Zi9FAy+scx+P+8S+IqyMSmhe
	sqqcF1W9VzCu4PLvxSWlK59shLKErYcaMx/iCoeQNaTvguK672o88KuqUxgxNCI4ZUHOdm
	29JTnjRqYrCAKyGzCbkYi8fI7C+78n6Kd+NyMTRvLSTLoyHlRUMd1caiilyqJA==
X-GPT-Reason: legitimate; the message is a technical software patch
	notification (Linux kernel style) that perfectly aligns with the
	mailbox's known user (alastair@d-silva.org); the sender domain
	(d-silva.org) matches the recipient domain and the "From" header;
	there are no phishing markers, no urgency tactics, and the content
	is purely technical/functional.
From: Alastair D'Silva <alastair@d-silva.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
Subject: [PATCH 2/4] hwrng: sun55i-ce - Add Allwinner CE v5 TRNG driver
Date: Thu, 26 Nov 2026 08:05:30 +1100
Message-ID: <20261125210532.695823-3-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125210532.695823-1-alastair@d-silva.org>
References: <20261125210532.695823-1-alastair@d-silva.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a hardware random number generator driver for Allwinner CE v5.
CE v5 uses 40-bit byte-addressed descriptors incompatible with sun8i-ce.
This enables /dev/hwrng on A523 and A733 SoCs.

Assisted-by: LLM
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 MAINTAINERS                             |   1 +
 drivers/char/hw_random/Kconfig          |  13 +
 drivers/char/hw_random/Makefile         |   1 +
 drivers/char/hw_random/sun55i-ce-trng.c | 377 ++++++++++++++++++++++++
 4 files changed, 392 insertions(+)
 create mode 100644 drivers/char/hw_random/sun55i-ce-trng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 757ab4e59f61..b5bdbf2b4698 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -897,6 +897,7 @@ M:	Alastair D'Silva <alastair@d-silva.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml
+F:	drivers/char/hw_random/sun55i-ce-trng.c
 
 ALLWINNER CPUFREQ DRIVER
 M:	Yangtao Li <tiny.windzz@gmail.com>
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1bf5e3f8a557..caa9f2286801 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -647,6 +647,19 @@ config HW_RANDOM_QCOM
 	  To compile this driver as a module, choose M here. The
 	  module will be called qcom-rng. If unsure, say N.
 
+config HW_RANDOM_SUN55I_CE
+	tristate "Allwinner CE v5 True Random Number Generator support"
+	depends on ARCH_SUNXI || COMPILE_TEST
+	depends on HAS_IOMEM
+	default ARCH_SUNXI
+	help
+	  This driver provides kernel-side support for the True Random Number
+	  Generator in the Allwinner Crypto Engine v5 found on A523 and A733
+	  SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sun55i-ce-trng.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 8fce2aa6cf7d..32e07990eefe 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_HW_RANDOM_ROCKCHIP) += rockchip-rng.o
 obj-$(CONFIG_HW_RANDOM_JH7110) += jh7110-trng.o
 obj-$(CONFIG_HW_RANDOM_XILINX) += xilinx-trng.o
 obj-$(CONFIG_HW_RANDOM_QCOM) += qcom-rng.o
+obj-$(CONFIG_HW_RANDOM_SUN55I_CE) += sun55i-ce-trng.o
diff --git a/drivers/char/hw_random/sun55i-ce-trng.c b/drivers/char/hw_random/sun55i-ce-trng.c
new file mode 100644
index 000000000000..6d623512797a
--- /dev/null
+++ b/drivers/char/hw_random/sun55i-ce-trng.c
@@ -0,0 +1,377 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Allwinner CE v5 True Random Number Generator driver
+ *
+ * Copyright (C) 2026 Alastair D'Silva <alastair@d-silva.org>
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/property.h>
+#include <linux/reset.h>
+#include <linux/string.h>
+
+#define CE_REG_TSK0			0x00
+#define CE_REG_TSK1			0x04
+#define CE_REG_ICR			0x08
+#define CE_REG_ISR			0x0c
+#define CE_REG_TLR			0x10
+#define CE_REG_ERR			0x18
+#define CE_REG_LPC			0xd0
+
+#define CE_MAX_SG			8
+#define CE_TRNG_FLOW			2
+#define CE_ISR_FLOW_MASK(flow)		(GENMASK(1, 0) << ((flow) * 2))
+#define CE_ICR_FLOW_EN(flow)		BIT(flow)
+#define CE_TLR_HASH_RBG_START		BIT(10)
+#define CE_ERR_FLOW_MASK(flow)		(GENMASK(7, 0) << ((flow) * 8))
+#define CE_LPC_DBL_ENT_SRC_EN		BIT(1)
+
+#define CE_COMM_LPKG			BIT(12)
+#define CE_COMM_IE			BIT(16)
+#define CE_CMD_HASH_SHA256		3
+#define CE_CMD_RNG_TRNG			2
+#define CE_CMD_RNG_SHIFT		8
+
+#define CE_TRNG_CHUNK_BYTES		32
+#define CE_TRNG_TIMEOUT_MS		100
+#define CE_AUTOSUSPEND_DELAY_MS		100
+
+struct sun55i_ce_sg {
+	u8 src_addr[5];
+	u8 dst_addr[5];
+	u8 pad[2];
+	__le32 src_len;
+	__le32 dst_len;
+} __packed;
+
+struct sun55i_ce_task {
+	__le32 comm_ctl;
+	__le32 main_cmd;
+	u8 data_len[5];
+	u8 key_addr[5];
+	u8 iv_addr[5];
+	u8 pad;
+	struct sun55i_ce_sg sg[CE_MAX_SG];
+	u8 next_sg_addr[5];
+	u8 next_task_addr[5];
+	u8 pad2[2];
+	__le32 reserved[3];
+} __packed;
+
+static_assert(sizeof(struct sun55i_ce_sg) == 20);
+static_assert(sizeof(struct sun55i_ce_task) == 208);
+
+struct sun55i_ce_variant {
+	bool has_lpc;
+};
+
+static const char * const sun55i_ce_clk_names[] = {
+	"bus", "mod", "ram", "trng",
+};
+
+struct sun55i_ce_trng {
+	struct device *dev;
+	void __iomem *base;
+	const struct sun55i_ce_variant *variant;
+	struct clk_bulk_data clks[ARRAY_SIZE(sun55i_ce_clk_names)];
+	struct reset_control *reset;
+	struct mutex lock; /* serializes hardware access */
+	struct completion done;
+	struct sun55i_ce_task *task;
+	dma_addr_t task_dma;
+	u8 *rng_buf;
+	dma_addr_t buf_dma;
+	struct hwrng rng;
+};
+
+static void sun55i_ce_set_addr40(u8 dst[5], dma_addr_t addr)
+{
+	dst[0] = lower_32_bits(addr) & 0xff;
+	dst[1] = (lower_32_bits(addr) >> 8) & 0xff;
+	dst[2] = (lower_32_bits(addr) >> 16) & 0xff;
+	dst[3] = (lower_32_bits(addr) >> 24) & 0xff;
+	dst[4] = upper_32_bits(addr) & 0xff;
+}
+
+static irqreturn_t sun55i_ce_trng_irq(int irq, void *data)
+{
+	struct sun55i_ce_trng *priv = data;
+	u32 isr;
+
+	isr = readl(priv->base + CE_REG_ISR);
+	if (!(isr & CE_ISR_FLOW_MASK(CE_TRNG_FLOW)))
+		return IRQ_NONE;
+
+	writel(isr & CE_ISR_FLOW_MASK(CE_TRNG_FLOW), priv->base + CE_REG_ISR);
+	complete(&priv->done);
+
+	return IRQ_HANDLED;
+}
+
+static int sun55i_ce_hw_init(struct sun55i_ce_trng *priv)
+{
+	int ret;
+
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(priv->clks), priv->clks);
+	if (ret)
+		return ret;
+
+	ret = reset_control_deassert(priv->reset);
+	if (ret) {
+		clk_bulk_disable_unprepare(ARRAY_SIZE(priv->clks), priv->clks);
+		return ret;
+	}
+
+	if (priv->variant->has_lpc)
+		writel(readl(priv->base + CE_REG_LPC) | CE_LPC_DBL_ENT_SRC_EN,
+		       priv->base + CE_REG_LPC);
+
+	return 0;
+}
+
+static void sun55i_ce_hw_fini(struct sun55i_ce_trng *priv)
+{
+	reset_control_assert(priv->reset);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(priv->clks), priv->clks);
+}
+
+static void sun55i_ce_hw_fini_action(void *data)
+{
+	struct sun55i_ce_trng *priv = data;
+
+	if (!pm_runtime_status_suspended(priv->dev))
+		sun55i_ce_hw_fini(priv);
+}
+
+static int sun55i_ce_trng_read_chunk(struct sun55i_ce_trng *priv)
+{
+	u32 esr;
+
+	memset(priv->task, 0, sizeof(*priv->task));
+	priv->task->comm_ctl = cpu_to_le32(CE_TRNG_FLOW | CE_COMM_LPKG |
+					   CE_COMM_IE);
+	priv->task->main_cmd = cpu_to_le32(CE_CMD_HASH_SHA256 |
+					   (CE_CMD_RNG_TRNG << CE_CMD_RNG_SHIFT));
+	sun55i_ce_set_addr40(priv->task->sg[0].dst_addr, priv->buf_dma);
+	priv->task->sg[0].dst_len = cpu_to_le32(CE_TRNG_CHUNK_BYTES);
+
+	reinit_completion(&priv->done);
+
+	writel(CE_ISR_FLOW_MASK(CE_TRNG_FLOW), priv->base + CE_REG_ISR);
+	writel(readl(priv->base + CE_REG_ICR) | CE_ICR_FLOW_EN(CE_TRNG_FLOW),
+	       priv->base + CE_REG_ICR);
+	writel(lower_32_bits(priv->task_dma), priv->base + CE_REG_TSK0);
+	writel(upper_32_bits(priv->task_dma), priv->base + CE_REG_TSK1);
+	writel(CE_TLR_HASH_RBG_START, priv->base + CE_REG_TLR);
+
+	if (!wait_for_completion_timeout(&priv->done,
+					 msecs_to_jiffies(CE_TRNG_TIMEOUT_MS))) {
+		writel(readl(priv->base + CE_REG_ICR) & ~CE_ICR_FLOW_EN(CE_TRNG_FLOW),
+		       priv->base + CE_REG_ICR);
+		writel(0, priv->base + CE_REG_TLR);
+		writel(0, priv->base + CE_REG_TSK0);
+		writel(0, priv->base + CE_REG_TSK1);
+		dev_err_ratelimited(priv->dev, "TRNG timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	writel(readl(priv->base + CE_REG_ICR) & ~CE_ICR_FLOW_EN(CE_TRNG_FLOW),
+	       priv->base + CE_REG_ICR);
+
+	esr = readl(priv->base + CE_REG_ERR) & CE_ERR_FLOW_MASK(CE_TRNG_FLOW);
+	if (esr) {
+		dev_err_ratelimited(priv->dev, "CE error status: 0x%x\n", esr);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sun55i_ce_trng_read(struct hwrng *rng, void *buf, size_t max,
+			       bool wait)
+{
+	struct sun55i_ce_trng *priv = container_of(rng, struct sun55i_ce_trng,
+						   rng);
+	u8 *dst = buf;
+	size_t read = 0;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(priv->dev);
+	if (ret < 0)
+		return ret;
+	ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	while (read < max) {
+		size_t chunk = min_t(size_t, max - read, CE_TRNG_CHUNK_BYTES);
+
+		ret = sun55i_ce_trng_read_chunk(priv);
+		if (ret)
+			break;
+
+		memcpy(dst + read, priv->rng_buf, chunk);
+		memzero_explicit(priv->rng_buf, CE_TRNG_CHUNK_BYTES);
+		read += chunk;
+	}
+
+	mutex_unlock(&priv->lock);
+
+	pm_runtime_put_autosuspend(priv->dev);
+
+	return read ? read : ret;
+}
+
+static int sun55i_ce_trng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sun55i_ce_trng *priv;
+	int irq, ret, i;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	priv->variant = device_get_match_data(dev);
+	if (!priv->variant)
+		return -EINVAL;
+
+	mutex_init(&priv->lock);
+	init_completion(&priv->done);
+
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to set DMA mask\n");
+
+	priv->task = dmam_alloc_coherent(dev, sizeof(*priv->task),
+					 &priv->task_dma, GFP_KERNEL);
+	if (!priv->task)
+		return -ENOMEM;
+
+	priv->rng_buf = dmam_alloc_coherent(dev, CE_TRNG_CHUNK_BYTES,
+					    &priv->buf_dma, GFP_KERNEL);
+	if (!priv->rng_buf)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(sun55i_ce_clk_names); i++)
+		priv->clks[i].id = sun55i_ce_clk_names[i];
+
+	ret = devm_clk_bulk_get(dev, ARRAY_SIZE(priv->clks), priv->clks);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to get clocks\n");
+
+	priv->reset = devm_reset_control_get_exclusive(dev, NULL);
+	if (IS_ERR(priv->reset))
+		return dev_err_probe(dev, PTR_ERR(priv->reset),
+				     "Failed to get reset\n");
+
+	ret = sun55i_ce_hw_init(priv);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to initialize hardware\n");
+
+	platform_set_drvdata(pdev, priv);
+
+	ret = devm_add_action_or_reset(dev, sun55i_ce_hw_fini_action, priv);
+	if (ret)
+		return ret;
+
+	/* Request IRQ after hw_fini action so devm frees it before gating clocks. */
+	ret = devm_request_irq(dev, irq, sun55i_ce_trng_irq, 0,
+			       dev_name(dev), priv);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to request IRQ\n");
+
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_set_autosuspend_delay(dev, CE_AUTOSUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
+
+	priv->rng.name = dev_name(dev);
+	priv->rng.read = sun55i_ce_trng_read;
+	priv->rng.quality = 512;
+
+	ret = devm_hwrng_register(dev, &priv->rng);
+	if (ret) {
+		pm_runtime_put_noidle(dev);
+		return dev_err_probe(dev, ret, "Failed to register hwrng\n");
+	}
+
+	pm_runtime_put_autosuspend(dev);
+
+	return 0;
+}
+
+static int sun55i_ce_trng_suspend(struct device *dev)
+{
+	struct sun55i_ce_trng *priv = dev_get_drvdata(dev);
+
+	sun55i_ce_hw_fini(priv);
+
+	return 0;
+}
+
+static int sun55i_ce_trng_resume(struct device *dev)
+{
+	struct sun55i_ce_trng *priv = dev_get_drvdata(dev);
+
+	return sun55i_ce_hw_init(priv);
+}
+
+static DEFINE_RUNTIME_DEV_PM_OPS(sun55i_ce_trng_pm_ops,
+				 sun55i_ce_trng_suspend,
+				 sun55i_ce_trng_resume, NULL);
+
+static const struct sun55i_ce_variant sun55i_a523_variant = {
+	.has_lpc = false,
+};
+
+static const struct sun55i_ce_variant sun60i_a733_variant = {
+	.has_lpc = true,
+};
+
+static const struct of_device_id sun55i_ce_trng_of_match[] = {
+	{ .compatible = "allwinner,sun60i-a733-crypto",
+	  .data = &sun60i_a733_variant },
+	{ .compatible = "allwinner,sun55i-a523-crypto",
+	  .data = &sun55i_a523_variant },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sun55i_ce_trng_of_match);
+
+static struct platform_driver sun55i_ce_trng_driver = {
+	.probe = sun55i_ce_trng_probe,
+	.driver = {
+		.name = "sun55i-ce-trng",
+		.pm = pm_ptr(&sun55i_ce_trng_pm_ops),
+		.of_match_table = sun55i_ce_trng_of_match,
+	},
+};
+module_platform_driver(sun55i_ce_trng_driver);
+
+MODULE_AUTHOR("Alastair D'Silva <alastair@d-silva.org>");
+MODULE_DESCRIPTION("Allwinner CE v5 True Random Number Generator driver");
+MODULE_LICENSE("GPL");
-- 
2.53.0

