From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix constants table DMA
Date: Mon, 29 Aug 2016 13:28:31 +0100
Message-ID: <1472473711-611-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:42403 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932211AbcH2M2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 08:28:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Maksim Lukoshkov <maksim.lukoshkov@intel.com>

Copy const_tab array into DMA-able memory (accesible by qat hw).

Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index ce7c462..3744b22 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -146,6 +146,7 @@ struct adf_admin_comms {
 	dma_addr_t phy_addr;
 	dma_addr_t const_tbl_addr;
 	void *virt_addr;
+	void *virt_tbl_addr;
 	void __iomem *mailbox_addr;
 	struct mutex lock;	/* protects adf_admin_comms struct */
 };
@@ -251,17 +252,19 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 		return -ENOMEM;
 	}
 
-	admin->const_tbl_addr = dma_map_single(&GET_DEV(accel_dev),
-					       (void *) const_tab, 1024,
-					       DMA_TO_DEVICE);
-
-	if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
-				       admin->const_tbl_addr))) {
+	admin->virt_tbl_addr = dma_zalloc_coherent(&GET_DEV(accel_dev),
+						   PAGE_SIZE,
+						   &admin->const_tbl_addr,
+						   GFP_KERNEL);
+	if (!admin->virt_tbl_addr) {
+		dev_err(&GET_DEV(accel_dev), "Failed to allocate const_tbl\n");
 		dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
 				  admin->virt_addr, admin->phy_addr);
 		kfree(admin);
 		return -ENOMEM;
 	}
+
+	memcpy(admin->virt_tbl_addr, const_tab, sizeof(const_tab));
 	reg_val = (u64)admin->phy_addr;
 	ADF_CSR_WR(csr, ADF_DH895XCC_ADMINMSGUR_OFFSET, reg_val >> 32);
 	ADF_CSR_WR(csr, ADF_DH895XCC_ADMINMSGLR_OFFSET, reg_val);
@@ -282,9 +285,10 @@ void adf_exit_admin_comms(struct adf_accel_dev *accel_dev)
 	if (admin->virt_addr)
 		dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
 				  admin->virt_addr, admin->phy_addr);
+	if (admin->virt_tbl_addr)
+		dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
+				  admin->virt_tbl_addr, admin->const_tbl_addr);
 
-	dma_unmap_single(&GET_DEV(accel_dev), admin->const_tbl_addr, 1024,
-			 DMA_TO_DEVICE);
 	mutex_destroy(&admin->lock);
 	kfree(admin);
 	accel_dev->admin = NULL;
-- 
1.7.4.1
