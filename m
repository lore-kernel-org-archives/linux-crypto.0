From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] iommu/amd - Set the device table entry PPR bit for IOMMU V2
 devices
Date: Wed, 20 Dec 2017 10:57:31 -0600
Message-ID: <151378905140.769.2045094569843732393.stgit@sosxen2.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: yong.zhao@amd.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0077.outbound.protection.outlook.com ([104.47.38.77]:49056
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755532AbdLTQ5i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 11:57:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AMD IOMMU specification Rev 3.00 (December 2016) introduces a
new Enhanced PPR Handling Support (EPHSup) bit in the MMIO register
offset 0030h (IOMMU Extended Feature Register).

When EPHSup=1, the IOMMU hardware requires the PPR bit of the
device table entry (DTE) to be set in order to support PPR for a
particular endpoint device.

Please see https://support.amd.com/TechDocs/48882_IOMMU.pdf for
this revision of the AMD IOMMU specification.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/iommu/amd_iommu.c       |   20 +++++++++++++++-----
 drivers/iommu/amd_iommu_types.h |    2 ++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index cb78933ef53f..5f3da95ff6a0 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1818,7 +1818,8 @@ static bool dma_ops_domain(struct protection_domain *domain)
 	return domain->flags & PD_DMA_OPS_MASK;
 }
 
-static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
+static void set_dte_entry(u16 devid, struct protection_domain *domain,
+			  bool ats, bool ppr)
 {
 	u64 pte_root = 0;
 	u64 flags = 0;
@@ -1835,6 +1836,13 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 	if (ats)
 		flags |= DTE_FLAG_IOTLB;
 
+	if (ppr) {
+		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+
+		if (iommu_feature(iommu, FEATURE_EPHSUP))
+			pte_root |= 1ULL << DEV_ENTRY_PPR;
+	}
+
 	if (domain->flags & PD_IOMMUV2_MASK) {
 		u64 gcr3 = iommu_virt_to_phys(domain->gcr3_tbl);
 		u64 glx  = domain->glx;
@@ -1897,9 +1905,9 @@ static void do_attach(struct iommu_dev_data *dev_data,
 	domain->dev_cnt                 += 1;
 
 	/* Update device table */
-	set_dte_entry(dev_data->devid, domain, ats);
+	set_dte_entry(dev_data->devid, domain, ats, dev_data->iommu_v2);
 	if (alias != dev_data->devid)
-		set_dte_entry(alias, domain, ats);
+		set_dte_entry(alias, domain, ats, dev_data->iommu_v2);
 
 	device_flush_dte(dev_data);
 }
@@ -2278,13 +2286,15 @@ static void update_device_table(struct protection_domain *domain)
 	struct iommu_dev_data *dev_data;
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		set_dte_entry(dev_data->devid, domain, dev_data->ats.enabled);
+		set_dte_entry(dev_data->devid, domain, dev_data->ats.enabled,
+			      dev_data->iommu_v2);
 
 		if (dev_data->devid == dev_data->alias)
 			continue;
 
 		/* There is an alias, update device table entry for it */
-		set_dte_entry(dev_data->alias, domain, dev_data->ats.enabled);
+		set_dte_entry(dev_data->alias, domain, dev_data->ats.enabled,
+			      dev_data->iommu_v2);
 	}
 }
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index f6b24c7d8b70..6a877ebd058b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -98,6 +98,7 @@
 #define FEATURE_HE		(1ULL<<8)
 #define FEATURE_PC		(1ULL<<9)
 #define FEATURE_GAM_VAPIC	(1ULL<<21)
+#define FEATURE_EPHSUP		(1ULL<<50)
 
 #define FEATURE_PASID_SHIFT	32
 #define FEATURE_PASID_MASK	(0x1fULL << FEATURE_PASID_SHIFT)
@@ -192,6 +193,7 @@
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
 #define DEV_ENTRY_TRANSLATION   0x01
+#define DEV_ENTRY_PPR           0x34
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
 #define DEV_ENTRY_NO_PAGE_FAULT	0x62
