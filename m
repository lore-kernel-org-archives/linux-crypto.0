Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A95DC433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C533206B8
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgIDIEt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:04:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:3276 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbgIDIEs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 04:04:48 -0400
IronPort-SDR: qjsD7+bT7otUC5DhXGLlDB00KKfUDPwAc1gztvSjVcv/SR6q/dNl1/y2xy14c1z2xjd0SD9iJR
 GvLq6BU987Ag==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="137760245"
X-IronPort-AV: E=Sophos;i="5.76,388,1592895600"; 
   d="scan'208";a="137760245"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 01:04:48 -0700
IronPort-SDR: ALDgnHf4XTALoU5LO+qpl/DzNF9AY/8n+uj+okEmSixMKDY3fBcUW43P6Me7qif+y6xwVFzmLf
 HfUpPPtNVW/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,388,1592895600"; 
   d="scan'208";a="298334812"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 04 Sep 2020 01:04:44 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - include domain in top level debugfs path
Date:   Fri,  4 Sep 2020 09:04:15 +0100
Message-Id: <20200904080415.75039-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use pci_name() when creating debugfs entries in order to include PCI
domain in the path.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 6 ++----
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 6 ++----
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 6 ++----
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 6 ++----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 6 ++----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 6 ++----
 6 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 020d099409e5..8a85484dca5b 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -143,10 +143,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
-		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
-		 pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 hw_data->dev_class->name, pci_name(pdev));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 11039fe55f61..71cf58f96292 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -127,10 +127,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
-		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
-		 pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 hw_data->dev_class->name, pci_name(pdev));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 4ba9c14383af..e8afbf5f7dd2 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -143,10 +143,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
-		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
-		 pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 hw_data->dev_class->name, pci_name(pdev));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index b8b021d54bb5..7e6536246238 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -127,10 +127,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
-		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
-		 pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 hw_data->dev_class->name, pci_name(pdev));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 4e877b75822b..bce10f1722ef 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -143,10 +143,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
-		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
-		 pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 hw_data->dev_class->name, pci_name(pdev));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 7d6e1db272c2..83cd51f2a852 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -127,10 +127,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
 	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%d",
-		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
-		 pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 hw_data->dev_class->name, pci_name(pdev));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
-- 
2.26.2

