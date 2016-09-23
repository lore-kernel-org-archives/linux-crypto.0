From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH v2] crypto: gcm - Fix IV buffer size in crypto_gcm_setkey
Date: Fri, 23 Sep 2016 10:47:32 +0200
Message-ID: <1474620452-7278-1-git-send-email-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, Ondrej Mosnacek <omosnacek@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35843 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935444AbcIWIsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2016 04:48:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id b184so1608098wma.3
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2016 01:47:52 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The cipher block size for GCM is 16 bytes, and thus the CTR transform
used in crypto_gcm_setkey() will also expect a 16-byte IV. However,
the code currently reserves only 8 bytes for the IV, causing
an out-of-bounds access in the CTR transform. This patch fixes
the issue by setting the size of the IV buffer to 16 bytes.

Fixes: 84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")
Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
(Sorry for previous broken patch, hopefully I got it right this
time.)

I randomly noticed this while going over igcm.c for an unrelated
reason. It seems the wrong buffer size never caused any noticeable
problems (it's been there since 2007), but it should be corrected
nonetheless...

 crypto/gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 70a892e8..f624ac9 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -117,7 +117,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	struct crypto_skcipher *ctr = ctx->ctr;
 	struct {
 		be128 hash;
-		u8 iv[8];
+		u8 iv[16];
 
 		struct crypto_gcm_setkey_result result;
 
--
2.7.4
