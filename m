Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6982E9748;
	Wed, 18 Jun 2025 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246298; cv=none; b=LbYyiDzxPJWzu7yRPG80+Ka5AnhwjVUD1Axae5yrC65JRD5EC3zD72DR6jcqK5svlbmvWS2F+aW7uAPuwUlMVaKCHzkCL2IJlMZ1OTZKHKxuuq4V+R5RzBUIB668kNND5mYLx3fujzGtDsFU9u73h56NU9BBxh6nfbp17p3n0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246298; c=relaxed/simple;
	bh=4dxPX4NOzHQedW1LxGnP6ZZIsLnT9CDHzxRMMqTOrnk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1vGP01CgRyKXbTYRpmIiAGALuvLJUA/Zd4UZRgYLoAFVQvt8X5Vh7w+fFWXTPx2FBVXddlwICZWSWjdO1s5UkP6HrNlXgrfooXh/PEQxYclEZt19uih1mHob2QvBjGQcqIPHGoN9Ri/MAO4rFV2uOi7QJR+vPuGEjIUfZoiDXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gOwKRKO4; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gOwKRKO4"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7qnJt023248;
	Wed, 18 Jun 2025 04:31:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	X6jJhOBMlV8iB6jT1j4u5/DVNeIGL/9JrHNQ+FsCLY=; b=gOwKRKO42FwJVSHn/
	70SZWcVHd0hpv4t2ebbrh5TGHn7DFBwbOSSjHt5Pu30TL/pvyy41YFKyKPB9F+Pm
	b+n3kNIViRGeDVi+V4jIDOrd47XnOrmO1tekgmSl+VmRGk1DkZQrxaoiXf/o3NvH
	4npfAxDXB1LhVZbzWJV0+jnEXtz3nKc139r5fL24AActwA7duGYAR8t+eJJJ9BXW
	emC38PftcbSbghlIfXeOK4nl2rfYLf1PkHoLHVkkWT2wMXkQ2ESLGbaxdnPmKw7z
	5GS94eraD4SjiB4wy5ZHOxTfZ/mxzx+rkz59FatW2nhGcuN/4DQUHWPS3KIbHl2/
	/4nwg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47bsf2redd-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:31:29 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:31:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:31:23 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id C7DE23F7048;
	Wed, 18 Jun 2025 04:31:19 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 11/14] octeontx2-pf: ipsec: Initialize ingress IPsec
Date: Wed, 18 Jun 2025 17:00:05 +0530
Message-ID: <20250618113020.130888-12-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: 78qrQdeaiv8qXAHSy2J_0GoygEYkYpRv
X-Proofpoint-GUID: 78qrQdeaiv8qXAHSy2J_0GoygEYkYpRv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5OCBTYWx0ZWRfXwi3E4lKoyynm RIJoJKwJOPgmwgweDaJBGcvgHslwEsks1jEUrEBQQd1eXRNORIpxs1j6JbxF1FbtPgInNQWwSw7 kFUU8TE4yAdnOFMptvtnaOBU21ZoeyC60lBnHpfZuK8fohUs2yZPmf1r9HJGq+hgzgrRp+iesxT
 twh/Ou0wE93zy669EGSqUNZnw2MiVJqRcEfIiTcLXq8kQeIWo6NfVIM2e6WhwjQ6nQuyjokJ5P3 lgktDAlM1TYJ2O26XuqwMsJQBJwh0VXmCOr9mRXTqqF1/NqZwVvua1S1vOvgEGkR23EXPkY+LJG XYHZiluCagKwqx378TMXxvfUOrGtEyeJX6Xao8OfIsZ6ShPOywNbrj4CrOsJfUtg6T2a0dJn+HH
 5BEsmI4MXzHJaI90NIjpGUTbgAmFhRKNoGwIZ4QsfXo96mY8ocLP50DAJ02H2Dnifi2hezXn
X-Authority-Analysis: v=2.4 cv=Yu4PR5YX c=1 sm=1 tr=0 ts=6852a392 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=1lKLCS0kNoqInZpCLlIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

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

NIX_ALLOC_BPID          - Configure bacpkpressure between NIX and CPT
			  blocks by allocating a backpressure ID using
			  this mailbox for the ingress inline IPsec flows.

NIX_FREE_BPID           - Free this BPID when ESP offload is disabled
			  via ethtool.

Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
Changes in V2:
- Fixed commit message be within 75 characters

V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-13-tanmay@marvell.com/ 

 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 167 ++++++++++++++++++
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |   2 +
 2 files changed, 169 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 84ddaef22f67..5cb6bc835e56 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -346,6 +346,97 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
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
+
+	req->rq_set.len_il4_dis = 1;
+	req->rq_set.csum_ol4_dis = 1;
+	req->rq_set.csum_il4_dis = 1;
+
+	req->rq_set.lenerr_dis = 1;
+	req->rq_set.port_ol4_dis = 1;
+	req->rq_set.port_il4_dis = 1;
+
+	req->ipsec_cfg1.rq_mask_enable = 1;
+	req->ipsec_cfg1.spb_cpt_enable = 0;
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
+	req->bpid = pfvf->ipsec.bpid;
+	req->credit = 8160;
+	req->credit_th = 100;
+	req->ctx_ilen_valid = 1;
+	req->ctx_ilen = 5;
+
+	ret = otx2_sync_mbox_msg(&pfvf->mbox);
+error:
+	mutex_unlock(&pfvf->mbox.lock);
+	return ret;
+}
+
 static int cn10k_ipsec_ingress_aura_init(struct otx2_nic *pfvf,
 					 struct otx2_pool *pool,
 					 int aura_id, int pool_id,
@@ -615,6 +706,28 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
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
 
@@ -1034,6 +1147,53 @@ static void cn10k_ipsec_sa_wq_handler(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static int cn10k_ipsec_configure_cpt_bpid(struct otx2_nic *pfvf)
+{
+	struct nix_alloc_bpid_req *req;
+	struct nix_bpids *rsp;
+	int rc;
+
+	req = otx2_mbox_alloc_msg_nix_alloc_bpids(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+	req->bpid_cnt = 1;
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
+
+	return 0;
+}
+
+static int cn10k_ipsec_free_cpt_bpid(struct otx2_nic *pfvf)
+{
+	struct nix_bpids *req;
+	int rc;
+
+	req = otx2_mbox_alloc_msg_nix_free_bpids(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->bpid_cnt = 1;
+	req->bpids[0] = pfvf->ipsec.bpid;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	/* Clear the bpid */
+	pfvf->ipsec.bpid = 0;
+	return 0;
+}
+
 int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
@@ -1052,6 +1212,10 @@ int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
 		ret = cn10k_inb_cpt_init(netdev);
 		if (ret)
 			return ret;
+
+		/* Configure NIX <-> CPT backpresure */
+		ret = cn10k_ipsec_configure_cpt_bpid(pf);
+		return ret;
 	}
 
 	/* Don't do CPT cleanup if SA installed */
@@ -1060,6 +1224,7 @@ int cn10k_ipsec_ethtool_init(struct net_device *netdev, bool enable)
 		return -EBUSY;
 	}
 
+	cn10k_ipsec_free_cpt_bpid(pf);
 	return cn10k_outb_cpt_clean(pf);
 }
 
@@ -1133,6 +1298,8 @@ void cn10k_ipsec_clean(struct otx2_nic *pf)
 
 	vec = pci_irq_vector(pf->pdev, pf->hw.npa_msixoff);
 	free_irq(vec, pf);
+
+	cn10k_ipsec_free_cpt_bpid(pf);
 }
 EXPORT_SYMBOL(cn10k_ipsec_clean);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
index 2604edd2af68..d5d84c0bc308 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
@@ -104,6 +104,8 @@ struct cn10k_ipsec {
 	atomic_t cpt_state;
 	struct cn10k_cpt_inst_queue iq;
 
+	u32 bpid;	/* Backpressure ID for NIX <-> CPT */
+
 	/* SA info */
 	u32 sa_size;
 	u32 outb_sa_count;
-- 
2.43.0

