From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - remove duplicate definition of Intel PCI
 vendor id
Date: Thu, 19 Mar 2015 16:03:33 -0700
Message-ID: <20150319230333.2818.15362.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbbCSXDe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 19:03:34 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2JN3Xq7002848
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2015 16:03:33 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This define is a duplicate of the one in ./include/linux/pci_ids.h

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 19c0efa..f22ce71 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -52,7 +52,6 @@
 #include <linux/io.h>
 #include "adf_cfg_common.h"
 
-#define PCI_VENDOR_ID_INTEL 0x8086
 #define ADF_DH895XCC_DEVICE_NAME "dh895xcc"
 #define ADF_DH895XCC_PCI_DEVICE_ID 0x435
 #define ADF_PCI_MAX_BARS 3
