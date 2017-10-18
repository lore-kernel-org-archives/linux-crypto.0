From: sunil.m@techveda.org
Subject: [PATCH v3] staging: ccree: fix boolreturn.cocci warning
Date: Wed, 18 Oct 2017 12:11:55 +0530
Message-ID: <1508308915-18789-1-git-send-email-sunil.m@techveda.org>
References: <20171018023607.GE30848@eros>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org, me@tobin.cc
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018023607.GE30848@eros>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Suniel Mahesh <sunil.m@techveda.org>

This fixes the following coccinelle warning:
WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

return "false" instead of 0.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Changes for v3:
- Changed the commit log even more to give an accurate
  description of the changeset as suggested by Toby C.Harding.
---
Changes for v2:
- Changed the commit log to give a more accurate description
  of the changeset as suggested by Toby C.Harding.
---
Note:
- Patch was built(ARCH=arm) on latest linux-next.
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
