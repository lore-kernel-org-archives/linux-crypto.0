From: sunil.m@techveda.org
Subject: [PATCH] staging: ccree: fix boolreturn.cocci warning
Date: Mon, 16 Oct 2017 15:39:57 +0530
Message-ID: <1508148597-11911-1-git-send-email-sunil.m@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:52453 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdJPKKH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2017 06:10:07 -0400
Received: by mail-pf0-f195.google.com with SMTP id e64so15454939pfk.9
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2017 03:10:06 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Suniel Mahesh <sunil.m@techveda.org>

This fixes the following coccinelle warning:
WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Note:
- Patch was tested and built(ARCH=arm) on latest
  linux-next.
- No build issues reported, however it was not
  tested on real hardware.
- Please discard this changeset, if this is not
  helping the code look better.
---
 drivers/staging/ccree/ssi_cipher.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index c9a83df..f499962 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -75,7 +75,7 @@ struct arm_hw_key_info {
 
 static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CRYPTO_TFM_REQ_HW_KEY */
-- 
1.9.1
