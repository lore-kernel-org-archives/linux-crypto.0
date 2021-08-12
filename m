Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD4BC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB71260EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhHLUWg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237136AbhHLUWd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474062"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474062"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:22:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608720"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:22:06 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 16/20] crypto: qat - fix naming of PF/VF enable functions
Date:   Thu, 12 Aug 2021 21:21:25 +0100
Message-Id: <20210812202129.18831-17-giovanni.cabiddu@intel.com>
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

Currently all the functions related to the activation of the PFVF
protocol, both on PF and VF, include the direction specific "vf2pf"
name.

Replace the existing naming schema with:
  - a direction agnostic naming, that applies to both PF and VF, for the
    function pointer ("pfvf")
  - a direction specific naming schema for the implementations ("pf2vf" or
    "vf2pf")

In particular this patch renames:
  - adf_pf_enable_vf2pf_comms() in adf_enable_pf2vf_comms()
  - enable_vf2pf_comms() in enable_pfvf_comms()

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c             | 4 ++--
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c           | 4 ++--
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       | 2 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c             | 4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c         | 2 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h          | 2 +-
 drivers/crypto/qat/qat_common/adf_init.c                   | 2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c     | 4 ++--
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c | 2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 82e67d679513..33d8e50dcbda 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -161,7 +161,7 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 	ADF_CSR_WR(addr, ADF_4XXX_SMIAPF_MASK_OFFSET, 0);
 }
 
-static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
 {
 	return 0;
 }
@@ -222,7 +222,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 45f3905f7f35..569d4a9fd8cf 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -159,7 +159,7 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_C3XXX_SMIA1_MASK);
 }
 
-static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
 {
 	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
 
@@ -212,7 +212,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index da0790f26574..3f840560d702 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -95,7 +95,7 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->enable_vf2pf_comms = adf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index dbce08b753c7..6660001d4297 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -160,7 +160,7 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_C62X_SMIA1_MASK);
 }
 
-static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
 {
 	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
 
@@ -213,7 +213,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index e8ed5970b2f2..67fd41662f20 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -95,7 +95,7 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->enable_vf2pf_comms = adf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 8250cf856e07..c00b16be8b0d 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -172,7 +172,7 @@ struct adf_hw_device_data {
 				      bool enable);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
-	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
+	int (*enable_pfvf_comms)(struct adf_accel_dev *accel_dev);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	char *(*uof_get_name)(u32 obj_num);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 52ce1fde9e93..60bc7b991d35 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -112,7 +112,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	hw_data->enable_ints(accel_dev);
 	hw_data->enable_error_correction(accel_dev);
 
-	ret = hw_data->enable_vf2pf_comms(accel_dev);
+	ret = hw_data->enable_pfvf_comms(accel_dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 6f5dab2a63a7..94fa65bac7e7 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -180,7 +180,7 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_DH895XCC_SMIA1_MASK);
 }
 
-static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
 {
 	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
 
@@ -232,7 +232,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 643a91f29e40..5f4e264016c9 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -95,7 +95,7 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->enable_vf2pf_comms = adf_enable_vf2pf_comms;
+	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
-- 
2.31.1

