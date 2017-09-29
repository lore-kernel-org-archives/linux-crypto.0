From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v4.1 05/30] crypto: ccp: Add Platform Security Processor (PSP) device support
Date: Fri, 29 Sep 2017 11:23:22 -0500
Message-ID: <20170929162322.47553-1-brijesh.singh@amd.com>
References: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: bp@suse.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Platform Security Processor (PSP) is part of AMD Secure Processor
(AMD-SP), PSP is a dedicated processor that provides the support for
key management commands in a Secure Encrypted Virtualization (SEV) mode,
along with software-based Trusted Execution Environment (TEE) to enable
the third-party trusted applications.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---

Hi Boris,

I have been going through feedbacks and issues reported by kbuild robot and
have been making the fixes at:

repo: https://github.com/codomania/kvm.git
branch: sev-v4-p2+fixes

After I am finished with all the fixes then will submit v5 part2.
In meantime, if you don't mind then can you look at updated patches
on sev-v4-p2+fixes branch or you can just wait for me to submit v5.

thank you very much.

-Brijesh

 drivers/crypto/ccp/Kconfig   |  11 +++++
 drivers/crypto/ccp/Makefile  |   1 +
 drivers/crypto/ccp/psp-dev.c | 113 +++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/psp-dev.h |  61 +++++++++++++++++++++++
 drivers/crypto/ccp/sp-dev.c  |  26 ++++++++++
 drivers/crypto/ccp/sp-dev.h  |  26 +++++++++-
 drivers/crypto/ccp/sp-pci.c  |  46 ++++++++++++++++++
 7 files changed, 283 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/ccp/psp-dev.c
 create mode 100644 drivers/crypto/ccp/psp-dev.h

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 6d626606b9c5..627f3e61dcac 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -32,3 +32,14 @@ config CRYPTO_DEV_CCP_CRYPTO
 	  Support for using the cryptographic API with the AMD Cryptographic
 	  Coprocessor. This module supports offload of SHA and AES algorithms.
 	  If you choose 'M' here, this module will be called ccp_crypto.
+
+config CRYPTO_DEV_SP_PSP
+	bool "Platform Security Processor (PSP) device"
+	default y
+	depends on CRYPTO_DEV_CCP_DD
+	help
+	 Provide the support for AMD Platform Security Processor (PSP). PSP is
+	 a dedicated processor that provides the support for key management
+	 commands in a Secure Encrypted Virtualiztion (SEV) mode, along with
+	 software-based Trusted Execution Environment (TEE) to enable the
+	 third-party trusted applications.
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 57f8debfcfb3..008bae7e26ec 100644
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
index 000000000000..b201c524c28f
--- /dev/null
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -0,0 +1,113 @@
+/*
+ * AMD Platform Security Processor (PSP) interface
+ *
+ * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
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
+const struct psp_vdata psp_entry = {
+	.offset = 0x10500,
+};
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
+static irqreturn_t psp_irq_handler(int irq, void *data)
+{
+	return IRQ_HANDLED;
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
+
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
+	iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTSTS);
+
+	dev_dbg(dev, "requesting an IRQ ...\n");
+	/* Request an irq */
+	ret = sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
+	if (ret) {
+		dev_err(dev, "psp: unable to allocate an IRQ\n");
+		goto e_err;
+	}
+
+	if (sp->set_psp_master_device)
+		sp->set_psp_master_device(sp);
+
+	/* Enable interrupt */
+	dev_dbg(dev, "Enabling interrupts ...\n");
+	iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTEN);
+
+	dev_notice(dev, "psp enabled\n");
+
+	return 0;
+
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
+}
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
new file mode 100644
index 000000000000..d53970ef5960
--- /dev/null
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -0,0 +1,61 @@
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
+};
+
+extern const struct psp_vdata psp_entry;
+
+#endif /* __PSP_DEV_H */
diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index bef387c8abfd..cf101c039c8f 100644
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
 
@@ -237,6 +242,27 @@ int sp_resume(struct sp_device *sp)
 }
 #endif
 
+struct sp_device *sp_get_psp_master_device(void)
+{
+	struct sp_device *i, *ret = NULL;
+	unsigned long flags;
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
 static int __init sp_mod_init(void)
 {
 #ifdef CONFIG_X86
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 5ab486ade1ad..761dba176168 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -42,12 +42,19 @@ struct ccp_vdata {
 	const unsigned int offset;
 	const unsigned int rsamax;
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
@@ -68,6 +75,10 @@ struct sp_device {
 	/* DMA caching attribute support */
 	unsigned int axcache;
 
+	/* get and set master device */
+	struct sp_device*(*get_psp_master_device)(void);
+	void (*set_psp_master_device)(struct sp_device *);
+
 	bool irq_registered;
 	bool use_tasklet;
 
@@ -103,6 +114,7 @@ void sp_free_ccp_irq(struct sp_device *sp, void *data);
 int sp_request_psp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
 void sp_free_psp_irq(struct sp_device *sp, void *data);
+struct sp_device *sp_get_psp_master_device(void);
 
 #ifdef CONFIG_CRYPTO_DEV_SP_CCP
 
@@ -130,4 +142,16 @@ static inline int ccp_dev_resume(struct sp_device *sp)
 }
 #endif	/* CONFIG_CRYPTO_DEV_SP_CCP */
 
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+
+int psp_dev_init(struct sp_device *sp);
+void psp_dev_destroy(struct sp_device *sp);
+
+#else /* !CONFIG_CRYPTO_DEV_SP_PSP */
+
+static inline int psp_dev_init(struct sp_device *sp) { return 0; }
+static inline void psp_dev_destroy(struct sp_device *sp) { }
+
+#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
+
 #endif
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 9859aa683a28..20a0f3543cf4 100644
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
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata = &psp_entry
+#endif
 	},
 	{
 		.bar = 2,
-- 
2.9.5
