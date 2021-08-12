Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7CFC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE9B60560
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhHLISs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:18:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:59623 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234086AbhHLISs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 04:18:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="215036124"
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="215036124"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 01:18:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="517348185"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 01:18:21 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        qat-linux@intel.com, u.kleine-koenig@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 1/4] crypto: qat - simplify code and axe the use of a deprecated API
Date:   Thu, 12 Aug 2021 09:18:13 +0100
Message-Id: <20210812081816.275405-2-giovanni.cabiddu@intel.com>
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

The wrappers in include/linux/pci-dma-compat.h should go away.

Replace 'pci_set_dma_mask/pci_set_consistent_dma_mask' by an equivalent
and less verbose 'dma_set_mask_and_coherent()' call.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c       | 14 ++++----------
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 15 ++++-----------
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 15 ++++-----------
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 15 ++++-----------
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 15 ++++-----------
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 15 ++++-----------
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 15 ++++-----------
 7 files changed, 28 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index a8805c815d16..359fb7989dfb 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -221,16 +221,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Set DMA identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration.\n");
-			ret = -EFAULT;
-			goto out_err;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration.\n");
+		goto out_err;
 	}
 
 	/* Get accelerator capabilities mask */
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 7fb3343ae8b0..b561851cf955 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -159,17 +159,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration\n");
-			ret = -EFAULT;
-			goto out_err_disable;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto out_err_disable;
 	}
 
 	if (pci_request_regions(pdev, ADF_C3XXX_DEVICE_NAME)) {
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 067ca5e17d38..5095ee30c6a0 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -141,17 +141,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration\n");
-			ret = -EFAULT;
-			goto out_err_disable;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto out_err_disable;
 	}
 
 	if (pci_request_regions(pdev, ADF_C3XXXVF_DEVICE_NAME)) {
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 1f5de442e1e6..f3ac4cda75e9 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -159,17 +159,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration\n");
-			ret = -EFAULT;
-			goto out_err_disable;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto out_err_disable;
 	}
 
 	if (pci_request_regions(pdev, ADF_C62X_DEVICE_NAME)) {
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 51ea88c0b17d..7bd23438bcee 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -141,17 +141,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration\n");
-			ret = -EFAULT;
-			goto out_err_disable;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto out_err_disable;
 	}
 
 	if (pci_request_regions(pdev, ADF_C62XVF_DEVICE_NAME)) {
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index a9ec4357144c..cc300a2662d5 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -159,17 +159,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration\n");
-			ret = -EFAULT;
-			goto out_err_disable;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto out_err_disable;
 	}
 
 	if (pci_request_regions(pdev, ADF_DH895XCC_DEVICE_NAME)) {
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 29999da716cc..da9c7434628c 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -141,17 +141,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
-			dev_err(&pdev->dev, "No usable DMA configuration\n");
-			ret = -EFAULT;
-			goto out_err_disable;
-		} else {
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		}
-
-	} else {
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto out_err_disable;
 	}
 
 	if (pci_request_regions(pdev, ADF_DH895XCCVF_DEVICE_NAME)) {
-- 
2.31.1

