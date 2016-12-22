From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - modify format of dev top level debugfs entries
Date: Thu, 22 Dec 2016 15:00:34 +0000
Message-ID: <20161222150034.6203-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13817 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758570AbcLVPAw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 10:00:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>

Remove leading zeros in pci function number to be consistent
with output from lspci.

Signed-off-by: Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 2 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 2 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 2 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 2 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 640c3fc..f172171 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -186,7 +186,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
 		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
 		 pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn));
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 949d77b..24ec908 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -170,7 +170,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
 		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
 		 pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn));
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 5b2d78a..58a984c9 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -186,7 +186,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
 		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
 		 pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn));
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 7540ce1..b9f3e0e 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -170,7 +170,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
 		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
 		 pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn));
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 4d2de28..2ce01f0 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -186,7 +186,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
 		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
 		 pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn));
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 60df986..26ab17b 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -170,7 +170,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
 		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
 		 pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn));
-- 
2.9.3
