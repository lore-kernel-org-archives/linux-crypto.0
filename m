From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: chacha20 - use rol32() macro from bitops.h
Date: Sun, 31 Dec 2017 18:02:45 -0600
Message-ID: <20180101000245.3670-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:43223 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbeAAACw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Dec 2017 19:02:52 -0500
Received: by mail-it0-f65.google.com with SMTP id u62so35646489ita.2
        for <linux-crypto@vger.kernel.org>; Sun, 31 Dec 2017 16:02:52 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

For chacha20_block(), use the existing 32-bit left-rotate function
instead of defining one ourselves.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/chacha20.c | 69 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/lib/chacha20.c b/lib/chacha20.c
index 29d3801dee24..c1cc50fb68c9 100644
--- a/lib/chacha20.c
+++ b/lib/chacha20.c
@@ -16,11 +16,6 @@
 #include <asm/unaligned.h>
 #include <crypto/chacha20.h>
 
-static inline u32 rotl32(u32 v, u8 n)
-{
-	return (v << n) | (v >> (sizeof(v) * 8 - n));
-}
-
 void chacha20_block(u32 *state, u32 *stream)
 {
 	u32 x[16], *out = stream;
@@ -30,45 +25,45 @@ void chacha20_block(u32 *state, u32 *stream)
 		x[i] = state[i];
 
 	for (i = 0; i < 20; i += 2) {
-		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
-		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
-		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
-		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
+		x[0]  += x[4];    x[12] = rol32(x[12] ^ x[0],  16);
+		x[1]  += x[5];    x[13] = rol32(x[13] ^ x[1],  16);
+		x[2]  += x[6];    x[14] = rol32(x[14] ^ x[2],  16);
+		x[3]  += x[7];    x[15] = rol32(x[15] ^ x[3],  16);
 
-		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
-		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
-		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
-		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
+		x[8]  += x[12];   x[4]  = rol32(x[4]  ^ x[8],  12);
+		x[9]  += x[13];   x[5]  = rol32(x[5]  ^ x[9],  12);
+		x[10] += x[14];   x[6]  = rol32(x[6]  ^ x[10], 12);
+		x[11] += x[15];   x[7]  = rol32(x[7]  ^ x[11], 12);
 
-		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
-		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
-		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
-		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
+		x[0]  += x[4];    x[12] = rol32(x[12] ^ x[0],   8);
+		x[1]  += x[5];    x[13] = rol32(x[13] ^ x[1],   8);
+		x[2]  += x[6];    x[14] = rol32(x[14] ^ x[2],   8);
+		x[3]  += x[7];    x[15] = rol32(x[15] ^ x[3],   8);
 
-		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
-		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
-		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
-		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
+		x[8]  += x[12];   x[4]  = rol32(x[4]  ^ x[8],   7);
+		x[9]  += x[13];   x[5]  = rol32(x[5]  ^ x[9],   7);
+		x[10] += x[14];   x[6]  = rol32(x[6]  ^ x[10],  7);
+		x[11] += x[15];   x[7]  = rol32(x[7]  ^ x[11],  7);
 
-		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
-		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
-		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
-		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
+		x[0]  += x[5];    x[15] = rol32(x[15] ^ x[0],  16);
+		x[1]  += x[6];    x[12] = rol32(x[12] ^ x[1],  16);
+		x[2]  += x[7];    x[13] = rol32(x[13] ^ x[2],  16);
+		x[3]  += x[4];    x[14] = rol32(x[14] ^ x[3],  16);
 
-		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
-		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
-		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
-		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
+		x[10] += x[15];   x[5]  = rol32(x[5]  ^ x[10], 12);
+		x[11] += x[12];   x[6]  = rol32(x[6]  ^ x[11], 12);
+		x[8]  += x[13];   x[7]  = rol32(x[7]  ^ x[8],  12);
+		x[9]  += x[14];   x[4]  = rol32(x[4]  ^ x[9],  12);
 
-		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
-		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
-		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
-		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
+		x[0]  += x[5];    x[15] = rol32(x[15] ^ x[0],   8);
+		x[1]  += x[6];    x[12] = rol32(x[12] ^ x[1],   8);
+		x[2]  += x[7];    x[13] = rol32(x[13] ^ x[2],   8);
+		x[3]  += x[4];    x[14] = rol32(x[14] ^ x[3],   8);
 
-		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
-		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
-		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
-		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
+		x[10] += x[15];   x[5]  = rol32(x[5]  ^ x[10],  7);
+		x[11] += x[12];   x[6]  = rol32(x[6]  ^ x[11],  7);
+		x[8]  += x[13];   x[7]  = rol32(x[7]  ^ x[8],   7);
+		x[9]  += x[14];   x[4]  = rol32(x[4]  ^ x[9],   7);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(x); i++)
-- 
2.15.1
