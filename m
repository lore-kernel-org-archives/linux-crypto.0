From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Rename dh895xcc mmp firmware
Date: Tue, 22 Dec 2015 11:20:34 -0800
Message-ID: <1450812034-26307-1-git-send-email-tadeusz.struk@intel.com>
Cc: <linux-crypto@vger.kernel.org>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932682AbbLVTYG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 14:24:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ahsan Atta <ahsan.atta@intel.com>

Resending again. The fw name suppoed to be 895xcc instead of 895xxcc.
Sorry for the noise.
Rename dh895xcc mmp fw to make it consistent with other mmp images.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 72eacfd..092f735 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -82,7 +82,7 @@
 #define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
-#define ADF_DH895XCC_MMP "qat_mmp.bin"
+#define ADF_DH895XCC_MMP "qat_895xcc_mmp.bin"
 
 void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
-- 
2.1.4
