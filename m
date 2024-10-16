Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34CE20F5A5;
	Wed, 16 Oct 2024 15:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729091974; cv=none; b=ZvEJlOQjadJrOCc4BIkjlsaSa98WaxScGom/S4l5w6sh+yEqxRTu8gSxmKUUovpQk9YYsr3qBwdnfp6u76/wnidIYHdFo3NvpAr/EOKJuRKYa4431jcvdqV6P/ckffZzW/9Ul3Se5QTcpgWNvxdX6iaPXvizOHC52dOx4p+RmO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729091974; c=relaxed/simple;
	bh=3uUQhJDyZfEvfA+H/zoL9J1bi9UO7IEk+2atQGAQ9aY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6hQjHufLET7jT80+1sUOJWpfa0+mEKiPtJb1ieDskM0U3usUeAWSyA2qmHYaG1eBR1DWWUujZofGr7+jxSJMJE9K8pOzoTtTvgZLHVq59lhL8/K05XzCy1kl9L8mgc2MAlTQkCtTR7DqvLEMPjUdhie6L6JNLxIp8uxdADOdfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sf9BjSlc; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sf9BjSlc"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a11e7so5316920a12.3;
        Wed, 16 Oct 2024 08:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729091971; x=1729696771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ZyHtBWqF5u5Xzu04V2sfnHpBpI5xssoZkdHYCYZx7M=;
        b=Sf9BjSlcdnZ1OyPZ4ofpfOKP65LHZ7aRxXKg69ouo/1M7u/+Gw6RDXFs8ljzoh3R7R
         UxyQL0lb4gbmoh5BvB9SJtpQYvUkizp0ZIYKDWJlCxnympYl9e/94KcmISQG3s0YenYV
         DT8XKUroZQChX59tQvXVaJucoa6YXPw7IfINN6ybv0aiT/B1mkhzTc1WCuD37AarvOYb
         Z01UJQKnn1g2VRTX6/ldeQrkfmz+D2lS8KVXDM8UPe8OY+9OaHlkP7Rhr5YoPULxIgu+
         ImSkp0NHirM9jscv/1rBBNlnfnK1HJNIXC2ug8vzV4RKdPHW1bxMHcAXiwg/OGJP0otE
         rzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729091971; x=1729696771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ZyHtBWqF5u5Xzu04V2sfnHpBpI5xssoZkdHYCYZx7M=;
        b=JartrOkTgasBgUUauIb+ESzdq1cJGYWr6e2YQlEM28b1gBJ48AHKlnvAXE8hexqFTv
         TNi+l08swVkcTGAdxoDN4EYQrxEIbmjASg9DsFC59Mi7Vo0ZTfsvvDhuatmv2psZvRbH
         jCphDmDt/Vd40aJyHN65atxEuvS4HsXnVTqGCNl4a+l+Mhm0lfoRRtiCqvB1cLdcejxJ
         hycdbkqa/7JEn0v0O/6Pg8OW7b/O9UgNWK7IoxqhXkLgL/s6O5HYcv7RAvRuXYTb3kzq
         flvH6qeh92nsgeuMpB5Yu1IggfC9Yw45+l4y6cNg/KTdJyykCYY23LU+0J8NZPeFrlV0
         JsfA==
X-Forwarded-Encrypted: i=1; AJvYcCV//eCz8859hk9UHrAgEgQtM19B2udhAYL+Lo74VR5WIlqrEq3HvBhzNdB6E/5ZzbPLKEnKvr+ZitMNVXn0@vger.kernel.org, AJvYcCVtQ3wlDtmhtSK38jDs9AL7spTG07X88xZKaTPXEecOwDZW+TOJrmoBR9S7cvi9ylF0+PxN2VJxkvoo@vger.kernel.org, AJvYcCXrH7AForve7mPEguttzS7bHXLf9KnRZBU/MufX89I0POySGzKRx1ss18vnanpsYy/vu7DZDtM4/TvHVo2+@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5tXRWtWK6Yt6FoMnGq502H7Q2cFxAv6EVabYtD1Rcm6ZNoZyu
	qQOzfgJkDWyKVOntNnvJaC3c0UzOvbqJRBTwODjEM9EaEibK/KOV
X-Google-Smtp-Source: AGHT+IE8OEOZ5K6XXqk2YjqRukkDeiFpNeCG1pEbJgojCc8M3+PwyIydJIzCzd4ZLhwEitFmm13sZg==
X-Received: by 2002:a05:6402:348c:b0:5c9:45f2:b26a with SMTP id 4fb4d7f45d1cf-5c95aaf5cdcmr11685630a12.0.1729091970582;
        Wed, 16 Oct 2024 08:19:30 -0700 (PDT)
Received: from localhost.localdomain ([62.19.118.125])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d7b725esm1824716a12.87.2024.10.16.08.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 08:19:30 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: [PATCH 2/2] hwrng: add support for Airoha EN7581 TRNG
Date: Wed, 16 Oct 2024 17:18:42 +0200
Message-ID: <20241016151845.23712-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241016151845.23712-1-ansuelsmth@gmail.com>
References: <20241016151845.23712-1-ansuelsmth@gmail.com>
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
index 000000000000..88650aeaf8d0
--- /dev/null
+++ b/drivers/char/hw_random/airoha-trng.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2024 Christian Marangi */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/interrupt.h>
+#include <linux/hw_random.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
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

