Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C4B2E8E1E;
	Wed, 18 Jun 2025 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246297; cv=none; b=oWHXD0IqEsTKDnFvJMFE6q10QFJc/gIRGEuMW1Rfnky3A5cPq5ySgAEkaSnlR3e5fg7aKZ3UilwKijILxRJhnayzZpAMqCXKrL+E8Gpl5i95/iRmXeZQPGqy2pGQfk2oGIBKFBL1C22Nma8Tf1hf5MNh1GTga2fFjHae4eKwugE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246297; c=relaxed/simple;
	bh=1ypwXjHGz5jBWmf+P6rPogRKyBIZKfcwrX1qSa9IKnI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obYO2boHv+I4aDz5rsyMZB2Q70GTZa6q+xT3CyKwCR8ZNTup82rO+MCDY7qk6fyTubR0gygx8K18o10tgyO2JkC+BNEZcDsDhdqlIx6lg8eHmkRBToLQL9kPZ5b7G4VxOgWbcQqebTIFmc7CLhfmA9X2TKjiO78NF6D8qsYEit8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KKjA5owf; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KKjA5owf"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7qnJu023248;
	Wed, 18 Jun 2025 04:31:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=t
	nQhpaD5ReslJ/vF4j+zjcDn9STTERO1YNz0OEDt3+4=; b=KKjA5owfpHemLYT+h
	EaNCeFngphckITINSuaxDTymYwdKdPK5Jj/7zplQ1yiZq+6BeH2g95LEM08+0lB5
	4I5g/PpUUuzXZ3SMbl0yufZQG44NDgw2ufijVp8wBQ1dt2T0pQ5mnE3mmcGaWljY
	2sem+2Zoo3p9qt+DE1dvJArXQ9GxdPS9OTTLqot4tB51l40a7w20jmQSUHCXAqC4
	k06nDaD65euzdpWnwN2bKCM7twW2BDe6dlGu9zVR8YVia9+ghRinjMhrUTo62Ylt
	X7fXdw1aFoc46pEe4tK5WSa6CqBVcPeZopzpljK6bBcix8vMEfKbtquAhpHlLwTv
	LmN8Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bsf2redd-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:30 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:26 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 615A03F7048;
	Wed, 18 Jun 2025 04:31:23 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 12/14] octeontx2-pf: ipsec: Process CPT metapackets
Date: Wed, 18 Jun 2025 17:00:06 +0530
Message-ID: <20250618113020.130888-13-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: GegYp7UDqAJ-d9y2-2qgCtPWNYDtBFvq
X-Proofpoint-GUID: GegYp7UDqAJ-d9y2-2qgCtPWNYDtBFvq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5OCBTYWx0ZWRfX1uMbmYnAVdls KvfYWEdIN2G3QtGzaynMFhCdop9ILsYB9gxQajfOymL1WULiGY2jmzNu/cZ/KnDl27OXUgaxYwZ 1uLXFfQHW13O5zXvWCJHAZrmXBmwFEn9KW2hrpzuExFebZ20lt4gp4IX9s0VUfzngcYKRYC8ug6
 GeIaTdQwdYzCQzR4ZxjR5kATWrejpo18K0aPhiOq/9x3bpi6lsFbLN4EDz8vZr8E1TntxArLdTA qW1XE29PSHtOoTSmF1jo4Xnsg9TJgNLwCGMzGhn0560uRztstGA/A82mQGfjD2I9lTXjJSSCl7I xnqLFZ4DBPGZ5kjTVF0tCLmQ+LN00mCsk1uDz0NRb4rxeKx9Lj1TSv0+wKc6dlKAAwmTwspZN1A
 Km9riosrUZkZjhfWah061nSO8SNX4YGz0SK63WaGUDT9B8zp2Oay8RFmcYyPDFi57gVu5uwq
X-Authority-Analysis: v=2.4 cv=Yu4PR5YX c=1 sm=1 tr=0 ts=6852a393 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=Jqs9V9nVHtBrITbsl1IA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

CPT hardware forwards decrypted IPsec packets to NIX via the X2P bus
as metapackets which are of 256 bytes in length. Each metapacket
contains CPT_PARSE_HDR_S and initial bytes of the decrypted packet
that helps NIX RX in classifying and submitting to CPU. Additionally,
CPT also sets BIT(11) of the channel number to indicate that it's a
2nd pass packet from CPT.

Since the metapackets are not complete packets, they don't have to go
through L3/L4 layer length and checksum verification so these are
disabled via the NIX_LF_INLINE_RQ_CFG mailbox during IPsec initialization.

The CPT_PARSE_HDR_S contains a WQE pointer to the complete decrypted
packet. Add code in the rx NAPI handler to parse the header and extract
WQE pointer. Later, use this WQE pointer to construct the skb, set the
XFRM packet mode flags to indicate successful decryption before submitting
it to the network stack.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V2:
- Removed unnecessary casts
- Don't convert complete cpt_parse_hdr from BE to LE and just
  convert required fields
- Fixed logic to avoid repeated calculation for start and end in sg

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-15-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 52 +++++++++++++++++++
 .../marvell/octeontx2/nic/cn10k_ipsec.h       | 48 +++++++++++++++++
 .../marvell/octeontx2/nic/otx2_common.h       |  2 +
 .../marvell/octeontx2/nic/otx2_struct.h       | 16 ++++++
 .../marvell/octeontx2/nic/otx2_txrx.c         | 29 +++++++++--
 5 files changed, 144 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 5cb6bc835e56..a95878378334 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,58 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct nix_cqe_rx_s *cqe,
+						     struct sk_buff *skb,
+						     int qidx)
+{
+	struct nix_rx_sg_s *sg = &cqe->sg;
+	struct nix_wqe_rx_s *wqe = NULL;
+	u64 *seg_addr = &sg->seg_addr;
+	struct cpt_parse_hdr_s *cptp;
+	struct xfrm_offload *xo;
+	struct xfrm_state *xs;
+	struct sec_path *sp;
+	void *va;
+
+	/* CPT_PARSE_HDR_S is present in the beginning of the buffer */
+	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, *seg_addr));
+
+	cptp = (struct cpt_parse_hdr_s *)va;
+
+	/* Convert the wqe_ptr from CPT_PARSE_HDR_S to a CPU usable pointer */
+	wqe = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
+					     be64_to_cpu(cptp->wqe_ptr)));
+
+	/* Get the XFRM state pointer stored in SA context */
+	xs = pfvf->ipsec.inb_sa->base +
+	     (be32_to_cpu(cptp->cookie) * pfvf->ipsec.sa_tbl_entry_sz) + 1024;
+
+	/* Set XFRM offload status and flags for successful decryption */
+	sp = secpath_set(skb);
+	if (!sp) {
+		netdev_err(pfvf->netdev, "Failed to secpath_set\n");
+		wqe = NULL;
+		goto err_out;
+	}
+
+	rcu_read_lock();
+	xfrm_state_hold(xs);
+	rcu_read_unlock();
+
+	sp->xvec[sp->len++] = xs;
+	sp->olen++;
+
+	xo = xfrm_offload(skb);
+	xo->flags = CRYPTO_DONE;
+	xo->status = CRYPTO_SUCCESS;
+
+err_out:
+	/* Return metapacket buffer back to pool since it's no longer needed */
+	otx2_free_rcv_seg(pfvf, cqe, qidx);
+	return wqe;
+}
+
 static int cn10k_inb_nix_inline_lf_cfg(struct otx2_nic *pfvf)
 {
 	struct nix_inline_ipsec_lf_cfg *req;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index d5d84c0bc308..c84da9420b0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -8,6 +8,7 @@
 #define CN10K_IPSEC_H
 
 #include <linux/types.h>
+#include "otx2_struct.h"
 
 DECLARE_STATIC_KEY_FALSE(cn10k_ipsec_sa_enabled);
 
@@ -302,6 +303,41 @@ struct cpt_sg_s {
 	u64 rsvd_63_50	: 14;
 };
 
+/* CPT Parse Header Structure for Inbound packets */
+struct cpt_parse_hdr_s {
+	/* Word 0 */
+	u64 cookie      : 32;
+	u64 match_id    : 16;
+	u64 err_sum     : 1;
+	u64 reas_sts    : 4;
+	u64 reserved_53 : 1;
+	u64 et_owr      : 1;
+	u64 pkt_fmt     : 1;
+	u64 pad_len     : 3;
+	u64 num_frags   : 3;
+	u64 pkt_out     : 2;
+
+	/* Word 1 */
+	u64 wqe_ptr;
+
+	/* Word 2 */
+	u64 frag_age    : 16;
+	u64 res_32_16   : 16;
+	u64 pf_func     : 16;
+	u64 il3_off     : 8;
+	u64 fi_pad      : 3;
+	u64 fi_offset   : 5;
+
+	/* Word 3 */
+	u64 hw_ccode    : 8;
+	u64 uc_ccode    : 8;
+	u64 res3_32_16  : 16;
+	u64 spi         : 32;
+
+	/* Word 4 */
+	u64 misc;
+};
+
 /* CPT LF_INPROG Register */
 #define CPT_LF_INPROG_INFLIGHT	GENMASK_ULL(8, 0)
 #define CPT_LF_INPROG_GRB_CNT	GENMASK_ULL(39, 32)
@@ -329,6 +365,10 @@ bool otx2_sqe_add_sg_ipsec(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 			  struct otx2_snd_queue *sq, struct sk_buff *skb,
 			  int num_segs, int size);
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct nix_cqe_rx_s *cqe,
+						     struct sk_buff *skb,
+						     int qidx);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -359,5 +399,13 @@ cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 {
 	return true;
 }
+
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct nix_cqe_rx_s *cqe,
+						     struct sk_buff *skb,
+						     int qidx)
+{
+	return NULL;
+}
 #endif
 #endif // CN10K_IPSEC_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 5d23f5623118..2a40bfd7234d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -1150,6 +1150,8 @@ int otx2_handle_ntuple_tc_features(struct net_device *netdev,
 int otx2_smq_flush(struct otx2_nic *pfvf, int smq);
 void otx2_free_bufs(struct otx2_nic *pfvf, struct otx2_pool *pool,
 		    u64 iova, int size);
+void otx2_free_rcv_seg(struct otx2_nic *pfvf, struct nix_cqe_rx_s *cqe,
+		       int qidx);
 int otx2_mcam_entry_init(struct otx2_nic *pfvf);
 
 /* tc support */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 4e5899d8fa2e..506fab414b7e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -175,6 +175,22 @@ struct nix_cqe_tx_s {
 	struct nix_send_comp_s comp;
 };
 
+/* NIX WQE header structure */
+struct nix_wqe_hdr_s {
+	u64 flow_tag              : 32;
+	u64 tt                    : 2;
+	u64 reserved_34_43        : 10;
+	u64 node                  : 2;
+	u64 q                     : 14;
+	u64 wqe_type              : 4;
+};
+
+struct nix_wqe_rx_s {
+	struct nix_wqe_hdr_s	hdr;
+	struct nix_rx_parse_s	parse;
+	struct nix_rx_sg_s	sg;
+};
+
 /* NIX SQE header structure */
 struct nix_sqe_hdr_s {
 	u64 total		: 18; /* W0 */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 99ace381cc78..f6fed7a56ef3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -205,11 +205,16 @@ static bool otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 		}
 	}
 
+	if (parse->chan & 0x800)
+		off = 0;
+
 	page = virt_to_page(va);
 	if (likely(skb_shinfo(skb)->nr_frags < MAX_SKB_FRAGS)) {
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 				va - page_address(page) + off,
 				len - off, pfvf->rbsize);
+		if (parse->chan & 0x800)
+			return false;
 		return true;
 	}
 
@@ -243,8 +248,8 @@ static void otx2_set_rxhash(struct otx2_nic *pfvf,
 	skb_set_hash(skb, hash, hash_type);
 }
 
-static void otx2_free_rcv_seg(struct otx2_nic *pfvf, struct nix_cqe_rx_s *cqe,
-			      int qidx)
+void otx2_free_rcv_seg(struct otx2_nic *pfvf, struct nix_cqe_rx_s *cqe,
+		       int qidx)
 {
 	struct nix_rx_sg_s *sg = &cqe->sg;
 	void *end, *start;
@@ -333,6 +338,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 				 struct nix_cqe_rx_s *cqe, bool *need_xdp_flush)
 {
 	struct nix_rx_parse_s *parse = &cqe->parse;
+	struct nix_wqe_rx_s *orig_pkt_wqe = NULL;
+	u32 desc_sizem1 = parse->desc_sizem1;
 	struct nix_rx_sg_s *sg = &cqe->sg;
 	struct sk_buff *skb = NULL;
 	u64 *word = (u64 *)parse;
@@ -359,8 +366,24 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
+	if (parse->chan & 0x800) {
+		orig_pkt_wqe = cn10k_ipsec_process_cpt_metapkt(pfvf, cqe, skb, cq->cq_idx);
+		if (!orig_pkt_wqe) {
+			netdev_err(pfvf->netdev, "Invalid WQE in CPT metapacket\n");
+			napi_free_frags(napi);
+			cq->pool_ptrs++;
+			return;
+		}
+		/* Switch *sg to the orig_pkt_wqe's *sg which has the actual
+		 * complete decrypted packet by CPT.
+		 */
+		sg = &orig_pkt_wqe->sg;
+		desc_sizem1 = orig_pkt_wqe->parse.desc_sizem1;
+	}
+
 	start = (void *)sg;
-	end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
+	end = start + ((desc_sizem1 + 1) * 16);
+
 	while (start < end) {
 		sg = (struct nix_rx_sg_s *)start;
 		seg_addr = &sg->seg_addr;
-- 
2.43.0

