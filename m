Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C51AC4320A
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355CF60EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhHLUW1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237087AbhHLUW0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474045"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474045"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608666"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:58 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Kanchana Velusamy <kanchanax.velusamy@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 12/20] crypto: qat - protect interrupt mask CSRs with a spinlock
Date:   Thu, 12 Aug 2021 21:21:21 +0100
Message-Id: <20210812202129.18831-13-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kanchana Velusamy <kanchanax.velusamy@intel.com>

In the PF interrupt handler, the interrupt is disabled for a set of VFs
by writing to the interrupt source mask register, ERRMSK.
The interrupt is re-enabled in the bottom half handler by writing to the
same CSR. This is done through the functions enable_vf2pf_interrupts()
and disable_vf2pf_interrupts() which perform a read-modify-write
operation on the ERRMSK registers to mask and unmask the source of
interrupt.

There can be a race condition where the top half handler for one VF
interrupt runs just as the bottom half for another VF is about to
re-enable the interrupt. Depending on whether the top or bottom half
updates the CSR first, this would result either in a spurious interrupt
or in the interrupt not being re-enabled.

This patch protects the access of ERRMSK with a spinlock.

The functions adf_enable_vf2pf_interrupts() and
adf_disable_vf2pf_interrupts() have been changed to acquire a spin lock
before accessing and modifying the ERRMSK registers. These functions use
spin_lock_irqsave() to disable IRQs and avoid potential deadlocks.
In addition, the function adf_disable_vf2pf_interrupts_irq() has been
added. This uses spin_lock() and it is meant to be used in the top half
only.

Signed-off-by: Kanchana Velusamy <kanchanax.velusamy@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  2 ++
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  2 ++
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 ++
 .../crypto/qat/qat_common/adf_common_drv.h    |  2 ++
 drivers/crypto/qat/qat_common/adf_isr.c       |  2 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 33 +++++++++++++++++--
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  2 ++
 7 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 1c7f6a6f6f2d..912e84ecb9a3 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -161,6 +161,8 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 
 static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
 {
+	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
+
 	return 0;
 }
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index a202f912820c..069b5d6857e8 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -163,6 +163,8 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 
 static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
 {
+	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
+
 	return 0;
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 180c7dba3ff2..8250cf856e07 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -246,6 +246,8 @@ struct adf_accel_dev {
 	struct adf_accel_pci accel_pci_dev;
 	union {
 		struct {
+			/* protects VF2PF interrupts access */
+			spinlock_t vf2pf_ints_lock;
 			/* vf_info is non-zero when SR-IOV is init'ed */
 			struct adf_accel_vf_info *vf_info;
 		} pf;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index bd76b8a86b86..3f6277347278 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -193,6 +193,8 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
 void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				  u32 vf_mask);
+void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
+				      u32 vf_mask);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 2302e43dfaf4..c678d5c531aa 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -103,7 +103,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 			int i;
 
 			/* Disable VF2PF interrupts for VFs with pending ints */
-			adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+			adf_disable_vf2pf_interrupts_irq(accel_dev, vf_mask);
 
 			/*
 			 * Handle VF2PF interrupt unless the VF is malicious and
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 0a927ed91b19..1b0df4a5b8b7 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -11,8 +11,8 @@
 #define ADF_DH895XCC_ERRMSK5	(ADF_DH895XCC_EP_OFFSET + 0xDC)
 #define ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask) (vf_mask >> 16)
 
-void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-				 u32 vf_mask)
+static void __adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
+					  u32 vf_mask)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *pmisc =
@@ -35,7 +35,17 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 	}
 }
 
-void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	__adf_enable_vf2pf_interrupts(accel_dev, vf_mask);
+	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
+}
+
+static void __adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
+					   u32 vf_mask)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *pmisc =
@@ -58,6 +68,22 @@ void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 	}
 }
 
+void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	__adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
+}
+
+void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev, u32 vf_mask)
+{
+	spin_lock(&accel_dev->pf.vf2pf_ints_lock);
+	__adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+	spin_unlock(&accel_dev->pf.vf2pf_ints_lock);
+}
+
 static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 {
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
@@ -264,6 +290,7 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 
 	/* re-enable interrupt on PF from this VF */
 	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_nr));
+
 	return;
 err:
 	dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x);\n",
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index dced2426edc1..07e7ba5c057d 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -182,6 +182,8 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 
 static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
 {
+	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
+
 	return 0;
 }
 
-- 
2.31.1

