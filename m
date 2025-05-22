Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E769C289354;
	Thu, 22 May 2025 10:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908429; cv=none; b=AlyNWT2N0btLuufPV/Fa8PRnOXpiZ5TxqQqrj2XtyXgdi6ZH3AhzVYeZSSF5KOmc3bqV8GRdVW4ptmvete9oksZqEBobbBrIQMSd22DxBBuzUPWfp0TQqIz9LwRVrQC+xmtlCmrv6Ok6yQZ17VayHcljIdAD8vxZg6+MJCNaE84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908429; c=relaxed/simple;
	bh=4pDb4C0sh/qZHgIzi6dKO1GV+ZeBStwpDtSQmWiKse0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZ7uw9uQP0lJRSm/cVXquesbbB8uNiU3T8k2odstk2ypqezoyHSUVlLX705sEDhlrTWbK/lIOHajaNG0gIS36Kq6vRBi5xmYi+c7J/JBbDensaob0pGG4C9CajbMA2oN80Uqkn60ru/WrXvA4vYGCsflrmMym+R1dClsnQgueG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=i/btlNAz; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="i/btlNAz"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6WIcj008628;
	Thu, 22 May 2025 03:06:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=X
	k8PVtFakCzcbPiBPd8CnD1tldsGHZZEWkvVmn0VXJ4=; b=i/btlNAzGeOD6v08M
	8QbNBSwrOuIQjo85C7GwGZQGDH67RzzKtkFTkIgLLm1i3M673E1cclTnywtJELC4
	TbrHFQNrIiR+Ew/13jbCGdcVG/pcGdZNUOsSlpGZHXHTyUR7VbxC7MPf256ONaAd
	VWFkRB1q2r8h9pJZddoGFxWhHoszqA5OI15ushmnz/+GKO1mVWN7afS246KFFyQM
	y928rbM0MLNiZtEZD8WDmFXa6+s9bRgT9rQ9MlBkz40BkuHSUbU5KWSG7QfW6KeC
	m3AXlBEiX47evwoO4yfDd+LbkA8H1Dyb1Sx1j5TmpW0ujhln2utNzniP9nmEO/7c
	amF6w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46sxr1gc04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 03:06:50 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 03:06:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 03:06:50 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 34F873F704D;
	Thu, 22 May 2025 03:06:45 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 4/4 v4] crypto: octeontx2: Fix address alignment on CN10KB and CN10KA-B0
Date: Thu, 22 May 2025 15:36:27 +0530
Message-ID: <20250522100627.175210-5-bbhushan2@marvell.com>
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
X-Proofpoint-GUID: fiy2aakT7L7dPgENFes702I92A9IY5M2
X-Proofpoint-ORIG-GUID: fiy2aakT7L7dPgENFes702I92A9IY5M2
X-Authority-Analysis: v=2.4 cv=LYU86ifi c=1 sm=1 tr=0 ts=682ef73b cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=BhrP5AWxFkdJNdVQK0QA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfX15NwPiTbS9ke yve0y+n/NiS4vFhMlid9TFZgTrtDqx/fiVdaQSeyQfq5l2DfDcHDjbijGTwHdCJOkM56g7gDtc1 kTBKeCibcvHXc0kICLixuzLEla9ViU55AH2VeBrAH0Ur1gT4sG5OpW5qylELG/oJs3VEESeuLmQ
 YggzmYRSDmDzvz+EB9qoluVr7UHuo3Yk36JVYRbShX3xJFPCXq2Rz6Ye5e0JPUpvkd3WnJQQ0YF yyUyO5iOVAWjnJEdkudlVoFYsw3l83KcNtS38thZXnImWwqy9YLAUZtBEri8Y9xWP7W9uXUSC8H A3F6kgmLAhFeg6/eq5V+t+gkPJFDfP6ksBw8umOrXBItpRBBKoMdJpfr143zmJPUYRaCB/qSdo4
 wT0YbJof5bVZ0pFIKQVe4sZjoUfWCTF+oPr4/ugrsB1VzmYBsguJ1DV3ChpUl6lTo2vCtokW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()

Memory allocated are used for following purpose:
 - Input data or scatter list address - 8-Byte alignment
 - Output data or gather list address - 8-Byte alignment
 - Completion address - 32-Byte alignment.

This patch ensures all addresses are aligned as mentioned above.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Cc: <stable@vger.kernel.org> # v6.8+
---
v3->v4:
 - Again fixed memory size calculation as per review comment

v2->v3:
 - Align DMA memory to ARCH_DMA_MINALIGN as that is mapped as
   bidirectional

v1->v2:
 - Fixed memory padding size calculation as per review comment

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 59 ++++++++++++++-----
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index 98de93851ba1..90a031421aac 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -350,22 +350,48 @@ static inline struct otx2_cpt_inst_info *
 cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		       gfp_t gfp)
 {
-	u32 dlen = 0, g_len, sg_len, info_len;
-	int align = OTX2_CPT_DMA_MINALIGN;
+	u32 dlen = 0, g_len, s_len, sg_len, info_len;
 	struct otx2_cpt_inst_info *info;
-	u16 g_sz_bytes, s_sz_bytes;
 	u32 total_mem_len;
 	int i;
 
-	g_sz_bytes = ((req->in_cnt + 2) / 3) *
-		      sizeof(struct cn10kb_cpt_sglist_component);
-	s_sz_bytes = ((req->out_cnt + 2) / 3) *
-		      sizeof(struct cn10kb_cpt_sglist_component);
+	/* Allocate memory to meet below alignment requirement:
+	 *  ------------------------------------
+	 * |    struct otx2_cpt_inst_info       |
+	 * |    (No alignment required)         |
+	 * |    --------------------------------|
+	 * |   | padding for ARCH_DMA_MINALIGN  |
+	 * |   | alignment                      |
+	 * |------------------------------------|
+	 * |    SG List Gather/Input memory     |
+	 * |    Length = multiple of 32Bytes    |
+	 * |    Alignment = 8Byte               |
+	 * |----------------------------------  |
+	 * |    SG List Scatter/Output memory   |
+	 * |    Length = multiple of 32Bytes    |
+	 * |    Alignment = 8Byte               |
+	 * |     -------------------------------|
+	 * |    | padding for 32B alignment     |
+	 * |------------------------------------|
+	 * |    Result response memory          |
+	 * |    Alignment = 32Byte              |
+	 *  ------------------------------------
+	 */
+
+	info_len = sizeof(*info);
+
+	g_len = ((req->in_cnt + 2) / 3) *
+		 sizeof(struct cn10kb_cpt_sglist_component);
+	s_len = ((req->out_cnt + 2) / 3) *
+		 sizeof(struct cn10kb_cpt_sglist_component);
+	sg_len = g_len + s_len;
 
-	g_len = ALIGN(g_sz_bytes, align);
-	sg_len = ALIGN(g_len + s_sz_bytes, align);
-	info_len = ALIGN(sizeof(*info), align);
-	total_mem_len = sg_len + info_len + sizeof(union otx2_cpt_res_s);
+	/* Allocate extra memory for SG and response address alignment */
+	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN);
+	total_mem_len += (ARCH_DMA_MINALIGN - 1) &
+			  ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
+	total_mem_len += ALIGN(sg_len, OTX2_CPT_RES_ADDR_ALIGN);
+	total_mem_len += sizeof(union otx2_cpt_res_s);
 
 	info = kzalloc(total_mem_len, gfp);
 	if (unlikely(!info))
@@ -375,7 +401,8 @@ cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		dlen += req->in[i].size;
 
 	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
+	info->in_buffer = PTR_ALIGN((u8 *)info + info_len, ARCH_DMA_MINALIGN);
+	info->out_buffer = info->in_buffer + g_len;
 	info->gthr_sz = req->in_cnt;
 	info->sctr_sz = req->out_cnt;
 
@@ -387,7 +414,7 @@ cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	}
 
 	if (sgv2io_components_setup(pdev, req->out, req->out_cnt,
-				    &info->in_buffer[g_len])) {
+				    info->out_buffer)) {
 		dev_err(&pdev->dev, "Failed to setup scatter list\n");
 		goto destroy_info;
 	}
@@ -404,8 +431,10 @@ cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	 * Get buffer for union otx2_cpt_res_s response
 	 * structure and its physical address
 	 */
-	info->completion_addr = info->in_buffer + sg_len;
-	info->comp_baddr = info->dptr_baddr + sg_len;
+	info->completion_addr = PTR_ALIGN((info->in_buffer + sg_len),
+					  OTX2_CPT_RES_ADDR_ALIGN);
+	info->comp_baddr = ALIGN((info->dptr_baddr + sg_len),
+				 OTX2_CPT_RES_ADDR_ALIGN);
 
 	return info;
 
-- 
2.34.1

