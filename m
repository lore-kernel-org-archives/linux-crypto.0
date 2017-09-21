From: Janani Sankara Babu <jananis37@gmail.com>
Subject: [PATCH] staging:ccree Fix use BIT macro
Date: Thu, 21 Sep 2017 12:09:42 +0530
Message-ID: <1505975982-28314-1-git-send-email-jananis37@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Janani Sankara Babu <jananis37@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch is created to solve the following warning shown by the checkpatch
script Warning: Replace all occurences of (1<<x) by BIT(x)

Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
---
 drivers/staging/ccree/ssi_cipher.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 296b375..6fbcf9d 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -27,11 +27,11 @@
 #include "ssi_buffer_mgr.h"
 
 /* Crypto cipher flags */
-#define CC_CRYPTO_CIPHER_KEY_KFDE0    (1 << 0)
-#define CC_CRYPTO_CIPHER_KEY_KFDE1    (1 << 1)
-#define CC_CRYPTO_CIPHER_KEY_KFDE2    (1 << 2)
-#define CC_CRYPTO_CIPHER_KEY_KFDE3    (1 << 3)
-#define CC_CRYPTO_CIPHER_DU_SIZE_512B (1 << 4)
+#define CC_CRYPTO_CIPHER_KEY_KFDE0    BIT(0)
+#define CC_CRYPTO_CIPHER_KEY_KFDE1    BIT(1)
+#define CC_CRYPTO_CIPHER_KEY_KFDE2    BIT(2)
+#define CC_CRYPTO_CIPHER_KEY_KFDE3    BIT(3)
+#define CC_CRYPTO_CIPHER_DU_SIZE_512B BIT(4)
 
 #define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | CC_CRYPTO_CIPHER_KEY_KFDE1 | CC_CRYPTO_CIPHER_KEY_KFDE2 | CC_CRYPTO_CIPHER_KEY_KFDE3)
 
-- 
1.9.1
