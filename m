Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE422A4D6;
	Sun, 26 Oct 2025 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491441; cv=none; b=tBgHs8cXy/4LZ7frAaYwmRnIOsJ49CtansC51Tcn1OjgDOtMwOlHF3+16N5LlZaGPOGdh/08E1bNoay6ZQGhjODp8glvEgo2zmaUqdphfX/t5rAswp2TjRTAOkZnwMLQ6swgfMdkCbo8AzO1cmcJcRjpfaHCP5Yd0b9hn+D4nkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491441; c=relaxed/simple;
	bh=QBvyO/Paip4PCpXKXBJr6QssBJPSM3crzgGIerxRy4Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjIBb4XgmoW1KqO3Bb1pLlilvKT3Uv829s9KE3dP2Q2ERpwdGTQrI4Now6z05Uk0EeqOH4dWI7PTOHO3+tbF/gKyJ4X1w1ceq2yFLfdcS0Mp9FovSWjZXb2QhLHs38xvxCNqa0E+IYGPhIz/PMXlSevs+5TYydmIAkeG9bQn5x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NTrdEcM1; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NTrdEcM1"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QF0Aig3923600;
	Sun, 26 Oct 2025 08:10:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	BRYKr6MEgRJFkdihI9LrINkvaEcyK2cNlBF5lQ0fsM=; b=NTrdEcM1Uts7fxbaF
	b0xl0YBxZsTtf3Hflng6wtBcQGE6hpLKuZAVGqpX4EBbcjabCVS0Wwx9kgRyQea9
	G3UfwSbVGCt01Hm09mpd244kULV0dD4CgZlBiqopecvZplywPYHz9Ak4D2Ls5kef
	I0KW0875vaopqiwoj3CWMGCpgU1663kL7M4jEPHGR4l9vKM6f1WIDxNw+E9fUGLS
	uYGHBPHVGcdTBEyJEJ191d5JqNI/TVXiEgNqGjolg9lj9BmA3usPOPtEhwnCt5Vs
	YpMMjZ+1wADxuPYPNPwWmOc2nPcUVCoASKx3OmIGF4nKFaWBUv7e1d8nArW5gaXy
	0t6RA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a0x2g1pm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:10:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:43 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 400493F70DE;
	Sun, 26 Oct 2025 08:10:30 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 11/15] octeontx2-pf: ipsec: Initialize ingress IPsec
Date: Sun, 26 Oct 2025 20:39:06 +0530
Message-ID: <20251026150916.352061-12-tanmay@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX4fMy8TD0hehu
 PSRmkhQUl/yB5wKzzuXzTLG05mqXRZWPGfrO9g+PaLmv0kWmIXFV0htzSxlaOH8qLv5a98gscGt
 aqfDqWYw3FPRPFMOaXCt2mKnpnhYu45vw/97lfmIcCNG3OZxM64VoG3CEwgVqnQyFdSuO2ysjcX
 NoPVqPrTUT1vOkJI05MKSvYQbsjMFVwJG4OQvnmtf+eRHveIEwzv2PPZy383lnh9Bz4quh7ET3P
 HPMgNDjVkdqczpaoZk6mPiTzwwMZQaruoqoBak/nT6dfggtAPic1u5tY+xuEKGJ8yX6YcgqZoAp
 VaC92Zbk781HRgd0Cel19Fe64xPvNqivrHf0NJogBNwR141IWw7rVYjb/4FnRbrgA+9b5UFNG05
 tNbeudnhvXqM9Iio+X3Gy6GHc0oqnQ==
X-Proofpoint-ORIG-GUID: pXPLQhEn1NwiEymInybq1_uKHzwpsSll
X-Authority-Analysis: v=2.4 cv=I4Bohdgg c=1 sm=1 tr=0 ts=68fe39ea cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=-FiweNwWFN28Ur5oYkUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: pXPLQhEn1NwiEymInybq1_uKHzwpsSll
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

Initialize ingress inline IPsec offload when ESP offload feature
is enabled via Ethtool. As part of initialization, the following
mailboxes must be invoked to configure inline IPsec:

NIX_INLINE_IPSEC_LF_CFG - Every NIX LF has the provision to maintain a
                          contiguous SA Table. This mailbox configure
                          the SA table base address, size of each SA,
                          maximum number entries in the table. Currently,
                          we support 128 entry table with each SA of size
                          1024 bytes.

NIX_LF_INLINE_RQ_CFG    - Post decryption, CPT sends a metapacket of 256
                          bytes which have enough packet headers to help
                          NIX RX classify it. However, since the packet is
                          not complete, we cannot perform checksum and
                          packet length verification. Hence, configure the
                          RQ context to disable L3, L4 checksum and length
                          verification for packets coming from CPT.

NIX_INLINE_IPSEC_CFG    - RVU hardware supports 1 common CPT LF for inbound
                          ingress IPsec flows. This CPT LF is configured
			  via this mailbox and is a one time system-wide
                          configuration.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V5:
- Remove backpressure related configuration from this patch
  to another patch dedicated for backpressure related changes.

Changes in V4:
- Moved BPID configuration before initializing CPT for inbound
  configuration

Changes in V3:
- None

Changes in V2:
- Fixed commit message be within 75 characters                                                      
V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-13-tanmay@marvell.com/
V2 Link: https://lore.kernel.org/netdev/20250618113020.130888-12-tanmay@marvell.com/
V3 Link: https://lore.kernel.org/netdev/20250711121317.340326-12-tanmay@marvell.com/
V4 Link: https://lore.kernel.org/netdev/20250819021507.323752-12-tanmay@marvell.com/

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 130 ++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 0899c6832c0d..664ccfc7e80d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -342,6 +342,114 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
 	return ret;
 }
 
+static int cn10k_inb_nix_inline_lf_cfg(struct otx2_nic *pfvf)
+{
+	struct nix_inline_ipsec_lf_cfg *req;
+	int ret = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_inline_ipsec_lf_cfg(&pfvf->mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	req->sa_base_addr = pfvf->ipsec.inb_sa->iova;
+	req->ipsec_cfg0.tag_const = 0;
+	req->ipsec_cfg0.tt = 0;
+	req->ipsec_cfg0.lenm1_max = 11872; /* (Max packet size - 128 (first skip)) */
+	req->ipsec_cfg0.sa_pow2_size = 0xb; /* 2048 */
+	req->ipsec_cfg1.sa_idx_max = CN10K_IPSEC_INB_MAX_SA - 1;
+	req->ipsec_cfg1.sa_idx_w = 0x7;
+	req->enable = 1;
+
+	ret = otx2_sync_mbox_msg(&pfvf->mbox);
+error:
+	mutex_unlock(&pfvf->mbox.lock);
+	return ret;
+}
+
+static int cn10k_inb_nix_inline_lf_rq_cfg(struct otx2_nic *pfvf)
+{
+	struct nix_rq_cpt_field_mask_cfg_req *req;
+	int ret = 0, i;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_lf_inline_rq_cfg(&pfvf->mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	for (i = 0; i < RQ_CTX_MASK_MAX; i++)
+		req->rq_ctx_word_mask[i] = 0xffffffffffffffff;
+
+	req->rq_set.len_ol3_dis = 1;
+	req->rq_set.len_ol4_dis = 1;
+	req->rq_set.len_il3_dis = 1;
+	req->rq_set.len_il4_dis = 1;
+	req->rq_set.csum_ol4_dis = 1;
+	req->rq_set.csum_il4_dis = 1;
+	req->rq_set.lenerr_dis = 1;
+	req->rq_set.port_ol4_dis = 1;
+	req->rq_set.port_il4_dis = 1;
+	req->rq_set.lpb_drop_ena = 0;
+	req->rq_set.spb_drop_ena = 0;
+	req->rq_set.xqe_drop_ena = 0;
+	req->rq_set.spb_ena = 1;
+	req->rq_set.ena = 1;
+
+	req->rq_mask.len_ol3_dis = 0;
+	req->rq_mask.len_ol4_dis = 0;
+	req->rq_mask.len_il3_dis = 0;
+	req->rq_mask.len_il4_dis = 0;
+	req->rq_mask.csum_ol4_dis = 0;
+	req->rq_mask.csum_il4_dis = 0;
+	req->rq_mask.lenerr_dis = 0;
+	req->rq_mask.port_ol4_dis = 0;
+	req->rq_mask.port_il4_dis = 0;
+	req->rq_mask.lpb_drop_ena = 0;
+	req->rq_mask.spb_drop_ena = 0;
+	req->rq_mask.xqe_drop_ena = 0;
+	req->rq_mask.spb_ena = 0;
+	req->rq_mask.ena = 0;
+
+	/* Setup SPB fields for second pass */
+	req->ipsec_cfg1.rq_mask_enable = 1;
+
+	ret = otx2_sync_mbox_msg(&pfvf->mbox);
+error:
+	mutex_unlock(&pfvf->mbox.lock);
+	return ret;
+}
+
+static int cn10k_inb_nix_inline_ipsec_cfg(struct otx2_nic *pfvf)
+{
+	struct cpt_rx_inline_lf_cfg_msg *req;
+	int ret = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cpt_rx_inline_lf_cfg(&pfvf->mbox);
+	if (!req) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	req->sso_pf_func = 0;
+	req->opcode = CN10K_IPSEC_MAJOR_OP_INB_IPSEC | (1 << 6);
+	req->param1 = 7; /* bit 0:ip_csum_dis 1:tcp_csum_dis 2:esp_trailer_dis */
+	req->param2 = 0;
+	req->credit = (pfvf->qset.rqe_cnt * 3) / 4;
+	req->credit_th = pfvf->qset.rqe_cnt / 10;
+	req->ctx_ilen_valid = 1;
+	req->ctx_ilen = 5;
+
+	ret = otx2_sync_mbox_msg(&pfvf->mbox);
+error:
+	mutex_unlock(&pfvf->mbox.lock);
+	return ret;
+}
+
 static int cn10k_ipsec_ingress_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 {
 	struct nix_cn10k_aq_enq_req *aq;
@@ -601,6 +709,28 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
 	/* Enable interrupt */
 	otx2_write64(pfvf, NPA_LF_QINTX_ENA_W1S(0), BIT_ULL(0));
 
+	/* Enable inbound inline IPSec in NIX LF */
+	ret = cn10k_inb_nix_inline_lf_cfg(pfvf);
+	if (ret) {
+		netdev_err(netdev, "Error configuring NIX for Inline IPSec\n");
+		goto out;
+	}
+
+	/* IPsec specific RQ settings in NIX LF */
+	ret = cn10k_inb_nix_inline_lf_rq_cfg(pfvf);
+	if (ret) {
+		netdev_err(netdev, "Error configuring NIX for Inline IPSec\n");
+		goto out;
+	}
+
+	/* One-time configuration to enable CPT LF for inline inbound IPSec */
+	ret = cn10k_inb_nix_inline_ipsec_cfg(pfvf);
+	if (ret && ret != -EEXIST)
+		netdev_err(netdev, "CPT LF configuration error\n");
+	else
+		ret = 0;
+
+out:
 	return ret;
 }
 
-- 
2.43.0

