From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 2/2] crypto: qat - Enforce valid numa configuration
Date: Mon, 13 Oct 2014 18:24:32 -0700
Message-ID: <20141014012432.742.24559.stgit@tstruk-mobl1>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: prarit@redhat.com, bruce.w.allan@intel.com, qat-linux@intel.com,
	naleksan@redhat.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaJNB0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Oct 2014 21:26:37 -0400
In-Reply-To: <20141014012251.742.5500.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In a system with NUMA configuration we want to enforce that the accelerator is
connected to a node with memory to avoid cross QPI memory transaction.
Otherwise there is no point in using the accelerator as the encryption in
software will be faster.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
 drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
 drivers/crypto/qat/qat_common/qat_algs.c          |    5 ++-
 drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
 7 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 9282381..fe7b3f0 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -198,8 +198,7 @@ struct adf_accel_dev {
 	struct dentry *debugfs_dir;
 	struct list_head list;
 	struct module *owner;
-	uint8_t accel_id;
-	uint8_t numa_node;
 	struct adf_accel_pci accel_pci_dev;
+	uint8_t accel_id;
 } __packed;
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 5f3fa45..9dd2cb7 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -419,9 +419,10 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 		WRITE_CSR_RING_BASE(csr_addr, bank_num, i, 0);
 		ring = &bank->rings[i];
 		if (hw_data->tx_rings_mask & (1 << i)) {
-			ring->inflights = kzalloc_node(sizeof(atomic_t),
-						       GFP_KERNEL,
-						       accel_dev->numa_node);
+			ring->inflights =
+				kzalloc_node(sizeof(atomic_t),
+					     GFP_KERNEL,
+					     dev_to_node(&GET_DEV(accel_dev)));
 			if (!ring->inflights)
 				goto err;
 		} else {
@@ -469,13 +470,14 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 	int i, ret;
 
 	etr_data = kzalloc_node(sizeof(*etr_data), GFP_KERNEL,
-				accel_dev->numa_node);
+				dev_to_node(&GET_DEV(accel_dev)));
 	if (!etr_data)
 		return -ENOMEM;
 
 	num_banks = GET_MAX_BANKS(accel_dev);
 	size = num_banks * sizeof(struct adf_etr_bank_data);
-	etr_data->banks = kzalloc_node(size, GFP_KERNEL, accel_dev->numa_node);
+	etr_data->banks = kzalloc_node(size, GFP_KERNEL,
+				       dev_to_node(&GET_DEV(accel_dev)));
 	if (!etr_data->banks) {
 		ret = -ENOMEM;
 		goto err_bank;
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index bd4bd27..7893a8b 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -599,7 +599,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kmalloc_node(sz, GFP_ATOMIC, inst->accel_dev->numa_node);
+	bufl = kmalloc_node(sz, GFP_ATOMIC,
+			    dev_to_node(&GET_DEV(inst->accel_dev)));
 	if (unlikely(!bufl))
 		return -ENOMEM;
 
@@ -645,7 +646,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		struct qat_alg_buf *bufers;
 
 		buflout = kmalloc_node(sz, GFP_ATOMIC,
-				       inst->accel_dev->numa_node);
+				       dev_to_node(&GET_DEV(inst->accel_dev)));
 		if (unlikely(!buflout))
 			goto err;
 		bloutp = dma_map_single(dev, buflout, sz, DMA_TO_DEVICE);
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 0d59bcb..828f2a6 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -109,12 +109,14 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 
 	list_for_each(itr, adf_devmgr_get_head()) {
 		accel_dev = list_entry(itr, struct adf_accel_dev, list);
-		if (accel_dev->numa_node == node && adf_dev_started(accel_dev))
+		if ((node == dev_to_node(&GET_DEV(accel_dev)) ||
+			dev_to_node(&GET_DEV(accel_dev)) < 0)
+				&& adf_dev_started(accel_dev))
 			break;
 		accel_dev = NULL;
 	}
 	if (!accel_dev) {
-		pr_err("QAT: Could not find device on give node\n");
+		pr_err("QAT: Could not find device on node %d\n", node);
 		accel_dev = adf_devmgr_get_first();
 	}
 	if (!accel_dev || !adf_dev_started(accel_dev))
@@ -164,7 +166,7 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 
 	for (i = 0; i < num_inst; i++) {
 		inst = kzalloc_node(sizeof(*inst), GFP_KERNEL,
-				    accel_dev->numa_node);
+				    dev_to_node(&GET_DEV(accel_dev)));
 		if (!inst)
 			goto err;
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
index 978d6c5..53c491b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
@@ -108,7 +108,7 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 	uint64_t reg_val;
 
 	admin = kzalloc_node(sizeof(*accel_dev->admin), GFP_KERNEL,
-			     accel_dev->numa_node);
+			     dev_to_node(&GET_DEV(accel_dev)));
 	if (!admin)
 		return -ENOMEM;
 	admin->virt_addr = dma_zalloc_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 0d0435a..948f66b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -119,21 +119,6 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	kfree(accel_dev);
 }
 
-static uint8_t adf_get_dev_node_id(struct pci_dev *pdev)
-{
-	unsigned int bus_per_cpu = 0;
-	struct cpuinfo_x86 *c = &cpu_data(num_online_cpus() - 1);
-
-	if (!c->phys_proc_id)
-		return 0;
-
-	bus_per_cpu = 256 / (c->phys_proc_id + 1);
-
-	if (bus_per_cpu != 0)
-		return pdev->bus->number / bus_per_cpu;
-	return 0;
-}
-
 static int qat_dev_start(struct adf_accel_dev *accel_dev)
 {
 	int cpus = num_online_cpus();
@@ -235,7 +220,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	void __iomem *pmisc_bar_addr = NULL;
 	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
-	uint8_t node;
 	int ret;
 
 	switch (ent->device) {
@@ -246,12 +230,19 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	node = adf_get_dev_node_id(pdev);
-	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL, node);
+	if (num_possible_nodes() > 1 && dev_to_node(&pdev->dev) < 0) {
+		/* If the accelerator is connected to a node with no memory
+		 * there is no point in using the accelerator since the remote
+		 * memory transaction will be very slow. */
+		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
+		return -EINVAL;
+	}
+
+	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL,
+			         dev_to_node(&pdev->dev));
 	if (!accel_dev)
 		return -ENOMEM;
 
-	accel_dev->numa_node = node;
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
 
 	/* Add accel device to accel table.
@@ -264,7 +255,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	accel_dev->owner = THIS_MODULE;
 	/* Allocate and configure device configuration structure */
-	hw_data = kzalloc_node(sizeof(*hw_data), GFP_KERNEL, node);
+	hw_data = kzalloc_node(sizeof(*hw_data), GFP_KERNEL,
+			       dev_to_node(&pdev->dev));
 	if (!hw_data) {
 		ret = -ENOMEM;
 		goto out_err;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index 67ec61e..d96ee21 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -168,7 +168,7 @@ static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
 	uint32_t msix_num_entries = hw_data->num_banks + 1;
 
 	entries = kzalloc_node(msix_num_entries * sizeof(*entries),
-			       GFP_KERNEL, accel_dev->numa_node);
+			       GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
 	if (!entries)
 		return -ENOMEM;
 
