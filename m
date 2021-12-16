Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB8CC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbhLPJLX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:9668 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232950AbhLPJLU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645880; x=1671181880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K2TzQOiZP4DKu0EJL9pdzCr9y9B+6SXnrUbfTnm41o0=;
  b=JT7ArY6VgHgtpKRUA8PycyCHM4MhNAdG7m4x9BdBPSaZLfQbtyq25biO
   h8vlVqYaMRaUmQA8XeWkYQkLPcbJoNB97YAKe/CnQSGZHDNMANj1XaHOQ
   SIuTi+Y0uNUnhycaVCxX68yGkVv2zpQ+fo/fPXLnsfhiiYU9d61vSljKn
   S1Qtiul+8+gM+i0+46G5WigHOQOPc31HXfe35Sxolz8GnXjqUX7nC1d3p
   lIsKiKVC+Q/f/ycx2oniIxP9lYykBdSKGEG4mciOV1A2qVfGJvxAOcEtW
   yOXeVTfUsFZy0GT7DxTO6JgUtfAATXCDV/NNyFMHFmXwpVPri4xWXIacU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458367"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458367"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968430"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:18 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 05/24] crypto: qat - support the reset of ring pairs on PF
Date:   Thu, 16 Dec 2021 09:13:15 +0000
Message-Id: <20211216091334.402420-6-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for triggering a HW reset of a specific ring pair.
Being a device specific feature, add it to the hw_device_data struct.

This feature is supported only by QAT GEN4 devices.

This patch is based on earlier work done by Zelin Deng.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  2 +
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |  1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 +
 .../crypto/qat/qat_common/adf_gen4_hw_data.c  | 53 +++++++++++++++++++
 .../crypto/qat/qat_common/adf_gen4_hw_data.h  |  9 ++++
 5 files changed, 67 insertions(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index d320c50c4561..0d1603894af4 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -239,6 +239,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->dev_class = &adf_4xxx_class;
 	hw_data->instance_id = adf_4xxx_class.instances++;
 	hw_data->num_banks = ADF_4XXX_ETR_MAX_BANKS;
+	hw_data->num_banks_per_vf = ADF_4XXX_NUM_BANKS_PER_VF;
 	hw_data->num_rings_per_bank = ADF_4XXX_NUM_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_4XXX_MAX_ACCELERATORS;
 	hw_data->num_engines = ADF_4XXX_MAX_ACCELENGINES;
@@ -279,6 +280,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->pfvf_ops.enable_comms = adf_pfvf_comms_disabled;
 	hw_data->pfvf_ops.get_vf2pf_sources = get_vf2pf_sources;
 	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 }
diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
index 924bac6feb37..a0c67752317f 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -37,6 +37,7 @@
 
 /* Bank and ring configuration */
 #define ADF_4XXX_NUM_RINGS_PER_BANK	2
+#define ADF_4XXX_NUM_BANKS_PER_VF	4
 
 /* Error source registers */
 #define ADF_4XXX_ERRSOU0	(0x41A200)
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 2c380fa10a09..cc8b10b23145 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -186,6 +186,7 @@ struct adf_hw_device_data {
 				      bool enable);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
+	int (*ring_pair_reset)(struct adf_accel_dev *accel_dev, u32 bank_nr);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	char *(*uof_get_name)(u32 obj_num);
@@ -206,6 +207,7 @@ struct adf_hw_device_data {
 	u16 tx_rings_mask;
 	u8 tx_rx_gap;
 	u8 num_banks;
+	u16 num_banks_per_vf;
 	u8 num_rings_per_bank;
 	u8 num_accel;
 	u8 num_logical_accel;
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
index e3157df8a653..c7808ff2aba1 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
+#include <linux/iopoll.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_hw_data.h"
@@ -146,3 +147,55 @@ int adf_pfvf_comms_disabled(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_pfvf_comms_disabled);
+
+static int reset_ring_pair(void __iomem *csr, u32 bank_number)
+{
+	u32 status;
+	int ret;
+
+	/* Write rpresetctl register BIT(0) as 1
+	 * Since rpresetctl registers have no RW fields, no need to preserve
+	 * values for other bits. Just write directly.
+	 */
+	ADF_CSR_WR(csr, ADF_WQM_CSR_RPRESETCTL(bank_number),
+		   ADF_WQM_CSR_RPRESETCTL_RESET);
+
+	/* Read rpresetsts register and wait for rp reset to complete */
+	ret = read_poll_timeout(ADF_CSR_RD, status,
+				status & ADF_WQM_CSR_RPRESETSTS_STATUS,
+				ADF_RPRESET_POLL_DELAY_US,
+				ADF_RPRESET_POLL_TIMEOUT_US, true,
+				csr, ADF_WQM_CSR_RPRESETSTS(bank_number));
+	if (!ret) {
+		/* When rp reset is done, clear rpresetsts */
+		ADF_CSR_WR(csr, ADF_WQM_CSR_RPRESETSTS(bank_number),
+			   ADF_WQM_CSR_RPRESETSTS_STATUS);
+	}
+
+	return ret;
+}
+
+int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 etr_bar_id = hw_data->get_etr_bar_id(hw_data);
+	void __iomem *csr;
+	int ret;
+
+	if (bank_number >= hw_data->num_banks)
+		return -EINVAL;
+
+	dev_dbg(&GET_DEV(accel_dev),
+		"ring pair reset for bank:%d\n", bank_number);
+
+	csr = (&GET_BARS(accel_dev)[etr_bar_id])->virt_addr;
+	ret = reset_ring_pair(csr, bank_number);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev),
+			"ring pair reset failed (timeout)\n");
+	else
+		dev_dbg(&GET_DEV(accel_dev), "ring pair reset successful\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_ring_pair_reset);
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
index b8fca1ff7aab..449d6a5976a9 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
@@ -106,6 +106,15 @@ do { \
 #define ADF_SSMWDTPKEL_OFFSET		0x58
 #define ADF_SSMWDTPKEH_OFFSET		0x60
 
+/* Ring reset */
+#define ADF_RPRESET_POLL_TIMEOUT_US	(5 * USEC_PER_SEC)
+#define ADF_RPRESET_POLL_DELAY_US	20
+#define ADF_WQM_CSR_RPRESETCTL_RESET	BIT(0)
+#define ADF_WQM_CSR_RPRESETCTL(bank)	(0x6000 + ((bank) << 3))
+#define ADF_WQM_CSR_RPRESETSTS_STATUS	BIT(0)
+#define ADF_WQM_CSR_RPRESETSTS(bank)	(ADF_WQM_CSR_RPRESETCTL(bank) + 4)
+
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
+int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number);
 #endif
-- 
2.31.1

