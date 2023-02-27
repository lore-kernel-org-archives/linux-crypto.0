Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A870C64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 15:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjB0Pof (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjB0PoX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 10:44:23 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72428EC50
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 07:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677512661; x=1709048661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=sbCLzsTis1EeR0WFl+GIs70LmlGz1HPq9aQ1E7QFmb4=;
  b=EsrwDVAo/nhW6b4NiwBLS4mIwM1WIcChL8rca3ESkxiP3kP48+5JC6fr
   vr5hpJA1xBiWgniSC4pMKsNFgvH+QwkJceaCV+AEwjP51d+/xIBcjnOrE
   cIh1g4XSSjZeRpVfD1X4TVuZokB1j12MG+gk1kU25Lxz7RAoczbpUvdXt
   EmvBCHCIQo1Gl112LgldgGggsFwD0pfvd8J1ldMh6+rOIbJ6Dg+1lZ2X8
   BBknWsSh76hIFk7Fg6ei6amtnpBmkZCX27mmSfb1lEkIrt0ovK2RHKM8+
   Ke4oksuf2CzEZu6kH4bXQhCxMZFt2m5Jtls9/qtBMRRiAOeOwo1idTyAK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336166199"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="336166199"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:44:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919392259"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919392259"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 07:44:16 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 2/5] crypto: qat - fix concurrency issue when device state changes
Date:   Mon, 27 Feb 2023 15:55:42 -0500
Message-Id: <20230227205545.5796-3-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20230227205545.5796-1-shashank.gupta@intel.com>
References: <20230227205545.5796-1-shashank.gupta@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sysfs `state` attribute is not protected against race conditions.
If multiple processes perform a device state transition on the same
device in parallel, unexpected behaviors might occur.

For transitioning the device state, adf_sysfs.c calls the functions
adf_dev_init(), adf_dev_start(), adf_dev_stop() and adf_dev_shutdown()
which are unprotected and interdependent on each other. To perform a
state transition, these functions needs to be called in a specific
order:
  * device up:   adf_dev_init() -> adf_dev_start()
  * device down: adf_dev_stop() -> adf_dev_shutdown()

This change introduces the functions adf_dev_up() and adf_dev_down()
which wrap the state machine functions and protect them with a
per-device lock. These are then used in adf_sysfs.c instead of the
individual state transition functions.

Fixes: 5ee52118ac14 ("crypto: qat - expose device state through sysfs for 4xxx")
Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_common_drv.h    |  3 ++
 drivers/crypto/qat/qat_common/adf_dev_mgr.c       |  2 +
 drivers/crypto/qat/qat_common/adf_init.c          | 64 +++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_sysfs.c         | 23 ++------
 5 files changed, 73 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 284f5aad3ee0..7be933d6f0ff 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -310,6 +310,7 @@ struct adf_accel_dev {
 			u8 pf_compat_ver;
 		} vf;
 	};
+	struct mutex state_lock; /* protect state of the device */
 	bool is_vf;
 	u32 accel_id;
 };
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 7189265573c0..4bf1fceb7052 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -58,6 +58,9 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev);
 
+int adf_dev_up(struct adf_accel_dev *accel_dev, bool init_config);
+int adf_dev_down(struct adf_accel_dev *accel_dev, bool cache_config);
+
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
 
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 4c752eed10fe..86ee36feefad 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -223,6 +223,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		map->attached = true;
 		list_add_tail(&map->list, &vfs_table);
 	}
+	mutex_init(&accel_dev->state_lock);
 unlock:
 	mutex_unlock(&table_lock);
 	return ret;
@@ -269,6 +270,7 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 		}
 	}
 unlock:
+	mutex_destroy(&accel_dev->state_lock);
 	list_del(&accel_dev->list);
 	mutex_unlock(&table_lock);
 }
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index cef7bb8ec007..988cffd0b833 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -400,3 +400,67 @@ int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
 
 	return 0;
 }
+
+int adf_dev_down(struct adf_accel_dev *accel_dev, bool reconfig)
+{
+	int ret = 0;
+
+	if (!accel_dev)
+		return -EINVAL;
+
+	mutex_lock(&accel_dev->state_lock);
+
+	if (!adf_dev_started(accel_dev)) {
+		dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already down\n",
+			 accel_dev->accel_id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (reconfig) {
+		ret = adf_dev_shutdown_cache_cfg(accel_dev);
+		goto out;
+	}
+
+	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
+
+out:
+	mutex_unlock(&accel_dev->state_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_dev_down);
+
+int adf_dev_up(struct adf_accel_dev *accel_dev, bool config)
+{
+	int ret = 0;
+
+	if (!accel_dev)
+		return -EINVAL;
+
+	mutex_lock(&accel_dev->state_lock);
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already up\n",
+			 accel_dev->accel_id);
+		ret = -EALREADY;
+		goto out;
+	}
+
+	if (config && GET_HW_DATA(accel_dev)->dev_config) {
+		ret = GET_HW_DATA(accel_dev)->dev_config(accel_dev);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	ret = adf_dev_init(accel_dev);
+	if (unlikely(ret))
+		goto out;
+
+	ret = adf_dev_start(accel_dev);
+
+out:
+	mutex_unlock(&accel_dev->state_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_dev_up);
diff --git a/drivers/crypto/qat/qat_common/adf_sysfs.c b/drivers/crypto/qat/qat_common/adf_sysfs.c
index e8b078e719c2..3eb6611ab1b1 100644
--- a/drivers/crypto/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/qat/qat_common/adf_sysfs.c
@@ -50,38 +50,21 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 
 	switch (ret) {
 	case DEV_DOWN:
-		if (!adf_dev_started(accel_dev)) {
-			dev_info(dev, "Device qat_dev%d already down\n",
-				 accel_id);
-			return -EINVAL;
-		}
-
 		dev_info(dev, "Stopping device qat_dev%d\n", accel_id);
 
-		ret = adf_dev_shutdown_cache_cfg(accel_dev);
+		ret = adf_dev_down(accel_dev, true);
 		if (ret < 0)
 			return -EINVAL;
 
 		break;
 	case DEV_UP:
-		if (adf_dev_started(accel_dev)) {
-			dev_info(dev, "Device qat_dev%d already up\n",
-				 accel_id);
-			return -EINVAL;
-		}
-
 		dev_info(dev, "Starting device qat_dev%d\n", accel_id);
 
-		ret = GET_HW_DATA(accel_dev)->dev_config(accel_dev);
-		if (!ret)
-			ret = adf_dev_init(accel_dev);
-		if (!ret)
-			ret = adf_dev_start(accel_dev);
-
+		ret = adf_dev_up(accel_dev, true);
 		if (ret < 0) {
 			dev_err(dev, "Failed to start device qat_dev%d\n",
 				accel_id);
-			adf_dev_shutdown_cache_cfg(accel_dev);
+			adf_dev_down(accel_dev, true);
 			return ret;
 		}
 		break;
-- 
2.16.4

