Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D3285058;
	Tue, 19 Aug 2025 02:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569751; cv=none; b=QQEfDhJaIHbJiHOz0X7a8b2fgN9/blZMX6cC//p0058J+xhNN9OKH4TTOg3zJEkKVRmJsDk+/SMvDVZWum2iueTRXjxdpn5Mq32jMF0U7q/vlD2QPEkCWyUFcIh9ZDXm+8vtTvcBEj063St4FGB2xCvA/94FkxRUhG8gzX1mUtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569751; c=relaxed/simple;
	bh=gAa+pw8E5HNFT0Vv6uIsI2yBVnbNLqn5YQQAowA3P+Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grE4D6dv+j/dlAEQlfibcUwddB+IrcU+8cXsupOgPPEMpaLeGDxHwJY140x6rmpNXvzCoCwnUDcjBUK06BWd1HgIb9Q9XrzWA5QrtdLl5ywRHIyr1QUfLCddMgyfZWltI8AOtZVmAOgyj/RcGUXNWB6+EkFcLi/0gCUthLDm5yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cDLVbhNV; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cDLVbhNV"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57INVpdt002859;
	Mon, 18 Aug 2025 19:15:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=h
	pca6ZQkU9HTgvt4TJmE4EOkJFZUGIKhNVo1DGh6GGM=; b=cDLVbhNVwEpvLGlq0
	2eFLeEvXdAhFKxR17QEzhDC7eXCigCDRaUKslcLc7IxTqoKiK20jvyFc+wCObfb6
	krUMMTCSGu+Va7RbfkmIVggJUuVPoEDRE0yJP2LjQzuhbnbfzn+0DjQOzfHLw3JF
	br9cPMNOP7jXt8KJ71AL0v3lOZfBsCIoM4vHxnoZfnH0xo9dwct8DFNj8Xmk36H/
	hxczsAzCdPkAG+7cfBrMwIdi1DqeqDSor2VyeQVyvScskn8up9D/HKGCwPFFA944
	8rM9Ndl+VGIFfAVd9kwMYF12huolDDVSEON9EchQKnp4Y1sLOF11l/y7avHGWPxF
	+CtDA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 48mdx0g8x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:44 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:15:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:15:48 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 19D0A3F7078;
	Mon, 18 Aug 2025 19:15:40 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v4 09/14] octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
Date: Tue, 19 Aug 2025 07:45:00 +0530
Message-ID: <20250819021507.323752-10-tanmay@marvell.com>
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
X-Proofpoint-GUID: 2fqZ92qhEdLGoey3m6vSXVGd9RuCh91M
X-Proofpoint-ORIG-GUID: 2fqZ92qhEdLGoey3m6vSXVGd9RuCh91M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfXxxklbZkyVRBu GmRUXyQ+BT7OiuOnkNCJ3OiyOEF1S5jqB5G6QYDHf1/IpYw9rdqL+BhMkfkYVuvV/kHhAjaX+it pLPqq+ITTJY1ZC3SIzZpcOjCuUpNTADqj5blM3SqBc23OXxQpwDQXLdAycmu358rVFOB3n8IXmM
 pn1HCGbDxqMjDoKce+2gqARnUEYHORR+Ln9hVqp6Uohcebh524yKxB982zHlvVQGPan1Tolq3PN kqBs9vEzSJrn8r8swi6X0gS0bKkZbyaPdwO6eqXzFO+Tfeq4SZrVBHnhRv2fp6B6AawI4J7uoM0 6Js7dna6cKZfZexGBlwd0yJ3HLGB8fuU6OOLznZpyh0By4j9B+VDAkFEHap2QXyu1i2yw/pZIPy
 OR2hZp0/4VB3HalQD6HmKInDEUkHylMZE4/GoLu7yebsR6bOGVNN6hpyYTECHGdPB8fzkJlM
X-Authority-Analysis: v=2.4 cv=D4hHKuRj c=1 sm=1 tr=0 ts=68a3de50 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=wxMr-_5KXNIXdAki7jQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

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

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V4:
- None
 
Changes in V3:
- Added a new function, cn10k_ipsec_free_aura_ptrs() that frees
  the allocated aura pointers during interface clean.

Changes in V2:
- Fixed logic to free pool in case of errors
- Spelling fixes

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-11-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-10-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-10-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 218 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   9 +
 .../marvell/octeontx2/nic/otx2_common.c       |  23 +-
 .../marvell/octeontx2/nic/otx2_common.h       |  16 ++
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   5 +
 5 files changed, 250 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index ae2aa0b73e96..5558fb0d122f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,186 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
+static int cn10k_ipsec_ingress_aura_init(struct otx2_nic *pfvf,
+					 struct otx2_pool *pool,
+					 int aura_id, int pool_id,
+					 int numptrs)
+{
+	struct npa_aq_enq_req *aq;
+
+	/* Initialize this aura's context via AF */
+	aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->aura_id = aura_id;
+	/* Will be filled by AF with correct pool context address */
+	aq->aura.pool_addr = pool_id;
+	aq->aura.pool_caching = 1;
+	aq->aura.shift = ilog2(numptrs) - 8;
+	aq->aura.count = numptrs;
+	aq->aura.limit = numptrs;
+	aq->aura.avg_level = 255;
+	aq->aura.ena = 1;
+	aq->aura.fc_ena = 1;
+	aq->aura.fc_addr = pool->fc_addr->iova;
+	aq->aura.fc_hyst_bits = 0; /* Store count on all updates */
+	aq->aura.thresh_up = 1;
+	aq->aura.thresh = aq->aura.count / 4;
+	aq->aura.thresh_qint_idx = 0;
+
+	/* Enable backpressure for RQ aura */
+	if (!is_otx2_lbkvf(pfvf->pdev)) {
+		aq->aura.bp_ena = 0;
+		/* If NIX1 LF is attached then specify NIX1_RX.
+		 *
+		 * Below NPA_AURA_S[BP_ENA] is set according to the
+		 * NPA_BPINTF_E enumeration given as:
+		 * 0x0 + a*0x1 where 'a' is 0 for NIX0_RX and 1 for NIX1_RX so
+		 * NIX0_RX is 0x0 + 0*0x1 = 0
+		 * NIX1_RX is 0x0 + 1*0x1 = 1
+		 * But in HRM it is given that
+		 * "NPA_AURA_S[BP_ENA](w1[33:32]) - Enable aura backpressure to
+		 * NIX-RX based on [BP] level. One bit per NIX-RX; index
+		 * enumerated by NPA_BPINTF_E."
+		 */
+		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
+			aq->aura.bp_ena = 1;
+#ifdef CONFIG_DCB
+		aq->aura.nix0_bpid = pfvf->bpid[pfvf->queue_to_pfc_map[aura_id]];
+#else
+		aq->aura.nix0_bpid = pfvf->bpid[0];
+#endif
+
+		/* Set backpressure level for RQ's Aura */
+		aq->aura.bp = RQ_BP_LVL_AURA;
+	}
+
+	/* Fill AQ info */
+	aq->ctype = NPA_AQ_CTYPE_AURA;
+	aq->op = NPA_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+static int cn10k_ipsec_ingress_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
+{
+	struct nix_cn10k_aq_enq_req *aq;
+
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
+static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_pool *pool = NULL;
+	int stack_pages, pool_id;
+	int err, ptr, num_ptrs;
+	dma_addr_t bufptr;
+
+	num_ptrs = pfvf->qset.rqe_cnt;
+	pool_id = pfvf->ipsec.inb_ipsec_pool;
+	stack_pages = (num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
+	pool = &pfvf->qset.pool[pool_id];
+
+	/* Allocate memory for HW to update Aura count.
+	 * Alloc one cache line, so that it fits all FC_STYPE modes.
+	 */
+	if (!pool->fc_addr) {
+		err = qmem_alloc(pfvf->dev, &pool->fc_addr, 1, OTX2_ALIGN);
+		if (err)
+			return err;
+	}
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* Initialize aura context */
+	err = cn10k_ipsec_ingress_aura_init(pfvf, pool, pool_id, pool_id,
+					    num_ptrs);
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
+		goto pool_fail;
+
+	/* Allocate pointers and free them to aura/pool */
+	for (ptr = 0; ptr < num_ptrs; ptr++) {
+		err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, ptr);
+		if (err) {
+			err = -ENOMEM;
+			goto pool_fail;
+		}
+		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
+	}
+
+	/* Initialize RQ and map buffers from pool_id */
+	err = cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq, pool_id);
+	if (err)
+		goto pool_fail;
+
+	mutex_unlock(&pfvf->mbox.lock);
+	return 0;
+
+pool_fail:
+	qmem_free(pfvf->dev, pool->stack);
+	page_pool_destroy(pool->page_pool);
+fail:
+	mutex_unlock(&pfvf->mbox.lock);
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+	qmem_free(pfvf->dev, pool->fc_addr);
+	return err;
+}
+
+static int cn10k_inb_cpt_init(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int ret = 0;
+
+	ret = cn10k_ipsec_setup_nix_rx_hw_resources(pfvf);
+	if (ret) {
+		netdev_err(netdev, "Failed to setup NIX HW resources for IPsec\n");
+		return ret;
+	}
+
+	return ret;
+}
+
 static int cn10k_outb_cpt_clean(struct otx2_nic *pf)
 {
 	int ret;
@@ -762,25 +942,51 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
 	rtnl_unlock();
 }
 
+void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
+{
+	struct otx2_pool *pool;
+	int pool_id;
+	u64 iova;
+
+	pool_id = pfvf->ipsec.inb_ipsec_pool;
+	pool = &pfvf->qset.pool[pool_id];
+	do {
+		iova = otx2_aura_allocptr(pfvf, pool_id);
+		if (!iova)
+			break;
+		otx2_free_bufs(pfvf, pool, iova - OTX2_HEAD_ROOM,
+			       pfvf->rbsize);
+	} while (1);
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
+			return ret;
+	}
 
 	/* Don't do CPT cleanup if SA installed */
-	if (pf->ipsec.outb_sa_count) {
+	if (!list_empty(&pf->ipsec.inb_sw_ctx_list) && !pf->ipsec.outb_sa_count) {
 		netdev_err(pf->netdev, "SA installed on this device\n");
 		return -EBUSY;
 	}
 
-	return cn10k_outb_cpt_clean(pf);
+	cn10k_ipsec_clean(pf);
+	return ret;
 }
 
 int cn10k_ipsec_init(struct net_device *netdev)
@@ -848,6 +1054,8 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 
 	/* Free Ingress SA table */
 	qmem_free(pf->dev, pf->ipsec.inb_sa);
+
+	cn10k_ipsec_free_aura_ptrs(pf);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 7ffbbedf26d5..1b0faf789a38 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -111,6 +111,8 @@ struct cn10k_ipsec {
 	struct workqueue_struct *sa_workq;
 
 	/* For Inbound Inline IPSec flows */
+	u16 inb_ipsec_rq;
+	u16 inb_ipsec_pool;
 	u32 sa_tbl_entry_sz;
 	struct qmem *inb_sa;
 	struct list_head inb_sw_ctx_list;
@@ -324,6 +326,7 @@ bool otx2_sqe_add_sg_ipsec(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 			  struct otx2_snd_queue *sq, struct sk_buff *skb,
 			  int num_segs, int size);
+void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf);
 #else
 static inline __maybe_unused int cn10k_ipsec_init(struct net_device *netdev)
 {
@@ -354,5 +357,11 @@ cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
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
index f674729124e6..268abddf2bec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -869,22 +869,6 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
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
@@ -1234,6 +1218,13 @@ int otx2_config_nix(struct otx2_nic *pfvf)
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
index e3765b73c434..3104d15623b0 100644
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
index b23585c5e5c2..ceae1104cfb2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1627,6 +1627,10 @@ int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->sqpool_cnt = otx2_get_total_tx_queues(pf);
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
+	/* Increase pool count by 1 for ingress inline IPsec */
+	pf->ipsec.inb_ipsec_pool = hw->pool_cnt;
+	hw->pool_cnt++;
+
 	if (!otx2_rep_dev(pf->pdev)) {
 		/* Maximum hardware supported transmit length */
 		pf->tx_max_pktlen = pf->netdev->max_mtu + OTX2_ETH_HLEN;
@@ -1792,6 +1796,7 @@ void otx2_free_hw_resources(struct otx2_nic *pf)
 
 	/* Free RQ buffer pointers*/
 	otx2_free_aura_ptr(pf, AURA_NIX_RQ);
+	cn10k_ipsec_free_aura_ptrs(pf);
 
 	otx2_free_cq_res(pf);
 
-- 
2.43.0

