Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93571547E2;
	Wed,  5 Mar 2025 07:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741161502; cv=none; b=r5iKSBo7AJys5ugnWv5A5ihN9d7+g6hYFA/eEngtJn3cosndefQWSkOjN6vw8P+mu7Zfd39DPcxXlrWcpFCEpIhG5y+pQQO5E/TwbEJo2h31fpQVJQp2NoAWOFZDrMZL1gfnAI2bvrUXsE2684zIHFzC8mVHdgzHMkmwC8EagR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741161502; c=relaxed/simple;
	bh=X5XQrDXEPciRuX9iq2hVuzW/+FG66YoJJMIz1n0bFZQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SldgZYtNWmoLHgabxr42dZawtKFMv9fB4ZNAOt5KWQTF0aBaDMxr9/ai/B1QpGK2irAGAewzOsI9huVUBEqO1e6bbClzTgxaqYoP0zAjRLrmYDv+TJRpArzAtCcBFhXMpp5zwfLT2gAZSwQ9NYBXL7gZ2iBXVQFLo1P6Gtz36Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iQFKH6n3; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iQFKH6n3"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5253vdEs028481;
	Tue, 4 Mar 2025 23:58:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=JIWQDFjaDYN/Y8wWU8cKql+
	4eIYuROMtD9vaIXBcFaE=; b=iQFKH6n3XXY65uasOFaTQ+xhBkAWPzMBl4eWONO
	FiocZ9c51uuwkEI3noL+ilIQluuhysxuIdmW3MCelNmSHMHRUsC4TjV4Om7s6SSf
	W/8d8DtxII5VG/XS0SXQijxEH5Ae+yJ3bJ8AIlf8vOd7Wn2b2nwwUPMzEVOG6THi
	bKb+2Y+byvQbmfIk0QZ7ikVu6U7DxO2YsCLk8wYUhqJMcpXdU8iNWvRT3kzyQZIz
	HAd8nX/NKVC4wdy9iyjKlQxA70hKZInokF7hU/ngu3esSmBfrGpWmXTWuaZePR1o
	Eza8roAzmtPBLghV/+uNV0FAKuh6qa/9yxSfZ09CCNM6HiA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 456f5tgcr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 23:58:02 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 4 Mar 2025 23:58:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 4 Mar 2025 23:58:01 -0800
Received: from bharat-OptiPlex-3070.marvell.com (bharat-OptiPlex-3070.marvell.com [10.28.8.24])
	by maili.marvell.com (Postfix) with ESMTP id E7D853F703F;
	Tue,  4 Mar 2025 23:57:57 -0800 (PST)
From: Shashank Gupta <shashankg@marvell.com>
To: Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard
	<arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Amit Singh Tomar
	<amitsinght@marvell.com>,
        Shashank Gupta <shashankg@marvell.com>,
        "Sunil
 Kovvuri Goutham" <sgoutham@marvell.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: octeontx2: suppress auth failure screaming due to negative tests
Date: Wed, 5 Mar 2025 13:27:05 +0530
Message-ID: <20250305075704.2987579-1-shashankg@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: rV9ak91RPM_aGl2NilWDy29WqeqvyyS7
X-Authority-Analysis: v=2.4 cv=JtULrN4C c=1 sm=1 tr=0 ts=67c8040a cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=Vs1iUdzkB0EA:10 a=M5GUcnROAAAA:8 a=y9R9rvgWzFRaf_s37dAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: rV9ak91RPM_aGl2NilWDy29WqeqvyyS7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_03,2025-03-05_01,2024-11-22_01

This patch addresses an issue where authentication failures were being
erroneously reported due to negative test failures in the "ccm(aes)"
selftest.
pr_debug suppress unnecessary screaming of these tests.

Signed-off-by: Shashank Gupta <shashankg@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index b89e245c9aa4..835a2a2de477 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -276,9 +276,10 @@ static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
 				break;
 			}
 
-			dev_err(&pdev->dev,
-				"Request failed with software error code 0x%x\n",
-				cpt_status->s.uc_compcode);
+			pr_debug("Request failed with software error code 0x%x: algo = %s driver = %s\n",
+				 cpt_status->s.uc_compcode,
+				 info->req->areq->tfm->__crt_alg->cra_name,
+				 info->req->areq->tfm->__crt_alg->cra_driver_name);
 			otx2_cpt_dump_sg_list(pdev, info->req);
 			if (uc_ccode == 0x4C)
 				*res_code = -EBADMSG;
-- 
2.34.1

