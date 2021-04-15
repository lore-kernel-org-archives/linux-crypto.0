Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D63C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 12:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4C761152
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 12:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhDOM3V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:29:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26570 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230056AbhDOM3U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Apr 2021 08:29:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FC9ehm002045;
        Thu, 15 Apr 2021 05:28:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=WeQ6MKbptIImu6T30PYfHMfQ+kH79n+DRDQCwcRtqZM=;
 b=ikebiLwL2ilRz61P6ARh+Bnv6I2/S8rJnEHKO3opIEvQSBZmqax2UFZ0+rdk4TGlbIOh
 FjxfdhTj3np+2/qGf7p99g3Z/tzKpeBrqvIkABFvjxbL4DtvqeIeooV9un2KVKvl5jFp
 KqBCJ45hwf0NeN0/Y2A1HG3fEUjr9SWZJPCiaCWe9RprbWsJC2Viib6MkIBNW0Osgv06
 Sl25FbpN1H1//8r3Avd2hzbImTE6lAhGdLAdJK/6ZEtg7qOJx/iSuke8NVZjWpa2CSvJ
 KPZxP6GhFO02SlIgQV9GVHMbROtTEBuIszMRjpDh7FkkUsxRWNthTokx2kiuG7a0S9Ve RQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37xcn4sh9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 05:28:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 15 Apr
 2021 05:28:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 15 Apr 2021 05:28:48 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 2D6633F703F;
        Thu, 15 Apr 2021 05:28:45 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <jerinj@marvell.com>, <pathreya@marvell.com>,
        <sgoutham@marvell.com>, "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH] crypto: octeontx2: add support for OcteonTX2 98xx CPT block.
Date:   Thu, 15 Apr 2021 17:58:37 +0530
Message-ID: <20210415122837.20506-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rMdwmEiXSyNQln2pKwYtXbQifg9iHfUy
X-Proofpoint-GUID: rMdwmEiXSyNQln2pKwYtXbQifg9iHfUy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_04:2021-04-15,2021-04-15 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

OcteonTX2 series of silicons have multiple variants, the
98xx variant has two crypto (CPT0 & CPT1) blocks. This patch
adds support for firmware load on new CPT block(CPT1).

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  10 +-
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  14 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |   8 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   1 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   1 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  33 +++-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 144 +++++++++++++-----
 7 files changed, 153 insertions(+), 58 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 3518fac29834..ecedd91a8d85 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -121,14 +121,14 @@ int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
 int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox,
 				  struct pci_dev *pdev);
-int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox,
-			     struct pci_dev *pdev, u64 reg, u64 *val);
+int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			     u64 reg, u64 *val, int blkaddr);
 int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			      u64 reg, u64 val);
+			      u64 reg, u64 val, int blkaddr);
 int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			 u64 reg, u64 *val);
+			 u64 reg, u64 *val, int blkaddr);
 int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			  u64 reg, u64 val);
+			  u64 reg, u64 val, int blkaddr);
 struct otx2_cptlfs_info;
 int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs);
 int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index 51cb6404ded7..9074876d38e5 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -43,7 +43,7 @@ int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox, struct pci_dev *pdev)
 }
 
 int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			     u64 reg, u64 *val)
+			     u64 reg, u64 *val, int blkaddr)
 {
 	struct cpt_rd_wr_reg_msg *reg_msg;
 
@@ -62,12 +62,13 @@ int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 	reg_msg->is_write = 0;
 	reg_msg->reg_offset = reg;
 	reg_msg->ret_val = val;
+	reg_msg->blkaddr = blkaddr;
 
 	return 0;
 }
 
 int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			      u64 reg, u64 val)
+			      u64 reg, u64 val, int blkaddr)
 {
 	struct cpt_rd_wr_reg_msg *reg_msg;
 
@@ -86,16 +87,17 @@ int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 	reg_msg->is_write = 1;
 	reg_msg->reg_offset = reg;
 	reg_msg->val = val;
+	reg_msg->blkaddr = blkaddr;
 
 	return 0;
 }
 
 int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			 u64 reg, u64 *val)
+			 u64 reg, u64 *val, int blkaddr)
 {
 	int ret;
 
-	ret = otx2_cpt_add_read_af_reg(mbox, pdev, reg, val);
+	ret = otx2_cpt_add_read_af_reg(mbox, pdev, reg, val, blkaddr);
 	if (ret)
 		return ret;
 
@@ -103,11 +105,11 @@ int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 }
 
 int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			  u64 reg, u64 val)
+			  u64 reg, u64 val, int blkaddr)
 {
 	int ret;
 
-	ret = otx2_cpt_add_write_af_reg(mbox, pdev, reg, val);
+	ret = otx2_cpt_add_write_af_reg(mbox, pdev, reg, val, blkaddr);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index 823a4571fd67..34aba1532761 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -56,7 +56,7 @@ static int cptlf_set_pri(struct otx2_cptlf_info *lf, int pri)
 
 	ret = otx2_cpt_read_af_reg(lfs->mbox, lfs->pdev,
 				   CPT_AF_LFX_CTL(lf->slot),
-				   &lf_ctrl.u);
+				   &lf_ctrl.u, lfs->blkaddr);
 	if (ret)
 		return ret;
 
@@ -64,7 +64,7 @@ static int cptlf_set_pri(struct otx2_cptlf_info *lf, int pri)
 
 	ret = otx2_cpt_write_af_reg(lfs->mbox, lfs->pdev,
 				    CPT_AF_LFX_CTL(lf->slot),
-				    lf_ctrl.u);
+				    lf_ctrl.u, lfs->blkaddr);
 	return ret;
 }
 
@@ -77,7 +77,7 @@ static int cptlf_set_eng_grps_mask(struct otx2_cptlf_info *lf,
 
 	ret = otx2_cpt_read_af_reg(lfs->mbox, lfs->pdev,
 				   CPT_AF_LFX_CTL(lf->slot),
-				   &lf_ctrl.u);
+				   &lf_ctrl.u, lfs->blkaddr);
 	if (ret)
 		return ret;
 
@@ -85,7 +85,7 @@ static int cptlf_set_eng_grps_mask(struct otx2_cptlf_info *lf,
 
 	ret = otx2_cpt_write_af_reg(lfs->mbox, lfs->pdev,
 				    CPT_AF_LFX_CTL(lf->slot),
-				    lf_ctrl.u);
+				    lf_ctrl.u, lfs->blkaddr);
 	return ret;
 }
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index 314e97354100..ab1678fc564d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -95,6 +95,7 @@ struct otx2_cptlfs_info {
 	u8 kcrypto_eng_grp_num;	/* Kernel crypto engine group number */
 	u8 kvf_limits;          /* Kernel crypto limits */
 	atomic_t state;         /* LF's state. started/reset */
+	int blkaddr;            /* CPT blkaddr: BLKADDR_CPT0/BLKADDR_CPT1 */
 };
 
 static inline void otx2_cpt_free_instruction_queues(
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 8c899ad531a5..e19af1356f12 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -51,6 +51,7 @@ struct otx2_cptpf_dev {
 	u8 max_vfs;		/* Maximum number of VFs supported by CPT */
 	u8 enabled_vfs;		/* Number of enabled VFs */
 	u8 kvf_limits;		/* Kernel crypto limits */
+	bool has_cpt1;
 };
 
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 5277e04badd9..58f47e3ab62e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -451,19 +451,19 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
 	return 0;
 }
 
-static int cptpf_device_reset(struct otx2_cptpf_dev *cptpf)
+static int cptx_device_reset(struct otx2_cptpf_dev *cptpf, int blkaddr)
 {
 	int timeout = 10, ret;
 	u64 reg = 0;
 
 	ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-				    CPT_AF_BLK_RST, 0x1);
+				    CPT_AF_BLK_RST, 0x1, blkaddr);
 	if (ret)
 		return ret;
 
 	do {
 		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-					   CPT_AF_BLK_RST, &reg);
+					   CPT_AF_BLK_RST, &reg, blkaddr);
 		if (ret)
 			return ret;
 
@@ -478,11 +478,35 @@ static int cptpf_device_reset(struct otx2_cptpf_dev *cptpf)
 	return ret;
 }
 
+static int cptpf_device_reset(struct otx2_cptpf_dev *cptpf)
+{
+	int ret = 0;
+
+	if (cptpf->has_cpt1) {
+		ret = cptx_device_reset(cptpf, BLKADDR_CPT1);
+		if (ret)
+			return ret;
+	}
+	return cptx_device_reset(cptpf, BLKADDR_CPT0);
+}
+
+static void cptpf_check_block_implemented(struct otx2_cptpf_dev *cptpf)
+{
+	u64 cfg;
+
+	cfg = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			      RVU_PF_BLOCK_ADDRX_DISC(BLKADDR_CPT1));
+	if (cfg & BIT_ULL(11))
+		cptpf->has_cpt1 = true;
+}
+
 static int cptpf_device_init(struct otx2_cptpf_dev *cptpf)
 {
 	union otx2_cptx_af_constants1 af_cnsts1 = {0};
 	int ret = 0;
 
+	/* check if 'implemented' bit is set for block BLKADDR_CPT1 */
+	cptpf_check_block_implemented(cptpf);
 	/* Reset the CPT PF device */
 	ret = cptpf_device_reset(cptpf);
 	if (ret)
@@ -490,7 +514,8 @@ static int cptpf_device_init(struct otx2_cptpf_dev *cptpf)
 
 	/* Get number of SE, IE and AE engines */
 	ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-				   CPT_AF_CONSTANTS1, &af_cnsts1.u);
+				   CPT_AF_CONSTANTS1, &af_cnsts1.u,
+				   BLKADDR_CPT0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 1dc3ba298139..a531f4c8b441 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -153,16 +153,16 @@ static int get_ucode_type(struct device *dev,
 }
 
 static int __write_ucode_base(struct otx2_cptpf_dev *cptpf, int eng,
-			      dma_addr_t dma_addr)
+			      dma_addr_t dma_addr, int blkaddr)
 {
 	return otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
 				     CPT_AF_EXEX_UCODE_BASE(eng),
-				     (u64)dma_addr);
+				     (u64)dma_addr, blkaddr);
 }
 
-static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
+static int cptx_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp,
+			       struct otx2_cptpf_dev *cptpf, int blkaddr)
 {
-	struct otx2_cptpf_dev *cptpf = obj;
 	struct otx2_cpt_engs_rsvd *engs;
 	dma_addr_t dma_addr;
 	int i, bit, ret;
@@ -170,7 +170,7 @@ static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
 	/* Set PF number for microcode fetches */
 	ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
 				    CPT_AF_PF_FUNC,
-				    cptpf->pf_id << RVU_PFVF_PF_SHIFT);
+				    cptpf->pf_id << RVU_PFVF_PF_SHIFT, blkaddr);
 	if (ret)
 		return ret;
 
@@ -187,7 +187,8 @@ static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
 		 */
 		for_each_set_bit(bit, engs->bmap, eng_grp->g->engs_num)
 			if (!eng_grp->g->eng_ref_cnt[bit]) {
-				ret = __write_ucode_base(cptpf, bit, dma_addr);
+				ret = __write_ucode_base(cptpf, bit, dma_addr,
+							 blkaddr);
 				if (ret)
 					return ret;
 			}
@@ -195,23 +196,32 @@ static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
 	return 0;
 }
 
-static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
-					void *obj)
+static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
 {
 	struct otx2_cptpf_dev *cptpf = obj;
-	struct otx2_cpt_bitmap bmap;
+	int ret;
+
+	if (cptpf->has_cpt1) {
+		ret = cptx_set_ucode_base(eng_grp, cptpf, BLKADDR_CPT1);
+		if (ret)
+			return ret;
+	}
+	return cptx_set_ucode_base(eng_grp, cptpf, BLKADDR_CPT0);
+}
+
+static int cptx_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+					 struct otx2_cptpf_dev *cptpf,
+					 struct otx2_cpt_bitmap bmap,
+					 int blkaddr)
+{
 	int i, timeout = 10;
 	int busy, ret;
 	u64 reg = 0;
 
-	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
-	if (!bmap.size)
-		return -EINVAL;
-
 	/* Detach the cores from group */
 	for_each_set_bit(i, bmap.bits, bmap.size) {
 		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-					   CPT_AF_EXEX_CTL2(i), &reg);
+					   CPT_AF_EXEX_CTL2(i), &reg, blkaddr);
 		if (ret)
 			return ret;
 
@@ -221,7 +231,8 @@ static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 
 			ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox,
 						    cptpf->pdev,
-						    CPT_AF_EXEX_CTL2(i), reg);
+						    CPT_AF_EXEX_CTL2(i), reg,
+						    blkaddr);
 			if (ret)
 				return ret;
 		}
@@ -237,7 +248,8 @@ static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 		for_each_set_bit(i, bmap.bits, bmap.size) {
 			ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox,
 						   cptpf->pdev,
-						   CPT_AF_EXEX_STS(i), &reg);
+						   CPT_AF_EXEX_STS(i), &reg,
+						   blkaddr);
 			if (ret)
 				return ret;
 
@@ -253,7 +265,8 @@ static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 		if (!eng_grp->g->eng_ref_cnt[i]) {
 			ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox,
 						    cptpf->pdev,
-						    CPT_AF_EXEX_CTL(i), 0x0);
+						    CPT_AF_EXEX_CTL(i), 0x0,
+						    blkaddr);
 			if (ret)
 				return ret;
 		}
@@ -262,22 +275,39 @@ static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 	return 0;
 }
 
-static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
-				       void *obj)
+static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+					void *obj)
 {
 	struct otx2_cptpf_dev *cptpf = obj;
 	struct otx2_cpt_bitmap bmap;
-	u64 reg = 0;
-	int i, ret;
+	int ret;
 
 	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
 	if (!bmap.size)
 		return -EINVAL;
 
+	if (cptpf->has_cpt1) {
+		ret = cptx_detach_and_disable_cores(eng_grp, cptpf, bmap,
+						    BLKADDR_CPT1);
+		if (ret)
+			return ret;
+	}
+	return cptx_detach_and_disable_cores(eng_grp, cptpf, bmap,
+					     BLKADDR_CPT0);
+}
+
+static int cptx_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+					struct otx2_cptpf_dev *cptpf,
+					struct otx2_cpt_bitmap bmap,
+					int blkaddr)
+{
+	u64 reg = 0;
+	int i, ret;
+
 	/* Attach the cores to the group */
 	for_each_set_bit(i, bmap.bits, bmap.size) {
 		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-					   CPT_AF_EXEX_CTL2(i), &reg);
+					   CPT_AF_EXEX_CTL2(i), &reg, blkaddr);
 		if (ret)
 			return ret;
 
@@ -287,7 +317,8 @@ static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 
 			ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox,
 						    cptpf->pdev,
-						    CPT_AF_EXEX_CTL2(i), reg);
+						    CPT_AF_EXEX_CTL2(i), reg,
+						    blkaddr);
 			if (ret)
 				return ret;
 		}
@@ -295,15 +326,33 @@ static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 
 	/* Enable the cores */
 	for_each_set_bit(i, bmap.bits, bmap.size) {
-		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox,
-						cptpf->pdev,
-						CPT_AF_EXEX_CTL(i), 0x1);
+		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+						CPT_AF_EXEX_CTL(i), 0x1,
+						blkaddr);
 		if (ret)
 			return ret;
 	}
-	ret = otx2_cpt_send_af_reg_requests(&cptpf->afpf_mbox, cptpf->pdev);
+	return otx2_cpt_send_af_reg_requests(&cptpf->afpf_mbox, cptpf->pdev);
+}
 
-	return ret;
+static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+				       void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_bitmap bmap;
+	int ret;
+
+	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
+	if (!bmap.size)
+		return -EINVAL;
+
+	if (cptpf->has_cpt1) {
+		ret = cptx_attach_and_enable_cores(eng_grp, cptpf, bmap,
+						   BLKADDR_CPT1);
+		if (ret)
+			return ret;
+	}
+	return cptx_attach_and_enable_cores(eng_grp, cptpf, bmap, BLKADDR_CPT0);
 }
 
 static int load_fw(struct device *dev, struct fw_info_t *fw_info,
@@ -1140,20 +1189,18 @@ int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
 	return ret;
 }
 
-int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
+static int cptx_disable_all_cores(struct otx2_cptpf_dev *cptpf, int total_cores,
+				  int blkaddr)
 {
-	int i, ret, busy, total_cores;
-	int timeout = 10;
-	u64 reg = 0;
-
-	total_cores = cptpf->eng_grps.avail.max_se_cnt +
-		      cptpf->eng_grps.avail.max_ie_cnt +
-		      cptpf->eng_grps.avail.max_ae_cnt;
+	int timeout = 10, ret;
+	int i, busy;
+	u64 reg;
 
 	/* Disengage the cores from groups */
 	for (i = 0; i < total_cores; i++) {
 		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-						CPT_AF_EXEX_CTL2(i), 0x0);
+						CPT_AF_EXEX_CTL2(i), 0x0,
+						blkaddr);
 		if (ret)
 			return ret;
 
@@ -1173,7 +1220,8 @@ int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
 		for (i = 0; i < total_cores; i++) {
 			ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox,
 						   cptpf->pdev,
-						   CPT_AF_EXEX_STS(i), &reg);
+						   CPT_AF_EXEX_STS(i), &reg,
+						   blkaddr);
 			if (ret)
 				return ret;
 
@@ -1187,13 +1235,30 @@ int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
 	/* Disable the cores */
 	for (i = 0; i < total_cores; i++) {
 		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-						CPT_AF_EXEX_CTL(i), 0x0);
+						CPT_AF_EXEX_CTL(i), 0x0,
+						blkaddr);
 		if (ret)
 			return ret;
 	}
 	return otx2_cpt_send_af_reg_requests(&cptpf->afpf_mbox, cptpf->pdev);
 }
 
+int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
+{
+	int total_cores, ret;
+
+	total_cores = cptpf->eng_grps.avail.max_se_cnt +
+		      cptpf->eng_grps.avail.max_ie_cnt +
+		      cptpf->eng_grps.avail.max_ae_cnt;
+
+	if (cptpf->has_cpt1) {
+		ret = cptx_disable_all_cores(cptpf, total_cores, BLKADDR_CPT1);
+		if (ret)
+			return ret;
+	}
+	return cptx_disable_all_cores(cptpf, total_cores, BLKADDR_CPT0);
+}
+
 void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
 			       struct otx2_cpt_eng_grps *eng_grps)
 {
@@ -1354,6 +1419,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	lfs->pdev = pdev;
 	lfs->reg_base = cptpf->reg_base;
 	lfs->mbox = &cptpf->afpf_mbox;
+	lfs->blkaddr = BLKADDR_CPT0;
 	ret = otx2_cptlf_init(&cptpf->lfs, OTX2_CPT_ALL_ENG_GRPS_MASK,
 			      OTX2_CPT_QUEUE_HI_PRIO, 1);
 	if (ret)
-- 
2.29.0

