Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24732248A4;
	Sun, 26 Oct 2025 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491435; cv=none; b=BoIBBq46+mGioU7mTL5b4o24QK6wh9Oew+fsrUoOj1EKzET51tBBla7HHJztYDbG3OoQj9m/UaotE2zZiYG8OCZYq7as5qkIifS6GHoJ+yXytLgg8npDMU7+E/VAUWDHXX70s4O0hk5xAVG3jHPXvidNnPy5gHvzK3nfvAPepvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491435; c=relaxed/simple;
	bh=hNOMFN4eGKGdsXUAxPfIwMXaD4WQS8H7DpEvNBH3rzw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H7kDaBpzAeIjvCNDpwPMFmsc/TMJG36vWcFqsEO30LO6XCjyEKRrah0JFBhE6sNnZTscnJiqyJrOmTMAcFUDo74n2b39t6O0F0BxW5hYJkKS1VhEduOIVucj7s03LFy0SrFzTFY8gG7GE4Fs3VfA/obnNNuroTRCvwC3bVqHyjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ezGbV7/5; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ezGbV7/5"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QDWx8d3735070;
	Sun, 26 Oct 2025 08:10:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=s
	fNHow/K28Z5TLsQ8KhGgYJxLp4EXa0aZJhOYxQjOww=; b=ezGbV7/5hdidMDQCI
	1I4OVV/kMuqmLir61Xnii0Wax3Xmu7J+390g2+PndccnSrlrpZDCQmfdUwdyWLTy
	CoyqxJ9eHNJezh1NgcYiT692Ceov/70IClFNGeSsQO9yzd4ckTYHk2XKcA9gQOJt
	kn4P24l2Jhwa3nO9Xb1E9E19E04yNx3n7qNP/ru3mdamYr5nIG3GsmigLz1AntGd
	uidRJSSf7yIuS+tJ+xchac78w9Or7YzG9Q45BDUExnQTHc5+0kao+0iUPPQEAC8O
	/NbKlI4o7oObwWiTFer/fjEJsC7q+gCPA+q4Mu2i9XjKGzpX3qvCsssBCrgyBLK9
	4O28w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a1fa5rfwy-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:28 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:36 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id E56F03F70DF;
	Sun, 26 Oct 2025 08:10:23 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 09/15] octeontx2-pf: ipsec: Allocate Ingress SA table
Date: Sun, 26 Oct 2025 20:39:04 +0530
Message-ID: <20251026150916.352061-10-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfXyf0gg3Me3VlL
 UYMcStH8CtZR6H+DT0UrNzcrkpkx+FGaWqcYgyX5PYfh/cHAd91lTztiI7H4GVGrM1YaYKG6xjV
 +jutfeLml+USM3LA7v6V5d3WrDyZR/BIMeBExg6tgNsNNwPU1sfsbTVGEc616OUaApSzsEvuVv4
 +Z/okCpb7z1CdZXkyo1MmnlX/I6BQmiy+CeCCyxX/DHl/VMGlq8XpDNpy72gUVE/uUx/Yf+gLik
 r7WW1QeZ+qsm8gjF8WHrhb0kA4/qFKt+rWJugX/ekiSTuulXVqvncCQ5wQ93K5NB8kO6UTDhaNS
 Rg3uERQU/YNpa88tQcUqqnMywZGHb+LC3/z10A0Kfu2aMUpHDWcbxGLLsvhQp0jPJmfu65qlbU8
 oG8SwYV0jmy9zzFKM40Isl/+Pz13Ng==
X-Authority-Analysis: v=2.4 cv=VOnQXtPX c=1 sm=1 tr=0 ts=68fe39e4 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=941-y9MuI4qzQJ12ibkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: h-cipH3EiS2osKto6BK9FK0MJLU1Fl6s
X-Proofpoint-ORIG-GUID: h-cipH3EiS2osKto6BK9FK0MJLU1Fl6s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

Every NIX LF has the facility to maintain a contiguous SA table that
is used by NIX RX to find the exact SA context pointer associated with
a particular flow. Allocate a 128-entry SA table where each entry is of
2048 bytes which is enough to hold the complete inbound SA context.

Add the structure definitions for SA context (cn10k_rx_sa_s) and
SA bookkeeping information (ctx_inb_ctx_info).

Also, initialize the inb_sw_ctx_list to track all the SA's and their
associated NPC rules and hash table related data.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- None

Changes in V4:
- None

Changes in V3:
- None

Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-10-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-9-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-9-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-9-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 23 ++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       | 92 +++++++++++++++++++
 2 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index e2abdac27ba5..3e4cdd6bac6c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -468,6 +468,19 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	int ret = 0, spb_cnt;
 
+	/* Set sa_tbl_entry_sz to 2048 since we are programming NIX RX
+	 * to calculate SA index as SPI * 2048. The first 1024 bytes
+	 * are used for SA context and  the next half for bookkeeping data.
+	 */
+	pfvf->ipsec.sa_tbl_entry_sz = 2048;
+	ret = qmem_alloc(pfvf->dev, &pfvf->ipsec.inb_sa, CN10K_IPSEC_INB_MAX_SA,
+			 pfvf->ipsec.sa_tbl_entry_sz);
+	if (ret)
+		return ret;
+
+	memset(pfvf->ipsec.inb_sa->base, 0,
+	       pfvf->ipsec.sa_tbl_entry_sz * CN10K_IPSEC_INB_MAX_SA);
+
 	/* Allocate SPB buffer count array to track the number of inbound SPB
 	 * buffers received per RX queue. This count would later be used to
 	 * refill the first pass IPsec pool.
@@ -933,6 +946,9 @@ static void cn10k_ipsec_free_hw_resources(struct otx2_nic *pfvf)
 	/* Free the per spb pool buffer counters */
 	devm_kfree(pfvf->dev, pfvf->ipsec.inb_spb_count);
 
+	/* Free the inbound SA table */
+	qmem_free(pfvf->dev, pfvf->ipsec.inb_sa);
+
 	cn10k_ipsec_free_aura_ptrs(pfvf);
 }
 
@@ -961,8 +977,8 @@ int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
 		return ret;
 	}
 
-	/* Don't do CPT cleanup if SA installed */
-	if (!pf->ipsec.outb_sa_count) {
+	/* Don't cleanup CPT if any inbound or outbound SA is installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list) && !pf->ipsec.outb_sa_count) {
 		netdev_err(pf->netdev, "SA installed on this device\n");
 		return -EBUSY;
 	}
@@ -987,6 +1003,9 @@ int cn10k_ipsec_init(struct net_device *netdev)
 			 OTX2_ALIGN : sizeof(struct cn10k_tx_sa_s);
 	pf->ipsec.sa_size = sa_size;
 
+	/* List to track all ingress SAs */
+	INIT_LIST_HEAD(&pf->ipsec.inb_sw_ctx_list);
+
 	INIT_WORK(&pf->ipsec.sa_work, cn10k_ipsec_sa_wq_handler);
 	pf->ipsec.sa_workq = alloc_workqueue("cn10k_ipsec_sa_workq",
 					     WQ_PERCPU, 0);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 78baddb9ffda..8ef67f1f0e3d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -52,10 +52,14 @@ DECLARE_STATIC_KEY_FALSE(cn10k_ipsec_sa_enabled);
 #define CN10K_CPT_LF_NQX(a)		(CPT_LFBASE | 0x400 | (a) << 3)
 #define CN10K_CPT_LF_CTX_FLUSH		(CPT_LFBASE | 0x510)
 
+/* Maximum Inbound SAs */
+#define CN10K_IPSEC_INB_MAX_SA	2048
+
 /* IPSEC Instruction opcodes */
 #define CN10K_IPSEC_MAJOR_OP_WRITE_SA 0x01UL
 #define CN10K_IPSEC_MINOR_OP_WRITE_SA 0x09UL
 #define CN10K_IPSEC_MAJOR_OP_OUTB_IPSEC 0x2AUL
+#define CN10K_IPSEC_MAJOR_OP_INB_IPSEC 0x29UL
 
 enum cn10k_cpt_comp_e {
 	CN10K_CPT_COMP_E_NOTDONE = 0x00,
@@ -81,6 +85,19 @@ enum cn10k_cpt_hw_state_e {
 	CN10K_CPT_HW_IN_USE
 };
 
+struct cn10k_inb_sw_ctx_info {
+	struct list_head list;
+	struct cn10k_rx_sa_s *sa_entry;
+	struct xfrm_state *x_state;
+	dma_addr_t sa_iova;
+	u32 npc_mcam_entry;
+	u32 sa_index;
+	__be32 spi;
+	u16 hash_index;	/* Hash index from SPI_TO_SA match */
+	u8 way;		/* SPI_TO_SA match table way index */
+	bool delete_npc_and_match_entry;
+};
+
 struct cn10k_ipsec {
 	/* Outbound CPT */
 	u64 io_addr;
@@ -98,6 +115,11 @@ struct cn10k_ipsec {
 	u16 inb_ipsec_pool;
 	u16 inb_ipsec_spb_pool;
 	atomic_t *inb_spb_count;
+
+	u32 sa_tbl_entry_sz;
+	struct qmem *inb_sa;
+	struct list_head inb_sw_ctx_list;
+	DECLARE_BITMAP(inb_sa_table, CN10K_IPSEC_INB_MAX_SA);
 };
 
 /* CN10K IPSEC Security Association (SA) */
@@ -152,6 +174,76 @@ struct cn10k_tx_sa_s {
 	u64 hw_ctx[6];		/* W31 - W36 */
 };
 
+struct cn10k_rx_sa_s {
+	u64 inb_ar_win_sz	: 3; /* W0 */
+	u64 hard_life_dec	: 1;
+	u64 soft_life_dec	: 1;
+	u64 count_glb_octets	: 1;
+	u64 count_glb_pkts	: 1;
+	u64 count_mib_bytes	: 1;
+	u64 count_mib_pkts	: 1;
+	u64 hw_ctx_off		: 7;
+	u64 ctx_id		: 16;
+	u64 orig_pkt_fabs	: 1;
+	u64 orig_pkt_free	: 1;
+	u64 pkind		: 6;
+	u64 rsvd_w0_40		: 1;
+	u64 eth_ovrwr		: 1;
+	u64 pkt_output		: 2;
+	u64 pkt_format		: 1;
+	u64 defrag_opt		: 2;
+	u64 x2p_dst		: 1;
+	u64 ctx_push_size	: 7;
+	u64 rsvd_w0_55		: 1;
+	u64 ctx_hdr_size	: 2;
+	u64 aop_valid		: 1;
+	u64 rsvd_w0_59		: 1;
+	u64 ctx_size		: 4;
+
+	u64 rsvd_w1_31_0	: 32; /* W1 */
+	u64 cookie		: 32;
+
+	u64 sa_valid		: 1; /* W2 Control Word */
+	u64 sa_dir		: 1;
+	u64 rsvd_w2_2_3		: 2;
+	u64 ipsec_mode		: 1;
+	u64 ipsec_protocol	: 1;
+	u64 aes_key_len		: 2;
+	u64 enc_type		: 3;
+	u64 life_unit		: 1;
+	u64 auth_type		: 4;
+	u64 encap_type		: 2;
+	u64 et_ovrwr_ddr_en	: 1;
+	u64 esn_en		: 1;
+	u64 tport_l4_incr_csum	: 1;
+	u64 iphdr_verify	: 2;
+	u64 udp_ports_verify	: 1;
+	u64 l2_l3_hdr_on_error	: 1;
+	u64 rsvd_w25_31		: 7;
+	u64 spi			: 32;
+
+	u64 w3;			/* W3 */
+
+	u8 cipher_key[32];	/* W4 - W7 */
+	u32 rsvd_w8_0_31;	/* W8 : IV */
+	u32 iv_gcm_salt;
+	u64 rsvd_w9;		/* W9 */
+	u64 rsvd_w10;		/* W10 : UDP Encap */
+	u32 dest_ipaddr;	/* W11 - Tunnel mode: outer src and dest ipaddr */
+	u32 src_ipaddr;
+	u64 rsvd_w12_w30[19];	/* W12 - W30 */
+
+	u64 ar_base;		/* W31 */
+	u64 ar_valid_mask;	/* W32 */
+	u64 hard_sa_life;	/* W33 */
+	u64 soft_sa_life;	/* W34 */
+	u64 mib_octs;		/* W35 */
+	u64 mib_pkts;		/* W36 */
+	u64 ar_winbits;		/* W37 */
+
+	u64 rsvd_w38_w100[63];
+};
+
 /* CPT instruction parameter-1 */
 #define CN10K_IPSEC_INST_PARAM1_DIS_L4_CSUM		0x1
 #define CN10K_IPSEC_INST_PARAM1_DIS_L3_CSUM		0x2
-- 
2.43.0

