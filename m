Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E557278162;
	Wed, 28 May 2025 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748444475; cv=none; b=CTnL0p82ID+OMBlBUMnv7xaujr/3omzKgkpHBxbY/7aHNJ7/GQlkAck4QtNdy4JFLVwoMeQOR71w9NAS89MXns6diLXcChSJ9XbrpfKSXL2RFZlXcbdWoroWG4vIypu80cBghl49h8xOmW2yQrfFTt6nFLfzo4mTP/akr3jNias=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748444475; c=relaxed/simple;
	bh=tVOvSZ8WGTNMT3w3paP3QmhD8M1rHT/WEr04d2e45+I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iXfTr4PJg9JwXWtg58UmbQcxnqBtdJqqOF9gO8AMEee86gUJiiIbhIu9FYg9qT9GDaAZsE2Y60BaQECttVXi4eTzI3PXURMN3kYG92YBFFqlDJ9TdKOZD9DUE5YKNio26jd0t0E5vFSHl0mOTbOYvfc8PFR8OVGAH7Ln4pZtQJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HtQkGB6U; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HtQkGB6U"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SDr8x5010777;
	Wed, 28 May 2025 08:00:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	7wA58ZuF2OXeCi/aBSKESuuC9O3XlcY7z/3D2Eq/FY=; b=HtQkGB6Uz40VvLUrK
	HsJy1cXhy5eQYUx+OUtzoHir/TLmCGs47lEqb5o01tPgOA5ZwjBiSDsL8yg2fm+m
	eTFgMOB/+Anoh1hwzOmQZ/sTHAh86qLs5erWZYqopVBH/uAXTCGNDvshJRibaa6R
	ocYYkrq5Jhz6w83Kz6+E0EnRqoaQm0/1II9xGykBBgDTIGksenJdlpVDvPHKk3OM
	XvRL2g2TaZra4ESAtCsajuCdjLv9wN2Iga7V/1STmULD0IgI9IwjsDw3XtiyO3Me
	jAFMcc0qiHOM5N3UPNbUhpXbjH8PQ9BdIGDy14Z0wjJ667sukhcGQG8ZJY1OII9C
	0VCOw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46x1e30bce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 08:00:03 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 28 May 2025 08:00:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 28 May 2025 08:00:01 -0700
Received: from localhost.localdomain (unknown [10.28.36.167])
	by maili.marvell.com (Postfix) with ESMTP id 3DB1F3F704F;
	Wed, 28 May 2025 07:59:56 -0700 (PDT)
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
Subject: [PATCH 2/2] crypto: octeontx2: get engine group number for asymmetric engine
Date: Wed, 28 May 2025 20:29:41 +0530
Message-ID: <20250528145941.2659706-3-amitsinght@marvell.com>
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
X-Proofpoint-ORIG-GUID: e4x9pK3bpR8ZeCjYTmRVQB9mlElvoYSh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzMCBTYWx0ZWRfXyCKjnCWrnV9r Xyywjxo2MIFrbHKH+a2/wW2SF2Jio4giVJwrAtNJvfxqtMuDbIyam1YWP1Ox3sT9qODtVcRIGou JXrJgph60mQGI3AasKaxL36bZYKuZiYLW8t09dXmnTJ4+xTLcuYNvw8ZEpPu4c9PjrJNMyduHUN
 qxaZJf8t6Tu7xNenjTpwfnEJ4lw6wFOnd4auvwj8SsGQeHdOXGg2DSXeI4Rjrm7+e/vpfb4A0wJ Yh6Z1ddbTC+Q6QrX/YBTfjUn+ow6I0zrjvABx5f3AP1Cq2z/WXMww2Gs4GmzqOsK4D30dlNYPXp gFb3/gA16HzxfBuUXRpXxOYBp4KGfQwHTkOOmteQvQzziU9fbHlC9s1KkH68sYJXvtH7TVxObDT
 XV7PgvRafgwjcmOuCIaZGBaDRnc5d7xpLEm3mcR4xdaOr13yWEFFmzif8dPw2Gteo0+sYc6p
X-Proofpoint-GUID: e4x9pK3bpR8ZeCjYTmRVQB9mlElvoYSh
X-Authority-Analysis: v=2.4 cv=baVrUPPB c=1 sm=1 tr=0 ts=683724f3 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=HShFi8kSKcbLiSuR9dgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_07,2025-05-27_01,2025-03-28_01

Cryptographic Accelerator Unit (CPT) support different engine groups, one
for asymmetric algorithms (only AE engines in this group), one for the
most common symmetric algorithms (all SE and all IE engines in this group),
and one for other symmetric algorithms (only SE engines in this group).

For symmetric engine (SE), we obtain the group number using
"MBOX_MSG_GET_ENG_GRP_NUM" mailbox. Let's follow a similar approach to
determine the group number for asymmetric engine (AE).

Signed-off-by: Amit Singh Tomar <amitsinght@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h   |  1 +
 .../crypto/marvell/octeontx2/otx2_cptvf_main.c  | 17 ++++++++++++++++-
 .../crypto/marvell/octeontx2/otx2_cptvf_mbox.c  |  2 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c       |  2 ++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index 49ec2b92e86d..1b9f75214d18 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -125,6 +125,7 @@ struct otx2_cptlfs_info {
 	u8 are_lfs_attached;	/* Whether CPT LFs are attached */
 	u8 lfs_num;		/* Number of CPT LFs */
 	u8 kcrypto_se_eng_grp_num; /* Crypto symmetric engine group number */
+	u8 kcrypto_ae_eng_grp_num; /* Crypto asymmetric engine group number */
 	u8 kvf_limits;          /* Kernel crypto limits */
 	atomic_t state;         /* LF's state. started/reset */
 	int blkaddr;            /* CPT blkaddr: BLKADDR_CPT0/BLKADDR_CPT1 */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 79adc224066e..c1c44a7b89fa 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -276,7 +276,22 @@ static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
 			"Symmetric Engine group for crypto not available\n");
 		return -ENOENT;
 	}
-	eng_grp_msk = 1 << cptvf->lfs.kcrypto_se_eng_grp_num;
+
+	/* Get engine group number for asymmetric crypto */
+	cptvf->lfs.kcrypto_ae_eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	ret = otx2_cptvf_send_eng_grp_num_msg(cptvf, OTX2_CPT_AE_TYPES);
+	if (ret)
+		return ret;
+
+	if (cptvf->lfs.kcrypto_ae_eng_grp_num ==
+		OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(dev,
+			"Asymmetric Engine group for crypto not available\n");
+		return -ENOENT;
+	}
+
+	eng_grp_msk = BIT(cptvf->lfs.kcrypto_se_eng_grp_num) |
+		      BIT(cptvf->lfs.kcrypto_ae_eng_grp_num);
 
 	ret = otx2_cptvf_send_kvf_limits_msg(cptvf);
 	if (ret)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
index f36d75f40014..3078e2375d3b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -126,6 +126,8 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 		grp_num = rsp_grp->eng_grp_num;
 		if (rsp_grp->eng_type == OTX2_CPT_SE_TYPES)
 			cptvf->lfs.kcrypto_se_eng_grp_num = grp_num;
+		else if (rsp_grp->eng_type == OTX2_CPT_AE_TYPES)
+			cptvf->lfs.kcrypto_ae_eng_grp_num = grp_num;
 		break;
 	case MBOX_MSG_GET_KVF_LIMITS:
 		rsp_limits = (struct otx2_cpt_kvf_limits_rsp *) msg;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 8b4ac269330a..e71494486c64 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -399,6 +399,8 @@ int otx2_cpt_get_eng_grp_num(struct pci_dev *pdev,
 	switch (eng_type) {
 	case OTX2_CPT_SE_TYPES:
 		return cptvf->lfs.kcrypto_se_eng_grp_num;
+	case OTX2_CPT_AE_TYPES:
+		return cptvf->lfs.kcrypto_ae_eng_grp_num;
 	default:
 		dev_err(&cptvf->pdev->dev, "Unsupported engine type");
 		break;
-- 
2.48.1

