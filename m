Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA79329D272;
	Tue, 19 Aug 2025 02:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569762; cv=none; b=AYl3IHu/uhOduiiXZThPYqyp0X1kvBdKwPd3URIgadgYPrrMFQ5MVr20D5MclZnkHGJJgucHB3CS0MNvI4NPLBBdLJPXTCBBkdxz/Mbyjs8o8r8q+BCEGb389nV4GLQNwY7M7g/E3+/2kgzTA3eJ50f9Xs9B+CytxSWYf6rLkYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569762; c=relaxed/simple;
	bh=LywiTCA3u3bQLgd39PSJMtAcEnXjJ22x/BeXJpHSJS8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kKHkphxOk2ApS4VsUHuyeBkTEHq8dP1OSS9GcZRaaLwWj4ghcspUw9nCvsYnOPIzAW1BCHyUsavqR9PiyWH4L9YOqBX509AIm0q8KjT27p13tRfcrW+n+TxLhOtF9JUcwbcmp/6g+E0SA7Pe//MEoWyKW8oZIeyp+WKJDQcgMfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Bb9QzlzK; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Bb9QzlzK"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IMlbUg000350;
	Mon, 18 Aug 2025 19:15:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	8QGdxzLBrtPNmVjZ6RGPkM0OoAWjXhOS1PUjm9JZTI=; b=Bb9QzlzKiEunHJDzh
	9hdIQSNHf3Y+pG5ngisEVWu6h5Mf/RKI9q4WLSwS5et2QOpsBZ5wvX9jQldD/6Wu
	vlUH61/VKAY6PO0/gHaYo7PtPS2iG0tjw6EJOmsk2Ov9UDG9gonq1AOzSS+AicwV
	KdofaK5+tvydpHUdCONFXUVl0eSloytVBx1EucqBJuLTOUkORUrnmfSad80a2Mc/
	Xktn3gk3+DszDQ2jl4CEfuRKnidu6ADMEtnexkkbTxCeC2QkrTfXDrQIpa6w7i52
	tq8kcBVF9s/vV/fGBSVsM/6RBkE8Qqsn4Z7ClURWvJ3+rhQmsbIX8jp/ob6agx/5
	w/wwA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 48md9ggcdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:56 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:16:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:16:00 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 040083F7078;
	Mon, 18 Aug 2025 19:15:52 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v4 13/14] octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
Date: Tue, 19 Aug 2025 07:45:04 +0530
Message-ID: <20250819021507.323752-14-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=PN8P+eqC c=1 sm=1 tr=0 ts=68a3de5c cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=M5GUcnROAAAA:8 a=W7DiWRy-leIxRNNnoksA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfX9M2pCPkZ1uFm E3PD8tmJXbfzkXKZD6zImpn7/+UDjC7yZbw62t603up92Ed45mNYcc1xk8r6o9wy9poJ/7hGhu0 tV0bw0yHR0Yb/XDO3RWOH9aNudcSJ+8lm0JyVQDeN7tY2Xp1YhHXkUhJxG3Z5+0U5taSPoiQvmd
 C7gkVF5wMFBPCiHskT3CMNTxU9enl85SIfbmQOu29UjqQtaWJX+Fyiogjy2z15Maku1bJDhYdr8 rYJ+tum0PzNrZlTkPsCMUrc570Qg6atZhtczrJKrwSQ8wP/S9PxFY9rCcH6gEDTvCsapCfnJAfZ nZOrauVXyXJdjUbY5ltz+8piBivUcIN50D4NSaqPhy3Ixh3uoBdnw8LOAIRWxBQqV0o+5IMgpnN
 j87XTwK3aMRDaMUItSNqMN/FNAYvYZ/rOhYY7yObmZKNd3oO4PGCeHSXFWeAxE5Paz7DQqAb
X-Proofpoint-GUID: VFXAuQxetloW4IBPQi6vcLFwpdRWsH0M
X-Proofpoint-ORIG-GUID: VFXAuQxetloW4IBPQi6vcLFwpdRWsH0M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

NPC rule for IPsec flows
------------------------
Incoming IPsec packets are first classified for hardware fastpath
processing in the NPC block. Hence, allocate an MCAM entry in NPC
using the MCAM_ALLOC_ENTRY mailbox to add a rule for IPsec flow
classification.

Then, install an NPC rule at this entry for packet classification
based on ESP header and SPI value with match action as UCAST_IPSEC.
Also, these packets need to be directed to the dedicated receive
queue so provide the RQ index as part of NPC_INSTALL_FLOW mailbox.
Add a function to delete NPC rule as well.

SPI-to-SA match table
---------------------
NIX RX maintains a common hash table for matching the SPI value from
in ESP packet to the SA index associated with it. This table has 2K entries
with 4 ways. When a packet is received with action as UCAST_IPSEC, NIXRX
uses the SPI from the packet header to perform lookup in the SPI-to-SA
hash table. This lookup, if successful, returns an SA index that is used
by NIXRX to calculate the exact SA context address and programs it in
the CPT_INST_S before submitting the packet to CPT for decryption.

Add functions to install the delete an entry from this table via the
NIX_SPI_TO_SA_ADD and NIX_SPI_TO_SA_DELETE mailbox calls respectively.

When the RQs are changed at runtime via ethtool, RVU PF driver frees all
the resources and goes through reinitialization with the new set of receive
queues. As part of this flow, the UCAST_IPSEC NPC rules that were installed
by the RVU PF/VF driver have to be reconfigured with the new RQ index.

So, delete the NPC rules when the interface is stopped via otx2_stop().
When otx2_open() is called, re-install the NPC flow and re-initialize the
SPI-to-SA table for every SA context that was previously installed.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V4:
- None
 
Changes in V3:
- Updated definitions as reported by kernel test robot.
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506200609.aTq7YfBa-lkp@intel.com/

Changes in V2:
- Use cpu_to_be32
- Moved code from patch 15/15 in V1 to avoid unusued function warnings
  for the following:

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-14-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-14-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-14-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 252 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   8 +
 3 files changed, 262 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 81610774e7b6..60c267128d6b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -396,6 +396,205 @@ struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
 	return wqe;
 }
 
+static int cn10k_inb_alloc_mcam_entry(struct otx2_nic *pfvf,
+				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_mcam_alloc_entry_req *mcam_req;
+	struct npc_mcam_alloc_entry_rsp *mcam_rsp;
+	int err = 0;
+
+	if (!pfvf->flow_cfg || !flow_cfg->flow_ent)
+		return -ENODEV;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* Request an MCAM entry to install UCAST_IPSEC rule */
+	mcam_req = otx2_mbox_alloc_msg_npc_mcam_alloc_entry(&pfvf->mbox);
+	if (!mcam_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	mcam_req->contig = false;
+	mcam_req->count = 1;
+	mcam_req->ref_entry = flow_cfg->flow_ent[0];
+	mcam_req->priority = NPC_MCAM_HIGHER_PRIO;
+
+	if (otx2_sync_mbox_msg(&pfvf->mbox)) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	mcam_rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+									0, &mcam_req->hdr);
+
+	/* Store NPC MCAM entry for bookkeeping */
+	inb_ctx_info->npc_mcam_entry = mcam_rsp->entry_list[0];
+
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+static int cn10k_inb_install_flow(struct otx2_nic *pfvf,
+				  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct npc_install_flow_req *req;
+	int err;
+
+	/* Allocate an MCAM entry if not previously allocated */
+	if (!inb_ctx_info->npc_mcam_entry) {
+		err = cn10k_inb_alloc_mcam_entry(pfvf, inb_ctx_info);
+		if (err) {
+			netdev_err(pfvf->netdev,
+				   "Failed to allocate MCAM entry for Inbound IPsec flow\n");
+			goto out;
+		}
+	}
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	req->entry = inb_ctx_info->npc_mcam_entry;
+	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI);
+	req->intf = NIX_INTF_RX;
+	req->index = pfvf->ipsec.inb_ipsec_rq;
+	req->match_id = 0xfeed;
+	req->channel = pfvf->hw.rx_chan_base;
+	req->op = NIX_RX_ACTIONOP_UCAST_IPSEC;
+	req->set_cntr = 1;
+	req->packet.spi = inb_ctx_info->spi;
+	req->mask.spi = cpu_to_be32(0xffffffff);
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+static int cn10k_inb_delete_flow(struct otx2_nic *pfvf,
+				 struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct npc_delete_flow_req *req;
+	int err = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_npc_delete_flow(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	req->entry = inb_ctx_info->npc_mcam_entry;
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+static int cn10k_inb_ena_dis_flow(struct otx2_nic *pfvf,
+				  struct cn10k_inb_sw_ctx_info *inb_ctx_info,
+				  bool disable)
+{
+	struct npc_mcam_ena_dis_entry_req *req;
+	int err = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	if (disable)
+		req = otx2_mbox_alloc_msg_npc_mcam_dis_entry(&pfvf->mbox);
+	else
+		req = otx2_mbox_alloc_msg_npc_mcam_ena_entry(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	req->entry = inb_ctx_info->npc_mcam_entry;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+void cn10k_ipsec_inb_disable_flows(struct otx2_nic *pfvf)
+{
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info;
+
+	list_for_each_entry(inb_ctx_info, &pfvf->ipsec.inb_sw_ctx_list, list) {
+		if (cn10k_inb_ena_dis_flow(pfvf, inb_ctx_info, true)) {
+			netdev_err(pfvf->netdev,
+				   "Failed to disable UCAST_IPSEC entry %d\n",
+				   inb_ctx_info->npc_mcam_entry);
+			continue;
+		}
+		inb_ctx_info->delete_npc_and_match_entry = false;
+	}
+}
+
+static int cn10k_inb_install_spi_to_sa_match_entry(struct otx2_nic *pfvf,
+						   struct xfrm_state *x,
+						   struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct nix_spi_to_sa_add_req *req;
+	struct nix_spi_to_sa_add_rsp *rsp;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_spi_to_sa_add(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->sa_index = inb_ctx_info->sa_index;
+	req->spi_index = be32_to_cpu(x->id.spi);
+	req->match_id = 0xfeed;
+	req->valid = 1;
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+
+	rsp = (struct nix_spi_to_sa_add_rsp *)otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	inb_ctx_info->hash_index = rsp->hash_index;
+	inb_ctx_info->way = rsp->way;
+
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+static int cn10k_inb_delete_spi_to_sa_match_entry(struct otx2_nic *pfvf,
+						  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct nix_spi_to_sa_delete_req *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_spi_to_sa_delete(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->hash_index = inb_ctx_info->hash_index;
+	req->way = inb_ctx_info->way;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
 static int cn10k_inb_nix_inline_lf_cfg(struct otx2_nic *pfvf)
 {
 	struct nix_inline_ipsec_lf_cfg *req;
@@ -719,6 +918,7 @@ static irqreturn_t cn10k_ipsec_npa_inb_ipsecq_intr_handler(int irq, void *data)
 static int cn10k_inb_cpt_init(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info;
 	int ret = 0, vec;
 	char *irq_name;
 	u64 val;
@@ -778,6 +978,18 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
 	else
 		ret = 0;
 
+	/* If the driver has any offloaded inbound SA context(s), re-install the
+	 * associated SPI-to-SA match and NPC rules. This is generally executed
+	 * when the RQs are changed at runtime.
+	 */
+	list_for_each_entry(inb_ctx_info, &pfvf->ipsec.inb_sw_ctx_list, list) {
+		cn10k_inb_ena_dis_flow(pfvf, inb_ctx_info, false);
+		cn10k_inb_install_flow(pfvf, inb_ctx_info);
+		cn10k_inb_install_spi_to_sa_match_entry(pfvf,
+							inb_ctx_info->x_state,
+							inb_ctx_info);
+	}
+
 out:
 	return ret;
 }
@@ -1190,12 +1402,42 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
 	struct cn10k_ipsec *ipsec = container_of(work, struct cn10k_ipsec,
 						 sa_work);
 	struct otx2_nic *pf = container_of(ipsec, struct otx2_nic, ipsec);
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info, *tmp;
+	int err;
 
-	/* Disable static branch when no more SA enabled */
-	static_branch_disable(&cn10k_ipsec_sa_enabled);
-	rtnl_lock();
-	netdev_update_features(pf->netdev);
-	rtnl_unlock();
+	list_for_each_entry_safe(inb_ctx_info, tmp, &pf->ipsec.inb_sw_ctx_list,
+				 list) {
+		if (!inb_ctx_info->delete_npc_and_match_entry)
+			continue;
+
+		/* Delete all the associated NPC rules associated */
+		err = cn10k_inb_delete_flow(pf, inb_ctx_info);
+		if (err)
+			netdev_err(pf->netdev,
+				   "Failed to free UCAST_IPSEC entry %d\n",
+				   inb_ctx_info->npc_mcam_entry);
+
+		/* Remove SPI_TO_SA exact match entry */
+		err = cn10k_inb_delete_spi_to_sa_match_entry(pf, inb_ctx_info);
+		if (err)
+			netdev_err(pf->netdev,
+				   "Failed to delete spi_to_sa_match_entry\n");
+
+		inb_ctx_info->delete_npc_and_match_entry = false;
+
+		/* Finally clear the entry from the SA Table and free inb_ctx_info */
+		clear_bit(inb_ctx_info->sa_index, pf->ipsec.inb_sa_table);
+		list_del(&inb_ctx_info->list);
+		devm_kfree(pf->dev, inb_ctx_info);
+	}
+
+	/* Disable static branch when no more SA(s) are enabled */
+	if (list_empty(&pf->ipsec.inb_sw_ctx_list) && !pf->ipsec.outb_sa_count) {
+		static_branch_disable(&cn10k_ipsec_sa_enabled);
+		rtnl_lock();
+		netdev_update_features(pf->netdev);
+		rtnl_unlock();
+	}
 }
 
 void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 7c1e24e21ea3..154247958d8c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -346,6 +346,7 @@ void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf);
 struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
 						     struct sk_buff *skb,
 						     dma_addr_t seg_addr);
+void cn10k_ipsec_inb_disable_flows(struct otx2_nic *pfvf);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -389,5 +390,11 @@ struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
 {
 	return NULL;
 }
+
+static inline __maybe_unused
+void cn10k_ipsec_inb_delete_flows(struct otx2_nic *pfvf)
+{
+}
+
 #endif
 #endif // CN10K_IPSEC_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index d1e77ea7b290..3d7ef46e9a8a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1804,6 +1804,10 @@ void otx2_free_hw_resources(struct otx2_nic *pf)
 	if (!otx2_rep_dev(pf->pdev))
 		cn10k_free_all_ipolicers(pf);
 
+	/* Delete Inbound IPSec flows if any SA's are installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
+		cn10k_ipsec_inb_disable_flows(pf);
+
 	mutex_lock(&mbox->lock);
 	/* Reset NIX LF */
 	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
@@ -2135,6 +2139,10 @@ int otx2_open(struct net_device *netdev)
 
 	otx2_do_set_rx_mode(pf);
 
+	/* Re-initialize IPsec flows if any previously installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
+		cn10k_ipsec_ethtool_init(netdev, true);
+
 	return 0;
 
 err_disable_rxtx:
-- 
2.43.0

