Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0A4298997;
	Fri, 11 Jul 2025 12:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752236063; cv=none; b=Ax5xPtAwzuXPY52KJW0dzxix5JSAzRIXTWe/lLrb2lJ65dPBBPyGxRYpEHLxjKFOWU912roiTUNbyySVFCgB2hYRxS2lJQeK+xE3eobJrCpb7WmP6X6lFSQG+QP+OFI+rTuTPT5umVEQk856h/y3a5j7D3oK6xFceJ0QVhY38Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752236063; c=relaxed/simple;
	bh=IMiRPPZtiwMdAG4wLC//WbEkAAhDsmLXVyjHzjywkBc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nleYd8jsde4ecNDN1YMLDzYU2rgA2L6mM8FFD5lVwB6LMMEiFTtv1bQYJuf/yDoWUf7cDyYBtRVZSbD8mo6wFtEvAvy2lQtmsPQjgmuFxV4WihGR4VxCvOE9M2TI+xR2QUPnu/6EjFtArwsjK+QTh2p8BURw8HClOutY4gjYDwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Y1QLaqRk; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Y1QLaqRk"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7pgd3013972;
	Fri, 11 Jul 2025 05:14:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=9
	wdP1qokpOKlROwTqKDcU/O+G5O2jM9ANvW6w3ikJIs=; b=Y1QLaqRkWbYPwnIoz
	nZKGfDmFOihWuGcOqd0ITmY5WTyc0eBogISv3WzjWyWGPaBLw9+DLyQvMPlBFrKh
	r6co689QEYtaWMnwFj4lcQeFLkhlaJ2f4KmcNIWLjCVtffZO1RoU1xa7TEdvnAsM
	BSCpcNL4cdjS2q6e6JM5E4BZ6hQaaOJlIiCSKdNQMFFJP+bE95D1gQ/442fC75Xg
	i0ve7nAwYQIfwm3aHQwOn9jMsAoCZeRtviAgzM6aIre8yuHiQD8b+ZALc6EJ8YBa
	rUOEbEg6cY/JlQDAnl379GJSN0dSrg0SoArxZexc2YMBrJswKHtQvKBZaGs2Sd9D
	8Jsrg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47txkg8dcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 05:14:14 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 11 Jul 2025 05:14:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 11 Jul 2025 05:14:12 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id A46723F7058;
	Fri, 11 Jul 2025 05:14:10 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <herbert@gondor.apana.org.au>, <sgoutham@marvell.com>,
        <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v3 10/14] octeontx2-pf: ipsec: Handle NPA threshold interrupt
Date: Fri, 11 Jul 2025 17:43:03 +0530
Message-ID: <20250711121317.340326-11-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250711121317.340326-1-tanmay@marvell.com>
References: <20250711121317.340326-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: IO9ZmBUEyoHUdY0y0QZmt-y7H-L8FuEs
X-Proofpoint-ORIG-GUID: IO9ZmBUEyoHUdY0y0QZmt-y7H-L8FuEs
X-Authority-Analysis: v=2.4 cv=OP0n3TaB c=1 sm=1 tr=0 ts=68710016 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=xvcL_y0s6g7ZpoMfgXAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA4NiBTYWx0ZWRfX9aav4zZ8EspL j6LYVq4y/dFeEeAQYwTvj6wiSTUm5wwdwk166iVP8cIyBXgsG5OpzJjZn/BfoERHIv7h0DoeAzR UTqhhAde2RtlbKAuOODDgIWisor8H3oU9zkPuyoDZqoXGj00oyvufGMBSjnsUv7m6twVVX6m8DX
 tEdG+ItvkhMFoZU9mEw3p1fuyeVoPAmBAOKyJMBUEDglGVtzB/O+K++8nTordnx+Q9Nso+Y7Jqy VBA517TauuG/nB6ONQQIexahekFZgrem3ZTl7j7KTeMWsMNUA7iHvuNQ0Lxq2dN9gWIgBySPJ24 UBOjkTbBH6nYp15EqOg6Y/f8C1g7jW1soeBu9aC73B2J2Bce8Roxsj79wjAqn5VDTncx/xu8D/B
 rnkaD/3QKOzyePmt3DNShy9drpPXA//9ZYtx7Dm+PrsgmLnJAxvNNlREocyrD4UPO69Fv00r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01

The NPA Aura pool that is dedicated for 1st pass inline IPsec flows
raises an interrupt when the buffers of that aura_id drop below a
threshold value.

Add the following changes to handle this interrupt
- Increase the number of MSIX vectors requested for the PF/VF to
  include NPA vector.
- Create a workqueue (refill_npa_inline_ipsecq) to allocate and
  refill buffers to the pool.
- When the interrupt is raised, schedule the workqueue entry,
  cn10k_ipsec_npa_refill_inb_ipsecq(), where the current count of
  consumed buffers is determined via NPA_LF_AURA_OP_CNT and then
  replenished.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V2:
- Dropped the unused 'ptr' variable in cn10k_inb_cpt_init().
- Use FIELD_PREP macros
- Reduced the number of MSIX vectors requested for NPA
- Disabled the NPA threshold interrupt in cn10k_ipsec_free_aura_ptrs()

Changes in V2:
- Fixed sparse warnings

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-12-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-11-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 100 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   5 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   4 +
 5 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index e7b396b531a4..8d32a2477631 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -517,10 +517,68 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
 	return err;
 }
 
+static void cn10k_ipsec_npa_refill_inb_ipsecq(struct work_struct *work)
+{
+	struct cn10k_ipsec *ipsec = container_of(work, struct cn10k_ipsec,
+						 refill_npa_inline_ipsecq);
+	struct otx2_nic *pfvf = container_of(ipsec, struct otx2_nic, ipsec);
+	struct otx2_pool *pool = NULL;
+	int err, pool_id, idx;
+	void __iomem *ptr;
+	dma_addr_t bufptr;
+	u64 val, count;
+
+	val = otx2_read64(pfvf, NPA_LF_QINTX_INT(0));
+	if (!(val & 1))
+		return;
+
+	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_INT);
+	val = otx2_atomic64_add(((u64)pfvf->ipsec.inb_ipsec_pool << 44), ptr);
+
+	/* Refill buffers only on a threshold interrupt */
+	if (!(val & NPA_LF_AURA_OP_INT_THRESH_INT))
+		return;
+
+	/* Get the current number of buffers consumed */
+	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_CNT);
+	count = otx2_atomic64_add(((u64)pfvf->ipsec.inb_ipsec_pool << 44), ptr);
+	count &= GENMASK_ULL(35, 0);
+
+	/* Allocate and refill to the IPsec pool */
+	pool_id = pfvf->ipsec.inb_ipsec_pool;
+	pool = &pfvf->qset.pool[pool_id];
+
+	for (idx = 0; idx < count; idx++) {
+		err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, idx);
+		if (err) {
+			netdev_err(pfvf->netdev,
+				   "Insufficient memory for IPsec pool buffers\n");
+			break;
+		}
+		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
+	}
+
+	/* Clear/ACK Interrupt */
+	val = FIELD_PREP(NPA_LF_AURA_OP_INT_AURA, pfvf->ipsec.inb_ipsec_pool);
+	val |= NPA_LF_AURA_OP_INT_THRESH_INT;
+	otx2_write64(pfvf, NPA_LF_AURA_OP_INT, val);
+}
+
+static irqreturn_t cn10k_ipsec_npa_inb_ipsecq_intr_handler(int irq, void *data)
+{
+	struct otx2_nic *pf = data;
+
+	schedule_work(&pf->ipsec.refill_npa_inline_ipsecq);
+
+	return IRQ_HANDLED;
+}
+
 static int cn10k_inb_cpt_init(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	int ret = 0;
+	int ret = 0, vec;
+	char *irq_name;
+	u64 val;
 
 	ret = cn10k_ipsec_setup_nix_rx_hw_resources(pfvf);
 	if (ret) {
@@ -528,6 +586,34 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
 		return ret;
 	}
 
+	/* Work entry for refilling the NPA queue for ingress inline IPSec */
+	INIT_WORK(&pfvf->ipsec.refill_npa_inline_ipsecq,
+		  cn10k_ipsec_npa_refill_inb_ipsecq);
+
+	/* Register NPA interrupt */
+	vec = pfvf->hw.npa_msixoff;
+	irq_name = &pfvf->hw.irq_name[vec * NAME_SIZE];
+	snprintf(irq_name, NAME_SIZE, "%s-npa-qint", pfvf->netdev->name);
+
+	ret = request_irq(pci_irq_vector(pfvf->pdev, vec),
+			  cn10k_ipsec_npa_inb_ipsecq_intr_handler, 0,
+			  irq_name, pfvf);
+	if (ret) {
+		dev_err(pfvf->dev,
+			"RVUPF%d: IRQ registration failed for NPA QINT\n",
+			rvu_get_pf(pfvf->pdev, pfvf->pcifunc));
+		return ret;
+	}
+
+	/* Enable NPA threshold interrupt */
+	val = FIELD_PREP(NPA_LF_AURA_OP_INT_AURA, pfvf->ipsec.inb_ipsec_pool);
+	val |= NPA_LF_AURA_OP_INT_SETOP;
+	val |= NPA_LF_AURA_OP_INT_THRESH_ENA;
+	otx2_write64(pfvf, NPA_LF_AURA_OP_INT, val);
+
+	/* Enable interrupt */
+	otx2_write64(pfvf, NPA_LF_QINTX_ENA_W1S(0), BIT_ULL(0));
+
 	return ret;
 }
 
@@ -951,7 +1037,12 @@ void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
 {
 	struct otx2_pool *pool;
 	int pool_id;
-	u64 iova;
+	u64 iova, val;
+
+	/* Disable threshold interrupt */
+	val = FIELD_PREP(NPA_LF_AURA_OP_INT_AURA, pfvf->ipsec.inb_ipsec_pool);
+	val |= NPA_LF_AURA_OP_INT_THRESH_ENA;
+	otx2_write64(pfvf, NPA_LF_AURA_OP_INT, val);
 
 	pool_id = pfvf->ipsec.inb_ipsec_pool;
 	pool = &pfvf->qset.pool[pool_id];
@@ -1044,6 +1135,8 @@ EXPORT_SYMBOL(cn10k_ipsec_init);
 
 void cn10k_ipsec_clean(struct otx2_nic *pf)
 {
+	int vec;
+
 	if (!is_dev_support_ipsec_offload(pf->pdev))
 		return;
 
@@ -1061,6 +1154,9 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 	qmem_free(pf->dev, pf->ipsec.inb_sa);
 
 	cn10k_ipsec_free_aura_ptrs(pf);
+
+	vec = pci_irq_vector(pf->pdev, pf->hw.npa_msixoff);
+	free_irq(vec, pf);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 1b0faf789a38..7eb4ca36c14a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -117,6 +117,7 @@ struct cn10k_ipsec {
 	struct qmem *inb_sa;
 	struct list_head inb_sw_ctx_list;
 	DECLARE_BITMAP(inb_sa_table, CN10K_IPSEC_INB_MAX_SA);
+	struct work_struct refill_npa_inline_ipsecq;
 };
 
 /* CN10K IPSEC Security Association (SA) */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ceae1104cfb2..d1e77ea7b290 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2995,6 +2995,10 @@ int otx2_realloc_msix_vectors(struct otx2_nic *pf)
 	num_vec = hw->nix_msixoff;
 	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
 
+	/* Update number of vectors to include NPA */
+	if (hw->nix_msixoff < hw->npa_msixoff)
+		num_vec = hw->npa_msixoff;
+
 	otx2_disable_mbox_intr(pf);
 	pci_free_irq_vectors(hw->pdev);
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 1cd576fd09c5..d270f96c5a3c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -109,6 +109,11 @@
 #define NPA_LF_QINTX_ENA_W1C(a)         (NPA_LFBASE | 0x330 | (a) << 12)
 #define NPA_LF_AURA_BATCH_FREE0         (NPA_LFBASE | 0x400)
 
+#define NPA_LF_AURA_OP_INT_THRESH_INT	BIT_ULL(16)
+#define NPA_LF_AURA_OP_INT_THRESH_ENA	BIT_ULL(17)
+#define NPA_LF_AURA_OP_INT_SETOP	BIT_ULL(43)
+#define NPA_LF_AURA_OP_INT_AURA		GENMASK_ULL(63, 44)
+
 /* NIX LF registers */
 #define	NIX_LFBASE			(BLKTYPE_NIX << RVU_FUNC_BLKADDR_SHIFT)
 #define	NIX_LF_RX_SECRETX(a)		(NIX_LFBASE | 0x0 | (a) << 3)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 5589fccd370b..951d5c17c75d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -547,6 +547,10 @@ static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
 	num_vec = hw->nix_msixoff;
 	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
 
+	/* Update number of vectors to include NPA */
+	if (hw->nix_msixoff < hw->npa_msixoff)
+		num_vec = hw->npa_msixoff;
+
 	otx2vf_disable_mbox_intr(vf);
 	pci_free_irq_vectors(hw->pdev);
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
-- 
2.43.0

