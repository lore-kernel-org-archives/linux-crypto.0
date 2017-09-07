From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v2] Staging: ccree: Prefer using BIT macro.
Date: Thu,  7 Sep 2017 19:44:52 +0530
Message-ID: <1504793692-8996-1-git-send-email-srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33274 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755053AbdIGOPM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 10:15:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use BIT(x) instead of using (1<<x), reported by checkpatch.pl.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v2:
 - Add tab spaces before BIT macro.

 drivers/staging/ccree/ssi_cipher.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 296b375..c9a83df 100644
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
+#define CC_CRYPTO_CIPHER_KEY_KFDE0	BIT(0)
+#define CC_CRYPTO_CIPHER_KEY_KFDE1	BIT(1)
+#define CC_CRYPTO_CIPHER_KEY_KFDE2	BIT(2)
+#define CC_CRYPTO_CIPHER_KEY_KFDE3	BIT(3)
+#define CC_CRYPTO_CIPHER_DU_SIZE_512B	BIT(4)

 #define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | CC_CRYPTO_CIPHER_KEY_KFDE1 | CC_CRYPTO_CIPHER_KEY_KFDE2 | CC_CRYPTO_CIPHER_KEY_KFDE3)
