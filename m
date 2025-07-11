Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A276D28B7E6;
	Fri, 11 Jul 2025 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752236042; cv=none; b=YB8mhid1HwMb2e1PM5eD81Wr8UGOh41t5RD86ktquX1HScKxXOgRp4k6AelAwD3GCONS8AYqy1L6yE4/5kOsOuCJEdw4jtgAPG5e/s8jNgIIte0KHWRy7XzLggVjndyVcBIyZhKlsLtfwQhzTGHdrIfOAHQtXumXSaWznqvN/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752236042; c=relaxed/simple;
	bh=DEzMQsDx3d741gOOqVv7ajRY2SvmxpjpdCvLK27B9mg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unl0Df8JyXBLcV2KoB84+5wqYlIfzyHlU8zdb7/6nZfoThiVCyhjt8H2Voflk6HPGInHEb9R5eShRpuClwglR4vsGj54NgZDIwp9wba+NNUV8RSqdDdyudzJ5pVVB/1181Dv4yusuomF8/M1Qp2Di6cnb/8qLCuodwt5CN8zGlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XsEkkycf; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XsEkkycf"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7pfHB013939;
	Fri, 11 Jul 2025 05:13:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=o
	AoDuFUdMQX5WxWDEAR/g7QgFceK2SeRY6zNCK2PwCM=; b=XsEkkycfTgnQlvoOg
	iGjwkLUn7aGNS/yzVXtJRWLCpcb1ZwOnYvxId8akwWdPjQoo3R28rb/w0Q4qvWcr
	rT5XaViM/tMGDdwLTN3jg2je8O45OXijQ3iyR7s4SmDpk5/Q3HFSmiNMpD/IB3Qh
	KWpl79s1wGrbNtjXhT/TNNJw5/YEPxSmpX/Q6x89ZkjQONtHRzOFmRNn7r394tSZ
	f0ptdHOt/SZA+qdg3bcKyH36twjpcexR2iA8fxyHfGY9Hq7Z7iofxmfOD6/yj2+F
	3ve+KCjTtLESAr72Wp7YHfwIMyLw9Gbe/eIBy0BsHeXPylVuLpt819/4bytNU7xQ
	ntXag==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47txkg8dc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 05:13:50 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 11 Jul 2025 05:13:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 11 Jul 2025 05:13:48 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 2D0623F7058;
	Fri, 11 Jul 2025 05:13:45 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <herbert@gondor.apana.org.au>, <sgoutham@marvell.com>,
        <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v3 03/14] octeontx2-af: Setup Large Memory Transaction for crypto
Date: Fri, 11 Jul 2025 17:42:56 +0530
Message-ID: <20250711121317.340326-4-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250711121317.340326-1-tanmay@marvell.com>
References: <20250711121317.340326-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 4noI1ZpOT-P5LpV3hc9Dhzqkh1pf5qZD
X-Proofpoint-ORIG-GUID: 4noI1ZpOT-P5LpV3hc9Dhzqkh1pf5qZD
X-Authority-Analysis: v=2.4 cv=OP0n3TaB c=1 sm=1 tr=0 ts=6870fffe cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=gcLevytPFhx6Mr_woyEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA4NiBTYWx0ZWRfX9F/+c/CW/UJs LF2vUyK0CKRAoIYpovuC8lLvKV6Vu6R/ItgB07VveZbcKL35GGeCSNMXr3r1/drPKgOvygFmFad QGTVTMDhM+dd9mVNqXZy1yZcYAjKmj58we/nqzTeycY5wNhgW7ARaA9QshzhUhHV0y3/pMZ06Mn
 Sxo4FuXGY0h2I8Rd1NuwA8uWnFxlGnfGkrPI7Wg0MkMDPu20EnAIAHRm6g9xOGmibtO1aK7r8Qg rssuz9H9RSJAs1Q5Ju2vtHxVI8YqSFgobVmZCGUKfcG+EUZQPhjpcUiZy4YdvEkFIKshZNCuR4C 1nnmxr3BZz98fkK0y+0fC16pEj2zVRHKWIMCQNJRZ6RAThbs37t0fPfnc3yw5QejhUvzf/ut/Xw
 5dZh3SAYQzG/PFXWeEunBdQ5MOKs7bL6ib94B1pH1qgttKcblCRukdYVnsM+O8pAFNTu4kd1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Large Memory Transaction store (LMTST) operation  is required
for enqueuing workto CPT hardware. An LMTST operation makes
one or more 128-byte write operation to normal, cacheable
memory region. This patch setup LMTST memory region for
enqueuing work to CPT hardware.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V3:
- None

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-4-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-4-tanmay@marvell.com/

 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  7 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 51 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |  4 ++
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index a4e9430acba9..250d9e34b91e 100644
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
index e1b170919ba9..84ca775b1871 100644
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

