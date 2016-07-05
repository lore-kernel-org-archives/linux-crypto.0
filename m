From: Conor McLoughlin <conor.mcloughlin@intel.com>
Subject: [PATCH] Enable slice hang handling for C3X and C6X devices.
Date: Tue,  5 Jul 2016 10:07:07 +0100
Message-ID: <1467709627-26551-1-git-send-email-conor.mcloughlin@intel.com>
Cc: Conor McLoughlin <conor.mcloughlin@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbcGEJHi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 05:07:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the QAT device fails to respond to a command, a watchdog
timer triggers an interrupt. This event is reported and the
the interrupt cleared. A separate watchdog register is used
for sym and asym crypto.

Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    8 ++
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |    2 +
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |   16 +++
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h     |    2 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   33 ++++++
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    1 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +
 drivers/crypto/qat/qat_common/adf_init.c           |   41 +++++++-
 drivers/crypto/qat/qat_common/adf_isr.c            |  115 +++++++++++++++++++-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    6 +
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +
 11 files changed, 220 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 6bc68bc..32e1c6c 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -149,6 +149,11 @@ static u32 get_vintmsk_offset(u32 i)
 	return ADF_C3XXX_VINTMSK_OFFSET(i);
 }
 
+static u32 get_clock_speed(struct adf_hw_device_data *self)
+{
+	return ADF_C3X_CLK_PER_SEC;
+}
+
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
@@ -217,6 +222,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
+	hw_data->get_clock_speed = get_clock_speed;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_C3XXX_FW;
 	hw_data->fw_mmp_name = ADF_C3XXX_MMP;
@@ -228,6 +234,8 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
+	hw_data->set_ssm_wdtimer = adf_set_ssm_wdtimer;
+	hw_data->check_slice_hang = adf_check_slice_hang;
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index 2f2681d..36fcfa0 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -71,6 +71,8 @@
 #define ADF_C3XXX_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_C3XXX_ERRSSMSH_EN BIT(3)
 
+#define ADF_C3X_CLK_PER_SEC	(343 * 1000000)
+
 #define ADF_C3XXX_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_C3XXX_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 618cec3..19081a1 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -159,6 +159,11 @@ static u32 get_vintmsk_offset(u32 i)
 	return ADF_C62X_VINTMSK_OFFSET(i);
 }
 
+static u32 get_clock_speed(struct adf_hw_device_data *self)
+{
+	return ADF_C6X_CLK_PER_SEC;
+}
+
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
@@ -190,6 +195,8 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *addr;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	u32 i;
 
 	addr = (&GET_BARS(accel_dev)[ADF_C62X_PMISC_BAR])->virt_addr;
 
@@ -198,6 +205,12 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_C62X_SMIA0_MASK);
 	ADF_CSR_WR(addr, ADF_C62X_SMIAPF1_MASK_OFFSET,
 		   ADF_C62X_SMIA1_MASK);
+
+	/* Enable slice hang interrupt */
+	for (i = 0; i < hw_device->get_num_accels(hw_device); i++) {
+		ADF_CSR_WR(addr, ADF_SHINTMASKSSM(i),
+			   ADF_ENABLE_SLICE_HANG);
+	}
 }
 
 static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
@@ -227,6 +240,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
+	hw_data->get_clock_speed = get_clock_speed;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_C62X_FW;
 	hw_data->fw_mmp_name = ADF_C62X_MMP;
@@ -238,6 +252,8 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
+	hw_data->set_ssm_wdtimer = adf_set_ssm_wdtimer;
+	hw_data->check_slice_hang = adf_check_slice_hang;
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
index 17a8a32..3cf5dfb 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
@@ -72,6 +72,8 @@
 #define ADF_C62X_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_C62X_ERRSSMSH_EN BIT(3)
 
+#define ADF_C6X_CLK_PER_SEC	(343 * 1000000)
+
 #define ADF_C62X_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_C62X_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index e882253..971251a 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -67,6 +67,36 @@
 #define ADF_C3XXXIOV_PCI_DEVICE_ID 0x19e3
 #define ADF_ERRSOU3 (0x3A000 + 0x0C)
 #define ADF_ERRSOU5 (0x3A000 + 0xD8)
+
+#define ADF_EMSK3_CPM0_MASK BIT(2)
+#define ADF_EMSK3_CPM1_MASK BIT(3)
+#define ADF_EMSK5_CPM2_MASK BIT(16)
+#define ADF_EMSK5_CPM3_MASK BIT(17)
+#define ADF_EMSK5_CPM4_MASK BIT(18)
+
+#define ADF_INTSTATSSM(i)	((i) * 0x4000 + 0x04)
+#define ADF_INTSTATSSM_SHANGERR BIT(13)
+#define ADF_UERRSSMSH(i)	((i) * 0x4000 + 0x18)
+#define ADF_UERRSSMSHAD(i)	((i) * 0x4000 + 0x1C)
+#define ADF_SLICEHANGSTATUS(i)  ((i) * 0x4000 + 0x4C)
+#define ADF_SLICE_HANG_AUTH0_MASK BIT(0)
+#define ADF_SLICE_HANG_AUTH1_MASK BIT(1)
+#define ADF_SLICE_HANG_CPHR0_MASK BIT(4)
+#define ADF_SLICE_HANG_CPHR1_MASK BIT(5)
+#define ADF_SLICE_HANG_CMP0_MASK  BIT(8)
+#define ADF_SLICE_HANG_CMP1_MASK  BIT(9)
+#define ADF_SLICE_HANG_XLT0_MASK  BIT(12)
+#define ADF_SLICE_HANG_XLT1_MASK  BIT(13)
+#define ADF_SLICE_HANG_MMP0_MASK  BIT(16)
+#define ADF_SLICE_HANG_MMP1_MASK  BIT(17)
+#define ADF_SLICE_HANG_MMP2_MASK  BIT(18)
+#define ADF_SLICE_HANG_MMP3_MASK  BIT(19)
+#define ADF_SLICE_HANG_MMP4_MASK  BIT(20)
+#define ADF_SSMWDT(i)            ((i) * 0x4000 + 0x54)
+#define ADF_SSMWDTPKE(i)         ((i) * 0x4000 + 0x58)
+#define ADF_SHINTMASKSSM(i)      ((i) * 0x4000 + 0x1018)
+#define ADF_ENABLE_SLICE_HANG  0x000000
+
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_PCI_MAX_BARS 3
@@ -162,6 +192,7 @@ struct adf_hw_device_data {
 	uint32_t (*get_num_accels)(struct adf_hw_device_data *self);
 	uint32_t (*get_pf2vf_offset)(uint32_t i);
 	uint32_t (*get_vintmsk_offset)(uint32_t i);
+	uint32_t (*get_clock_speed)(struct adf_hw_device_data *self);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
@@ -175,6 +206,8 @@ struct adf_hw_device_data {
 				const uint32_t **cfg);
 	void (*disable_iov)(struct adf_accel_dev *accel_dev);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
+	bool (*check_slice_hang)(struct adf_accel_dev *accel_dev);
+	int (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
 	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
index 8c4f657..1454857 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -61,6 +61,7 @@
 #define ADF_CFG_AFFINITY_WHATEVER 0xFF
 #define MAX_DEVICE_NAME_SIZE 32
 #define ADF_MAX_DEVICES (32 * 32)
+#define ADF_SSM_WDT_DEFAULT_VALUE 100
 
 enum adf_cfg_val_type {
 	ADF_DEC,
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 980e074..9585239 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -152,6 +152,8 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
+int adf_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
+bool adf_check_slice_hang(struct adf_accel_dev *accel_dev);
 
 int adf_dev_get(struct adf_accel_dev *accel_dev);
 void adf_dev_put(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 888c667..e837325 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -88,6 +88,33 @@ int adf_service_unregister(struct service_hndl *service)
 }
 
 /**
+ * adf_set_ssm_wdtimer() - Initialize the slice hang watchdog timer.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_set_ssm_wdtimer(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 timer_val = ADF_SSM_WDT_DEFAULT_VALUE;
+	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[hw_data->
+						get_misc_bar_id(hw_data)];
+	void __iomem *csr = misc_bar->virt_addr;
+	u32 clk_per_sec = hw_data->get_clock_speed(hw_data);
+	u32 i;
+
+	/* Convert msec to CPP clocks */
+	timer_val = timer_val * (clk_per_sec / 1000);
+
+	for (i = 0; i < hw_data->get_num_accels(hw_data); i++) {
+		ADF_CSR_WR(csr, ADF_SSMWDT(i), timer_val);
+		ADF_CSR_WR(csr, ADF_SSMWDTPKE(i), timer_val);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_set_ssm_wdtimer);
+
+/**
  * adf_dev_init() - Init data structures and services for the given accel device
  * @accel_dev: Pointer to acceleration device.
  *
@@ -128,8 +155,6 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
-	hw_data->enable_ints(accel_dev);
-
 	if (adf_ae_init(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to initialise Acceleration Engine\n");
@@ -150,6 +175,8 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 	set_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
 
+	hw_data->enable_ints(accel_dev);
+
 	/*
 	 * Subservice initialisation is divided into two stages: init and start.
 	 * This is to facilitate any ordering dependencies between services
@@ -169,6 +196,16 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	hw_data->enable_error_correction(accel_dev);
 	hw_data->enable_vf2pf_comms(accel_dev);
 
+	/*
+	 * Set ssm watch dog timer for slice hang detection
+	 * Note! Not supported on devices older than C62x
+	 */
+	if (hw_data->set_ssm_wdtimer && hw_data->set_ssm_wdtimer(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev),
+			"QAT: Failed to set ssm watch dog timer\n");
+		return -EFAULT;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_dev_init);
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 06d4901..b06e39e 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -100,17 +100,111 @@ static irqreturn_t adf_msix_isr_bundle(int irq, void *bank_ptr)
 	return IRQ_HANDLED;
 }
 
+static void adf_log_slice_hang(struct adf_accel_dev *accel_dev,
+			       u8 accel_num, char *unit_name, u8 unit_number)
+{
+	dev_err(&GET_DEV(accel_dev),
+		"CPM #%x Slice Hang Detected unit: %s%d.\n",
+		accel_num, unit_name, unit_number);
+}
+
+static bool adf_handle_slice_hang(struct adf_accel_dev *accel_dev,
+				  u8 accel_num, void __iomem *csr)
+{
+	u32 slice_hang = ADF_CSR_RD(csr, ADF_SLICEHANGSTATUS(accel_num));
+
+	if (!slice_hang)
+		return false;
+
+	if (slice_hang & ADF_SLICE_HANG_AUTH0_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Auth", 0);
+	if (slice_hang & ADF_SLICE_HANG_AUTH1_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Auth", 1);
+	if (slice_hang & ADF_SLICE_HANG_CPHR0_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Cipher", 0);
+	if (slice_hang & ADF_SLICE_HANG_CPHR1_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Cipher", 1);
+	if (slice_hang & ADF_SLICE_HANG_CMP0_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Comp", 0);
+	if (slice_hang & ADF_SLICE_HANG_CMP1_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Comp", 1);
+	if (slice_hang & ADF_SLICE_HANG_XLT0_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Xlator", 0);
+	if (slice_hang & ADF_SLICE_HANG_XLT1_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "Xlator", 1);
+	if (slice_hang & ADF_SLICE_HANG_MMP0_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "MMP", 0);
+	if (slice_hang & ADF_SLICE_HANG_MMP1_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "MMP", 1);
+	if (slice_hang & ADF_SLICE_HANG_MMP2_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "MMP", 2);
+	if (slice_hang & ADF_SLICE_HANG_MMP3_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "MMP", 3);
+	if (slice_hang & ADF_SLICE_HANG_MMP4_MASK)
+		adf_log_slice_hang(accel_dev, accel_num, "MMP", 4);
+
+	/* Clear the associated interrupt - write 1 to clear */
+	ADF_CSR_WR(csr, ADF_SLICEHANGSTATUS(accel_num), slice_hang);
+
+	return true;
+}
+
+/**
+ * adf_check_slice_hang() - Check slice hang status
+ *
+ * Return: true if a slice hange interrupt is serviced..
+ */
+bool adf_check_slice_hang(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *misc_bar =
+		&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *csr = misc_bar->virt_addr;
+	u32 errsou3 = ADF_CSR_RD(csr, ADF_ERRSOU3);
+	u32 errsou5 = ADF_CSR_RD(csr, ADF_ERRSOU5);
+	u32 accel_num;
+	bool handled = false;
+	u32 num_accels = hw_data->get_num_accels(hw_data);
+	u32 errsou[] = {errsou3, errsou3, errsou5, errsou5, errsou5};
+	u32 mask[] = {ADF_EMSK3_CPM0_MASK,
+		      ADF_EMSK3_CPM1_MASK,
+		      ADF_EMSK5_CPM2_MASK,
+		      ADF_EMSK5_CPM3_MASK,
+		      ADF_EMSK5_CPM4_MASK};
+
+	for (accel_num = 0; accel_num < num_accels; accel_num++) {
+		if (accel_num >= ARRAY_SIZE(errsou)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Invalid num_accels %d.\n", num_accels);
+			break;
+		}
+
+		if (errsou[accel_num] & mask[accel_num]) {
+			if (ADF_CSR_RD(csr, ADF_INTSTATSSM(accel_num)) &
+				       ADF_INTSTATSSM_SHANGERR)
+				handled |= adf_handle_slice_hang(accel_dev,
+								 accel_num,
+								 csr);
+		}
+	}
+
+	return handled;
+}
+EXPORT_SYMBOL_GPL(adf_check_slice_hang);
+
 static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 {
 	struct adf_accel_dev *accel_dev = dev_ptr;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+		&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	u32 errsou3;
+	u32 errsou5;
 
 #ifdef CONFIG_PCI_IOV
 	/* If SR-IOV is enabled (vf_info is non-NULL), check for VF->PF ints */
 	if (accel_dev->pf.vf_info) {
-		struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-		struct adf_bar *pmisc =
-			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
-		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
 		u32 vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
@@ -154,8 +248,17 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 	}
 #endif /* CONFIG_PCI_IOV */
 
-	dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
-		accel_dev->accel_id);
+	if (hw_data->check_slice_hang &&
+			hw_data->check_slice_hang(accel_dev))
+		return IRQ_HANDLED;
+
+	errsou3 = ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU3);
+	errsou5 = ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5);
+	if (errsou3 | errsou5)
+		adf_print_err_registers(pmisc_bar_addr, accel_dev, hw_data);
+	else
+		dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
+			accel_dev->accel_id);
 
 	return IRQ_NONE;
 }
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 1dfcab3..a18b7ad 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -171,6 +171,11 @@ static uint32_t get_vintmsk_offset(uint32_t i)
 	return ADF_DH895XCC_VINTMSK_OFFSET(i);
 }
 
+static u32 get_clock_speed(struct adf_hw_device_data *self)
+{
+	return ADF_DH895X_CLK_PER_SEC;
+}
+
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
@@ -239,6 +244,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
+	hw_data->get_clock_speed = get_clock_speed;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_DH895XCC_FW;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 092f735..58af612 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -78,6 +78,8 @@
 #define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
+#define ADF_DH895X_CLK_PER_SEC (467 * 1000000)
+
 #define ADF_DH895XCC_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 /* FW names */
-- 
1.7.4.1
