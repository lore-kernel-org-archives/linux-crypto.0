Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECF6246763;
	Fri,  2 May 2025 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192220; cv=none; b=tdYQOQ7plSxYB5Yhgw6wHrltE1SGoSIxrgbDqXRgBiZMOOOu+uJTTzkEFGC9VjGNTWs24RIFY729CLftuSGUiBlIlDjwJtSNHLEQnkrcWbhQ4VLXsgQPweVWmwoy5TcOaAhqKy2Qpc6D7A6dVv66BJble3C8qkld2WW2/eb2Kc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192220; c=relaxed/simple;
	bh=pC2CCmebeUOTqnFjS4F/voA5+PYAyi+CQIXov6sxF7s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnDYtSQqztIthBbqeX68f6O77hFwRbxCEWUrCfoVdYZOWNh+8D2uH7204f0QDZR5ymfGsXvl42TWKlXJIjkZhYETz+NYbuJoc+mVMQsi4Z2c5zVuP1L+2tXhskMy0CN4wvmJIGuzyJv6l+tqYArWyCYk6Pe/8hfX0wnLQmjlRY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BItH495H; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BItH495H"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5429mQqd008547;
	Fri, 2 May 2025 06:23:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=n
	GpbTgCMePKMDJQ/LENXSFO/35PhxOQ5Pg3DYsRsC5k=; b=BItH495HQHKOUFlnn
	IU5JuErlABWMivjaqlmH8FrUYR877Aj2aJN3vLjDOXaM4PI1Leninfb/9Wzqj0yw
	ww3LsfNAaWpCFXYJ/IOIlsdn5Ba6VxJuxMe43l0BY3KgeSzK3cnKyz8lWaP1njb4
	TQh/UZOhsvzmSSTxMkPCfv2NG2HohtG3eUlGtfc2HgWBJ3ovADfRb9ZeDniPdKDQ
	zd0S8NxuoQe51qouKvq7Ml560EZ0ghSLr+UK3dQypY8tm10Ydnzmoa+nYerw6tmx
	sZKo1Fk8xbs6LCyIXxJ9+lzsSKADFEpFVpo/QlUuCqwEMb9ertxu8Qm5wchf10g9
	0/YmQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cuqyr9wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:23:22 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:23:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:23:21 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id C64015B6921;
	Fri,  2 May 2025 06:23:09 -0700 (PDT)
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
Subject: [net-next PATCH v1 10/15] octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
Date: Fri, 2 May 2025 18:49:51 +0530
Message-ID: <20250502132005.611698-11-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: y0kem1ieWEbiMTGGixf1tCvHlgL-rgG2
X-Authority-Analysis: v=2.4 cv=JvPxrN4C c=1 sm=1 tr=0 ts=6814c74a cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=eRz5E_71QNUotyJBA5UA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: y0kem1ieWEbiMTGGixf1tCvHlgL-rgG2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX1i38PuzQJN4l 5mCx/JTjiG9pf8pS+6auJIF5/KwtbFkB2X3wXNgEpl24F8ibJwuSOLQ4UIwgPsg/PJE1Ov7pc3w XmjKDk4QN/Ug7JPj6HB1CtYf/ZuwJl+L93+s5sMrJ5qVm48hjC8yqQRP7jV6r5N7fspd1fhzAEb
 3vYbGfd23P3b8k82gXI5Tjnjyz32uLp0g4k+wOBlvYVgZquEwDolgEvmqN03z9Zfl7esSgxAgOS x6yK4JDPwQzSsJzDeMjQztHIK2C7i0TFpiRvIRBJK0DgQolKN7dZ5+BkRUK+aY/SctyFpStvyIF dBTqyxiD7W7m08rDVqkTTGMnlYW+Tk8spKL47wU85mMxk+nPmf9+ZkHp+rfvW7oD9UWDu27FOB9
 1ZtocHxRpqvrLP8stP5xCFSz/Q+Nlm9CgSd9+qm2pe7VRn3jPR8Tmij7PNyhQjz5gL+mcVfZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

A incoming encrypted IPsec packet in the RVU NIX hardware needs
to be classified for inline fastpath processing and then assinged
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
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 201 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   2 +
 .../marvell/octeontx2/nic/otx2_common.c       |  23 +-
 .../marvell/octeontx2/nic/otx2_common.h       |  16 ++
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   4 +
 5 files changed, 227 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index c435dcae4929..b88c1b4c5839 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,193 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
+static int cn10k_ipsec_ingress_aura_init(struct otx2_nic *pfvf, int aura_id,
+					 int pool_id, int numptrs)
+{
+	struct npa_aq_enq_req *aq;
+	struct otx2_pool *pool;
+	int err;
+
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
+	struct otx2_qset *qset = &pfvf->qset;
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
+	aq->rq.xqe_drop_ena = 1; /* Enable RED dropping for CQ/SSO */
+	aq->rq.xqe_pass = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+	aq->rq.xqe_drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+	aq->rq.lpb_aura_pass = RQ_PASS_LVL_AURA;
+	aq->rq.lpb_aura_drop = RQ_DROP_LVL_AURA;
+	aq->rq.ipsech_ena = 1;		/* IPsec HW fast path enable */
+	aq->rq.ipsecd_drop_ena = 1;	/* IPsec dynamic drop enable */
+	aq->rq.xqe_drop_ena = 0;
+	aq->rq.ena_wqwd = 1;		/* Store NIX headers in packet buffer */
+	aq->rq.first_skip = 16;		/* Store packet after skiiping 16*8 bytes
+					 * to accommodate NIX headers.
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
+	int stack_pages, pool_id;
+	struct otx2_pool *pool;
+	int err, ptr, num_ptrs;
+	dma_addr_t bufptr;
+
+	num_ptrs = 256;
+	pool_id = pfvf->ipsec.inb_ipsec_pool;
+	stack_pages = (num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* Initialize aura context */
+	err = cn10k_ipsec_ingress_aura_init(pfvf, pool_id, pool_id, num_ptrs);
+	if (err)
+		goto fail;
+
+	/* Initialize pool */
+	err = otx2_pool_init(pfvf, pool_id, stack_pages, num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
+	if (err)
+		goto fail;
+
+	/* Flush accumulated messages */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto pool_fail;
+
+	/* Allocate pointers and free them to aura/pool */
+	pool = &pfvf->qset.pool[pool_id];
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
+	mutex_unlock(&pfvf->mbox.lock);
+	qmem_free(pfvf->dev, pool->stack);
+	qmem_free(pfvf->dev, pool->fc_addr);
+	page_pool_destroy(pool->page_pool);
+	devm_kfree(pfvf->dev, pool->xdp);
+	pool->xsk_pool = NULL;
+fail:
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
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
@@ -765,14 +952,22 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
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
 	if (pf->ipsec.outb_sa_count) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 6dd6ead0b28b..5b7b8f3db913 100644
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 84cd029a85aa..c077e5ae346f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -877,22 +877,6 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
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
@@ -1242,6 +1226,13 @@ int otx2_config_nix(struct otx2_nic *pfvf)
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
index 7e3ddb0bee12..b5b87b5553ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -76,6 +76,22 @@ enum arua_mapped_qtypes {
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
index 0aee8e3861f3..8f1c17fa5a0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1538,6 +1538,10 @@ int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->sqpool_cnt = otx2_get_total_tx_queues(pf);
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
+	/* Increase pool count by 1 for ingress inline IPsec */
+	pf->ipsec.inb_ipsec_pool = hw->pool_cnt;
+	hw->pool_cnt++;
+
 	if (!otx2_rep_dev(pf->pdev)) {
 		/* Maximum hardware supported transmit length */
 		pf->tx_max_pktlen = pf->netdev->max_mtu + OTX2_ETH_HLEN;
-- 
2.43.0

