Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD8FC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767E060EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhHLISv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:18:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:59623 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235102AbhHLISt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 04:18:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="215036141"
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="215036141"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 01:18:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="517348207"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 01:18:23 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        qat-linux@intel.com, u.kleine-koenig@pengutronix.de,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 2/4] crypto: qat - set DMA mask to 48 bits for Gen2
Date:   Thu, 12 Aug 2021 09:18:14 +0100
Message-Id: <20210812081816.275405-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
References: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the DMA mask from 64 to 48 for Gen2 devices as they cannot handle
addresses greater than 48 bits.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 2 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 2 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 2 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 2 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index b561851cf955..2df26643dbc9 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -159,7 +159,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(&pdev->dev, "No usable DMA configuration\n");
 		goto out_err_disable;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 5095ee30c6a0..7ef5a5185d29 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -141,7 +141,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(&pdev->dev, "No usable DMA configuration\n");
 		goto out_err_disable;
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index f3ac4cda75e9..efdba841d720 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -159,7 +159,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(&pdev->dev, "No usable DMA configuration\n");
 		goto out_err_disable;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 7bd23438bcee..c91beedd267c 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -141,7 +141,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(&pdev->dev, "No usable DMA configuration\n");
 		goto out_err_disable;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index cc300a2662d5..e1c167507157 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -159,7 +159,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(&pdev->dev, "No usable DMA configuration\n");
 		goto out_err_disable;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index da9c7434628c..d332b68795f2 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -141,7 +141,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* set dma identifier */
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(&pdev->dev, "No usable DMA configuration\n");
 		goto out_err_disable;
-- 
2.31.1

