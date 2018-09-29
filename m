From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 4/4] crypto: cavium/nitrox - use pci_alloc_irq_vectors() while enabling MSI-X.
Date: Sat, 29 Sep 2018 13:49:10 +0530
Message-ID: <20180929081910.17652-4-Jampala.Srikanth@cavium.com>
References: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

replace pci_enable_msix_exact() with pci_alloc_irq_vectors(). get the
required vector count from pci_msix_vec_count().
use struct nitrox_q_vector as the argument to tasklets.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_common.h |   5 +-
 drivers/crypto/cavium/nitrox/nitrox_dev.h    |  44 +--
 drivers/crypto/cavium/nitrox/nitrox_isr.c    | 336 +++++++------------
 drivers/crypto/cavium/nitrox/nitrox_isr.h    |  10 +
 drivers/crypto/cavium/nitrox/nitrox_lib.c    |   4 +
 drivers/crypto/cavium/nitrox/nitrox_main.c   |   5 +-
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c |  16 +-
 drivers/crypto/cavium/nitrox/nitrox_sriov.c  |   5 +-
 8 files changed, 162 insertions(+), 263 deletions(-)
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_isr.h

diff --git a/drivers/crypto/cavium/nitrox/nitrox_common.h b/drivers/crypto/cavium/nitrox/nitrox_common.h
index 00ef931115da..863143a8336b 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_common.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_common.h
@@ -12,13 +12,10 @@ void crypto_free_context(void *ctx);
 struct nitrox_device *nitrox_get_first_device(void);
 void nitrox_put_device(struct nitrox_device *ndev);
 
-void nitrox_pf_cleanup_isr(struct nitrox_device *ndev);
-int nitrox_pf_init_isr(struct nitrox_device *ndev);
-
 int nitrox_common_sw_init(struct nitrox_device *ndev);
 void nitrox_common_sw_cleanup(struct nitrox_device *ndev);
 
-void pkt_slc_resp_handler(unsigned long data);
+void pkt_slc_resp_tasklet(unsigned long data);
 int nitrox_process_se_request(struct nitrox_device *ndev,
 			      struct se_crypto_request *req,
 			      completion_t cb,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index 62fb75923bfe..283e252385fb 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -18,6 +18,7 @@
  * @response_head: submitted request list
  * @backlog_head: backlog queue
  * @dbell_csr_addr: doorbell register address for this queue
+ * @compl_cnt_csr_addr: completion count register address of the slc port
  * @base: command queue base address
  * @dma: dma address of the base
  * @pending_count: request pending at device
@@ -39,6 +40,7 @@ struct nitrox_cmdq {
 	struct list_head backlog_head;
 
 	u8 __iomem *dbell_csr_addr;
+	u8 __iomem *compl_cnt_csr_addr;
 	u8 *base;
 	dma_addr_t dma;
 
@@ -88,30 +90,17 @@ struct nitrox_stats {
 	atomic64_t dropped;
 };
 
-#define MAX_MSIX_VECTOR_NAME	20
-/**
- * vectors for queues (64 AE, 64 SE and 64 ZIP) and
- * error condition/mailbox.
- */
-#define MAX_MSIX_VECTORS	192
-
-struct nitrox_msix {
-	struct msix_entry *entries;
-	char **names;
-	DECLARE_BITMAP(irqs, MAX_MSIX_VECTORS);
-	u32 nr_entries;
-};
-
-struct bh_data {
-	/* slc port completion count address */
-	u8 __iomem *completion_cnt_csr_addr;
-
-	struct nitrox_cmdq *cmdq;
-	struct tasklet_struct resp_handler;
-};
-
-struct nitrox_bh {
-	struct bh_data *slc;
+#define IRQ_NAMESZ	32
+
+struct nitrox_q_vector {
+	char name[IRQ_NAMESZ];
+	bool valid;
+	int ring;
+	struct tasklet_struct resp_tasklet;
+	union {
+		struct nitrox_cmdq *cmdq;
+		struct nitrox_device *ndev;
+	};
 };
 
 /*
@@ -160,8 +149,7 @@ enum vf_mode {
  * @mode: Device mode PF/VF
  * @ctx_pool: DMA pool for crypto context
  * @pkt_inq: Packet input rings
- * @msix: MSI-X information
- * @bh: post processing work
+ * @qvec: MSI-X queue vectors information
  * @hw: hardware information
  * @debugfs_dir: debugfs directory
  */
@@ -186,8 +174,8 @@ struct nitrox_device {
 	struct dma_pool *ctx_pool;
 	struct nitrox_cmdq *pkt_inq;
 
-	struct nitrox_msix msix;
-	struct nitrox_bh bh;
+	struct nitrox_q_vector *qvec;
+	int num_vecs;
 
 	struct nitrox_stats stats;
 	struct nitrox_hw hw;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index baeacacbddbe..88a77b8fb3fb 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -8,8 +8,14 @@
 #include "nitrox_common.h"
 #include "nitrox_hal.h"
 
+/**
+ * One vector for each type of ring
+ *  - NPS packet ring, AQMQ ring and ZQMQ ring
+ */
 #define NR_RING_VECTORS 3
-#define NPS_CORE_INT_ACTIVE_ENTRY 192
+/* base entry for packet ring/port */
+#define PKT_RING_MSIX_BASE 0
+#define NON_RING_MSIX_BASE 192
 
 /**
  * nps_pkt_slc_isr - IRQ handler for NPS solicit port
@@ -18,13 +24,14 @@
  */
 static irqreturn_t nps_pkt_slc_isr(int irq, void *data)
 {
-	struct bh_data *slc = data;
-	union nps_pkt_slc_cnts pkt_slc_cnts;
+	struct nitrox_q_vector *qvec = data;
+	union nps_pkt_slc_cnts slc_cnts;
+	struct nitrox_cmdq *cmdq = qvec->cmdq;
 
-	pkt_slc_cnts.value = readq(slc->completion_cnt_csr_addr);
+	slc_cnts.value = readq(cmdq->compl_cnt_csr_addr);
 	/* New packet on SLC output port */
-	if (pkt_slc_cnts.s.slc_int)
-		tasklet_hi_schedule(&slc->resp_handler);
+	if (slc_cnts.s.slc_int)
+		tasklet_hi_schedule(&qvec->resp_tasklet);
 
 	return IRQ_HANDLED;
 }
@@ -191,165 +198,92 @@ static void clear_bmi_err_intr(struct nitrox_device *ndev)
 	dev_err_ratelimited(DEV(ndev), "BMI_INT  0x%016llx\n", value);
 }
 
+static void nps_core_int_tasklet(unsigned long data)
+{
+	struct nitrox_q_vector *qvec = (void *)(uintptr_t)(data);
+	struct nitrox_device *ndev = qvec->ndev;
+
+	/* if pf mode do queue recovery */
+	if (ndev->mode == __NDEV_MODE_PF) {
+	} else {
+		/**
+		 * if VF(s) enabled communicate the error information
+		 * to VF(s)
+		 */
+	}
+}
+
 /**
- * clear_nps_core_int_active - clear NPS_CORE_INT_ACTIVE interrupts
- * @ndev: NITROX device
+ * nps_core_int_isr - interrupt handler for NITROX errors and
+ *   mailbox communication
  */
-static void clear_nps_core_int_active(struct nitrox_device *ndev)
+static irqreturn_t nps_core_int_isr(int irq, void *data)
 {
-	union nps_core_int_active core_int_active;
+	struct nitrox_device *ndev = data;
+	union nps_core_int_active core_int;
 
-	core_int_active.value = nitrox_read_csr(ndev, NPS_CORE_INT_ACTIVE);
+	core_int.value = nitrox_read_csr(ndev, NPS_CORE_INT_ACTIVE);
 
-	if (core_int_active.s.nps_core)
+	if (core_int.s.nps_core)
 		clear_nps_core_err_intr(ndev);
 
-	if (core_int_active.s.nps_pkt)
+	if (core_int.s.nps_pkt)
 		clear_nps_pkt_err_intr(ndev);
 
-	if (core_int_active.s.pom)
+	if (core_int.s.pom)
 		clear_pom_err_intr(ndev);
 
-	if (core_int_active.s.pem)
+	if (core_int.s.pem)
 		clear_pem_err_intr(ndev);
 
-	if (core_int_active.s.lbc)
+	if (core_int.s.lbc)
 		clear_lbc_err_intr(ndev);
 
-	if (core_int_active.s.efl)
+	if (core_int.s.efl)
 		clear_efl_err_intr(ndev);
 
-	if (core_int_active.s.bmi)
+	if (core_int.s.bmi)
 		clear_bmi_err_intr(ndev);
 
 	/* If more work callback the ISR, set resend */
-	core_int_active.s.resend = 1;
-	nitrox_write_csr(ndev, NPS_CORE_INT_ACTIVE, core_int_active.value);
-}
-
-static irqreturn_t nps_core_int_isr(int irq, void *data)
-{
-	struct nitrox_device *ndev = data;
-
-	clear_nps_core_int_active(ndev);
+	core_int.s.resend = 1;
+	nitrox_write_csr(ndev, NPS_CORE_INT_ACTIVE, core_int.value);
 
 	return IRQ_HANDLED;
 }
 
-static int nitrox_enable_msix(struct nitrox_device *ndev)
+void nitrox_unregister_interrupts(struct nitrox_device *ndev)
 {
-	struct msix_entry *entries;
-	char **names;
-	int i, nr_entries, ret;
-
-	/*
-	 * PF MSI-X vectors
-	 *
-	 * Entry 0: NPS PKT ring 0
-	 * Entry 1: AQMQ ring 0
-	 * Entry 2: ZQM ring 0
-	 * Entry 3: NPS PKT ring 1
-	 * Entry 4: AQMQ ring 1
-	 * Entry 5: ZQM ring 1
-	 * ....
-	 * Entry 192: NPS_CORE_INT_ACTIVE
-	 */
-	nr_entries = (ndev->nr_queues * NR_RING_VECTORS) + 1;
-	entries = kcalloc_node(nr_entries, sizeof(struct msix_entry),
-			       GFP_KERNEL, ndev->node);
-	if (!entries)
-		return -ENOMEM;
-
-	names = kcalloc(nr_entries, sizeof(char *), GFP_KERNEL);
-	if (!names) {
-		kfree(entries);
-		return -ENOMEM;
-	}
-
-	/* fill entires */
-	for (i = 0; i < (nr_entries - 1); i++)
-		entries[i].entry = i;
-
-	entries[i].entry = NPS_CORE_INT_ACTIVE_ENTRY;
-
-	for (i = 0; i < nr_entries; i++) {
-		*(names + i) = kzalloc(MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
-		if (!(*(names + i))) {
-			ret = -ENOMEM;
-			goto msix_fail;
-		}
-	}
-	ndev->msix.entries = entries;
-	ndev->msix.names = names;
-	ndev->msix.nr_entries = nr_entries;
-
-	ret = pci_enable_msix_exact(ndev->pdev, ndev->msix.entries,
-				    ndev->msix.nr_entries);
-	if (ret) {
-		dev_err(&ndev->pdev->dev, "Failed to enable MSI-X IRQ(s) %d\n",
-			ret);
-		goto msix_fail;
-	}
-	return 0;
-
-msix_fail:
-	for (i = 0; i < nr_entries; i++)
-		kfree(*(names + i));
-
-	kfree(entries);
-	kfree(names);
-	return ret;
-}
-
-static void nitrox_cleanup_pkt_slc_bh(struct nitrox_device *ndev)
-{
-	int i;
-
-	if (!ndev->bh.slc)
-		return;
-
-	for (i = 0; i < ndev->nr_queues; i++) {
-		struct bh_data *bh = &ndev->bh.slc[i];
-
-		tasklet_disable(&bh->resp_handler);
-		tasklet_kill(&bh->resp_handler);
-	}
-	kfree(ndev->bh.slc);
-	ndev->bh.slc = NULL;
-}
-
-static int nitrox_setup_pkt_slc_bh(struct nitrox_device *ndev)
-{
-	u32 size;
+	struct pci_dev *pdev = ndev->pdev;
 	int i;
 
-	size = ndev->nr_queues * sizeof(struct bh_data);
-	ndev->bh.slc = kzalloc(size, GFP_KERNEL);
-	if (!ndev->bh.slc)
-		return -ENOMEM;
+	for (i = 0; i < ndev->num_vecs; i++) {
+		struct nitrox_q_vector *qvec;
+		int vec;
 
-	for (i = 0; i < ndev->nr_queues; i++) {
-		struct bh_data *bh = &ndev->bh.slc[i];
-		u64 offset;
+		qvec = ndev->qvec + i;
+		if (!qvec->valid)
+			continue;
 
-		offset = NPS_PKT_SLC_CNTSX(i);
-		/* pre calculate completion count address */
-		bh->completion_cnt_csr_addr = NITROX_CSR_ADDR(ndev, offset);
-		bh->cmdq = &ndev->pkt_inq[i];
+		/* get the vector number */
+		vec = pci_irq_vector(pdev, i);
+		irq_set_affinity_hint(vec, NULL);
+		free_irq(vec, qvec);
 
-		tasklet_init(&bh->resp_handler, pkt_slc_resp_handler,
-			     (unsigned long)bh);
+		tasklet_disable(&qvec->resp_tasklet);
+		tasklet_kill(&qvec->resp_tasklet);
+		qvec->valid = false;
 	}
-
-	return 0;
+	kfree(ndev->qvec);
+	pci_free_irq_vectors(pdev);
 }
 
-static int nitrox_request_irqs(struct nitrox_device *ndev)
+int nitrox_register_interrupts(struct nitrox_device *ndev)
 {
 	struct pci_dev *pdev = ndev->pdev;
-	struct msix_entry *msix_ent = ndev->msix.entries;
-	int nr_ring_vectors, i = 0, ring, cpu, ret;
-	char *name;
+	struct nitrox_q_vector *qvec;
+	int nr_vecs, vec, cpu;
+	int ret, i;
 
 	/*
 	 * PF MSI-X vectors
@@ -358,112 +292,76 @@ static int nitrox_request_irqs(struct nitrox_device *ndev)
 	 * Entry 1: AQMQ ring 0
 	 * Entry 2: ZQM ring 0
 	 * Entry 3: NPS PKT ring 1
+	 * Entry 4: AQMQ ring 1
+	 * Entry 5: ZQM ring 1
 	 * ....
 	 * Entry 192: NPS_CORE_INT_ACTIVE
 	 */
-	nr_ring_vectors = ndev->nr_queues * NR_RING_VECTORS;
-
-	/* request irq for pkt ring/ports only */
-	while (i < nr_ring_vectors) {
-		name = *(ndev->msix.names + i);
-		ring = (i / NR_RING_VECTORS);
-		snprintf(name, MAX_MSIX_VECTOR_NAME, "n5(%d)-slc-ring%d",
-			 ndev->idx, ring);
+	nr_vecs = pci_msix_vec_count(pdev);
 
-		ret = request_irq(msix_ent[i].vector, nps_pkt_slc_isr, 0,
-				  name, &ndev->bh.slc[ring]);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to get irq %d for %s\n",
-				msix_ent[i].vector, name);
-			return ret;
-		}
-		cpu = ring % num_online_cpus();
-		irq_set_affinity_hint(msix_ent[i].vector, get_cpu_mask(cpu));
-
-		set_bit(i, ndev->msix.irqs);
-		i += NR_RING_VECTORS;
-	}
-
-	/* Request IRQ for NPS_CORE_INT_ACTIVE */
-	name = *(ndev->msix.names + i);
-	snprintf(name, MAX_MSIX_VECTOR_NAME, "n5(%d)-nps-core-int", ndev->idx);
-	ret = request_irq(msix_ent[i].vector, nps_core_int_isr, 0, name, ndev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to get irq %d for %s\n",
-			msix_ent[i].vector, name);
+	/* Enable MSI-X */
+	ret = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(DEV(ndev), "msix vectors %d alloc failed\n", nr_vecs);
 		return ret;
 	}
-	set_bit(i, ndev->msix.irqs);
+	ndev->num_vecs = nr_vecs;
 
-	return 0;
-}
-
-static void nitrox_disable_msix(struct nitrox_device *ndev)
-{
-	struct msix_entry *msix_ent = ndev->msix.entries;
-	char **names = ndev->msix.names;
-	int i = 0, ring, nr_ring_vectors;
-
-	nr_ring_vectors = ndev->msix.nr_entries - 1;
-
-	/* clear pkt ring irqs */
-	while (i < nr_ring_vectors) {
-		if (test_and_clear_bit(i, ndev->msix.irqs)) {
-			ring = (i / NR_RING_VECTORS);
-			irq_set_affinity_hint(msix_ent[i].vector, NULL);
-			free_irq(msix_ent[i].vector, &ndev->bh.slc[ring]);
-		}
-		i += NR_RING_VECTORS;
+	ndev->qvec = kcalloc(nr_vecs, sizeof(*qvec), GFP_KERNEL);
+	if (!ndev->qvec) {
+		pci_free_irq_vectors(pdev);
+		return -ENOMEM;
 	}
-	irq_set_affinity_hint(msix_ent[i].vector, NULL);
-	free_irq(msix_ent[i].vector, ndev);
-	clear_bit(i, ndev->msix.irqs);
 
-	kfree(ndev->msix.entries);
-	for (i = 0; i < ndev->msix.nr_entries; i++)
-		kfree(*(names + i));
+	/* request irqs for packet rings/ports */
+	for (i = PKT_RING_MSIX_BASE; i < (nr_vecs - 1); i += NR_RING_VECTORS) {
+		qvec = &ndev->qvec[i];
 
-	kfree(names);
-	pci_disable_msix(ndev->pdev);
-}
-
-/**
- * nitrox_pf_cleanup_isr: Cleanup PF MSI-X and IRQ
- * @ndev: NITROX device
- */
-void nitrox_pf_cleanup_isr(struct nitrox_device *ndev)
-{
-	nitrox_disable_msix(ndev);
-	nitrox_cleanup_pkt_slc_bh(ndev);
-}
+		qvec->ring = i / NR_RING_VECTORS;
+		if (qvec->ring >= ndev->nr_queues)
+			break;
 
-/**
- * nitrox_init_isr - Initialize PF MSI-X vectors and IRQ
- * @ndev: NITROX device
- *
- * Return: 0 on success, a negative value on failure.
- */
-int nitrox_pf_init_isr(struct nitrox_device *ndev)
-{
-	int err;
+		snprintf(qvec->name, IRQ_NAMESZ, "nitrox-pkt%d", qvec->ring);
+		/* get the vector number */
+		vec = pci_irq_vector(pdev, i);
+		ret = request_irq(vec, nps_pkt_slc_isr, 0, qvec->name, qvec);
+		if (ret) {
+			dev_err(DEV(ndev), "irq failed for pkt ring/port%d\n",
+				qvec->ring);
+			goto irq_fail;
+		}
+		cpu = qvec->ring % num_online_cpus();
+		irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-	err = nitrox_setup_pkt_slc_bh(ndev);
-	if (err)
-		return err;
+		tasklet_init(&qvec->resp_tasklet, pkt_slc_resp_tasklet,
+			     (unsigned long)qvec);
+		qvec->cmdq = &ndev->pkt_inq[qvec->ring];
+		qvec->valid = true;
+	}
 
-	err = nitrox_enable_msix(ndev);
-	if (err)
-		goto msix_fail;
+	/* request irqs for non ring vectors */
+	i = NON_RING_MSIX_BASE;
+	qvec = &ndev->qvec[i];
 
-	err = nitrox_request_irqs(ndev);
-	if (err)
+	snprintf(qvec->name, IRQ_NAMESZ, "nitrox-core-int%d", i);
+	/* get the vector number */
+	vec = pci_irq_vector(pdev, i);
+	ret = request_irq(vec, nps_core_int_isr, 0, qvec->name, qvec);
+	if (ret) {
+		dev_err(DEV(ndev), "irq failed for nitrox-core-int%d\n", i);
 		goto irq_fail;
+	}
+	cpu = num_online_cpus();
+	irq_set_affinity_hint(vec, get_cpu_mask(cpu));
+
+	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
+		     (unsigned long)qvec);
+	qvec->ndev = ndev;
+	qvec->valid = true;
 
 	return 0;
 
 irq_fail:
-	nitrox_disable_msix(ndev);
-msix_fail:
-	nitrox_cleanup_pkt_slc_bh(ndev);
-	return err;
+	nitrox_unregister_interrupts(ndev);
+	return ret;
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.h b/drivers/crypto/cavium/nitrox/nitrox_isr.h
new file mode 100644
index 000000000000..63418a6cc52c
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NITROX_ISR_H
+#define __NITROX_ISR_H
+
+#include "nitrox_dev.h"
+
+int nitrox_register_interrupts(struct nitrox_device *ndev);
+void nitrox_unregister_interrupts(struct nitrox_device *ndev);
+
+#endif /* __NITROX_ISR_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index ed08aa9380ee..2260efa42308 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -69,6 +69,7 @@ static void nitrox_cmdq_cleanup(struct nitrox_cmdq *cmdq)
 	nitrox_cmdq_reset(cmdq);
 
 	cmdq->dbell_csr_addr = NULL;
+	cmdq->compl_cnt_csr_addr = NULL;
 	cmdq->unalign_base = NULL;
 	cmdq->base = NULL;
 	cmdq->unalign_dma = 0;
@@ -112,6 +113,9 @@ static int nitrox_alloc_pktin_queues(struct nitrox_device *ndev)
 		/* packet input ring doorbell address */
 		offset = NPS_PKT_IN_INSTR_BAOFF_DBELLX(i);
 		cmdq->dbell_csr_addr = NITROX_CSR_ADDR(ndev, offset);
+		/* packet solicit port completion count address */
+		offset = NPS_PKT_SLC_CNTSX(i);
+		cmdq->compl_cnt_csr_addr = NITROX_CSR_ADDR(ndev, offset);
 
 		err = nitrox_cmdq_init(cmdq, PKTIN_Q_ALIGN_BYTES);
 		if (err)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 13436ca98cb5..6595c95af9f1 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -12,6 +12,7 @@
 #include "nitrox_common.h"
 #include "nitrox_csr.h"
 #include "nitrox_hal.h"
+#include "nitrox_isr.h"
 
 #define CNN55XX_DEV_ID	0x12
 #define MAX_PF_QUEUES	64
@@ -244,7 +245,7 @@ static int nitrox_pf_sw_init(struct nitrox_device *ndev)
 	if (err)
 		return err;
 
-	err = nitrox_pf_init_isr(ndev);
+	err = nitrox_register_interrupts(ndev);
 	if (err)
 		nitrox_common_sw_cleanup(ndev);
 
@@ -253,7 +254,7 @@ static int nitrox_pf_sw_init(struct nitrox_device *ndev)
 
 static void nitrox_pf_sw_cleanup(struct nitrox_device *ndev)
 {
-	nitrox_pf_cleanup_isr(ndev);
+	nitrox_unregister_interrupts(ndev);
 	nitrox_common_sw_cleanup(ndev);
 }
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index d606c7af4667..3987cd84c033 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -721,18 +721,18 @@ static void process_response_list(struct nitrox_cmdq *cmdq)
 }
 
 /**
- * pkt_slc_resp_handler - post processing of SE responses
+ * pkt_slc_resp_tasklet - post processing of SE responses
  */
-void pkt_slc_resp_handler(unsigned long data)
+void pkt_slc_resp_tasklet(unsigned long data)
 {
-	struct bh_data *bh = (void *)(uintptr_t)(data);
-	struct nitrox_cmdq *cmdq = bh->cmdq;
-	union nps_pkt_slc_cnts pkt_slc_cnts;
+	struct nitrox_q_vector *qvec = (void *)(uintptr_t)(data);
+	struct nitrox_cmdq *cmdq = qvec->cmdq;
+	union nps_pkt_slc_cnts slc_cnts;
 
 	/* read completion count */
-	pkt_slc_cnts.value = readq(bh->completion_cnt_csr_addr);
+	slc_cnts.value = readq(cmdq->compl_cnt_csr_addr);
 	/* resend the interrupt if more work to do */
-	pkt_slc_cnts.s.resend = 1;
+	slc_cnts.s.resend = 1;
 
 	process_response_list(cmdq);
 
@@ -740,7 +740,7 @@ void pkt_slc_resp_handler(unsigned long data)
 	 * clear the interrupt with resend bit enabled,
 	 * MSI-X interrupt generates if Completion count > Threshold
 	 */
-	writeq(pkt_slc_cnts.value, bh->completion_cnt_csr_addr);
+	writeq(slc_cnts.value, cmdq->compl_cnt_csr_addr);
 	/* order the writes */
 	mmiowb();
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_sriov.c b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
index 453d920fbd69..30c0aa874583 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_sriov.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
@@ -5,6 +5,7 @@
 #include "nitrox_dev.h"
 #include "nitrox_hal.h"
 #include "nitrox_common.h"
+#include "nitrox_isr.h"
 
 static inline bool num_vfs_valid(int num_vfs)
 {
@@ -55,7 +56,7 @@ static void pf_sriov_cleanup(struct nitrox_device *ndev)
 	nitrox_crypto_unregister();
 
 	/* cleanup PF resources */
-	nitrox_pf_cleanup_isr(ndev);
+	nitrox_unregister_interrupts(ndev);
 	nitrox_common_sw_cleanup(ndev);
 }
 
@@ -68,7 +69,7 @@ static int pf_sriov_init(struct nitrox_device *ndev)
 	if (err)
 		return err;
 
-	err = nitrox_pf_init_isr(ndev);
+	err = nitrox_register_interrupts(ndev);
 	if (err) {
 		nitrox_common_sw_cleanup(ndev);
 		return err;
-- 
2.17.1
