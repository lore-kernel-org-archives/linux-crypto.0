Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6D4C64ED8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 15:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjB0Ppo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjB0Pph (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 10:45:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ADD1165C
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 07:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677512698; x=1709048698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=mtfoIDnH0Q8yi+sYUEm4Z/EhGI4QDDiRP+fp8GfNyhE=;
  b=LuHYc2OK5SklZ0fK9ytA4WoLrXcL7savs+t43aCVJ6VpfoGDpGL7P9Zb
   8HxXU3sPJQPaNLmvLmOgt8+6ZyQzTUW/G4ls9PzFuDdJrHVsyYgXmbwZq
   sjLLD0z6MktBTh+IBERc8z8NxTHzquIELJsL/uvJGQ3a1YnAJC2kMXp2A
   3ChxBQ9EUO9ybOwSmXHv3I+P0eHGVpY/kFGtkBUY0KbDs8VNPWnhFTGVp
   GN1BB1xYY9/QyI0mt1Fhh/eZ+BN6fw4dxmC2KzMv+USo3cRVlQ3Spm1N5
   idzLy+qymBUogOhKUfHxFVOYVl1ufbIv/7Q7cMuFgpevYQHofFQUgbMp4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336166230"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="336166230"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:44:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919392272"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919392272"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 07:44:19 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 4/5] crypto: qat - refactor device restart logic
Date:   Mon, 27 Feb 2023 15:55:44 -0500
Message-Id: <20230227205545.5796-5-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20230227205545.5796-1-shashank.gupta@intel.com>
References: <20230227205545.5796-1-shashank.gupta@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor the restart logic by moving it into the function
adf_dev_restart() which uses the safe function adf_dev_up() and
adf_dev_down().

This commit does not implement any functional change.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c        |  4 +---
 drivers/crypto/qat/qat_common/adf_common_drv.h |  1 +
 drivers/crypto/qat/qat_common/adf_init.c       | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index fe9bb2f3536a..9fa76c527051 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -90,9 +90,7 @@ static void adf_device_reset_worker(struct work_struct *work)
 	struct adf_accel_dev *accel_dev = reset_data->accel_dev;
 
 	adf_dev_restarting_notify(accel_dev);
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
-	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
+	if (adf_dev_restart(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
 		kfree(reset_data);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 4bf1fceb7052..3666109b6320 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -60,6 +60,7 @@ int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev);
 
 int adf_dev_up(struct adf_accel_dev *accel_dev, bool init_config);
 int adf_dev_down(struct adf_accel_dev *accel_dev, bool cache_config);
+int adf_dev_restart(struct adf_accel_dev *accel_dev);
 
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 988cffd0b833..11ade5d8e4a0 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -464,3 +464,21 @@ int adf_dev_up(struct adf_accel_dev *accel_dev, bool config)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_dev_up);
+
+int adf_dev_restart(struct adf_accel_dev *accel_dev)
+{
+	int ret = 0;
+
+	if (!accel_dev)
+		return -EFAULT;
+
+	adf_dev_down(accel_dev, false);
+
+	ret = adf_dev_up(accel_dev, false);
+	/* if device is already up return success*/
+	if (ret == -EALREADY)
+		return 0;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_dev_restart);
-- 
2.16.4

