From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: [PATCH] crypto: gcm - Fix IV buffer size in crypto_gcm_setkey
Date: Fri, 16 Sep 2016 14:07:40 +0200
Message-ID: <CAAUqJDt=wXHbU1z5f_=r9tuJxUKDZKR1d9AURoDrye+iwnVrKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34099 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934741AbcIPMHm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 08:07:42 -0400
Received: by mail-oi0-f68.google.com with SMTP id v62so2989918oig.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2016 05:07:42 -0700 (PDT)
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
@@ -117,7 +117,7 @@ static int crypto_gcm_setkey(struct crypto_aead
*aead, const u8 *key,
 	struct crypto_skcipher *ctr = ctx->ctr;
 	struct {
 		be128 hash;
-		u8 iv[8];
+		u8 iv[16];

 		struct crypto_gcm_setkey_result result;

-- 
2.7.4
