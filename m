From: Omer Khaliq <okhaliq@caviumnetworks.com>
Subject: [PATCH 1/2] PCI/IOV: Add function to allow Function Dependency Link override.
Date: Fri, 19 Aug 2016 15:32:12 -0700
Message-ID: <1471645933-3643-2-git-send-email-okhaliq@caviumnetworks.com>
References: <1471645933-3643-1-git-send-email-okhaliq@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Omer Khaliq <okhaliq@caviumnetworks.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-arm-kernel@vger.kernel.org>,
        <bhelgaas@google.com>, <mpm@selenic.com>,
        <herbert@gondor.apana.org.au>, <Ananth.Jasty@cavium.com>,
        <david.daney@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471645933-3643-1-git-send-email-okhaliq@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: David Daney <david.daney@cavium.com>

Some hardware presents an incorrect SR-IOV Function Dependency Link,
add a function to allow this to be overridden in the PF driver for
such devices.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Omer Khaliq <okhaliq@caviumnetworks.com>
---
 drivers/pci/iov.c   | 14 ++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 2194b44..81f0672 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -640,6 +640,20 @@ int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 EXPORT_SYMBOL_GPL(pci_enable_sriov);
 
 /**
+ * pci_sriov_fdl_override - fix incorrect Function Dependency Link
+ * @dev: the PCI device
+ * @fdl: the corrected Function Dependency Link value
+ *
+ * For hardware presenting an incorrect Function Dependency Link in
+ * the SR-IOV Extended Capability, allow a driver to override it.
+ */
+void pci_sriov_fdl_override(struct pci_dev *dev, u8 fdl)
+{
+	dev->sriov->link = fdl;
+}
+EXPORT_SYMBOL_GPL(pci_sriov_fdl_override);
+
+/**
  * pci_disable_sriov - disable the SR-IOV capability
  * @dev: the PCI device
  */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2599a98..da8a5b3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1823,6 +1823,7 @@ int pci_num_vf(struct pci_dev *dev);
 int pci_vfs_assigned(struct pci_dev *dev);
 int pci_sriov_set_totalvfs(struct pci_dev *dev, u16 numvfs);
 int pci_sriov_get_totalvfs(struct pci_dev *dev);
+void pci_sriov_fdl_override(struct pci_dev *dev, u8 fdl);
 resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
 #else
 static inline int pci_iov_virtfn_bus(struct pci_dev *dev, int id)
-- 
1.9.1
