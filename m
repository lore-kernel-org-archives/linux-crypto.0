Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014E2C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 11:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 988DE21D7E
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 11:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIILAP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 07:00:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:31533 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgIIK7t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 06:59:49 -0400
IronPort-SDR: 7nTk6UagMfkDPY7Xvmkux8saSBdG4lUwh21/TRnegzQrTGd36/6g0+nkK92MryjuYgmd0N0MUT
 H7n0lFgAs/fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="222511314"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="222511314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 03:59:48 -0700
IronPort-SDR: uZcvasRZeEOMzCa8QkzLLW8sWoSQd0KIUENwiRQxMPP9TAZ/6tO5iIAsM061vMdyx/uWHrxacy
 qD06s1CEwjrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="341534352"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Sep 2020 03:59:46 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH RESEND 2/2] crypto: qat - use PCI_VDEVICE
Date:   Wed,  9 Sep 2020 11:59:40 +0100
Message-Id: <20200909105940.203532-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909105940.203532-1-giovanni.cabiddu@intel.com>
References: <20200909105940.203532-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Build pci_device_id structure using the PCI_VDEVICE macro.
This removes any references to the ADF_SYSTEM_DEVICE macro.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 7 ++-----
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 7 ++-----
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 7 ++-----
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 7 ++-----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 7 ++-----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 7 ++-----
 6 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index bba0f142f7f6..43929d70c41d 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c3xxx_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C3XXX),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index b77a58886599..dca52de22e8d 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c3xxxvf_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 722838ff03be..f104c9d1195d 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c62x_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C62X),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index a766cc18aae9..e0b909e70712 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c62xvf_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C62X_VF),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X_VF), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 4c3aea07f444..857aa4c8595f 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_dh895xcc_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_DH895XCC),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_DH895XCC), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 673348ca5dea..2987855a70dc 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_dh895xccvf_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
-- 
2.26.2

