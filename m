From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/5] crypto: qat - Add support for SRIOV
Date: Fri, 07 Aug 2015 11:34:25 -0700
Message-ID: <20150807183425.630.32268.stgit@tstruk-mobl1>
References: <20150807183414.630.25889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bhelgaas@google.com,
	linux-pci@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35859 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946070AbbHGSfu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 14:35:50 -0400
In-Reply-To: <20150807183414.630.25889.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add code that enables SRIOV on dh895xcc devices.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile             |    1 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   37 ++
 drivers/crypto/qat/qat_common/adf_aer.c            |    3 
 drivers/crypto/qat/qat_common/adf_cfg.c            |    3 
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    3 
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   37 ++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    6 
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |  283 +++++++++++++-
 drivers/crypto/qat/qat_common/adf_init.c           |   10 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  336 +++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h      |  144 +++++++
 drivers/crypto/qat/qat_common/adf_sriov.c          |  406 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |    4 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   24 +
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    4 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   80 ++--
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |  139 +++++--
 17 files changed, 1426 insertions(+), 94 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_sriov.c

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index e5fe4e7..df20a9d 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -19,3 +19,4 @@ intel_qat-objs := adf_cfg.o \
 	qat_hal.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
+intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index a7d3d11..ca853d5 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -46,13 +46,17 @@
 */
 #ifndef ADF_ACCEL_DEVICES_H_
 #define ADF_ACCEL_DEVICES_H_
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/ratelimit.h>
 #include "adf_cfg_common.h"
 
 #define ADF_DH895XCC_DEVICE_NAME "dh895xcc"
+#define ADF_DH895XCCVF_DEVICE_NAME "dh895xccvf"
 #define ADF_DH895XCC_PCI_DEVICE_ID 0x435
+#define ADF_DH895XCCIOV_PCI_DEVICE_ID 0x443
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16
@@ -79,6 +83,7 @@ struct adf_bar {
 struct adf_accel_msix {
 	struct msix_entry *entries;
 	char **names;
+	u32 num_entries;
 } __packed;
 
 struct adf_accel_pci {
@@ -99,6 +104,7 @@ enum dev_sku_info {
 	DEV_SKU_2,
 	DEV_SKU_3,
 	DEV_SKU_4,
+	DEV_SKU_VF,
 	DEV_SKU_UNKNOWN,
 };
 
@@ -113,6 +119,8 @@ static inline const char *get_sku_info(enum dev_sku_info info)
 		return "SKU3";
 	case DEV_SKU_4:
 		return "SKU4";
+	case DEV_SKU_VF:
+		return "SKUVF";
 	case DEV_SKU_UNKNOWN:
 	default:
 		break;
@@ -140,6 +148,8 @@ struct adf_hw_device_data {
 	uint32_t (*get_etr_bar_id)(struct adf_hw_device_data *self);
 	uint32_t (*get_num_aes)(struct adf_hw_device_data *self);
 	uint32_t (*get_num_accels)(struct adf_hw_device_data *self);
+	uint32_t (*get_pf2vf_offset)(uint32_t i);
+	uint32_t (*get_vintmsk_offset)(uint32_t i);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
@@ -151,7 +161,9 @@ struct adf_hw_device_data {
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
 	void (*get_arb_mapping)(struct adf_accel_dev *accel_dev,
 				const uint32_t **cfg);
+	void (*disable_iov)(struct adf_accel_dev *accel_dev);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
+	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
 	const char *fw_mmp_name;
 	uint32_t fuses;
@@ -165,6 +177,7 @@ struct adf_hw_device_data {
 	uint8_t num_accel;
 	uint8_t num_logical_accel;
 	uint8_t num_engines;
+	uint8_t min_iov_compat_ver;
 } __packed;
 
 /* CSR write macro */
@@ -189,6 +202,15 @@ struct adf_fw_loader_data {
 	const struct firmware *mmp_fw;
 };
 
+struct adf_accel_vf_info {
+	struct adf_accel_dev *accel_dev;
+	struct tasklet_struct vf2pf_bh_tasklet;
+	struct mutex pf2vf_lock; /* protect CSR access for PF2VF messages */
+	struct ratelimit_state vf2pf_ratelimit;
+	u32 vf_nr;
+	bool init;
+};
+
 struct adf_accel_dev {
 	struct adf_etr_data *transport;
 	struct adf_hw_device_data *hw_device;
@@ -202,6 +224,21 @@ struct adf_accel_dev {
 	struct list_head list;
 	struct module *owner;
 	struct adf_accel_pci accel_pci_dev;
+	union {
+		struct {
+			/* vf_info is non-zero when SR-IOV is init'ed */
+			struct adf_accel_vf_info *vf_info;
+		} pf;
+		struct {
+			char *irq_name;
+			struct tasklet_struct pf2vf_bh_tasklet;
+			struct mutex vf2pf_lock; /* protect CSR access */
+			struct completion iov_msg_completion;
+			uint8_t compatible;
+			uint8_t pf_version;
+		} vf;
+	};
+	bool is_vf;
 	uint8_t accel_id;
 } __packed;
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 8f34a5f..a57b419 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -91,6 +91,9 @@ static void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	dev_info(&GET_DEV(accel_dev), "Resetting device qat_dev%d\n",
 		 accel_dev->accel_id);
 
+	if (!parent)
+		parent = pdev;
+
 	if (!pci_wait_for_pending_transaction(pdev))
 		dev_info(&GET_DEV(accel_dev),
 			 "Transaction still in progress. Proceeding\n");
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index 76eccb8..d087979 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -178,6 +178,9 @@ void adf_cfg_dev_remove(struct adf_accel_dev *accel_dev)
 {
 	struct adf_cfg_device_data *dev_cfg_data = accel_dev->cfg;
 
+	if (!dev_cfg_data)
+		return;
+
 	down_write(&dev_cfg_data->lock);
 	adf_cfg_section_del_all(&dev_cfg_data->sec_list);
 	up_write(&dev_cfg_data->lock);
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
index 88b8218..c697fb1 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -60,7 +60,7 @@
 #define ADF_CFG_NO_DEVICE 0xFF
 #define ADF_CFG_AFFINITY_WHATEVER 0xFF
 #define MAX_DEVICE_NAME_SIZE 32
-#define ADF_MAX_DEVICES 32
+#define ADF_MAX_DEVICES (32 * 32)
 
 enum adf_cfg_val_type {
 	ADF_DEC,
@@ -71,6 +71,7 @@ enum adf_cfg_val_type {
 enum adf_device_type {
 	DEV_UNKNOWN = 0,
 	DEV_DH895XCC,
+	DEV_DH895XCCVF,
 };
 
 struct adf_dev_status_info {
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 7935a38..0f5f5e8 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -54,8 +54,8 @@
 #include "icp_qat_hal.h"
 
 #define ADF_MAJOR_VERSION	0
-#define ADF_MINOR_VERSION	1
-#define ADF_BUILD_VERSION	4
+#define ADF_MINOR_VERSION	2
+#define ADF_BUILD_VERSION	0
 #define ADF_DRV_VERSION		__stringify(ADF_MAJOR_VERSION) "." \
 				__stringify(ADF_MINOR_VERSION) "." \
 				__stringify(ADF_BUILD_VERSION)
@@ -95,7 +95,7 @@ struct service_hndl {
 
 static inline int get_current_node(void)
 {
-	return cpu_data(current_thread_info()->cpu).phys_proc_id;
+	return topology_physical_package_id(smp_processor_id());
 }
 
 int adf_service_register(struct service_hndl *service);
@@ -106,13 +106,23 @@ int adf_dev_start(struct adf_accel_dev *accel_dev);
 int adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
+void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
+void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
+int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
+void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
+int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
+void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
+void adf_clean_vf_map(bool);
+
 int adf_ctl_dev_register(void);
 void adf_ctl_dev_unregister(void);
 int adf_processes_dev_register(void);
 void adf_processes_dev_unregister(void);
 
-int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev);
-void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev);
+int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
+		       struct adf_accel_dev *pf);
+void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
+		       struct adf_accel_dev *pf);
 struct list_head *adf_devmgr_get_head(void);
 struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id);
 struct adf_accel_dev *adf_devmgr_get_first(void);
@@ -211,4 +221,21 @@ int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 			 void *addr_ptr, int mem_size);
 void qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 			void *addr_ptr, int mem_size);
+#if defined(CONFIG_PCI_IOV)
+int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
+void adf_disable_sriov(struct adf_accel_dev *accel_dev);
+void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
+				  uint32_t vf_mask);
+void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
+				 uint32_t vf_mask);
+#else
+static inline int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
+{
+	return 0;
+}
+
+static inline void adf_disable_sriov(struct adf_accel_dev *accel_dev)
+{
+}
+#endif
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index e056b9e..cd8a12a 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -398,10 +398,9 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
 	}
 
 	accel_dev = adf_devmgr_get_dev_by_id(dev_info.accel_id);
-	if (!accel_dev) {
-		pr_err("QAT: Device %d not found\n", dev_info.accel_id);
+	if (!accel_dev)
 		return -ENODEV;
-	}
+
 	hw_data = accel_dev->hw_device;
 	dev_info.state = adf_dev_started(accel_dev) ? DEV_UP : DEV_DOWN;
 	dev_info.num_ae = hw_data->get_num_aes(hw_data);
@@ -495,6 +494,7 @@ static void __exit adf_unregister_ctl_device_driver(void)
 	adf_exit_aer();
 	qat_crypto_unregister();
 	qat_algs_exit();
+	adf_clean_vf_map(false);
 	mutex_destroy(&adf_ctl_lock);
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index b574a82..8dfdb8f 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -50,21 +50,125 @@
 #include "adf_common_drv.h"
 
 static LIST_HEAD(accel_table);
+static LIST_HEAD(vfs_table);
 static DEFINE_MUTEX(table_lock);
 static uint32_t num_devices;
 
+struct vf_id_map {
+	u32 bdf;
+	u32 id;
+	u32 fake_id;
+	bool attached;
+	struct list_head list;
+};
+
+static int adf_get_vf_id(struct adf_accel_dev *vf)
+{
+	return ((7 * (PCI_SLOT(accel_to_pci_dev(vf)->devfn) - 1)) +
+		PCI_FUNC(accel_to_pci_dev(vf)->devfn) +
+		(PCI_SLOT(accel_to_pci_dev(vf)->devfn) - 1));
+}
+
+static int adf_get_vf_num(struct adf_accel_dev *vf)
+{
+	return (accel_to_pci_dev(vf)->bus->number << 8) | adf_get_vf_id(vf);
+}
+
+static struct vf_id_map *adf_find_vf(u32 bdf)
+{
+	struct list_head *itr;
+
+	list_for_each(itr, &vfs_table) {
+		struct vf_id_map *ptr =
+			list_entry(itr, struct vf_id_map, list);
+
+		if (ptr->bdf == bdf)
+			return ptr;
+	}
+	return NULL;
+}
+
+static int adf_get_vf_real_id(u32 fake)
+{
+	struct list_head *itr;
+
+	list_for_each(itr, &vfs_table) {
+		struct vf_id_map *ptr =
+			list_entry(itr, struct vf_id_map, list);
+		if (ptr->fake_id == fake)
+			return ptr->id;
+	}
+	return -1;
+}
+
+/**
+ * adf_clean_vf_map() - Cleans VF id mapings
+ *
+ * Function cleans internal ids for virtual functions.
+ * @vf: flag indicating whether mappings is cleaned
+ *	for vfs only or for vfs and pfs
+ */
+void adf_clean_vf_map(bool vf)
+{
+	struct vf_id_map *map;
+	struct list_head *ptr, *tmp;
+
+	mutex_lock(&table_lock);
+	list_for_each_safe(ptr, tmp, &vfs_table) {
+		map = list_entry(ptr, struct vf_id_map, list);
+		if (map->bdf != -1)
+			num_devices--;
+
+		if (vf && map->bdf == -1)
+			continue;
+
+		list_del(ptr);
+		kfree(map);
+	}
+	mutex_unlock(&table_lock);
+}
+EXPORT_SYMBOL_GPL(adf_clean_vf_map);
+
+/**
+ * adf_devmgr_update_class_index() - Update internal index
+ * @hw_data:  Pointer to internal device data.
+ *
+ * Function updates internal dev index for VFs
+ */
+void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data)
+{
+	struct adf_hw_device_class *class = hw_data->dev_class;
+	struct list_head *itr;
+	int i = 0;
+
+	list_for_each(itr, &accel_table) {
+		struct adf_accel_dev *ptr =
+				list_entry(itr, struct adf_accel_dev, list);
+
+		if (ptr->hw_device->dev_class == class)
+			ptr->hw_device->instance_id = i++;
+
+		if (i == class->instances)
+				break;
+	}
+}
+EXPORT_SYMBOL_GPL(adf_devmgr_update_class_index);
+
 /**
  * adf_devmgr_add_dev() - Add accel_dev to the acceleration framework
  * @accel_dev:  Pointer to acceleration device.
+ * @pf:		Corresponding PF if the accel_dev is a VF
  *
  * Function adds acceleration device to the acceleration framework.
  * To be used by QAT device specific drivers.
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev)
+int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
+		       struct adf_accel_dev *pf)
 {
 	struct list_head *itr;
+	int ret = 0;
 
 	if (num_devices == ADF_MAX_DEVICES) {
 		dev_err(&GET_DEV(accel_dev), "Only support up to %d devices\n",
@@ -73,20 +177,77 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev)
 	}
 
 	mutex_lock(&table_lock);
-	list_for_each(itr, &accel_table) {
-		struct adf_accel_dev *ptr =
+	atomic_set(&accel_dev->ref_count, 0);
+
+	/* PF on host or VF on guest */
+	if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
+		struct vf_id_map *map;
+
+		list_for_each(itr, &accel_table) {
+			struct adf_accel_dev *ptr =
 				list_entry(itr, struct adf_accel_dev, list);
 
-		if (ptr == accel_dev) {
-			mutex_unlock(&table_lock);
-			return -EEXIST;
+			if (ptr == accel_dev) {
+				ret = -EEXIST;
+				goto unlock;
+			}
 		}
+
+		list_add_tail(&accel_dev->list, &accel_table);
+		accel_dev->accel_id = num_devices++;
+
+		map = kzalloc(sizeof(*map), GFP_KERNEL);
+		if (!map) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+		map->bdf = ~0;
+		map->id = accel_dev->accel_id;
+		map->fake_id = map->id;
+		map->attached = true;
+		list_add_tail(&map->list, &vfs_table);
+	} else if (accel_dev->is_vf && pf) {
+		/* VF on host */
+		struct adf_accel_vf_info *vf_info;
+		struct vf_id_map *map;
+
+		vf_info = pf->pf.vf_info + adf_get_vf_id(accel_dev);
+
+		map = adf_find_vf(adf_get_vf_num(accel_dev));
+		if (map) {
+			struct vf_id_map *next;
+
+			accel_dev->accel_id = map->id;
+			list_add_tail(&accel_dev->list, &accel_table);
+			map->fake_id++;
+			map->attached = true;
+			next = list_next_entry(map, list);
+			while (next && &next->list != &vfs_table) {
+				next->fake_id++;
+				next = list_next_entry(next, list);
+			}
+
+			ret = 0;
+			goto unlock;
+		}
+
+		map = kzalloc(sizeof(*map), GFP_KERNEL);
+		if (!map) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		accel_dev->accel_id = num_devices++;
+		list_add_tail(&accel_dev->list, &accel_table);
+		map->bdf = adf_get_vf_num(accel_dev);
+		map->id = accel_dev->accel_id;
+		map->fake_id = map->id;
+		map->attached = true;
+		list_add_tail(&map->list, &vfs_table);
 	}
-	atomic_set(&accel_dev->ref_count, 0);
-	list_add_tail(&accel_dev->list, &accel_table);
-	accel_dev->accel_id = num_devices++;
+unlock:
 	mutex_unlock(&table_lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_add_dev);
 
@@ -98,17 +259,37 @@ struct list_head *adf_devmgr_get_head(void)
 /**
  * adf_devmgr_rm_dev() - Remove accel_dev from the acceleration framework.
  * @accel_dev:  Pointer to acceleration device.
+ * @pf:		Corresponding PF if the accel_dev is a VF
  *
  * Function removes acceleration device from the acceleration framework.
  * To be used by QAT device specific drivers.
  *
  * Return: void
  */
-void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev)
+void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
+		       struct adf_accel_dev *pf)
 {
 	mutex_lock(&table_lock);
+	if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
+		num_devices--;
+	} else if (accel_dev->is_vf && pf) {
+		struct vf_id_map *map, *next;
+
+		map = adf_find_vf(adf_get_vf_num(accel_dev));
+		if (!map) {
+			dev_err(&GET_DEV(accel_dev), "Failed to find VF map\n");
+			goto unlock;
+		}
+		map->fake_id--;
+		map->attached = false;
+		next = list_next_entry(map, list);
+		while (next && &next->list != &vfs_table) {
+			next->fake_id--;
+			next = list_next_entry(next, list);
+		}
+	}
+unlock:
 	list_del(&accel_dev->list);
-	num_devices--;
 	mutex_unlock(&table_lock);
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_rm_dev);
@@ -154,17 +335,24 @@ EXPORT_SYMBOL_GPL(adf_devmgr_pci_to_accel_dev);
 struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
 {
 	struct list_head *itr;
+	int real_id;
 
 	mutex_lock(&table_lock);
+	real_id = adf_get_vf_real_id(id);
+	if (real_id < 0)
+		goto unlock;
+
+	id = real_id;
+
 	list_for_each(itr, &accel_table) {
 		struct adf_accel_dev *ptr =
 				list_entry(itr, struct adf_accel_dev, list);
-
 		if (ptr->accel_id == id) {
 			mutex_unlock(&table_lock);
 			return ptr;
 		}
 	}
+unlock:
 	mutex_unlock(&table_lock);
 	return NULL;
 }
@@ -180,16 +368,52 @@ int adf_devmgr_verify_id(uint32_t id)
 	return -ENODEV;
 }
 
+static int adf_get_num_dettached_vfs(void)
+{
+	struct list_head *itr;
+	int vfs = 0;
+
+	mutex_lock(&table_lock);
+	list_for_each(itr, &vfs_table) {
+		struct vf_id_map *ptr =
+			list_entry(itr, struct vf_id_map, list);
+		if (ptr->bdf != ~0 && !ptr->attached)
+			vfs++;
+	}
+	mutex_unlock(&table_lock);
+	return vfs;
+}
+
 void adf_devmgr_get_num_dev(uint32_t *num)
 {
-	*num = num_devices;
+	*num = num_devices - adf_get_num_dettached_vfs();
 }
 
+/**
+ * adf_dev_in_use() - Check whether accel_dev is currently in use
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 1 when device is in use, 0 otherwise.
+ */
 int adf_dev_in_use(struct adf_accel_dev *accel_dev)
 {
 	return atomic_read(&accel_dev->ref_count) != 0;
 }
+EXPORT_SYMBOL_GPL(adf_dev_in_use);
 
+/**
+ * adf_dev_get() - Increment accel_dev reference count
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Increment the accel_dev refcount and if this is the first time
+ * incrementing it during this period the accel_dev is in use,
+ * increment the module refcount too.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 when successful, EFAULT when fail to bump module refcount
+ */
 int adf_dev_get(struct adf_accel_dev *accel_dev)
 {
 	if (atomic_add_return(1, &accel_dev->ref_count) == 1)
@@ -197,19 +421,50 @@ int adf_dev_get(struct adf_accel_dev *accel_dev)
 			return -EFAULT;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(adf_dev_get);
 
+/**
+ * adf_dev_put() - Decrement accel_dev reference count
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Decrement the accel_dev refcount and if this is the last time
+ * decrementing it during this period the accel_dev is in use,
+ * decrement the module refcount too.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: void
+ */
 void adf_dev_put(struct adf_accel_dev *accel_dev)
 {
 	if (atomic_sub_return(1, &accel_dev->ref_count) == 0)
 		module_put(accel_dev->owner);
 }
+EXPORT_SYMBOL_GPL(adf_dev_put);
 
+/**
+ * adf_devmgr_in_reset() - Check whether device is in reset
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 1 when the device is being reset, 0 otherwise.
+ */
 int adf_devmgr_in_reset(struct adf_accel_dev *accel_dev)
 {
 	return test_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 }
+EXPORT_SYMBOL_GPL(adf_devmgr_in_reset);
 
+/**
+ * adf_dev_started() - Check whether device has started
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 1 when the device has started, 0 otherwise
+ */
 int adf_dev_started(struct adf_accel_dev *accel_dev)
 {
 	return test_bit(ADF_STATUS_STARTED, &accel_dev->status);
 }
+EXPORT_SYMBOL_GPL(adf_dev_started);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 1aaa5fd..ac37a89 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -187,6 +187,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 
 	hw_data->enable_error_correction(accel_dev);
+	hw_data->enable_vf2pf_comms(accel_dev);
 
 	return 0;
 }
@@ -235,7 +236,8 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (qat_algs_register() || qat_asym_algs_register()) {
+	if (!list_empty(&accel_dev->crypto_list) &&
+	    (qat_algs_register() || qat_asym_algs_register())) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to register crypto algs\n");
 		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
@@ -270,11 +272,12 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (qat_algs_unregister())
+	if (!list_empty(&accel_dev->crypto_list) && qat_algs_unregister())
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to unregister crypto algs\n");
 
-	qat_asym_algs_unregister();
+	if (!list_empty(&accel_dev->crypto_list))
+		qat_asym_algs_unregister();
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
@@ -363,6 +366,7 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 	if (hw_data->exit_admin_comms)
 		hw_data->exit_admin_comms(accel_dev);
 
+	hw_data->disable_iov(accel_dev);
 	adf_cleanup_etr_data(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_dev_shutdown);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
new file mode 100644
index 0000000..c5790cd
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -0,0 +1,336 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2015 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2015 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+
+#include <linux/pci.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_pf2vf_msg.h"
+
+#define ADF_DH895XCC_EP_OFFSET	0x3A000
+#define ADF_DH895XCC_ERRMSK3	(ADF_DH895XCC_EP_OFFSET + 0x1C)
+#define ADF_DH895XCC_ERRMSK3_VF2PF_L_MASK(vf_mask) ((vf_mask & 0xFFFF) << 9)
+#define ADF_DH895XCC_ERRMSK5	(ADF_DH895XCC_EP_OFFSET + 0xDC)
+#define ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask) (vf_mask >> 16)
+
+/**
+ * adf_enable_pf2vf_interrupts() - Enable PF to VF interrupts
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function enables PF to VF interrupts
+ */
+void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_bar_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+
+	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x0);
+}
+EXPORT_SYMBOL_GPL(adf_enable_pf2vf_interrupts);
+
+/**
+ * adf_disable_pf2vf_interrupts() - Disable PF to VF interrupts
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function disables PF to VF interrupts
+ */
+void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_bar_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+
+	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x2);
+}
+EXPORT_SYMBOL_GPL(adf_disable_pf2vf_interrupts);
+
+void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
+				 u32 vf_mask)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	u32 reg;
+
+	/* Enable VF2PF Messaging Ints - VFs 1 through 16 per vf_mask[15:0] */
+	if (vf_mask & 0xFFFF) {
+		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK3);
+		reg &= ~ADF_DH895XCC_ERRMSK3_VF2PF_L_MASK(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK3, reg);
+	}
+
+	/* Enable VF2PF Messaging Ints - VFs 17 through 32 per vf_mask[31:16] */
+	if (vf_mask >> 16) {
+		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK5);
+		reg &= ~ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK5, reg);
+	}
+}
+
+/**
+ * adf_disable_pf2vf_interrupts() - Disable VF to PF interrupts
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function disables VF to PF interrupts
+ */
+void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	u32 reg;
+
+	/* Disable VF2PF interrupts for VFs 1 through 16 per vf_mask[15:0] */
+	if (vf_mask & 0xFFFF) {
+		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK3) |
+			ADF_DH895XCC_ERRMSK3_VF2PF_L_MASK(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK3, reg);
+	}
+
+	/* Disable VF2PF interrupts for VFs 17 through 32 per vf_mask[31:16] */
+	if (vf_mask >> 16) {
+		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK5) |
+			ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK5, reg);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_disable_vf2pf_interrupts);
+
+static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_bar_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+	u32 val, pf2vf_offset, count = 0;
+	u32 local_in_use_mask, local_in_use_pattern;
+	u32 remote_in_use_mask, remote_in_use_pattern;
+	struct mutex *lock;	/* lock preventing concurrent acces of CSR */
+	u32 int_bit;
+	int ret = 0;
+
+	if (accel_dev->is_vf) {
+		pf2vf_offset = hw_data->get_pf2vf_offset(0);
+		lock = &accel_dev->vf.vf2pf_lock;
+		local_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
+		local_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
+		remote_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
+		remote_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
+		int_bit = ADF_VF2PF_INT;
+	} else {
+		pf2vf_offset = hw_data->get_pf2vf_offset(vf_nr);
+		lock = &accel_dev->pf.vf_info[vf_nr].pf2vf_lock;
+		local_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
+		local_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
+		remote_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
+		remote_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
+		int_bit = ADF_PF2VF_INT;
+	}
+
+	mutex_lock(lock);
+
+	/* Check if PF2VF CSR is in use by remote function */
+	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
+	if ((val & remote_in_use_mask) == remote_in_use_pattern) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"PF2VF CSR in use by remote function\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Attempt to get ownership of PF2VF CSR */
+	msg &= ~local_in_use_mask;
+	msg |= local_in_use_pattern;
+	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg);
+
+	/* Wait in case remote func also attempting to get ownership */
+	msleep(ADF_IOV_MSG_COLLISION_DETECT_DELAY);
+
+	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
+	if ((val & local_in_use_mask) != local_in_use_pattern) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"PF2VF CSR in use by remote - collision detected\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * This function now owns the PV2VF CSR.  The IN_USE_BY pattern must
+	 * remain in the PF2VF CSR for all writes including ACK from remote
+	 * until this local function relinquishes the CSR.  Send the message
+	 * by interrupting the remote.
+	 */
+	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
+
+	/* Wait for confirmation from remote func it received the message */
+	do {
+		msleep(ADF_IOV_MSG_ACK_DELAY);
+		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
+	} while ((val & int_bit) && (count++ < ADF_IOV_MSG_ACK_MAX_RETRY));
+
+	if (val & int_bit) {
+		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
+		val &= ~int_bit;
+		ret = -EIO;
+	}
+
+	/* Finished with PF2VF CSR; relinquish it and leave msg in CSR */
+	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, val & ~local_in_use_mask);
+out:
+	mutex_unlock(lock);
+	return ret;
+}
+
+/**
+ * adf_iov_putmsg() - send PF2VF message
+ * @accel_dev:  Pointer to acceleration device.
+ * @msg:	Message to send
+ * @vf_nr:	VF number to which the message will be sent
+ *
+ * Function sends a messge from the PF to a VF
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
+{
+	u32 count = 0;
+	int ret;
+
+	do {
+		ret = __adf_iov_putmsg(accel_dev, msg, vf_nr);
+		if (ret)
+			msleep(ADF_IOV_MSG_RETRY_DELAY);
+	} while (ret && (count++ < ADF_IOV_MSG_MAX_RETRIES));
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_iov_putmsg);
+
+void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_vf_info *vf;
+	u32 msg = (ADF_PF2VF_MSGORIGIN_SYSTEM |
+		(ADF_PF2VF_MSGTYPE_RESTARTING << ADF_PF2VF_MSGTYPE_SHIFT));
+	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
+
+	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
+		if (vf->init && adf_iov_putmsg(accel_dev, msg, i))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send restarting msg to VF%d\n", i);
+	}
+}
+
+static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
+{
+	unsigned long timeout = msecs_to_jiffies(ADF_IOV_MSG_RESP_TIMEOUT);
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 msg = 0;
+	int ret;
+
+	msg = ADF_VF2PF_MSGORIGIN_SYSTEM;
+	msg |= ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ << ADF_VF2PF_MSGTYPE_SHIFT;
+	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
+	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
+
+	/* Send request from VF to PF */
+	ret = adf_iov_putmsg(accel_dev, msg, 0);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Compatibility Version Request.\n");
+		return ret;
+	}
+
+	/* Wait for response */
+	if (!wait_for_completion_timeout(&accel_dev->vf.iov_msg_completion,
+					 timeout)) {
+		dev_err(&GET_DEV(accel_dev),
+			"IOV request/response message timeout expired\n");
+		return -EIO;
+	}
+
+	/* Response from PF received, check compatibility */
+	switch (accel_dev->vf.compatible) {
+	case ADF_PF2VF_VF_COMPATIBLE:
+		break;
+	case ADF_PF2VF_VF_COMPAT_UNKNOWN:
+		/* VF is newer than PF and decides whether it is compatible */
+		if (accel_dev->vf.pf_version >= hw_data->min_iov_compat_ver)
+			break;
+		/* fall through */
+	case ADF_PF2VF_VF_INCOMPATIBLE:
+		dev_err(&GET_DEV(accel_dev),
+			"PF (vers %d) and VF (vers %d) are not compatible\n",
+			accel_dev->vf.pf_version,
+			ADF_PFVF_COMPATIBILITY_VERSION);
+		return -EINVAL;
+	default:
+		dev_err(&GET_DEV(accel_dev),
+			"Invalid response from PF; assume not compatible\n");
+		return -EINVAL;
+	}
+	return ret;
+}
+
+/**
+ * adf_enable_vf2pf_comms() - Function enables communication from vf to pf
+ *
+ * @accel_dev: Pointer to acceleration device virtual function.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+{
+	adf_enable_pf2vf_interrupts(accel_dev);
+	return adf_vf2pf_request_version(accel_dev);
+}
+EXPORT_SYMBOL_GPL(adf_enable_vf2pf_comms);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
new file mode 100644
index 0000000..3ceaa38
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
@@ -0,0 +1,144 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2015 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2015 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_PF2VF_MSG_H
+#define ADF_PF2VF_MSG_H
+
+/*
+ * PF<->VF Messaging
+ * The PF has an array of 32-bit PF2VF registers, one for each VF.  The
+ * PF can access all these registers; each VF can access only the one
+ * register associated with that particular VF.
+ *
+ * The register functionally is split into two parts:
+ * The bottom half is for PF->VF messages. In particular when the first
+ * bit of this register (bit 0) gets set an interrupt will be triggered
+ * in the respective VF.
+ * The top half is for VF->PF messages. In particular when the first bit
+ * of this half of register (bit 16) gets set an interrupt will be triggered
+ * in the PF.
+ *
+ * The remaining bits within this register are available to encode messages.
+ * and implement a collision control mechanism to prevent concurrent use of
+ * the PF2VF register by both the PF and VF.
+ *
+ *  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
+ *  _______________________________________________
+ * |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
+ * +-----------------------------------------------+
+ *  \___________________________/ \_________/ ^   ^
+ *                ^                    ^      |   |
+ *                |                    |      |   VF2PF Int
+ *                |                    |      Message Origin
+ *                |                    Message Type
+ *                Message-specific Data/Reserved
+ *
+ *  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
+ *  _______________________________________________
+ * |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
+ * +-----------------------------------------------+
+ *  \___________________________/ \_________/ ^   ^
+ *                ^                    ^      |   |
+ *                |                    |      |   PF2VF Int
+ *                |                    |      Message Origin
+ *                |                    Message Type
+ *                Message-specific Data/Reserved
+ *
+ * Message Origin (Should always be 1)
+ * A legacy out-of-tree QAT driver allowed for a set of messages not supported
+ * by this driver; these had a Msg Origin of 0 and are ignored by this driver.
+ *
+ * When a PF or VF attempts to send a message in the lower or upper 16 bits,
+ * respectively, the other 16 bits are written to first with a defined
+ * IN_USE_BY pattern as part of a collision control scheme (see adf_iov_putmsg).
+ */
+
+#define ADF_PFVF_COMPATIBILITY_VERSION		0x1	/* PF<->VF compat */
+
+/* PF->VF messages */
+#define ADF_PF2VF_INT				BIT(0)
+#define ADF_PF2VF_MSGORIGIN_SYSTEM		BIT(1)
+#define ADF_PF2VF_MSGTYPE_MASK			0x0000003C
+#define ADF_PF2VF_MSGTYPE_SHIFT			2
+#define ADF_PF2VF_MSGTYPE_RESTARTING		0x01
+#define ADF_PF2VF_MSGTYPE_VERSION_RESP		0x02
+#define ADF_PF2VF_IN_USE_BY_PF			0x6AC20000
+#define ADF_PF2VF_IN_USE_BY_PF_MASK		0xFFFE0000
+
+/* PF->VF Version Response */
+#define ADF_PF2VF_VERSION_RESP_VERS_MASK	0x00003FC0
+#define ADF_PF2VF_VERSION_RESP_VERS_SHIFT	6
+#define ADF_PF2VF_VERSION_RESP_RESULT_MASK	0x0000C000
+#define ADF_PF2VF_VERSION_RESP_RESULT_SHIFT	14
+#define ADF_PF2VF_VF_COMPATIBLE			1
+#define ADF_PF2VF_VF_INCOMPATIBLE		2
+#define ADF_PF2VF_VF_COMPAT_UNKNOWN		3
+
+/* VF->PF messages */
+#define ADF_VF2PF_IN_USE_BY_VF			0x00006AC2
+#define ADF_VF2PF_IN_USE_BY_VF_MASK		0x0000FFFE
+#define ADF_VF2PF_INT				BIT(16)
+#define ADF_VF2PF_MSGORIGIN_SYSTEM		BIT(17)
+#define ADF_VF2PF_MSGTYPE_MASK			0x003C0000
+#define ADF_VF2PF_MSGTYPE_SHIFT			18
+#define ADF_VF2PF_MSGTYPE_INIT			0x3
+#define ADF_VF2PF_MSGTYPE_SHUTDOWN		0x4
+#define ADF_VF2PF_MSGTYPE_VERSION_REQ		0x5
+#define ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ	0x6
+
+/* VF->PF Compatible Version Request */
+#define ADF_VF2PF_COMPAT_VER_REQ_SHIFT		22
+
+/* Collision detection */
+#define ADF_IOV_MSG_COLLISION_DETECT_DELAY	10
+#define ADF_IOV_MSG_ACK_DELAY			2
+#define ADF_IOV_MSG_ACK_MAX_RETRY		100
+#define ADF_IOV_MSG_RETRY_DELAY			5
+#define ADF_IOV_MSG_MAX_RETRIES			3
+#define ADF_IOV_MSG_RESP_TIMEOUT	(ADF_IOV_MSG_ACK_DELAY * \
+					 ADF_IOV_MSG_ACK_MAX_RETRY + \
+					 ADF_IOV_MSG_COLLISION_DETECT_DELAY)
+#endif /* ADF_IOV_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
new file mode 100644
index 0000000..a766fb5
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -0,0 +1,406 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2015 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2015 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/workqueue.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include "adf_common_drv.h"
+#include "adf_cfg.h"
+#include "adf_pf2vf_msg.h"
+
+static struct workqueue_struct *pf2vf_resp_wq;
+
+#define ME2FUNCTION_MAP_A_OFFSET	(0x3A400 + 0x190)
+#define ME2FUNCTION_MAP_A_NUM_REGS	96
+
+#define ME2FUNCTION_MAP_B_OFFSET	(0x3A400 + 0x310)
+#define ME2FUNCTION_MAP_B_NUM_REGS	12
+
+#define ME2FUNCTION_MAP_REG_SIZE	4
+#define ME2FUNCTION_MAP_VALID		BIT(7)
+
+#define READ_CSR_ME2FUNCTION_MAP_A(pmisc_bar_addr, index)		\
+	ADF_CSR_RD(pmisc_bar_addr, ME2FUNCTION_MAP_A_OFFSET +		\
+		   ME2FUNCTION_MAP_REG_SIZE * index)
+
+#define WRITE_CSR_ME2FUNCTION_MAP_A(pmisc_bar_addr, index, value)	\
+	ADF_CSR_WR(pmisc_bar_addr, ME2FUNCTION_MAP_A_OFFSET +		\
+		   ME2FUNCTION_MAP_REG_SIZE * index, value)
+
+#define READ_CSR_ME2FUNCTION_MAP_B(pmisc_bar_addr, index)		\
+	ADF_CSR_RD(pmisc_bar_addr, ME2FUNCTION_MAP_B_OFFSET +		\
+		   ME2FUNCTION_MAP_REG_SIZE * index)
+
+#define WRITE_CSR_ME2FUNCTION_MAP_B(pmisc_bar_addr, index, value)	\
+	ADF_CSR_WR(pmisc_bar_addr, ME2FUNCTION_MAP_B_OFFSET +		\
+		   ME2FUNCTION_MAP_REG_SIZE * index, value)
+
+struct adf_pf2vf_resp_data {
+	struct work_struct pf2vf_resp_work;
+	struct adf_accel_dev *accel_dev;
+	u32 resp;
+	u8 vf_nr;
+};
+
+static void adf_iov_send_resp(struct work_struct *work)
+{
+	struct adf_pf2vf_resp_data *pf2vf_resp_data =
+		container_of(work, struct adf_pf2vf_resp_data, pf2vf_resp_work);
+
+	if (adf_iov_putmsg(pf2vf_resp_data->accel_dev, pf2vf_resp_data->resp,
+			   pf2vf_resp_data->vf_nr)) {
+		dev_err(&GET_DEV(pf2vf_resp_data->accel_dev),
+			"Failed to send response\n");
+	}
+
+	kfree(pf2vf_resp_data);
+}
+
+static void adf_vf2pf_bh_handler(void *data)
+{
+	struct adf_accel_vf_info *vf_info = (struct adf_accel_vf_info *)data;
+	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	u32 msg;
+
+	/* Read message from the VF */
+	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_info->vf_nr));
+
+	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM))
+		/* Ignore legacy non-system (non-kernel) VF2PF messages */
+		goto err;
+
+	switch ((msg & ADF_VF2PF_MSGTYPE_MASK) >> ADF_VF2PF_MSGTYPE_SHIFT) {
+	case ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ:
+		{
+		u8 vf_compat_ver = msg >> ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
+		struct adf_pf2vf_resp_data *pf2vf_resp_data;
+		u32 resp = (ADF_PF2VF_MSGORIGIN_SYSTEM |
+				 (ADF_PF2VF_MSGTYPE_VERSION_RESP <<
+				  ADF_PF2VF_MSGTYPE_SHIFT) |
+				 (ADF_PFVF_COMPATIBILITY_VERSION <<
+				  ADF_PF2VF_VERSION_RESP_VERS_SHIFT));
+
+		dev_dbg(&GET_DEV(accel_dev),
+			"Compatibility Version Request from VF%d vers=%u\n",
+			vf_info->vf_nr + 1, vf_compat_ver);
+
+		if (vf_compat_ver < hw_data->min_iov_compat_ver) {
+			dev_err(&GET_DEV(accel_dev),
+				"VF (vers %d) incompatible with PF (vers %d)\n",
+				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
+			resp |= ADF_PF2VF_VF_INCOMPATIBLE <<
+				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		} else if (vf_compat_ver > ADF_PFVF_COMPATIBILITY_VERSION) {
+			dev_err(&GET_DEV(accel_dev),
+				"VF (vers %d) compat with PF (vers %d) unkn.\n",
+				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
+			resp |= ADF_PF2VF_VF_COMPAT_UNKNOWN <<
+				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		} else {
+			dev_dbg(&GET_DEV(accel_dev),
+				"VF (vers %d) compatible with PF (vers %d)\n",
+				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
+			resp |= ADF_PF2VF_VF_COMPATIBLE <<
+				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		}
+
+		pf2vf_resp_data = kzalloc(sizeof(*pf2vf_resp_data), GFP_ATOMIC);
+		if (!pf2vf_resp_data)
+			return;
+
+		pf2vf_resp_data->accel_dev = accel_dev;
+		pf2vf_resp_data->vf_nr = vf_info->vf_nr;
+		pf2vf_resp_data->resp = resp;
+		INIT_WORK(&pf2vf_resp_data->pf2vf_resp_work, adf_iov_send_resp);
+		queue_work(pf2vf_resp_wq, &pf2vf_resp_data->pf2vf_resp_work);
+		}
+		break;
+	case ADF_VF2PF_MSGTYPE_INIT:
+		{
+		dev_dbg(&GET_DEV(accel_dev),
+			"Init message received from VF%d 0x%x\n",
+			vf_info->vf_nr + 1, msg);
+		vf_info->init = true;
+		}
+		break;
+	case ADF_VF2PF_MSGTYPE_SHUTDOWN:
+		{
+		dev_dbg(&GET_DEV(accel_dev),
+			"Shutdown message received from VF%d 0x%x\n",
+			vf_info->vf_nr + 1, msg);
+		vf_info->init = false;
+		}
+		break;
+	case ADF_VF2PF_MSGTYPE_VERSION_REQ:
+		dev_err(&GET_DEV(accel_dev),
+			"Incompatible VersionRequest received from VF%d 0x%x\n",
+			vf_info->vf_nr + 1, msg);
+		break;
+	default:
+		goto err;
+	}
+
+	/* To ACK, clear the VF2PFINT bit */
+	msg &= ~ADF_VF2PF_INT;
+	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_info->vf_nr), msg);
+
+	/* re-enable interrupt on PF from this VF */
+	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_info->vf_nr));
+	return;
+err:
+	dev_err(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x);\n",
+		vf_info->vf_nr + 1, msg);
+}
+
+static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	int totalvfs = pci_sriov_get_totalvfs(pdev);
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	struct adf_accel_vf_info *vf_info;
+	int i, ret;
+	u32 reg;
+
+	/* Workqueue for PF2VF responses */
+	pf2vf_resp_wq = create_workqueue("qat_pf2vf_resp_wq");
+	if (!pf2vf_resp_wq)
+		return -ENOMEM;
+
+	for (i = 0, vf_info = accel_dev->pf.vf_info; i < totalvfs;
+	     i++, vf_info++) {
+		/* This ptr will be populated when VFs will be created */
+		vf_info->accel_dev = accel_dev;
+		vf_info->vf_nr = i;
+
+		tasklet_init(&vf_info->vf2pf_bh_tasklet,
+			     (void *)adf_vf2pf_bh_handler,
+			     (unsigned long)vf_info);
+		mutex_init(&vf_info->pf2vf_lock);
+		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
+				     DEFAULT_RATELIMIT_INTERVAL,
+				     DEFAULT_RATELIMIT_BURST);
+	}
+
+	/* Set Valid bits in ME Thread to PCIe Function Mapping Group A */
+	for (i = 0; i < ME2FUNCTION_MAP_A_NUM_REGS; i++) {
+		reg = READ_CSR_ME2FUNCTION_MAP_A(pmisc_addr, i);
+		reg |= ME2FUNCTION_MAP_VALID;
+		WRITE_CSR_ME2FUNCTION_MAP_A(pmisc_addr, i, reg);
+	}
+
+	/* Set Valid bits in ME Thread to PCIe Function Mapping Group B */
+	for (i = 0; i < ME2FUNCTION_MAP_B_NUM_REGS; i++) {
+		reg = READ_CSR_ME2FUNCTION_MAP_B(pmisc_addr, i);
+		reg |= ME2FUNCTION_MAP_VALID;
+		WRITE_CSR_ME2FUNCTION_MAP_B(pmisc_addr, i, reg);
+	}
+
+	/* Enable VF to PF interrupts for all VFs */
+	adf_enable_vf2pf_interrupts(accel_dev, GENMASK_ULL(totalvfs - 1, 0));
+
+	/*
+	 * Due to the hardware design, when SR-IOV and the ring arbiter
+	 * are enabled all the VFs supported in hardware must be enabled in
+	 * order for all the hardware resources (i.e. bundles) to be usable.
+	 * When SR-IOV is enabled, each of the VFs will own one bundle.
+	 */
+	ret = pci_enable_sriov(pdev, totalvfs);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * adf_disable_sriov() - Disable SRIOV for the device
+ * @pdev:  Pointer to pci device.
+ *
+ * Function disables SRIOV for the pci device.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+void adf_disable_sriov(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	int totalvfs = pci_sriov_get_totalvfs(accel_to_pci_dev(accel_dev));
+	struct adf_accel_vf_info *vf;
+	u32 reg;
+	int i;
+
+	if (!accel_dev->pf.vf_info)
+		return;
+
+	adf_pf2vf_notify_restarting(accel_dev);
+
+	pci_disable_sriov(accel_to_pci_dev(accel_dev));
+
+	/* Disable VF to PF interrupts */
+	adf_disable_vf2pf_interrupts(accel_dev, 0xFFFFFFFF);
+
+	/* Clear Valid bits in ME Thread to PCIe Function Mapping Group A */
+	for (i = 0; i < ME2FUNCTION_MAP_A_NUM_REGS; i++) {
+		reg = READ_CSR_ME2FUNCTION_MAP_A(pmisc_addr, i);
+		reg &= ~ME2FUNCTION_MAP_VALID;
+		WRITE_CSR_ME2FUNCTION_MAP_A(pmisc_addr, i, reg);
+	}
+
+	/* Clear Valid bits in ME Thread to PCIe Function Mapping Group B */
+	for (i = 0; i < ME2FUNCTION_MAP_B_NUM_REGS; i++) {
+		reg = READ_CSR_ME2FUNCTION_MAP_B(pmisc_addr, i);
+		reg &= ~ME2FUNCTION_MAP_VALID;
+		WRITE_CSR_ME2FUNCTION_MAP_B(pmisc_addr, i, reg);
+	}
+
+	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++) {
+		tasklet_disable(&vf->vf2pf_bh_tasklet);
+		tasklet_kill(&vf->vf2pf_bh_tasklet);
+		mutex_destroy(&vf->pf2vf_lock);
+	}
+
+	kfree(accel_dev->pf.vf_info);
+	accel_dev->pf.vf_info = NULL;
+
+	if (pf2vf_resp_wq) {
+		destroy_workqueue(pf2vf_resp_wq);
+		pf2vf_resp_wq = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(adf_disable_sriov);
+
+/**
+ * adf_sriov_configure() - Enable SRIOV for the device
+ * @pdev:  Pointer to pci device.
+ *
+ * Function enables SRIOV for the pci device.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	int totalvfs = pci_sriov_get_totalvfs(pdev);
+	unsigned long val;
+	int ret;
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return -EFAULT;
+	}
+
+	if (!iommu_present(&pci_bus_type)) {
+		dev_err(&pdev->dev,
+			"IOMMU must be enabled for SR-IOV to work\n");
+		return -EINVAL;
+	}
+
+	if (accel_dev->pf.vf_info) {
+		dev_info(&pdev->dev, "Already enabled for this device\n");
+		return -EINVAL;
+	}
+
+	if (adf_dev_started(accel_dev)) {
+		if (adf_devmgr_in_reset(accel_dev) ||
+		    adf_dev_in_use(accel_dev)) {
+			dev_err(&GET_DEV(accel_dev), "Device busy\n");
+			return -EBUSY;
+		}
+
+		if (adf_dev_stop(accel_dev)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to stop qat_dev%d\n",
+				accel_dev->accel_id);
+			return -EFAULT;
+		}
+
+		adf_dev_shutdown(accel_dev);
+	}
+
+	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
+		return -EFAULT;
+	val = 0;
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					ADF_NUM_CY, (void *)&val, ADF_DEC))
+		return -EFAULT;
+
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+
+	/* Allocate memory for VF info structs */
+	accel_dev->pf.vf_info = kcalloc(totalvfs,
+					sizeof(struct adf_accel_vf_info),
+					GFP_KERNEL);
+	if (!accel_dev->pf.vf_info)
+		return -ENOMEM;
+
+	if (adf_dev_init(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed to init qat_dev%d\n",
+			accel_dev->accel_id);
+		return -EFAULT;
+	}
+
+	if (adf_dev_start(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
+			accel_dev->accel_id);
+		return -EFAULT;
+	}
+
+	ret = adf_enable_sriov(accel_dev);
+	if (ret)
+		return ret;
+
+	return numvfs;
+}
+EXPORT_SYMBOL_GPL(adf_sriov_configure);
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 359ae94..07c2f9f 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -103,9 +103,11 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 
 	list_for_each(itr, adf_devmgr_get_head()) {
 		accel_dev = list_entry(itr, struct adf_accel_dev, list);
+
 		if ((node == dev_to_node(&GET_DEV(accel_dev)) ||
 		     dev_to_node(&GET_DEV(accel_dev)) < 0) &&
-		    adf_dev_started(accel_dev))
+		    adf_dev_started(accel_dev) &&
+		    !list_empty(&accel_dev->crypto_list))
 			break;
 		accel_dev = NULL;
 	}
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index a3b1be8..ff54257 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -45,6 +45,7 @@
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 #include <adf_accel_devices.h>
+#include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include "adf_dh895xcc_hw_data.h"
 #include "adf_drv.h"
@@ -161,6 +162,16 @@ void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
 	}
 }
 
+static uint32_t get_pf2vf_offset(uint32_t i)
+{
+	return ADF_DH895XCC_PF2VF_OFFSET(i);
+}
+
+static uint32_t get_vintmsk_offset(uint32_t i)
+{
+	return ADF_DH895XCC_VINTMSK_OFFSET(i);
+}
+
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
@@ -197,11 +208,17 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 
 	/* Enable bundle and misc interrupts */
 	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF0_MASK_OFFSET,
-		   ADF_DH895XCC_SMIA0_MASK);
+		   accel_dev->pf.vf_info ? 0 :
+			GENMASK_ULL(GET_MAX_BANKS(accel_dev) - 1, 0));
 	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF1_MASK_OFFSET,
 		   ADF_DH895XCC_SMIA1_MASK);
 }
 
+static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+{
+	return 0;
+}
+
 void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &dh895xcc_class;
@@ -221,17 +238,22 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
+	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_DH895XCC_FW;
 	hw_data->fw_mmp_name = ADF_DH895XCC_MMP;
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
+	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->send_admin_init = adf_send_admin_init;
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
+	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
 }
 
 void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index d410afb..88dffb2 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -80,6 +80,10 @@
 #define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
+#define ADF_DH895XCC_ERRSOU3	(0x3A000 + 0x00C)
+#define ADF_DH895XCC_ERRSOU5	(0x3A000 + 0x0D8)
+#define ADF_DH895XCC_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+#define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
 #define ADF_DH895XCC_MMP "qat_mmp.bin"
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 1837c32..f8dd14f 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -82,16 +82,21 @@ static struct pci_driver adf_driver = {
 	.id_table = adf_pci_tbl,
 	.name = adf_driver_name,
 	.probe = adf_probe,
-	.remove = adf_remove
+	.remove = adf_remove,
+	.sriov_configure = adf_sriov_configure,
 };
 
+static void adf_cleanup_pci_dev(struct adf_accel_dev *accel_dev)
+{
+	pci_release_regions(accel_dev->accel_pci_dev.pci_dev);
+	pci_disable_device(accel_dev->accel_pci_dev.pci_dev);
+}
+
 static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *accel_pci_dev = &accel_dev->accel_pci_dev;
 	int i;
 
-	adf_dev_shutdown(accel_dev);
-
 	for (i = 0; i < ADF_PCI_MAX_BARS; i++) {
 		struct adf_bar *bar = &accel_pci_dev->pci_bars[i];
 
@@ -108,13 +113,11 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 			break;
 		}
 		kfree(accel_dev->hw_device);
+		accel_dev->hw_device = NULL;
 	}
 	adf_cfg_dev_remove(accel_dev);
 	debugfs_remove(accel_dev->debugfs_dir);
-	adf_devmgr_rm_dev(accel_dev);
-	pci_release_regions(accel_pci_dev->pci_dev);
-	pci_disable_device(accel_pci_dev->pci_dev);
-	kfree(accel_dev);
+	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
 static int adf_dev_configure(struct adf_accel_dev *accel_dev)
@@ -205,7 +208,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_hw_device_data *hw_data;
 	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
-	int ret;
+	int ret, bar_mask;
 
 	switch (ent->device) {
 	case ADF_DH895XCC_PCI_DEVICE_ID:
@@ -229,10 +232,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
+	accel_pci_dev = &accel_dev->accel_pci_dev;
+	accel_pci_dev->pci_dev = pdev;
 
 	/* Add accel device to accel table.
 	 * This should be called before adf_cleanup_accel is called */
-	if (adf_devmgr_add_dev(accel_dev)) {
+	if (adf_devmgr_add_dev(accel_dev, NULL)) {
 		dev_err(&pdev->dev, "Failed to add new accelerator device.\n");
 		kfree(accel_dev);
 		return -EFAULT;
@@ -255,7 +260,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	default:
 		return -ENODEV;
 	}
-	accel_pci_dev = &accel_dev->accel_pci_dev;
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_DH895XCC_FUSECTL_OFFSET,
 			      &hw_data->fuses);
@@ -264,7 +268,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
 	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
-	accel_pci_dev->pci_dev = pdev;
 	/* If the device has no acceleration engines then ignore it. */
 	if (!hw_data->accel_mask || !hw_data->ae_mask ||
 	    ((~hw_data->ae_mask) & 0x01)) {
@@ -274,11 +277,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_dev%d", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, hw_data->instance_id);
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
+		 pdev->bus->number, PCI_SLOT(pdev->devfn),
+		 PCI_FUNC(pdev->devfn));
+
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir\n");
+		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
 		ret = -EINVAL;
 		goto out_err;
 	}
@@ -301,7 +307,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 			dev_err(&pdev->dev, "No usable DMA configuration\n");
 			ret = -EFAULT;
-			goto out_err;
+			goto out_err_disable;
 		} else {
 			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		}
@@ -312,7 +318,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (pci_request_regions(pdev, adf_driver_name)) {
 		ret = -EFAULT;
-		goto out_err;
+		goto out_err_disable;
 	}
 
 	/* Read accelerator capabilities mask */
@@ -320,19 +326,21 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			      &hw_data->accel_capabilities_mask);
 
 	/* Find and map all the device's BARS */
-	for (i = 0; i < ADF_PCI_MAX_BARS; i++) {
-		struct adf_bar *bar = &accel_pci_dev->pci_bars[i];
+	i = 0;
+	bar_mask = pci_select_bars(pdev, IORESOURCE_MEM);
+	for_each_set_bit(bar_nr, (const unsigned long *)&bar_mask,
+			 ADF_PCI_MAX_BARS * 2) {
+		struct adf_bar *bar = &accel_pci_dev->pci_bars[i++];
 
-		bar_nr = i * 2;
 		bar->base_addr = pci_resource_start(pdev, bar_nr);
 		if (!bar->base_addr)
 			break;
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", i);
+			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
-			goto out_err;
+			goto out_err_free_reg;
 		}
 	}
 	pci_set_master(pdev);
@@ -340,32 +348,40 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (adf_enable_aer(accel_dev, &adf_driver)) {
 		dev_err(&pdev->dev, "Failed to enable aer\n");
 		ret = -EFAULT;
-		goto out_err;
+		goto out_err_free_reg;
 	}
 
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_err_free_reg;
 	}
 
 	ret = adf_dev_configure(accel_dev);
 	if (ret)
-		goto out_err;
+		goto out_err_free_reg;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
-		goto out_err;
+		goto out_err_dev_shutdown;
 
 	ret = adf_dev_start(accel_dev);
-	if (ret) {
-		adf_dev_stop(accel_dev);
-		goto out_err;
-	}
+	if (ret)
+		goto out_err_dev_stop;
 
-	return 0;
+	return ret;
+
+out_err_dev_stop:
+	adf_dev_stop(accel_dev);
+out_err_dev_shutdown:
+	adf_dev_shutdown(accel_dev);
+out_err_free_reg:
+	pci_release_regions(accel_pci_dev->pci_dev);
+out_err_disable:
+	pci_disable_device(accel_pci_dev->pci_dev);
 out_err:
 	adf_cleanup_accel(accel_dev);
+	kfree(accel_dev);
 	return ret;
 }
 
@@ -379,8 +395,12 @@ static void adf_remove(struct pci_dev *pdev)
 	}
 	if (adf_dev_stop(accel_dev))
 		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
+
+	adf_dev_shutdown(accel_dev);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
+	adf_cleanup_pci_dev(accel_dev);
+	kfree(accel_dev);
 }
 
 static int __init adfdrv_init(void)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index 0d03c10..5570f78 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -59,21 +59,30 @@
 #include <adf_transport_access_macros.h>
 #include <adf_transport_internal.h>
 #include "adf_drv.h"
+#include "adf_dh895xcc_hw_data.h"
 
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	uint32_t msix_num_entries = hw_data->num_banks + 1;
-	int i;
-
-	for (i = 0; i < msix_num_entries; i++)
-		pci_dev_info->msix_entries.entries[i].entry = i;
+	u32 msix_num_entries = 1;
+
+	/* If SR-IOV is disabled, add entries for each bank */
+	if (!accel_dev->pf.vf_info) {
+		int i;
+
+		msix_num_entries += hw_data->num_banks;
+		for (i = 0; i < msix_num_entries; i++)
+			pci_dev_info->msix_entries.entries[i].entry = i;
+	} else {
+		pci_dev_info->msix_entries.entries[0].entry =
+			hw_data->num_banks;
+	}
 
 	if (pci_enable_msix_exact(pci_dev_info->pci_dev,
 				  pci_dev_info->msix_entries.entries,
 				  msix_num_entries)) {
-		dev_err(&GET_DEV(accel_dev), "Failed to enable MSIX IRQ\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to enable MSI-X IRQ(s)\n");
 		return -EFAULT;
 	}
 	return 0;
@@ -97,9 +106,58 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 {
 	struct adf_accel_dev *accel_dev = dev_ptr;
 
-	dev_info(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
-		 accel_dev->accel_id);
-	return IRQ_HANDLED;
+#ifdef CONFIG_PCI_IOV
+	/* If SR-IOV is enabled (vf_info is non-NULL), check for VF->PF ints */
+	if (accel_dev->pf.vf_info) {
+		void __iomem *pmisc_bar_addr =
+		    (&GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR])->virt_addr;
+		u32 vf_mask;
+
+		/* Get the interrupt sources triggered by VFs */
+		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCC_ERRSOU5) &
+			    0x0000FFFF) << 16) |
+			  ((ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCC_ERRSOU3) &
+			    0x01FFFE00) >> 9);
+
+		if (vf_mask) {
+			struct adf_accel_vf_info *vf_info;
+			bool irq_handled = false;
+			int i;
+
+			/* Disable VF2PF interrupts for VFs with pending ints */
+			adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+
+			/*
+			 * Schedule tasklets to handle VF2PF interrupt BHs
+			 * unless the VF is malicious and is attempting to
+			 * flood the host OS with VF2PF interrupts.
+			 */
+			for_each_set_bit(i, (const unsigned long *)&vf_mask,
+					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
+				vf_info = accel_dev->pf.vf_info + i;
+
+				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
+					dev_info(&GET_DEV(accel_dev),
+						 "Too many ints from VF%d\n",
+						  vf_info->vf_nr + 1);
+					continue;
+				}
+
+				/* Tasklet will re-enable ints from this VF */
+				tasklet_hi_schedule(&vf_info->vf2pf_bh_tasklet);
+				irq_handled = true;
+			}
+
+			if (irq_handled)
+				return IRQ_HANDLED;
+		}
+	}
+#endif /* CONFIG_PCI_IOV */
+
+	dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
+		accel_dev->accel_id);
+
+	return IRQ_NONE;
 }
 
 static int adf_request_irqs(struct adf_accel_dev *accel_dev)
@@ -108,28 +166,32 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct msix_entry *msixe = pci_dev_info->msix_entries.entries;
 	struct adf_etr_data *etr_data = accel_dev->transport;
-	int ret, i;
+	int ret, i = 0;
 	char *name;
 
-	/* Request msix irq for all banks */
-	for (i = 0; i < hw_data->num_banks; i++) {
-		struct adf_etr_bank_data *bank = &etr_data->banks[i];
-		unsigned int cpu, cpus = num_online_cpus();
-
-		name = *(pci_dev_info->msix_entries.names + i);
-		snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
-			 "qat%d-bundle%d", accel_dev->accel_id, i);
-		ret = request_irq(msixe[i].vector,
-				  adf_msix_isr_bundle, 0, name, bank);
-		if (ret) {
-			dev_err(&GET_DEV(accel_dev),
-				"failed to enable irq %d for %s\n",
-				msixe[i].vector, name);
-			return ret;
+	/* Request msix irq for all banks unless SR-IOV enabled */
+	if (!accel_dev->pf.vf_info) {
+		for (i = 0; i < hw_data->num_banks; i++) {
+			struct adf_etr_bank_data *bank = &etr_data->banks[i];
+			unsigned int cpu, cpus = num_online_cpus();
+
+			name = *(pci_dev_info->msix_entries.names + i);
+			snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
+				 "qat%d-bundle%d", accel_dev->accel_id, i);
+			ret = request_irq(msixe[i].vector,
+					  adf_msix_isr_bundle, 0, name, bank);
+			if (ret) {
+				dev_err(&GET_DEV(accel_dev),
+					"failed to enable irq %d for %s\n",
+					msixe[i].vector, name);
+				return ret;
+			}
+
+			cpu = ((accel_dev->accel_id * hw_data->num_banks) +
+			       i) % cpus;
+			irq_set_affinity_hint(msixe[i].vector,
+					      get_cpu_mask(cpu));
 		}
-
-		cpu = ((accel_dev->accel_id * hw_data->num_banks) + i) % cpus;
-		irq_set_affinity_hint(msixe[i].vector, get_cpu_mask(cpu));
 	}
 
 	/* Request msix irq for AE */
@@ -152,11 +214,13 @@ static void adf_free_irqs(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct msix_entry *msixe = pci_dev_info->msix_entries.entries;
 	struct adf_etr_data *etr_data = accel_dev->transport;
-	int i;
+	int i = 0;
 
-	for (i = 0; i < hw_data->num_banks; i++) {
-		irq_set_affinity_hint(msixe[i].vector, NULL);
-		free_irq(msixe[i].vector, &etr_data->banks[i]);
+	if (pci_dev_info->msix_entries.num_entries > 1) {
+		for (i = 0; i < hw_data->num_banks; i++) {
+			irq_set_affinity_hint(msixe[i].vector, NULL);
+			free_irq(msixe[i].vector, &etr_data->banks[i]);
+		}
 	}
 	irq_set_affinity_hint(msixe[i].vector, NULL);
 	free_irq(msixe[i].vector, accel_dev);
@@ -168,7 +232,11 @@ static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
 	char **names;
 	struct msix_entry *entries;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	uint32_t msix_num_entries = hw_data->num_banks + 1;
+	u32 msix_num_entries = 1;
+
+	/* If SR-IOV is disabled (vf_info is NULL), add entries for each bank */
+	if (!accel_dev->pf.vf_info)
+		msix_num_entries += hw_data->num_banks;
 
 	entries = kzalloc_node(msix_num_entries * sizeof(*entries),
 			       GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
@@ -185,6 +253,7 @@ static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
 		if (!(*(names + i)))
 			goto err;
 	}
+	accel_dev->accel_pci_dev.msix_entries.num_entries = msix_num_entries;
 	accel_dev->accel_pci_dev.msix_entries.entries = entries;
 	accel_dev->accel_pci_dev.msix_entries.names = names;
 	return 0;
@@ -198,13 +267,11 @@ err:
 
 static void adf_isr_free_msix_entry_table(struct adf_accel_dev *accel_dev)
 {
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	uint32_t msix_num_entries = hw_data->num_banks + 1;
 	char **names = accel_dev->accel_pci_dev.msix_entries.names;
 	int i;
 
 	kfree(accel_dev->accel_pci_dev.msix_entries.entries);
-	for (i = 0; i < msix_num_entries; i++)
+	for (i = 0; i < accel_dev->accel_pci_dev.msix_entries.num_entries; i++)
 		kfree(*(names + i));
 	kfree(names);
 }
