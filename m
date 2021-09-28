Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB8AC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5451061157
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240403AbhI1Lq4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:37946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240408AbhI1Lqu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339089"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339089"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224923"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:45:08 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 12/12] crypto: qat - share adf_enable_pf2vf_comms() from adf_pf2vf_msg.c
Date:   Tue, 28 Sep 2021 12:44:40 +0100
Message-Id: <20210928114440.355368-13-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

The PFVF protocol "enable" functions are direction specific but not
device specific. Move the protocol enable function for the PF into the
PF specific protocol file for better file organization and duplicated
code reduction.

NOTE: the patch keeps gen4 disabled as it doesn't have full PFVF
support yet.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c |  4 ++--
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  7 -------
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c |  7 -------
 drivers/crypto/qat/qat_common/adf_common_drv.h |  6 ++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c  | 18 ++++++++++++++++++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c    |  7 -------
 6 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 88c0ded411f1..fa768f10635f 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -191,7 +191,7 @@ static int adf_init_device(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
-static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
+static int pfvf_comms_disabled(struct adf_accel_dev *accel_dev)
 {
 	return 0;
 }
@@ -253,7 +253,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
+	hw_data->enable_pfvf_comms = pfvf_comms_disabled;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 6a39d2e7f4c0..1fa690219d92 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -91,13 +91,6 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_C3XXX_SMIA1_MASK);
 }
 
-static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
-{
-	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
-
-	return 0;
-}
-
 static void configure_iov_threads(struct adf_accel_dev *accel_dev, bool enable)
 {
 	adf_gen2_cfg_iov_thds(accel_dev, enable,
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index e259ca38a653..0613db077689 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -93,13 +93,6 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_C62X_SMIA1_MASK);
 }
 
-static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
-{
-	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
-
-	return 0;
-}
-
 static void configure_iov_threads(struct adf_accel_dev *accel_dev, bool enable)
 {
 	adf_gen2_cfg_iov_thds(accel_dev, enable,
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index dd82272019ec..2cc6622833c4 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -196,6 +196,7 @@ void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
 				      u32 vf_mask);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask);
+int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info);
@@ -210,6 +211,11 @@ void adf_flush_vf_wq(struct adf_accel_dev *accel_dev);
 #else
 #define adf_sriov_configure NULL
 
+static inline int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
+{
+	return 0;
+}
+
 static inline void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 {
 }
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 711f6e3f6673..59860bdaedb6 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -396,3 +396,21 @@ int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
 	return adf_vf2pf_request_version(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_enable_vf2pf_comms);
+
+/**
+ * adf_enable_pf2vf_comms() - Function enables communication from pf to vf
+ *
+ * @accel_dev: Pointer to acceleration device virtual function.
+ *
+ * This function carries out the necessary steps to setup and start the PFVF
+ * communication channel, if any.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
+{
+	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_enable_pf2vf_comms);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index e5e64f880fbf..8e2e1554dcf6 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -158,13 +158,6 @@ static void disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 	}
 }
 
-static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
-{
-	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
-
-	return 0;
-}
-
 static void configure_iov_threads(struct adf_accel_dev *accel_dev, bool enable)
 {
 	adf_gen2_cfg_iov_thds(accel_dev, enable,
-- 
2.31.1

