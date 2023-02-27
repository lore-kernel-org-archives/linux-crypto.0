Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797CFC64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 15:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjB0Ppo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjB0Ppk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 10:45:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6C8234C7
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 07:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677512701; x=1709048701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nGmsP1/ummp2MCurfUCe1yVa5fxfM04cMjeNnUmgRzI=;
  b=Hh0i5+c2J4WMT/j5wM1E6aPYapZvCM0Zx/Lk4fUhb17HJ7+bkiBgaRrR
   XQcMpwurubwhADANcVG3yU+qDBcBQ796eKFJzcgGBeodnAGr+Fwm6AEkb
   nSryda0jK69CO4hw2bs7Jh/3cOYBj9r7IXsOPTSW5f75fALP0JYxRKsnw
   XX3farB6xaLnAaTe1qZ5W2R9l/dA9c0737L8SfEGXkD/b71Nm19UatJ5b
   By7ZCumfZ4GzmG6AKFZbE8m1qwfG7zVmyxi4ZBfA4+ErBnmFAeDzzP07c
   MGA9pbncijEXNCJYQI3Mz1TJixtZ7iqQWtQSqnR3JDfp1+olEbgA4lkcf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336166239"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="336166239"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:44:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919392279"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919392279"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 07:44:21 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 5/5] crypto: qat - make state machine functions static
Date:   Mon, 27 Feb 2023 15:55:45 -0500
Message-Id: <20230227205545.5796-6-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20230227205545.5796-1-shashank.gupta@intel.com>
References: <20230227205545.5796-1-shashank.gupta@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The state machine functions adf_dev_init(), adf_dev_start(),
adf_dev_stop() adf_dev_shutdown() and adf_dev_shutdown_cache_cfg()
are only used internally within adf_init.c.
Do not export these functions and make them static as state transitions
are now performed using the safe function adf_dev_up() and
adf_dev_down().

This commit does not implement any functional change.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |  6 ------
 drivers/crypto/qat/qat_common/adf_init.c       | 14 +++++---------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 3666109b6320..b2f14aaf6950 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -52,12 +52,6 @@ struct service_hndl {
 int adf_service_register(struct service_hndl *service);
 int adf_service_unregister(struct service_hndl *service);
 
-int adf_dev_init(struct adf_accel_dev *accel_dev);
-int adf_dev_start(struct adf_accel_dev *accel_dev);
-void adf_dev_stop(struct adf_accel_dev *accel_dev);
-void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
-int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev);
-
 int adf_dev_up(struct adf_accel_dev *accel_dev, bool init_config);
 int adf_dev_down(struct adf_accel_dev *accel_dev, bool cache_config);
 int adf_dev_restart(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 11ade5d8e4a0..0985f64ab11a 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -56,7 +56,7 @@ int adf_service_unregister(struct service_hndl *service)
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_dev_init(struct adf_accel_dev *accel_dev)
+static int adf_dev_init(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
 	struct list_head *list_itr;
@@ -146,7 +146,6 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_dev_init);
 
 /**
  * adf_dev_start() - Start acceleration service for the given accel device
@@ -158,7 +157,7 @@ EXPORT_SYMBOL_GPL(adf_dev_init);
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_dev_start(struct adf_accel_dev *accel_dev)
+static int adf_dev_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
@@ -219,7 +218,6 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_dev_start);
 
 /**
  * adf_dev_stop() - Stop acceleration service for the given accel device
@@ -231,7 +229,7 @@ EXPORT_SYMBOL_GPL(adf_dev_start);
  *
  * Return: void
  */
-void adf_dev_stop(struct adf_accel_dev *accel_dev)
+static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
 	struct list_head *list_itr;
@@ -276,7 +274,6 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev)
 			clear_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
 	}
 }
-EXPORT_SYMBOL_GPL(adf_dev_stop);
 
 /**
  * adf_dev_shutdown() - shutdown acceleration services and data strucutures
@@ -285,7 +282,7 @@ EXPORT_SYMBOL_GPL(adf_dev_stop);
  * Cleanup the ring data structures and the admin comms and arbitration
  * services.
  */
-void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
+static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
@@ -343,7 +340,6 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 	adf_cleanup_etr_data(accel_dev);
 	adf_dev_restore(accel_dev);
 }
-EXPORT_SYMBOL_GPL(adf_dev_shutdown);
 
 int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 {
@@ -375,7 +371,7 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 
-int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
+static int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
 	int ret;
-- 
2.16.4

