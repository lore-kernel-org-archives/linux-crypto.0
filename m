Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D261E257844;
	Sun, 26 Oct 2025 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491430; cv=none; b=eIQP9IYMgHXJWNpbB9/WP2jcnnDVWczpw6R77/scmMrGn5hJelO9zCkJShnloJAG9IZVdDnDLK1KR8xoja1EIYe68UIm9BZc9lpYs4mq+mG2e6P3WwyPOIdlymadf5z/2bxcjwjmIBHZa2XklwO/D3DW1/K9WFsah224QEla4MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491430; c=relaxed/simple;
	bh=UUUTXlhZIS46SNkQsYxDIqjziAT5YRo2wl6Qte+ipwY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jfG/VGj5Y8TpWwf/JV+Y2EY99SGDNkkA05CbcTSl+u0NBd8kiXu6845SwOHe/wV70wu1zJKEW9WzTFiF7Vz7boL+cefwpzIm2QIQjA/aOF5qjB5urPzGmtXqoBFloG1bG8Hh1WZY8b2yG55h3NKj4OvkcW9yUJHabLfrmUmRH+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kYzbg5aQ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kYzbg5aQ"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QBTSEp3498980;
	Sun, 26 Oct 2025 08:10:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	CNiIcRAT/ipa9DQhsSuGOdhQlcaQJMD+5H2k6asZ9Q=; b=kYzbg5aQKlKPw6TCn
	fslbflA/Q+bOPnuNASCOMosmhG4GUTG6sRKyPUseRgmu37GeBvLOsy8BShIBvr8/
	hWQUUsBKokhcrIedQ1z3zI8gI05/36cT7grCzkpl8eH0nouZVkxM3ITumTJNShoj
	gvwnytuGPhI8onG6SSBM5kfSMtKmhjkDXN/hcZoToWejNdRkDHz+VwAU5WXo0cOC
	eAciEfjW12PXdOIL7xKFyJUou9ABdbt5iQbceVtw5LpQXQEuGkunoy5RMeBjrAUb
	O0PO6J2GQea2rgeCfiblSbnY7hAVEE6kDLJCtVPjDkKoNr4LkYf5ScivMb6e679o
	ZDI6w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4a1jt807vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:23 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:33 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id BE0C93F70B5;
	Sun, 26 Oct 2025 08:10:20 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 08/15] octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
Date: Sun, 26 Oct 2025 20:39:03 +0530
Message-ID: <20251026150916.352061-9-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX1c58QAg+E3MD
 IePws7k5ub4cQu2Gk3EtkotA8Q1ghsCe9UYIs+FtSj/zdz+KIofgTtWbiAwPj6W1U/n96C6THBH
 PW2jkc3Cc2fjbOGj3IM88pBYSpa11khqjQ30QhQab6HnvXZrlgptUH/eOfJOXKitqWrBTs3pLEC
 M2W2ZlCzvZaIaY0mR+ixuU8/lA2Vn9xEHIGc7fxTCR2RmIrUIRgDuklCyIjznMXX6py8o4UdmQ3
 wT3d6zWD2Hg8uI5atDqiA8tikicizzjzZlfMyDS6luvVdBXvcHDYETCz5hh8t+qOFYyFRp+Hp58
 vwS2QF2L0Naphvta+AW+r7XZOKK9s5zcKEsIAYh1JQ+8/yjjOAnWpUdCsuYI2s9vVSqLKXhdy4H
 EAGbDqmTf+ahy3FGk03cfqHNwx0Znw==
X-Proofpoint-GUID: LqV8TQA0MyyLkKQ3UUVgJGmNu0lJLA41
X-Proofpoint-ORIG-GUID: LqV8TQA0MyyLkKQ3UUVgJGmNu0lJLA41
X-Authority-Analysis: v=2.4 cv=APHuRV3Y c=1 sm=1 tr=0 ts=68fe39df cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=T5pxirhoQpyptJQ-KkoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

A incoming encrypted IPsec packet in the RVU NIX hardware needs
to be classified for inline fastpath processing and then assigned
a RQ and Aura pool before sending to CPT for decryption.

Create a dedicated RQ, Aura and Pool with the following setup
specifically for IPsec flows:
 - Set ipsech_en, ipsecd_drop_en in RQ context to enable hardware
   fastpath processing for IPsec flows.
 - Configure the dedicated Aura to raise an interrupt when
   it's buffer count drops below a threshold value so that the
   buffers can be replenished from the CPU.

The RQ, Aura and Pool contexts are initialized only when esp-hw-offload
feature is enabled via ethtool.

Also, move some of the RQ context macro definitions to otx2_common.h
so that they can be used in the IPsec driver as well.

Also create per-RQ short packet buffer (SPB) pools which will be
used to store the decrypted meta packets. Also, setup a counter
for these SPB buffers which will be used to refill the first pass
buffer pool. This logic is added to prevent any packet drops in the
the second pass.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- Created a separate per-RQ SPB pool to store the 2nd pass
  metapackets.
- Added a per SPB pool counter to track and refill the first
  pass buffer pool

Changes in V4:
- None

Changes in V3:
- Added a new function, cn10k_ipsec_free_aura_ptrs() that frees
  the allocated aura pointers during interface clean.                                               

Changes in V2:                                                                                      - Fixed logic to free pool in case of errors
- Spelling fixes

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-11-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-10-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-10-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-10-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 229 ++++++++++++++++--
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  13 +
 .../marvell/octeontx2/nic/otx2_common.c       |  26 +-
 .../marvell/octeontx2/nic/otx2_common.h       |  16 ++
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
 5 files changed, 259 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 77543d472345..e2abdac27ba5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -333,10 +333,6 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf,
 						CN10K_CPT_LF_NQX(0));
 
-	/* Set ipsec offload enabled for this device */
-	pf->flags |= OTX2_FLAG_IPSEC_OFFLOAD_ENABLED;
-
-	cn10k_cpt_device_set_available(pf);
 	return 0;
 
 lf_free:
@@ -346,17 +342,161 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
-static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
+static int cn10k_ipsec_ingress_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 {
-	int ret;
+	struct nix_cn10k_aq_enq_req *aq;
 
-	if (!cn10k_cpt_device_set_inuse(pf)) {
-		netdev_err(pf->netdev, "CPT LF device unavailable\n");
-		return -ENODEV;
+	/* Get memory to put this msg */
+	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->rq.cq = qidx;
+	aq->rq.ena = 1;
+	aq->rq.pb_caching = 1;
+	aq->rq.lpb_aura = lpb_aura; /* Use large packet buffer aura */
+	aq->rq.lpb_sizem1 = (DMA_BUFFER_LEN(pfvf->rbsize) / 8) - 1;
+	aq->rq.xqe_imm_size = 0; /* Copying of packet to CQE not needed */
+	aq->rq.flow_tagw = 32; /* Copy full 32bit flow_tag to CQE header */
+	aq->rq.qint_idx = 0;
+	aq->rq.lpb_drop_ena = 1; /* Enable RED dropping for AURA */
+	aq->rq.lpb_aura_pass = RQ_PASS_LVL_AURA;
+	aq->rq.lpb_aura_drop = RQ_DROP_LVL_AURA;
+	aq->rq.ipsech_ena = 1;		/* IPsec HW fast path enable */
+	aq->rq.ipsecd_drop_ena = 1;	/* IPsec dynamic drop enable */
+	aq->rq.ena_wqwd = 1;		/* Store NIX header in packet buffer */
+	aq->rq.first_skip = 16;		/* Store packet after skipping 16x8
+					 * bytes to accommodate NIX header.
+					 */
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_RQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+static int cn10k_ipsec_aura_and_pool_init(struct otx2_nic *pfvf, int pool_id)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_pool *pool = NULL;
+	int num_ptrs, stack_pages;
+	dma_addr_t bufptr;
+	int err, ptr;
+
+	num_ptrs = pfvf->qset.rqe_cnt;
+	stack_pages = (num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
+	pool = &pfvf->qset.pool[pool_id];
+
+	/* Initialize aura context */
+	err = otx2_aura_init(pfvf, pool_id, pool_id, num_ptrs);
+	if (err)
+		goto fail;
+
+	/* Initialize pool */
+	err = otx2_pool_init(pfvf, pool_id, stack_pages, num_ptrs, pfvf->rbsize,
+			     AURA_NIX_RQ);
+	if (err)
+		goto fail;
+
+	/* Flush accumulated messages */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	/* Allocate pointers and free them to aura/pool */
+	for (ptr = 0; ptr < num_ptrs; ptr++) {
+		err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, ptr);
+		if (err) {
+			err = -ENOMEM;
+			goto free_auras;
+		}
+		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
 	}
 
-	/* Set ipsec offload disabled for this device */
-	pf->flags &= ~OTX2_FLAG_IPSEC_OFFLOAD_ENABLED;
+	return err;
+
+free_auras:
+	cn10k_ipsec_free_aura_ptrs(pfvf);
+fail:
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+	return err;
+}
+
+static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
+{
+	int rbsize, err, pool;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* Initialize Pool for first pass */
+	err = cn10k_ipsec_aura_and_pool_init(pfvf, pfvf->ipsec.inb_ipsec_pool);
+	if (err)
+		return err;
+
+	/* Initialize first pass RQ and map buffers from pool_id */
+	err = cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq,
+					  pfvf->ipsec.inb_ipsec_pool);
+	if (err)
+		goto free_auras;
+
+	/* Initialize SPB pool for second pass */
+	rbsize = pfvf->rbsize;
+	pfvf->rbsize = 512;
+
+	for (pool = pfvf->ipsec.inb_ipsec_spb_pool;
+	     pool < pfvf->hw.rx_queues + pfvf->ipsec.inb_ipsec_spb_pool; pool++) {
+		err = cn10k_ipsec_aura_and_pool_init(pfvf, pool);
+		if (err)
+			goto free_auras;
+	}
+	pfvf->rbsize = rbsize;
+
+	mutex_unlock(&pfvf->mbox.lock);
+	return 0;
+
+free_auras:
+	cn10k_ipsec_free_aura_ptrs(pfvf);
+	mutex_unlock(&pfvf->mbox.lock);
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+	return err;
+}
+
+static int cn10k_inb_cpt_init(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int ret = 0, spb_cnt;
+
+	/* Allocate SPB buffer count array to track the number of inbound SPB
+	 * buffers received per RX queue. This count would later be used to
+	 * refill the first pass IPsec pool.
+	 */
+	pfvf->ipsec.inb_spb_count = devm_kmalloc_array(pfvf->dev,
+						       pfvf->hw.rx_queues,
+						       sizeof(atomic_t),
+						       GFP_KERNEL);
+	if (!pfvf->ipsec.inb_spb_count) {
+		netdev_err(netdev, "Failed to allocate inbound SPB buffer count array\n");
+		return -ENOMEM;
+	}
+
+	for (spb_cnt = 0; spb_cnt < pfvf->hw.rx_queues; spb_cnt++)
+		atomic_set(&pfvf->ipsec.inb_spb_count[spb_cnt], 0);
+
+	/* Setup NIX RX HW resources for inline inbound IPSec */
+	ret = cn10k_ipsec_setup_nix_rx_hw_resources(pfvf);
+	if (ret) {
+		netdev_err(netdev, "Failed to setup NIX HW resources for IPsec\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
+{
+	int ret;
 
 	/* Disable CPTLF Instruction Queue (IQ) */
 	cn10k_outb_cptlf_iq_disable(pf);
@@ -374,7 +514,6 @@ static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
 	if (ret)
 		netdev_err(pf->netdev, "Failed to detach CPT LF\n");
 
-	cn10k_cpt_device_set_unavailable(pf);
 	return ret;
 }
 
@@ -762,25 +901,76 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
 	rtnl_unlock();
 }
 
+void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
+{
+	struct otx2_pool *pool;
+	int pool_id;
+	u64 iova;
+
+	/* Free all first and second pass pool buffers */
+	for (pool_id = pfvf->ipsec.inb_ipsec_spb_pool;
+	     pool_id <= pfvf->ipsec.inb_ipsec_pool; pool_id++) {
+		pool = &pfvf->qset.pool[pool_id];
+		do {
+			iova = otx2_aura_allocptr(pfvf, pool_id);
+			if (!iova)
+				break;
+			otx2_free_bufs(pfvf, pool, iova - OTX2_HEAD_ROOM,
+				       pfvf->rbsize);
+		} while (1);
+	}
+}
+
+static void cn10k_ipsec_free_hw_resources(struct otx2_nic *pfvf)
+{
+	if (!cn10k_cpt_device_set_inuse(pfvf)) {
+		netdev_err(pfvf->netdev, "CPT LF device unavailable\n");
+		return;
+	}
+
+	cn10k_outb_cpt_clean(pfvf);
+
+	/* Free the per spb pool buffer counters */
+	devm_kfree(pfvf->dev, pfvf->ipsec.inb_spb_count);
+
+	cn10k_ipsec_free_aura_ptrs(pfvf);
+}
+
 int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
+	int ret = 0;
 
 	/* IPsec offload supported on cn10k */
 	if (!is_dev_support_ipsec_offload(pf->pdev))
 		return -EOPNOTSUPP;
 
-	/* Initialize CPT for outbound ipsec offload */
-	if (enable)
-		return cn10k_outb_cpt_init(netdev);
+	/* Initialize CPT for outbound and inbound IPsec offload */
+	if (enable) {
+		ret = cn10k_outb_cpt_init(netdev);
+		if (ret)
+			return ret;
+
+		ret = cn10k_inb_cpt_init(netdev);
+		if (ret)
+			goto out;
+
+		/* Set ipsec offload enabled for this device */
+		pf->flags |= OTX2_FLAG_IPSEC_OFFLOAD_ENABLED;
+		cn10k_cpt_device_set_available(pf);
+		return ret;
+	}
 
 	/* Don't do CPT cleanup if SA installed */
-	if (pf->ipsec.outb_sa_count) {
+	if (!pf->ipsec.outb_sa_count) {
 		netdev_err(pf->netdev, "SA installed on this device\n");
 		return -EBUSY;
 	}
 
-	return cn10k_outb_cpt_clean(pf);
+out:
+	cn10k_ipsec_free_hw_resources(pf);
+	cn10k_cpt_device_set_unavailable(pf);
+	return ret;
 }
 
 int cn10k_ipsec_init(struct net_device *netdev)
@@ -828,7 +1018,10 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 		pf->ipsec.sa_workq = NULL;
 	}
 
-	cn10k_outb_cpt_clean(pf);
+	/* Set ipsec offload disabled for this device */
+	pf->flags &= ~OTX2_FLAG_IPSEC_OFFLOAD_ENABLED;
+
+	cn10k_ipsec_free_hw_resources(pf);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 43fbce0d6039..78baddb9ffda 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -92,6 +92,12 @@ struct cn10k_ipsec {
 	u32 outb_sa_count;
 	struct work_struct sa_work;
 	struct workqueue_struct *sa_workq;
+
+	/* For Inbound Inline IPSec flows */
+	u16 inb_ipsec_rq;
+	u16 inb_ipsec_pool;
+	u16 inb_ipsec_spb_pool;
+	atomic_t *inb_spb_count;
 };
 
 /* CN10K IPSEC Security Association (SA) */
@@ -231,6 +237,7 @@ bool otx2_sqe_add_sg_ipsec(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 			  struct otx2_snd_queue *sq, struct sk_buff *skb,
 			  int num_segs, int size);
+void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -261,5 +268,11 @@ cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 {
 	return true;
 }
+
+static inline __maybe_unused
+void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
+{
+}
+
 #endif
 #endif // CN10K_IPSEC_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index aff17c37ddde..754b95c96c28 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -871,22 +871,6 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
 	}
 }
 
-/* RED and drop levels of CQ on packet reception.
- * For CQ level is measure of emptiness ( 0x0 = full, 255 = empty).
- */
-#define RQ_PASS_LVL_CQ(skid, qsize)	((((skid) + 16) * 256) / (qsize))
-#define RQ_DROP_LVL_CQ(skid, qsize)	(((skid) * 256) / (qsize))
-
-/* RED and drop levels of AURA for packet reception.
- * For AURA level is measure of fullness (0x0 = empty, 255 = full).
- * Eg: For RQ length 1K, for pass/drop level 204/230.
- * RED accepts pkts if free pointers > 102 & <= 205.
- * Drops pkts if free pointers < 102.
- */
-#define RQ_BP_LVL_AURA   (255 - ((85 * 256) / 100)) /* BP when 85% is full */
-#define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
-#define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */
-
 int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 {
 	struct otx2_qset *qset = &pfvf->qset;
@@ -911,6 +895,9 @@ int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 	aq->rq.xqe_drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
 	aq->rq.lpb_aura_pass = RQ_PASS_LVL_AURA;
 	aq->rq.lpb_aura_drop = RQ_DROP_LVL_AURA;
+	/* Set SPB aura that would be used for 2nd pass IPsec packets */
+	aq->rq.spb_aura = pfvf->ipsec.inb_ipsec_spb_pool + lpb_aura;
+	aq->rq.spb_sizem1 = 0x1f;
 
 	/* Fill AQ info */
 	aq->qidx = qidx;
@@ -1236,6 +1223,13 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
 	nixlf->rss_grps = MAX_RSS_GROUPS;
 	nixlf->xqe_sz = pfvf->hw.xqe_size == 128 ? NIX_XQESZ_W16 : NIX_XQESZ_W64;
+	/* Add an additional RQ for inline inbound IPsec flows
+	 * and store the RQ index for setting it up later when
+	 * IPsec offload is enabled via ethtool.
+	 */
+	nixlf->rq_cnt++;
+	pfvf->ipsec.inb_ipsec_rq = pfvf->hw.rx_queues;
+
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
 	 * NPA LF attached to this RVU PF/VF.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 1c8a3c078a64..c7bca4e04d1a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -84,6 +84,22 @@ enum arua_mapped_qtypes {
 /* Send skid of 2000 packets required for CQ size of 4K CQEs. */
 #define SEND_CQ_SKID	2000
 
+/* RED and drop levels of CQ on packet reception.
+ * For CQ level is measure of emptiness ( 0x0 = full, 255 = empty).
+ */
+#define RQ_PASS_LVL_CQ(skid, qsize)	((((skid) + 16) * 256) / (qsize))
+#define RQ_DROP_LVL_CQ(skid, qsize)	(((skid) * 256) / (qsize))
+
+/* RED and drop levels of AURA for packet reception.
+ * For AURA level is measure of fullness (0x0 = empty, 255 = full).
+ * Eg: For RQ length 1K, for pass/drop level 204/230.
+ * RED accepts pkts if free pointers > 102 & <= 205.
+ * Drops pkts if free pointers < 102.
+ */
+#define RQ_BP_LVL_AURA   (255 - ((85 * 256) / 100)) /* BP when 85% is full */
+#define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
+#define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */
+
 #define OTX2_GET_RX_STATS(reg) \
 	otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
 #define OTX2_GET_TX_STATS(reg) \
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index e808995703cf..e4be6744c990 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1627,6 +1627,14 @@ int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->sqpool_cnt = otx2_get_total_tx_queues(pf);
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
+	/* Create an additional LPB pool for 1st pass IPsec packets and
+	 * one SPB pool per RX queue for storing 2nd pass meta-IPsec packets.
+	 */
+	pf->ipsec.inb_ipsec_spb_pool = hw->pool_cnt;
+	hw->pool_cnt += hw->rx_queues;
+	pf->ipsec.inb_ipsec_pool = hw->pool_cnt;
+	hw->pool_cnt++;
+
 	if (!otx2_rep_dev(pf->pdev)) {
 		/* Maximum hardware supported transmit length */
 		pf->tx_max_pktlen = pf->netdev->max_mtu + OTX2_ETH_HLEN;
@@ -1792,6 +1800,7 @@ void otx2_free_hw_resources(struct otx2_nic *pf)
 
 	/* Free RQ buffer pointers*/
 	otx2_free_aura_ptr(pf, AURA_NIX_RQ);
+	cn10k_ipsec_free_aura_ptrs(pf);
 
 	otx2_free_cq_res(pf);
 
-- 
2.43.0

