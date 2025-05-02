Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED593254AF2;
	Fri,  2 May 2025 13:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192294; cv=none; b=CyWJ8dI6A/57h105AhreTWmiP+Zg+/7L6r7TvgxtRUdnlVOl7RXLtTLEkk1ONMhaNcU9geMx4sCwdD1YfMjXwI4nfmxBWG+hzyGHnC7fe8KStr/WUvRWxsPQG+cRbOKO47bEd/CNLUVAXxdGEnKeYh/uY1B/AnjzwqIrqQp2dRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192294; c=relaxed/simple;
	bh=wvmlMbtOarE9caNEUaIOli+1n8K+SsmegETHweI9bV8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEi9iUmQJdqka66By4xO6n2ymfCUjArcXDxE+aGjFhHY7zieiQdD609kSEdaE784TZZIHi42hHvo0kZhEtYnE0nWDTrXy9j4uLRltGZhUxgpUk9X7XkS6lQO4Fm6smTPjBxTTGBadbPSco1GEhYEBVqyaf7Fg60Iwq8/+qW8xvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=V3KH1ewl; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="V3KH1ewl"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5429m2mT008278;
	Fri, 2 May 2025 06:24:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	nZ2uFQB7LUIZpdev28ZB021s3dVPX7/1B0zoHXEVIc=; b=V3KH1ewlZKCwuekXR
	y7ecXHQJbQzaSsLEZSd1MwghFIEYtHKgtkQgYdWLwsOX2flupWNvLN2M1gx7l2HF
	6kaXS+MpAMIXaRYn/z7Np9IB6GtWyuhI1TTRnvkqqCAbqO5Jd1d67DNjJaRK+F3Z
	8N4AntCw8X1UspQf9fLHTwcjZsGHxdJfQiUC2GVbaZug/gSSDs4PsZQqzrLiiDk5
	NFf0patzIb1aTsbWi+LMfX/IXTWPD5/xz0OUzKUsgjEuBa6/tb+f6/uSOmKiF3Ep
	Jq45PZw3Y+FixsdIPtAfE3DhgNwKBGSpwGmFUaW6joNdQL70/pCICFMX0osPssUX
	r+QCQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cuqyr9ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:24:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:24:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:24:24 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 7FE6A3F7041;
	Fri,  2 May 2025 06:24:12 -0700 (PDT)
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
Subject: [net-next PATCH v1 15/15] octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
Date: Fri, 2 May 2025 18:49:56 +0530
Message-ID: <20250502132005.611698-16-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: jfyytFcmRtj4ci4CCmOrK2LIsXbPn3GU
X-Authority-Analysis: v=2.4 cv=JvPxrN4C c=1 sm=1 tr=0 ts=6814c78a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=cBXoo_FVw3z3HtC9pokA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: jfyytFcmRtj4ci4CCmOrK2LIsXbPn3GU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX3fB/piCS6GWC n7xrjmi85F5JtW3EsgIOzzBXpasHvBjeJ2eJsY9US4ZyAp9rDSLOMjOwszf23EjYrMplzua892M ThQJgvA2V+GSGpkZ+f+xzAroU1xuFMf4qRxh0DdFX8TIHma6q57C5iuPoADjLYy4ZvH2Us8mGGf
 ZblcVE99vcuqB2L/KtntEjxfGEgTND4o7LU3zfoE//A11lDNfXlFtP6EbckmKq+IUju7I83pQcr YeK85/nSmg3iLHIHaqJ8dYepE8//oVpQT81fM1iVqluOF9D+pTBkEZTr6ZUO2i+Hge2m2tYKVkf H329Z3Gci+HYDRSAaFm5T1/b0WHe6ihb0uZXUZZlKeR98KeLmImYlz6qR7HF4QWHXgH+TgCe1sg
 p4SvdFpXvpd3LIdQFYDL02wU4B6lqFNqG2CnXbIHZe3v4t2a+JQXnqdU9bVyR39YyV7yCcVe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

Add XFRM state hook for inbound flows and configure the following:
  - Install an NPC rule to classify the 1st pass IPsec packets and
    direct them to the dedicated RQ
  - Allocate a free entry from the SA table and populate it with the
    SA context details based on xfrm state data.
  - Create a mapping of the SPI value to the SA table index. This is
    used by NIXRX to calculate the exact SA context  pointer address
    based on the SPI in the packet.
  - Prepare the CPT SA context to decrypt buffer in place and the
    write it the CPT hardware via LMT operation.
  - When the XFRM state is deleted, clear this SA in CPT hardware.

Also add XFRM Policy hooks to allow successful offload of inbound
PACKET_MODE.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 449 ++++++++++++++++--
 1 file changed, 419 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index bebf5cdedee4..6441598c7e0f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -448,7 +448,7 @@ static int cn10k_inb_alloc_mcam_entry(struct otx2_nic *pfvf,
 	return err;
 }
 
-static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
+static int cn10k_inb_install_flow(struct otx2_nic *pfvf,
 				  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
 {
 	struct npc_install_flow_req *req;
@@ -463,14 +463,14 @@ static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
 	}
 
 	req->entry = inb_ctx_info->npc_mcam_entry;
-	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI) | BIT(NPC_DMAC);
+	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI);
 	req->intf = NIX_INTF_RX;
 	req->index = pfvf->ipsec.inb_ipsec_rq;
 	req->match_id = 0xfeed;
 	req->channel = pfvf->hw.rx_chan_base;
 	req->op = NIX_RX_ACTIONOP_UCAST_IPSEC;
 	req->set_cntr = 1;
-	req->packet.spi = x->id.spi;
+	req->packet.spi = inb_ctx_info->spi;
 	req->mask.spi = 0xffffffff;
 
 	/* Send message to AF */
@@ -993,7 +993,7 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
 	 */
 	list_for_each_entry(inb_ctx_info, &pfvf->ipsec.inb_sw_ctx_list, list) {
 		cn10k_inb_ena_dis_flow(pfvf, inb_ctx_info, false);
-		cn10k_inb_install_flow(pfvf, inb_ctx_info->x_state, inb_ctx_info);
+		cn10k_inb_install_flow(pfvf, inb_ctx_info);
 		cn10k_inb_install_spi_to_sa_match_entry(pfvf,
 							inb_ctx_info->x_state,
 							inb_ctx_info);
@@ -1035,6 +1035,19 @@ static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
 	return ret;
 }
 
+static u32 cn10k_inb_alloc_sa(struct otx2_nic *pf, struct xfrm_state *x)
+{
+	u32 sa_index = 0;
+
+	sa_index = find_first_zero_bit(pf->ipsec.inb_sa_table, CN10K_IPSEC_INB_MAX_SA);
+	if (sa_index >= CN10K_IPSEC_INB_MAX_SA)
+		return sa_index;
+
+	set_bit(sa_index, pf->ipsec.inb_sa_table);
+
+	return sa_index;
+}
+
 static void cn10k_cpt_inst_flush(struct otx2_nic *pf, struct cpt_inst_s *inst,
 				 u64 size)
 {
@@ -1149,6 +1162,137 @@ static int cn10k_outb_write_sa(struct otx2_nic *pf, struct qmem *sa_info)
 	return ret;
 }
 
+static int cn10k_inb_write_sa(struct otx2_nic *pf,
+			      struct xfrm_state *x,
+			      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	dma_addr_t res_iova, dptr_iova, sa_iova;
+	struct cn10k_rx_sa_s *sa_dptr, *sa_cptr;
+	struct cpt_inst_s inst;
+	u32 sa_size, off;
+	struct cpt_res_s *res;
+	u64 reg_val;
+	int ret;
+
+	res = dma_alloc_coherent(pf->dev, sizeof(struct cpt_res_s),
+				 &res_iova, GFP_ATOMIC);
+	if (!res)
+		return -ENOMEM;
+
+	sa_cptr = inb_ctx_info->sa_entry;
+	sa_iova = inb_ctx_info->sa_iova;
+	sa_size = sizeof(struct cn10k_rx_sa_s);
+
+	sa_dptr = dma_alloc_coherent(pf->dev, sa_size, &dptr_iova, GFP_ATOMIC);
+	if (!sa_dptr) {
+		dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res,
+				  res_iova);
+		return -ENOMEM;
+	}
+
+	for (off = 0; off < (sa_size / 8); off++)
+		*((u64 *)sa_dptr + off) = cpu_to_be64(*((u64 *)sa_cptr + off));
+
+	memset(&inst, 0, sizeof(struct cpt_inst_s));
+
+	res->compcode = 0;
+	inst.res_addr = res_iova;
+	inst.dptr = (u64)dptr_iova;
+	inst.param2 = sa_size >> 3;
+	inst.dlen = sa_size;
+	inst.opcode_major = CN10K_IPSEC_MAJOR_OP_WRITE_SA;
+	inst.opcode_minor = CN10K_IPSEC_MINOR_OP_WRITE_SA;
+	inst.cptr = sa_iova;
+	inst.ctx_val = 1;
+	inst.egrp = CN10K_DEF_CPT_IPSEC_EGRP;
+
+	/* Re-use Outbound CPT LF to install Ingress SAs as well because
+	 * the driver does not own the ingress CPT LF.
+	 */
+	pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf, CN10K_CPT_LF_NQX(0));
+	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
+	dmb(sy);
+
+	ret = cn10k_wait_for_cpt_respose(pf, res);
+	if (ret)
+		goto out;
+
+	/* Trigger CTX flush to write dirty data back to DRAM */
+	reg_val = FIELD_PREP(GENMASK_ULL(45, 0), sa_iova >> 7);
+	otx2_write64(pf, CN10K_CPT_LF_CTX_FLUSH, reg_val);
+
+out:
+	dma_free_coherent(pf->dev, sa_size, sa_dptr, dptr_iova);
+	dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res, res_iova);
+	return ret;
+}
+
+static void cn10k_xfrm_inb_prepare_sa(struct otx2_nic *pf, struct xfrm_state *x,
+				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct cn10k_rx_sa_s *sa_entry = inb_ctx_info->sa_entry;
+	int key_len = (x->aead->alg_key_len + 7) / 8;
+	u8 *key = x->aead->alg_key;
+	u32 sa_size = sizeof(struct cn10k_rx_sa_s);
+	u64 *tmp_key;
+	u32 *tmp_salt;
+	int idx;
+
+	memset(sa_entry, 0, sizeof(struct cn10k_rx_sa_s));
+
+	/* Disable ESN for now */
+	sa_entry->esn_en = 0;
+
+	/* HW context offset is word-31 */
+	sa_entry->hw_ctx_off = 31;
+	sa_entry->pkind = NPC_RX_CPT_HDR_PKIND;
+	sa_entry->eth_ovrwr = 1;
+	sa_entry->pkt_output = 1;
+	sa_entry->pkt_format = 1;
+	sa_entry->orig_pkt_free = 0;
+	/* context push size is up to word 31 */
+	sa_entry->ctx_push_size = 31 + 1;
+	/* context size, 128 Byte aligned up */
+	sa_entry->ctx_size = (sa_size / OTX2_ALIGN)  & 0xF;
+
+	sa_entry->cookie = inb_ctx_info->sa_index;
+
+	/* 1 word (??) prepanded to context header size */
+	sa_entry->ctx_hdr_size = 1;
+	/* Mark SA entry valid */
+	sa_entry->aop_valid = 1;
+
+	sa_entry->sa_dir = 0;			/* Inbound */
+	sa_entry->ipsec_protocol = 1;		/* ESP */
+	/* Default to Transport Mode */
+	if (x->props.mode == XFRM_MODE_TUNNEL)
+		sa_entry->ipsec_mode = 1;	/* Tunnel Mode */
+
+	sa_entry->et_ovrwr_ddr_en = 1;
+	sa_entry->enc_type = 5;			/* AES-GCM only */
+	sa_entry->aes_key_len = 1;		/* AES key length 128 */
+	sa_entry->l2_l3_hdr_on_error = 1;
+	sa_entry->spi = cpu_to_be32(x->id.spi);
+
+	/* Last 4 bytes are salt */
+	key_len -= 4;
+	memcpy(sa_entry->cipher_key, key, key_len);
+	tmp_key = (u64 *)sa_entry->cipher_key;
+
+	for (idx = 0; idx < key_len / 8; idx++)
+		tmp_key[idx] = be64_to_cpu(tmp_key[idx]);
+
+	memcpy(&sa_entry->iv_gcm_salt, key + key_len, 4);
+	tmp_salt = (u32 *)&sa_entry->iv_gcm_salt;
+	*tmp_salt = be32_to_cpu(*tmp_salt);
+
+	/* Write SA context data to memory before enabling */
+	wmb();
+
+	/* Enable SA */
+	sa_entry->sa_valid = 1;
+}
+
 static int cn10k_ipsec_get_hw_ctx_offset(void)
 {
 	/* Offset on Hardware-context offset in word */
@@ -1256,11 +1400,6 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
 				   "Only IPv4/v6 xfrm states may be offloaded");
 		return -EINVAL;
 	}
-	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Cannot offload other than crypto-mode");
-		return -EINVAL;
-	}
 	if (x->props.mode != XFRM_MODE_TRANSPORT &&
 	    x->props.mode != XFRM_MODE_TUNNEL) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -1272,11 +1411,6 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
 				   "Only ESP xfrm state may be offloaded");
 		return -EINVAL;
 	}
-	if (x->encap) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Encapsulated xfrm state may not be offloaded");
-		return -EINVAL;
-	}
 	if (!x->aead) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot offload xfrm states without aead");
@@ -1316,8 +1450,96 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
 static int cn10k_ipsec_inb_add_state(struct xfrm_state *x,
 				     struct netlink_ext_ack *extack)
 {
-	NL_SET_ERR_MSG_MOD(extack, "xfrm inbound offload not supported");
-	return -EOPNOTSUPP;
+	struct net_device *netdev = x->xso.dev;
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info = NULL, *inb_ctx;
+	bool enable_rule = false;
+	struct otx2_nic *pf;
+	u64 *sa_offset_ptr;
+	u32 sa_index = 0;
+	int err = 0;
+
+	pf = netdev_priv(netdev);
+
+	/* If XFRM policy was added before state, then the inb_ctx_info instance
+	 * would be allocated there.
+	 */
+	list_for_each_entry(inb_ctx, &pf->ipsec.inb_sw_ctx_list, list) {
+		if (inb_ctx->spi == x->id.spi) {
+			inb_ctx_info = inb_ctx;
+			enable_rule = true;
+			break;
+		}
+	}
+
+	if (!inb_ctx_info) {
+		/* Allocate a structure to track SA related info in driver */
+		inb_ctx_info = devm_kzalloc(pf->dev, sizeof(*inb_ctx_info), GFP_KERNEL);
+		if (!inb_ctx_info)
+			return -ENOMEM;
+
+		/* Stash pointer in the xfrm offload handle */
+		x->xso.offload_handle = (unsigned long)inb_ctx_info;
+	}
+
+	sa_index = cn10k_inb_alloc_sa(pf, x);
+	if (sa_index >= CN10K_IPSEC_INB_MAX_SA) {
+		netdev_err(netdev, "Failed to find free entry in SA Table\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* Fill in information for bookkeeping */
+	inb_ctx_info->sa_index = sa_index;
+	inb_ctx_info->spi = x->id.spi;
+	inb_ctx_info->sa_entry = pf->ipsec.inb_sa->base +
+				 (sa_index * pf->ipsec.sa_tbl_entry_sz);
+	inb_ctx_info->sa_iova = pf->ipsec.inb_sa->iova +
+				(sa_index * pf->ipsec.sa_tbl_entry_sz);
+	inb_ctx_info->x_state = x;
+
+	/* Store XFRM state pointer in SA context at an offset of 1KB.
+	 * It will be later used in the rcv_pkt_handler to associate
+	 * an skb with XFRM state.
+	 */
+	sa_offset_ptr = pf->ipsec.inb_sa->base +
+		 (sa_index * pf->ipsec.sa_tbl_entry_sz) + 1024;
+	*sa_offset_ptr = (u64)x;
+
+	err = cn10k_inb_install_spi_to_sa_match_entry(pf, x, inb_ctx_info);
+	if (err) {
+		netdev_err(netdev, "Failed to install Inbound IPSec exact match entry\n");
+		goto err_out;
+	}
+
+	cn10k_xfrm_inb_prepare_sa(pf, x, inb_ctx_info);
+
+	netdev_dbg(netdev, "inb_ctx_info: sa_index:%d spi:0x%x mcam_entry:%d"
+		   " hash_index:0x%x way:0x%x\n",
+		   inb_ctx_info->sa_index, inb_ctx_info->spi,
+		   inb_ctx_info->npc_mcam_entry, inb_ctx_info->hash_index,
+		   inb_ctx_info->way);
+
+	err = cn10k_inb_write_sa(pf, x, inb_ctx_info);
+	if (err)
+		netdev_err(netdev, "Error writing inbound SA\n");
+
+	/* Enable NPC rule if policy was already installed */
+	if (enable_rule) {
+		err = cn10k_inb_ena_dis_flow(pf, inb_ctx_info, false);
+		if (err)
+			netdev_err(netdev, "Failed to enable rule\n");
+	} else {
+		/* All set, add ctx_info to the list */
+		list_add_tail(&inb_ctx_info->list, &pf->ipsec.inb_sw_ctx_list);
+	}
+
+	cn10k_cpt_device_set_available(pf);
+	return err;
+
+err_out:
+	x->xso.offload_handle = 0;
+	devm_kfree(pf->dev, inb_ctx_info);
+	return err;
 }
 
 static int cn10k_ipsec_outb_add_state(struct xfrm_state *x,
@@ -1329,10 +1551,6 @@ static int cn10k_ipsec_outb_add_state(struct xfrm_state *x,
 	struct otx2_nic *pf;
 	int err;
 
-	err = cn10k_ipsec_validate_state(x, extack);
-	if (err)
-		return err;
-
 	pf = netdev_priv(netdev);
 
 	err = qmem_alloc(pf->dev, &sa_info, pf->ipsec.sa_size, OTX2_ALIGN);
@@ -1360,10 +1578,52 @@ static int cn10k_ipsec_outb_add_state(struct xfrm_state *x,
 static int cn10k_ipsec_add_state(struct xfrm_state *x,
 				 struct netlink_ext_ack *extack)
 {
+	int err;
+
+	err = cn10k_ipsec_validate_state(x, extack);
+	if (err)
+		return err;
+
 	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return cn10k_ipsec_inb_add_state(x, extack);
 	else
 		return cn10k_ipsec_outb_add_state(x, extack);
+
+	return err;
+}
+
+static void cn10k_ipsec_inb_del_state(struct otx2_nic *pf, struct xfrm_state *x)
+{
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info;
+	struct cn10k_rx_sa_s *sa_entry;
+	struct net_device *netdev = x->xso.dev;
+	int err = 0;
+
+	/* 1. Find SPI to SA entry */
+	inb_ctx_info = (struct cn10k_inb_sw_ctx_info *)x->xso.offload_handle;
+
+	if (inb_ctx_info->spi != be32_to_cpu(x->id.spi)) {
+		netdev_err(netdev, "SPI Mismatch (ctx) 0x%x != 0x%x (xfrm)\n",
+			   inb_ctx_info->spi, be32_to_cpu(x->id.spi));
+		return;
+	}
+
+	/* 2. Delete SA in CPT HW */
+	sa_entry = inb_ctx_info->sa_entry;
+	memset(sa_entry, 0, sizeof(struct cn10k_rx_sa_s));
+
+	sa_entry->ctx_push_size = 31 + 1;
+	sa_entry->ctx_size = (sizeof(struct cn10k_rx_sa_s) / OTX2_ALIGN) & 0xF;
+	sa_entry->aop_valid = 1;
+
+	if (cn10k_cpt_device_set_inuse(pf)) {
+		err = cn10k_inb_write_sa(pf, x, inb_ctx_info);
+		if (err)
+			netdev_err(netdev, "Error (%d) deleting INB SA\n", err);
+		cn10k_cpt_device_set_available(pf);
+	}
+
+	x->xso.offload_handle = 0;
 }
 
 static void cn10k_ipsec_del_state(struct xfrm_state *x)
@@ -1374,11 +1634,11 @@ static void cn10k_ipsec_del_state(struct xfrm_state *x)
 	struct otx2_nic *pf;
 	int err;
 
-	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
-		return;
-
 	pf = netdev_priv(netdev);
 
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
+		return cn10k_ipsec_inb_del_state(pf, x);
+
 	sa_info = (struct qmem *)x->xso.offload_handle;
 	sa_entry = (struct cn10k_tx_sa_s *)sa_info->base;
 	memset(sa_entry, 0, sizeof(struct cn10k_tx_sa_s));
@@ -1397,13 +1657,112 @@ static void cn10k_ipsec_del_state(struct xfrm_state *x)
 	/* If no more SA's then update netdev feature for potential change
 	 * in NETIF_F_HW_ESP.
 	 */
-	if (!--pf->ipsec.outb_sa_count)
-		queue_work(pf->ipsec.sa_workq, &pf->ipsec.sa_work);
+	pf->ipsec.outb_sa_count--;
+	queue_work(pf->ipsec.sa_workq, &pf->ipsec.sa_work);
+}
+
+static int cn10k_ipsec_policy_add(struct xfrm_policy *x,
+				  struct netlink_ext_ack *extack)
+{
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info = NULL, *inb_ctx;
+	struct net_device *netdev = x->xdo.dev;
+	struct otx2_nic *pf;
+	int ret = 0;
+	bool disable_rule = true;
+
+	if (x->xdo.dir != XFRM_DEV_OFFLOAD_IN) {
+		netdev_err(netdev, "ERR: Can only offload Inbound policies\n");
+		ret = -EINVAL;
+	}
+
+	if (x->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
+		netdev_err(netdev, "ERR: Only Packet mode supported\n");
+		ret = -EINVAL;
+	}
+
+	pf = netdev_priv(netdev);
+
+	/* If XFRM state was added before policy, then the inb_ctx_info instance
+	 * would be allocated there.
+	 */
+	list_for_each_entry(inb_ctx, &pf->ipsec.inb_sw_ctx_list, list) {
+		if (inb_ctx->spi == x->xfrm_vec[0].id.spi) {
+			inb_ctx_info = inb_ctx;
+			disable_rule = false;
+			break;
+		}
+	}
+
+	if (!inb_ctx_info) {
+		/* Allocate a structure to track SA related info in driver */
+		inb_ctx_info = devm_kzalloc(pf->dev, sizeof(*inb_ctx_info), GFP_KERNEL);
+		if (!inb_ctx_info)
+			return -ENOMEM;
+
+		inb_ctx_info->spi = x->xfrm_vec[0].id.spi;
+	}
+
+	ret = cn10k_inb_alloc_mcam_entry(pf, inb_ctx_info);
+	if (ret) {
+		netdev_err(netdev, "Failed to allocate MCAM entry for Inbound IPSec flow\n");
+		goto err_out;
+	}
+
+	ret = cn10k_inb_install_flow(pf, inb_ctx_info);
+	if (ret) {
+		netdev_err(netdev, "Failed to install Inbound IPSec flow\n");
+		goto err_out;
+	}
+
+	/* Leave rule in a disabled state until xfrm_state add is completed */
+	if (disable_rule) {
+		ret = cn10k_inb_ena_dis_flow(pf, inb_ctx_info, true);
+		if (ret)
+			netdev_err(netdev, "Failed to disable rule\n");
+
+		/* All set, add ctx_info to the list */
+		list_add_tail(&inb_ctx_info->list, &pf->ipsec.inb_sw_ctx_list);
+	}
+
+	/* Stash pointer in the xfrm offload handle */
+	x->xdo.offload_handle = (unsigned long)inb_ctx_info;
+
+err_out:
+	return ret;
+}
+
+static void cn10k_ipsec_policy_delete(struct xfrm_policy *x)
+{
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info;
+	struct net_device *netdev = x->xdo.dev;
+	struct otx2_nic *pf;
+
+	if (!x->xdo.offload_handle)
+		return;
+
+	pf = netdev_priv(netdev);
+	inb_ctx_info = (struct cn10k_inb_sw_ctx_info *)x->xdo.offload_handle;
+
+	/* Schedule a workqueue to free NPC rule and SPI-to-SA match table
+	 * entry because they are freed via a mailbox call which can sleep
+	 * and the delete policy routine from XFRM stack is called in an
+	 * atomic context.
+	 */
+	inb_ctx_info->delete_npc_and_match_entry = true;
+	queue_work(pf->ipsec.sa_workq, &pf->ipsec.sa_work);
+}
+
+static void cn10k_ipsec_policy_free(struct xfrm_policy *x)
+{
+	return;
 }
 
 static const struct xfrmdev_ops cn10k_ipsec_xfrmdev_ops = {
 	.xdo_dev_state_add	= cn10k_ipsec_add_state,
 	.xdo_dev_state_delete	= cn10k_ipsec_del_state,
+	.xdo_dev_policy_add	= cn10k_ipsec_policy_add,
+	.xdo_dev_policy_delete	= cn10k_ipsec_policy_delete,
+	.xdo_dev_policy_free	= cn10k_ipsec_policy_free,
 };
 
 static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
@@ -1411,12 +1770,42 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
 	struct cn10k_ipsec *ipsec = container_of(work, struct cn10k_ipsec,
 						 sa_work);
 	struct otx2_nic *pf = container_of(ipsec, struct otx2_nic, ipsec);
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info, *tmp;
+	int err;
+
+	list_for_each_entry_safe(inb_ctx_info, tmp, &pf->ipsec.inb_sw_ctx_list,
+				 list) {
+		if (!inb_ctx_info->delete_npc_and_match_entry)
+			continue;
+
+		/* 3. Delete all the associated NPC rules associated */
+		err = cn10k_inb_delete_flow(pf, inb_ctx_info);
+		if (err) {
+			netdev_err(pf->netdev, "Failed to free UCAST_IPSEC entry %d\n",
+				   inb_ctx_info->npc_mcam_entry);
+		}
+
+		/* 4. Remove SPI_TO_SA exact match entry */
+		err = cn10k_inb_delete_spi_to_sa_match_entry(pf, inb_ctx_info);
+		if (err)
+			netdev_err(pf->netdev, "Failed to delete spi_to_sa_match_entry\n");
+
+		inb_ctx_info->delete_npc_and_match_entry = false;
+
+		/* 5. Finally clear the entry from the SA Table */
+		clear_bit(inb_ctx_info->sa_index, pf->ipsec.inb_sa_table);
 
-	/* Disable static branch when no more SA enabled */
-	static_branch_disable(&cn10k_ipsec_sa_enabled);
-	rtnl_lock();
-	netdev_update_features(pf->netdev);
-	rtnl_unlock();
+		/* 6. Free the inb_ctx_info */
+		list_del(&inb_ctx_info->list);
+		devm_kfree(pf->dev, inb_ctx_info);
+	}
+
+	if (list_empty(&pf->ipsec.inb_sw_ctx_list) && !pf->ipsec.outb_sa_count) {
+		static_branch_disable(&cn10k_ipsec_sa_enabled);
+		rtnl_lock();
+		netdev_update_features(pf->netdev);
+		rtnl_unlock();
+	}
 }
 
 static int cn10k_ipsec_configure_cpt_bpid(struct otx2_nic *pfvf)
-- 
2.43.0

