Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CA1C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Feb 2022 12:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiBDMqa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 07:46:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14256 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbiBDMq3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 07:46:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 214BYanm017612;
        Fri, 4 Feb 2022 04:46:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=p6ma0eZM7jxGSZcLR0gmGhKIQUqy3RS1CPHPviff0f0=;
 b=DIy54at4yHem3yL9kqzvefrkbFaaVZlSaxtocw6R41GA88N9NtOipJ77DoAB9/+sEFI7
 xpV9mY6yh6WUKE+Ria/k83W9b6RTZTYym47MWjmdz/51m6Jac6nVC5yZPYi3LtV4Sc+5
 kNDRKI9c+5pycM5BTHyBPSsdkRTsRo7zdEjBnLbNOhbgoHsYmotVsvHfz9SgDrBeTeRe
 nFgGiZlKukMKLM/pTp2UGt8z7UfPPzvZFLaNtY+sAlmEnGV6GiPBcDyEKJWIuZq0guOg
 41QATX55wOFyZR0e4H4fn1zgzWRatvbg4aEfvhATQvHvA1hyXxPipKFPYPpS+8+HMW2N 2w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e0jvrkmd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 04:46:15 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Feb
 2022 04:46:13 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Feb 2022 04:46:13 -0800
Received: from cavium-ThM82.marvell.com (unknown [10.28.34.21])
        by maili.marvell.com (Postfix) with ESMTP id 6FDFB3F706C;
        Fri,  4 Feb 2022 04:46:11 -0800 (PST)
From:   Harman Kalra <hkalra@marvell.com>
To:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>
CC:     <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, Harman Kalra <hkalra@marvell.com>
Subject: [PATCH] crypto: octeontx2 - add synchronization between mailbox accesses
Date:   Fri, 4 Feb 2022 18:16:01 +0530
Message-ID: <20220204124601.3617217-1-hkalra@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: yPYa0FIIqsTRYux4bUjzV1AFG5THuG4S
X-Proofpoint-ORIG-GUID: yPYa0FIIqsTRYux4bUjzV1AFG5THuG4S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since there are two workqueues implemented in CPTPF driver - one
for handling mailbox requests from VFs and another for handling FLR.
In both cases PF driver will forward the request to AF driver by
writing to mailbox memory. A race condition may arise if two
simultaneous requests are written to mailbox memory. Introducing
locking mechanism to maintain synchronization between multiple
mailbox accesses.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  1 +
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  | 14 +++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  1 +
 .../marvell/octeontx2/otx2_cptpf_main.c       | 21 ++++++++++-------
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 23 ++++++++++++++-----
 5 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index fb56824cb0a6..5012b7e669f0 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -157,5 +157,6 @@ struct otx2_cptlfs_info;
 int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs);
 int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs);
 int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs);
+int otx2_cpt_sync_mbox_msg(struct otx2_mbox *mbox);
 
 #endif /* __OTX2_CPT_COMMON_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index 9074876d38e5..a317319696ef 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -202,3 +202,17 @@ int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs)
 	}
 	return ret;
 }
+
+int otx2_cpt_sync_mbox_msg(struct otx2_mbox *mbox)
+{
+	int err;
+
+	if (!otx2_mbox_nonempty(mbox, 0))
+		return 0;
+	otx2_mbox_msg_send(mbox, 0);
+	err = otx2_mbox_wait_for_rsp(mbox, 0);
+	if (err)
+		return err;
+
+	return otx2_mbox_check_rsp_msgs(mbox, 0);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 05b2d9c650e1..936174b012e8 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -46,6 +46,7 @@ struct otx2_cptpf_dev {
 
 	struct workqueue_struct	*flr_wq;
 	struct cptpf_flr_work   *flr_work;
+	struct mutex            lock;   /* serialize mailbox access */
 
 	unsigned long cap_flag;
 	u8 pf_id;               /* RVU PF number */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 1720a5bb7016..17a9dd20c8c3 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -140,6 +140,7 @@ static void cptpf_flr_wq_handler(struct work_struct *work)
 
 	vf = flr_work - pf->flr_work;
 
+	mutex_lock(&pf->lock);
 	req = otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
 				      sizeof(struct msg_rsp));
 	if (!req)
@@ -151,16 +152,19 @@ static void cptpf_flr_wq_handler(struct work_struct *work)
 	req->pcifunc |= (vf + 1) & RVU_PFVF_FUNC_MASK;
 
 	otx2_cpt_send_mbox_msg(mbox, pf->pdev);
+	if (!otx2_cpt_sync_mbox_msg(&pf->afpf_mbox)) {
 
-	if (vf >= 64) {
-		reg = 1;
-		vf = vf - 64;
+		if (vf >= 64) {
+			reg = 1;
+			vf = vf - 64;
+		}
+		/* Clear transaction pending register */
+		otx2_cpt_write64(pf->reg_base, BLKADDR_RVUM, 0,
+				 RVU_PF_VFTRPENDX(reg), BIT_ULL(vf));
+		otx2_cpt_write64(pf->reg_base, BLKADDR_RVUM, 0,
+				 RVU_PF_VFFLR_INT_ENA_W1SX(reg), BIT_ULL(vf));
 	}
-	/* Clear transaction pending register */
-	otx2_cpt_write64(pf->reg_base, BLKADDR_RVUM, 0,
-			 RVU_PF_VFTRPENDX(reg), BIT_ULL(vf));
-	otx2_cpt_write64(pf->reg_base, BLKADDR_RVUM, 0,
-			 RVU_PF_VFFLR_INT_ENA_W1SX(reg), BIT_ULL(vf));
+	mutex_unlock(&pf->lock);
 }
 
 static irqreturn_t cptpf_vf_flr_intr(int __always_unused irq, void *arg)
@@ -468,6 +472,7 @@ static int cptpf_afpf_mbox_init(struct otx2_cptpf_dev *cptpf)
 		goto error;
 
 	INIT_WORK(&cptpf->afpf_mbox_work, otx2_cptpf_afpf_mbox_handler);
+	mutex_init(&cptpf->lock);
 	return 0;
 
 error:
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 186f1c1190c1..fee758b86d29 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -18,6 +18,7 @@ static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 	struct mbox_msghdr *msg;
 	int ret;
 
+	mutex_lock(&cptpf->lock);
 	msg = otx2_mbox_alloc_msg(&cptpf->afpf_mbox, 0, size);
 	if (msg == NULL)
 		return -ENOMEM;
@@ -29,15 +30,19 @@ static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 	msg->sig = req->sig;
 	msg->ver = req->ver;
 
-	otx2_mbox_msg_send(&cptpf->afpf_mbox, 0);
-	ret = otx2_mbox_wait_for_rsp(&cptpf->afpf_mbox, 0);
+	ret = otx2_cpt_sync_mbox_msg(&cptpf->afpf_mbox);
+	/* Error code -EIO indicate there is a communication failure
+	 * to the AF. Rest of the error codes indicate that AF processed
+	 * VF messages and set the error codes in response messages
+	 * (if any) so simply forward responses to VF.
+	 */
 	if (ret == -EIO) {
-		dev_err(&cptpf->pdev->dev, "RVU MBOX timeout.\n");
+		dev_warn(&cptpf->pdev->dev,
+			 "AF not responding to VF%d messages\n", vf->vf_id);
+		mutex_unlock(&cptpf->lock);
 		return ret;
-	} else if (ret) {
-		dev_err(&cptpf->pdev->dev, "RVU MBOX error: %d.\n", ret);
-		return -EFAULT;
 	}
+	mutex_unlock(&cptpf->lock);
 	return 0;
 }
 
@@ -204,6 +209,10 @@ void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work)
 		if (err == -ENOMEM || err == -EIO)
 			break;
 		offset = msg->next_msgoff;
+		/* Write barrier required for VF responses which are handled by
+		 * PF driver and not forwarded to AF.
+		 */
+		smp_wmb();
 	}
 	/* Send mbox responses to VF */
 	if (mdev->num_msgs)
@@ -350,6 +359,8 @@ void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
 			process_afpf_mbox_msg(cptpf, msg);
 
 		offset = msg->next_msgoff;
+		/* Sync VF response ready to be sent */
+		smp_wmb();
 		mdev->msgs_acked++;
 	}
 	otx2_mbox_reset(afpf_mbox, 0);
-- 
2.25.1

