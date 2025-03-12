Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562DE1D63FF
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 11:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741779616; cv=none; b=aJhxXMqu/7KmIyfx7vnjCBNc1sv+CJ0VJqKb9FL7iJzpYNzFWFtMVgdkwOoetpOgqNmwU/F89i72hR/aKYDKOjShaGneWIKowtZAnvdvjX1U9ys5REog9l9arZdE0Yzvcbze8wggrhSUz8CRMgNzKpkeILLEJImZJLXAw37boqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741779616; c=relaxed/simple;
	bh=r+4qqWwQKI9mNIs8z1vPZ3rFAdFsf+bPVs4sqJdT7Xc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FdhrvteezJ/zr/hH6NTQeQMOtzMTzMy+vqxFodKaP1M2xb36LBXRjAw0+y1ahN9MRcOiKnsQTHhjJHyE1ymsa65lmtTczAHUB/r4vIkSGco5bi0vRSMdPGf/D2ZFKEI+dIHS2SDdBSiGayX61CMnnxg49ZVJRhkC2DmVVM7LV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bz7eH735; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bz7eH735"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741779615; x=1773315615;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r+4qqWwQKI9mNIs8z1vPZ3rFAdFsf+bPVs4sqJdT7Xc=;
  b=Bz7eH7359/gMtcKWPFZWYQt0Ta11hmfi41ANzzWVbBF4RSrb8mIpNGRG
   HtyapumVEFJUXFaseCs4RZ5xhlOYvbhVover7TZLZDfkQBY3JOR7ic2aD
   E4UefaTwF5NvJdaWdaNHbAeI6gSAWXWg7iVHk8kF47DH/0hCb0BluYvfI
   3UqvgrDJxbQivWivxtnp7Is8NyJZD9N/SMfwMHO/FDFrzODH05ZhpCCxZ
   eNjs/rU0H/PeeFn94e0dyzB0VdLA6m/en3ih9WZbRKwKX0slL1IInQCub
   5flahA66a0Fwb7OeHlnmEC2KTumkfryvL4Zli6a2Yw/a54OqO5nEgcIFf
   w==;
X-CSE-ConnectionGUID: 3WbnIiTKRVCjBXgo+xZBKQ==
X-CSE-MsgGUID: 76pfwRQSRL+ad1m1B4iGVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="60255024"
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="60255024"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 04:40:14 -0700
X-CSE-ConnectionGUID: evZs+bS2T6CBvuiSUZWutw==
X-CSE-MsgGUID: dZ19fomiQZqHhUZlalIgZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="151422532"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa002.jf.intel.com with ESMTP; 12 Mar 2025 04:40:11 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - introduce fuse array
Date: Wed, 12 Mar 2025 11:39:38 +0000
Message-Id: <20250312113938.766631-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the representation of fuses in the accelerator device
structure from a single value to an array.

This allows the structure to accommodate additional fuses that
are required for future generations of QAT hardware.

This does not introduce any functional changes.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c   |  2 +-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c         |  2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c |  2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c          |  2 +-
 .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  4 ++--
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c         |  2 +-
 drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c |  4 ++--
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c          |  4 ++--
 .../crypto/intel/qat/qat_common/adf_accel_devices.h  | 12 +++++++++++-
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c   |  2 +-
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c    |  6 +++---
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c      |  2 +-
 12 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 87c71914ae87..98f3c1210666 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -98,7 +98,7 @@ static struct adf_hw_device_class adf_420xx_class = {
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 me_disable = self->fuses;
+	u32 me_disable = self->fuses[ADF_FUSECTL4];
 
 	return ~me_disable & ADF_420XX_ACCELENGINES_MASK;
 }
diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index 9589d60fb281..8084aa0f7f41 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -79,7 +79,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_420xx(accel_dev->hw_device, ent->device);
 
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
-	pci_read_config_dword(pdev, ADF_GEN4_FUSECTL4_OFFSET, &hw_data->fuses);
+	pci_read_config_dword(pdev, ADF_GEN4_FUSECTL4_OFFSET, &hw_data->fuses[ADF_FUSECTL4]);
 
 	/* Get Accelerators and Accelerators Engines masks */
 	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 36eebda3a028..4eb6ef99efdd 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -101,7 +101,7 @@ static struct adf_hw_device_class adf_4xxx_class = {
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 me_disable = self->fuses;
+	u32 me_disable = self->fuses[ADF_FUSECTL4];
 
 	return ~me_disable & ADF_4XXX_ACCELENGINES_MASK;
 }
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index d7de1cad1335..5537a9991e4e 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -81,7 +81,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_4xxx(accel_dev->hw_device, ent->device);
 
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
-	pci_read_config_dword(pdev, ADF_GEN4_FUSECTL4_OFFSET, &hw_data->fuses);
+	pci_read_config_dword(pdev, ADF_GEN4_FUSECTL4_OFFSET, &hw_data->fuses[ADF_FUSECTL4]);
 
 	/* Get Accelerators and Accelerators Engines masks */
 	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 201f9412c582..e78f7bfd30b8 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -27,8 +27,8 @@ static struct adf_hw_device_class c3xxx_class = {
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
+	u32 fuses = self->fuses[ADF_FUSECTL0];
 	u32 straps = self->straps;
-	u32 fuses = self->fuses;
 	u32 accel;
 
 	accel = ~(fuses | straps) >> ADF_C3XXX_ACCELERATORS_REG_OFFSET;
@@ -39,8 +39,8 @@ static u32 get_accel_mask(struct adf_hw_device_data *self)
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
+	u32 fuses = self->fuses[ADF_FUSECTL0];
 	u32 straps = self->straps;
-	u32 fuses = self->fuses;
 	unsigned long disabled;
 	u32 ae_disable;
 	int accel;
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index caa53882fda6..b825b35ab4bf 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -126,7 +126,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_c3xxx(accel_dev->hw_device);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
-			      &hw_data->fuses);
+			      &hw_data->fuses[ADF_FUSECTL0]);
 	pci_read_config_dword(pdev, ADF_C3XXX_SOFTSTRAP_CSR_OFFSET,
 			      &hw_data->straps);
 
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 6b5b0cf9c7c7..32ebe09477a8 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -27,8 +27,8 @@ static struct adf_hw_device_class c62x_class = {
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
+	u32 fuses = self->fuses[ADF_FUSECTL0];
 	u32 straps = self->straps;
-	u32 fuses = self->fuses;
 	u32 accel;
 
 	accel = ~(fuses | straps) >> ADF_C62X_ACCELERATORS_REG_OFFSET;
@@ -39,8 +39,8 @@ static u32 get_accel_mask(struct adf_hw_device_data *self)
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
+	u32 fuses = self->fuses[ADF_FUSECTL0];
 	u32 straps = self->straps;
-	u32 fuses = self->fuses;
 	unsigned long disabled;
 	u32 ae_disable;
 	int accel;
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index b7398fee19ed..8a7bdec358d6 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -126,7 +126,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_c62x(accel_dev->hw_device);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
-			      &hw_data->fuses);
+			      &hw_data->fuses[ADF_FUSECTL0]);
 	pci_read_config_dword(pdev, ADF_C62X_SOFTSTRAP_CSR_OFFSET,
 			      &hw_data->straps);
 
@@ -169,7 +169,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
 
 	/* Find and map all the device's BARS */
-	i = (hw_data->fuses & ADF_DEVICE_FUSECTL_MASK) ? 1 : 0;
+	i = (hw_data->fuses[ADF_FUSECTL0] & ADF_DEVICE_FUSECTL_MASK) ? 1 : 0;
 	bar_mask = pci_select_bars(pdev, IORESOURCE_MEM);
 	for_each_set_bit(bar_nr, &bar_mask, ADF_PCI_MAX_BARS * 2) {
 		struct adf_bar *bar = &accel_pci_dev->pci_bars[i++];
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 0509174d6030..dc21551153cb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -53,6 +53,16 @@ enum adf_accel_capabilities {
 	ADF_ACCEL_CAPABILITIES_RANDOM_NUMBER = 128
 };
 
+enum adf_fuses {
+	ADF_FUSECTL0,
+	ADF_FUSECTL1,
+	ADF_FUSECTL2,
+	ADF_FUSECTL3,
+	ADF_FUSECTL4,
+	ADF_FUSECTL5,
+	ADF_MAX_FUSES
+};
+
 struct adf_bar {
 	resource_size_t base_addr;
 	void __iomem *virt_addr;
@@ -345,7 +355,7 @@ struct adf_hw_device_data {
 	struct qat_migdev_ops vfmig_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
-	u32 fuses;
+	u32 fuses[ADF_MAX_FUSES];
 	u32 straps;
 	u32 accel_capabilities_mask;
 	u32 extended_dc_capabilities;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
index 1f64bf49b221..2b263442c856 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
@@ -115,8 +115,8 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct pci_dev *pdev = accel_dev->accel_pci_dev.pci_dev;
+	u32 fuses = hw_data->fuses[ADF_FUSECTL0];
 	u32 straps = hw_data->straps;
-	u32 fuses = hw_data->fuses;
 	u32 legfuses;
 	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index c0661ff5e929..e48bcf1818cd 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -29,7 +29,7 @@ static struct adf_hw_device_class dh895xcc_class = {
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
-	u32 fuses = self->fuses;
+	u32 fuses = self->fuses[ADF_FUSECTL0];
 
 	return ~fuses >> ADF_DH895XCC_ACCELERATORS_REG_OFFSET &
 			 ADF_DH895XCC_ACCELERATORS_MASK;
@@ -37,7 +37,7 @@ static u32 get_accel_mask(struct adf_hw_device_data *self)
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 fuses = self->fuses;
+	u32 fuses = self->fuses[ADF_FUSECTL0];
 
 	return ~fuses & ADF_DH895XCC_ACCELENGINES_MASK;
 }
@@ -99,7 +99,7 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
-	int sku = (self->fuses & ADF_DH895XCC_FUSECTL_SKU_MASK)
+	int sku = (self->fuses[ADF_FUSECTL0] & ADF_DH895XCC_FUSECTL_SKU_MASK)
 	    >> ADF_DH895XCC_FUSECTL_SKU_SHIFT;
 
 	switch (sku) {
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index 3137fc3b5cf6..07e9d7e52861 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -126,7 +126,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_dh895xcc(accel_dev->hw_device);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
-			      &hw_data->fuses);
+			      &hw_data->fuses[ADF_FUSECTL0]);
 
 	/* Get Accelerators and Accelerators Engines masks */
 	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);

base-commit: f97a9e0738b14a7d65c1bb92c87614965c3ad17a
-- 
2.40.1

