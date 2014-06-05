From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH V1 1/3] crypto: ccp - Modify PCI support in prep for arm64
 support
Date: Thu, 5 Jun 2014 10:17:45 -0500
Message-ID: <20140605151745.20604.24457.stgit@tlendack-t1.amdoffice.net>
References: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:43512
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559AbaFEPdD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 11:33:03 -0400
In-Reply-To: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify the PCI device support in prep for supporting the
CCP as a platform device for arm64.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |    3 +--
 drivers/crypto/ccp/ccp-pci.c |   39 ++++++++++++++-------------------------
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 7ec536e..72bf153 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -23,8 +23,6 @@
 #include <linux/hw_random.h>
 
 
-#define IO_OFFSET			0x20000
-
 #define MAX_DMAPOOL_NAME_LEN		32
 
 #define MAX_HW_QUEUES			5
@@ -194,6 +192,7 @@ struct ccp_device {
 	void *dev_specific;
 	int (*get_irq)(struct ccp_device *ccp);
 	void (*free_irq)(struct ccp_device *ccp);
+	unsigned int irq;
 
 	/*
 	 * I/O area used for device communication. The register mapping
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 0d74623..180cc87 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -12,8 +12,10 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/dma-mapping.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
@@ -24,6 +26,8 @@
 #include "ccp-dev.h"
 
 #define IO_BAR				2
+#define IO_OFFSET			0x20000
+
 #define MSIX_VECTORS			2
 
 struct ccp_msix {
@@ -89,7 +93,8 @@ static int ccp_get_msi_irq(struct ccp_device *ccp)
 	if (ret)
 		return ret;
 
-	ret = request_irq(pdev->irq, ccp_irq_handler, 0, "ccp", dev);
+	ccp->irq = pdev->irq;
+	ret = request_irq(ccp->irq, ccp_irq_handler, 0, "ccp", dev);
 	if (ret) {
 		dev_notice(dev, "unable to allocate MSI IRQ (%d)\n", ret);
 		goto e_msi;
@@ -136,7 +141,7 @@ static void ccp_free_irqs(struct ccp_device *ccp)
 				 dev);
 		pci_disable_msix(pdev);
 	} else {
-		free_irq(pdev->irq, dev);
+		free_irq(ccp->irq, dev);
 		pci_disable_msi(pdev);
 	}
 }
@@ -147,21 +152,12 @@ static int ccp_find_mmio_area(struct ccp_device *ccp)
 	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
 	resource_size_t io_len;
 	unsigned long io_flags;
-	int bar;
 
 	io_flags = pci_resource_flags(pdev, IO_BAR);
 	io_len = pci_resource_len(pdev, IO_BAR);
 	if ((io_flags & IORESOURCE_MEM) && (io_len >= (IO_OFFSET + 0x800)))
 		return IO_BAR;
 
-	for (bar = 0; bar < PCI_STD_RESOURCE_END; bar++) {
-		io_flags = pci_resource_flags(pdev, bar);
-		io_len = pci_resource_len(pdev, bar);
-		if ((io_flags & IORESOURCE_MEM) &&
-		    (io_len >= (IO_OFFSET + 0x800)))
-			return bar;
-	}
-
 	return -EIO;
 }
 
@@ -214,20 +210,13 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	ccp->io_regs = ccp->io_map + IO_OFFSET;
 
-	ret = dma_set_mask(dev, DMA_BIT_MASK(48));
-	if (ret == 0) {
-		ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(48));
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (ret) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 		if (ret) {
-			dev_err(dev,
-				"pci_set_consistent_dma_mask failed (%d)\n",
+			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
 				ret);
-			goto e_bar0;
-		}
-	} else {
-		ret = dma_set_mask(dev, DMA_BIT_MASK(32));
-		if (ret) {
-			dev_err(dev, "pci_set_dma_mask failed (%d)\n", ret);
-			goto e_bar0;
+			goto e_iomap;
 		}
 	}
 
@@ -235,13 +224,13 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = ccp_init(ccp);
 	if (ret)
-		goto e_bar0;
+		goto e_iomap;
 
 	dev_notice(dev, "enabled\n");
 
 	return 0;
 
-e_bar0:
+e_iomap:
 	pci_iounmap(pdev, ccp->io_map);
 
 e_device:
