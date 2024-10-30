Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC272144A7
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 21:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730324085; cv=none; b=JMot2rCc9WiCzUtCJe3+xa+6d+k3nmO6luI8uZoti49ARWpQ8kl5xpsmltFn1aB+lYzGHX+zD105h1FDZ0YyKh+LgOjcpLEKxz4C7WeAvYvTHePY2lM4OOTyR+uZlisTLVmDmqneF6x8mEK4nH/6Qxd6nR5WUqyIWouB5bf6RHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730324085; c=relaxed/simple;
	bh=DwPw63JU7YU7EA4xKffPQMQHFNG7sL8srdFoP5jrOqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0nAxv4TAbGvboADhQ7nxm/g8SSPYFWDzJGqKsPTn9wk7wlJdek6YVVHGGVBNYX+HAklTN05d3b5bWS9JDx+5xIW2WP6eKMEDJ3zaZsBBf3EPWzi2H2JzxwVVl69FuMJPnyztlU+9ue5wHAGOEqfKcoHOKtbv4Dkua9kgl3cqzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BmyKI3+I; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BmyKI3+I"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83b2a41b81cso11755339f.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 14:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730324082; x=1730928882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doqscSHfpShWQHBZSY/c6QnT4Gkd7L46DSkSZNKlIZY=;
        b=BmyKI3+IyT9mQNM2jZdbOelveoYFZFNWGi5ps6Of3GDUgRgCjRuq+P3F/pB2R6MR5A
         mvL/Xt+SqV76vjfQk//nfCdgq70MzyU89iJ5rOHFQB7yzF0G+J9kpYoGocs9btFosy3s
         rta3ZMFHnBAXuqmXfaP3XJWliYzUieaETgmAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730324082; x=1730928882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=doqscSHfpShWQHBZSY/c6QnT4Gkd7L46DSkSZNKlIZY=;
        b=mSvyrjTIvwxZSkmdJgj5PtY7gjbehFi74WqJGLdpmMvStRQ/zvTdzSO82VTutO4XpO
         iB7JDUZiWrSUWM33P1jfNtfzcIR6P/bHmqEI5SvgUHXD3D9nuDilqCJYPRo1bqQHspPb
         mSoP8ZbjgLOfXI3XCFlQaHvPC4EEStkF1HvuoYzMBUf+8di29AC2BEaitORO9TmScpIi
         wLeM2fXGuROvgef8Cm3aqs4AO4o+Onkwx6qGIEpWYBz3dJ6nfQWScVKpp0kr5DlkaVNX
         816RkUkq+JODV7+2VQGiA4khLqfFOtoJ/aw3r0rP188oc8aG3JQ6Jk9mBZeSmZQLIw6t
         jbTA==
X-Forwarded-Encrypted: i=1; AJvYcCVGxYLYxs+KWbYnJTf5+ReCaSkQboKHTfZ5Gmf4vXI0BUyf6KQgqg3cWtD0o/gbk1G7Ej3k1MQ/koEAM+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTPl8VzYIXy7ilBM/pNzBMkJdACL0dhv4nhjDw+GQPBry8e5Ox
	IaN+Di0K7YRhDEDJpbXjaRWum/BgtCOolxLFqd5I0ktm4KmaCROSVJutcrmp6A==
X-Google-Smtp-Source: AGHT+IFUFxxXzGw5Yp5MtqvNUqpgpiZmswpQB9hlCkuvqvVD/RBmS8Oc3Oz2FDxa1m2q/bm3wo280Q==
X-Received: by 2002:a05:6e02:b22:b0:3a4:e63e:550 with SMTP id e9e14a558f8ab-3a4ed27817dmr169550735ab.1.1730324082208;
        Wed, 30 Oct 2024 14:34:42 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee45a13178sm33150a12.90.2024.10.30.14.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:34:41 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
	id EDD4F88A; Wed, 30 Oct 2024 14:34:40 -0700 (PDT)
From: Markus Mayer <mmayer@broadcom.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>
Cc: Markus Mayer <mmayer@broadcom.com>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
Date: Wed, 30 Oct 2024 14:33:55 -0700
Message-ID: <20241030213400.802264-3-mmayer@broadcom.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241030213400.802264-1-mmayer@broadcom.com>
References: <20241030213400.802264-1-mmayer@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a driver for the random number generator present on the Broadcom
BCM74110 SoC.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---
 drivers/char/hw_random/Kconfig        |  14 +++
 drivers/char/hw_random/Makefile       |   1 +
 drivers/char/hw_random/bcm74110-rng.c | 125 ++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)
 create mode 100644 drivers/char/hw_random/bcm74110-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index b51d9e243f35..90ae35aeb23a 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -99,6 +99,20 @@ config HW_RANDOM_BCM2835
 
 	  If unsure, say Y.
 
+config HW_RANDOM_BCM74110
+	tristate "Broadcom BCM74110 Random Number Generator support"
+	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
+		   ARCH_BCMBCA || BCM63XX || ARCH_BRCMSTB || COMPILE_TEST
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on the Broadcom BCM74110 SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bcm74110-rng
+
+	  If unsure, say Y.
+
 config HW_RANDOM_IPROC_RNG200
 	tristate "Broadcom iProc/STB RNG200 support"
 	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB || COMPILE_TEST
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 01f012eab440..283791f5462d 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
 obj-$(CONFIG_HW_RANDOM_HISTB) += histb-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
+obj-$(CONFIG_HW_RANDOM_BCM74110) += bcm74110-rng.o
 obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
 obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
diff --git a/drivers/char/hw_random/bcm74110-rng.c b/drivers/char/hw_random/bcm74110-rng.c
new file mode 100644
index 000000000000..5c64148e91f1
--- /dev/null
+++ b/drivers/char/hw_random/bcm74110-rng.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Broadcom
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/hw_random.h>
+
+#define HOST_REV_ID		0x00
+#define HOST_FIFO_DEPTH		0x04
+#define HOST_FIFO_COUNT		0x08
+#define HOST_FIFO_THRESHOLD	0x0c
+#define HOST_FIFO_DATA		0x10
+
+#define HOST_FIFO_COUNT_MASK		0xffff
+
+/* Delay range in microseconds */
+#define FIFO_DELAY_MIN_US		3
+#define FIFO_DELAY_MAX_US		7
+#define FIFO_DELAY_MAX_COUNT		10
+
+struct bcm74110_priv {
+	void __iomem *base;
+};
+
+static inline int bcm74110_rng_fifo_count(void __iomem *mem)
+{
+	return readl_relaxed(mem) & HOST_FIFO_COUNT_MASK;
+}
+
+static int bcm74110_rng_read(struct hwrng *rng, void *buf, size_t max,
+			bool wait)
+{
+	struct bcm74110_priv *priv = (struct bcm74110_priv *)rng->priv;
+	void __iomem *fc_addr = priv->base + HOST_FIFO_COUNT;
+	void __iomem *fd_addr = priv->base + HOST_FIFO_DATA;
+	unsigned underrun_count = 0;
+	u32 max_words = max / sizeof(u32);
+	u32 num_words;
+	unsigned i;
+
+	/*
+	 * We need to check how many words are available in the RNG FIFO. If
+	 * there aren't any, we need to wait for some to become available.
+	 */
+	while ((num_words = bcm74110_rng_fifo_count(fc_addr)) == 0) {
+		if (!wait)
+			return 0;
+		/*
+		 * As a precaution, limit how long we wait. If the FIFO doesn't
+		 * refill within the allotted time, return 0 (=no data) to the
+		 * caller.
+		 */
+		if (likely(underrun_count < FIFO_DELAY_MAX_COUNT))
+			usleep_range(FIFO_DELAY_MIN_US, FIFO_DELAY_MAX_US);
+		else
+			return 0;
+		underrun_count++;
+	}
+	if (num_words > max_words)
+		num_words = max_words;
+
+	/* Bail early if we run out of random numbers unexpectedly */
+	for (i = 0; i < num_words && bcm74110_rng_fifo_count(fc_addr) > 0; i++)
+		((u32 *)buf)[i] = readl_relaxed(fd_addr);
+
+	return i * sizeof(u32);
+}
+
+static struct hwrng bcm74110_hwrng = {
+	.read = bcm74110_rng_read,
+};
+
+static int bcm74110_rng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct bcm74110_priv *priv;
+	int rc;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	bcm74110_hwrng.name = pdev->name;
+	bcm74110_hwrng.priv = (unsigned long)priv;
+
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	rc = devm_hwrng_register(dev, &bcm74110_hwrng);
+	if (rc)
+		dev_err(dev, "hwrng registration failed (%d)\n", rc);
+	else
+		dev_info(dev, "hwrng registered\n");
+
+	return rc;
+}
+
+static const struct of_device_id bcm74110_rng_match[] = {
+	{ .compatible	= "brcm,bcm74110-rng", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm74110_rng_match);
+
+static struct platform_driver bcm74110_rng_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = bcm74110_rng_match,
+	},
+	.probe	= bcm74110_rng_probe,
+};
+module_platform_driver(bcm74110_rng_driver);
+
+MODULE_AUTHOR("Markus Mayer <mmayer@broadcom.com>");
+MODULE_DESCRIPTION("BCM 74110 Random Number Generator (RNG) driver");
+MODULE_LICENSE("GPL v2");
-- 
2.46.0

