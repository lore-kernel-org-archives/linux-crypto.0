From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/3] i.MX27: Add platform support for SAHARA2.
Date: Thu, 21 Feb 2013 13:19:20 +0100
Message-ID: <1361449162-27302-2-git-send-email-javier.martin@vista-silicon.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
	swarren@nvidia.com, shawn.guo@linaro.org, gcembed@gmail.com,
	arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	Javier Martin <javier.martin@vista-silicon.com>
To: kernel@pengutronix.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41057 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3BUMTe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 07:19:34 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so7463163wib.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 04:19:33 -0800 (PST)
In-Reply-To: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

i.MX27 devices include this HW cryptographic
accelerator.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/clk-imx27.c                     |    2 ++
 arch/arm/mach-imx/devices-imx27.h                 |    4 +++
 arch/arm/mach-imx/devices/Kconfig                 |    4 +++
 arch/arm/mach-imx/devices/Makefile                |    1 +
 arch/arm/mach-imx/devices/devices-common.h        |    8 +++++
 arch/arm/mach-imx/devices/platform-imx27-sahara.c |   37 +++++++++++++++++++++
 6 files changed, 56 insertions(+)
 create mode 100644 arch/arm/mach-imx/devices/platform-imx27-sahara.c

diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 4c1d1e4..0b9664a 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -253,6 +253,8 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[nfc_baud_gate], NULL, "imx27-nand.0");
 	clk_register_clkdev(clk[vpu_baud_gate], "per", "coda-imx27.0");
 	clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "coda-imx27.0");
+	clk_register_clkdev(clk[sahara_ahb_gate], "ahb", "sahara-imx27.0");
+	clk_register_clkdev(clk[sahara_ipg_gate], "ipg", "sahara-imx27.0");
 	clk_register_clkdev(clk[dma_ahb_gate], "ahb", "imx27-dma");
 	clk_register_clkdev(clk[dma_ipg_gate], "ipg", "imx27-dma");
 	clk_register_clkdev(clk[fec_ipg_gate], "ipg", "imx27-fec.0");
diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
index 1309625..3bc95d8 100644
--- a/arch/arm/mach-imx/devices-imx27.h
+++ b/arch/arm/mach-imx/devices-imx27.h
@@ -20,6 +20,10 @@ extern const struct imx_imx27_coda_data imx27_coda_data;
 #define imx27_add_coda()	\
 	imx_add_imx27_coda(&imx27_coda_data)
 
+extern const struct imx_imx27_sahara_data imx27_sahara_data;
+#define imx27_add_sahara()	\
+	imx_add_imx27_sahara(&imx27_sahara_data)
+
 extern const struct imx_imx2_wdt_data imx27_imx2_wdt_data;
 #define imx27_add_imx2_wdt()	\
 	imx_add_imx2_wdt(&imx27_imx2_wdt_data)
diff --git a/arch/arm/mach-imx/devices/Kconfig b/arch/arm/mach-imx/devices/Kconfig
index 9a8f1ca..3edaa8d 100644
--- a/arch/arm/mach-imx/devices/Kconfig
+++ b/arch/arm/mach-imx/devices/Kconfig
@@ -20,6 +20,10 @@ config IMX_HAVE_PLATFORM_IMX27_CODA
 	bool
 	default y if SOC_IMX27
 
+config IMX_HAVE_PLATFORM_IMX27_SAHARA
+	bool
+	default y if SOC_IMX27
+
 config IMX_HAVE_PLATFORM_IMX2_WDT
 	bool
 
diff --git a/arch/arm/mach-imx/devices/Makefile b/arch/arm/mach-imx/devices/Makefile
index 6acf37e..f5534a2 100644
--- a/arch/arm/mach-imx/devices/Makefile
+++ b/arch/arm/mach-imx/devices/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
 obj-y += platform-gpio-mxc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX21_HCD) += platform-imx21-hcd.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX27_CODA) += platform-imx27-coda.o
+obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX27_SAHARA) += platform-imx27-sahara.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT) += platform-imx2-wdt.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMXDI_RTC) += platform-imxdi_rtc.o
 obj-y += platform-imx-dma.o
diff --git a/arch/arm/mach-imx/devices/devices-common.h b/arch/arm/mach-imx/devices/devices-common.h
index 6277baf..48065b2 100644
--- a/arch/arm/mach-imx/devices/devices-common.h
+++ b/arch/arm/mach-imx/devices/devices-common.h
@@ -91,6 +91,14 @@ struct imx_imx27_coda_data {
 struct platform_device *__init imx_add_imx27_coda(
 		const struct imx_imx27_coda_data *data);
 
+struct imx_imx27_sahara_data {
+	resource_size_t iobase;
+	resource_size_t iosize;
+	resource_size_t irq;
+};
+struct platform_device *__init imx_add_imx27_sahara(
+		const struct imx_imx27_sahara_data *data);
+
 struct imx_imx2_wdt_data {
 	int id;
 	resource_size_t iobase;
diff --git a/arch/arm/mach-imx/devices/platform-imx27-sahara.c b/arch/arm/mach-imx/devices/platform-imx27-sahara.c
new file mode 100644
index 0000000..94288f4
--- /dev/null
+++ b/arch/arm/mach-imx/devices/platform-imx27-sahara.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2012 Vista Silicon
+ * Javier Martin <javier.martin@vista-silicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+
+#include "../hardware.h"
+#include "devices-common.h"
+
+#ifdef CONFIG_SOC_IMX27
+const struct imx_imx27_sahara_data imx27_sahara_data __initconst = {
+	.iobase = MX27_SAHARA_BASE_ADDR,
+	.iosize = SZ_2K,
+	.irq = MX27_INT_SAHARA,
+};
+#endif
+
+struct platform_device *__init imx_add_imx27_sahara(
+		const struct imx_imx27_sahara_data *data)
+{
+	struct resource res[] = {
+		{
+			.start = data->iobase,
+			.end = data->iobase + data->iosize - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = data->irq,
+			.end = data->irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+	return imx_add_platform_device_dmamask("sahara-imx27", 0, res, 2, NULL,
+					0, DMA_BIT_MASK(32));
+}
-- 
1.7.9.5
