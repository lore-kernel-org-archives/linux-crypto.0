Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9E0C4167D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Nov 2023 05:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjKCFeK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Nov 2023 01:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjKCFeC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2023 01:34:02 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4550C1BC;
        Thu,  2 Nov 2023 22:33:56 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2LI7TU025175;
        Thu, 2 Nov 2023 22:33:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=RouRC90iUnGmzQEJwDOWvRMGZYb2s/pGqXig6p8hTpM=;
 b=FFD1nP6HpsTEimcdnZuqbZf7nbKuiUI5+8aRtydpq018uCSn5K6aGN56mcCm1ny77Rse
 BiJmOhLR50plORy4SLgZ6++fcNuibh1jDGZUqePVSyV63w5MUSUeshB1MfqARIy+okEN
 4DpFfsnVyro+9L9rQUqqKZBCJKYpB2YVfUeGvV6djAQYhHYfb7X/Resb7p50GlNDFLmi
 W8n7Rj0FRhYbDgeA8RiysrJO2D8Uga3GFNX+rK+XQgmKOGJ27wMNpTTCVR8VpFQQ3Ggn
 K4AFxbID8gm2i/gG6RBzNjcIPCDGB8y841Q44Qsf5BjGh4MC0wa1Ejcf0LWSEgwNR45Q 0w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3u3y235e16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Nov 2023 22:33:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 2 Nov
 2023 22:33:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 2 Nov 2023 22:33:48 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 999AB3F705E;
        Thu,  2 Nov 2023 22:33:45 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <sgoutham@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v1 10/10] crypto: octeontx2: support setting ctx ilen for inline CPT LF
Date:   Fri, 3 Nov 2023 11:03:06 +0530
Message-ID: <20231103053306.2259753-11-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231103053306.2259753-1-schalla@marvell.com>
References: <20231103053306.2259753-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: u3SDPRBcqccQn5hRQ4NZjmL0wMRFsmrD
X-Proofpoint-GUID: u3SDPRBcqccQn5hRQ4NZjmL0wMRFsmrD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_05,2023-11-02_03,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Provide an option in Inline IPsec configure mailbox to configure the
CPT_AF_LFX_CTL:CTX_ILEN for inline CPT LF attached to CPT RVU PF.
This is needed to set the ctx ilen to size of inbound SA for
HW errata IPBUCPT-38756. Not setting this would lead to new context's
not being fetched.

Also set FLR_FLUSH in CPT_LF_CTX_CTL for CPT LF's as workaround
for same errata.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  2 ++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  4 ++-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 33 +++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 17 ++++++++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  5 +++
 5 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 3caa5245df1d..f8abe3ab15cb 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -59,6 +59,8 @@ struct otx2_cpt_rx_inline_lf_cfg {
 	u32 credit_th;
 	u16 bpid;
 	u32 reserved;
+	u8 ctx_ilen_valid : 1;
+	u8 ctx_ilen : 7;
 };
 
 /*
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
index 06bcf49ee379..7e746a4def86 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -102,6 +102,7 @@
 #define OTX2_CPT_LF_Q_INST_PTR          (0x110)
 #define OTX2_CPT_LF_Q_GRP_PTR           (0x120)
 #define OTX2_CPT_LF_NQX(a)              (0x400 | (a) << 3)
+#define OTX2_CPT_LF_CTX_CTL             (0x500)
 #define OTX2_CPT_LF_CTX_FLUSH           (0x510)
 #define OTX2_CPT_LF_CTX_ERR             (0x520)
 #define OTX2_CPT_RVU_FUNC_BLKADDR_SHIFT 20
@@ -472,7 +473,8 @@ union otx2_cptx_af_lf_ctrl {
 		u64 cont_err:1;
 		u64 reserved_11_15:5;
 		u64 nixtx_en:1;
-		u64 reserved_17_47:31;
+		u64 ctx_ilen:3;
+		u64 reserved_17_47:28;
 		u64 grp:8;
 		u64 reserved_56_63:8;
 	} s;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index d7805e672047..571a8ec154e9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -106,6 +106,33 @@ static int cptlf_set_grp_and_pri(struct otx2_cptlfs_info *lfs,
 	return ret;
 }
 
+static int cptlf_set_ctx_ilen(struct otx2_cptlfs_info *lfs, int ctx_ilen)
+{
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	struct otx2_cptlf_info *lf;
+	int slot, ret = 0;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		lf = &lfs->lf[slot];
+
+		ret = otx2_cpt_read_af_reg(lfs->mbox, lfs->pdev,
+					   CPT_AF_LFX_CTL(lf->slot),
+					   &lf_ctrl.u, lfs->blkaddr);
+		if (ret)
+			return ret;
+
+		lf_ctrl.s.ctx_ilen = ctx_ilen;
+
+		ret = otx2_cpt_write_af_reg(lfs->mbox, lfs->pdev,
+					    CPT_AF_LFX_CTL(lf->slot),
+					    lf_ctrl.u, lfs->blkaddr);
+		if (ret)
+			return ret;
+
+	}
+	return ret;
+}
+
 static void cptlf_hw_init(struct otx2_cptlfs_info *lfs)
 {
 	/* Disable instruction queues */
@@ -440,6 +467,12 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 	if (ret)
 		goto free_iq;
 
+	if (lfs->ctx_ilen_ovrd) {
+		ret = cptlf_set_ctx_ilen(lfs, lfs->ctx_ilen);
+		if (ret)
+			goto free_iq;
+	}
+
 	return 0;
 
 free_iq:
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index f6138da945e9..cf4c055c50f4 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -120,6 +120,8 @@ struct otx2_cptlfs_info {
 	atomic_t state;         /* LF's state. started/reset */
 	int blkaddr;            /* CPT blkaddr: BLKADDR_CPT0/BLKADDR_CPT1 */
 	int global_slot;        /* Global slot across the blocks */
+	u8 ctx_ilen;
+	u8 ctx_ilen_ovrd;
 };
 
 static inline void otx2_cpt_free_instruction_queues(
@@ -309,6 +311,17 @@ static inline void otx2_cptlf_set_iqueue_exec(struct otx2_cptlf_info *lf,
 			 OTX2_CPT_LF_INPROG, lf_inprog.u);
 }
 
+static inline void otx2_cptlf_set_ctx_flr_flush(struct otx2_cptlf_info *lf)
+{
+	u8 blkaddr = lf->lfs->blkaddr;
+	u64 val;
+
+	val = otx2_cpt_read64(lf->lfs->reg_base, blkaddr, lf->slot, OTX2_CPT_LF_CTX_CTL);
+	val |= BIT_ULL(0);
+
+	otx2_cpt_write64(lf->lfs->reg_base, blkaddr, lf->slot, OTX2_CPT_LF_CTX_CTL, val);
+}
+
 static inline void otx2_cptlf_enable_iqueue_exec(struct otx2_cptlf_info *lf)
 {
 	otx2_cptlf_set_iqueue_exec(lf, true);
@@ -324,6 +337,10 @@ static inline void otx2_cptlf_enable_iqueues(struct otx2_cptlfs_info *lfs)
 	int slot;
 
 	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		/* Enable flush on FLR for Errata */
+		if (is_dev_cn10kb(lfs->pdev))
+			otx2_cptlf_set_ctx_flr_flush(&lfs->lf[slot]);
+
 		otx2_cptlf_enable_iqueue_exec(&lfs->lf[slot]);
 		otx2_cptlf_enable_iqueue_enq(&lfs->lf[slot]);
 	}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index f7cb4ec74153..fd9632d2de03 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -267,6 +267,9 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 	otx2_cptlf_set_dev_info(&cptpf->lfs, cptpf->pdev, cptpf->reg_base,
 				&cptpf->afpf_mbox, BLKADDR_CPT0);
 	cptpf->lfs.global_slot = 0;
+	cptpf->lfs.ctx_ilen_ovrd = cfg_req->ctx_ilen_valid;
+	cptpf->lfs.ctx_ilen = cfg_req->ctx_ilen;
+
 	ret = otx2_inline_cptlf_setup(cptpf, &cptpf->lfs, egrp, num_lfs);
 	if (ret) {
 		dev_err(&cptpf->pdev->dev, "Inline CPT0 LF setup failed.\n");
@@ -279,6 +282,8 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 					cptpf->reg_base, &cptpf->afpf_mbox,
 					BLKADDR_CPT1);
 		cptpf->cpt1_lfs.global_slot = num_lfs;
+		cptpf->cpt1_lfs.ctx_ilen_ovrd = cfg_req->ctx_ilen_valid;
+		cptpf->cpt1_lfs.ctx_ilen = cfg_req->ctx_ilen;
 		ret = otx2_inline_cptlf_setup(cptpf, &cptpf->cpt1_lfs, egrp, num_lfs);
 		if (ret) {
 			dev_err(&cptpf->pdev->dev, "Inline CPT1 LF setup failed.\n");
-- 
2.25.1

