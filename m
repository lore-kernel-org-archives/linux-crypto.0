Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBB2C433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FFED2145D
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgJLUjf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgJLUjf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:35 -0400
IronPort-SDR: ReHo/Mu8KFQEeFlIrhOeMca7QUKDK93Y4saPXr16IAHQ6nOY/1NRd+6E8s3bP/aRfMP3RB+QMm
 hQ2jpI28YNsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913143"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913143"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:35 -0700
IronPort-SDR: /N/o9DxB8r8bdZKCK4ZMxDOdLBC6Qiboox3szO14i7vgMy3GxOB2LBczPheQgp6/TDfVa5jbtf
 PfRdt7JxzRqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328210"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:33 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 17/31] crypto: qat - register crypto instances based on capability
Date:   Mon, 12 Oct 2020 21:38:33 +0100
Message-Id: <20201012203847.340030-18-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce the function adf_hw_dev_has_crypto() that returns true if a
device supports symmetric crypto, asymmetric crypto and authentication
services.
If a device has crypto capabilities, add crypto instances to the
configuration.
This is done since the function that allows to retrieve crypto
instances, qat_crypto_get_instance_node(), return instances that support
all crypto services.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c |  7 ++++++-
 drivers/crypto/qat/qat_common/qat_crypto.h | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index ab621b7dbd20..089d5d7b738e 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -117,10 +117,15 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 {
 	int cpus = num_online_cpus();
 	int banks = GET_MAX_BANKS(accel_dev);
-	int instances = min(cpus, banks);
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	int i;
 	unsigned long val;
+	int instances;
+
+	if (adf_hw_dev_has_crypto(accel_dev))
+		instances = min(cpus, banks);
+	else
+		instances = 0;
 
 	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
 		goto err;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 8d11e94cbf08..b6a4c95ae003 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -55,4 +55,19 @@ struct qat_crypto_request {
 	bool encryption;
 };
 
+static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	u32 mask = ~hw_device->accel_capabilities_mask;
+
+	if (mask & ADF_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC)
+		return false;
+	if (mask & ADF_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC)
+		return false;
+	if (mask & ADF_ACCEL_CAPABILITIES_AUTHENTICATION)
+		return false;
+
+	return true;
+}
+
 #endif
-- 
2.26.2

