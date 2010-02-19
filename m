From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 18/19] crypto: wp512 - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:23:47 +0100
Message-ID: <1266539029-3682-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/wp512.c |  372 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 185 insertions(+), 187 deletions(-)

diff --git a/crypto/wp512.c b/crypto/wp512.c
index 7234272..a8e4c94 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -773,7 +773,8 @@ static const u64 rc[WHIRLPOOL_ROUNDS + 1] = {
  * The core Whirlpool transform.
  */
 
-static void wp512_process_buffer(struct wp512_ctx *wctx) {
+static void wp512_process_buffer(struct wp512_ctx *wctx)
+{
 	int i, r;
 	u64 K[8];        /* the round key */
 	u64 block[8];    /* mu(buffer) */
@@ -795,78 +796,78 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 
 	for (r = 1; r <= WHIRLPOOL_ROUNDS; r++) {
 
-		L[0] = C0[(int)(K[0] >> 56)       ] ^
-			   C1[(int)(K[7] >> 48) & 0xff] ^
-			   C2[(int)(K[6] >> 40) & 0xff] ^
-			   C3[(int)(K[5] >> 32) & 0xff] ^
-			   C4[(int)(K[4] >> 24) & 0xff] ^
-			   C5[(int)(K[3] >> 16) & 0xff] ^
-			   C6[(int)(K[2] >>  8) & 0xff] ^
-			   C7[(int)(K[1]      ) & 0xff] ^
-			   rc[r];
-
-		L[1] = C0[(int)(K[1] >> 56)       ] ^
-			   C1[(int)(K[0] >> 48) & 0xff] ^
-			   C2[(int)(K[7] >> 40) & 0xff] ^
-			   C3[(int)(K[6] >> 32) & 0xff] ^
-			   C4[(int)(K[5] >> 24) & 0xff] ^
-			   C5[(int)(K[4] >> 16) & 0xff] ^
-			   C6[(int)(K[3] >>  8) & 0xff] ^
-			   C7[(int)(K[2]      ) & 0xff];
-
-		L[2] = C0[(int)(K[2] >> 56)       ] ^
-			   C1[(int)(K[1] >> 48) & 0xff] ^
-			   C2[(int)(K[0] >> 40) & 0xff] ^
-			   C3[(int)(K[7] >> 32) & 0xff] ^
-			   C4[(int)(K[6] >> 24) & 0xff] ^
-			   C5[(int)(K[5] >> 16) & 0xff] ^
-			   C6[(int)(K[4] >>  8) & 0xff] ^
-			   C7[(int)(K[3]      ) & 0xff];
-
-		L[3] = C0[(int)(K[3] >> 56)       ] ^
-			   C1[(int)(K[2] >> 48) & 0xff] ^
-			   C2[(int)(K[1] >> 40) & 0xff] ^
-			   C3[(int)(K[0] >> 32) & 0xff] ^
-			   C4[(int)(K[7] >> 24) & 0xff] ^
-			   C5[(int)(K[6] >> 16) & 0xff] ^
-			   C6[(int)(K[5] >>  8) & 0xff] ^
-			   C7[(int)(K[4]      ) & 0xff];
-
-		L[4] = C0[(int)(K[4] >> 56)       ] ^
-			   C1[(int)(K[3] >> 48) & 0xff] ^
-			   C2[(int)(K[2] >> 40) & 0xff] ^
-			   C3[(int)(K[1] >> 32) & 0xff] ^
-			   C4[(int)(K[0] >> 24) & 0xff] ^
-			   C5[(int)(K[7] >> 16) & 0xff] ^
-			   C6[(int)(K[6] >>  8) & 0xff] ^
-			   C7[(int)(K[5]      ) & 0xff];
-
-		L[5] = C0[(int)(K[5] >> 56)       ] ^
-			   C1[(int)(K[4] >> 48) & 0xff] ^
-			   C2[(int)(K[3] >> 40) & 0xff] ^
-			   C3[(int)(K[2] >> 32) & 0xff] ^
-			   C4[(int)(K[1] >> 24) & 0xff] ^
-			   C5[(int)(K[0] >> 16) & 0xff] ^
-			   C6[(int)(K[7] >>  8) & 0xff] ^
-			   C7[(int)(K[6]      ) & 0xff];
-
-		L[6] = C0[(int)(K[6] >> 56)       ] ^
-			   C1[(int)(K[5] >> 48) & 0xff] ^
-			   C2[(int)(K[4] >> 40) & 0xff] ^
-			   C3[(int)(K[3] >> 32) & 0xff] ^
-			   C4[(int)(K[2] >> 24) & 0xff] ^
-			   C5[(int)(K[1] >> 16) & 0xff] ^
-			   C6[(int)(K[0] >>  8) & 0xff] ^
-			   C7[(int)(K[7]      ) & 0xff];
-
-		L[7] = C0[(int)(K[7] >> 56)       ] ^
-			   C1[(int)(K[6] >> 48) & 0xff] ^
-			   C2[(int)(K[5] >> 40) & 0xff] ^
-			   C3[(int)(K[4] >> 32) & 0xff] ^
-			   C4[(int)(K[3] >> 24) & 0xff] ^
-			   C5[(int)(K[2] >> 16) & 0xff] ^
-			   C6[(int)(K[1] >>  8) & 0xff] ^
-			   C7[(int)(K[0]      ) & 0xff];
+		L[0] = C0[(int)(K[0] >> 56)] ^
+		       C1[(int)(K[7] >> 48) & 0xff] ^
+		       C2[(int)(K[6] >> 40) & 0xff] ^
+		       C3[(int)(K[5] >> 32) & 0xff] ^
+		       C4[(int)(K[4] >> 24) & 0xff] ^
+		       C5[(int)(K[3] >> 16) & 0xff] ^
+		       C6[(int)(K[2] >>  8) & 0xff] ^
+		       C7[(int)(K[1]) & 0xff] ^
+		       rc[r];
+
+		L[1] = C0[(int)(K[1] >> 56)] ^
+		       C1[(int)(K[0] >> 48) & 0xff] ^
+		       C2[(int)(K[7] >> 40) & 0xff] ^
+		       C3[(int)(K[6] >> 32) & 0xff] ^
+		       C4[(int)(K[5] >> 24) & 0xff] ^
+		       C5[(int)(K[4] >> 16) & 0xff] ^
+		       C6[(int)(K[3] >>  8) & 0xff] ^
+		       C7[(int)(K[2]) & 0xff];
+
+		L[2] = C0[(int)(K[2] >> 56)] ^
+		       C1[(int)(K[1] >> 48) & 0xff] ^
+		       C2[(int)(K[0] >> 40) & 0xff] ^
+		       C3[(int)(K[7] >> 32) & 0xff] ^
+		       C4[(int)(K[6] >> 24) & 0xff] ^
+		       C5[(int)(K[5] >> 16) & 0xff] ^
+		       C6[(int)(K[4] >>  8) & 0xff] ^
+		       C7[(int)(K[3]) & 0xff];
+
+		L[3] = C0[(int)(K[3] >> 56)] ^
+		       C1[(int)(K[2] >> 48) & 0xff] ^
+		       C2[(int)(K[1] >> 40) & 0xff] ^
+		       C3[(int)(K[0] >> 32) & 0xff] ^
+		       C4[(int)(K[7] >> 24) & 0xff] ^
+		       C5[(int)(K[6] >> 16) & 0xff] ^
+		       C6[(int)(K[5] >>  8) & 0xff] ^
+		       C7[(int)(K[4]) & 0xff];
+
+		L[4] = C0[(int)(K[4] >> 56)] ^
+		       C1[(int)(K[3] >> 48) & 0xff] ^
+		       C2[(int)(K[2] >> 40) & 0xff] ^
+		       C3[(int)(K[1] >> 32) & 0xff] ^
+		       C4[(int)(K[0] >> 24) & 0xff] ^
+		       C5[(int)(K[7] >> 16) & 0xff] ^
+		       C6[(int)(K[6] >>  8) & 0xff] ^
+		       C7[(int)(K[5]) & 0xff];
+
+		L[5] = C0[(int)(K[5] >> 56)] ^
+		       C1[(int)(K[4] >> 48) & 0xff] ^
+		       C2[(int)(K[3] >> 40) & 0xff] ^
+		       C3[(int)(K[2] >> 32) & 0xff] ^
+		       C4[(int)(K[1] >> 24) & 0xff] ^
+		       C5[(int)(K[0] >> 16) & 0xff] ^
+		       C6[(int)(K[7] >>  8) & 0xff] ^
+		       C7[(int)(K[6]) & 0xff];
+
+		L[6] = C0[(int)(K[6] >> 56)] ^
+		       C1[(int)(K[5] >> 48) & 0xff] ^
+		       C2[(int)(K[4] >> 40) & 0xff] ^
+		       C3[(int)(K[3] >> 32) & 0xff] ^
+		       C4[(int)(K[2] >> 24) & 0xff] ^
+		       C5[(int)(K[1] >> 16) & 0xff] ^
+		       C6[(int)(K[0] >>  8) & 0xff] ^
+		       C7[(int)(K[7]) & 0xff];
+
+		L[7] = C0[(int)(K[7] >> 56)] ^
+		       C1[(int)(K[6] >> 48) & 0xff] ^
+		       C2[(int)(K[5] >> 40) & 0xff] ^
+		       C3[(int)(K[4] >> 32) & 0xff] ^
+		       C4[(int)(K[3] >> 24) & 0xff] ^
+		       C5[(int)(K[2] >> 16) & 0xff] ^
+		       C6[(int)(K[1] >>  8) & 0xff] ^
+		       C7[(int)(K[0]) & 0xff];
 
 		K[0] = L[0];
 		K[1] = L[1];
@@ -877,85 +878,85 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 		K[6] = L[6];
 		K[7] = L[7];
 
-		L[0] = C0[(int)(state[0] >> 56)       ] ^
-			   C1[(int)(state[7] >> 48) & 0xff] ^
-			   C2[(int)(state[6] >> 40) & 0xff] ^
-			   C3[(int)(state[5] >> 32) & 0xff] ^
-			   C4[(int)(state[4] >> 24) & 0xff] ^
-			   C5[(int)(state[3] >> 16) & 0xff] ^
-			   C6[(int)(state[2] >>  8) & 0xff] ^
-			   C7[(int)(state[1]      ) & 0xff] ^
-			   K[0];
-
-		L[1] = C0[(int)(state[1] >> 56)       ] ^
-			   C1[(int)(state[0] >> 48) & 0xff] ^
-			   C2[(int)(state[7] >> 40) & 0xff] ^
-			   C3[(int)(state[6] >> 32) & 0xff] ^
-			   C4[(int)(state[5] >> 24) & 0xff] ^
-			   C5[(int)(state[4] >> 16) & 0xff] ^
-			   C6[(int)(state[3] >>  8) & 0xff] ^
-			   C7[(int)(state[2]      ) & 0xff] ^
-			   K[1];
-
-		L[2] = C0[(int)(state[2] >> 56)       ] ^
-			   C1[(int)(state[1] >> 48) & 0xff] ^
-			   C2[(int)(state[0] >> 40) & 0xff] ^
-			   C3[(int)(state[7] >> 32) & 0xff] ^
-			   C4[(int)(state[6] >> 24) & 0xff] ^
-			   C5[(int)(state[5] >> 16) & 0xff] ^
-			   C6[(int)(state[4] >>  8) & 0xff] ^
-			   C7[(int)(state[3]      ) & 0xff] ^
-			   K[2];
-
-		L[3] = C0[(int)(state[3] >> 56)       ] ^
-			   C1[(int)(state[2] >> 48) & 0xff] ^
-			   C2[(int)(state[1] >> 40) & 0xff] ^
-			   C3[(int)(state[0] >> 32) & 0xff] ^
-			   C4[(int)(state[7] >> 24) & 0xff] ^
-			   C5[(int)(state[6] >> 16) & 0xff] ^
-			   C6[(int)(state[5] >>  8) & 0xff] ^
-			   C7[(int)(state[4]      ) & 0xff] ^
-			   K[3];
-
-		L[4] = C0[(int)(state[4] >> 56)       ] ^
-			   C1[(int)(state[3] >> 48) & 0xff] ^
-			   C2[(int)(state[2] >> 40) & 0xff] ^
-			   C3[(int)(state[1] >> 32) & 0xff] ^
-			   C4[(int)(state[0] >> 24) & 0xff] ^
-			   C5[(int)(state[7] >> 16) & 0xff] ^
-			   C6[(int)(state[6] >>  8) & 0xff] ^
-			   C7[(int)(state[5]      ) & 0xff] ^
-			   K[4];
-
-		L[5] = C0[(int)(state[5] >> 56)       ] ^
-			   C1[(int)(state[4] >> 48) & 0xff] ^
-			   C2[(int)(state[3] >> 40) & 0xff] ^
-			   C3[(int)(state[2] >> 32) & 0xff] ^
-			   C4[(int)(state[1] >> 24) & 0xff] ^
-			   C5[(int)(state[0] >> 16) & 0xff] ^
-			   C6[(int)(state[7] >>  8) & 0xff] ^
-			   C7[(int)(state[6]      ) & 0xff] ^
-			   K[5];
-
-		L[6] = C0[(int)(state[6] >> 56)       ] ^
-			   C1[(int)(state[5] >> 48) & 0xff] ^
-			   C2[(int)(state[4] >> 40) & 0xff] ^
-			   C3[(int)(state[3] >> 32) & 0xff] ^
-			   C4[(int)(state[2] >> 24) & 0xff] ^
-			   C5[(int)(state[1] >> 16) & 0xff] ^
-			   C6[(int)(state[0] >>  8) & 0xff] ^
-			   C7[(int)(state[7]      ) & 0xff] ^
-			   K[6];
-
-		L[7] = C0[(int)(state[7] >> 56)       ] ^
-			   C1[(int)(state[6] >> 48) & 0xff] ^
-			   C2[(int)(state[5] >> 40) & 0xff] ^
-			   C3[(int)(state[4] >> 32) & 0xff] ^
-			   C4[(int)(state[3] >> 24) & 0xff] ^
-			   C5[(int)(state[2] >> 16) & 0xff] ^
-			   C6[(int)(state[1] >>  8) & 0xff] ^
-			   C7[(int)(state[0]      ) & 0xff] ^
-			   K[7];
+		L[0] = C0[(int)(state[0] >> 56)] ^
+		       C1[(int)(state[7] >> 48) & 0xff] ^
+		       C2[(int)(state[6] >> 40) & 0xff] ^
+		       C3[(int)(state[5] >> 32) & 0xff] ^
+		       C4[(int)(state[4] >> 24) & 0xff] ^
+		       C5[(int)(state[3] >> 16) & 0xff] ^
+		       C6[(int)(state[2] >>  8) & 0xff] ^
+		       C7[(int)(state[1]) & 0xff] ^
+		       K[0];
+
+		L[1] = C0[(int)(state[1] >> 56)] ^
+		           C1[(int)(state[0] >> 48) & 0xff] ^
+		           C2[(int)(state[7] >> 40) & 0xff] ^
+		           C3[(int)(state[6] >> 32) & 0xff] ^
+		           C4[(int)(state[5] >> 24) & 0xff] ^
+		           C5[(int)(state[4] >> 16) & 0xff] ^
+		           C6[(int)(state[3] >>  8) & 0xff] ^
+		           C7[(int)(state[2]) & 0xff] ^
+		           K[1];
+
+		L[2] = C0[(int)(state[2] >> 56)] ^
+		           C1[(int)(state[1] >> 48) & 0xff] ^
+		           C2[(int)(state[0] >> 40) & 0xff] ^
+		           C3[(int)(state[7] >> 32) & 0xff] ^
+		           C4[(int)(state[6] >> 24) & 0xff] ^
+		           C5[(int)(state[5] >> 16) & 0xff] ^
+		           C6[(int)(state[4] >>  8) & 0xff] ^
+		           C7[(int)(state[3]) & 0xff] ^
+		           K[2];
+
+		L[3] = C0[(int)(state[3] >> 56)] ^
+		           C1[(int)(state[2] >> 48) & 0xff] ^
+		           C2[(int)(state[1] >> 40) & 0xff] ^
+		           C3[(int)(state[0] >> 32) & 0xff] ^
+		           C4[(int)(state[7] >> 24) & 0xff] ^
+		           C5[(int)(state[6] >> 16) & 0xff] ^
+		           C6[(int)(state[5] >>  8) & 0xff] ^
+		           C7[(int)(state[4]) & 0xff] ^
+		           K[3];
+
+		L[4] = C0[(int)(state[4] >> 56)] ^
+		           C1[(int)(state[3] >> 48) & 0xff] ^
+		           C2[(int)(state[2] >> 40) & 0xff] ^
+		           C3[(int)(state[1] >> 32) & 0xff] ^
+		           C4[(int)(state[0] >> 24) & 0xff] ^
+		           C5[(int)(state[7] >> 16) & 0xff] ^
+		           C6[(int)(state[6] >>  8) & 0xff] ^
+		           C7[(int)(state[5]) & 0xff] ^
+		           K[4];
+
+		L[5] = C0[(int)(state[5] >> 56)] ^
+		           C1[(int)(state[4] >> 48) & 0xff] ^
+		           C2[(int)(state[3] >> 40) & 0xff] ^
+		           C3[(int)(state[2] >> 32) & 0xff] ^
+		           C4[(int)(state[1] >> 24) & 0xff] ^
+		           C5[(int)(state[0] >> 16) & 0xff] ^
+		           C6[(int)(state[7] >>  8) & 0xff] ^
+		           C7[(int)(state[6]) & 0xff] ^
+		           K[5];
+
+		L[6] = C0[(int)(state[6] >> 56)] ^
+		           C1[(int)(state[5] >> 48) & 0xff] ^
+		           C2[(int)(state[4] >> 40) & 0xff] ^
+		           C3[(int)(state[3] >> 32) & 0xff] ^
+		           C4[(int)(state[2] >> 24) & 0xff] ^
+		           C5[(int)(state[1] >> 16) & 0xff] ^
+		           C6[(int)(state[0] >>  8) & 0xff] ^
+		           C7[(int)(state[7]) & 0xff] ^
+		           K[6];
+
+		L[7] = C0[(int)(state[7] >> 56)] ^
+		           C1[(int)(state[6] >> 48) & 0xff] ^
+		           C2[(int)(state[5] >> 40) & 0xff] ^
+		           C3[(int)(state[4] >> 32) & 0xff] ^
+		           C4[(int)(state[3] >> 24) & 0xff] ^
+		           C5[(int)(state[2] >> 16) & 0xff] ^
+		           C6[(int)(state[1] >>  8) & 0xff] ^
+		           C7[(int)(state[0]) & 0xff] ^
+		           K[7];
 
 		state[0] = L[0];
 		state[1] = L[1];
@@ -980,26 +981,26 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 
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
 
 	return 0;
 }
 
 static int wp512_update(struct shash_desc *desc, const u8 *source,
-			 unsigned int len)
+                        unsigned int len)
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int sourcePos    = 0;
-	unsigned int bits_len = len * 8; // convert to number of bits
+	unsigned int bits_len = len * 8; /* convert to number of bits */
 	int sourceGap    = (8 - ((int)bits_len & 7)) & 7;
 	int bufferRem    = wctx->bufferBits & 7;
 	int i;
@@ -1060,33 +1061,32 @@ static int wp512_final(struct shash_desc *desc, u8 *out)
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
-			  (WP512_BLOCK_SIZE - WP512_LENGTHBYTES) - bufferPos);
-   	}
-   	bufferPos = WP512_BLOCK_SIZE - WP512_LENGTHBYTES;
-   	memcpy(&buffer[WP512_BLOCK_SIZE - WP512_LENGTHBYTES],
+	buffer[bufferPos] |= 0x80U >> (bufferBits & 7);
+	bufferPos++;
+	if (bufferPos > WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
+		if (bufferPos < WP512_BLOCK_SIZE)
+			memset(&buffer[bufferPos], 0, WP512_BLOCK_SIZE - bufferPos);
+		wp512_process_buffer(wctx);
+		bufferPos = 0;
+	}
+	if (bufferPos < WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
+		memset(&buffer[bufferPos], 0,
+			(WP512_BLOCK_SIZE - WP512_LENGTHBYTES) - bufferPos);
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
@@ -1096,8 +1096,8 @@ static int wp384_final(struct shash_desc *desc, u8 *out)
 	u8 D[64];
 
 	wp512_final(desc, D);
-	memcpy (out, D, WP384_DIGEST_SIZE);
-	memset (D, 0, WP512_DIGEST_SIZE);
+	memcpy(out, D, WP384_DIGEST_SIZE);
+	memset(D, 0, WP512_DIGEST_SIZE);
 
 	return 0;
 }
@@ -1107,8 +1107,8 @@ static int wp256_final(struct shash_desc *desc, u8 *out)
 	u8 D[64];
 
 	wp512_final(desc, D);
-	memcpy (out, D, WP256_DIGEST_SIZE);
-	memset (D, 0, WP512_DIGEST_SIZE);
+	memcpy(out, D, WP256_DIGEST_SIZE);
+	memset(D, 0, WP512_DIGEST_SIZE);
 
 	return 0;
 }
@@ -1165,15 +1165,13 @@ static int __init wp512_mod_init(void)
 		goto out;
 
 	ret = crypto_register_shash(&wp384);
-	if (ret < 0)
-	{
+	if (ret < 0) {
 		crypto_unregister_shash(&wp512);
 		goto out;
 	}
 
 	ret = crypto_register_shash(&wp256);
-	if (ret < 0)
-	{
+	if (ret < 0) {
 		crypto_unregister_shash(&wp512);
 		crypto_unregister_shash(&wp384);
 	}
-- 
1.6.6.1
