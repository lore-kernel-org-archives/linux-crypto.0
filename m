From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix checkpatch BIT_MACRO issues
Date: Tue, 31 Mar 2015 09:30:45 -0700
Message-ID: <20150331163045.6379.95797.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48759 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbbCaQas (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:30:48 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUjht006461
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:45 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CHECK:BIT_MACRO: Prefer using the BIT macro

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c            |    4 ++--
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 8a02d51..274ff7e 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -434,8 +434,8 @@ static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 	SET_GLB_CSR(handle, MISC_CONTROL, misc_ctl | MC_TIMESTAMP_ENABLE);
 }
 
-#define ESRAM_AUTO_TINIT (1<<2)
-#define ESRAM_AUTO_TINIT_DONE (1<<3)
+#define ESRAM_AUTO_TINIT	BIT(2)
+#define ESRAM_AUTO_TINIT_DONE	BIT(3)
 #define ESRAM_AUTO_INIT_USED_CYCLES (1640)
 #define ESRAM_AUTO_INIT_CSR_OFFSET 0xC1C
 static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 01e0be2..25269a9 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -73,11 +73,11 @@
 /* Error detection and correction */
 #define ADF_DH895XCC_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
 #define ADF_DH895XCC_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
-#define ADF_DH895XCC_ENABLE_AE_ECC_ERR (1 << 28)
-#define ADF_DH895XCC_ENABLE_AE_ECC_PARITY_CORR (1 << 24 | 1 << 12)
+#define ADF_DH895XCC_ENABLE_AE_ECC_ERR BIT(28)
+#define ADF_DH895XCC_ENABLE_AE_ECC_PARITY_CORR (BIT(24) | BIT(12))
 #define ADF_DH895XCC_UERRSSMSH(i) (i * 0x4000 + 0x18)
 #define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
-#define ADF_DH895XCC_ERRSSMSH_EN (1 << 3)
+#define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
 /* Admin Messages Registers */
 #define ADF_DH895XCC_ADMINMSGUR_OFFSET (0x3A000 + 0x574)
