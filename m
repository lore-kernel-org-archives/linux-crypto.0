Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A6DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 08:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiF0IhO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 04:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiF0IhL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 04:37:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E062E8
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 01:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656319027; x=1687855027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gl2R1tP1DMa9l8hq+I6fQ3bV6+MyZZSz5vfSSRtCsU8=;
  b=LrNOAslA0r2ZOlHP7Dua9YXq4c8YElNlghhapHPyaamzSji1fFXwUwt9
   wPlleP5sFv02O0o//0H3ruz2wU+l01E9cMldcTk7x+5OI+GxxSiYcFYrK
   ENUbJ/nahKp7JfiIKCR+xuoyhUgL8wUnLX6R+FNf3cj9t6DG6mrH6lh3m
   fD4Mk2faR5YIHOahmDRuW29taCE3yqr7ljbHI75zpiVrYTMtL6GubGTxk
   +Ii9ls2xO9qaS17Qan1vFGs+gbmwt6KQwbx9NXAhkMOZNqU0FFN8kwikq
   fpZrbwjAjllfn6R7WBk19/My9ombcnAfjvKxFF5qDIvQGunw8NBAop4tu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="282488945"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="282488945"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 01:37:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="657595549"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2022 01:37:04 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 3/4] crypto: qat - relocate and rename adf_sriov_prepare_restart()
Date:   Mon, 27 Jun 2022 09:36:51 +0100
Message-Id: <20220627083652.880303-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
References: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_sriov_prepare_restart() is used in adf_sriov.c to stop
and shutdown a device preserving its configuration.

Since this function will be re-used by the logic that allows to
reconfigure the device through sysfs, move it to adf_init.c and rename
it as adf_dev_shutdown_cache_cfg();

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Vladis Dronov <vdronov@redhat.com>
---
 .../crypto/qat/qat_common/adf_common_drv.h    |  1 +
 drivers/crypto/qat/qat_common/adf_init.c      | 26 +++++++++++++++++
 drivers/crypto/qat/qat_common/adf_sriov.c     | 28 +------------------
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 0f3031f9055d..b6104f8c3571 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -61,6 +61,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev);
 int adf_dev_start(struct adf_accel_dev *accel_dev);
 void adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
+int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev);
 
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index c2c718f1b489..33a9a46d6949 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -363,3 +363,29 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 	}
 	return 0;
 }
+
+int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
+{
+	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
+	int ret;
+
+	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				      ADF_SERVICES_ENABLED, services);
+
+	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
+
+	if (!ret) {
+		ret = adf_cfg_section_add(accel_dev, ADF_GENERAL_SEC);
+		if (ret)
+			return ret;
+
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+						  ADF_SERVICES_ENABLED,
+						  services, ADF_STR);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index f38b2ffde146..b2db1d70d71f 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -120,32 +120,6 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_disable_sriov);
 
-static int adf_sriov_prepare_restart(struct adf_accel_dev *accel_dev)
-{
-	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-	int ret;
-
-	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
-				      ADF_SERVICES_ENABLED, services);
-
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
-
-	if (!ret) {
-		ret = adf_cfg_section_add(accel_dev, ADF_GENERAL_SEC);
-		if (ret)
-			return ret;
-
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
-						  ADF_SERVICES_ENABLED,
-						  services, ADF_STR);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 /**
  * adf_sriov_configure() - Enable SRIOV for the device
  * @pdev:  Pointer to PCI device.
@@ -185,7 +159,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 			return -EBUSY;
 		}
 
-		ret = adf_sriov_prepare_restart(accel_dev);
+		ret = adf_dev_shutdown_cache_cfg(accel_dev);
 		if (ret)
 			return ret;
 	}
-- 
2.36.1

