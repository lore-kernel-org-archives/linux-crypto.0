Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327C32E54B1;
	Wed, 18 Jun 2025 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246276; cv=none; b=ildDxuPDDXlyYCuDfMxsREdHLEM2p2UGkAUMMZ6tXDLFhk+4HtneFKCnOtkQCdMrBSxhdTQQZQFlsaxVtLd7xCR8/gFdF73rC2KQzC2NuYVluqLx1QxWUu/hSrQ9kc8jX5KiX5y+MRxQ6quoJvb/fTKeSKO1ELO0oH4lrAUlW4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246276; c=relaxed/simple;
	bh=7y/M4jArsIParKO/xwXGgOrojYaUWvOx2zwrPb53ywE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZkQoqYyUbmWP6fCZuzRBjchbeCRRiGZ5+BPNVZs0EF/O+u4tbuKO8mpPZMwDVm961v9dEv1s97xj9BS8UVTErd7WUXzkxQQkyIzrfct0LyYd+IYJqO/8hbgmAA7nHy/1G1YvDCrtd+YMb2/rYvyUPmgErIfDjbgSo6Cso7gUYTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=aGPp0Z6H; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aGPp0Z6H"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HNSRIv016134;
	Wed, 18 Jun 2025 04:31:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=X
	TIkcaS/7UVsvs+a/Z/AW1qhYF+7KBKv31yA4vxCVO8=; b=aGPp0Z6HxXAcpZC5B
	GVn1A5F6Sn7JjN86R+gRBQk6tVi2mCkBXDky3zB0g60KoH3t08zHi2x1YmU0JMgY
	ymPf6lOTidUSihMV5oJHHbzrfpXJ9Oaq+OM7VW0J4wZNvYtVlKSoNQHvOVfkmwHO
	XxIxdlMClfupY0dDdueA+c03nboobDPBaayk4fl9Ee0FP4N8KgrPjAiSFSxAE52u
	4LE904ZGCaYYb4jt6ZZJ2W4Az7YhPwEGiaVPJTIFULda6lRhVRiJJxLC2UsWFfiz
	cvayXQ+H6BDAs6yHLfy64s9VoH7ZBR0LXDjFDnySFtYXWAeSQa4RlcdaEt3XrlPi
	3DHxw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bj2kh92m-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:08 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:04 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 7430B3F7048;
	Wed, 18 Jun 2025 04:31:00 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kiran Kumar K
	<kirankumark@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH net-next v2 06/14] octeontx2-af: Add support for SPI to SA index translation
Date: Wed, 18 Jun 2025 17:00:00 +0530
Message-ID: <20250618113020.130888-7-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=Q9jS452a c=1 sm=1 tr=0 ts=6852a37c cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=Hje_HFLC617AwcLRykUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5OCBTYWx0ZWRfX4ziXoqoE1c/2 JViz08n8Lw9wkuswZkf3+wnC5BVmQ4FdOLVXli+oYjdtHgo8yoL4px2laPDIl8g6zCM0vw9kBuO yrJRAPKXp4r/Yfr275W2aXscUUL7FxXNo4ranA8iqheL6dnQUDJOHm+irb6l4+YPQZbGXOKMvok
 yt1Y7WE/EUL6khfId6XHRqkZRjehMNgkuMjXMTqNp6m7tlcrT7F//lsv+JmMMcBXa1y7E9GtmAo UbAyZLObjv8xv20aW6T4fJ0yzYbDwEbkuXZaK/yAGtACVG+d0TNzv+UKupS3nZCvP4K4FlC+exh F3ErGOJcLomRHPa6NWRXL51r3xzcYJn2mSAgrB9aOKKh5t4c5OgeXvHXI1Sylcd6CF8uFPq/Ej1
 oeuqCl6m/ciYbJhFEYoxKMjC5DFkuQjNZqpxY1D43n1GGkb0Cnb2L0UW8AOt7B7posLPrur1
X-Proofpoint-GUID: OuxcSZ4bkfR1QBg7WjAGOR0_FIKp9mzU
X-Proofpoint-ORIG-GUID: OuxcSZ4bkfR1QBg7WjAGOR0_FIKp9mzU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

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
Changes in V2:
- RCT order definition
- Fixed 80 character limit line warning
- Used GENMASK and FIELD_PREP macros
- Removed unused gotos

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-8-tanmay@marvell.com/

 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  27 +++
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  13 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   6 +
 .../marvell/octeontx2/af/rvu_nix_spi.c        | 211 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   9 +
 7 files changed, 271 insertions(+), 1 deletion(-)
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
index 5be73248fdf8..d1f6c68b0acb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -334,6 +334,10 @@ M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
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
@@ -890,6 +894,29 @@ enum nix_rx_vtag0_type {
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
index 6b9958a87a45..5f16a360c8e8 100644
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
@@ -2781,6 +2784,7 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
 	rvu_reset_lmt_map_tbl(rvu, pcifunc);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
+
 	/* In scenarios where PF/VF drivers detach NIXLF without freeing MCAM
 	 * entries, check and free the MCAM entries explicitly to avoid leak.
 	 * Since LF is detached use LF number as -1.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 39385c4fbb4b..d943f0a9e92d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -423,6 +423,7 @@ struct hw_cap {
 	u16	nix_txsch_per_cgx_lmac; /* Max Q's transmitting to CGX LMAC */
 	u16	nix_txsch_per_lbk_lmac; /* Max Q's transmitting to LBK LMAC */
 	u16	nix_txsch_per_sdp_lmac; /* Max Q's transmitting to SDP LMAC */
+	u16     spi_to_sas; /* Num of SPI to SA index */
 	bool	nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
 	bool	nix_shaping;		 /* Is shaping and coloring supported */
 	bool    nix_shaper_toggle_wait; /* Shaping toggle needs poll/wait */
@@ -847,6 +848,17 @@ static inline bool is_rvu_npc_hash_extract_en(struct rvu *rvu)
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
@@ -1052,6 +1064,7 @@ int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
 			struct nix_hw **nix_hw, int *blkaddr);
 int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
 				 u16 rq_idx, u16 match_id);
+int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc);
 int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
 			struct nix_cn10k_aq_enq_req *aq_req,
 			struct nix_cn10k_aq_enq_rsp *aq_rsp,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 9cbb3fab83a1..6fe39c77a14f 100644
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

