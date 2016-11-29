From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm/aesbs - fix brokenness after skcipher conversion
Date: Tue, 29 Nov 2016 17:23:36 +0000
Message-ID: <1480440216-341-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f173.google.com ([209.85.210.173]:35157 "EHLO
        mail-wj0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758074AbcK2RXn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 12:23:43 -0500
Received: by mail-wj0-f173.google.com with SMTP id v7so151501727wjy.2
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 09:23:42 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CBC encryption routine should use the encryption round keys, not
the decryption round keys.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Another fix for the queued changes, this time for 32-bit ARM.

I must say, I'm not impressed with the level of testing that has been
carried out after applying these changes. If you had cc'd me on these
patches, I would have been happy to test/review.

 arch/arm/crypto/aesbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index f5eafce10557..d8e06de72ef3 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -113,7 +113,7 @@ static inline void aesbs_encrypt_one(struct crypto_skcipher *tfm,
 {
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	AES_encrypt(src, dst, &ctx->dec.rk);
+	AES_encrypt(src, dst, &ctx->enc);
 }
 
 static int aesbs_cbc_encrypt(struct skcipher_request *req)
-- 
2.7.4
