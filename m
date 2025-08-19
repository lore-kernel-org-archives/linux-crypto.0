Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A838121C9E4;
	Tue, 19 Aug 2025 02:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569746; cv=none; b=iQi9Jxw4gFCl5pXNIMgZtZk0JDTUzyquGwykynPGNgoB/E81rjOoMFqrCRR6C9PbMTb+AnzjUDra6DRLPGIGUqKC9+4+N6sBrEsDuuQK9FZchkKfemzWHWoQ5Gv02HF2Moxi5kAn7hLBo1zZAlZPabkF5sRnvV9WuB9dkW4oSUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569746; c=relaxed/simple;
	bh=/jz10a3dygiTKHSQ/35pxIUjuHDYkOGoTVdTSokorFk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDOvJalJFuFMcTLgEOeemXTvaeMXdCJlm7Q2Jh3NlJ4YwdorYavk/8UF4+BQIDQZ13hi1t8nUcBhYEyreW5Qu0zrULHl3PyPLySnGCI6E7iKIzrCo6GvKSZ62fy9odkROx1o8Y5/mVJuTHWy+azJuwijYJjkALYNuAGZDw4zNsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dP9p5x09; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dP9p5x09"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57INWcoo004833;
	Mon, 18 Aug 2025 19:15:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	wd/B7xuRAQkATs6M9EgOXf5CJCkeOGZnB6Qoo099cg=; b=dP9p5x09DTghLr0nW
	Pz35KCdBM7tnN5OrR7bywcIIgAi5UzeAXzp1kYVLh304U+gw3YNYI4MRzBd6x1TJ
	lsPzLLD6U+8SExIhVblp1wCP37ORztJep+KCRnkSbxREnBT4yFReZvE0matvDPLK
	oAPRPm+1JPwdc5LlU+0C8N4BjYDEuia2AdUfM6CpjlCzRV4KG1EBY3M+UrZ5Dclb
	+xP5b+7qtyVvnqjIrtM1CSHpVUUagXmJGa5aTLzfuG8bfBvQHS5QNPrlUvR41lKO
	5o9gOPsinoAqlLKCDWIPJm0pAiLP8NDpiJUy2cbh2m6MmFKd0HCAnNxRKwJ7cbcW
	yIL4A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 48mdx0g8wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:38 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:15:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:15:42 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 9D70B3F709F;
	Mon, 18 Aug 2025 19:15:34 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Geetha sowjanya
	<gakula@marvell.com>,
        Amit Singh Tomar <amitsinght@marvell.com>,
        "Tanmay
 Jagdale" <tanmay@marvell.com>
Subject: [PATCH net-next v4 07/14] octeontx2-af: Add mbox to alloc/free BPIDs
Date: Tue, 19 Aug 2025 07:44:58 +0530
Message-ID: <20250819021507.323752-8-tanmay@marvell.com>
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
X-Proofpoint-GUID: fsfM2O_0eT41M3PYxDmaD8S91ryXIQgw
X-Proofpoint-ORIG-GUID: fsfM2O_0eT41M3PYxDmaD8S91ryXIQgw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfX0Y4wJdOXkT7p 5XS+UeUiVhpggaK43pHxID4kI/8Zxefg1ioOUkd0La+XrfPPZDPHjisKW1FcpCrLRjQ2m4LuQk8 lYoozU/7Tzxn4dFjQpScFe5kD1q5AVV5F7DjnnoPgMTmP2lSA1t9alLfdNcxyXk76H6TtRvzeJj
 5enpq4Xyh4SO3cIqj/bR0Wwqn5pqc4W7ppBfk7Xrst6AOI69kFSZAASkRTXh8ny0G0Ygx244Mdu bHgbHWP/DOzAjkcElhbIIgv2SqthJdQDXQTD86hY4bIPd4aTmkdIY3yZzHHeQ9LRc2lUxSpRrIY wEZiI8gIBxYlN2RoBso4Q+uAKlZKL8wzKNra1NjWcPhWge/wCvI7/eN3bkuvVsLnfwu5bJ4GB+J
 QyAT0sn2VL3V1Os6FjXBI+3ecAP4NMxpfREMeoGFfviY2dW+S6/22YI2TxwF4DXK1jVjDFy/
X-Authority-Analysis: v=2.4 cv=D4hHKuRj c=1 sm=1 tr=0 ts=68a3de4a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=Bbp0eoHYjeZGJuDmjPgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

From: Geetha sowjanya <gakula@marvell.com>

Adds mbox handlers to allocate/free BPIDs from the free BPIDs pool.
This can be used by the PF/VF to request up to 8 BPIds.
Also add a mbox handler to configure NIXX_AF_RX_CHANX with multiple
Bpids.

Signed-off-by: Amit Singh Tomar <amitsinght@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V4:
- None

Changes in V3:
- None

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-9-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-8-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-8-tanmay@marvell.com/

 .../ethernet/marvell/octeontx2/af/common.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  26 +++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 100 ++++++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 8a08bebf08c2..656f6e5c8524 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -191,6 +191,7 @@ enum nix_scheduler {
 #define NIX_INTF_TYPE_CGX		0
 #define NIX_INTF_TYPE_LBK		1
 #define NIX_INTF_TYPE_SDP		2
+#define NIX_INTF_TYPE_CPT		3
 
 #define MAX_LMAC_PKIND			12
 #define NIX_LINK_CGX_LMAC(a, b)		(0 + 4 * (a) + (b))
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6b2f46f32cfd..709b4eb3de59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -347,6 +347,9 @@ M(NIX_MCAST_GRP_UPDATE, 0x802d, nix_mcast_grp_update,				\
 				nix_mcast_grp_update_req,			\
 				nix_mcast_grp_update_rsp)			\
 M(NIX_LF_STATS, 0x802e, nix_lf_stats, nix_stats_req, nix_stats_rsp)	\
+M(NIX_ALLOC_BPIDS,     0x8028, nix_alloc_bpids, nix_alloc_bpid_req, nix_bpids) \
+M(NIX_FREE_BPIDS,      0x8029, nix_free_bpids, nix_bpids, msg_rsp)             \
+M(NIX_RX_CHAN_CFG,     0x802a, nix_rx_chan_cfg, nix_rx_chan_cfg, nix_rx_chan_cfg)      \
 /* MCS mbox IDs (range 0xA000 - 0xBFFF) */					\
 M(MCS_ALLOC_RESOURCES,	0xa000, mcs_alloc_resources, mcs_alloc_rsrc_req,	\
 				mcs_alloc_rsrc_rsp)				\
@@ -1365,6 +1368,29 @@ struct nix_mcast_grp_update_rsp {
 	u32 mce_start_index;
 };
 
+struct nix_alloc_bpid_req {
+	struct mbox_msghdr hdr;
+	u8 bpid_cnt;
+	u8 type;
+	u64 rsvd;
+};
+
+struct nix_bpids {
+	struct mbox_msghdr hdr;
+	u8 bpid_cnt;
+	u16 bpids[8];
+	u64 rsvd;
+};
+
+struct nix_rx_chan_cfg {
+	struct mbox_msghdr hdr;
+	u8 type;	/* Interface type(CGX/CPT/LBK) */
+	u8 read;
+	u16 chan;	/* RX channel to be configured */
+	u64 val;	/* NIX_AF_RX_CHAN_CFG value */
+	u64 rsvd;
+};
+
 /* Global NIX inline IPSec configuration */
 struct nix_inline_ipsec_cfg {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index fa21e440eb11..f4095b105417 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -570,6 +570,106 @@ void rvu_nix_flr_free_bpids(struct rvu *rvu, u16 pcifunc)
 	mutex_unlock(&rvu->rsrc_lock);
 }
 
+int rvu_mbox_handler_nix_rx_chan_cfg(struct rvu *rvu,
+				     struct nix_rx_chan_cfg *req,
+				     struct nix_rx_chan_cfg *rsp)
+{
+	struct rvu_pfvf *pfvf;
+	int blkaddr;
+	u16 chan;
+
+	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, req->hdr.pcifunc);
+	chan = pfvf->rx_chan_base + req->chan;
+
+	if (req->type == NIX_INTF_TYPE_CPT)
+		chan = chan | BIT(11);
+
+	if (req->read) {
+		rsp->val = rvu_read64(rvu, blkaddr,
+				      NIX_AF_RX_CHANX_CFG(chan));
+		rsp->chan = req->chan;
+	} else {
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(chan), req->val);
+	}
+	return 0;
+}
+
+int rvu_mbox_handler_nix_alloc_bpids(struct rvu *rvu,
+				     struct nix_alloc_bpid_req *req,
+				     struct nix_bpids *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct nix_hw *nix_hw;
+	int blkaddr, cnt = 0;
+	struct nix_bp *bp;
+	int bpid, err;
+
+	err = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	bp = &nix_hw->bp;
+
+	/* For interface like sso uses same bpid across multiple
+	 * application. Find the bpid is it already allocate or
+	 * allocate a new one.
+	 */
+	if (req->type > NIX_INTF_TYPE_CPT) {
+		for (bpid = 0; bpid < bp->bpids.max; bpid++) {
+			if (bp->intf_map[bpid] == req->type) {
+				rsp->bpids[cnt] = bpid + bp->free_pool_base;
+				rsp->bpid_cnt++;
+				bp->ref_cnt[bpid]++;
+				cnt++;
+			}
+		}
+		if (rsp->bpid_cnt)
+			return 0;
+	}
+
+	for (cnt = 0; cnt < req->bpid_cnt; cnt++) {
+		bpid = rvu_alloc_rsrc(&bp->bpids);
+		if (bpid < 0)
+			return 0;
+		rsp->bpids[cnt] = bpid + bp->free_pool_base;
+		bp->intf_map[bpid] = req->type;
+		bp->fn_map[bpid] = pcifunc;
+		bp->ref_cnt[bpid]++;
+		rsp->bpid_cnt++;
+	}
+	return 0;
+}
+
+int rvu_mbox_handler_nix_free_bpids(struct rvu *rvu,
+				    struct nix_bpids *req,
+				    struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int blkaddr, cnt, err, id;
+	struct nix_hw *nix_hw;
+	struct nix_bp *bp;
+	u16 bpid;
+
+	err = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	bp = &nix_hw->bp;
+	for (cnt = 0; cnt < req->bpid_cnt; cnt++) {
+		bpid = req->bpids[cnt] - bp->free_pool_base;
+		bp->ref_cnt[bpid]--;
+		if (bp->ref_cnt[bpid])
+			continue;
+		rvu_free_rsrc(&bp->bpids, bpid);
+		for (id = 0; id < bp->bpids.max; id++) {
+			if (bp->fn_map[id] == pcifunc)
+				bp->fn_map[id] = 0;
+		}
+	}
+	return 0;
+}
+
 static u16 nix_get_channel(u16 chan, bool cpt_link)
 {
 	/* CPT channel for a given link channel is always
-- 
2.43.0

