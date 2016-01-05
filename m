From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - change name for c6xx dev type
Date: Tue,  5 Jan 2016 11:14:55 -0800
Message-ID: <1452021295-7739-1-git-send-email-tadeusz.struk@intel.com>
Cc: <linux-crypto@vger.kernel.org>, <tadeusz.struk@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9702 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbcAETSm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jan 2016 14:18:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

change name for c6x dev type to more generic.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index f96d427..5a07208 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -55,8 +55,8 @@
 
 #define ADF_DH895XCC_DEVICE_NAME "dh895xcc"
 #define ADF_DH895XCCVF_DEVICE_NAME "dh895xccvf"
-#define ADF_C62X_DEVICE_NAME "c62x"
-#define ADF_C62XVF_DEVICE_NAME "c62xvf"
+#define ADF_C62X_DEVICE_NAME "c6xx"
+#define ADF_C62XVF_DEVICE_NAME "c6xxvf"
 #define ADF_C3XXX_DEVICE_NAME "c3xxx"
 #define ADF_C3XXXVF_DEVICE_NAME "c3xxxvf"
 #define ADF_DH895XCC_PCI_DEVICE_ID 0x435
-- 
2.1.4
