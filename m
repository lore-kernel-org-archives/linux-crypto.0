From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH V1 3/3] crypto: ccp - Add platform device support for arm64
Date: Thu, 5 Jun 2014 10:17:57 -0500
Message-ID: <20140605151757.20604.90761.stgit@tlendack-t1.amdoffice.net>
References: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:39294
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751588AbaFEPdn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 11:33:43 -0400
In-Reply-To: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for the CCP on arm64 as a platform device.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig            |    2 
 drivers/crypto/ccp/Makefile       |    5 +
 drivers/crypto/ccp/ccp-dev.c      |   34 ++++++
 drivers/crypto/ccp/ccp-dev.h      |    7 +
 drivers/crypto/ccp/ccp-platform.c |  224 +++++++++++++++++++++++++++++++++++++
 5 files changed, 270 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-platform.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f066fa2..09ae35c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -391,7 +391,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on X86 && PCI
+	depends on (X86 && PCI) || ARM64
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index d3505a0..7f592d8 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -1,6 +1,11 @@
 obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
 ccp-objs := ccp-dev.o ccp-ops.o
+ifdef CONFIG_X86
 ccp-objs += ccp-pci.o
+endif
+ifdef CONFIG_ARM64
+ccp-objs += ccp-platform.o
+endif
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 2c78161..fa1ab10 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -20,7 +20,9 @@
 #include <linux/delay.h>
 #include <linux/hw_random.h>
 #include <linux/cpu.h>
+#ifdef CONFIG_X86
 #include <asm/cpu_device_id.h>
+#endif
 #include <linux/ccp.h>
 
 #include "ccp-dev.h"
@@ -360,6 +362,12 @@ int ccp_init(struct ccp_device *ccp)
 		/* Build queue interrupt mask (two interrupts per queue) */
 		qim |= cmd_q->int_ok | cmd_q->int_err;
 
+#ifdef CONFIG_ARM64
+		/* For arm64 set the recommended queue cache settings */
+		iowrite32(CACHE_WB_NO_ALLOC, ccp->io_regs + CMD_Q_CACHE_BASE +
+			  (CMD_Q_CACHE_INC * i));
+#endif
+
 		dev_dbg(dev, "queue #%u available\n", i);
 	}
 	if (ccp->cmd_q_count == 0) {
@@ -558,12 +566,15 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 }
 #endif
 
+#ifdef CONFIG_X86
 static const struct x86_cpu_id ccp_support[] = {
 	{ X86_VENDOR_AMD, 22, },
 };
+#endif
 
 static int __init ccp_mod_init(void)
 {
+#ifdef CONFIG_X86
 	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
 	int ret;
 
@@ -589,12 +600,30 @@ static int __init ccp_mod_init(void)
 
 		break;
 	}
+#endif
+
+#ifdef CONFIG_ARM64
+	int ret;
+
+	ret = ccp_platform_init();
+	if (ret)
+		return ret;
+
+	/* Don't leave the driver loaded if init failed */
+	if (!ccp_get_device()) {
+		ccp_platform_exit();
+		return -ENODEV;
+	}
+
+	return 0;
+#endif
 
 	return -ENODEV;
 }
 
 static void __exit ccp_mod_exit(void)
 {
+#ifdef CONFIG_X86
 	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
 
 	switch (cpuinfo->x86) {
@@ -602,6 +631,11 @@ static void __exit ccp_mod_exit(void)
 		ccp_pci_exit();
 		break;
 	}
+#endif
+
+#ifdef CONFIG_ARM64
+	ccp_platform_exit();
+#endif
 }
 
 module_init(ccp_mod_init);
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 72bf153..1c5651b 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -30,6 +30,8 @@
 
 #define TRNG_RETRIES			10
 
+#define CACHE_WB_NO_ALLOC		0xb7
+
 
 /****** Register Mappings ******/
 #define Q_MASK_REG			0x000
@@ -48,7 +50,7 @@
 #define CMD_Q_INT_STATUS_BASE		0x214
 #define CMD_Q_STATUS_INCR		0x20
 
-#define CMD_Q_CACHE			0x228
+#define CMD_Q_CACHE_BASE		0x228
 #define CMD_Q_CACHE_INC			0x20
 
 #define CMD_Q_ERROR(__qs)		((__qs) & 0x0000003f);
@@ -259,6 +261,9 @@ struct ccp_device {
 int ccp_pci_init(void);
 void ccp_pci_exit(void);
 
+int ccp_platform_init(void);
+void ccp_platform_exit(void);
+
 struct ccp_device *ccp_alloc_struct(struct device *dev);
 int ccp_init(struct ccp_device *ccp);
 void ccp_destroy(struct ccp_device *ccp);
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
new file mode 100644
index 0000000..65e5829
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -0,0 +1,224 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/dma-mapping.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+
+static int ccp_get_irq(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	int ret;
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+
+	ccp->irq = ret;
+	ret = request_irq(ccp->irq, ccp_irq_handler, 0, "ccp", dev);
+	if (ret) {
+		dev_notice(dev, "unable to allocate IRQ (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ccp_get_irqs(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	int ret;
+
+	ret = ccp_get_irq(ccp);
+	if (!ret)
+		return 0;
+
+	/* Couldn't get an interrupt */
+	dev_notice(dev, "could not enable interrupts (%d)\n", ret);
+
+	return ret;
+}
+
+static void ccp_free_irqs(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+
+	free_irq(ccp->irq, dev);
+}
+
+static struct resource *ccp_find_mmio_area(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct resource *ior;
+
+	ior = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (ior && (resource_size(ior) >= 0x800))
+		return ior;
+
+	return NULL;
+}
+
+static int ccp_platform_probe(struct platform_device *pdev)
+{
+	struct ccp_device *ccp;
+	struct device *dev = &pdev->dev;
+	struct resource *ior;
+	int ret;
+
+	ret = -ENOMEM;
+	ccp = ccp_alloc_struct(dev);
+	if (!ccp)
+		goto e_err;
+
+	ccp->dev_specific = NULL;
+	ccp->get_irq = ccp_get_irqs;
+	ccp->free_irq = ccp_free_irqs;
+
+	ior = ccp_find_mmio_area(ccp);
+	ccp->io_map = devm_ioremap_resource(dev, ior);
+	if (IS_ERR(ccp->io_map)) {
+		ret = PTR_ERR(ccp->io_map);
+		goto e_free;
+	}
+	ccp->io_regs = ccp->io_map;
+
+	if (!dev->dma_mask)
+		dev->dma_mask = &dev->coherent_dma_mask;
+	*(dev->dma_mask) = DMA_BIT_MASK(48);
+	dev->coherent_dma_mask = DMA_BIT_MASK(48);
+
+	dev_set_drvdata(dev, ccp);
+
+	ret = ccp_init(ccp);
+	if (ret)
+		goto e_free;
+
+	dev_notice(dev, "enabled\n");
+
+	return 0;
+
+e_free:
+	kfree(ccp);
+
+e_err:
+	dev_notice(dev, "initialization failed\n");
+	return ret;
+}
+
+static int ccp_platform_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+
+	ccp_destroy(ccp);
+
+	kfree(ccp);
+
+	dev_notice(dev, "disabled\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ccp_platform_suspend(struct platform_device *pdev,
+				pm_message_t state)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 1;
+
+	/* Wake all the queue kthreads to prepare for suspend */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		wake_up_process(ccp->cmd_q[i].kthread);
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* Wait for all queue kthreads to say they're done */
+	while (!ccp_queues_suspended(ccp))
+		wait_event_interruptible(ccp->suspend_queue,
+					 ccp_queues_suspended(ccp));
+
+	return 0;
+}
+
+static int ccp_platform_resume(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 0;
+
+	/* Wake up all the kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		ccp->cmd_q[i].suspended = 0;
+		wake_up_process(ccp->cmd_q[i].kthread);
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	return 0;
+}
+#endif
+
+static const struct of_device_id ccp_platform_ids[] = {
+	{ .compatible = "amd,ccp-seattle-v1a" },
+	{ },
+};
+
+static struct platform_driver ccp_platform_driver = {
+	.driver = {
+		.name = "AMD Cryptographic Coprocessor",
+		.owner = THIS_MODULE,
+		.of_match_table = ccp_platform_ids,
+	},
+	.probe = ccp_platform_probe,
+	.remove = ccp_platform_remove,
+#ifdef CONFIG_PM
+	.suspend = ccp_platform_suspend,
+	.resume = ccp_platform_resume,
+#endif
+};
+
+int ccp_platform_init(void)
+{
+	return platform_driver_register(&ccp_platform_driver);
+}
+
+void ccp_platform_exit(void)
+{
+	platform_driver_unregister(&ccp_platform_driver);
+}
