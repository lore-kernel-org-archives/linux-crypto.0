From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 4/5] crypto: ccp - Convert calls to their devm_
 counterparts
Date: Tue, 3 Feb 2015 13:07:23 -0600
Message-ID: <20150203190723.15045.5531.stgit@tlendack-t1.amdoffice.net>
References: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:11025
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965959AbbBCTWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 14:22:11 -0500
In-Reply-To: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Where applicable, convert calls to their devm_ counterparts, e.g. kzalloc
to devm_kzalloc.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c      |    2 +-
 drivers/crypto/ccp/ccp-pci.c      |   19 +++++--------------
 drivers/crypto/ccp/ccp-platform.c |   11 +++--------
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 68c637a..861bacc 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -295,7 +295,7 @@ struct ccp_device *ccp_alloc_struct(struct device *dev)
 {
 	struct ccp_device *ccp;
 
-	ccp = kzalloc(sizeof(*ccp), GFP_KERNEL);
+	ccp = devm_kzalloc(dev, sizeof(*ccp), GFP_KERNEL);
 	if (!ccp)
 		return NULL;
 	ccp->dev = dev;
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 1980f77..af190d4 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -174,11 +174,10 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ccp)
 		goto e_err;
 
-	ccp_pci = kzalloc(sizeof(*ccp_pci), GFP_KERNEL);
-	if (!ccp_pci) {
-		ret = -ENOMEM;
-		goto e_free1;
-	}
+	ccp_pci = devm_kzalloc(dev, sizeof(*ccp_pci), GFP_KERNEL);
+	if (!ccp_pci)
+		goto e_err;
+
 	ccp->dev_specific = ccp_pci;
 	ccp->get_irq = ccp_get_irqs;
 	ccp->free_irq = ccp_free_irqs;
@@ -186,7 +185,7 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = pci_request_regions(pdev, "ccp");
 	if (ret) {
 		dev_err(dev, "pci_request_regions failed (%d)\n", ret);
-		goto e_free2;
+		goto e_err;
 	}
 
 	ret = pci_enable_device(pdev);
@@ -239,12 +238,6 @@ e_device:
 e_regions:
 	pci_release_regions(pdev);
 
-e_free2:
-	kfree(ccp_pci);
-
-e_free1:
-	kfree(ccp);
-
 e_err:
 	dev_notice(dev, "initialization failed\n");
 	return ret;
@@ -266,8 +259,6 @@ static void ccp_pci_remove(struct pci_dev *pdev)
 
 	pci_release_regions(pdev);
 
-	kfree(ccp);
-
 	dev_notice(dev, "disabled\n");
 }
 
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 04265a3..20661f0 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -103,7 +103,7 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	ccp->io_map = devm_ioremap_resource(dev, ior);
 	if (IS_ERR(ccp->io_map)) {
 		ret = PTR_ERR(ccp->io_map);
-		goto e_free;
+		goto e_err;
 	}
 	ccp->io_regs = ccp->io_map;
 
@@ -112,7 +112,7 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
-		goto e_free;
+		goto e_err;
 	}
 
 	if (of_property_read_bool(dev->of_node, "dma-coherent"))
@@ -124,15 +124,12 @@ static int ccp_platform_probe(struct platform_device *pdev)
 
 	ret = ccp_init(ccp);
 	if (ret)
-		goto e_free;
+		goto e_err;
 
 	dev_notice(dev, "enabled\n");
 
 	return 0;
 
-e_free:
-	kfree(ccp);
-
 e_err:
 	dev_notice(dev, "initialization failed\n");
 	return ret;
@@ -145,8 +142,6 @@ static int ccp_platform_remove(struct platform_device *pdev)
 
 	ccp_destroy(ccp);
 
-	kfree(ccp);
-
 	dev_notice(dev, "disabled\n");
 
 	return 0;
