Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3C0C77B73
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Apr 2023 14:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbjDYOGf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 10:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjDYOGe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 10:06:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC633C15
        for <linux-crypto@vger.kernel.org>; Tue, 25 Apr 2023 07:06:31 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P9Em00013086;
        Tue, 25 Apr 2023 07:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qwB6efa0VZbVXKLnBrCFLsJNg3VeGdLqiwBhRhr+2XI=;
 b=DMTi+OvjY1txADrwn5wX8Toe5p9iCcqzFnT1kBCrwpVAu+YtUEwjeLFlerSCkVNQi017
 Xvz8U1lHc9fpKUVvUqOZ3AaHWY1cTtc5Etm1+I3Bc2Zv2hY0bwkiYljiO77MwIHKctuT
 C/lWzCoBjc3D0AdinsS7AMhsHf0Jjcg5sXFY9p8soGamYE2WBCcz3UdFRCjcHmwbVeW9
 NYOS9KroiiBX7vmS7F07PzWDP8oq7EhWbWgeCnCz+NE8fBS/ogGY8DpysW1DvPT7bhlL
 oeN4buS2tWXOhZXm6FdEwh/PdgAN0LdXbBRvQG3XxT+F5yCYRWQhWUIt8b3gY9y69B2U /Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2f94kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 07:06:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 07:06:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 07:06:25 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 5F69A3F7058;
        Tue, 25 Apr 2023 07:06:23 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>
Subject: [PATCH 1/2] crypto: octeontx2: add support for AF to CPT PF uplink mbox
Date:   Tue, 25 Apr 2023 19:36:19 +0530
Message-ID: <20230425140620.2031480-2-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230425140620.2031480-1-schalla@marvell.com>
References: <20230425140620.2031480-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: sZz2T5gYk9arr6esfRnTXoDKUYAYkddk
X-Proofpoint-ORIG-GUID: sZz2T5gYk9arr6esfRnTXoDKUYAYkddk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_06,2023-04-25_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for AF -> CPT PF uplink mailbox messages
and adds a mailbox handler to submit a CPT instruction from AF as
current architecture doesn't allow AF to submit CPT instruction
directly to HW.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  4 +
 .../marvell/octeontx2/otx2_cptpf_main.c       | 10 +++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 86 ++++++++++++++++++-
 3 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 936174b012e8..67ea070d5849 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -40,6 +40,9 @@ struct otx2_cptpf_dev {
 	struct work_struct	afpf_mbox_work;
 	struct workqueue_struct *afpf_mbox_wq;
 
+	struct otx2_mbox	afpf_mbox_up;
+	struct work_struct	afpf_mbox_up_work;
+
 	/* VF <=> PF mbox */
 	struct otx2_mbox	vfpf_mbox;
 	struct workqueue_struct *vfpf_mbox_wq;
@@ -61,6 +64,7 @@ struct otx2_cptpf_dev {
 
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
 void otx2_cptpf_afpf_mbox_handler(struct work_struct *work);
+void otx2_cptpf_afpf_mbox_up_handler(struct work_struct *work);
 irqreturn_t otx2_cptpf_vfpf_mbox_intr(int irq, void *arg);
 void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index ddf6e913c1c4..612a764b8a8c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -473,10 +473,19 @@ static int cptpf_afpf_mbox_init(struct otx2_cptpf_dev *cptpf)
 	if (err)
 		goto error;
 
+	err = otx2_mbox_init(&cptpf->afpf_mbox_up, cptpf->afpf_mbox_base,
+			     pdev, cptpf->reg_base, MBOX_DIR_PFAF_UP, 1);
+	if (err)
+		goto mbox_cleanup;
+
 	INIT_WORK(&cptpf->afpf_mbox_work, otx2_cptpf_afpf_mbox_handler);
+	INIT_WORK(&cptpf->afpf_mbox_up_work, otx2_cptpf_afpf_mbox_up_handler);
 	mutex_init(&cptpf->lock);
+
 	return 0;
 
+mbox_cleanup:
+	otx2_mbox_destroy(&cptpf->afpf_mbox);
 error:
 	destroy_workqueue(cptpf->afpf_mbox_wq);
 	return err;
@@ -486,6 +495,7 @@ static void cptpf_afpf_mbox_destroy(struct otx2_cptpf_dev *cptpf)
 {
 	destroy_workqueue(cptpf->afpf_mbox_wq);
 	otx2_mbox_destroy(&cptpf->afpf_mbox);
+	otx2_mbox_destroy(&cptpf->afpf_mbox_up);
 }
 
 static ssize_t kvf_limits_show(struct device *dev,
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index dee0aa60b698..d2216d1e9c2e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -224,14 +224,28 @@ void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work)
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int __always_unused irq, void *arg)
 {
 	struct otx2_cptpf_dev *cptpf = arg;
+	struct otx2_mbox_dev *mdev;
+	struct otx2_mbox *mbox;
+	struct mbox_hdr *hdr;
 	u64 intr;
 
 	/* Read the interrupt bits */
 	intr = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT);
 
 	if (intr & 0x1ULL) {
-		/* Schedule work queue function to process the MBOX request */
-		queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_work);
+		mbox = &cptpf->afpf_mbox;
+		mdev = &mbox->dev[0];
+		hdr = mdev->mbase + mbox->rx_start;
+		if (hdr->num_msgs)
+			/* Schedule work queue function to process the MBOX request */
+			queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_work);
+
+		mbox = &cptpf->afpf_mbox_up;
+		mdev = &mbox->dev[0];
+		hdr = mdev->mbase + mbox->rx_start;
+		if (hdr->num_msgs)
+			/* Schedule work queue function to process the MBOX request */
+			queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_up_work);
 		/* Clear and ack the interrupt */
 		otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT,
 				 0x1ULL);
@@ -367,3 +381,71 @@ void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
 	}
 	otx2_mbox_reset(afpf_mbox, 0);
 }
+
+static void handle_msg_cpt_inst_lmtst(struct otx2_cptpf_dev *cptpf,
+				      struct mbox_msghdr *msg)
+{
+	struct cpt_inst_lmtst_req *req = (struct cpt_inst_lmtst_req *)msg;
+	struct otx2_cptlfs_info *lfs = &cptpf->lfs;
+	struct msg_rsp *rsp;
+
+	if (cptpf->lfs.lfs_num)
+		lfs->ops->send_cmd((union otx2_cpt_inst_s *)req->inst, 1,
+				   &lfs->lf[0]);
+
+	rsp = (struct msg_rsp *)otx2_mbox_alloc_msg(&cptpf->afpf_mbox_up, 0,
+						    sizeof(*rsp));
+	if (!rsp)
+		return;
+
+	rsp->hdr.id = msg->id;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = 0;
+	rsp->hdr.rc = 0;
+}
+
+static void process_afpf_mbox_up_msg(struct otx2_cptpf_dev *cptpf,
+				     struct mbox_msghdr *msg)
+{
+	if (msg->id >= MBOX_MSG_MAX) {
+		dev_err(&cptpf->pdev->dev,
+			"MBOX msg with unknown ID %d\n", msg->id);
+		return;
+	}
+
+	switch (msg->id) {
+	case MBOX_MSG_CPT_INST_LMTST:
+		handle_msg_cpt_inst_lmtst(cptpf, msg);
+		break;
+	default:
+		otx2_reply_invalid_msg(&cptpf->afpf_mbox_up, 0, 0, msg->id);
+	}
+}
+
+void otx2_cptpf_afpf_mbox_up_handler(struct work_struct *work)
+{
+	struct otx2_cptpf_dev *cptpf;
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	struct otx2_mbox *mbox;
+	int offset, i;
+
+	cptpf = container_of(work, struct otx2_cptpf_dev, afpf_mbox_up_work);
+	mbox = &cptpf->afpf_mbox_up;
+	mdev = &mbox->dev[0];
+	/* Sync mbox data into memory */
+	smp_wmb();
+
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
+
+	for (i = 0; i < rsp_hdr->num_msgs; i++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
+
+		process_afpf_mbox_up_msg(cptpf, msg);
+
+		offset = mbox->rx_start + msg->next_msgoff;
+	}
+	otx2_mbox_msg_send(mbox, 0);
+}
-- 
2.25.1

