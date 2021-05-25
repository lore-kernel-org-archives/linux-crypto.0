Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5218C4707F
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4EA0610A0
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhEYLaB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 07:30:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1882 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231220AbhEYLaB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 07:30:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PBB3rT023202;
        Tue, 25 May 2021 04:28:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=EeZdrRoIdZ9dSTJyR4IwUT6OG0IhxYMVrlM01BwQf14=;
 b=NIa4T9IBkHuuiz88AcBEZ/z4iAnC8riJWd2QlG8A6ldqXRNoYqVqnEnJ6KAmIuca7b0e
 OFvOECEbmNTZrwW31SLy3HX28hQA6BPmgKqvkGwQzJp8GPzU7ofxDc3ZWQuCIF5wB/kR
 j4A57N/39VSbj/V4jPKtPZ+nfL6nSN8qSLjI5ONOPA0RRknX3Ss+Dqv09gyiDr/zmr/w
 hSE7cib9vbc5Npt7bl3UYcasmOGocsgOMVZhCA7PxZ1U8bpZVzgq5QPtxsxBTz0Q8lSK
 JHTvrW0Qrn3Pxrztl0D3aNx3V1srkJLfvgXNoGN2wuurtDn5DVlNizMKCMr84XgU/sWY Vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38rphp23d0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 04:28:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 04:27:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 04:27:52 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id B12743F703F;
        Tue, 25 May 2021 04:27:50 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>, <jerinj@marvell.com>,
        "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH 2/4] crypto: octeontx2: add support to map LMTST region for CN10K
Date:   Tue, 25 May 2021 16:57:16 +0530
Message-ID: <20210525112718.18288-3-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210525112718.18288-1-schalla@marvell.com>
References: <20210525112718.18288-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: wqaGkQmSG91MvXYxj_bHUa60_WzlSOvf
X-Proofpoint-ORIG-GUID: wqaGkQmSG91MvXYxj_bHUa60_WzlSOvf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On CN10K platform transmit/receive buffer alloc and free from/to
hardware had changed to support burst operation. Whereas pervious
silicon's only support single buffer free at a time.
To Support the same firmware allocates a DRAM region for each PF/VF for
storing LMTLINES. These LMTLINES are used to send CPT commands to HW.
PF/VF LMTST region is accessed via BAR4. PFs LMTST region is followed
by its VFs mbox memory. The size of region varies from 2KB to 256KB
based on number of LMTLINES configured.

This patch adds support for mapping of PF/VF LMTST region.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     |  5 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  | 53 +++++++++++++++++++
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  | 13 +++++
 .../marvell/octeontx2/otx2_cpt_common.h       |  5 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  2 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  5 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |  6 +++
 7 files changed, 86 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.c
 create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.h

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index 10e1fe056a9e..c242d22008c3 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -2,9 +2,10 @@
 obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += rvu_cptpf.o rvu_cptvf.o
 
 rvu_cptpf-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
-		  otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
+		  otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o \
+		  cn10k_cpt.o
 rvu_cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
 		  otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
-		  otx2_cptvf_algs.o
+		  otx2_cptvf_algs.o cn10k_cpt.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
new file mode 100644
index 000000000000..57cf156934ab
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2021 Marvell. */
+
+#include "otx2_cptpf.h"
+#include "otx2_cptvf.h"
+#include "otx2_cptlf.h"
+#include "cn10k_cpt.h"
+
+int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf)
+{
+	struct pci_dev *pdev = cptpf->pdev;
+	resource_size_t size;
+	u64 lmt_base;
+
+	if (!test_bit(CN10K_LMTST, &cptpf->cap_flag))
+		return 0;
+
+	lmt_base = readq(cptpf->reg_base + RVU_PF_LMTLINE_ADDR);
+	if (!lmt_base) {
+		dev_err(&pdev->dev, "PF LMTLINE address not configured\n");
+		return -ENOMEM;
+	}
+	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
+	size -= ((1 + cptpf->max_vfs) * MBOX_SIZE);
+	cptpf->lfs.lmt_base = devm_ioremap_wc(&pdev->dev, lmt_base, size);
+	if (!cptpf->lfs.lmt_base) {
+		dev_err(&pdev->dev,
+			"Mapping of PF LMTLINE address failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
+{
+	struct pci_dev *pdev = cptvf->pdev;
+	resource_size_t offset, size;
+
+	if (!test_bit(CN10K_LMTST, &cptvf->cap_flag))
+		return 0;
+
+	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
+	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
+	/* Map VF LMILINE region */
+	cptvf->lfs.lmt_base = devm_ioremap_wc(&pdev->dev, offset, size);
+	if (!cptvf->lfs.lmt_base) {
+		dev_err(&pdev->dev, "Unable to map BAR4\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
new file mode 100644
index 000000000000..b9a8c463eaf3
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2021 Marvell.
+ */
+#ifndef __CN10K_CPT_H
+#define __CN10K_CPT_H
+
+#include "otx2_cptpf.h"
+#include "otx2_cptvf.h"
+
+int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);
+int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);
+
+#endif /* __CN10K_CPTLF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 414427dcfa61..c5445b05f53c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -27,6 +27,7 @@
 
 /* HW capability flags */
 #define CN10K_MBOX  0
+#define CN10K_LMTST 1
 
 #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
 
@@ -131,8 +132,10 @@ static inline bool is_dev_otx2(struct pci_dev *pdev)
 static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 					unsigned long *cap_flag)
 {
-	if (!is_dev_otx2(pdev))
+	if (!is_dev_otx2(pdev)) {
 		__set_bit(CN10K_MBOX, cap_flag);
+		__set_bit(CN10K_LMTST, cap_flag);
+	}
 }
 
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index ab1678fc564d..c87c18e31171 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -87,6 +87,8 @@ struct otx2_cptlf_info {
 struct otx2_cptlfs_info {
 	/* Registers start address of VF/PF LFs are attached to */
 	void __iomem *reg_base;
+#define LMTLINE_SIZE  128
+	void __iomem *lmt_base;
 	struct pci_dev *pdev;   /* Device LFs are attached to */
 	struct otx2_cptlf_info lf[OTX2_CPT_MAX_LFS_NUM];
 	struct otx2_mbox *mbox;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index d341aecd3dd2..4ec3a4613e74 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -6,6 +6,7 @@
 #include "otx2_cpt_common.h"
 #include "otx2_cptpf_ucode.h"
 #include "otx2_cptpf.h"
+#include "cn10k_cpt.h"
 #include "rvu_reg.h"
 
 #define OTX2_CPT_DRV_NAME    "rvu_cptpf"
@@ -677,6 +678,10 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 
 	cptpf->max_vfs = pci_sriov_get_totalvfs(pdev);
 
+	err = cn10k_cptpf_lmtst_init(cptpf);
+	if (err)
+		goto unregister_intr;
+
 	/* Initialize CPT PF device */
 	err = cptpf_device_init(cptpf);
 	if (err)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 5178e0688d75..3411e664cf50 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -5,6 +5,7 @@
 #include "otx2_cptvf.h"
 #include "otx2_cptlf.h"
 #include "otx2_cptvf_algs.h"
+#include "cn10k_cpt.h"
 #include <rvu_reg.h>
 
 #define OTX2_CPTVF_DRV_NAME "rvu_cptvf"
@@ -364,6 +365,11 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 	cptvf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
 
 	otx2_cpt_set_hw_caps(pdev, &cptvf->cap_flag);
+
+	ret = cn10k_cptvf_lmtst_init(cptvf);
+	if (ret)
+		goto clear_drvdata;
+
 	/* Initialize PF<=>VF mailbox */
 	ret = cptvf_pfvf_mbox_init(cptvf);
 	if (ret)
-- 
2.29.0

