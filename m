Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FA1C2B9F8
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79F096101E
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhEYLcL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 07:32:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230414AbhEYLcI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 07:32:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PBUPU7028126;
        Tue, 25 May 2021 04:30:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=D3yREjf6iQdaIRqhI0riw2nDFyNV+IF6m/MM/d+O+fE=;
 b=XWYqbok8Hlix+QYVgU1z/N8C+MSzDgZ1GLlNMUZRebulrfW+AxK63bqMpLPqRkIdhi3r
 wcYKYxw985DrgijlO3VgdxHLYxhuLQCgYdXp+GylLhN7CfsaqJ9A4AKWbPOVPIEQF7nO
 ZO1BXKd3es/y8FmfqEHJDAeLXvUN173CaiJ9xGAi/pstoqLcWwx9wu9OGyrAEbX3haT6
 Xax6FsPNu5CS/2OG0ryu6EEnUu4HwX1Dhy5/FQ651+Htppt0bvcZGPLEUysP/w0+WGi3
 M+a9tr7SbMQgZwZgfoCMmDRCLSZRsVx3OFkWYOdozjpRMe5OpNRMBAfac2heoc4NMFOj xQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38s0dw801h-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 04:30:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 04:28:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 04:28:02 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id B2AFD3F7040;
        Tue, 25 May 2021 04:27:59 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>, <jerinj@marvell.com>,
        "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH 4/4] crypto: octeontx2: enable and handle ME interrupts
Date:   Tue, 25 May 2021 16:57:18 +0530
Message-ID: <20210525112718.18288-5-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210525112718.18288-1-schalla@marvell.com>
References: <20210525112718.18288-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: zkcnEQd_L_Bx8-Eo4zh0bI17XHnH0s5W
X-Proofpoint-ORIG-GUID: zkcnEQd_L_Bx8-Eo4zh0bI17XHnH0s5W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds master enable (ME) interrupt handler in PF. Upon
receiving ME interrupt for a VF, PF clears it's transaction
pending bit.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cptpf_main.c       | 118 ++++++++++++++----
 1 file changed, 95 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 1fb04f9bb7ac..146a55ac4b9b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -63,45 +63,66 @@ static void cptpf_disable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
 	}
 }
 
-static void cptpf_enable_vf_flr_intrs(struct otx2_cptpf_dev *cptpf)
+static void cptpf_enable_vf_flr_me_intrs(struct otx2_cptpf_dev *cptpf,
+					 int num_vfs)
 {
-	/* Clear interrupt if any */
+	/* Clear FLR interrupt if any */
 	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(0),
-			~0x0ULL);
-	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(1),
-			~0x0ULL);
+			 INTR_MASK(num_vfs));
 
 	/* Enable VF FLR interrupts */
 	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
-			 RVU_PF_VFFLR_INT_ENA_W1SX(0), ~0x0ULL);
+			 RVU_PF_VFFLR_INT_ENA_W1SX(0), INTR_MASK(num_vfs));
+	/* Clear ME interrupt if any */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFME_INTX(0),
+			 INTR_MASK(num_vfs));
+	/* Enable VF ME interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFME_INT_ENA_W1SX(0), INTR_MASK(num_vfs));
+
+	if (num_vfs <= 64)
+		return;
+
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(1),
+			 INTR_MASK(num_vfs - 64));
 	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
-			 RVU_PF_VFFLR_INT_ENA_W1SX(1), ~0x0ULL);
+			 RVU_PF_VFFLR_INT_ENA_W1SX(1), INTR_MASK(num_vfs - 64));
+
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFME_INTX(1),
+			 INTR_MASK(num_vfs - 64));
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFME_INT_ENA_W1SX(1), INTR_MASK(num_vfs - 64));
 }
 
-static void cptpf_disable_vf_flr_intrs(struct otx2_cptpf_dev *cptpf,
+static void cptpf_disable_vf_flr_me_intrs(struct otx2_cptpf_dev *cptpf,
 				       int num_vfs)
 {
 	int vector;
 
 	/* Disable VF FLR interrupts */
 	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
-			 RVU_PF_VFFLR_INT_ENA_W1CX(0), ~0x0ULL);
+			 RVU_PF_VFFLR_INT_ENA_W1CX(0), INTR_MASK(num_vfs));
+	vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFFLR0);
+	free_irq(vector, cptpf);
+
+	/* Disable VF ME interrupts */
 	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
-			 RVU_PF_VFFLR_INT_ENA_W1CX(1), ~0x0ULL);
+			 RVU_PF_VFME_INT_ENA_W1CX(0), INTR_MASK(num_vfs));
+	vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFME0);
+	free_irq(vector, cptpf);
 
-	/* Clear interrupt if any */
-	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(0),
-			 ~0x0ULL);
-	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(1),
-			 ~0x0ULL);
+	if (num_vfs <= 64)
+		return;
 
-	vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFFLR0);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFFLR_INT_ENA_W1CX(1), INTR_MASK(num_vfs - 64));
+	vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFFLR1);
 	free_irq(vector, cptpf);
 
-	if (num_vfs > 64) {
-		vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFFLR1);
-		free_irq(vector, cptpf);
-	}
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFME_INT_ENA_W1CX(1), INTR_MASK(num_vfs - 64));
+	vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFME1);
+	free_irq(vector, cptpf);
 }
 
 static void cptpf_flr_wq_handler(struct work_struct *work)
@@ -173,11 +194,38 @@ static irqreturn_t cptpf_vf_flr_intr(int __always_unused irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t cptpf_vf_me_intr(int __always_unused irq, void *arg)
+{
+	struct otx2_cptpf_dev *cptpf = arg;
+	int reg, vf, num_reg = 1;
+	u64 intr;
+
+	if (cptpf->max_vfs > 64)
+		num_reg = 2;
+
+	for (reg = 0; reg < num_reg; reg++) {
+		intr = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0,
+				       RVU_PF_VFME_INTX(reg));
+		if (!intr)
+			continue;
+		for (vf = 0; vf < 64; vf++) {
+			if (!(intr & BIT_ULL(vf)))
+				continue;
+			otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+					 RVU_PF_VFTRPENDX(reg), BIT_ULL(vf));
+			/* Clear interrupt */
+			otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+					 RVU_PF_VFME_INTX(reg), BIT_ULL(vf));
+		}
+	}
+	return IRQ_HANDLED;
+}
+
 static void cptpf_unregister_vfpf_intr(struct otx2_cptpf_dev *cptpf,
 				       int num_vfs)
 {
 	cptpf_disable_vfpf_mbox_intr(cptpf, num_vfs);
-	cptpf_disable_vf_flr_intrs(cptpf, num_vfs);
+	cptpf_disable_vf_flr_me_intrs(cptpf, num_vfs);
 }
 
 static int cptpf_register_vfpf_intr(struct otx2_cptpf_dev *cptpf, int num_vfs)
@@ -203,6 +251,15 @@ static int cptpf_register_vfpf_intr(struct otx2_cptpf_dev *cptpf, int num_vfs)
 			"IRQ registration failed for VFFLR0 irq\n");
 		goto free_mbox0_irq;
 	}
+	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFME0);
+	/* Register VF ME interrupt handler */
+	ret = request_irq(vector, cptpf_vf_me_intr, 0, "CPTPF ME0", cptpf);
+	if (ret) {
+		dev_err(dev,
+			"IRQ registration failed for PFVF mbox0 irq\n");
+		goto free_flr0_irq;
+	}
+
 	if (num_vfs > 64) {
 		vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX1);
 		ret = request_irq(vector, otx2_cptpf_vfpf_mbox_intr, 0,
@@ -210,7 +267,7 @@ static int cptpf_register_vfpf_intr(struct otx2_cptpf_dev *cptpf, int num_vfs)
 		if (ret) {
 			dev_err(dev,
 				"IRQ registration failed for PFVF mbox1 irq\n");
-			goto free_flr0_irq;
+			goto free_me0_irq;
 		}
 		vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFFLR1);
 		/* Register VF FLR interrupt handler */
@@ -221,15 +278,30 @@ static int cptpf_register_vfpf_intr(struct otx2_cptpf_dev *cptpf, int num_vfs)
 				"IRQ registration failed for VFFLR1 irq\n");
 			goto free_mbox1_irq;
 		}
+		vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFME1);
+		/* Register VF FLR interrupt handler */
+		ret = request_irq(vector, cptpf_vf_me_intr, 0, "CPTPF ME1",
+				  cptpf);
+		if (ret) {
+			dev_err(dev,
+				"IRQ registration failed for VFFLR1 irq\n");
+			goto free_flr1_irq;
+		}
 	}
 	cptpf_enable_vfpf_mbox_intr(cptpf, num_vfs);
-	cptpf_enable_vf_flr_intrs(cptpf);
+	cptpf_enable_vf_flr_me_intrs(cptpf, num_vfs);
 
 	return 0;
 
+free_flr1_irq:
+	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFFLR1);
+	free_irq(vector, cptpf);
 free_mbox1_irq:
 	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX1);
 	free_irq(vector, cptpf);
+free_me0_irq:
+	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFME0);
+	free_irq(vector, cptpf);
 free_flr0_irq:
 	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFFLR0);
 	free_irq(vector, cptpf);
-- 
2.29.0

