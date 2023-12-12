Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GzpRSOsX"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E20D1;
	Mon, 11 Dec 2023 21:18:46 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BBNk5qO014653;
	Mon, 11 Dec 2023 21:18:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=Ku5DC/+Mwpv3EuEsCkLSFQiX2Hpg1wl2a0PvmxAZfEA=; b=Gzp
	RSOsXcHwDg342yCZ9baFrmGZm+lju454Z6Af8fxXL3hVczfBw5fHZhE4ga1/XKt0
	0P50aSeci22y0g5g9YxODRBooJ/iKAX3gJDjhNW/HyBMoV5C97HQ7kXN9Zf40zOa
	wmBmxENx3cYHsYEpMPrevoGrD2MHBZFBJt0E3AEQTqmmArju1MsAhGpyYez4Yz6s
	tilhtK0rwejjd8Lgl5yoxAFKFZ2P4uVdonY8Fmnb0I1i39HeDAO218uKqQ1wOT8Z
	a/2/yMZcxAvly0iSwuZUIVCl28fW8uL49U2S31GCXzaNH5GsBgAq9bppacWpTUZD
	5jQQg2V9eHXn2m967Qw==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uvrmjqjct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Mon, 11 Dec 2023 21:18:35 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 11 Dec
 2023 21:18:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 11 Dec 2023 21:18:32 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id D64133F70A0;
	Mon, 11 Dec 2023 21:18:26 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <corbet@lwn.net>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v2 09/10] crypto/octeontx2: register error interrupts for inline cptlf
Date: Tue, 12 Dec 2023 10:47:29 +0530
Message-ID: <20231212051730.386088-10-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231212051730.386088-1-schalla@marvell.com>
References: <20231212051730.386088-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mRdQZu61HfVErVWppErOC-WOzMifULjr
X-Proofpoint-ORIG-GUID: mRdQZu61HfVErVWppErOC-WOzMifULjr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Register errors interrupts for inline cptlf attached to PF driver
so that SMMU faults and other errors can be reported.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 101 +++++++++++-------
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   6 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   4 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  19 +++-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  68 ++++++++++--
 .../marvell/octeontx2/otx2_cptvf_main.c       |  12 ++-
 6 files changed, 155 insertions(+), 55 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index 6edd27ff8c4e..c3bafd9a11dd 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -151,26 +151,14 @@ static void cptlf_set_misc_intrs(struct otx2_cptlfs_info *lfs, u8 enable)
 				 irq_misc.u);
 }
 
-static void cptlf_enable_intrs(struct otx2_cptlfs_info *lfs)
+static void cptlf_set_done_intrs(struct otx2_cptlfs_info *lfs, u8 enable)
 {
+	u64 reg = enable ? OTX2_CPT_LF_DONE_INT_ENA_W1S :
+			   OTX2_CPT_LF_DONE_INT_ENA_W1C;
 	int slot;
 
-	/* Enable done interrupts */
 	for (slot = 0; slot < lfs->lfs_num; slot++)
-		otx2_cpt_write64(lfs->reg_base, lfs->blkaddr, slot,
-				 OTX2_CPT_LF_DONE_INT_ENA_W1S, 0x1);
-	/* Enable Misc interrupts */
-	cptlf_set_misc_intrs(lfs, true);
-}
-
-static void cptlf_disable_intrs(struct otx2_cptlfs_info *lfs)
-{
-	int slot;
-
-	for (slot = 0; slot < lfs->lfs_num; slot++)
-		otx2_cpt_write64(lfs->reg_base, lfs->blkaddr, slot,
-				 OTX2_CPT_LF_DONE_INT_ENA_W1C, 0x1);
-	cptlf_set_misc_intrs(lfs, false);
+		otx2_cpt_write64(lfs->reg_base, lfs->blkaddr, slot, reg, 0x1);
 }
 
 static inline int cptlf_read_done_cnt(struct otx2_cptlf_info *lf)
@@ -257,24 +245,44 @@ static irqreturn_t cptlf_done_intr_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-void otx2_cptlf_unregister_interrupts(struct otx2_cptlfs_info *lfs)
+void otx2_cptlf_unregister_misc_interrupts(struct otx2_cptlfs_info *lfs)
 {
-	int i, offs, vector;
+	int i, irq_offs, vector;
 
+	irq_offs = OTX2_CPT_LF_INT_VEC_E_MISC;
 	for (i = 0; i < lfs->lfs_num; i++) {
-		for (offs = 0; offs < OTX2_CPT_LF_MSIX_VECTORS; offs++) {
-			if (!lfs->lf[i].is_irq_reg[offs])
-				continue;
+		if (!lfs->lf[i].is_irq_reg[irq_offs])
+			continue;
 
-			vector = pci_irq_vector(lfs->pdev,
-						lfs->lf[i].msix_offset + offs);
-			free_irq(vector, &lfs->lf[i]);
-			lfs->lf[i].is_irq_reg[offs] = false;
-		}
+		vector = pci_irq_vector(lfs->pdev,
+					lfs->lf[i].msix_offset + irq_offs);
+		free_irq(vector, &lfs->lf[i]);
+		lfs->lf[i].is_irq_reg[irq_offs] = false;
+	}
+
+	cptlf_set_misc_intrs(lfs, false);
+}
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_unregister_misc_interrupts,
+		     CRYPTO_DEV_OCTEONTX2_CPT);
+
+void otx2_cptlf_unregister_done_interrupts(struct otx2_cptlfs_info *lfs)
+{
+	int i, irq_offs, vector;
+
+	irq_offs = OTX2_CPT_LF_INT_VEC_E_DONE;
+	for (i = 0; i < lfs->lfs_num; i++) {
+		if (!lfs->lf[i].is_irq_reg[irq_offs])
+			continue;
+
+		vector = pci_irq_vector(lfs->pdev,
+					lfs->lf[i].msix_offset + irq_offs);
+		free_irq(vector, &lfs->lf[i]);
+		lfs->lf[i].is_irq_reg[irq_offs] = false;
 	}
-	cptlf_disable_intrs(lfs);
+
+	cptlf_set_done_intrs(lfs, false);
 }
-EXPORT_SYMBOL_NS_GPL(otx2_cptlf_unregister_interrupts,
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_unregister_done_interrupts,
 		     CRYPTO_DEV_OCTEONTX2_CPT);
 
 static int cptlf_do_register_interrrupts(struct otx2_cptlfs_info *lfs,
@@ -296,34 +304,53 @@ static int cptlf_do_register_interrrupts(struct otx2_cptlfs_info *lfs,
 	return ret;
 }
 
-int otx2_cptlf_register_interrupts(struct otx2_cptlfs_info *lfs)
+int otx2_cptlf_register_misc_interrupts(struct otx2_cptlfs_info *lfs)
 {
+	bool is_cpt1 = (lfs->blkaddr == BLKADDR_CPT1);
 	int irq_offs, ret, i;
 
+	irq_offs = OTX2_CPT_LF_INT_VEC_E_MISC;
 	for (i = 0; i < lfs->lfs_num; i++) {
-		irq_offs = OTX2_CPT_LF_INT_VEC_E_MISC;
-		snprintf(lfs->lf[i].irq_name[irq_offs], 32, "CPTLF Misc%d", i);
+		snprintf(lfs->lf[i].irq_name[irq_offs], 32, "CPT%dLF Misc%d",
+			 is_cpt1, i);
 		ret = cptlf_do_register_interrrupts(lfs, i, irq_offs,
 						    cptlf_misc_intr_handler);
 		if (ret)
 			goto free_irq;
+	}
+	cptlf_set_misc_intrs(lfs, true);
+	return 0;
 
-		irq_offs = OTX2_CPT_LF_INT_VEC_E_DONE;
-		snprintf(lfs->lf[i].irq_name[irq_offs], 32, "OTX2_CPTLF Done%d",
-			 i);
+free_irq:
+	otx2_cptlf_unregister_misc_interrupts(lfs);
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_register_misc_interrupts,
+		     CRYPTO_DEV_OCTEONTX2_CPT);
+
+int otx2_cptlf_register_done_interrupts(struct otx2_cptlfs_info *lfs)
+{
+	bool is_cpt1 = (lfs->blkaddr == BLKADDR_CPT1);
+	int irq_offs, ret, i;
+
+	irq_offs = OTX2_CPT_LF_INT_VEC_E_DONE;
+	for (i = 0; i < lfs->lfs_num; i++) {
+		snprintf(lfs->lf[i].irq_name[irq_offs], 32,
+			 "OTX2_CPT%dLF Done%d", is_cpt1, i);
 		ret = cptlf_do_register_interrrupts(lfs, i, irq_offs,
 						    cptlf_done_intr_handler);
 		if (ret)
 			goto free_irq;
 	}
-	cptlf_enable_intrs(lfs);
+	cptlf_set_done_intrs(lfs, true);
 	return 0;
 
 free_irq:
-	otx2_cptlf_unregister_interrupts(lfs);
+	otx2_cptlf_unregister_done_interrupts(lfs);
 	return ret;
 }
-EXPORT_SYMBOL_NS_GPL(otx2_cptlf_register_interrupts, CRYPTO_DEV_OCTEONTX2_CPT);
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_register_done_interrupts,
+		     CRYPTO_DEV_OCTEONTX2_CPT);
 
 void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
 {
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index f68631ec8861..ffaca642b640 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -410,8 +410,10 @@ static inline void otx2_cptlf_set_dev_info(struct otx2_cptlfs_info *lfs,
 int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_msk, int pri,
 		    int lfs_num);
 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs);
-int otx2_cptlf_register_interrupts(struct otx2_cptlfs_info *lfs);
-void otx2_cptlf_unregister_interrupts(struct otx2_cptlfs_info *lfs);
+int otx2_cptlf_register_misc_interrupts(struct otx2_cptlfs_info *lfs);
+int otx2_cptlf_register_done_interrupts(struct otx2_cptlfs_info *lfs);
+void otx2_cptlf_unregister_misc_interrupts(struct otx2_cptlfs_info *lfs);
+void otx2_cptlf_unregister_done_interrupts(struct otx2_cptlfs_info *lfs);
 void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs);
 int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index a209ec5af381..e5859a1e1c60 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -71,4 +71,8 @@ void otx2_cptpf_afpf_mbox_up_handler(struct work_struct *work);
 irqreturn_t otx2_cptpf_vfpf_mbox_intr(int irq, void *arg);
 void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work);
 
+int otx2_inline_cptlf_setup(struct otx2_cptpf_dev *cptpf,
+			    struct otx2_cptlfs_info *lfs, u8 egrp, int num_lfs);
+void otx2_inline_cptlf_cleanup(struct otx2_cptlfs_info *lfs);
+
 #endif /* __OTX2_CPTPF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 8cbfffab12e3..3b03c951da0b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -722,7 +722,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 {
 	struct device *dev = &pdev->dev;
 	struct otx2_cptpf_dev *cptpf;
-	int err;
+	int err, num_vec;
 
 	cptpf = devm_kzalloc(dev, sizeof(*cptpf), GFP_KERNEL);
 	if (!cptpf)
@@ -757,8 +757,13 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 	if (err)
 		goto clear_drvdata;
 
-	err = pci_alloc_irq_vectors(pdev, RVU_PF_INT_VEC_CNT,
-				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);
+	num_vec = pci_msix_vec_count(cptpf->pdev);
+	if (num_vec <= 0) {
+		err = -EINVAL;
+		goto clear_drvdata;
+	}
+
+	err = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
 	if (err < 0) {
 		dev_err(dev, "Request for %d msix vectors failed\n",
 			RVU_PF_INT_VEC_CNT);
@@ -822,6 +827,14 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 
 	cptpf_sriov_disable(pdev);
 	otx2_cpt_unregister_dl(cptpf);
+
+	/* Cleanup Inline CPT LF's if attached */
+	if (cptpf->lfs.lfs_num)
+		otx2_inline_cptlf_cleanup(&cptpf->lfs);
+
+	if (cptpf->cpt1_lfs.lfs_num)
+		otx2_inline_cptlf_cleanup(&cptpf->cpt1_lfs);
+
 	/* Delete sysfs entry created for kernel VF limits */
 	sysfs_remove_group(&pdev->dev.kobj, &cptpf_sysfs_group);
 	/* Cleanup engine groups */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index bbabb57b4665..5d63763db2af 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -199,6 +199,47 @@ static int rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf, u8 egrp,
 	return send_inline_ipsec_inbound_msg(cptpf, req->sso_pf_func, 0);
 }
 
+int
+otx2_inline_cptlf_setup(struct otx2_cptpf_dev *cptpf,
+			struct otx2_cptlfs_info *lfs, u8 egrp, int num_lfs)
+{
+	int ret;
+
+	ret = otx2_cptlf_init(lfs, 1 << egrp, OTX2_CPT_QUEUE_HI_PRIO, 1);
+	if (ret) {
+		dev_err(&cptpf->pdev->dev,
+			"LF configuration failed for RX inline ipsec.\n");
+		return ret;
+	}
+
+	/* Get msix offsets for attached LFs */
+	ret = otx2_cpt_msix_offset_msg(lfs);
+	if (ret)
+		goto cleanup_lf;
+
+	/* Register for CPT LF Misc interrupts */
+	ret = otx2_cptlf_register_misc_interrupts(lfs);
+	if (ret)
+		goto free_irq;
+
+	return 0;
+free_irq:
+	otx2_cptlf_unregister_misc_interrupts(lfs);
+cleanup_lf:
+	otx2_cptlf_shutdown(lfs);
+	return ret;
+}
+
+void
+otx2_inline_cptlf_cleanup(struct otx2_cptlfs_info *lfs)
+{
+	/* Unregister misc interrupt */
+	otx2_cptlf_unregister_misc_interrupts(lfs);
+
+	/* Cleanup LFs */
+	otx2_cptlf_shutdown(lfs);
+}
+
 static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 					     struct mbox_msghdr *req)
 {
@@ -226,11 +267,9 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 	otx2_cptlf_set_dev_info(&cptpf->lfs, cptpf->pdev, cptpf->reg_base,
 				&cptpf->afpf_mbox, BLKADDR_CPT0);
 	cptpf->lfs.global_slot = 0;
-	ret = otx2_cptlf_init(&cptpf->lfs, 1 << egrp, OTX2_CPT_QUEUE_HI_PRIO,
-			      num_lfs);
+	ret = otx2_inline_cptlf_setup(cptpf, &cptpf->lfs, egrp, num_lfs);
 	if (ret) {
-		dev_err(&cptpf->pdev->dev,
-			"LF configuration failed for RX inline ipsec.\n");
+		dev_err(&cptpf->pdev->dev, "Inline-Ipsec CPT0 LF setup failed.\n");
 		return ret;
 	}
 
@@ -240,11 +279,10 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 					cptpf->reg_base, &cptpf->afpf_mbox,
 					BLKADDR_CPT1);
 		cptpf->cpt1_lfs.global_slot = num_lfs;
-		ret = otx2_cptlf_init(&cptpf->cpt1_lfs, 1 << egrp,
-				      OTX2_CPT_QUEUE_HI_PRIO, num_lfs);
+		ret = otx2_inline_cptlf_setup(cptpf, &cptpf->cpt1_lfs, egrp,
+					      num_lfs);
 		if (ret) {
-			dev_err(&cptpf->pdev->dev,
-				"LF configuration failed for RX inline ipsec.\n");
+			dev_err(&cptpf->pdev->dev, "Inline CPT1 LF setup failed.\n");
 			goto lf_cleanup;
 		}
 		cptpf->rsrc_req_blkaddr = 0;
@@ -257,9 +295,9 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 	return 0;
 
 lf1_cleanup:
-	otx2_cptlf_shutdown(&cptpf->cpt1_lfs);
+	otx2_inline_cptlf_cleanup(&cptpf->cpt1_lfs);
 lf_cleanup:
-	otx2_cptlf_shutdown(&cptpf->lfs);
+	otx2_inline_cptlf_cleanup(&cptpf->lfs);
 	return ret;
 }
 
@@ -414,6 +452,8 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 	struct otx2_cptlfs_info *lfs = &cptpf->lfs;
 	struct device *dev = &cptpf->pdev->dev;
 	struct cpt_rd_wr_reg_msg *rsp_rd_wr;
+	struct msix_offset_rsp *rsp_msix;
+	int i;
 
 	if (msg->id >= MBOX_MSG_MAX) {
 		dev_err(dev, "MBOX msg with unknown ID %d\n", msg->id);
@@ -432,6 +472,14 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 		cptpf->pf_id = (msg->pcifunc >> RVU_PFVF_PF_SHIFT) &
 				RVU_PFVF_PF_MASK;
 		break;
+	case MBOX_MSG_MSIX_OFFSET:
+		rsp_msix = (struct msix_offset_rsp *) msg;
+		for (i = 0; i < rsp_msix->cptlfs; i++)
+			lfs->lf[i].msix_offset = rsp_msix->cptlf_msixoff[i];
+
+		for (i = 0; i < rsp_msix->cpt1_lfs; i++)
+			lfs->lf[i].msix_offset = rsp_msix->cpt1_lf_msixoff[i];
+		break;
 	case MBOX_MSG_CPT_RD_WR_REGISTER:
 		rsp_rd_wr = (struct cpt_rd_wr_reg_msg *)msg;
 		if (msg->rc) {
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index d3eaac072ff2..26a3ba4b4af7 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -246,7 +246,8 @@ static void cptvf_lf_shutdown(struct otx2_cptlfs_info *lfs)
 	/* Unregister crypto algorithms */
 	otx2_cpt_crypto_exit(lfs->pdev, THIS_MODULE);
 	/* Unregister LFs interrupts */
-	otx2_cptlf_unregister_interrupts(lfs);
+	otx2_cptlf_unregister_misc_interrupts(lfs);
+	otx2_cptlf_unregister_done_interrupts(lfs);
 	/* Cleanup LFs software side */
 	lf_sw_cleanup(lfs);
 	/* Send request to detach LFs */
@@ -298,7 +299,11 @@ static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
 		goto cleanup_lf;
 
 	/* Register LFs interrupts */
-	ret = otx2_cptlf_register_interrupts(lfs);
+	ret = otx2_cptlf_register_misc_interrupts(lfs);
+	if (ret)
+		goto cleanup_lf_sw;
+
+	ret = otx2_cptlf_register_done_interrupts(lfs);
 	if (ret)
 		goto cleanup_lf_sw;
 
@@ -319,7 +324,8 @@ static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
 disable_irqs:
 	otx2_cptlf_free_irqs_affinity(lfs);
 unregister_intr:
-	otx2_cptlf_unregister_interrupts(lfs);
+	otx2_cptlf_unregister_misc_interrupts(lfs);
+	otx2_cptlf_unregister_done_interrupts(lfs);
 cleanup_lf_sw:
 	lf_sw_cleanup(lfs);
 cleanup_lf:
-- 
2.25.1

