Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6918C4707F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8FD6613DD
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhE0TPJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 15:15:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:7504 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhE0TPF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 15:15:05 -0400
IronPort-SDR: dp9iJ5DghotfCgypiTJcfFLPpBbCokal4sVYLnT2fJWsIt4e8t6gTvYnIMU23YAVTMj/9u8O8F
 +X7h1eoDfI9A==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264012450"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264012450"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 12:13:32 -0700
IronPort-SDR: hWOakFUOzuwy7T04a4o2bEcoH6N8NT0nkQLbu3i2YOGYKKA67QOhELpriZefWr5X5vrQ66x6Bx
 RD0zANOenQ4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480717785"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 12:13:30 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 07/10] crypto: qat - prevent spurious MSI interrupt in PF
Date:   Thu, 27 May 2021 20:12:48 +0100
Message-Id: <20210527191251.6317-8-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210527191251.6317-1-marco.chiappero@intel.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is a chance of getting a "spurious interrupt" warning from the
adf_vf2pf_bh_handler() bottom half when multiple interrupts come
simultaneously from different VFs.
Since the source VF is identified by a positional bit set in the ERRSOU
registers and that it is not cleared until the bottom half completes,
new top halves from other VFs may reschedule a second bottom half
for previous interrupts.

This patch solves the problem in the ISR handler by not considering
sources with already disabled interrupts (and processing pending), as
set in the ERRMSK registers.

Also, move some definitions where actually needed.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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
index 22f8ef5bfbc5..403d2fc00a7d 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -17,6 +17,12 @@
 
 #ifdef CONFIG_PCI_IOV
 #define ADF_MAX_NUM_VFS	32
+#define ADF_ERRSOU3 (0x3A000 + 0x0C)
+#define ADF_ERRSOU5 (0x3A000 + 0xD8)
+#define ADF_ERRMSK3 (0x3A000 + 0x1C)
+#define ADF_ERRMSK5 (0x3A000 + 0xDC)
+#define ADF_ERR_REG_VF2PF_L(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
+#define ADF_ERR_REG_VF2PF_U(vf_src)	(((vf_src) & 0x0000FFFF) << 16)
 #endif
 
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
@@ -75,14 +81,23 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
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
2.26.2

