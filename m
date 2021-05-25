Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BAAC2B9F8
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E4161413
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhEYLaC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 07:30:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2708 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231220AbhEYLaC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 07:30:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PBB3rV023202;
        Tue, 25 May 2021 04:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=HHDextDNyznOuZTd1Jr24+t9lvB5gfQ3Dvrv4EYmJw4=;
 b=dzG0hWwJbRtEhu3FUcSbHVvSRwufr17/GhC2CM237O2a8jp7d/UnAR31hDK571wCQv81
 2hpnQj8t4SJexHReicvdOXv4ZHhUUiapTzFl1V5qbXxdVzfg6aT2xFzpqtbHHcqcbi4x
 fyQ/WJgzfgnXdzsEJRDNixGlmeRiFh7+7lbx7NFXY6520XfOUzSy1jj2LeD60xnbOT4x
 hoD1J4LNaAZMokmwmcRyto5EU2FtmNO164tu3vEVYdKua8UZq6B/V4iRsJMcXTIuV4z0
 wJJRy1jCb+1ceQK+XF+S/erzYoSGbm6dGvtmH+XsxemuW8I5JpKi4cdGNETYaZ/l1So1 pQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38rphp23d0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 04:28:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 04:27:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 04:27:57 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 337AD3F703F;
        Tue, 25 May 2021 04:27:54 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>, <jerinj@marvell.com>,
        "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH 3/4] crypto: octeontx2: add support for CPT operations on CN10K
Date:   Tue, 25 May 2021 16:57:17 +0530
Message-ID: <20210525112718.18288-4-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210525112718.18288-1-schalla@marvell.com>
References: <20210525112718.18288-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: o5IefFD3bHHmcLZjG8sy6RcJpZZgUGF_
X-Proofpoint-ORIG-GUID: o5IefFD3bHHmcLZjG8sy6RcJpZZgUGF_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CPT result format had changed for CN10K HW to accommodate more
fields. This patch adds support to use new result format and
new LMTST lines for CPT operations on CN10K platform.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  | 44 ++++++++++++++++++-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  | 23 ++++++++++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     | 13 +++++-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  9 +++-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  8 ++++
 .../marvell/octeontx2/otx2_cptpf_main.c       |  2 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 32 +++++++++++---
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  8 ++--
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 17 ++++---
 9 files changed, 134 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
index 57cf156934ab..1499ef75b5c2 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
@@ -1,20 +1,57 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (C) 2021 Marvell. */
 
+#include <linux/soc/marvell/octeontx2/asm.h>
 #include "otx2_cptpf.h"
 #include "otx2_cptvf.h"
 #include "otx2_cptlf.h"
 #include "cn10k_cpt.h"
 
+static struct cpt_hw_ops otx2_hw_ops = {
+	.send_cmd = otx2_cpt_send_cmd,
+	.cpt_get_compcode = otx2_cpt_get_compcode,
+	.cpt_get_uc_compcode = otx2_cpt_get_uc_compcode,
+};
+
+static struct cpt_hw_ops cn10k_hw_ops = {
+	.send_cmd = cn10k_cpt_send_cmd,
+	.cpt_get_compcode = cn10k_cpt_get_compcode,
+	.cpt_get_uc_compcode = cn10k_cpt_get_uc_compcode,
+};
+
+void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
+			struct otx2_cptlf_info *lf)
+{
+	void __iomem *lmtline = lf->lmtline;
+	u64 val = (lf->slot & 0x7FF);
+	u64 tar_addr = 0;
+
+	/* tar_addr<6:4> = Size of first LMTST - 1 in units of 128b. */
+	tar_addr |= (__force u64)lf->ioreg |
+		    (((OTX2_CPT_INST_SIZE/16) - 1) & 0x7) << 4;
+	/*
+	 * Make sure memory areas pointed in CPT_INST_S
+	 * are flushed before the instruction is sent to CPT
+	 */
+	dma_wmb();
+
+	/* Copy CPT command to LMTLINE */
+	memcpy_toio(lmtline, cptinst, insts_num * OTX2_CPT_INST_SIZE);
+	cn10k_lmt_flush(val, tar_addr);
+}
+
 int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf)
 {
 	struct pci_dev *pdev = cptpf->pdev;
 	resource_size_t size;
 	u64 lmt_base;
 
-	if (!test_bit(CN10K_LMTST, &cptpf->cap_flag))
+	if (!test_bit(CN10K_LMTST, &cptpf->cap_flag)) {
+		cptpf->lfs.ops = &otx2_hw_ops;
 		return 0;
+	}
 
+	cptpf->lfs.ops = &cn10k_hw_ops;
 	lmt_base = readq(cptpf->reg_base + RVU_PF_LMTLINE_ADDR);
 	if (!lmt_base) {
 		dev_err(&pdev->dev, "PF LMTLINE address not configured\n");
@@ -37,9 +74,12 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
 	struct pci_dev *pdev = cptvf->pdev;
 	resource_size_t offset, size;
 
-	if (!test_bit(CN10K_LMTST, &cptvf->cap_flag))
+	if (!test_bit(CN10K_LMTST, &cptvf->cap_flag)) {
+		cptvf->lfs.ops = &otx2_hw_ops;
 		return 0;
+	}
 
+	cptvf->lfs.ops = &cn10k_hw_ops;
 	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
 	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
 	/* Map VF LMILINE region */
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
index b9a8c463eaf3..c091392b47e0 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
@@ -4,9 +4,32 @@
 #ifndef __CN10K_CPT_H
 #define __CN10K_CPT_H
 
+#include "otx2_cpt_common.h"
 #include "otx2_cptpf.h"
 #include "otx2_cptvf.h"
 
+static inline u8 cn10k_cpt_get_compcode(union otx2_cpt_res_s *result)
+{
+	return ((struct cn10k_cpt_res_s *)result)->compcode;
+}
+
+static inline u8 cn10k_cpt_get_uc_compcode(union otx2_cpt_res_s *result)
+{
+	return ((struct cn10k_cpt_res_s *)result)->uc_compcode;
+}
+
+static inline u8 otx2_cpt_get_compcode(union otx2_cpt_res_s *result)
+{
+	return ((struct cn9k_cpt_res_s *)result)->compcode;
+}
+
+static inline u8 otx2_cpt_get_uc_compcode(union otx2_cpt_res_s *result)
+{
+	return ((struct cn9k_cpt_res_s *)result)->uc_compcode;
+}
+
+void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
+			struct otx2_cptlf_info *lf);
 int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);
 int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
index 391a457f7116..6f947978e4e8 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -138,7 +138,7 @@ enum otx2_cpt_comp_e {
 	OTX2_CPT_COMP_E_FAULT = 0x02,
 	OTX2_CPT_COMP_E_HWERR = 0x04,
 	OTX2_CPT_COMP_E_INSTERR = 0x05,
-	OTX2_CPT_COMP_E_LAST_ENTRY = 0x06
+	OTX2_CPT_COMP_E_WARN = 0x06
 };
 
 /*
@@ -269,13 +269,22 @@ union otx2_cpt_inst_s {
 union otx2_cpt_res_s {
 	u64 u[2];
 
-	struct {
+	struct cn9k_cpt_res_s {
 		u64 compcode:8;
 		u64 uc_compcode:8;
 		u64 doneint:1;
 		u64 reserved_17_63:47;
 		u64 reserved_64_127;
 	} s;
+
+	struct cn10k_cpt_res_s {
+		u64 compcode:7;
+		u64 doneint:1;
+		u64 uc_compcode:8;
+		u64 rlen:16;
+		u64 spi:32;
+		u64 esn;
+	} cn10k;
 };
 
 /*
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index 34aba1532761..c8350fcd60fa 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -379,9 +379,14 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 	for (slot = 0; slot < lfs->lfs_num; slot++) {
 		lfs->lf[slot].lfs = lfs;
 		lfs->lf[slot].slot = slot;
-		lfs->lf[slot].lmtline = lfs->reg_base +
-			OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_LMT, slot,
+		if (lfs->lmt_base)
+			lfs->lf[slot].lmtline = lfs->lmt_base +
+						(slot * LMTLINE_SIZE);
+		else
+			lfs->lf[slot].lmtline = lfs->reg_base +
+				OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_LMT, slot,
 						 OTX2_CPT_LMT_LF_LMTLINEX(0));
+
 		lfs->lf[slot].ioreg = lfs->reg_base +
 			OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_CPT0, slot,
 						 OTX2_CPT_LF_NQX(0));
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index c87c18e31171..b691b6c1d5c4 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -84,6 +84,13 @@ struct otx2_cptlf_info {
 	struct otx2_cptlf_wqe *wqe;       /* Tasklet work info */
 };
 
+struct cpt_hw_ops {
+	void (*send_cmd)(union otx2_cpt_inst_s *cptinst, u32 insts_num,
+			 struct otx2_cptlf_info *lf);
+	u8 (*cpt_get_compcode)(union otx2_cpt_res_s *result);
+	u8 (*cpt_get_uc_compcode)(union otx2_cpt_res_s *result);
+};
+
 struct otx2_cptlfs_info {
 	/* Registers start address of VF/PF LFs are attached to */
 	void __iomem *reg_base;
@@ -92,6 +99,7 @@ struct otx2_cptlfs_info {
 	struct pci_dev *pdev;   /* Device LFs are attached to */
 	struct otx2_cptlf_info lf[OTX2_CPT_MAX_LFS_NUM];
 	struct otx2_mbox *mbox;
+	struct cpt_hw_ops *ops;
 	u8 are_lfs_attached;	/* Whether CPT LFs are attached */
 	u8 lfs_num;		/* Number of CPT LFs */
 	u8 kcrypto_eng_grp_num;	/* Kernel crypto engine group number */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 4ec3a4613e74..1fb04f9bb7ac 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -586,7 +586,7 @@ static int cptpf_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	if (ret)
 		goto disable_intr;
 
-	ret = otx2_cpt_create_eng_grps(cptpf->pdev, &cptpf->eng_grps);
+	ret = otx2_cpt_create_eng_grps(cptpf, &cptpf->eng_grps);
 	if (ret)
 		goto disable_intr;
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index a531f4c8b441..dff34b3ec09e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -16,6 +16,8 @@
 #define LOADFVC_MAJOR_OP 0x01
 #define LOADFVC_MINOR_OP 0x08
 
+#define CTX_FLUSH_TIMER_CNT 0xFFFFFF
+
 struct fw_info_t {
 	struct list_head ucodes;
 };
@@ -666,7 +668,8 @@ static int reserve_engines(struct device *dev,
 static void ucode_unload(struct device *dev, struct otx2_cpt_ucode *ucode)
 {
 	if (ucode->va) {
-		dma_free_coherent(dev, ucode->size, ucode->va, ucode->dma);
+		dma_free_coherent(dev, OTX2_CPT_UCODE_SZ, ucode->va,
+				  ucode->dma);
 		ucode->va = NULL;
 		ucode->dma = 0;
 		ucode->size = 0;
@@ -685,7 +688,7 @@ static int copy_ucode_to_dma_mem(struct device *dev,
 	u32 i;
 
 	/*  Allocate DMAable space */
-	ucode->va = dma_alloc_coherent(dev, ucode->size, &ucode->dma,
+	ucode->va = dma_alloc_coherent(dev, OTX2_CPT_UCODE_SZ, &ucode->dma,
 				       GFP_KERNEL);
 	if (!ucode->va)
 		return -ENOMEM;
@@ -1100,11 +1103,12 @@ int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type)
 	return eng_grp_num;
 }
 
-int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
+int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 			     struct otx2_cpt_eng_grps *eng_grps)
 {
 	struct otx2_cpt_uc_info_t *uc_info[OTX2_CPT_MAX_ETYPES_PER_GRP] = {  };
 	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
+	struct pci_dev *pdev = cptpf->pdev;
 	struct fw_info_t fw_info;
 	int ret;
 
@@ -1180,6 +1184,23 @@ int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
 	eng_grps->is_grps_created = true;
 
 	cpt_ucode_release_fw(&fw_info);
+
+	if (is_dev_otx2(pdev))
+		return 0;
+	/*
+	 * Configure engine group mask to allow context prefetching
+	 * for the groups.
+	 */
+	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL,
+			      OTX2_CPT_ALL_ENG_GRPS_MASK << 3 | BIT_ULL(16),
+			      BLKADDR_CPT0);
+	/*
+	 * Set interval to periodically flush dirty data for the next
+	 * CTX cache entry. Set the interval count to maximum supported
+	 * value.
+	 */
+	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTX_FLUSH_TIMER,
+			      CTX_FLUSH_TIMER_CNT, BLKADDR_CPT0);
 	return 0;
 
 delete_eng_grp:
@@ -1460,9 +1481,10 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 		iq_cmd.cptr.s.grp = otx2_cpt_get_eng_grp(&cptpf->eng_grps,
 							 etype);
 		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
-		otx2_cpt_send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
+		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
 
-		while (result->s.compcode == OTX2_CPT_COMPLETION_CODE_INIT)
+		while (lfs->ops->cpt_get_compcode(result) ==
+						OTX2_CPT_COMPLETION_CODE_INIT)
 			cpu_relax();
 
 		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
index 6b0d432de0af..fe019ab730b2 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -23,11 +23,13 @@
 /* Microcode version string length */
 #define OTX2_CPT_UCODE_VER_STR_SZ   44
 
-/* Maximum number of supported engines/cores on OcteonTX2 platform */
-#define OTX2_CPT_MAX_ENGINES        128
+/* Maximum number of supported engines/cores on OcteonTX2/CN10K platform */
+#define OTX2_CPT_MAX_ENGINES        144
 
 #define OTX2_CPT_ENGS_BITMASK_LEN   BITS_TO_LONGS(OTX2_CPT_MAX_ENGINES)
 
+#define OTX2_CPT_UCODE_SZ           (64 * 1024)
+
 /* Microcode types */
 enum otx2_cpt_ucode_type {
 	OTX2_CPT_AE_UC_TYPE = 1,  /* AE-MAIN */
@@ -153,7 +155,7 @@ int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 			   struct otx2_cpt_eng_grps *eng_grps);
 void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
 			       struct otx2_cpt_eng_grps *eng_grps);
-int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
+int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 			     struct otx2_cpt_eng_grps *eng_grps);
 int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf);
 int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index d5c1c1b7c7e4..811ded72ce5f 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -320,7 +320,7 @@ static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 			     cpt_req->dlen, false);
 
 	/* Send CPT command */
-	otx2_cpt_send_cmd(&cptinst, 1, lf);
+	lf->lfs->ops->send_cmd(&cptinst, 1, lf);
 
 	/*
 	 * We allocate and prepare pending queue entry in critical section
@@ -349,13 +349,14 @@ int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 			       &lfs->lf[cpu_num]);
 }
 
-static int cpt_process_ccode(struct pci_dev *pdev,
+static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
 			     union otx2_cpt_res_s *cpt_status,
 			     struct otx2_cpt_inst_info *info,
 			     u32 *res_code)
 {
-	u8 uc_ccode = cpt_status->s.uc_compcode;
-	u8 ccode = cpt_status->s.compcode;
+	u8 uc_ccode = lfs->ops->cpt_get_uc_compcode(cpt_status);
+	u8 ccode = lfs->ops->cpt_get_compcode(cpt_status);
+	struct pci_dev *pdev = lfs->pdev;
 
 	switch (ccode) {
 	case OTX2_CPT_COMP_E_FAULT:
@@ -389,6 +390,7 @@ static int cpt_process_ccode(struct pci_dev *pdev,
 		return 1;
 
 	case OTX2_CPT_COMP_E_GOOD:
+	case OTX2_CPT_COMP_E_WARN:
 		/*
 		 * Check microcode completion code, it is only valid
 		 * when completion code is CPT_COMP_E::GOOD
@@ -426,7 +428,7 @@ static int cpt_process_ccode(struct pci_dev *pdev,
 	return 0;
 }
 
-static inline void process_pending_queue(struct pci_dev *pdev,
+static inline void process_pending_queue(struct otx2_cptlfs_info *lfs,
 					 struct otx2_cpt_pending_queue *pqueue)
 {
 	struct otx2_cpt_pending_entry *resume_pentry = NULL;
@@ -436,6 +438,7 @@ static inline void process_pending_queue(struct pci_dev *pdev,
 	struct otx2_cpt_inst_info *info = NULL;
 	struct otx2_cpt_req_info *req = NULL;
 	struct crypto_async_request *areq;
+	struct pci_dev *pdev = lfs->pdev;
 	u32 res_code, resume_index;
 
 	while (1) {
@@ -476,7 +479,7 @@ static inline void process_pending_queue(struct pci_dev *pdev,
 			goto process_pentry;
 		}
 
-		if (cpt_process_ccode(pdev, cpt_status, info, &res_code)) {
+		if (cpt_process_ccode(lfs, cpt_status, info, &res_code)) {
 			spin_unlock_bh(&pqueue->lock);
 			return;
 		}
@@ -529,7 +532,7 @@ static inline void process_pending_queue(struct pci_dev *pdev,
 
 void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe)
 {
-	process_pending_queue(wqe->lfs->pdev,
+	process_pending_queue(wqe->lfs,
 			      &wqe->lfs->lf[wqe->lf_num].pqueue);
 }
 
-- 
2.29.0

