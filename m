Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D53EDE99F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbjINJ50 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbjINJ5X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:57:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DBA1BFB
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694685439; x=1726221439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XDbX2JYxC2xfrYLOcXNrI/7AbLEXZjsCiyeDWQA0Vdw=;
  b=Ks8wg+azTVDfV4uydveS0VncH0vHDWRpWl0G5U18kgyuk/V2ot5m+z8q
   t5YmcLkmK4krvy41I0rqehPoDrqaUTQHexGZ79XmZJa7hRTYn/eenxQ7x
   pcw1EHDViiLgiJ2NB35DeTnJqFCKOMbdpBQ8mgPMnb2W7IovGQmcYD72u
   pPyGhNHwQd16QbcdACn1U0uXTNdgqL2EgpmDSMitbT2b3omiVtsoDehDT
   uKwbgy8otn/iByiUx3jMaI7SppwRE+ZQJxnlKdJ5PVi9JatRHv7jyZdNe
   4/Ef/h5j/gnvEUlHNsOZ6FfUcjb3ezdHODc1L77aD1jGO0fCqRRSoV598
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465279181"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465279181"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:57:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814619766"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="814619766"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2023 02:57:17 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 5/5] crypto: qat - fix unregistration of compression algorithms
Date:   Thu, 14 Sep 2023 10:55:49 +0100
Message-ID: <20230914095658.27166-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
References: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_dev_init(), through the subsystem qat_compression,
populates the list of list of compression instances
accel_dev->compression_list. If the list of instances is not empty,
the function adf_dev_start() will then call qat_compression_registers()
register the compression algorithms into the crypto framework.

If any of the functions in adf_dev_start() fail, the caller of such
function, in the error path calls adf_dev_down() which in turn call
adf_dev_stop() and adf_dev_shutdown(), see for example the function
state_store in adf_sriov.c.
However, if the registration of compression algorithms is not done,
adf_dev_stop() will try to unregister the algorithms regardless.
This might cause the counter active_devs in qat_compression.c to get
to a negative value.

Add a new state, ADF_STATUS_COMPRESSION_ALGS_REGISTERED, which tracks
if the compression algorithms are registered into the crypto framework.
Then use this to unregister the algorithms if such flag is set. This
ensures that the compression algorithms are only unregistered if
previously registered.

Fixes: 1198ae56c9a5 ("crypto: qat - expose deflate through acomp api for QAT GEN2")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c       | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 95efe0f26811..18a382508542 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -26,6 +26,7 @@
 #define ADF_STATUS_PF_RUNNING 7
 #define ADF_STATUS_IRQ_ALLOCATED 8
 #define ADF_STATUS_CRYPTO_ALGS_REGISTERED 9
+#define ADF_STATUS_COMP_ALGS_REGISTERED 10
 
 enum adf_dev_reset_mode {
 	ADF_DEV_RESET_ASYNC = 0,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 37cf5ce99092..bccd6bf8cf63 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -236,6 +236,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 		return -EFAULT;
 	}
+	set_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
 	adf_dbgfs_add(accel_dev);
 
@@ -275,8 +276,10 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	}
 	clear_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->compression_list))
+	if (!list_empty(&accel_dev->compression_list) &&
+	    test_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status))
 		qat_comp_algs_unregister();
+	clear_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
 	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, service->start_status))
-- 
2.41.0

