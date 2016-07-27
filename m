From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 01/10] crypto: ccp - Abstract PCI info for the CCP
Date: Tue, 26 Jul 2016 19:09:20 -0500
Message-ID: <20160727000920.24944.33926.stgit@taos>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0066.outbound.protection.outlook.com ([104.47.34.66]:63232
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756964AbcG0AYZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:24:25 -0400
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Device-specific values for the BAR and offset should be found
in the version data structure.


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |    3 +++
 drivers/crypto/ccp/ccp-dev.h    |    3 +++
 drivers/crypto/ccp/ccp-pci.c    |   15 +++++++--------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index d7a7103..2f7f3c5 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -541,4 +542,6 @@ static const struct ccp_actions ccp3_actions = {
 struct ccp_vdata ccpv3 = {
 	.version = CCP_VERSION(3, 0),
 	.perform = &ccp3_actions,
+	.bar = 2,
+	.offset = 0x20000,
 };
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 5fbee638..8824e41 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -4,6 +4,7 @@
  * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -163,6 +164,8 @@ struct ccp_actions {
 struct ccp_vdata {
 	unsigned int version;
 	const struct ccp_actions *perform;
+	const unsigned int bar;
+	const unsigned int offset;
 };
 
 extern struct ccp_vdata ccpv3;
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 0bf262e..072bced 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -25,9 +26,6 @@
 
 #include "ccp-dev.h"
 
-#define IO_BAR				2
-#define IO_OFFSET			0x20000
-
 #define MSIX_VECTORS			2
 
 struct ccp_msix {
@@ -156,10 +154,11 @@ static int ccp_find_mmio_area(struct ccp_device *ccp)
 	resource_size_t io_len;
 	unsigned long io_flags;
 
-	io_flags = pci_resource_flags(pdev, IO_BAR);
-	io_len = pci_resource_len(pdev, IO_BAR);
-	if ((io_flags & IORESOURCE_MEM) && (io_len >= (IO_OFFSET + 0x800)))
-		return IO_BAR;
+	io_flags = pci_resource_flags(pdev, ccp->vdata->bar);
+	io_len = pci_resource_len(pdev, ccp->vdata->bar);
+	if ((io_flags & IORESOURCE_MEM) &&
+	    (io_len >= (ccp->vdata->offset + 0x800)))
+		return ccp->vdata->bar;
 
 	return -EIO;
 }
@@ -216,7 +215,7 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(dev, "pci_iomap failed\n");
 		goto e_device;
 	}
-	ccp->io_regs = ccp->io_map + IO_OFFSET;
+	ccp->io_regs = ccp->io_map + ccp->vdata->offset;
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
