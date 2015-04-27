From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - do not duplicate string containing firmware
 name
Date: Mon, 27 Apr 2015 13:58:27 -0700
Message-ID: <20150427205827.27002.45117.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41019 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081AbbD0U62 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 16:58:28 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t3RKwRLR027024
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2015 13:58:27 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use ADF_DH895XCC_FW instead of duplicating the string "qat_895xcc.bin"
when referring to the DH895xCC firmware.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 9decea2..c1b3f0b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -417,5 +417,5 @@ module_exit(adfdrv_release);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
-MODULE_FIRMWARE("qat_895xcc.bin");
+MODULE_FIRMWARE(ADF_DH895XCC_FW);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
