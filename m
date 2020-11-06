Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB836C55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82767206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgKFL32 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgKFL31 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:27 -0500
IronPort-SDR: u0fN2SXhMlFFTDd001FnME68CGNh/IIB/DboD4GbreSfYAUveAz10V6F6USjudBBWkHEN6Si3o
 6BPGwHcJm7jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698363"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698363"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:27 -0800
IronPort-SDR: nCIC6H2XlCOuSPCLYcK1Uiz9ynWDi2IajERJG1ATFbNstPj1/f73sYquhjDxIvS9NktKVwN10X
 QYgpAMs9reBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779445"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:25 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 31/32] crypto: qat - loader: add support for broadcasting mode
Date:   Fri,  6 Nov 2020 19:28:09 +0800
Message-Id: <20201106112810.2566-32-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for broadcasting mode in firmware loader to enable the next
generation of QAT devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
 drivers/crypto/qat/qat_common/icp_qat_hal.h   | 10 +++
 drivers/crypto/qat/qat_common/qat_hal.c       |  1 +
 drivers/crypto/qat/qat_common/qat_uclo.c      | 90 ++++++++++++++++++-
 4 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 5b9f2e8c9451..b8f3463be6ef 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -15,6 +15,7 @@ struct icp_qat_fw_loader_ae_data {
 struct icp_qat_fw_loader_hal_handle {
 	struct icp_qat_fw_loader_ae_data aes[ICP_QAT_UCLO_MAX_AE];
 	unsigned int ae_mask;
+	unsigned int admin_ae_mask;
 	unsigned int slice_mask;
 	unsigned int revision_id;
 	unsigned int ae_max_num;
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index 02476b2ceee1..8372f18ebc80 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -53,6 +53,15 @@ enum fcu_csr {
 	FCU_RAMBASE_ADDR_LO   = 0x8d8
 };
 
+enum fcu_csr_4xxx {
+	FCU_CONTROL_4XXX           = 0x1000,
+	FCU_STATUS_4XXX            = 0x1004,
+	FCU_ME_BROADCAST_MASK_TYPE = 0x1008,
+	FCU_AE_LOADED_4XXX         = 0x1010,
+	FCU_DRAM_ADDR_LO_4XXX      = 0x1014,
+	FCU_DRAM_ADDR_HI_4XXX      = 0x1018,
+};
+
 enum fcu_cmd {
 	FCU_CTRL_CMD_NOOP  = 0,
 	FCU_CTRL_CMD_AUTH  = 1,
@@ -90,6 +99,7 @@ enum fcu_sts {
 #define LCS_STATUS          (0x1)
 #define MMC_SHARE_CS_BITPOS         2
 #define WAKEUP_EVENT 0x10000
+#define FCU_CTRL_BROADCAST_POS   0x4
 #define FCU_CTRL_AE_POS     0x8
 #define FCU_AUTH_STS_MASK   0x7
 #define FCU_STS_DONE_POS    0x9
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 6ccfb8cf3a07..a3c1f2163910 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -762,6 +762,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	handle->pci_dev = pci_info->pci_dev;
 	handle->hal_handle->revision_id = accel_dev->accel_pci_dev.revid;
 	handle->hal_handle->ae_mask = hw_data->ae_mask;
+	handle->hal_handle->admin_ae_mask = hw_data->admin_ae_mask;
 	handle->hal_handle->slice_mask = hw_data->accel_mask;
 	handle->cfg_ae_mask = ALL_AE_MASK;
 	/* create AE objects */
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index b280fb0722c5..c089c2709376 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1239,6 +1239,83 @@ static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	return -EINVAL;
 }
 
+static bool qat_uclo_is_broadcast(struct icp_qat_fw_loader_handle *handle,
+				  int imgid)
+{
+	struct icp_qat_suof_handle *sobj_handle;
+
+	if (!handle->chip_info->tgroup_share_ustore)
+		return false;
+
+	sobj_handle = (struct icp_qat_suof_handle *)handle->sobj_handle;
+	if (handle->hal_handle->admin_ae_mask &
+	    sobj_handle->img_table.simg_hdr[imgid].ae_mask)
+		return false;
+
+	return true;
+}
+
+static int qat_uclo_broadcast_load_fw(struct icp_qat_fw_loader_handle *handle,
+				      struct icp_qat_fw_auth_desc *desc)
+{
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned long desc_ae_mask = desc->ae_mask;
+	u32 fcu_sts, ae_broadcast_mask = 0;
+	u32 fcu_loaded_csr, ae_loaded;
+	u32 fcu_sts_csr, fcu_ctl_csr;
+	unsigned int ae, retry = 0;
+
+	if (handle->chip_info->tgroup_share_ustore) {
+		fcu_ctl_csr = handle->chip_info->fcu_ctl_csr;
+		fcu_sts_csr = handle->chip_info->fcu_sts_csr;
+		fcu_loaded_csr = handle->chip_info->fcu_loaded_ae_csr;
+	} else {
+		pr_err("Chip 0x%x doesn't support broadcast load\n",
+		       handle->pci_dev->device);
+		return -EINVAL;
+	}
+
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
+		if (qat_hal_check_ae_active(handle, (unsigned char)ae)) {
+			pr_err("QAT: Broadcast load failed. AE is not enabled or active.\n");
+			return -EINVAL;
+		}
+
+		if (test_bit(ae, &desc_ae_mask))
+			ae_broadcast_mask |= 1 << ae;
+	}
+
+	if (ae_broadcast_mask) {
+		SET_CAP_CSR(handle, FCU_ME_BROADCAST_MASK_TYPE,
+			    ae_broadcast_mask);
+
+		SET_CAP_CSR(handle, fcu_ctl_csr, FCU_CTRL_CMD_LOAD);
+
+		do {
+			msleep(FW_AUTH_WAIT_PERIOD);
+			fcu_sts = GET_CAP_CSR(handle, fcu_sts_csr);
+			fcu_sts &= FCU_AUTH_STS_MASK;
+
+			if (fcu_sts == FCU_STS_LOAD_FAIL) {
+				pr_err("Broadcast load failed: 0x%x)\n", fcu_sts);
+				return -EINVAL;
+			} else if (fcu_sts == FCU_STS_LOAD_DONE) {
+				ae_loaded = GET_CAP_CSR(handle, fcu_loaded_csr);
+				ae_loaded >>= handle->chip_info->fcu_loaded_ae_pos;
+
+				if ((ae_loaded & ae_broadcast_mask) == ae_broadcast_mask)
+					break;
+			}
+		} while (retry++ < FW_AUTH_MAX_RETRY);
+
+		if (retry > FW_AUTH_MAX_RETRY) {
+			pr_err("QAT: broadcast load failed timeout %d\n", retry);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 static int qat_uclo_simg_alloc(struct icp_qat_fw_loader_handle *handle,
 			       struct icp_firml_dram_desc *dram_desc,
 			       unsigned int size)
@@ -1420,7 +1497,9 @@ static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 			return -EINVAL;
 		}
 		SET_CAP_CSR(handle, fcu_ctl_csr,
-			    (FCU_CTRL_CMD_LOAD | (i << FCU_CTRL_AE_POS)));
+			    (FCU_CTRL_CMD_LOAD |
+			    (1 << FCU_CTRL_BROADCAST_POS) |
+			    (i << FCU_CTRL_AE_POS)));
 
 		do {
 			msleep(FW_AUTH_WAIT_PERIOD);
@@ -1945,8 +2024,13 @@ static int qat_uclo_wr_suof_img(struct icp_qat_fw_loader_handle *handle)
 			goto wr_err;
 		if (qat_uclo_auth_fw(handle, desc))
 			goto wr_err;
-		if (qat_uclo_load_fw(handle, desc))
-			goto wr_err;
+		if (qat_uclo_is_broadcast(handle, i)) {
+			if (qat_uclo_broadcast_load_fw(handle, desc))
+				goto wr_err;
+		} else {
+			if (qat_uclo_load_fw(handle, desc))
+				goto wr_err;
+		}
 		qat_uclo_ummap_auth_fw(handle, &desc);
 	}
 	return 0;
-- 
2.25.4

