Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20AEC433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F04B20BED
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbgJLUj7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387887AbgJLUjz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:55 -0400
IronPort-SDR: EfcMx+J/LuFjpGw6DwWEyGHd5p/CdYR/1dXW++QLCZcoFbcYMV5clMRNtQsqoI6I7kqV4FKgfQ
 yT3/noRhsYCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913193"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913193"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:54 -0700
IronPort-SDR: sTNA7sHKVc6zTaqZ92UYqLiKfVkYHHc+IxkqO7GR37oms4DsrpuKMJCUmMmiptUdYLLqa1mSgL
 9dl2MUmC+bBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328283"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:53 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 29/31] crypto: qat - refactor qat_crypto_dev_config()
Date:   Mon, 12 Oct 2020 21:38:45 +0100
Message-Id: <20201012203847.340030-30-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor function qat_crypto_dev_config() to propagate errors to
the caller.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c | 67 +++++++++++++---------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 735463042987..8d8ac5e48f47 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -115,88 +115,103 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
  */
 int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 {
-	int cpus = num_online_cpus();
-	int banks = GET_MAX_BANKS(accel_dev);
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
-	int i;
+	int banks = GET_MAX_BANKS(accel_dev);
+	int cpus = num_online_cpus();
 	unsigned long val;
 	int instances;
+	int ret;
+	int i;
 
 	if (adf_hw_dev_has_crypto(accel_dev))
 		instances = min(cpus, banks);
 	else
 		instances = 0;
 
-	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
+	ret = adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC);
+	if (ret)
 		goto err;
-	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
+
+	ret = adf_cfg_section_add(accel_dev, "Accelerator0");
+	if (ret)
 		goto err;
+
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
 			 i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
 		val = 128;
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		val = 512;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		val = 0;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		val = 2;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		val = 8;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		val = 10;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 
 		val = ADF_COALESCING_DEF_TIME;
 		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
-		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
-						key, &val, ADF_DEC))
+		ret = adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
+						  key, &val, ADF_DEC);
+		if (ret)
 			goto err;
 	}
 
 	val = i;
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					ADF_NUM_CY, &val, ADF_DEC))
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_CY,
+					  &val, ADF_DEC);
+	if (ret)
 		goto err;
 
 	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 	return 0;
 err:
 	dev_err(&GET_DEV(accel_dev), "Failed to start QAT accel dev\n");
-	return -EINVAL;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(qat_crypto_dev_config);
 
-- 
2.26.2

