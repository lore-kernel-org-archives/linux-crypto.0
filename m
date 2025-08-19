Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617228C5BC;
	Tue, 19 Aug 2025 02:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569758; cv=none; b=d4zRNZKkulbsUbWlPa+Xbk7aUvmJzEJYfFaBWrdMvwlVUMzSeJWTDUhuw4QaKRxigpQNYcnNfOuPEtt5o3qGoTEVfm2D2TLDgGRUKdi/cAzPvEMi/DaRge+tRw5X0hFDta6EZfhOEP/cHllle4V5D+yvrI2aPmW/njVJV5kiQmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569758; c=relaxed/simple;
	bh=Mq4SXCh+sqYL9x15nfqmjQRIwE1zvOJkS1aqoqZS4yE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7XivJVb+GG+/ph599KQ0VroYN/1jHb77oLgXVtioTsOtBQzpltnb/wOdOpkOHZjbi+6KBvKGYXtZAQ2B5OWf7uJLbsWindcWAVy1lPy1jZZ/Kz7mFj5Pbww+k6SAV1l+vabH5sHqFyOk+5d/LmrUAiPNXbpZIdIerynMKZReK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VjTn0IV9; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VjTn0IV9"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57J22Cou031764;
	Mon, 18 Aug 2025 19:15:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	9BjZ47WdSTat3rOHm3GHWYmKauASTx6PXylw/L9f7M=; b=VjTn0IV9Tme+yu5lG
	8SnRuNLdNh2/7jYTOns8jGOXWVrsIR2Xa2DkwduMYt0+t6ybczhKaLLOwsmpc9L2
	rmHCb403KGnkjEAWVz5dvWtJFFOpqN91ysdytRud30NM880j0OEEVv5+rmHXczhy
	fOb5NiFfiA6D+utlfIYGNsTcDdniPqt596w+oYt8nezWhRd31AhuFAgyH0AZRBEN
	6Ro37iZhwuamo+lyWGutqDp4+e8WEZY4BXBBMH+c1/swD6o5D74sGc8/C33JtGPL
	jFYtNyQ+8qPgdeKE8zcbcx1lPikvfkYV7fAD90tRJWY7S7M7ZPvRh82dTkOw60dP
	Lwa5A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 48mg4r80nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:53 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:15:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:15:57 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 089DA3F7078;
	Mon, 18 Aug 2025 19:15:49 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v4 12/14] octeontx2-pf: ipsec: Process CPT metapackets
Date: Tue, 19 Aug 2025 07:45:03 +0530
Message-ID: <20250819021507.323752-13-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=IK4CChvG c=1 sm=1 tr=0 ts=68a3de5a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=2V_QfZprvCi1FviU9xwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 9nsGgjmrROQha6D46aI7c9h9_FYaJY_3
X-Proofpoint-ORIG-GUID: 9nsGgjmrROQha6D46aI7c9h9_FYaJY_3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfX/jnNonS+b1G8 Dxo6vbNXV3bjDgv0rUDBe8IaeFzPx3X0sODeUZ6x5/E1hq87mjDn0HISBNBCuo8wcASF59SOtXv OfEh3P97eKWhUX6j/1EEPHZ22rA1nrTNDXEjEMyeswKZHeCrG/oF2/ZCxvkzUMZ3UWWpf9utb2E
 uwAd7u0zZ8NBh0DIzD9FGC4cyoPMXp4LA5HSMd79Y/eId9ilV2Ju0mdb47B+TVf+EGFHe078TkU GhnW/MdM0nVo/8U1u3h3oMRqpclwW+vzAdmr2cPUJazIGrR7bNVgAam3ieMW3fm5Ep5RbdH98rI 3C33qdRBfSxxhqfmMyqf1WKjla8XOEaKNjosZPxWHZl+Q2aI4tNc9eCta55Lrr2QmcE7y26NxwG
 Dii74dUYsD/7/tF42zWsIrDbZTnBR4ToMrQy8fs0JpO/zGjYXqwrbsILRrCfCb9rs2uqECq5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

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
Changes in V4:
- Updated cpt_parse_hdr_s to 4 u64 words
- Switched to using FIELD_GET macros for extracting fields withing
  cpt_parse_hdr_s
- With above changes, all the sparse warnings are now resolved

Changes in V3:
- Updated cpt_parse_hdr_s structure to use __be64 type

Changes in V2:
- Removed unnecessary casts
- Don't convert complete cpt_parse_hdr from BE to LE and just
  convert required fields
- Fixed logic to avoid repeated calculation for start and end in sg

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-15-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-13-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-13-tanmay@marvell.com/ 

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 50 +++++++++++++++++++
 .../marvell/octeontx2/nic/cn10k_ipsec.h       | 23 +++++++++
 .../marvell/octeontx2/nic/otx2_struct.h       | 16 ++++++
 .../marvell/octeontx2/nic/otx2_txrx.c         | 27 +++++++++-
 4 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 550a8da04f1f..81610774e7b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,56 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct sk_buff *skb,
+						     dma_addr_t seg_addr)
+{
+	struct nix_wqe_rx_s *wqe = NULL;
+	struct cpt_parse_hdr_s *cptp;
+	struct xfrm_offload *xo;
+	struct xfrm_state *xs;
+	struct sec_path *sp;
+	dma_addr_t wqe_iova;
+	u32 sa_index;
+	u64 *sa_ptr;
+
+	/* CPT_PARSE_HDR_S is present in the beginning of the buffer */
+	cptp = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, seg_addr));
+
+	/* Convert the wqe_ptr from CPT_PARSE_HDR_S to a CPU usable pointer */
+	wqe_iova = FIELD_GET(CPT_PARSE_HDR_W1_WQE_PTR, cptp->w1);
+	wqe = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
+					     be64_to_cpu((__force __be64)wqe_iova)));
+
+	/* Get the XFRM state pointer stored in SA context */
+	sa_index = FIELD_GET(CPT_PARSE_HDR_W0_COOKIE, cptp->w0);
+	sa_ptr = pfvf->ipsec.inb_sa->base +
+		 (be32_to_cpu((__force __be32)sa_index) * pfvf->ipsec.sa_tbl_entry_sz) + 1024;
+	xs = (struct xfrm_state *)*sa_ptr;
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
+	return wqe;
+}
+
 static int cn10k_inb_nix_inline_lf_cfg(struct otx2_nic *pfvf)
 {
 	struct nix_inline_ipsec_lf_cfg *req;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 80bc0e4a9da6..7c1e24e21ea3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -8,6 +8,7 @@
 #define CN10K_IPSEC_H
 
 #include <linux/types.h>
+#include "otx2_struct.h"
 
 DECLARE_STATIC_KEY_FALSE(cn10k_ipsec_sa_enabled);
 
@@ -302,6 +303,18 @@ struct cpt_sg_s {
 	u64 rsvd_63_50	: 14;
 };
 
+/* CPT Parse Header Structure for Inbound packets */
+struct cpt_parse_hdr_s {
+	u64 w0;
+	u64 w1;
+	u64 w2;
+	u64 w3;
+};
+
+/* Macros to get specific fields from CPT_PARSE_HDR_S*/
+#define CPT_PARSE_HDR_W0_COOKIE		GENMASK_ULL(63, 32)
+#define CPT_PARSE_HDR_W1_WQE_PTR	GENMASK_ULL(63, 0)
+
 /* CPT LF_INPROG Register */
 #define CPT_LF_INPROG_INFLIGHT	GENMASK_ULL(8, 0)
 #define CPT_LF_INPROG_GRB_CNT	GENMASK_ULL(39, 32)
@@ -330,6 +343,9 @@ bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 			  struct otx2_snd_queue *sq, struct sk_buff *skb,
 			  int num_segs, int size);
 void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf);
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct sk_buff *skb,
+						     dma_addr_t seg_addr);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -366,5 +382,12 @@ void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
 {
 }
 
+static inline __maybe_unused
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct sk_buff *skb,
+						     dma_addr_t seg_addr)
+{
+	return NULL;
+}
 #endif
 #endif // CN10K_IPSEC_H
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
index 625bb5a05344..6cffc60a443c 100644
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
 
@@ -333,6 +338,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 				 struct nix_cqe_rx_s *cqe, bool *need_xdp_flush)
 {
 	struct nix_rx_parse_s *parse = &cqe->parse;
+	struct nix_wqe_rx_s *orig_pkt_wqe = NULL;
+	u32 desc_sizem1 = parse->desc_sizem1;
 	struct nix_rx_sg_s *sg = &cqe->sg;
 	struct sk_buff *skb = NULL;
 	u64 *word = (u64 *)parse;
@@ -359,8 +366,26 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
+	if (parse->chan & 0x800) {
+		orig_pkt_wqe = cn10k_ipsec_process_cpt_metapkt(pfvf, skb, sg->seg_addr);
+		if (!orig_pkt_wqe) {
+			netdev_err(pfvf->netdev, "Invalid WQE in CPT metapacket\n");
+			napi_free_frags(napi);
+			cq->pool_ptrs++;
+			return;
+		}
+		/* Return metapacket buffer back to pool since it's no longer needed */
+		otx2_free_rcv_seg(pfvf, cqe, cq->cq_idx);
+
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
 	while (start < end) {
 		sg = (struct nix_rx_sg_s *)start;
 		seg_addr = &sg->seg_addr;
-- 
2.43.0

