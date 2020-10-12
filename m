Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F56C43467
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF53214DB
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgJLUjy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387832AbgJLUju (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:50 -0400
IronPort-SDR: QbQsRMlpqrZqS9DArUQov9jKiBuvYBDqmQz/QCKv3gunM8tgaCIqcH/fi0UTog76tLLXF/9pQa
 gzBeYi42tKMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913178"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913178"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:49 -0700
IronPort-SDR: JyDonXfnAuNJPYX93U7EsdoOP7bSa1XEo8nCg9/rtHRLNGZJfhcixhzWQfLxGnLmR7UTkanPZM
 aJiUp7hgxcdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328261"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:47 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 25/31] crypto: qat - remove unnecessary void* casts
Date:   Mon, 12 Oct 2020 21:38:41 +0100
Message-Id: <20201012203847.340030-26-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove superfluous casts to void* in function qat_crypto_dev_config().

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 089d5d7b738e..ab1716f7044d 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -135,61 +135,61 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
 			 i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
 		val = 128;
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		val = 512;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		val = 0;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		val = 2;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		val = 8;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		val = 10;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 
 		val = ADF_COALESCING_DEF_TIME;
 		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
 		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
-						key, (void *)&val, ADF_DEC))
+						key, &val, ADF_DEC))
 			goto err;
 	}
 
 	val = i;
 	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					ADF_NUM_CY, (void *)&val, ADF_DEC))
+					ADF_NUM_CY, &val, ADF_DEC))
 		goto err;
 
 	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
-- 
2.26.2

