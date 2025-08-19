Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6929D126F0A;
	Tue, 19 Aug 2025 02:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755570662; cv=none; b=mXZKMGzjM0KKweaNaohIf2+11jlyWeq6cXPsOZ5kljN+ZMoPChYav0w8a4Sks6KKkwivnMDfLTBENq4FK29JqD23a62UE2IcJNpgyl3zrvcYHbN3O2RLeAaBFAEnLwfJ+u10FO4sS4GVVKnwgAoG/b3j6cykxlJ0Kypu1OJnz8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755570662; c=relaxed/simple;
	bh=+m5hiLXwf4nXAbpcLrmzwvB2bKAbWEIMT/z8yovTW/E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ak7FrSK9GIvmq5uAbvu3lzektFSk9XslR7/PGNFj4CGNDT1DfhR4Rj4lJLCIZul+swK1POx5ds9iA4WGr5uE1ISjI9/vW51Fvczq6sMXBP/23sj/YOtbA98067GiW4FAz7Qfr7O1tqNQo+aKv9mFEhZeTJUJnvnuZ1N5clhC+1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iO66RYAe; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iO66RYAe"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IMlacm000348;
	Mon, 18 Aug 2025 19:15:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	3Szz2J4kEeBtTK4aI9ty8ioL+5W0DIaR+WBLTbIjgo=; b=iO66RYAegLun5Z0MQ
	ddGJiC7ppGe5PHQ58YRXAuov3YrpNt7bLzzrGQW08EPfmQfXz+INPSOjDItg7xK1
	fC3+MkC6xidKR9+FzKu40PNq8NOf3U1tdbETXacjyIwq7tSl0bjlq5khqDIYKzsI
	oInDwrZVkyE4xzJaYIJ7pvP4/J+cP5hrWFd5WDwCSOl0VrVlxmAr9ShJpReP/ONf
	wmFlPVoKe2nn4ZkzCC9ECy2oUlf4/sOqzxIfPNRtAhHf5u4GDDnVZHRNUKCQaNUP
	sWGk+C+KovmZUMCPS3KRZ33thfuiUjyXfO4B0aL6O3yv4AO1ogKneoWRtPqJgI4z
	M+tlw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 48md9ggcd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:15:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:15:29 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id EDCAC3F709F;
	Mon, 18 Aug 2025 19:15:21 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v4 03/14] octeontx2-af: Setup Large Memory Transaction for crypto
Date: Tue, 19 Aug 2025 07:44:54 +0530
Message-ID: <20250819021507.323752-4-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250819021507.323752-1-tanmay@marvell.com>
References: <20250819021507.323752-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=PN8P+eqC c=1 sm=1 tr=0 ts=68a3de3d cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=gcLevytPFhx6Mr_woyEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfX5NlcBYUtgAD4 BWhF2bzrB50uFXJERncfZbgFbvWCz68bNkB8hBT8YYZ2dOF1LflppyFuMLWr2PP4tHxjFpgCF0o /UazS1zEfHGzrWdWG5SEzqQr8/a7RsISfSOlssDEe9sAwNRDerXbdDjxx4rMSKMM09dtNKfpH65
 kU2CaJ+rE0QEM+gczGO3u0fK39Ml2xim/X1pWQ7tk4AknTh+Mht+IHVYtVz6RSUVFHGi5zT/SEm WTDNaqOyG4er5lx/8NEYAuX1r8yBkJSkcgM9tG1pxvv1TgOco8IMRbFIhR1dYUxZNs8E4mO4gDU q1nreQ6i61AUVg9jznlbnOyl1dc8mq3QaYvDdHkzlOepR3BOESaUjKBhPOSAImLSqiPW+p4ev6K
 SBvgvGiK5qvNi/hlT0oBhmO4/JwqToBs0M7za7dLCRoZO3itAZFWXbUdYyWYaVy11oN9DYsE
X-Proofpoint-GUID: 0JVKWm8BqlxwU61Tc4IBgZC6xT1WpW1y
X-Proofpoint-ORIG-GUID: 0JVKWm8BqlxwU61Tc4IBgZC6xT1WpW1y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Large Memory Transaction store (LMTST) operation  is required
for enqueuing workto CPT hardware. An LMTST operation makes
one or more 128-byte write operation to normal, cacheable
memory region. This patch setup LMTST memory region for
enqueuing work to CPT hardware.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V4:
- None

Changes in V3:
- None

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-4-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-4-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-4-tanmay@marvell.com/

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

