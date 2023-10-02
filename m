Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285EEE7849A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Oct 2023 08:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbjJBIv4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 04:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjJBIvz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 04:51:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E885CD3
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 01:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696236711; x=1727772711;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F8CoDhxr/CrbyoLPmMRdZStTLo+fdGZNk+b4JEYaORA=;
  b=aXdqhJCXE8cQAD4DONeqnWC/O6aeJxhQ0GMfqBLSV6SJb5XJzso8IE8e
   Ag3L2KZ8o1L1k8aJLfW+B/cPPpfKVAeq9BTpdYXZRXdqBtrTmesEBRZ6u
   TlwB4EYCIe0ZV93OgmJo3uHLNI0nY6Y2FVR0djgvS66V90k7Pbce9nDJx
   KhIs6FdJS/FlKk65dMvfVyj2FFCJn+nqvyshc1Hz+zU09+tk0kkS7NXQ6
   tFE+FBlM259p5Pu5r6URE/8x8ly5j7Zmm8C4ERdr1++icXyGGIgadHYGn
   nq9bNIPRTUb/AVrugd1fsYe6HQxv0CHhSZ+8iDCvkKcame+N7XoXhLZLm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="446759775"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="446759775"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 01:51:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="744059144"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="744059144"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by orsmga007.jf.intel.com with ESMTP; 02 Oct 2023 01:51:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH] crypto: qat - add namespace to driver
Date:   Mon,  2 Oct 2023 09:51:09 +0100
Message-ID: <20231002085126.11127-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Create CRYPTO_QAT namespace for symbols exported by the qat_common
module and import those in the QAT drivers. It will reduce the global
namespace crowdedness and potential misuse or the API.

This does not introduce any functional change.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c       | 1 +
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c      | 1 +
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c    | 1 +
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c       | 1 +
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c     | 1 +
 drivers/crypto/intel/qat/qat_common/Makefile      | 1 +
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 1 +
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c | 1 +
 8 files changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 90f5c1ca7b8d..2ccd1223f1ef 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -467,3 +467,4 @@ MODULE_FIRMWARE(ADF_4XXX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_SOFTDEP("pre: crypto-intel_qat");
+MODULE_IMPORT_NS(CRYPTO_QAT);
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index 468c9102093f..956a4c85609a 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -252,3 +252,4 @@ MODULE_FIRMWARE(ADF_C3XXX_FW);
 MODULE_FIRMWARE(ADF_C3XXX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_QAT);
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index d5a0ecca9d0b..a8de9cd09c05 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -226,3 +226,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_QAT);
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 0186921be936..ad0ca4384998 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -252,3 +252,4 @@ MODULE_FIRMWARE(ADF_C62X_FW);
 MODULE_FIRMWARE(ADF_C62X_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_QAT);
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index c9ae6c0d0dca..53b8ddb63364 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -226,3 +226,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_QAT);
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 43622c7fca71..0f7c12397fa2 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
+ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CRYPTO_QAT
 intel_qat-objs := adf_cfg.o \
 	adf_isr.o \
 	adf_ctl_drv.o \
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index 1e748e8ce12d..40b456b8035b 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -252,3 +252,4 @@ MODULE_FIRMWARE(ADF_DH895XCC_FW);
 MODULE_FIRMWARE(ADF_DH895XCC_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_QAT);
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index fefb85ceaeb9..d59cb1ba2ad5 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -226,3 +226,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_QAT);
-- 
2.41.0

