From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] crypto: keywrap - Add missing ULL suffixes for 64-bit constants
Date: Wed, 15 Nov 2017 11:44:28 +0100
Message-ID: <1510742668-21121-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:60832 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758188AbdKOOKi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Nov 2017 09:10:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):

    crypto/keywrap.c: In function ‘crypto_kw_decrypt’:
    crypto/keywrap.c:191: warning: integer constant is too large for ‘long’ type
    crypto/keywrap.c: In function ‘crypto_kw_encrypt’:
    crypto/keywrap.c:224: warning: integer constant is too large for ‘long’ type

Fixes: 9e49451d7a15365d ("crypto: keywrap - simplify code")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 crypto/keywrap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 744e35134c45f300..ec5c6a087c901501 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -188,7 +188,7 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 	}
 
 	/* Perform authentication check */
-	if (block.A != cpu_to_be64(0xa6a6a6a6a6a6a6a6))
+	if (block.A != cpu_to_be64(0xa6a6a6a6a6a6a6a6ULL))
 		ret = -EBADMSG;
 
 	memzero_explicit(&block, sizeof(struct crypto_kw_block));
@@ -221,7 +221,7 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	 * Place the predefined IV into block A -- for encrypt, the caller
 	 * does not need to provide an IV, but he needs to fetch the final IV.
 	 */
-	block.A = cpu_to_be64(0xa6a6a6a6a6a6a6a6);
+	block.A = cpu_to_be64(0xa6a6a6a6a6a6a6a6ULL);
 
 	/*
 	 * src scatterlist is read-only. dst scatterlist is r/w. During the
-- 
2.7.4
