Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031EBC47085
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F0761413
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhEYLcL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 07:32:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34891 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231410AbhEYLcI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 07:32:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PBUPZV028087;
        Tue, 25 May 2021 04:30:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=XntUNJI1Y8J9WpMovwxzXQF2E/x7qF8tBe5x7pds3w8=;
 b=JDVbNegoLP5y6PIjPmz6IJoBleBGxBWty3uzqUIobfWnDA+2rfWhmLlE6Y25TDWQazs2
 ab27mS2t79qq8S2QVWWakHcY/HkFkRriLfidj6gCXXXuGo53yDianGKXDR1reUVpdkAx
 XutnydkACuS66EbaQ7PRensphZ472v/gUMWHCiAB90785NdshhuLChwkJe7l2A71B9/Z
 CMT0InnkkjdhY31eTa+a8ZYslwYBwSi9WoIJG5EGAyf8/nEEtz2BFY0xSSig7y7luo9n
 17ayI5r8u6d7xJrTABfMJnuUaVJu4nndZLz0o7P6JcG5FDv5W8rofN34quXGw+INl0hD XA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38s0dw8026-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 04:30:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 04:27:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 04:27:47 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 44B2E3F703F;
        Tue, 25 May 2021 04:27:46 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>, <jerinj@marvell.com>,
        "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH 1/4] crypto: octeontx2: Add mailbox support for CN10K
Date:   Tue, 25 May 2021 16:57:15 +0530
Message-ID: <20210525112718.18288-2-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210525112718.18288-1-schalla@marvell.com>
References: <20210525112718.18288-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: kZOYVKzFH9sWpDAC_K58XqV6VzquokXV
X-Proofpoint-ORIG-GUID: kZOYVKzFH9sWpDAC_K58XqV6VzquokXV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Mailbox region configuration has some changes on CN10K platform
from OcteonTX2(CN9XX) platform.

On CN10K platform:
The DRAM region allocated to PF is enumerated as PF BAR4 memory.
PF BAR4 contains AF-PF mbox region followed by its VFs mbox region.
AF-PF mbox region base address is configured at RVU_AF_PFX_BAR4_ADDR
PF-VF mailbox base address is configured at
RVU_PF(x)_VF_MBOX_ADDR = RVU_AF_PF()_BAR4_ADDR+64KB. PF access its
mbox region via BAR4, whereas VF accesses PF-VF DRAM mailboxes via
BAR2 indirect access.

On CN9XX platform:
Mailbox region in DRAM is divided into two parts AF-PF mbox region and
PF-VF mbox region i.e all PFs mbox region is contiguous similarly all
VFs.
The base address of the AF-PF mbox region is configured at
RVU_AF_PF_BAR4_ADDR.
AF-PF1 mbox address can be calculated as RVU_AF_PF_BAR4_ADDR * mbox
size.

This patch changes mbox initialization to support both CN9XX and CN10K
platform.
This patch also removes platform specific name from the PF/VF driver name
to make it appropriate for all supported platforms.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     | 12 ++---
 .../marvell/octeontx2/otx2_cpt_common.h       | 20 +++++++++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  3 ++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  1 +
 .../marvell/octeontx2/otx2_cptpf_main.c       | 35 +++++++++------
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |  3 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       | 45 +++++++++++++------
 .../marvell/octeontx2/otx2_cptvf_mbox.c       | 43 ++++++++++++++++++
 8 files changed, 129 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index b9c6201019e0..10e1fe056a9e 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o octeontx2-cptvf.o
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += rvu_cptpf.o rvu_cptvf.o
 
-octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
-		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
-octeontx2-cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
-			otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
-			otx2_cptvf_algs.o
+rvu_cptpf-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
+		  otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
+rvu_cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
+		  otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
+		  otx2_cptvf_algs.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index ecedd91a8d85..414427dcfa61 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -25,6 +25,9 @@
 #define OTX2_CPT_NAME_LENGTH 64
 #define OTX2_CPT_DMA_MINALIGN 128
 
+/* HW capability flags */
+#define CN10K_MBOX  0
+
 #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
 
 enum otx2_cpt_eng_type {
@@ -116,6 +119,23 @@ static inline u64 otx2_cpt_read64(void __iomem *reg_base, u64 blk, u64 slot,
 			     OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs));
 }
 
+static inline bool is_dev_otx2(struct pci_dev *pdev)
+{
+	if (pdev->device == OTX2_CPT_PCI_PF_DEVICE_ID ||
+	    pdev->device == OTX2_CPT_PCI_VF_DEVICE_ID)
+		return true;
+
+	return false;
+}
+
+static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
+					unsigned long *cap_flag)
+{
+	if (!is_dev_otx2(pdev))
+		__set_bit(CN10K_MBOX, cap_flag);
+}
+
+
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
index ecafc42f37a2..391a457f7116 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -10,6 +10,8 @@
 /* Device IDs */
 #define OTX2_CPT_PCI_PF_DEVICE_ID 0xA0FD
 #define OTX2_CPT_PCI_VF_DEVICE_ID 0xA0FE
+#define CN10K_CPT_PCI_PF_DEVICE_ID 0xA0F2
+#define CN10K_CPT_PCI_VF_DEVICE_ID 0xA0F3
 
 /* Mailbox interrupts offset */
 #define OTX2_CPT_PF_MBOX_INT	6
@@ -25,6 +27,7 @@
  */
 #define OTX2_CPT_VF_MSIX_VECTORS 1
 #define OTX2_CPT_VF_INTR_MBOX_MASK BIT(0)
+#define CN10K_CPT_VF_MBOX_REGION  (0xC0000)
 
 /* CPT LF MSIX vectors */
 #define OTX2_CPT_LF_MSIX_VECTORS 2
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index e19af1356f12..5ebba86c65d9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -47,6 +47,7 @@ struct otx2_cptpf_dev {
 	struct workqueue_struct	*flr_wq;
 	struct cptpf_flr_work   *flr_work;
 
+	unsigned long cap_flag;
 	u8 pf_id;               /* RVU PF number */
 	u8 max_vfs;		/* Maximum number of VFs supported by CPT */
 	u8 enabled_vfs;		/* Number of enabled VFs */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 58f47e3ab62e..d341aecd3dd2 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -8,8 +8,8 @@
 #include "otx2_cptpf.h"
 #include "rvu_reg.h"
 
-#define OTX2_CPT_DRV_NAME    "octeontx2-cpt"
-#define OTX2_CPT_DRV_STRING  "Marvell OcteonTX2 CPT Physical Function Driver"
+#define OTX2_CPT_DRV_NAME    "rvu_cptpf"
+#define OTX2_CPT_DRV_STRING  "Marvell RVU CPT Physical Function Driver"
 
 static void cptpf_enable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
 					int num_vfs)
@@ -284,7 +284,11 @@ static int cptpf_vfpf_mbox_init(struct otx2_cptpf_dev *cptpf, int num_vfs)
 		return -ENOMEM;
 
 	/* Map VF-PF mailbox memory */
-	vfpf_mbox_base = readq(cptpf->reg_base + RVU_PF_VF_BAR4_ADDR);
+	if (test_bit(CN10K_MBOX, &cptpf->cap_flag))
+		vfpf_mbox_base = readq(cptpf->reg_base + RVU_PF_VF_MBOX_ADDR);
+	else
+		vfpf_mbox_base = readq(cptpf->reg_base + RVU_PF_VF_BAR4_ADDR);
+
 	if (!vfpf_mbox_base) {
 		dev_err(dev, "VF-PF mailbox address not configured\n");
 		err = -ENOMEM;
@@ -365,6 +369,8 @@ static int cptpf_register_afpf_mbox_intr(struct otx2_cptpf_dev *cptpf)
 
 static int cptpf_afpf_mbox_init(struct otx2_cptpf_dev *cptpf)
 {
+	struct pci_dev *pdev = cptpf->pdev;
+	resource_size_t offset;
 	int err;
 
 	cptpf->afpf_mbox_wq = alloc_workqueue("cpt_afpf_mailbox",
@@ -373,8 +379,17 @@ static int cptpf_afpf_mbox_init(struct otx2_cptpf_dev *cptpf)
 	if (!cptpf->afpf_mbox_wq)
 		return -ENOMEM;
 
+	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
+	/* Map AF-PF mailbox memory */
+	cptpf->afpf_mbox_base = devm_ioremap_wc(&pdev->dev, offset, MBOX_SIZE);
+	if (!cptpf->afpf_mbox_base) {
+		dev_err(&pdev->dev, "Unable to map BAR4\n");
+		err = -ENOMEM;
+		goto error;
+	}
+
 	err = otx2_mbox_init(&cptpf->afpf_mbox, cptpf->afpf_mbox_base,
-			     cptpf->pdev, cptpf->reg_base, MBOX_DIR_PFAF, 1);
+			     pdev, cptpf->reg_base, MBOX_DIR_PFAF, 1);
 	if (err)
 		goto error;
 
@@ -607,7 +622,6 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
-	resource_size_t offset, size;
 	struct otx2_cptpf_dev *cptpf;
 	int err;
 
@@ -644,15 +658,6 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 	if (err)
 		goto clear_drvdata;
 
-	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
-	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
-	/* Map AF-PF mailbox memory */
-	cptpf->afpf_mbox_base = devm_ioremap_wc(dev, offset, size);
-	if (!cptpf->afpf_mbox_base) {
-		dev_err(&pdev->dev, "Unable to map BAR4\n");
-		err = -ENODEV;
-		goto clear_drvdata;
-	}
 	err = pci_alloc_irq_vectors(pdev, RVU_PF_INT_VEC_CNT,
 				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);
 	if (err < 0) {
@@ -660,6 +665,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 			RVU_PF_INT_VEC_CNT);
 		goto clear_drvdata;
 	}
+	otx2_cpt_set_hw_caps(pdev, &cptpf->cap_flag);
 	/* Initialize AF-PF mailbox */
 	err = cptpf_afpf_mbox_init(cptpf);
 	if (err)
@@ -719,6 +725,7 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 /* Supported devices */
 static const struct pci_device_id otx2_cpt_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OTX2_CPT_PCI_PF_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, CN10K_CPT_PCI_PF_DEVICE_ID) },
 	{ 0, }  /* end of table */
 };
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
index 4f0a169fddbd..4207e2236903 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
@@ -19,11 +19,14 @@ struct otx2_cptvf_dev {
 	struct otx2_mbox	pfvf_mbox;
 	struct work_struct	pfvf_mbox_work;
 	struct workqueue_struct *pfvf_mbox_wq;
+	void *bbuf_base;
+	unsigned long cap_flag;
 };
 
 irqreturn_t otx2_cptvf_pfvf_mbox_intr(int irq, void *arg);
 void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work);
 int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int eng_type);
 int otx2_cptvf_send_kvf_limits_msg(struct otx2_cptvf_dev *cptvf);
+int otx2_cpt_mbox_bbuf_init(struct otx2_cptvf_dev *cptvf, struct pci_dev *pdev);
 
 #endif /* __OTX2_CPTVF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 47f378731024..5178e0688d75 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -7,7 +7,7 @@
 #include "otx2_cptvf_algs.h"
 #include <rvu_reg.h>
 
-#define OTX2_CPTVF_DRV_NAME "octeontx2-cptvf"
+#define OTX2_CPTVF_DRV_NAME "rvu_cptvf"
 
 static void cptvf_enable_pfvf_mbox_intrs(struct otx2_cptvf_dev *cptvf)
 {
@@ -70,6 +70,8 @@ static int cptvf_register_interrupts(struct otx2_cptvf_dev *cptvf)
 
 static int cptvf_pfvf_mbox_init(struct otx2_cptvf_dev *cptvf)
 {
+	struct pci_dev *pdev = cptvf->pdev;
+	resource_size_t offset, size;
 	int ret;
 
 	cptvf->pfvf_mbox_wq = alloc_workqueue("cpt_pfvf_mailbox",
@@ -78,14 +80,39 @@ static int cptvf_pfvf_mbox_init(struct otx2_cptvf_dev *cptvf)
 	if (!cptvf->pfvf_mbox_wq)
 		return -ENOMEM;
 
+	if (test_bit(CN10K_MBOX, &cptvf->cap_flag)) {
+		/* For cn10k platform, VF mailbox region is in its BAR2
+		 * register space
+		 */
+		cptvf->pfvf_mbox_base = cptvf->reg_base +
+					CN10K_CPT_VF_MBOX_REGION;
+	} else {
+		offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
+		size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
+		/* Map PF-VF mailbox memory */
+		cptvf->pfvf_mbox_base = devm_ioremap_wc(&pdev->dev, offset,
+							size);
+		if (!cptvf->pfvf_mbox_base) {
+			dev_err(&pdev->dev, "Unable to map BAR4\n");
+			ret = -ENOMEM;
+			goto free_wqe;
+		}
+	}
+
 	ret = otx2_mbox_init(&cptvf->pfvf_mbox, cptvf->pfvf_mbox_base,
-			     cptvf->pdev, cptvf->reg_base, MBOX_DIR_VFPF, 1);
+			     pdev, cptvf->reg_base, MBOX_DIR_VFPF, 1);
 	if (ret)
 		goto free_wqe;
 
+	ret = otx2_cpt_mbox_bbuf_init(cptvf, pdev);
+	if (ret)
+		goto destroy_mbox;
+
 	INIT_WORK(&cptvf->pfvf_mbox_work, otx2_cptvf_pfvf_mbox_handler);
 	return 0;
 
+destroy_mbox:
+	otx2_mbox_destroy(&cptvf->pfvf_mbox);
 free_wqe:
 	destroy_workqueue(cptvf->pfvf_mbox_wq);
 	return ret;
@@ -305,7 +332,6 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
-	resource_size_t offset, size;
 	struct otx2_cptvf_dev *cptvf;
 	int ret;
 
@@ -337,15 +363,7 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 
 	cptvf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
 
-	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
-	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
-	/* Map PF-VF mailbox memory */
-	cptvf->pfvf_mbox_base = devm_ioremap_wc(dev, offset, size);
-	if (!cptvf->pfvf_mbox_base) {
-		dev_err(&pdev->dev, "Unable to map BAR4\n");
-		ret = -ENODEV;
-		goto clear_drvdata;
-	}
+	otx2_cpt_set_hw_caps(pdev, &cptvf->cap_flag);
 	/* Initialize PF<=>VF mailbox */
 	ret = cptvf_pfvf_mbox_init(cptvf);
 	if (ret)
@@ -392,6 +410,7 @@ static void otx2_cptvf_remove(struct pci_dev *pdev)
 /* Supported devices */
 static const struct pci_device_id otx2_cptvf_id_table[] = {
 	{PCI_VDEVICE(CAVIUM, OTX2_CPT_PCI_VF_DEVICE_ID), 0},
+	{PCI_VDEVICE(CAVIUM, CN10K_CPT_PCI_VF_DEVICE_ID), 0},
 	{ 0, }  /* end of table */
 };
 
@@ -405,6 +424,6 @@ static struct pci_driver otx2_cptvf_pci_driver = {
 module_pci_driver(otx2_cptvf_pci_driver);
 
 MODULE_AUTHOR("Marvell");
-MODULE_DESCRIPTION("Marvell OcteonTX2 CPT Virtual Function Driver");
+MODULE_DESCRIPTION("Marvell RVU CPT Virtual Function Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(pci, otx2_cptvf_id_table);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
index 5d73b711cba6..02cb9e44afd8 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -5,6 +5,48 @@
 #include "otx2_cptvf.h"
 #include <rvu_reg.h>
 
+int otx2_cpt_mbox_bbuf_init(struct otx2_cptvf_dev *cptvf, struct pci_dev *pdev)
+{
+	struct otx2_mbox_dev *mdev;
+	struct otx2_mbox *otx2_mbox;
+
+	cptvf->bbuf_base = devm_kmalloc(&pdev->dev, MBOX_SIZE, GFP_KERNEL);
+	if (!cptvf->bbuf_base)
+		return -ENOMEM;
+	/*
+	 * Overwrite mbox mbase to point to bounce buffer, so that PF/VF
+	 * prepare all mbox messages in bounce buffer instead of directly
+	 * in hw mbox memory.
+	 */
+	otx2_mbox = &cptvf->pfvf_mbox;
+	mdev = &otx2_mbox->dev[0];
+	mdev->mbase = cptvf->bbuf_base;
+
+	return 0;
+}
+
+static void otx2_cpt_sync_mbox_bbuf(struct otx2_mbox *mbox, int devid)
+{
+	u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
+	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
+	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
+	struct mbox_hdr *hdr;
+	u64 msg_size;
+
+	if (mdev->mbase == hw_mbase)
+		return;
+
+	hdr = hw_mbase + mbox->rx_start;
+	msg_size = hdr->msg_size;
+
+	if (msg_size > mbox->rx_size - msgs_offset)
+		msg_size = mbox->rx_size - msgs_offset;
+
+	/* Copy mbox messages from mbox memory to bounce buffer */
+	memcpy(mdev->mbase + mbox->rx_start,
+	       hw_mbase + mbox->rx_start, msg_size + msgs_offset);
+}
+
 irqreturn_t otx2_cptvf_pfvf_mbox_intr(int __always_unused irq, void *arg)
 {
 	struct otx2_cptvf_dev *cptvf = arg;
@@ -106,6 +148,7 @@ void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work)
 
 	cptvf = container_of(work, struct otx2_cptvf_dev, pfvf_mbox_work);
 	pfvf_mbox = &cptvf->pfvf_mbox;
+	otx2_cpt_sync_mbox_bbuf(pfvf_mbox, 0);
 	mdev = &pfvf_mbox->dev[0];
 	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + pfvf_mbox->rx_start);
 	if (rsp_hdr->num_msgs == 0)
-- 
2.29.0

