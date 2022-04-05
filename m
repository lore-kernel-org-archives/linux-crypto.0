Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF2AC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Apr 2022 14:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbiDEPBI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 11:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388178AbiDENVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 09:21:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A137113A;
        Tue,  5 Apr 2022 05:25:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3159FD6E;
        Tue,  5 Apr 2022 05:25:15 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2B3F53F5A1;
        Tue,  5 Apr 2022 05:25:14 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat - stop using iommu_present()
Date:   Tue,  5 Apr 2022 13:25:11 +0100
Message-Id: <ef01fbd7d2c60d56a0b8e8847a08ccb3ee5132af.1649161511.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.28.0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Even if an IOMMU might be present for some PCI segment in the system,
that doesn't necessarily mean it provides translation for the device
we care about. Replace iommu_present() with a more appropriate check.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 drivers/crypto/qat/qat_common/adf_sriov.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index b960bca1f9d2..7f9c18dc4540 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -3,7 +3,6 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/device.h>
-#include <linux/iommu.h>
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
 #include "adf_pfvf_pf_msg.h"
@@ -176,7 +175,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 		return -EFAULT;
 	}
 
-	if (!iommu_present(&pci_bus_type))
+	if (!device_iommu_mapped(&pdev->dev))
 		dev_warn(&pdev->dev, "IOMMU should be enabled for SR-IOV to work correctly\n");
 
 	if (accel_dev->pf.vf_info) {
-- 
2.28.0.dirty

