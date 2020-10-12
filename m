Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306ECC433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E68CE214DB
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbgJLUjy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbgJLUjy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:54 -0400
IronPort-SDR: GA+iNWqk+HwHLTBYkbjXlsC8EvlPxYsWZ60QDvy+WCCd5DODlKJX6eR2wskQVIW/ulrTm59Yl7
 vVV8DfDO0fXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913188"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913188"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:53 -0700
IronPort-SDR: bfgqdKCu8tL213Osbko6Zih9XSYanSLTZTtkhuooksY65/EYTFKMWsamMA4U34B2DTzMAwdZhc
 F1PgcLtsAELg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328279"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:51 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 28/31] crypto: qat - refactor qat_crypto_create_instances()
Date:   Mon, 12 Oct 2020 21:38:44 +0100
Message-Id: <20201012203847.340030-29-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor function qat_crypto_create_instances() to propagate errors to
the caller.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c | 68 +++++++++++++---------
 1 file changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index ab1716f7044d..735463042987 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -202,83 +202,97 @@ EXPORT_SYMBOL_GPL(qat_crypto_dev_config);
 
 static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 {
-	int i;
-	unsigned long bank;
-	unsigned long num_inst, num_msg_sym, num_msg_asym;
-	int msg_size;
-	struct qat_crypto_instance *inst;
+	unsigned long bank, num_inst, num_msg_sym, num_msg_asym;
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	struct qat_crypto_instance *inst;
+	int msg_size;
+	int ret;
+	int i;
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
-	if (adf_cfg_get_param_value(accel_dev, SEC, ADF_NUM_CY, val))
-		return -EFAULT;
+	ret = adf_cfg_get_param_value(accel_dev, SEC, ADF_NUM_CY, val);
+	if (ret)
+		return ret;
 
-	if (kstrtoul(val, 0, &num_inst))
-		return -EFAULT;
+	ret = kstrtoul(val, 0, &num_inst);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < num_inst; i++) {
 		inst = kzalloc_node(sizeof(*inst), GFP_KERNEL,
 				    dev_to_node(&GET_DEV(accel_dev)));
-		if (!inst)
+		if (!inst) {
+			ret = -ENOMEM;
 			goto err;
+		}
 
 		list_add_tail(&inst->list, &accel_dev->crypto_list);
 		inst->id = i;
 		atomic_set(&inst->refctr, 0);
 		inst->accel_dev = accel_dev;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
-		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+		ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
+		if (ret)
 			goto err;
 
-		if (kstrtoul(val, 10, &bank))
+		ret = kstrtoul(val, 10, &bank);
+		if (ret)
 			goto err;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
-		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+		ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
+		if (ret)
 			goto err;
 
-		if (kstrtoul(val, 10, &num_msg_sym))
+		ret = kstrtoul(val, 10, &num_msg_sym);
+		if (ret)
 			goto err;
 
 		num_msg_sym = num_msg_sym >> 1;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
-		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+		ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
+		if (ret)
 			goto err;
 
-		if (kstrtoul(val, 10, &num_msg_asym))
+		ret = kstrtoul(val, 10, &num_msg_asym);
+		if (ret)
 			goto err;
 		num_msg_asym = num_msg_asym >> 1;
 
 		msg_size = ICP_QAT_FW_REQ_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
-				    msg_size, key, NULL, 0, &inst->sym_tx))
+		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
+				      msg_size, key, NULL, 0, &inst->sym_tx);
+		if (ret)
 			goto err;
 
 		msg_size = msg_size >> 1;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, NULL, 0, &inst->pke_tx))
+		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+				      msg_size, key, NULL, 0, &inst->pke_tx);
+		if (ret)
 			goto err;
 
 		msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
-				    msg_size, key, qat_alg_callback, 0,
-				    &inst->sym_rx))
+		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
+				      msg_size, key, qat_alg_callback, 0,
+				      &inst->sym_rx);
+		if (ret)
 			goto err;
 
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, qat_alg_asym_callback, 0,
-				    &inst->pke_rx))
+		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+				      msg_size, key, qat_alg_asym_callback, 0,
+				      &inst->pke_rx);
+		if (ret)
 			goto err;
 	}
 	return 0;
 err:
 	qat_crypto_free_instances(accel_dev);
-	return -ENOMEM;
+	return ret;
 }
 
 static int qat_crypto_init(struct adf_accel_dev *accel_dev)
-- 
2.26.2

