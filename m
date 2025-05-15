Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3F296713;
	Thu, 15 May 2025 06:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747289649; cv=none; b=jdDe3LYBKVngCT4ZroSrJ1+8ZytbrqHdEaJ5x/Mjfn+HJedhGcEa1PNAQ+xYlc/4wfIY+y9dftwGmMEiWrinSlGkutIRiEi2Rxd13CqXgcMGkfk8Sa1j83sMqjj3OZFdugOBScdQ/2PylXqbiSKywH74FMK86gXWYpWn7/zTHQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747289649; c=relaxed/simple;
	bh=iYhe+S8jXbk5CtPEoJIc0J773RL9eT33eYMfmbBtBqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6GMkNm9EjDN+cj20Ug6Rki8XhmadX3q240560pZtYMesDWKhotpByP5hYt9GSct6A4QVzcKPwLeZoGxrFN6U++BHr7ojKvbvBuKOVYllBRPouCOCq2/UTmyMbALUd5bljkBUmUnHOdsunJMkWuL74MJryAOzn3YQ+ijqp6/C6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=A6qLSMZ2; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A6qLSMZ2"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EMC3Ih027980;
	Wed, 14 May 2025 23:13:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	VQaVYNJv9PyY4Cu+j74kfvDlS4q8mMrMJle+Ai0FlM=; b=A6qLSMZ24rdN1Pz3U
	GfK7Xh5AgEPbmjwgWvoaPqabiF3HMG6ubCfhmDw5LxAS2gIwrWv5XuzlmoYsZoLV
	umCiZxAEAN1c1JGd9hqxmBLFoVkyxRly8INjSWSSUAQ48Qup1N4kTausHqttoATY
	Psq9SV00+K63fNaAZJqNFNIzfMOtFj482luiypacSeCY2PZW1AuIbBW/z/eKIUhB
	aGnkX3OvzJ2jDjS3E0qcclj03pYnj+SDmoJhFxLZSWjcx7JyCWPsOronhLxZJXIS
	f0gohnVrq/fP3L2ucWDRKnsNYHxM9Cvud2iQE+XHB2oF2wi0W/e9cgBlmNRb3gK3
	xLWrg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46n3r00rhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 23:13:46 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 14 May 2025 23:13:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 14 May 2025 23:13:45 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 589EA3F707D;
	Wed, 14 May 2025 23:13:42 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 1/2] crypto: octeontx2: Initialize cptlfs device info once
Date: Thu, 15 May 2025 11:43:35 +0530
Message-ID: <20250515061336.3348493-2-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250515061336.3348493-1-bbhushan2@marvell.com>
References: <20250515061336.3348493-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: hTzS6J4SNBOSiuqw4PaAd_zYlOh_4xUG
X-Authority-Analysis: v=2.4 cv=WdEMa1hX c=1 sm=1 tr=0 ts=6825861a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=3-882hBxx_MLuhTU-JcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: hTzS6J4SNBOSiuqw4PaAd_zYlOh_4xUG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDA1OCBTYWx0ZWRfX3SuWYa7M6KIb loHhtL6bP3S/nfuTRbBTcNeg5HesKWTJsmWOfFr8QYtDdwZTr1TztQhK1om3fcBbrWF4BYzYakp GoaS6u+EDj3s59980zMQxSlmmKfwUGWC79QD1e7yaa29HMX7ybLGR27O2EQzIaArUJqCqWgmPRY
 u+7W1X4M8qG9GGZo1VZ89GhZptBDW2EndCez1T8op5nfUmrvNGlbGbJFGaASmBFOftvTAxX5da0 sgfyZqh6ipx9/+cgwPaMC87eK70xGy/8V8bew+/g5tn8xDTupcD7X+nlZNGXhlLKVpG1Y5XuWpB HTJ2syS8HsZGO1Yw/2c7Hy+395Wl4NXfxEW40X5Ol7G7jT1KwWao9mKDuftZ1JYophQQLTUb68B
 aeWPEk6GQwZOVndmJB/2VxAZo0WUdO+R4etne+2KSeeqEkYf2dTH26f43E8+8a9nBQrFNOko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_02,2025-05-14_03,2025-02-21_01

Function otx2_cptlf_set_dev_info() initializes common
fields of cptlfs data-struct. This function is called
every time a cptlf is initialized but this needs be done
once for a cptlf block. So this initialization is moved
to early device probe code to avoid redundant initialization.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c  | 6 ++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c  | 5 -----
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 --
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c  | 5 +++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 12971300296d..687b6c7d7674 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -639,6 +639,12 @@ static int cptpf_device_init(struct otx2_cptpf_dev *cptpf)
 	/* Disable all cores */
 	ret = otx2_cpt_disable_all_cores(cptpf);
 
+	otx2_cptlf_set_dev_info(&cptpf->lfs, cptpf->pdev, cptpf->reg_base,
+				&cptpf->afpf_mbox, BLKADDR_CPT0);
+	if (cptpf->has_cpt1)
+		otx2_cptlf_set_dev_info(&cptpf->cpt1_lfs, cptpf->pdev,
+					cptpf->reg_base, &cptpf->afpf_mbox,
+					BLKADDR_CPT1);
 	return ret;
 }
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index ec1ac7e836a3..3eb45bb91296 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -264,8 +264,6 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 		return -ENOENT;
 	}
 
-	otx2_cptlf_set_dev_info(&cptpf->lfs, cptpf->pdev, cptpf->reg_base,
-				&cptpf->afpf_mbox, BLKADDR_CPT0);
 	cptpf->lfs.global_slot = 0;
 	cptpf->lfs.ctx_ilen_ovrd = cfg_req->ctx_ilen_valid;
 	cptpf->lfs.ctx_ilen = cfg_req->ctx_ilen;
@@ -278,9 +276,6 @@ static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
 
 	if (cptpf->has_cpt1) {
 		cptpf->rsrc_req_blkaddr = BLKADDR_CPT1;
-		otx2_cptlf_set_dev_info(&cptpf->cpt1_lfs, cptpf->pdev,
-					cptpf->reg_base, &cptpf->afpf_mbox,
-					BLKADDR_CPT1);
 		cptpf->cpt1_lfs.global_slot = num_lfs;
 		cptpf->cpt1_lfs.ctx_ilen_ovrd = cfg_req->ctx_ilen_valid;
 		cptpf->cpt1_lfs.ctx_ilen = cfg_req->ctx_ilen;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 1c2aa9626088..3e8357c0ecb2 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1515,8 +1515,6 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	if (ret)
 		goto delete_grps;
 
-	otx2_cptlf_set_dev_info(lfs, cptpf->pdev, cptpf->reg_base,
-				&cptpf->afpf_mbox, BLKADDR_CPT0);
 	ret = otx2_cptlf_init(lfs, OTX2_CPT_ALL_ENG_GRPS_MASK,
 			      OTX2_CPT_QUEUE_HI_PRIO, 1);
 	if (ret)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index d84eebdf2fa8..11e351a48efe 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -283,8 +283,6 @@ static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
 
 	lfs_num = cptvf->lfs.kvf_limits;
 
-	otx2_cptlf_set_dev_info(lfs, cptvf->pdev, cptvf->reg_base,
-				&cptvf->pfvf_mbox, cptvf->blkaddr);
 	ret = otx2_cptlf_init(lfs, eng_grp_msk, OTX2_CPT_QUEUE_HI_PRIO,
 			      lfs_num);
 	if (ret)
@@ -396,6 +394,9 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 
 	cptvf_hw_ops_get(cptvf);
 
+	otx2_cptlf_set_dev_info(&cptvf->lfs, cptvf->pdev, cptvf->reg_base,
+				&cptvf->pfvf_mbox, cptvf->blkaddr);
+
 	ret = otx2_cptvf_send_caps_msg(cptvf);
 	if (ret) {
 		dev_err(&pdev->dev, "Couldn't get CPT engine capabilities.\n");
-- 
2.34.1

