From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings for blowfish
Date: Wed, 10 Feb 2010 01:48:42 +0100
Message-ID: <1265762923-21795-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:39038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0BJAtQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 19:49:16 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/blowfish.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index 6f5b487..a67d52e 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * Blowfish Cipher Algorithm, by Bruce Schneier.
@@ -299,7 +299,7 @@ static const u32 bf_sbox[256 * 4] = {
 	0xb74e6132, 0xce77e25b, 0x578fdfe3, 0x3ac372e6,
 };
 
-/* 
+/*
  * Round loop unrolling macros, S is a pointer to a S-Box array
  * organized in 4 unsigned longs at a row.
  */
@@ -315,7 +315,7 @@ static const u32 bf_sbox[256 * 4] = {
 
 /*
  * The blowfish encipher, processes 64-bit blocks.
- * NOTE: This function MUSTN'T respect endianess 
+ * NOTE: This function MUSTN'T respect endianess
  */
 static void encrypt_block(struct bf_ctx *bctx, u32 *dst, u32 *src)
 {
@@ -395,7 +395,7 @@ static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	out_blk[1] = cpu_to_be32(yl);
 }
 
-/* 
+/*
  * Calculates the blowfish S and P boxes for encryption and decryption.
  */
 static int bf_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
@@ -417,10 +417,10 @@ static int bf_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 
 	/* Actual subkey generation */
 	for (j = 0, i = 0; i < 16 + 2; i++) {
-		temp = (((u32 )key[j] << 24) |
-			((u32 )key[(j + 1) % keylen] << 16) |
-			((u32 )key[(j + 2) % keylen] << 8) |
-			((u32 )key[(j + 3) % keylen]));
+		temp = (((u32)key[j] << 24) |
+			((u32)key[(j + 1) % keylen] << 16) |
+			((u32)key[(j + 2) % keylen] << 8) |
+			((u32)key[(j + 3) % keylen]));
 
 		P[i] = P[i] ^ temp;
 		j = (j + 4) % keylen;
@@ -444,7 +444,7 @@ static int bf_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 			S[count + 1] = data[1];
 		}
 	}
-	
+
 	/* Bruce says not to bother with the weak key check. */
 	return 0;
 }
-- 
1.6.6.1

