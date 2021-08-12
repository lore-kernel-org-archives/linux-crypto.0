Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955C6C4320A
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798766103E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhHLUWe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:4160 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237238AbhHLUWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474056"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474056"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:22:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608687"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:22:02 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 14/20] crypto: qat - move IO virtualization functions
Date:   Thu, 12 Aug 2021 21:21:23 +0100
Message-Id: <20210812202129.18831-15-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move IOV functions at the end of hw_data so that PFVF functions related
functions are group together.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c         |  6 +++---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c       |  9 +++++----
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c         | 10 +++++-----
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |  7 ++++---
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index a72142413caa..82e67d679513 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -210,21 +210,21 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->fw_mmp_name = ADF_4XXX_MMP;
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
-	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->send_admin_init = adf_send_admin_init;
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->admin_ae_mask = ADF_4XXX_ADMIN_AE_MASK;
 	hw_data->uof_get_num_objs = uof_get_num_objs;
 	hw_data->uof_get_name = uof_get_name;
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
+	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 }
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 912e84ecb9a3..45f3905f7f35 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -195,7 +195,6 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
 	hw_data->get_arb_info = adf_gen2_get_arb_info;
@@ -205,16 +204,18 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
 	hw_data->configure_iov_threads = configure_iov_threads;
-	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->send_admin_init = adf_send_admin_init;
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
+	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
+
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 069b5d6857e8..dbce08b753c7 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -112,7 +112,6 @@ static u32 get_pf2vf_offset(u32 i)
 {
 	return ADF_C62X_PF2VF_OFFSET(i);
 }
-
 static u32 get_vintmsk_offset(u32 i)
 {
 	return ADF_C62X_VINTMSK_OFFSET(i);
@@ -197,7 +196,6 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
 	hw_data->get_arb_info = adf_gen2_get_arb_info;
@@ -207,16 +205,18 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
 	hw_data->configure_iov_threads = configure_iov_threads;
-	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->send_admin_init = adf_send_admin_init;
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
+	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
+
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 07e7ba5c057d..6f5dab2a63a7 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -215,7 +215,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
 	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
 	hw_data->get_arb_info = adf_gen2_get_arb_info;
@@ -226,15 +225,17 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
 	hw_data->configure_iov_threads = configure_iov_threads;
-	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->send_admin_init = adf_send_admin_init;
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
-	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_sbr;
+	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
+
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
-- 
2.31.1

