Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9738E255F39;
	Fri,  2 May 2025 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192195; cv=none; b=rkFcoX7BoHjEn7mD64RnKlNRjjzNkt3G31sG2Yj2PknoR/jQ48SogC2HdAX2p47KDDM647AyCMfveMQhd/4iBjqiYdfQth26cspd0NIljV7LlDZfoozTSrckCr+dvUGk6WdsoIHGK5VDF0m9daGO8L5B+uCnqE4Hv0O5XWi0xrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192195; c=relaxed/simple;
	bh=au+S6SmqxDG+55r8q8quZ4R1Sw0QG4A9zZRMe4d8vnA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8thh8WukNkvp5Y7F1BmUUCeLXE++h9gpRoKmDD+ITp95AyN1ZDQZ37elNqxev+QUVlc5zcoQZBvJl68vmHK5JARcyiIIh7bCQ3fhhrGXVrStzCm4IAt16efg7vGvK2dkXrvg0wgMZmpTfMqINNR/6IMkRzhbJ8tW9ytKMKmPCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZHQrgCPY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZHQrgCPY"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542Cv0Rj031010;
	Fri, 2 May 2025 06:22:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=R
	ApmBC2ehpSd6oAoYyn3gNx8vtv7quWGBv0vGFThims=; b=ZHQrgCPYqhRgxygho
	sIg8nGqHMLKXLCK39ZHvx5V+PVKh/4rb+VVFkda2VG+Pgo7ATWgTSIve/Opeopla
	xY1L4G98iZmHjGrzxVrkspgWL7/GyKiGCxjqCiwn6qjFami9YSDrOhMVPAALiAQ2
	pua0vW+yGCzJso9FCwER04VOPy4emQSoN+2HK6SG7DUZ8o/dTAE641IW9ZtqXTAi
	Nh9o8bqR+kPUJHAoRSKcfU8jYuMQsQkAVpE+Xqq2/OeO7Q99Cgo1jACVqDW5A5U6
	XoGA1q/TK1M9KRkylVYkmQSSI+hJueoesESLOkQUojgQozkF59sXLe72dUglKGRW
	jt4ug==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cutur9ex-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:22:59 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:22:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:22:56 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id D19E23F7041;
	Fri,  2 May 2025 06:22:44 -0700 (PDT)
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
        <gcherian@marvell.com>, Amit Singh Tomar <amitsinght@marvell.com>,
        "Tanmay
 Jagdale" <tanmay@marvell.com>
Subject: [net-next PATCH v1 08/15] octeontx2-af: Add mbox to alloc/free BPIDs
Date: Fri, 2 May 2025 18:49:49 +0530
Message-ID: <20250502132005.611698-9-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: n5g9vh1ywJow8x0oe5QTf7F_6aut7Bdj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX8mWI8wq1krr5 LNx14dxRI+zMpPNaLapPPHKKN7GA166wH8d3oZy5Q2ld+ZTkmOdLAYxT7ioz0C/gRn9XSq5lYsE AV7Vb1/bjFadYCnd1j+GpsVw+LdHJAkidzhffKkP9k4y4zQOwmdMZbI72bFaavLlHGy5oH/Rh5W
 +JfhfAvEbvUiI9FmovDJz2iTZOCpvSfxWG6S44p4mkTw7NkPUCIwQLtLMkBf+5ynXB5EJPf4JMx e+0o+D5+15fdn1aUDitM43kj9Gg/r0LgR10vNhO7H/tQdZFf4XIrcH831s1Li+q+aFdOrSr3+K9 08n+7XxK7Ag4ZC2rmFqFoDrV1mw+z1Z4HyeQABeEH33mZBWqPTplTqqc2OhYPTUtgTZPp7mAV/i
 WflX9uvet97nZLP0LiVzVm7erjjSILkCN+0wBeQKUQk+E+Rr51NVONNM4VY8F0yTra9SyT4d
X-Authority-Analysis: v=2.4 cv=BaPY0qt2 c=1 sm=1 tr=0 ts=6814c733 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=Bbp0eoHYjeZGJuDmjPgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: n5g9vh1ywJow8x0oe5QTf7F_6aut7Bdj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

From: Geetha sowjanya <gakula@marvell.com>

Adds mbox handlers to allocate/free BPIDs from the free BPIDs pool.
This can be used by the PF/VF to request up to 8 BPIds.
Also add a mbox handler to configure NIXX_AF_RX_CHANX with multiple
Bpids.

Signed-off-by: Amit Singh Tomar <amitsinght@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/common.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  26 +++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 100 ++++++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 406c59100a35..a7c1223dedc6 100644
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
index 5cebf10a15a7..71cf507c2591 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -338,6 +338,9 @@ M(NIX_MCAST_GRP_UPDATE, 0x802d, nix_mcast_grp_update,				\
 				nix_mcast_grp_update_req,			\
 				nix_mcast_grp_update_rsp)			\
 M(NIX_LF_STATS, 0x802e, nix_lf_stats, nix_stats_req, nix_stats_rsp)	\
+M(NIX_ALLOC_BPIDS,     0x8028, nix_alloc_bpids, nix_alloc_bpid_req, nix_bpids) \
+M(NIX_FREE_BPIDS,      0x8029, nix_free_bpids, nix_bpids, msg_rsp)             \
+M(NIX_RX_CHAN_CFG,     0x802a, nix_rx_chan_cfg, nix_rx_chan_cfg, nix_rx_chan_cfg)      \
 /* MCS mbox IDs (range 0xA000 - 0xBFFF) */					\
 M(MCS_ALLOC_RESOURCES,	0xa000, mcs_alloc_resources, mcs_alloc_rsrc_req,	\
 				mcs_alloc_rsrc_rsp)				\
@@ -1347,6 +1350,29 @@ struct nix_mcast_grp_update_rsp {
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
index 68525bfc8e6d..d5ec6ad0f30c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -569,6 +569,106 @@ void rvu_nix_flr_free_bpids(struct rvu *rvu, u16 pcifunc)
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

