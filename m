Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8387FC433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 10:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE9621D7B
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 10:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgIIK7u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 06:59:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:31532 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgIIK7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 06:59:48 -0400
IronPort-SDR: +VgKKMNdgTBEc67cb4qv69g2F8pJ2xZG57bDfNnSJt4s1PCzfNoG5j+Aey3HioeG7DSYmAldYV
 M6jQTQRwVaoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="222511312"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="222511312"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 03:59:46 -0700
IronPort-SDR: sPoKyiqduOaI6vkbjU3p28ZiOxdxpFVf/NNC9AyL0QZhPSoIAHcDO/Jx8qBE5YiKe6vl/uXpJM
 GjqrIE1bwHHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="341534345"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Sep 2020 03:59:44 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH RESEND 1/2] crypto: qat - replace device ids defines
Date:   Wed,  9 Sep 2020 11:59:39 +0100
Message-Id: <20200909105940.203532-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909105940.203532-1-giovanni.cabiddu@intel.com>
References: <20200909105940.203532-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace device ids defined in the QAT drivers with the ones in
include/linux/pci_ids.h.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c            | 6 +++---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c          | 6 +++---
 drivers/crypto/qat/qat_c62x/adf_drv.c             | 6 +++---
 drivers/crypto/qat/qat_c62xvf/adf_drv.c           | 6 +++---
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 6 ------
 drivers/crypto/qat/qat_common/qat_hal.c           | 7 ++++---
 drivers/crypto/qat/qat_common/qat_uclo.c          | 9 +++++----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         | 6 +++---
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c       | 6 +++---
 9 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 020d099409e5..bba0f142f7f6 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -22,7 +22,7 @@
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(ADF_C3XXX_PCI_DEVICE_ID),
+	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C3XXX),
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -58,7 +58,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 	if (accel_dev->hw_device) {
 		switch (accel_pci_dev->pci_dev->device) {
-		case ADF_C3XXX_PCI_DEVICE_ID:
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 			adf_clean_hw_data_c3xxx(accel_dev->hw_device);
 			break;
 		default:
@@ -83,7 +83,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	switch (ent->device) {
-	case ADF_C3XXX_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 11039fe55f61..b77a58886599 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -22,7 +22,7 @@
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(ADF_C3XXXIOV_PCI_DEVICE_ID),
+	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF),
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -58,7 +58,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 	if (accel_dev->hw_device) {
 		switch (accel_pci_dev->pci_dev->device) {
-		case ADF_C3XXXIOV_PCI_DEVICE_ID:
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
 			adf_clean_hw_data_c3xxxiov(accel_dev->hw_device);
 			break;
 		default:
@@ -85,7 +85,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	switch (ent->device) {
-	case ADF_C3XXXIOV_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 4ba9c14383af..722838ff03be 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -22,7 +22,7 @@
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(ADF_C62X_PCI_DEVICE_ID),
+	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C62X),
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -58,7 +58,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 	if (accel_dev->hw_device) {
 		switch (accel_pci_dev->pci_dev->device) {
-		case ADF_C62X_PCI_DEVICE_ID:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X:
 			adf_clean_hw_data_c62x(accel_dev->hw_device);
 			break;
 		default:
@@ -83,7 +83,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	switch (ent->device) {
-	case ADF_C62X_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_C62X:
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index b8b021d54bb5..a766cc18aae9 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -22,7 +22,7 @@
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(ADF_C62XIOV_PCI_DEVICE_ID),
+	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C62X_VF),
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -58,7 +58,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 	if (accel_dev->hw_device) {
 		switch (accel_pci_dev->pci_dev->device) {
-		case ADF_C62XIOV_PCI_DEVICE_ID:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
 			adf_clean_hw_data_c62xiov(accel_dev->hw_device);
 			break;
 		default:
@@ -85,7 +85,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	switch (ent->device) {
-	case ADF_C62XIOV_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index c1db8c26afb6..06952ece53d9 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -15,12 +15,6 @@
 #define ADF_C62XVF_DEVICE_NAME "c6xxvf"
 #define ADF_C3XXX_DEVICE_NAME "c3xxx"
 #define ADF_C3XXXVF_DEVICE_NAME "c3xxxvf"
-#define ADF_DH895XCC_PCI_DEVICE_ID 0x435
-#define ADF_DH895XCCIOV_PCI_DEVICE_ID 0x443
-#define ADF_C62X_PCI_DEVICE_ID 0x37c8
-#define ADF_C62XIOV_PCI_DEVICE_ID 0x37c9
-#define ADF_C3XXX_PCI_DEVICE_ID 0x19e2
-#define ADF_C3XXXIOV_PCI_DEVICE_ID 0x19e3
 #define ADF_ERRSOU3 (0x3A000 + 0x0C)
 #define ADF_ERRSOU5 (0x3A000 + 0xD8)
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index fa467e0f8285..6b9d47682d04 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/pci_ids.h>
 
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
@@ -412,7 +413,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 	unsigned int csr_val;
 	int times = 30;
 
-	if (handle->pci_dev->device != ADF_DH895XCC_PCI_DEVICE_ID)
+	if (handle->pci_dev->device != PCI_DEVICE_ID_INTEL_QAT_DH895XCC)
 		return 0;
 
 	csr_val = ADF_CSR_RD(csr_addr, 0);
@@ -672,13 +673,13 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 		(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v +
 				 LOCAL_TO_XFER_REG_OFFSET);
 	handle->pci_dev = pci_info->pci_dev;
-	if (handle->pci_dev->device == ADF_DH895XCC_PCI_DEVICE_ID) {
+	if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_DH895XCC) {
 		sram_bar =
 			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
 		handle->hal_sram_addr_v = sram_bar->virt_addr;
 	}
 	handle->fw_auth = (handle->pci_dev->device ==
-			   ADF_DH895XCC_PCI_DEVICE_ID) ? false : true;
+			   PCI_DEVICE_ID_INTEL_QAT_DH895XCC) ? false : true;
 	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
 	if (!handle->hal_handle)
 		goto out_hal_handle;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index bff759e2f811..978d1fce0e74 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -4,6 +4,7 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
+#include <linux/pci_ids.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "icp_qat_uclo.h"
@@ -711,11 +712,11 @@ static unsigned int
 qat_uclo_get_dev_type(struct icp_qat_fw_loader_handle *handle)
 {
 	switch (handle->pci_dev->device) {
-	case ADF_DH895XCC_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		return ICP_QAT_AC_895XCC_DEV_TYPE;
-	case ADF_C62X_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_C62X:
 		return ICP_QAT_AC_C62X_DEV_TYPE;
-	case ADF_C3XXX_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		return ICP_QAT_AC_C3XXX_DEV_TYPE;
 	default:
 		pr_err("QAT: unsupported device 0x%x\n",
@@ -1391,7 +1392,7 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 			status = qat_uclo_auth_fw(handle, desc);
 		qat_uclo_ummap_auth_fw(handle, &desc);
 	} else {
-		if (handle->pci_dev->device == ADF_C3XXX_PCI_DEVICE_ID) {
+		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_C3XXX) {
 			pr_err("QAT: C3XXX doesn't support unsigned MMP\n");
 			return -EINVAL;
 		}
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 4e877b75822b..4c3aea07f444 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -22,7 +22,7 @@
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(ADF_DH895XCC_PCI_DEVICE_ID),
+	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_DH895XCC),
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -58,7 +58,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 	if (accel_dev->hw_device) {
 		switch (accel_pci_dev->pci_dev->device) {
-		case ADF_DH895XCC_PCI_DEVICE_ID:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 			adf_clean_hw_data_dh895xcc(accel_dev->hw_device);
 			break;
 		default:
@@ -83,7 +83,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	switch (ent->device) {
-	case ADF_DH895XCC_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 7d6e1db272c2..673348ca5dea 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -22,7 +22,7 @@
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(ADF_DH895XCCIOV_PCI_DEVICE_ID),
+	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF),
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -58,7 +58,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 	if (accel_dev->hw_device) {
 		switch (accel_pci_dev->pci_dev->device) {
-		case ADF_DH895XCCIOV_PCI_DEVICE_ID:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
 			adf_clean_hw_data_dh895xcciov(accel_dev->hw_device);
 			break;
 		default:
@@ -85,7 +85,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	switch (ent->device) {
-	case ADF_DH895XCCIOV_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
-- 
2.26.2

