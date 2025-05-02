Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9BDDAB;
	Fri,  2 May 2025 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192182; cv=none; b=tckcxBmn6RuR8YG5wM+xH2DEoqZ7shcM7h4WNfbXS4kevqE7UB6Pv9u9QMW1BqsOlMXgPvwkrOJXy2x1OFRpxhJdUWNWb8zXM9sr5XcYrCG4hKcYydtN8X4vn9e+zhMPtEFSW+nMY+mKElr8Pfd4fT2NYCP8Kx0pAizUMcmPvB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192182; c=relaxed/simple;
	bh=ixbexPzawmWI+k2Bphjud7QiGsBUtkT6OWMbXoXUXdQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyK+Fm6Z4KUbXSxunEhJlYBOd0WfYsRzqoZEHJ3lX0mMfcYcKCcQpvXKqrGOeMV2mwNOW3HYyeHY8WHkTpFilYY5jOFLSnTSginSiCxUOtobQyvOj2zlfJuVzTB+EEUH7hzGGEygwFxafMsxl6B2UqaPtemaLw0Ma9YSfHbAygM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=j71J4/4c; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="j71J4/4c"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542A3i0I023658;
	Fri, 2 May 2025 06:22:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	+d2czD0ySAsGlHkPxTG+SXCqec5/G5n9A4rGAhrJmw=; b=j71J4/4c6o+RiL8mX
	ae9aUxby+6A6mqBaVJT/31POWETvXG/ELdhFR0L1mOjO/LLxTszr4UBS6UpiBA/1
	SoazoPo5mt4IkPCyV3wgjNN46mr43KxKvAF3iuhrwar/dJFmL17TFwEiR5+S7ElS
	7nkp+bwgCVEfLKzgJtx5PBeMD9xx8cXhFLp4IwQoxdVyooB2PT0+Os45wwN05x9U
	ED1nmGkIgJZwNKTwgry9a2FnbHGQd/uovywmzv/jCZ3p7BogqUOoTosE01L41SgO
	6s0dmbP40IW3GbuRUM7hF8JZx5qlTVy6WbtCDzA4V4mgpS/6nvJTNirlPUl1B3sS
	7cKHA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cutur9eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:22:44 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:22:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:22:43 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 420463F7044;
	Fri,  2 May 2025 06:22:30 -0700 (PDT)
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
        <gcherian@marvell.com>, Kiran Kumar K <kirankumark@marvell.com>,
        "Nithin
 Dabilpuram" <ndabilpuram@marvell.com>,
        Tanmay Jagdale <tanmay@marvell.com>
Subject: [net-next PATCH v1 07/15] octeontx2-af: Add support for SPI to SA index translation
Date: Fri, 2 May 2025 18:49:48 +0530
Message-ID: <20250502132005.611698-8-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: 9KE7_H05N5gym2oe83jeOcHRVqIB8RpE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX5avotjnUuYA9 0ttUOCtbISPlq4hVjjlkQX39XVScp9I2Hk7jYoqRmVmLUkiqgSGhKTZF7v6BD1RHQoJB9Z7s7LQ MGMjzhzL2CInPWjvIvpNZdV7WJxD1P+L+1Uo8T0P4zT6jlWDfifcG9lRICl1LaTg/z59CbkhdIj
 c30dIxF8t6A7dY8QXZOCIV2ur3W+yjMBjAzjsWgJUQBmpnAJhFJLFVhco5mZAwLO8otctmVsHzX 9fC+ukyEZp8GxGTTgfh3bzL90je59gn7LjQe/MkzNSNfB5LThBLWf/xwN+F4szOn6QDnpzwy5lZ x6oIgynV6g75GlbiVv4LL4NmYoPGPl2JgkwELPbsE/+wf2T4LH3L/0l6hwXGMeeHrNWb5FqyqFi
 ziwl/47EuyWUC8qNO9VbwOX5TRRB37tCiABfnxZcVgd++zR7viAUh8EYgdKLnsEBFIxitW10
X-Authority-Analysis: v=2.4 cv=BaPY0qt2 c=1 sm=1 tr=0 ts=6814c724 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=KpuqD5-phFCYfedluycA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 9KE7_H05N5gym2oe83jeOcHRVqIB8RpE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

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
 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  27 +++
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  13 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   6 +
 .../marvell/octeontx2/af/rvu_nix_spi.c        | 220 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   4 +
 7 files changed, 275 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index ccea37847df8..49318017f35f 100644
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
index 715efcc04c9e..5cebf10a15a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -326,6 +326,10 @@ M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
 M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
 				nix_rq_cpt_field_mask_cfg_req,  \
 				msg_rsp)	\
+M(NIX_SPI_TO_SA_ADD,    0x8026, nix_spi_to_sa_add, nix_spi_to_sa_add_req,   \
+				nix_spi_to_sa_add_rsp)                      \
+M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete, nix_spi_to_sa_delete_req,   \
+				msg_rsp)                                        \
 M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
 				nix_mcast_grp_create_rsp)			\
 M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\
@@ -880,6 +884,29 @@ enum nix_rx_vtag0_type {
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
index ea346e59835b..2b7c09bb24e1 100644
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
@@ -2723,6 +2726,7 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
 	rvu_reset_lmt_map_tbl(rvu, pcifunc);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
+
 	/* In scenarios where PF/VF drivers detach NIXLF without freeing MCAM
 	 * entries, check and free the MCAM entries explicitly to avoid leak.
 	 * Since LF is detached use LF number as -1.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 71407f6318ec..42fc3e762bc0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -395,6 +395,7 @@ struct hw_cap {
 	u16	nix_txsch_per_cgx_lmac; /* Max Q's transmitting to CGX LMAC */
 	u16	nix_txsch_per_lbk_lmac; /* Max Q's transmitting to LBK LMAC */
 	u16	nix_txsch_per_sdp_lmac; /* Max Q's transmitting to SDP LMAC */
+	u16     spi_to_sas; /* Num of SPI to SA index */
 	bool	nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
 	bool	nix_shaping;		 /* Is shaping and coloring supported */
 	bool    nix_shaper_toggle_wait; /* Shaping toggle needs poll/wait */
@@ -800,6 +801,17 @@ static inline bool is_rvu_npc_hash_extract_en(struct rvu *rvu)
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
@@ -992,6 +1004,7 @@ int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
 			struct nix_hw **nix_hw, int *blkaddr);
 int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
 				 u16 rq_idx, u16 match_id);
+int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc);
 int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
 			struct nix_cn10k_aq_enq_req *aq_req,
 			struct nix_cn10k_aq_enq_rsp *aq_rsp,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index b15fd331facf..68525bfc8e6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1751,6 +1751,9 @@ int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct nix_lf_free_req *req,
 	else
 		rvu_npc_free_mcam_entries(rvu, pcifunc, nixlf);
 
+	/* Reset SPI to SA index table */
+	rvu_nix_free_spi_to_sa_table(rvu, pcifunc);
+
 	/* Free any tx vtag def entries used by this NIX LF */
 	if (!(req->flags & NIX_LF_DONT_FREE_TX_VTAG))
 		nix_free_tx_vtag_entries(rvu, pcifunc);
@@ -5312,6 +5315,9 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_rx_sync(rvu, blkaddr);
 	nix_txschq_free(rvu, pcifunc);
 
+	/* Reset SPI to SA index table */
+	rvu_nix_free_spi_to_sa_table(rvu, pcifunc);
+
 	clear_bit(NIXLF_INITIALIZED, &pfvf->flags);
 
 	if (is_pf_cgxmapped(rvu, pf) && rvu->rep_mode)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
new file mode 100644
index 000000000000..b8acc23a47bc
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2022 Marvell.
+ *
+ */
+
+#include "rvu.h"
+
+static bool nix_spi_to_sa_index_check_duplicate(struct rvu *rvu,
+						struct nix_spi_to_sa_add_req *req,
+						struct nix_spi_to_sa_add_rsp *rsp,
+						int blkaddr, int16_t index, u8 way,
+						bool *is_valid, int lfidx)
+{
+	u32 spi_index;
+	u16 match_id;
+	bool valid;
+	u8 lfid;
+	u64 wkey;
+
+	wkey = rvu_read64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way));
+	spi_index = (wkey & 0xFFFFFFFF);
+	match_id = ((wkey >> 32) & 0xFFFF);
+	lfid = ((wkey >> 48) & 0x7f);
+	valid = ((wkey >> 55) & 0x1);
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
+					      int blkaddr, int16_t index, u8 way,
+					      int lfidx)
+{
+	u64 wvalue;
+	u64 wkey;
+
+	wkey = (req->spi_index | ((u64)req->match_id << 32) |
+		(((u64)lfidx) << 48) | ((u64)req->valid << 55));
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
+	int lfidx, lfid;
+	int blkaddr;
+	u64 wvalue;
+	u64 wkey;
+	int ret = 0;
+
+	if (!hw->cap.spi_to_sas)
+		return NIX_AF_ERR_PARAM;
+
+	if (!is_nixlf_attached(rvu, pcifunc)) {
+		ret = NIX_AF_ERR_AF_LF_INVALID;
+		goto exit;
+	}
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	lfidx = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (lfidx < 0) {
+		ret = NIX_AF_ERR_AF_LF_INVALID;
+		goto exit;
+	}
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	wkey = rvu_read64(rvu, blkaddr,
+			  NIX_AF_SPI_TO_SA_KEYX_WAYX(req->hash_index, req->way));
+	lfid = ((wkey >> 48) & 0x7f);
+	if (lfid != lfidx) {
+		ret = NIX_AF_ERR_AF_LF_INVALID;
+		goto unlock;
+	}
+
+	wkey = 0;
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_SPI_TO_SA_KEYX_WAYX(req->hash_index, req->way), wkey);
+	wvalue = 0;
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_SPI_TO_SA_VALUEX_WAYX(req->hash_index, req->way), wvalue);
+unlock:
+	mutex_unlock(&rvu->rsrc_lock);
+exit:
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
+	if (!is_nixlf_attached(rvu, pcifunc)) {
+		ret = NIX_AF_ERR_AF_LF_INVALID;
+		goto exit;
+	}
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	lfidx = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (lfidx < 0) {
+		ret = NIX_AF_ERR_AF_LF_INVALID;
+		goto exit;
+	}
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	key = (((u64)lfidx << 48) | ((u64)req->match_id << 32) | req->spi_index);
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
+exit:
+	return ret;
+}
+
+int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int lfidx, lfid;
+	int index, way;
+	u64 value, key;
+	int blkaddr;
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
+			lfid = ((key >> 48) & 0x7f);
+			if (lfid == lfidx) {
+				key = 0;
+				rvu_write64(rvu, blkaddr,
+					    NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way),
+					    key);
+				value = 0;
+				rvu_write64(rvu, blkaddr,
+					    NIX_AF_SPI_TO_SA_VALUEX_WAYX(index, way),
+					    value);
+			}
+		}
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index e5e005d5d71e..b64547fe4811 100644
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
-- 
2.43.0

