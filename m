From: Ahmed Mohamed Abd EL Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH] cleanups for crypto/wp512.c
Date: Fri, 24 Jul 2015 18:50:15 +0200
Message-ID: <1437756615.27636.2.camel@My-Computer>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35581 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbGXQuU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 12:50:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


fixing all errors and warning of checkpatch.pl for
crypto/wp512.c
Signed-off-by: Ahmed Mohamed <ahmedsoliman0x666@gmail.com>
---
 crypto/wp512.c | 120 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/crypto/wp512.c b/crypto/wp512.c
index 7ee5a04..8a26965 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -779,7 +779,8 @@ static const u64 rc[WHIRLPOOL_ROUNDS] = {
  * The core Whirlpool transform.
  */
 
-static void wp512_process_buffer(struct wp512_ctx *wctx) {
+static void wp512_process_buffer(struct wp512_ctx *wctx)
+{
 	int i, r;
 	u64 K[8];        /* the round key */
 	u64 block[8];    /* mu(buffer) */
@@ -801,78 +802,78 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 
 	for (r = 0; r < WHIRLPOOL_ROUNDS; r++) {
 
-		L[0] = C0[(int)(K[0] >> 56)       ] ^
+		L[0] =	   C0[(int)(K[0] >> 56)]	^
 			   C1[(int)(K[7] >> 48) & 0xff] ^
 			   C2[(int)(K[6] >> 40) & 0xff] ^
 			   C3[(int)(K[5] >> 32) & 0xff] ^
 			   C4[(int)(K[4] >> 24) & 0xff] ^
 			   C5[(int)(K[3] >> 16) & 0xff] ^
 			   C6[(int)(K[2] >>  8) & 0xff] ^
-			   C7[(int)(K[1]      ) & 0xff] ^
+			   C7[(int)(K[1]) & 0xff]	^
 			   rc[r];
 
-		L[1] = C0[(int)(K[1] >> 56)       ] ^
+		L[1] =	   C0[(int)(K[1] >> 56)]	^
 			   C1[(int)(K[0] >> 48) & 0xff] ^
 			   C2[(int)(K[7] >> 40) & 0xff] ^
 			   C3[(int)(K[6] >> 32) & 0xff] ^
 			   C4[(int)(K[5] >> 24) & 0xff] ^
 			   C5[(int)(K[4] >> 16) & 0xff] ^
 			   C6[(int)(K[3] >>  8) & 0xff] ^
-			   C7[(int)(K[2]      ) & 0xff];
+			   C7[(int)(K[2]) & 0xff];
 
-		L[2] = C0[(int)(K[2] >> 56)       ] ^
+		L[2] =	   C0[(int)(K[2] >> 56)]	^
 			   C1[(int)(K[1] >> 48) & 0xff] ^
 			   C2[(int)(K[0] >> 40) & 0xff] ^
 			   C3[(int)(K[7] >> 32) & 0xff] ^
 			   C4[(int)(K[6] >> 24) & 0xff] ^
 			   C5[(int)(K[5] >> 16) & 0xff] ^
 			   C6[(int)(K[4] >>  8) & 0xff] ^
-			   C7[(int)(K[3]      ) & 0xff];
+			   C7[(int)(K[3]) & 0xff];
 
-		L[3] = C0[(int)(K[3] >> 56)       ] ^
+		L[3] =	   C0[(int)(K[3] >> 56)]	^
 			   C1[(int)(K[2] >> 48) & 0xff] ^
 			   C2[(int)(K[1] >> 40) & 0xff] ^
 			   C3[(int)(K[0] >> 32) & 0xff] ^
 			   C4[(int)(K[7] >> 24) & 0xff] ^
 			   C5[(int)(K[6] >> 16) & 0xff] ^
 			   C6[(int)(K[5] >>  8) & 0xff] ^
-			   C7[(int)(K[4]      ) & 0xff];
+			   C7[(int)(K[4]) & 0xff];
 
-		L[4] = C0[(int)(K[4] >> 56)       ] ^
+		L[4] =	   C0[(int)(K[4] >> 56)]	^
 			   C1[(int)(K[3] >> 48) & 0xff] ^
 			   C2[(int)(K[2] >> 40) & 0xff] ^
 			   C3[(int)(K[1] >> 32) & 0xff] ^
 			   C4[(int)(K[0] >> 24) & 0xff] ^
 			   C5[(int)(K[7] >> 16) & 0xff] ^
 			   C6[(int)(K[6] >>  8) & 0xff] ^
-			   C7[(int)(K[5]      ) & 0xff];
+			   C7[(int)(K[5]) & 0xff];
 
-		L[5] = C0[(int)(K[5] >> 56)       ] ^
+		L[5] =	   C0[(int)(K[5] >> 56)]	^
 			   C1[(int)(K[4] >> 48) & 0xff] ^
 			   C2[(int)(K[3] >> 40) & 0xff] ^
 			   C3[(int)(K[2] >> 32) & 0xff] ^
 			   C4[(int)(K[1] >> 24) & 0xff] ^
 			   C5[(int)(K[0] >> 16) & 0xff] ^
 			   C6[(int)(K[7] >>  8) & 0xff] ^
-			   C7[(int)(K[6]      ) & 0xff];
+			   C7[(int)(K[6]) & 0xff];
 
-		L[6] = C0[(int)(K[6] >> 56)       ] ^
+		L[6] =	   C0[(int)(K[6] >> 56)]	^
 			   C1[(int)(K[5] >> 48) & 0xff] ^
 			   C2[(int)(K[4] >> 40) & 0xff] ^
 			   C3[(int)(K[3] >> 32) & 0xff] ^
 			   C4[(int)(K[2] >> 24) & 0xff] ^
 			   C5[(int)(K[1] >> 16) & 0xff] ^
 			   C6[(int)(K[0] >>  8) & 0xff] ^
-			   C7[(int)(K[7]      ) & 0xff];
+			   C7[(int)(K[7]) & 0xff];
 
-		L[7] = C0[(int)(K[7] >> 56)       ] ^
+		L[7] =	   C0[(int)(K[7] >> 56)]	^
 			   C1[(int)(K[6] >> 48) & 0xff] ^
 			   C2[(int)(K[5] >> 40) & 0xff] ^
 			   C3[(int)(K[4] >> 32) & 0xff] ^
 			   C4[(int)(K[3] >> 24) & 0xff] ^
 			   C5[(int)(K[2] >> 16) & 0xff] ^
 			   C6[(int)(K[1] >>  8) & 0xff] ^
-			   C7[(int)(K[0]      ) & 0xff];
+			   C7[(int)(K[0]) & 0xff];
 
 		K[0] = L[0];
 		K[1] = L[1];
@@ -883,84 +884,84 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 		K[6] = L[6];
 		K[7] = L[7];
 
-		L[0] = C0[(int)(state[0] >> 56)       ] ^
+		L[0] =	   C0[(int)(state[0] >> 56)]	    ^
 			   C1[(int)(state[7] >> 48) & 0xff] ^
 			   C2[(int)(state[6] >> 40) & 0xff] ^
 			   C3[(int)(state[5] >> 32) & 0xff] ^
 			   C4[(int)(state[4] >> 24) & 0xff] ^
 			   C5[(int)(state[3] >> 16) & 0xff] ^
 			   C6[(int)(state[2] >>  8) & 0xff] ^
-			   C7[(int)(state[1]      ) & 0xff] ^
+			   C7[(int)(state[1]) & 0xff]	    ^
 			   K[0];
 
-		L[1] = C0[(int)(state[1] >> 56)       ] ^
+		L[1] =	   C0[(int)(state[1] >> 56)]	    ^
 			   C1[(int)(state[0] >> 48) & 0xff] ^
 			   C2[(int)(state[7] >> 40) & 0xff] ^
 			   C3[(int)(state[6] >> 32) & 0xff] ^
 			   C4[(int)(state[5] >> 24) & 0xff] ^
 			   C5[(int)(state[4] >> 16) & 0xff] ^
 			   C6[(int)(state[3] >>  8) & 0xff] ^
-			   C7[(int)(state[2]      ) & 0xff] ^
+			   C7[(int)(state[2]) & 0xff]	    ^
 			   K[1];
 
-		L[2] = C0[(int)(state[2] >> 56)       ] ^
+		L[2] =	   C0[(int)(state[2] >> 56)]        ^
 			   C1[(int)(state[1] >> 48) & 0xff] ^
 			   C2[(int)(state[0] >> 40) & 0xff] ^
 			   C3[(int)(state[7] >> 32) & 0xff] ^
 			   C4[(int)(state[6] >> 24) & 0xff] ^
 			   C5[(int)(state[5] >> 16) & 0xff] ^
 			   C6[(int)(state[4] >>  8) & 0xff] ^
-			   C7[(int)(state[3]      ) & 0xff] ^
+			   C7[(int)(state[3]) & 0xff]	    ^
 			   K[2];
 
-		L[3] = C0[(int)(state[3] >> 56)       ] ^
+		L[3] =	   C0[(int)(state[3] >> 56)]	    ^
 			   C1[(int)(state[2] >> 48) & 0xff] ^
 			   C2[(int)(state[1] >> 40) & 0xff] ^
 			   C3[(int)(state[0] >> 32) & 0xff] ^
 			   C4[(int)(state[7] >> 24) & 0xff] ^
 			   C5[(int)(state[6] >> 16) & 0xff] ^
 			   C6[(int)(state[5] >>  8) & 0xff] ^
-			   C7[(int)(state[4]      ) & 0xff] ^
+			   C7[(int)(state[4]) & 0xff]	    ^
 			   K[3];
 
-		L[4] = C0[(int)(state[4] >> 56)       ] ^
+		L[4] =	   C0[(int)(state[4] >> 56)]	    ^
 			   C1[(int)(state[3] >> 48) & 0xff] ^
 			   C2[(int)(state[2] >> 40) & 0xff] ^
 			   C3[(int)(state[1] >> 32) & 0xff] ^
 			   C4[(int)(state[0] >> 24) & 0xff] ^
 			   C5[(int)(state[7] >> 16) & 0xff] ^
 			   C6[(int)(state[6] >>  8) & 0xff] ^
-			   C7[(int)(state[5]      ) & 0xff] ^
+			   C7[(int)(state[5]) & 0xff]	    ^
 			   K[4];
 
-		L[5] = C0[(int)(state[5] >> 56)       ] ^
+		L[5] =	   C0[(int)(state[5] >> 56)]	    ^
 			   C1[(int)(state[4] >> 48) & 0xff] ^
 			   C2[(int)(state[3] >> 40) & 0xff] ^
 			   C3[(int)(state[2] >> 32) & 0xff] ^
 			   C4[(int)(state[1] >> 24) & 0xff] ^
 			   C5[(int)(state[0] >> 16) & 0xff] ^
 			   C6[(int)(state[7] >>  8) & 0xff] ^
-			   C7[(int)(state[6]      ) & 0xff] ^
+			   C7[(int)(state[6]) & 0xff]	    ^
 			   K[5];
 
-		L[6] = C0[(int)(state[6] >> 56)       ] ^
+		L[6] =	   C0[(int)(state[6] >> 56)]	    ^
 			   C1[(int)(state[5] >> 48) & 0xff] ^
 			   C2[(int)(state[4] >> 40) & 0xff] ^
 			   C3[(int)(state[3] >> 32) & 0xff] ^
 			   C4[(int)(state[2] >> 24) & 0xff] ^
 			   C5[(int)(state[1] >> 16) & 0xff] ^
 			   C6[(int)(state[0] >>  8) & 0xff] ^
-			   C7[(int)(state[7]      ) & 0xff] ^
+			   C7[(int)(state[7]) & 0xff]	    ^
 			   K[6];
 
-		L[7] = C0[(int)(state[7] >> 56)       ] ^
+		L[7] =	   C0[(int)(state[7] >> 56)]        ^
 			   C1[(int)(state[6] >> 48) & 0xff] ^
 			   C2[(int)(state[5] >> 40) & 0xff] ^
 			   C3[(int)(state[4] >> 32) & 0xff] ^
 			   C4[(int)(state[3] >> 24) & 0xff] ^
 			   C5[(int)(state[2] >> 16) & 0xff] ^
 			   C6[(int)(state[1] >>  8) & 0xff] ^
-			   C7[(int)(state[0]      ) & 0xff] ^
+			   C7[(int)(state[0]) & 0xff]	    ^
 			   K[7];
 
 		state[0] = L[0];
@@ -986,17 +987,16 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 
 }
 
-static int wp512_init(struct shash_desc *desc) {
+static int wp512_init(struct shash_desc *desc)
+{
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int i;
 
 	memset(wctx->bitLength, 0, 32);
 	wctx->bufferBits = wctx->bufferPos = 0;
 	wctx->buffer[0] = 0;
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++)
 		wctx->hash[i] = 0L;
-	}
-
 	return 0;
 }
 
@@ -1005,7 +1005,7 @@ static int wp512_update(struct shash_desc *desc, const u8 *source,
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int sourcePos    = 0;
-	unsigned int bits_len = len * 8; // convert to number of bits
+	unsigned int bits_len = len * 8; /* convert to number of bits */
 	int sourceGap    = (8 - ((int)bits_len & 7)) & 7;
 	int bufferRem    = wctx->bufferBits & 7;
 	int i;
@@ -1014,8 +1014,8 @@ static int wp512_update(struct shash_desc *desc, const u8 *source,
 	u8 *bitLength    = wctx->bitLength;
 	int bufferBits   = wctx->bufferBits;
 	int bufferPos    = wctx->bufferPos;
-
 	u64 value = bits_len;
+
 	for (i = 31, carry = 0; i >= 0 && (carry != 0 || value != 0ULL); i--) {
 		carry += bitLength[i] + ((u32)value & 0xff);
 		bitLength[i] = (u8)carry;
@@ -1066,33 +1066,33 @@ static int wp512_final(struct shash_desc *desc, u8 *out)
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int i;
-   	u8 *buffer      = wctx->buffer;
-   	u8 *bitLength   = wctx->bitLength;
-   	int bufferBits  = wctx->bufferBits;
-   	int bufferPos   = wctx->bufferPos;
+	u8 *buffer      = wctx->buffer;
+	u8 *bitLength   = wctx->bitLength;
+	int bufferBits  = wctx->bufferBits;
+	int bufferPos   = wctx->bufferPos;
 	__be64 *digest  = (__be64 *)out;
 
-   	buffer[bufferPos] |= 0x80U >> (bufferBits & 7);
-   	bufferPos++;
-   	if (bufferPos > WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
-   		if (bufferPos < WP512_BLOCK_SIZE) {
-	   	memset(&buffer[bufferPos], 0, WP512_BLOCK_SIZE - bufferPos);
-   		}
-   		wp512_process_buffer(wctx);
-   		bufferPos = 0;
-   	}
-   	if (bufferPos < WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
-   		memset(&buffer[bufferPos], 0,
+	buffer[bufferPos] |= 0x80U >> (bufferBits & 7);
+	bufferPos++;
+	if (bufferPos > WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
+		if (bufferPos < WP512_BLOCK_SIZE)
+			memset(&buffer[bufferPos], 0,
+					WP512_BLOCK_SIZE - bufferPos);
+		wp512_process_buffer(wctx);
+		bufferPos = 0;
+	}
+	if (bufferPos < WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
+		memset(&buffer[bufferPos], 0,
 			  (WP512_BLOCK_SIZE - WP512_LENGTHBYTES) - bufferPos);
-   	}
-   	bufferPos = WP512_BLOCK_SIZE - WP512_LENGTHBYTES;
-   	memcpy(&buffer[WP512_BLOCK_SIZE - WP512_LENGTHBYTES],
+	}
+	bufferPos = WP512_BLOCK_SIZE - WP512_LENGTHBYTES;
+	memcpy(&buffer[WP512_BLOCK_SIZE - WP512_LENGTHBYTES],
 		   bitLength, WP512_LENGTHBYTES);
-   	wp512_process_buffer(wctx);
+	wp512_process_buffer(wctx);
 	for (i = 0; i < WP512_DIGEST_SIZE/8; i++)
 		digest[i] = cpu_to_be64(wctx->hash[i]);
-   	wctx->bufferBits   = bufferBits;
-   	wctx->bufferPos    = bufferPos;
+	wctx->bufferBits   = bufferBits;
+	wctx->bufferPos    = bufferPos;
 
 	return 0;
 }
-- 
1.9.1
