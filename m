Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8BCC43457
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51EF6214DB
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbgJLUkA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:40:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:34137 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbgJLUj5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:57 -0400
IronPort-SDR: yxh5N5H8mQHaplGw+jtuE7utl7HHb1DLZYr486lnPxZFKcuHMGaAu+WmcTsRi7HLx9w9zcOp2k
 uBfYYgs2GQlg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913196"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913196"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:56 -0700
IronPort-SDR: KDYKWK4O8xChBPSqMM/etGeoOoUR19MfxyBYcVgSuhCl2VEIXi5qPkxSrAP8744QRj4mp2hNix
 XiGct5l3AL6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328287"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:55 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 30/31] crypto: qat - allow for instances in different banks
Date:   Mon, 12 Oct 2020 21:38:46 +0100
Message-Id: <20201012203847.340030-31-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow for crypto instances to be configured with symmetric crypto rings
that belong to a bank that is different from the one where asymmetric
crypto rings are located.

This is to allow for devices with banks made of a single ring pair.
In these, crypto instances will be composed of two separate banks.

Changed string literals are not exposed to the user space.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/qat/qat_common/adf_cfg_strings.h   |  3 +-
 drivers/crypto/qat/qat_common/qat_crypto.c    | 34 ++++++++++++++-----
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
index 314790f5b0af..09651e1f937a 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -18,7 +18,8 @@
 #define ADF_RING_DC_TX "RingTx"
 #define ADF_RING_DC_RX "RingRx"
 #define ADF_ETRMGR_BANK "Bank"
-#define ADF_RING_BANK_NUM "BankNumber"
+#define ADF_RING_SYM_BANK_NUM "BankSymNumber"
+#define ADF_RING_ASYM_BANK_NUM "BankAsymNumber"
 #define ADF_CY "Cy"
 #define ADF_DC "Dc"
 #define ADF_ETRMGR_COALESCING_ENABLED "InterruptCoalescingEnabled"
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 8d8ac5e48f47..ece6776fbd53 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -138,7 +138,13 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 
 	for (i = 0; i < instances; i++) {
 		val = i;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_BANK_NUM, i);
 		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
 						  key, &val, ADF_DEC);
 		if (ret)
@@ -217,9 +223,10 @@ EXPORT_SYMBOL_GPL(qat_crypto_dev_config);
 
 static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 {
-	unsigned long bank, num_inst, num_msg_sym, num_msg_asym;
+	unsigned long num_inst, num_msg_sym, num_msg_asym;
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	unsigned long sym_bank, asym_bank;
 	struct qat_crypto_instance *inst;
 	int msg_size;
 	int ret;
@@ -246,14 +253,25 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 		inst->id = i;
 		atomic_set(&inst->refctr, 0);
 		inst->accel_dev = accel_dev;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_BANK_NUM, i);
+		ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
+		if (ret)
+			goto err;
+
+		ret = kstrtoul(val, 10, &sym_bank);
+		if (ret)
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
 		ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
 		if (ret)
 			goto err;
 
-		ret = kstrtoul(val, 10, &bank);
+		ret = kstrtoul(val, 10, &asym_bank);
 		if (ret)
 			goto err;
+
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
 		ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
 		if (ret)
@@ -277,28 +295,28 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 
 		msg_size = ICP_QAT_FW_REQ_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
-		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
+		ret = adf_create_ring(accel_dev, SEC, sym_bank, num_msg_sym,
 				      msg_size, key, NULL, 0, &inst->sym_tx);
 		if (ret)
 			goto err;
 
 		msg_size = msg_size >> 1;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+		ret = adf_create_ring(accel_dev, SEC, asym_bank, num_msg_asym,
 				      msg_size, key, NULL, 0, &inst->pke_tx);
 		if (ret)
 			goto err;
 
 		msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
-		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
+		ret = adf_create_ring(accel_dev, SEC, sym_bank, num_msg_sym,
 				      msg_size, key, qat_alg_callback, 0,
 				      &inst->sym_rx);
 		if (ret)
 			goto err;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+		ret = adf_create_ring(accel_dev, SEC, asym_bank, num_msg_asym,
 				      msg_size, key, qat_alg_asym_callback, 0,
 				      &inst->pke_rx);
 		if (ret)
-- 
2.26.2

