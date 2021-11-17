Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D06C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3D4061B08
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhKQOeS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:57913 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235003AbhKQOeM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722577"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722577"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829637"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:11 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH v3 01/25] crypto: qat - do not handle PFVF sources for qat_4xxx
Date:   Wed, 17 Nov 2021 14:30:34 +0000
Message-Id: <20211117143058.211550-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
References: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The QAT driver does not have support for PFVF interrupts for GEN4
devices, therefore report the vf2pf sources as 0.
This prevents a NULL pointer dereference in the function
adf_msix_isr_ae() if the device triggers a spurious interrupt.

Fixes: 993161d36ab5 ("crypto: qat - fix handling of VF to PF interrupts")
Reported-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index fa768f10635f..fd29861526d6 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -211,6 +211,12 @@ static u32 uof_get_ae_mask(u32 obj_num)
 	return adf_4xxx_fw_config[obj_num].ae_mask;
 }
 
+static u32 get_vf2pf_sources(void __iomem *pmisc_addr)
+{
+	/* For the moment do not report vf2pf sources */
+	return 0;
+}
+
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &adf_4xxx_class;
@@ -254,6 +260,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
 	hw_data->enable_pfvf_comms = pfvf_comms_disabled;
+	hw_data->get_vf2pf_sources = get_vf2pf_sources;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
-- 
2.33.1

