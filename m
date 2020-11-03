Return-Path: <SRS0=/kEc=EJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDB5C2D0A3
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 17:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21636216C4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 17:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgKCR3o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Nov 2020 12:29:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:40193 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgKCR3n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Nov 2020 12:29:43 -0500
IronPort-SDR: 3C33d2yUvRbNkUr/v9xC16WGSWkaaXBd3SURCzyYk9OUND3zU0m1guNwsQ/pi8KrXV7woV0wU+
 /1XUDOefFxuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="148372310"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="148372310"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 09:29:42 -0800
IronPort-SDR: cY0cKhWQgyzWoO1yCJvcROR5rXT8Zgh6tb6IEIAcVEyo35bmznBusc0ZEW1ptSOJOzj7OlPfxx
 FvLUWmJNk9XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="320515723"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 03 Nov 2020 09:29:38 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - replace pci with PCI in comments
Date:   Tue,  3 Nov 2020 17:29:36 +0000
Message-Id: <20201103172936.765026-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Adam Guerin <adam.guerin@intel.com>

Change all lower case pci in comments to be upper case PCI.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_dev_mgr.c | 4 ++--
 drivers/crypto/qat/qat_common/adf_sriov.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 92ec035576df..29dc2e3d38ff 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -285,9 +285,9 @@ struct adf_accel_dev *adf_devmgr_get_first(void)
 
 /**
  * adf_devmgr_pci_to_accel_dev() - Get accel_dev associated with the pci_dev.
- * @pci_dev:  Pointer to pci device.
+ * @pci_dev:  Pointer to PCI device.
  *
- * Function returns acceleration device associated with the given pci device.
+ * Function returns acceleration device associated with the given PCI device.
  * To be used by QAT device specific drivers.
  *
  * Return: pointer to accel_dev or NULL if not found.
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index d887640355d4..8c822c2861c2 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -122,13 +122,13 @@ EXPORT_SYMBOL_GPL(adf_disable_sriov);
 
 /**
  * adf_sriov_configure() - Enable SRIOV for the device
- * @pdev:  Pointer to pci device.
+ * @pdev:  Pointer to PCI device.
  * @numvfs: Number of virtual functions (VFs) to enable.
  *
  * Note that the @numvfs parameter is ignored and all VFs supported by the
  * device are enabled due to the design of the hardware.
  *
- * Function enables SRIOV for the pci device.
+ * Function enables SRIOV for the PCI device.
  *
  * Return: number of VFs enabled on success, error code otherwise.
  */
-- 
2.28.0

