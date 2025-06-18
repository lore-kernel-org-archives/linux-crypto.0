Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729D2E4279;
	Wed, 18 Jun 2025 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246275; cv=none; b=m+lkG+M2IZpN+c8kWXkNjP6hlp7e95mfw9vyHz9v6qmm8J7LGWO8W8Y7OHC0/KgFYmawRrVvjroeltoBXka4lnmQ1U7Wy9GXXL9xx4Rx4iCjoipqoy1tX+m75so5tjuYZr0FS+Sg7WYjPCa8KrJ9iIk5ggKqumoUh1LguU4zlME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246275; c=relaxed/simple;
	bh=XSvwUq6z6I2YGqQ6t4muNlmdJ4zaCGaUGnKIJRd6P3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RydOLij5vFQssdM+dCd3+0ZQC6NDgDaOCKmeOL3P8xsoVSOQ1yWk2MtTWn+hDSYzLo31F3o4XYIH3Wfl0x4Bx098vVf4U2yi5GrFysBpd2FRVOJL9Eo0CGdZ2/CkUcKP6HkNC6lITVgYEZdUvTWPj8ZkQD2ECVLpbQAN21+mwW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dlpRK19j; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dlpRK19j"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HNSRIu016134;
	Wed, 18 Jun 2025 04:31:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=k
	VhMoudfWdBZSewLIilfSPx9Nwp2wS2sP0iVg6Giusw=; b=dlpRK19j7DUCV4gVh
	4bBgqHhaP5/VMFZwM0JXn3h2xBG//Is92aLea6HZWevKJNjy/XV9QU7xJ/zPa3wo
	zL+Z4GJXqneADsimLsTMXBlMFUrPgs3L91sH0T1L7Hn03pvh4Q9TYZe8rKQOZWvw
	aTcGtmnDrEuyJfWIhXN2RI8kMB8psHCzML52OolXX7r70FJaGsOqMIdyEOlxg2A+
	rwFIClQimalDIFF8TZmwqYaZg1PcFkXbtStuq1bYS5fGbcEH9pZ/imfYQreX5ezq
	oeMh+oAcH+0R/5XMFK5x8JADG6E0hmAgKG9YEP3m5ChEqU4RujFbLmEDBVjkaT+/
	xwiIA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bj2kh92m-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:00 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 99EC23F7066;
	Wed, 18 Jun 2025 04:30:56 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Rakesh
 Kudurumalla" <rkudurumalla@marvell.com>,
        Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH net-next v2 05/14] octeontx2-af: Add support for CPT second pass
Date: Wed, 18 Jun 2025 16:59:59 +0530
Message-ID: <20250618113020.130888-6-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=Q9jS452a c=1 sm=1 tr=0 ts=6852a37b cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=8JFNMAf0qV5VGRTVGfUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5OCBTYWx0ZWRfXwZDSev7CcFGp gkxKaDOu//NghfWR35nEQUxjAaLXEsHpiEsB3z8YA/he6ogG6Xfb8L4wF/9C4PLWA61/a/dSfBq AOvEK2GRMyvTOsjmCOB2ZX7a72LRXymo+Fu0qf1myDqArA4HbdNfmDvqQaULyx69awAwM/PlnBI
 t3CvAqiCNrAexUoExzwdgITBLvaa8KqLkHrzM4w4S+LyzgvLfivKbwLYekeYJebYedkYQP8bCiV 5Bj2zkzS9EROD02iIqs9EWmCJJ4B2gvhNbjZnPdcF4JGJl4kNrCtKeRMAjg2cOjHnpAwCq2OxRZ jImNbnqAtJC7+XOfBeN8yhasTPCDueMh15Pmn3WWYt6F9LR91Jdn0WKItqjD9SW8G+l+NLT56Gx
 jcXSYT0oJN889tiRi+BY4Agh6/+66DpCZRoETpTsUqb2BanKc+QORr/fBJpwSjHBbSHe4+q3
X-Proofpoint-GUID: 0ORNo8zsWEV6X5-ZRVb_PkHBv3W0Gpop
X-Proofpoint-ORIG-GUID: 0ORNo8zsWEV6X5-ZRVb_PkHBv3W0Gpop
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

From: Rakesh Kudurumalla <rkudurumalla@marvell.com>

Implemented mailbox to add mechanism to allocate a
rq_mask and apply to nixlf to toggle RQ context fields
for CPT second pass packets.

Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-6-tanmay@marvell.com/

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  23 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   7 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |  11 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 125 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  15 +++
 .../marvell/octeontx2/af/rvu_struct.h         |   4 +-
 6 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index dafba59564d8..5be73248fdf8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -331,6 +331,9 @@ M(NIX_CPT_BP_DISABLE,   0x8021, nix_cpt_bp_disable, nix_bp_cfg_req,	    \
 				msg_rsp)				\
 M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
 				msg_req, nix_inline_ipsec_cfg)		\
+M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
+				nix_rq_cpt_field_mask_cfg_req,  \
+				msg_rsp)	\
 M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
 				nix_mcast_grp_create_rsp)			\
 M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\
@@ -867,6 +870,7 @@ enum nix_af_status {
 	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
 	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
 	NIX_AF_ERR_LINK_CREDITS  = -431,
+	NIX_AF_ERR_RQ_CPT_MASK  = -432,
 	NIX_AF_ERR_INVALID_BPID         = -434,
 	NIX_AF_ERR_INVALID_BPID_REQ     = -435,
 	NIX_AF_ERR_INVALID_MCAST_GRP	= -436,
@@ -1188,6 +1192,25 @@ struct nix_mark_format_cfg_rsp {
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
index 05adc54535eb..d8896fcc32a0 100644
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
index 446e7d3234b5..9cbb3fab83a1 100644
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

