Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D12C41537
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291FF610A2
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346670AbhIARv1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Sep 2021 13:51:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:16284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347528AbhIARvF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Sep 2021 13:51:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="215694376"
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="215694376"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 10:49:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="499022534"
Received: from silpixa00400294.ir.intel.com ([10.237.222.100])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2021 10:49:54 -0700
From:   Wojciech Ziemba <wojciech.ziemba@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 4/4] crypto: qat - free irq in case of failure
Date:   Wed,  1 Sep 2021 18:36:08 +0100
Message-Id: <20210901173608.16777-5-wojciech.ziemba@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210901173608.16777-1-wojciech.ziemba@intel.com>
References: <20210901173608.16777-1-wojciech.ziemba@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If devm_request_irq() fails inside adf_request_irqs(), unwind properly by
freeing the allocated irqs.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 63 +++++++++++++------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 861a9368b9db..c55a9f14b0d2 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -126,6 +126,31 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 	return IRQ_NONE;
 }
 
+static void adf_free_irqs(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_irq *irqs = pci_dev_info->msix_entries.irqs;
+	struct adf_etr_data *etr_data = accel_dev->transport;
+	int clust_irq = hw_data->num_banks;
+	int irq, i = 0;
+
+	if (pci_dev_info->msix_entries.num_entries > 1) {
+		for (i = 0; i < hw_data->num_banks; i++) {
+			if (irqs[i].enabled) {
+				irq = pci_irq_vector(pci_dev_info->pci_dev, i);
+				irq_set_affinity_hint(irq, NULL);
+				free_irq(irq, &etr_data->banks[i]);
+			}
+		}
+	}
+
+	if (irqs[i].enabled) {
+		irq = pci_irq_vector(pci_dev_info->pci_dev, clust_irq);
+		free_irq(irq, accel_dev);
+	}
+}
+
 static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
@@ -150,7 +175,8 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 				dev_err(&GET_DEV(accel_dev),
 					"Failed to get IRQ number of device vector %d - %s\n",
 					i, name);
-				return irq;
+				ret = irq;
+				goto err;
 			}
 			ret = request_irq(irq, adf_msix_isr_bundle, 0,
 					  &name[0], bank);
@@ -158,7 +184,7 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 				dev_err(&GET_DEV(accel_dev),
 					"Failed to allocate IRQ %d for %s\n",
 					irq, name);
-				return ret;
+				goto err;
 			}
 
 			cpu = ((accel_dev->accel_id * hw_data->num_banks) +
@@ -177,41 +203,20 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to get IRQ number of device vector %d - %s\n",
 			i, name);
-		return irq;
+		ret = irq;
+		goto err;
 	}
 	ret = request_irq(irq, adf_msix_isr_ae, 0, &name[0], accel_dev);
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to allocate IRQ %d for %s\n", irq, name);
-		return ret;
+		goto err;
 	}
 	irqs[i].enabled = true;
 	return ret;
-}
-
-static void adf_free_irqs(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_irq *irqs = pci_dev_info->msix_entries.irqs;
-	struct adf_etr_data *etr_data = accel_dev->transport;
-	int clust_irq = hw_data->num_banks;
-	int irq, i = 0;
-
-	if (pci_dev_info->msix_entries.num_entries > 1) {
-		for (i = 0; i < hw_data->num_banks; i++) {
-			if (irqs[i].enabled) {
-				irq = pci_irq_vector(pci_dev_info->pci_dev, i);
-				irq_set_affinity_hint(irq, NULL);
-				free_irq(irq, &etr_data->banks[i]);
-			}
-		}
-	}
-
-	if (irqs[i].enabled) {
-		irq = pci_irq_vector(pci_dev_info->pci_dev, clust_irq);
-		free_irq(irq, accel_dev);
-	}
+err:
+	adf_free_irqs(accel_dev);
+	return ret;
 }
 
 static int adf_isr_alloc_msix_vectors_data(struct adf_accel_dev *accel_dev)
-- 
2.29.2

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

