Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58C8CDB483
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 06:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjJPGuI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjJPGuG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 02:50:06 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D988DC
        for <linux-crypto@vger.kernel.org>; Sun, 15 Oct 2023 23:50:03 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39FMh2vS018622;
        Sun, 15 Oct 2023 23:49:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=J/w4HyoXLoqcstXa+S9q9fuJ0iGxxlX4hqvPQLcgNSM=;
 b=btoz/hkRpvpP2odfcz84hzhwG7WnN/Ht2uDy2bo3LTvZaXznVHmjb79CmbXThI6Nf+3d
 CUfWwWqpI5ZMUUbsBNsndF92c2MuJ2cz52FGBRfxwIAxuXVsfJ2izKLJdOmQPPteESJR
 3xiI96j7c1Sn/KSDq33T8CXLzpf8WDiYu8J/LP8AFc/1fE+l5yplKOzjLtEzD+97ZXE2
 zYOEz5Z4lVaQ+ayHcqouLI6DHCM0iTXaVvPSVpb7xvbJPRc98ELlX9qxPsnTE0edtTlL
 SH5HxTF/4K3ilmu+9ftzrldJ1BQ/kK6iC88oie/BAhzER61p3vOKqXYm+HVWbHR2ixjv nA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3tqtgkm92r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Oct 2023 23:49:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 15 Oct
 2023 23:49:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 15 Oct 2023 23:49:47 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 36F173F705B;
        Sun, 15 Oct 2023 23:49:44 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <schalla@marvell.com>
Subject: [PATCH 03/10] crypto: octeontx2: add devlink option to set max_rxc_icb_cnt
Date:   Mon, 16 Oct 2023 12:19:27 +0530
Message-ID: <20231016064934.1913964-4-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016064934.1913964-1-schalla@marvell.com>
References: <20231016064934.1913964-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: q__4qb9mngesn2bV8j5VQ0Tt48Cu-xnU
X-Proofpoint-ORIG-GUID: q__4qb9mngesn2bV8j5VQ0Tt48Cu-xnU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-15_09,2023-10-12_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On CN10KA B0/CN10KB HW, maximum icb entries that RX can use,
can be configured through HW CSR. This patch adds option
to set max icb entries through devlink parameter and also sets
max_rxc_icb_cnt to 0xc0 as default to match inline
inbound peak performance compared to other chip versions.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  8 ++++
 .../marvell/octeontx2/otx2_cpt_devlink.c      | 44 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 14 ++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  1 +
 4 files changed, 67 insertions(+)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 9a2cbee5a834..805b2adf0c22 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -192,6 +192,14 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 	}
 }
 
+static inline bool cpt_feature_rxc_icb_cnt(struct pci_dev *pdev)
+{
+	if (!is_dev_otx2(pdev) && !is_dev_cn10ka_ax(pdev))
+		return true;
+
+	return false;
+}
+
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
index a2aba0b0d68a..e11f334600c7 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
@@ -32,10 +32,48 @@ static int otx2_cpt_dl_uc_info(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int otx2_cpt_dl_max_rxc_icb_cnt(struct devlink *dl, u32 id,
+				       struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+	struct pci_dev *pdev = cptpf->pdev;
+	u64 reg_val = 0;
+
+	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_RXC_CFG1, &reg_val,
+			     BLKADDR_CPT0);
+	ctx->val.vu16 = (reg_val >> 32) & 0x1FF;
+
+	return 0;
+}
+
+static int otx2_cpt_dl_max_rxc_icb_cnt_set(struct devlink *dl, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+	struct pci_dev *pdev = cptpf->pdev;
+	u64 reg_val = 0;
+
+	if (cptpf->enabled_vfs != 0)
+		return -EPERM;
+
+	if (cpt_feature_rxc_icb_cnt(pdev)) {
+		otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_RXC_CFG1, &reg_val,
+				     BLKADDR_CPT0);
+		reg_val &= ~(0x1FFULL << 32);
+		reg_val |= (u64)ctx->val.vu16 << 32;
+		return otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_RXC_CFG1,
+					     reg_val, BLKADDR_CPT0);
+	}
+	return 0;
+}
+
 enum otx2_cpt_dl_param_id {
 	OTX2_CPT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_CREATE,
 	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_DELETE,
+	OTX2_CPT_DEVLINK_PARAM_ID_MAX_RXC_ICB_CNT,
 };
 
 static const struct devlink_param otx2_cpt_dl_params[] = {
@@ -49,6 +87,12 @@ static const struct devlink_param otx2_cpt_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     otx2_cpt_dl_uc_info, otx2_cpt_dl_egrp_delete,
 			     NULL),
+	DEVLINK_PARAM_DRIVER(OTX2_CPT_DEVLINK_PARAM_ID_MAX_RXC_ICB_CNT,
+			     "max_rxc_icb_cnt", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_cpt_dl_max_rxc_icb_cnt,
+			     otx2_cpt_dl_max_rxc_icb_cnt_set,
+			     NULL),
 };
 
 static int otx2_cpt_dl_info_firmware_version_put(struct devlink_info_req *req,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index f047185f38e0..f36a5ee55ac3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -673,6 +673,7 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 		case CPT_AF_BLK_RST:
 		case CPT_AF_CONSTANTS1:
 		case CPT_AF_CTX_FLUSH_TIMER:
+		case CPT_AF_RXC_CFG1:
 			return true;
 		}
 
@@ -1213,8 +1214,21 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 
 int rvu_cpt_init(struct rvu *rvu)
 {
+	u64 reg_val;
+
 	/* Retrieve CPT PF number */
 	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
+	if (is_block_implemented(rvu->hw, BLKADDR_CPT0) &&
+	    (!is_rvu_otx2(rvu) && !is_cn10ka_a0(rvu) && !is_cn10ka_a1(rvu))) {
+		/* Set CPT_AF_RXC_CFG1:max_rxc_icb_cnt to 0xc0 to not effect
+		 * inline inbound peak performance
+		 */
+		reg_val = rvu_read64(rvu, BLKADDR_CPT0, CPT_AF_RXC_CFG1);
+		reg_val &= ~(0x1FFULL << 32);
+		reg_val |= 0xC0ULL << 32;
+		rvu_write64(rvu, BLKADDR_CPT0, CPT_AF_RXC_CFG1, reg_val);
+	}
+
 	spin_lock_init(&rvu->cpt_intr_lock);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index b42e631e52d0..b3f1442d5196 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -532,6 +532,7 @@
 #define CPT_AF_CTX_PSH_PC               (0x49450ull)
 #define CPT_AF_CTX_PSH_LATENCY_PC       (0x49458ull)
 #define CPT_AF_CTX_CAM_DATA(a)          (0x49800ull | (u64)(a) << 3)
+#define CPT_AF_RXC_CFG1                 (0x50000ull)
 #define CPT_AF_RXC_TIME                 (0x50010ull)
 #define CPT_AF_RXC_TIME_CFG             (0x50018ull)
 #define CPT_AF_RXC_DFRG                 (0x50020ull)
-- 
2.25.1

