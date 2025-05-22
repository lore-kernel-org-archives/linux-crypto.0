Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F5E221F37;
	Thu, 22 May 2025 10:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908417; cv=none; b=rCgE250nFtXsNhPgotLNxOeYwJN5C/5J1vxHGj2twjrHVRBCtBtpwKSb9Rq+1MAa6W7RWr5G/52jJttizayxtO8N0HFvmxt/zgVdxYwlGEJYhZhLCJdYZzRt8cVJ6+Bi9bZwhK7f5IeCjbqMf+HfhxiJx1K/OWWpHUrRvsXzyvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908417; c=relaxed/simple;
	bh=w3AaIJAHuk3uQ+QykUvpy5268DoANgoa/H0j6w4F6K8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKLQfEU/ZONcZS1y2cGjPrXkLCVhbF2KbJpCu3d+Jwm8tq8UvFnKtCFQwOoaeSsS4Cz/7OUoCs5fdFc3GQ3/h1E6syYFx/Uq0F2f5yTphUY3UATJI80KB0U581N5xouMEGkm6vt32ebeU9Fye11gIAfq/i250iDC9JKk4p1bOJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=A8S1Ychu; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A8S1Ychu"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9H7cQ007465;
	Thu, 22 May 2025 03:06:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=9
	Xa4YAlvMZ/o0rCENPbDSK5TOI09/+nRQJsQBJ6Loms=; b=A8S1YchurUxuuMpZH
	0UpTv8FzY7WD0ucuRGmH+5JBvkbvr/Z3CBZV6ioxz62g6N9Kamy7SISqUfu4Kium
	AtJOFF1QnyyzVMY5e+rjVosFF6OPYxKYFberIP3A8ropXAiM/gUcmCqka8uJS013
	PdERO5eGSFbER3C8y9Gr+Lwz19Do2Nyv98HpA/8wVleo5BS7aajRGSebxCYrRvax
	ZkfEjIAVTc0xQ5hNPzPZgZz7bHh3pIxCsG/WpgfpBxRbKahvLF4CfW70+uipGD76
	feWi83j58sCqRPJVglUQCnVDqcUHuyVs179UYh74SZFHyLI7CYAHvBFux6N6VlGT
	W4Fkg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46t15jr3a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 03:06:47 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 03:06:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 03:06:45 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 180483F704D;
	Thu, 22 May 2025 03:06:41 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/4 v4] crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
Date: Thu, 22 May 2025 15:36:26 +0530
Message-ID: <20250522100627.175210-4-bbhushan2@marvell.com>
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
X-Proofpoint-ORIG-GUID: CzDbLdtoWdgm-6o69KHgHzKEavf6N4Y4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfXweW87W9DUKjw 2JCtyKB4JuFjPvUztPUENJnDpBC23Srv8BZ2a0gsIMGLPWCR5CzhJmuIVHJZWh4K4NRcoOrPzOq XlPYLv2wAU1/FUOKFPBFLJc9r8zuhiuD/UuMINB4zrMfkEHz+OqZjZu3MumaeXLTM2NV/GZ3cBF
 q+Z9hejOP+1OwSLcWOdAOI5VfhvuKYYpchjLsnhD0HTtWKcCo/OIbH0Nl+dipquEUasmDPGfPU8 o3qF2jJ6HOuyL5iE8ExVIJf9nrAyqCsnAidth8hQKg8sx7wVQGJYVZCL/W/n2WHe+7VhhA1Nm0Z GsS/lL4cOOx4QEW0q1b1wJWAVGXyKtSFetAn6HSMcWR3imQjWRyduRlyNPLIv4X/8qXzrdd1OHp
 ew16Ptf2cirOY0StzeVfwJta+wQ8h83VvZ3MEUgKxnMqAEvkGddJKzu3hBg5mlZxUeIZAxM8
X-Authority-Analysis: v=2.4 cv=HOrDFptv c=1 sm=1 tr=0 ts=682ef737 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=vPvlv9gvxcbrHEec8UYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: CzDbLdtoWdgm-6o69KHgHzKEavf6N4Y4
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
Cc: <stable@vger.kernel.org> # v6.5+
---
v3->v4:
 - Again fixed memory size calculation as per review comment

v2->v3:
 - Align DMA memory to ARCH_DMA_MINALIGN as that is mapped as
   bidirectional

v1->v2:
 - Fixed memory padding size calculation as per review comment

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 66 ++++++++++++++-----
 1 file changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index e27e849b01df..98de93851ba1 100644
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
@@ -429,22 +431,54 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		return NULL;
 	}
 
-	g_sz_bytes = ((req->in_cnt + 3) / 4) *
-		      sizeof(struct otx2_cpt_sglist_component);
-	s_sz_bytes = ((req->out_cnt + 3) / 4) *
-		      sizeof(struct otx2_cpt_sglist_component);
+	/* Allocate memory to meet below alignment requirement:
+	 *  ------------------------------------
+	 * |    struct otx2_cpt_inst_info       |
+	 * |    (No alignment required)         |
+	 * |    --------------------------------|
+	 * |   | padding for ARCH_DMA_MINALIGN  |
+	 * |   | alignment                      |
+	 * |------------------------------------|
+	 * |    SG List Header of 8 Byte        |
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
+	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN);
+	total_mem_len += (ARCH_DMA_MINALIGN - 1) &
+			  ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
+	total_mem_len += ALIGN(dlen, OTX2_CPT_RES_ADDR_ALIGN);
+	total_mem_len += sizeof(union otx2_cpt_res_s);
 
 	info = kzalloc(total_mem_len, gfp);
 	if (unlikely(!info))
 		return NULL;
 
 	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
+	info->in_buffer = PTR_ALIGN((u8 *)info + info_len, ARCH_DMA_MINALIGN);
+	info->out_buffer = info->in_buffer + SG_LIST_HDR_SIZE + g_len;
 
 	((u16 *)info->in_buffer)[0] = req->out_cnt;
 	((u16 *)info->in_buffer)[1] = req->in_cnt;
@@ -460,7 +494,7 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	}
 
 	if (setup_sgio_components(pdev, req->out, req->out_cnt,
-				  &info->in_buffer[8 + g_sz_bytes])) {
+				  info->out_buffer)) {
 		dev_err(&pdev->dev, "Failed to setup scatter list\n");
 		goto destroy_info;
 	}
@@ -476,8 +510,10 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
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

