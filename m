Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931172550D7;
	Sun, 26 Oct 2025 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491416; cv=none; b=b7LL7P9P32BOwJhh20Q4Q4Ej6Tdrj7eTwaVPLZa3efLd7wavExRAcUVQvBgfV2Qah/QuHxcxaofb+rSfJNrJvBDmdt6ntW22l6xZXBxvCTtB1xQs4akiCkpbxSogFwQjKy3MikZRvP19cDJD9DybLy6UW2uDPNYJKwJof9AFJyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491416; c=relaxed/simple;
	bh=J3CJcOPKqc25ZYY35iI+wN/bHlm0nAON0cNU87+ZxaY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tb41a9yabslKcbpz8KxdBa5yt6AafmNk0e8Bn58brLtbokDgM5xyBjmgWZM++rP4xzfbf8jGhnmaWXbypGrXuZudxB7irwdRJFgb+cNQk8Gzb1xqkgCqJuvRiTuL1p1hFeeEioJ9vlCAWa2YXNhHzfTB/2MWfjmRUX0N6kCnYVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eDyEvhkl; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eDyEvhkl"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QDWx8a3735070;
	Sun, 26 Oct 2025 08:10:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	N00CTvNaacvghDRLqphoLoeWVmZGp7LFBdL6DkBeA8=; b=eDyEvhklE1YnJScCp
	1JMcdR/P1d3HAaSxPORaHiUaCKHQfG9xv9NyA7soDBEYFq4Y3NpF8mAUOJ92SVwL
	NAeUGZxQqIn2Oo69oShj6iyOSzFPF7ItEgyI2dkUDN9yjBK9Ug9jWBV6i7gfq4Bu
	PwATfgMl+85mpuSADm7Hw5DwkYeFvGzJL9tCZ/Ocuh7EJRiveMtG0/mTB5RHtNlT
	JDvcmy+qPqK8TPW5EYXzlSqfEO4tbNb1te82OoPtW5hP/nCtXVF8VttFWPOjnsum
	SkyBVAUp3ZJsfpCLbLW6MF8o6mYMTgo6nENFb+OtOY5Rec6n36oSjbKN4DdnEvTv
	loLEw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a1fa5rfwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:08 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:16 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id BEA593F70B5;
	Sun, 26 Oct 2025 08:10:03 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 03/15] octeontx2-af: Setup Large Memory Transaction for crypto
Date: Sun, 26 Oct 2025 20:38:58 +0530
Message-ID: <20251026150916.352061-4-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251026150916.352061-1-tanmay@marvell.com>
References: <20251026150916.352061-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX/kV5mQlvhe9v
 wd+0fMllC5NIgwmbaLriMhmA/s8WgUkcM0q6zNE05aUs5EmI7dsMm//xOvJ0CQq7ZZCcK6iFDBG
 LCuOeBU7dR6naTy4Or8EaX58GN9mX2CjGLq9b5TTt/RG03pRUKu/t7n7JIAuLcSpxN9AGn2RpBm
 Ad2Rp6QsntrRv8jx/x4b1FSAAg9D3pT9SrsRt8UJLpG4JOT6QH67+rtjmxYb1kcBqVoLg+lc3/F
 JFo/I62lxGJLK2V1M7/iUk9EHwzqqyn+ewOSJKrNeCYMfVP69WHsqhzi+M8S/a4BA8TCBALg39e
 s3+AnFc2tQP4x0CfmexFkIPZk6j6yqTHtTcb/cU/pmQ8VinXKpWiNoLh2oc5cyErhQKAmATmV1x
 fSvBK0zlZhcuF6ixLnP0rNT1PiGyNg==
X-Authority-Analysis: v=2.4 cv=VOnQXtPX c=1 sm=1 tr=0 ts=68fe39d0 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=u7xRXLSO9GMRmrarCrgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: kwkQsqBGuzhBspZZJzYQqgnJSg4FPkCd
X-Proofpoint-ORIG-GUID: kwkQsqBGuzhBspZZJzYQqgnJSg4FPkCd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Large Memory Transaction store (LMTST) operation  is required
for enqueuing workto CPT hardware. An LMTST operation makes
one or more 128-byte write operation to normal, cacheable
memory region. This patch setup LMTST memory region for
enqueuing work to CPT hardware.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- None

Changes in V4:
- None

Changes in V3:
- None

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-4-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-4-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-4-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-4-tanmay@marvell.com/

 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  7 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 51 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |  4 ++
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index d8cf8e4a6d00..c496bb72e9f8 100644
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
index 9e837992924f..e5e1a9c18258 100644
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
@@ -1164,6 +1170,7 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
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

