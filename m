Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A16B22B8A6;
	Sun, 26 Oct 2025 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491423; cv=none; b=EMj5fYoKEKgpMLM4DpEkEosPeRlHx12kNrSebI5sdV9rdJFgRYsIUGjpC5bdjpx1e+AuD3bn6TvXAy+SYmETRjacGjYMAf2P+gPmSqdY1QNrJL7ZxpRIzj25zxtFBZ10ond70ZevlrMsM0lWwuSz+Fm9ezN2v1dqPWoaW/DrOQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491423; c=relaxed/simple;
	bh=tK74iCri9GWBFwzsAxQEN/8TZiE9pIn1mUkxXcVveE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQfRZVf5OCrtS1n5HeAxCdZDFDwt1YFhjzdGN51MpMaEupmn8lRkQu2PEuI5+x3LdG60O0tPc38puRnqYdjR/W/woetz4BpWPcylfnR+Nqfq6PKV/BD4rDRu2CeUZRssI9o4rKYrF5Xep201ztSc0iygKV1+dF0qV6BeXTCfgSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Q9BnSP/G; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Q9BnSP/G"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QBTSEn3498980;
	Sun, 26 Oct 2025 08:10:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=k
	yqXifxWE7rpr3THyVaFohxIav36/klP7pQP7y+MUo0=; b=Q9BnSP/GVE2lzxPlA
	CmvKG3X/ypIyKTK/ysOteNtivnH2mt0MA+Vy04qlGiEnsDd0S9Vl7juRqd1CxK2q
	QxB/lLms6EOj6vfI3Ff6472JlC0eFg+He828qb3LoJWZoTC/uCdOW1mJyqu8blRY
	ucHOIeAK61F9PCT9KH9uyhheRYPiozDkEVsXUaBxJq7Qna2fI58uFiyKX56vj1e+
	p88iCtnSwKx85yhiOlt+47MvW+MlEw2X4x0oNFYQKFUdLHrPY70yZ4mDYEoxXOZe
	CBwh5u2o1C3yYKYtSPTIu2ThtSt82zSjn+GgC9RrCAafmf2sLRQ1bD0TdPdrQMLp
	BvIQQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4a1jt807v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:17 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:26 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 791253F70E2;
	Sun, 26 Oct 2025 08:10:13 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kiran Kumar K
	<kirankumark@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH net-next v5 06/15] octeontx2-af: Add support for SPI to SA index translation
Date: Sun, 26 Oct 2025 20:39:01 +0530
Message-ID: <20251026150916.352061-7-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX+ZVHvjlm/F8h
 NPJMbzdaAFV6iIsGbrGIwFUWPtUg62dBzFrXSM+uty/24/6gcazc5/MlYetiKBFv0uj98/J9OPE
 +rjVaTT5tgpousC4yL8xPYy7hiJKbjjI/lWZuj/toacMmqmyD2LrtqeupSrFR6goxrlU3Tjtuy6
 1jzSLS068wqNM5poyg9L18Cpq4yJHrzp/pafgIzF/+rV70By5KzAitup+QKyeB4d7CPeLgTXtg/
 a/Bq34erSVdnZSzJNkGCzkMKbvDYEpjBZuNr/Zs0ixQS3bOuvgoyq6x4swQvgmLim7SH+g90ciy
 MPd3dN1RlOaDwZjwxGQJ//VpDBK4I+vpl1RRHmUmV/kdoXPHwAPY48zAp95Toq3Q0rX2sGTDt7W
 P6/Oh088fLA5RqS8gIrk5mFvl9xlaw==
X-Proofpoint-GUID: -L-aV6rnljyTNz8iKEJgyoK2AKpFoYfu
X-Proofpoint-ORIG-GUID: -L-aV6rnljyTNz8iKEJgyoK2AKpFoYfu
X-Authority-Analysis: v=2.4 cv=APHuRV3Y c=1 sm=1 tr=0 ts=68fe39d9 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=rBsrSOb4FH7PZyWj1TwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

From: Kiran Kumar K <kirankumark@marvell.com>

In case of IPsec, the inbound SPI can be random. HW supports mapping
SPI to an arbitrary SA index. SPI to SA index is done using a lookup
in NPC cam entry with key as SPI, MATCH_ID, LFID. Adding Mbox API
changes to configure the match table.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- None

Changes in V4:
- None

Changes in V3:
- Dropped an extra line which was added accidently

Changes in V2:
- RCT order definition
- Fixed 80 character limit line warning
- Used GENMASK and FIELD_PREP macros
- Removed unused gotos

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-8-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-7-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-7-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-7-tanmay@marvell.com/

 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  27 +++
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   3 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  13 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   6 +
 .../marvell/octeontx2/af/rvu_nix_spi.c        | 211 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   9 +
 7 files changed, 270 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 532813d8d028..366f6537a1ee 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_OCTEONTX2_MBOX) += rvu_mbox.o
 obj-$(CONFIG_OCTEONTX2_AF) += rvu_af.o
 
 rvu_mbox-y := mbox.o rvu_trace.o
-rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
+rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o rvu_nix_spi.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
 		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o rvu_switch.o \
 		  rvu_sdp.o rvu_npc_hash.o mcs.o mcs_rvu_if.o mcs_cnf10kb.o \
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 92a000770668..6b2f46f32cfd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -335,6 +335,10 @@ M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
 M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
 				nix_rq_cpt_field_mask_cfg_req,  \
 				msg_rsp)	\
+M(NIX_SPI_TO_SA_ADD,    0x8026, nix_spi_to_sa_add, nix_spi_to_sa_add_req,	\
+				nix_spi_to_sa_add_rsp)				\
+M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete, nix_spi_to_sa_delete_req,\
+				msg_rsp)					\
 M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
 				nix_mcast_grp_create_rsp)			\
 M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\
@@ -898,6 +902,29 @@ enum nix_rx_vtag0_type {
 	NIX_AF_LFX_RX_VTAG_TYPE7,
 };
 
+/* For SPI to SA index add */
+struct nix_spi_to_sa_add_req {
+	struct mbox_msghdr hdr;
+	u32 sa_index;
+	u32 spi_index;
+	u16 match_id;
+	bool valid;
+};
+
+struct nix_spi_to_sa_add_rsp {
+	struct mbox_msghdr hdr;
+	u16 hash_index;
+	u8 way;
+	u8 is_duplicate;
+};
+
+/* To free SPI to SA index */
+struct nix_spi_to_sa_delete_req {
+	struct mbox_msghdr hdr;
+	u16 hash_index;
+	u8 way;
+};
+
 /* For NIX LF context alloc and init */
 struct nix_lf_alloc_req {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c496bb72e9f8..ebe583bf2f21 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -90,6 +90,9 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 
 	if (is_rvu_npc_hash_extract_en(rvu))
 		hw->cap.npc_hash_extract = true;
+
+	if (is_rvu_nix_spi_to_sa_en(rvu))
+		hw->cap.spi_to_sas = 0x2000;
 }
 
 /* Poll a RVU block's register 'offset', for a 'zero'
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 10b611433d42..95d3f901f83f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -423,6 +423,7 @@ struct hw_cap {
 	u16	nix_txsch_per_cgx_lmac; /* Max Q's transmitting to CGX LMAC */
 	u16	nix_txsch_per_lbk_lmac; /* Max Q's transmitting to LBK LMAC */
 	u16	nix_txsch_per_sdp_lmac; /* Max Q's transmitting to SDP LMAC */
+	u16     spi_to_sas;		/* Num of SPI to SA index */
 	bool	nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
 	bool	nix_shaping;		 /* Is shaping and coloring supported */
 	bool    nix_shaper_toggle_wait; /* Shaping toggle needs poll/wait */
@@ -861,6 +862,17 @@ static inline bool is_rvu_npc_hash_extract_en(struct rvu *rvu)
 	return true;
 }
 
+static inline bool is_rvu_nix_spi_to_sa_en(struct rvu *rvu)
+{
+	u64 nix_const2;
+
+	nix_const2 = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_CONST2);
+	if ((nix_const2 >> 48) & 0xffff)
+		return true;
+
+	return false;
+}
+
 static inline u16 rvu_nix_chan_cgx(struct rvu *rvu, u8 cgxid,
 				   u8 lmacid, u8 chan)
 {
@@ -1066,6 +1078,7 @@ int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
 			struct nix_hw **nix_hw, int *blkaddr);
 int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
 				 u16 rq_idx, u16 match_id);
+int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc);
 int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
 			struct nix_cn10k_aq_enq_req *aq_req,
 			struct nix_cn10k_aq_enq_rsp *aq_rsp,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 95f93a29a00e..f759b7d33402 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1752,6 +1752,9 @@ int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct nix_lf_free_req *req,
 	else
 		rvu_npc_free_mcam_entries(rvu, pcifunc, nixlf);
 
+	/* Reset SPI to SA index table */
+	rvu_nix_free_spi_to_sa_table(rvu, pcifunc);
+
 	/* Free any tx vtag def entries used by this NIX LF */
 	if (!(req->flags & NIX_LF_DONT_FREE_TX_VTAG))
 		nix_free_tx_vtag_entries(rvu, pcifunc);
@@ -5316,6 +5319,9 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_rx_sync(rvu, blkaddr);
 	nix_txschq_free(rvu, pcifunc);
 
+	/* Reset SPI to SA index table */
+	rvu_nix_free_spi_to_sa_table(rvu, pcifunc);
+
 	clear_bit(NIXLF_INITIALIZED, &pfvf->flags);
 
 	if (is_pf_cgxmapped(rvu, pf) && rvu->rep_mode)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
new file mode 100644
index 000000000000..6f048d44a41e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2025 Marvell.
+ *
+ */
+
+#include "rvu.h"
+
+static bool
+nix_spi_to_sa_index_check_duplicate(struct rvu *rvu,
+				    struct nix_spi_to_sa_add_req *req,
+				    struct nix_spi_to_sa_add_rsp *rsp,
+				    int blkaddr, int16_t index, u8 way,
+				    bool *is_valid, int lfidx)
+{
+	u32 spi_index;
+	u16 match_id;
+	bool valid;
+	u64 wkey;
+	u8 lfid;
+
+	wkey = rvu_read64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way));
+
+	spi_index = FIELD_GET(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, wkey);
+	match_id = FIELD_GET(NIX_AF_SPI_TO_SA_MATCH_ID_MASK, wkey);
+	lfid = FIELD_GET(NIX_AF_SPI_TO_SA_LFID_MASK, wkey);
+	valid = FIELD_GET(NIX_AF_SPI_TO_SA_KEYX_WAYX_VALID, wkey);
+
+	*is_valid = valid;
+	if (!valid)
+		return 0;
+
+	if (req->spi_index == spi_index && req->match_id == match_id &&
+	    lfidx == lfid) {
+		rsp->hash_index = index;
+		rsp->way = way;
+		rsp->is_duplicate = true;
+		return 1;
+	}
+	return 0;
+}
+
+static void  nix_spi_to_sa_index_table_update(struct rvu *rvu,
+					      struct nix_spi_to_sa_add_req *req,
+					      struct nix_spi_to_sa_add_rsp *rsp,
+					      int blkaddr, int16_t index,
+					      u8 way, int lfidx)
+{
+	u64 wvalue;
+	u64 wkey;
+
+	wkey = FIELD_PREP(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, req->spi_index);
+	wkey |= FIELD_PREP(NIX_AF_SPI_TO_SA_MATCH_ID_MASK, req->match_id);
+	wkey |= FIELD_PREP(NIX_AF_SPI_TO_SA_LFID_MASK, lfidx);
+	wkey |= FIELD_PREP(NIX_AF_SPI_TO_SA_KEYX_WAYX_VALID, req->valid);
+
+	rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way),
+		    wkey);
+	wvalue = (req->sa_index & 0xFFFFFFFF);
+	rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_VALUEX_WAYX(index, way),
+		    wvalue);
+	rsp->hash_index = index;
+	rsp->way = way;
+	rsp->is_duplicate = false;
+}
+
+int rvu_mbox_handler_nix_spi_to_sa_delete(struct rvu *rvu,
+					  struct nix_spi_to_sa_delete_req *req,
+					  struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int lfidx, lfid, blkaddr;
+	int ret = 0;
+	u64 wkey;
+
+	if (!hw->cap.spi_to_sas)
+		return NIX_AF_ERR_PARAM;
+
+	if (!is_nixlf_attached(rvu, pcifunc))
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	lfidx = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (lfidx < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	wkey = rvu_read64(rvu, blkaddr,
+			  NIX_AF_SPI_TO_SA_KEYX_WAYX(req->hash_index, req->way));
+	lfid = FIELD_GET(NIX_AF_SPI_TO_SA_LFID_MASK, wkey);
+	if (lfid != lfidx) {
+		ret = NIX_AF_ERR_AF_LF_INVALID;
+		goto unlock;
+	}
+
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_SPI_TO_SA_KEYX_WAYX(req->hash_index, req->way), 0);
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_SPI_TO_SA_VALUEX_WAYX(req->hash_index, req->way), 0);
+unlock:
+	mutex_unlock(&rvu->rsrc_lock);
+	return ret;
+}
+
+int rvu_mbox_handler_nix_spi_to_sa_add(struct rvu *rvu,
+				       struct nix_spi_to_sa_add_req *req,
+				       struct nix_spi_to_sa_add_rsp *rsp)
+{
+	u16 way0_index, way1_index, way2_index, way3_index;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	bool way0, way1, way2, way3;
+	int ret = 0;
+	int blkaddr;
+	int lfidx;
+	u64 value;
+	u64 key;
+
+	if (!hw->cap.spi_to_sas)
+		return NIX_AF_ERR_PARAM;
+
+	if (!is_nixlf_attached(rvu, pcifunc))
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	lfidx = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (lfidx < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	key = FIELD_PREP(NIX_AF_SPI_TO_SA_LFID_MASK, lfidx);
+	key |= FIELD_PREP(NIX_AF_SPI_TO_SA_MATCH_ID_MASK, req->match_id);
+	key |= FIELD_PREP(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, req->spi_index);
+	rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_HASH_KEY, key);
+	value = rvu_read64(rvu, blkaddr, NIX_AF_SPI_TO_SA_HASH_VALUE);
+	way0_index = (value & 0x7ff);
+	way1_index = ((value >> 16) & 0x7ff);
+	way2_index = ((value >> 32) & 0x7ff);
+	way3_index = ((value >> 48) & 0x7ff);
+
+	/* Check for duplicate entry */
+	if (nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
+						way0_index, 0, &way0, lfidx) ||
+	    nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
+						way1_index, 1, &way1, lfidx) ||
+	    nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
+						way2_index, 2, &way2, lfidx) ||
+	    nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
+						way3_index, 3, &way3, lfidx)) {
+		ret = 0;
+		goto unlock;
+	}
+
+	/* If not present, update first available way with index */
+	if (!way0)
+		nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
+						 way0_index, 0, lfidx);
+	else if (!way1)
+		nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
+						 way1_index, 1, lfidx);
+	else if (!way2)
+		nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
+						 way2_index, 2, lfidx);
+	else if (!way3)
+		nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
+						 way3_index, 3, lfidx);
+unlock:
+	mutex_unlock(&rvu->rsrc_lock);
+	return ret;
+}
+
+int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int lfidx, lfid;
+	int index, way;
+	int blkaddr;
+	u64 key;
+
+	if (!hw->cap.spi_to_sas)
+		return 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	lfidx = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (lfidx < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	mutex_lock(&rvu->rsrc_lock);
+	for (index = 0; index < hw->cap.spi_to_sas / 4; index++) {
+		for (way = 0; way < 4; way++) {
+			key = rvu_read64(rvu, blkaddr,
+					 NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way));
+			lfid = FIELD_GET(NIX_AF_SPI_TO_SA_LFID_MASK, key);
+			if (lfid == lfidx) {
+				rvu_write64(rvu, blkaddr,
+					    NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way),
+					    0);
+				rvu_write64(rvu, blkaddr,
+					    NIX_AF_SPI_TO_SA_VALUEX_WAYX(index, way),
+					    0);
+			}
+		}
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index cb5972100058..fcb02846f365 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -396,6 +396,10 @@
 #define NIX_AF_RX_CHANX_CFG(a)                  (0x1A30 | (a) << 15)
 #define NIX_AF_CINT_TIMERX(a)                   (0x1A40 | (a) << 18)
 #define NIX_AF_LSO_FORMATX_FIELDX(a, b)         (0x1B00 | (a) << 16 | (b) << 3)
+#define NIX_AF_SPI_TO_SA_KEYX_WAYX(a, b)        (0x1C00 | (a) << 16 | (b) << 3)
+#define NIX_AF_SPI_TO_SA_VALUEX_WAYX(a, b)      (0x1C40 | (a) << 16 | (b) << 3)
+#define NIX_AF_SPI_TO_SA_HASH_KEY               (0x1C90)
+#define NIX_AF_SPI_TO_SA_HASH_VALUE             (0x1CA0)
 #define NIX_AF_LFX_CFG(a)		(0x4000 | (a) << 17)
 #define NIX_AF_LFX_SQS_CFG(a)		(0x4020 | (a) << 17)
 #define NIX_AF_LFX_TX_CFG2(a)		(0x4028 | (a) << 17)
@@ -463,6 +467,11 @@
 #define NIX_AF_LFX_RX_IPSEC_CFG1_SA_IDX_WIDTH	GENMASK_ULL(36, 32)
 #define NIX_AF_LFX_RX_IPSEC_CFG1_SA_IDX_MAX	GENMASK_ULL(31, 0)
 
+#define NIX_AF_SPI_TO_SA_KEYX_WAYX_VALID	BIT_ULL(55)
+#define NIX_AF_SPI_TO_SA_LFID_MASK		GENMASK_ULL(54, 48)
+#define NIX_AF_SPI_TO_SA_MATCH_ID_MASK		GENMASK_ULL(47, 32)
+#define NIX_AF_SPI_TO_SA_SPI_INDEX_MASK		GENMASK_ULL(31, 0)
+
 #define NIX_AF_LF_CFG_SHIFT		17
 #define NIX_AF_LF_SSO_PF_FUNC_SHIFT	16
 #define NIX_RQ_MSK_PROFILES             4
-- 
2.43.0

