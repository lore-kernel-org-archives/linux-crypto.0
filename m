From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix bar discovery for c62x
Date: Thu, 22 Dec 2016 15:00:12 +0000
Message-ID: <20161222150012.6040-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756592AbcLVPAR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 10:00:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some accelerators of the c62x series have only two bars.
This patch skips BAR0 if the accelerator does not have it.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c62x/adf_drv.c             | 2 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index bc5cbc1..5b2d78a 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -233,7 +233,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			      &hw_data->accel_capabilities_mask);
 
 	/* Find and map all the device's BARS */
-	i = 0;
+	i = (hw_data->fuses & ADF_DEVICE_FUSECTL_MASK) ? 1 : 0;
 	bar_mask = pci_select_bars(pdev, IORESOURCE_MEM);
 	for_each_set_bit(bar_nr, (const unsigned long *)&bar_mask,
 			 ADF_PCI_MAX_BARS * 2) {
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index e882253..33f0a62 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -69,6 +69,7 @@
 #define ADF_ERRSOU5 (0x3A000 + 0xD8)
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
+#define ADF_DEVICE_FUSECTL_MASK 0x80000000
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16
-- 
2.9.3
