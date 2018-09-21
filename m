From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 3/3] crypto: cavium/nitrox - updated debugfs information.
Date: Fri, 21 Sep 2018 17:08:02 +0530
Message-ID: <20180921113802.26475-3-Jampala.Srikanth@cavium.com>
References: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Updated debugfs to provide device partname and frequency etc.
New file "stats" shows the number of requests posted, dropped and
completed.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/Makefile         |   1 +
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 113 +++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_dev.h     |  13 ++
 drivers/crypto/cavium/nitrox/nitrox_main.c    | 129 ------------------
 4 files changed, 127 insertions(+), 129 deletions(-)
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_debugfs.c

diff --git a/drivers/crypto/cavium/nitrox/Makefile b/drivers/crypto/cavium/nitrox/Makefile
index 6fcda6b56f7e..e12954791673 100644
--- a/drivers/crypto/cavium/nitrox/Makefile
+++ b/drivers/crypto/cavium/nitrox/Makefile
@@ -9,3 +9,4 @@ n5pf-objs := nitrox_main.o \
 	nitrox_algs.o
 
 n5pf-$(CONFIG_PCI_IOV) += nitrox_sriov.o
+n5pf-$(CONFIG_DEBUG_FS) += nitrox_debugfs.o
diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
new file mode 100644
index 000000000000..2f1e74ea846e
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+
+#include "nitrox_csr.h"
+#include "nitrox_dev.h"
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
+static int device_show(struct seq_file *s, void *v)
+{
+	struct nitrox_device *ndev = s->private;
+
+	seq_printf(s, "NITROX [%d]\n", ndev->idx);
+	seq_printf(s, "  Part Name: %s\n", ndev->hw.partname);
+	seq_printf(s, "  Frequency: %d MHz\n", ndev->hw.freq);
+	seq_printf(s, "  Device ID: 0x%0x\n", ndev->hw.device_id);
+	seq_printf(s, "  Revision ID: 0x%0x\n", ndev->hw.revision_id);
+	seq_printf(s, "  Cores: [AE=%u  SE=%u  ZIP=%u]\n",
+		   ndev->hw.ae_cores, ndev->hw.se_cores, ndev->hw.zip_cores);
+
+	return 0;
+}
+
+static int nitrox_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, device_show, inode->i_private);
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
+static int stats_show(struct seq_file *s, void *v)
+{
+	struct nitrox_device *ndev = s->private;
+
+	seq_printf(s, "NITROX [%d] Request Statistics\n", ndev->idx);
+	seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
+	seq_printf(s, "  Completed: %lld\n",
+		   atomic64_read(&ndev->stats.completed));
+	seq_printf(s, "  Dropped: %lld\n", atomic64_read(&ndev->stats.dropped));
+
+	return 0;
+}
+
+static int nitrox_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stats_show, inode->i_private);
+}
+
+static const struct file_operations nitrox_stats_fops = {
+	.owner = THIS_MODULE,
+	.open = nitrox_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+void nitrox_debugfs_exit(struct nitrox_device *ndev)
+{
+	debugfs_remove_recursive(ndev->debugfs_dir);
+	ndev->debugfs_dir = NULL;
+}
+
+int nitrox_debugfs_init(struct nitrox_device *ndev)
+{
+	struct dentry *dir, *f;
+
+	dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	ndev->debugfs_dir = dir;
+	f = debugfs_create_file("firmware", 0400, dir, ndev, &firmware_fops);
+	if (!f)
+		goto err;
+	f = debugfs_create_file("device", 0400, dir, ndev, &nitrox_fops);
+	if (!f)
+		goto err;
+	f = debugfs_create_file("stats", 0400, dir, ndev, &nitrox_stats_fops);
+	if (!f)
+		goto err;
+
+	return 0;
+
+err:
+	nitrox_debugfs_exit(ndev);
+	return -ENODEV;
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index a1442006f256..abb5c8ac54e5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -218,4 +218,17 @@ static inline bool nitrox_ready(struct nitrox_device *ndev)
 	return atomic_read(&ndev->state) == __NDEV_READY;
 }
 
+#ifdef CONFIG_DEBUG_FS
+int nitrox_debugfs_init(struct nitrox_device *ndev);
+void nitrox_debugfs_exit(struct nitrox_device *ndev);
+#else
+static inline int nitrox_debugfs_init(struct nitrox_device *ndev)
+{
+	return 0;
+}
+
+static inline void nitrox_debugfs_exit(struct nitrox_device *ndev)
+{ }
+#endif
+
 #endif /* __NITROX_DEV_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 362e7217354c..5bd97cff1405 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -323,135 +323,6 @@ static int nitrox_pf_hw_init(struct nitrox_device *ndev)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_DEBUG_FS)
-static int registers_show(struct seq_file *s, void *v)
-{
-	struct nitrox_device *ndev = s->private;
-	u64 offset;
-
-	/* NPS DMA stats */
-	offset = NPS_STATS_PKT_DMA_RD_CNT;
-	seq_printf(s, "NPS_STATS_PKT_DMA_RD_CNT  0x%016llx\n",
-		   nitrox_read_csr(ndev, offset));
-	offset = NPS_STATS_PKT_DMA_WR_CNT;
-	seq_printf(s, "NPS_STATS_PKT_DMA_WR_CNT  0x%016llx\n",
-		   nitrox_read_csr(ndev, offset));
-
-	/* BMI/BMO stats */
-	offset = BMI_NPS_PKT_CNT;
-	seq_printf(s, "BMI_NPS_PKT_CNT  0x%016llx\n",
-		   nitrox_read_csr(ndev, offset));
-	offset = BMO_NPS_SLC_PKT_CNT;
-	seq_printf(s, "BMO_NPS_PKT_CNT  0x%016llx\n",
-		   nitrox_read_csr(ndev, offset));
-
-	return 0;
-}
-
-static int registers_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, registers_show, inode->i_private);
-}
-
-static const struct file_operations register_fops = {
-	.owner = THIS_MODULE,
-	.open = registers_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int firmware_show(struct seq_file *s, void *v)
-{
-	struct nitrox_device *ndev = s->private;
-
-	seq_printf(s, "Version: %s\n", ndev->hw.fw_name);
-	return 0;
-}
-
-static int firmware_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, firmware_show, inode->i_private);
-}
-
-static const struct file_operations firmware_fops = {
-	.owner = THIS_MODULE,
-	.open = firmware_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int nitrox_show(struct seq_file *s, void *v)
-{
-	struct nitrox_device *ndev = s->private;
-
-	seq_printf(s, "NITROX-5 [idx: %d]\n", ndev->idx);
-	seq_printf(s, "  Revision ID: 0x%0x\n", ndev->hw.revision_id);
-	seq_printf(s, "  Cores [AE: %u  SE: %u]\n",
-		   ndev->hw.ae_cores, ndev->hw.se_cores);
-	seq_printf(s, "  Number of Queues: %u\n", ndev->nr_queues);
-	seq_printf(s, "  Queue length: %u\n", ndev->qlen);
-	seq_printf(s, "  Node: %u\n", ndev->node);
-
-	return 0;
-}
-
-static int nitrox_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nitrox_show, inode->i_private);
-}
-
-static const struct file_operations nitrox_fops = {
-	.owner = THIS_MODULE,
-	.open = nitrox_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static void nitrox_debugfs_exit(struct nitrox_device *ndev)
-{
-	debugfs_remove_recursive(ndev->debugfs_dir);
-	ndev->debugfs_dir = NULL;
-}
-
-static int nitrox_debugfs_init(struct nitrox_device *ndev)
-{
-	struct dentry *dir, *f;
-
-	dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!dir)
-		return -ENOMEM;
-
-	ndev->debugfs_dir = dir;
-	f = debugfs_create_file("counters", 0400, dir, ndev, &register_fops);
-	if (!f)
-		goto err;
-	f = debugfs_create_file("firmware", 0400, dir, ndev, &firmware_fops);
-	if (!f)
-		goto err;
-	f = debugfs_create_file("nitrox", 0400, dir, ndev, &nitrox_fops);
-	if (!f)
-		goto err;
-
-	return 0;
-
-err:
-	nitrox_debugfs_exit(ndev);
-	return -ENODEV;
-}
-#else
-static int nitrox_debugfs_init(struct nitrox_device *ndev)
-{
-	return 0;
-}
-
-static void nitrox_debugfs_exit(struct nitrox_device *ndev)
-{
-}
-#endif
-
 /**
  * nitrox_probe - NITROX Initialization function.
  * @pdev: PCI device information struct
-- 
2.17.1
