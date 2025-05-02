Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9C255237;
	Fri,  2 May 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192134; cv=none; b=a7IxAC2aJy/V0lFkmU9xRLg6HkNl5nvE5nrZ7K7JruSM/RWf/dUAcLgtH/Gat1FeRh4pHVLx1a5xMi8vXbu0+cT+oR5ncwWrN6eircwzd9MDDpkoCIzt7H8aAMqJhwbU0ksR4JdeLTbuoOLaZ3WfvTYRcudwLkh1hpj9w/EYkqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192134; c=relaxed/simple;
	bh=37B6PMh/6sEC5uQdEJHN3nbfj8eUefTL3Eaw1/BFKpU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dt7xrJ0WuiP4HVYJmD6EYX2t54IyPzq6aoXARugKn0/swTWRe1mEPQm5QJOvwZrLKpo3K/xkUuj6NjD8coxlyoSOLpUWkZu6IqXfNrQy94NC5sCNrLCxl9Xj6bAizUAekzRSSnNVpGCmg6c3lVt0T+ZgVWRpOuJSWt0P4qmxUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=aoahraDh; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aoahraDh"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542CxphH022581;
	Fri, 2 May 2025 06:21:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	iW053hUhkoewKY57vLCn4s/zGxUU0wcbj/9keQadSU=; b=aoahraDhLu8MdpAHi
	kBuGcX179F/cM7FXXfWfp3GXf81lG6tgrz03IPb3z1zaQfsECIAuN+aGHEGe00Hp
	o0ZM45w8ZXrjWSQZK5be6AJBoHa90Rlp156r7qotcSOEbf3Fe37TNzW/sP72Xq43
	eMkuu4VEVYzOauN3lhrjrBk0UhjvN7cR2yu42LJ9EzRVsZzWe1G2z+gp522oBGN0
	hhaUBShFPdhm8lvhv8N7u/zVOORy0BXWCHZGzghu6ZdgQIbNWiOgn3+ZD72eUroF
	n/i5E0mnfgHmQNAMTJWxvkdbLhPu+T8fUxhWu6/YfbcfceNCmpKtMWktd3wp+ze/
	UEg7w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cuqyr9t9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:21:58 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:21:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:21:56 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id E38F33F7041;
	Fri,  2 May 2025 06:21:45 -0700 (PDT)
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
Subject: [net-next PATCH v1 04/15] octeontx2-af: Handle inbound inline ipsec config in AF
Date: Fri, 2 May 2025 18:49:45 +0530
Message-ID: <20250502132005.611698-5-tanmay@marvell.com>
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
X-Proofpoint-ORIG-GUID: ER1MhkG2ozJ0NhtQL-nlQQ-M_jRAI6Eh
X-Authority-Analysis: v=2.4 cv=JvPxrN4C c=1 sm=1 tr=0 ts=6814c6f6 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=IFrmSRDCLOpRzf7F5L0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: ER1MhkG2ozJ0NhtQL-nlQQ-M_jRAI6Eh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX+7KGt4+2+W7N 0xl8i5fz4ao+tNV/+BSByLEjdqCh2+lw05uvBLaWr62yW2iD334B1HhJpMvF2daEnPU9C0T9KSS vJWRYeyBLAXErYxR6eiLQ5+q8sBH7XVJuazp1mmEL3B9vZQaE0KtjrFAINvjcyn2NqrFO/ObhNl
 GpZ0XzRE9ZQ5VifDcDjahAF1B/5uvrCtjpthbj8A4OhoauohkNinbs6Hy4Ij+Fq947FW0mxZPdR 35pFhcVrmRmKocV8vSHsXrgxF1AISnvGsWKfBG0Qnf0bQ+OASWooq0Rf5v7Y9YfzoOlAolZxaY3 A6uKPulhd0AHtXub/LkrwZlfzFOIaCkdN6uVlCUIBTBKEM1hHnXWbLVdE6qScAnQQi/xDGIdJRq
 6ElsRhtFUA055qnTDlXepeDLX16c1BpUTCXYYlTXnGOwjkKkeOCStReWfVlm7u2wUeC9loVJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Now CPT context flush can be handled in AF as CPT LF
can be attached to it. With that AF driver can completely
handle inbound inline ipsec configuration mailbox, so
forward this mailbox to AF driver.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  1 -
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  3 -
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 67 +++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  1 +
 5 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index df735eab8f08..27a2dd997f73 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -33,7 +33,6 @@
 #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
 
 /* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
-#define MBOX_MSG_RX_INLINE_IPSEC_LF_CFG 0xBFE
 #define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
 #define MBOX_MSG_GET_CAPS               0xBFD
 #define MBOX_MSG_GET_KVF_LIMITS         0xBFC
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 5e6f70ac35a7..222419bd5ac9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -326,9 +326,6 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 	case MBOX_MSG_GET_KVF_LIMITS:
 		err = handle_msg_kvf_limits(cptpf, vf, req);
 		break;
-	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
-		err = handle_msg_rx_inline_ipsec_lf_cfg(cptpf, req);
-		break;
 
 	default:
 		err = forward_to_af(cptpf, vf, req, size);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8540a04a92f9..ad74a27888da 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -213,6 +213,8 @@ M(CPT_FLT_ENG_INFO,     0xA09, cpt_flt_eng_info, cpt_flt_eng_info_req,	\
 			       cpt_flt_eng_info_rsp)			\
 M(CPT_SET_ENG_GRP_NUM,  0xA0A, cpt_set_eng_grp_num, cpt_set_egrp_num,   \
 				msg_rsp)				\
+M(CPT_RX_INLINE_LF_CFG, 0xBFE, cpt_rx_inline_lf_cfg, cpt_rx_inline_lf_cfg_msg, \
+				msg_rsp) \
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 8ed56ac512ef..2e8ac71979ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -12,6 +12,7 @@
 #include "mbox.h"
 #include "rvu.h"
 #include "rvu_cpt.h"
+#include <linux/soc/marvell/octeontx2/asm.h>
 
 /* CPT PF device id */
 #define	PCI_DEVID_OTX2_CPT_PF	0xA0FD
@@ -26,6 +27,10 @@
 /* Default CPT_AF_RXC_CFG1:max_rxc_icb_cnt */
 #define CPT_DFLT_MAX_RXC_ICB_CNT  0xC0ULL
 
+/* CPT LMTST */
+#define LMT_LINE_SIZE   128 /* LMT line size in bytes */
+#define LMT_BURST_SIZE  32  /* 32 LMTST lines for burst */
+
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
 	u64 free_sts = 0, busy_sts = 0;                             \
@@ -1253,20 +1258,36 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 	return 0;
 }
 
+static void cn10k_cpt_inst_flush(struct rvu *rvu, u64 *inst, u64 size)
+{
+	u64 val = 0, tar_addr = 0;
+	void __iomem *io_addr;
+	u64 blkaddr = BLKADDR_CPT0;
+
+	io_addr	= rvu->pfreg_base + CPT_RVU_FUNC_ADDR_S(blkaddr, 0, CPT_LF_NQX);
+
+	/* Target address for LMTST flush tells HW how many 128bit
+	 * words are present.
+	 * tar_addr[6:4] size of first LMTST - 1 in units of 128b.
+	 */
+	tar_addr |= (__force u64)io_addr | (((size / 16) - 1) & 0x7) << 4;
+	dma_wmb();
+	memcpy((u64 *)rvu->rvu_cpt.lmt_addr, inst, size);
+	cn10k_lmt_flush(val, tar_addr);
+	dma_wmb();
+}
+
 #define CPT_RES_LEN    16
 #define CPT_SE_IE_EGRP 1ULL
 
 static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 				      int nix_blkaddr)
 {
-	int cpt_pf_num = rvu->cpt_pf_num;
-	struct cpt_inst_lmtst_req *req;
 	dma_addr_t res_daddr;
 	int timeout = 3000;
 	u8 cpt_idx;
-	u64 *inst;
+	u64 inst[8];
 	u16 *res;
-	int rc;
 
 	res = kzalloc(CPT_RES_LEN, GFP_KERNEL);
 	if (!res)
@@ -1276,24 +1297,11 @@ static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 				   DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(rvu->dev, res_daddr)) {
 		dev_err(rvu->dev, "DMA mapping failed for CPT result\n");
-		rc = -EFAULT;
-		goto res_free;
+		kfree(res);
+		return -EFAULT;
 	}
 	*res = 0xFFFF;
 
-	/* Send mbox message to CPT PF */
-	req = (struct cpt_inst_lmtst_req *)
-	       otx2_mbox_alloc_msg_rsp(&rvu->afpf_wq_info.mbox_up,
-				       cpt_pf_num, sizeof(*req),
-				       sizeof(struct msg_rsp));
-	if (!req) {
-		rc = -ENOMEM;
-		goto res_daddr_unmap;
-	}
-	req->hdr.sig = OTX2_MBOX_REQ_SIG;
-	req->hdr.id = MBOX_MSG_CPT_INST_LMTST;
-
-	inst = req->inst;
 	/* Prepare CPT_INST_S */
 	inst[0] = 0;
 	inst[1] = res_daddr;
@@ -1314,11 +1322,8 @@ static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 	rvu_write64(rvu, nix_blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
 		    BIT_ULL(22) - 1);
 
-	otx2_mbox_msg_send(&rvu->afpf_wq_info.mbox_up, cpt_pf_num);
-	rc = otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, cpt_pf_num);
-	if (rc)
-		dev_warn(rvu->dev, "notification to pf %d failed\n",
-			 cpt_pf_num);
+	cn10k_cpt_inst_flush(rvu, inst, 64);
+
 	/* Wait for CPT instruction to be completed */
 	do {
 		mdelay(1);
@@ -1331,11 +1336,8 @@ static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 	if (timeout == 0)
 		dev_warn(rvu->dev, "Poll for result hits hard loop counter\n");
 
-res_daddr_unmap:
 	dma_unmap_single(rvu->dev, res_daddr, CPT_RES_LEN, DMA_BIDIRECTIONAL);
-res_free:
 	kfree(res);
-
 	return 0;
 }
 
@@ -1381,23 +1383,16 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 		goto unlock;
 	}
 
-	/* Enable BAR2 ALIAS for this pcifunc. */
-	reg = BIT_ULL(16) | pcifunc;
-	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
-
 	for (i = 0; i < max_ctx_entries; i++) {
 		cam_data = rvu_read64(rvu, blkaddr, CPT_AF_CTX_CAM_DATA(i));
 
 		if ((FIELD_GET(CTX_CAM_PF_FUNC, cam_data) == pcifunc) &&
 		    FIELD_GET(CTX_CAM_CPTR, cam_data)) {
 			reg = BIT_ULL(46) | FIELD_GET(CTX_CAM_CPTR, cam_data);
-			rvu_write64(rvu, blkaddr,
-				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTX_FLUSH),
-				    reg);
+			otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot,
+					 CPT_LF_CTX_FLUSH, reg);
 		}
 	}
-	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
-
 unlock:
 	mutex_unlock(&rvu->rsrc_lock);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index a982cffdc5f5..245e69fcbff9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -571,6 +571,7 @@
 #define CPT_LF_Q_SIZE                   0x100
 #define CPT_LF_Q_INST_PTR               0x110
 #define CPT_LF_Q_GRP_PTR                0x120
+#define CPT_LF_NQX                      0x400
 #define CPT_LF_CTX_FLUSH                0x510
 
 #define NPC_AF_BLK_RST                  (0x00040)
-- 
2.43.0

