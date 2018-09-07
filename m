From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH 1/1] crypto: cavium/nitrox - Added support for SR-IOV configuration.
Date: Fri,  7 Sep 2018 12:31:18 +0530
Message-ID: <1536303678-3674-1-git-send-email-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Added support to configure SR-IOV using sysfs interface.
Supported VF modes are 16, 32, 64 and 128. Grouped the
hardware configuration functions to "nitrox_hal.h" file.
Changed driver version to "1.1".

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
---
 drivers/crypto/cavium/nitrox/Makefile        |   2 +
 drivers/crypto/cavium/nitrox/nitrox_common.h |  14 --
 drivers/crypto/cavium/nitrox/nitrox_dev.h    |  36 ++++-
 drivers/crypto/cavium/nitrox/nitrox_hal.c    |  12 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.h    |  22 +++
 drivers/crypto/cavium/nitrox/nitrox_isr.c    |   1 +
 drivers/crypto/cavium/nitrox/nitrox_main.c   |  29 +++-
 drivers/crypto/cavium/nitrox/nitrox_sriov.c  | 150 +++++++++++++++++++
 8 files changed, 236 insertions(+), 30 deletions(-)
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_hal.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_sriov.c

diff --git a/drivers/crypto/cavium/nitrox/Makefile b/drivers/crypto/cavium/nitrox/Makefile
index 45b7379e8e30..6fcda6b56f7e 100644
--- a/drivers/crypto/cavium/nitrox/Makefile
+++ b/drivers/crypto/cavium/nitrox/Makefile
@@ -7,3 +7,5 @@ n5pf-objs := nitrox_main.o \
 	nitrox_hal.o \
 	nitrox_reqmgr.o \
 	nitrox_algs.o
+
+n5pf-$(CONFIG_PCI_IOV) += nitrox_sriov.o
diff --git a/drivers/crypto/cavium/nitrox/nitrox_common.h b/drivers/crypto/cavium/nitrox/nitrox_common.h
index 312f72801af6..00ef931115da 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_common.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_common.h
@@ -25,19 +25,5 @@ int nitrox_process_se_request(struct nitrox_device *ndev,
 			      struct skcipher_request *skreq);
 void backlog_qflush_work(struct work_struct *work);
 
-void nitrox_config_emu_unit(struct nitrox_device *ndev);
-void nitrox_config_pkt_input_rings(struct nitrox_device *ndev);
-void nitrox_config_pkt_solicit_ports(struct nitrox_device *ndev);
-void nitrox_config_vfmode(struct nitrox_device *ndev, int mode);
-void nitrox_config_nps_unit(struct nitrox_device *ndev);
-void nitrox_config_pom_unit(struct nitrox_device *ndev);
-void nitrox_config_rand_unit(struct nitrox_device *ndev);
-void nitrox_config_efl_unit(struct nitrox_device *ndev);
-void nitrox_config_bmi_unit(struct nitrox_device *ndev);
-void nitrox_config_bmo_unit(struct nitrox_device *ndev);
-void nitrox_config_lbc_unit(struct nitrox_device *ndev);
-void invalidate_lbc(struct nitrox_device *ndev);
-void enable_pkt_input_ring(struct nitrox_device *ndev, int ring);
-void enable_pkt_solicit_port(struct nitrox_device *ndev, int port);
 
 #endif /* __NITROX_COMMON_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index af596455b420..4f560cedd0aa 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -88,9 +88,25 @@ struct nitrox_bh {
 	struct bh_data *slc;
 };
 
-/* NITROX-V driver state */
-#define NITROX_UCODE_LOADED	0
-#define NITROX_READY		1
+/*
+ * NITROX Device states
+ */
+enum ndev_state {
+	__NDEV_NOT_READY,
+	__NDEV_READY,
+	__NDEV_IN_RESET,
+};
+
+/* NITROX support modes for VF(s) */
+enum vf_mode {
+	__NDEV_MODE_PF,
+	__NDEV_MODE_VF16,
+	__NDEV_MODE_VF32,
+	__NDEV_MODE_VF64,
+	__NDEV_MODE_VF128,
+};
+
+#define __NDEV_SRIOV_BIT 0
 
 /* command queue size */
 #define DEFAULT_CMD_QLEN 2048
@@ -98,7 +114,6 @@ struct nitrox_bh {
 #define CMD_TIMEOUT 2000
 
 #define DEV(ndev) ((struct device *)(&(ndev)->pdev->dev))
-#define PF_MODE 0
 
 #define NITROX_CSR_ADDR(ndev, offset) \
 	((ndev)->bar_addr + (offset))
@@ -108,13 +123,15 @@ struct nitrox_bh {
  * @list: pointer to linked list of devices
  * @bar_addr: iomap address
  * @pdev: PCI device information
- * @status: NITROX status
+ * @state: NITROX device state
+ * @flags: flags to indicate device the features
  * @timeout: Request timeout in jiffies
  * @refcnt: Device usage count
  * @idx: device index (0..N)
  * @node: NUMA node id attached
  * @qlen: Command queue length
  * @nr_queues: Number of command queues
+ * @mode: Device mode PF/VF
  * @ctx_pool: DMA pool for crypto context
  * @pkt_cmdqs: SE Command queues
  * @msix: MSI-X information
@@ -128,7 +145,8 @@ struct nitrox_device {
 	u8 __iomem *bar_addr;
 	struct pci_dev *pdev;
 
-	unsigned long status;
+	atomic_t state;
+	unsigned long flags;
 	unsigned long timeout;
 	refcount_t refcnt;
 
@@ -136,6 +154,8 @@ struct nitrox_device {
 	int node;
 	u16 qlen;
 	u16 nr_queues;
+	int num_vfs;
+	enum vf_mode mode;
 
 	struct dma_pool *ctx_pool;
 	struct nitrox_cmdq *pkt_cmdqs;
@@ -173,9 +193,9 @@ static inline void nitrox_write_csr(struct nitrox_device *ndev, u64 offset,
 	writeq(value, (ndev->bar_addr + offset));
 }
 
-static inline int nitrox_ready(struct nitrox_device *ndev)
+static inline bool nitrox_ready(struct nitrox_device *ndev)
 {
-	return test_bit(NITROX_READY, &ndev->status);
+	return atomic_read(&ndev->state) == __NDEV_READY;
 }
 
 #endif /* __NITROX_DEV_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index ab4ccf2f9e77..2b256ba36dff 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -256,7 +256,7 @@ void nitrox_config_nps_unit(struct nitrox_device *ndev)
 	/* disable ILK interface */
 	core_gbl_vfcfg.value = 0;
 	core_gbl_vfcfg.s.ilk_disable = 1;
-	core_gbl_vfcfg.s.cfg = PF_MODE;
+	core_gbl_vfcfg.s.cfg = __NDEV_MODE_PF;
 	nitrox_write_csr(ndev, NPS_CORE_GBL_VFCFG, core_gbl_vfcfg.value);
 	/* config input and solicit ports */
 	nitrox_config_pkt_input_rings(ndev);
@@ -400,3 +400,13 @@ void nitrox_config_lbc_unit(struct nitrox_device *ndev)
 	offset = LBC_ELM_VF65_128_INT_ENA_W1S;
 	nitrox_write_csr(ndev, offset, (~0ULL));
 }
+
+void config_nps_core_vfcfg_mode(struct nitrox_device *ndev, enum vf_mode mode)
+{
+	union nps_core_gbl_vfcfg vfcfg;
+
+	vfcfg.value = nitrox_read_csr(ndev, NPS_CORE_GBL_VFCFG);
+	vfcfg.s.cfg = mode & 0x7;
+
+	nitrox_write_csr(ndev, NPS_CORE_GBL_VFCFG, vfcfg.value);
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.h b/drivers/crypto/cavium/nitrox/nitrox_hal.h
new file mode 100644
index 000000000000..3baef865b17c
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NITROX_HAL_H
+#define __NITROX_HAL_H
+
+#include "nitrox_dev.h"
+
+void nitrox_config_emu_unit(struct nitrox_device *ndev);
+void nitrox_config_pkt_input_rings(struct nitrox_device *ndev);
+void nitrox_config_pkt_solicit_ports(struct nitrox_device *ndev);
+void nitrox_config_nps_unit(struct nitrox_device *ndev);
+void nitrox_config_pom_unit(struct nitrox_device *ndev);
+void nitrox_config_rand_unit(struct nitrox_device *ndev);
+void nitrox_config_efl_unit(struct nitrox_device *ndev);
+void nitrox_config_bmi_unit(struct nitrox_device *ndev);
+void nitrox_config_bmo_unit(struct nitrox_device *ndev);
+void nitrox_config_lbc_unit(struct nitrox_device *ndev);
+void invalidate_lbc(struct nitrox_device *ndev);
+void enable_pkt_input_ring(struct nitrox_device *ndev, int ring);
+void enable_pkt_solicit_port(struct nitrox_device *ndev, int port);
+void config_nps_core_vfcfg_mode(struct nitrox_device *ndev, enum vf_mode mode);
+
+#endif /* __NITROX_HAL_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index ee0d70ba25d5..4f4334929f35 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -6,6 +6,7 @@
 #include "nitrox_dev.h"
 #include "nitrox_csr.h"
 #include "nitrox_common.h"
+#include "nitrox_hal.h"
 
 #define NR_RING_VECTORS 3
 #define NPS_CORE_INT_ACTIVE_ENTRY 192
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index fee7cb2ce747..6d7a421bddb8 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -11,13 +11,14 @@
 #include "nitrox_dev.h"
 #include "nitrox_common.h"
 #include "nitrox_csr.h"
+#include "nitrox_hal.h"
 
 #define CNN55XX_DEV_ID	0x12
 #define MAX_PF_QUEUES	64
 #define UCODE_HLEN 48
 #define SE_GROUP 0
 
-#define DRIVER_VERSION "1.0"
+#define DRIVER_VERSION "1.1"
 #define FW_DIR "cavium/"
 /* SE microcode */
 #define SE_FW	FW_DIR "cnn55xx_se.fw"
@@ -42,6 +43,15 @@ static unsigned int qlen = DEFAULT_CMD_QLEN;
 module_param(qlen, uint, 0644);
 MODULE_PARM_DESC(qlen, "Command queue length - default 2048");
 
+#ifdef CONFIG_PCI_IOV
+int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs);
+#else
+int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	return 0;
+}
+#endif
+
 /**
  * struct ucode - Firmware Header
  * @id: microcode ID
@@ -136,9 +146,6 @@ static int nitrox_load_fw(struct nitrox_device *ndev, const char *fw_name)
 	write_to_ucd_unit(ndev, ucode);
 	release_firmware(fw);
 
-	set_bit(NITROX_UCODE_LOADED, &ndev->status);
-	/* barrier to sync with other cpus */
-	smp_mb__after_atomic();
 	return 0;
 }
 
@@ -555,7 +562,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 	if (err)
 		goto pf_hw_fail;
 
-	set_bit(NITROX_READY, &ndev->status);
+	atomic_set(&ndev->state, __NDEV_READY);
 	/* barrier to sync with other cpus */
 	smp_mb__after_atomic();
 
@@ -567,7 +574,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 
 crypto_fail:
 	nitrox_debugfs_exit(ndev);
-	clear_bit(NITROX_READY, &ndev->status);
+	atomic_set(&ndev->state, __NDEV_NOT_READY);
 	/* barrier to sync with other cpus */
 	smp_mb__after_atomic();
 pf_hw_fail:
@@ -602,11 +609,16 @@ static void nitrox_remove(struct pci_dev *pdev)
 	dev_info(DEV(ndev), "Removing Device %x:%x\n",
 		 ndev->hw.vendor_id, ndev->hw.device_id);
 
-	clear_bit(NITROX_READY, &ndev->status);
+	atomic_set(&ndev->state, __NDEV_NOT_READY);
 	/* barrier to sync with other cpus */
 	smp_mb__after_atomic();
 
 	nitrox_remove_from_devlist(ndev);
+
+#ifdef CONFIG_PCI_IOV
+	/* disable SR-IOV */
+	nitrox_sriov_configure(pdev, 0);
+#endif
 	nitrox_crypto_unregister();
 	nitrox_debugfs_exit(ndev);
 	nitrox_pf_sw_cleanup(ndev);
@@ -632,6 +644,9 @@ static struct pci_driver nitrox_driver = {
 	.probe = nitrox_probe,
 	.remove	= nitrox_remove,
 	.shutdown = nitrox_shutdown,
+#ifdef CONFIG_PCI_IOV
+	.sriov_configure = nitrox_sriov_configure,
+#endif
 };
 
 module_pci_driver(nitrox_driver);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_sriov.c b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
new file mode 100644
index 000000000000..453d920fbd69
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/pci.h>
+#include <linux/delay.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_hal.h"
+#include "nitrox_common.h"
+
+static inline bool num_vfs_valid(int num_vfs)
+{
+	bool valid = false;
+
+	switch (num_vfs) {
+	case 16:
+	case 32:
+	case 64:
+	case 128:
+		valid = true;
+		break;
+	}
+
+	return valid;
+}
+
+static inline enum vf_mode num_vfs_to_mode(int num_vfs)
+{
+	enum vf_mode mode = 0;
+
+	switch (num_vfs) {
+	case 0:
+		mode = __NDEV_MODE_PF;
+		break;
+	case 16:
+		mode = __NDEV_MODE_VF16;
+		break;
+	case 32:
+		mode = __NDEV_MODE_VF32;
+		break;
+	case 64:
+		mode = __NDEV_MODE_VF64;
+		break;
+	case 128:
+		mode = __NDEV_MODE_VF128;
+		break;
+	}
+
+	return mode;
+}
+
+static void pf_sriov_cleanup(struct nitrox_device *ndev)
+{
+	 /* PF has no queues in SR-IOV mode */
+	atomic_set(&ndev->state, __NDEV_NOT_READY);
+	/* unregister crypto algorithms */
+	nitrox_crypto_unregister();
+
+	/* cleanup PF resources */
+	nitrox_pf_cleanup_isr(ndev);
+	nitrox_common_sw_cleanup(ndev);
+}
+
+static int pf_sriov_init(struct nitrox_device *ndev)
+{
+	int err;
+
+	/* allocate resources for PF */
+	err = nitrox_common_sw_init(ndev);
+	if (err)
+		return err;
+
+	err = nitrox_pf_init_isr(ndev);
+	if (err) {
+		nitrox_common_sw_cleanup(ndev);
+		return err;
+	}
+
+	/* configure the packet queues */
+	nitrox_config_pkt_input_rings(ndev);
+	nitrox_config_pkt_solicit_ports(ndev);
+
+	/* set device to ready state */
+	atomic_set(&ndev->state, __NDEV_READY);
+
+	/* register crypto algorithms */
+	return nitrox_crypto_register();
+}
+
+static int nitrox_sriov_enable(struct pci_dev *pdev, int num_vfs)
+{
+	struct nitrox_device *ndev = pci_get_drvdata(pdev);
+	int err;
+
+	if (!num_vfs_valid(num_vfs)) {
+		dev_err(DEV(ndev), "Invalid num_vfs %d\n", num_vfs);
+		return -EINVAL;
+	}
+
+	if (pci_num_vf(pdev) == num_vfs)
+		return num_vfs;
+
+	err = pci_enable_sriov(pdev, num_vfs);
+	if (err) {
+		dev_err(DEV(ndev), "failed to enable PCI sriov %d\n", err);
+		return err;
+	}
+	dev_info(DEV(ndev), "Enabled VF(s) %d\n", num_vfs);
+
+	ndev->num_vfs = num_vfs;
+	ndev->mode = num_vfs_to_mode(num_vfs);
+	/* set bit in flags */
+	set_bit(__NDEV_SRIOV_BIT, &ndev->flags);
+
+	/* cleanup PF resources */
+	pf_sriov_cleanup(ndev);
+
+	config_nps_core_vfcfg_mode(ndev, ndev->mode);
+
+	return num_vfs;
+}
+
+static int nitrox_sriov_disable(struct pci_dev *pdev)
+{
+	struct nitrox_device *ndev = pci_get_drvdata(pdev);
+
+	if (!test_bit(__NDEV_SRIOV_BIT, &ndev->flags))
+		return 0;
+
+	if (pci_vfs_assigned(pdev)) {
+		dev_warn(DEV(ndev), "VFs are attached to VM. Can't disable SR-IOV\n");
+		return -EPERM;
+	}
+	pci_disable_sriov(pdev);
+	/* clear bit in flags */
+	clear_bit(__NDEV_SRIOV_BIT, &ndev->flags);
+
+	ndev->num_vfs = 0;
+	ndev->mode = __NDEV_MODE_PF;
+
+	config_nps_core_vfcfg_mode(ndev, ndev->mode);
+
+	return pf_sriov_init(ndev);
+}
+
+int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	if (!num_vfs)
+		return nitrox_sriov_disable(pdev);
+
+	return nitrox_sriov_enable(pdev, num_vfs);
+}
-- 
2.17.1
