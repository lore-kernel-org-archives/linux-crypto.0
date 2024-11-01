Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941521E32A4
	for <linux-crypto@vger.kernel.org>; Fri,  1 Nov 2024 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495637; cv=none; b=koaWoruTJz83PZtUtDGsWFdU6Ty8IV8c36YiHKUBu9KqzoDNn3VaY3Cqj5ukPAwtVmoMQr/p+4HKIJqTRnQ/ZkMmtLRYQpwp7ygd4FzfH+7Bh7l+YoMo3oWnf5KN5Qs0QWpXjfo2zc/xF9mgWokg73uNsT3n3tPncIuFysy/P/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495637; c=relaxed/simple;
	bh=tTKJWC4m/dcrSDCuI7wOwicEJ8xN9VnFDvBp4okD5vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdID6CyALVkhrspnnC5Ww84yRsQ35qutisJLLXPrmomds7wfz5uxDLsC9c7Xt+QEY3sV6kFwJeJHDmC2nhLd1tSf/SVkAsoFApn5qtPoV49263ZKBNEV3S6pFtvj6Cpj/G+8oJCKyfAA0uLZ5z8rTLvOmzayNIkpJ0DiaLG9ZTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gu0MmJpf; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gu0MmJpf"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20cd76c513cso20249225ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Nov 2024 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730495633; x=1731100433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bux4qQm3jbRay7d0Y4soWyVIUi5ar2JUuw2c1anvqY8=;
        b=gu0MmJpf8jl8dDQl8vMjEYrhejanKBsZajvmiZj5kZoNRbaoDsoVG/jSpvAbKUz6Gy
         qxuTDw/Mt/reRp/PvyW0bUVROvjZtSIMllsb8rdcvLYPpf2aDeInPw3Y3rJIeweXehRH
         B8+bM82toD9+wl4HQqAvIG/90gHn3EuUGA504=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495633; x=1731100433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bux4qQm3jbRay7d0Y4soWyVIUi5ar2JUuw2c1anvqY8=;
        b=PGxABTvPu/RqsgThBvNVOMZafbYwU89lB/u/lFuIyXseFxTUukuo74jTa03Nkvq2ED
         oST+5USvF11cGLjNaJlz6L4NlZHj1fL9E/EWRBNycloFmtarxIiLQU3qHEb8Rxjx7/4k
         7NkLfWFWWJAJPshUGgRS3xqjI00KIfe8VNHq1TKanvmNCIu+fYI/lh8onJbLlw94pU/o
         eK1F/dmAra/rCD3yQ7khgtv8VmHFZvO2G0n5RAXZ4SVQrgPaQhHu27hp7iY0rzcvU5A3
         JjZp+lZGxnij3yx+sJpaCKJP+fHdWwLoCaXKRzb3cK6MzXKSroV3DaBr6JSgxoXHHC4P
         804A==
X-Forwarded-Encrypted: i=1; AJvYcCUe3vlhBVQ4H3oB9GaJuXzc+wrv8iZrrYQN7jYmOGMd9g3AkLIpdG560tysti01H2CMGi7TWoivylBehhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMlXX4z0ipX+o4FTKlkx5UW+mu6mUEr2tysTm8DkZ8tSwVl+nD
	NXHJimyZhgClSWbwGRs2+UuApejPaHS2dhrPGP9c279Flp7BaK/07k1u2/8rBw==
X-Google-Smtp-Source: AGHT+IHPOKhR+ft9tq6Iy6AlSQ2rRoMlb3tquFpw/db3ZPEwwf1jqkcGaWh/DFAxUE6QVaVpvJ0/jw==
X-Received: by 2002:a17:903:182:b0:20b:5b1a:209 with SMTP id d9443c01a7336-210f74f48efmr151842195ad.9.1730495632929;
        Fri, 01 Nov 2024 14:13:52 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057c076bsm25305715ad.197.2024.11.01.14.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 14:13:52 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
	id 80188A82; Fri,  1 Nov 2024 14:13:51 -0700 (PDT)
From: Markus Mayer <mmayer@broadcom.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>
Cc: Markus Mayer <mmayer@broadcom.com>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
Date: Fri,  1 Nov 2024 14:13:15 -0700
Message-ID: <20241101211316.91345-3-mmayer@broadcom.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241101211316.91345-1-mmayer@broadcom.com>
References: <20241101211316.91345-1-mmayer@broadcom.com>
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
 drivers/char/hw_random/Kconfig        |  13 +++
 drivers/char/hw_random/Makefile       |   1 +
 drivers/char/hw_random/bcm74110-rng.c | 125 ++++++++++++++++++++++++++
 3 files changed, 139 insertions(+)
 create mode 100644 drivers/char/hw_random/bcm74110-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index b51d9e243f35..e665581e2324 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -99,6 +99,19 @@ config HW_RANDOM_BCM2835
 
 	  If unsure, say Y.
 
+config HW_RANDOM_BCM74110
+	tristate "Broadcom BCM74110 Random Number Generator support"
+	depends on ARCH_BRCMSTB || COMPILE_TEST
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
2.47.0

