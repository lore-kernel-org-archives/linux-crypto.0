From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH v1 2/3] crypto: cavium - Add debugfs support in CNN55XX driver
Date: Wed, 10 May 2017 18:36:39 +0530
Message-ID: <20170510130640.5838-3-Jampala.Srikanth@cavium.com>
References: <20170510130640.5838-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, George.Cherian@cavium.com,
        Nidadavolu.Murthy@cavium.com, Sreerama.Gadam@cavium.com,
        Ram.Kumar@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510130640.5838-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add debugfs support in CNN55XX Physical Function driver.
Provides hardware counters and firmware information.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_csr.h  |   5 ++
 drivers/crypto/cavium/nitrox/nitrox_dev.h  |   3 +
 drivers/crypto/cavium/nitrox/nitrox_main.c | 139 +++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_csr.h b/drivers/crypto/cavium/nitrox/nitrox_csr.h
index 988a85d..32ebdeb 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_csr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_csr.h
@@ -42,6 +42,8 @@
 #define NPS_CORE_INT_ACTIVE	0x1000080
 #define NPS_CORE_INT		0x10000A0
 #define NPS_CORE_INT_ENA_W1S	0x10000B8
+#define NPS_STATS_PKT_DMA_RD_CNT	0x1000180
+#define NPS_STATS_PKT_DMA_WR_CNT	0x1000190
 
 /* NPS packet registers */
 #define NPS_PKT_INT				0x1040018
@@ -73,11 +75,13 @@
 #define POM_GRP_EXECMASKX(_i)	(0x11C1100 | ((_i) * 8))
 #define POM_INT		0x11C0000
 #define POM_PERF_CTL	0x11CC400
+#define POM_PERF_CNT	0x11CC408
 
 /* BMI registers */
 #define BMI_INT		0x1140000
 #define BMI_CTL		0x1140020
 #define BMI_INT_ENA_W1S	0x1140018
+#define BMI_NPS_PKT_CNT	0x1140070
 
 /* EFL registers */
 #define EFL_CORE_INT_ENA_W1SX(_i)		(0x1240018 + ((_i) * 0x400))
@@ -91,6 +95,7 @@
 
 /* BMO registers */
 #define BMO_CTL2		0x1180028
+#define BMO_NPS_SLC_PKT_CNT	0x1180078
 
 /* LBC registers */
 #define LBC_INT			0x1200000
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index ff6bb09..84c2341 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -134,6 +134,9 @@ struct nitrox_device {
 	struct nitrox_bh bh;
 
 	struct nitrox_hw hw;
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+	struct dentry *debugfs_dir;
+#endif
 };
 
 static inline u8 __iomem *nitrox_csr_addr(struct nitrox_device *ndev,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index ac3e9b3..432a21b 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -1,5 +1,6 @@
 #include <linux/aer.h>
 #include <linux/delay.h>
+#include <linux/debugfs.h>
 #include <linux/firmware.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -303,6 +304,139 @@ static int nitrox_pf_hw_init(struct nitrox_device *ndev)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+static int registers_show(struct seq_file *s, void *v)
+{
+	struct nitrox_device *ndev = s->private;
+	u64 offset;
+
+	/* NPS DMA stats */
+	offset = NPS_STATS_PKT_DMA_RD_CNT;
+	seq_printf(s, "NPS_STATS_PKT_DMA_RD_CNT  0x%016llx\n",
+		   nitrox_read_csr(ndev, offset));
+	offset = NPS_STATS_PKT_DMA_WR_CNT;
+	seq_printf(s, "NPS_STATS_PKT_DMA_WR_CNT  0x%016llx\n",
+		   nitrox_read_csr(ndev, offset));
+
+	/* BMI/BMO stats */
+	offset = BMI_NPS_PKT_CNT;
+	seq_printf(s, "BMI_NPS_PKT_CNT  0x%016llx\n",
+		   nitrox_read_csr(ndev, offset));
+	offset = BMO_NPS_SLC_PKT_CNT;
+	seq_printf(s, "BMO_NPS_PKT_CNT  0x%016llx\n",
+		   nitrox_read_csr(ndev, offset));
+
+	offset = POM_PERF_CNT;
+	seq_printf(s, "POM_PERF_CNT  0x%016llx\n",
+		   nitrox_read_csr(ndev, offset));
+
+	return 0;
+}
+
+static int registers_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, registers_show, inode->i_private);
+}
+
+static const struct file_operations register_fops = {
+	.owner = THIS_MODULE,
+	.open = registers_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int firmware_show(struct seq_file *s, void *v)
+{
+	struct nitrox_device *ndev = s->private;
+
+	seq_printf(s, "Version: %s\n", ndev->hw.fw_name);
+	return 0;
+}
+
+static int firmware_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, firmware_show, inode->i_private);
+}
+
+static const struct file_operations firmware_fops = {
+	.owner = THIS_MODULE,
+	.open = firmware_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int nitrox_show(struct seq_file *s, void *v)
+{
+	struct nitrox_device *ndev = s->private;
+
+	seq_printf(s, "NITROX-5 [idx: %d]\n", ndev->idx);
+	seq_printf(s, "  Revsion ID: 0x%0x\n", ndev->hw.revision_id);
+	seq_printf(s, "  Cores [AE: %u  SE: %u]\n",
+		   ndev->hw.ae_cores, ndev->hw.se_cores);
+	seq_printf(s, "  Number of Queues: %u\n", ndev->nr_queues);
+	seq_printf(s, "  Queue length: %u\n", ndev->qlen);
+	seq_printf(s, "  Node: %u\n", ndev->node);
+
+	return 0;
+}
+
+static int nitrox_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nitrox_show, inode->i_private);
+}
+
+static const struct file_operations nitrox_fops = {
+	.owner = THIS_MODULE,
+	.open = nitrox_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void nitrox_debugfs_exit(struct nitrox_device *ndev)
+{
+	debugfs_remove_recursive(ndev->debugfs_dir);
+	ndev->debugfs_dir = NULL;
+}
+
+static int nitrox_debugfs_init(struct nitrox_device *ndev)
+{
+	struct dentry *dir, *f;
+
+	dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	ndev->debugfs_dir = dir;
+	f = debugfs_create_file("counters", 0400, dir, ndev, &register_fops);
+	if (!f)
+		goto err;
+	f = debugfs_create_file("firmware", 0400, dir, ndev, &firmware_fops);
+	if (!f)
+		goto err;
+	f = debugfs_create_file("nitrox", 0400, dir, ndev, &nitrox_fops);
+	if (!f)
+		goto err;
+
+	return 0;
+
+err:
+	nitrox_debugfs_exit(ndev);
+	return -ENODEV;
+}
+#else
+static int nitrox_debugfs_init(struct nitrox_device *ndev)
+{
+	return 0;
+}
+
+static void nitrox_debugfs_exit(struct nitrox_device *ndev)
+{
+}
+#endif
+
 /**
  * nitrox_probe - NITROX Initialization function.
  * @pdev: PCI device information struct
@@ -386,6 +520,10 @@ static int nitrox_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto pf_hw_fail;
 
+	err = nitrox_debugfs_init(ndev);
+	if (err)
+		goto pf_hw_fail;
+
 	set_bit(NITROX_READY, &ndev->status);
 	/* barrier to sync with other cpus */
 	smp_mb__after_atomic();
@@ -426,6 +564,7 @@ static void nitrox_remove(struct pci_dev *pdev)
 	smp_mb__after_atomic();
 
 	nitrox_remove_from_devlist(ndev);
+	nitrox_debugfs_exit(ndev);
 	nitrox_pf_sw_cleanup(ndev);
 
 	iounmap(ndev->bar_addr);
-- 
2.9.3
