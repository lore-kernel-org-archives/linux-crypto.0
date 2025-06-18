Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936522BEFF3;
	Wed, 18 Jun 2025 11:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246273; cv=none; b=NzLAslV87CROVmtm/ze+ESQ/TMcQR4wtdBCdmlqWzFWUUb2jWdHEL+G41TVB4XblBTiKMlUA3B50XqpMJ+pDnUEL78kdsEVlHatyNcn2DoXrlU8bHbStntXr7MWKGERpUamq2xeH+IHDEpxqYKJ/ZPDMZesynyR+hgyFcZdNg2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246273; c=relaxed/simple;
	bh=xggQkqJse8oSBvMmidJYWkmkFfwrwriH2+tOdruLHPw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kfWXBmdcJlWBAqtupuMDzMpatinIYOsiEP3G3FZ/rPdkkyEF3MFsSUvjm2OyAzTFnopLkwsJ9TbpQ7/1j+2bJMEZVEKFIJMUFm6AAanaW2tjol7fZgdaUbzNBJoOUs9/d/yerpVsnJ45T3C2wX3UQUydEoAgKdIYlzKgF3n9+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BoCGojza; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BoCGojza"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HNSRIt016134;
	Wed, 18 Jun 2025 04:31:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	vStsAFWh9+TijO0lBIHNjHFOd4COBsLrzsOVwXUcYQ=; b=BoCGojzaY9xJttNdM
	a+pRFsmfrDhmAqWJPPVmBAhM00IoZf479526UX8m59gwSQ8BlsZWpaus2OyIXvAt
	CdopUUaZ0Lw0EUlwPrqEjKOMNCByYsdMYOtzvSn2TDjCvKsUbjqgQKsEtO8Vd6tv
	MywVknadV2mYN1vnAo0CO8AJChpPsJO4MoZUBubXCUAQpEzgbUaCMBDXZVvUPDI5
	6Psjdsg1/ZACYMabzgevHUBuAgGCFBgoGlOa+NMLufty7IAuaGqSV2Cfi4bwUsUy
	iF9ihS/iFKLh/AVIxA5jVukq4t+PC333R4vYZRtrikzrIUNkIwRzrAdI80M9owZw
	abfhw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bj2kh92m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:04 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:30:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:30:52 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 7C1D13F7048;
	Wed, 18 Jun 2025 04:30:49 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 03/14] octeontx2-af: Setup Large Memory Transaction for crypto
Date: Wed, 18 Jun 2025 16:59:57 +0530
Message-ID: <20250618113020.130888-4-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113020.130888-1-tanmay@marvell.com>
References: <20250618113020.130888-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=Q9jS452a c=1 sm=1 tr=0 ts=6852a379 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=gcLevytPFhx6Mr_woyEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5OCBTYWx0ZWRfX1zSnxt1lN+lT IU4poc7kT8JFoUZha85cj/4+mcZPy8qPif+z6hIKKnSVu3LUt+MxNJ/dYovWdMQ/cvKpHRiskay YbvvlME6acEZe8+9PiAg8zeLkQx/GYQBB8eVTLYkMEDltPYaY3pOOvEAAZhLXr2TpVyVr89z69D
 DPEk/6nBrcYJOcaFCBG9c/60PgpvPboOfzfb/BOpTL3/O9zVeDd9wy5KbL4c2ImGtCLNZ4xY+bA yDFIn+47n0jSMsZmxvSFFj5w30VtvW+1YTeiwV/0zRXGgV5b19N0suf1NIfReekHBnH7MNgHJ9q XEqp3gMl0NWVoKu+rc1w4HcB7CjxkqtCRr7Uzl/rRRD9LcdpGTdenZDf2tpeP5FBuyG21LOX0xV
 ohwDWakDpI76X4T7q1vFpzeT/hiFdKuGEv9V2SBhXEUnXslu9AgNV9NtDRJaSsefDTkUPh+H
X-Proofpoint-GUID: VOgCV9RL_3rmS_D4V4pSq2aKNZ1Hqmf_
X-Proofpoint-ORIG-GUID: VOgCV9RL_3rmS_D4V4pSq2aKNZ1Hqmf_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Large Memory Transaction store (LMTST) operation  is required
for enqueuing workto CPT hardware. An LMTST operation makes
one or more 128-byte write operation to normal, cacheable
memory region. This patch setup LMTST memory region for
enqueuing work to CPT hardware.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-4-tanmay@marvell.com/

 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  7 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 51 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |  4 ++
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 25a9eec374bf..6b9958a87a45 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -726,6 +726,7 @@ static void rvu_free_hw_resources(struct rvu *rvu)
 	rvu_npa_freemem(rvu);
 	rvu_npc_freemem(rvu);
 	rvu_nix_freemem(rvu);
+	rvu_cpt_freemem(rvu);
 
 	/* Free block LF bitmaps */
 	for (id = 0; id < BLK_COUNT; id++) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 9f982c9f5953..1054a4ee19e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -602,6 +602,12 @@ struct rvu_cpt {
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
@@ -1149,6 +1155,7 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
 int rvu_cpt_init(struct rvu *rvu);
+void rvu_cpt_freemem(struct rvu *rvu);
 
 #define NDC_AF_BANK_MASK       GENMASK_ULL(7, 0)
 #define NDC_AF_BANK_LINE_MASK  GENMASK_ULL(31, 16)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 98d55969fd6a..154c13dec3ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -1875,10 +1875,46 @@ int rvu_mbox_handler_cpt_rx_inline_lf_cfg(struct rvu *rvu,
 
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
@@ -1899,6 +1935,21 @@ int rvu_cpt_init(struct rvu *rvu)
 
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

