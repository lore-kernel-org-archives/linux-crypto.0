From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: Merge assignment with return
Date: Sat,  9 Sep 2017 01:31:35 +0530
Message-ID: <1504900895-13110-1-git-send-email-srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34607 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756799AbdIHUBp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 16:01:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return the return value of a function directly, instead of first saving it in a variable and then returning it. This change was made using the following
semantic patch by coccinelle.

@@
local idexpression ret;
expression e;
@@

-ret =
+return
     e;
-return ret;

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5abe6b2..6bb98f7 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -651,17 +651,14 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int rc = 0;
-
+
 	if (keylen < 3)
 		return -EINVAL;

 	keylen -= 3;
 	memcpy(ctx->ctr_nonce, key + keylen, 3);

-	rc = ssi_aead_setkey(tfm, key, keylen);
-
-	return rc;
+	return ssi_aead_setkey(tfm, key, keylen);
 }
 #endif /*SSI_CC_HAS_AES_CCM*/

@@ -2214,8 +2211,7 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int rc = 0;
-
+
 	SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);

 	if (keylen < 4)
@@ -2224,16 +2220,13 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	keylen -= 4;
 	memcpy(ctx->ctr_nonce, key + keylen, 4);

-	rc = ssi_aead_setkey(tfm, key, keylen);
-
-	return rc;
+	return ssi_aead_setkey(tfm, key, keylen);
 }

 static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int rc = 0;
-
+
 	SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);

 	if (keylen < 4)
@@ -2242,9 +2235,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	keylen -= 4;
 	memcpy(ctx->ctr_nonce, key + keylen, 4);

-	rc = ssi_aead_setkey(tfm, key, keylen);
-
-	return rc;
+	return ssi_aead_setkey(tfm, key, keylen);
 }

 static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
