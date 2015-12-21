From: "Atta, Ahsan" <ahsan.atta@intel.com>
Subject: [PATCH] Renaming dh895xcc mmp fw
Date: Mon, 21 Dec 2015 16:59:17 +0000
Message-ID: <E0A450CA4D390344969A8802152422FF44A1BE6D@irsmsx105.ger.corp.intel.com>
References: <1450371133-20595-1-git-send-email-ahsan.atta@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32057 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbbLUQ7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Dec 2015 11:59:20 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Renaming dh895xcc mmp fw

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 72eacfd..f3c5de9 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -82,7 +82,7 @@
 #define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
-#define ADF_DH895XCC_MMP "qat_mmp.bin"
+#define ADF_DH895XCC_MMP "qat_dh895xcc_mmp.bin"
 
 void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);  void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
--
1.7.4.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.
