Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595F8101EE;
	Wed, 14 May 2025 05:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199498; cv=none; b=GvV3sk5vaK3lA0elrgpZADmCcH6moFgS806L26IhBbP8X5DTaZgCqg3S1z73vxBnwsWq4SFl61tFXcKTKD5Oph6pEdRK4oBS2ga/Oh5QqibGN12TrtKerFvRgVDFkYjzwhEWSmNaEKbl3ZKtaudZtP/A/rkk9d5IeNjtExHuGGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199498; c=relaxed/simple;
	bh=nftJTquf7IRaq8HHdnbjeXO05NPydCSiIigaPKYx7mU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OD9/U+9xkoYNd8mVIxcap6HLxijEFqVtS/wJbBfRwqVH3My0llha9zyxUEC36fazx+WSILnkRU5VnYnWJdCB+oDsu8q6I9QJ2+AeHE1g2km8IX0zOBTIyXpeKbnduD8xA2jPCNubqCO0Ym55ZpWjfri8cYm9gOG5WrMKC4m0cYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=j9LbfbrB; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="j9LbfbrB"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNSt3r028349;
	Tue, 13 May 2025 22:11:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	Walq60J9nmTGN587g4K2toCWBPNF4Fg/bQygVQX8eM=; b=j9LbfbrBJXY6fUcSX
	2g+57D9Z3DIgnjZf5gn1JtPlgcJx9AsXBKi8b24EuwKC/bPwc+qLH4kljkKh08jd
	MW5WxEQsuiceaCtsu/LnzCbT1PZQHYmN3BC7q2bDcVQs8bFPrGo1G4dzkVLwNT99
	e72moPbyuGQz9iAuGnDoeaVKKzQ3x1WrjP9r5iBxvZimSlOZPEjQpDWA+s+J3YPX
	YbKWVAJYx3t+MnJAcYtpr6LjOVTb7V/kn4Si11whFsb7J6QoqgH39CIp3dNlBjuy
	4Hje/DIkBmcFZsqqlYb8hL9c0aIpTAdLdH/ZLUjHPY6k31sEv9KA70AuGi+3NFaq
	aPwwA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46mfssrgtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 22:11:22 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 13 May 2025 22:11:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 13 May 2025 22:11:21 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 547F85B693B;
	Tue, 13 May 2025 22:11:17 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bharatb.linux@gmail.com>
CC: <stable@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 2/4 RESEND] crypto: octeontx2: Fix address alignment issue on ucode loading
Date: Wed, 14 May 2025 10:40:41 +0530
Message-ID: <20250514051043.3178659-3-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514051043.3178659-1-bbhushan2@marvell.com>
References: <20250514051043.3178659-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=OvpPyz/t c=1 sm=1 tr=0 ts=682425fa cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=ub5NSpVJfYrinLkKqRIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: xZPNwD6JWLyKI20MPR_s5kz7M7YRzA9-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0MyBTYWx0ZWRfX3Ndg4D4v0Eae 25p35NHNCAODSFEk9c6lZuoJUuSsT5BrnPkRTjJQ4u0AvwJU7nKBcI/k4iMWC0dK+kh8xJGtgsD gQBNRq36XdV7z8HAPjwg+2ogJ3kRS8w2kGfVdAl/BfItFGC694tBGugjN1iu3grHFL1YnVk8Iom
 Z+EC8nIW7GSVLxL49YHvxTsBC0+JU2MjSC9LIfaKytgYqk05CrSS1wXNkSpRQVMHRkMoEhMVcs8 8MVPDf4ISYsa0dLfaGaU9H4fw2jxxm62V31/Devye55xhMsjkECLbBWJjZZKNJVUrChG7GAAtSw DywmgvCfPXUwZLzsm5E10BVhg82/qYJ9mVniEb0KuUFcaBEHw2TOTDGYK3EwWc1Ieih0NC0fq+W
 Kd0iit2ByxCQ2LtjLE5LQXKFjKrTNbN7guEq5DBk0KkLzP9UJ+kiFQXTr5CqiiwrMSA6eWn/
X-Proofpoint-GUID: xZPNwD6JWLyKI20MPR_s5kz7M7YRzA9-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()"

Completion address should be 32-Byte alignment when loading
microcode.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 3a818ac89295..1c2aa9626088 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1491,12 +1491,13 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	union otx2_cpt_opcode opcode;
 	union otx2_cpt_res_s *result;
 	union otx2_cpt_inst_s inst;
+	dma_addr_t result_baddr;
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
-	u32 len, compl_rlen;
 	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
+	u32 len;
 
 	/*
 	 * We don't get capabilities if it was already done
@@ -1521,22 +1522,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	if (ret)
 		goto delete_grps;
 
-	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
-	len = compl_rlen + LOADFVC_RLEN;
+	len = LOADFVC_RLEN + sizeof(union otx2_cpt_res_s) +
+	       OTX2_CPT_RES_ADDR_ALIGN;
 
-	result = kzalloc(len, GFP_KERNEL);
-	if (!result) {
+	rptr = kzalloc(len, GFP_KERNEL);
+	if (!rptr) {
 		ret = -ENOMEM;
 		goto lf_cleanup;
 	}
-	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
+
+	rptr_baddr = dma_map_single(&pdev->dev, rptr, len,
 				    DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&pdev->dev, rptr_baddr)) {
 		dev_err(&pdev->dev, "DMA mapping failed\n");
 		ret = -EFAULT;
-		goto free_result;
+		goto free_rptr;
 	}
-	rptr = (u8 *)result + compl_rlen;
+
+	result = (union otx2_cpt_res_s *)PTR_ALIGN(rptr + LOADFVC_RLEN,
+						   OTX2_CPT_RES_ADDR_ALIGN);
+	result_baddr = ALIGN(rptr_baddr + LOADFVC_RLEN,
+			     OTX2_CPT_RES_ADDR_ALIGN);
 
 	/* Fill in the command */
 	opcode.s.major = LOADFVC_MAJOR_OP;
@@ -1548,14 +1554,14 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	/* 64-bit swap for microcode data reads, not needed for addresses */
 	cpu_to_be64s(&iq_cmd.cmd.u);
 	iq_cmd.dptr = 0;
-	iq_cmd.rptr = rptr_baddr + compl_rlen;
+	iq_cmd.rptr = rptr_baddr;
 	iq_cmd.cptr.u = 0;
 
 	for (etype = 1; etype < OTX2_CPT_MAX_ENG_TYPES; etype++) {
 		result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
 		iq_cmd.cptr.s.grp = otx2_cpt_get_eng_grp(&cptpf->eng_grps,
 							 etype);
-		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
+		otx2_cpt_fill_inst(&inst, &iq_cmd, result_baddr);
 		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
 		timeout = 10000;
 
@@ -1578,8 +1584,8 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
 error_no_response:
 	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
-free_result:
-	kfree(result);
+free_rptr:
+	kfree(rptr);
 lf_cleanup:
 	otx2_cptlf_shutdown(lfs);
 delete_grps:
-- 
2.34.1

