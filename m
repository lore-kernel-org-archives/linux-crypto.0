Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7672561C5;
	Fri,  2 May 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192256; cv=none; b=WbdO698eYazYTHgKs6r9AravLnn1PHK/HY3MAh451hmHUjYU1pvjE5NhJRkQdGA3gDoY+XyrZXmjZw5geGK4BH9foMmxIdSVBcipN2zE9ud9fqCxFKmJwdEt6b4TUYFqwu+N6o11wj1nr/OmJeA8od9SOucynaxewsSawIlhba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192256; c=relaxed/simple;
	bh=JNpDvDI9jnLMI9JI/8hAZUmyEFlD81KIQ9wUm5og7/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c5cDXIZMrWaagHkmGp4MxlqwhI1GbQMMKVQqBEoP/eOpIn/4QoT3p7bGaLsY5kQCUzXmrOI7SNBl0dM7LXfQnrsQFc6Bknme2P1Dh6IQrvpGE/srLbRP3GFQeK181mdPWNardfHR47WnRxAX/o9603oEoxD1P7y8GehkUCph3Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TOYJAHmn; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TOYJAHmn"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542CCrJe023157;
	Fri, 2 May 2025 06:24:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=4
	fS1Ti8HMPhBk6oSTl5NdaARu1L4UtTq1Jkv4qRSDKc=; b=TOYJAHmny8aauB2SA
	poCtGCF0LPMWMN+04xbG4jFDAn+3+rgfjLo7LKNSUIn0pmn5mz7eU0ulEEBShdu5
	bbtSYaOu4WfyVRXkbVOASNpImRAHL7PanocCQeMAbom68edqmC9hLm/DNKtRQmvr
	qx7mLuX1Pjaa+C7TwAVjPpL8SUJCToatUClN8oZSMJFDznlwR0V/ZQwtN/rsZk1z
	oBI7hfgj4vouDh47EvOr7DBxVvgPru+eKUYIWixrxWJkdWhJS5IXYZWKX9L20N5r
	rEF5631FP9yvbZMYlbSpocZ88QM4T8XCLA/VR9M82HzsGiBVYe6vLcoR8V/zkGJ6
	LglGw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cutur9gx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:24:00 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:23:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:23:59 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 9E1FE3F7041;
	Fri,  2 May 2025 06:23:47 -0700 (PDT)
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
Subject: [net-next PATCH v1 13/15] octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
Date: Fri, 2 May 2025 18:49:54 +0530
Message-ID: <20250502132005.611698-14-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: tFOOYUnNNkXJ3PjuaBYSnWnm4OfI-1XB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfXxfKMENa5yugX 2KgcU8fnY7rvjAcVF/8fB82BRkvLKN20buAbjItr9ocxEqe6BZDoE3WJDX1JnJj3OeS9XwghYG4 d6FMQ87hKjZKFx+ptiyTT6nG9cdw6103+asMlAaujUqKnyOvenuszF67qMJUmr+L7bSxHu8bA3k
 VXLxleOvTpFM7fKqYKsP9G1CcooZLm4B4xTJRP2N5ZYNQXQmwW+qzclmJepBkJU1BvkJ20USWR7 QYPar7A+B8/vzlkW22FfWr7ietZl9GDeoT7ES5isGce5d03NjuZRIMx7qpBa+NuIxQgr763+hv7 fFfspJ1MDEHMTTWBI/lX8pI3mBVMTk4lzQ7/sp1f7SXGmGO0AUURB883LMlndMPJNhP6gRRnYhW
 VZzIpjfw/O83R241OfgHC42+lQ1IREd/ie9oK+sG2xpSCEgnp1XcvU9tV9e9UcIEER8nbYy3
X-Authority-Analysis: v=2.4 cv=BaPY0qt2 c=1 sm=1 tr=0 ts=6814c770 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=MCrkOfBp92-sPASCV2wA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: tFOOYUnNNkXJ3PjuaBYSnWnm4OfI-1XB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

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
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 201 ++++++++++++++++++
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
 3 files changed, 217 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index c6f408007511..91c8f13b6e48 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,194 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
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
+static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
+				  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
+{
+	struct npc_install_flow_req *req;
+	int err;
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
+	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI) | BIT(NPC_DMAC);
+	req->intf = NIX_INTF_RX;
+	req->index = pfvf->ipsec.inb_ipsec_rq;
+	req->match_id = 0xfeed;
+	req->channel = pfvf->hw.rx_chan_base;
+	req->op = NIX_RX_ACTIONOP_UCAST_IPSEC;
+	req->set_cntr = 1;
+	req->packet.spi = x->id.spi;
+	req->mask.spi = 0xffffffff;
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
+			netdev_err(pfvf->netdev, "Failed to disable UCAST_IPSEC"
+				   " entry %d\n", inb_ctx_info->npc_mcam_entry);
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
@@ -677,6 +865,7 @@ static irqreturn_t cn10k_ipsec_npa_inb_ipsecq_intr_handler(int irq, void *data)
 static int cn10k_inb_cpt_init(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cn10k_inb_sw_ctx_info *inb_ctx_info;
 	int ret = 0, vec;
 	char *irq_name;
 	void *ptr;
@@ -737,6 +926,18 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
 	else
 		ret = 0;
 
+	/* If the driver has any offloaded inbound SA context(s), re-install the
+	 * associated SPI-to-SA match and NPC rules. This is generally executed
+	 * when the RQs are changed at runtime.
+	 */
+	list_for_each_entry(inb_ctx_info, &pfvf->ipsec.inb_sw_ctx_list, list) {
+		cn10k_inb_ena_dis_flow(pfvf, inb_ctx_info, false);
+		cn10k_inb_install_flow(pfvf, inb_ctx_info->x_state, inb_ctx_info);
+		cn10k_inb_install_spi_to_sa_match_entry(pfvf,
+							inb_ctx_info->x_state,
+							inb_ctx_info);
+	}
+
 out:
 	return ret;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index f042cbadf054..aad5ebea64ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -329,6 +329,7 @@ bool otx2_sqe_add_sg_ipsec(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 			  struct otx2_snd_queue *sq, struct sk_buff *skb,
 			  int num_segs, int size);
+void cn10k_ipsec_inb_disable_flows(struct otx2_nic *pf);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -359,5 +360,11 @@ cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 {
 	return true;
 }
+
+static inline void __maybe_unused
+cn10k_ipsec_inb_delete_flows(struct otx2_nic *pf)
+{
+}
+
 #endif
 #endif // CN10K_IPSEC_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 0ffc56efcc23..7fcd382cb410 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1714,7 +1714,12 @@ void otx2_free_hw_resources(struct otx2_nic *pf)
 	if (!otx2_rep_dev(pf->pdev))
 		cn10k_free_all_ipolicers(pf);
 
+	/* Delete Inbound IPSec flows if any SA's are installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
+		cn10k_ipsec_inb_disable_flows(pf);
+
 	mutex_lock(&mbox->lock);
+
 	/* Reset NIX LF */
 	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
 	if (free_req) {
@@ -2045,6 +2050,10 @@ int otx2_open(struct net_device *netdev)
 
 	otx2_do_set_rx_mode(pf);
 
+	/* Re-initialize IPsec flows if any previously installed */
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
+		cn10k_ipsec_ethtool_init(netdev, true);
+
 	return 0;
 
 err_disable_rxtx:
-- 
2.43.0

