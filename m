Return-Path: <SRS0=hy52=AG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E973C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 20:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6378820789
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 20:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389067AbgFYUIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:08:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:54738 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388615AbgFYUIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jun 2020 16:08:00 -0400
IronPort-SDR: 0VN1LJtzruAPpsdE8O9WKcMKhbUVeWcmapEiCmWnubpAVgyM/1BiAdCzLwL+Q4PCys02pHCoD3
 FksDE4DQEaLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="229784477"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="229784477"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 13:07:59 -0700
IronPort-SDR: lzNMNoJWbxcej9iBMgBrJXFgOShF63/ya54FTSlorKvuZ+B38c+n7KoUpNO3JxSp2Mw2oy8D+M
 6YTetnVty84A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="312107905"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2020 13:07:59 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Zhou Wang" <wangzhou1@hisilicon.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     linux-crypto@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] crypto: hisilicon/qm: Change type of pasid to u32
Date:   Thu, 25 Jun 2020 13:07:12 -0700
Message-Id: <1593115632-31417-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PASID is defined as "int" although it's a 20-bit value and shouldn't be
negative int. To be consistent with PASID type in iommu, define PASID
as "u32".

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
PASID type will be changed consistently as u32:
https://lore.kernel.org/patchwork/patch/1257770/

 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9bb263cec6c3..8697dacf926d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1741,7 +1741,7 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_release_qp);
 
-static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
+static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 {
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
@@ -1813,7 +1813,7 @@ static int qm_start_qp_nolock(struct hisi_qp *qp, unsigned long arg)
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
 	int qp_id = qp->qp_id;
-	int pasid = arg;
+	u32 pasid = arg;
 	int ret;
 
 	if (!qm_qp_avail_state(qm, qp, QP_START))
-- 
2.19.1

