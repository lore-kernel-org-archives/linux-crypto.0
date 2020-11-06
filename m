Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05447C55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF7DE206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgKFL30 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgKFL30 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:26 -0500
IronPort-SDR: tZx7x/+ZD3RRRIHLageF68d5fPzkumyOfMguZtRGfrI+zZuKKw8P4ALqI9Km6xxCntkVbvUR+e
 j/+RhKRI9+lQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698360"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698360"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:25 -0800
IronPort-SDR: 4+JIbl9DvwydJw+9aot2ktfXsMILsDGG9wGUK041YMMS7ByiSKGGrHozHRo8hyp2JuJPZR/qNj
 u921cKAt6grA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779436"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:23 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 30/32] crypto: qat - loader: add support for shared ustore
Date:   Fri,  6 Nov 2020 19:28:08 +0800
Message-Id: <20201106112810.2566-31-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for shared ustore mode support. This is required by the next
generation of QAT devices to share the same fw image across engines.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
 drivers/crypto/qat/qat_common/qat_hal.c       |  2 ++
 drivers/crypto/qat/qat_common/qat_uclo.c      | 29 ++++++++++---------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index cc9b83d965af..5b9f2e8c9451 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -34,6 +34,7 @@ struct icp_qat_fw_loader_chip_info {
 	u32 wakeup_event_val;
 	bool fw_auth;
 	bool css_3k;
+	bool tgroup_share_ustore;
 	u32 fcu_ctl_csr;
 	u32 fcu_sts_csr;
 	u32 fcu_dram_addr_hi;
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 94c0b04088b5..6ccfb8cf3a07 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -707,6 +707,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = true;
 		handle->chip_info->css_3k = false;
+		handle->chip_info->tgroup_share_ustore = false;
 		handle->chip_info->fcu_ctl_csr = FCU_CONTROL;
 		handle->chip_info->fcu_sts_csr = FCU_STATUS;
 		handle->chip_info->fcu_dram_addr_hi = FCU_DRAM_ADDR_HI;
@@ -725,6 +726,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = false;
 		handle->chip_info->css_3k = false;
+		handle->chip_info->tgroup_share_ustore = false;
 		handle->chip_info->fcu_ctl_csr = 0;
 		handle->chip_info->fcu_sts_csr = 0;
 		handle->chip_info->fcu_dram_addr_hi = 0;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index c6b309d107f3..b280fb0722c5 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1180,21 +1180,24 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 		if (!suof_img_hdr)
 			return -ENOMEM;
 		suof_handle->img_table.simg_hdr = suof_img_hdr;
-	}
 
-	for (i = 0; i < suof_handle->img_table.num_simgs; i++) {
-		qat_uclo_map_simg(handle, &suof_img_hdr[i],
-				  &suof_chunk_hdr[1 + i]);
-		ret = qat_uclo_check_simg_compat(handle,
-						 &suof_img_hdr[i]);
-		if (ret)
-			return ret;
-		suof_img_hdr[i].ae_mask &= handle->cfg_ae_mask;
-		if ((suof_img_hdr[i].ae_mask & 0x1) != 0)
-			ae0_img = i;
+		for (i = 0; i < suof_handle->img_table.num_simgs; i++) {
+			qat_uclo_map_simg(handle, &suof_img_hdr[i],
+					  &suof_chunk_hdr[1 + i]);
+			ret = qat_uclo_check_simg_compat(handle,
+							 &suof_img_hdr[i]);
+			if (ret)
+				return ret;
+			suof_img_hdr[i].ae_mask &= handle->cfg_ae_mask;
+			if ((suof_img_hdr[i].ae_mask & 0x1) != 0)
+				ae0_img = i;
+		}
+
+		if (!handle->chip_info->tgroup_share_ustore) {
+			qat_uclo_tail_img(suof_img_hdr, ae0_img,
+					  suof_handle->img_table.num_simgs);
+		}
 	}
-	qat_uclo_tail_img(suof_img_hdr, ae0_img,
-			  suof_handle->img_table.num_simgs);
 	return 0;
 }
 
-- 
2.25.4

