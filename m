Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183D2222A0;
	Sun, 26 Oct 2025 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491449; cv=none; b=nwFnmZ8DDg+dsjBxYRUUhChL8T2L7fu+lzbdjR2glwQXUL6VcS8SeuVMS3I3CoKzaAwbLhkI9wkRT9XKWwbJ+IL0d+oZCCmYSQCsmktlZ6WM9uGL0LuQrYhP+p5aD9Mne/Pzd6ymROaUqbaMKqjOIlSM3gQIi9dnR1NaxJyk1xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491449; c=relaxed/simple;
	bh=NqPMZR8QQ1o0eBC33hVIMeFgSXLkYEg/5HCgwjczXgU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OczxSmPlIreOwfJAbIMsYO3ANsj1Ul2RyS+iI5tWZgE9RLV6jfdSDP6nIsKHYj2/a52R0LgRVWzR7ptf5mRktmcj2yBQ17yZjWTVD0okrWIBItiuP6698PfGCkdJrBghMFBvnfWo+Lhu9B4g0xr2i7ekxg+8scgOszcsGqtm3Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=abIycOR+; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="abIycOR+"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QEa3vE3822883;
	Sun, 26 Oct 2025 08:10:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	8k/5H4fGysnEmnOlZfS6bckpYsnFeJlyMOjRKBInPY=; b=abIycOR+rqk/1mOJv
	RD1UjiEDgtfqCB8pzqqU9CNjjvitX4ISri1MjewznTsvG6pFZdFa0FzeFlVF4kFz
	i4M3jaYTKvtI9p+R5zyCORGKtG7YGiaLy0y8DuoWP7L2KW3HnisEiOq0PDOyDih4
	xWxf6MAWweVs//d2QxeIwx359U29asjzAmWMHefvc218Bi788BKhRDkev/Hp3ErK
	1+EQkHi3IBrBSmWLKCsB2RyEjRSCdXuid2YFNrnmhk+bNE+Wkx+B88KTT9q5XuH0
	0Eg1mM9mm6h/FFGf4nAUnz3hos7WFHwU/Lsut74/s8yf1ezUbPoKwwzx6Mj4Hwkm
	INVOQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4a1jt807wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:43 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:42 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id BBC943F70B5;
	Sun, 26 Oct 2025 08:10:39 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 14/15] octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
Date: Sun, 26 Oct 2025 20:39:09 +0530
Message-ID: <20251026150916.352061-15-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX5WxgjpPiXcKd
 2+xgHNtXbCJ/5Tiq6VVS1HuA01mg/624fpwmQiujU2eziSe3ZZ15RwGJRXW6ek9qfbrnvzZD36C
 GGXVlNE0zAJxfsXQSnzNb44Q11fDtLiBRxp3VIIkGqA76cUg2S53RcB5fwo3QpBDchrZLVK6GWD
 QAjWeRGOBHYBjdV1oJnhv+VFFmAFWn+9KgeqOjZWaTyi7zJufeFKZt91WBbAMKIW88c2SaUplL7
 cQws8TyWEIejpQ0wJdSK1U6q4HCbrzkE8CZmi0RPPnwzSWyv3CypJB3v6Qg/XF+nSn1nICVMPYb
 0ZdFJ902bCyMZW/e/HmguW1rIzrLQyuBcN4ZgGsfPzyb/VG52b3mq0RmbgYZttcFyhTgmstvavT
 CcY9hnIWdb+5ABwrROW36T3xPfQ3rw==
X-Proofpoint-GUID: rsUniofBNeGOfldipvVDFByz8mrOlAls
X-Proofpoint-ORIG-GUID: rsUniofBNeGOfldipvVDFByz8mrOlAls
X-Authority-Analysis: v=2.4 cv=APHuRV3Y c=1 sm=1 tr=0 ts=68fe39f3 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=M5GUcnROAAAA:8 a=MWLLgxhS0d5IzbIQ4OoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

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
Changes in V5:
- None

Changes in V4:
- None
                                                                                                    Changes in V3:
- Updated definitions as reported by kernel test robot.
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506200609.aTq7YfBa-lkp@intel.com/

Changes in V2:                                                                                      - Use cpu_to_be32
- Moved code from patch 15/15 in V1 to avoid unusued function warnings
  for the following:
                                                                                                    V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-14-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-14-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-14-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-14-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 252 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   8 +
 3 files changed, 262 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index c0b8d8267d87..8317656af094 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -392,6 +392,205 @@ struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
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
 	int ret = 0, spb_cnt;
 	char *irq_name;
 	int  vec;
@@ -816,6 +1016,18 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
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
@@ -1219,12 +1431,42 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
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
index 507ddd9b7e78..89d6812a4d29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -350,6 +350,7 @@ void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf);
 struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
 						     struct sk_buff *skb,
 						     dma_addr_t seg_addr);
+void cn10k_ipsec_inb_disable_flows(struct otx2_nic *pfvf);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -393,5 +394,11 @@ struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
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
index 483956d12cc1..3a16a26c1745 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1808,6 +1808,10 @@ void otx2_free_hw_resources(struct otx2_nic *pf)
 	if (!otx2_rep_dev(pf->pdev))
 		cn10k_free_all_ipolicers(pf);
 
+	/* Delete Inbound IPSec flows if any SA's are installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
+		cn10k_ipsec_inb_disable_flows(pf);
+
 	mutex_lock(&mbox->lock);
 	/* Reset NIX LF */
 	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
@@ -2139,6 +2143,10 @@ int otx2_open(struct net_device *netdev)
 
 	otx2_do_set_rx_mode(pf);
 
+	/* Re-initialize IPsec flows if any previously installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
+		cn10k_ipsec_ethtool_init(netdev, true);
+
 	return 0;
 
 err_disable_rxtx:
-- 
2.43.0

