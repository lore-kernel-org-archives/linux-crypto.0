Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1243D27454;
	Wed, 28 May 2025 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748444421; cv=none; b=WJ3UhSukNQKqaKlbr0xPzAsTejXjM5iZcIMxGr+00+Df/qSSllrWd08gdn5jilEmFjX4GXqvVY2cxIKSFxTgrTTelECoUj+O3dMhdJkLms5Rep5am+Ke5pPgxpSyaPbm1PThAcLJ0UnUYCXZJpBxZWss6CjYd7m6u4IwuiLNXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748444421; c=relaxed/simple;
	bh=PEE6FuDKo4h6V90wsU4VKCmHyqBb8yiBwrX2i1gXiIU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiekyTDYhkJD07gKg8+YYPy43uJt5+ELnSl/VmVgY9cPFkE2S3Ahermt2r7I2QvuCuhkeO0WRzZuL5ukaXtZB4/Q3uKO5sfW7EqlbNTs0MX1GPl/xdeqhwqsfss4+whVhZlvkNIt30LxxsHcbS6/wfFnWd1j8lyO79trLOaYoew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cNAOQMg5; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cNAOQMg5"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SDqTKi009900;
	Wed, 28 May 2025 07:59:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	ALYiRI/siKruRzfP5l7WiygRqJIDrWuK4jFkmWmTSg=; b=cNAOQMg5++V+KQbGH
	HgthiZjmpjujQ6HWN0yPme5yMlu9TqH69ajBF9Jjq4OTUWfmGbHFx+L1u1cGbtOi
	/vXj3VIOz3Eq5/FB+PDR8xrCEbuuBo9msTM0Imp28TXzGizQjEQWoohhYK6qAW4O
	UM6ZLZ4V18nuzK+LQ7l6XEzPx3m+eXpO7gceVtXUTCfAj8BmyRUQtVu5G2Z/jVgx
	3fvpBpnkU2wfC9ME1svvb9VGWO9fkdwDrjbzmYs3Wado0liEyqbiazgiFanlykou
	+/z2139O14pUQpKUm7D+kjEBlm+zySG8ZzFbpSN0ip6x2e47eZFqwP/kFxhRoCIL
	qSkBg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46x1e30bc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 07:59:57 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 28 May 2025 07:59:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 28 May 2025 07:59:56 -0700
Received: from localhost.localdomain (unknown [10.28.36.167])
	by maili.marvell.com (Postfix) with ESMTP id 752263F704F;
	Wed, 28 May 2025 07:59:52 -0700 (PDT)
From: Amit Singh Tomar <amitsinght@marvell.com>
To: Srujana Challa <schalla@marvell.com>,
        Bharat Bhushan
	<bbhushan2@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S.
 Miller" <davem@davemloft.net>,
        Amit Singh Tomar <amitsinght@marvell.com>,
        Kuan-Wei Chiu <visitorckw@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Philipp Stanner <pstanner@redhat.com>,
        Shashank Gupta <shashankg@marvell.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH 1/2] crypto: octeontx2: Rework how engine group number is obtained
Date: Wed, 28 May 2025 20:29:40 +0530
Message-ID: <20250528145941.2659706-2-amitsinght@marvell.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250528145941.2659706-1-amitsinght@marvell.com>
References: <20250528145941.2659706-1-amitsinght@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QvGPBgVmeOEd8ii4BNgzwZvcBuAQwnNC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzMCBTYWx0ZWRfX2OQKxb9wcdNI kmHpCXzTGXTX2320W/f/dmg4lwiuOuD8OmBaPCX9snre3nvGh0Pyg/185U6e5KUCG5bSj4O8+pC PCzQum6U0febxQUq01DrAojQikeT34cfWWPO+DCf6FR7kdJTcF4ia2vlZZ6AnJZbuuEmdjKd2qb
 1Qum210FNiv4FoKDWDVwNXakYVm7kAZE64RBNaGE9JQdMMueba1hoIKeiYK0JRlDaRnBNmupxYS 5giR4nb3+aOEQxnDl0ePWtImHlbvQ++qPeTatFDUbUfAwSwWS/DA25wubOxQf7C+Eg5qFk7QITe uhiOMYyQFUZ0w6NjJnHIoweBVDFWoKCXWAB6LJbOZ2ozqDcgYbnTdjAKL4PVL1V4qU69ljLA32Z
 oOVTFv1ZO/sTqnuAhp2FcuaK4WutBC0SBAfhj2hiICCia50vFGRI0ykXlskcUtH5qR+oPY1X
X-Proofpoint-GUID: QvGPBgVmeOEd8ii4BNgzwZvcBuAQwnNC
X-Authority-Analysis: v=2.4 cv=baVrUPPB c=1 sm=1 tr=0 ts=683724ed cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=8f77AyW8qadUDfJvTo0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_07,2025-05-27_01,2025-03-28_01

By default, otx2_cpt_get_kcrypto_eng_grp_num() returns the engine group
number of SE engine type. Add an engine type parameter to support
retrieving the engine group number for different engine types.

Since otx2_cpt_get_kcrypto_eng_grp_num() always returns the kernel crypto
engine group number, rename it to otx2_cpt_get_eng_grp_num().

Signed-off-by: Amit Singh Tomar <amitsinght@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h  |  3 ++-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h       |  2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c  |  6 ++++--
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c  | 13 +++++++------
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c  |  5 ++++-
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c    | 12 ++++++++++--
 6 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index e27e849b01df..72473f0070f3 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -490,6 +490,7 @@ struct otx2_cptlf_wqe;
 int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 			int cpu_num);
 void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe);
-int otx2_cpt_get_kcrypto_eng_grp_num(struct pci_dev *pdev);
+int otx2_cpt_get_eng_grp_num(struct pci_dev *pdev,
+			     enum otx2_cpt_eng_type);
 
 #endif /* __OTX2_CPT_REQMGR_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index 6e004a5568d8..49ec2b92e86d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -124,7 +124,7 @@ struct otx2_cptlfs_info {
 	struct cpt_hw_ops *ops;
 	u8 are_lfs_attached;	/* Whether CPT LFs are attached */
 	u8 lfs_num;		/* Number of CPT LFs */
-	u8 kcrypto_eng_grp_num;	/* Kernel crypto engine group number */
+	u8 kcrypto_se_eng_grp_num; /* Crypto symmetric engine group number */
 	u8 kvf_limits;          /* Kernel crypto limits */
 	atomic_t state;         /* LF's state. started/reset */
 	int blkaddr;            /* CPT blkaddr: BLKADDR_CPT0/BLKADDR_CPT1 */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 7eb0bc13994d..8d9f394d6b50 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -384,7 +384,8 @@ static inline int cpt_enc_dec(struct skcipher_request *req, u32 enc)
 	req_info->req_type = OTX2_CPT_ENC_DEC_REQ;
 	req_info->is_enc = enc;
 	req_info->is_trunc_hmac = false;
-	req_info->ctrl.s.grp = otx2_cpt_get_kcrypto_eng_grp_num(pdev);
+	req_info->ctrl.s.grp = otx2_cpt_get_eng_grp_num(pdev,
+							OTX2_CPT_SE_TYPES);
 
 	req_info->req.cptr = ctx->er_ctx.hw_ctx;
 	req_info->req.cptr_dma = ctx->er_ctx.cptr_dma;
@@ -1288,7 +1289,8 @@ static int cpt_aead_enc_dec(struct aead_request *req, u8 reg_type, u8 enc)
 	if (status)
 		return status;
 
-	req_info->ctrl.s.grp = otx2_cpt_get_kcrypto_eng_grp_num(pdev);
+	req_info->ctrl.s.grp = otx2_cpt_get_eng_grp_num(pdev,
+							OTX2_CPT_SE_TYPES);
 
 	/*
 	 * We perform an asynchronous send and once
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 56904bdfd6e8..79adc224066e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -265,17 +265,18 @@ static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
 	u8 eng_grp_msk;
 
 	/* Get engine group number for symmetric crypto */
-	cptvf->lfs.kcrypto_eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	cptvf->lfs.kcrypto_se_eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
 	ret = otx2_cptvf_send_eng_grp_num_msg(cptvf, OTX2_CPT_SE_TYPES);
 	if (ret)
 		return ret;
 
-	if (cptvf->lfs.kcrypto_eng_grp_num == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
-		dev_err(dev, "Engine group for kernel crypto not available\n");
-		ret = -ENOENT;
-		return ret;
+	if (cptvf->lfs.kcrypto_se_eng_grp_num ==
+		OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(dev,
+			"Symmetric Engine group for crypto not available\n");
+		return -ENOENT;
 	}
-	eng_grp_msk = 1 << cptvf->lfs.kcrypto_eng_grp_num;
+	eng_grp_msk = 1 << cptvf->lfs.kcrypto_se_eng_grp_num;
 
 	ret = otx2_cptvf_send_kvf_limits_msg(cptvf);
 	if (ret)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
index 931b72580fd9..f36d75f40014 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -75,6 +75,7 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 	struct otx2_cpt_caps_rsp *eng_caps;
 	struct cpt_rd_wr_reg_msg *rsp_reg;
 	struct msix_offset_rsp *rsp_msix;
+	u8 grp_num;
 	int i;
 
 	if (msg->id >= MBOX_MSG_MAX) {
@@ -122,7 +123,9 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 		break;
 	case MBOX_MSG_GET_ENG_GRP_NUM:
 		rsp_grp = (struct otx2_cpt_egrp_num_rsp *) msg;
-		cptvf->lfs.kcrypto_eng_grp_num = rsp_grp->eng_grp_num;
+		grp_num = rsp_grp->eng_grp_num;
+		if (rsp_grp->eng_type == OTX2_CPT_SE_TYPES)
+			cptvf->lfs.kcrypto_se_eng_grp_num = grp_num;
 		break;
 	case MBOX_MSG_GET_KVF_LIMITS:
 		rsp_limits = (struct otx2_cpt_kvf_limits_rsp *) msg;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 426244107037..8b4ac269330a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -391,9 +391,17 @@ void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe)
 			      &wqe->lfs->lf[wqe->lf_num].pqueue);
 }
 
-int otx2_cpt_get_kcrypto_eng_grp_num(struct pci_dev *pdev)
+int otx2_cpt_get_eng_grp_num(struct pci_dev *pdev,
+			     enum otx2_cpt_eng_type eng_type)
 {
 	struct otx2_cptvf_dev *cptvf = pci_get_drvdata(pdev);
 
-	return cptvf->lfs.kcrypto_eng_grp_num;
+	switch (eng_type) {
+	case OTX2_CPT_SE_TYPES:
+		return cptvf->lfs.kcrypto_se_eng_grp_num;
+	default:
+		dev_err(&cptvf->pdev->dev, "Unsupported engine type");
+		break;
+	}
+	return -ENXIO;
 }
-- 
2.48.1

