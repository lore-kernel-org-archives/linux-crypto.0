From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 08/27] Drivers: ccree: ssi_ivgen.c - align block comments
Date: Wed, 24 May 2017 16:42:57 +1200
Message-ID: <20170524044257.30237-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35064 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965717AbdEXEnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 00:43:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_ivgen.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 1bb6f8919101..db4b831e82a3 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -26,7 +26,8 @@
 /* The max. size of pool *MUST* be <= SRAM total size */
 #define SSI_IVPOOL_SIZE 1024
 /* The first 32B fraction of pool are dedicated to the
-   next encryption "key" & "IV" for pool regeneration */
+ * next encryption "key" & "IV" for pool regeneration
+ */
 #define SSI_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
 #define SSI_IVPOOL_GEN_SEQ_LEN	4
 
@@ -278,7 +279,8 @@ int ssi_ivgen_getiv(
 	}
 
 	/* Bypass operation is proceeded by crypto sequence, hence must
-	*  assure bypass-write-transaction by a memory barrier */
+	 *  assure bypass-write-transaction by a memory barrier
+	 */
 	HW_DESC_INIT(&iv_seq[idx]);
 	HW_DESC_SET_DIN_NO_DMA(&iv_seq[idx], 0, 0xfffff0);
 	HW_DESC_SET_DOUT_NO_DMA(&iv_seq[idx], 0, 0, 1);
-- 
2.12.2
