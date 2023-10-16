Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07024CDB465
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 06:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjJPGuG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjJPGuF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 02:50:05 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66241D9
        for <linux-crypto@vger.kernel.org>; Sun, 15 Oct 2023 23:50:03 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39FLaD4k032587;
        Sun, 15 Oct 2023 23:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=OG97vvAQIoOxPm3AIvVPeiUqkiDiY1rRhVBuPiOogEU=;
 b=LopiPX7+7956XIw/+yhRLWYFS4wrf6hz+1LdDywzdreBdSuKzzqqfGmJcvvLTujeP6Tn
 dR5SRhq0HmhPKdfU7b01iAg6S+betvQhhF16hiHpx31H6xrshKp4Bcwy/CLTM4tbhiMM
 tTNQM4F9D0+lcIBXdCz7egI2AUPn/PZ+owgvdlIRWsSaCnEaIfYyrXjVfHZPRubUV2jR
 Tti76GvMYvhWIbBM2pMNhHF1kY0/QQ4/rULSL8LhS9EwZYJNEN1TY8NXRi0MaIwWj/aa
 xCmb+dtcygaMSD2KEAZmxu2XNnYV9fdTQiv4gmcONsdHNYul71vjoA1qHDY386kjVKXJ IQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3tqrbpvhq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Oct 2023 23:49:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 15 Oct
 2023 23:49:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 15 Oct 2023 23:49:50 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 4184D3F705C;
        Sun, 15 Oct 2023 23:49:48 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <schalla@marvell.com>
Subject: [PATCH 04/10] crypto: octeontx2: add devlink option to set t106 mode
Date:   Mon, 16 Oct 2023 12:19:28 +0530
Message-ID: <20231016064934.1913964-5-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016064934.1913964-1-schalla@marvell.com>
References: <20231016064934.1913964-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: swkkqhdT4wn9PwAoXv_LTRuX9yKpnwVt
X-Proofpoint-GUID: swkkqhdT4wn9PwAoXv_LTRuX9yKpnwVt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-15_09,2023-10-12_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On CN10KA B0/CN10KB, CPT scatter gather format has modified
to support multi-seg in inline IPsec. Due to this CPT requires
new firmware and doesn't work with CN10KA0/A1 firmware. To make
HW works in backward compatibility mode or works with CN10KA0/A1
firmware, a bit(T106_MODE) is introduced in HW CSR.

This patch adds devlink parameter for configuring T106_MODE.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  8 +++
 .../marvell/octeontx2/otx2_cpt_devlink.c      | 51 +++++++++++++++++--
 .../marvell/octeontx2/otx2_cptpf_main.c       |  4 +-
 3 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 805b2adf0c22..bef78db15a89 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -200,6 +200,14 @@ static inline bool cpt_feature_rxc_icb_cnt(struct pci_dev *pdev)
 	return false;
 }
 
+static inline bool cpt_feature_sgv2(struct pci_dev *pdev)
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
index e11f334600c7..161eeb54c306 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
@@ -24,10 +24,7 @@ static int otx2_cpt_dl_egrp_delete(struct devlink *dl, u32 id,
 static int otx2_cpt_dl_uc_info(struct devlink *dl, u32 id,
 			       struct devlink_param_gset_ctx *ctx)
 {
-	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
-	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
-
-	otx2_cpt_print_uc_dbg_info(cptpf);
+	ctx->val.vstr[0] = '\0';
 
 	return 0;
 }
@@ -69,11 +66,50 @@ static int otx2_cpt_dl_max_rxc_icb_cnt_set(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int otx2_cpt_dl_t106_mode_get(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+	struct pci_dev *pdev = cptpf->pdev;
+	u64 reg_val = 0;
+
+	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
+			     BLKADDR_CPT0);
+	ctx->val.vu8 = (reg_val >> 18) & 0x1;
+
+	return 0;
+}
+
+static int otx2_cpt_dl_t106_mode_set(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+	struct pci_dev *pdev = cptpf->pdev;
+	u64 reg_val = 0;
+
+	if (cptpf->enabled_vfs != 0 || cptpf->eng_grps.is_grps_created)
+		return -EPERM;
+
+	if (cpt_feature_sgv2(pdev)) {
+		otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
+				     BLKADDR_CPT0);
+		reg_val &= ~(0x1ULL << 18);
+		reg_val |= ((u64)ctx->val.vu8 & 0x1) << 18;
+		return otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL,
+					     reg_val, BLKADDR_CPT0);
+	}
+
+	return 0;
+}
+
 enum otx2_cpt_dl_param_id {
 	OTX2_CPT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_CREATE,
 	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_DELETE,
 	OTX2_CPT_DEVLINK_PARAM_ID_MAX_RXC_ICB_CNT,
+	OTX2_CPT_DEVLINK_PARAM_ID_T106_MODE,
 };
 
 static const struct devlink_param otx2_cpt_dl_params[] = {
@@ -93,6 +129,11 @@ static const struct devlink_param otx2_cpt_dl_params[] = {
 			     otx2_cpt_dl_max_rxc_icb_cnt,
 			     otx2_cpt_dl_max_rxc_icb_cnt_set,
 			     NULL),
+	DEVLINK_PARAM_DRIVER(OTX2_CPT_DEVLINK_PARAM_ID_T106_MODE,
+			     "t106_mode", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_cpt_dl_t106_mode_get, otx2_cpt_dl_t106_mode_set,
+			     NULL),
 };
 
 static int otx2_cpt_dl_info_firmware_version_put(struct devlink_info_req *req,
@@ -164,7 +205,7 @@ int otx2_cpt_register_dl(struct otx2_cptpf_dev *cptpf)
 		devlink_free(dl);
 		return ret;
 	}
-
+	devlink_params_publish(dl);
 	devlink_register(dl);
 
 	return 0;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index c64c50a964ed..7d44b54659bf 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -600,10 +600,10 @@ static int cptpf_get_rid(struct pci_dev *pdev, struct otx2_cptpf_dev *cptpf)
 	}
 	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
 			     BLKADDR_CPT0);
-	if ((is_dev_cn10ka_b0(pdev) && (reg_val & BIT_ULL(18))) ||
+	if ((cpt_feature_sgv2(pdev) && (reg_val & BIT_ULL(18))) ||
 	    is_dev_cn10ka_ax(pdev))
 		eng_grps->rid = CPT_UC_RID_CN10K_A;
-	else if (is_dev_cn10kb(pdev) || is_dev_cn10ka_b0(pdev))
+	else if (cpt_feature_sgv2(pdev))
 		eng_grps->rid = CPT_UC_RID_CN10K_B;
 
 	return 0;
-- 
2.25.1

