From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - make sure const_tab is 1024 bytes aligned
Date: Tue, 22 Mar 2016 10:45:25 -0700
Message-ID: <1458668725-21232-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57834 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbcCVRub (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 13:50:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

FW requires the const_tab to be 1024 bytes aligned.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index eb557f6..ce7c462 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -61,7 +61,7 @@
 #define ADF_DH895XCC_MAILBOX_STRIDE 0x1000
 #define ADF_ADMINMSG_LEN 32
 
-static const u8 const_tab[1024] = {
+static const u8 const_tab[1024] __aligned(1024) = {
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-- 
2.1.4
