From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security Processor (PSP) device support
Date: Mon, 24 Jul 2017 15:02:39 -0500
Message-ID: <20170724200303.12197-3-brijesh.singh@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=5C=22Radim=20Kr=C4=8Dm=C3=A1=C5=99=5C=22?=
        <rkrcmar@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0066.outbound.protection.outlook.com ([104.47.41.66]:3232
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751942AbdGXUD2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 16:03:28 -0400
In-Reply-To: <20170724200303.12197-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Platform Security Processor (PSP) is part of AMD Secure Processor (AMD-SP),
PSP is a dedicated processor that provides the support for key management
commands in a Secure Encrypted Virtualiztion (SEV) mode, along with
software-based Tursted Executation Environment (TEE) to enable the
third-party tursted applications.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gary Hook <gary.hook@amd.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/Kconfig   |   9 ++
 drivers/crypto/ccp/Makefile  |   1 +
 drivers/crypto/ccp/psp-dev.c | 226 +++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/psp-dev.h |  82 ++++++++++++++++
 drivers/crypto/ccp/sp-dev.c  |  43 ++++++++
 drivers/crypto/ccp/sp-dev.h  |  41 +++++++-
 drivers/crypto/ccp/sp-pci.c  |  46 +++++++++
 7 files changed, 447 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/ccp/psp-dev.c
 create mode 100644 drivers/crypto/ccp/psp-dev.h

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 15b63fd..41c0ff5 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -31,3 +31,12 @@ config CRYPTO_DEV_CCP_CRYPTO
 	  Support for using the cryptographic API with the AMD Cryptographic
 	  Coprocessor. This module supports offload of SHA and AES algorithms.
 	  If you choose 'M' here, this module will be called ccp_crypto.
+
+config CRYPTO_DEV_SP_PSP
+	bool "Platform Security Processor device"
+	default y
+	depends on CRYPTO_DEV_CCP_DD
+	help
+	 Provide the support for AMD Platform Security Processor (PSP) device
+	 which can be used for communicating with Secure Encryption Virtualization
+	 (SEV) firmware.
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 5f2adc5..8aae4ff 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -7,6 +7,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
 	    ccp-dmaengine.o \
 	    ccp-debugfs.o
 ccp-$(CONFIG_PCI) += sp-pci.o
+ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
new file mode 100644
index 0000000..bb0ea9a
--- /dev/null
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -0,0 +1,226 @@
+/*
+ * AMD Platform Security Processor (PSP) interface
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/ccp.h>
+
+#include "sp-dev.h"
+#include "psp-dev.h"
+
+static LIST_HEAD(psp_devs);
+static DEFINE_SPINLOCK(psp_devs_lock);
+
+const struct psp_vdata psp_entry = {
+	.offset = 0x10500,
+};
+
+void psp_add_device(struct psp_device *psp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&psp_devs_lock, flags);
+
+	list_add_tail(&psp->entry, &psp_devs);
+
+	spin_unlock_irqrestore(&psp_devs_lock, flags);
+}
+
+void psp_del_device(struct psp_device *psp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&psp_devs_lock, flags);
+
+	list_del(&psp->entry);
+	spin_unlock_irqrestore(&psp_devs_lock, flags);
+}
+
+static struct psp_device *psp_alloc_struct(struct sp_device *sp)
+{
+	struct device *dev = sp->dev;
+	struct psp_device *psp;
+
+	psp = devm_kzalloc(dev, sizeof(*psp), GFP_KERNEL);
+	if (!psp)
+		return NULL;
+
+	psp->dev = dev;
+	psp->sp = sp;
+
+	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
+
+	return psp;
+}
+
+irqreturn_t psp_irq_handler(int irq, void *data)
+{
+	unsigned int status;
+	irqreturn_t ret = IRQ_HANDLED;
+	struct psp_device *psp = data;
+
+	/* read the interrupt status */
+	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
+
+	/* invoke subdevice interrupt handlers */
+	if (status) {
+		if (psp->sev_irq_handler)
+			ret = psp->sev_irq_handler(irq, psp->sev_irq_data);
+		if (psp->tee_irq_handler)
+			ret = psp->tee_irq_handler(irq, psp->tee_irq_data);
+	}
+
+	/* clear the interrupt status */
+	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
+
+	return ret;
+}
+
+static int psp_init(struct psp_device *psp)
+{
+	psp_add_device(psp);
+
+	return 0;
+}
+
+int psp_dev_init(struct sp_device *sp)
+{
+	struct device *dev = sp->dev;
+	struct psp_device *psp;
+	int ret;
+
+	ret = -ENOMEM;
+	psp = psp_alloc_struct(sp);
+	if (!psp)
+		goto e_err;
+	sp->psp_data = psp;
+
+	psp->vdata = (struct psp_vdata *)sp->dev_vdata->psp_vdata;
+	if (!psp->vdata) {
+		ret = -ENODEV;
+		dev_err(dev, "missing driver data\n");
+		goto e_err;
+	}
+
+	psp->io_regs = sp->io_map + psp->vdata->offset;
+
+	/* Disable and clear interrupts until ready */
+	iowrite32(0, psp->io_regs + PSP_P2CMSG_INTEN);
+	iowrite32(0xffffffff, psp->io_regs + PSP_P2CMSG_INTSTS);
+
+	dev_dbg(dev, "requesting an IRQ ...\n");
+	/* Request an irq */
+	ret = sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
+	if (ret) {
+		dev_err(dev, "psp: unable to allocate an IRQ\n");
+		goto e_err;
+	}
+
+	sp_set_psp_master(sp);
+
+	dev_dbg(dev, "initializing psp\n");
+	ret = psp_init(psp);
+	if (ret) {
+		dev_err(dev, "failed to init psp\n");
+		goto e_irq;
+	}
+
+	/* Enable interrupt */
+	dev_dbg(dev, "Enabling interrupts ...\n");
+	iowrite32(7, psp->io_regs + PSP_P2CMSG_INTEN);
+
+	dev_notice(dev, "psp enabled\n");
+
+	return 0;
+
+e_irq:
+	sp_free_psp_irq(psp->sp, psp);
+e_err:
+	sp->psp_data = NULL;
+
+	dev_notice(dev, "psp initialization failed\n");
+
+	return ret;
+}
+
+void psp_dev_destroy(struct sp_device *sp)
+{
+	struct psp_device *psp = sp->psp_data;
+
+	sp_free_psp_irq(sp, psp);
+
+	psp_del_device(psp);
+}
+
+int psp_dev_resume(struct sp_device *sp)
+{
+	return 0;
+}
+
+int psp_dev_suspend(struct sp_device *sp, pm_message_t state)
+{
+	return 0;
+}
+
+int psp_request_tee_irq(struct psp_device *psp, irq_handler_t handler,
+			void *data)
+{
+	psp->tee_irq_data = data;
+	psp->tee_irq_handler = handler;
+
+	return 0;
+}
+
+int psp_free_tee_irq(struct psp_device *psp, void *data)
+{
+	if (psp->tee_irq_handler) {
+		psp->tee_irq_data = NULL;
+		psp->tee_irq_handler = NULL;
+	}
+
+	return 0;
+}
+
+int psp_request_sev_irq(struct psp_device *psp, irq_handler_t handler,
+			void *data)
+{
+	psp->sev_irq_data = data;
+	psp->sev_irq_handler = handler;
+
+	return 0;
+}
+
+int psp_free_sev_irq(struct psp_device *psp, void *data)
+{
+	if (psp->sev_irq_handler) {
+		psp->sev_irq_data = NULL;
+		psp->sev_irq_handler = NULL;
+	}
+
+	return 0;
+}
+
+struct psp_device *psp_get_master_device(void)
+{
+	struct sp_device *sp = sp_get_psp_master_device();
+
+	return sp ? sp->psp_data : NULL;
+}
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
new file mode 100644
index 0000000..6e167b8
--- /dev/null
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -0,0 +1,82 @@
+/*
+ * AMD Platform Security Processor (PSP) interface driver
+ *
+ * Copyright (C) 2017 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PSP_DEV_H__
+#define __PSP_DEV_H__
+
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/dmapool.h>
+#include <linux/hw_random.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/dmaengine.h>
+
+#include "sp-dev.h"
+
+#define PSP_P2CMSG_INTEN		0x0110
+#define PSP_P2CMSG_INTSTS		0x0114
+
+#define PSP_C2PMSG_ATTR_0		0x0118
+#define PSP_C2PMSG_ATTR_1		0x011c
+#define PSP_C2PMSG_ATTR_2		0x0120
+#define PSP_C2PMSG_ATTR_3		0x0124
+#define PSP_P2CMSG_ATTR_0		0x0128
+
+#define PSP_CMDRESP_CMD_SHIFT		16
+#define PSP_CMDRESP_IOC			BIT(0)
+#define PSP_CMDRESP_RESP		BIT(31)
+#define PSP_CMDRESP_ERR_MASK		0xffff
+
+#define MAX_PSP_NAME_LEN		16
+
+struct psp_device {
+	struct list_head entry;
+
+	struct psp_vdata *vdata;
+	char name[MAX_PSP_NAME_LEN];
+
+	struct device *dev;
+	struct sp_device *sp;
+
+	void __iomem *io_regs;
+
+	irq_handler_t sev_irq_handler;
+	void *sev_irq_data;
+	irq_handler_t tee_irq_handler;
+	void *tee_irq_data;
+
+	void *sev_data;
+	void *tee_data;
+};
+
+void psp_add_device(struct psp_device *psp);
+void psp_del_device(struct psp_device *psp);
+
+int psp_request_sev_irq(struct psp_device *psp, irq_handler_t handler,
+			void *data);
+int psp_free_sev_irq(struct psp_device *psp, void *data);
+
+int psp_request_tee_irq(struct psp_device *psp, irq_handler_t handler,
+			void *data);
+int psp_free_tee_irq(struct psp_device *psp, void *data);
+
+struct psp_device *psp_get_master_device(void);
+
+extern const struct psp_vdata psp_entry;
+
+#endif /* __PSP_DEV_H */
diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index a017233..d263ba4 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -198,6 +198,8 @@ int sp_init(struct sp_device *sp)
 	if (sp->dev_vdata->ccp_vdata)
 		ccp_dev_init(sp);
 
+	if (sp->dev_vdata->psp_vdata)
+		psp_dev_init(sp);
 	return 0;
 }
 
@@ -206,6 +208,9 @@ void sp_destroy(struct sp_device *sp)
 	if (sp->dev_vdata->ccp_vdata)
 		ccp_dev_destroy(sp);
 
+	if (sp->dev_vdata->psp_vdata)
+		psp_dev_destroy(sp);
+
 	sp_del_device(sp);
 }
 
@@ -219,6 +224,12 @@ int sp_suspend(struct sp_device *sp, pm_message_t state)
 			return ret;
 	}
 
+	if (sp->dev_vdata->psp_vdata) {
+		ret = psp_dev_suspend(sp, state);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -232,9 +243,41 @@ int sp_resume(struct sp_device *sp)
 			return ret;
 	}
 
+	if (sp->dev_vdata->psp_vdata) {
+		ret = psp_dev_resume(sp);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
+struct sp_device *sp_get_psp_master_device(void)
+{
+	unsigned long flags;
+	struct sp_device *i, *ret = NULL;
+
+	write_lock_irqsave(&sp_unit_lock, flags);
+	if (list_empty(&sp_units))
+		goto unlock;
+
+	list_for_each_entry(i, &sp_units, entry) {
+		if (i->psp_data)
+			break;
+	}
+
+	if (i->get_psp_master_device)
+		ret = i->get_psp_master_device();
+unlock:
+	write_unlock_irqrestore(&sp_unit_lock, flags);
+	return ret;
+}
+
+void sp_set_psp_master(struct sp_device *sp)
+{
+	if (sp->set_psp_master_device)
+		sp->set_psp_master_device(sp);
+}
+
 static int __init sp_mod_init(void)
 {
 #ifdef CONFIG_X86
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 3520da4..f98a3f9 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -41,12 +41,19 @@ struct ccp_vdata {
 	const struct ccp_actions *perform;
 	const unsigned int offset;
 };
+
+struct psp_vdata {
+	const unsigned int version;
+	const struct psp_actions *perform;
+	const unsigned int offset;
+};
+
 /* Structure to hold SP device data */
 struct sp_dev_vdata {
 	const unsigned int bar;
 
 	const struct ccp_vdata *ccp_vdata;
-	void *psp_vdata;
+	const struct psp_vdata *psp_vdata;
 };
 
 struct sp_device {
@@ -67,6 +74,10 @@ struct sp_device {
 	/* DMA caching attribute support */
 	unsigned int axcache;
 
+	/* get and set master device */
+	struct sp_device*(*get_psp_master_device)(void);
+	void(*set_psp_master_device)(struct sp_device *);
+
 	bool irq_registered;
 	bool use_tasklet;
 
@@ -102,6 +113,8 @@ void sp_free_ccp_irq(struct sp_device *sp, void *data);
 int sp_request_psp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
 void sp_free_psp_irq(struct sp_device *sp, void *data);
+void sp_set_psp_master(struct sp_device *sp);
+struct sp_device *sp_get_psp_master_device(void);
 
 #ifdef CONFIG_CRYPTO_DEV_SP_CCP
 
@@ -129,4 +142,30 @@ static inline int ccp_dev_resume(struct sp_device *sp)
 }
 #endif	/* CONFIG_CRYPTO_DEV_SP_CCP */
 
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+
+int psp_dev_init(struct sp_device *sp);
+void psp_dev_destroy(struct sp_device *sp);
+
+int psp_dev_suspend(struct sp_device *sp, pm_message_t state);
+int psp_dev_resume(struct sp_device *sp);
+#else /* !CONFIG_CRYPTO_DEV_SP_PSP */
+
+static inline int psp_dev_init(struct sp_device *sp)
+{
+	return 0;
+}
+static inline void psp_dev_destroy(struct sp_device *sp) { }
+
+static inline int psp_dev_suspend(struct sp_device *sp, pm_message_t state)
+{
+	return 0;
+}
+static inline int psp_dev_resume(struct sp_device *sp)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
+
 #endif
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 9859aa6..e58b3ad 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -25,6 +25,7 @@
 #include <linux/ccp.h>
 
 #include "ccp-dev.h"
+#include "psp-dev.h"
 
 #define MSIX_VECTORS			2
 
@@ -32,6 +33,7 @@ struct sp_pci {
 	int msix_count;
 	struct msix_entry msix_entry[MSIX_VECTORS];
 };
+static struct sp_device *sp_dev_master;
 
 static int sp_get_msix_irqs(struct sp_device *sp)
 {
@@ -108,6 +110,45 @@ static void sp_free_irqs(struct sp_device *sp)
 	sp->psp_irq = 0;
 }
 
+static bool sp_pci_is_master(struct sp_device *sp)
+{
+	struct device *dev_cur, *dev_new;
+	struct pci_dev *pdev_cur, *pdev_new;
+
+	dev_new = sp->dev;
+	dev_cur = sp_dev_master->dev;
+
+	pdev_new = to_pci_dev(dev_new);
+	pdev_cur = to_pci_dev(dev_cur);
+
+	if (pdev_new->bus->number < pdev_cur->bus->number)
+		return true;
+
+	if (PCI_SLOT(pdev_new->devfn) < PCI_SLOT(pdev_cur->devfn))
+		return true;
+
+	if (PCI_FUNC(pdev_new->devfn) < PCI_FUNC(pdev_cur->devfn))
+		return true;
+
+	return false;
+}
+
+static void psp_set_master(struct sp_device *sp)
+{
+	if (!sp_dev_master) {
+		sp_dev_master = sp;
+		return;
+	}
+
+	if (sp_pci_is_master(sp))
+		sp_dev_master = sp;
+}
+
+static struct sp_device *psp_get_master(void)
+{
+	return sp_dev_master;
+}
+
 static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct sp_device *sp;
@@ -166,6 +207,8 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto e_err;
 
 	pci_set_master(pdev);
+	sp->set_psp_master_device = psp_set_master;
+	sp->get_psp_master_device = psp_get_master;
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
@@ -237,6 +280,9 @@ static const struct sp_dev_vdata dev_vdata[] = {
 #ifdef CONFIG_CRYPTO_DEV_SP_CCP
 		.ccp_vdata = &ccpv5a,
 #endif
+#ifdef CONFIG_CRYPTO_DEV_PSP
+		.psp_vdata = &psp_entry
+#endif
 	},
 	{
 		.bar = 2,
-- 
2.9.4
