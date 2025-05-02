Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79899254AEE;
	Fri,  2 May 2025 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192133; cv=none; b=bMY61T6Q6E3Te7uPfcLhyJhHQEWrURE9BMM825tazrWM9SteDr42zgK1A+4QsMp6shQmXKMWFMoEZ/ltOfjXwaHOEf5JApAVV+H7CvqtXym9ZaNqq+f3tnmtDL1X4O0Bp1sRCuczUBoXnyg6XlZ0NIydtcbWKkWqb7EVHDdTPu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192133; c=relaxed/simple;
	bh=pNToQ4sn8mggyUxqZ4vVLqm2SADL++fk9nZg0HdSa4I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwnsRxd1l7Je9JKspeIsRhvJK8HzZbpGS166/0yHKRMcL5iqtki3l0BCOJRGpmymeOt6u1ZB2cgfriBxXAnGGVoov3iYxUFF7YixaLkIL76lW9Yjmlyz7n/RgBFUETcQKODZ1uz/XSWwD4uLS/9d/1k9DTt3l2r+zviiejNaS1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=glwkkgQX; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="glwkkgQX"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5429m2rh008255;
	Fri, 2 May 2025 06:21:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=q
	jDrNvUo+XqJVxxrOTNvSb0lMwxy+8viuYTnXF0wgXs=; b=glwkkgQXXh9PXDq44
	uWUCen4l1pUYCh3AoddQHk2cy4Vo3nn+TEHIxb7dJD8DhSxfPmhmOq8JWmXgnUxw
	6SVxk0VVNXI7aqvSnWQ/FeKKNMV0RSuLmK3JkJbC6RndHDyXZl20ikrlAhViDe+j
	y1udQJRDXu0K8VzOYhdbyZAQXXT8d8jNuU5ADjRqBR1UVOaiB31HP/nMBLptili2
	Oaf8xAleOLeNW8AJx9yYkGQo2KpWVg+WKOubpQwoSNilBJ928eyM1Q8dpHekMW6H
	Z5ImVV1eRVfHMkuHgz6SR8FNCtQVKAdnX+gXwKdyhs0DDUnT1FNPnluSHmjuQcGz
	ZMRew==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cuqyr9sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:21:45 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:21:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:21:44 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 33F2D5B6922;
	Fri,  2 May 2025 06:21:33 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <hkelam@marvell.com>, <sbhatta@marvell.com>,
        <andrew+netdev@lunn.ch>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bbhushan2@marvell.com>, <bhelgaas@google.com>,
        <pstanner@redhat.com>, <gregkh@linuxfoundation.org>,
        <peterz@infradead.org>, <linux@treblig.org>,
        <krzysztof.kozlowski@linaro.org>, <giovanni.cabiddu@intel.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rkannoth@marvell.com>, <sumang@marvell.com>,
        <gcherian@marvell.com>, Tanmay Jagdale <tanmay@marvell.com>
Subject: [net-next PATCH v1 03/15] octeontx2-af: Setup Large Memory Transaction for crypto
Date: Fri, 2 May 2025 18:49:44 +0530
Message-ID: <20250502132005.611698-4-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502132005.611698-1-tanmay@marvell.com>
References: <20250502132005.611698-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: H8HsNSuyrZVsA8SacGoAW4TtKYlLR02y
X-Authority-Analysis: v=2.4 cv=JvPxrN4C c=1 sm=1 tr=0 ts=6814c6e9 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=gcLevytPFhx6Mr_woyEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: H8HsNSuyrZVsA8SacGoAW4TtKYlLR02y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX17cf5hDJIvlZ keSH2DUzeSS81ZOeieISG2FdseIfeLYDBNAsMo8BuVELxmLelGsz/D+AvY/+Lh1m2MxS1UlyvpZ n/J2DmecDRau+3y2SEdAI0u5xL8ub4utUjhdUTOkYfaDLGs4lKOj4J+VLwJ8/UmD8GxdLgHsr6D
 t9p/DLWmCgGkFb2jqZrdlqgKaq2zu0CDTdsmfioiCESypI31qMYT2za05XrmqLJ8N4rSRUAd127 xeQuVbo7lKxntwsWDuElhxQ12iKVsQzqBDRJqvZI2lDHd9vkRLlRTVeImSp4yB959vEdUjm0HeS Znks1mdEKxWk2JBybLQNatO3i5oyyzCv2zeNHmUM05W6Ni34BqTdGPvPq97mycUOVIKtw0wSdCl
 Utc8XG+HWtnLtCTkloJeZXY/BYAxKKcq1k8PMHyX7ENEvNrkbQlF8Q3U+5x2Vuf2g7QMURCT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Large Memory Transaction store (LMTST) operation  is required
for enqueuing workto CPT hardware. An LMTST operation makes
one or more 128-byte write operation to normal, cacheable
memory region. This patch setup LMTST memory region for
enqueuing work to CPT hardware.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  7 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 51 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |  4 ++
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index d9f000cda5e5..ea346e59835b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -731,6 +731,7 @@ static void rvu_free_hw_resources(struct rvu *rvu)
 	rvu_npa_freemem(rvu);
 	rvu_npc_freemem(rvu);
 	rvu_nix_freemem(rvu);
+	rvu_cpt_freemem(rvu);
 
 	/* Free block LF bitmaps */
 	for (id = 0; id < BLK_COUNT; id++) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 6923fd756b19..6551fdb612dc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -557,6 +557,12 @@ struct rvu_cpt {
 	struct rvu_cpt_inst_queue cpt0_iq;
 	struct rvu_cpt_inst_queue cpt1_iq;
 	struct rvu_cpt_rx_inline_lf_cfg rx_cfg;
+
+	/* CPT LMTST */
+	void *lmt_base;
+	u64 lmt_addr;
+	size_t lmt_size;
+	dma_addr_t lmt_iova;
 };
 
 struct rvu {
@@ -1086,6 +1092,7 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
 int rvu_cpt_init(struct rvu *rvu);
+void rvu_cpt_freemem(struct rvu *rvu);
 
 #define NDC_AF_BANK_MASK       GENMASK_ULL(7, 0)
 #define NDC_AF_BANK_LINE_MASK  GENMASK_ULL(31, 16)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 89e0739ba414..8ed56ac512ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -1874,10 +1874,46 @@ int rvu_mbox_handler_cpt_rx_inline_lf_cfg(struct rvu *rvu,
 
 #define MAX_RXC_ICB_CNT  GENMASK_ULL(40, 32)
 
+static int rvu_cpt_lmt_init(struct rvu *rvu)
+{
+	struct lmtst_tbl_setup_req req;
+	dma_addr_t iova;
+	void *base;
+	int size;
+	int err;
+
+	if (is_rvu_otx2(rvu))
+		return 0;
+
+	memset(&req, 0, sizeof(struct lmtst_tbl_setup_req));
+
+	size = LMT_LINE_SIZE * LMT_BURST_SIZE + OTX2_ALIGN;
+	base = dma_alloc_attrs(rvu->dev, size, &iova, GFP_ATOMIC,
+			       DMA_ATTR_FORCE_CONTIGUOUS);
+	if (!base)
+		return -ENOMEM;
+
+	req.lmt_iova = ALIGN(iova, OTX2_ALIGN);
+	req.use_local_lmt_region = true;
+	err = rvu_mbox_handler_lmtst_tbl_setup(rvu, &req, NULL);
+	if (err) {
+		dma_free_attrs(rvu->dev, size, base, iova,
+			       DMA_ATTR_FORCE_CONTIGUOUS);
+		return err;
+	}
+
+	rvu->rvu_cpt.lmt_addr = (__force u64)PTR_ALIGN(base, OTX2_ALIGN);
+	rvu->rvu_cpt.lmt_base = base;
+	rvu->rvu_cpt.lmt_size = size;
+	rvu->rvu_cpt.lmt_iova = iova;
+	return 0;
+}
+
 int rvu_cpt_init(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	u64 reg_val;
+	int ret;
 
 	/* Retrieve CPT PF number */
 	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
@@ -1898,6 +1934,21 @@ int rvu_cpt_init(struct rvu *rvu)
 
 	spin_lock_init(&rvu->cpt_intr_lock);
 
+	ret = rvu_cpt_lmt_init(rvu);
+	if (ret)
+		return ret;
+
 	mutex_init(&rvu->rvu_cpt.lock);
 	return 0;
 }
+
+void rvu_cpt_freemem(struct rvu *rvu)
+{
+	if (is_rvu_otx2(rvu))
+		return;
+
+	if (rvu->rvu_cpt.lmt_base)
+		dma_free_attrs(rvu->dev, rvu->rvu_cpt.lmt_size,
+			       rvu->rvu_cpt.lmt_base, rvu->rvu_cpt.lmt_iova,
+			       DMA_ATTR_FORCE_CONTIGUOUS);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
index 4b57c7038d6c..e6fa247a03ba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
@@ -49,6 +49,10 @@
 #define OTX2_CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
 #define CN10K_CPT_INLINE_RX_OPCODE (0x29 | (1 << 6))
 
+/* CPT LMTST */
+#define LMT_LINE_SIZE   128 /* LMT line size in bytes */
+#define LMT_BURST_SIZE  32  /* 32 LMTST lines for burst */
+
 /* Calculate CPT register offset */
 #define CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
 		(((blk) << 20) | ((slot) << 12) | (offs))
-- 
2.43.0

