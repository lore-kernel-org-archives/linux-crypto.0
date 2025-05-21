Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106D725C814;
	Wed, 21 May 2025 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747821925; cv=none; b=rn/CZm6uFjqRFJPbq2UIHgZjkFFuSM3KWhqY450uF1SHrW/JlxTbaRJKGKZnraK9V4ew8fEDjDh1fWwKe+WUY7YO5fi1/1xnVNeRJu/qh3c6IQmI6TRrxUWfVaM9rQgMd0/vdTaUTdNK/lO9QNyq+8zsxcbGjQMghZkSpsk91yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747821925; c=relaxed/simple;
	bh=w09QJS2CHpPPPBShQSbx0kEh1cU4AjomvsaLibzzqZI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BihaGUJ67W7rfazLoSmIT+IqmYplvxSf0IDXMI//pu2pMwbBCTuKgcI+uzvwu0NBNUDrVyHAYBq4/SPnQVEP5/i8yIMZty6/kAXbSIWnrCecUQqFC8nGOU53CC6VVUUAjG1YWZUCgVIcVChkzF3OisovpFNbOoT4srJeMFzyhCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TUN2K96J; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TUN2K96J"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L9qwLG010201;
	Wed, 21 May 2025 03:05:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	7h4I8UCAWaJQNlnW6T1gZDYgXALjPeTnXR+aNDIrRc=; b=TUN2K96J+ODsiLf2s
	Ef2ivX/q3WnPXqonS2CQj541LAKrEVUE1tj878cYNYNFtDCSM19abIWtsJt/y0Vn
	FcZVHaQVdbCsuk868E7sG7EMp0RSKPRq5YkeaKgSz3EVYlRXrGivpUPr7a3eD9Cr
	IXHAkvCSIzNn5/8Q6j2N2QoUjeo5KLxv4KuqJ8nulViNWAubcCmfWAPq8GLnI9US
	FV8w6rxEUcx0q2K05fnF3gP9PalnQvBbxd/jV670u9A7EK48GdVhivHdtBeZnThP
	G2PQ3HdlCl0kSmqzyYUXD40uyrglprkKfYTVi0Kpui9cwPbfL51eQRWJiPIRqV8j
	BTMZA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46rwfghpgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 03:05:01 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 21 May 2025 03:05:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 21 May 2025 03:05:01 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id ADCA53F70B3;
	Wed, 21 May 2025 03:04:57 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 2/4 v3] crypto: octeontx2: Fix address alignment issue on ucode loading
Date: Wed, 21 May 2025 15:34:45 +0530
Message-ID: <20250521100447.94421-3-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250521100447.94421-1-bbhushan2@marvell.com>
References: <20250521100447.94421-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDA5OSBTYWx0ZWRfX1n4IXN0WpHVf FAuEe/JFFMji8Em2DPPiJjlwMkzeVZtSgcV2xSU5m+/nNZcIvG6Amk0ZJ/HPNAFE7X0gQazL7Rl 2jwAi3/rv6iUp/2Qyc9RkLZTxBUUN5eIHZzl8+57hYLB/cCVWRpZISOHWHLnafLwNCfAwU/6L4U
 1bC+MbmMNkJiOZ/g7zyll/7UQwnbzyhr/ObSnEgcWxlcvfpFUFkeXcIBfsK6dWIeXe5JWypDS02 LiunQWbzNytjzRXb0EkZAnpWOAmSKsjmMHgQ+HzbSO/rOsHao1I3j90ZS5oPJdDBsI16NyzOSZU RLkVsVpbj5lhriwLOGAPZ08jc4bHkewh8LsPfVN3CXTglBT33fPcy508m6ipdjGzgxsgWXftZdx
 U5lMZXVkiruG0xN0VX1O+Nqj0bcPgAiHkzgrTuFAOrg+AmJ6RyRa82q9cJ8bmetQjHLXXqcG
X-Proofpoint-GUID: ifjEwj9PkHVDTON98cmujFQvIIOt3cDj
X-Authority-Analysis: v=2.4 cv=T6OMT+KQ c=1 sm=1 tr=0 ts=682da54d cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=ub5NSpVJfYrinLkKqRIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: ifjEwj9PkHVDTON98cmujFQvIIOt3cDj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_03,2025-05-20_03,2025-03-28_01

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
v2->v3:
 - Align DMA memory to ARCH_DMA_MINALIGN as that is mapped as
   bidirectional
 
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 35 +++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 9095dea2748d..56645b3eb717 100644
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
+	void *base, *rptr;
 	int ret, etype;
-	void *rptr;
+	u32 len;
 
 	/*
 	 * We don't get capabilities if it was already done
@@ -1519,22 +1520,28 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	if (ret)
 		goto delete_grps;
 
-	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
-	len = compl_rlen + LOADFVC_RLEN;
+	/* Allocate extra memory for "rptr" and "result" pointer alignment */
+	len = LOADFVC_RLEN + ARCH_DMA_MINALIGN +
+	       sizeof(union otx2_cpt_res_s) + OTX2_CPT_RES_ADDR_ALIGN;
 
-	result = kzalloc(len, GFP_KERNEL);
-	if (!result) {
+	base = kzalloc(len, GFP_KERNEL);
+	if (!base) {
 		ret = -ENOMEM;
 		goto lf_cleanup;
 	}
-	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
-				    DMA_BIDIRECTIONAL);
+
+	rptr = PTR_ALIGN(base, ARCH_DMA_MINALIGN);
+	rptr_baddr = dma_map_single(&pdev->dev, rptr, len, DMA_BIDIRECTIONAL);
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
@@ -1546,14 +1553,14 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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
 
@@ -1576,8 +1583,8 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
 error_no_response:
 	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
-free_result:
-	kfree(result);
+free_rptr:
+	kfree(base);
 lf_cleanup:
 	otx2_cptlf_shutdown(lfs);
 delete_grps:
-- 
2.34.1

