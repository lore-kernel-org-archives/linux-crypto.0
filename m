Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E222C55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223B2206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgKFL3W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgKFL3W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:22 -0500
IronPort-SDR: EGySbbBSmKVhXld5J/sPHZ7ofQqJkePJX3F6t5MCZ0O1CPxGAoDsJfqQyIV8C+rRxLfWAkOZN2
 hHFcMXPBRJww==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698350"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698350"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:21 -0800
IronPort-SDR: xpOwbH0Pyl6ZEr4gRhQkuC75KbxUcEnp76edVnkUlUFO0Hrk7Wu3X6PT6QrtJ0LVlsysqwgDVp
 esrm9lxxxDQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779400"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:20 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 28/32] crypto: qat - loader: add FCU CSRs to chip info
Date:   Fri,  6 Nov 2020 19:28:06 +0800
Message-Id: <20201106112810.2566-29-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add firmware control unit (FCU) CSRs to chip info so the firmware
authentication code is common between all devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  6 +++
 drivers/crypto/qat/qat_common/qat_hal.c       | 19 +++++++-
 drivers/crypto/qat/qat_common/qat_uclo.c      | 44 +++++++++++++------
 3 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 29710e88e8b8..e280a077303f 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -34,6 +34,12 @@ struct icp_qat_fw_loader_chip_info {
 	u32 wakeup_event_val;
 	bool fw_auth;
 	bool css_3k;
+	u32 fcu_ctl_csr;
+	u32 fcu_sts_csr;
+	u32 fcu_dram_addr_hi;
+	u32 fcu_dram_addr_lo;
+	u32 fcu_loaded_ae_csr;
+	u8 fcu_loaded_ae_pos;
 };
 
 struct icp_qat_fw_loader_handle {
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 8470139bcfe8..da138fb11a63 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -707,6 +707,12 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = true;
 		handle->chip_info->css_3k = false;
+		handle->chip_info->fcu_ctl_csr = FCU_CONTROL;
+		handle->chip_info->fcu_sts_csr = FCU_STATUS;
+		handle->chip_info->fcu_dram_addr_hi = FCU_DRAM_ADDR_HI;
+		handle->chip_info->fcu_dram_addr_lo = FCU_DRAM_ADDR_LO;
+		handle->chip_info->fcu_loaded_ae_csr = FCU_STATUS;
+		handle->chip_info->fcu_loaded_ae_pos = FCU_LOADED_AE_POS;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		handle->chip_info->sram_visible = true;
@@ -719,6 +725,12 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = false;
 		handle->chip_info->css_3k = false;
+		handle->chip_info->fcu_ctl_csr = 0;
+		handle->chip_info->fcu_sts_csr = 0;
+		handle->chip_info->fcu_dram_addr_hi = 0;
+		handle->chip_info->fcu_dram_addr_lo = 0;
+		handle->chip_info->fcu_loaded_ae_csr = 0;
+		handle->chip_info->fcu_loaded_ae_pos = 0;
 		break;
 	default:
 		ret = -EINVAL;
@@ -842,17 +854,20 @@ int qat_hal_start(struct icp_qat_fw_loader_handle *handle)
 {
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	u32 wakeup_val = handle->chip_info->wakeup_event_val;
+	u32 fcu_ctl_csr, fcu_sts_csr;
 	unsigned int fcu_sts;
 	unsigned char ae;
 	u32 ae_ctr = 0;
 	int retry = 0;
 
 	if (handle->chip_info->fw_auth) {
+		fcu_ctl_csr = handle->chip_info->fcu_ctl_csr;
+		fcu_sts_csr = handle->chip_info->fcu_sts_csr;
 		ae_ctr = hweight32(ae_mask);
-		SET_CAP_CSR(handle, FCU_CONTROL, FCU_CTRL_CMD_START);
+		SET_CAP_CSR(handle, fcu_ctl_csr, FCU_CTRL_CMD_START);
 		do {
 			msleep(FW_AUTH_WAIT_PERIOD);
-			fcu_sts = GET_CAP_CSR(handle, FCU_STATUS);
+			fcu_sts = GET_CAP_CSR(handle, fcu_sts_csr);
 			if (((fcu_sts >> FCU_STS_DONE_POS) & 0x1))
 				return ae_ctr;
 		} while (retry++ < FW_AUTH_MAX_RETRY);
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 933b6357971f..3c5746d52756 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1190,18 +1190,26 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
 			    struct icp_qat_fw_auth_desc *desc)
 {
-	unsigned int fcu_sts, retry = 0;
+	u32 fcu_sts, retry = 0;
+	u32 fcu_ctl_csr, fcu_sts_csr;
+	u32 fcu_dram_hi_csr, fcu_dram_lo_csr;
 	u64 bus_addr;
 
 	bus_addr = ADD_ADDR(desc->css_hdr_high, desc->css_hdr_low)
 			   - sizeof(struct icp_qat_auth_chunk);
-	SET_CAP_CSR(handle, FCU_DRAM_ADDR_HI, (bus_addr >> BITS_IN_DWORD));
-	SET_CAP_CSR(handle, FCU_DRAM_ADDR_LO, bus_addr);
-	SET_CAP_CSR(handle, FCU_CONTROL, FCU_CTRL_CMD_AUTH);
+
+	fcu_ctl_csr = handle->chip_info->fcu_ctl_csr;
+	fcu_sts_csr = handle->chip_info->fcu_sts_csr;
+	fcu_dram_hi_csr = handle->chip_info->fcu_dram_addr_hi;
+	fcu_dram_lo_csr = handle->chip_info->fcu_dram_addr_lo;
+
+	SET_CAP_CSR(handle, fcu_dram_hi_csr, (bus_addr >> BITS_IN_DWORD));
+	SET_CAP_CSR(handle, fcu_dram_lo_csr, bus_addr);
+	SET_CAP_CSR(handle, fcu_ctl_csr, FCU_CTRL_CMD_AUTH);
 
 	do {
 		msleep(FW_AUTH_WAIT_PERIOD);
-		fcu_sts = GET_CAP_CSR(handle, FCU_STATUS);
+		fcu_sts = GET_CAP_CSR(handle, fcu_sts_csr);
 		if ((fcu_sts & FCU_AUTH_STS_MASK) == FCU_STS_VERI_FAIL)
 			goto auth_fail;
 		if (((fcu_sts >> FCU_STS_AUTHFWLD_POS) & 0x1))
@@ -1369,11 +1377,16 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 			    struct icp_qat_fw_auth_desc *desc)
 {
-	unsigned int i;
-	unsigned int fcu_sts;
 	struct icp_qat_simg_ae_mode *virt_addr;
-	unsigned int fcu_loaded_ae_pos = FCU_LOADED_AE_POS;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	u32 fcu_sts_csr, fcu_ctl_csr;
+	u32 loaded_aes, loaded_csr;
+	unsigned int i;
+	u32 fcu_sts;
+
+	fcu_ctl_csr = handle->chip_info->fcu_ctl_csr;
+	fcu_sts_csr = handle->chip_info->fcu_sts_csr;
+	loaded_csr = handle->chip_info->fcu_loaded_ae_csr;
 
 	virt_addr = (void *)((uintptr_t)desc +
 		     sizeof(struct icp_qat_auth_chunk) +
@@ -1389,16 +1402,19 @@ static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 			pr_err("QAT: AE %d is active\n", i);
 			return -EINVAL;
 		}
-		SET_CAP_CSR(handle, FCU_CONTROL,
+		SET_CAP_CSR(handle, fcu_ctl_csr,
 			    (FCU_CTRL_CMD_LOAD | (i << FCU_CTRL_AE_POS)));
 
 		do {
 			msleep(FW_AUTH_WAIT_PERIOD);
-			fcu_sts = GET_CAP_CSR(handle, FCU_STATUS);
-			if (((fcu_sts & FCU_AUTH_STS_MASK) ==
-			    FCU_STS_LOAD_DONE) &&
-			    ((fcu_sts >> fcu_loaded_ae_pos) & (1 << i)))
-				break;
+			fcu_sts = GET_CAP_CSR(handle, fcu_sts_csr);
+			if ((fcu_sts & FCU_AUTH_STS_MASK) ==
+			    FCU_STS_LOAD_DONE) {
+				loaded_aes = GET_CAP_CSR(handle, loaded_csr);
+				loaded_aes >>= handle->chip_info->fcu_loaded_ae_pos;
+				if (loaded_aes & (1 << i))
+					break;
+			}
 		} while (retry++ < FW_AUTH_MAX_RETRY);
 		if (retry > FW_AUTH_MAX_RETRY) {
 			pr_err("QAT: firmware load failed timeout %x\n", retry);
-- 
2.25.4

