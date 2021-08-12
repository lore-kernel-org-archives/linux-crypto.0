Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DE3C4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BAEF60EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhHLITK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:19:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:59643 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234086AbhHLITJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 04:19:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="215036155"
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="215036155"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 01:18:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="517348222"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 01:18:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        qat-linux@intel.com, u.kleine-koenig@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 3/4] crypto: qat - disable AER if an error occurs in probe functions
Date:   Thu, 12 Aug 2021 09:18:15 +0100
Message-Id: <20210812081816.275405-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
References: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

If an error occurs after a 'adf_enable_aer()' call, it must be undone by a
corresponding 'adf_disable_aer()' call, as already done in the remove
function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c    | 6 ++++--
 drivers/crypto/qat/qat_c62x/adf_drv.c     | 6 ++++--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 2df26643dbc9..cc6e75dc60de 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -201,12 +201,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 	}
 
 	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
@@ -222,6 +222,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_dev_stop(accel_dev);
 out_err_dev_shutdown:
 	adf_dev_shutdown(accel_dev);
+out_err_disable_aer:
+	adf_disable_aer(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index efdba841d720..bf251dfe74b3 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -201,12 +201,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 	}
 
 	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
@@ -222,6 +222,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_dev_stop(accel_dev);
 out_err_dev_shutdown:
 	adf_dev_shutdown(accel_dev);
+out_err_disable_aer:
+	adf_disable_aer(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index e1c167507157..3976a81bd99b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -201,12 +201,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 	}
 
 	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
@@ -222,6 +222,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_dev_stop(accel_dev);
 out_err_dev_shutdown:
 	adf_dev_shutdown(accel_dev);
+out_err_disable_aer:
+	adf_disable_aer(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
-- 
2.31.1

