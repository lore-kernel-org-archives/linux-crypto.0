Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E035A101F2;
	Tue, 20 May 2025 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746483; cv=none; b=oB6oJSDnzsUCritE2wOeEbwwCE5SM7X8j+L5/zKBoX3Ev8nDIv5M9xVroJebBNPRAhc2Jhd4YtYg+pQsgneaSOfppWHGI3s/Kbr2yOEKe4Fo6qRVwPdBSS1HEP9bWbXVum8lxgl7+nrX9p2Pfij60ofIqh/3fjzVWgEDH8vJlpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746483; c=relaxed/simple;
	bh=I52q+hoDuobCy/FE574vOeIZBD8bXnP6OQrciNhZ8HI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRAvFRciowcisSRrnqXsmeMABFwnx+QuC6vb1rpZ+TiA5KnMBKtkEjAKO55B2hFldONvleoauvPmIX0/gCWkzsmNBnDG+IlKARlRJemkYsz99rPQvmZmXTIPIqvPAu/xl47lB7GOmK+siYBRjZxO36P2vA6Di2hAN770Fn0XpHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RgkWp0Gd; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RgkWp0Gd"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KAHgCI005546;
	Tue, 20 May 2025 06:07:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	SbBzYuT1HPa+UBLObZa/rHSQ7RZhJDOVONg8UkQXQI=; b=RgkWp0Gdzt+WhToNc
	CKhi+F6iSqBC+G9KtQ5XzAnoI+Robm2zs6blv7hzmV+8Y4kn9EmMfu7oQii+sXKG
	ngA5HaMj/6BjscQdcJKfqP6pW0l60pFPWnqNUfPlpst+EPMLHy+MhxSgyH+9qp9Q
	K35yT3x+C5x8BMXLtJgK5YihHLojE6p9bOH236YaKr3trnBaIHRbiD5s1FwHi15N
	oPCtEfTFoFdBeNKTM5h5Aj+FCwogQcoipMKDC8VZGrg9VY4xAWRqIFrUN+eSIsjX
	AG8rCYSK1oayYN+T9X/FOpX7R5RUfuNHDGKmNwRmYfsOjHTWKA5OIpHaGgIy5w7v
	yoM/A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46q46fcvcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 06:07:53 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 20 May 2025 06:07:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 20 May 2025 06:07:51 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 511E23F7061;
	Tue, 20 May 2025 06:07:48 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/4 v2] crypto: octeontx2: Fix address alignment issue on ucode loading
Date: Tue, 20 May 2025 18:37:35 +0530
Message-ID: <20250520130737.4181994-3-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250520130737.4181994-1-bbhushan2@marvell.com>
References: <20250520130737.4181994-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=b8uy4sGx c=1 sm=1 tr=0 ts=682c7ea9 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=ub5NSpVJfYrinLkKqRIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: olhpXK5So6qKuNjGuL2zlBSu_2HPqY99
X-Proofpoint-ORIG-GUID: olhpXK5So6qKuNjGuL2zlBSu_2HPqY99
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEwNSBTYWx0ZWRfX0MLIo7fHjGfI hPTN8+93NS4GWBgASuoLMlJ7Kvh28PjQiEFoMaN48/pp9HioH4IYVga5vh4VVA3ARPiTYq5Lnwt w3a50UmRU9nml9BzQ+rrBbK3K1rtHZSo7LuO2AxmvctLorg6OiP8tA8g0nB8TnEak+WF3fJK+xS
 Y8j6cXKoPJaxN9vm6A68yry5hKb087TjNSpyo//U7TT+gDjEPujuWD76yGZ4avEk1x7CA5hlFcI 4aJT8Ej+/Hbl7D0iwpR0ohn+zHkL518krr3JShf8MHvkTc4baR8m93vHVGRQCDbu3tUVxmlfF/w fjFNBcI+kEETdnDadCb82PNlx/0nDn7ESZB522PD+y7Z3m0cm+NfXul+wRKg39Spv4atKaf+jxM
 phV5vGFRURdxNGSEtL049RU2vKkws5qNAO6S8VXHzgN6dv36BCbMLFyzJ4qx6ptdGfC7S8VR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_05,2025-05-16_03,2025-03-28_01

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()"

Completion address should be 32-Byte alignment when loading
microcode.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Cc: <stable@vger.kernel.org> #v6.5+
---
v1->v2:
 - No Change

 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 9095dea2748d..3e8357c0ecb2 100644
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
@@ -1519,22 +1520,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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
@@ -1546,14 +1552,14 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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
 
@@ -1576,8 +1582,8 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
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

