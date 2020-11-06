Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962FDC55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA3B206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgKFL3I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgKFL3I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:08 -0500
IronPort-SDR: 2Z1a6K0O2aoO9xvMTuthW2/+MjL3vOpQpBZiiInD53Cx//D35Zf+9Yqf3NH1kzuOovnnmal0BJ
 joqIysmRAUbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698321"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698321"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:07 -0800
IronPort-SDR: WxKIRRSGpFjKe27AatInMeKQM4lVOcq8bju081o2qqzOvk5NhwVnr0IffkZFYeikblDx8DqR9E
 ZsRrtoWICmgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779325"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:06 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 20/32] crypto: qat - loader: add local memory size to chip info
Date:   Fri,  6 Nov 2020 19:27:58 +0800
Message-Id: <20201106112810.2566-21-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the local memory size to the chip info since the size of this memory
will be different in the next generation of QAT devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h | 1 +
 drivers/crypto/qat/qat_common/qat_hal.c                  | 2 ++
 drivers/crypto/qat/qat_common/qat_uclo.c                 | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 3c587105d09d..0fa5c22fd9c0 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -26,6 +26,7 @@ struct icp_qat_fw_loader_chip_info {
 	bool sram_visible;
 	bool nn;
 	bool lm2lm3;
+	u32 lm_size;
 	bool fw_auth;
 };
 
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 70fc93f31e79..44cf797ace71 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -699,12 +699,14 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->sram_visible = false;
 		handle->chip_info->nn = true;
 		handle->chip_info->lm2lm3 = false;
+		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->fw_auth = true;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		handle->chip_info->sram_visible = true;
 		handle->chip_info->nn = true;
 		handle->chip_info->lm2lm3 = false;
+		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->fw_auth = false;
 		break;
 	default:
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 4a90b150199c..32c64a48926f 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -311,7 +311,7 @@ static int qat_uclo_init_lmem_seg(struct icp_qat_fw_loader_handle *handle,
 	unsigned int ae;
 
 	if (qat_uclo_fetch_initmem_ae(handle, init_mem,
-				      ICP_QAT_UCLO_MAX_LMEM_REG, &ae))
+				      handle->chip_info->lm_size, &ae))
 		return -EINVAL;
 	if (qat_uclo_create_batch_init_list(handle, init_mem, ae,
 					    &obj_handle->lm_init_tab[ae]))
-- 
2.25.4

