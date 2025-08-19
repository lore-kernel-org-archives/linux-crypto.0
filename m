Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5F6157A5A;
	Tue, 19 Aug 2025 02:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569737; cv=none; b=RmoojiRMMbJe0TL30BEaHQFY4lNkzS4f6N50k7hP9V8WQdv04c7KiTV5AqjldzdmMDy8orpfJygZk9b6kVEkG9blrP89HcPgVrThpZTM2G6k2mc69CUe4Bmeo01auo+v7ICYxEt05MPjdZhCgFbhbqFDwN60CfVefZDjRf1JoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569737; c=relaxed/simple;
	bh=7u9akta8g8yPcNpE/ozVfGl2YJGdSpiKmDPeGp4fc4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OlmUF2/l/LDvo1LZD2ASUF4sJKUf36z/hdrjhpJqvpcHL3ZWj56vowkZho3szPXtpZKPfs172B0teSPV0rMCJyjsjCXmn5il0wzBc8KW8m5SSEqqkJx3PiJk9CnyZnQqw8pdx/j9T6inZGs9WkJkPk5RGp/yUSdd0HPoRjcSkiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=j4+VL4Tn; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="j4+VL4Tn"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IMm53c001168;
	Mon, 18 Aug 2025 19:15:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=g
	+plsckEPGaplOzwlRf5U32Zd2uyRTGB7sPiipwdSow=; b=j4+VL4TnlNhe8rsZa
	ebGuivcaSJIc61FD5jpzCfggdhMjRsLdJfo30V/+DDy8GqthSJgCDe+KpSJdXPx1
	Nn3ggUSjKByOtFx0lXALx2x4sW8/rwVyj+gGyiC9V3SEwU9WupW0mbOLnYvaqJUj
	98XcoGpfR5QJ4imJlfLjGuF0QOicW6Mr24BkXEYXEsACALPxskqGHFOQHUpg3DVI
	36caBvvz7xlQjGWbozvw1155GALZrAUx7uhGBorDStBY3F0WMEnJFFuVRxsMeTwd
	YALh8PSNBl6myMz3RtczIfJVbafk1rEo+FyMA/krJCEitj75oNbfPR9IwwPxFZy9
	E6xPQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 48md9ggcd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:31 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:15:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:15:35 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id E55983F709F;
	Mon, 18 Aug 2025 19:15:27 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Rakesh
 Kudurumalla" <rkudurumalla@marvell.com>,
        Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH net-next v4 05/14] octeontx2-af: Add support for CPT second pass
Date: Tue, 19 Aug 2025 07:44:56 +0530
Message-ID: <20250819021507.323752-6-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=PN8P+eqC c=1 sm=1 tr=0 ts=68a3de43 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=8JFNMAf0qV5VGRTVGfUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfX1T6Um4Ztc6li tRQP7HJv83w9uYMmczHF5ocrUNLnXDGIMEK3d693zh2j/T35q2hh+knWyTBiEfodsVtQGTyrfDt VjWIajS6FEW8QHwyXUovFAmY40lPQ7pm0GJJVNqwhH523tpk7ITgwZ6qqZPVum7ZF9ToeEI6Iy/
 7kua7/X7h05tN2ph/yDVXxw/ghSVYGIeerk0dfXzZUqLkXQi6MitheejPUOF0cCbaGPt2YckFTI gc0mM1Hg6kQ3w7IckVhTxKNgYqw3B4a3N9tjCZDS9ejqtJo2TKmIrPfq5lLJf0W8HCmQ2std8aS FXm2XAH+zTPyp/iLZcfKNYpJpwhlFIeB9GPpi4B2nqxGobK0AW/vOPYlyirjo5jmH1eB4iJUCqX
 rgjzv4++LcIBW9poQ2WD9bW9Fx89LFoyOUZuxhC5O6OIcWAXWmZprBKZHlOk3nqs0uJ11wPg
X-Proofpoint-GUID: JAC5kS2yQfv1YSKPDrxBHpJZQvI33ByD
X-Proofpoint-ORIG-GUID: JAC5kS2yQfv1YSKPDrxBHpJZQvI33ByD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

From: Rakesh Kudurumalla <rkudurumalla@marvell.com>

Implemented mailbox to add mechanism to allocate a
rq_mask and apply to nixlf to toggle RQ context fields
for CPT second pass packets.

Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V4:
- None

Changes in V3:
- Fixed uninitialized rq_mask variable

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-6-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-6-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-6-tanmay@marvell.com/

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  23 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   7 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |  11 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 125 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  15 +++
 .../marvell/octeontx2/af/rvu_struct.h         |   4 +-
 6 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6e8e36548344..92a000770668 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -332,6 +332,9 @@ M(NIX_CPT_BP_DISABLE,   0x8021, nix_cpt_bp_disable, nix_bp_cfg_req,	    \
 				msg_rsp)				\
 M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
 				msg_req, nix_inline_ipsec_cfg)		\
+M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
+				nix_rq_cpt_field_mask_cfg_req,  \
+				msg_rsp)	\
 M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
 				nix_mcast_grp_create_rsp)			\
 M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\
@@ -875,6 +878,7 @@ enum nix_af_status {
 	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
 	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
 	NIX_AF_ERR_LINK_CREDITS  = -431,
+	NIX_AF_ERR_RQ_CPT_MASK  = -432,
 	NIX_AF_ERR_INVALID_BPID         = -434,
 	NIX_AF_ERR_INVALID_BPID_REQ     = -435,
 	NIX_AF_ERR_INVALID_MCAST_GRP	= -436,
@@ -1196,6 +1200,25 @@ struct nix_mark_format_cfg_rsp {
 	u8 mark_format_idx;
 };
 
+struct nix_rq_cpt_field_mask_cfg_req {
+	struct mbox_msghdr hdr;
+#define RQ_CTX_MASK_MAX 6
+	union {
+		u64 rq_ctx_word_set[RQ_CTX_MASK_MAX];
+		struct nix_cn10k_rq_ctx_s rq_set;
+	};
+	union {
+		u64 rq_ctx_word_mask[RQ_CTX_MASK_MAX];
+		struct nix_cn10k_rq_ctx_s rq_mask;
+	};
+	struct nix_lf_rx_ipec_cfg1_req {
+		u32 spb_cpt_aura;
+		u8 rq_mask_enable;
+		u8 spb_cpt_sizem1;
+		u8 spb_cpt_enable;
+	} ipsec_cfg1;
+};
+
 struct nix_rx_mode {
 	struct mbox_msghdr hdr;
 #define NIX_RX_MODE_UCAST	BIT(0)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 1054a4ee19e0..39385c4fbb4b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -378,6 +378,11 @@ struct nix_lso {
 	u8 in_use;
 };
 
+struct nix_rq_cpt_mask {
+	u8 total;
+	u8 in_use;
+};
+
 struct nix_txvlan {
 #define NIX_TX_VTAG_DEF_MAX 0x400
 	struct rsrc_bmap rsrc;
@@ -401,6 +406,7 @@ struct nix_hw {
 	struct nix_flowkey flowkey;
 	struct nix_mark_format mark_format;
 	struct nix_lso lso;
+	struct nix_rq_cpt_mask rq_msk;
 	struct nix_txvlan txvlan;
 	struct nix_ipolicer *ipolicer;
 	struct nix_bp bp;
@@ -426,6 +432,7 @@ struct hw_cap {
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
+	bool	second_cpt_pass;
 	bool	nix_multiple_dwrr_mtu;   /* Multiple DWRR_MTU to choose from */
 	bool	npc_hash_extract; /* Hash extract enabled ? */
 	bool	npc_exact_match_enabled; /* Exact match supported ? */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index d2163da28d18..0276622e276e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -558,6 +558,7 @@ void rvu_program_channels(struct rvu *rvu)
 
 void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
 {
+	struct rvu_hwinfo *hw = rvu->hw;
 	int blkaddr = nix_hw->blkaddr;
 	u64 cfg;
 
@@ -572,6 +573,16 @@ void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CFG);
 	cfg |= BIT_ULL(1) | BIT_ULL(2);
 	rvu_write64(rvu, blkaddr, NIX_AF_CFG, cfg);
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+
+	if (!(cfg & BIT_ULL(62))) {
+		hw->cap.second_cpt_pass = false;
+		return;
+	}
+
+	hw->cap.second_cpt_pass = true;
+	nix_hw->rq_msk.total = NIX_RQ_MSK_PROFILES;
 }
 
 void rvu_apr_block_cn10k_init(struct rvu *rvu)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 91af1ada11c2..17a4e885503d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -6616,3 +6616,128 @@ int rvu_mbox_handler_nix_mcast_grp_update(struct rvu *rvu,
 
 	return ret;
 }
+
+static inline void
+configure_rq_mask(struct rvu *rvu, int blkaddr, int nixlf,
+		  u8 rq_mask, bool enable)
+{
+	u64 cfg, reg;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
+	reg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf));
+	if (enable) {
+		cfg |= NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA;
+		reg &= ~NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL;
+		reg |= FIELD_PREP(NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL, rq_mask);
+	} else {
+		cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA;
+		reg &= ~NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL;
+	}
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf), reg);
+}
+
+static inline void
+configure_spb_cpt(struct rvu *rvu, int blkaddr, int nixlf,
+		  struct nix_rq_cpt_field_mask_cfg_req *req, bool enable)
+{
+	u64 cfg;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
+
+	/* Clear the SPB bit fields */
+	cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA;
+	cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1;
+	cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA;
+
+	if (enable) {
+		cfg |= NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA;
+		cfg |= FIELD_PREP(NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1,
+				  req->ipsec_cfg1.spb_cpt_sizem1);
+		cfg |= FIELD_PREP(NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA,
+				  req->ipsec_cfg1.spb_cpt_aura);
+	}
+
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
+}
+
+static
+int nix_inline_rq_mask_alloc(struct rvu *rvu,
+			     struct nix_rq_cpt_field_mask_cfg_req *req,
+			     struct nix_hw *nix_hw, int blkaddr)
+{
+	u8 rq_cpt_mask_select;
+	int idx, rq_idx;
+	u64 reg_mask;
+	u64 reg_set;
+
+	for (idx = 0; idx < nix_hw->rq_msk.in_use; idx++) {
+		for (rq_idx = 0; rq_idx < RQ_CTX_MASK_MAX; rq_idx++) {
+			reg_mask = rvu_read64(rvu, blkaddr,
+					      NIX_AF_RX_RQX_MASKX(idx, rq_idx));
+			reg_set  = rvu_read64(rvu, blkaddr,
+					      NIX_AF_RX_RQX_SETX(idx, rq_idx));
+			if (reg_mask != req->rq_ctx_word_mask[rq_idx] &&
+			    reg_set != req->rq_ctx_word_set[rq_idx])
+				break;
+		}
+		if (rq_idx == RQ_CTX_MASK_MAX)
+			break;
+	}
+
+	if (idx < nix_hw->rq_msk.in_use) {
+		/* Match found */
+		rq_cpt_mask_select = idx;
+		return idx;
+	}
+
+	if (nix_hw->rq_msk.in_use == nix_hw->rq_msk.total)
+		return NIX_AF_ERR_RQ_CPT_MASK;
+
+	rq_cpt_mask_select = nix_hw->rq_msk.in_use++;
+
+	for (rq_idx = 0; rq_idx < RQ_CTX_MASK_MAX; rq_idx++) {
+		rvu_write64(rvu, blkaddr,
+			    NIX_AF_RX_RQX_MASKX(rq_cpt_mask_select, rq_idx),
+			    req->rq_ctx_word_mask[rq_idx]);
+		rvu_write64(rvu, blkaddr,
+			    NIX_AF_RX_RQX_SETX(rq_cpt_mask_select, rq_idx),
+			    req->rq_ctx_word_set[rq_idx]);
+	}
+
+	return rq_cpt_mask_select;
+}
+
+int
+rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
+				      struct nix_rq_cpt_field_mask_cfg_req *req,
+				      struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct nix_hw *nix_hw;
+	int rq_mask = 0, err;
+	int blkaddr, nixlf;
+
+	err = nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
+
+	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+
+	if (!hw->cap.second_cpt_pass)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+
+	if (req->ipsec_cfg1.rq_mask_enable) {
+		rq_mask = nix_inline_rq_mask_alloc(rvu, req, nix_hw, blkaddr);
+		if (rq_mask < 0)
+			return NIX_AF_ERR_RQ_CPT_MASK;
+	}
+
+	configure_rq_mask(rvu, blkaddr, nixlf, rq_mask,
+			  req->ipsec_cfg1.rq_mask_enable);
+	configure_spb_cpt(rvu, blkaddr, nixlf, req,
+			  req->ipsec_cfg1.spb_cpt_enable);
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index b24d9e7c8df4..cb5972100058 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -433,6 +433,8 @@
 #define NIX_AF_MDQX_IN_MD_COUNT(a)	(0x14e0 | (a) << 16)
 #define NIX_AF_SMQX_STATUS(a)		(0x730 | (a) << 16)
 #define NIX_AF_MDQX_OUT_MD_COUNT(a)	(0xdb0 | (a) << 16)
+#define NIX_AF_RX_RQX_MASKX(a, b)       (0x4A40 | (a) << 16 | (b) << 3)
+#define NIX_AF_RX_RQX_SETX(a, b)        (0x4A80 | (a) << 16 | (b) << 3)
 
 #define NIX_PRIV_AF_INT_CFG		(0x8000000)
 #define NIX_PRIV_LFX_CFG		(0x8000010)
@@ -452,6 +454,19 @@
 #define NIX_AF_TL3_PARENT_MASK         GENMASK_ULL(23, 16)
 #define NIX_AF_TL2_PARENT_MASK         GENMASK_ULL(20, 16)
 
+#define NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL	GENMASK_ULL(36, 35)
+
+#define NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA	GENMASK_ULL(63, 44)
+#define NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA	BIT_ULL(43)
+#define NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1	GENMASK_ULL(42, 38)
+#define NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA	BIT_ULL(37)
+#define NIX_AF_LFX_RX_IPSEC_CFG1_SA_IDX_WIDTH	GENMASK_ULL(36, 32)
+#define NIX_AF_LFX_RX_IPSEC_CFG1_SA_IDX_MAX	GENMASK_ULL(31, 0)
+
+#define NIX_AF_LF_CFG_SHIFT		17
+#define NIX_AF_LF_SSO_PF_FUNC_SHIFT	16
+#define NIX_RQ_MSK_PROFILES             4
+
 /* SSO */
 #define SSO_AF_CONST			(0x1000)
 #define SSO_AF_CONST1			(0x1008)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 0596a3ac4c12..a1bcb51d049c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -379,7 +379,9 @@ struct nix_cn10k_rq_ctx_s {
 	u64 ipsech_ena		: 1;
 	u64 ena_wqwd		: 1;
 	u64 cq			: 20;
-	u64 rsvd_36_24		: 13;
+	u64 rsvd_34_24          : 11;
+	u64 port_ol4_dis        : 1;
+	u64 port_il4_dis        : 1;
 	u64 lenerr_dis		: 1;
 	u64 csum_il4_dis	: 1;
 	u64 csum_ol4_dis	: 1;
-- 
2.43.0

