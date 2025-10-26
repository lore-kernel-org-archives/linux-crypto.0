Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2728258CE9;
	Sun, 26 Oct 2025 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491455; cv=none; b=k/itKB0Ml+hb9h847t8L8e0t/laKkrS/Fvt4nj1lc/wl2ETv6m6qQv/bLFWkUxDhvnPiIDNvuozYCOqxOn9UkBMC4VDedvdbtnJexJSK/SUWazZK/4DJF1bt7Pgw6v/3Ia5hvvE0hgjsQituPZdQi+xhbZ/RVIjT5dujsMChEn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491455; c=relaxed/simple;
	bh=GIje63777J1nlUREmaqLkgMIkHfwKpXwmyRb1E5+MB4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhxxsAnUs+R82qMs5Xq5gP9lT6l0Hnxa98Eqy0a4ZC7c8qgofWhri116pGW/r00HWJLOXBPUq3iQOPvbCnCu+xYtsCTUsxaGEA6pCSPrYhuEwSd/ZFUPXjyCcDyOSW4JKI3+8TafihFgaF+xIkR5hCLMGXcTAwXVrQa8x64kLxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=M5KU+3bY; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="M5KU+3bY"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QF04K93886040;
	Sun, 26 Oct 2025 08:10:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=i
	xDyNQnhkimrfEgrhFCWbrJpYme2PcsIk9oHox2B71U=; b=M5KU+3bYVOtKTNJ1a
	Hbu+qLs8fWGRubppwPxrU8JCYEE5iNV6R+PmvyB740rRFP1piXp1upujZ1iCtyPx
	lF8LNkVYuHL+IjAYsUij1DpjSBhT02MPKz9NIKEw9vFCLnoJBlzpmdrvC+u446ue
	mOpVu9TnwN5q/5gjvdN5fN7TaGCbaoBuScbztRDXzp4Y1lX58g+wVxT0Z1FQFW0w
	Y4H2jEPlAjeXfWrMm76F2R/dbNdAdETeZ/HtykObklNGid6bUdAK+1enEoy3ciMO
	MrEUW0Y+v69QPKFSNTytILLHUF6vwmagWtzmtb26B0Wxmp8q05/qqlhJwbKlaN29
	UUFGw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a1fa5rfxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:46 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:55 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id E46E33F70B5;
	Sun, 26 Oct 2025 08:10:42 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 15/15] octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
Date: Sun, 26 Oct 2025 20:39:10 +0530
Message-ID: <20251026150916.352061-16-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfXyUpW7DoHEzsX
 0QK2HC+HtwAAQjEmzjUCYydq1hZdeSt8olPO3K2qFbWHRz6sQncKklHTjuf9DbzHuj9ZAWU6M5a
 Kca7vUnrgSXWMtNNvX2JH50nDaHfCcjv0Ogdt35dhmMbnQF4tA4XkkiXTk17y9Tg1DdJmt249r5
 lBqoF/M1QytuaTncdDGADGRizeRKMD+iVQHxs9cYRj+wLkqR5A2mUFefRwNfP6wd+Na1owvK9Jw
 9ZFXr17TGnePfKwJR9XsOiZU9OXA5lkl2SD/y9Ai+A7vytm7uISa3sEL1H2xYxXR1UHxjly4p40
 oZ7jBYkr6wQe6pRaQmhTJHdgPSGHb1BG2gYB2igm+qWOicte5KWi614RkUb7qJNh8EwwuFQFvJJ
 xT772mr4/ldBP+CngKovvp9gCtKgJQ==
X-Authority-Analysis: v=2.4 cv=VOnQXtPX c=1 sm=1 tr=0 ts=68fe39f6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=_aetzDJvF-EFRKYuIGoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: jJ5eWVlYgUy2lXdhvigIr-Z1JM1str-Y
X-Proofpoint-ORIG-GUID: jJ5eWVlYgUy2lXdhvigIr-Z1JM1str-Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

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
Changes in V5:
- RCT definition

Changes in V4:
- Fixed warnings reported by sparse tool

Changes in V3:
- Use dma_wmb() instead of arm64 specific dmb(sy)
                                                                                                    Changes in V2
- Used reqid to track NPC rule between XFRM state and policy hooks

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-16-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-15-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-15-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-15-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 401 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   1 +
 2 files changed, 379 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 8317656af094..8c8ec5578180 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -1055,6 +1055,19 @@ static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
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
@@ -1169,6 +1182,137 @@ static int cn10k_outb_write_sa(struct otx2_nic *pf, struct qmem *sa_info)
 	return ret;
 }
 
+static int cn10k_inb_write_sa(struct otx2_nic *pf,
+			      struct xfrm_state *x,
+			      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	dma_addr_t res_iova, dptr_iova, sa_iova;
+	struct cn10k_rx_sa_s *sa_dptr, *sa_cptr;
+	struct cpt_inst_s inst;
+	struct cpt_res_s *res;
+	u32 sa_size, off;
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
+		*((u64 *)sa_dptr + off) = (__force u64)cpu_to_be64(*((u64 *)sa_cptr + off));
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
+	/* Reuse Outbound CPT LF to install Ingress SAs as well because
+	 * the driver does not own the ingress CPT LF.
+	 */
+	pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf, CN10K_CPT_LF_NQX(0));
+	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
+	dma_wmb();
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
+	u32 sa_size = sizeof(struct cn10k_rx_sa_s);
+	u8 *key = x->aead->alg_key;
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
+	sa_entry->spi = (__force u32)be32_to_cpu(x->id.spi);
+
+	/* Last 4 bytes are salt */
+	key_len -= 4;
+	memcpy(sa_entry->cipher_key, key, key_len);
+	tmp_key = (u64 *)sa_entry->cipher_key;
+
+	for (idx = 0; idx < key_len / 8; idx++)
+		tmp_key[idx] = (__force u64)cpu_to_be64(tmp_key[idx]);
+
+	memcpy(&sa_entry->iv_gcm_salt, key + key_len, 4);
+	tmp_salt = (u32 *)&sa_entry->iv_gcm_salt;
+	*tmp_salt = (__force u32)cpu_to_be32(*tmp_salt);
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
@@ -1276,11 +1420,6 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
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
@@ -1292,11 +1431,6 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
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
@@ -1333,11 +1467,95 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
 	return 0;
 }
 
-static int cn10k_ipsec_inb_add_state(struct xfrm_state *x,
+static int cn10k_ipsec_inb_add_state(struct net_device *dev,
+				     struct xfrm_state *x,
 				     struct netlink_ext_ack *extack)
 {
-	NL_SET_ERR_MSG_MOD(extack, "xfrm inbound offload not supported");
-	return -EOPNOTSUPP;
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info = NULL, *inb_ctx;
+	bool enable_rule = false;
+	struct otx2_nic *pf;
+	u64 *sa_offset_ptr;
+	u32 sa_index = 0;
+	int err = 0;
+
+	pf = netdev_priv(dev);
+
+	/* If XFRM policy was added before state, then the inb_ctx_info instance
+	 * would be allocated there.
+	 */
+	list_for_each_entry(inb_ctx, &pf->ipsec.inb_sw_ctx_list, list) {
+		if (inb_ctx->reqid == x->props.reqid) {
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
+		netdev_err(dev, "Failed to find free entry in SA Table\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* Fill in information for bookkeeping */
+	inb_ctx_info->sa_index = sa_index;
+	inb_ctx_info->spi = x->id.spi;
+	inb_ctx_info->reqid = x->props.reqid;
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
+		netdev_err(dev, "Failed to install Inbound IPSec exact match entry\n");
+		goto err_out;
+	}
+
+	/* Fill the Inbound SA context structure */
+	cn10k_xfrm_inb_prepare_sa(pf, x, inb_ctx_info);
+
+	err = cn10k_inb_write_sa(pf, x, inb_ctx_info);
+	if (err)
+		netdev_err(dev, "Error writing inbound SA\n");
+
+	/* Enable NPC rule if policy was already installed */
+	if (enable_rule) {
+		err = cn10k_inb_ena_dis_flow(pf, inb_ctx_info, false);
+		if (err)
+			netdev_err(dev, "Failed to enable rule\n");
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
 
 static int cn10k_ipsec_outb_add_state(struct net_device *dev,
@@ -1349,10 +1567,6 @@ static int cn10k_ipsec_outb_add_state(struct net_device *dev,
 	struct otx2_nic *pf;
 	int err;
 
-	err = cn10k_ipsec_validate_state(x, extack);
-	if (err)
-		return err;
-
 	pf = netdev_priv(dev);
 
 	err = qmem_alloc(pf->dev, &sa_info, pf->ipsec.sa_size, OTX2_ALIGN);
@@ -1381,10 +1595,52 @@ static int cn10k_ipsec_add_state(struct net_device *dev,
 				 struct xfrm_state *x,
 				 struct netlink_ext_ack *extack)
 {
+	int err;
+
+	err = cn10k_ipsec_validate_state(x, extack);
+	if (err)
+		return err;
+
 	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
-		return cn10k_ipsec_inb_add_state(x, extack);
+		return cn10k_ipsec_inb_add_state(dev, x, extack);
 	else
 		return cn10k_ipsec_outb_add_state(dev, x, extack);
+
+	return err;
+}
+
+static void cn10k_ipsec_inb_del_state(struct net_device *dev,
+				      struct otx2_nic *pf, struct xfrm_state *x)
+{
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info;
+	struct cn10k_rx_sa_s *sa_entry;
+	int err = 0;
+
+	/* 1. Find SPI to SA entry */
+	inb_ctx_info = (struct cn10k_inb_sw_ctx_info *)x->xso.offload_handle;
+
+	if (inb_ctx_info->spi != x->id.spi) {
+		netdev_err(dev, "SPI Mismatch (ctx) 0x%x != 0x%x (xfrm)\n",
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
+			netdev_err(dev, "Error (%d) deleting INB SA\n", err);
+		cn10k_cpt_device_set_available(pf);
+	}
+
+	x->xso.offload_handle = 0;
 }
 
 static void cn10k_ipsec_del_state(struct net_device *dev, struct xfrm_state *x)
@@ -1394,11 +1650,11 @@ static void cn10k_ipsec_del_state(struct net_device *dev, struct xfrm_state *x)
 	struct otx2_nic *pf;
 	int err;
 
-	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
-		return;
-
 	pf = netdev_priv(dev);
 
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
+		return cn10k_ipsec_inb_del_state(dev, pf, x);
+
 	sa_info = (struct qmem *)x->xso.offload_handle;
 	sa_entry = (struct cn10k_tx_sa_s *)sa_info->base;
 	memset(sa_entry, 0, sizeof(struct cn10k_tx_sa_s));
@@ -1417,13 +1673,112 @@ static void cn10k_ipsec_del_state(struct net_device *dev, struct xfrm_state *x)
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
+	bool disable_rule = true;
+	struct otx2_nic *pf;
+	int ret = 0;
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
+		if (inb_ctx->reqid == x->xfrm_vec[0].reqid) {
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
+		inb_ctx_info->reqid = x->xfrm_vec[0].reqid;
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 89d6812a4d29..1b1c5315133d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -94,6 +94,7 @@ struct cn10k_inb_sw_ctx_info {
 	u32 npc_mcam_entry;
 	u32 sa_index;
 	__be32 spi;
+	u32 reqid;
 	u16 hash_index;	/* Hash index from SPI_TO_SA match */
 	u8 way;		/* SPI_TO_SA match table way index */
 	bool delete_npc_and_match_entry;
-- 
2.43.0

