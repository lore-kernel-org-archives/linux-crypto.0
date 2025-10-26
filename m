Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCB122A7F1;
	Sun, 26 Oct 2025 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491442; cv=none; b=ZIWGrC/zJMR3xAr39gfmS6syfXS/PaowCePU7BkQbYUu+KYlFBAPG7yZYEomYiDjKpdgYC5XwLOkil10GlQBhsTwZNQZQ+YjfghCJuNaxIYrFinZvy8O7rIZNsJxADxJOnrVIeN4Stgaa15+IU++HIkCqdnotX7BLBb8ashPHp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491442; c=relaxed/simple;
	bh=Cojo87jNRp6UmUrVtiUwbclZcPDAHlr0k3sI8frYer8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1TePk+2l+AyBiM89/8u54UR1eg8cHc3W0yGKwt7csPQ91Z+k6uP2qNzKVX5jhO7mpOyJqc+95ApVhFcHz4QF1yzDbF49EMbvjh7UCxAPFWjPqbTPZKIzTPJjBPaHg/+ar6ABmMrhvSaV16V+aU7a0kEgVnl3zZHbGRNu63X2+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=c+EFVzH/; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="c+EFVzH/"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59Q9Yu173227937;
	Sun, 26 Oct 2025 08:10:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	ooBvBLd/pb2YjTSsMBdSa8Gu8QyC/tmXtZp5fs06As=; b=c+EFVzH/x0numX7p6
	Fh9ugBX1MB0dgt5v7AdItctub0WwtVZKTwGldNdwQFbsRIykhKxyFF4atNoMYITt
	n/3TP9ZLOrYPSFSxcKt9WQuNmS7A2BsiV5vfYsQmIEuWhLNy+qAYnYa4S9pS11o+
	EVQUNEQ7wSjLz4Q1e8QFKMrzpsQvq5P8DZbSFxwv4Qd3wbwbRgL2bqufy7RDgjZs
	AO2ymmVUFqwyu8tR4r3/LtoYftaFtBgR+hZ9UzyYUjhjgShpT6h0f5Cz2mXen/5M
	VEAKeIRg9e5Ceq1wFg6Ss5Woi6MKXXtVe11sFTmKVxviBacOTjN1bKUZTNztjST+
	/7g0A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4a0uwh1vh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:36 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:46 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 68CC13F70B5;
	Sun, 26 Oct 2025 08:10:33 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 12/15] octeontx2-pf: ipsec: Configure backpressure
Date: Sun, 26 Oct 2025 20:39:07 +0530
Message-ID: <20251026150916.352061-13-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=H6vWAuYi c=1 sm=1 tr=0 ts=68fe39ec cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8
 a=1QF-8sLhr1iMatrQ988A:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: SS0AV37wv-Qr_MBRYRWz3l8eaUtkQ5XG
X-Proofpoint-GUID: SS0AV37wv-Qr_MBRYRWz3l8eaUtkQ5XG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX5c9puqlaI9IH
 mbrnMAn5U+rhqybvK7QeozpKjOPEkEvoBtdZbZSVrRhoyRfkcuP39q4p5jI6FcR68y6kVEyiM/b
 xSNQEPEOfTL68mUXJTclAciin7e4we9G+yz8UOE84aOfPStzzNJv9KC0mCUOzgSei3qmYTixj1g
 rka1a9cBn0BCY5tFd6a/+TfCVUDVBmo+w0BFRNzMOxmOYB29S0w+ZH1n3mOrFSAmupLN7H+9Lu9
 3p1uQZkT2GPm4JS121u6CbGGghPzEnf2p5JXzy3i6DHl6DJuO200jeX0AW18uF/5y8U45k1IO4j
 +ZTg9PPY5ZOk9HoeavAyXXyp6emKgT6TWVwN5hX8kYVC5mg+nUo7YwL1+7B9t7jAW5nne+UjUn0
 naqqQ60RTkkMFEFfmAGB1uxjfpTxFQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

Backpressure can be asserted by NIX and CPT hardware blocks in the first
and second pass. In the first pass, backpressure can be asserted by CPT.
Since we have a global CPT LF across the system to handle IPsec traffic,
we need to allocate a global backpressure ID and configure the NIX RX
channel to listen to this ID as well. Define a 'bpid' to refer to the
first pass backpressure and configure the corresponding NIX RX channels.

During the second pass, NIX can assert backpressure to CPT due to
buffers pool reaching a threshold. Hence allocate another BPID for the
second pass and configure the CPT X2P link to listen to this back
pressure ID. Additionally, the CQs in the second pass can assert
backpressure, so configure that CPT X2P link to listen to that as well.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- This is a new patch added to this series by removing backpressure
  related changes from the previous patch (11/15) and adding more
  BPID related configuration.

 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |   1 +
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 175 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   9 +
 4 files changed, 185 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index edc3c356dba3..797e2dd83d29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -609,6 +609,7 @@ static int cpt_inline_ipsec_cfg_inbound(struct rvu *rvu, int blkaddr, u8 cptlf,
 	if (!is_rvu_otx2(rvu)) {
 		val = (ilog2(NIX_CHAN_CPT_X2P_MASK + 1) << 16);
 		val |= (u64)rvu->hw->cpt_chan_base;
+		val |= 0x2 << 20;
 
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(0), val);
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(1), val);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 664ccfc7e80d..d545e56e0b6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -439,6 +439,7 @@ static int cn10k_inb_nix_inline_ipsec_cfg(struct otx2_nic *pfvf)
 	req->opcode = CN10K_IPSEC_MAJOR_OP_INB_IPSEC | (1 << 6);
 	req->param1 = 7; /* bit 0:ip_csum_dis 1:tcp_csum_dis 2:esp_trailer_dis */
 	req->param2 = 0;
+	req->bpid = pfvf->ipsec.bpid;
 	req->credit = (pfvf->qset.rqe_cnt * 3) / 4;
 	req->credit_th = pfvf->qset.rqe_cnt / 10;
 	req->ctx_ilen_valid = 1;
@@ -485,7 +486,35 @@ static int cn10k_ipsec_ingress_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
-static int cn10k_ipsec_aura_and_pool_init(struct otx2_nic *pfvf, int pool_id)
+/* Enable backpressure for the specified aura since
+ * it cannot be enabled during aura initialization.
+ */
+static int cn10k_ipsec_enable_aura_backpressure(struct otx2_nic *pfvf,
+						int aura_id, int bpid)
+{
+	struct npa_aq_enq_req *npa_aq;
+
+	npa_aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!npa_aq)
+		return -ENOMEM;
+
+	npa_aq->aura.bp_ena = 1;
+	npa_aq->aura_mask.bp_ena = 1;
+	npa_aq->aura.nix0_bpid = bpid;
+	npa_aq->aura_mask.nix0_bpid = GENMASK(8, 0);
+	npa_aq->aura.bp = (255 - ((50 * 256) / 100));
+	npa_aq->aura_mask.bp = GENMASK(7, 0);
+
+	/* Fill NPA AQ info */
+	npa_aq->aura_id = aura_id;
+	npa_aq->ctype = NPA_AQ_CTYPE_AURA;
+	npa_aq->op = NPA_AQ_INSTOP_WRITE;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+static int cn10k_ipsec_aura_and_pool_init(struct otx2_nic *pfvf, int pool_id,
+					  int bpid)
 {
 	struct otx2_hw *hw = &pfvf->hw;
 	struct otx2_pool *pool = NULL;
@@ -523,6 +552,11 @@ static int cn10k_ipsec_aura_and_pool_init(struct otx2_nic *pfvf, int pool_id)
 		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
 	}
 
+	/* Enable backpressure for the aura */
+	err = cn10k_ipsec_enable_aura_backpressure(pfvf, pool_id, bpid);
+	if (err)
+		goto free_auras;
+
 	return err;
 
 free_auras:
@@ -539,7 +573,8 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
 	mutex_lock(&pfvf->mbox.lock);
 
 	/* Initialize Pool for first pass */
-	err = cn10k_ipsec_aura_and_pool_init(pfvf, pfvf->ipsec.inb_ipsec_pool);
+	err = cn10k_ipsec_aura_and_pool_init(pfvf, pfvf->ipsec.inb_ipsec_pool,
+					     pfvf->ipsec.bpid);
 	if (err)
 		return err;
 
@@ -555,7 +590,8 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
 
 	for (pool = pfvf->ipsec.inb_ipsec_spb_pool;
 	     pool < pfvf->hw.rx_queues + pfvf->ipsec.inb_ipsec_spb_pool; pool++) {
-		err = cn10k_ipsec_aura_and_pool_init(pfvf, pool);
+		err = cn10k_ipsec_aura_and_pool_init(pfvf, pool,
+						     pfvf->ipsec.spb_bpid);
 		if (err)
 			goto free_auras;
 	}
@@ -1166,6 +1202,29 @@ void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
 	}
 }
 
+static int cn10k_ipsec_free_cpt_bpid(struct otx2_nic *pfvf)
+{
+	struct nix_bpids *req;
+	int rc;
+
+	req = otx2_mbox_alloc_msg_nix_free_bpids(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->bpid_cnt = 2;
+	req->bpids[0] = pfvf->ipsec.bpid;
+	req->bpids[1] = pfvf->ipsec.spb_bpid;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	/* Clear the bpids */
+	pfvf->ipsec.bpid = 0;
+	pfvf->ipsec.spb_bpid = 0;
+	return 0;
+}
+
 static void cn10k_ipsec_free_hw_resources(struct otx2_nic *pfvf)
 {
 	int vec;
@@ -1187,6 +1246,111 @@ static void cn10k_ipsec_free_hw_resources(struct otx2_nic *pfvf)
 
 	vec = pci_irq_vector(pfvf->pdev, pfvf->hw.npa_msixoff);
 	free_irq(vec, pfvf);
+
+	if (pfvf->ipsec.bpid && pfvf->ipsec.spb_bpid)
+		cn10k_ipsec_free_cpt_bpid(pfvf);
+}
+
+static int cn10k_ipsec_configure_cpt_bpid(struct otx2_nic *pfvf)
+{
+	struct nix_rx_chan_cfg *chan_cfg, *chan_cfg_rsp;
+	struct nix_alloc_bpid_req *req;
+	int chan, chan_cnt = 1;
+	struct nix_bpids *rsp;
+	u64 rx_chan_cfg;
+	int rc;
+
+	req = otx2_mbox_alloc_msg_nix_alloc_bpids(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	/* Request 2 BPIDs:
+	 * One for 1st pass LPB pool and another for 2nd pass SPB pool
+	 */
+	req->bpid_cnt = 2;
+	req->type = NIX_INTF_TYPE_CPT;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	rsp = (struct nix_bpids *)otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	/* Store the bpid for configuring it in the future */
+	pfvf->ipsec.bpid = rsp->bpids[0];
+	pfvf->ipsec.spb_bpid = rsp->bpids[1];
+
+	/* Get the default RX channel configuration */
+	chan_cfg = otx2_mbox_alloc_msg_nix_rx_chan_cfg(&pfvf->mbox);
+	if (!chan_cfg)
+		return -ENOMEM;
+
+	chan_cfg->read = true;
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	/* Get the response */
+	chan_cfg_rsp = (struct nix_rx_chan_cfg *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &chan_cfg->hdr);
+
+	rx_chan_cfg = chan_cfg_rsp->val;
+	/* Find a free backpressure ID slot to configure */
+	if (!FIELD_GET(NIX_AF_RX_CHANX_CFG_BP1_ENA, rx_chan_cfg)) {
+		rx_chan_cfg |= FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP1_ENA, 1) |
+			       FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP1, pfvf->ipsec.bpid);
+	} else if (!FIELD_GET(NIX_AF_RX_CHANX_CFG_BP2_ENA, rx_chan_cfg)) {
+		rx_chan_cfg |= FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP2_ENA, 1) |
+			       FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP2, pfvf->ipsec.bpid);
+	} else if (!FIELD_GET(NIX_AF_RX_CHANX_CFG_BP3_ENA, rx_chan_cfg)) {
+		rx_chan_cfg |= FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP3_ENA, 1) |
+			       FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP3, pfvf->ipsec.bpid);
+	} else {
+		netdev_err(pfvf->netdev, "No BPID available in RX channel\n");
+		return -ENONET;
+	}
+
+	/* Update the RX_CHAN_CFG to listen to backpressure due to IPsec traffic */
+	chan_cfg = otx2_mbox_alloc_msg_nix_rx_chan_cfg(&pfvf->mbox);
+	if (!chan_cfg)
+		return -ENOMEM;
+
+	/* Configure BPID for PF RX channel */
+	chan_cfg->val = rx_chan_cfg;
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	/* Enable backpressure in CPT Link's RX Channel(s) */
+#ifdef CONFIG_DCB
+	chan_cnt = IEEE_8021QAZ_MAX_TCS;
+#endif
+	for (chan = 0; chan < chan_cnt; chan++) {
+		chan_cfg = otx2_mbox_alloc_msg_nix_rx_chan_cfg(&pfvf->mbox);
+		if (!chan_cfg)
+			return -ENOMEM;
+
+		/* CPT Link can be backpressured due to buffers reaching the
+		 * threshold in SPB pool (pfvf->ipsec.spb_bpid) or due to CQ
+		 * (pfvf->bpid[chan]) entries crossing the configured threshold
+		 */
+		chan_cfg->chan = chan;
+		chan_cfg->type = NIX_INTF_TYPE_CPT;
+		chan_cfg->val = FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP0_ENA, 1) |
+				FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP0, pfvf->bpid[chan]) |
+				FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP1_ENA, 1) |
+				FIELD_PREP(NIX_AF_RX_CHANX_CFG_BP1, pfvf->ipsec.spb_bpid);
+
+		rc = otx2_sync_mbox_msg(&pfvf->mbox);
+		if (rc)
+			netdev_err(pfvf->netdev,
+				   "Failed to enable backpressure on CPT channel %d\n",
+				   chan);
+	}
+
+	return 0;
 }
 
 int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
@@ -1204,6 +1368,11 @@ int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
 		if (ret)
 			return ret;
 
+		/* Configure NIX <-> CPT backpressure */
+		ret = cn10k_ipsec_configure_cpt_bpid(pf);
+		if (ret)
+			goto out;
+
 		ret = cn10k_inb_cpt_init(netdev);
 		if (ret)
 			goto out;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 34154f002d22..a7d82757ff90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -104,6 +104,9 @@ struct cn10k_ipsec {
 	atomic_t cpt_state;
 	struct cn10k_cpt_inst_queue iq;
 
+	u32 bpid;	/* Backpressure ID for 1st pass CPT -> NIX */
+	u32 spb_bpid;	/* Backpressure ID for 2nd pass NIX -> CPT */
+
 	/* SA info */
 	u32 sa_size;
 	u32 outb_sa_count;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index e05763fbb559..209a35299061 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -168,6 +168,15 @@
 #define LMT_LF_LMTLINEX(a)		(LMT_LFBASE | 0x000 | (a) << 12)
 #define LMT_LF_LMTCANCEL		(LMT_LFBASE | 0x400)
 
+#define NIX_AF_RX_CHANX_CFG_BP0_ENA     BIT_ULL(16)
+#define NIX_AF_RX_CHANX_CFG_BP0         GENMASK_ULL(8, 0)
+#define NIX_AF_RX_CHANX_CFG_BP1_ENA     BIT_ULL(15)
+#define NIX_AF_RX_CHANX_CFG_BP1         GENMASK_ULL(28, 20)
+#define NIX_AF_RX_CHANX_CFG_BP2_ENA     BIT_ULL(14)
+#define NIX_AF_RX_CHANX_CFG_BP2         GENMASK_ULL(40, 32)
+#define NIX_AF_RX_CHANX_CFG_BP3_ENA     BIT_ULL(13)
+#define NIX_AF_RX_CHANX_CFG_BP3         GENMASK_ULL(52, 44)
+
 /* CN20K registers */
 #define RVU_PF_DISC			(0x0)
 
-- 
2.43.0

