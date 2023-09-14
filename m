Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCAAEDE99C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbjINJ5Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237638AbjINJ5V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:57:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889241BFA
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694685437; x=1726221437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HtNF+DodAJ+LzztCCgIMJt2A2eJ1Roc9kQ4m6N/xCek=;
  b=D+zb2tJSWPgcnFMdLI8OIjIh3BAyQMbqFTq8pUklQYppi8wtDgfcu0ls
   UH+9lONm8VhNe3oCODxXkFttdJXqkcVbtqjwoNulBqCTTMlEdwuugWI0U
   z5SfNyRfKwhFot/OIHfw19wFoiknaF20eZC3mtdG3hMJ4cBsQFqsHjTLz
   3RIbvGu2j/zq8vBHIpYpjveCiIu0gm97l0FJ4gL/x92+uBqKiB/jcvg2X
   B6PDOs2rXayuJtLUwcA0hOWz7/Kz/wdBiCJzWxHmhALM9L8pXF4t5TXdb
   mPm5Qia8AlKkFMXQt1J8QYRXi2dlELxaoBMkHMWCO0ZJTmqnj7vlxgWot
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465279172"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465279172"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:57:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814619756"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="814619756"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2023 02:57:15 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 4/5] crypto: qat - fix unregistration of crypto algorithms
Date:   Thu, 14 Sep 2023 10:55:48 +0100
Message-ID: <20230914095658.27166-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
References: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_dev_init(), through the subsystem qat_crypto, populates
the list of list of crypto instances accel_dev->crypto_list.
If the list of instances is not empty, the function adf_dev_start() will
then call qat_algs_registers() and qat_asym_algs_register() to register
the crypto algorithms into the crypto framework.

If any of the functions in adf_dev_start() fail, the caller of such
function, in the error path calls adf_dev_down() which in turn call
adf_dev_stop() and adf_dev_shutdown(), see for example the function
state_store in adf_sriov.c.
However, if the registration of crypto algorithms is not done,
adf_dev_stop() will try to unregister the algorithms regardless.
This might cause the counter active_devs in qat_algs.c and
qat_asym_algs.c to get to a negative value.

Add a new state, ADF_STATUS_CRYPTO_ALGS_REGISTERED, which tracks if the
crypto algorithms are registered into the crypto framework. Then use
this to unregister the algorithms if such flag is set. This ensures that
the crypto algorithms are only unregistered if previously registered.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c       | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index d4c602b4fec7..95efe0f26811 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -25,6 +25,7 @@
 #define ADF_STATUS_AE_STARTED 6
 #define ADF_STATUS_PF_RUNNING 7
 #define ADF_STATUS_IRQ_ALLOCATED 8
+#define ADF_STATUS_CRYPTO_ALGS_REGISTERED 9
 
 enum adf_dev_reset_mode {
 	ADF_DEV_RESET_ASYNC = 0,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 542318a5b771..37cf5ce99092 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -227,6 +227,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 		return -EFAULT;
 	}
+	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
 	if (!list_empty(&accel_dev->compression_list) && qat_comp_algs_register()) {
 		dev_err(&GET_DEV(accel_dev),
@@ -267,10 +268,12 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->crypto_list)) {
+	if (!list_empty(&accel_dev->crypto_list) &&
+	    test_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status)) {
 		qat_algs_unregister();
 		qat_asym_algs_unregister();
 	}
+	clear_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
 	if (!list_empty(&accel_dev->compression_list))
 		qat_comp_algs_unregister();
-- 
2.41.0

