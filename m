Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A749723E35E;
	Fri,  2 May 2025 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192268; cv=none; b=kY92opFvgN+E3VY8MpULoHE1a7FTPKJY3CjZ1uqAOgrGCu8WxwPVrbN56uS/GRlVqfqFAmbC7rsrKmtEMdnlw/j/c7LS+cDR8Ee7ULdH0o45kvbHjdbSSg+ipHm7JIC2pB9jkzr/IK/VIBzfQD+FvDgS2ApbhrQ+eoZeLf6YeAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192268; c=relaxed/simple;
	bh=+RM0f3CV+cEUi8eokXdWyADFznYU6I6nZXEoPA18dn4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKv1EvYcVRlMp5PN7+yJ2SLZ05EGo3C3RP2MsyC0CuEPmDkrPs4x9zmbsIO1cM7AYJyIMLRRQY4/Ir525ioi/9sWS+4m7HJGD5ozO2R6mZoOPoqswhNnhz/9/9G5e64hll8glI59jaaFhU2wK9SjEDpanbuRbAmkA04Bm4QhzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EtxdpzMi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EtxdpzMi"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542A3i0S023658;
	Fri, 2 May 2025 06:24:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	JqmDA/vK7XCoPmevuOIhotplQ8cxVT6SVbCsyZCZ58=; b=EtxdpzMi3TFYkkhvj
	JRyStrPBqGfIpouFhDi+vchjminFGu3iHAy0AE6MvycmSMKMYFdCTgoes5JUAbmh
	6YFNpwed7a++y93EVWt3S1ROdcdMjfOrNEbWfKngLurfALmfTpxCggPzSAxJpyRH
	WBs0U+i5L9HggIT63OF5hY7YseyNPdkkdkdwx5jb90iYMShymE6hqPuoXEhFguxw
	CkojTTamYtkMufak3OnLvLWnxaY8tSZbQWLpdTOGsHiQbAC5sBk6X1sZakqBjrsJ
	87XpJ2Kcy09V705HIrN/XGK/48gbJZyCbwfdmvL7HPv9kFrVMf7sPwi50CiuGdSb
	RkWag==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cutur9h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:24:12 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:24:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:24:11 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id F0E663F7041;
	Fri,  2 May 2025 06:23:59 -0700 (PDT)
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
        <gcherian@marvell.com>, Tanmay Jagdale <tanmay@marvell.com>
Subject: [net-next PATCH v1 14/15] octeontx2-pf: ipsec: Process CPT metapackets
Date: Fri, 2 May 2025 18:49:55 +0530
Message-ID: <20250502132005.611698-15-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: wfZedJ0U8BnNR-vor4ynbGd3rT26no7W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX8cPK87mAi0Zg PM0YJrbd3NjN5HB6v/R68G28v5xI4UIaSPOjt1+8RpHzA+scnU/z0J+rOmUSSV4P6B3BoWbXDJI EebRuNINYm00l6ZfLK1HUck2x6i6uitKtupuA9Q9FqT+KCLtxNKcj9ZIPvrczgWYrOJ/+QFDCgC
 HFCl+RULyBarCcHcP2HbAXTFoBGACzEagjsUxfqFB5cFSI22lTkKs7Z0WwHlKCQxKIJau2f+0YX 7D/tkGphar1P+CN9/QuT9lEq9pmWmD8pfNxILnyuW8Z1u9131woUNpSBkhGnYaa3ix75FdYwB7B bR8IL6j6Kff1zzMJhReYl8YX95HOibm6I3nUIrsfyW5ys/XdaLobfvCFMJdf3kxxWJJpyLyOUh6
 xFGguTqfmSPzbStbHZijZIJJASgvr1uUKSGYNUULP0YhD1hZ0ne48w/IyTSONyE8BO8rWwNL
X-Authority-Analysis: v=2.4 cv=BaPY0qt2 c=1 sm=1 tr=0 ts=6814c77c cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=eJ26ZJIWB3iPADzCtwIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: wfZedJ0U8BnNR-vor4ynbGd3rT26no7W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

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
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 61 +++++++++++++++++++
 .../marvell/octeontx2/nic/cn10k_ipsec.h       | 47 ++++++++++++++
 .../marvell/octeontx2/nic/otx2_struct.h       | 16 +++++
 .../marvell/octeontx2/nic/otx2_txrx.c         | 25 +++++++-
 4 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 91c8f13b6e48..bebf5cdedee4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,67 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct nix_rx_sg_s *sg,
+						     struct sk_buff *skb,
+						     int qidx)
+{
+	struct nix_wqe_rx_s *wqe = NULL;
+	u64 *seg_addr = &sg->seg_addr;
+	struct cpt_parse_hdr_s *cptp;
+	struct xfrm_offload *xo;
+	struct otx2_pool *pool;
+	struct xfrm_state *xs;
+	struct sec_path *sp;
+	u64 *va_ptr;
+	void *va;
+	int i;
+
+	/* CPT_PARSE_HDR_S is present in the beginning of the buffer */
+	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, *seg_addr));
+
+	/* Convert CPT_PARSE_HDR_S from BE to LE */
+	va_ptr = (u64 *)va;
+	for (i = 0; i < (sizeof(struct cpt_parse_hdr_s) / sizeof(u64)); i++)
+		va_ptr[i] = be64_to_cpu(va_ptr[i]);
+
+	cptp = (struct cpt_parse_hdr_s *)va;
+
+	/* Convert the wqe_ptr from CPT_PARSE_HDR_S to a CPU usable pointer */
+	wqe = (struct nix_wqe_rx_s *)phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
+								    cptp->wqe_ptr));
+
+	/* Get the XFRM state pointer stored in SA context */
+	va_ptr = pfvf->ipsec.inb_sa->base +
+		(cptp->cookie * pfvf->ipsec.sa_tbl_entry_sz) + 1024;
+	xs = (struct xfrm_state *)*va_ptr;
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
+	/* Free the metapacket memory here since it's not needed anymore */
+	pool = &pfvf->qset.pool[qidx];
+	otx2_free_bufs(pfvf, pool, *seg_addr - OTX2_HEAD_ROOM, pfvf->rbsize);
+	return wqe;
+}
+
 static int cn10k_inb_alloc_mcam_entry(struct otx2_nic *pfvf,
 				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index aad5ebea64ef..68046e377486 100644
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
@@ -330,6 +366,10 @@ bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 			  struct otx2_snd_queue *sq, struct sk_buff *skb,
 			  int num_segs, int size);
 void cn10k_ipsec_inb_disable_flows(struct otx2_nic *pf);
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct nix_rx_sg_s *sg,
+						     struct sk_buff *skb,
+						     int qidx);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -366,5 +406,12 @@ cn10k_ipsec_inb_delete_flows(struct otx2_nic *pf)
 {
 }
 
+struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
+						     struct nix_rx_sg_s *sg,
+						     struct sk_buff *skb,
+						     int qidx)
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
index 9593627b35a3..e9d0e27ffd0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -205,6 +205,9 @@ static bool otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 		}
 	}
 
+	if (parse->chan & 0x800)
+		off = 0;
+
 	page = virt_to_page(va);
 	if (likely(skb_shinfo(skb)->nr_frags < MAX_SKB_FRAGS)) {
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
@@ -333,6 +336,7 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 				 struct nix_cqe_rx_s *cqe, bool *need_xdp_flush)
 {
 	struct nix_rx_parse_s *parse = &cqe->parse;
+	struct nix_wqe_rx_s *orig_pkt_wqe = NULL;
 	struct nix_rx_sg_s *sg = &cqe->sg;
 	struct sk_buff *skb = NULL;
 	void *end, *start;
@@ -355,8 +359,25 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
-	start = (void *)sg;
-	end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
+	if (parse->chan & 0x800) {
+		orig_pkt_wqe = cn10k_ipsec_process_cpt_metapkt(pfvf, sg, skb, cq->cq_idx);
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
+		start = (void *)sg;
+		end = start + ((orig_pkt_wqe->parse.desc_sizem1 + 1) * 16);
+	} else {
+		start = (void *)sg;
+		end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
+	}
+
 	while (start < end) {
 		sg = (struct nix_rx_sg_s *)start;
 		seg_addr = &sg->seg_addr;
-- 
2.43.0

