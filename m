Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88C225522F;
	Fri,  2 May 2025 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192239; cv=none; b=mbX3S5qANY89YcITZ0PRsSzdT5Vvhh+6c4JhQ9eB5XnMnq4K/nEarIWK68RwlytpOSGJENv43nq1G74ec2MngWuPmc/y+XpwyZoBLbVx5gmqiZ8ksYuHlEAsPN7wji9HrgSTTPPu7YPsphqJvOtAOi2p2qlk9lr+nlkDjAvZd8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192239; c=relaxed/simple;
	bh=Vqe+A83lh54YiRV2ihKSwl9IdRzqp8veVM20/Y8zcN0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jbpvoS6efTD/iwhjsD/ejxZ4GMQyJGjT8jen5CGQTolsCXkxvt9VjIh5jt3evBSoPZ6cbBsmWEuH66GywTJpQHjHURbYxULG7NlcmBxSkqtj53srqLCD/3q9XFVJhBUlHZ2pynBavFpL9Kz0l5Wd+mEwE9aj6B4OQMwHoSdtU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cjdIJ+wn; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cjdIJ+wn"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542A3iur023653;
	Fri, 2 May 2025 06:23:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	6Lv5OYDs2q+y3Cn2tdE1N+/KAFSZBeuRAhZePF16is=; b=cjdIJ+wnk1c+XBxLf
	oVTlphgCaK2U84oPcy+fstzHPa+aTS6+PAZyBVAN8SguT5PFwqODNT74Odo7ehh3
	Bi/7CUmkRM0KhQW2nrme9NtHrvAtYlT+m/3/V3Kn4rQadwAwDScevQKHttIPpXIt
	Tv8VMXytbeEIc3s+hnY6G7rHx6Vd+IYKOaBKCu7eH2gtvTLMLGpdhtRk4TqYf+DE
	isgJNLzqr/mUOe2bMFbs87RlxCoUeb1XQizTLyogu2iMjHE4N9RoTwkVhObPso6e
	aHejlXvR43q7g9lj6HfnZyFPJbJKVw705CiGjkTl96VvItsd2j681llNWL7Yc51d
	/1h9w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cutur9ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:23:35 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:23:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:23:34 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 37C243F7041;
	Fri,  2 May 2025 06:23:21 -0700 (PDT)
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
Subject: [net-next PATCH v1 11/15] octeontx2-pf: ipsec: Handle NPA threshold interrupt
Date: Fri, 2 May 2025 18:49:52 +0530
Message-ID: <20250502132005.611698-12-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: LMQ2yLfuNTivbCgli8JWckRfL1GaE-33
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX7ZGZqzNhQ8rI MINVck8xAa6ThgYj51kJcEzW6j0BU56769xiTpxipVgSIPJVJztF2JieK4HCYYKo1eGOySnCq5l dbrCRywbLxbF8tfbiPuEDDPdRHJF12eqnuu51yquwgR+VHJxBgUM4Hi7yZYI8j7Ys7Eezaqfsd9
 RZFlowYylwd9Q7szXa+l7aS1pqui58lTWPWjlABiR5I+epdB//pkD9QMotwnRy9krpT1AlQRFaB fUiG9g1ir6G0/cCXrnMvS7rAtovP5v84vSEEanssOFObSXEeOprhoke+mx7ht9sr6gyoVV5FUkR 3yk0q5QKjbbYkQqTNQLZYziK8202Dymqq3N+j42tN2DiejiQD0vhsoFquIxDIv1eFq36KS2x9AF
 5ehn+XlUceKyTnuXxKeqeyJ/8P4AZdme5bmK0W6qjPhWYt9ApTEVMDs9wS59Jjzhr9QxXOTO
X-Authority-Analysis: v=2.4 cv=BaPY0qt2 c=1 sm=1 tr=0 ts=6814c757 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=JPgNaNvCGk0F3rCmk-4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: LMQ2yLfuNTivbCgli8JWckRfL1GaE-33
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

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
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 102 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   4 +
 4 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index b88c1b4c5839..365327ab9079 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -519,10 +519,77 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
 	return err;
 }
 
+static void cn10k_ipsec_npa_refill_inb_ipsecq(struct work_struct *work)
+{
+	struct cn10k_ipsec *ipsec = container_of(work, struct cn10k_ipsec,
+						 refill_npa_inline_ipsecq);
+	struct otx2_nic *pfvf = container_of(ipsec, struct otx2_nic, ipsec);
+	struct otx2_pool *pool = NULL;
+	struct otx2_qset *qset = NULL;
+	u64 val, *ptr, op_int = 0, count;
+	int err, pool_id, idx;
+	dma_addr_t bufptr;
+
+	qset = &pfvf->qset;
+
+	val = otx2_read64(pfvf, NPA_LF_QINTX_INT(0));
+	if (!(val & 1))
+		return;
+
+	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_INT);
+	val = otx2_atomic64_add(((u64)pfvf->ipsec.inb_ipsec_pool << 44), ptr);
+
+	/* Error interrupt bits */
+	if (val & 0xff)
+		op_int = (val & 0xff);
+
+	/* Refill buffers on a Threshold interrupt */
+	if (val & (1 << 16)) {
+		/* Get the current number of buffers consumed */
+		ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_CNT);
+		count = otx2_atomic64_add(((u64)pfvf->ipsec.inb_ipsec_pool << 44), ptr);
+		count &= GENMASK_ULL(35, 0);
+
+		/* Refill */
+		pool_id = pfvf->ipsec.inb_ipsec_pool;
+		pool = &pfvf->qset.pool[pool_id];
+
+		for (idx = 0; idx < count; idx++) {
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, idx);
+			if (err) {
+				netdev_err(pfvf->netdev,
+					   "Insufficient memory for IPsec pool buffers\n");
+				break;
+			}
+			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
+						    bufptr + OTX2_HEAD_ROOM);
+		}
+
+		op_int |= (1 << 16);
+	}
+
+	/* Clear/ACK Interrupt */
+	if (op_int)
+		otx2_write64(pfvf, NPA_LF_AURA_OP_INT,
+			     ((u64)pfvf->ipsec.inb_ipsec_pool << 44) | op_int);
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
@@ -530,6 +597,34 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
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
+			"RVUPF%d: IRQ registration failed for NPA QINT%d\n",
+			rvu_get_pf(pfvf->pcifunc), 0);
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
 
@@ -1028,6 +1123,8 @@ EXPORT_SYMBOL(cn10k_ipsec_init);
 
 void cn10k_ipsec_clean(struct otx2_nic *pf)
 {
+	int vec;
+
 	if (!is_dev_support_ipsec_offload(pf->pdev))
 		return;
 
@@ -1043,6 +1140,9 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 
 	/* Free Ingress SA table */
 	qmem_free(pf->dev, pf->ipsec.inb_sa);
+
+	vec = pci_irq_vector(pf->pdev, pf->hw.npa_msixoff);
+	free_irq(vec, pf);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 5b7b8f3db913..30d5812d52ad 100644
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
index 8f1c17fa5a0b..0ffc56efcc23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2909,6 +2909,10 @@ int otx2_realloc_msix_vectors(struct otx2_nic *pf)
 	num_vec = hw->nix_msixoff;
 	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
 
+	/* Update number of vectors to include NPA */
+	if (hw->nix_msixoff < hw->npa_msixoff)
+		num_vec = hw->npa_msixoff + 1;
+
 	otx2_disable_mbox_intr(pf);
 	pci_free_irq_vectors(hw->pdev);
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index fb4da816d218..0b0f8a94ca41 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -521,6 +521,10 @@ static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
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

