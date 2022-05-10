Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD17C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 10 May 2022 16:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243993AbiEJQ6i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 May 2022 12:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbiEJQ6f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 May 2022 12:58:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A848E27E3E6
        for <linux-crypto@vger.kernel.org>; Tue, 10 May 2022 09:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652201673; x=1683737673;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZzffcCZsP6BscOeg9bDiKWhevHfZyKaZfvz2Y8niwPc=;
  b=maiClQr6IBYhxZukQdeInPLEcilho7PpspoQ3tiJU+gxYs8wDE/tj9Hn
   HJIs2co+Xsf0QZ2aFx232srePwuNPVTiTaCNng+CrHYwZK2yu6MZ53uAu
   KTH1UqzIQka+IIAFFxpHGRdouncD5C89/yl7/2pEyZo0Z6d/rSFlOSnsH
   3JeXHzzUO9C8qt1ZQ++rAsKwV0lN0FHsir4g+L9rZNYzacCw2RY6xCiFs
   Lth/8vVvALqdbIO/lvgm/Zf3DoO9T8NsfDR37WbI5Kl1xe9zIH9f/Wvta
   CJGBoIsIIcacdyL3t3P+I0OIE4c4eZoyzy78eFY4swH0m7rAGurS+J4EI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="294672532"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="294672532"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 09:54:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="711114595"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga001.fm.intel.com with ESMTP; 10 May 2022 09:54:23 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Srinivas Kerekare <srinivas.kerekare@intel.com>
Subject: [PATCH] crypto: qat - add support for 401xx devices
Date:   Tue, 10 May 2022 17:54:19 +0100
Message-Id: <20220510165419.182774-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QAT_401xx is a derivative of 4xxx. Add support for that device in the
qat_4xxx driver by including the DIDs (both PF and VF), extending the
probe and the firmware loader.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Srinivas Kerekare <srinivas.kerekare@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c             | 1 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 2 ++
 drivers/crypto/qat/qat_common/qat_hal.c           | 1 +
 drivers/crypto/qat/qat_common/qat_uclo.c          | 1 +
 4 files changed, 5 insertions(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index a6c78b9c730b..181fa1c8b3c7 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -14,6 +14,7 @@
 
 static const struct pci_device_id adf_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ADF_4XXX_PCI_DEVICE_ID), },
+	{ PCI_VDEVICE(INTEL, ADF_401XX_PCI_DEVICE_ID), },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index e927799a8e6c..ede6458c9dbf 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -19,6 +19,8 @@
 #define ADF_4XXX_DEVICE_NAME "4xxx"
 #define ADF_4XXX_PCI_DEVICE_ID 0x4940
 #define ADF_4XXXIOV_PCI_DEVICE_ID 0x4941
+#define ADF_401XX_PCI_DEVICE_ID 0x4942
+#define ADF_401XXIOV_PCI_DEVICE_ID 0x4943
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_DEVICE_FUSECTL_MASK 0x80000000
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 4bfd8f3566f7..7bba35280dac 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -695,6 +695,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	handle->pci_dev = pci_info->pci_dev;
 	switch (handle->pci_dev->device) {
 	case ADF_4XXX_PCI_DEVICE_ID:
+	case ADF_401XX_PCI_DEVICE_ID:
 		handle->chip_info->mmp_sram_size = 0;
 		handle->chip_info->nn = false;
 		handle->chip_info->lm2lm3 = true;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 4b6f37d6e85b..0fe5a474aa45 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -731,6 +731,7 @@ qat_uclo_get_dev_type(struct icp_qat_fw_loader_handle *handle)
 	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		return ICP_QAT_AC_C3XXX_DEV_TYPE;
 	case ADF_4XXX_PCI_DEVICE_ID:
+	case ADF_401XX_PCI_DEVICE_ID:
 		return ICP_QAT_AC_4XXX_A_DEV_TYPE;
 	default:
 		pr_err("QAT: unsupported device 0x%x\n",
-- 
2.35.1

