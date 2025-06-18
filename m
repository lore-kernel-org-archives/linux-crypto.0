Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C572DE1E6;
	Wed, 18 Jun 2025 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246304; cv=none; b=nacSq2xSOZvlxuhMaLozgovUuJti/QgfvFgSQhSD0J2rdCwI+RpQpMSROz2o3PYEChycmC5KJdhDglkcfi4AxSJ/jRnd1gULdK3goboNNrDTPctFsbLq1wde22gk/VSkRv/Cn28P5wGW3MiHG10N33eRmJ5acU5lwVDabstGJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246304; c=relaxed/simple;
	bh=WwlL+tEPhpif6nSBxOXntKkY0pupNr5zZk/EogYNAXU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CdsJuTuyJGxQomGQF1TfQ7w37LOi6JvqeHsazewRXQL7r7U7304hf5tnd53aclLekDIMB1J903TF7t2nqZeVe39sbi9/d229C+KvD4Ia8JUTwAMcw13l4e1Pzho8KXq5I0915zG1W95E3f1V9j9pLaaIJru5dcHIk/Y77RqaQSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JJu458Qj; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JJu458Qj"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I9G6Wn022728;
	Wed, 18 Jun 2025 04:31:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	89RDX6cOhZyyQTtDPcnEDMs36gsWgBJYrEncNP8qGM=; b=JJu458QjowyYxwTeC
	o+MufbCCHALHwA9ZbitAEHBGLx08Ll5RbKQ2Gq+1SdaVOFyWWqtLRW7TVTOS0+nb
	Zt4sS9/VvEcnphOPAlkLnoQTtIaruMG57mjVH/1r9qoWciQ47i2/ALmfJNdtkgOe
	UnBY2OyRVE+Ce13YAOmPq5vlnjYkD833cvdlMqcqiedWOUhOPamSpKa9Zuf5Cv09
	JGEg6uD3UiihqgJvmG7UxNnRWuagJrT8rh4Z7RexmgwIim+spJAXb0mEnVttNxp0
	rqhP1dQWL5SXXsVP2H/X6wMsjsSTof5R4xXzeV4QPVWlWpD/AxaqRot+nKEZ932C
	aftRw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47btnx88vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:34 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:33 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 79C733F7048;
	Wed, 18 Jun 2025 04:31:30 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 14/14] octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
Date: Wed, 18 Jun 2025 17:00:08 +0530
Message-ID: <20250618113020.130888-15-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=E4TNpbdl c=1 sm=1 tr=0 ts=6852a397 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=_aetzDJvF-EFRKYuIGoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: HuWDxr6M8wzDL83kEXDZdMONnP4r4nTF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5NyBTYWx0ZWRfX+Y0PINZAAsAT zMwHigKliFjZgWHodJV7O5LiZyl3YiyuMPiQDdnwhOJWM5ACOl7POr5Gzs+hXZTzIq9F+vXF+z/ 0QuG1hNyzZO+Jm4HCSScQJjtTPN7R+rQOj50Ts/eCl0ugw8wpY+x+l16dv3os1cnpnTd/a5ipms
 H3JQ8b2jWKhBGakvCNA0xS1hUViploJIih1Ioagww3i3GGg93UjuYTamy9njUdx/njmdwqaYVHU km04ippkY5wboN2eNZvKkygY7NlLvAtrumXxrvx6J8fWbttxnQQS9ikSFZrfx922d4XrlcAGBVe TDBD30jpODTw9SVsGHmUgXffCgI4Ctl+ZDwvLSXzx3u2pWqmOFkpb5TqXCtHKldXriC2Mf/wEL3
 ubXGVofQ4BDvf/UH1fagA3jLhs+jHNLFYOhFrLaws3kos3t7tiNwxrm34F9LXLU6DlCWQ2rt
X-Proofpoint-GUID: HuWDxr6M8wzDL83kEXDZdMONnP4r4nTF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

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
Changes in V2
- Used reqid to track NPC rule between XFRM state and policy hooks

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-16-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 401 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   1 +
 2 files changed, 379 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 4183526bd1c3..a70e3bf2424a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -1027,6 +1027,19 @@ static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
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
@@ -1141,6 +1154,137 @@ static int cn10k_outb_write_sa(struct otx2_nic *pf, struct qmem *sa_info)
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
@@ -1248,11 +1392,6 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
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
@@ -1264,11 +1403,6 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
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
@@ -1305,11 +1439,95 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
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
@@ -1321,10 +1539,6 @@ static int cn10k_ipsec_outb_add_state(struct net_device *dev,
 	struct otx2_nic *pf;
 	int err;
 
-	err = cn10k_ipsec_validate_state(x, extack);
-	if (err)
-		return err;
-
 	pf = netdev_priv(dev);
 
 	err = qmem_alloc(pf->dev, &sa_info, pf->ipsec.sa_size, OTX2_ALIGN);
@@ -1353,10 +1567,52 @@ static int cn10k_ipsec_add_state(struct net_device *dev,
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
+	if (inb_ctx_info->spi != be32_to_cpu(x->id.spi)) {
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
@@ -1366,11 +1622,11 @@ static void cn10k_ipsec_del_state(struct net_device *dev, struct xfrm_state *x)
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
@@ -1389,13 +1645,112 @@ static void cn10k_ipsec_del_state(struct net_device *dev, struct xfrm_state *x)
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
index 808d03b703b3..ad2aaa48e9cb 100644
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

