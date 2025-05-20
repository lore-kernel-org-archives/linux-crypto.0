Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5293A22D78D;
	Tue, 20 May 2025 13:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746489; cv=none; b=IkfciPF3awQiPJ1wp2svQXd6oEl97Ulijv2tKBhDQQH7hKQHgLuonGV9Oznsf555tYLSPGXA1vVS5RPuqafmuOyX/sDPXE+wS1SOMNRRR5k4l4DVIrRD/0hNgfPqoRA/UlKfFBIshrgoYNtHm9H1bJPtQOW/LQnra1XU23E9EFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746489; c=relaxed/simple;
	bh=tEfLy6FVHZcie3IKvuRy6JFSYbRIvA56lw1COPPC9YE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYEKvHpimnFhtbLTqQomA9IDDC4kcfiKsTzI7FRnvdng1hGOejMR3iuEC5rJsAtYFDIxegVO4GkojW9hiGuHXMtMT0TmtTIKVwvdTwperOCPdhjh5XZpy7vm5QPgjhKQXnI5RY/vJRFl9EQAQ7SU1aYCtzEeNN+YjF5OaXuqwM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NLU0gPOn; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NLU0gPOn"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNT7x3011159;
	Tue, 20 May 2025 06:08:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	SLmtUS3te1snL6BRGN9tN+VKR2hhu6soJQA9DTvbOk=; b=NLU0gPOnOO8hKqZJa
	d4tW09qj5zMJlGSGiVi07ED2ji4qNzCWD5BOEYndxutiwpFhfln0vno9BjDJH5Ns
	wccJEWtyGV3Qg4CGUbJXt+FktuXmlOl6lWkq4uJ62ryLlNGe45k2MuMiJdKQ9M4/
	lzDWp86P96Vxp9WjnWFuXJCTB1SB4pD2Uo2vlWQDLTiTEbQn4ER6eS5JbkvRL9LU
	4vlygBGg17E9FcuBppwcRz1OxgEB6R58UPswlojSSCAWQIetCrPc8jNpG07Ku+Fp
	gdynt6NkkHM9447M+X7mEYIgqZg47gXTYkpPTRXVVALCLiVqPkypI0e2pw60VHxJ
	L3adg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46rebt18km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 06:08:01 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 20 May 2025 06:08:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 20 May 2025 06:08:00 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 741103F7065;
	Tue, 20 May 2025 06:07:56 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 4/4 v2] crypto: octeontx2: Fix address alignment on CN10KB and CN10KA-B0
Date: Tue, 20 May 2025 18:37:37 +0530
Message-ID: <20250520130737.4181994-5-bbhushan2@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEwNSBTYWx0ZWRfX4Qele+icYLbn bGwFnBW59MWjNUb1iyVH+awXF9oMoVopckc4kilRcpAXlvXbsyQWFg3Mmq2rmVHYg0Gy54vmRqm MD9lFOz0AgphQxX/MG10FrrOtyHQRumEnR+JTgXh/kJaTMx91lKd4h8QhMAd7/9J/aA1nmV0WQy
 0xOmxvFbrZkEHWVHZTJsncFdvm0/yuansFrIQH6bCj+XQzi8YK6nhoe0ujZpyUONKGECSV+D9VR GT14nyAtdFYNpSbz3DDYdZnhMV5T+xHkVLVWUFYVVKmnCehRiLAs/Y9v/loNVWnn67m79H10WcR 7qTlfRqGYTo6Nxufo4k8FI7MLD8YoDII4VMnhrMBlaqHfwir/wRkmUUKbUXCRnRpiPIzim8olZY
 n/6yNHf4jwOzrcrVSZUbB4Vqj/A1Ha7rfAfkBXUf/2NbTUNfZccY1tCyv3xyKlUh89BHmEFV
X-Proofpoint-ORIG-GUID: NVCHJ3yVRSytzNs950JmBf8zBc1HMC8y
X-Authority-Analysis: v=2.4 cv=BqCdwZX5 c=1 sm=1 tr=0 ts=682c7eb1 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=BhrP5AWxFkdJNdVQK0QA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: NVCHJ3yVRSytzNs950JmBf8zBc1HMC8y
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
Cc: <stable@vger.kernel.org> #v6.8+
---
v1->v2:
 - Fixed memory padding size calculation as per review comment 

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 59 ++++++++++++++-----
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index bb4e067ae826..766fa63fb075 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -350,22 +350,47 @@ static inline struct otx2_cpt_inst_info *
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
 
-	g_len = ALIGN(g_sz_bytes, align);
-	sg_len = ALIGN(g_len + s_sz_bytes, align);
-	info_len = ALIGN(sizeof(*info), align);
-	total_mem_len = sg_len + info_len + sizeof(union otx2_cpt_res_s);
+	info_len = sizeof(*info);
+
+	g_len = ((req->in_cnt + 2) / 3) *
+		 sizeof(struct cn10kb_cpt_sglist_component);
+	s_len = ((req->out_cnt + 2) / 3) *
+		 sizeof(struct cn10kb_cpt_sglist_component);
+	sg_len = g_len + s_len;
+
+	/* Allocate extra memory for SG and response address alignment */
+	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + sg_len;
+	total_mem_len = ALIGN(total_mem_len, OTX2_CPT_DPTR_RPTR_ALIGN);
+	total_mem_len += (OTX2_CPT_RES_ADDR_ALIGN - 1) &
+			  ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
+	total_mem_len += sizeof(union otx2_cpt_res_s);
 
 	info = kzalloc(total_mem_len, gfp);
 	if (unlikely(!info))
@@ -375,7 +400,9 @@ cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		dlen += req->in[i].size;
 
 	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
+	info->in_buffer = PTR_ALIGN((u8 *)info + info_len,
+				    OTX2_CPT_DPTR_RPTR_ALIGN);
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

