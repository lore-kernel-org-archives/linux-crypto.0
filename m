Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1329922B8A6;
	Sun, 26 Oct 2025 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491436; cv=none; b=NQRzgFhWZXD5TPt0fQeVFvO0z2Cs6FAnL7OAAzEePsxwnawTFeyswXxGHUB0qW5MUMkNO5GS0J30X2Cdt1Kqem/5RYkuVxNSLSka9VeEKn412uX18xpEWP9Hthxi+6UvlLRkX2jkPgk+n0fH9mZUFNUZbzTleEO3q8QYI6ra1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491436; c=relaxed/simple;
	bh=pFfXKmHhSyTmYfECdFDVx5922f3FA0KCydie+DlZQeQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bx0KkWAkQKhyxCGS1bLyF8mzsGa1aKwuH3v+8SqQDScEPClExd72jG0TQcutgkEMsrkheCY3NFrnA+4/nTBmO2/gTrasrJjAI9vBj1YNa/4wB1JFqNs64nTFbS7vt6ur2Q752ORlD7buiNiRjos+eC/pL1z3nrx0fcVx3azFqXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=c2zJTvf1; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="c2zJTvf1"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QEuaqT3857975;
	Sun, 26 Oct 2025 08:10:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	iSIjzqXMuCg0Ff1By4xqcE5f/GlrwPsNiNsqaBnYZY=; b=c2zJTvf1BvKW71OUq
	sRdddY/5yUKx31Mo5BvwHSMnmxK8HgUSdDH+LnGOLHBPAKcT9X09URjNWe5agNZP
	foQFEKvj/2ggNrOhvjq3m4Y56fB6wR4hoIcz3dn0oP7plObax5xkcq6A75U7GC4D
	bN5qRLV8fKGAItYTlsIXOnfzm2SS6JBv2QWp3RIYx50uFIKmBghXC7bfqw0uvPUW
	M5GpZpC4DlqxONwiZHeDyQs4doFGGBa6OK4BjN4cUo4MGkp/93iVhcj2TUFVWUdK
	dq1MrG87jD7OyW75VXfBrAASyDjZZmzlU+j13c3cXjGN17z1b+Dft4oUxnibbvgt
	IKZoQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4a1jt807vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:30 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:40 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 18F253F70DE;
	Sun, 26 Oct 2025 08:10:26 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 10/15] octeontx2-pf: ipsec: Handle NPA threshold interrupt
Date: Sun, 26 Oct 2025 20:39:05 +0530
Message-ID: <20251026150916.352061-11-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX2wDIUWZKMYel
 U/DMhq+/0iWdagAL0nPosNGtF8mjZWwZ0U0C3OvPEZvcsmIbME/9rKxifK7/OtCONkqQ33ump7Q
 xcuLIH/ZJnGPJf1t4EAcuhJQYJsPkw1TKSXDpNqbsD+IFHgvXvcPvG56NF6LK+Q5w2MunOqxHMt
 vvSbOXgSJKo56KHd3nhY/TMQlx9Zc/dpzBeIK0GazSQRsAnd/QpzOJ1lzyzqMCmrSAvHWQMwz6t
 /GaTg7AIn7vHdOeQ31rFa013kzmQHdvR6hFfBMfMXkvkze5w0/tVdJ4IIRtVQohYQfDgENuT21I
 k0GkXNTIstD6qz+5LIb3i61WsrB35tQw1/nCLfgjX17IT+FIrP6F7jpkuT30u3OJl24akQZ/RwJ
 uXrRelCBrqUhxbXS7diDbbgP4aJY3w==
X-Proofpoint-GUID: JAvPeFCG6--T4l8DvsUU4l03hA8Upyjy
X-Proofpoint-ORIG-GUID: JAvPeFCG6--T4l8DvsUU4l03hA8Upyjy
X-Authority-Analysis: v=2.4 cv=APHuRV3Y c=1 sm=1 tr=0 ts=68fe39e6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=BK_dZi9wOfJuS42oONkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

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
  received packets is calculated by summing the per SPB pool counters
  and then refilled. This method is added to avoid any drops in the
  hardware during the second pass.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- The number of buffers to be refilled is now calculated by
  summing the number of received spb buffers instead of reading
  the NPA_LF_AURA_OP_CNT register

Changes in V4:
- None

Changes in V3:
- Dropped the unused 'ptr' variable in cn10k_inb_cpt_init().
- Use FIELD_PREP macros
- Reduced the number of MSIX vectors requested for NPA
- Disabled the NPA threshold interrupt in cn10k_ipsec_free_aura_ptrs()

Changes in V2:
- Fixed sparse warnings
                                                                                                    V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-12-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-11-tanmay@marvell.com/                V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-11-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-11-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 109 +++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   9 ++
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   4 +
 5 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 3e4cdd6bac6c..0899c6832c0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -463,10 +463,72 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
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
+	local_bh_disable();
+
+	/* Allocate and refill to the IPsec pool */
+	pool_id = pfvf->ipsec.inb_ipsec_pool;
+	pool = &pfvf->qset.pool[pool_id];
+
+	/* Calculate the number of spb buffers received */
+	for (count = 0, idx = 0; idx < pfvf->hw.rx_queues; idx++)
+		count += atomic_xchg(&pfvf->ipsec.inb_spb_count[idx], 0);
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
+
+	local_bh_enable();
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
 	int ret = 0, spb_cnt;
+	char *irq_name;
+	int  vec;
+	u64 val;
 
 	/* Set sa_tbl_entry_sz to 2048 since we are programming NIX RX
 	 * to calculate SA index as SPI * 2048. The first 1024 bytes
@@ -504,6 +566,41 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
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
+	/* Set threshold values */
+	val = FIELD_PREP(NPA_LF_AURA_OP_THRESH_AURA, pfvf->ipsec.inb_ipsec_pool);
+	val |= NPA_LF_AURA_OP_THRESH_THRESH_UP;
+	val |= FIELD_PREP(NPA_LF_AURA_OP_THRESH_THRESHOLD,
+			  ((pfvf->qset.rqe_cnt / 2) - 1));
+	otx2_write64(pfvf, NPA_LF_AURA_OP_THRESH, val);
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
 
@@ -917,8 +1014,13 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
 void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
 {
 	struct otx2_pool *pool;
+	u64 iova, val;
 	int pool_id;
-	u64 iova;
+
+	/* Disable threshold interrupt */
+	val = FIELD_PREP(NPA_LF_AURA_OP_INT_AURA, pfvf->ipsec.inb_ipsec_pool);
+	val |= NPA_LF_AURA_OP_INT_THRESH_ENA;
+	otx2_write64(pfvf, NPA_LF_AURA_OP_INT, val);
 
 	/* Free all first and second pass pool buffers */
 	for (pool_id = pfvf->ipsec.inb_ipsec_spb_pool;
@@ -936,6 +1038,8 @@ void cn10k_ipsec_free_aura_ptrs(struct otx2_nic *pfvf)
 
 static void cn10k_ipsec_free_hw_resources(struct otx2_nic *pfvf)
 {
+	int vec;
+
 	if (!cn10k_cpt_device_set_inuse(pfvf)) {
 		netdev_err(pfvf->netdev, "CPT LF device unavailable\n");
 		return;
@@ -950,6 +1054,9 @@ static void cn10k_ipsec_free_hw_resources(struct otx2_nic *pfvf)
 	qmem_free(pfvf->dev, pfvf->ipsec.inb_sa);
 
 	cn10k_ipsec_free_aura_ptrs(pfvf);
+
+	vec = pci_irq_vector(pfvf->pdev, pfvf->hw.npa_msixoff);
+	free_irq(vec, pfvf);
 }
 
 int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 8ef67f1f0e3d..34154f002d22 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -120,6 +120,7 @@ struct cn10k_ipsec {
 	struct qmem *inb_sa;
 	struct list_head inb_sw_ctx_list;
 	DECLARE_BITMAP(inb_sa_table, CN10K_IPSEC_INB_MAX_SA);
+	struct work_struct refill_npa_inline_ipsecq;
 };
 
 /* CN10K IPSEC Security Association (SA) */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index e4be6744c990..483956d12cc1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3002,6 +3002,10 @@ int otx2_realloc_msix_vectors(struct otx2_nic *pf)
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
index 1cd576fd09c5..e05763fbb559 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -109,6 +109,15 @@
 #define NPA_LF_QINTX_ENA_W1C(a)         (NPA_LFBASE | 0x330 | (a) << 12)
 #define NPA_LF_AURA_BATCH_FREE0         (NPA_LFBASE | 0x400)
 
+#define NPA_LF_AURA_OP_INT_THRESH_INT	BIT_ULL(16)
+#define NPA_LF_AURA_OP_INT_THRESH_ENA	BIT_ULL(17)
+#define NPA_LF_AURA_OP_INT_SETOP	BIT_ULL(43)
+#define NPA_LF_AURA_OP_INT_AURA		GENMASK_ULL(63, 44)
+
+#define NPA_LF_AURA_OP_THRESH_THRESHOLD GENMASK_ULL(35, 0)
+#define NPA_LF_AURA_OP_THRESH_THRESH_UP BIT_ULL(43)
+#define NPA_LF_AURA_OP_THRESH_AURA      GENMASK_ULL(63, 44)
+
 /* NIX LF registers */
 #define	NIX_LFBASE			(BLKTYPE_NIX << RVU_FUNC_BLKADDR_SHIFT)
 #define	NIX_LF_RX_SECRETX(a)		(NIX_LFBASE | 0x0 | (a) << 3)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 25381f079b97..aa072b59848b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -557,6 +557,10 @@ static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
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

