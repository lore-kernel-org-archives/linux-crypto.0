Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D08C43214
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C2B60C3F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhHLUWZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:4146 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237087AbhHLUWY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474026"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474026"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:21:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608600"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 07/20] crypto: qat - prevent spurious MSI interrupt in PF
Date:   Thu, 12 Aug 2021 21:21:16 +0100
Message-Id: <20210812202129.18831-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

There is a chance that the PFVF handler, adf_vf2pf_req_hndl(), runs
twice for the same request when multiple interrupts come simultaneously
from different VFs.
Since the source VF is identified by a positional bit set in the ERRSOU
registers and that is not cleared until the bottom half completes, new
top halves from other VFs may reschedule a second bottom half for
previous interrupts.

This patch solves the problem in the ISR handler by not considering
sources with already disabled interrupts (and processing pending), as
set in the ERRMSK registers.

Also, move some definitions where actually needed.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 --
 drivers/crypto/qat/qat_common/adf_isr.c       | 25 +++++++++++++++----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index ac435b44f1d2..2ee11b4763cd 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -18,8 +18,6 @@
 #define ADF_4XXX_DEVICE_NAME "4xxx"
 #define ADF_4XXX_PCI_DEVICE_ID 0x4940
 #define ADF_4XXXIOV_PCI_DEVICE_ID 0x4941
-#define ADF_ERRSOU3 (0x3A000 + 0x0C)
-#define ADF_ERRSOU5 (0x3A000 + 0xD8)
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_DEVICE_FUSECTL_MASK 0x80000000
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index daab02011717..a25b7845c9d3 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -16,6 +16,12 @@
 #include "adf_transport_internal.h"
 
 #define ADF_MAX_NUM_VFS	32
+#define ADF_ERRSOU3	(0x3A000 + 0x0C)
+#define ADF_ERRSOU5	(0x3A000 + 0xD8)
+#define ADF_ERRMSK3	(0x3A000 + 0x1C)
+#define ADF_ERRMSK5	(0x3A000 + 0xDC)
+#define ADF_ERR_REG_VF2PF_L(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
+#define ADF_ERR_REG_VF2PF_U(vf_src)	(((vf_src) & 0x0000FFFF) << 16)
 
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
@@ -73,14 +79,23 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 		struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 		struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
-		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+		void __iomem *pmisc_addr = pmisc->virt_addr;
+		u32 errsou3, errsou5, errmsk3, errmsk5;
 		unsigned long vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
-		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5) &
-			    0x0000FFFF) << 16) |
-			  ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU3) &
-			    0x01FFFE00) >> 9);
+		errsou3 = ADF_CSR_RD(pmisc_addr, ADF_ERRSOU3);
+		errsou5 = ADF_CSR_RD(pmisc_addr, ADF_ERRSOU5);
+		vf_mask = ADF_ERR_REG_VF2PF_L(errsou3);
+		vf_mask |= ADF_ERR_REG_VF2PF_U(errsou5);
+
+		/* To avoid adding duplicate entries to work queue, clear
+		 * vf_int_mask_sets bits that are already masked in ERRMSK register.
+		 */
+		errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_ERRMSK3);
+		errmsk5 = ADF_CSR_RD(pmisc_addr, ADF_ERRMSK5);
+		vf_mask &= ~ADF_ERR_REG_VF2PF_L(errmsk3);
+		vf_mask &= ~ADF_ERR_REG_VF2PF_U(errmsk5);
 
 		if (vf_mask) {
 			struct adf_accel_vf_info *vf_info;
-- 
2.31.1

