Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5574ECDB474
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 06:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjJPGuH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjJPGuG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 02:50:06 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFF9E1
        for <linux-crypto@vger.kernel.org>; Sun, 15 Oct 2023 23:50:04 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39FLp6EL018723;
        Sun, 15 Oct 2023 23:49:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=3D+65mgOQMHjn2EntR4dondm+obUjYjZmEoEC9Lrnso=;
 b=Oc7avGf0alvDeOi0T1erCLTndtfiYfIAMgzEc9nyT7qVVo4KFUkZ/Xi4062uX/5NiQ2r
 tkx628fhwrFg9a9UlbM1bZeL29lfS52eFjL0cnGtNC1KISvAd+I0dlqtD7B+bnzfh0+P
 ajy/u+xOJ5HGf0pZsg7O2ioyQA8mIeLC0/K3eb2+gmSJJMqoyeTexo2Jwx7/phMZsZHv
 IabUXFew06NmeRLVQw9N+e/q9Wv77VwFbwwvhWogdVWn+7Y00l4AI+2b71C8RG05TWa0
 eWgH0ICcXBbcir+OTOLZ2pS6pvzhVggwWra5jVxB4FlyrOqOH6sVpEpsMkr7AbXoGe09 Ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3tqtgkm92x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Oct 2023 23:49:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 15 Oct
 2023 23:49:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 15 Oct 2023 23:49:53 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 4D5EE3F7076;
        Sun, 15 Oct 2023 23:49:51 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <schalla@marvell.com>
Subject: [PATCH 05/10] crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0 chip.
Date:   Mon, 16 Oct 2023 12:19:29 +0530
Message-ID: <20231016064934.1913964-6-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016064934.1913964-1-schalla@marvell.com>
References: <20231016064934.1913964-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _R04afGx2Z5_QvB06brAwsOEbphBA7Hy
X-Proofpoint-ORIG-GUID: _R04afGx2Z5_QvB06brAwsOEbphBA7Hy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-15_09,2023-10-12_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds code to not execute CPT errata "when CPT_AF_DIAG[FLT_DIS] = 0 and a
CPT engine access to LLC/DRAM encounters  a fault/poison, a rare case
may result in unpredictable data being delivered to a CPT engine"
workaround on CN10KA B0/CN10KB HW as it is fixed on these chips.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h  |  8 ++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 10 ++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index bef78db15a89..b6d53e249dac 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -208,6 +208,14 @@ static inline bool cpt_feature_sgv2(struct pci_dev *pdev)
 	return false;
 }
 
+static inline bool cpt_is_errata_38550_exists(struct pci_dev *pdev)
+{
+	if (is_dev_otx2(pdev) || is_dev_cn10ka_ax(pdev))
+		return true;
+
+	return false;
+}
+
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 7fccc348f66e..7178fa81f00f 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1254,10 +1254,12 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	 * encounters a fault/poison, a rare case may result in
 	 * unpredictable data being delivered to a CPT engine.
 	 */
-	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG, &reg_val,
-			     BLKADDR_CPT0);
-	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG,
-			      reg_val | BIT_ULL(24), BLKADDR_CPT0);
+	if (cpt_is_errata_38550_exists(pdev)) {
+		otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG, &reg_val,
+				     BLKADDR_CPT0);
+		otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG,
+				      reg_val | BIT_ULL(24), BLKADDR_CPT0);
+	}
 
 	mutex_unlock(&eng_grps->lock);
 	return 0;
-- 
2.25.1

