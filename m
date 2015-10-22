From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: qat - remove superfluous check from adf_probe
Date: Thu, 22 Oct 2015 15:23:12 +0100
Message-ID: <1445523792-28389-1-git-send-email-salvatore.benedetto@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:24838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803AbbJVOXT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Oct 2015 10:23:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 - ent->device is already checked at the beginning of the function
   against the same value. This check is a duplicate.

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 8 +-------
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 9 +--------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index f8dd14f..f933f7d 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -253,13 +253,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	accel_dev->hw_device = hw_data;
-	switch (ent->device) {
-	case ADF_DH895XCC_PCI_DEVICE_ID:
-		adf_init_hw_data_dh895xcc(accel_dev->hw_device);
-		break;
-	default:
-		return -ENODEV;
-	}
+	adf_init_hw_data_dh895xcc(accel_dev->hw_device);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DH895XCC_FUSECTL_OFFSET,
 			      &hw_data->fuses);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 789426f..7bec249 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -243,14 +243,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 	accel_dev->hw_device = hw_data;
-	switch (ent->device) {
-	case ADF_DH895XCCIOV_PCI_DEVICE_ID:
-		adf_init_hw_data_dh895xcciov(accel_dev->hw_device);
-		break;
-	default:
-		ret = -ENODEV;
-		goto out_err;
-	}
+	adf_init_hw_data_dh895xcciov(accel_dev->hw_device);
 
 	/* Get Accelerators and Accelerators Engines masks */
 	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-- 
1.9.1
