Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0DD1E98FB;
	Wed, 18 Jun 2025 11:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246289; cv=none; b=DuPg13EVDWHYCoyBICqeT27iRakC1PWeS1+Ni6txy2pqWPNrPgORqJtEMymLHrDvmH0qP5ruGrtTzUaOKdJelaXpRSSZM04QMmcmrERNAxdBw/gGsGqT0UNK4QJyP6x1F7dsNcdzIe/kOKOJk9uCG5G4HeYu6RYPLpMP8ZffoVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246289; c=relaxed/simple;
	bh=b/3ORvKsZRPFj4x7rI46nZKncmZNOwFNPecN8P4g76Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gY8b9FyB4RTZmmBwMDUIQCVvT+n4M6l8szPFe5jTawV91yx7H6uRL5gxF58hEq2MqBsgAWRLKiYqT569cUzZmnFVJfpX+n3qaxlRDzGKL0b+if/lH8h93zlbe7DcZ4OxUEhG7vGeUTfqmEXGDWxwMxmCz9mv/blm4dW0y7ws+08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JpM1vfs3; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JpM1vfs3"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I901dj026159;
	Wed, 18 Jun 2025 04:31:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	i0+E+XkvstmMVobQfFQTAkaAWmiHI9DORAipwVW5KU=; b=JpM1vfs3UHoyu7vHn
	ZxxyX55PjWER7GDYI+bboMh0eiSugWmgxAAQF6Bb3FqM4Dx3cAAT21ZfDjZkx0+I
	F2dcX+Y2d8Y1k6Oyg9Ct5czmBsDjkRtzPafWul4rcvrlMaKJfmdS1miP6RH6XnfG
	aqBluLYmHs+Nr5Vp9/79u9Yzcko5kl4bjbZwU1vwf1lMKhQnF3UFWPbOaHJEalLG
	bsJcDMsRhdfDAsUKr8opzFF0UDL6i3AzmutgMLlqp33Ca1Y6HJXkpoiBvBW9JhuP
	Dr6QhYYPJWxnl+lsJHiHffPW/nRCa7hvw2jS0sA0zSNocFyQIdbnEns3QiHnZjYp
	ANrrA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47bj4xs908-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:20 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:19 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 424933F7068;
	Wed, 18 Jun 2025 04:31:15 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 10/14] octeontx2-pf: ipsec: Handle NPA threshold interrupt
Date: Wed, 18 Jun 2025 17:00:04 +0530
Message-ID: <20250618113020.130888-11-tanmay@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=ULrdHDfy c=1 sm=1 tr=0 ts=6852a388 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=iVNeYkpuy8Kx-O5h_gEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5NyBTYWx0ZWRfX/kcpIJGBO7oR ETNupCG1am3K67sI5fRZDAP1Sd4hNiMRva42HtRzb7dusXRCMe1CaFyKXfbVIGOitRrZGiwXNOH DjPlzVq5L3lYPZxGhbY9x/s0P0++mlG5GqlPpZPQHeceOQ4D+V38DKHSVjU6B7+3sw3Qccp6wyH
 SFhFN652L5TrUHSuReL6w0mwatq+Gjnua6NzG6GFyvdM68mJOEih2AMZmRcMa9oHs+1pYUeL9rx NZCYfogOPddK0x8gKsgbreLnMvnv4bi163T9eFaBzU1HGPjbZcf0Hl5LD2ELdJjLeI/6TkhpInW kpPcoUhjiQh+lLo6DzL7NH+gLEjMwFX7J3wVJ4AHhN1VL2EZ3dkJOfzbf6SjpME/oQ551yVSo2P
 ig1k6P2CogIKbMB4MzUR868fDm2u11eWP8CmVMKkjHO0ZAbqeVu//oHRuiBAuyEDy+4S3X0s
X-Proofpoint-GUID: 2Kw3-HtU5bCx62Fv39CsozNfUDTXg5yN
X-Proofpoint-ORIG-GUID: 2Kw3-HtU5bCx62Fv39CsozNfUDTXg5yN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

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
- Fixed sparse warnings

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-12-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 94 ++++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |  2 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 +
 5 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 6283633ca58c..84ddaef22f67 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -517,10 +517,69 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
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
+	if (!(val & NPA_LF_AURA_OP_THRESH_INT))
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
+	otx2_write64(pfvf, NPA_LF_AURA_OP_INT,
+		     ((u64)pfvf->ipsec.inb_ipsec_pool << 44) |
+		     NPA_LF_AURA_OP_THRESH_INT);
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
+	void *ptr;
+	u64 val;
 
 	ret = cn10k_ipsec_setup_nix_rx_hw_resources(pfvf);
 	if (ret) {
@@ -528,6 +587,34 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
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
+	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_INT);
+	val = BIT_ULL(43) | BIT_ULL(17);
+	otx2_write64(pfvf, NPA_LF_AURA_OP_INT,
+		     ((u64)pfvf->ipsec.inb_ipsec_pool << 44) | val);
+
+	/* Enable interrupt */
+	otx2_write64(pfvf, NPA_LF_QINTX_ENA_W1S(0), BIT_ULL(0));
+
 	return ret;
 }
 
@@ -1026,6 +1113,8 @@ EXPORT_SYMBOL(cn10k_ipsec_init);
 
 void cn10k_ipsec_clean(struct otx2_nic *pf)
 {
+	int vec;
+
 	if (!is_dev_support_ipsec_offload(pf->pdev))
 		return;
 
@@ -1041,6 +1130,9 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 
 	/* Free Ingress SA table */
 	qmem_free(pf->dev, pf->ipsec.inb_sa);
+
+	vec = pci_irq_vector(pf->pdev, pf->hw.npa_msixoff);
+	free_irq(vec, pf);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 6da69e6802c8..2604edd2af68 100644
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
index 6337657cd907..fb9ea38a17ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2998,6 +2998,10 @@ int otx2_realloc_msix_vectors(struct otx2_nic *pf)
 	num_vec = hw->nix_msixoff;
 	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
 
+	/* Update number of vectors to include NPA */
+	if (hw->nix_msixoff < hw->npa_msixoff)
+		num_vec = hw->npa_msixoff + 1;
+
 	otx2_disable_mbox_intr(pf);
 	pci_free_irq_vectors(hw->pdev);
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 1cd576fd09c5..d370e00cc038 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -109,6 +109,8 @@
 #define NPA_LF_QINTX_ENA_W1C(a)         (NPA_LFBASE | 0x330 | (a) << 12)
 #define NPA_LF_AURA_BATCH_FREE0         (NPA_LFBASE | 0x400)
 
+#define NPA_LF_AURA_OP_THRESH_INT       BIT_ULL(16)
+
 /* NIX LF registers */
 #define	NIX_LFBASE			(BLKTYPE_NIX << RVU_FUNC_BLKADDR_SHIFT)
 #define	NIX_LF_RX_SECRETX(a)		(NIX_LFBASE | 0x0 | (a) << 3)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 5589fccd370b..13648b4fa246 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -547,6 +547,10 @@ static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
 	num_vec = hw->nix_msixoff;
 	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
 
+	/* Update number of vectors to include NPA */
+	if (hw->nix_msixoff < hw->npa_msixoff)
+		num_vec = hw->npa_msixoff + 1;
+
 	otx2vf_disable_mbox_intr(vf);
 	pci_free_irq_vectors(hw->pdev);
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
-- 
2.43.0

