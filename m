Return-Path: <SRS0=qsBZ=OA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr690052.outbound.protection.outlook.com ([40.107.69.52]:62592
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbeKUU0T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Nov 2018 15:26:19 -0500
From: "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
Subject: [PATCH 1/1] crypto: cavium/nitrox - Enable interrups for PF in SR-IOV
 mode.
Date: Wed, 21 Nov 2018 09:52:24 +0000
Message-ID: <20181121095200.6036-1-Jampala.Srikanth@cavium.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable the available interrupt vectors for PF in SR-IOV Mode.
Only single vector entry 192 is valid of PF. This is used to
notify any hardware errors and mailbox messages from VF(s).

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_dev.h   | 15 +++-
 drivers/crypto/cavium/nitrox/nitrox_isr.c   | 84 ++++++++++++++++++++-
 drivers/crypto/cavium/nitrox/nitrox_isr.h   |  2 +
 drivers/crypto/cavium/nitrox/nitrox_sriov.c | 51 +++++++++++--
 4 files changed, 142 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cav=
ium/nitrox/nitrox_dev.h
index 283e252385fb..247df32f687c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -103,6 +103,16 @@ struct nitrox_q_vector {
 	};
 };
=20
+/**
+ * struct nitrox_iov - SR-IOV information
+ * @num_vfs: number of VF(s) enabled
+ * @msix: MSI-X for PF in SR-IOV case
+ */
+struct nitrox_iov {
+	int num_vfs;
+	struct msix_entry msix;
+};
+
 /*
  * NITROX Device states
  */
@@ -150,6 +160,9 @@ enum vf_mode {
  * @ctx_pool: DMA pool for crypto context
  * @pkt_inq: Packet input rings
  * @qvec: MSI-X queue vectors information
+ * @iov: SR-IOV informatin
+ * @num_vecs: number of MSI-X vectors
+ * @stats: request statistics
  * @hw: hardware information
  * @debugfs_dir: debugfs directory
  */
@@ -168,13 +181,13 @@ struct nitrox_device {
 	int node;
 	u16 qlen;
 	u16 nr_queues;
-	int num_vfs;
 	enum vf_mode mode;
=20
 	struct dma_pool *ctx_pool;
 	struct nitrox_cmdq *pkt_inq;
=20
 	struct nitrox_q_vector *qvec;
+	struct nitrox_iov iov;
 	int num_vecs;
=20
 	struct nitrox_stats stats;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cav=
ium/nitrox/nitrox_isr.c
index 88a77b8fb3fb..c5b797808680 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -13,6 +13,7 @@
  *  - NPS packet ring, AQMQ ring and ZQMQ ring
  */
 #define NR_RING_VECTORS 3
+#define NR_NON_RING_VECTORS 1
 /* base entry for packet ring/port */
 #define PKT_RING_MSIX_BASE 0
 #define NON_RING_MSIX_BASE 192
@@ -275,6 +276,7 @@ void nitrox_unregister_interrupts(struct nitrox_device =
*ndev)
 		qvec->valid =3D false;
 	}
 	kfree(ndev->qvec);
+	ndev->qvec =3D NULL;
 	pci_free_irq_vectors(pdev);
 }
=20
@@ -321,6 +323,7 @@ int nitrox_register_interrupts(struct nitrox_device *nd=
ev)
 		if (qvec->ring >=3D ndev->nr_queues)
 			break;
=20
+		qvec->cmdq =3D &ndev->pkt_inq[qvec->ring];
 		snprintf(qvec->name, IRQ_NAMESZ, "nitrox-pkt%d", qvec->ring);
 		/* get the vector number */
 		vec =3D pci_irq_vector(pdev, i);
@@ -335,13 +338,13 @@ int nitrox_register_interrupts(struct nitrox_device *=
ndev)
=20
 		tasklet_init(&qvec->resp_tasklet, pkt_slc_resp_tasklet,
 			     (unsigned long)qvec);
-		qvec->cmdq =3D &ndev->pkt_inq[qvec->ring];
 		qvec->valid =3D true;
 	}
=20
 	/* request irqs for non ring vectors */
 	i =3D NON_RING_MSIX_BASE;
 	qvec =3D &ndev->qvec[i];
+	qvec->ndev =3D ndev;
=20
 	snprintf(qvec->name, IRQ_NAMESZ, "nitrox-core-int%d", i);
 	/* get the vector number */
@@ -356,7 +359,6 @@ int nitrox_register_interrupts(struct nitrox_device *nd=
ev)
=20
 	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
 		     (unsigned long)qvec);
-	qvec->ndev =3D ndev;
 	qvec->valid =3D true;
=20
 	return 0;
@@ -365,3 +367,81 @@ int nitrox_register_interrupts(struct nitrox_device *n=
dev)
 	nitrox_unregister_interrupts(ndev);
 	return ret;
 }
+
+void nitrox_sriov_unregister_interrupts(struct nitrox_device *ndev)
+{
+	struct pci_dev *pdev =3D ndev->pdev;
+	int i;
+
+	for (i =3D 0; i < ndev->num_vecs; i++) {
+		struct nitrox_q_vector *qvec;
+		int vec;
+
+		qvec =3D ndev->qvec + i;
+		if (!qvec->valid)
+			continue;
+
+		vec =3D ndev->iov.msix.vector;
+		irq_set_affinity_hint(vec, NULL);
+		free_irq(vec, qvec);
+
+		tasklet_disable(&qvec->resp_tasklet);
+		tasklet_kill(&qvec->resp_tasklet);
+		qvec->valid =3D false;
+	}
+	kfree(ndev->qvec);
+	ndev->qvec =3D NULL;
+	pci_disable_msix(pdev);
+}
+
+int nitrox_sriov_register_interupts(struct nitrox_device *ndev)
+{
+	struct pci_dev *pdev =3D ndev->pdev;
+	struct nitrox_q_vector *qvec;
+	int vec, cpu;
+	int ret;
+
+	/**
+	 * only non ring vectors i.e Entry 192 is available
+	 * for PF in SR-IOV mode.
+	 */
+	ndev->iov.msix.entry =3D NON_RING_MSIX_BASE;
+	ret =3D pci_enable_msix_exact(pdev, &ndev->iov.msix, NR_NON_RING_VECTORS)=
;
+	if (ret) {
+		dev_err(DEV(ndev), "failed to allocate nps-core-int%d\n",
+			NON_RING_MSIX_BASE);
+		return ret;
+	}
+
+	qvec =3D kcalloc(NR_NON_RING_VECTORS, sizeof(*qvec), GFP_KERNEL);
+	if (!qvec) {
+		pci_disable_msix(pdev);
+		return -ENOMEM;
+	}
+	qvec->ndev =3D ndev;
+
+	ndev->qvec =3D qvec;
+	ndev->num_vecs =3D NR_NON_RING_VECTORS;
+	snprintf(qvec->name, IRQ_NAMESZ, "nitrox-core-int%d",
+		 NON_RING_MSIX_BASE);
+
+	vec =3D ndev->iov.msix.vector;
+	ret =3D request_irq(vec, nps_core_int_isr, 0, qvec->name, qvec);
+	if (ret) {
+		dev_err(DEV(ndev), "irq failed for nitrox-core-int%d\n",
+			NON_RING_MSIX_BASE);
+		goto iov_irq_fail;
+	}
+	cpu =3D num_online_cpus();
+	irq_set_affinity_hint(vec, get_cpu_mask(cpu));
+
+	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
+		     (unsigned long)qvec);
+	qvec->valid =3D true;
+
+	return 0;
+
+iov_irq_fail:
+	nitrox_sriov_unregister_interrupts(ndev);
+	return ret;
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.h b/drivers/crypto/cav=
ium/nitrox/nitrox_isr.h
index 63418a6cc52c..1062c9336c1f 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.h
@@ -6,5 +6,7 @@
=20
 int nitrox_register_interrupts(struct nitrox_device *ndev);
 void nitrox_unregister_interrupts(struct nitrox_device *ndev);
+int nitrox_sriov_register_interupts(struct nitrox_device *ndev);
+void nitrox_sriov_unregister_interrupts(struct nitrox_device *ndev);
=20
 #endif /* __NITROX_ISR_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_sriov.c b/drivers/crypto/c=
avium/nitrox/nitrox_sriov.c
index 30c0aa874583..7ba0cc5d6d02 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_sriov.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
@@ -7,6 +7,10 @@
 #include "nitrox_common.h"
 #include "nitrox_isr.h"
=20
+/**
+ * num_vfs_valid - validate VF count
+ * @num_vfs: number of VF(s)
+ */
 static inline bool num_vfs_valid(int num_vfs)
 {
 	bool valid =3D false;
@@ -48,7 +52,7 @@ static inline enum vf_mode num_vfs_to_mode(int num_vfs)
 	return mode;
 }
=20
-static void pf_sriov_cleanup(struct nitrox_device *ndev)
+static void nitrox_pf_cleanup(struct nitrox_device *ndev)
 {
 	 /* PF has no queues in SR-IOV mode */
 	atomic_set(&ndev->state, __NDEV_NOT_READY);
@@ -60,7 +64,11 @@ static void pf_sriov_cleanup(struct nitrox_device *ndev)
 	nitrox_common_sw_cleanup(ndev);
 }
=20
-static int pf_sriov_init(struct nitrox_device *ndev)
+/**
+ * nitrox_pf_reinit - re-initialize PF resources once SR-IOV is disabled
+ * @ndev: NITROX device
+ */
+static int nitrox_pf_reinit(struct nitrox_device *ndev)
 {
 	int err;
=20
@@ -86,6 +94,18 @@ static int pf_sriov_init(struct nitrox_device *ndev)
 	return nitrox_crypto_register();
 }
=20
+static int nitrox_sriov_init(struct nitrox_device *ndev)
+{
+	/* register interrupts for PF in SR-IOV */
+	return nitrox_sriov_register_interupts(ndev);
+}
+
+static void nitrox_sriov_cleanup(struct nitrox_device *ndev)
+{
+	/* unregister interrupts for PF in SR-IOV */
+	nitrox_sriov_unregister_interrupts(ndev);
+}
+
 static int nitrox_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 	struct nitrox_device *ndev =3D pci_get_drvdata(pdev);
@@ -106,17 +126,31 @@ static int nitrox_sriov_enable(struct pci_dev *pdev, =
int num_vfs)
 	}
 	dev_info(DEV(ndev), "Enabled VF(s) %d\n", num_vfs);
=20
-	ndev->num_vfs =3D num_vfs;
+	ndev->iov.num_vfs =3D num_vfs;
 	ndev->mode =3D num_vfs_to_mode(num_vfs);
 	/* set bit in flags */
 	set_bit(__NDEV_SRIOV_BIT, &ndev->flags);
=20
 	/* cleanup PF resources */
-	pf_sriov_cleanup(ndev);
+	nitrox_pf_cleanup(ndev);
=20
-	config_nps_core_vfcfg_mode(ndev, ndev->mode);
+	/* PF SR-IOV mode initialization */
+	err =3D nitrox_sriov_init(ndev);
+	if (err)
+		goto iov_fail;
=20
+	config_nps_core_vfcfg_mode(ndev, ndev->mode);
 	return num_vfs;
+
+iov_fail:
+	pci_disable_sriov(pdev);
+	/* clear bit in flags */
+	clear_bit(__NDEV_SRIOV_BIT, &ndev->flags);
+	ndev->iov.num_vfs =3D 0;
+	ndev->mode =3D __NDEV_MODE_PF;
+	/* reset back to working mode in PF */
+	nitrox_pf_reinit(ndev);
+	return err;
 }
=20
 static int nitrox_sriov_disable(struct pci_dev *pdev)
@@ -134,12 +168,15 @@ static int nitrox_sriov_disable(struct pci_dev *pdev)
 	/* clear bit in flags */
 	clear_bit(__NDEV_SRIOV_BIT, &ndev->flags);
=20
-	ndev->num_vfs =3D 0;
+	ndev->iov.num_vfs =3D 0;
 	ndev->mode =3D __NDEV_MODE_PF;
=20
+	/* cleanup PF SR-IOV resources */
+	nitrox_sriov_cleanup(ndev);
+
 	config_nps_core_vfcfg_mode(ndev, ndev->mode);
=20
-	return pf_sriov_init(ndev);
+	return nitrox_pf_reinit(ndev);
 }
=20
 int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs)
--=20
2.17.1
