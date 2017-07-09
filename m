From: sleepingzucchini@gmail.com
Subject: [PATCH 5/5] staging: ccree: fix switch case indentation
Date: Sun,  9 Jul 2017 17:10:47 -0400
Message-ID: <81ec1fd439ab32793757242358a558c9a72aef3c.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Cc: gregkh@linuxfoundation.orgc, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        Tyler Olivieri <sleepingzucchini@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35020 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbdGIWQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jul 2017 18:16:02 -0400
Received: by mail-qk0-f194.google.com with SMTP id 16so10817774qkg.2
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jul 2017 15:16:02 -0700 (PDT)
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tyler Olivieri <sleepingzucchini@gmail.com>

Patch to fix following checkpatch error:
ERROR: switch and case should be at the same indent

Signed-off-by: Tyler Olivieri <sleepingzucchini@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index c66314f..4f596eb 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1177,12 +1177,12 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
 	switch (keylen) {
-		case AES_KEYSIZE_128:
-		case AES_KEYSIZE_192:
-		case AES_KEYSIZE_256:
-			break;
-		default:
-			return -EINVAL;
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	ctx->key_params.keylen = keylen;
@@ -1265,12 +1265,12 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 	ctx->is_hmac = true;
 
 	switch (keylen) {
-		case AES_KEYSIZE_128:
-		case AES_KEYSIZE_192:
-		case AES_KEYSIZE_256:
-			break;
-		default:
-			return -EINVAL;
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	ctx->key_params.keylen = keylen;
-- 
2.9.4
