From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Rename dh895xcc mmp firmware
Date: Tue, 22 Dec 2015 10:13:10 -0800
Message-ID: <1450807990-24289-1-git-send-email-tadeusz.struk@intel.com>
Cc: <linux-crypto@vger.kernel.org>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbbLVSQy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 13:16:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ahsan Atta <ahsan.atta@intel.com>

Rename dh895xcc mmp fw to make it consistent with other mmp
images

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 72eacfd..57a749f 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -82,7 +82,7 @@
 #define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
-#define ADF_DH895XCC_MMP "qat_mmp.bin"
+#define ADF_DH895XCC_MMP "qat_895xxcc_mmp.bin"
 
 void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
-- 
2.1.4
