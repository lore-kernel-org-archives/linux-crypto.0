Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79842E8DEE;
	Wed, 18 Jun 2025 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246296; cv=none; b=PG9OrjD8CTa5YG9jsRpqQg7oBR4s+XrWVUVpN/7dhbFk9onug1d/J0MVdPX+WoOCcXIoe93WLtO4NuZxI/4e/w+gV9ikUH5Fy1LdcVNicciyzHcH2uKC0qsmdu2A3bljR0UP9r9DReOz9mkHi7RxeQ6UB7cPwE7EqYN4pru3m3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246296; c=relaxed/simple;
	bh=CV+TVRzOwmCKt5S/eKHL+ZZJLaKFwT4f5qNATDVxcBk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhXFrjtTug1BOpH/XGkUd8sdqImmyHA1uoRmcqr0S5fSiWy4pfMtYGFFZXS4vIQgjQDhbLeUfwLNoQKE4IOLIWly8RcPfDO10mOy2XUUNQAw8REBrDL3bSAaZ/jXo3A2eFP8SlcJI1CdwYzksTvxSmo2VSheKWqhZvEVnkSxyuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FnDjiCdZ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FnDjiCdZ"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7qnJr023248;
	Wed, 18 Jun 2025 04:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	ilTK+Pe1WM4fcLlDnWP1S/XObgmJEQS46gTQd9Pt4A=; b=FnDjiCdZHU9TOAKRj
	dD+TYvLOtFkNx3gGyeBi7/3Egl43WQ7ptkU2xsbuwPxk6kuYHAVgj/igYaOnZB5L
	hIFiAFtX/XLjCB18b5tcH6OvOOchSar91unceyduGO8XPUfB2TQDCm63KYHe/e/7
	vGqJCcAxPyJrz8g+3IuWTRqinL+7kYkrFj3uESOg3usd8tGaK8BkJ1qmBBGl0VB4
	4UcJmzdiOOpjymlzSPvDgGHvoSSVG+JioHU5fTSkpNQyXI8/1kZDcAJ0NK5zG9dt
	/blmf7kyvqb0ll82nL3VWJd4MRUDzvY08Pe7DekE2hNuOFkLKpIejnoYgWTsnflR
	3hraA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bsf2redd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:12 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 273F93F7048;
	Wed, 18 Jun 2025 04:31:08 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 08/14] octeontx2-pf: ipsec: Allocate Ingress SA table
Date: Wed, 18 Jun 2025 17:00:02 +0530
Message-ID: <20250618113020.130888-9-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: cS3zoXCpFS2g5drkJjme4YNy5LWWxzJt
X-Proofpoint-GUID: cS3zoXCpFS2g5drkJjme4YNy5LWWxzJt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5OCBTYWx0ZWRfX7Cox5mYSBESj 5H/raG81XKmvdQRp+UFwjDzZVDhPgLgfxa19Efx5cdZgKZZNV7BlTjIjIh8y/A72us5s8MqvvKu LGhzkIlg5h9BZKLg8NyurE+PJHNu7+fy/sdOlnbTvyzhKeOTt1s25IsVUBhqUy6bNm0aQ0mkxDb
 pyZ6M6bqZBlC/PZLuJ8WYnUrX8dGHy6abq/4GKg6tlGRrLsB9c1923UzGm5bedUduZnqdfNkTiv 7eXZA4mWXedzyi3xt+QxHB7N2BcRwKoRwS/4MMilgRKycw2bGV7c6thi4zwShmip/o85FeXuagl 5MlYuJqUgM24u/NOj70vl2bZUY0FvAyy+CGpbEgu/crdQ31H/GI6lZyqwZj2nQhqT6NQASs2kSd
 amQBBxsGERyzXu2zYKkUF+GF9JoIpy6goEAXO3Fu+OpG8xoIzKY/r9FN6MvZZHniRDcAx/Iu
X-Authority-Analysis: v=2.4 cv=Yu4PR5YX c=1 sm=1 tr=0 ts=6852a38b cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=ShQPJPp02mSZ9WD1TkIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

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
Changes in V2:
- None

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-10-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 20 ++++
 .../marvell/octeontx2/nic/cn10k_ipsec.h       | 93 +++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index c691f0722154..ae2aa0b73e96 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -787,6 +787,7 @@ int cn10k_ipsec_init(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 	u32 sa_size;
+	int err;
 
 	if (!is_dev_support_ipsec_offload(pf->pdev))
 		return 0;
@@ -797,6 +798,22 @@ int cn10k_ipsec_init(struct net_device *netdev)
 			 OTX2_ALIGN : sizeof(struct cn10k_tx_sa_s);
 	pf->ipsec.sa_size = sa_size;
 
+	/* Set sa_tbl_entry_sz to 2048 since we are programming NIX RX
+	 * to calculate SA index as SPI * 2048. The first 1024 bytes
+	 * are used for SA context and  the next half for bookkeeping data.
+	 */
+	pf->ipsec.sa_tbl_entry_sz = 2048;
+	err = qmem_alloc(pf->dev, &pf->ipsec.inb_sa, CN10K_IPSEC_INB_MAX_SA,
+			 pf->ipsec.sa_tbl_entry_sz);
+	if (err)
+		return err;
+
+	memset(pf->ipsec.inb_sa->base, 0,
+	       pf->ipsec.sa_tbl_entry_sz * CN10K_IPSEC_INB_MAX_SA);
+
+	/* List to track all ingress SAs */
+	INIT_LIST_HEAD(&pf->ipsec.inb_sw_ctx_list);
+
 	INIT_WORK(&pf->ipsec.sa_work, cn10k_ipsec_sa_wq_handler);
 	pf->ipsec.sa_workq = alloc_workqueue("cn10k_ipsec_sa_workq", 0, 0);
 	if (!pf->ipsec.sa_workq) {
@@ -828,6 +845,9 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 	}
 
 	cn10k_outb_cpt_clean(pf);
+
+	/* Free Ingress SA table */
+	qmem_free(pf->dev, pf->ipsec.inb_sa);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 43fbce0d6039..7ffbbedf26d5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -52,10 +52,14 @@ DECLARE_STATIC_KEY_FALSE(cn10k_ipsec_sa_enabled);
 #define CN10K_CPT_LF_NQX(a)		(CPT_LFBASE | 0x400 | (a) << 3)
 #define CN10K_CPT_LF_CTX_FLUSH		(CPT_LFBASE | 0x510)
 
+/* Inbound SA*/
+#define CN10K_IPSEC_INB_MAX_SA	128
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
@@ -92,6 +109,12 @@ struct cn10k_ipsec {
 	u32 outb_sa_count;
 	struct work_struct sa_work;
 	struct workqueue_struct *sa_workq;
+
+	/* For Inbound Inline IPSec flows */
+	u32 sa_tbl_entry_sz;
+	struct qmem *inb_sa;
+	struct list_head inb_sw_ctx_list;
+	DECLARE_BITMAP(inb_sa_table, CN10K_IPSEC_INB_MAX_SA);
 };
 
 /* CN10K IPSEC Security Association (SA) */
@@ -146,6 +169,76 @@ struct cn10k_tx_sa_s {
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

