From: Conor McLoughlin <conor.mcloughlin@intel.com>
Subject: [PATCH] Use alternative reset methods depending on the specific device.
Date: Mon,  4 Jul 2016 16:26:00 +0100
Message-ID: <1467645960-15246-1-git-send-email-conor.mcloughlin@intel.com>
Cc: Conor McLoughlin <conor.mcloughlin@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:54103 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbcGDP0R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 11:26:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Different product families will use FLR or SBR.
Virtual Function devices have no reset method.

Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 +
 drivers/crypto/qat/qat_common/adf_aer.c            |   46 ++++++++++++++++----
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    1 +
 6 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index c5bd5a9..6bc68bc 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -229,6 +229,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->reset_device = adf_reset_flr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
 }
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 879e04c..618cec3 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -239,6 +239,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->reset_device = adf_reset_flr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 5a07208..e882253 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -176,6 +176,7 @@ struct adf_hw_device_data {
 	void (*disable_iov)(struct adf_accel_dev *accel_dev);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
+	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
 	const char *fw_mmp_name;
 	uint32_t fuses;
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 7bfb57f..2839fcc 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -82,18 +82,12 @@ struct adf_reset_dev_data {
 	struct work_struct reset_work;
 };
 
-void adf_dev_restore(struct adf_accel_dev *accel_dev)
+void adf_reset_sbr(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	struct pci_dev *parent = pdev->bus->self;
 	uint16_t bridge_ctl = 0;
 
-	if (accel_dev->is_vf)
-		return;
-
-	dev_info(&GET_DEV(accel_dev), "Resetting device qat_dev%d\n",
-		 accel_dev->accel_id);
-
 	if (!parent)
 		parent = pdev;
 
@@ -101,6 +95,8 @@ void adf_dev_restore(struct adf_accel_dev *accel_dev)
 		dev_info(&GET_DEV(accel_dev),
 			 "Transaction still in progress. Proceeding\n");
 
+	dev_info(&GET_DEV(accel_dev), "Secondary bus reset\n");
+
 	pci_read_config_word(parent, PCI_BRIDGE_CONTROL, &bridge_ctl);
 	bridge_ctl |= PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(parent, PCI_BRIDGE_CONTROL, bridge_ctl);
@@ -108,8 +104,40 @@ void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	bridge_ctl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(parent, PCI_BRIDGE_CONTROL, bridge_ctl);
 	msleep(100);
-	pci_restore_state(pdev);
-	pci_save_state(pdev);
+}
+EXPORT_SYMBOL_GPL(adf_reset_sbr);
+
+void adf_reset_flr(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	u16 control = 0;
+	int pos = 0;
+
+	dev_info(&GET_DEV(accel_dev), "Function level reset\n");
+	pos = pci_pcie_cap(pdev);
+	if (!pos) {
+		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
+		return;
+	}
+	pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &control);
+	control |= PCI_EXP_DEVCTL_BCR_FLR;
+	pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, control);
+	msleep(100);
+}
+EXPORT_SYMBOL_GPL(adf_reset_flr);
+
+void adf_dev_restore(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	if (hw_device->reset_device) {
+		dev_info(&GET_DEV(accel_dev), "Resetting device qat_dev%d\n",
+			 accel_dev->accel_id);
+		hw_device->reset_device(accel_dev);
+		pci_restore_state(pdev);
+		pci_save_state(pdev);
+	}
 }
 
 static void adf_device_reset_worker(struct work_struct *work)
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 75faa39..980e074 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -141,6 +141,8 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev);
 
 int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf);
 void adf_disable_aer(struct adf_accel_dev *accel_dev);
+void adf_reset_sbr(struct adf_accel_dev *accel_dev);
+void adf_reset_flr(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 6e1d5e1..1dfcab3 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -252,6 +252,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->reset_device = adf_reset_sbr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
 }
 
-- 
1.7.4.1
