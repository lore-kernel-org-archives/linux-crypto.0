From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 02/19] crypto: khazad - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:21:41 +0100
Message-ID: <1266538903-3145-1-git-send-email-richih.mailinglist@gmail.com>
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
 crypto/khazad.c |   71 +++++++++++++++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/crypto/khazad.c b/crypto/khazad.c
index 527e4e3..5b23532 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -768,30 +768,30 @@ static int khazad_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 
 	/* setup the encrypt key */
 	for (r = 0; r <= KHAZAD_ROUNDS; r++) {
-		ctx->E[r] = T0[(int)(K1 >> 56)       ] ^
-			    T1[(int)(K1 >> 48) & 0xff] ^
-			    T2[(int)(K1 >> 40) & 0xff] ^
-			    T3[(int)(K1 >> 32) & 0xff] ^
-			    T4[(int)(K1 >> 24) & 0xff] ^
-			    T5[(int)(K1 >> 16) & 0xff] ^
-			    T6[(int)(K1 >>  8) & 0xff] ^
-			    T7[(int)(K1      ) & 0xff] ^
+		ctx->E[r] = T0[(int)(K1 >> 56)] ^
+			    T1[(int)(K1 >> 48)&0xff] ^
+			    T2[(int)(K1 >> 40)&0xff] ^
+			    T3[(int)(K1 >> 32)&0xff] ^
+			    T4[(int)(K1 >> 24)&0xff] ^
+			    T5[(int)(K1 >> 16)&0xff] ^
+			    T6[(int)(K1 >>  8)&0xff] ^
+			    T7[(int)(K1      )&0xff] ^
 			    c[r] ^ K2;
-		K2 = K1; 
+		K2 = K1;
 		K1 = ctx->E[r];
 	}
 	/* Setup the decrypt key */
 	ctx->D[0] = ctx->E[KHAZAD_ROUNDS];
 	for (r = 1; r < KHAZAD_ROUNDS; r++) {
 		K1 = ctx->E[KHAZAD_ROUNDS - r];
-		ctx->D[r] = T0[(int)S[(int)(K1 >> 56)       ] & 0xff] ^
-			    T1[(int)S[(int)(K1 >> 48) & 0xff] & 0xff] ^
-			    T2[(int)S[(int)(K1 >> 40) & 0xff] & 0xff] ^
-			    T3[(int)S[(int)(K1 >> 32) & 0xff] & 0xff] ^
-			    T4[(int)S[(int)(K1 >> 24) & 0xff] & 0xff] ^
-			    T5[(int)S[(int)(K1 >> 16) & 0xff] & 0xff] ^
-			    T6[(int)S[(int)(K1 >>  8) & 0xff] & 0xff] ^
-			    T7[(int)S[(int)(K1      ) & 0xff] & 0xff];
+		ctx->D[r] = T0[(int)S[(int)(K1 >> 56)] & 0xff] ^
+			    T1[(int)S[(int)(K1 >> 48)&0xff]&0xff] ^
+			    T2[(int)S[(int)(K1 >> 40)&0xff]&0xff] ^
+			    T3[(int)S[(int)(K1 >> 32)&0xff]&0xff] ^
+			    T4[(int)S[(int)(K1 >> 24)&0xff]&0xff] ^
+			    T5[(int)S[(int)(K1 >> 16)&0xff]&0xff] ^
+			    T6[(int)S[(int)(K1 >>  8)&0xff]&0xff] ^
+			    T7[(int)S[(int)(K1      )&0xff]&0xff];
 	}
 	ctx->D[KHAZAD_ROUNDS] = ctx->E[0];
 
@@ -810,25 +810,25 @@ static void khazad_crypt(const u64 roundKey[KHAZAD_ROUNDS + 1],
 	state = be64_to_cpu(*src) ^ roundKey[0];
 
 	for (r = 1; r < KHAZAD_ROUNDS; r++) {
-		state = T0[(int)(state >> 56)       ] ^
-			T1[(int)(state >> 48) & 0xff] ^
-			T2[(int)(state >> 40) & 0xff] ^
-			T3[(int)(state >> 32) & 0xff] ^
-			T4[(int)(state >> 24) & 0xff] ^
-			T5[(int)(state >> 16) & 0xff] ^
-			T6[(int)(state >>  8) & 0xff] ^
-			T7[(int)(state      ) & 0xff] ^
+		state = T0[(int)(state >> 56)] ^
+			T1[(int)(state >> 48)&0xff] ^
+			T2[(int)(state >> 40)&0xff] ^
+			T3[(int)(state >> 32)&0xff] ^
+			T4[(int)(state >> 24)&0xff] ^
+			T5[(int)(state >> 16)&0xff] ^
+			T6[(int)(state >>  8)&0xff] ^
+			T7[(int)(state      )&0xff] ^
 			roundKey[r];
-    	}
+		}
 
-	state = (T0[(int)(state >> 56)       ] & 0xff00000000000000ULL) ^
-		(T1[(int)(state >> 48) & 0xff] & 0x00ff000000000000ULL) ^
-		(T2[(int)(state >> 40) & 0xff] & 0x0000ff0000000000ULL) ^
-		(T3[(int)(state >> 32) & 0xff] & 0x000000ff00000000ULL) ^
-		(T4[(int)(state >> 24) & 0xff] & 0x00000000ff000000ULL) ^
-		(T5[(int)(state >> 16) & 0xff] & 0x0000000000ff0000ULL) ^
-		(T6[(int)(state >>  8) & 0xff] & 0x000000000000ff00ULL) ^
-		(T7[(int)(state      ) & 0xff] & 0x00000000000000ffULL) ^
+	state = (T0[(int)(state >> 56)]&0xff00000000000000ULL) ^
+		(T1[(int)(state >> 48)&0xff]&0x00ff000000000000ULL) ^
+		(T2[(int)(state >> 40)&0xff]&0x0000ff0000000000ULL) ^
+		(T3[(int)(state >> 32)&0xff]&0x000000ff00000000ULL) ^
+		(T4[(int)(state >> 24)&0xff]&0x00000000ff000000ULL) ^
+		(T5[(int)(state >> 16)&0xff]&0x0000000000ff0000ULL) ^
+		(T6[(int)(state >>  8)&0xff]&0x000000000000ff00ULL) ^
+		(T7[(int)(state      )&0xff]&0x00000000000000ffULL) ^
 		roundKey[KHAZAD_ROUNDS];
 
 	*dst = cpu_to_be64(state);
@@ -850,7 +850,7 @@ static struct crypto_alg khazad_alg = {
 	.cra_name		=	"khazad",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	KHAZAD_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof (struct khazad_ctx),
+	.cra_ctxsize		=	sizeof(struct khazad_ctx),
 	.cra_alignmask		=	7,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(khazad_alg.cra_list),
@@ -865,7 +865,6 @@ static struct crypto_alg khazad_alg = {
 static int __init khazad_mod_init(void)
 {
 	int ret = 0;
-	
 	ret = crypto_register_alg(&khazad_alg);
 	return ret;
 }
-- 
1.6.6.1
