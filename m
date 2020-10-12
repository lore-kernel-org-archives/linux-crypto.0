Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E915AC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A942020BED
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgJLUjH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:33900 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:07 -0400
IronPort-SDR: L/j4Kr5/F5MhGYdmjGTpZ5/tcwKiuZR5dBMyRNSd22rPu50oUu64W88QvoJgLcDm2j/JIR3rDv
 wCLg9iAUiBHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913058"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913058"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:06 -0700
IronPort-SDR: tR5tf7wvYUrw21xjJrt4QLWZNkIpe8PZ0hldRc9O5qYeZDHyq+KZtizzmHHTKMEgff/ebxO+Q7
 YeVJPcQqfjBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328117"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:04 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 02/31] crypto: qat - mask device capabilities with soft straps
Date:   Mon, 12 Oct 2020 21:38:18 +0100
Message-Id: <20201012203847.340030-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable acceleration engines (AEs) and accelerators based on soft straps
and fuses. When looping with a number of AEs or accelerators, ignore the
ones that are disabled.

This patch is based on earlier work done by Conor McLoughlin.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 34 +++++++++++++++----
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |  1 +
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  6 ++--
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |  4 +--
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  4 +--
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 34 +++++++++++++++----
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |  1 +
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  6 ++--
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |  4 +--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  4 +--
 .../crypto/qat/qat_common/adf_accel_devices.h |  5 +--
 drivers/crypto/qat/qat_common/qat_hal.c       | 27 ++++++++-------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 20 +++++++----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  4 +--
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  4 +--
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  4 +--
 16 files changed, 109 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index aee494d3da52..4b2f5aa83391 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -17,15 +17,33 @@ static struct adf_hw_device_class c3xxx_class = {
 	.instances = 0
 };
 
-static u32 get_accel_mask(u32 fuse)
+static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
-	return (~fuse) >> ADF_C3XXX_ACCELERATORS_REG_OFFSET &
-		ADF_C3XXX_ACCELERATORS_MASK;
+	u32 straps = self->straps;
+	u32 fuses = self->fuses;
+	u32 accel;
+
+	accel = ~(fuses | straps) >> ADF_C3XXX_ACCELERATORS_REG_OFFSET;
+	accel &= ADF_C3XXX_ACCELERATORS_MASK;
+
+	return accel;
 }
 
-static u32 get_ae_mask(u32 fuse)
+static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	return (~fuse) & ADF_C3XXX_ACCELENGINES_MASK;
+	u32 straps = self->straps;
+	u32 fuses = self->fuses;
+	unsigned long disabled;
+	u32 ae_disable;
+	int accel;
+
+	/* If an accel is disabled, then disable the corresponding two AEs */
+	disabled = ~get_accel_mask(self) & ADF_C3XXX_ACCELERATORS_MASK;
+	ae_disable = BIT(1) | BIT(0);
+	for_each_set_bit(accel, &disabled, ADF_C3XXX_MAX_ACCELERATORS)
+		straps |= ae_disable << (accel << 1);
+
+	return ~(fuses | straps) & ADF_C3XXX_ACCELENGINES_MASK;
 }
 
 static u32 get_num_accels(struct adf_hw_device_data *self)
@@ -109,11 +127,13 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
 	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_C3XXX_PMISC_BAR];
+	unsigned long accel_mask = hw_device->accel_mask;
+	unsigned long ae_mask = hw_device->ae_mask;
 	void __iomem *csr = misc_bar->virt_addr;
 	unsigned int val, i;
 
 	/* Enable Accel Engine error detection & correction */
-	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
+	for_each_set_bit(i, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
 		val = ADF_CSR_RD(csr, ADF_C3XXX_AE_CTX_ENABLES(i));
 		val |= ADF_C3XXX_ENABLE_AE_ECC_ERR;
 		ADF_CSR_WR(csr, ADF_C3XXX_AE_CTX_ENABLES(i), val);
@@ -123,7 +143,7 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 	}
 
 	/* Enable shared memory error detection & correction */
-	for (i = 0; i < hw_device->get_num_accels(hw_device); i++) {
+	for_each_set_bit(i, &accel_mask, ADF_C3XXX_MAX_ACCELERATORS) {
 		val = ADF_CSR_RD(csr, ADF_C3XXX_UERRSSMSH(i));
 		val |= ADF_C3XXX_ERRSSMSH_EN;
 		ADF_CSR_WR(csr, ADF_C3XXX_UERRSSMSH(i), val);
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index 8b5dd2c94ebf..94097816f68a 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -18,6 +18,7 @@
 #define ADF_C3XXX_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
 #define ADF_C3XXX_SMIA0_MASK 0xFFFF
 #define ADF_C3XXX_SMIA1_MASK 0x1
+#define ADF_C3XXX_SOFTSTRAP_CSR_OFFSET 0x2EC
 /* Error detection and correction */
 #define ADF_C3XXX_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
 #define ADF_C3XXX_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index ed0e8e33fe4b..da6e88026988 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -126,10 +126,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
 			      &hw_data->fuses);
+	pci_read_config_dword(pdev, ADF_C3XXX_SOFTSTRAP_CSR_OFFSET,
+			      &hw_data->straps);
 
 	/* Get Accelerators and Accelerators Engines masks */
-	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 	/* If the device has no acceleration engines then ignore it. */
 	if (!hw_data->accel_mask || !hw_data->ae_mask ||
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index d2fedbd7113c..cdf8c500ef2a 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -11,12 +11,12 @@ static struct adf_hw_device_class c3xxxiov_class = {
 	.instances = 0
 };
 
-static u32 get_accel_mask(u32 fuse)
+static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
 	return ADF_C3XXXIOV_ACCELERATORS_MASK;
 }
 
-static u32 get_ae_mask(u32 fuse)
+static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
 	return ADF_C3XXXIOV_ACCELENGINES_MASK;
 }
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 456979b136a2..1d1532e8fb6d 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -119,8 +119,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_c3xxxiov(accel_dev->hw_device);
 
 	/* Get Accelerators and Accelerators Engines masks */
-	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 844ad5ed33fc..c0b5751e9682 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -22,15 +22,33 @@ static struct adf_hw_device_class c62x_class = {
 	.instances = 0
 };
 
-static u32 get_accel_mask(u32 fuse)
+static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
-	return (~fuse) >> ADF_C62X_ACCELERATORS_REG_OFFSET &
-			  ADF_C62X_ACCELERATORS_MASK;
+	u32 straps = self->straps;
+	u32 fuses = self->fuses;
+	u32 accel;
+
+	accel = ~(fuses | straps) >> ADF_C62X_ACCELERATORS_REG_OFFSET;
+	accel &= ADF_C62X_ACCELERATORS_MASK;
+
+	return accel;
 }
 
-static u32 get_ae_mask(u32 fuse)
+static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	return (~fuse) & ADF_C62X_ACCELENGINES_MASK;
+	u32 straps = self->straps;
+	u32 fuses = self->fuses;
+	unsigned long disabled;
+	u32 ae_disable;
+	int accel;
+
+	/* If an accel is disabled, then disable the corresponding two AEs */
+	disabled = ~get_accel_mask(self) & ADF_C62X_ACCELERATORS_MASK;
+	ae_disable = BIT(1) | BIT(0);
+	for_each_set_bit(accel, &disabled, ADF_C62X_MAX_ACCELERATORS)
+		straps |= ae_disable << (accel << 1);
+
+	return ~(fuses | straps) & ADF_C62X_ACCELENGINES_MASK;
 }
 
 static u32 get_num_accels(struct adf_hw_device_data *self)
@@ -119,11 +137,13 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
 	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_C62X_PMISC_BAR];
+	unsigned long accel_mask = hw_device->accel_mask;
+	unsigned long ae_mask = hw_device->ae_mask;
 	void __iomem *csr = misc_bar->virt_addr;
 	unsigned int val, i;
 
 	/* Enable Accel Engine error detection & correction */
-	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
+	for_each_set_bit(i, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
 		val = ADF_CSR_RD(csr, ADF_C62X_AE_CTX_ENABLES(i));
 		val |= ADF_C62X_ENABLE_AE_ECC_ERR;
 		ADF_CSR_WR(csr, ADF_C62X_AE_CTX_ENABLES(i), val);
@@ -133,7 +153,7 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 	}
 
 	/* Enable shared memory error detection & correction */
-	for (i = 0; i < hw_device->get_num_accels(hw_device); i++) {
+	for_each_set_bit(i, &accel_mask, ADF_C62X_MAX_ACCELERATORS) {
 		val = ADF_CSR_RD(csr, ADF_C62X_UERRSSMSH(i));
 		val |= ADF_C62X_ERRSSMSH_EN;
 		ADF_CSR_WR(csr, ADF_C62X_UERRSSMSH(i), val);
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
index 88504d2bf30d..a2e2961a2102 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
@@ -19,6 +19,7 @@
 #define ADF_C62X_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
 #define ADF_C62X_SMIA0_MASK 0xFFFF
 #define ADF_C62X_SMIA1_MASK 0x1
+#define ADF_C62X_SOFTSTRAP_CSR_OFFSET 0x2EC
 /* Error detection and correction */
 #define ADF_C62X_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
 #define ADF_C62X_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index d8e7c9c25590..3da697a566ad 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -126,10 +126,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
 			      &hw_data->fuses);
+	pci_read_config_dword(pdev, ADF_C62X_SOFTSTRAP_CSR_OFFSET,
+			      &hw_data->straps);
 
 	/* Get Accelerators and Accelerators Engines masks */
-	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 	/* If the device has no acceleration engines then ignore it. */
 	if (!hw_data->accel_mask || !hw_data->ae_mask ||
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 29fd3f1091ab..a2543f75e81f 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -11,12 +11,12 @@ static struct adf_hw_device_class c62xiov_class = {
 	.instances = 0
 };
 
-static u32 get_accel_mask(u32 fuse)
+static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
 	return ADF_C62XIOV_ACCELERATORS_MASK;
 }
 
-static u32 get_ae_mask(u32 fuse)
+static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
 	return ADF_C62XIOV_ACCELENGINES_MASK;
 }
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index b9810f79eb84..04742a6d91ca 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -119,8 +119,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_c62xiov(accel_dev->hw_device);
 
 	/* Get Accelerators and Accelerators Engines masks */
-	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 06952ece53d9..411a505e1f59 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -104,8 +104,8 @@ struct adf_etr_ring_data;
 
 struct adf_hw_device_data {
 	struct adf_hw_device_class *dev_class;
-	u32 (*get_accel_mask)(u32 fuse);
-	u32 (*get_ae_mask)(u32 fuse);
+	u32 (*get_accel_mask)(struct adf_hw_device_data *self);
+	u32 (*get_ae_mask)(struct adf_hw_device_data *self);
 	u32 (*get_sram_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_misc_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_etr_bar_id)(struct adf_hw_device_data *self);
@@ -131,6 +131,7 @@ struct adf_hw_device_data {
 	const char *fw_name;
 	const char *fw_mmp_name;
 	u32 fuses;
+	u32 straps;
 	u32 accel_capabilities_mask;
 	u32 instance_id;
 	u16 accel_mask;
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 6b9d47682d04..bc07199459e7 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -346,11 +346,12 @@ static void qat_hal_put_wakeup_event(struct icp_qat_fw_loader_handle *handle,
 
 static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned int base_cnt, cur_cnt;
 	unsigned char ae;
 	int times = MAX_RETRY_TIMES;
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		base_cnt = qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT);
 		base_cnt &= 0xffff;
 
@@ -384,6 +385,7 @@ int qat_hal_check_ae_active(struct icp_qat_fw_loader_handle *handle,
 
 static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned int misc_ctl;
 	unsigned char ae;
 
@@ -393,7 +395,7 @@ static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 		SET_GLB_CSR(handle, MISC_CONTROL, misc_ctl &
 			    (~MC_TIMESTAMP_ENABLE));
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		qat_hal_wr_ae_csr(handle, ae, TIMESTAMP_LOW, 0);
 		qat_hal_wr_ae_csr(handle, ae, TIMESTAMP_HIGH, 0);
 	}
@@ -438,6 +440,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 #define SHRAM_INIT_CYCLES 2060
 int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned int ae_reset_csr;
 	unsigned char ae;
 	unsigned int clk_csr;
@@ -464,7 +467,7 @@ int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
 		goto out_err;
 
 	/* Set undefined power-up/reset states to reasonable default values */
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES,
 				  INIT_CTX_ENABLE_VALUE);
 		qat_hal_wr_indr_csr(handle, ae, ICP_QAT_UCLO_AE_ALL_CTX,
@@ -570,10 +573,11 @@ static void qat_hal_enable_ctx(struct icp_qat_fw_loader_handle *handle,
 
 static void qat_hal_clear_xfer(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned char ae;
 	unsigned short reg;
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		for (reg = 0; reg < ICP_QAT_UCLO_MAX_GPR_REG; reg++) {
 			qat_hal_init_rd_xfer(handle, ae, 0, ICP_SR_RD_ABS,
 					     reg, 0);
@@ -585,6 +589,7 @@ static void qat_hal_clear_xfer(struct icp_qat_fw_loader_handle *handle)
 
 static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned char ae;
 	unsigned int ctx_mask = ICP_QAT_UCLO_AE_ALL_CTX;
 	int times = MAX_RETRY_TIMES;
@@ -592,7 +597,7 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 	unsigned int savctx = 0;
 	int ret = 0;
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		csr_val = qat_hal_rd_ae_csr(handle, ae, AE_MISC_CONTROL);
 		csr_val &= ~(1 << MMC_SHARE_CS_BITPOS);
 		qat_hal_wr_ae_csr(handle, ae, AE_MISC_CONTROL, csr_val);
@@ -613,7 +618,7 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wr_ae_csr(handle, ae, CTX_SIG_EVENTS_ACTIVE, 0);
 		qat_hal_enable_ctx(handle, ae, ctx_mask);
 	}
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		/* wait for AE to finish */
 		do {
 			ret = qat_hal_wait_cycles(handle, ae, 20, 1);
@@ -654,6 +659,8 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *misc_bar =
 			&pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)];
+	unsigned long ae_mask = hw_data->ae_mask;
+	unsigned int csr_val = 0;
 	struct adf_bar *sram_bar;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
@@ -689,9 +696,7 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	/* create AE objects */
 	handle->hal_handle->upc_mask = 0x1ffff;
 	handle->hal_handle->max_ustore = 0x4000;
-	for (ae = 0; ae < ICP_QAT_UCLO_MAX_AE; ae++) {
-		if (!(hw_data->ae_mask & (1 << ae)))
-			continue;
+	for_each_set_bit(ae, &ae_mask, ICP_QAT_UCLO_MAX_AE) {
 		handle->hal_handle->aes[ae].free_addr = 0;
 		handle->hal_handle->aes[ae].free_size =
 		    handle->hal_handle->max_ustore;
@@ -714,9 +719,7 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	}
 
 	/* Set SIGNATURE_ENABLE[0] to 0x1 in order to enable ALU_OUT csr */
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
-		unsigned int csr_val = 0;
-
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		csr_val = qat_hal_rd_ae_csr(handle, ae, SIGNATURE_ENABLE);
 		csr_val |= 0x1;
 		qat_hal_wr_ae_csr(handle, ae, SIGNATURE_ENABLE, csr_val);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index b975c263446d..6a0d01103136 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -24,15 +24,19 @@ static struct adf_hw_device_class dh895xcc_class = {
 	.instances = 0
 };
 
-static u32 get_accel_mask(u32 fuse)
+static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
-	return (~fuse) >> ADF_DH895XCC_ACCELERATORS_REG_OFFSET &
-			  ADF_DH895XCC_ACCELERATORS_MASK;
+	u32 fuses = self->fuses;
+
+	return ~fuses >> ADF_DH895XCC_ACCELERATORS_REG_OFFSET &
+			 ADF_DH895XCC_ACCELERATORS_MASK;
 }
 
-static u32 get_ae_mask(u32 fuse)
+static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	return (~fuse) & ADF_DH895XCC_ACCELENGINES_MASK;
+	u32 fuses = self->fuses;
+
+	return ~fuses & ADF_DH895XCC_ACCELENGINES_MASK;
 }
 
 static u32 get_num_accels(struct adf_hw_device_data *self)
@@ -131,11 +135,13 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
 	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR];
+	unsigned long accel_mask = hw_device->accel_mask;
+	unsigned long ae_mask = hw_device->ae_mask;
 	void __iomem *csr = misc_bar->virt_addr;
 	unsigned int val, i;
 
 	/* Enable Accel Engine error detection & correction */
-	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
+	for_each_set_bit(i, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
 		val = ADF_CSR_RD(csr, ADF_DH895XCC_AE_CTX_ENABLES(i));
 		val |= ADF_DH895XCC_ENABLE_AE_ECC_ERR;
 		ADF_CSR_WR(csr, ADF_DH895XCC_AE_CTX_ENABLES(i), val);
@@ -145,7 +151,7 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 	}
 
 	/* Enable shared memory error detection & correction */
-	for (i = 0; i < hw_device->get_num_accels(hw_device); i++) {
+	for_each_set_bit(i, &accel_mask, ADF_DH895XCC_MAX_ACCELERATORS) {
 		val = ADF_CSR_RD(csr, ADF_DH895XCC_UERRSSMSH(i));
 		val |= ADF_DH895XCC_ERRSSMSH_EN;
 		ADF_CSR_WR(csr, ADF_DH895XCC_UERRSSMSH(i), val);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index ecb4f6f20e22..d7941bc2bafd 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -128,8 +128,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			      &hw_data->fuses);
 
 	/* Get Accelerators and Accelerators Engines masks */
-	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 	/* If the device has no acceleration engines then ignore it. */
 	if (!hw_data->accel_mask || !hw_data->ae_mask ||
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 5246f0524ca3..737f9132f71a 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -11,12 +11,12 @@ static struct adf_hw_device_class dh895xcciov_class = {
 	.instances = 0
 };
 
-static u32 get_accel_mask(u32 fuse)
+static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCCIOV_ACCELERATORS_MASK;
 }
 
-static u32 get_ae_mask(u32 fuse)
+static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCCIOV_ACCELENGINES_MASK;
 }
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 404cf9df6922..c972554a755e 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -119,8 +119,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_init_hw_data_dh895xcciov(accel_dev->hw_device);
 
 	/* Get Accelerators and Accelerators Engines masks */
-	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
-	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-- 
2.26.2

