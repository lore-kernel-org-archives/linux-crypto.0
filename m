From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH] crypto: picoxcell: fix boolean and / or confusion
Date: Tue, 13 Dec 2011 09:54:06 +0000
Message-ID: <1323770046-3548-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43356 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1LMJyM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 04:54:12 -0500
Received: by qadc12 with SMTP id c12so3154309qad.19
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2011 01:54:11 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES engine only supports 128 and 256 bit keys so we should correctly
test for that.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/picoxcell_crypto.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a2b553e..925cc33 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -873,7 +873,7 @@ static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	 * request for any other size (192 bits) then we need to do a software
 	 * fallback.
 	 */
-	if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&
+	if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256 &&
 	    ctx->sw_cipher) {
 		/*
 		 * Set the fallback transform to use the same request flags as
@@ -886,7 +886,7 @@ static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		err = crypto_ablkcipher_setkey(ctx->sw_cipher, key, len);
 		if (err)
 			goto sw_setkey_failed;
-	} else if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&
+	} else if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256 &&
 		   !ctx->sw_cipher)
 		err = -EINVAL;
 
-- 
1.7.4.1
