Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F318E1DA113;
	Thu, 17 Oct 2024 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729169133; cv=none; b=Uf/vPPJddCw4jkiqbWIHfWojQER906+MaC5g7WqOwW2OxZYx7LGDx3I5FVO+qo5YYuJ6ZcOiuNeol3I0LGuZjhn1zjVcZ+elZ8XZSdHMQwCC/iDFzkWgrVfI57CHFL4RLT/+tvTgaXj9js1d1P2D7OO4TDy+mr+fbKROtvJSu0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729169133; c=relaxed/simple;
	bh=rLMuLlvNxUmI/HYbU7n1zwDepmiigcIx6X3+oCrYkTM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo64GcE/l88zUsAj2uXaTtDtveqy8YyKwQ2pri9AG7pc0zsKJiW0CJElB1ZVb+ylGCbf/v919oBN08FP4Xr5MCUIxRqPQqgK/9sDF9/sqyeAcrbBHtWIIbQ7QPw5QI42Mr3tJdqY8ObnHZO+KW/PIbcQvnWxNbm/WMnXqh8dxus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeKAPGCI; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeKAPGCI"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43155abaf0bso9016795e9.0;
        Thu, 17 Oct 2024 05:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729169127; x=1729773927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HUqOU/B9V5bI7aGKr6oAsSPOnkfnMzWjy3ytFshj7Go=;
        b=jeKAPGCIOD3jwZ2bKAghqK7C3b+eoN1hfLrSF3wrzBUX71IrWL7VM0oOi25P4eBJnM
         fTUHlsyTay+rYqCYkEElRAED8VWpGZwBc0x93rluYPR3iPHYJztfDHeZ8fmo9mBUNtUb
         jmW/nyTFN4MuJoA5O2//+xYOSc5ckzRJO7v3y2qEO7NbtXhKsgAcZX+/RSle+7boLRJt
         HwiMi/rNblLVxPa1QWo19Qfeh7+CIzFdyAaQaePWESdJeI0HUQ8MZyT24WT/zWMn8fLc
         UUU1kr6rzy0FiPCW2o0xKHejdxK05JOMF7hq9MwL/x4F6TLtE9ciOG/2qu7Zo8jWVkAH
         WqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729169127; x=1729773927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUqOU/B9V5bI7aGKr6oAsSPOnkfnMzWjy3ytFshj7Go=;
        b=aXTwgkc9KQx7RDSyXvP39mwRtKvAV35B4Blwb15/bGr4pUnQxt43H4qv6r4XCKCe/4
         Lpijskda+J+010XysFI9HgI3gvcuzcftfOJIFw11iLR6RFAa82vHUWgSgn6O1jTz0LEr
         fAwLDshFzoQXgRVFMT31C+lJfKqffCzFxKbkvrcNNJLrRec9LEOYRwPxLL/kKi1LM2/Y
         owJ57F05XZQqfLcTWSyMue02LrgjrsMQMzg/fmQekIf1WB0VVgUrgszUkZsttliWkS5A
         P5Pg1xyViQDpXC0X/g/+I0QP7dfSSRQHSUm0/Hj9Bb3mV31lkAGe5dOgDtR6cGmFk5Rw
         TRbw==
X-Forwarded-Encrypted: i=1; AJvYcCUzyb1iqxRWWewawp0T3H70FQJEjlHq14vVNnhgM/tUigubfoFrh42zSvzkrY+3swPB212Mn3mNc7jKbQ0U@vger.kernel.org, AJvYcCVr7yBIz679mhW1QpjB04FXBNfcS9mCuoIbzfwmrhD0LIRfbEG3jIM9MvkuzIcsgoRsy71EXBlofVPnxgz9@vger.kernel.org, AJvYcCWjFyPibxGBlygCjvNTV2ClG11c2qR+DGRKVYwmt9CvN6r9+PBmYy8n1hptumbVwgggKabeU0VVuYXk@vger.kernel.org
X-Gm-Message-State: AOJu0YwueFrFrK0zruREKNrDCRrQqMNc6ObngB9iHxO9U3aDSIoMZ6ee
	K/xbT0F7+5GbbwLE4R6ehoXQTca8zMUE/AP4qqfpVnadQZwolq7s6W7wOw==
X-Google-Smtp-Source: AGHT+IGvuMPufDXVDYbEhJWtD46EBlhB5FmV62WB5Un0gh6JrnWiCzE3F9WFz/2/bCs7ocs/lbKLCg==
X-Received: by 2002:a05:600c:4f8f:b0:431:5ba1:a529 with SMTP id 5b1f17b1804b1-4315ba1a7eemr12857475e9.14.1729169127146;
        Thu, 17 Oct 2024 05:45:27 -0700 (PDT)
Received: from localhost.localdomain (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43158c4d9desm24972935e9.35.2024.10.17.05.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 05:45:26 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: [PATCH v2 2/2] hwrng: add support for Airoha EN7581 TRNG
Date: Thu, 17 Oct 2024 14:44:38 +0200
Message-ID: <20241017124456.32584-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241017124456.32584-1-ansuelsmth@gmail.com>
References: <20241017124456.32584-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for Airoha TRNG. The Airoha SoC provide a True RNG module
that can output 4 bytes of raw data at times.

The module makes use of various noise source to provide True Random
Number Generation.

On probe the module is reset to operate Health Test and verify correct
execution of it.

The module can also provide DRBG function but the execution mode is
mutually exclusive, running as TRNG doesn't permit to also run it as
DRBG.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
Changes v2:
- Sort include header
- Add missing bitfield.h

 drivers/char/hw_random/Kconfig       |  13 ++
 drivers/char/hw_random/Makefile      |   1 +
 drivers/char/hw_random/airoha-trng.c | 243 +++++++++++++++++++++++++++
 3 files changed, 257 insertions(+)
 create mode 100644 drivers/char/hw_random/airoha-trng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 5912c2dd6398..bda283f290bc 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -62,6 +62,19 @@ config HW_RANDOM_AMD
 
 	  If unsure, say Y.
 
+config HW_RANDOM_AIROHA
+	tristate "Airoha True HW Random Number Generator support"
+	depends on ARCH_AIROHA || COMPILE_TEST
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the True Random Number
+	  Generator hardware found on Airoha SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called airoha-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
 	depends on (ARCH_AT91 || COMPILE_TEST)
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 01f012eab440..dfb717b12f0b 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -8,6 +8,7 @@ rng-core-y := core.o
 obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
 obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
+obj-$(CONFIG_HW_RANDOM_AIROHA) += airoha-trng.o
 obj-$(CONFIG_HW_RANDOM_ATMEL) += atmel-rng.o
 obj-$(CONFIG_HW_RANDOM_BA431) += ba431-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
new file mode 100644
index 000000000000..1dbfa9505c21
--- /dev/null
+++ b/drivers/char/hw_random/airoha-trng.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2024 Christian Marangi */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+
+#define TRNG_IP_RDY			0x800
+#define   CNT_TRANS			GENMASK(15, 8)
+#define   SAMPLE_RDY			BIT(0)
+#define TRNG_NS_SEK_AND_DAT_EN		0x804
+#define	  RNG_EN			BIT(31) /* referenced as ring_en */
+#define	  RAW_DATA_EN			BIT(16)
+#define TRNG_HEALTH_TEST_SW_RST		0x808
+#define   SW_RST			BIT(0) /* Active High */
+#define TRNG_INTR_EN			0x818
+#define   INTR_MASK			BIT(16)
+#define   CONTINUOUS_HEALTH_INITR_EN	BIT(2)
+#define   SW_STARTUP_INITR_EN		BIT(1)
+#define   RST_STARTUP_INITR_EN		BIT(0)
+/* Notice that Health Test are done only out of Reset and with RNG_EN */
+#define TRNG_HEALTH_TEST_STATUS		0x824
+#define   CONTINUOUS_HEALTH_AP_TEST_FAIL BIT(23)
+#define   CONTINUOUS_HEALTH_RC_TEST_FAIL BIT(22)
+#define   SW_STARTUP_TEST_DONE		BIT(21)
+#define   SW_STARTUP_AP_TEST_FAIL	BIT(20)
+#define   SW_STARTUP_RC_TEST_FAIL	BIT(19)
+#define   RST_STARTUP_TEST_DONE		BIT(18)
+#define   RST_STARTUP_AP_TEST_FAIL	BIT(17)
+#define   RST_STARTUP_RC_TEST_FAIL	BIT(16)
+#define   RAW_DATA_VALID		BIT(7)
+
+#define TRNG_RAW_DATA_OUT		0x828
+
+#define TRNG_CNT_TRANS_VALID		0x80
+#define BUSY_LOOP_SLEEP			10
+#define BUSY_LOOP_TIMEOUT		(BUSY_LOOP_SLEEP * 10000)
+
+struct airoha_trng {
+	void __iomem *base;
+	struct hwrng rng;
+	struct device *dev;
+
+	struct completion rng_op_done;
+};
+
+static int airoha_trng_irq_mask(struct airoha_trng *trng)
+{
+	u32 val;
+
+	val = readl(trng->base + TRNG_INTR_EN);
+	val |= INTR_MASK;
+	writel(val, trng->base + TRNG_INTR_EN);
+
+	return 0;
+}
+
+static int airoha_trng_irq_unmask(struct airoha_trng *trng)
+{
+	u32 val;
+
+	val = readl(trng->base + TRNG_INTR_EN);
+	val &= ~INTR_MASK;
+	writel(val, trng->base + TRNG_INTR_EN);
+
+	return 0;
+}
+
+static int airoha_trng_init(struct hwrng *rng)
+{
+	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
+	int ret;
+	u32 val;
+
+	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
+	val |= RNG_EN;
+	writel(val, trng->base + TRNG_NS_SEK_AND_DAT_EN);
+
+	/* Set out of SW Reset */
+	airoha_trng_irq_unmask(trng);
+	writel(0, trng->base + TRNG_HEALTH_TEST_SW_RST);
+
+	ret = wait_for_completion_timeout(&trng->rng_op_done, BUSY_LOOP_TIMEOUT);
+	if (ret <= 0) {
+		dev_err(trng->dev, "Timeout waiting for Health Check\n");
+		airoha_trng_irq_mask(trng);
+		return -ENODEV;
+	}
+
+	/* Check if Health Test Failed */
+	val = readl(trng->base + TRNG_HEALTH_TEST_STATUS);
+	if (val & (RST_STARTUP_AP_TEST_FAIL | RST_STARTUP_RC_TEST_FAIL)) {
+		dev_err(trng->dev, "Health Check fail: %s test fail\n",
+			val & RST_STARTUP_AP_TEST_FAIL ? "AP" : "RC");
+		return -ENODEV;
+	}
+
+	/* Check if IP is ready */
+	ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
+				 val & SAMPLE_RDY, 10, 1000);
+	if (ret < 0) {
+		dev_err(trng->dev, "Timeout waiting for IP ready");
+		return -ENODEV;
+	}
+
+	/* CNT_TRANS must be 0x80 for IP to be considered ready */
+	ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
+				 FIELD_GET(CNT_TRANS, val) == TRNG_CNT_TRANS_VALID,
+				 10, 1000);
+	if (ret < 0) {
+		dev_err(trng->dev, "Timeout waiting for IP ready");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void airoha_trng_cleanup(struct hwrng *rng)
+{
+	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
+	u32 val;
+
+	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
+	val &= ~RNG_EN;
+	writel(val, trng->base + TRNG_NS_SEK_AND_DAT_EN);
+
+	/* Put it in SW Reset */
+	writel(SW_RST, trng->base + TRNG_HEALTH_TEST_SW_RST);
+}
+
+static int airoha_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
+	u32 *data = buf;
+	u32 status;
+	int ret;
+
+	ret = readl_poll_timeout(trng->base + TRNG_HEALTH_TEST_STATUS, status,
+				 status & RAW_DATA_VALID, 10, 1000);
+	if (ret < 0) {
+		dev_err(trng->dev, "Timeout waiting for TRNG RAW Data valid\n");
+		return ret;
+	}
+
+	*data = readl(trng->base + TRNG_RAW_DATA_OUT);
+
+	return 4;
+}
+
+static irqreturn_t airoha_trng_irq(int irq, void *priv)
+{
+	struct airoha_trng *trng = (struct airoha_trng *)priv;
+
+	airoha_trng_irq_mask(trng);
+	/* Just complete the task, we will read the value later */
+	complete(&trng->rng_op_done);
+
+	return IRQ_HANDLED;
+}
+
+static int airoha_trng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct airoha_trng *trng;
+	int irq, ret;
+	u32 val;
+
+	trng = devm_kzalloc(dev, sizeof(*trng), GFP_KERNEL);
+	if (!trng)
+		return -ENOMEM;
+
+	trng->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(trng->base))
+		return PTR_ERR(trng->base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	airoha_trng_irq_mask(trng);
+	ret = devm_request_irq(&pdev->dev, irq, airoha_trng_irq, 0,
+			       pdev->name, (void *)trng);
+	if (ret) {
+		dev_err(dev, "Can't get interrupt working.\n");
+		return ret;
+	}
+
+	init_completion(&trng->rng_op_done);
+
+	/* Enable interrupt for SW reset Health Check */
+	val = readl(trng->base + TRNG_INTR_EN);
+	val |= RST_STARTUP_INITR_EN;
+	writel(val, trng->base + TRNG_INTR_EN);
+
+	/* Set output to raw data */
+	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
+	val |= RAW_DATA_EN;
+	writel(val, trng->base + TRNG_NS_SEK_AND_DAT_EN);
+
+	/* Put it in SW Reset */
+	writel(SW_RST, trng->base + TRNG_HEALTH_TEST_SW_RST);
+
+	trng->dev = dev;
+	trng->rng.name = pdev->name;
+	trng->rng.init = airoha_trng_init;
+	trng->rng.cleanup = airoha_trng_cleanup;
+	trng->rng.read = airoha_trng_read;
+
+	ret = devm_hwrng_register(dev, &trng->rng);
+	if (ret) {
+		dev_err(dev, "failed to register rng device: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id airoha_trng_of_match[] = {
+	{ .compatible = "airoha,en7581-trng", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, airoha_trng_of_match);
+
+static struct platform_driver airoha_trng_driver = {
+	.driver = {
+		.name = "airoha-trng",
+		.of_match_table	= airoha_trng_of_match,
+	},
+	.probe = airoha_trng_probe,
+};
+
+module_platform_driver(airoha_trng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christian Marangi <ansuelsmth@gmail.com>");
+MODULE_DESCRIPTION("Airoha True Random Number Generator driver");
-- 
2.45.2

