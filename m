From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] qat: add driver version
Date: Thu, 07 May 2015 17:00:42 -0700
Message-ID: <20150508000042.8205.32112.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20295 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbbEHAAu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2015 20:00:50 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t4800g7D008227
	for <linux-crypto@vger.kernel.org>; Thu, 7 May 2015 17:00:42 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    7 +++++++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |    1 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c      |    1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 0666ee6..27e16c0 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -53,6 +53,13 @@
 #include "icp_qat_fw_loader_handle.h"
 #include "icp_qat_hal.h"
 
+#define ADF_MAJOR_VERSION	0
+#define ADF_MINOR_VERSION	1
+#define ADF_BUILD_VERSION	3
+#define ADF_DRV_VERSION		__stringify(ADF_MAJOR_VERSION) "." \
+				__stringify(ADF_MINOR_VERSION) "." \
+				__stringify(ADF_BUILD_VERSION)
+
 #define ADF_STATUS_RESTARTING 0
 #define ADF_STATUS_STARTING 1
 #define ADF_STATUS_CONFIGURED 2
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index cb5f066..e056b9e 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -504,3 +504,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_ALIAS_CRYPTO("intel_qat");
+MODULE_VERSION(ADF_DRV_VERSION);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index c1b3f0b..ecf0ef1 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -419,3 +419,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_DH895XCC_FW);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
+MODULE_VERSION(ADF_DRV_VERSION);
