Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9AB1F791C;
	Wed, 14 May 2025 05:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199502; cv=none; b=iXLJR5ypnel+CkIgSyPbCuSPqP1at7sdai9pNfKmKoK6jT7af+RvbWDy2PFKx7Rf5L4NdxU+B/axxNv/fl3uKw84yLBveTuhAC/PnOgsxNmgvCBA2McUqvsGYjcYFCVUnHNbS6xPYZF71VgiRywOc9V9kWJRtq1mCS1EulxTDBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199502; c=relaxed/simple;
	bh=2u/76lM2Mfg4ZKuNuBrLs/mRGlWi5jQPe3o/Wbvd6Bo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b1RhNAcnD3Lj6iFVsNjbGHVHskgxJe/PhvIpjWNIDZNjubG696NwzyjmoZMnT9OsHEAU2i/4w2kXjjgwJftlYZWRTJnoe6zce/SKCMEqyyTmgceYFhHevycC/OA9Eed2fkI5BOpaa1Ggovw7s5YtUFfWlDhI7jdVel1BWddQI1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=bC0zsuYb; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bC0zsuYb"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DIUiBO005870;
	Tue, 13 May 2025 22:11:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	Edeb0hbSxfVDzp8AXTaWewX0YDK1f5oG5uC+/dDPJ8=; b=bC0zsuYbN3hwzbYlN
	+hKbVtTfXw7/nlOsj98oGzhL3W/K3M3/i7HLtmYE3ATOSiPsGg/UvMlM+fjt35MO
	7VO8gxppaSge5tx1B0aYUi3P8bSgdYwLxnwcXRqMOLAA4BxE8X2jLu+3fHC+W8bR
	H0e7UgoTZgx7EgaZAaBPk2gqdCAcu9rVpiEfyT5lRN6t7Z9Z1WKpqGsg/k9ZImzM
	dCFUYPLt8sHcsG3I4zUzXQZnhPb964fDgPIEOePrq6duY0BYSYnLl02JTJXWpEII
	GV6s0UbGm4yKOUF/buzUy27+2XZM1Tte71k/NFWvrQ0zDkcScHxm0ERUSeL7xdnp
	3pphw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46mbe211ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 22:11:26 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 13 May 2025 22:11:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 13 May 2025 22:11:25 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id CDB075B6934;
	Tue, 13 May 2025 22:11:21 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bharatb.linux@gmail.com>
CC: <stable@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 3/4 RESEND] crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
Date: Wed, 14 May 2025 10:40:42 +0530
Message-ID: <20250514051043.3178659-4-bbhushan2@marvell.com>
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
X-Proofpoint-ORIG-GUID: fyktusxU6I6pW2F6-ibaHTYh6ZtzvdJC
X-Authority-Analysis: v=2.4 cv=fbyty1QF c=1 sm=1 tr=0 ts=682425fe cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=x_2_y-6S6mRvB2HLd-wA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: fyktusxU6I6pW2F6-ibaHTYh6ZtzvdJC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0MyBTYWx0ZWRfX4ySys8jiiAza KRDsoGvsS+LIaqbw3HE71VBMF8A80fVpiwDO7p9EKCF5IcsVEqXn3Rjp/sSBGud+xnqEU4qkqZE gnMs4ak41gC0vmuScz/xlXnfcueXpe7/OJnXktThDfmc99u41WggsDxcDxzHT+6D36dpFGz1lcc
 bRyzr/xnQGlgNhu8o1rfnYxRvyS2SCopfzeAmo5WYfPOyJTFfDbRgrK3Hld2wixkU1GfcJIYKq5 CzVV0+8IE5JVnaRVVi9u6qY/Vuk5yWepsSa3g6dYS2CcL5jm3DaSQC6o7e6sFZ+5ZIFuxg1pKE7 oVb8zMkd09yDsuENNu1ZijWUXnJPDHzzvsqNiYjTVwuxcNRDo9vBGHH3y5iatZfdxUL7sIWCpXd
 riQvifoXXDgC8QxMhVD/hH6v5SmzfDCJkzK8/SVJFojsvFq7ugnEqNJ/IpDs0ySI527OfGoZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01

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
---
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 62 ++++++++++++++-----
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index e27e849b01df..f0f1ff45c383 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -34,6 +34,9 @@
 #define SG_COMP_2    2
 #define SG_COMP_1    1
 
+#define OTX2_CPT_DPTR_RPTR_ALIGN	8
+#define OTX2_CPT_RES_ADDR_ALIGN		32
+
 union otx2_cpt_opcode {
 	u16 flags;
 	struct {
@@ -417,10 +420,9 @@ static inline struct otx2_cpt_inst_info *
 otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		    gfp_t gfp)
 {
-	int align = OTX2_CPT_DMA_MINALIGN;
 	struct otx2_cpt_inst_info *info;
-	u32 dlen, align_dlen, info_len;
-	u16 g_sz_bytes, s_sz_bytes;
+	u32 dlen, info_len;
+	u16 g_len, s_len;
 	u32 total_mem_len;
 
 	if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
@@ -429,22 +431,50 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		return NULL;
 	}
 
-	g_sz_bytes = ((req->in_cnt + 3) / 4) *
-		      sizeof(struct otx2_cpt_sglist_component);
-	s_sz_bytes = ((req->out_cnt + 3) / 4) *
-		      sizeof(struct otx2_cpt_sglist_component);
+	/* Allocate memory to meet below alignment requirement:
+	 *  ----------------------------------
+	 * |    struct otx2_cpt_inst_info     |
+	 * |    (No alignment required)       |
+	 * |     -----------------------------|
+	 * |    | padding for 8B alignment    |
+	 * |----------------------------------|
+	 * |    SG List Gather/Input memory   |
+	 * |    Length = multiple of 32Bytes  |
+	 * |    Alignment = 8Byte             |
+	 * |----------------------------------|
+	 * |    SG List Scatter/Output memory |
+	 * |    Length = multiple of 32Bytes  |
+	 * |    Alignment = 8Byte             |
+	 * |    (padding for below alignment) |
+	 * |     -----------------------------|
+	 * |    | padding for 32B alignment   |
+	 * |----------------------------------|
+	 * |    Result response memory        |
+	 *  ----------------------------------
+	 */
 
-	dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
-	align_dlen = ALIGN(dlen, align);
-	info_len = ALIGN(sizeof(*info), align);
-	total_mem_len = align_dlen + info_len + sizeof(union otx2_cpt_res_s);
+	info_len = sizeof(*info);
+
+	g_len = ((req->in_cnt + 3) / 4) *
+		 sizeof(struct otx2_cpt_sglist_component);
+	s_len = ((req->out_cnt + 3) / 4) *
+		 sizeof(struct otx2_cpt_sglist_component);
+
+	dlen = g_len + s_len + SG_LIST_HDR_SIZE;
+
+	/* Allocate extra memory for SG and response address alignment */
+	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + dlen;
+	total_mem_len = ALIGN(total_mem_len, OTX2_CPT_RES_ADDR_ALIGN) +
+			 sizeof(union otx2_cpt_res_s);
 
 	info = kzalloc(total_mem_len, gfp);
 	if (unlikely(!info))
 		return NULL;
 
 	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
+	info->in_buffer = PTR_ALIGN((u8 *)info + info_len,
+				    OTX2_CPT_DPTR_RPTR_ALIGN);
+	info->out_buffer = info->in_buffer + 8 + g_len;
 
 	((u16 *)info->in_buffer)[0] = req->out_cnt;
 	((u16 *)info->in_buffer)[1] = req->in_cnt;
@@ -460,7 +490,7 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	}
 
 	if (setup_sgio_components(pdev, req->out, req->out_cnt,
-				  &info->in_buffer[8 + g_sz_bytes])) {
+				  info->out_buffer)) {
 		dev_err(&pdev->dev, "Failed to setup scatter list\n");
 		goto destroy_info;
 	}
@@ -476,8 +506,10 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	 * Get buffer for union otx2_cpt_res_s response
 	 * structure and its physical address
 	 */
-	info->completion_addr = info->in_buffer + align_dlen;
-	info->comp_baddr = info->dptr_baddr + align_dlen;
+	info->completion_addr = PTR_ALIGN((info->in_buffer + dlen),
+					  OTX2_CPT_RES_ADDR_ALIGN);
+	info->comp_baddr = ALIGN((info->dptr_baddr + dlen),
+				 OTX2_CPT_RES_ADDR_ALIGN);
 
 	return info;
 
-- 
2.34.1

