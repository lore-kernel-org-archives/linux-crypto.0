From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] crypto: cavium/cptpf: switch to pci_alloc_irq_vectors
Date: Wed, 15 Feb 2017 08:18:42 +0100
Message-ID: <20170215071843.30108-3-hch@lst.de>
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
the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/crypto/cavium/cpt/cptpf.h      |  5 ---
 drivers/crypto/cavium/cpt/cptpf_main.c | 58 ++++++----------------------------
 2 files changed, 10 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf.h b/drivers/crypto/cavium/cpt/cptpf.h
index 8a2a8e538da4..c0556c5f63c9 100644
--- a/drivers/crypto/cavium/cpt/cptpf.h
+++ b/drivers/crypto/cavium/cpt/cptpf.h
@@ -51,11 +51,6 @@ struct cpt_device {
 	struct cpt_vf_info vfinfo[CPT_MAX_VF_NUM]; /* Per VF info */
 
 	void __iomem *reg_base; /* Register start address */
-	/* MSI-X */
-	u8 num_vec;
-	bool msix_enabled;
-	struct msix_entry msix_entries[CPT_PF_MSIX_VECTORS];
-	bool irq_allocated[CPT_PF_MSIX_VECTORS];
 	struct pci_dev *pdev; /* pci device handle */
 
 	struct microcode mcode[CPT_MAX_CORE_GROUPS];
diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 682d57a11a75..4119c40e7c4b 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -332,26 +332,6 @@ static int cpt_ucode_load(struct cpt_device *cpt)
 	return ret;
 }
 
-static int cpt_enable_msix(struct cpt_device *cpt)
-{
-	int i, ret;
-
-	cpt->num_vec = CPT_PF_MSIX_VECTORS;
-
-	for (i = 0; i < cpt->num_vec; i++)
-		cpt->msix_entries[i].entry = i;
-
-	ret = pci_enable_msix(cpt->pdev, cpt->msix_entries, cpt->num_vec);
-	if (ret) {
-		dev_err(&cpt->pdev->dev, "Request for #%d msix vectors failed\n",
-			cpt->num_vec);
-		return ret;
-	}
-
-	cpt->msix_enabled = 1;
-	return 0;
-}
-
 static irqreturn_t cpt_mbx0_intr_handler(int irq, void *cpt_irq)
 {
 	struct cpt_device *cpt = (struct cpt_device *)cpt_irq;
@@ -361,26 +341,6 @@ static irqreturn_t cpt_mbx0_intr_handler(int irq, void *cpt_irq)
 	return IRQ_HANDLED;
 }
 
-static void cpt_disable_msix(struct cpt_device *cpt)
-{
-	if (cpt->msix_enabled) {
-		pci_disable_msix(cpt->pdev);
-		cpt->msix_enabled = 0;
-		cpt->num_vec = 0;
-	}
-}
-
-static void cpt_free_all_interrupts(struct cpt_device *cpt)
-{
-	int irq;
-
-	for (irq = 0; irq < cpt->num_vec; irq++) {
-		if (cpt->irq_allocated[irq])
-			free_irq(cpt->msix_entries[irq].vector, cpt);
-		cpt->irq_allocated[irq] = false;
-	}
-}
-
 static void cpt_reset(struct cpt_device *cpt)
 {
 	cpt_write_csr64(cpt->reg_base, CPTX_PF_RESET(0), 1);
@@ -506,32 +466,34 @@ static int cpt_register_interrupts(struct cpt_device *cpt)
 	struct device *dev = &cpt->pdev->dev;
 
 	/* Enable MSI-X */
-	ret = cpt_enable_msix(cpt);
-	if (ret)
+	ret = pci_alloc_irq_vectors(cpt->pdev, CPT_PF_MSIX_VECTORS,
+			CPT_PF_MSIX_VECTORS, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(&cpt->pdev->dev, "Request for #%d msix vectors failed\n",
+			CPT_PF_MSIX_VECTORS);
 		return ret;
+	}
 
 	/* Register mailbox interrupt handlers */
-	ret = request_irq(cpt->msix_entries[CPT_PF_INT_VEC_E_MBOXX(0)].vector,
+	ret = request_irq(pci_irq_vector(cpt->pdev, CPT_PF_INT_VEC_E_MBOXX(0)),
 			  cpt_mbx0_intr_handler, 0, "CPT Mbox0", cpt);
 	if (ret)
 		goto fail;
 
-	cpt->irq_allocated[CPT_PF_INT_VEC_E_MBOXX(0)] = true;
-
 	/* Enable mailbox interrupt */
 	cpt_enable_mbox_interrupts(cpt);
 	return 0;
 
 fail:
 	dev_err(dev, "Request irq failed\n");
-	cpt_free_all_interrupts(cpt);
+	pci_disable_msix(cpt->pdev);
 	return ret;
 }
 
 static void cpt_unregister_interrupts(struct cpt_device *cpt)
 {
-	cpt_free_all_interrupts(cpt);
-	cpt_disable_msix(cpt);
+	free_irq(pci_irq_vector(cpt->pdev, CPT_PF_INT_VEC_E_MBOXX(0)), cpt);
+	pci_disable_msix(cpt->pdev);
 }
 
 static int cpt_sriov_init(struct cpt_device *cpt, int num_vfs)
-- 
2.11.0
