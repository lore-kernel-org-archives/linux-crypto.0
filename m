From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] crypto: cavium/cptvf: switch to pci_alloc_irq_vectors
Date: Wed, 15 Feb 2017 08:18:43 +0100
Message-ID: <20170215071843.30108-4-hch@lst.de>
References: <20170215071843.30108-1-hch@lst.de>
Cc: David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170215071843.30108-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pci_enable_msix has been long deprecated, but this driver adds a new
instance.  Convert it to pci_alloc_irq_vectors and greatly simplify
the code, and make sure the prope code properly unwinds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/crypto/cavium/cpt/cptvf.h      |   3 -
 drivers/crypto/cavium/cpt/cptvf_main.c | 203 +++++++++++----------------------
 2 files changed, 65 insertions(+), 141 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf.h b/drivers/crypto/cavium/cpt/cptvf.h
index 1cc04aa611e4..0a835a07d4f2 100644
--- a/drivers/crypto/cavium/cpt/cptvf.h
+++ b/drivers/crypto/cavium/cpt/cptvf.h
@@ -107,9 +107,6 @@ struct cpt_vf {
 	void __iomem *reg_base; /* Register start address */
 	void *wqe_info;	/* BH worker info */
 	/* MSI-X */
-	bool msix_enabled;
-	struct msix_entry msix_entries[CPT_VF_MSIX_VECTORS];
-	bool irq_allocated[CPT_VF_MSIX_VECTORS];
 	cpumask_var_t affinity_mask[CPT_VF_MSIX_VECTORS];
 	/* Command and Pending queues */
 	u32 qsize;
diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 527bdc3c2969..aac2966ff8d9 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -357,48 +357,10 @@ static int cptvf_sw_init(struct cpt_vf *cptvf, u32 qlen, u32 nr_queues)
 	return ret;
 }
 
-static void cptvf_disable_msix(struct cpt_vf *cptvf)
+static void cptvf_free_irq_affinity(struct cpt_vf *cptvf, int vec)
 {
-	if (cptvf->msix_enabled) {
-		pci_disable_msix(cptvf->pdev);
-		cptvf->msix_enabled = 0;
-	}
-}
-
-static int cptvf_enable_msix(struct cpt_vf *cptvf)
-{
-	int i, ret;
-
-	for (i = 0; i < CPT_VF_MSIX_VECTORS; i++)
-		cptvf->msix_entries[i].entry = i;
-
-	ret = pci_enable_msix(cptvf->pdev, cptvf->msix_entries,
-			      CPT_VF_MSIX_VECTORS);
-	if (ret) {
-		dev_err(&cptvf->pdev->dev, "Request for #%d msix vectors failed\n",
-			CPT_VF_MSIX_VECTORS);
-		return ret;
-	}
-
-	cptvf->msix_enabled = 1;
-	/* Mark MSIX enabled */
-	cptvf->flags |= CPT_FLAG_MSIX_ENABLED;
-
-	return 0;
-}
-
-static void cptvf_free_all_interrupts(struct cpt_vf *cptvf)
-{
-	int irq;
-
-	for (irq = 0; irq < CPT_VF_MSIX_VECTORS; irq++) {
-		if (cptvf->irq_allocated[irq])
-			irq_set_affinity_hint(cptvf->msix_entries[irq].vector,
-					      NULL);
-		free_cpumask_var(cptvf->affinity_mask[irq]);
-		free_irq(cptvf->msix_entries[irq].vector, cptvf);
-		cptvf->irq_allocated[irq] = false;
-	}
+	irq_set_affinity_hint(pci_irq_vector(cptvf->pdev, vec), NULL);
+	free_cpumask_var(cptvf->affinity_mask[vec]);
 }
 
 static void cptvf_write_vq_ctl(struct cpt_vf *cptvf, bool val)
@@ -650,85 +612,23 @@ static irqreturn_t cptvf_done_intr_handler(int irq, void *cptvf_irq)
 	return IRQ_HANDLED;
 }
 
-static int cptvf_register_misc_intr(struct cpt_vf *cptvf)
-{
-	struct pci_dev *pdev = cptvf->pdev;
-	int ret;
-
-	/* Register misc interrupt handlers */
-	ret = request_irq(cptvf->msix_entries[CPT_VF_INT_VEC_E_MISC].vector,
-			  cptvf_misc_intr_handler, 0, "CPT VF misc intr",
-			  cptvf);
-	if (ret)
-		goto fail;
-
-	cptvf->irq_allocated[CPT_VF_INT_VEC_E_MISC] = true;
-
-	/* Enable mailbox interrupt */
-	cptvf_enable_mbox_interrupts(cptvf);
-	cptvf_enable_swerr_interrupts(cptvf);
-
-	return 0;
-
-fail:
-	dev_err(&pdev->dev, "Request misc irq failed");
-	cptvf_free_all_interrupts(cptvf);
-	return ret;
-}
-
-static int cptvf_register_done_intr(struct cpt_vf *cptvf)
-{
-	struct pci_dev *pdev = cptvf->pdev;
-	int ret;
-
-	/* Register DONE interrupt handlers */
-	ret = request_irq(cptvf->msix_entries[CPT_VF_INT_VEC_E_DONE].vector,
-			  cptvf_done_intr_handler, 0, "CPT VF done intr",
-			  cptvf);
-	if (ret)
-		goto fail;
-
-	cptvf->irq_allocated[CPT_VF_INT_VEC_E_DONE] = true;
-
-	/* Enable mailbox interrupt */
-	cptvf_enable_done_interrupts(cptvf);
-	return 0;
-
-fail:
-	dev_err(&pdev->dev, "Request done irq failed\n");
-	cptvf_free_all_interrupts(cptvf);
-	return ret;
-}
-
-static void cptvf_unregister_interrupts(struct cpt_vf *cptvf)
-{
-	cptvf_free_all_interrupts(cptvf);
-	cptvf_disable_msix(cptvf);
-}
-
-static void cptvf_set_irq_affinity(struct cpt_vf *cptvf)
+static void cptvf_set_irq_affinity(struct cpt_vf *cptvf, int vec)
 {
 	struct pci_dev *pdev = cptvf->pdev;
-	int vec, cpu;
-	int irqnum;
-
-	for (vec = 0; vec < CPT_VF_MSIX_VECTORS; vec++) {
-		if (!cptvf->irq_allocated[vec])
-			continue;
-
-		if (!zalloc_cpumask_var(&cptvf->affinity_mask[vec],
-					GFP_KERNEL)) {
-			dev_err(&pdev->dev, "Allocation failed for affinity_mask for VF %d",
-				cptvf->vfid);
-			return;
-		}
+	int cpu;
 
-		cpu = cptvf->vfid % num_online_cpus();
-		cpumask_set_cpu(cpumask_local_spread(cpu, cptvf->node),
-				cptvf->affinity_mask[vec]);
-		irqnum = cptvf->msix_entries[vec].vector;
-		irq_set_affinity_hint(irqnum, cptvf->affinity_mask[vec]);
+	if (!zalloc_cpumask_var(&cptvf->affinity_mask[vec],
+				GFP_KERNEL)) {
+		dev_err(&pdev->dev, "Allocation failed for affinity_mask for VF %d",
+			cptvf->vfid);
+		return;
 	}
+
+	cpu = cptvf->vfid % num_online_cpus();
+	cpumask_set_cpu(cpumask_local_spread(cpu, cptvf->node),
+			cptvf->affinity_mask[vec]);
+	irq_set_affinity_hint(pci_irq_vector(pdev, vec),
+			cptvf->affinity_mask[vec]);
 }
 
 static void cptvf_write_vq_saddr(struct cpt_vf *cptvf, u64 val)
@@ -809,22 +709,32 @@ static int cptvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	cptvf->node = dev_to_node(&pdev->dev);
-	/* Enable MSI-X */
-	err = cptvf_enable_msix(cptvf);
-	if (err) {
-		dev_err(dev, "cptvf_enable_msix() failed");
+	err = pci_alloc_irq_vectors(pdev, CPT_VF_MSIX_VECTORS,
+			CPT_VF_MSIX_VECTORS, PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(dev, "Request for #%d msix vectors failed\n",
+			CPT_VF_MSIX_VECTORS);
 		goto cptvf_err_release_regions;
 	}
 
-	/* Register mailbox interrupts */
-	cptvf_register_misc_intr(cptvf);
+	err = request_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_MISC),
+			  cptvf_misc_intr_handler, 0, "CPT VF misc intr",
+			  cptvf);
+	if (err) {
+		dev_err(dev, "Request misc irq failed");
+		goto cptvf_free_vectors;
+	}
+
+	/* Enable mailbox interrupt */
+	cptvf_enable_mbox_interrupts(cptvf);
+	cptvf_enable_swerr_interrupts(cptvf);
 
 	/* Check ready with PF */
 	/* Gets chip ID / device Id from PF if ready */
 	err = cptvf_check_pf_ready(cptvf);
 	if (err) {
 		dev_err(dev, "PF not responding to READY msg");
-		goto cptvf_err_release_regions;
+		goto cptvf_free_misc_irq;
 	}
 
 	/* CPT VF software resources initialization */
@@ -832,13 +742,13 @@ static int cptvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = cptvf_sw_init(cptvf, CPT_CMD_QLEN, CPT_NUM_QS_PER_VF);
 	if (err) {
 		dev_err(dev, "cptvf_sw_init() failed");
-		goto cptvf_err_release_regions;
+		goto cptvf_free_misc_irq;
 	}
 	/* Convey VQ LEN to PF */
 	err = cptvf_send_vq_size_msg(cptvf);
 	if (err) {
 		dev_err(dev, "PF not responding to QLEN msg");
-		goto cptvf_err_release_regions;
+		goto cptvf_free_misc_irq;
 	}
 
 	/* CPT VF device initialization */
@@ -848,37 +758,50 @@ static int cptvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = cptvf_send_vf_to_grp_msg(cptvf);
 	if (err) {
 		dev_err(dev, "PF not responding to VF_GRP msg");
-		goto cptvf_err_release_regions;
+		goto cptvf_free_misc_irq;
 	}
 
 	cptvf->priority = 1;
 	err = cptvf_send_vf_priority_msg(cptvf);
 	if (err) {
 		dev_err(dev, "PF not responding to VF_PRIO msg");
-		goto cptvf_err_release_regions;
+		goto cptvf_free_misc_irq;
+	}
+
+	err = request_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_DONE),
+			  cptvf_done_intr_handler, 0, "CPT VF done intr",
+			  cptvf);
+	if (err) {
+		dev_err(dev, "Request done irq failed\n");
+		goto cptvf_free_misc_irq;
 	}
-	/* Register DONE interrupts */
-	err = cptvf_register_done_intr(cptvf);
-	if (err)
-		goto cptvf_err_release_regions;
+
+	/* Enable mailbox interrupt */
+	cptvf_enable_done_interrupts(cptvf);
 
 	/* Set irq affinity masks */
-	cptvf_set_irq_affinity(cptvf);
-	/* Convey UP to PF */
+	cptvf_set_irq_affinity(cptvf, CPT_VF_INT_VEC_E_MISC);
+	cptvf_set_irq_affinity(cptvf, CPT_VF_INT_VEC_E_DONE);
+
 	err = cptvf_send_vf_up(cptvf);
 	if (err) {
 		dev_err(dev, "PF not responding to UP msg");
-		goto cptvf_up_fail;
+		goto cptvf_free_irq_affinity;
 	}
 	err = cvm_crypto_init(cptvf);
 	if (err) {
 		dev_err(dev, "Algorithm register failed\n");
-		goto cptvf_up_fail;
+		goto cptvf_free_irq_affinity;
 	}
 	return 0;
 
-cptvf_up_fail:
-	cptvf_unregister_interrupts(cptvf);
+cptvf_free_irq_affinity:
+	cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_DONE);
+	cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_MISC);
+cptvf_free_misc_irq:
+	free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_MISC), cptvf);
+cptvf_free_vectors:
+	pci_free_irq_vectors(cptvf->pdev);
 cptvf_err_release_regions:
 	pci_release_regions(pdev);
 cptvf_err_disable_device:
@@ -899,7 +822,11 @@ static void cptvf_remove(struct pci_dev *pdev)
 	if (cptvf_send_vf_down(cptvf)) {
 		dev_err(&pdev->dev, "PF not responding to DOWN msg");
 	} else {
-		cptvf_unregister_interrupts(cptvf);
+		cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_DONE);
+		cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_MISC);
+		free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_DONE), cptvf);
+		free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_MISC), cptvf);
+		pci_free_irq_vectors(cptvf->pdev);
 		cptvf_sw_cleanup(cptvf);
 		pci_set_drvdata(pdev, NULL);
 		pci_release_regions(pdev);
-- 
2.11.0
