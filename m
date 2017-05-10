From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: aes_ti - fix comment for MixColumns step
Date: Tue,  9 May 2017 17:20:27 -0700
Message-ID: <20170510002027.47632-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34615 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdEJAVY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 May 2017 20:21:24 -0400
Received: by mail-pg0-f67.google.com with SMTP id u187so1854325pgb.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 May 2017 17:21:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

mix_columns() contains a comment which shows the matrix used by the
MixColumns step of AES, but the last entry in this matrix was incorrect
--- and did not match the code, which is correct.  Fix the comment.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aes_ti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 92644fd1ac19..03023b2290e8 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -114,7 +114,7 @@ static u32 mix_columns(u32 x)
 	 * | 0x2 0x3 0x1 0x1 |   | x[0] |
 	 * | 0x1 0x2 0x3 0x1 |   | x[1] |
 	 * | 0x1 0x1 0x2 0x3 | x | x[2] |
-	 * | 0x3 0x1 0x1 0x3 |   | x[3] |
+	 * | 0x3 0x1 0x1 0x2 |   | x[3] |
 	 */
 	u32 y = mul_by_x(x) ^ ror32(x, 16);
 
-- 
2.13.0.rc2.291.g57267f2277-goog
