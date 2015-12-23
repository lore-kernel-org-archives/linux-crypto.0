From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] crypto: ccp - use to_pci_dev and to_platform_device
Date: Wed, 23 Dec 2015 20:49:01 +0800
Message-ID: <3a86c7e2921be1783aaab4dfbb3f4021a0e2f8d4.1450874840.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:50853 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbbLWMtk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 07:49:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use to_pci_dev() and to_platform_device() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/crypto/ccp/ccp-pci.c      | 8 ++++----
 drivers/crypto/ccp/ccp-platform.c | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 6ade02f..7690467 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -44,7 +44,7 @@ static int ccp_get_msix_irqs(struct ccp_device *ccp)
 {
 	struct ccp_pci *ccp_pci = ccp->dev_specific;
 	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct msix_entry msix_entry[MSIX_VECTORS];
 	unsigned int name_len = sizeof(ccp_pci->msix[0].name) - 1;
 	int v, ret;
@@ -86,7 +86,7 @@ e_irq:
 static int ccp_get_msi_irq(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
 	int ret;
 
 	ret = pci_enable_msi(pdev);
@@ -133,7 +133,7 @@ static void ccp_free_irqs(struct ccp_device *ccp)
 {
 	struct ccp_pci *ccp_pci = ccp->dev_specific;
 	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (ccp_pci->msix_count) {
 		while (ccp_pci->msix_count--)
@@ -149,7 +149,7 @@ static void ccp_free_irqs(struct ccp_device *ccp)
 static int ccp_find_mmio_area(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
 	resource_size_t io_len;
 	unsigned long io_flags;
 
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 01b50cb..66dd7c9 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -35,8 +35,7 @@ struct ccp_platform {
 static int ccp_get_irq(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
-	struct platform_device *pdev = container_of(dev,
-					struct platform_device, dev);
+	struct platform_device *pdev = to_platform_device(dev);
 	int ret;
 
 	ret = platform_get_irq(pdev, 0);
@@ -78,8 +77,7 @@ static void ccp_free_irqs(struct ccp_device *ccp)
 static struct resource *ccp_find_mmio_area(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
-	struct platform_device *pdev = container_of(dev,
-					struct platform_device, dev);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *ior;
 
 	ior = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
2.5.0
