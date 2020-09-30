Return-Path: <SRS0=wif3=DH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB0AC4363D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Sep 2020 22:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 148DD2075F
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Sep 2020 22:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgI3WWd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:22:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:64714 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730201AbgI3WWc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Sep 2020 18:22:32 -0400
IronPort-SDR: IloreJ5YZU/wtoTfyQtHu53yRiTyhekD4gxEXtrrb8TucxnuPi/brQdugxvyxsXHVtyrA2X06r
 1jm/qVmGdGag==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="150212810"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="150212810"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 15:22:25 -0700
IronPort-SDR: aBL99JrbVX5DyhbskJmxWS/ylh9HahwGK9atKONFsJc0hj1HYyid89IFV07wynRhydN0rB67+C
 QiVqx1vvV2RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457834868"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga004.jf.intel.com with ESMTP; 30 Sep 2020 15:22:23 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH] crypto: qat - drop input parameter from adf_enable_aer()
Date:   Wed, 30 Sep 2020 23:22:11 +0100
Message-Id: <20200930222211.557316-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove pointer to struct pci_driver from function adf_enable_aer() as it
is possible to get it directly from pdev->driver.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c         | 2 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c          | 2 +-
 drivers/crypto/qat/qat_common/adf_aer.c        | 6 +++---
 drivers/crypto/qat/qat_common/adf_common_drv.h | 2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c      | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 6057dc9f1572..ed0e8e33fe4b 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -198,7 +198,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	pci_set_master(pdev);
 
-	if (adf_enable_aer(accel_dev, &adf_driver)) {
+	if (adf_enable_aer(accel_dev)) {
 		dev_err(&pdev->dev, "Failed to enable aer\n");
 		ret = -EFAULT;
 		goto out_err_free_reg;
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index ed4b3c282380..d8e7c9c25590 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -198,7 +198,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	pci_set_master(pdev);
 
-	if (adf_enable_aer(accel_dev, &adf_driver)) {
+	if (adf_enable_aer(accel_dev)) {
 		dev_err(&pdev->dev, "Failed to enable aer\n");
 		ret = -EFAULT;
 		goto out_err_free_reg;
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 32102e27e559..d2ae293d0df6 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -175,7 +175,6 @@ static const struct pci_error_handlers adf_err_handler = {
 /**
  * adf_enable_aer() - Enable Advance Error Reporting for acceleration device
  * @accel_dev:  Pointer to acceleration device.
- * @adf:        PCI device driver owning the given acceleration device.
  *
  * Function enables PCI Advance Error Reporting for the
  * QAT acceleration device accel_dev.
@@ -183,11 +182,12 @@ static const struct pci_error_handlers adf_err_handler = {
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf)
+int adf_enable_aer(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	struct pci_driver *pdrv = pdev->driver;
 
-	adf->err_handler = &adf_err_handler;
+	pdrv->err_handler = &adf_err_handler;
 	pci_enable_pcie_error_reporting(pdev);
 	return 0;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index ebfcb4ea618d..f22342f612c1 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -95,7 +95,7 @@ void adf_ae_fw_release(struct adf_accel_dev *accel_dev);
 int adf_ae_start(struct adf_accel_dev *accel_dev);
 int adf_ae_stop(struct adf_accel_dev *accel_dev);
 
-int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf);
+int adf_enable_aer(struct adf_accel_dev *accel_dev);
 void adf_disable_aer(struct adf_accel_dev *accel_dev);
 void adf_reset_sbr(struct adf_accel_dev *accel_dev);
 void adf_reset_flr(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 1e0a5965d9b6..ecb4f6f20e22 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -200,7 +200,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	pci_set_master(pdev);
 
-	if (adf_enable_aer(accel_dev, &adf_driver)) {
+	if (adf_enable_aer(accel_dev)) {
 		dev_err(&pdev->dev, "Failed to enable aer\n");
 		ret = -EFAULT;
 		goto out_err_free_reg;
-- 
2.26.2

