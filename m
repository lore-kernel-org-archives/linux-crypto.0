Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12635DDAB;
	Fri,  2 May 2025 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192170; cv=none; b=e5c6lrOuULY6PKlgdEDTomPhVtYqxnU1V5SbX+f+g9TIPo7A1FYSd8u+Dvw8uhCy0GsYI+l2TOsoyNiouwaNbWinu+Lcc+q2pkd8b+PXfJIIshpXVov4/moc9q6DMjURdJ56arxMn+s6hIpA6NvmCCKuDcApDUNJ/l/cLGeXGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192170; c=relaxed/simple;
	bh=r7nY0des2DiT9LAu4L8lzCK8tf3ocbHTXlnqA7fHY1c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jeop/a/n6OiPiUx+muiA4URua2OhJkSmsWy+OHHq9m1KQ7Fqgx9R2zif1JdzhtK4GDkqG20eKs2LZPgrUWmKtzaDp6sKymuNWQVVo5GDkMNft7T49b/rQYNYowUSVClNHJ0ppGYfp82/fUlRmv59Oj1G0C5YFHsWMjxbUelqN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UZLSbzr/; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UZLSbzr/"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5429s2EW004717;
	Fri, 2 May 2025 06:22:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	bXLvi8vvbZCaaeEdRCnLA1BlYf4kYdjP1KzgYrhD1g=; b=UZLSbzr/yXc7O0/Vi
	TaItxu72+4XNNPBG9mBdtcUe81k5yCAufiSzU5C6sQY9dGhkVaGM6yFv/ZNH5SJR
	oe1cX1i9Y8OgzjA5g/313xDwdlxW4jHY8gjNUxRETuYRPTupOHpAdMtsVlXy3Pxq
	BYOYfWP4jHTIKEmzPyjOR/bpIVWpdk0YOk+Sw9Gknui9RlZMgFvpmxT3DRiSUN+t
	lH+JWditzQtmnpj4oTzwWJCROTVoDwtm3qgNiwEgdAcIzldV4Rg6ii3UlCYLK39C
	4Uf2bWZY6DNo6OnYOgYdqwwiYJCtbIcFK82A2BHRed/BJRfnDIJQTypuNH1aHqh6
	SMVpQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cutur9dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:22:26 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:22:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:22:25 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 8CB6B3F7041;
	Fri,  2 May 2025 06:22:12 -0700 (PDT)
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
        <gcherian@marvell.com>, Rakesh Kudurumalla <rkudurumalla@marvell.com>,
        "Tanmay Jagdale" <tanmay@marvell.com>
Subject: [net-next PATCH v1 06/15] octeontx2-af: Add support for CPT second pass
Date: Fri, 2 May 2025 18:49:47 +0530
Message-ID: <20250502132005.611698-7-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: 6kmX-Rt7yLlH2pkF1dlLx9wl3Nc9K9D8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX+kWUJLrYjsDO VKg7HYwr3adffONK8eiugBpovLUYC2eRtk27qWGb2OiSY7+8eIweeCVGSSxHC86BqHVvpqEAlvK R6M9PAEeOiv9OW+u7VlL4CzOSE/uomb8bfYKb6WmOodbbdgXCShOjFf4iW39/FZk1UNgf1FX4rB
 QsSBb3FvRua6yPkXDCZ/8rk937LG1hlER1nTP52RcjvGH+vgrlZJTgGtVXve9c4wzEspcUQ2f2q 8GsDMEZLhuEeyZRIWJWRO3W002ZCLI/pCl8N1h+W+P4/vhh/aeulxSJ+DJpXwZXuawV8JARikPk 69nSgtfAxUp0FUldYAK1O1zMkIB287lS8jb4kYY1ibauo1ppLeq3JYsloSlUjzk6oAI3VsRX2IX
 lDGL3TmnPemUV7WFrQPxHzz5SzJlCQ86cChrUa+vPQNu5p+TxOzhczWTR0oHaTkvDLtDUBDq
X-Authority-Analysis: v=2.4 cv=BaPY0qt2 c=1 sm=1 tr=0 ts=6814c712 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=46K6FPTX4cr-Sf61t84A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 6kmX-Rt7yLlH2pkF1dlLx9wl3Nc9K9D8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

From: Rakesh Kudurumalla <rkudurumalla@marvell.com>

Implemented mailbox to add mechanism to allocate a
rq_mask and apply to nixlf to toggle RQ context fields
for CPT second pass packets.

Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  23 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   7 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |  11 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 120 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   6 +
 .../marvell/octeontx2/af/rvu_struct.h         |   4 +-
 6 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f9321084abb6..715efcc04c9e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -323,6 +323,9 @@ M(NIX_CPT_BP_DISABLE,   0x8021, nix_cpt_bp_disable, nix_bp_cfg_req,	    \
 				msg_rsp)				\
 M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
 				msg_req, nix_inline_ipsec_cfg)		\
+M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
+				nix_rq_cpt_field_mask_cfg_req,  \
+				msg_rsp)	\
 M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
 				nix_mcast_grp_create_rsp)			\
 M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\
@@ -857,6 +860,7 @@ enum nix_af_status {
 	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
 	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
 	NIX_AF_ERR_LINK_CREDITS  = -431,
+	NIX_AF_ERR_RQ_CPT_MASK  = -432,
 	NIX_AF_ERR_INVALID_BPID         = -434,
 	NIX_AF_ERR_INVALID_BPID_REQ     = -435,
 	NIX_AF_ERR_INVALID_MCAST_GRP	= -436,
@@ -1178,6 +1182,25 @@ struct nix_mark_format_cfg_rsp {
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
index 6551fdb612dc..71407f6318ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -350,6 +350,11 @@ struct nix_lso {
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
@@ -373,6 +378,7 @@ struct nix_hw {
 	struct nix_flowkey flowkey;
 	struct nix_mark_format mark_format;
 	struct nix_lso lso;
+	struct nix_rq_cpt_mask rq_msk;
 	struct nix_txvlan txvlan;
 	struct nix_ipolicer *ipolicer;
 	struct nix_bp bp;
@@ -398,6 +404,7 @@ struct hw_cap {
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
+	bool	second_cpt_pass;
 	bool	nix_multiple_dwrr_mtu;   /* Multiple DWRR_MTU to choose from */
 	bool	npc_hash_extract; /* Hash extract enabled ? */
 	bool	npc_exact_match_enabled; /* Exact match supported ? */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 7fa98aeb3663..18e2a48e2de1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -544,6 +544,7 @@ void rvu_program_channels(struct rvu *rvu)
 
 void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
 {
+	struct rvu_hwinfo *hw = rvu->hw;
 	int blkaddr = nix_hw->blkaddr;
 	u64 cfg;
 
@@ -558,6 +559,16 @@ void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
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
index 6bd995c45dad..b15fd331facf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -6612,3 +6612,123 @@ int rvu_mbox_handler_nix_mcast_grp_update(struct rvu *rvu,
 
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
+		cfg |= BIT_ULL(43);
+		reg = (reg & ~GENMASK_ULL(36, 35)) | ((u64)rq_mask << 35);
+	} else {
+		cfg &= ~BIT_ULL(43);
+		reg = (reg & ~GENMASK_ULL(36, 35));
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
+	if (enable) {
+		cfg |= BIT_ULL(37);
+		cfg &= ~GENMASK_ULL(42, 38);
+		cfg |= ((u64)req->ipsec_cfg1.spb_cpt_sizem1 << 38);
+		cfg &= ~GENMASK_ULL(63, 44);
+		cfg |= ((u64)req->ipsec_cfg1.spb_cpt_aura << 44);
+	} else {
+		cfg &= ~BIT_ULL(37);
+		cfg &= ~GENMASK_ULL(42, 38);
+		cfg &= ~GENMASK_ULL(63, 44);
+	}
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
+int rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
+					  struct nix_rq_cpt_field_mask_cfg_req *req,
+					  struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct nix_hw *nix_hw;
+	int blkaddr, nixlf;
+	int rq_mask, err;
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
index 245e69fcbff9..e5e005d5d71e 100644
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
@@ -452,6 +454,10 @@
 #define NIX_AF_TL3_PARENT_MASK         GENMASK_ULL(23, 16)
 #define NIX_AF_TL2_PARENT_MASK         GENMASK_ULL(20, 16)
 
+#define NIX_AF_LF_CFG_SHIFT		17
+#define NIX_AF_LF_SSO_PF_FUNC_SHIFT	16
+#define NIX_RQ_MSK_PROFILES             4
+
 /* SSO */
 #define SSO_AF_CONST			(0x1000)
 #define SSO_AF_CONST1			(0x1008)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 77ac94cb2ec4..bd37ed3a81ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -377,7 +377,9 @@ struct nix_cn10k_rq_ctx_s {
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

