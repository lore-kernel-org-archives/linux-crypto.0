Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79835246778;
	Fri,  2 May 2025 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192133; cv=none; b=pc9GDmg3w8dVUGkQqHVfUFWfyGrpPdi5GkCI9rD9h7IWodnCg7K+9QFLskVvb0qH4lrXy9g4WKaUCI58Vg6YLkxb7nOPy/AN9HHSUGJIY/JU8NmgqbuhL6q7+/bq+cV9k6hD8qmpMeiHPhStqtcOqlpEVSy60kSZGEEo8fF3qcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192133; c=relaxed/simple;
	bh=Bmec8ft+PFxlzI+xrjaOYINq3oIpdhvpiQwhI/wCnlg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVPRWuDcF7hUPLIryHEajkeIcYu9BuZYvr4Xc9t10ZnM/dGOesqd7/kQmFe4UX0SYme1ODVZiB9ez/3Sg7C/lLQARK0EgX0g/6GWlEIzieW6uLppoinspPk41p+wj1HeJzx5pUzuapdaKHrzb+L0qEXJVKZ7IVHOqCA7eP8K4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NYV/12MA; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NYV/12MA"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 542ANFXI000863;
	Fri, 2 May 2025 06:21:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=O
	AEsz8l7/irz2klrfBCJ98obQY2J47xLuNq/qtk1NTs=; b=NYV/12MAUKsZd9Rvd
	abVGwwiUe4yJNDBkRf0zsXwMIfO4D5QrKT5M9eyeznfDhyT/COsrtxiXN6sYHTa4
	a9u4xRYtLCCvr4MB5w5s1B0i7ot2zWmgAU+9RF6tbybCFTHFbvSjCG6NyjcqKUDo
	gOog5bDtasfgPvSir6zmdZRvcroAA3b3GY/rsyHiUzb6n6gEXhVJK9POIVj/e8XX
	TeIdJ5DvDEiUesNg7ldlJVK0BYH4cq1xmBB8mchPCFJKDPJFvOhb8lKtswmeNa2Z
	ptZIlorkxh3b8oosAma51U1fSGIhx/+jTwzkGhL8bhEYoa/R0/gfHwlUMWnH1VnN
	LyyuA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46cuqyr9sd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:21:31 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:21:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:21:28 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id D26705B693A;
	Fri,  2 May 2025 06:21:14 -0700 (PDT)
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
Subject: [net-next PATCH v1 02/15] octeontx2-af: Configure crypto hardware for inline ipsec
Date: Fri, 2 May 2025 18:49:43 +0530
Message-ID: <20250502132005.611698-3-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502132005.611698-1-tanmay@marvell.com>
References: <20250502132005.611698-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 0pB0h7hiNreudM2MsTouMKDV_ad8a60b
X-Authority-Analysis: v=2.4 cv=JvPxrN4C c=1 sm=1 tr=0 ts=6814c6db cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=fy8_9_DjlNJKTM-CpToA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 0pB0h7hiNreudM2MsTouMKDV_ad8a60b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfXytATkCP40SKw 86EnaCW4S2vSn5XLtPXw31B0xGUT6qLqicxUIWsiRQG8BLY8uxehTzbGnQISFJVoEYKftNdpT/F fKpmLd+6Yc6VdvZRvWra2PQefnG7KJyHS30MeNR4xw/i4DcPOJ/jiJUUnFOjbpngdyTeyO9ezNm
 VIidgEG1+YuK+Us2+WuBP+ddG/W/W1M6SNu5VjkUT7w46P8ShLKgvp7gZfSqvIRTeIDjlLBepVh aqv2HV2G8XXZxOadluqf/k2/PU09IA3saOnM9eMTr1UQdsynv3OclxFzg9AwN1fnnm/W1KQnoIl FYNGlg6hnVvXKGjFsUFtA/Q5Ow337zxVSMx7x/JTZyIq5AGBO0yJ0IgRqPpXDCCp2ov4GPHtlS8
 FLFeHck81HxrLPzWUQGHuUxXofvNIpFj17vhdxQWSIkSt5vueZU5z7aZzXiitNW3X/WyiWz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

From: Bharat Bhushan <bbhushan2@marvell.com>

Currently cpt_rx_inline_lf_cfg mailbox is handled by CPT PF
driver to configures inbound inline ipsec. Ideally inbound
inline ipsec configuration should be done by AF driver.

This patch adds support to allocate, attach and initialize
a cptlf from AF. It also configures NIX to send CPT instruction
if the packet needs inline ipsec processing and configures
CPT LF to handle inline inbound instruction received from NIX.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  14 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  34 ++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 563 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |  67 +++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   4 +-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   5 +
 7 files changed, 687 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 973ff5cf1a7d..8540a04a92f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1950,6 +1950,20 @@ enum otx2_cpt_eng_type {
 	OTX2_CPT_MAX_ENG_TYPES,
 };
 
+struct cpt_rx_inline_lf_cfg_msg {
+	struct mbox_msghdr hdr;
+	u16 sso_pf_func;
+	u16 param1;
+	u16 param2;
+	u16 opcode;
+	u32 credit;
+	u32 credit_th;
+	u16 bpid;
+	u32 reserved;
+	u8 ctx_ilen_valid : 1;
+	u8 ctx_ilen : 7;
+};
+
 struct cpt_set_egrp_num {
 	struct mbox_msghdr hdr;
 	bool set;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 6575c422635b..d9f000cda5e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1775,8 +1775,8 @@ int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 	return err;
 }
 
-static u16 rvu_get_msix_offset(struct rvu *rvu, struct rvu_pfvf *pfvf,
-			       int blkaddr, int lf)
+u16 rvu_get_msix_offset(struct rvu *rvu, struct rvu_pfvf *pfvf,
+			int blkaddr, int lf)
 {
 	u16 vec;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index fa403da555ff..6923fd756b19 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -525,8 +525,38 @@ struct rvu_cpt_eng_grp {
 	u8 grp_num;
 };
 
+struct rvu_cpt_rx_inline_lf_cfg {
+	u16 sso_pf_func;
+	u16 param1;
+	u16 param2;
+	u16 opcode;
+	u32 credit;
+	u32 credit_th;
+	u16 bpid;
+	u32 reserved;
+	u8 ctx_ilen_valid : 1;
+	u8 ctx_ilen : 7;
+};
+
+struct rvu_cpt_inst_queue {
+	u8 *vaddr;
+	u8 *real_vaddr;
+	dma_addr_t dma_addr;
+	dma_addr_t real_dma_addr;
+	u32 size;
+};
+
 struct rvu_cpt {
 	struct rvu_cpt_eng_grp eng_grp[OTX2_CPT_MAX_ENG_TYPES];
+
+	/* RX inline ipsec lock */
+	struct mutex lock;
+	bool rx_initialized;
+	u16 msix_offset;
+	u8 inline_ipsec_egrp;
+	struct rvu_cpt_inst_queue cpt0_iq;
+	struct rvu_cpt_inst_queue cpt1_iq;
+	struct rvu_cpt_rx_inline_lf_cfg rx_cfg;
 };
 
 struct rvu {
@@ -1066,6 +1096,8 @@ void rvu_program_channels(struct rvu *rvu);
 
 /* CN10K NIX */
 void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw);
+void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *req,
+			  int blkaddr);
 
 /* CN10K RVU - LMT*/
 void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc);
@@ -1097,6 +1129,8 @@ int rvu_mcs_init(struct rvu *rvu);
 int rvu_mcs_flr_handler(struct rvu *rvu, u16 pcifunc);
 void rvu_mcs_ptp_cfg(struct rvu *rvu, u8 rpm_id, u8 lmac_id, bool ena);
 void rvu_mcs_exit(struct rvu *rvu);
+u16 rvu_get_msix_offset(struct rvu *rvu, struct rvu_pfvf *pfvf,
+			int blkaddr, int lf);
 
 /* Representor APIs */
 int rvu_rep_pf_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index e720ae03133d..89e0739ba414 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -11,6 +11,7 @@
 #include "rvu_reg.h"
 #include "mbox.h"
 #include "rvu.h"
+#include "rvu_cpt.h"
 
 /* CPT PF device id */
 #define	PCI_DEVID_OTX2_CPT_PF	0xA0FD
@@ -968,6 +969,33 @@ int rvu_mbox_handler_cpt_ctx_cache_sync(struct rvu *rvu, struct msg_req *req,
 	return rvu_cpt_ctx_flush(rvu, req->hdr.pcifunc);
 }
 
+static int cpt_rx_ipsec_lf_reset(struct rvu *rvu, int blkaddr, int slot)
+{
+	struct rvu_block *block;
+	u16 pcifunc = 0;
+	int cptlf, ret;
+	u64 ctl, ctl2;
+
+	block = &rvu->hw->block[blkaddr];
+
+	cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	ctl = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+	ctl2 = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf));
+
+	ret = rvu_lf_reset(rvu, block, cptlf);
+	if (ret)
+		dev_err(rvu->dev, "Failed to reset blkaddr %d LF%d\n",
+			block->addr, cptlf);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), ctl);
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), ctl2);
+
+	return 0;
+}
+
 int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
 				  struct msg_rsp *rsp)
 {
@@ -1087,6 +1115,72 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 #define DQPTR      GENMASK_ULL(19, 0)
 #define NQPTR      GENMASK_ULL(51, 32)
 
+static void cpt_rx_ipsec_lf_enable_iqueue(struct rvu *rvu, int blkaddr,
+					  int slot)
+{
+	u64 val;
+
+	/* Set Execution Enable of instruction queue */
+	val = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG);
+	val |= BIT_ULL(16);
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG, val);
+
+	/* Set iqueue's enqueuing */
+	val = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL);
+	val |= BIT_ULL(0);
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL, val);
+}
+
+static void cpt_rx_ipsec_lf_disable_iqueue(struct rvu *rvu, int blkaddr,
+					   int slot)
+{
+	int timeout = 1000000;
+	u64 inprog, inst_ptr;
+	u64 qsize, pending;
+	int i = 0;
+
+	/* Disable instructions enqueuing */
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL, 0x0);
+
+	inprog = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG);
+	inprog |= BIT_ULL(16);
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG, inprog);
+
+	qsize = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_Q_SIZE)
+		 & 0x7FFF;
+	do {
+		inst_ptr = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot,
+					   CPT_LF_Q_INST_PTR);
+		pending = (FIELD_GET(XQ_XOR, inst_ptr) * qsize * 40) +
+			  FIELD_GET(NQPTR, inst_ptr) -
+			  FIELD_GET(DQPTR, inst_ptr);
+		udelay(1);
+		timeout--;
+	} while ((pending != 0) && (timeout != 0));
+
+	if (timeout == 0)
+		dev_warn(rvu->dev, "TIMEOUT: CPT poll on pending instructions\n");
+
+	timeout = 1000000;
+	/* Wait for CPT queue to become execution-quiescent */
+	do {
+		inprog = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot,
+					 CPT_LF_INPROG);
+		if ((FIELD_GET(INFLIGHT, inprog) == 0) &&
+		    (FIELD_GET(GRB_CNT, inprog) == 0)) {
+			i++;
+		} else {
+			i = 0;
+			timeout--;
+		}
+	} while ((timeout != 0) && (i < 10));
+
+	if (timeout == 0)
+		dev_warn(rvu->dev, "TIMEOUT: CPT poll on inflight count\n");
+	/* Wait for 2 us to flush all queue writes to memory */
+	udelay(2);
+}
+
 static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int slot)
 {
 	int timeout = 1000000;
@@ -1310,6 +1404,474 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 	return 0;
 }
 
+static irqreturn_t rvu_cpt_rx_ipsec_misc_intr_handler(int irq, void *ptr)
+{
+	struct rvu_block *block = ptr;
+	struct rvu *rvu = block->rvu;
+	int blkaddr = block->addr;
+	struct device *dev = rvu->dev;
+	int slot = 0;
+	u64 val;
+
+	val = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_MISC_INT);
+
+	if (val & (1 << 6)) {
+		dev_err(dev, "Memory error detected while executing CPT_INST_S, LF %d.\n",
+			slot);
+	} else if (val & (1 << 5)) {
+		dev_err(dev, "HW error from an engine executing CPT_INST_S, LF %d.",
+			slot);
+	} else if (val & (1 << 3)) {
+		dev_err(dev, "SMMU fault while writing CPT_RES_S to CPT_INST_S[RES_ADDR], LF %d.\n",
+			slot);
+	} else if (val & (1 << 2)) {
+		dev_err(dev, "Memory error when accessing instruction memory queue CPT_LF_Q_BASE[ADDR].\n");
+	} else if (val & (1 << 1)) {
+		dev_err(dev, "Error enqueuing an instruction received at CPT_LF_NQ.\n");
+	} else {
+		dev_err(dev, "Unhandled interrupt in CPT LF %d\n", slot);
+		return IRQ_NONE;
+	}
+
+	/* Acknowledge interrupts */
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_MISC_INT,
+			 val & CPT_LF_MISC_INT_MASK);
+
+	return IRQ_HANDLED;
+}
+
+static int rvu_cpt_rx_inline_setup_irq(struct rvu *rvu, int blkaddr, int slot)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	struct rvu_pfvf *pfvf;
+	u16 msix_offset;
+	int pcifunc = 0;
+	int ret, cptlf;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	if (!pfvf->msix.bmap)
+		return -ENODEV;
+
+	block = &hw->block[blkaddr];
+	cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	msix_offset = rvu_get_msix_offset(rvu, pfvf, blkaddr, cptlf);
+	if (msix_offset == MSIX_VECTOR_INVALID)
+		return -ENODEV;
+
+	ret = rvu_cpt_do_register_interrupt(block, msix_offset,
+					    rvu_cpt_rx_ipsec_misc_intr_handler,
+					    "CPTLF RX IPSEC MISC");
+	if (ret)
+		return ret;
+
+	/* Enable All Misc interrupts */
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot,
+			 CPT_LF_MISC_INT_ENA_W1S, CPT_LF_MISC_INT_MASK);
+
+	rvu->rvu_cpt.msix_offset = msix_offset;
+	return 0;
+}
+
+static void rvu_cpt_rx_inline_cleanup_irq(struct rvu *rvu, int blkaddr,
+					  int slot)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+
+	/* Disable All Misc interrupts */
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot,
+			 CPT_LF_MISC_INT_ENA_W1C, CPT_LF_MISC_INT_MASK);
+
+	block = &hw->block[blkaddr];
+	free_irq(pci_irq_vector(rvu->pdev, rvu->rvu_cpt.msix_offset), block);
+}
+
+static int rvu_rx_attach_cptlf(struct rvu *rvu, int blkaddr)
+{
+	struct rsrc_attach attach;
+
+	memset(&attach, 0, sizeof(struct rsrc_attach));
+	attach.hdr.id = MBOX_MSG_ATTACH_RESOURCES;
+	attach.hdr.sig = OTX2_MBOX_REQ_SIG;
+	attach.hdr.ver = OTX2_MBOX_VERSION;
+	attach.hdr.pcifunc = 0;
+	attach.modify = 1;
+	attach.cptlfs = 1;
+	attach.cpt_blkaddr = blkaddr;
+
+	return rvu_mbox_handler_attach_resources(rvu, &attach, NULL);
+}
+
+static int rvu_rx_detach_cptlf(struct rvu *rvu)
+{
+	struct rsrc_detach detach;
+
+	memset(&detach, 0, sizeof(struct rsrc_detach));
+	detach.hdr.id = MBOX_MSG_ATTACH_RESOURCES;
+	detach.hdr.sig = OTX2_MBOX_REQ_SIG;
+	detach.hdr.ver = OTX2_MBOX_VERSION;
+	detach.hdr.pcifunc = 0;
+	detach.partial = 1;
+	detach.cptlfs = 1;
+
+	return rvu_mbox_handler_detach_resources(rvu, &detach, NULL);
+}
+
+/* Allocate memory for CPT outbound Instruction queue.
+ * Instruction queue memory format is:
+ *      -----------------------------
+ *     | Instruction Group memory    |
+ *     |  (CPT_LF_Q_SIZE[SIZE_DIV40] |
+ *     |   x 16 Bytes)               |
+ *     |                             |
+ *      ----------------------------- <-- CPT_LF_Q_BASE[ADDR]
+ *     | Flow Control (128 Bytes)    |
+ *     |                             |
+ *      -----------------------------
+ *     |  Instruction Memory         |
+ *     |  (CPT_LF_Q_SIZE[SIZE_DIV40] |
+ *     |   × 40 × 64 bytes)          |
+ *     |                             |
+ *      -----------------------------
+ */
+static int rvu_rx_cpt_iq_alloc(struct rvu *rvu, struct rvu_cpt_inst_queue *iq)
+{
+	iq->size = RVU_CPT_INST_QLEN_BYTES + RVU_CPT_Q_FC_LEN +
+		    RVU_CPT_INST_GRP_QLEN_BYTES + OTX2_ALIGN;
+
+	iq->real_vaddr = dma_alloc_coherent(rvu->dev, iq->size,
+					    &iq->real_dma_addr, GFP_KERNEL);
+	if (!iq->real_vaddr)
+		return -ENOMEM;
+
+	/* iq->vaddr/dma_addr points to Flow Control location */
+	iq->vaddr = iq->real_vaddr + RVU_CPT_INST_GRP_QLEN_BYTES;
+	iq->dma_addr = iq->real_dma_addr + RVU_CPT_INST_GRP_QLEN_BYTES;
+
+	/* Align pointers */
+	iq->vaddr = PTR_ALIGN(iq->vaddr, OTX2_ALIGN);
+	iq->dma_addr = PTR_ALIGN(iq->dma_addr, OTX2_ALIGN);
+	return 0;
+}
+
+static void rvu_rx_cpt_iq_free(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_cpt_inst_queue *iq;
+
+	if (blkaddr == BLKADDR_CPT0)
+		iq = &rvu->rvu_cpt.cpt0_iq;
+	else
+		iq = &rvu->rvu_cpt.cpt1_iq;
+
+	if (!iq->real_vaddr)
+		dma_free_coherent(rvu->dev, iq->size, iq->real_vaddr,
+				  iq->real_dma_addr);
+
+	iq->real_vaddr = NULL;
+	iq->vaddr = NULL;
+}
+
+static int rvu_rx_cpt_set_grp_pri_ilen(struct rvu *rvu, int blkaddr, int cptlf)
+{
+	u64 reg_val;
+
+	reg_val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+	/* Set High priority */
+	reg_val |= 1;
+	/* Set engine group */
+	reg_val |= ((1ULL << rvu->rvu_cpt.inline_ipsec_egrp) << 48);
+	/* Set ilen if valid */
+	if (rvu->rvu_cpt.rx_cfg.ctx_ilen_valid)
+		reg_val |= rvu->rvu_cpt.rx_cfg.ctx_ilen  << 17;
+
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), reg_val);
+	return 0;
+}
+
+static int rvu_cpt_rx_inline_cptlf_init(struct rvu *rvu, int blkaddr, int slot)
+{
+	struct rvu_cpt_inst_queue *iq;
+	struct rvu_block *block;
+	int pcifunc = 0;
+	int cptlf;
+	int err;
+	u64 val;
+
+	/* Attach cptlf with AF for inline inbound ipsec */
+	err = rvu_rx_attach_cptlf(rvu, blkaddr);
+	if (err)
+		return err;
+
+	block = &rvu->hw->block[blkaddr];
+	cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+	if (cptlf < 0) {
+		err = CPT_AF_ERR_LF_INVALID;
+		goto detach_cptlf;
+	}
+
+	if (blkaddr == BLKADDR_CPT0)
+		iq = &rvu->rvu_cpt.cpt0_iq;
+	else
+		iq = &rvu->rvu_cpt.cpt1_iq;
+
+	/* Allocate CPT instruction queue */
+	err = rvu_rx_cpt_iq_alloc(rvu, iq);
+	if (err)
+		goto detach_cptlf;
+
+	/* reset CPT LF */
+	cpt_rx_ipsec_lf_reset(rvu, blkaddr, slot);
+
+	/* Disable IQ */
+	cpt_rx_ipsec_lf_disable_iqueue(rvu, blkaddr, slot);
+
+	/* Set IQ base address */
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_Q_BASE,
+			 iq->dma_addr);
+	/* Set IQ size */
+	val = FIELD_PREP(CPT_LF_Q_SIZE_DIV40, RVU_CPT_SIZE_DIV40 +
+			 RVU_CPT_EXTRA_SIZE_DIV40);
+	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_Q_SIZE, val);
+
+	/* Enable IQ */
+	cpt_rx_ipsec_lf_enable_iqueue(rvu, blkaddr, slot);
+
+	/* Set High priority */
+	rvu_rx_cpt_set_grp_pri_ilen(rvu, blkaddr, cptlf);
+
+	return 0;
+detach_cptlf:
+	rvu_rx_detach_cptlf(rvu);
+	return err;
+}
+
+static void rvu_cpt_rx_inline_cptlf_clean(struct rvu *rvu, int blkaddr,
+					  int slot)
+{
+	/* Disable IQ */
+	cpt_rx_ipsec_lf_disable_iqueue(rvu, blkaddr, slot);
+
+	/* Free Instruction Queue */
+	rvu_rx_cpt_iq_free(rvu, blkaddr);
+
+	/* Detach CPTLF */
+	rvu_rx_detach_cptlf(rvu);
+}
+
+static void rvu_cpt_save_rx_inline_lf_cfg(struct rvu *rvu,
+					  struct cpt_rx_inline_lf_cfg_msg *req)
+{
+	rvu->rvu_cpt.rx_cfg.sso_pf_func = req->sso_pf_func;
+	rvu->rvu_cpt.rx_cfg.param1 = req->param1;
+	rvu->rvu_cpt.rx_cfg.param2 = req->param2;
+	rvu->rvu_cpt.rx_cfg.opcode = req->opcode;
+	rvu->rvu_cpt.rx_cfg.credit = req->credit;
+	rvu->rvu_cpt.rx_cfg.credit_th = req->credit_th;
+	rvu->rvu_cpt.rx_cfg.bpid = req->bpid;
+	rvu->rvu_cpt.rx_cfg.ctx_ilen_valid = req->ctx_ilen_valid;
+	rvu->rvu_cpt.rx_cfg.ctx_ilen = req->ctx_ilen;
+}
+
+static void
+rvu_show_diff_cpt_rx_inline_lf_cfg(struct rvu *rvu,
+				   struct cpt_rx_inline_lf_cfg_msg *req)
+{
+	struct device *dev = rvu->dev;
+
+	if (rvu->rvu_cpt.rx_cfg.sso_pf_func != req->sso_pf_func)
+		dev_info(dev, "Mismatch RX inline config sso_pf_func Req %x Prog %x\n",
+			 req->sso_pf_func, rvu->rvu_cpt.rx_cfg.sso_pf_func);
+	if (rvu->rvu_cpt.rx_cfg.param1 != req->param1)
+		dev_info(dev, "Mismatch RX inline config param1 Req %x Prog %x\n",
+			 req->param1, rvu->rvu_cpt.rx_cfg.param1);
+	if (rvu->rvu_cpt.rx_cfg.param2 != req->param2)
+		dev_info(dev, "Mismatch RX inline config param2 Req %x Prog %x\n",
+			 req->param2, rvu->rvu_cpt.rx_cfg.param2);
+	if (rvu->rvu_cpt.rx_cfg.opcode != req->opcode)
+		dev_info(dev, "Mismatch RX inline config opcode Req %x Prog %x\n",
+			 req->opcode, rvu->rvu_cpt.rx_cfg.opcode);
+	if (rvu->rvu_cpt.rx_cfg.credit != req->credit)
+		dev_info(dev, "Mismatch RX inline config credit Req %x Prog %x\n",
+			 req->credit, rvu->rvu_cpt.rx_cfg.credit);
+	if (rvu->rvu_cpt.rx_cfg.credit_th != req->credit_th)
+		dev_info(dev, "Mismatch RX inline config credit_th Req %x Prog %x\n",
+			 req->credit_th, rvu->rvu_cpt.rx_cfg.credit_th);
+	if (rvu->rvu_cpt.rx_cfg.bpid != req->bpid)
+		dev_info(dev, "Mismatch RX inline config bpid Req %x Prog %x\n",
+			 req->bpid, rvu->rvu_cpt.rx_cfg.bpid);
+	if (rvu->rvu_cpt.rx_cfg.ctx_ilen != req->ctx_ilen)
+		dev_info(dev, "Mismatch RX inline config ctx_ilen Req %x Prog %x\n",
+			 req->ctx_ilen, rvu->rvu_cpt.rx_cfg.ctx_ilen);
+	if (rvu->rvu_cpt.rx_cfg.ctx_ilen_valid != req->ctx_ilen_valid)
+		dev_info(dev, "Mismatch RX inline config ctx_ilen_valid Req %x Prog %x\n",
+			 req->ctx_ilen_valid,
+			 rvu->rvu_cpt.rx_cfg.ctx_ilen_valid);
+}
+
+static void rvu_cpt_rx_inline_nix_cfg(struct rvu *rvu)
+{
+	struct nix_inline_ipsec_cfg nix_cfg;
+
+	nix_cfg.enable = 1;
+	nix_cfg.credit_th = rvu->rvu_cpt.rx_cfg.credit_th;
+	nix_cfg.bpid = rvu->rvu_cpt.rx_cfg.bpid;
+	if (!rvu->rvu_cpt.rx_cfg.credit || rvu->rvu_cpt.rx_cfg.credit >
+	    RVU_CPT_INST_QLEN_MSGS)
+		nix_cfg.cpt_credit = RVU_CPT_INST_QLEN_MSGS - 1;
+	else
+		nix_cfg.cpt_credit = rvu->rvu_cpt.rx_cfg.credit - 1;
+
+	nix_cfg.gen_cfg.egrp = rvu->rvu_cpt.inline_ipsec_egrp;
+	if (rvu->rvu_cpt.rx_cfg.opcode) {
+		nix_cfg.gen_cfg.opcode = rvu->rvu_cpt.rx_cfg.opcode;
+	} else {
+		if (is_rvu_otx2(rvu))
+			nix_cfg.gen_cfg.opcode = OTX2_CPT_INLINE_RX_OPCODE;
+		else
+			nix_cfg.gen_cfg.opcode = CN10K_CPT_INLINE_RX_OPCODE;
+	}
+
+	nix_cfg.gen_cfg.param1 = rvu->rvu_cpt.rx_cfg.param1;
+	nix_cfg.gen_cfg.param2 = rvu->rvu_cpt.rx_cfg.param2;
+	nix_cfg.inst_qsel.cpt_pf_func = rvu_get_pf(0);
+	nix_cfg.inst_qsel.cpt_slot = 0;
+
+	nix_inline_ipsec_cfg(rvu, &nix_cfg, BLKADDR_NIX0);
+
+	if (is_block_implemented(rvu->hw, BLKADDR_CPT1))
+		nix_inline_ipsec_cfg(rvu, &nix_cfg, BLKADDR_NIX1);
+}
+
+static int rvu_cpt_rx_inline_ipsec_cfg(struct rvu *rvu)
+{
+	struct rvu_block *block;
+	struct cpt_inline_ipsec_cfg_msg req;
+	u16 pcifunc  = 0;
+	int cptlf;
+	int err;
+
+	memset(&req, 0, sizeof(struct cpt_inline_ipsec_cfg_msg));
+	req.sso_pf_func_ovrd = 0; // Add sysfs interface to set this
+	req.sso_pf_func = rvu->rvu_cpt.rx_cfg.sso_pf_func;
+	req.enable = 1;
+
+	block = &rvu->hw->block[BLKADDR_CPT0];
+	cptlf = rvu_get_lf(rvu, block, pcifunc, 0);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	err = cpt_inline_ipsec_cfg_inbound(rvu, BLKADDR_CPT0, cptlf, &req);
+	if (err)
+		return err;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT1))
+		return 0;
+
+	block = &rvu->hw->block[BLKADDR_CPT1];
+	cptlf = rvu_get_lf(rvu, block, pcifunc, 0);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	return cpt_inline_ipsec_cfg_inbound(rvu, BLKADDR_CPT1, cptlf, &req);
+}
+
+static int rvu_cpt_rx_inline_cptlf_setup(struct rvu *rvu, int blkaddr, int slot)
+{
+	int err;
+
+	err = rvu_cpt_rx_inline_cptlf_init(rvu, blkaddr, slot);
+	if (err) {
+		dev_err(rvu->dev,
+			"CPTLF configuration failed for RX inline ipsec\n");
+		return err;
+	}
+
+	err = rvu_cpt_rx_inline_setup_irq(rvu, blkaddr, slot);
+	if (err) {
+		dev_err(rvu->dev,
+			"CPTLF Interrupt setup failed for RX inline ipsec\n");
+		rvu_cpt_rx_inline_cptlf_clean(rvu, blkaddr, slot);
+		return err;
+	}
+	return 0;
+}
+
+static void rvu_rx_cptlf_cleanup(struct rvu *rvu, int blkaddr, int slot)
+{
+	/* IRQ cleanup */
+	rvu_cpt_rx_inline_cleanup_irq(rvu, blkaddr, slot);
+
+	/* CPTLF cleanup */
+	rvu_cpt_rx_inline_cptlf_clean(rvu, blkaddr, slot);
+}
+
+int rvu_mbox_handler_cpt_rx_inline_lf_cfg(struct rvu *rvu,
+					  struct cpt_rx_inline_lf_cfg_msg *req,
+					  struct msg_rsp *rsp)
+{
+	u8 egrp = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	int err;
+	int i;
+
+	mutex_lock(&rvu->rvu_cpt.lock);
+	if (rvu->rvu_cpt.rx_initialized) {
+		dev_info(rvu->dev, "Inline RX CPT already initialized\n");
+		rvu_show_diff_cpt_rx_inline_lf_cfg(rvu, req);
+		err = 0;
+		goto unlock;
+	}
+
+	/* Get Inline Ipsec Engine Group */
+	for (i = 0; i < OTX2_CPT_MAX_ENG_TYPES; i++) {
+		if (rvu->rvu_cpt.eng_grp[i].eng_type == OTX2_CPT_IE_TYPES) {
+			egrp = rvu->rvu_cpt.eng_grp[i].grp_num;
+			break;
+		}
+	}
+
+	if (egrp == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(rvu->dev,
+			"Engine group for inline ipsec not available\n");
+		err = -ENODEV;
+		goto unlock;
+	}
+	rvu->rvu_cpt.inline_ipsec_egrp = egrp;
+
+	rvu_cpt_save_rx_inline_lf_cfg(rvu, req);
+
+	err = rvu_cpt_rx_inline_cptlf_setup(rvu, BLKADDR_CPT0, 0);
+	if (err)
+		goto unlock;
+
+	if (is_block_implemented(rvu->hw, BLKADDR_CPT1)) {
+		err = rvu_cpt_rx_inline_cptlf_setup(rvu, BLKADDR_CPT1, 0);
+		if (err)
+			goto cptlf_cleanup;
+	}
+
+	rvu_cpt_rx_inline_nix_cfg(rvu);
+
+	err = rvu_cpt_rx_inline_ipsec_cfg(rvu);
+	if (err)
+		goto cptlf1_cleanup;
+
+	rvu->rvu_cpt.rx_initialized = true;
+	mutex_unlock(&rvu->rvu_cpt.lock);
+	return 0;
+
+cptlf1_cleanup:
+	rvu_rx_cptlf_cleanup(rvu, BLKADDR_CPT1, 0);
+cptlf_cleanup:
+	rvu_rx_cptlf_cleanup(rvu, BLKADDR_CPT0, 0);
+unlock:
+	mutex_unlock(&rvu->rvu_cpt.lock);
+	return err;
+}
+
 #define MAX_RXC_ICB_CNT  GENMASK_ULL(40, 32)
 
 int rvu_cpt_init(struct rvu *rvu)
@@ -1336,5 +1898,6 @@ int rvu_cpt_init(struct rvu *rvu)
 
 	spin_lock_init(&rvu->cpt_intr_lock);
 
+	mutex_init(&rvu->rvu_cpt.lock);
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
new file mode 100644
index 000000000000..4b57c7038d6c
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell AF CPT driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#ifndef RVU_CPT_H
+#define RVU_CPT_H
+
+#include <linux/types.h>
+
+/* CPT instruction size in bytes */
+#define RVU_CPT_INST_SIZE	64
+
+/* CPT instruction (CPT_INST_S) queue length */
+#define RVU_CPT_INST_QLEN	8200
+
+/* CPT instruction queue size passed to HW is in units of
+ * 40*CPT_INST_S messages.
+ */
+#define RVU_CPT_SIZE_DIV40 (RVU_CPT_INST_QLEN / 40)
+
+/* CPT instruction and pending queues length in CPT_INST_S messages */
+#define RVU_CPT_INST_QLEN_MSGS	((RVU_CPT_SIZE_DIV40 - 1) * 40)
+
+/* CPT needs 320 free entries */
+#define RVU_CPT_INST_QLEN_EXTRA_BYTES	(320 * RVU_CPT_INST_SIZE)
+#define RVU_CPT_EXTRA_SIZE_DIV40	(320 / 40)
+
+/* CPT instruction queue length in bytes */
+#define RVU_CPT_INST_QLEN_BYTES                                               \
+		((RVU_CPT_SIZE_DIV40 * 40 * RVU_CPT_INST_SIZE) +             \
+		RVU_CPT_INST_QLEN_EXTRA_BYTES)
+
+/* CPT instruction group queue length in bytes */
+#define RVU_CPT_INST_GRP_QLEN_BYTES                                           \
+		((RVU_CPT_SIZE_DIV40 + RVU_CPT_EXTRA_SIZE_DIV40) * 16)
+
+/* CPT FC length in bytes */
+#define RVU_CPT_Q_FC_LEN 128
+
+/* CPT LF_Q_SIZE Register */
+#define CPT_LF_Q_SIZE_DIV40 GENMASK_ULL(14, 0)
+
+/* CPT invalid engine group num */
+#define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
+
+/* Fastpath ipsec opcode with inplace processing */
+#define OTX2_CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
+#define CN10K_CPT_INLINE_RX_OPCODE (0x29 | (1 << 6))
+
+/* Calculate CPT register offset */
+#define CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
+		(((blk) << 20) | ((slot) << 12) | (offs))
+
+static inline void otx2_cpt_write64(void __iomem *reg_base, u64 blk, u64 slot,
+				    u64 offs, u64 val)
+{
+	writeq_relaxed(val, reg_base + CPT_RVU_FUNC_ADDR_S(blk, slot, offs));
+}
+
+static inline u64 otx2_cpt_read64(void __iomem *reg_base, u64 blk, u64 slot,
+				  u64 offs)
+{
+	return readq_relaxed(reg_base + CPT_RVU_FUNC_ADDR_S(blk, slot, offs));
+}
+#endif // RVU_CPT_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 613655fcd34f..6bd995c45dad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -5486,8 +5486,8 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 #define CPT_INST_CREDIT_BPID  GENMASK_ULL(30, 22)
 #define CPT_INST_CREDIT_CNT   GENMASK_ULL(21, 0)
 
-static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *req,
-				 int blkaddr)
+void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *req,
+			  int blkaddr)
 {
 	u8 cpt_idx, cpt_blkaddr;
 	u64 val;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 62cdc714ba57..a982cffdc5f5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -563,6 +563,11 @@
 
 #define CPT_LF_CTL                      0x10
 #define CPT_LF_INPROG                   0x40
+#define CPT_LF_MISC_INT                 0xb0
+#define CPT_LF_MISC_INT_ENA_W1S         0xb0
+#define CPT_LF_MISC_INT_ENA_W1C         0xb0
+#define CPT_LF_MISC_INT_MASK            0x6e
+#define CPT_LF_Q_BASE                   0xf0
 #define CPT_LF_Q_SIZE                   0x100
 #define CPT_LF_Q_INST_PTR               0x110
 #define CPT_LF_Q_GRP_PTR                0x120
-- 
2.43.0

