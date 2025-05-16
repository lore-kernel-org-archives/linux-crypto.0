Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F222D21B9D8;
	Fri, 16 May 2025 08:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747385134; cv=none; b=PgeQSu+65AldTyqqOtazuffgOqzElnzU0baodMRFx2f6np1tbTcGWiZOKh6zGsb76KAiVAwFqPis00b5WLnaSJXG0DMojbjxsEPBNsIA7GMCd+TU0CPGP7PldBpJsG7rNUodeOTP53UGBsvHCKjL1ZmFc7GHzQND6yNaLTI6hzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747385134; c=relaxed/simple;
	bh=3bBBe0HQb0Ed7Gl/Noo0rkSg2Ion18PRsWjl5r5hvsM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTaancybERAuqdE48DWqoYN2dXzZfrYCQmoVBT4fMO40PrXFu4dfzv4TjNT9grwfYWsIHCtYj/iG8u9efUpgC9ZBMjWD4aSx0TyIY5W2X+1Pby1CAdkbvf2o9n27IFvD06eI7aBJcjKXjbcUquLuCZW5tV5SOPT8ht4q4OPfHHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iZvVCIFz; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iZvVCIFz"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G6AflK018907;
	Fri, 16 May 2025 01:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=i
	EXY57rh/LiHp95qWg8e6r9ONYGQRdEg7ZfdZx/cvOo=; b=iZvVCIFzZWPXmeSk0
	LrIzMwM31bFhZqH0dYz1z7mkpe0HnxYPc+UEDYfUjEQj7DG6kekTb82AJx/DnuCd
	xcIzpVFtwaWZ2oBRw8r04MA4j6iKX1XC2wUS+VhEyHhZXxAChuvXjGG8Su45OeNs
	BB8fn9DAabAm9Bt2iazf5HecQUqBY0yotCK9croaZnl5Q9mRqxmPwjiDyBpjddnW
	39ZfkIg9+jMNyB7KjUfpxY7dUxWwhhVH3Y6tFlsn/fchZ8siWoEWQdRlq5jBanlV
	OKXXKc5vLZGFxLVdSzEc2TmWKbIOhoQgMaE0NSC9Umb1OoYGi/uWO3FKdDrMY19D
	aaskA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46nyv4re8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 01:45:10 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 16 May 2025 01:44:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 16 May 2025 01:44:52 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 901583F707C;
	Fri, 16 May 2025 01:44:48 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH v2 1/2] crypto: octeontx2: Initialize cptlfs device info once
Date: Fri, 16 May 2025 14:14:40 +0530
Message-ID: <20250516084441.3721548-2-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250516084441.3721548-1-bbhushan2@marvell.com>
References: <20250516084441.3721548-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=S6bZwJsP c=1 sm=1 tr=0 ts=6826fb16 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=3-882hBxx_MLuhTU-JcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: zC0K-ydAxGFnp-G-4BIPDQe_R8EJMRbq
X-Proofpoint-ORIG-GUID: zC0K-ydAxGFnp-G-4BIPDQe_R8EJMRbq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDA4MiBTYWx0ZWRfX4v/QBTtE/OOK Ard0yEHgpn+I7dJi7w9B45B64ADGKaK3SbUiu1SGS1eLie2svVDqUJ7GvqNRP0eM1rDq5oSW3u5 u7ZKEvLzn5rldHNA4/1qdXhteUgNyM6nTf93Jki00UORpIQoFo6pZDOTo3+iSNl25ynl/M9n91Q
 q4MhX/DsZJlLTT4sXp8X8o09MNV7UCS1eJa+RoLdOk1iRwQ4gkjzb1RJ14uDh6bitYseQUuAm+d +9csYRjy1m/VWbaqWDndg0Lb/bEmQvZC4nk9VGgAkS3p/WIgCQs6p5yzYul1/bV6BwECz9RsKIr wxhdqDQhTREK68qA/cOwjCan6SYybyvcmpalXAcjS3NqADvVKiA9M5A8n3txVxSNsVV0fQdAJZm
 2A5JswoU8v3lTduUUpGo/WJ8P4JDT7HzZtAZkJ5sRF0dgEOuD0XqUvAvqKdRn2zw1wrUY/zt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_03,2025-05-15_01,2025-03-28_01

Function otx2_cptlf_set_dev_info() initializes common
fields of cptlfs data-struct. This function is called
every time a cptlf is initialized but this needs be done
once for a cptlf block. So this initialization is moved
to early device probe code to avoid redundant initialization.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
---
v1->v2:
 - No change

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

