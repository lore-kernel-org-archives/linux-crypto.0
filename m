Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CB422F75E;
	Sun, 26 Oct 2025 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491422; cv=none; b=chJk2kuQmAm1tca8NToSh2z/2jMjwHzWUX8/GRJijRP9w0MP0yA9cwORqJkF6CFILfTvz+lHFnT0td42mmAwlyKSsnAUcRKCAyR14erBcBPqFIjOTEPS8vTk/3gKPOJepNzm++7gQ+UPWidB72EXUukHbr8vaRarTWdC9eQLGKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491422; c=relaxed/simple;
	bh=F5e5h+V6b1C36g0iRxWDIcpnb8ljR9cFNY+dcZ0hPCY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+YXReK2F/vjlGsdiu+9WLMCudH0WY6F2uKAWeHXpJgF/hyo2iLh4kxv1TCzG9T0VtFCb4qB6H3D9eczvoyzTY0ONr8AQR0YwU50AotWFNnnjHW5Wq3Jms8EsTO6VEaCl3xwI3pRsb4roo+GEZs1Rg0UJ74cYcxO71xdm0Uaivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Kei3TeyZ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Kei3TeyZ"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QF0Aie3923600;
	Sun, 26 Oct 2025 08:10:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	+ynF9+C2ClXfQMFeJWN7KvGKMf/+CkJtHZG2/XTZnw=; b=Kei3TeyZal+FCR/3j
	j+d6/C5zlTI8qtEFqy+uiFwl3sBXC6vBj/n8waP9RHhpkzQAVDSknR9TonUOxwe1
	yR2rRgt8GYf2dS2RFyh92ViRQV67f8NNOfonl677tJ0jEb22zBod0b/ft6OoW7iP
	itXlgxLrnkAeel+4z7clRwIZm6bsB5mNIf3O2hgKoj1v7iuzkTOBCyi9ok8bBVpZ
	GL+ZP3Qx4jkDXz+Cfe9EHqV//gfTY36BGc/1OWIrOtca8MSoeCici8VzQuvWAI8e
	INBCIFr+KD7dLgX6qcKoFM90j37JoWsXedvxncVlgc2MJNbd0R1LIaBMi+0hOJxR
	2fSrg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a0x2g1pkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:14 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:23 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 17AB63F70E0;
	Sun, 26 Oct 2025 08:10:09 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Rakesh
 Kudurumalla" <rkudurumalla@marvell.com>,
        Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH net-next v5 05/15] octeontx2-af: Add support for CPT second pass
Date: Sun, 26 Oct 2025 20:39:00 +0530
Message-ID: <20251026150916.352061-6-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfXwT90agzKVCwP
 +dYgHZa/EUl7OaYWZ0m0rDQ0NufoPS2OBCxrcp+SzPOCKPPhRyGLuPodJRKwoxZPjqxko9P+Ebx
 rUYoMvkDplpzVtO0d6ewpZOSvh2EpiJLGvgsedzHFiLW4U3RsBLmfnDmDoB/9LxL0AbDw8Y3BTE
 CebXEq72i2keo+FqrDFghYimcJhsMvkVjZOrk/rmjw6RV8KIP1Cf5ilr2cJWxdnPpmJrgaeuX6Q
 96+/CKU45Uf6mN0yuC8ZpnsWB0WbY4gGzYoDVXEjNPA2wzCD1e2f9Cn4ALbZhPl3RAi6Fled+9C
 Os72F/Xu/5p8tfgLIWWDliuMwrIevgn/NsmlQuP54vGz6AzisLrTLtMjUsTIbCS2/gr+pK79E99
 uD+ULmZExkrzObi5XGu9yCZHs0dlVQ==
X-Proofpoint-ORIG-GUID: ruC2-XPSuN6EgxTlDCGWkuHiCqWRmBRJ
X-Authority-Analysis: v=2.4 cv=I4Bohdgg c=1 sm=1 tr=0 ts=68fe39d6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=na5Vt5bUGMnm0HcGXXkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: ruC2-XPSuN6EgxTlDCGWkuHiCqWRmBRJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

From: Rakesh Kudurumalla <rkudurumalla@marvell.com>

Implemented mailbox to add mechanism to allocate a
rq_mask and apply to nixlf to toggle RQ context fields
for CPT second pass packets.

Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- None

Changes in V4:
- None

Changes in V3:
- Fixed uninitialized rq_mask variable

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-6-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-6-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-6-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-6-tanmay@marvell.com/

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
index e5e1a9c18258..10b611433d42 100644
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
index c3d6f363bf61..95f93a29a00e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -6632,3 +6632,128 @@ void rvu_block_bcast_xon(struct rvu *rvu, int blkaddr)
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0));
 	rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0), cfg);
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

