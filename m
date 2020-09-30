Return-Path: <SRS0=wif3=DH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5A1C4363D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Sep 2020 22:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFAF1206FC
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Sep 2020 22:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbgI3WSA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:18:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:30056 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731321AbgI3WR7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Sep 2020 18:17:59 -0400
IronPort-SDR: TBwNBNrhgOTfuZmg66tYVIzu0i0/2UEdRzduq8mKopBwsCY0nYbwr0PiiyLjIeny0OKtHa453O
 LPSsrbQA/CMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="150344563"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="150344563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 15:17:55 -0700
IronPort-SDR: lK8lxT9R/SrpiAkzpNiKrwDo84w7kEFHRluB0sbgxmWHvPokG6WL9ViIeeb0l6Gzz/Ozz2mXao
 lXmbo190CvdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="312752710"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga006.jf.intel.com with ESMTP; 30 Sep 2020 15:17:54 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH] crypto: qat - fix function parameters descriptions
Date:   Wed, 30 Sep 2020 23:17:47 +0100
Message-Id: <20200930221747.553707-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix description of function parameters. This is to fix the following
warnings when compiling the driver with W=1:

    drivers/crypto/qat/qat_common/adf_sriov.c:133: warning: Function parameter or member 'numvfs' not described in 'adf_sriov_configure'
    drivers/crypto/qat/qat_common/adf_dev_mgr.c:296: warning: Function parameter or member 'pci_dev' not described in 'adf_devmgr_pci_to_accel_dev'
    drivers/crypto/qat/qat_common/adf_dev_mgr.c:296: warning: Excess function parameter 'accel_dev' description in 'adf_devmgr_pci_to_accel_dev'

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/qat/qat_common/adf_dev_mgr.c | 2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c   | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 72753af056b3..92ec035576df 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -285,7 +285,7 @@ struct adf_accel_dev *adf_devmgr_get_first(void)
 
 /**
  * adf_devmgr_pci_to_accel_dev() - Get accel_dev associated with the pci_dev.
- * @accel_dev:  Pointer to pci device.
+ * @pci_dev:  Pointer to pci device.
  *
  * Function returns acceleration device associated with the given pci device.
  * To be used by QAT device specific drivers.
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 8827aa139f96..963b2bea78f2 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -173,10 +173,14 @@ EXPORT_SYMBOL_GPL(adf_disable_sriov);
 /**
  * adf_sriov_configure() - Enable SRIOV for the device
  * @pdev:  Pointer to pci device.
+ * @numvfs: Number of virtual functions (VFs) to enable.
+ *
+ * Note that the @numvfs parameter is ignored and all VFs supported by the
+ * device are enabled due to the design of the hardware.
  *
  * Function enables SRIOV for the pci device.
  *
- * Return: 0 on success, error code otherwise.
+ * Return: number of VFs enabled on success, error code otherwise.
  */
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 {
-- 
2.26.2

