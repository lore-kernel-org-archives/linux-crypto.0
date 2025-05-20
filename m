Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C6622D9EE;
	Tue, 20 May 2025 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746486; cv=none; b=BkofLO+Gljr4IehOz479zTqK2yMi9GRE9i6/rrJEPIe0oWrFIXXwHgoF3mhG8JPogh8O8i9FiTRY0x/g1sjeL3C6V9T6AsKozsTdynCU6glPRU0ilX7BhhIK4HRJkX7QSHW2oV3xBQ0aLC7lyVmoApaXSFgdVkHjb6Lso6MwXBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746486; c=relaxed/simple;
	bh=DqgLSVdfu92LEwWfia0MIjKRE8xhGX8E3C06uS4L/Cw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZHjFByS3qQ2gKNrgq4bxs6eW+6pV9KDaQZaqHn+FsuB6TLg19CRa7IqCIKvQqBBTRrb7/i7nOnpJu9tifh2P3SdM5swxZEqdYQesMjhr1CHGqiyN+JbDtVY+DXOtg2RLvkiE2m/+Aq5noKRuApJJLeo0JhQCL4CyWd/jRtTK68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dWd4EWxF; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dWd4EWxF"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K9iEOb013054;
	Tue, 20 May 2025 06:07:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Q
	N0/mdXHuF6XBYxGjUmQHJ+UgVGeQf/qRWNI0uOOs9s=; b=dWd4EWxF9V7byVMee
	xam/PM2dExjOEzgxdZLJqNiQao0RYa2Lh8tHXEbiNbJjUvNWb26yQ+F3ra/3vfv6
	zVMuIgFG9RXUWmouNTOr/UsMMH5jRM/iGJ5hVJ7uROtF6fZeBHaMQ7KqWs5xpBGX
	8NKV2g6VsLwyIV500K20jw0iAfqNbbDMsuV64ul2yxCKk/qm5qGJE8uqSgFLEG1P
	SdkkFyeT7szgFDNgT8ytceBJI5bPDbOi7w8Zm5KrjLBAY/GX3Bbbv+0K7c0Ukgq/
	DrEHM1dagigHMLeVcFlAt6+dlSctEwOvw6nkIpXzRR2tcIxSCetDe+doV5m/TurX
	7bImA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46rqc8gadt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 06:07:56 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 20 May 2025 06:07:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 20 May 2025 06:07:55 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 64E6F3F7061;
	Tue, 20 May 2025 06:07:52 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/4 v2] crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
Date: Tue, 20 May 2025 18:37:36 +0530
Message-ID: <20250520130737.4181994-4-bbhushan2@marvell.com>
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
X-Proofpoint-ORIG-GUID: l8g_urLdKfNUC3avzQVSHSb9VaW9hem2
X-Authority-Analysis: v=2.4 cv=HuR2G1TS c=1 sm=1 tr=0 ts=682c7eac cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=_7N3KsqXCoWpZ83F5FEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: l8g_urLdKfNUC3avzQVSHSb9VaW9hem2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEwNSBTYWx0ZWRfXzcOStxtzQxJT NvBNIAqbdhNe0VeSi+rZY2VQxsOQCxe9tWZXC1XsrDzmWgizwylfg8L5TZmWNgwBor7DKmLXVFO Dr6AHMoKXGlkBowerka+9PrENC6RZJW6zrBHX/7FmX5nphRIdBnBTqhzinvxeCQYynRhl7bFHY3
 crgQlnI0rfJ1TDOqA33tMzGsh34mvDUaZfwclakg5T811ALH9UJnIKizzKat5B8rqRCFLkeDEai U85KCFI3uz0KYOsoMtXhpDyPv+LOhgU3ZWPUWj9jqwIFmJniaGvk79XBYJ+Kk5TEQ5liatWWm0G 788M7UykAPuZR3+XnE2iONjLsxKECzj33SanK39QVsHqWjRH4BBB1HCDcIdV68ylOc5JS+kj3mf
 JFlCay/tXtjo0Hh7Pqfb4NDaEqYxp/7vdnv9GRh+W066rk6NAt9mzUQKin+ElDqZBENW8XXe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_05,2025-05-16_03,2025-03-28_01

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
Cc: <stable@vger.kernel.org> #v6.5+
---
v1->v2:
 - Fixed memory padding size calculation as per review comment 

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 64 ++++++++++++++-----
 1 file changed, 49 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index e27e849b01df..bb4e067ae826 100644
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
@@ -429,22 +431,52 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
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
+	total_mem_len = ALIGN(total_mem_len, OTX2_CPT_DPTR_RPTR_ALIGN);
+	total_mem_len += (OTX2_CPT_RES_ADDR_ALIGN - 1) &
+			  ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
+	total_mem_len += sizeof(union otx2_cpt_res_s);
 
 	info = kzalloc(total_mem_len, gfp);
 	if (unlikely(!info))
 		return NULL;
 
 	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
+	info->in_buffer = PTR_ALIGN((u8 *)info + info_len,
+				    OTX2_CPT_DPTR_RPTR_ALIGN);
+	info->out_buffer = info->in_buffer + SG_LIST_HDR_SIZE + g_len;
 
 	((u16 *)info->in_buffer)[0] = req->out_cnt;
 	((u16 *)info->in_buffer)[1] = req->in_cnt;
@@ -460,7 +492,7 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	}
 
 	if (setup_sgio_components(pdev, req->out, req->out_cnt,
-				  &info->in_buffer[8 + g_sz_bytes])) {
+				  info->out_buffer)) {
 		dev_err(&pdev->dev, "Failed to setup scatter list\n");
 		goto destroy_info;
 	}
@@ -476,8 +508,10 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
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

