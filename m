Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7432BEDE99E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbjINJ5R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbjINJ5Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:57:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6B483
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694685432; x=1726221432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ziVvr7l4KJrltF95aX1enLC5Yil0BRxSFwkmSuCyIL4=;
  b=Ihkl37EH13eyqBad5DhNXejN6IFLcqK75roAnKWkpLhxkNVXeCxcHCy8
   MzsP5hyFOAY4YgfSjzVR8DsHIDNjvdIfUYgq8s0NHI8vsJ4G/mJflHap9
   e+sBg+JoHfx6+N6VuD6S/vmVllJ6AH2EdK7unQiXJgfLu72pDjeiMej12
   QELoQRZKVd0jRuf/8WqmAZJtezRlRdfUI9eJ+hVTY+1heSQ0WVRikGKK7
   AGc2Jnx0k1H518Al3UbGvMW0/srh8b8nw0dtn+xccDnVgEY3Upet9K3KZ
   oWM5+YCpASMQURUV6gQAlCN/yNQA0hiVtiW16ekc+WolWkYio+Ib+Yi44
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465279150"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465279150"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:57:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814619715"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="814619715"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2023 02:57:10 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 1/5] crypto: qat - fix state machines cleanup paths
Date:   Thu, 14 Sep 2023 10:55:45 +0100
Message-ID: <20230914095658.27166-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
References: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 1bdc85550a2b ("crypto: qat - fix concurrency issue when device
state changes") introduced the function adf_dev_down() which wraps the
functions adf_dev_stop() and adf_dev_shutdown().
In a subsequent change, the sequence adf_dev_stop() followed by
adf_dev_shutdown() was then replaced across the driver with just a call
to the function adf_dev_down().

The functions adf_dev_stop() and adf_dev_shutdown() are called in error
paths to stop the accelerator and free up resources and can be called
even if the counterparts adf_dev_init() and adf_dev_start() did not
complete successfully.
However, the implementation of adf_dev_down() prevents the stop/shutdown
sequence if the device is found already down.
For example, if adf_dev_init() fails, the device status is not set as
started and therefore a call to adf_dev_down() won't be calling
adf_dev_shutdown() to undo what adf_dev_init() did.

Do not check if a device is started in adf_dev_down() but do the
equivalent check in adf_sysfs.c when handling a DEV_DOWN command from
the user.

Fixes: 2b60f79c7b81 ("crypto: qat - replace state machine calls")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c  | 7 -------
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 79a81e25de97..542318a5b771 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -428,13 +428,6 @@ int adf_dev_down(struct adf_accel_dev *accel_dev, bool reconfig)
 
 	mutex_lock(&accel_dev->state_lock);
 
-	if (!adf_dev_started(accel_dev)) {
-		dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already down\n",
-			 accel_dev->accel_id);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (reconfig) {
 		ret = adf_dev_shutdown_cache_cfg(accel_dev);
 		goto out;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index a74d2f930367..a8f33558d7cb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -52,6 +52,13 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	case DEV_DOWN:
 		dev_info(dev, "Stopping device qat_dev%d\n", accel_id);
 
+		if (!adf_dev_started(accel_dev)) {
+			dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already down\n",
+				 accel_id);
+
+			break;
+		}
+
 		ret = adf_dev_down(accel_dev, true);
 		if (ret < 0)
 			return -EINVAL;
-- 
2.41.0

