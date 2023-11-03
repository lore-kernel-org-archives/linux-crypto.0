Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A65C4167D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Nov 2023 05:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjKCFdr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Nov 2023 01:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjKCFdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2023 01:33:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF411B3;
        Thu,  2 Nov 2023 22:33:40 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2LALrt025243;
        Thu, 2 Nov 2023 22:33:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=o9tw8oKk3uqh1RfckyJZQ1ro7WWsevdcNFajSb4vzkU=;
 b=aVnw1eIb+Ra4Cm5ODWIlQM0pfkWxFJcefjWAaR0txnQfzmmjbOMZYjNN8rmhCuqFmEpj
 hi1a/9Ad04YWm9MsIpLKoZbOK9/CxsItcaY4t9MZFGQaDO+UfQjdOjQEGzesFLYi/Fjo
 0t8NxodozOCTEQXkQImVZ1kfglfRxJHl1i8Awe7TlIprqxk2gaoePqgXCTownGexkxCX
 8oxsVv3wfxMTygmTCgPpBKIxMpqqnJ9yeU6b68+eAgzzM4T6anonPFum/xSN2CkPLUWW
 mdpKczxVcE902bF5W2DeZw7h9A/AdKT1fwCMvQt2UabQY53CEQCwN+vMWXj7wxEUJonO YQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3u3y235dyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Nov 2023 22:33:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 2 Nov
 2023 22:33:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 2 Nov 2023 22:33:29 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 935CF3F705E;
        Thu,  2 Nov 2023 22:33:26 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <sgoutham@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v1 05/10] crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0 chip.
Date:   Fri, 3 Nov 2023 11:03:01 +0530
Message-ID: <20231103053306.2259753-6-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231103053306.2259753-1-schalla@marvell.com>
References: <20231103053306.2259753-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0pr9Cn6MWSSDxsRDrvlHRUfJAInsMQHW
X-Proofpoint-GUID: 0pr9Cn6MWSSDxsRDrvlHRUfJAInsMQHW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_05,2023-11-02_03,2023-05-22_02
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
index bef78db15a89..4c5454470267 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -192,6 +192,14 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 	}
 }
 
+static inline bool cpt_is_errata_38550_exists(struct pci_dev *pdev)
+{
+	if (is_dev_otx2(pdev) || is_dev_cn10ka_ax(pdev))
+		return true;
+
+	return false;
+}
+
 static inline bool cpt_feature_rxc_icb_cnt(struct pci_dev *pdev)
 {
 	if (!is_dev_otx2(pdev) && !is_dev_cn10ka_ax(pdev))
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

