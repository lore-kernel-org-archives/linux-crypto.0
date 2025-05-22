Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13125288CA1;
	Thu, 22 May 2025 10:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908424; cv=none; b=NAT9LUtuB7+z1ubeC9QytU4Oiqv+1G6WGMNCyI+4AvthfzubX7hUMZNGKenektUj0/nHS7/Hm4NKYPHJ/+49dijxV3tpqJUGnFRF5xN077SPvyIWQsBWpn2yBu6TkN8qcA+FQYXZnWAqzZ6tzmyzLhUjlK4pqBEu7QHePUUb6Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908424; c=relaxed/simple;
	bh=mtboeDMY5otbNjIXDqs9HEzEdkdlvsdHOhf4Wb6sTCU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unaJsnzfRo5DlIy7XSXW4w2kR7lsIKedDmnAm/u7eDw1hE29uTaMXRAS6ysa2bMSty0uWdVbSSwdSiS49MtfRYqM9/5OLf2cxKbJQfJkU3lOEYayrlOL8XUBFIF8m930+zAQuofgNxT/qLU5MX3nQ7mKy0V4vYKIL0pSVqjtxzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=WfdPNCag; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WfdPNCag"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5K8rc014360;
	Thu, 22 May 2025 03:06:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=B
	em5GbQzb8pFdcLi28ckFrDdVlDIhuU/H/j2UJ2eTA0=; b=WfdPNCagjHGPWSR3T
	UQxp5oYjKh2ka5GSdrLc8zWcS4VNPZZpJVQL2czyVmK+cX5RDVsdzO4w4Nd73wd4
	KBMDzlIMrhn/5JEt6mMNQUcZF5+wZCSBFsZIymCRPH2m82I6pOIGhWb23f9CRPsf
	cBIOx9iDmZWm9IX5wDV0TNqxETSYFxPFVo/zZXUSLmxdw/tT4JgIxjEHm8EGzMA4
	AYOs6FndNermZ8Arka8Eqgn0oW15HkvREh7WUdL0lhgivzmVm54lYYfuPWOwkbFd
	1QBTi4zvl5+uV4/erWc4vD4v3psuG+FjnPcDWp/1j+lXhrxgUB6i0Fj3KKSC+u15
	whQqg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46swp68ge2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 03:06:42 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 03:06:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 03:06:41 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 912623F704D;
	Thu, 22 May 2025 03:06:37 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/4 v4] crypto: octeontx2: Fix address alignment issue on ucode loading
Date: Thu, 22 May 2025 15:36:25 +0530
Message-ID: <20250522100627.175210-3-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250522100627.175210-1-bbhushan2@marvell.com>
References: <20250522100627.175210-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: LwY1sFshyr7NSYurl1e65pB6wLFNNMA1
X-Authority-Analysis: v=2.4 cv=DO+P4zNb c=1 sm=1 tr=0 ts=682ef732 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=ub5NSpVJfYrinLkKqRIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfX+EsRKjsVKzPS Tp3vUi9Bj97rOPyqLq9Ze5OpuZrglvTYKwXNuuAMCzU+hchuFre3/VqGs8RIcKe/GHUNnK3y1wY V7RzH3M75fNz1SHiE8Eiuc0ic1lmfRRg2EDODeEGC00Z5bD7q1cEbk1RE2gR72KK8kBjm9Cm5WL
 hyQ/3E2/s6qbzjMzHi36s6Zu8kR1n9f+aZOJuaOzB5XGYuBybmVG0ccgqOkwHorXeqLYLu3oo8f kdZ3/6a+hWgt6LYoUgRaaTRRviEg9ttxW1eJOpyRL5q0i6SzH9ku1mAkCwrzsYaDU3KQ2QVNYu7 12Yom/MTHJolKggfvV6/jSbNLhxkt6qyTdUetbrXMBjj6TzHXJF5fZOZ6qyfhi+GrKr0cc0AFhs
 fQmBYMq5n5cTEC3hFzZKVX/JB91fdkyzcNHziYdUaNKJ9nItziiVB5fRSQRZ2bSZQ+K5DrkA
X-Proofpoint-ORIG-GUID: LwY1sFshyr7NSYurl1e65pB6wLFNNMA1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()"

Completion address should be 32-Byte alignment when loading
microcode.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Cc: <stable@vger.kernel.org> # v6.5+
---
v2->v3:
 - Align DMA memory to ARCH_DMA_MINALIGN as that is mapped as
   bidirectional

 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 35 +++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 3a818ac89295..88f0f72a4462 100644
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
@@ -1521,22 +1522,28 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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
@@ -1548,14 +1555,14 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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
 
@@ -1578,8 +1585,8 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
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

