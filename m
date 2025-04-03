Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1525D212
	for <linux-crypto@vger.kernel.org>; Thu,  3 Apr 2025 20:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710866; cv=none; b=YjX0v3uSadsaQaDscovay6TMr1y3nzaSChOcd3y2GNtH/pKl+xYdsGBnwWxrkaajVxXp4rrY+xM4uAtuCPm6PtrsxMkbP5Dr8FFFczA/91jBnSfEsybUyVjFHWw03AqpaA0n72mqwSBHUusB0x+WYbUzDZWtdGFMXwU8rsceqSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710866; c=relaxed/simple;
	bh=b9Y31fbj/b7rz/nXfY+Yg5xE0Bw1dktQy8Rkl1clFm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s6E7aVmN5ZIWl6oFlOffWOUIZXSduCarAx5gmcDvWyVumEOL1lqyqfjVnOmPo9McWQBxicE1y8sp/+wpvQ3MUXqcksXUfFFuZ9sWc9okJ1PC2byTdKgEI9rid5ioUoH7fFQmUFWfqsjnu7/v8GRsfePuR78pWERn5ZdrlqIutEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i1j8DM9/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i1j8DM9/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743710864; x=1775246864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b9Y31fbj/b7rz/nXfY+Yg5xE0Bw1dktQy8Rkl1clFm8=;
  b=i1j8DM9/N1WjMaWHXJmHuu0X05mjn6sQcFdgpL5FfOpQm9HD/SFnBCqh
   PFX8VYQGDVKzggYzV/AhHjvc5TlBI7Q4762nuL5EFeRYKw32aX7s/yyA9
   kKVnK/rKYmzxKUlH+kWAkffYqZut5ov4N12QMd/pSF4uI0XDLY0dhyZHa
   12BOohrBQvuGcBbhynzg7Z7GcfCHqNZnd6juXjzv7JO50TMk4Z6yYuwaI
   e1zv3qEjVh8NSvNpXpT8hEPAEdwwQ+aUlLLPI+4J1a67O4RD89m2mLchf
   gEnfxvKUnc4psqtWvlRG4nHH57mdzfgzArOFJAcF9lrbfJD6rXkaO+lVD
   Q==;
X-CSE-ConnectionGUID: XXPaWfD1TWOteaKs6K2CCw==
X-CSE-MsgGUID: yWqEi+AeR3mp/Vg/NY8b7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="44392373"
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="44392373"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 13:07:43 -0700
X-CSE-ConnectionGUID: MxjujKfWTLWQadJWQzzq4g==
X-CSE-MsgGUID: TcAJSYEpTtaempzZKFC0rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="127966722"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa009.fm.intel.com with ESMTP; 03 Apr 2025 13:07:42 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - switch to standard pattern for PCI IDs
Date: Thu,  3 Apr 2025 21:07:28 +0100
Message-ID: <20250403200734.7415-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Update the names of the defines for PCI IDs to follow the standard
naming convention `PCI_DEVICE_ID_<DEVICE NAME>`.

Also drop the unnecessary inner comma from the pci_device_id tables that
use these definitions.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c     |  2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c |  4 ++--
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c      |  6 +++---
 .../intel/qat/qat_common/adf_accel_devices.h     | 16 ++++++++--------
 drivers/crypto/intel/qat/qat_common/qat_hal.c    | 10 +++++-----
 drivers/crypto/intel/qat/qat_common/qat_uclo.c   |  8 ++++----
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index b4731f02deb8..cfa00daeb4fb 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -14,7 +14,7 @@
 #include "adf_420xx_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, ADF_420XX_PCI_DEVICE_ID), },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_420XX) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 63c7c8e90cca..7d4c366aa8b2 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -421,13 +421,13 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->admin_ae_mask = ADF_4XXX_ADMIN_AE_MASK;
 	hw_data->num_rps = ADF_GEN4_MAX_RPS;
 	switch (dev_id) {
-	case ADF_402XX_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_402XX:
 		hw_data->fw_name = ADF_402XX_FW;
 		hw_data->fw_mmp_name = ADF_402XX_MMP;
 		hw_data->uof_get_name = uof_get_name_402xx;
 		hw_data->get_ena_thd_mask = get_ena_thd_mask;
 		break;
-	case ADF_401XX_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_401XX:
 		hw_data->fw_name = ADF_4XXX_FW;
 		hw_data->fw_mmp_name = ADF_4XXX_MMP;
 		hw_data->uof_get_name = uof_get_name_4xxx;
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 1ac415ef3c31..c9be5dcddb27 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -14,9 +14,9 @@
 #include "adf_4xxx_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, ADF_4XXX_PCI_DEVICE_ID), },
-	{ PCI_VDEVICE(INTEL, ADF_401XX_PCI_DEVICE_ID), },
-	{ PCI_VDEVICE(INTEL, ADF_402XX_PCI_DEVICE_ID), },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_4XXX) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_401XX) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_402XX) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index dc21551153cb..1e301a20c244 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -25,14 +25,14 @@
 #define ADF_C3XXXVF_DEVICE_NAME "c3xxxvf"
 #define ADF_4XXX_DEVICE_NAME "4xxx"
 #define ADF_420XX_DEVICE_NAME "420xx"
-#define ADF_4XXX_PCI_DEVICE_ID 0x4940
-#define ADF_4XXXIOV_PCI_DEVICE_ID 0x4941
-#define ADF_401XX_PCI_DEVICE_ID 0x4942
-#define ADF_401XXIOV_PCI_DEVICE_ID 0x4943
-#define ADF_402XX_PCI_DEVICE_ID 0x4944
-#define ADF_402XXIOV_PCI_DEVICE_ID 0x4945
-#define ADF_420XX_PCI_DEVICE_ID 0x4946
-#define ADF_420XXIOV_PCI_DEVICE_ID 0x4947
+#define PCI_DEVICE_ID_INTEL_QAT_4XXX 0x4940
+#define PCI_DEVICE_ID_INTEL_QAT_4XXXIOV 0x4941
+#define PCI_DEVICE_ID_INTEL_QAT_401XX 0x4942
+#define PCI_DEVICE_ID_INTEL_QAT_401XXIOV 0x4943
+#define PCI_DEVICE_ID_INTEL_QAT_402XX 0x4944
+#define PCI_DEVICE_ID_INTEL_QAT_402XXIOV 0x4945
+#define PCI_DEVICE_ID_INTEL_QAT_420XX 0x4946
+#define PCI_DEVICE_ID_INTEL_QAT_420XXIOV 0x4947
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_DEVICE_FUSECTL_MASK 0x80000000
diff --git a/drivers/crypto/intel/qat/qat_common/qat_hal.c b/drivers/crypto/intel/qat/qat_common/qat_hal.c
index ef8a9cf74f0c..841c1d7d3ffe 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -694,16 +694,16 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 
 	handle->pci_dev = pci_info->pci_dev;
 	switch (handle->pci_dev->device) {
-	case ADF_4XXX_PCI_DEVICE_ID:
-	case ADF_401XX_PCI_DEVICE_ID:
-	case ADF_402XX_PCI_DEVICE_ID:
-	case ADF_420XX_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_4XXX:
+	case PCI_DEVICE_ID_INTEL_QAT_401XX:
+	case PCI_DEVICE_ID_INTEL_QAT_402XX:
+	case PCI_DEVICE_ID_INTEL_QAT_420XX:
 		handle->chip_info->mmp_sram_size = 0;
 		handle->chip_info->nn = false;
 		handle->chip_info->lm2lm3 = true;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG_2X;
 		handle->chip_info->icp_rst_csr = ICP_RESET_CPP0;
-		if (handle->pci_dev->device == ADF_420XX_PCI_DEVICE_ID)
+		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_420XX)
 			handle->chip_info->icp_rst_mask = 0x100155;
 		else
 			handle->chip_info->icp_rst_mask = 0x100015;
diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 87e247ac1c9a..620300e70238 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -732,10 +732,10 @@ qat_uclo_get_dev_type(struct icp_qat_fw_loader_handle *handle)
 		return ICP_QAT_AC_C62X_DEV_TYPE;
 	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		return ICP_QAT_AC_C3XXX_DEV_TYPE;
-	case ADF_4XXX_PCI_DEVICE_ID:
-	case ADF_401XX_PCI_DEVICE_ID:
-	case ADF_402XX_PCI_DEVICE_ID:
-	case ADF_420XX_PCI_DEVICE_ID:
+	case PCI_DEVICE_ID_INTEL_QAT_4XXX:
+	case PCI_DEVICE_ID_INTEL_QAT_401XX:
+	case PCI_DEVICE_ID_INTEL_QAT_402XX:
+	case PCI_DEVICE_ID_INTEL_QAT_420XX:
 		return ICP_QAT_AC_4XXX_A_DEV_TYPE;
 	default:
 		pr_err("QAT: unsupported device 0x%x\n",

base-commit: fa6e29c73cccd2afa7f9c1873fc9d47e2330e465
-- 
2.49.0

