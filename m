From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] crypto: qat: use pcie_flr instead of duplicating it
Date: Tue, 16 May 2017 16:21:05 +0200
Message-ID: <20170516142105.21686-1-hch@lst.de>
Cc: herbert@gondor.apana.org.au, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
To: giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55155 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752287AbdEPOVQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2017 10:21:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 2839fccdd84b..d3e25c37dc33 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -109,20 +109,7 @@ EXPORT_SYMBOL_GPL(adf_reset_sbr);
 
 void adf_reset_flr(struct adf_accel_dev *accel_dev)
 {
-	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
-	u16 control = 0;
-	int pos = 0;
-
-	dev_info(&GET_DEV(accel_dev), "Function level reset\n");
-	pos = pci_pcie_cap(pdev);
-	if (!pos) {
-		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		return;
-	}
-	pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &control);
-	control |= PCI_EXP_DEVCTL_BCR_FLR;
-	pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, control);
-	msleep(100);
+	pcie_flr(accel_to_pci_dev(accel_dev));
 }
 EXPORT_SYMBOL_GPL(adf_reset_flr);
 
-- 
2.11.0
