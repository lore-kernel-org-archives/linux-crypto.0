From: Branislav Katreniak <brano@ksp.sk>
Subject: [PATCH] staging: ccree: fix checkpatch no space before tabs
Date: Thu, 18 May 2017 22:28:33 +0200
Message-ID: <20170518202833.GA30843@archiv.ksp.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:40857 "EHLO ksp.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752741AbdERUfp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 16:35:45 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Branislav Katreniak <brano@ksp.sk>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 216d247..ac39d34 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -54,13 +54,13 @@
 #define CC_AES_KEY_SIZE_MAX			CC_AES_256_BIT_KEY_SIZE
 #define CC_AES_KEY_SIZE_WORDS_MAX		(CC_AES_KEY_SIZE_MAX >> 2)
 
-#define CC_MD5_DIGEST_SIZE 	16
-#define CC_SHA1_DIGEST_SIZE 	20
-#define CC_SHA224_DIGEST_SIZE 	28
-#define CC_SHA256_DIGEST_SIZE 	32
+#define CC_MD5_DIGEST_SIZE	16
+#define CC_SHA1_DIGEST_SIZE	20
+#define CC_SHA224_DIGEST_SIZE	28
+#define CC_SHA256_DIGEST_SIZE	32
 #define CC_SHA256_DIGEST_SIZE_IN_WORDS 8
-#define CC_SHA384_DIGEST_SIZE 	48
-#define CC_SHA512_DIGEST_SIZE 	64
+#define CC_SHA384_DIGEST_SIZE	48
+#define CC_SHA512_DIGEST_SIZE	64
 
 #define CC_SHA1_BLOCK_SIZE 64
 #define CC_SHA1_BLOCK_SIZE_IN_WORDS 16
@@ -83,9 +83,9 @@
 
 #define CC_HMAC_BLOCK_SIZE_MAX CC_HASH_BLOCK_SIZE_MAX
 
-#define CC_MULTI2_SYSTEM_KEY_SIZE 		32
-#define CC_MULTI2_DATA_KEY_SIZE 		8
-#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE 	(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
+#define CC_MULTI2_SYSTEM_KEY_SIZE		32
+#define CC_MULTI2_DATA_KEY_SIZE		8
+#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE	(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
 #define	CC_MULTI2_BLOCK_SIZE					8
 #define	CC_MULTI2_IV_SIZE					8
 #define	CC_MULTI2_MIN_NUM_ROUNDS				8
-- 
2.7.4
